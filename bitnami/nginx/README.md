# NGINX

[NGINX](https://nginx.org) (pronounced "engine-x") is an open source reverse proxy server for HTTP, HTTPS, SMTP, POP3, and IMAP protocols, as well as a load balancer, HTTP cache, and a web server (origin server).

## TL;DR;

```bash
$ helm install bitnami/nginx
```

## Introduction

Bitnami charts for Helm are carefully engineered, actively maintained and are the quickest and easiest way to deploy containers on a Kubernetes cluster that are ready to handle production workloads.

This chart bootstraps a [NGINX Open Source](https://github.com/bitnami/bitnami-docker-nginx) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release bitnami/nginx
```

The command deploys NGINX Open Source on the Kubernetes cluster in the default configuration.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the NGINX Open Source chart and their default values.

|          Parameter        |             Description        |                        Default                            |
| ------------------------- | ------------------------------ | --------------------------------------------------------- |
| `global.imageRegistry`    | Global Docker image registry   | `nil`                                                     |
| `image.registry`          | NGINX image registry           | `docker.io`                                               |
| `image.repository`        | NGINX Image name               | `bitnami/nginx`                                           |
| `image.tag`               | NGINX Image tag                | `{VERSION}`                                               |
| `image.pullPolicy`        | NGINX image pull policy        | `Always` if `imageTag` is `latest`, else `IfNotPresent`   |
| `image.pullSecrets`       | Specify image pull secrets     | `nil` (does not add image pull secrets to deployed pods)  |
| `vhost`                   | Custom NGINX virtual host      | `nil`                                                     |
| `podAnnotations`                | Pod annotations                                   | `{}`                                                       |
| `metrics.enabled`                          | Start a side-car prometheus exporter                                                                           | `false`                                              |
| `metrics.image.registry`                   | Promethus exporter image registry                                                                                  | `docker.io`                                          |
| `metrics.image.repository`                 | Promethus exporter image name                                                                                      | `nginx/nginx-prometheus-exporter`                    |
| `metrics.image.tag`                        | Promethus exporter image tag                                                                                       | `0.1.0`                                              |
| `metrics.image.pullPolicy`                 | Image pull policy                                                                                              | `IfNotPresent`                                       |
| `metrics.image.pullSecrets`                | Specify docker-registry secret names as an array                                                               | `nil`                                                |
| `metrics.podAnnotations`                   | Additional annotations for Metrics exporter pod                                                                | `{prometheus.io/scrape: "true", prometheus.io/port: "9113"}`                                                   |
| `metrics.resources`                        | Exporter resource requests/limit                                                                               | {}                        |
| `service.type`                    | Kubernetes Service type                    | `LoadBalancer`                                          |
| `service.port`                    | Service HTTP port                  | `80`                                          |
| `service.nodePorts.http`                 | Kubernetes http node port                  | `""`                                                    |
| `service.externalTrafficPolicy`   | Enable client source IP preservation       | `Cluster`                                               |
| `service.loadBalancerIP`   | LoadBalancer service IP address       | `""`                                               |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
  --set imagePullPolicy=Always \
    bitnami/nginx
```

The above command sets the `imagePullPolicy` to `Always`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml bitnami/nginx
```

> **Tip**: You can use the default [values.yaml](values.yaml)

### Providing a custom virtual host

You can use the `vhost` value to provide a custom virtual host for NGINX to use.
To do this, create a values files with your virtual host:

_custom-vhost.yaml_
```yaml
vhost: |-
  server {
    listen 0.0.0.0:8080;
    location / {
      return 200 "hello!";
    }
  }
```

Install the chart with this value:

```console
$ helm install --name my-release -f custom-vhost.yaml bitnami/nginx
```

## Upgrading

### To 1.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 1.0.0. The following example assumes that the release name is nginx:

```console
$ kubectl patch deployment nginx --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
```
