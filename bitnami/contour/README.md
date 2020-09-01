# contour

## TL;DR

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/contour
```

## Introduction

Bitnami charts for Helm are carefully engineered, actively maintained and are the quickest and easiest way to deploy containers on a Kubernetes cluster that are ready to handle production workloads.

This chart bootstraps a [Contour](https://projectcontour.io) Ingress Controller Deployment and a [Envoy Proxy](https://www.envoyproxy.io) Daemonset on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This Helm chart has been tested on top of [Bitnami Kubernetes Production Runtime](https://kubeprod.io/) (BKPR). Deploy BKPR to get automated TLS certificates, logging and monitoring for your applications.

## Prerequisites

- Kubernetes 1.12+
- Helm 2.11+ or Helm 3.0-beta3+
- An Operator for `ServiceType: LoadBalancer` like [MetalLB](../metallb/README.md)

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/contour
```

These commands deploy contour on the Kubernetes cluster in the default configuration. The [Parameters](##parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list` or `helm ls --all-namespaces`

## Uninstalling the Chart

To uninstall/delete the `my-release` helm release:

```console
$ helm uninstall my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

The following tables lists the configurable parameters of the contour chart and their default values.

| Parameter                                          | Description                                                                                            | Default                                                 |
|----------------------------------------------------|--------------------------------------------------------------------------------------------------------|---------------------------------------------------------|
| `global.imageRegistry`                             | Global Docker image registry                                                                           | `nil`                                                   |
| `global.imagePullSecrets`                          | Global Docker registry secret names as an array                                                        | `[]` (does not add image pull secrets to deployed pods) |
| `rbac.create`                                      | create the RBAC roles for API accessibility                                                            | `true`                                                  |
| `contour.enabled`                                  | Contour Deployment creation.                                                                           | `true`                                                  |
| `contour.image.registry`                           | Contour image registry                                                                                 | `docker.io`                                             |
| `contour.image.repository`                         | Contour image name                                                                                     | `projectcontour/contour`                                |
| `contour.image.tag`                                | Contour image tag                                                                                      | `{TAG_NAME}`                                            |
| `contour.pullPolicy`                               | Contour image pull policy                                                                              | `IfNotPresent`                                          |
| `contour.image.pullSecrets`                        | Specify docker-registry secret names as an array                                                       | `[]` (does not add image pull secrets to deployed pods) |
| `contour.resources.limits`                         | Specify resource limits which the container is not allowed to succeed.                                 | `{}` (does not add resource limits to deployed pods)    |
| `contour.resources.requests`                       | Specify resource requests which the container needs to spawn.                                          | `{}` (does not add resource limits to deployed pods)    |
| `contour.createCustomResource`                     | Creation of customResources via helm hooks (only helm v2)                                              | `true`                                                  |
| `contour.customResourceDeletePolicy`               | Deletion hook of customResources viah helm hooks (only helm v2)                                        | `nil`                                                   |
| `contour.nodeSelector`                             | Node labels for contour pod assignment                                                                 | `{}`                                                    |
| `contour.tolerations`                              | Tolerations for contour pod assignment                                                                 | `[]`                                                    |
| `contour.affinity`                                 | Affinity for contour pod assignment                                                                    | `{}`                                                    |
| `contour.podAnnotations`                           | Contour Pod annotations                                                                                | `{}`                                                    |
| `contour.serviceAccount.create`                    | create a serviceAccount for the contour pod                                                            | `true`                                                  |
| `contour.serviceAccount.name`                      | use the serviceAccount with the specified name                                                         | ""                                                      |
| `contour.livenessProbe.enabled`                    | Enable/disable the Liveness probe                                                                      | `true`                                                  |
| `contour.livenessProbe.initialDelaySeconds`        | Delay before liveness probe is initiated                                                               | `120`                                                   |
| `contour.livenessProbe.periodSeconds`              | How often to perform the probe                                                                         | `20`                                                    |
| `contour.livenessProbe.timeoutSeconds`             | When the probe times out                                                                               | `5`                                                     |
| `contour.livenessProbe.successThreshold`           | Minimum consecutive successes for the probe to be considered successful after having failed.           | `6`                                                     |
| `contour.livenessProbe.failureThreshold`           | Minimum consecutive failures for the probe to be considered failed after having succeeded.             | `1`                                                     |
| `contour.readynessProbe.enabled`                   | Enable/disable the Readyness probe                                                                     | `true`                                                  |
| `contour.readynessProbe.initialDelaySeconds`       | Delay before readyness probe is initiated                                                              | `15`                                                    |
| `contour.readynessProbe.periodSeconds`             | How often to perform the probe                                                                         | `10`                                                    |
| `contour.readynessProbe.timeoutSeconds`            | When the probe times out                                                                               | `5`                                                     |
| `contour.readynessProbe.successThreshold`          | Minimum consecutive successes for the probe to be considered successful after having failed.           | `3`                                                     |
| `contour.readynessProbe.failureThreshold`          | Minimum consecutive failures for the probe to be considered failed after having succeeded.             | `1`                                                     |
| `contour.certgen.serviceAccount.create`            | create a serviceAccount for the contour pod                                                            | `true`                                                  |
| `contour.certgen.serviceAccount.name`              | use the serviceAccount with the specified name                                                         | `""`                                                    |
| `contour.securityContext.enabled`                  | If the pod should run in a securityContext.                                                            | `true`                                                  |
| `contour.securityContext.runAsNonRoot`             | If the pod should run as a non root container.                                                         | `true`                                                  |
| `contour.securityContext.runAsUser`                | define the uid with which the pod will run                                                             | `65534`                                                 |
| `contour.securityContext.runAsGroup`               | define the gid with which the pod will run                                                             | `65534`                                                 |
| `envoy.enabled`                                    | Envoy Proxy Daemonset creation.                                                                        | `true`                                                  |
| `envoy.image.registry`                             | Envoy Proxy image registry                                                                             | `docker.io`                                             |
| `envoy.image.repository`                           | Envoy Proxy image name                                                                                 | `envoyproxy/envoy`                                      |
| `envoy.image.tag`                                  | Envoy Proxy image tag                                                                                  | `{TAG_NAME}`                                            |
| `envoy.pullPolicy`                                 | Envoy Proxy image pull policy                                                                          | `IfNotPresent`                                          |
| `envoy.image.pullSecrets`                          | Specify docker-registry secret names as an array                                                       | `[]` (does not add image pull secrets to deployed pods) |
| `envoy.resources.limits`                           | Specify resource limits which the container is not allowed to succeed.                                 | `{}` (does not add resource limits to deployed pods)    |
| `envoy.resources.requests`                         | Specify resource requests which the container needs to spawn.                                          | `{}` (does not add resource limits to deployed pods)    |
| `envoy.nodeSelector`                               | Node labels for envoy pod assignment                                                                   | `{}`                                                    |
| `envoy.tolerations`                                | Tolerations for envoy pod assignment                                                                   | `[]`                                                    |
| `envoy.affinity`                                   | Affinity for envoy pod assignment                                                                      | `{}`                                                    |
| `envoy.podAnnotations`                             | Envoy Pod annotations                                                                                  | `{}`                                                    |
| `envoy.podSecurityContext`                         | Envoy Pod securityContext                                                                                  | `{}`                                                    |
| `envoy.containerSecurityContext`                   | Envoy Container securityContext                                                                                  | `{}`                                                    |
| `envoy.dnsPolicy`                                  | Envoy Pod Dns Policy                                                                                   | `ClusterFirst`                                                    |
| `envoy.hostNetwork`                                | Envoy Pod host network access                                                                                   | `false`                                                    |
| `envoy.readynessProbe.enabled`                     | Enable/disable the Readyness probe                                                                     | `true`                                                  |
| `envoy.readynessProbe.initialDelaySeconds`         | Delay before readyness probe is initiated                                                              | `10`                                                    |
| `envoy.readynessProbe.periodSeconds`               | How often to perform the probe                                                                         | `3`                                                     |
| `envoy.readynessProbe.timeoutSeconds`              | When the probe times out                                                                               | `1`                                                     |
| `envoy.readynessProbe.successThreshold`            | Minimum consecutive successes for the probe to be considered successful after having failed.           | `3`                                                     |
| `envoy.readynessProbe.failureThreshold`            | Minimum consecutive failures for the probe to be considered failed after having succeeded.             | `1`                                                     |
| `envoy.service.type`                               | Type of envoy service to create                                                                        | `LoadBalancer`                                          |
| `envoy.service.externalTrafficPolicy`              | If `envoy.service.type` is NodePort or LoadBalancer, set this to Local to enable [source IP preservation](https://kubernetes.io/docs/tutorials/services/source-ip/#source-ip-for-services-with-typenodeport) | `Local` |
| `envoy.service.clusterIP`                          | Internal envoy cluster service IP                                                                      | `""`                                                    |
| `envoy.service.externalIPs`                        | Envoy service external IP addresses.                                                                   | `[]`                                                    |
| `envoy.service.loadBalancerIP`                     | IP address to assign to load balancer (if supported)                                                   | `""`                                                    |
| `envoy.service.loadBalancerSourceRanges`           | List of IP CIDRs allowed access to load balancer (if supported)                                        | `[]`                                                    |
| `envoy.service.annotations`                        | Annotations for envoy service                                                                          | `{}`                                                    |
| `envoy.service.ports.http`                         | Sets service http port                                                                                 | `80`                                                    |
| `envoy.service.ports.https`                        | Sets service https port                                                                                | `443`                                                   |
| `envoy.service.nodePorts.http`                     | If `envoy.service.type` is NodePort and this is non-empty, it sets the nodePort that maps to envoys http port  | `""`                                            |
| `envoy.service.nodePorts.https`                    | If `envoy.service.type` is NodePort and this is non-empty, it sets the nodePort that maps to envoys https port | `""`                                            |
| `existingConfigMap`                                | Specify an existing configMapName to use. (this mutually exclusive with existingConfigMap)             | `nil`                                                   |
| `configInline`                                     | Specify the config for contour as a new configMap inline.                                              | `{Quickstart Config}` (evaluated as a template)         |
| `ingressClass`                                     | Name of the ingress class to route through this controller (defaults to `contour` if `nil`)            | `nil`                                                   |
| `nameOverride`                                     | String to partially override contour.fullname template with a string (will prepend the release name)   | `nil`                                                   |
| `fullnameOverride`                                 | String to fully override contour.fullname template with a string                                       | `nil`                                                   |
| `prometheus.serviceMonitor.enabled`                | Specify if a servicemonitor will be deployed for prometheus-operator.                                  | `true`                                                  |
| `prometheus.serviceMonitor.jobLabel`               | Specify the jobLabel to use for the prometheus-operator                                                | `contour`                                               |
| `prometheus.serviceMonitor.interval`               | Specify the scrape interval if not specified use defaul prometheus scrapeIntervall                     | `""`                                                    |
| `prometheus.serviceMonitor.metricRelabelings`      | Specify additional relabeling of metrics.                                                              | `[]`                                                    |
| `prometheus.serviceMonitor.relabelings`            | Specify general relabeling.                                                                            | `[]`                                                    |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install my-release \
  --set envoy.readynessProbe.successThreshold=5 \
    bitnami/contour
```

The above command sets the `envoy.readynessProbe.successThreshold` to `5`.


## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

To configure [Contour](https://projectcontour.io) please look into the configuration section [Contour Configuration](https://github.com/projectcontour/contour/blob/master/site/docs/v1.2.1/configuration.md).

### Example Quickstart Contour Confiuration

```yaml
configInline:
  # should contour expect to be running inside a k8s cluster
  # incluster: true
  #
  # path to kubeconfig (if not running inside a k8s cluster)
  # kubeconfig: /path/to/.kube/config
  #
  # Client request timeout to be passed to Envoy
  # as the connection manager request_timeout.
  # Defaults to 0, which Envoy interprets as disabled.
  # Note that this is the timeout for the whole request,
  # not an idle timeout.
  # request-timeout: 0s
  # disable ingressroute permitInsecure field
  disablePermitInsecure: false
  tls:
  #   minimum TLS version that Contour will negotiate
  #   minimum-protocol-version: "1.1"
  # The following config shows the defaults for the leader election.
  # leaderelection:
  #   configmap-name: leader-elect
  #   configmap-namespace: projectcontour
  ### Logging options
  # Default setting
  accesslog-format: envoy
  # To enable JSON logging in Envoy
  # accesslog-format: json
  # The default fields that will be logged are specified below.
  # To customise this list, just add or remove entries.
  # The canonical list is available at
  # https://godoc.org/github.com/projectcontour/contour/internal/envoy#JSONFields
  # json-fields:
  #   - "@timestamp"
  #   - "authority"
  #   - "bytes_received"
  #   - "bytes_sent"
  #   - "downstream_local_address"
  #   - "downstream_remote_address"
  #   - "duration"
  #   - "method"
  #   - "path"
  #   - "protocol"
  #   - "request_id"
  #   - "requested_server_name"
  #   - "response_code"
  #   - "response_flags"
  #   - "uber_trace_id"
  #   - "upstream_cluster"
  #   - "upstream_host"
  #   - "upstream_local_address"
  #   - "upstream_service_time"
  #   - "user_agent"
  #   - "x_forwarded_for"
```

### Deploying Contour with an AWS NLB

By default, Contour is launched with a AWS Classic ELB. To launch contour backed by a NLB, please set [these settings](https://github.com/projectcontour/contour/tree/master/examples/contour#deploying-with-host-networking-enabled-for-envoy):

```yaml
envoy:
  hostNetwork: true
  dnsPolicy: ClusterFirstWithHostNet
  service:
    annotations:
      service.beta.kubernetes.io/aws-load-balancer-type: nlb
```
