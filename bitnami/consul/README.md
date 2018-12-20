# HashiCorp Consul Helm Chart

[HashiCorp Consul](https://www.consul.io/) has multiple components, but as a whole, it is a tool for discovering and configuring services in your infrastructure

## TL;DR

```console
$ helm repo add bitnami https://charts.bitnami.com/incubator
$ helm install bitnami/consul
```

## Introduction

This chart bootstraps a [HashiCorp Consul](https://github.com/bitnami/bitnami-docker-consul) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release bitnami/consul
```

The command deploys HashiCorp Consul on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```
The command removes all the Kubernetes components associated with the chart and deletes the release. Remove also the chart using `--purge` option:

```console
$ helm delete --purge my-release
```

## Configuration

The following tables lists the configurable parameters of the HashiCorp Consul chart and their default values.

| Parameter                            | Description                                                      | Default                                                    |
| ------------------------------------ | ---------------------------------------------------------------- | ---------------------------------------------------------- |
| `global.imageRegistry`               | Global Docker image registry                                     | `nil`                                                      |
| `image.registry`                     | HashiCorp Consul image registry                                  | `docker.io`                                                |
| `image.repository`                   | HashiCorp Consul image name                                      | `bitnami/consul`                                           |
| `image.tag`                          | HashiCorp Consul image tag                                       | `{VERSION}`                                                |
| `image.pullPolicy`                   | Image pull policy                                                | `Always`                                                   |
| `image.pullSecrets`                  | Specify image pull secrets                                       | `nil`                                                      |
| `replicas`                           | Number of replicas                                               | `3`                                                        |
| `port`                               | HashiCorp Consul http listening port                             | `8500`                                                     |
| `service.rpcPort`                    | HashiCorp Consul rpc listening port                              | `8400`                                                     |
| `service.serflanPort`                | Container serf lan listening port                                | `8301`                                                     |
| `service.serverPort`                 | Container server listening port                                  | `8300`                                                     |
| `service.consulDnsPort`              | Container dns listening port                                     | `8600`                                                     |
| `service.uiPort`                     | HashiCorp Consul UI port                                         | `80`                                                       |
| `datacenterName`                     | HashiCorp Consul datacenter name                                 | `dc1`                                                      |
| `gossipKey`                          | Gossip key for all members                                       | `nil`                                                      |
| `domain`                             | HashiCorp Consul domain                                          | `consul`                                                   |
| `clientAddress`                      | Address in which HashiCorp Consul will bind client interfaces    | `0.0.0.0`                                                  |
| `serflanAddress`                     | Address used for Serf LAN communications                         | `0.0.0.0`                                                  |
| `raftMultiplier`                     | Multiplier used to scale key Raft timing parameters              | `10Gi`                                                     |
| `securityContext.enabled`            | Enable security context                                          | `true`                                                     |
| `securityContext.fsGroup`            | Group ID for the container                                       | `1001`                                                     |
| `securityContext.runAsUser`          | User ID for the container                                        | `1001`                                                     |
| `persistence.enabled`                | Use a PVC to persist data                                        | `true`                                                     |
| `persistence.storageClass`           | Storage class of backing PVC                                     | `nil` (uses alpha storage class annotation)                |
| `persistence.accessMode`             | Use volume as ReadOnly or ReadWrite                              | `ReadWriteOnce`                                            |
| `persistence.size`                   | Size of data volume                                              | `8Gi`                                                      |
| `persistence.annotations`            | Annotations for the persistent volume                            | `nil`                                                      |
| `resources`                          | Container resource requests and limits                           | `{}`                                                       |
| `maxUnavailable`                     | Pod disruption Budget maxUnavailable                             | `1`                                                        |
| `nodeAffinity`                       | HashiCorp Consul pod node-affinity setting                       | `nil`                                                      |
| `antiAffinity`                       | HashiCorp Consul pod anti-affinity setting                       | `soft`                                                     |
| `ui.service.enabled`                 | Use a service to access HashiCorp Consul Ui                      | `true`                                                     |
| `ui.service.type`                    | Kubernetes Service Type                                          | `ClusterIP`                                                |
| `ui.service.annotations`             | Annotations for HashiCorp Consul UI service                      | {}                                                         |
| `ui.service.loadBalancerIP`          | IP if HashiCorp Consul UI service type is `LoadBalancer`         | `nil`                                                      |
| `ingress.enabled`                    | Enable ingress controller resource                               | `false`                                                    |
| `ingress.certManager`                | Add annotations for cert-manager                                 | `false`                                                    |
| `ingress.annotations`                | Ingress annotations                                              | `[]`                                                       |
| `ingress.hosts[0].name`              | Hostname to your HashiCorp Consul installation                   | `consul-ui.local`                                          |
| `ingress.hosts[0].path`              | Path within the url structure                                    | `/`                                                        |
| `ingress.hosts[0].tls`               | Utilize TLS backend in ingress                                   | `false`                                                    |
| `ingress.hosts[0].tlsSecret`         | TLS Secret (certificates)                                        | `consul-ui.local-tls`                                      |
| `ingress.secrets[0].name`            | TLS Secret Name                                                  | `nil`                                                      |
| `ingress.secrets[0].certificate`     | TLS Secret Certificate                                           | `nil`                                                      |
| `ingress.secrets[0].key`             | TLS Secret Key                                                   | `nil`                                                      |
| `configmap`                          | HashiCorp Consul configuration to be injected as ConfigMap       | `nil`                                                      |
| `metrics.enabled`                    | Start a side-car prometheus exporter                             | `false`                                                    |
| `metrics.image`                      | Exporter image                                                   | `prom/consul-exporter`                                     |
| `metrics.imageTag`                   | Exporter image tag                                               | `v0.3.0`                                                   |
| `metrics.imagePullPolicy`            | Exporter image pull policy                                       | `IfNotPresent`                                             |
| `metrics.resources`                  | Exporter resource requests/limit                                 | `{}`                                                       |
| `metrics.podAnnotations`             | Exporter annotations                                             | `{}`                                                       |
| `nodeSelector`                       | Node labels for pod assignment                                   | `{}`                                                       |
| `livenessProbe.initialDelaySeconds`  | Delay before liveness probe is initiated                         | 30                                                         |
| `livenessProbe.periodSeconds`        | How often to perform the probe                                   | 10                                                         |
| `livenessProbe.timeoutSeconds`       | When the probe times out                                         | 5                                                          |
| `livenessProbe.successThreshold`     | Minimum consecutive successes for the probe to be considered successful after having failed. | 1                              |
| `livenessProbe.failureThreshold`     | Minimum consecutive failures for the probe to be considered failed after having succeeded.   | 6                              |
| `podAnnotations`                     | Pod annotations                                                  | `{}`                                                       |
| `readinessProbe.initialDelaySeconds` | Delay before readiness probe is initiated                        | 5                                                          |
| `readinessProbe.periodSeconds`       | How often to perform the probe                                   | 10                                                         |
| `readinessProbe.timeoutSeconds`      | When the probe times out                                         | 5                                                          |
| `readinessProbe.successThreshold`    | Minimum consecutive successes for the probe to be considered successful after having failed. | 1                              |
| `readinessProbe.failureThreshold`    | Minimum consecutive failures for the probe to be considered failed after having succeeded. | 6                                |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release --set domain=consul-domain,gossipKey=secretkey bitnami/consul
```
The above command sets the HashiCorp Consul domain to `consul-domain` and sets the gossip key to `secretkey`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml bitnami/consul
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Persistence

The [Bitnami HashiCorp Consul](https://github.com/bitnami/bitnami-docker-consul) image stores the HashiCorp Consul data at the `/bitnami` path of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Configuration](#configuration) section to configure the PVC or to disable persistence.

## Ingress

This chart provides support for ingress resources. If you have an
ingress controller installed on your cluster, such as [nginx-ingress](https://kubeapps.com/charts/stable/nginx-ingress)
or [traefik](https://kubeapps.com/charts/stable/traefik) you can utilize
the ingress controller to service your HashiCorp Consul UI application.

To enable ingress integration, please set `ingress.enabled` to `true`

### Hosts
Most likely you will only want to have one hostname that maps to this
HashiCorp Consul installation, however it is possible to have more than one
host.  To facilitate this, the `ingress.hosts` object is an array.

For each item, please indicate a `name`, `tls`, `tlsSecret`, and any
`annotations` that you may want the ingress controller to know about.

Indicating TLS will cause HashiCorp Consul to generate HTTPS urls, and
HashiCorp Consul will be connected to at port 443.  The actual secret that
`tlsSecret` references does not have to be generated by this chart.
However, please note that if TLS is enabled, the ingress record will not
work until this secret exists.

For annotations, please see [this document](https://github.com/kubernetes/ingress-nginx/blob/master/docs/annotations.md).
Not all annotations are supported by all ingress controllers, but this
document does a good job of indicating which annotation is supported by
many popular ingress controllers.

### TLS Secrets
This chart will facilitate the creation of TLS secrets for use with the
ingress controller, however this is not required.  There are three
common use cases:

* helm generates / manages certificate secrets
* user generates / manages certificates separately
* an additional tool (like [kube-lego](https://kubeapps.com/charts/stable/kube-lego))
manages the secrets for the application

In the first two cases, one will need a certificate and a key.  We would
expect them to look like this:

* certificate files should look like (and there can be more than one
certificate if there is a certificate chain)

```
-----BEGIN CERTIFICATE-----
MIID6TCCAtGgAwIBAgIJAIaCwivkeB5EMA0GCSqGSIb3DQEBCwUAMFYxCzAJBgNV
...
jScrvkiBO65F46KioCL9h5tDvomdU1aqpI/CBzhvZn1c0ZTf87tGQR8NK7v7
-----END CERTIFICATE-----
```
* keys should look like:
```
-----BEGIN RSA PRIVATE KEY-----
MIIEogIBAAKCAQEAvLYcyu8f3skuRyUgeeNpeDvYBCDcgq+LsWap6zbX5f8oLqp4
...
wrj2wDbCDCFmfqnSJ+dKI3vFLlEz44sAV8jX/kd4Y6ZTQhlLbYc=
-----END RSA PRIVATE KEY-----
````

If you are going to use helm to manage the certificates, please copy
these values into the `certificate` and `key` values for a given
`ingress.secrets` entry.

If you are going to manage TLS secrets outside of helm, please
know that you can create a TLS secret by doing the following:

```
kubectl create secret tls consul.local-tls --key /path/to/key.key --cert /path/to/cert.crt
```

Please see [this example](https://github.com/kubernetes/contrib/tree/master/ingress/controllers/nginx/examples/tls)
for more information.

## Enable TLS encryption between servers

You must manually create a secret containing your PEM-encoded certificate authority, your PEM-encoded certificate, and your PEM-encoded private key.

```
kubectl create secret generic consul-tls-encryption \
  --from-file=ca.pem \
  --from-file=consul.pem \
  --from-file=consul-key.pem
```

> Take into account that you will need to create a config map with the proper configuration.

If the secret is specified, the chart will locate those files at `/opt/bitnami/consul/certs/`, so you will want to use the below snippet to configure HashiCorp Consul TLS encryption in your config map:

```
  "ca_file": "/opt/bitnami/consul/certs/ca.pem",
  "cert_file": "/opt/bitnami/consul/certs/consul.pem",
  "key_file": "/opt/bitnami/consul/certs/consul-key.pem",
  "verify_incoming": true,
  "verify_outgoing": true,
  "verify_server_hostname": true,
```

After creating the secret, you can install the helm chart specyfing the secret name:

```
helm install bitnami/consul --set tlsEncryptionSecretName=consul-tls-encryption
```

## Metrics

The chart can optionally start a metrics exporter endpoint on port `9107` for [prometheus](https://prometheus.io). The data exposed by the endpoint is intended to be consumed by a prometheus chart deployed within the cluster and as such the endpoint is not exposed outside the cluster.

## Upgrading

### To 3.1.0

Consul container was moved to a non-root approach. There shouldn't be any issue when upgrading since the corresponding `securityContext` is enabled by default. Both the container image and the chart can be upgraded by running the command below:

```
$ helm upgrade my-release stable/consul
```

If you use a previous container image (previous to **1.4.0-r16**) disable the `securityContext` by running the command below:

```
$ helm upgrade my-release stable/consul --set securityContext.enabled=fase,image.tag=XXX
```

### To 2.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 2.0.0. The following example assumes that the release name is consul:

```console
$ kubectl delete statefulset consul --cascade=false
```
