# Ghost

[Ghost](https://ghost.org/) is an open source publishing platform designed to create blogs, magazines, and news sites. It includes a simple markdown editor with preview, theming, and SEO built-in to simplify editing.

## TL;DR

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/ghost
```

## Introduction

This chart bootstraps a [Ghost](https://github.com/bitnami/bitnami-docker-ghost) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages the [Bitnami MariaDB chart](https://github.com/kubernetes/charts/tree/master/bitnami/mariadb) which is required for bootstrapping a MariaDB deployment for the database requirements of the Ghost application.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This chart has been tested to work with NGINX Ingress, cert-manager, fluentd and Prometheus on top of the [BKPR](https://kubeprod.io/).

## Prerequisites

- Kubernetes 1.12+
- Helm 3.1.0
- PV provisioner support in the underlying infrastructure
- ReadWriteMany volumes for deployment scaling

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install my-release bitnami/ghost
```

The command deploys Ghost on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

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

| Name                | Description                                        | Value           |
| ------------------- | -------------------------------------------------- | --------------- |
| `kubeVersion`       | Override Kubernetes version                        | `""`            |
| `nameOverride`      | String to partially override common.names.fullname | `""`            |
| `fullnameOverride`  | String to fully override common.names.fullname     | `""`            |
| `commonLabels`      | Labels to add to all deployed objects              | `{}`            |
| `commonAnnotations` | Annotations to add to all deployed objects         | `{}`            |
| `clusterDomain`     | Kubernetes cluster domain name                     | `cluster.local` |
| `extraDeploy`       | Array of extra objects to deploy with the release  | `[]`            |


### Ghost Image parameters

| Name                | Description                                      | Value                 |
| ------------------- | ------------------------------------------------ | --------------------- |
| `image.registry`    | Ghost image registry                             | `docker.io`           |
| `image.repository`  | Ghost image repository                           | `bitnami/ghost`       |
| `image.tag`         | Ghost image tag (immutable tags are recommended) | `4.18.0-debian-10-r0` |
| `image.pullPolicy`  | Ghost image pull policy                          | `IfNotPresent`        |
| `image.pullSecrets` | Ghost image pull secrets                         | `[]`                  |
| `image.debug`       | Enable image debug mode                          | `false`               |


### Ghost Configuration parameters

| Name                 | Description                                                          | Value              |
| -------------------- | -------------------------------------------------------------------- | ------------------ |
| `ghostUsername`      | Ghost user name                                                      | `user`             |
| `ghostPassword`      | Ghost user password                                                  | `""`               |
| `existingSecret`     | Name of existing secret containing Ghost credentials                 | `""`               |
| `ghostEmail`         | Ghost user email                                                     | `user@example.com` |
| `ghostBlogTitle`     | Ghost Blog title                                                     | `User's Blog`      |
| `ghostHost`          | Ghost host to create application URLs                                | `""`               |
| `ghostPath`          | URL sub path where to server the Ghost application                   | `/`                |
| `ghostEnableHttps`   | Configure Ghost to build application URLs using https                | `false`            |
| `smtpHost`           | SMTP server host                                                     | `""`               |
| `smtpPort`           | SMTP server port                                                     | `""`               |
| `smtpUser`           | SMTP username                                                        | `""`               |
| `smtpPassword`       | SMTP user password                                                   | `""`               |
| `smtpService`        | SMTP service                                                         | `""`               |
| `smtpExistingSecret` | The name of an existing secret with SMTP credentials                 | `""`               |
| `allowEmptyPassword` | Allow the container to be started with blank passwords               | `true`             |
| `ghostSkipInstall`   | Skip performing the initial bootstrapping for Ghost                  | `false`            |
| `command`            | Override default container command (useful when using custom images) | `[]`               |
| `args`               | Override default container args (useful when using custom images)    | `[]`               |
| `extraEnvVars`       | Array with extra environment variables to add to the Ghost container | `[]`               |
| `extraEnvVarsCM`     | Name of existing ConfigMap containing extra env vars                 | `""`               |
| `extraEnvVarsSecret` | Name of existing Secret containing extra env vars                    | `""`               |


### Ghost deployment parameters

| Name                                    | Description                                                                               | Value           |
| --------------------------------------- | ----------------------------------------------------------------------------------------- | --------------- |
| `replicaCount`                          | Number of Ghost replicas to deploy                                                        | `1`             |
| `updateStrategy.type`                   | Ghost deployment strategy type                                                            | `RollingUpdate` |
| `priorityClassName`                     | Ghost pod priority class name                                                             | `""`            |
| `schedulerName`                         | Name of the k8s scheduler (other than default)                                            | `""`            |
| `topologySpreadConstraints`             | Topology Spread Constraints for pod assignment                                            | `[]`            |
| `hostAliases`                           | Ghost pod host aliases                                                                    | `[]`            |
| `extraVolumes`                          | Optionally specify extra list of additional volumes for Ghost pods                        | `[]`            |
| `extraVolumeMounts`                     | Optionally specify extra list of additional volumeMounts for Ghost container(s)           | `[]`            |
| `sidecars`                              | Add additional sidecar containers to the Ghost pod                                        | `[]`            |
| `initContainers`                        | Add additional init containers to the Ghost pods                                          | `[]`            |
| `lifecycleHooks`                        | Add lifecycle hooks to the Ghost deployment                                               | `{}`            |
| `podLabels`                             | Extra labels for Ghost pods                                                               | `{}`            |
| `podAnnotations`                        | Annotations for Ghost pods                                                                | `{}`            |
| `podAffinityPreset`                     | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`       | `""`            |
| `podAntiAffinityPreset`                 | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`  | `soft`          |
| `nodeAffinityPreset.type`               | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard` | `""`            |
| `nodeAffinityPreset.key`                | Node label key to match. Ignored if `affinity` is set                                     | `""`            |
| `nodeAffinityPreset.values`             | Node label values to match. Ignored if `affinity` is set                                  | `[]`            |
| `affinity`                              | Affinity for pod assignment                                                               | `{}`            |
| `nodeSelector`                          | Node labels for pod assignment                                                            | `{}`            |
| `tolerations`                           | Tolerations for pod assignment                                                            | `{}`            |
| `resources.limits`                      | The resources limits for the Ghost container                                              | `{}`            |
| `resources.requests`                    | The requested resources for the Ghost container                                           | `{}`            |
| `containerPorts.http`                   | Ghost HTTP container port                                                                 | `2368`          |
| `containerPorts.https`                  | Ghost HTTPS container port                                                                | `2368`          |
| `podSecurityContext.enabled`            | Enabled Ghost pods' Security Context                                                      | `true`          |
| `podSecurityContext.fsGroup`            | Set Ghost pod's Security Context fsGroup                                                  | `1001`          |
| `containerSecurityContext.enabled`      | Enabled Ghost containers' Security Context                                                | `true`          |
| `containerSecurityContext.runAsUser`    | Set Ghost container's Security Context runAsUser                                          | `1001`          |
| `containerSecurityContext.runAsNonRoot` | Set Ghost container's Security Context runAsNonRoot                                       | `true`          |
| `startupProbe.enabled`                  | Enable startupProbe                                                                       | `false`         |
| `startupProbe.initialDelaySeconds`      | Initial delay seconds for startupProbe                                                    | `120`           |
| `startupProbe.periodSeconds`            | Period seconds for startupProbe                                                           | `10`            |
| `startupProbe.timeoutSeconds`           | Timeout seconds for startupProbe                                                          | `5`             |
| `startupProbe.failureThreshold`         | Failure threshold for startupProbe                                                        | `6`             |
| `startupProbe.successThreshold`         | Success threshold for startupProbe                                                        | `1`             |
| `livenessProbe.enabled`                 | Enable livenessProbe                                                                      | `true`          |
| `livenessProbe.initialDelaySeconds`     | Initial delay seconds for livenessProbe                                                   | `120`           |
| `livenessProbe.periodSeconds`           | Period seconds for livenessProbe                                                          | `10`            |
| `livenessProbe.timeoutSeconds`          | Timeout seconds for livenessProbe                                                         | `5`             |
| `livenessProbe.failureThreshold`        | Failure threshold for livenessProbe                                                       | `6`             |
| `livenessProbe.successThreshold`        | Success threshold for livenessProbe                                                       | `1`             |
| `readinessProbe.enabled`                | Enable readinessProbe                                                                     | `true`          |
| `readinessProbe.initialDelaySeconds`    | Initial delay seconds for readinessProbe                                                  | `30`            |
| `readinessProbe.periodSeconds`          | Period seconds for readinessProbe                                                         | `5`             |
| `readinessProbe.timeoutSeconds`         | Timeout seconds for readinessProbe                                                        | `3`             |
| `readinessProbe.failureThreshold`       | Failure threshold for readinessProbe                                                      | `6`             |
| `readinessProbe.successThreshold`       | Success threshold for readinessProbe                                                      | `1`             |
| `customLivenessProbe`                   | Custom livenessProbe that overrides the default one                                       | `{}`            |
| `customReadinessProbe`                  | Custom readinessProbe that overrides the default one                                      | `{}`            |


### Traffic Exposure Parameters

| Name                               | Description                                                                                                                      | Value                    |
| ---------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `service.type`                     | Ghost service type                                                                                                               | `LoadBalancer`           |
| `service.ports.http`               | Ghost service HTTP port                                                                                                          | `80`                     |
| `service.ports.https`              | Ghost service HTTPS port                                                                                                         | `443`                    |
| `service.nodePorts.http`           | Node port for HTTP                                                                                                               | `""`                     |
| `service.nodePorts.https`          | Node port for HTTPS                                                                                                              | `""`                     |
| `service.clusterIP`                | Ghost service Cluster IP                                                                                                         | `""`                     |
| `service.loadBalancerIP`           | Ghost service Load Balancer IP                                                                                                   | `""`                     |
| `service.loadBalancerSourceRanges` | Ghost service Load Balancer sources                                                                                              | `[]`                     |
| `service.externalTrafficPolicy`    | Ghost service external traffic policy                                                                                            | `Cluster`                |
| `service.annotations`              | Additional custom annotations for Ghost service                                                                                  | `{}`                     |
| `service.extraPorts`               | Extra port to expose on Ghost service                                                                                            | `[]`                     |
| `service.sessionAffinity`          | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                                                             | `None`                   |
| `service.sessionAffinityConfig`    | Additional settings for the sessionAffinity                                                                                      | `{}`                     |
| `ingress.enabled`                  | Enable ingress record generation for Ghost                                                                                       | `false`                  |
| `ingress.pathType`                 | Ingress path type                                                                                                                | `ImplementationSpecific` |
| `ingress.apiVersion`               | Force Ingress API version (automatically detected if not set)                                                                    | `""`                     |
| `ingress.hostname`                 | Default host for the ingress record                                                                                              | `ghost.local`            |
| `ingress.path`                     | Default path for the ingress record                                                                                              | `/`                      |
| `ingress.annotations`              | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                     |
| `ingress.tls`                      | Enable TLS configuration for the host defined at `ingress.hostname` parameter                                                    | `false`                  |
| `ingress.selfSigned`               | Create a TLS secret for this ingress record using self-signed certificates generated by Helm                                     | `false`                  |
| `ingress.extraHosts`               | An array with additional hostname(s) to be covered with the ingress record                                                       | `[]`                     |
| `ingress.extraPaths`               | An array with additional arbitrary paths that may need to be added to the ingress under the main host                            | `[]`                     |
| `ingress.extraTls`                 | TLS configuration for additional hostname(s) to be covered with this ingress record                                              | `[]`                     |
| `ingress.secrets`                  | Custom TLS certificates as secrets                                                                                               | `[]`                     |
| `ingress.ingressClassName`         | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                    | `""`                     |


### Persistence Parameters

| Name                                          | Description                                                                                     | Value                   |
| --------------------------------------------- | ----------------------------------------------------------------------------------------------- | ----------------------- |
| `persistence.enabled`                         | Enable persistence using Persistent Volume Claims                                               | `true`                  |
| `persistence.storageClass`                    | Persistent Volume storage class                                                                 | `""`                    |
| `persistence.annotations`                     | Additional custom annotations for the PVC                                                       | `{}`                    |
| `persistence.accessModes`                     | Persistent Volume access modes                                                                  | `[]`                    |
| `persistence.size`                            | Persistent Volume size                                                                          | `8Gi`                   |
| `persistence.existingClaim`                   | The name of an existing PVC to use for persistence                                              | `""`                    |
| `volumePermissions.enabled`                   | Enable init container that changes the owner/group of the PV mount point to `runAsUser:fsGroup` | `false`                 |
| `volumePermissions.image.registry`            | Bitnami Shell image registry                                                                    | `docker.io`             |
| `volumePermissions.image.repository`          | Bitnami Shell image repository                                                                  | `bitnami/bitnami-shell` |
| `volumePermissions.image.tag`                 | Bitnami Shell image tag (immutable tags are recommended)                                        | `10-debian-10-r216`     |
| `volumePermissions.image.pullPolicy`          | Bitnami Shell image pull policy                                                                 | `IfNotPresent`          |
| `volumePermissions.image.pullSecrets`         | Bitnami Shell image pull secrets                                                                | `[]`                    |
| `volumePermissions.resources.limits`          | The resources limits for the init container                                                     | `{}`                    |
| `volumePermissions.resources.requests`        | The requested resources for the init container                                                  | `{}`                    |
| `volumePermissions.securityContext.runAsUser` | Set init container's Security Context runAsUser                                                 | `0`                     |


### Database Parameters

| Name                                       | Description                                                               | Value           |
| ------------------------------------------ | ------------------------------------------------------------------------- | --------------- |
| `mariadb.enabled`                          | Deploy a MariaDB server to satisfy the applications database requirements | `true`          |
| `mariadb.architecture`                     | MariaDB architecture. Allowed values: `standalone` or `replication`       | `standalone`    |
| `mariadb.auth.rootPassword`                | MariaDB root password                                                     | `""`            |
| `mariadb.auth.database`                    | MariaDB custom database                                                   | `bitnami_ghost` |
| `mariadb.auth.username`                    | MariaDB custom user name                                                  | `bn_ghost`      |
| `mariadb.auth.password`                    | MariaDB custom user password                                              | `""`            |
| `mariadb.auth.existingSecret`              | Existing secret with MariaDB credentials                                  | `""`            |
| `mariadb.primary.persistence.enabled`      | Enable persistence on MariaDB using PVC(s)                                | `true`          |
| `mariadb.primary.persistence.storageClass` | Persistent Volume storage class                                           | `""`            |
| `mariadb.primary.persistence.accessModes`  | Persistent Volume access modes                                            | `[]`            |
| `mariadb.primary.persistence.size`         | Persistent Volume size                                                    | `8Gi`           |
| `externalDatabase.host`                    | External Database server host                                             | `localhost`     |
| `externalDatabase.port`                    | External Database server port                                             | `3306`          |
| `externalDatabase.user`                    | External Database username                                                | `bn_ghost`      |
| `externalDatabase.password`                | External Database user password                                           | `""`            |
| `externalDatabase.database`                | External Database database name                                           | `bitnami_ghost` |
| `externalDatabase.existingSecret`          | The name of an existing secret with database credentials                  | `""`            |


The above parameters map to the env variables defined in [bitnami/ghost](http://github.com/bitnami/bitnami-docker-ghost). For more information please refer to the [bitnami/ghost](http://github.com/bitnami/bitnami-docker-ghost) image documentation.

> **Note**:
>
> For the Ghost application function correctly, you should specify the `ghostHost` parameter to specify the FQDN (recommended) or the public IP address of the Ghost service.
>
> Optionally, you can specify the `ghostLoadBalancerIP` parameter to assign a reserved IP address to the Ghost service of the chart. However please note that this feature is only available on a few cloud providers (f.e. GKE).
>
> To reserve a public IP address on GKE:
>
> ```bash
> $ gcloud compute addresses create ghost-public-ip
> ```
>
> The reserved IP address can be assigned to the Ghost service by specifying it as the value of the `service.loadBalancerIP` parameter while installing the chart.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install my-release \
  --set ghostUsername=admin,ghostPassword=password,mariadb.auth.rootPassword=secretpassword \
    bitnami/ghost
```

The above command sets the Ghost administrator account username and password to `admin` and `password` respectively. Additionally, it sets the MariaDB `root` user password to `secretpassword`.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install my-release -f values.yaml bitnami/ghost
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### External database support

You may want to have Ghost connect to an external database rather than installing one inside your cluster. Typical reasons for this are to use a managed database service, or to share a common database server for all your applications. To achieve this, the chart allows you to specify credentials for an external database with the [`externalDatabase` parameter](#database-parameters). You should also disable the MariaDB installation with the `mariadb.enabled` option. Here is an example:

```console
mariadb.enabled=false
externalDatabase.host=myexternalhost
externalDatabase.user=myuser
externalDatabase.password=mypassword
externalDatabase.database=mydatabase
externalDatabase.port=3306
```

Refer to the [documentation on using an external database with Ghost](https://docs.bitnami.com/kubernetes/apps/ghost/configuration/use-external-database/) for more information.

### Configure Ingress

This chart provides support for Ingress resources. If you have an ingress controller installed on your cluster, such as [nginx-ingress-controller](https://github.com/bitnami/charts/tree/master/bitnami/nginx-ingress-controller) or [contour](https://github.com/bitnami/charts/tree/master/bitnami/contour) you can utilize the ingress controller to serve your application.

To enable Ingress integration, set `ingress.enabled` to `true`. The `ingress.hostname` property can be used to set the host name. The `ingress.tls` parameter can be used to add the TLS configuration for this host. It is also possible to have more than one host, with a separate TLS configuration for each host. [Learn more about configuring and using Ingress](https://docs.bitnami.com/kubernetes/apps/ghost/configuration/configure-ingress/).

### Configure TLS Secrets for use with Ingress

The chart also facilitates the creation of TLS secrets for use with the Ingress controller, with different options for certificate management. [Learn more about TLS secrets](https://docs.bitnami.com/kubernetes/apps/ghost/administration/enable-tls-ingress/).

### Configure extra environment variables

To add extra environment variables (useful for advanced operations like custom init scripts), use the `extraEnvVars` property.

```yaml
extraEnvVars:
  - name: LOG_LEVEL
    value: DEBUG
```

Alternatively, use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values.

### Configure Sidecars and Init Containers

If additional containers are needed in the same pod as Ghost (such as additional metrics or logging exporters), they can be defined using the `sidecars` parameter. Similarly, you can add extra init containers using the `initContainers` parameter.

[Learn more about configuring and using sidecar and init containers](https://docs.bitnami.com/kubernetes/apps/ghost/configuration/configure-sidecar-init-containers/).

### Deploy extra resources

There are cases where you may want to deploy extra objects, such a ConfigMap containing your app's configuration or some extra deployment with a micro service used by your app. For covering this case, the chart allows adding the full specification of other objects using the `extraDeploy` parameter.

### Set Pod affinity

This chart allows you to set custom Pod affinity using the `affinity` parameter(s). Find more information about Pod affinity in the [Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

## Persistence

The [Bitnami Ghost](https://github.com/bitnami/bitnami-docker-ghost) image stores the Ghost data and configurations at the `/bitnami/ghost` and `/bitnami/apache` paths of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Parameters](#parameters) section to configure the PVC or to disable persistence.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami’s Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 15.0.0

This major release renames several values in this chart and adds missing features, in order to be inline with the rest of assets in the Bitnami charts repository.

Affected values:

- `service.port` was deprecated, we recommend using `service.ports.http` instead.
- `service.httpsPort` was deprecated, we recommend using `service.ports.https` instead.

Additionally, updates the MariaDB subchart to it newest major, 10.0.0, which contains similar changes.

### To 14.0.0

Due to recent changes in the container image (see [Notable changes](https://github.com/bitnami/bitnami-docker-ghost#notable-changes)), the major version of the chart has been bumped preemptively.

Compatibility is not guaranteed due to the amount of involved changes, however no breaking changes are expected.

### To 12.0.0

This version standardizes the way of defining Ingress rules. When configuring a single hostname for the Ingress rule, set the `ingress.hostname` value. When defining more than one, set the `ingress.extraHosts` array. Apart from this case, no issues are expected to appear when upgrading.

### To 11.0.0

In this major there were two main changes introduced:

1. Adaptation to Helm v2 EOL
2. Updated MariaDB dependency version

Please read the update notes carefully.

**1. Adaptation to Helm v2 EOL**

[On November 13, 2020, Helm v2 support was formally finished](https://github.com/helm/charts#status-of-the-project), this major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

**What changes were introduced in this major version?**

- Previous versions of this Helm Chart use `apiVersion: v1` (installable by both Helm 2 and 3), this Helm Chart was updated to `apiVersion: v2` (installable by Helm 3 only). [Here](https://helm.sh/docs/topics/charts/#the-apiversion-field) you can find more information about the `apiVersion` field.
- Move dependency information from the *requirements.yaml* to the *Chart.yaml*
- After running `helm dependency update`, a *Chart.lock* file is generated containing the same structure used in the previous *requirements.lock*
- The different fields present in the *Chart.yaml* file has been ordered alphabetically in a homogeneous way for all the Bitnami Helm Charts

**Considerations when upgrading to this version**

- If you want to upgrade to this version from a previous one installed with Helm v3, you shouldn't face any issues
- If you want to upgrade to this version using Helm v2, this scenario is not supported as this version doesn't support Helm v2 anymore
- If you installed the previous version with Helm v2 and wants to upgrade to this version with Helm v3, please refer to the [official Helm documentation](https://helm.sh/docs/topics/v2_v3_migration/#migration-use-cases) about migrating from Helm v2 to v3

**Useful links**

- https://docs.bitnami.com/tutorials/resolve-helm2-helm3-post-migration-issues/
- https://helm.sh/docs/topics/v2_v3_migration/
- https://helm.sh/blog/migrate-from-helm-v2-to-helm-v3/

**2. Updated MariaDB dependency version**

In this major the MariaDB dependency version was also bumped to a new major version that introduces several incompatilibites. Therefore, backwards compatibility is not guaranteed unless an external database is used. Check [MariaDB Upgrading Notes](https://github.com/bitnami/charts/tree/master/bitnami/mariadb#to-800) for more information.

To upgrade to `11.0.0`, it should be done reusing the PVCs used to hold both the MariaDB and Ghost data on your previous release. To do so, follow the instructions below (the following example assumes that the release name is `ghost`):

> NOTE: Please, create a backup of your database before running any of those actions. The steps below would be only valid if your application (e.g. any plugins or custom code) is compatible with MariaDB 10.5.x

Obtain the credentials and the name of the PVC used to hold the MariaDB data on your current release:

```console
$ export GHOST_HOST=$(kubectl get svc --namespace default ghost --template "{{ range (index .status.loadBalancer.ingress 0) }}{{ . }}{{ end }}")
$ export GHOST_PASSWORD=$(kubectl get secret --namespace default ghost -o jsonpath="{.data.ghost-password}" | base64 --decode)
$ export MARIADB_ROOT_PASSWORD=$(kubectl get secret --namespace default ghost-mariadb -o jsonpath="{.data.mariadb-root-password}" | base64 --decode)
$ export MARIADB_PASSWORD=$(kubectl get secret --namespace default ghost-mariadb -o jsonpath="{.data.mariadb-password}" | base64 --decode)
$ export MARIADB_PVC=$(kubectl get pvc -l app=mariadb,component=master,release=ghost -o jsonpath="{.items[0].metadata.name}")
```

Delete the Ghost deployment and delete the MariaDB statefulset. Notice the option `--cascade=false` in the latter.

  ```console
  $ kubectl delete deployments.apps ghost

  $ kubectl delete statefulsets.apps ghost-mariadb --cascade=false
  ```

Upgrade you release to 11.0.0 reusing the existing PVC, and enabling back MariaDB:

```console
$ helm upgrade ghost bitnami/ghost --set mariadb.primary.persistence.existingClaim=$MARIADB_PVC --set mariadb.auth.rootPassword=$MARIADB_ROOT_PASSWORD --set mariadb.auth.password=$MARIADB_PASSWORD --set ghostPassword=$GHOST_PASSWORD --set ghostHost=$GHOST_HOST
```

You will need to kill the existing MariaDB pod now as the new statefulset is going to create a new one:

```console
$ kubectl delete pod ghost-mariadb-0
```

You should see the lines below in MariaDB container logs:

```console
$ kubectl logs $(kubectl get pods -l app.kubernetes.io/instance=ghost,app.kubernetes.io/name=mariadb,app.kubernetes.io/component=primary -o jsonpath="{.items[0].metadata.name}")
...
mariadb 12:13:24.98 INFO  ==> Using persisted data
mariadb 12:13:25.01 INFO  ==> Running mysql_upgrade
...
```

### To 10.0.0

This version introduces `bitnami/common`, a [library chart](https://helm.sh/docs/topics/library_charts/#helm) as a dependency. More documentation about this new utility could be found [here](https://github.com/bitnami/charts/tree/master/bitnami/common#bitnami-common-library-chart). Please, make sure that you have updated the chart dependencies before executing any upgrade.

Also, `allowEmptyPassword` has changed its value type from string to boolean, if you were using it please make sure that you are passing the proper value.

```console
# before
--set allowEmptyPassword="no"
# after
--set allowEmptyPassword=false
```

### To 9.0.0

Helm performs a lookup for the object based on its group (apps), version (v1), and kind (Deployment). Also known as its GroupVersionKind, or GVK. Changing the GVK is considered a compatibility breaker from Kubernetes' point of view, so you cannot "upgrade" those objects to the new GVK in-place. Earlier versions of Helm 3 did not perform the lookup correctly which has since been fixed to match the spec.

In https://github.com/helm/charts/pulls/17297 the `apiVersion` of the deployment resources was updated to `apps/v1` in tune with the api's deprecated, resulting in compatibility breakage.

This major version signifies this change.

### To 5.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 5.0.0. The following example assumes that the release name is ghost:

```console
$ kubectl patch deployment ghost-ghost --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
$ kubectl delete statefulset ghost-mariadb --cascade=false
```
