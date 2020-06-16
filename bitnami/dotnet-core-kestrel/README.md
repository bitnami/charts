# dotnet-core-kestrel

[dotnet-core-kestrel](https://docs.microsoft.com/en-us/aspnet/core/fundamentals/servers/kestrel) Kestrel is a cross-platform web server for ASP.NET Core applications.

## TL;DR;

```console
  helm repo add bitnami https://charts.bitnami.com/bitnami
  helm install my-release bitnami/dotnet-core-kestrel
```

## Introduction

Bitnami charts for Helm are carefully engineered, actively maintained and are the quickest and easiest way to deploy containers on a Kubernetes cluster that are ready to handle production workloads.

This chart bootstraps a [dotnet-core-kestrel](https://github.com/bitnami/dotnet-core-kestrel) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This Helm chart has been tested on top of [Bitnami Kubernetes Production Runtime](https://kubeprod.io/) (BKPR). Deploy BKPR to get automated TLS certificates, logging and monitoring for your applications.

## Prerequisites

- Kubernetes 1.12+
- Helm 2.12+ or Helm 3.0-beta3+

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/dotnet-core-kestrel
```

These commands deploy dotnet core applicatoin for kestrel server on the Kubernetes cluster in the default configuration.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

The following tables lists the configurable parameters of the dotnet-core-kestrel chart and their default values.

| Parameter                                  | Description                                                                                  | Default                                                      |
|--------------------------------------------|----------------------------------------------------------------------------------------------|--------------------------------------------------------------|
| `global.imageRegistry`                     | Global Docker image registry                                                                 | `nil`                                                        |
| `global.imagePullSecrets`                  | Global Docker registry secret names as an array                                              | `[]` (does not add image pull secrets to deployed pods)      |
| `image.registry`                           | dotnet-core-kestrel image registry                                                           | `example.io`                                                 |
| `image.repository`                         | dotnet-core-kestrel Image name                                                               | `example/dotnet-core-kestrel`                                |
| `image.tag`                                | dotnet-core-kestrel Image tag                                                                | `{TAG_NAME}`                                                 |
| `image.pullPolicy`                         | dotnet-core-kestrel image pull policy                                                        | `IfNotPresent`                                               |
| `image.pullSecrets`                        | Specify docker-registry secret names as an array                                             | `[]` (does not add image pull secrets to deployed pods)      |
| `nameOverride`                             | String to partially override nginx.fullname template                                         | `nil`                                                        |
| `fullnameOverride`                         | String to fully override nginx.fullname template                                             | `nil`                                                        |
| `replicaCount`                             | Number of replicas to deploy                                                                 | `1`                                                          |
| `containerPort`                            | Deployment Container Port                                                                    | `8080`                                                       |
| `nodeSelector`                             | Node labels for pod assignment                                                               | `{}` (The value is evaluated as a template)                  |
| `resources`                                | Resource requests/limit                                                                      | `{}`                                                         |
| `service.type`                             | Kubernetes Service type                                                                      | `LoadBalancer`                                               |
| `service.port`                             | Service HTTP port                                                                            | `80`                                                         |
| `service.httpsPort`                        | Service HTTPS port                                                                           | `443`                                                        |
| `service.nodePorts.http`                   | Kubernetes http node port                                                                    | `""`                                                         |
| `service.nodePorts.https`                  | Kubernetes https node port                                                                   | `""`                                                         |
| `service.externalTrafficPolicy`            | Enable client source IP preservation                                                         | `Cluster`                                                    |
| `appIngress.enabled`                       | Enable application ingress controller resource                                               | `false`                                                      |
| `appIngress.certManager`                   | Add annotations for cert-manager                                                             | `false`                                                      |
| `appIngress.selectors`                     | Ingress selectors for labelSelector option                                                   | `[]`                                                         |
| `appIngress.annotations`                   | Ingress annotations                                                                          | `[]`                                                         |
| `appIngress.hosts[0].name`                 | Hostname to your NGINX installation                                                          | `nginx.local`                                                |
| `appIngress.hosts[0].path`                 | Path within the url structure                                                                | `/`                                                          |
| `appIngress.tls[0].hosts[0]`               | TLS hosts                                                                                    | `nginx.local`                                                |
| `appIngress.tls[0].secretName`             | TLS Secret (certificates)                                                                    | `nginx.local-tls`                                            |
| `appIngress.secrets[0].name`               | TLS Secret Name                                                                              | `nil`                                                        |
| `appIngress.secrets[0].certificate`        | TLS Secret Certificate                                                                       | `nil`                                                        |
| `appIngress.secrets[0].key`                | TLS Secret Key                                                                               | `nil`                                                        |
| `healthIngress.enabled`                    | Enable health ingress controller resource                                                    | `false`                                                      |
| `healthIngress.certManager`                | Add annotations for cert-manager                                                             | `false`                                                      |
| `healthIngress.selectors`                  | Health Ingress selectors for labelSelector option                                            | `[]`                                                         |
| `healthIngress.annotations`                | Health Ingress annotations                                                                   | `[]`                                                         |
| `healthIngress.hosts[0].name`              | Hostname to your NGINX installation                                                          | `nginx.local`                                                |
| `healthIngress.hosts[0].path`              | Path within the url structure                                                                | `/`                                                          |
| `healthIngress.tls[0].hosts[0]`            | TLS hosts                                                                                    | `nginx.local`                                                |
| `healthIngress.tls[0].secretName`          | TLS Secret (certificates)                                                                    | `nginx.local-tls`                                            |
| `healthIngress.secrets[0].name`            | TLS Secret Name                                                                              | `nil`                                                        |
| `healthIngress.secrets[0].certificate`     | TLS Secret Certificate                                                                       | `nil`                                                        |
| `healthIngress.secrets[0].key`             | TLS Secret Key                                                                               | `nil`                                                        |
| `extraVolumes`                             | Array to add extra volumes (evaluated as a template)                                         | `[]`                                                         |
| `extraVolumeMounts`                        | Array to add extra mounts (normally used with extraVolumes, evaluated as a template)         | `[]`                                                         |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install my-release \
  --set imagePullPolicy=Always \
    bitnami/dotnet-core-kestrel
```

The above command sets the `imagePullPolicy` to `Always`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install my-release -f values.yaml bitnami/dotnet-core-kestrel
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.
