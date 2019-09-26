# Fluentd

[Fluentd](https://www.fluentd.org/) is an open source data collector, which lets you unify the data collection and consumption for a better use and understanding of data.

## TL;DR;

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install bitnami/fluentd
```

## Introduction

This chart bootstraps a [Fluentd](https://github.com/bitnami/bitnami-docker-fluentd) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install bitnami/fluentd --name my-release
```

These commands deploy Fluentd on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` statefulset:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release. Use the option `--purge` to delete all history too.

## Configuration

The following tables lists the configurable parameters of the kibana chart and their default values.

| Parameter                                       | Description                                                                                                    | Default                                                 |
| ----------------------------------------------- | -------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------- |
| `global.imageRegistry`                          | Global Docker image registry                                                                                   | `nil`                                                   |
| `global.imagePullSecrets`                       | Global Docker registry secret names as an array                                                                | `[]` (does not add image pull secrets to deployed pods) |
| `global.storageClass`                           | Global storage class for dynamic provisioning                                                                  | `nil`                                                   |
| `image.registry`                                | Fluentd image registry                                                                                         | `docker.io`                                             |
| `image.repository`                              | Fluentd image name                                                                                             | `bitnami/fluentd`                                       |
| `image.tag`                                     | Fluentd image tag                                                                                              | `{TAG_NAME}`                                            |
| `image.pullPolicy`                              | Fluentd image pull policy                                                                                      | `IfNotPresent`                                          |
| `image.pullSecrets`                             | Specify docker-registry secret names as an array                                                               | `[]` (does not add image pull secrets to deployed pods) |
| `nameOverride`                                  | String to partially override fluentd.fullname template with a string (will prepend the release name)           | `nil`                                                   |
| `fullnameOverride`                              | String to fully override fluentd.fullname template with a string                                               | `nil`                                                   |
| `clusterDomain`                                 | Kubernetes DNS domain name to use                                                                              | `cluster.local`                                         |
| `forwarder.configFile`                          | Name of the config file that will be used by Fluentd at launch under the `/opt/bitnami/fluentd/conf` directory | `fluentd.conf`                                          |
| `forwarder.service.type`                        | Kubernetes Service type                                                                                        |                                                         | `ClusterIP` |
| `forwarder.service.port`                        | Kubernetes Service port - Fluentd transport port for the forwarders                                            | `24224`                                                 |
| `forwarder.service.nodePort`                    | Port to bind to for NodePort service type (client port)                                                        | `nil`                                                   |
| `forwarder.service.annotations`                 | Annotations for Fluentd service (evaluated as a template)                                                      | `{}`                                                    |
| `forwarder.service.loadBalancerIP`              | loadBalancerIP if Fluentd service type is `LoadBalancer`                                                       | `nil`                                                   |
| `forwarder.extraArgs`                           | Extra arguments for the Fluentd command line                                                                   | `nil`                                                   |
| `forwarder.extraEnv`                            | Extra environment variables to pass to the container                                                           | `{}`                                                    |
| `forwarder.livenessProbe.initialDelaySeconds`   | Delay before liveness probe is initiated                                                                       | `60`                                                    |
| `forwarder.livenessProbe.periodSeconds`         | How often to perform the probe                                                                                 | `10`                                                    |
| `forwarder.livenessProbe.timeoutSeconds`        | When the probe times out                                                                                       | `5`                                                     |
| `forwarder.livenessProbe.failureThreshold`      | Minimum consecutive failures for the probe to be considered failed after having succeeded.                     | `6`                                                     |
| `forwarder.livenessProbe.successThreshold`      | Minimum consecutive successes for the probe to be considered successful after having failed.                   | `1`                                                     |
| `forwarder.readinessProbe.initialDelaySeconds`  | Delay before readiness probe is initiated                                                                      | `5`                                                     |
| `forwarder.readinessProbe.periodSeconds`        | How often to perform the probe                                                                                 | `10`                                                    |
| `forwarder.readinessProbe.timeoutSeconds`       | When the probe times out                                                                                       | `5`                                                     |
| `forwarder.readinessProbe.failureThreshold`     | Minimum consecutive failures for the probe to be considered failed after having succeeded.                     | `6`                                                     |
| `forwarder.readinessProbe.successThreshold`     | Minimum consecutive successes for the probe to be considered successful after having failed.                   | `1`                                                     |
| `forwarder.updateStrategy`                      | Update strategy for the forwarder DaemonSet                                                                    | `RollingUpdate`                                         |
| `forwarder.resources`                           | Configure resource requests and limits                                                                         | `nil`                                                   |
| `forwarder.nodeSelector`                        | Node labels for pod assignment                                                                                 | `{}`                                                    |
| `forwarder.tolerations`                         | Tolerations for pod assignment                                                                                 | `[]`                                                    |
| `forwarder.affinity`                            | Affinity for pod assignment                                                                                    | `{}`                                                    |
| `forwarder.podAnnotations`                      | Pod annotations                                                                                                | `{}`                                                    |
| `aggregator.replicaCount`                       | Number of aggregator pods to deploy in the Stateful Set                                                        | `2`                                                     |
| `aggregator.configFile`                         | Name of the config file that will be used by Fluentd at launch under the `/opt/bitnami/fluentd/conf` directory | `fluentd.conf`                                          |
| `aggregator.service.type`                       | Kubernetes Service type                                                                                        |                                                         | `ClusterIP` |
| `aggregator.port`                               | Kubernetes Service port - Fluentd transport port for the aggregators                                           | `24224`                                                 |
| `aggregator.extraArgs`                          | Extra arguments for the Fluentd command line                                                                   | `nil`                                                   |
| `aggregator.extraEnv`                           | Extra environment variables to pass to the container                                                           | `{}`                                                    |
| `aggregator.livenessProbe.initialDelaySeconds`  | Delay before liveness probe is initiated                                                                       | `60`                                                    |
| `aggregator.livenessProbe.periodSeconds`        | How often to perform the probe                                                                                 | `10`                                                    |
| `aggregator.livenessProbe.timeoutSeconds`       | When the probe times out                                                                                       | `5`                                                     |
| `aggregator.livenessProbe.failureThreshold`     | Minimum consecutive failures for the probe to be considered failed after having succeeded.                     | `6`                                                     |
| `aggregator.livenessProbe.successThreshold`     | Minimum consecutive successes for the probe to be considered successful after having failed.                   | `1`                                                     |
| `aggregator.readinessProbe.initialDelaySeconds` | Delay before readiness probe is initiated                                                                      | `5`                                                     |
| `aggregator.readinessProbe.periodSeconds`       | How often to perform the probe                                                                                 | `10`                                                    |
| `aggregator.readinessProbe.timeoutSeconds`      | When the probe times out                                                                                       | `5`                                                     |
| `aggregator.readinessProbe.failureThreshold`    | Minimum consecutive failures for the probe to be considered failed after having succeeded.                     | `6`                                                     |
| `aggregator.readinessProbe.successThreshold`    | Minimum consecutive successes for the probe to be considered successful after having failed.                   | `1`                                                     |
| `aggregator.updateStrategy`                     | Update strategy for the aggregator DaemonSet                                                                   | `RollingUpdate`                                         |
| `aggregator.resources`                          | Configure resource requests and limits                                                                         | `nil`                                                   |
| `aggregator.nodeSelector`                       | Node labels for pod assignment                                                                                 | `{}`                                                    |
| `aggregator.tolerations`                        | Tolerations for pod assignment                                                                                 | `[]`                                                    |
| `aggregator.affinity`                           | Affinity for pod assignment                                                                                    | `{}`                                                    |
| `aggregator.podAnnotations`                     | Pod annotations                                                                                                | `{}`                                                    |
| `serviceAccount.create`                         | Specify whether a ServiceAccount should be created                                                             | `true`                                                  |
| `serviceAccount.name`                           | The name of the ServiceAccount to create                                                                       | Generated using the `fluentd.fullname` template         |
| `rbac.create`                                   | Specify whether RBAC resources should be created and used                                                      | `true`                                                  |
| `metrics.enabled`                               | Enable the export of Prometheus metrics                                                                        | `nil`                                                   |
| `metrics.service.port`                          | Prometheus metrics service port                                                                                | `24231`                                                 |
| `metrics.service.annotations`                   | Annotations for Prometheus metrics service                                                                     | `{}`                                                    |
| `tls.enabled`                                   | Enable the addition of TLS certificates                                                                        |                                                         | `false`     |
| `tls.caCertificate`                             | Ca certificate                                                                                                 | Certificate Authority (CA) bundle content               |
| `tls.serverCertificate`                         | Server certificate                                                                                             | Server certificate content                              |
| `tls.serverKey`                                 | Server Key                                                                                                     | Server private key content                              |
| `tls.existingSecret`                            | Existing secret with certificate content                                                                       | `nil`                                                   |
| `securityContext.enabled`                       | Enable security context                                                                                        | `true`                                                  |
| `securityContext.fsGroup`                       | Group ID for the container filesystem                                                                          | `1001`                                                  |
| `securityContext.runAsUser`                     | User ID for the container                                                                                      | `1001`                                                  |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set aggregator.port=24444 bitnami/fluentd
```

The above command sets the aggregators to listen on port 24444.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml bitnami/fluentd
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.
