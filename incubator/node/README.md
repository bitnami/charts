# Node

[Node](https://www.nodejs.org) Event-driven I/O server-side JavaScript environment based on V8

## TL;DR;

```console
$ helm repo add bitnami-incubator https://charts.bitnami.com/incubator
$ helm install bitnami-incubator/node
```
## Introduction

This chart bootstraps a [Node](https://github.com/bitnami/bitnami-docker-node) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It clones and deploys a Node.js application from a git repository. Optionally you can set un an Ingress resource to access your application and provision an external database using the k8s service catalog and the Open Service Broker for Azure.

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release bitnami-incubator/node
```

The command deploys Node.js on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation. Also includes support for MariaDB chart out of the box.

Due that the Helm Chart clones the application on the /app volume while the container is initializing, a persistent volume is not required.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the Node chart and their default values.

|              Parameter               |            Description                                    |                        Default                            |
|--------------------------------------|-----------------------------------------------------------|-----------------------------------------------------------|
| `image`                              | Node image                                                | `bitnami/node:{VERSION}`                                  |
| `devImage`                           | Image used for initContainers                             | `bitnami/node:{VERSION}`                                  |
| `imagePullPolicy`                    | Image pull policy                                         | `IfNotPresent`                                            |
| `repository`                         | Repo of the application                                   | `https://github.com/jbianquetti-nami/simple-node-app.git` |
| `revision`                           | Revision  to checkout                                     | `master`                                                  |
| `replicas`                           | Number of replicas for the application                    | `1`                                                       |
| `applicationPort`                    | Port where the application will be running                | `3000`                                                    |
| `serviceType`                        | Kubernetes Service type                                   | `LoadBalancer`                                            |
| `persistence.enabled`                | Enable persistence using PVC                              | `false`                                                   |
| `persistence.path`                   | Path to persisted directory                               | `/app/data`                                               |
| `persistence.accessMode`             | PVC Access Mode                                           | `ReadWriteOnce`                                           |
| `persistence.size`                   | PVC Storage Request                                       | `1Gi`                                                     |
| `externalDatabase.azure.enabled`     | Create a database on Azure cloud with k8s service catalog | `false`                                                   |
| `externalDatabase.azure.location`    | The Azure region in which to deploy the database          | `eastus`                                                  |
| `externalDatabase.azure.servicePlan` | The plan to request for the Azure database                | `mongo-db`                                                |
| `ingress.enabled`                    | Enable ingress creation                                   | `false`                                                   |
| `ingress.path`                       | Ingress path                                              | `/`                                                       |
| `ingress.host`                       | Ingress host                                              | `example.local`                                           |
| `ingress.tls`                        | TLS configuration for the ingress                         | `{}`                                                      |

The above parameters map to the env variables defined in [bitnami/node](http://github.com/bitnami/bitnami-docker-node). For more information please refer to the [bitnami/node](http://github.com/bitnami/bitnami-docker-node) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set repository=https://github.com/jbianquetti-nami/simple-node-app.git,replicas=2 \
    bitnami-incubator/node
```

The above command clones the remote git  repository to the `/app/` directory  of the container. Additionally it sets the number or `replicas` to `2`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml incubator/node
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Persistence

The [Bitnami Node](https://github.com/bitnami/bitnami-docker-node) image stores the Node application and configurations at the `/app`  path of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Configuration](#configuration) section to configure the PVC or to disable persistence.

## Set an Ingress

First install the nginx-ingress controller via helm:

```
$ helm install stable/nginx-ingress
```

Now deploy the node helm chart:

```
$ helm install --name my-release bitnami-incubator/node --set ingress.enabled=true,ingress.host=example.com,serviceType=ClusterIP
```

### Configure TLS termination for your ingress controller

You must manually create a secret containing the certificate and key for your domain. You can do it with this command:

```
$ kubectl create secret tls my-tls-secret --cert=path/to/file.cert --key=path/to/file.key
```

Then ensure you deploy the Helm chart with the following ingress configuration:

```
ingress:
  enabled: false
  path: /
  host: example.com
  annotations:
    kubernetes.io/ingress.class: nginx
  tls:
      hosts:
        - example.com
```

## Provision a database using the Open Source Broker for Azure

1. Install Service Catalog in your Kubernetes cluster following [this instructions](https://kubernetes.io/docs/tasks/service-catalog/install-service-catalog-using-helm/)
2. Install the Open Service Broker for Azure in your Kubernetes cluster following [this instructions](https://github.com/Azure/helm-charts/tree/master/open-service-broker-azure)
3. Deploy the helm chart:

    ```
    $ helm install --name node-app --set externalDatabase.azure.enabled=true bitnami-incubator/node
    ```

Setting `externalDatabase.azure.enabled` to `true` makes the chart to create a `ServiceInstance` and a `ServiceBinding` kubernetes resources.
Once the instance has been provisioned in Azure, a new secret should have been automatically created with the connection parameters for your application.

Deploy the helm chart enabling the Azure external database makes the following assumptions:
  - You would want an Azure Cosmos MongoDB database
  - Your application uses DATABASE_HOST, DATABASE_PORT, DATABASE_USER and DATABASE_PASSWORD environment variables to connect to the database.

You can read more about the kubernetes service catalog at https://github.com/kubernetes-incubator/service-catalog 