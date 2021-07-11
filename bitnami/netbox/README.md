# Netbox

[Netbox](https://Netbox.com) is a fast, reliable, scalable, and easy to use open-source relational database system. Netbox Server is intended for mission-critical, heavy-load production systems as well as for embedding into mass-deployed software.

## TL;DR

```bash
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/netbox
```

## Introduction

Bitnami charts for Helm are carefully engineered, actively maintained and are the quickest and easiest way to deploy containers on a Kubernetes cluster that are ready to handle production workloads.

This chart bootstraps a [Netbox](https://github.com/bitnami/bitnami-docker-netbox) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This Helm chart has been tested on top of [Bitnami Kubernetes Production Runtime](https://kubeprod.io/) (BKPR). Deploy BKPR to get automated TLS certificates, logging and monitoring for your applications.

## Prerequisites

- Kubernetes 1.12+
- Helm 3.1.0
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/netbox
```

These commands deploy Netbox on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

The following table lists the configurable parameters of the Netbox chart and their default values.

| Parameter                               | Description                                                                               | Default                                                 |
| --------------------------------------- | ----------------------------------------------------------------------------------------- | ------------------------------------------------------- |
| `global.imageRegistry`                  | Global Docker Image registry                                                              | `nil`                                                   |
| `global.imagePullSecrets`               | Global Docker registry secret names as an array                                           | `[]` (does not add image pull secrets to deployed pods) |
| `global.storageClass`                   | Global storage class for dynamic provisioning                                             | `nil`                                                   |
| `nameOverride`                          | String to partially override common.names.fullname                                        | `nil`                                                   |
| `fullnameOverride`                      | String to fully override common.names.fullname                                            | `nil`                                                   |
| `commonLabels`                          | Labels to add to all deployed objects                                                     | `nil`                                                   |
| `commonAnnotations`                     | Annotations to add to all deployed objects                                                | `[]`                                                    |
| `schedulerName`                         | Name of the scheduler (other than default) to dispatch pods                               | `nil`                                                   |
| `extraDeploy`                           | Array of extra objects to deploy with the release (evaluated as a template)               | `nil`                                                   |
| `priorityClassName`                     | Name of priority class                                                                    | `nil`                                                   |
| `replicaCount`                          | Number of replicas of the Netbox deployment                                               | `1`                                                     |
| `hostAliases`                           | Add deployment host aliases                                                               | `Check values.yaml`                                     |
| `podAnnotations`                        | Pod annotations                                                                           | `{}` (evaluated as a template)                          |
| `podAffinityPreset`                     | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`       | `""`                                                    |
| `podAntiAffinityPreset`                 | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`  | `soft`                                                  |
| `nodeAffinityPreset.type`               | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard` | `""`                                                    |
| `nodeAffinityPreset.key`                | Node label key to match Ignored if `affinity` is set.                                     | `""`                                                    |
| `nodeAffinityPreset.values`             | Node label values to match. Ignored if `affinity` is set.                                 | `[]`                                                    |
| `affinity`                              | Affinity for pod assignment                                                               | `{}` (evaluated as a template)                          |
| `nodeSelector`                          | Node labels for pod assignment                                                            | `{}` (evaluated as a template)                          |
| `tolerations`                           | Tolerations for pod assignment                                                            | `[]` (evaluated as a template)                          |
| `lifecycleHooks`                        | LifecycleHooks to set additional configuration at startup.                                | `{}` (evaluated as a template)                          |
| `updateStrategy.type`                   | Update strategy to use for the deployment                                                 | `RollingUpdate`                                         |
| `livenessProbe.enabled`                 | Enable liveness probe                                                                     | `true`                                                  |
| `livenessProbe.httpGet.path`            | Path to access on the HTTP server                                                         | `/login`                                                |
| `livenessProbe.httpGet.port`            | Port to access on the HTTP server                                                         | `8080`                                                  |
| `livenessProbe.initialDelaySeconds`     | initialDelaySeconds                                                                       | `0`                                                     |
| `livenessProbe.periodSeconds`           | periodSeconds                                                                             | `10`                                                    |
| `livenessProbe.timeoutSeconds`          | timeoutSeconds                                                                            | `1`                                                     |
| `livenessProbe.failureThreshold`        | failureThreshold                                                                          | `3`                                                     |
| `livenessProbe.successThreshold`        | successThreshold                                                                          | `1`                                                     |
| `readinessProbe.enabled`                | Enable readiness probe                                                                    | `true`                                                  |
| `readinessProbe.httpGet.path`           | Path to access on the HTTP server                                                         | `/login`                                                |
| `readinessProbe.httpGet.port`           | Port to access on the HTTP server                                                         | `8080`                                                  |
| `readinessProbe.initialDelaySeconds`    | initialDelaySeconds                                                                       | `0`                                                     |
| `readinessProbe.periodSeconds`          | periodSeconds                                                                             | `10`                                                    |
| `readinessProbe.timeoutSeconds`         | timeoutSeconds                                                                            | `1`                                                     |
| `readinessProbe.failureThreshold`       | failureThreshold                                                                          | `3`                                                     |
| `readinessProbe.successThreshold`       | successThreshold                                                                          | `1`                                                     |
| `customLivenessProbe`                   | Override default liveness probe                                                           | `nil`                                                   |
| `customReadinessProbe`                  | Override default readiness probe                                                          | `nil`                                                   |
| `ingress.enabled`                       | Enable ingress controller resource                                                        | `false`                                                 |
| `ingress.apiVersion`                    | Force Ingress API version (automatically detected if not set)                             | ``                                                      |
| `ingress.path`                          | Ingress path                                                                              | `/`                                                     |
| `ingress.pathType`                      | Ingress path type                                                                         | `ImplementationSpecific`                                |
| `ingress.hostname`                      | Default host for the ingress resource                                                     | `netbox.local`                                          |
| `ingress.certManager`                   | Add annotations for cert-manager                                                          | `false`                                                 |
| `ingress.annotations`                   | Ingress annotations                                                                       | `[]`                                                    |
| `ingress.hosts[0].name`                 | Hostname to your Netbox installation                                                      | `netbox.local`                                          |
| `ingress.hosts[0].path`                 | Path within the url structure                                                             | `/`                                                     |
| `ingress.tls[0].hosts[0]`               | TLS hosts                                                                                 | `netbox.local`                                          |
| `ingress.tls[0].secretName`             | TLS Secret (certificates)                                                                 | `netbox.local-tls`                                      |
| `ingress.secrets[0].name`               | TLS Secret Name                                                                           | `nil`                                                   |
| `ingress.secrets[0].certificate`        | TLS Secret Certificate                                                                    | `nil`                                                   |
| `ingress.secrets[0].key`                | TLS Secret Key                                                                            | `nil`                                                   |
| `command`                               | Override default container command (useful when using custom images)                      | `[]`                                                    |
| `podAnnotations`                        | Additional pod annotations                                                                | `{}`                                                    |
| `podLabels`                             | Additional pod labels                                                                     | `{}`                                                    |
| `args`                                  | Override default container args (useful when using custom images)                         | `[]`                                                    |
| `resources.limits`                      | The resources limits for the ASP.NET Core container                                       | `{}`                                                    |
| `resources.requests`                    | The requested resources for the ASP.NET Core container                                    | `{}`                                                    |
| `containerSecurityContext.enabled`      | Enable Ghost containers' Security Context                                                 | `true`                                                  |
| `containerSecurityContext.runAsUser`    | Ghost containers' Security Context                                                        | `1001`                                                  |
| `containerSecurityContext.runAsNonRoot` | Ghost containers' Security Context Non Root                                               | `true`                                                  |
| `podSecurityContext.enabled`            | Enable security context for Cassandra pods                                                | `true`                                                  |
| `podSecurityContext.fsGroup`            | Group ID for the volumes of the pod                                                       | `1001`                                                  |
| `initContainers`                        | List of init containers to be added to the web, worker and scheduler pods                 | `nil`                                                   |
| `sidecars`                              | List of sidecar containers to be adde to web, worker and scheduler pods                   | `nil`                                                   |
| `image.registry`                        | Netbox image registry                                                                     | `docker.io`                                             |
| `image.repository`                      | Netbox image name                                                                         | `bitnami/Netbox`                                        |
| `image.tag`                             | Netbox image tag                                                                          | `{TAG_NAME}`                                            |
| `image.pullPolicy`                      | Netbox image pull policy                                                                  | `IfNotPresent`                                          |
| `image.pullSecrets`                     | Specify docker-registry secret names as an array                                          | `[]` (does not add image pull secrets to deployed pods) |
| `service.type`                          | Kubernetes Service type                                                                   | `ClusterIP`                                             |
| `service.port`                          | Service HTTP port                                                                         | `80`                                                    |
| `service.nodePorts.http`                | Kubernetes http node port                                                                 | `""`                                                    |
| `service.externalTrafficPolicy`         | Enable client source IP preservation                                                      | `Cluster`                                               |
| `service.loadBalancerIP`                | LoadBalancer service IP address                                                           | `""`                                                    |
| `extraVolumes`                          | Array to add extra volumes                                                                | `[]` (evaluated as a template)                          |
| `extraVolumeMounts`                     | Array to add extra mount                                                                  | `[]` (evaluated as a template)                          |
| `extraEnvVars`                          | Array to add extra environment variables                                                  | `[]` (evaluated as a template)                          |
| `extraEnvVarsCM`                        | ConfigMap containing extra env vars to add to web, worker and scheduler pods              | `nil`                                                   |
| `extraEnvVarsSecret`                    | Secret containing extra env vars to add to web, worker and scheduler pods                 | `nil`                                                   |
| `netbox.debug`                          | Enable Netbox debug mode                                                                  | `false`                                                 |
| `netbox.maintenanceMode`                | Enable Netbox maintenance mode                                                            | `false`                                                 |
| `netbox.superuser_name`                 | Netbox Superuser name                                                                     | `admin`                                                 |
| `netbox.dbConnMaxAge`                   | Netbox DB Connection maximum age                                                          | `300`                                                   |
| `netbox.superuser_password`             | Netbox Superuser Password                                                                 | `admin`                                                 |
| `netbox.superuser_api_token`            | Netbox Superuser API Token                                                                | `admin`                                                 |
| `netbox.skipStartupScripts`             | Skip Netbox startup Scripts                                                               | `true`                                                  |
| `netbox.secret_key`                     | Secret Key for Netbox to use for Cookies and so forth. Will be autogenerated if empty     | `""`                                                    |
| `netbox.extraConfig`                    | Place to pass Entbox Config in a Configmap                                                | `Check values.yaml`                                     |
| `netbox.extraSecretConfig`              | Place to pass Entbox Config in a Secret                                                   | `Check values.yaml`                                     |
| `persistence.media.enabled`             | Enable Netbox media persistence using PVC                                                 | `true`                                                  |
| `persistence.media.storageClass`        | PVC Storage Class for Netbox media volume                                                 | `nil`                                                   |
| `persistence.media.annotations`         | Persistent Volume Claim annotations Annotations                                           | `{}` (evaluated as a template)                          |
| `persistence.media.accessMode`          | PVC Access Mode for Netbox media volume                                                   | `[ReadWriteOnce]`                                       |
| `persistence.media.size`                | PVC Storage Request for Netbox media volume                                               | `8Gi`                                                   |
| `persistence.media.mountPath`           | The path the volume will be mounted at                                                    | `/opt/netbox/netbox/media`                              |
| `persistence.reports.enabled`           | Enable Netbox reports persistence using PVC                                               | `true`                                                  |
| `persistence.reports.storageClass`      | PVC Storage Class for Netbox reports volume                                               | `nil`                                                   |
| `persistence.reports.annotations`       | Persistent Volume Claim annotations Annotations                                           | `{}` (evaluated as a template)                          |
| `persistence.reports.accessMode`        | PVC Access Mode for Netbox reports volume                                                 | `[ReadWriteOnce]`                                       |
| `persistence.reports.size`              | PVC Storage Request for Netbox reports volume                                             | `8Gi`                                                   |
| `persistence.reports.mountPath`         | The path the volume will be mounted at                                                    | `/opt/netbox/netbox/reports`                            |

### Volume Permissions parameters

| Parameter                              | Description                                                                                                          | Default                                                 |
| -------------------------------------- | -------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------- |
| `volumePermissions.enabled`            | Enable init container that changes the owner and group of the persistent volume(s) mountpoint to `runAsUser:fsGroup` | `false`                                                 |
| `volumePermissions.image.registry`     | Init container volume-permissions image registry                                                                     | `docker.io`                                             |
| `volumePermissions.image.repository`   | Init container volume-permissions image name                                                                         | `bitnami/minideb`                                       |
| `volumePermissions.image.tag`          | Init container volume-permissions image tag                                                                          | `buster`                                                |
| `volumePermissions.image.pullPolicy`   | Init container volume-permissions image pull policy                                                                  | `Always`                                                |
| `volumePermissions.image.pullSecrets`  | Specify docker-registry secret names as an array                                                                     | `[]` (does not add image pull secrets to deployed pods) |
| `volumePermissions.resources.limits`   | Init container volume-permissions resource limits                                                                    | `{}`                                                    |
| `volumePermissions.resources.requests` | Init container volume-permissions resource requests                                                                  | `{}`                                                    |

### Redis<sup>TM</sup> parameters

| Parameter                                 | Description                                                                            | Default          |
| ----------------------------------------- | -------------------------------------------------------------------------------------- | ---------------- |
| `redis.enabled`                           | Deploy Redis<sup>TM</sup> container(s)                                                 | `true`           |
| `redis.usePassword`                       | Use password authentication                                                            | `false`          |
| `redis.password`                          | Password for Redis<sup>TM</sup> authentication - ignored if existingSecret is provided | `nil`            |
| `redis.existingSecret`                    | Name of an existing Kubernetes secret                                                  | `nil`            |
| `redis.existingSecretPasswordKey`         | Name of the key pointing to the password in your Kubernetes secret                     | `redis-password` |
| `redis.cluster.enabled`                   | Whether to use cluster replication                                                     | `false`          |
| `redis.master.persistence.enabled`        | Enable database persistence using PVC                                                  | `true`           |
| `externalRedis.host`                      | Host of the external database                                                          | `""`             |
| `externalRedis.port`                      | Database port number                                                                   | `6379`           |
| `externalRedis.password`                  | Password for the external Redis<sup>TM</sup>                                           | `nil`            |
| `externalRedis.existingSecret`            | Name of an existing Kubernetes secret                                                  | `nil`            |
| `externalRedis.existingSecretPasswordKey` | Name of the key pointing to the password in your Kubernetes secret                     | `redis-password` |

### Database parameters

| Parameter                                     | Description                                                                                                                                      | Default                                        |
| --------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------ | ---------------------------------------------- |
| `postgresql.enabled`                          | Deploy PostgreSQL container(s)                                                                                                                   | `true`                                         |
| `postgresql.postgresqlUsername`               | PostgreSQL user to create (used by Netbox)                                                                                                       | `bn_Netbox`                                    |
| `postgresql.postgresqlPassword`               | Password for the Dicourse user - ignored if existingSecret is provided                                                                           | _random 10 character long alphanumeric string_ |
| `postgresql.postgresqlPostgresPassword`       | Password for the admin user ("postgres") - ignored if existingSecret is provided                                                                 | `bitnami`                                      |
| `postgresql.existingSecret`                   | Name of an existing Kubernetes secret. The secret must have the following keys configured: `postgresql-postgres-password`, `postgresql-password` | `nil`                                          |
| `postgresql.postgresqlDatabase`               | Name of the database to create                                                                                                                   | `bitnami_application`                          |
| `postgresql.persistence.enabled`              | Enable database persistence using PVC                                                                                                            | `true`                                         |
| `externalDatabase.host`                       | Host of the external database                                                                                                                    | `""`                                           |
| `externalDatabase.port`                       | Database port number (when using an external db)                                                                                                 | `5432`                                         |
| `externalDatabase.user`                       | PostgreSQL username (when using an external db)                                                                                                  | `bn_Netbox`                                    |
| `externalDatabase.password`                   | Password for the above username (when using an external db)                                                                                      | `""`                                           |
| `externalDatabase.postgresqlPostgresUser`     | PostgreSQL admin user, used during the installation stage (when using an external db)                                                            | `""`                                           |
| `externalDatabase.postgresqlPostgresPassword` | Password for PostgreSQL admin user (when using an external db)                                                                                   | `""`                                           |
| `externalDatabase.existingSecret`             | Name of an existing Kubernetes secret. The secret must have the following keys configured: `postgresql-postgres-password`, `postgresql-password` | `nil`                                          |
| `externalDatabase.database`                   | Name of the existing database (when using an external db)                                                                                        | `bitnami_application`                          |

The above parameters map to the env variables defined in [bitnami/netbox](http://github.com/bitnami/bitnami-docker-netbox) and into config files. For more information please refer to the [bitnami/netbox](http://github.com/bitnami/bitnami-docker-netbox) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install my-release \
  --set netbox.superuser_name=admin,netbox.superuser_password=secretpassword,postgresql.postgresqlPassword=secretdbpassword \
    bitnami/netbox
```

The above command sets the Netbox `admin` account password to `secretpassword`. Additionally it sets the password for the database to `secretdbpassword`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install my-release -f values.yaml bitnami/netbox
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Change Netbox version

To modify the Netbox version used in this chart you can specify a [valid image tag](https://hub.docker.com/r/bitnami/netbox/tags/) using the `image.tag` parameter. For example, `image.tag=X.Y.Z`. This approach is also applicable to other images like exporters.

### Sidecars and Init Containers

If you have a need for additional containers to run within the same pod as Netbox, you can do so via the `sidecars` config parameter. Simply define your container according to the Kubernetes container spec.

```yaml
sidecars:
  - name: your-image-name
    image: your-image
    imagePullPolicy: Always
    ports:
      - name: portname
       containerPort: 1234
```

Similarly, you can add extra init containers using the `initContainers` parameter.

```yaml
initContainers:
  - name: your-image-name
    image: your-image
    imagePullPolicy: Always
    ports:
      - name: portname
        containerPort: 1234
```

## Persistence

### Media

The [Bitnami Netbox](https://github.com/bitnami/bitnami-docker-netbox) image stores the Netbox media data at the `/opt/netbox/netbox/media` path of the container.

The chart mounts a [Persistent Volume](https://kubernetes.io/docs/user-guide/persistent-volumes/) volume at this location. The volume is created using dynamic volume provisioning by default. An existing PersistentVolumeClaim can also be defined for this purpose.

### Reports

The [Bitnami Netbox](https://github.com/bitnami/bitnami-docker-netbox) image stores the Netbox reports at the `/opt/netbox/netbox/reports` path of the container.

The chart mounts a [Persistent Volume](https://kubernetes.io/docs/user-guide/persistent-volumes/) volume at this location. The volume is created using dynamic volume provisioning by default. An existing PersistentVolumeClaim can also be defined for this purpose.

## Pod affinity

This chart allows you to set your custom affinity using the `XXX.affinity` parameter(s). Find more information about Pod affinity in the [Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `XXX.podAffinityPreset`, `XXX.podAntiAffinityPreset`, or `XXX.nodeAffinityPreset` parameters.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami’s Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).
