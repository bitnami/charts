# Discourse

[Discourse](https://www.discourse.org/) is an open source discussion platform. It can be used as a mailing list, discussion forum, long-form chat room, and more.

## TL;DR;

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/discourse
```

## Introduction

This chart bootstraps a [Discourse](https://www.discourse.org/) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages [Bitnami Postgresql](https://github.com/bitnami/charts/tree/master/bitnami/postgresql) and [Bitnami Redis](https://github.com/bitnami/charts/tree/master/bitnami/redis) which are required as databases for the Discourse application.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.12+
- Helm 2.11+ or Helm 3.0-beta3+
- PV provisioner support in the underlying infrastructure
- ReadWriteMany volumes for deployment scaling

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install my-release bitnami/discourse
```

The command deploys Discourse on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

The following table lists the configurable parameters of the Discourse chart and their default values.

 Parameter                                  | Description                                                                           | Default                                                      |
|-------------------------------------------|---------------------------------------------------------------------------------------|--------------------------------------------------------------|
| `global.imageRegistry`                    | Global Docker image registry                                                          | `nil`                                                        |
| `global.imagePullSecrets`                 | Global Docker registry secret names as an array                                       | `[]` (does not add image pull secrets to deployed pods)      |
| `global.storageClass`                     | Global storage class for dynamic provisioning                                         | `nil`                                                        |

### Common parameters

| Parameter                                 | Description                                                                           | Default                                                      |
|-------------------------------------------|---------------------------------------------------------------------------------------|--------------------------------------------------------------|
| `replicaCount`                            | Number of Discourse & Sidekiq replicas                                                | `1`                                                          |
| `image.registry`                          | Discourse image registry                                                              | `docker.io`                                                  |
| `image.repository`                        | Discourse image name                                                                  | `bitnami/discouse`                                           |
| `image.tag`                               | Discourse image tag                                                                   | `{TAG_NAME}`                                                 |
| `image.pullPolicy`                        | Discourse image pull policy                                                           | `IfNotPresent`                                               |
| `image.debug`                             | Specify if debug logs should be enabled                                               | `false`                                                      |
| `imagePullSecrets`                        | Specify docker-registry secret names as an array                                      | `[]` (does not add image pull secrets to deployed pods)      |
| `nameOverride`                            | String to partially override discourse.fullname                                       | `nil`                                                        |
| `fullnameOverride`                        | String to fully override discourse.fullname                                           | `nil`                                                        |
| `extraVolumes`                            | Array of extra volumes to be added deployment. Requires setting `extraVolumeMounts`   | `[]` (evaluated as a template)                               |
| `sidecars`                                | Attach additional sidecar containers to the pod                                       | `[]` (evaluated as a template)                               |
| `initContainers`                          | Additional init containers to add to the pods                                         | `[]` (evaluated as a template)                               |
| `serviceAccount.create`                   | Whether the service account should be created                                         | `false`                                                      |
| `serviceAccount.annotations`              | Annotations to add to the service account                                             | `{}`                                                         |
| `serviceAccount.name`                     | Name to be used for the service account                                               | `""`                                                         |
| `podSecurityContext`                      | Pod security context specification                                                    | `{}`                                                         |
| `persistence.enabled`                     | Whether to enable persistence based on Persistent Volume Claims                       | `true`                                                       |
| `persistence.storageClass`                | PVC Storage Class                                                                     | `nil`                                                        |
| `persistence.existingClaim`               | Name of an existing PVC to reuse                                                      | `nil`                                                        |
| `persistence.accessMode`                  | PVC Access Mode (RWO, ROX, RWX)                                                       | `ReadWriteOnce`                                              |
| `persistence.size`                        | Size of the PVC to request                                                            | `10Gi`                                                       |
| `podAnnotations`                          | Additional pod annotations                                                            | `{}`                                                         |
| `podLabels`                               | Additional pod labels                                                                 | `{}` (evaluated as a template)                               |
| `commonLabels`                            | Labels to be added to all deployed resources                                          | `{}` (evaluated as a template)                               |
| `commonAnnotations`                       | Annotations to be added to all deployed resources                                     | `{}` (evaluated as a template)                               |
| `nodeSelector`                            | Node labels for pod assignment.                                                       | `{}` (evaluated as a template)                               |
| `tolerations`                             | Tolerations for pod assignment.                                                       | `[]` (evaluated as a template)                               |
| `affinity`                                | Affinity for pod assignment                                                           | `{}` (evaluated as a template)                               |

### Service parameters

| Parameter                                 | Description                                                                           | Default                                                      |
|-------------------------------------------|---------------------------------------------------------------------------------------|--------------------------------------------------------------|
| `service.type`                            | Kubernetes Service type                                                               | `LoadBalancer`                                               |
| `service.port`                            | Service HTTP port                                                                     | `80`                                                         |
| `service.nodePort`                        | NodePort service IP address                                                           | `nil`                                                        |
| `service.loadBalancerIP`                  | LoadBalancer service IP address                                                       | `nil`                                                        |
| `service.externalTrafficPolicy`           | Enable client source IP preservation                                                  | `Cluster`                                                    |
| `service.annotations`                     | Service annotations                                                                   | `{}` (evaluated as a template)                               |
| `service.loadBalancerSourceRanges`        | Restricts access for LoadBalancer (only with `service.type: LoadBalancer`)            | `[]`                                                         |
| `service.extraPorts`                      | Extra ports to expose in the service (normally used with the `sidecar` value)         | `nil`                                                        |
| `service.nodePorts.http`                  | Kubernetes http node port                                                             | `""`                                                         |

### Discourse parameters

| Parameter                                 | Description                                                                           | Default                                                      |
|-------------------------------------------|---------------------------------------------------------------------------------------|--------------------------------------------------------------|
| `discourse.host`                          | Discourse host to create application URLs (include the port if =/= 80)                | `""`                                                         |
| `discourse.siteName`                      | Discourse site name                                                                   | `My Site!`                                                   |
| `discourse.username`                      | Admin user of the application                                                         | `user`                                                       |
| `discourse.password`                      | Application password (min length of 10 chars)                                         | _random 10 character long alphanumeric string_               |
| `discourse.email`                         | Admin user email of the application                                                   | `user@example.com`                                           |
| `discourse.command`                       | Custom command to override image cmd                                                  | `nil` (evaluated as a template)                              |
| `discourse.args`                          | Custom args for the custom commad                                                     | `nil` (evaluated as a template)                              |
| `discourse.containerSecurityContext`      | Container security context specification                                              | `{}`                                                         |
| `discourse.resources`                     | Discourse container's resource requests and limits                                    | `{}`                                                         |
| `discourse.livenessProbe.enabled`         | Enable/disable livenessProbe                                                          | `true`                                                       |
| `discourse.livenessProbe.initialDelaySeconds`| Delay before liveness probe is initiated                                           | `500`                                                        |
| `discourse.livenessProbe.periodSeconds`   | How often to perform the probe                                                        | `10`                                                         |
| `discourse.livenessProbe.timeoutSeconds`  | When the probe times out                                                              | `5`                                                          |
| `discourse.livenessProbe.failureThreshold`| Minimum consecutive failures for the probe                                            | `6`                                                          |
| `discourse.livenessProbe.successThreshold`| Minimum consecutive successes for the probe                                           | `1`                                                          |
| `discourse.readinessProbe.enabled`        | Enable/disable readinessProbe                                                         | `true`                                                       |
| `discourse.readinessProbe.initialDelaySeconds`| Delay before readiness probe is initiated                                         | `30`                                                         |
| `discourse.readinessProbe.periodSeconds`  | How often to perform the probe                                                        | `10`                                                         |
| `discourse.readinessProbe.timeoutSeconds` | When the probe times out                                                              | `5`                                                          |
| `discourse.readinessProbe.failureThreshold`| Minimum consecutive failures for the probe                                           | `6`                                                          |
| `discourse.readinessProbe.successThreshold`| Minimum consecutive successes for the probe                                          | `1`                                                          |
| `discourse.customLivenessProbe`           | Custom liveness probe to execute (when the main one is disabled)                      | `{}` (evaluated as a template)                               |
| `discourse.customReadinessProbe`          | Custom readiness probe to execute (when the main one is disabled)                     | `{}` (evaluated as a template)                               |
| `discourse.extraEnvVars`                  | An array to add extra env vars                                                        | `[]` (evaluated as a template)                               |
| `discourse.extraEnvVarsCM`                | Array to add extra configmaps                                                         | `[]`                                                         |
| `discourse.extraEnvVarsSecret`            | Array to add extra environment from a Secret                                          | `nil`                                                        |
| `discourse.extraVolumeMounts`             | Additional volume mounts (used along with `extraVolumes`)                             | `[]` (evaluated as a template)                               |
| `discourse.skipInstall`                   | Do not run the Discourse installation wizard                                          | `false`                                                      |

### Sidekiq parameters

| Parameter                                 | Description                                                                           | Default                                                      |
|-------------------------------------------|---------------------------------------------------------------------------------------|--------------------------------------------------------------|
| `sidekiq.containerSecurityContext`        | Container security context specification                                              | `{}`                                                         |
| `sidekiq.command`                         | Custom command to override image cmd (evaluated as a template)                        | `["/app-entrypoint.sh"]`                                     |
| `sidekiq.args`                            | Custom args for the custom commad (evaluated as a template)                           | `["nami", "start", "--foreground", "discourse-sidekiq"`      |
| `sidekiq.resources`                       | Sidekiq container's resource requests and limits                                      | `{}`                                                         |
| `sidekiq.livenessProbe.enabled`           | Enable/disable livenessProbe                                                          | `true`                                                       |
| `sidekiq.livenessProbe.initialDelaySeconds`| Delay before liveness probe is initiated                                             | `500`                                                        |
| `sidekiq.livenessProbe.periodSeconds`     | How often to perform the probe                                                        | `10`                                                         |
| `sidekiq.livenessProbe.timeoutSeconds`    | When the probe times out                                                              | `5`                                                          |
| `sidekiq.livenessProbe.failureThreshold`  | Minimum consecutive failures for the probe                                            | `6`                                                          |
| `sidekiq.livenessProbe.successThreshold`  | Minimum consecutive successes for the probe                                           | `1`                                                          |
| `sidekiq.readinessProbe.enabled`          | Enable/disable readinessProbe                                                         | `true`                                                       |
| `sidekiq.readinessProbe.initialDelaySeconds`| Delay before readiness probe is initiated                                           | `30`                                                         |
| `sidekiq.readinessProbe.periodSeconds`    | How often to perform the probe                                                        | `10`                                                         |
| `sidekiq.readinessProbe.timeoutSeconds`   | When the probe times out                                                              | `5`                                                          |
| `sidekiq.readinessProbe.failureThreshold` | Minimum consecutive failures for the probe                                            | `6`                                                          |
| `sidekiq.readinessProbe.successThreshold` | Minimum consecutive successes for the probe                                           | `1`                                                          |
| `sidekiq.customLivenessProbe`             | Custom liveness probe to execute (when the main one is disabled)                      | `{}` (evaluated as a template)                               |
| `sidekiq.customReadinessProbe`            | Custom readiness probe to execute (when the main one is disabled)                     | `{}` (evaluated as a template)                               |
| `sidekiq.extraEnvVars`                    | An array to add extra env vars                                                        | `[]` (evaluated as a template)                               |
| `sidekiq.extraEnvVarsCM`                  | Array to add extra configmaps                                                         | `[]`                                                         |
| `sidekiq.extraEnvVarsSecret`              | Array to add extra environment from a Secret                                          | `nil`                                                        |
| `discourse.extraVolumeMounts`             | Additional volume mounts (used along with `extraVolumes`)                             | `[]` (evaluated as a template)                               |

### Ingress parameters

| Parameter                                 | Description                                                                           | Default                                                      |
|-------------------------------------------|---------------------------------------------------------------------------------------|--------------------------------------------------------------|
| `ingress.enabled`                         | Enable ingress controller resource                                                    | `false`                                                      |
| `ingress.certManager`                     | Add annotations for cert-manager                                                      | `false`                                                      |
| `ingress.hostname`                        | Default host for the ingress resource                                                 | `discourse.local`                                            |
| `ingress.tls`                             | Create TLS Secret                                                                     | `false`                                                      |
| `ingress.annotations`                     | Ingress annotations                                                                   | `{}` (evaluated as a template)                               |
| `ingress.extraHosts[0].name`              | Additional hostnames to be covered                                                    | `nil`                                                        |
| `ingress.extraHosts[0].path`              | Additional hostnames to be covered                                                    | `nil`                                                        |
| `ingress.extraTls[0].hosts[0]`            | TLS configuration for additional hostnames to be covered                              | `nil`                                                        |
| `ingress.extraTls[0].secretName`          | TLS configuration for additional hostnames to be covered                              | `nil`                                                        |
| `ingress.secrets[0].name`                 | TLS Secret Name                                                                       | `nil`                                                        |
| `ingress.secrets[0].certificate`          | TLS Secret Certificate                                                                | `nil`                                                        |
| `ingress.secrets[0].key`                  | TLS Secret Key                                                                        | `nil`                                                        |

### Database parameters

| Parameter                                 | Description                                                                           | Default                                                      |
|-------------------------------------------|---------------------------------------------------------------------------------------|--------------------------------------------------------------|
| `postgresql.enabled`                      | Deploy PostgreSQL container(s)                                                        | `true`                                                       |
| `postgresql.postgresqlUsername`           | PostgreSQL user to create (used by Discourse)                                         | `bn_discourse`                                               |
| `postgresql.postgresqlPassword`           | Password for the Dicourse user                                                        | _random 10 character long alphanumeric string_               |
| `postgresql.postgresqlPostgresPassword`   | Password for the admin user ("postgres")                                              | `bitnami`                                                    |
| `postgresql.postgresqlDatabase`           | Name of the database to create                                                        | `bitnami_application`                                        |
| `postgresql.persistence.enabled`          | Enable database persistence using PVC                                                 | `true`                                                       |
| `externalDatabase.host`                   | Host of the external database                                                         | `""`                                                         |
| `externalDatabase.port`                   | Database port number                                                                  | `5432`                                                       |
| `externalDatabase.user`                   | Existing username in the external db                                                  | `bn_discourse`                                               |
| `externalDatabase.password`               | Password for the above username                                                       | `""`                                                         |
| `externalDatabase.postgresqlPostgresPassword`| Password for the root "postgres" user (used in the installation stage)             | `""`                                                         |
| `externalDatabase.database`               | Name of the existing database                                                         | `bitnami_application`                                        |

### Redis parameters

| Parameter                                 | Description                                                                           | Default                                                      |
|-------------------------------------------|---------------------------------------------------------------------------------------|--------------------------------------------------------------|
| `redis.enabled`                           | Deploy Redis container(s)                                                             | `true`                                                       |
| `redis.usePassword`                       | Use password authentication                                                           | `false`                                                      |
| `redis.password`                          | Password for Redis authentication                                                     | `nil`                                                        |
| `redis.cluster.enabled`                   | Whether to use cluster replication                                                    | `false`                                                      |
| `redis.master.persistence.enabled`        | Enable database persistence using PVC                                                 | `true`                                                       |
| `externalRedis.host`                      | Host of the external database                                                         | `""`                                                         |
| `externalRedis.port`                      | Database port number                                                                  | `6379`                                                       |
| `externalRedis.password`                  | Password for the above username                                                       | `nil`                                                        |

The above parameters map to the env variables defined in [bitnami/discourse](http://github.com/bitnami/bitnami-docker-discourse). For more information please refer to the [bitnami/discourse](http://github.com/bitnami/bitnami-docker-discourse) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install my-release \
  --set discourse.username=admin,discourse.password=password,postgresql.postgresqlPassword=secretpassword \
    bitnami/discourse
```

The above command sets the Discourse administrator account username and password to `admin` and `password` respectively. Additionally, it sets the Postgresql `bn_discourse` user password to `secretpassword`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install my-release -f values.yaml bitnami/discourse
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Setting up replication

By default, this Chart only deploys a single pod running Discourse. Should you want to increase the number of replicas, you may follow these simple steps to ensure everything works smoothly:

> **Tip**: Running these steps ensures the PostgreSQL instance is correctly populated. If you already have an initialised DB, you may directly create a release with the desired number of replicas. Remind to set `discourse.skipInstall` to `true`!

1. Create a conventional release, that will be scaled later:
```console
$ helm install my-release bitnami/discourse
...
export APP_PASSWORD=$(kubectl get secret --namespace default my-release-discourse -o jsonpath="{.data.discourse-password}" | base64 --decode)
export APP_DATABASE_PASSWORD=$(kubectl get secret --namespace default my-release-postgresql -o jsonpath="{.data.postgresql-password}" | base64 --decode)
...
```

2. Wait for the release to complete and Discourse to be running successfully.
```console
$ kubectl get pods
NAME                               READY   STATUS    RESTARTS   AGE
my-release-discourse-744c48dd97-wx5h9   2/2     Running   0          5m11s
my-release-postgresql-0                 1/1     Running   0          5m10s
my-release-redis-master-0               1/1     Running   0          5m11s
```

3. Perform an upgrade specifying the number of replicas and the credentials used.
```console
$ helm upgrade my-release --set replicaCount=2,discourse.password=$APP_PASSWORD,postgresql.postgresqlPassword=$APP_DATABASE_PASSWORD,discourse.skipInstall=true bitnami/discourse
```

Note that for this to work properly, you need to provide ReadWriteMany PVCs. If you don't have a provisioner for this type of storage, we recommend that you install the NFS provisioner chart (with the correct parameters, such as `persistence.enabled=true` and `persistence.size=10Gi`) and map it to a RWO volume.

Then you can deploy Discourse chart using the proper parameters:

```console
persistence.storageClass=nfs
postgresql.persistence.storageClass=nfs
```

### Production configuration

This chart includes a `values-production.yaml` file where you can find some parameters oriented to production configuration in comparison to the regular `values.yaml`. You can use this file instead of the default one.

- Enable client source IP preservation:

```diff
- service.externalTrafficPolicy: Cluster
+ service.externalTrafficPolicy: Local
```

- Make Redis use password for auth:

```diff
- redis.usePassword: false
+ redis.usePassword: true
```

- PVC Access Mode:

```diff
- persistence.accessMode: ReadWriteOnce
+ ## To use the portal and to ensure you can scale Discourse you need to provide a
+ ## ReadWriteMany PVC, if you dont have a provisioner for this type of storage
+ ## We recommend that you install the nfs provisioner and map it to a RWO volume
+ ## helm install nfs-server stable/nfs-server-provisioner --set persistence.enabled=true,persistence.size=10Gi
+ ##
+ persistence.accessMode: ReadWriteMany
```
Note that [values-production.yaml](values-production.yaml) specifies ReadWriteMany PVCs are specified. This is intended to ease the process of replication (see [Setting up replication](#setting-up-replication)).

### Sidecars

If you have a need for additional containers to run within the same pod as Discourse (e.g. metrics or logging exporter), you can do so via the `sidecars` config parameter. Simply define your container according to the Kubernetes container spec.

```yaml
sidecars:
- name: your-image-name
  image: your-image
  imagePullPolicy: Always
  ports:
  - name: portname
   containerPort: 1234
```

If these sidecars export extra ports, you can add extra port definitions using the `service.extraPorts` value:

```yaml
service:
...
  extraPorts:
  - name: extraPort
    port: 11311
    targetPort: 11311
```

### Using an external database

Sometimes you may want to have Discourse connect to an external database rather than installing one inside your cluster, e.g. to use a managed database service, or use run a single database server for all your applications. To do this, the chart allows you to specify credentials for an external database under the [`externalDatabase` parameter](#parameters). You should also disable the PostgreSQL installation with the `postgresql.enabled` option. For example with the following parameters:

```console
postgresql.enabled=false
externalDatabase.host=myexternalhost
externalDatabase.user=myuser
externalDatabase.password=mypassword
externalDatabase.postgresqlPostgresPassword=rootpassword
externalDatabase.database=mydatabase
externalDatabase.port=5432
```

Note also that if you disable PostgreSQL per above you MUST supply values for the `externalDatabase` connection.

In case the database already contains data from a previous Discourse installation, you need to set the `discourse.skipInstall` parameter to _true_. Otherwise, the container would execute the installation wizard and could modify the existing data in the database. This parameter force the container to not execute the Discourse installation wizard.

Similarly, you can specify an external Redis instance rather than installing one inside your cluster. First, you may disable the Redis installation with the `redis.enabled` option. As aforementioned, used the provided parameters to provide data about your instance:

```console
redis.enabled=false
externalRedis.host=myexternalhost
externalRedis.password=mypassword
externalRedis.port=5432
```

### Ingress

This chart provides support for ingress resources. If you have an ingress controller installed on your cluster, such as [nginx-ingress](https://kubeapps.com/charts/stable/nginx-ingress) or [traefik](https://kubeapps.com/charts/stable/traefik) you can utilize the ingress controller to serve your Discourse application.

To enable ingress integration, please set `ingress.enabled` to `true`

### Hosts

Most likely you will only want to have one hostname that maps to this Discourse installation. If that's your case, the property `ingress.hostname` will set it. However, it is possible to have more than one host. To facilitate this, the `ingress.extraHosts` object can be specified as an array.

For each host indicated at `ingress.extraHosts`, please indicate a `name`, `path`, and any `annotations` that you may want the ingress controller to know about.

The actual TLS secret do not have to be generated by this chart. However, please note that if TLS is enabled, the ingress record will not work until this secret exists.

For annotations, please see [this document](https://github.com/kubernetes/ingress-nginx/blob/master/docs/user-guide/nginx-configuration/annotations.md). Not all annotations are supported by all ingress controllers, but this document does a good job of indicating which annotation is supported by many popular ingress controllers.

### TLS Secrets

This chart will facilitate the creation of TLS secrets for use with the ingress controller, however, this is not required.  There are three common use cases:

- Helm generates/manages certificate secrets
- User generates/manages certificates separately
- An additional tool (like [kube-lego](https://kubeapps.com/charts/stable/kube-lego)) manages the secrets for the application

In the first two cases, one will need a certificate and a key.  We would expect them to look like this:

- certificate files should look like (and there can be more than one certificate if there is a certificate chain)

```console
-----BEGIN CERTIFICATE-----
MIID6TCCAtGgAwIBAgIJAIaCwivkeB5EMA0GCSqGSIb3DQEBCwUAMFYxCzAJBgNV
...
jScrvkiBO65F46KioCL9h5tDvomdU1aqpI/CBzhvZn1c0ZTf87tGQR8NK7v7
-----END CERTIFICATE-----
```

- keys should look like:

```console
-----BEGIN RSA PRIVATE KEY-----
MIIEogIBAAKCAQEAvLYcyu8f3skuRyUgeeNpeDvYBCDcgq+LsWap6zbX5f8oLqp4
...
wrj2wDbCDCFmfqnSJ+dKI3vFLlEz44sAV8jX/kd4Y6ZTQhlLbYc=
-----END RSA PRIVATE KEY-----
```

If you are going to use Helm to manage the certificates, please copy these values into the `certificate` and `key` values for a given `ingress.secrets` entry.

If you are going to manage TLS secrets outside of Helm, please know that you can create a TLS secret (named `discourse.local-tls` for example).

Please see [this example](https://github.com/kubernetes/contrib/tree/master/ingress/controllers/nginx/examples/tls) for more information.

## Persistence

The [Bitnami Discourse](https://github.com/bitnami/bitnami-docker-discourse) image stores the Discourse data and configurations at the `/bitnami` path of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Parameters](#parameters) section to configure the PVC or to disable persistence.

### Image

The `image` parameter allows specifying which image will be pulled for the chart.

#### Private registry

If you configure the `image` value to one in a private registry, you will need to [specify an image pull secret](https://kubernetes.io/docs/concepts/containers/images/#specifying-imagepullsecrets-on-a-pod).

1. Manually create image pull secret(s) in the namespace. See [this YAML example reference](https://kubernetes.io/docs/concepts/containers/images/#creating-a-secret-with-a-docker-config). Consult your image registry's documentation about getting the appropriate secret.
2. Note that the `imagePullSecrets` configuration value cannot currently be passed to helm using the `--set` parameter, so you must supply these using a `values.yaml` file, such as:

```yaml
imagePullSecrets:
  - name: SECRET_NAME
```
3. Install the chart
