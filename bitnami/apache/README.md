# Apache

The [Apache HTTP Server Project](https://httpd.apache.org/) is an effort to develop and maintain an open-source HTTP server for modern operating systems including UNIX and Windows NT. The goal of this project is to provide a secure, efficient and extensible server that provides HTTP services in sync with the current HTTP standards.

The Apache HTTP Server ("httpd") was launched in 1995 and it has been the most popular web server on the Internet since April 1996. It has celebrated its 20th birthday as a project in February 2015.

## TL;DR

```bash
$ helm install bitnami/apache
```

## Introduction

Bitnami charts for Helm are carefully engineered, actively maintained and are the quickest and easiest way to deploy containers on a Kubernetes cluster that are ready to handle production workloads.

This chart bootstraps a [Apache](https://github.com/bitnami/bitnami-docker-apache) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This Helm chart has been tested on top of [Bitnami Kubernetes Production Runtime](https://kubeprod.io/) (BKPR). Deploy BKPR to get automated TLS certificates, logging and monitoring for your applications.

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release bitnami/apache
```

The command deploys Apache on the Kubernetes cluster in the default configuration.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the Apache chart and their default values.

| Parameter                        | Description                                      | Default                                                      |
|----------------------------------|--------------------------------------------------|--------------------------------------------------------------|
| `global.imageRegistry`           | Global Docker image registry                     | `nil`                                                        |
| `global.imagePullSecrets`        | Global Docker registry secret names as an array  | `[]` (does not add image pull secrets to deployed pods)      |
| `image.registry`                 | Apache Docker image registry                     | `docker.io`                                                  |
| `image.repository`               | Apache Docker image name                         | `bitnami/apache`                                             |
| `image.tag`                      | Apache Docker image tag                          | `{TAG_NAME}`                                                 |
| `image.pullPolicy`               | Apache Docker image pull policy                  | `IfNotPresent`                                               |
| `image.pullSecrets`              | Specify Docker registry secret names as an array | `[]` (does not add image pull secrets to deployed pods)      |
| `podAnnotations`                 | Pod annotations                                  | `{}`                                                         |
| `ingress.enabled`                | Enable ingress controller resource               | `false`                                                      |
| `ingress.certManager`            | Add annotations for cert-manager                 | `false`                                                      |
| `ingress.annotations`            | Ingress annotations                              | `[]`                                                         |
| `ingress.hosts[0].name`          | Hostname to your Apache installation             | `example.local`                                              |
| `ingress.hosts[0].path`          | Path within the url structure                    | `/`                                                          |
| `ingress.tls[0].hosts[0]`        | TLS hosts                                        | `example.local`                                              |
| `ingress.tls[0].secretName`      | TLS Secret (certificates)                        | `example.local-tls`                                          |
| `ingress.secrets[0].name`        | TLS Secret Name                                  | `nil`                                                        |
| `ingress.secrets[0].certificate` | TLS Secret Certificate                           | `nil`                                                        |
| `ingress.secrets[0].key`         | TLS Secret Key                                   | `nil`                                                        |
| `metrics.enabled`                | Start a side-car prometheus exporter             | `false`                                                      |
| `metrics.image.registry`         | Apache exporter image registry                   | `docker.io`                                                  |
| `metrics.image.repository`       | Apache exporter image name                       | `lusotycoon/apache-exporter`                                 |
| `metrics.image.tag`              | Apache exporter image tag                        | `v0.5.0`                                                     |
| `metrics.image.pullPolicy`       | Apache exporter image pull policy                | `IfNotPresent`                                               |
| `metrics.image.pullSecrets`      | Specify Docker registry secret names as an array | `[]` (does not add image pull secrets to deployed pods)      |
| `metrics.podAnnotations`         | Additional annotations for Metrics exporter pod  | `{prometheus.io/scrape: "true", prometheus.io/port: "9117"}` |
| `metrics.resources`              | Exporter resource requests/limit                 | {}                                                           |
| `service.type`                   | Kubernetes Service type                          | `LoadBalancer`                                               |
| `service.port`                   | Service HTTP port                                | `80`                                                         |
| `service.httpsPort`              | Service HTTPS port                               | `443`                                                        |
| `service.nodePorts.http`         | Kubernetes http node port                        | `""`                                                         |
| `service.nodePorts.https`        | Kubernetes https node port                       | `""`                                                         |
| `service.externalTrafficPolicy`  | Enable client source IP preservation             | `Cluster`                                                    |
| `service.loadBalancerIP`         | LoadBalancer service IP address                  | `""`                                                         |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
  --set imagePullPolicy=Always \
    bitnami/apache
```

The above command sets the `imagePullPolicy` to `Always`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml bitnami/apache
```

> **Tip**: You can use the default [values.yaml](values.yaml)

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

## Upgrading

### To 2.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 2.0.0. The following example assumes that the release name is apache:

```console
$ kubectl patch deployment apache --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
```
