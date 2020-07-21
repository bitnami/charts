# EJBCA

[EJBCA](https://www.ejbca.org/) is a free software public key infrastructure certificate authority software package.

## TL;DR;

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/ejbca
```

## Introduction

This chart bootstraps a [EJBCA](https://www.ejbca.org/) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages [Bitnami MariaDB](https://github.com/bitnami/charts/tree/master/bitnami/mariadb) as the required databases for the EJBCA application.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.12+
- Helm 2.11+ or Helm 3.0-beta3+
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install my-release bitnami/ejbca
```

The command deploys EJBCA on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

The following table lists the configurable parameters of the EJBCA chart and their default values.

 Parameter                                  | Description                                                                           | Default                                                      |
|-------------------------------------------|---------------------------------------------------------------------------------------|--------------------------------------------------------------|
| `global.imageRegistry`                    | Global Docker image registry                                                          | `nil`                                                        |
| `global.imagePullSecrets`                 | Global Docker registry secret names as an array                                       | `[]` (does not add image pull secrets to deployed pods)      |
| `global.storageClass`                     | Global storage class for dynamic provisioning                                         | `nil`                                                        |

### Common & Pod-specific parameters

| Parameter                                 | Description                                                                           | Default                                                      |
|-------------------------------------------|---------------------------------------------------------------------------------------|--------------------------------------------------------------|
| `image.registry`                          | EJBCA image registry                                                                  | `docker.io`                                                  |
| `image.repository`                        | EJBCA image name                                                                      | `bitnami/ejbca`                                              |
| `image.tag`                               | EJBCA image tag                                                                       | `{TAG_NAME}`                                                 |
| `image.pullPolicy`                        | EJBCA image pull policy                                                               | `IfNotPresent`                                               |
| `image.pullSecrets`                       | Specify docker-registry secret names as an array                                      | `[]` (does not add image pull secrets to deployed pods)      |
| `nameOverride`                            | String to partially override discourse.fullname                                       | `nil`                                                        |
| `fullnameOverride`                        | String to fully override discourse.fullname                                           | `nil`                                                        |
| `replicaCount`                            | Number of EJBCA replicas                                                              | `1`                                                          |
| `extraVolumes`                            | Array of extra volumes to be added deployment. Requires setting `extraVolumeMounts`   | `[]` (evaluated as a template)                               |
| `podAnnotations`                          | Additional pod annotations                                                            | `{}`                                                         |
| `podLabels`                               | Additional pod labels                                                                 | `{}` (evaluated as a template)                               |
| `commonAnnotations`                       | Annotations to be added to all deployed resources                                     | `{}` (evaluated as a template)                               |
| `podSecurityContext.enabled`              | Enable security context for EJBCA pods                                                | `true`                                                       |
| `podSecurityContext.fsGroup`              | Group ID for the volumes of the pod                                                   | `1001`                                                       |
| `nodeSelector`                            | Node labels for pod assignment.                                                       | `{}` (evaluated as a template)                               |
| `tolerations`                             | Tolerations for pod assignment.                                                       | `[]` (evaluated as a template)                               |
| `affinity`                                | Affinity for pod assignment                                                           | `{}` (evaluated as a template)                               |
| `sidecars`                                | Attach additional sidecar containers to the pod                                       | `[]` (evaluated as a template)                               |
| `initContainers`                          | Additional init containers to add to the pods                                         | `[]` (evaluated as a template)                               |
| `persistence.enabled`                     | Whether to enable persistence based on Persistent Volume Claims                       | `true`                                                       |
| `persistence.storageClass`                | PVC Storage Class                                                                     | `nil`                                                        |
| `persistence.existingClaim`               | Name of an existing PVC to reuse                                                      | `nil`                                                        |
| `persistence.accessMode`                  | PVC Access Mode (RWO, ROX, RWX)                                                       | `ReadWriteOnce`                                              |
| `persistence.size`                        | Size of the PVC to request                                                            | `2Gi`                                                        |

### Service parameters

| Parameter                                 | Description                                                                           | Default                                                      |
|-------------------------------------------|---------------------------------------------------------------------------------------|--------------------------------------------------------------|
| `service.type`                            | Kubernetes Service type                                                               | `LoadBalancer`                                               |
| `service.port`                            | Service HTTP port                                                                     | `8080`                                                       |
| `service.httpsPort`                       | Service HTTPS port                                                                    | `8443`                                                       |
| `service.httpsTargetPort`                 | Service Target HTTPS port                                                             | `https`                                                      |
| `service.nodePorts.http`                  | Kubernetes http node port                                                             | `""`                                                         |
| `service.nodePorts.https`                 | Kubernetes https node port                                                            | `""`                                                         |
| `service.externalTrafficPolicy`           | Enable client source IP preservation                                                  | `Cluster`                                                    |
| `service.annotations`                     | Service annotations                                                                   | `{}` (evaluated as a template)                               |
| `service.loadBalancerSourceRanges`        | Restricts access for LoadBalancer (only with `service.type: LoadBalancer`)            | `[]`                                                         |
| `service.extraPorts`                      | Extra ports to expose in the service (normally used with the `sidecar` value)         | `nil`                                                        |

### EJBCA parameters

| Parameter                                 | Description                                                                           | Default                                                      |
|-------------------------------------------|---------------------------------------------------------------------------------------|--------------------------------------------------------------|
| `ejbcaAdminUsername`                      | EJBCA administrator username                                                          | `bitnami`                                                    |
| `ejbcaAdminPassword`                      | EJBCA administrator password                                                          | _random 10 character long alphanumeric string_               |
| `existingSecret`                          | Name of an existing secret containing EJBCA admin password ('ejbca-admin-password' key) | `nil`                                                      |
| `ejbcaJavaOpts`                           | Options used to launch the WildFly server                                             | `nil`                                                        |
| `ejbcaHttpsServerHostname`                | Hostname of the server when using HTTPS                                               | `hostname`                                                   |
| `ejbcaCA.name`                            | Name of the CA EJBCA will instantiate by default                                      | `ManagementCA`                                               |
| `ejbcaCA.baseDN`                          | Base DomainName of the CA EJBCA will instantiate by default                           | `nil`                                                        |
| `ejbcaKeystoreExistingSecret`             | Existing Secret containing a Keystore to be imported by EBJCA                         | `nil`                                                        |
| `extraEnvVars`                            | An array to add extra env vars                                                        | `[]` (evaluated as a template)                               |
| `command`                                 | Custom command to override image cmd                                                  | `nil` (evaluated as a template)                              |
| `args`                                    | Custom args for the custom commad                                                     | `nil` (evaluated as a template)                              |
| `extraVolumeMounts`                       | Additional volume mounts (used along with `extraVolumes`)                             | `[]` (evaluated as a template)                               |
| `resources`                               | EJBCA container's resource requests and limits                                        | `{}`                                                         |
| `podSecurityContext.enabled`              | Enable security context for EJBCA container                                           | `true`                                                       |
| `podSecurityContext.runAsUser`            | User ID for the EJBCA container                                                       | `1001`                                                       |
| `livenessProbe.enabled`                   | Enable/disable livenessProbe                                                          | `true`                                                       |
| `livenessProbe.initialDelaySeconds`       | Delay before liveness probe is initiated                                              | `500`                                                        |
| `livenessProbe.periodSeconds`             | How often to perform the probe                                                        | `10`                                                         |
| `livenessProbe.timeoutSeconds`            | When the probe times out                                                              | `5`                                                          |
| `livenessProbe.failureThreshold`          | Minimum consecutive failures for the probe                                            | `6`                                                          |
| `livenessProbe.successThreshold`          | Minimum consecutive successes for the probe                                           | `1`                                                          |
| `readinessProbe.enabled`                  | Enable/disable readinessProbe                                                         | `true`                                                       |
| `readinessProbe.initialDelaySeconds`      | Delay before readiness probe is initiated                                             | `500`                                                        |
| `readinessProbe.periodSeconds`            | How often to perform the probe                                                        | `10`                                                         |
| `readinessProbe.timeoutSeconds`           | When the probe times out                                                              | `5`                                                          |
| `readinessProbe.failureThreshold`         | Minimum consecutive failures for the probe                                            | `6`                                                          |
| `readinessProbe.successThreshold`         | Minimum consecutive successes for the probe                                           | `1`                                                          |
| `customLivenessProbe`                     | Custom liveness probe to execute (when the main one is disabled)                      | `{}` (evaluated as a template)                               |
| `customReadinessProbe`                    | Custom readiness probe to execute (when the main one is disabled)                     | `{}` (evaluated as a template)                               |
| `containerPorts.http`                     | Port to open for HTTP traffic in EJBCA                                                | `8080`                                                       |
| `containerPorts.https`                    | Port to open for HTTPS traffic in EJBCA                                               | `8443`                                                       |
| `extraEnvVarsCM`                          | Array to add extra configmaps                                                         | `[]`                                                         |
| `extraEnvVarsSecret`                      | Array to add extra environment from a Secret                                          | `nil`                                                        |

### Database parameters

| Parameter                                 | Description                                                                           | Default                                                      |
|-------------------------------------------|---------------------------------------------------------------------------------------|--------------------------------------------------------------|
| `mariadb.enabled`                         | Deploy MariaDB container(s)                                                           | `true`                                                       |
| `mariadb.rootUser.password`               | MariaDB admin password                                                                | `nil`                                                        |
| `mariadb.db.name`                         | Database name to create                                                               | `bitnami_ejbca`                                              |
| `mariadb.db.user`                         | Database user to create                                                               | `bn_ejbca`                                                   |
| `mariadb.db.password`                     | Password for the database                                                             | _random 10 character long alphanumeric string_               |
| `mariadb.existingSecret`                  | Use existing secret for password details (`rootUser.password`, `db.password`, `replication.password` will be ignored and picked up from this secret) See [ref](https://github.com/bitnami/charts/tree/master/bitnami/mariadb)                                                                                         | `nil`                                                        |
| `mariadb.replication.enabled`             | MariaDB replication enabled                                                           | `false`                                                      |
| `mariadb.master.persistence.enabled`      | Enable database persistence using PVC                                                 | `true`                                                       |
| `mariadb.master.persistence.accessModes`  | Database Persistent Volume Access Modes                                               | `[ReadWriteOnce]`                                            |
| `mariadb.master.persistence.size`         | Database Persistent Volume Size                                                       | `8Gi`                                                        |
| `externalDatabase.host`                   | Host of the external database                                                         | `localhost`                                                  |
| `externalDatabase.user`                   | Existing username in the external db                                                  | `bn_ejbca`                                                   |
| `externalDatabase.password`               | Password for the above username                                                       | `nil`                                                        |
| `externalDatabase.existingSecret`         | Name of an existing secret resource containing the DB password in a 'mariadb-password' key | `nil`                                                   |
| `externalDatabase.database`               | Name of the existing database                                                         | `bitnami_ejbca`                                              |
| `externalDatabase.port`                   | Database port number                                                                  | `3306`                                                       |

The above parameters map to the env variables defined in [bitnami/ejbca](http://github.com/bitnami/bitnami-docker-ejbca). For more information please refer to the [bitnami/ejbca](http://github.com/bitnami/bitnami-docker-ejbca) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install my-release \
  --set ejbcaAdminUsername=admin,ejbcaAdminPassword=password,mariadb.db.password=secretpassword \
    bitnami/discourse
```

The above command sets the EJBCA administrator account username and password to `admin` and `password` respectively. Additionally, it sets the MariaDB `bn_ejbca` user password to `secretpassword`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install my-release -f values.yaml bitnami/ejbca
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Setting up replication

By default, this Chart only deploys a single pod running EJBCA. Should you want to increase the number of replicas, you may follow these simple steps to ensure everything works smoothly:

1. Create a conventional release with only one replica, that will be scaled later.
2. Wait for the release to complete and EJBCA to be running successfully. You may verify you have access to the main page in order to do this.
3. Perform an upgrade specifying the number of replicas and the credentials that were previously used. Set the parameters `replicaCount`, `ejbcaAdminPassword` and `mariadb.db.password` accordingly.

For example, for a release using `secretPassword` and `dbPassword` to scale up to a total of `2` replicas, the aforementioned parameters should hold these values `replicaCount=2`, `ejbcaAdminPassword=secretPassword`, `mariadb.db.password=dbPassword`.

> **Tip**: You can modify the file [values.yaml](values.yaml)

### Sidecars

If you have a need for additional containers to run within the same pod as EJBCA (e.g. metrics or logging exporter), you can do so via the `sidecars` config parameter. Simply define your container according to the Kubernetes container spec.

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

Sometimes you may want to have EJBCA connect to an external database rather than installing one inside your cluster, e.g. to use a managed database service, or use run a single database server for all your applications. To do this, the chart allows you to specify credentials for an external database under the [`externalDatabase` parameter](#parameters). You should also disable the MariaDB installation with the `mariadb.enabled` option. For example with the following parameters:

```console
mariadb.enabled=false
externalDatabase.host=myexternalhost
externalDatabase.user=myuser
externalDatabase.password=mypassword
externalDatabase.database=mydatabase
externalDatabase.port=3306
```

Note also that if you disable MariaDB per above you MUST supply values for the `externalDatabase` connection.

## Persistence

The [Bitnami EJBCA](https://github.com/bitnami/bitnami-docker-discourse) image stores the EJBCA data and configurations at the `/bitnami` path of the container.

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
