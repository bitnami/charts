# Node

[Node](https://www.nodejs.org) Event-driven I/O server-side JavaScript environment based on V8.

## TL;DR

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/node
```

## Introduction

This chart bootstraps a [Node](https://github.com/bitnami/bitnami-docker-node) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It clones and deploys a Node.js application from a Git repository. Optionally, you can set up an Ingress resource to access your application and provision an external database using the Kubernetes service catalog and the Open Service Broker for Azure.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This Helm chart has been tested on top of [Bitnami Kubernetes Production Runtime](https://kubeprod.io/) (BKPR). Deploy BKPR to get automated TLS certificates, logging and monitoring for your applications.

## Prerequisites

- Kubernetes 1.12+
- Helm 2.12+ or Helm 3.0-beta3+
- PV provisioner support in the underlying infrastructure
- ReadWriteMany volumes for deployment scaling

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/node
```

These commands deploy Node.js on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation. Also includes support for MariaDB chart out of the box.

Due that the Helm Chart clones the application on the /app volume while the container is initializing, a persistent volume is not required.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

The following table lists the configurable parameters of the Node chart and their default values.

| Parameter                               | Description                                                                 | Default                                                 |
|-----------------------------------------|-----------------------------------------------------------------------------|---------------------------------------------------------|
| `global.imageRegistry`                  | Global Docker image registry                                                | `nil`                                                   |
| `global.imagePullSecrets`               | Global Docker registry secret names as an array                             | `[]` (does not add image pull secrets to deployed pods) |
| `global.storageClass`                   | Global storage class for dynamic provisioning                               | `nil`                                                   |
| `image.registry`                        | NodeJS image registry                                                       | `docker.io`                                             |
| `image.repository`                      | NodeJS image name                                                           | `bitnami/node`                                          |
| `image.tag`                             | NodeJS image tag                                                            | `{TAG_NAME}`                                            |
| `image.pullPolicy`                      | NodeJS image pull policy                                                    | `IfNotPresent`                                          |
| `image.pullSecrets`                     | Specify docker-registry secret names as an array                            | `[]` (does not add image pull secrets to deployed pods) |
| `nameOverride`                          | String to partially override node.fullname template                         | `nil`                                                   |
| `fullnameOverride`                      | String to fully override node.fullname template                             | `nil`                                                   |
| `volumePermissions.enabled`             | Enable init container that changes volume permissions in the data directory | `false`                                                 |
| `volumePermissions.image.registry`      | Init container volume-permissions image registry                            | `docker.io`                                             |
| `volumePermissions.image.repository`    | Init container volume-permissions image name                                | `bitnami/minideb`                                       |
| `volumePermissions.image.tag`           | Init container volume-permissions image tag                                 | `buster`                                                |
| `volumePermissions.image.pullPolicy`    | Init container volume-permissions image pull policy                         | `Always`                                                |
| `volumePermissions.resources`           | Init container resource requests/limit                                      | `{}`                                                    |
| `git.registry`                          | Git image registry                                                          | `docker.io`                                             |
| `git.repository`                        | Git image name                                                              | `bitnami/git`                                           |
| `git.tag`                               | Git image tag                                                               | `{TAG_NAME}`                                            |
| `git.pullPolicy`                        | Git image pull policy                                                       | `IfNotPresent`                                          |
| `getAppFromExternalRepository`          | Whether to get app from external git repo or not                            | `true`                                                  |
| `repository`                            | Repo of the application                                                     | `https://github.com/bitnami/sample-mean.git`            |
| `revision`                              | Revision to checkout                                                        | `master`                                                |
| `replicas`                              | Number of replicas for the application                                      | `1`                                                     |
| `applicationPort`                       | Port where the application will be running                                  | `3000`                                                  |
| `extraEnv`                              | Any extra environment variables to be pass to the pods                      | `[]`                                                    |
| `affinity`                              | Map of node/pod affinities                                                  | `{}` (The value is evaluated as a template)             |
| `nodeSelector`                          | Node labels for pod assignment                                              | `{}` (The value is evaluated as a template)             |
| `tolerations`                           | Tolerations for pod assignment                                              | `[]` (The value is evaluated as a template)             |
| `securityContext.enabled`               | Enable security context                                                     | `true`                                                  |
| `securityContext.fsGroup`               | Group ID for the container                                                  | `1001`                                                  |
| `securityContext.runAsUser`             | User ID for the container                                                   | `1001`                                                  |
| `resources`                             | Resource requests and limits                                                | `{}`                                                    |
| `persistence.enabled`                   | Enable persistence using PVC                                                | `false`                                                 |
| `persistence.path`                      | Path to persisted directory                                                 | `/app/data`                                             |
| `persistence.accessMode`                | PVC Access Mode                                                             | `ReadWriteOnce`                                         |
| `persistence.size`                      | PVC Storage Request                                                         | `1Gi`                                                   |
| `service.type`                          | Kubernetes Service type                                                     | `ClusterIP`                                             |
| `service.port`                          | Kubernetes Service port                                                     | `80`                                                    |
| `service.annotations`                   | Annotations for the Service                                                 | {}                                                      |
| `service.loadBalancerIP`                | LoadBalancer IP if Service type is `LoadBalancer`                           | `nil`                                                   |
| `service.nodePort`                      | NodePort if Service type is `LoadBalancer` or `NodePort`                    | `nil`                                                   |
| `ingress.enabled`                       | Enable ingress controller resource                                          | `false`                                                 |
| `ingress.hosts[0].name`                 | Hostname to your Node installation                                          | `node.local`                                            |
| `ingress.hosts[0].path`                 | Path within the url structure                                               | `/`                                                     |
| `ingress.hosts[0].tls`                  | Utilize TLS backend in ingress                                              | `false`                                                 |
| `ingress.hosts[0].certManager`          | Add annotations for cert-manager                                            | `false`                                                 |
| `ingress.hosts[0].tlsSecret`            | TLS Secret (certificates)                                                   | `node.local-tls-secret`                                 |
| `ingress.hosts[0].annotations`          | Annotations for this host's ingress record                                  | `[]`                                                    |
| `ingress.secrets[0].name`               | TLS Secret Name                                                             | `nil`                                                   |
| `ingress.secrets[0].certificate`        | TLS Secret Certificate                                                      | `nil`                                                   |
| `ingress.secrets[0].key`                | TLS Secret Key                                                              | `nil`                                                   |
| `mongodb.install`                       | Wheter to install or not the MongoDB chart                                  | `true`                                                  |
| `externaldb.enabled`                    | Enables or disables external database (ignored if `mongodb.install=true`)   | `false`                                                 |
| `externaldb.secretName`                 | Secret containing existing database credentials                             | `nil`                                                   |
| `externaldb.type`                       | Type of database that defines the database secret mapping                   | `osba`                                                  |
| `externaldb.broker.serviceInstanceName` | The existing ServiceInstance to be used                                     | `nil`                                                   |

The above parameters map to the env variables defined in [bitnami/node](http://github.com/bitnami/bitnami-docker-node). For more information please refer to the [bitnami/node](http://github.com/bitnami/bitnami-docker-node) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install my-release \
  --set repository=https://github.com/jbianquetti-nami/simple-node-app.git,replicas=2 \
    bitnami/node
```

The above command clones the remote git repository to the `/app/` directory  of the container. Additionally it sets the number of `replicas` to `2`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install my-release -f values.yaml bitnami/node
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Change Node version

To modify the Node version used in this chart you can specify a [valid image tag](https://hub.docker.com/r/bitnami/node/tags/) using the `image.tag` parameter. For example, `image.tag=X.Y.Z`. This approach is also applicable to other images like exporters.

### Set up an Ingress controller

First install the nginx-ingress controller and then deploy the node helm chart with the following parameters:

```console
ingress.enabled=true
ingress.host=example.com
service.type=ClusterIP
```

### Configure TLS termination for your ingress controller

You must manually create a secret containing the certificate and key for your domain. Then ensure you deploy the Helm chart with the following ingress configuration:

```yaml
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

### Connect your application to an already existing database

1. Create a secret containing your database credentials (named `my-database-secret` as example), you can use the following options (set with `--from-literal`) to create the secret:

  ```console
  host=YOUR_DATABASE_HOST
  port=YOUR_DATABASE_PORT
  username=YOUR_DATABASE_USER
  password=YOUR_DATABASE_PASSWORD
  database=YOUR_DATABASE_NAME
  ```

  `YOUR_DATABASE_HOST`, `YOUR_DATABASE_PORT`, `YOUR_DATABASE_USER`, `YOUR_DATABASE_PASSWORD`, and `YOUR_DATABASE_NAME` are placeholders that must be replaced with correct values.

2. Deploy the node chart specifying the secret name

  ```console
  mongodb.install=false
  externaldb.enabled=true
  externaldb.secretName=my-database-secret
  ```

### Provision a database using the Open Service Broker for Azure

1. Install Service Catalog in your Kubernetes cluster following [this instructions](https://kubernetes.io/docs/tasks/service-catalog/install-service-catalog-using-helm/)
2. Install the Open Service Broker for Azure in your Kubernetes cluster following [this instructions](https://github.com/Azure/open-service-broker-azure/tree/master/contrib/k8s/charts/open-service-broker-azure)

> TIP: you may want to install the osba chart setting the `modules.minStability=EXPERIMENTAL` to see all the available services.
>
>            azure.subscriptionId=$AZURE_SUBSCRIPTION_ID
>            azure.tenantId=$AZURE_TENANT_ID
>            azure.clientId=$AZURE_CLIENT_ID
>            azure.clientSecret=$AZURE_CLIENT_SECRET
>            modules.minStability=EXPERIMENTAL

3. Create and deploy a ServiceInstance to provision a database server in Azure cloud.

  ```yaml
  apiVersion: servicecatalog.k8s.io/v1beta1
  kind: ServiceInstance
  metadata:
    name: azure-mongodb-instance
    labels:
      app: mongodb
  spec:
    clusterServiceClassExternalName: azure-cosmosdb-mongo-account
    clusterServicePlanExternalName: account
    parameters:
      location: YOUR_AZURE_LOCATION
      resourceGroup: mongodb-k8s-service-catalog
      ipFilters:
        allowedIPRanges:
        -  "0.0.0.0/0"
  ```

  Please update the `YOUR_AZURE_LOCATION` placeholder in the above example.

4. Deploy the helm chart:

    ```command
    mongodb.install=false
    externaldb.enabled=true
    externaldb.broker.serviceInstanceName=azure-mongodb-instance
    externaldb.ssl=true
    ```

Once the instance has been provisioned in Azure, a new secret should have been automatically created with the connection parameters for your application.

Deploying the helm chart enabling the Azure external database makes the following assumptions:

- You would want an Azure CosmosDB MongoDB database
- Your application uses DATABASE_HOST, DATABASE_PORT, DATABASE_USER, DATABASE_PASSWORD, and DATABASE_NAME environment variables to connect to the database.

You can read more about the kubernetes service catalog at https://github.com/kubernetes-bitnami/service-catalog

## Persistence

The [Bitnami Node](https://github.com/bitnami/bitnami-docker-node) image stores the Node application and configurations at the `/app`  path of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Parameters](#parameters) section to configure the PVC or to disable persistence.

### Adjust permissions of persistent volume mountpoint

As the image run as non-root by default, it is necessary to adjust the ownership of the persistent volume so that the container can write data into it.

By default, the chart is configured to use Kubernetes Security Context to automatically change the ownership of the volume. However, this feature does not work in all Kubernetes distributions.
As an alternative, this chart supports using an initContainer to change the ownership of the volume before mounting it in the final destination.

You can enable this initContainer by setting `volumePermissions.enabled` to `true`.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami’s Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 13.0.0

MongoDB subchart container images were updated to 4.4.x and it can affect compatibility with older versions of MongoDB.

- https://github.com/bitnami/charts/tree/master/bitnami/mongodb#to-900

### To 12.0.0

Backwards compatibility is not guaranteed since breaking changes were included in MongoDB subchart. More information in the link below:

- https://github.com/bitnami/charts/tree/master/bitnami/mongodb#to-800

### To 7.0.0

This release includes security contexts, so the containers in the chart are run as non-root. More information in [this link](https://github.com/bitnami/bitnami-docker-node#484-r1-6112-r1-7101-r1-and-830-r1).

### To 6.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 6.0.0. The following example assumes that the release name is node:

```console
$ kubectl patch deployment node --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
$ kubectl patch deployment node-mongodb --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
```
