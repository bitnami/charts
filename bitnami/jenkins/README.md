# Jenkins

[Jenkins](https://jenkins.io) is widely recognized as the most feature-rich CI available with easy configuration, continuous delivery and continuous integration support, easily test, build and stage your app, and more. It supports multiple SCM tools including CVS, Subversion and Git. It can execute Apache Ant and Apache Maven-based projects as well as arbitrary scripts.

## TL;DR;

```console
$ helm install bitnami/jenkins
```

## Introduction

This chart bootstraps a [Jenkins](https://github.com/bitnami/bitnami-docker-jenkins) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release bitnami/jenkins
```

The command deploys Jenkins on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the Jenkins chart and their default values.

|         Parameter          |              Description               |                               Default                     |
|----------------------------|----------------------------------------|---------------------------------------------------------- |
| `global.imageRegistry`     | Global Docker image registry           | `nil`                                                     |
| `image.registry`           | Jenkins image registry                 | `docker.io`                                               |
| `image.repository`         | Jenkins Image name                     | `bitnami/jenkins`                                         |
| `image.tag`                | Jenkins Image tag                      | `{VERSION}`                                               |
| `image.pullPolicy`         | Jenkins image pull policy              | `Always` if `imageTag` is `latest`, else `IfNotPresent`   |
| `image.pullSecrets`        | Specify image pull secrets             | `nil` (does not add image pull secrets to deployed pods)  |
| `jenkinsUser`              | User of the application                | `user`                                                    |
| `jenkinsPassword`          | Application password                   | _random 10 character alphanumeric string_                 |
| `jenkinsHome`              | Jenkins home directory                 | `/opt/bitnami/jenkins/jenkins_home`                       |
| `disableInitialization`    | Allows to disable the initial Bitnami configuration for Jenkins  | `no`                            |
| `javaOpts`                 | Customize JVM parameters               | `nil`                                                     |
| `service.type`                    | Kubernetes Service type                    | `LoadBalancer`                                          |
| `service.port`                    | Service HTTP port                  | `80`                                          |
| `service.httpsPort`                    | Service HTTPS port                   | `443`                                          |
| `service.nodePorts.http`                 | Kubernetes http node port                  | `""`                                                    |
| `service.nodePorts.https`                | Kubernetes https node port                 | `""`                                                    |
| `service.externalTrafficPolicy`   | Enable client source IP preservation       | `Cluster`                                               |
| `service.loadBalancerIP`   | LoadBalancer service IP address       | `""`                                               |
| `persistence.enabled`      | Enable persistence using PVC           | `true`                                                    |
| `persistence.storageClass` | PVC Storage Class for Jenkins volume   | `nil` (uses alpha storage class annotation)               |
| `persistence.accessMode`   | PVC Access Mode for Jenkins volume     | `ReadWriteOnce`                                           |
| `persistence.size`         | PVC Storage Request for Jenkins volume | `8Gi`                                                     |
| `resources`                | CPU/Memory resource requests/limits    | Memory: `512Mi`, CPU: `300m`                              |
| `podAnnotations`                | Pod annotations                                   | `{}`                                                       |
| `metrics.enabled`                          | Start a side-car Jenkins prometheus exporter                                                                           | `false`                                              |
| `metrics.image.registry`                   | Jenkins exporter image registry                                                                                  | `docker.io`                                          |
| `metrics.image.repository`                 | Jenkins exporter image name                                                                                      | `tolleiv/jenkins_exporter`                           |
| `metrics.image.tag`                        | Jenkins exporter image tag                                                                                       | `latest`                                            |
| `metrics.image.pullPolicy`                 | Image pull policy                                                                                              | `IfNotPresent`                                       |
| `metrics.image.pullSecrets`                | Specify docker-registry secret names as an array                                                               | `nil`                                                |
| `metrics.podAnnotations`                   | Additional annotations for Metrics exporter pod                                                                | `{prometheus.io/scrape: "true", prometheus.io/port: "9118"}`                                                   |
| `metrics.resources`                        | Exporter resource requests/limit                                                                               | Memory: `256Mi`, CPU: `100m`                         |


The above parameters map to the env variables defined in [bitnami/jenkins](http://github.com/bitnami/bitnami-docker-jenkins). For more information please refer to the [bitnami/jenkins](http://github.com/bitnami/bitnami-docker-jenkins) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set jenkinsUsername=admin,jenkinsPassword=password \
    bitnami/jenkins
```

The above command sets the Jenkins administrator account username and password to `admin` and `password` respectively.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml bitnami/jenkins
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Persistence

The [Bitnami Jenkins](https://github.com/bitnami/bitnami-docker-jenkins) image stores the Jenkins data and configurations at the `/bitnami/jenkins` path of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Configuration](#configuration) section to configure the PVC or to disable persistence.

## Upgrading

### To 1.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 1.0.0. The following example assumes that the release name is jenkins:

```console
$ kubectl patch deployment jenkins --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
```
