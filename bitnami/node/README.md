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
- Helm 3.1.0
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

### Global parameters

| Name                      | Description                                     | Value |
| ------------------------- | ----------------------------------------------- | ----- |
| `global.imageRegistry`    | Global Docker image registry                    | `""`  |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]`  |
| `global.storageClass`     | Global StorageClass for Persistent Volume(s)    | `""`  |


### Common parameters

| Name                | Description                                                                          | Value |
| ------------------- | ------------------------------------------------------------------------------------ | ----- |
| `kubeVersion`       | Force target Kubernetes version (using Helm capabilities if not set)                 | `""`  |
| `nameOverride`      | String to partially override node.fullname template (will maintain the release name) | `""`  |
| `fullnameOverride`  | String to fully override node.fullname template                                      | `""`  |
| `commonLabels`      | Add labels to all the deployed resources                                             | `{}`  |
| `commonAnnotations` | Add annotations to all the deployed resources                                        | `{}`  |


### Node parameters

| Name                                    | Description                                                                                                          | Value             |
| --------------------------------------- | -------------------------------------------------------------------------------------------------------------------- | ----------------- |
| `command`                               | Override default container command (useful when using custom images)                                                 | `[]`              |
| `args`                                  | Override default container args (useful when using custom images)                                                    | `[]`              |
| `hostAliases`                           | Deployment pod host aliases                                                                                          | `[]`              |
| `extraEnvVars`                          | Extra environment variables to be set on Node container                                                              | `[]`              |
| `extraEnvVarsCM`                        | Name of existing ConfigMap containing extra environment variables                                                    | `""`              |
| `extraEnvVarsSecret`                    | Name of existing Secret containing extra environment variables                                                       | `""`              |
| `mongodb.enabled`                       | Whether to install or not the MongoDB&reg; chart                                                                     | `true`            |
| `mongodb.auth.enabled`                  | Whether to enable auth or not for the MongoDB&reg; chart                                                             | `true`            |
| `mongodb.auth.rootPassword`             | MongoDB&reg; admin password                                                                                          | `""`              |
| `mongodb.auth.username`                 | MongoDB&reg; custom user                                                                                             | `user`            |
| `mongodb.auth.database`                 | MongoDB&reg; custom database                                                                                         | `test_db`         |
| `mongodb.auth.password`                 | MongoDB&reg; custom password                                                                                         | `secret_password` |
| `externaldb.enabled`                    | Enables or disables external database (ignored if `mongodb.enabled=true`)                                            | `false`           |
| `externaldb.ssl`                        | Set to true if your external database has ssl enabled                                                                | `false`           |
| `externaldb.secretName`                 | Secret containing existing database credentials                                                                      | `""`              |
| `externaldb.type`                       | Only if using Kubernetes Service Catalog you can specify the kind of broker used. Available options are osba|gce|aws | `osba`            |
| `externaldb.broker.serviceInstanceName` | If you provide the serviceInstanceName, the chart will create a ServiceBinding for that ServiceInstance              | `""`              |


### Node deployment parameters

| Name                                    | Description                                                                               | Value                  |
| --------------------------------------- | ----------------------------------------------------------------------------------------- | ---------------------- |
| `image.registry`                        | NodeJS image registry                                                                     | `docker.io`            |
| `image.repository`                      | NodeJS image repository                                                                   | `bitnami/node`         |
| `image.tag`                             | NodeJS image tag (immutable tags are recommended)                                         | `14.17.3-debian-10-r6` |
| `image.pullPolicy`                      | NodeJS image pull policy                                                                  | `IfNotPresent`         |
| `image.pullSecrets`                     | Specify docker-registry secret names as an array                                          | `[]`                   |
| `replicaCount`                          | Specify the number of replicas for the application                                        | `1`                    |
| `applicationPort`                       | Specify the port where your application will be running                                   | `3000`                 |
| `podAffinityPreset`                     | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`       | `""`                   |
| `podAntiAffinityPreset`                 | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`  | `soft`                 |
| `nodeAffinityPreset.type`               | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard` | `""`                   |
| `nodeAffinityPreset.key`                | Node label key to match Ignored if `affinity` is set.                                     | `""`                   |
| `nodeAffinityPreset.values`             | Node label values to match. Ignored if `affinity` is set.                                 | `[]`                   |
| `affinity`                              | Affinity for pod assignment. Evaluated as a template.                                     | `{}`                   |
| `nodeSelector`                          | Node labels for pod assignment. Evaluated as a template.                                  | `{}`                   |
| `tolerations`                           | Tolerations for pod assignment. Evaluated as a template.                                  | `{}`                   |
| `podAnnotations`                        | Additional pod annotations                                                                | `{}`                   |
| `podLabels`                             | Additional labels for Node pods                                                           | `{}`                   |
| `extraDeploy`                           | Array of extra objects to deploy with the release (evaluated as a template)               | `[]`                   |
| `livenessProbe.enabled`                 | Enable livenessProbe                                                                      | `true`                 |
| `livenessProbe.path`                    | Request path for livenessProbe                                                            | `/`                    |
| `livenessProbe.initialDelaySeconds`     | Initial delay seconds for livenessProbe                                                   | `60`                   |
| `livenessProbe.periodSeconds`           | Period seconds for livenessProbe                                                          | `10`                   |
| `livenessProbe.timeoutSeconds`          | Timeout seconds for livenessProbe                                                         | `5`                    |
| `livenessProbe.failureThreshold`        | Failure threshold for livenessProbe                                                       | `6`                    |
| `livenessProbe.successThreshold`        | Success threshold for livenessProbe                                                       | `1`                    |
| `readinessProbe.enabled`                | Enable readinessProbe                                                                     | `true`                 |
| `readinessProbe.path`                   | Request path for readinessProbe                                                           | `/`                    |
| `readinessProbe.initialDelaySeconds`    | Initial delay seconds for readinessProbe                                                  | `10`                   |
| `readinessProbe.periodSeconds`          | Period seconds for readinessProbe                                                         | `5`                    |
| `readinessProbe.timeoutSeconds`         | Timeout seconds for readinessProbe                                                        | `3`                    |
| `readinessProbe.failureThreshold`       | Failure threshold for readinessProbe                                                      | `3`                    |
| `readinessProbe.successThreshold`       | Success threshold for readinessProbe                                                      | `1`                    |
| `customLivenessProbe`                   | Override default liveness probe                                                           | `{}`                   |
| `customReadinessProbe`                  | Override default readiness probe                                                          | `{}`                   |
| `priorityClassName`                     | Node priorityClassName                                                                    | `""`                   |
| `lifecycleHooks`                        | lifecycleHooks for the Node container to automate configuration before or after startup.  | `{}`                   |
| `sidecars`                              | Add sidecars to the Node pods                                                             | `[]`                   |
| `initContainers`                        | Add init containers to the Node pods                                                      | `[]`                   |
| `extraVolumes`                          | Extra volumes to add to the deployment                                                    | `[]`                   |
| `extraVolumeMounts`                     | Extra volume mounts to add to the container                                               | `[]`                   |
| `containerSecurityContext.enabled`      | Node Container securityContext                                                            | `true`                 |
| `containerSecurityContext.runAsUser`    | User ID for the Node container                                                            | `1001`                 |
| `containerSecurityContext.runAsNonRoot` | Set container's Security Context runAsNonRoot                                             | `true`                 |
| `podSecurityContext.enabled`            | Enable security context for Node pods                                                     | `true`                 |
| `podSecurityContext.fsGroup`            | Group ID for the volumes of the pod                                                       | `1001`                 |
| `resources.limits`                      | The resources limits for the Node container                                               | `{}`                   |
| `resources.requests`                    | The requested resources for the Node container                                            | `{}`                   |


### Node application parameters

| Name                           | Description                                         | Value                                        |
| ------------------------------ | --------------------------------------------------- | -------------------------------------------- |
| `git.image.registry`           | Git image registry                                  | `docker.io`                                  |
| `git.image.repository`         | Git image repository                                | `bitnami/git`                                |
| `git.image.tag`                | Git image tag (immutable tags are recommended)      | `2.32.0-debian-10-r30`                       |
| `git.image.pullPolicy`         | Git image pull policy                               | `IfNotPresent`                               |
| `git.image.pullSecrets`        | Specify docker-registry secret names as an array    | `[]`                                         |
| `git.extraVolumeMounts`        | Add extra volume mounts for the Git container       | `[]`                                         |
| `getAppFromExternalRepository` | Enable to download app from external git repository | `true`                                       |
| `repository`                   | Git repository http/https url                       | `https://github.com/bitnami/sample-mean.git` |
| `revision`                     | Git repository revision to checkout                 | `master`                                     |


### Volume permissions parameters

| Name                                   | Description                                                                  | Value                   |
| -------------------------------------- | ---------------------------------------------------------------------------- | ----------------------- |
| `volumePermissions.enabled`            | Enable init container that changes volume permissions in the data directory  | `false`                 |
| `volumePermissions.image.registry`     | Init container volume-permissions image registry                             | `docker.io`             |
| `volumePermissions.image.repository`   | Init container volume-permissions image repository                           | `bitnami/bitnami-shell` |
| `volumePermissions.image.tag`          | Init container volume-permissions image tag (immutable tags are recommended) | `10-debian-10-r131`     |
| `volumePermissions.image.pullPolicy`   | Init container volume-permissions image pull policy                          | `Always`                |
| `volumePermissions.image.pullSecrets`  | Specify docker-registry secret names as an array                             | `[]`                    |
| `volumePermissions.resources.limits`   | The resources limits for the container                                       | `{}`                    |
| `volumePermissions.resources.requests` | The requested resources for the container                                    | `{}`                    |


### Persistence parameters

| Name                       | Description                     | Value           |
| -------------------------- | ------------------------------- | --------------- |
| `persistence.enabled`      | Enable persistence using PVC    | `false`         |
| `persistence.path`         | Path to persisted directory     | `/app/data`     |
| `persistence.storageClass` | Persistent Volume Storage Class | `""`            |
| `persistence.accessMode`   | PVC Access Mode                 | `ReadWriteOnce` |
| `persistence.size`         | PVC Storage Request             | `1Gi`           |


### Traffic exposure parameters

| Name                               | Description                                                                                                | Value                    |
| ---------------------------------- | ---------------------------------------------------------------------------------------------------------- | ------------------------ |
| `service.type`                     | Kubernetes Service type                                                                                    | `ClusterIP`              |
| `service.port`                     | Kubernetes Service port                                                                                    | `80`                     |
| `service.clusterIP`                | Service Cluster IP                                                                                         | `""`                     |
| `service.sessionAffinity`          | Control where client requests go, to the same pod or round-robin                                           | `None`                   |
| `service.nodePort`                 | NodePort if Service type is `LoadBalancer` or `NodePort`                                                   | `""`                     |
| `service.loadBalancerIP`           | LoadBalancer IP if Service type is `LoadBalancer`                                                          | `""`                     |
| `service.loadBalancerSourceRanges` | In order to limit which client IP's can access the Network Load Balancer, specify loadBalancerSourceRanges | `[]`                     |
| `service.annotations`              | Annotations for the Service                                                                                | `{}`                     |
| `ingress.enabled`                  | Set to true to enable ingress record generation                                                            | `false`                  |
| `ingress.certManager`              | Set this to true in order to add the corresponding annotations for cert-manager                            | `false`                  |
| `ingress.pathType`                 | Ingress path type                                                                                          | `ImplementationSpecific` |
| `ingress.apiVersion`               | Override API Version (automatically detected if not set)                                                   | `""`                     |
| `ingress.hostname`                 | When the ingress is enabled, a host pointing to this will be created                                       | `node.local`             |
| `ingress.path`                     | The Path to Node.js. You may need to set this to '/*' in order to use this with ALB ingress controllers.   | `ImplementationSpecific` |
| `ingress.annotations`              | Ingress annotations                                                                                        | `{}`                     |
| `ingress.tls`                      | Enable TLS configuration for the hostname defined at ingress.hostname parameter                            | `false`                  |
| `ingress.extraHosts`               | The list of additional hostnames to be covered with this ingress record.                                   | `[]`                     |
| `ingress.extraPaths`               | Any additional arbitrary paths that may need to be added to the ingress under the main host.               | `[]`                     |
| `ingress.extraTls`                 | The tls configuration for additional hostnames to be covered with this ingress record.                     | `[]`                     |
| `ingress.secrets`                  | If you're providing your own certificates, please use this to add the certificates as secrets              | `[]`                     |


The above parameters map to the env variables defined in [bitnami/node](http://github.com/bitnami/bitnami-docker-node). For more information please refer to the [bitnami/node](http://github.com/bitnami/bitnami-docker-node) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install my-release \
  --set repository=https://github.com/jbianquetti-nami/simple-node-app.git,replicaCount=2 \
    bitnami/node
```

The above command clones the remote git repository to the `/app/` directory  of the container. Additionally it sets the number of `replicaCount` to `2`.

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
  mongodb.enabled=false
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
    mongodb.enabled=false
    externaldb.enabled=true
    externaldb.broker.serviceInstanceName=azure-mongodb-instance
    externaldb.ssl=true
    ```

Once the instance has been provisioned in Azure, a new secret should have been automatically created with the connection parameters for your application.

Deploying the helm chart enabling the Azure external database makes the following assumptions:

- You would want an Azure CosmosDB MongoDB&reg; database
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

### To 15.0.0

This version standardizes the way of defining Ingress rules. When configuring a single hostname for the Ingress rule, set the `ingress.hostname` value. When defining more than one, set the `ingress.extraHosts` array. Apart from this case, no issues are expected to appear when upgrading.

### To 14.0.0

[On November 13, 2020, Helm v2 support was formally finished](https://github.com/helm/charts#status-of-the-project), this major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

**What changes were introduced in this major version?**

- Previous versions of this Helm Chart use `apiVersion: v1` (installable by both Helm 2 and 3), this Helm Chart was updated to `apiVersion: v2` (installable by Helm 3 only). [Here](https://helm.sh/docs/topics/charts/#the-apiversion-field) you can find more information about the `apiVersion` field.
- Move dependency information from the *requirements.yaml* to the *Chart.yaml*
- After running `helm dependency update`, a *Chart.lock* file is generated containing the same structure used in the previous *requirements.lock*
- The different fields present in the *Chart.yaml* file has been ordered alphabetically in a homogeneous way for all the Bitnami Helm Charts
- MongoDB&reg; dependency version was bumped to a new major version `10.X.X`. Check [MongoDB&reg; Upgrading Notes](https://github.com/bitnami/charts/tree/master/bitnami/mongodb#to-1000) for more information.
- Inclusion of the`bitnami/common` library chart and standardization to include common features found on other charts.
- `securityContext.*` is deprecated in favor of `podSecurityContext` and `containerSecurityContext`.
- `replicas` is deprecated in favor of `replicaCount`.

**Considerations when upgrading to this version**

- If you want to upgrade to this version from a previous one installed with Helm v3, you shouldn't face any issues
- If you want to upgrade to this version using Helm v2, this scenario is not supported as this version doesn't support Helm v2 anymore
- If you installed the previous version with Helm v2 and wants to upgrade to this version with Helm v3, please refer to the [official Helm documentation](https://helm.sh/docs/topics/v2_v3_migration/#migration-use-cases) about migrating from Helm v2 to v3

**Useful links**

- https://docs.bitnami.com/tutorials/resolve-helm2-helm3-post-migration-issues/
- https://helm.sh/docs/topics/v2_v3_migration/
- https://helm.sh/blog/migrate-from-helm-v2-to-helm-v3/

### To 13.0.0

MongoDB&reg; subchart container images were updated to 4.4.x and it can affect compatibility with older versions of MongoDB&reg;.

- https://github.com/bitnami/charts/tree/master/bitnami/mongodb#to-900

### To 12.0.0

Backwards compatibility is not guaranteed since breaking changes were included in MongoDB&reg; subchart. More information in the link below:

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
