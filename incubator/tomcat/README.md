# Tomcat

[Apache Tomcat](http://tomcat.apache.org/), often referred to as Tomcat, is an open-source web server and servlet container developed by the Apache Software Foundation. Tomcat implements several Java EE specifications including Java Servlet, JavaServer Pages, Java EL, and WebSocket, and provides a "pure Java" HTTP web server environment for Java code to run in.

## TL;DR;

```console
$ helm install incubator/tomcat
```

## Introduction

This chart bootstraps a [Tomcat](https://github.com/bitnami/bitnami-docker-tomcat) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release incubator/tomcat
```

The command deploys Tomcat on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the Tomcat chart and their default values.

|           Parameter           |                 Description                  |                   Default                   |
|-------------------------------|----------------------------------------------|---------------------------------------------|
| `image`                       | Tomcat image                                 | `bitnami/tomcat:{VERSION}`                  |
| `imagePullPolicy`             | Image pull policy                            | `IfNotPresent`                              |
| `tomcatUsername`              | Tomcat admin user                            | `user`                                      |
| `tomcatPassword`              | Tomcat admin password                        | _random 10 character alphanumeric string_   |
| `tomcatAllowRemoteManagement` | Enable remote access to management interface | `0` (disabled)                              |
| `serviceType`                 | Kubernetes Service type                      | `LoadBalancer`                              |
| `persistence.enabled`         | Enable persistence using PVC                 | `true`                                      |
| `persistence.storageClass`    | PVC Storage Class for Tomcat volume          | `nil` (uses alpha storage class annotation) |
| `persistence.accessMode`      | PVC Access Mode for Tomcat volume            | `ReadWriteOnce`                             |
| `persistence.size`            | PVC Storage Request for Tomcat volume        | `8Gi`                                       |
| `resources`                   | CPU/Memory resource requests/limits          | Memory: `512Mi`, CPU: `300m`                |

The above parameters map to the env variables defined in [bitnami/tomcat](http://github.com/bitnami/bitnami-docker-tomcat). For more information please refer to the [bitnami/tomcat](http://github.com/bitnami/bitnami-docker-tomcat) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set tomcatUser=manager,tomcatPassword=password incubator/tomcat
```

The above command sets the Tomcat management username and password to `manager` and `password` respectively.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml incubator/tomcat
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Persistence

The [Bitnami Tomcat](https://github.com/bitnami/bitnami-docker-tomcat) image stores the Tomcat data and configurations at the `/bitnami/tomcat` path of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Configuration](#configuration) section to configure the PVC or to disable persistence.
