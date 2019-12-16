# Apache

The [Apache HTTP Server Project](https://httpd.apache.org/) is an effort to develop and maintain an open-source HTTP server for modern operating systems including UNIX and Windows NT. The goal of this project is to provide a secure, efficient and extensible server that provides HTTP services in sync with the current HTTP standards.

The Apache HTTP Server ("httpd") was launched in 1995 and it has been the most popular web server on the Internet since April 1996. It has celebrated its 20th birthday as a project in February 2015.

## TL;DR;

```bash
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install bitnami/apache
```

## Introduction

Bitnami charts for Helm are carefully engineered, actively maintained and are the quickest and easiest way to deploy containers on a Kubernetes cluster that are ready to handle production workloads.

This chart bootstraps a [Apache](https://github.com/bitnami/bitnami-docker-apache) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This Helm chart has been tested on top of [Bitnami Kubernetes Production Runtime](https://kubeprod.io/) (BKPR). Deploy BKPR to get automated TLS certificates, logging and monitoring for your applications.

## Prerequisites

- Kubernetes 1.12+
- Helm 2.11+ or Helm 3.0-beta3+

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install --name my-release bitnami/apache
```

These commands deploy Apache on the Kubernetes cluster in the default configuration.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

The following tables lists the configurable parameters of the Apache chart and their default values.

| Parameter                        | Description                                             | Default                                                      |
| -------------------------------- | ------------------------------------------------------- | ------------------------------------------------------------ |
| `global.imageRegistry`           | Global Docker image registry                            | `nil`                                                        |
| `global.imagePullSecrets`        | Global Docker registry secret names as an array         | `[]` (does not add image pull secrets to deployed pods)      |
| `image.registry`                 | Apache Docker image registry                            | `docker.io`                                                  |
| `image.repository`               | Apache Docker image name                                | `bitnami/apache`                                             |
| `image.tag`                      | Apache Docker image tag                                 | `{TAG_NAME}`                                                 |
| `image.pullPolicy`               | Apache Docker image pull policy                         | `Always`                                                     |
| `image.pullSecrets`              | Specify Docker registry secret names as an array        | `[]` (does not add image pull secrets to deployed pods)      |
| `git.registry`                   | Git image registry                                      | `docker.io`                                                  |
| `git.repository`                 | Git image name                                          | `bitnami/git`                                                |
| `git.tag`                        | Git image tag                                           | `{TAG_NAME}`                                                 |
| `git.pullPolicy`                 | Git image pull policy                                   | `Always`                                                     |
| `git.pullSecrets`                | Specify docker-registry secret names as an array        | `[]` (does not add image pull secrets to deployed pods)      |
| `replicaCount`                   | Number of replicas of the Apache deployment             | `docker.io`                                                  |
| `htdocsConfigMap`                | ConfigMap with the server static content                | `nil`                                                        |
| `htdocsPVC`                      | PVC with the server static content                      | `nil`                                                        |
| `vhostsConfigMap`                | ConfigMap with the virtual hosts content                | `nil`                                                        |
| `httpdConfConfigMap`             | ConfigMap with the httpd.conf content                   | `nil`                                                        |
| `cloneHtdocsFromGit.enabled`     | Get the server static content from a git repository     | `false`                                                      |
| `cloneHtdocsFromGit.repository`  | Repository to clone static content from                 | `nil`                                                        |
| `cloneHtdocsFromGit.branch`      | Branch inside the git repository                        | `nil`                                                        |
| `cloneHtdocsFromGit.interval`    | Interval for sidecar container pull from the repository | `60`                                                         |
| `podAnnotations`                 | Pod annotations                                         | `{}`                                                         |
| `livenessProbe.enabled`          | Enable liveness probe                                   | `true`                                                       |
| `livenessProbe.path`             | Path to access on the HTTP server                       | `/`                                                          |
| `readinessProbe.enabled`         | Enable readiness probe                                  | `true`                                                       |
| `readinessProbe.path`            | Path to access on the HTTP server                       | `/`                                                          |    
| `ingress.enabled`                | Enable ingress controller resource                      | `false`                                                      |
| `ingress.hostname`               | Default host for the ingress resource                   | `example.local`                                              |
| `ingress.certManager`            | Add annotations for cert-manager                        | `false`                                                      |
| `ingress.annotations`            | Ingress annotations                                     | `[]`                                                         |
| `ingress.hosts[0].name`          | Hostname to your Apache installation                    | `example.local`                                              |
| `ingress.hosts[0].path`          | Path within the url structure                           | `/`                                                          |
| `ingress.tls[0].hosts[0]`        | TLS hosts                                               | `example.local`                                              |
| `ingress.tls[0].secretName`      | TLS Secret (certificates)                               | `example.local-tls`                                          |
| `ingress.secrets[0].name`        | TLS Secret Name                                         | `nil`                                                        |
| `ingress.secrets[0].certificate` | TLS Secret Certificate                                  | `nil`                                                        |
| `ingress.secrets[0].key`         | TLS Secret Key                                          | `nil`                                                        |
| `affinity`                       | Map of node/pod affinities                              | `{}` (The value is evaluated as a template)                  |
| `nodeSelector`                   | Node labels for pod assignment                          | `{}` (The value is evaluated as a template)                  |
| `tolerations`                    | Tolerations for pod assignment                          | `[]` (The value is evaluated as a template)                  |
| `metrics.enabled`                | Start a side-car prometheus exporter                    | `false`                                                      |
| `metrics.image.registry`         | Apache exporter image registry                          | `docker.io`                                                  |
| `metrics.image.repository`       | Apache exporter image name                              | `lusotycoon/apache-exporter`                                 |
| `metrics.image.tag`              | Apache exporter image tag                               | `v0.5.0`                                                     |
| `metrics.image.pullPolicy`       | Apache exporter image pull policy                       | `IfNotPresent`                                               |
| `metrics.image.pullSecrets`      | Specify Docker registry secret names as an array        | `[]` (does not add image pull secrets to deployed pods)      |
| `metrics.podAnnotations`         | Additional annotations for Metrics exporter pod         | `{prometheus.io/scrape: "true", prometheus.io/port: "9117"}` |
| `metrics.resources`              | Exporter resource requests/limit                        | {}                                                           |
| `service.type`                   | Kubernetes Service type                                 | `LoadBalancer`                                               |
| `service.port`                   | Service HTTP port                                       | `80`                                                         |
| `service.httpsPort`              | Service HTTPS port                                      | `443`                                                        |
| `service.nodePorts.http`         | Kubernetes http node port                               | `""`                                                         |
| `service.nodePorts.https`        | Kubernetes https node port                              | `""`                                                         |
| `service.externalTrafficPolicy`  | Enable client source IP preservation                    | `Cluster`                                                    |
| `service.loadBalancerIP`         | LoadBalancer service IP address                         | `""`                                                         |

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

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Deploying your custom web application

The Apache chart allows you to deploy a custom web application using one of the following methods:

  - Cloning from a git repository: Set `cloneHtdocsFromGit.enabled` to `true` and set the repository and branch using the `cloneHtdocsFromGit.repository` and  `cloneHtdocsFromGit.branch` parameters. A sidecar will also pull the latest changes in an interval set by `cloneHtdocsFromGit.interval`.
  - Providing a ConfigMap: Set the `htdocsConfigMap` value to mount a ConfigMap in the Apache htdocs folder.
  - Using an existing PVC: Set the `htdocsPVC` value to mount an PersistentVolumeClaim with the web application content.

You can deploy a example web application using git deploying the chart with the following parameters:

```console
cloneHtdocsFromGit.enabled=true
cloneHtdocsFromGit.repository=https://github.com/mdn/beginner-html-site-styled.git
cloneHtdocsFromGit.branch=master
```

To use your own `httpd.conf` file you can mount it using the `httpdConfConfigMap` parameter, which is the name of a Config Map with the contents of your `httpd.conf`. Additionaly, you can copy your `httpd.conf` to `/files/httpd.conf` in your current working directory to mount it to the container.

You may also want to mount different virtual host configurations. This can be done using the `vhostsConfigMap` value. This is a pointer to a ConfigMap with the desired Apache virtual host configurations. You can also copy your virtual host configurations under the `files/vhosts/` directory in your current working directory to mount them as a Config Map to the container.

## Notable changes

### 7.0.0

This release updates the Bitnami Apache container to `2.4.41-debian-9-r40`, which is based on Bash instead of Node.js.

### 6.0.0

This release allows you to use your custom static applicaton. In order to do so, check [this section](#deploying-your-custom-web-application).

## Upgrading

### To 2.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 2.0.0. The following example assumes that the release name is apache:

```console
$ kubectl patch deployment apache --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
```
