# Ghost

[Ghost](https://ghost.org/) is one of the most versatile open source content management systems on the market.

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

The following table lists the configurable parameters of the Ghost chart and their default values.

### Global parameters

| Parameter                 | Description                                     | Default                                                 |
|---------------------------|-------------------------------------------------|---------------------------------------------------------|
| `global.imageRegistry`    | Global Docker image registry                    | `nil`                                                   |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]` (does not add image pull secrets to deployed pods) |
| `global.storageClass`     | Global storage class for dynamic provisioning   | `nil`                                                   |

### Common parameters

| Parameter           | Description                                                                  | Default                                                 |
|---------------------|------------------------------------------------------------------------------|---------------------------------------------------------|
| `image.registry`    | Ghost image registry                                                         | `docker.io`                                             |
| `image.repository`  | Ghost Image name                                                             | `bitnami/ghost`                                         |
| `image.tag`         | Ghost Image tag                                                              | `{TAG_NAME}`                                            |
| `image.pullPolicy`  | Ghost image pull policy                                                      | `IfNotPresent`                                          |
| `image.pullSecrets` | Specify docker-registry secret names as an array                             | `[]` (does not add image pull secrets to deployed pods) |
| `image.debug`       | Specify if debug logs should be enabled                                      | `false`                                                 |
| `nameOverride`      | String to partially override common.names.fullname template                  | `nil`                                                   |
| `fullnameOverride`  | String to fully override common.names.fullname template                      | `nil`                                                   |
| `commonLabels`      | Labels to add to all deployed objects                                        | `nil`                                                   |
| `commonAnnotations` | Annotations to add to all deployed objects                                   | `[]`                                                    |
| `extraDeploy`       | Array of extra objects to deploy with the release (evaluated as a template). | `nil`                                                   |

### Ghost parameters

| Parameter                               | Description                                                                                                           | Default                                     |
|-----------------------------------------|-----------------------------------------------------------------------------------------------------------------------|---------------------------------------------|
| `affinity`                              | Map of node/pod affinities                                                                                            | `{}`                                        |
| `allowEmptyPassword`                    | Allow DB blank passwords                                                                                              | true                                        |
| `args`                                  | Override default container args (useful when using custom images)                                                     | `nil`                                       |
| `command`                               | Override default container command (useful when using custom images)                                                  | `nil`                                       |
| `hostAliases`                           | Add deployment host aliases                                                                                           | `[]`                                        |
| `containerPorts.http`                   | Sets http port inside Ghost container                                                                                 | `8080`                                      |
| `containerPorts.https`                  | Sets https port inside Ghost container                                                                                | `8443`                                      |
| `livenessProbe.enabled`                 | Would you like a livenessProbe to be enabled                                                                          | `true`                                      |
| `livenessProbe.initialDelaySeconds`     | Delay before liveness probe is initiated                                                                              | 120                                         |
| `livenessProbe.periodSeconds`           | How often to perform the probe                                                                                        | 3                                           |
| `livenessProbe.timeoutSeconds`          | When the probe times out                                                                                              | 5                                           |
| `livenessProbe.failureThreshold`        | Minimum consecutive failures to be considered failed                                                                  | 6                                           |
| `livenessProbe.successThreshold`        | Minimum consecutive successes to be considered successful                                                             | 1                                           |
| `readinessProbe.enabled`                | Would you like a readinessProbe to be enabled                                                                         | `true`                                      |
| `readinessProbe.initialDelaySeconds`    | Delay before readiness probe is initiated                                                                             | 30                                          |
| `readinessProbe.periodSeconds`          | How often to perform the probe                                                                                        | 3                                           |
| `readinessProbe.timeoutSeconds`         | When the probe times out                                                                                              | 5                                           |
| `readinessProbe.failureThreshold`       | Minimum consecutive failures to be considered failed                                                                  | 6                                           |
| `readinessProbe.successThreshold`       | Minimum consecutive successes to be considered successful                                                             | 1                                           |
| `podSecurityContext.enabled`            | Enable security context                                                                                               | `true`                                      |
| `podSecurityContext.fsGroup`            | Group ID for the container                                                                                            | `1001`                                      |
| `podSecurityContext.runAsUser`          | User ID for the container                                                                                             | `1001`                                      |
| `containerSecurityContext.enabled`      | Enable Ghost containers' Security Context                                                                             | `true`                                      |
| `containerSecurityContext.runAsUser`    | Ghost containers' Security Context                                                                                    | `1001`                                      |
| `containerSecurityContext.runAsNonRoot` | Ghost containers' Security Context Non Root                                                                           | `true`                                      |
| `customLivenessProbe`                   | Override default liveness probe                                                                                       | `nil`                                       |
| `customReadinessProbe`                  | Override default readiness probe                                                                                      | `nil`                                       |
| `existingSecret`                        | Name of a secret with the application password                                                                        | `nil`                                       |
| `extraEnvVarsConfigMap`                 | ConfigMap containing extra env vars                                                                                   | `nil`                                       |
| `extraEnvVarsSecret`                    | Secret containing extra env vars (in case of sensitive data)                                                          | `nil`                                       |
| `extraEnvVars`                          | Extra environment variables                                                                                           | `nil`                                       |
| `extraVolumeMounts`                     | Array of extra volume mounts to be added to the container (evaluated as template). Normally used with `extraVolumes`. | `nil`                                       |
| `extraVolumes`                          | Array of extra volumes to be added to the deployment (evaluated as template). Requires setting `extraVolumeMounts`    | `nil`                                       |
| `initContainers`                        | Add additional init containers to the pod (evaluated as a template)                                                   | `nil`                                       |
| `lifecycleHooks`                        | LifecycleHook to set additional configuration at startup Evaluated as a template                                      | ``                                          |
| `ghostHost`                             | Ghost host to create application URLs                                                                                 | `nil`                                       |
| `ghostPort`                             | Ghost port to use in application URLs (defaults to `service.port` if `nil`)                                           | `nil`                                       |
| `ghostProtocol`                         | Protocol (http or https) to use in the application URLs                                                               | `http`                                      |
| `ghostPath`                             | Ghost path to create application URLs                                                                                 | `nil`                                       |
| `ghostUsername`                         | User of the application                                                                                               | `user@example.com`                          |
| `ghostPassword`                         | Application password                                                                                                  | Randomly generated                          |
| `ghostEmail`                            | Admin email                                                                                                           | `user@example.com`                          |
| `ghostBlogTitle`                        | Ghost Blog name                                                                                                       | `User's Blog`                               |
| `nodeAffinityPreset.type`               | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                             | `""`                                        |
| `nodeAffinityPreset.key`                | Node label key to match Ignored if `affinity` is set.                                                                 | `""`                                        |
| `nodeAffinityPreset.values`             | Node label values to match. Ignored if `affinity` is set.                                                             | `[]`                                        |
| `nodeSelector`                          | Node labels for pod assignment                                                                                        | `{}` (The value is evaluated as a template) |
| `persistence.accessMode`                | PVC Access Mode for Ghost volume                                                                                      | `ReadWriteOnce`                             |
| `persistence.enabled`                   | Enable persistence using PVC                                                                                          | `true`                                      |
| `persistence.existingClaim`             | An Existing PVC name                                                                                                  | `nil`                                       |
| `persistence.path`                      | Host mount path for Ghost volume                                                                                      | `nil` (will not mount to a host path)       |
| `persistence.size`                      | PVC Storage Request for Ghost volume                                                                                  | `8Gi`                                       |
| `persistence.storageClass`              | PVC Storage Class for Ghost volume                                                                                    | `nil` (uses alpha storage class annotation) |
| `podAnnotations`                        | Pod annotations                                                                                                       | `{}`                                        |
| `podAffinityPreset`                     | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                   | `""`                                        |
| `podAntiAffinityPreset`                 | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                              | `soft`                                      |
| `podLabels`                             | Add additional labels to the pod (evaluated as a template)                                                            | `nil`                                       |
| `podSecurityContext.enabled`            | Enable Ghost pods' Security Context                                                                                   | `true`                                      |
| `podSecurityContext.fsGroup`            | Ghost pods' group ID                                                                                                  | `1001`                                      |
| `priorityClassName`                     | Define the priority class name to use for the ghost pods here.                                                        | `""`                                        |
| `replicaCount`                          | Number of Ghost Pods to run                                                                                           | `1`                                         |
| `resources`                             | CPU/Memory resource requests/limits                                                                                   | Memory: `512Mi`, CPU: `300m`                |
| `sidecars`                              | Attach additional containers to the pod (evaluated as a template)                                                     | `nil`                                       |
| `smtpHost`                              | SMTP host                                                                                                             | `nil`                                       |
| `smtpPort`                              | SMTP port                                                                                                             | `nil`                                       |
| `smtpUser`                              | SMTP user                                                                                                             | `nil`                                       |
| `smtpPassword`                          | SMTP password                                                                                                         | `nil`                                       |
| `smtpFromAddress`                       | SMTP from address                                                                                                     | `nil`                                       |
| `smtpService`                           | SMTP service                                                                                                          | `nil`                                       |
| `tolerations`                           | Tolerations for pod assignment                                                                                        | `[]` (The value is evaluated as a template) |
| `updateStrategy`                        | Deployment update strategy                                                                                            | `RollingUpdate`                                       |

### Traffic Exposure Parameters

| Parameter                         | Description                                                                          | Default                        |
|-----------------------------------|--------------------------------------------------------------------------------------|--------------------------------|
| `service.type`                    | Kubernetes Service type                                                              | `LoadBalancer`                 |
| `service.port`                    | Service HTTP port                                                                    | `80`                           |
| `service.nodePorts.http`          | Kubernetes http node port                                                            | `""`                           |
| `service.externalTrafficPolicy`   | Enable client source IP preservation                                                 | `Cluster`                      |
| `service.loadBalancerIP`          | LoadBalancerIP for the Ghost service                                                 | ``                             |
| `service.loadBalancerSourceRanges`| define loadBalancerSourceRanges if the service type is `LoadBalancer`                | `[]`                           |
| `service.annotations`             | Service annotations. Evaluated as a template                                         | `{}`                           |
| `service.extraPorts`              | Service extra ports, normally used with the `sidecar` value. Evaluated as a template | `[]`                           |
| `ingress.enabled`                 | Enable ingress controller resource                                                   | `false`                        |
| `ingress.certManager`             | Add annotations for cert-manager                                                     | `false`                        |
| `ingress.hostname`                | Default host for the ingress resource                                                | `ghost.local`                  |
| `ingress.path`                    | Default path for the ingress resource                                                | `/`                            |
| `ingress.tls`                     | Create TLS Secret                                                                    | `false`                        |
| `ingress.annotations`             | Ingress annotations                                                                  | `[]` (evaluated as a template) |
| `ingress.extraHosts[0].name`      | Additional hostnames to be covered                                                   | `nil`                          |
| `ingress.extraHosts[0].path`      | Additional hostnames to be covered                                                   | `nil`                          |
| `ingress.extraPaths`              | Additional arbitrary path/backend objects                                            | `nil`                          |
| `ingress.extraTls[0].hosts[0]`    | TLS configuration for additional hostnames to be covered                             | `nil`                          |
| `ingress.extraTls[0].secretName`  | TLS configuration for additional hostnames to be covered                             | `nil`                          |
| `ingress.secrets[0].name`         | TLS Secret Name                                                                      | `nil`                          |
| `ingress.secrets[0].certificate`  | TLS Secret Certificate                                                               | `nil`                          |
| `ingress.secrets[0].key`          | TLS Secret Key                                                                       | `nil`                          |

### Database parameters

| Parameter                                   | Description                                                                                | Default                                        |
|---------------------------------------------|--------------------------------------------------------------------------------------------|------------------------------------------------|
| `mariadb.enabled`                           | Whether to use the MariaDB chart                                                           | `true`                                         |
| `mariadb.architecture`                      | MariaDB architecture (`standalone` or `replication`)                                       | `standalone`                                   |
| `mariadb.auth.rootPassword`                 | Password for the MariaDB `root` user                                                       | _random 10 character alphanumeric string_      |
| `mariadb.auth.database`                     | Database name to create                                                                    | `bitnami_ghost`                                |
| `mariadb.auth.username`                     | Database user to create                                                                    | `bn_ghost`                                     |
| `mariadb.auth.password`                     | Password for the database                                                                  | _random 10 character long alphanumeric string_ |
| `mariadb.primary.persistence.enabled`       | Enable database persistence using PVC                                                      | `true`                                         |
| `mariadb.primary.persistence.existingClaim` | Name of an existing `PersistentVolumeClaim` for MariaDB primary replicas                   | `nil`                                          |
| `mariadb.primary.persistence.accessMode`    | Database Persistent Volume Access Modes                                                    | `[ReadWriteOnce]`                              |
| `mariadb.primary.persistence.size`          | Database Persistent Volume Size                                                            | `8Gi`                                          |
| `mariadb.primary.persistence.storageClass`  | MariaDB primary persistent volume storage Class                                            | `nil` (uses alpha storage class annotation)    |
| `mariadb.primary.persistence.hostPath`      | Host mount path for MariaDB volume                                                         | `nil` (will not mount to a host path)          |
| `externalDatabase.user`                     | Existing username in the external db                                                       | `bn_ghost`                                     |
| `externalDatabase.password`                 | Password for the above username                                                            | `nil`                                          |
| `externalDatabase.existingSecret`           | Name of an existing secret resource containing the DB password in a 'mariadb-password' key | `nil`                                          |
| `externalDatabase.database`                 | Name of the existing database                                                              | `bitnami_ghost`                                |
| `externalDatabase.host`                     | Host of the existing database                                                              | `nil`                                          |
| `externalDatabase.port`                     | Port of the existing database                                                              | `3306`                                         |

### Volume Permissions parameters

| Parameter                             | Description                                         | Default                                                 |
|---------------------------------------|-----------------------------------------------------|---------------------------------------------------------|
| `volumePermissions.image.registry`    | Init container volume-permissions image registry    | `docker.io`                                             |
| `volumePermissions.image.repository`  | Init container volume-permissions image name        | `bitnami/bitnami-shell`                                 |
| `volumePermissions.image.tag`         | Init container volume-permissions image tag         | `"10"`                                                  |
| `volumePermissions.image.pullSecrets` | Specify docker-registry secret names as an array    | `[]` (does not add image pull secrets to deployed pods) |
| `volumePermissions.image.pullPolicy`  | Init container volume-permissions image pull policy | `Always`                                                |
| `volumePermissions.resources`         | Init container resource requests/limit              | `nil`                                                   |

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
> The reserved IP address can be assigned to the Ghost service by specifying it as the value of the `ghostLoadBalancerIP` parameter while installing the chart.

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

### Using an existing database

Sometimes you may want to have Ghost connect to an external database rather than installing one inside your cluster, e.g. to use a managed database service, or use run a single database server for all your applications. To do this, the chart allows you to specify credentials for an external database under the [`externalDatabase` parameter](#parameters). You should also disable the MariaDB installation with the `mariadb.enabled` option. For example using the following parameters:

```console
mariadb.enabled=false
externalDatabase.host=myexternalhost
externalDatabase.user=myuser
externalDatabase.password=mypassword
externalDatabase.database=mydatabase
```

### Setting Pod's affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

## Persistence

The [Bitnami Ghost](https://github.com/bitnami/bitnami-docker-ghost) image stores the Ghost data and configurations at the `/bitnami/ghost` and `/bitnami/apache` paths of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Parameters](#parameters) section to configure the PVC or to disable persistence.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami’s Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

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
