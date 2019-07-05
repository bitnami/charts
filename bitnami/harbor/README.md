# Helm Chart for Harbor

This Helm chart has been developed based on [goharbor/harbor-helm](https://github.com/goharbor/harbor-helm) chart but including some features common to the Bitnami chart library.
For example, the following changes have been introduced:

- Possibility to pull all the required images from a private registry through the  Global Docker image parameters.
- Redis and PostgreSQL are managed as chart dependencies.
- Liveness and Readiness probes for all deployments are exposed to the values.yaml.
- Uses new Helm chart labels formating.
- Uses Bitnami container images:
  - non-root by default
  - published for debian-9, ol-7, and eventually centos-7
- At this moment, this chart does not support the Harbor optional component Chartmuseum but it does support Clair and Notary integrations.

## Introduction

This [Helm](https://github.com/kubernetes/helm) chart installs [Harbor](https://github.com/goharbor/harbor) in a Kubernetes cluster. Welcome to [contribute](CONTRIBUTING.md) to Helm Chart for Harbor.

## Prerequisites

- Kubernetes cluster 1.10+
- Helm 2.8.0+

## Installation

### Download the chart

Download Harbor helm chart

```bash
git clone https://github.com/bitnami/charts
```

Change directory to Harbor code

```bash
cd charts/bitnami/harbor
```

### Configure the chart

The following items can be configured in `values.yaml` or set via `--set` flag during installation.

#### Configure the way how to expose Harbor service:

- **Ingress**: The ingress controller must be installed in the Kubernetes cluster.
  **Notes:** if the TLS is disabled, the port must be included in the command when pulling/pushing images. Refer to issue [#5291](https://github.com/goharbor/harbor/issues/5291) for the detail.
- **ClusterIP**: Exposes the service on a cluster-internal IP. Choosing this value makes the service only reachable from within the cluster.
- **NodePort**: Exposes the service on each Node’s IP at a static port (the NodePort). You’ll be able to contact the NodePort service, from outside the cluster, by requesting `NodeIP:NodePort`.
- **LoadBalancer**: Exposes the service externally using a cloud provider’s load balancer.

#### Configure the external URL

The external URL for Harbor core service is used to:

1. populate the docker/helm commands showed on portal
2. populate the token service URL returned to docker/notary client

Format: `protocol://domain[:port]`. Usually:

- if expose the service via `Ingress`, the `domain` should be the value of `service.ingress.hosts.core`
- if expose the service via `ClusterIP`, the `domain` should be the value of `service.clusterIP.name`
- if expose the service via `NodePort`, the `domain` should be the IP address of one Kubernetes node
- if expose the service via `LoadBalancer`, set the `domain` as your own domain name and add a CNAME record to map the domain name to the one you got from the cloud provider

If Harbor is deployed behind the proxy, set it as the URL of proxy.

#### Configure data persistence:

- **Disable**: The data does not survive the termination of a pod.
- **Persistent Volume Claim(default)**: A default `StorageClass` is needed in the Kubernetes cluster to dynamically provision the volumes. Specify another StorageClass in the `storageClass` or set `existingClaim` if you have already existing persistent volumes to use.
- **External Storage(only for images and charts)**: For images and charts, the external storages are supported: `azure`, `gcs`, `s3` `swift` and `oss`.

#### Configure the secrets

- **Secret keys**: Secret keys are used for secure communication between components. Fill `core.secret`, `jobservice.secret` and `registry.secret` to configure.
- **Certificates**: Used for token encryption/decryption. Fill `core.secretName` to configure.

Secrets and certificates must be setup to avoid changes on every Helm upgrade (see: [#107](https://github.com/goharbor/harbor-helm/issues/107)).

#### Configure the other items listed in [configuration](#configuration) section.

### Install the chart

Install the Harbor helm chart with a release name `my-release`:

```bash
helm install --name my-release --set service.tls.commonName=your.domain.com .
```

## Uninstallation

To uninstall/delete the `my-release` deployment:

```bash
helm delete --purge my-release
```

Additionaly, if `persistence.resourcePolicy` is set to `keep`, you should manually delete the PVCs.

## Configuration

The following table lists the configurable parameters of the Harbor chart and the default values.

| Parameter                                                                   | Description                                                              | Default                                                 |
| --------------------------------------------------------------------------- |  ----------------------------------------------------------------------- | ------------------------------------------------------- |
| **Expose**                                                                  |
| `service.type`                                                              | The way how to expose the service: `Ingress`, `ClusterIP`, `NodePort` or `LoadBalancer` | `ingress`                                |
| `service.tls.enabled`                                                       | Enable the tls or not                                                    | `true`                                                  |
| `service.ingress.controller`                                                | The ingress controller type. Currently supports `default` and `gce`      | `default`                                               |
| `service.tls.secretName`                                                    | Fill the name of secret if you want to use your own TLS certificate and private key. The secret must contain two keys named `tls.crt` and `tls.key` that contain the certificate and private key to use for TLS. Will be generated automatically if not set | `nil` |
| `service.tls.notarySecretName`                                              | By default, the Notary service will use the same cert and key as described above. Fill the name of secret if you want to use a separated one. Only needed when the `service.type` is `ingress`. | `nil` |
| `service.tls.commonName`                                                    | The common name used to generate the certificate, it's necessary when the `service.type` is `ClusterIP` or `NodePort` and `service.tls.secretName` is null | `nil` |
| `service.ingress.hosts.core`                                                | The host of Harbor core service in ingress rule                          | `core.harbor.domain`                                    |
| `service.ingress.hosts.notary`                                              | The host of Harbor Notary service in ingress rule                        | `notary.harbor.domain`                                  |
| `service.ingress.annotations`                                               | The annotations used in ingress                                          | `nil`                                                   |
| `service.clusterIP.name`                                                    | The name of ClusterIP service                                            | `harbor`                                                |
| `service.clusterIP.ports.httpPort`                                          | The service port Harbor listens on when serving with HTTP                | `80`                                                    |
| `service.clusterIP.ports.httpsPort`                                         | The service port Harbor listens on when serving with HTTPS               | `443`                                                   |
| `service.clusterIP.ports.notaryPort`                                        | The service port Notary listens on. Only needed when `notary.enabled` is set to `true` | `4443`                                    |
| `service.nodePort.name`                                                     | The name of NodePort service                                             | `harbor`                                                |
| `service.nodePort.ports.http.port`                                          | The service port Harbor listens on when serving with HTTP                | `80`                                                    |
| `service.nodePort.ports.http.nodePort`                                      | The node port Harbor listens on when serving with HTTP                   | `30002`                                                 |
| `service.nodePort.ports.https.port`                                         | The service port Harbor listens on when serving with HTTPS               | `443`                                                   |
| `service.nodePort.ports.https.nodePort`                                     | The node port Harbor listens on when serving with HTTPS                  | `30003`                                                 |
| `service.nodePort.ports.notary.port`                                        | The service port Notary listens on. Only needed when `notary.enabled` is set to `true` | `4443`                                    |
| `service.nodePort.ports.notary.nodePort`                                    | The node port Notary listens on. Only needed when `notary.enabled` is set to `true` | `30004`                                      |
| `service.loadBalancer.name`                                                 | The name of service                                                      | `harbor`                                                |
| `service.loadBalancer.ports.httpPort`                                       | The service port Harbor listens on when serving with HTTP                | `80`                                                    |
| `service.loadBalancer.ports.httpsPort`                                      | The service port Harbor listens on when serving with HTTP                | `30002`                                                 |
| `service.loadBalancer.ports.notaryPort`                                     | The service port Notary listens on. Only needed when `notary.enabled` is set to `true` | `nil`                                     |
| **Persistence**                                                             |
| `persistence.enabled`                                                       | Enable the data persistence or not                                       | `true`                                                  |
| `persistence.resourcePolicy`                                                | Setting it to `keep` to avoid removing PVCs during a helm delete operation. Leaving it empty will delete PVCs after the chart deleted | `keep` |
| `persistence.persistentVolumeClaim.registry.existingClaim`                  | Use the existing PVC which must be created manually before bound, and specify the `subPath` if the PVC is shared with other components | `nil` |
| `persistence.persistentVolumeClaim.registry.storageClass`                   | Specify the `storageClass` used to provision the volume. Or the default StorageClass will be used(the default). Set it to `-` to disable dynamic provisioning | `nil` |
| `persistence.persistentVolumeClaim.registry.subPath`                        | The sub path used in the volume                                          | `nil`                                                   |
| `persistence.persistentVolumeClaim.registry.accessMode`                     | The access mode of the volume                                            | `ReadWriteOnce`                                         |
| `persistence.persistentVolumeClaim.registry.size`                           | The size of the volume                                                   | `5Gi`                                                   |
| `persistence.persistentVolumeClaim.jobservice.existingClaim`                | Use the existing PVC which must be created manually before bound, and specify the `subPath` if the PVC is shared with other components | `nil` |
| `persistence.persistentVolumeClaim.jobservice.storageClass`                 | Specify the `storageClass` used to provision the volume. Or the default StorageClass will be used(the default). Set it to `-` to disable dynamic provisioning | `nil` |
| `persistence.persistentVolumeClaim.jobservice.subPath`                      | The sub path used in the volume                                          | `nil`                                                   |
| `persistence.persistentVolumeClaim.jobservice.accessMode`                   | The access mode of the volume                                            | `ReadWriteOnce`                                         |
| `persistence.persistentVolumeClaim.jobservice.size`                         | The size of the volume                                                   | `1Gi`                                                   |
| `persistence.imageChartStorage.disableredirect`                             | The configuration for managing redirects from content backends. For backends which do not supported it (such as using minio for `s3` storage type), please set it to `true` to disable redirects. Refer to the [guide](https://github.com/docker/distribution/blob/master/docs/configuration.md#redirect) for more information about the detail | `false` |
| `persistence.imageChartStorage.type`                                        | The type of storage for images and charts: `filesystem`, `azure`, `gcs`, `s3`, `swift` or `oss`. The type must be `filesystem` if you want to use persistent volumes for registry and chartmuseum. Refer to the [guide](https://github.com/docker/distribution/blob/master/docs/configuration.md#storage) for more information about the detail | `filesystem` |
| **General**                                                                 |
| `externalURL`                                                               | The external URL for Harbor core service                                 | `https://core.harbor.domain`                            |
| `imagePullPolicy`                                                           | The image pull policy                                                    | `IfNotPresent`                                          |
| `logLevel`                                                                  | The log level                                                            | `debug`                                                 |
| `forcePassword`                                                             | Option to ensure all passwords and keys are set by the user              | `false`                                                 |
| `harborAdminPassword`                                                       | The initial password of Harbor admin. Change it from portal after launching Harbor | `Harbor12345`                                 |
| `secretkey`                                                                 | The key used for encryption. Must be a string of 16 chars                | `not-a-secure-key`                                      |
| **Nginx** (if expose the service via `ingress`, the Nginx will not be used) |
| `nginx.image.repository`                                                    | Image repository                                                         | `goharbor/nginx-photon`                                 |
| `nginx.image.tag`                                                           | Image tag                                                                | `dev`                                                   |
| `nginx.replicas`                                                            | The replica count                                                        | `1`                                                     |
| `nginx.resources`                                                           | The [resources] to allocate for container                                | undefined                                               |
| `nginx.nodeSelector`                                                        | Node labels for pod assignment                                           | `{}` (The value is evaluated as a template)             |
| `nginx.tolerations`                                                         | Tolerations for pod assignment                                           | `[]` (The value is evaluated as a template)             |
| `nginx.affinity`                                                            | Node/Pod affinities                                                      | `{}` (The value is evaluated as a template)             |
| `nginx.podAnnotations`                                                      | Annotations to add to the nginx pod                                      | `{}`                                                    |
| **Portal**                                                                  |
| `portalImage.registry`                                                      | Registry for portal image                                                | `goharbor/harbor-portal`                                |
| `portalImage.repository`                                                    | Repository for portal image                                              | `goharbor/harbor-portal`                                |
| `portalImage.tag`                                                           | Tag for portal image                                                     | `dev`                                                   |
| `portalImage.pullPolicy`                                                    | Harbor Portal image pull policy                                          | `IfNotPresent`                                          |
| `portalImage.pullSecrets`                                                   | Specify docker-registry secret names as an array                         | `[]` (does not add image pull secrets to deployed pods) |
| `portalImage.debug`                                                         | Specify if debug logs should be enabled                                  | `false`                                                 |
| `portal.replicas`                                                           | The replica count                                                        | `1`                                                     |
| `portal.resources`                                                          | The [resources] to allocate for container                                | undefined                                               |
| `portal.nodeSelector`                                                       | Node labels for pod assignment                                           | `{}` (The value is evaluated as a template)             |
| `portal.tolerations`                                                        | Tolerations for pod assignment                                           | `[]` (The value is evaluated as a template)             |
| `portal.affinity`                                                           | Node/Pod affinities                                                      | `{}` (The value is evaluated as a template)             |
| `portal.podAnnotations`                                                     | Annotations to add to the portal pod                                     | `{}`                                                    |
| `portal.livenessProbe`                                                      | Liveness probe configuration for Portal                                  | `Check values.yaml file`                                |
| `portal.readinessProbe`                                                     | Readines probe configuration for Portal                                  | `Check values.yaml file`                                |
| **Core**                                                                    |
| `coreImage.registry`                                                        | Registry for core image                                                  | `goharbor/harbor-portal`                                |
| `coreImage.repository`                                                      | Repository for Harbor core image                                         | `goharbor/harbor-core`                                  |
| `coreImage.tag`                                                             | Tag for Harbor core image                                                | `dev`                                                   |
| `coreImage.pullPolicy`                                                      | Harbor Core image pull policy                                            | `IfNotPresent`                                          |
| `coreImage.pullSecrets`                                                     | Specify docker-registry secret names as an array                         | `[]` (does not add image pull secrets to deployed pods) |
| `coreImage.debug`                                                           | Specify if debug logs should be enabled                                  | `false`                                                 |
| `core.replicas`                                                             | The replica count                                                        | `1`                                                     |
| `core.resources`                                                            | The [resources] to allocate for container                                | undefined                                               |
| `core.nodeSelector`                                                         | Node labels for pod assignment                                           | `{}` (The value is evaluated as a template)             |
| `core.tolerations`                                                          | Tolerations for pod assignment                                           | `[]` (The value is evaluated as a template)             |
| `core.affinity`                                                             | Node/Pod affinities                                                      | `{}` (The value is evaluated as a template)             |
| `core.podAnnotations`                                                       | Annotations to add to the core pod                                       | `{}`                                                    |
| `core.secret`                                                               | Secret used when the core server communicates with other components. If a secret key is not specified, Helm will generate one. Must be a string of 16 chars. | `nil`                                                   |
| `core.secretName`                                                           | Fill the name of a kubernetes secret if you want to use your own TLS certificate and private key for token encryption/decryption. The secret must contain two keys named: `tls.crt` - the certificate and `tls.key` - the private key. The default key pair will be used if it isn't set | `nil` |
| `core.livenessProbe`                                                        | Liveness probe configuration for Core                                    | `Check values.yaml file`                                |
| `core.readinessProbe`                                                       | Readines probe configuration for Core                                    | `Check values.yaml file`                                |
| **Jobservice**                                                              |
| `jobserviceImage.registry`                                                  | Registry for jobservice image                                            | `goharbor/harbor-portal`                                |
| `jobserviceImage.repository`                                                | Repository for jobservice image                                          | `goharbor/harbor-jobservice`                            |
| `jobserviceImage.tag`                                                       | Tag for jobservice image                                                 | `dev`                                                   |
| `jobserviceImage.pullPolicy`                                                | Harbor Jobservice image pull policy                                      | `IfNotPresent`                                          |
| `jobserviceImage.pullSecrets`                                               | Specify docker-registry secret names as an array                         | `[]` (does not add image pull secrets to deployed pods) |
| `jobserviceImage.debug`                                                     | Specify if debug logs should be enabled                                  | `false`                                                 |
| `jobservice.replicas`                                                       | The replica count                                                        | `1`                                                     |
| `jobservice.maxJobWorkers`                                                  | The max job workers                                                      | `10`                                                    |
| `jobservice.jobLogger`                                                      | The logger for jobs: `file`, `database` or `stdout`                      | `file`                                                  |
| `jobservice.resources`                                                      | The [resources] to allocate for container                                | undefined                                               |
| `jobservice.nodeSelector`                                                   | Node labels for pod assignment                                           | `{}` (The value is evaluated as a template)             |
| `jobservice.tolerations`                                                    | Tolerations for pod assignment                                           | `[]` (The value is evaluated as a template)             |
| `jobservice.affinity`                                                       | Node/Pod affinities                                                      | `{}` (The value is evaluated as a template)             |
| `jobservice.podAnnotations`                                                 | Annotations to add to the jobservice pod                                 | `{}`                                                    |
| `jobservice.secret`                                                         | Secret used when the job service communicates with other components. If a secret key is not specified, Helm will generate one. Must be a string of 16 chars. | |
| `jobservice.livenessProbe`                                                  | Liveness probe configuration for Job Service                             | `Check values.yaml file`                                |
| `jobservice.readinessProbe`                                                 | Readines probe configuration for Job Service                             | `Check values.yaml file`                                |
| **Registry**                                                                |
| `registryImage.registry`                                                    | Registry for registry image                                              | `goharbor/harbor-portal`                                |
| `registryImage.repository`                                                  | Repository for registry image                                            | `goharbor/registry-photon`                              |
| `registryImage.tag`                                                         | Tag for registry image                                                   | `dev`                                                   |
| `registryImage.pullPolicy`                                                  | Harbor Registry image pull policy                                        | `IfNotPresent`                                          |
| `registryImage.pullSecrets`                                                 | Specify docker-registry secret names as an array                         | `[]` (does not add image pull secrets to deployed pods) |
| `registryImage.debug`                                                       | Specify if debug logs should be enabled                                  | `false`                                                 |
| `registry.registry.resources`                                               | The [resources] to allocate for container                                | undefined                                               |
| `registry.registry.livenessProbe`                                           | Liveness probe configuration for Registry                                | `Check values.yaml file`                                |
| `registry.registry.readinessProbe`                                          | Readines probe configuration for Registry                                | `Check values.yaml file`                                |
| `registryctlImage.registry`                                                 | Registry for registryctl image                                           | `goharbor/harbor-portal`                                |
| `registryctlImage.repository`                                               | Repository for registryctl controller image                              | `goharbor/harbor-registryctl`                           |
| `registryctlImage.tag`                                                      | Tag for registrycrtl controller image                                    | `dev`                                                   |
| `registryctlImage.pullPolicy`                                               | Harbor Registryctl image pull policy                                     | `IfNotPresent`                                          |
| `registryctlImage.pullSecrets`                                              | Specify docker-registry secret names as an array                         | `[]` (does not add image pull secrets to deployed pods) |
| `registryctlImage.debug`                                                    | Specify if debug logs should be enabled                                  | `false`                                                 |
| `registry.controller.resources`                                             | The [resources] to allocate for container                                | undefined                                               |
| `registry.controller.livenessProbe`                                         | Liveness probe configuration for Registryctl                             | `Check values.yaml file`                                |
| `registry.controller.readinessProbe`                                        | Readines probe configuration for Registryctl                             | `Check values.yaml file`                                |
| `registry.replicas`                                                         | The replica count                                                        | `1`                                                     |
| `registry.nodeSelector`                                                     | Node labels for pod assignment                                           | `{}` (The value is evaluated as a template)             |
| `registry.tolerations`                                                      | Tolerations for pod assignment                                           | `[]` (The value is evaluated as a template)             |
| `registry.affinity`                                                         | Node/Pod affinities                                                      | `{}` (The value is evaluated as a template)             |
| `registry.podAnnotations`                                                   | Annotations to add to the registry pod                                   | `{}`                                                    |
| `registry.secret`                                                           | Secret is used to secure the upload state from client and registry storage backend. See: https://github.com/docker/distribution/blob/master/docs/configuration.md#http. If a secret key is not specified, Helm will generate one. Must be a string of 16 chars. | `nil` |
| **Clair**                                                                   |
| `clairImage.registry`                                                       | Registry for clair image                                                 | `docker.io`                                             |
| `clairImage.repository`                                                     | Repository for clair image                                               | `bitnami/harbor-clair`                                  |
| `clairImage.tag`                                                            | Tag for clair image                                                      | `{TAG_NAME}`                                            |
| `clairImage.pullPolicy`                                                     | Harbor Jobservice image pull policy                                      | `IfNotPresent`                                          |
| `clairImage.pullSecrets`                                                    | Specify docker-registry secret names as an array                         | `[]` (does not add image pull secrets to deployed pods) |
| `clairImage.debug`                                                          | Specify if debug logs should be enabled                                  | `false`                                                 |
| `clair.enabled`                                                             | Enable Clair                                                             | `true`                                                  |
| `clair.replicas`                                                            | The replica count                                                        | `1`                                                     |
| `clair.httpProxy`                                                           | The http proxy used to update vulnerabilities database from internet     | undefined                                               |
| `clair.httpsProxy`                                                          | The https proxy used to update vulnerabilities database from internet    | undefined                                               |
| `clair.updatersInterval`                                                    | The interval of clair updaters (hours), set to 0 to disable              | `12`                                                    |
| `clair.resource`                                                            | The [resources] to allocate for container                                | undefined                                               |
| `clair.nodeSelector`                                                        | Node labels for pod assignment                                           | `{}` (The value is evaluated as a template)             |
| `clair.tolerations`                                                         | Tolerations for pod assignment                                           | `[]` (The value is evaluated as a template)             |
| `clair.affinity`                                                            | Node/Pod affinities                                                      | `{}` (The value is evaluated as a template)             |
| `clair.podAnnotations`                                                      | Annotations to add to the clair pod                                      | `{}`                                                    |
| `clair.livenessProbe`                                                       | Liveness probe configuration                                             | `Check values.yaml file`                                |
| `clair.readinessProbe`                                                      | Readiness probe configuration                                            | `Check values.yaml file`                                |
| **PostgreSQL**                                                              |
| `database.type`                                                             | If external database is used, set it to `external`                       | `internal`                                              |
| `database.internal.image.repository`                                        | Repository for database image                                            | `goharbor/harbor-db`                                    |
| `database.internal.image.tag`                                               | Tag for database image                                                   | `dev`                                                   |
| `database.internal.password`                                                | The password for database                                                | `changeit`                                              |
| `database.internal.resources`                                               | The [resources] to allocate for container                                | undefined                                               |
| `database.internal.nodeSelector`                                            | Node labels for pod assignment                                           | `{}`                                                    |
| `database.internal.tolerations`                                             | Tolerations for pod assignment                                           | `[]`                                                    |
| `database.internal.affinity`                                                | Node/Pod affinities                                                      | `{}`                                                    |
| `database.external.host`                                                    | The hostname of external database                                        | `192.168.0.1`                                           |
| `database.external.port`                                                    | The port of external database                                            | `5432`                                                  |
| `database.external.username`                                                | The username of external database                                        | `user`                                                  |
| `database.external.password`                                                | The password of external database                                        | `password`                                              |
| `database.external.coreDatabase`                                            | The database used by core service                                        | `registry`                                              |
| `database.external.clairDatabase`                                           | The database used by clair                                               | `clair`                                                 |
| `database.external.notaryServerDatabase`                                    | The database used by Notary server                                       | `notary_server`                                         |
| `database.external.notarySignerDatabase`                                    | The database used by Notary signer                                       | `notary_signer`                                         |
| `database.external.sslmode`                                                 | Connection method of external database (require                          | prefer                                                  |
| `database.podAnnotations`                                                   | Annotations to add to the database pod                                   | `{}`                                                    |
| **Redis**                                                                   |
| `redis.type`                                                                | If external redis is used, set it to `external`                          | `internal`                                              |
| `redis.internal.image.repository`                                           | Repository for redis image                                               | `goharbor/redis-photon`                                 |
| `redis.internal.image.tag`                                                  | Tag for redis image                                                      | `dev`                                                   |
| `redis.internal.resources`                                                  | The [resources] to allocate for container                                | undefined                                               |
| `redis.internal.nodeSelector`                                               | Node labels for pod assignment                                           | `{}`                                                    |
| `redis.internal.tolerations`                                                | Tolerations for pod assignment                                           | `[]`                                                    |
| `redis.internal.affinity`                                                   | Node/Pod affinities                                                      | `{}`                                                    |
| `redis.external.host`                                                       | The hostname of external Redis                                           | `192.168.0.2`                                           |
| `redis.external.port`                                                       | The port of external Redis                                               | `6379`                                                  |
| `redis.external.coreDatabaseIndex`                                          | The database index for core                                              | `0`                                                     |
| `redis.external.jobserviceDatabaseIndex`                                    | The database index for jobservice                                        | `1`                                                     |
| `redis.external.registryDatabaseIndex`                                      | The database index for registry                                          | `2`                                                     |
| `redis.external.chartmuseumDatabaseIndex`                                   | The database index for chartmuseum                                       | `3`                                                     |
| `redis.external.password`                                                   | The password of external Redis                                           | `nil`                                                   |
| `redis.podAnnotations`                                                      | Annotations to add to the redis pod                                      | `{}`                                                    |

[resources]: https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container/

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set harborAdminPassword=password \
    bitnami/harbor
```

The above command sets the Harbor administrator account password to `password`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml bitnami/harbor
```
### Production configuration

This chart includes a `values-production.yaml` file where you can find some parameters oriented to production configuration in comparison to the regular `values.yaml`:

- The way how to expose the service: `Ingress`, `ClusterIP`, `NodePort` or `LoadBalancer`:
```diff
- service.type: ClusterIP
+ service.type: Ingress
```

- The common name used to generate the certificate. It's necessary when the `service.type` is `ClusterIP` or `NodePort` and `service.tls.secretName` is null:
```diff
- service.tls.commonName: "core.harbor.domain"
+ service.tls.commonName: ""
```

- Option to ensure all passwords and keys are set by the user:
```diff
- forcePassword: false
+ forcePassword: true
```

- Option to deploy Redis cluster:
```diff
- redis.cluster.enabled: false
+ redis.cluster.enabled: true
```

- Option to deploy PostgreSQL replication cluster:
```diff
- postgresql.replication.enabled: false
+ postgresql.replication.enabled: true
```

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.