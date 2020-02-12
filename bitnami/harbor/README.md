# Harbor

This Helm chart has been developed based on [goharbor/harbor-helm](https://github.com/goharbor/harbor-helm) chart but including some features common to the Bitnami chart library.
For example, the following changes have been introduced:

- Possibility to pull all the required images from a private registry through the  Global Docker image parameters.
- Redis and PostgreSQL are managed as chart dependencies.
- Liveness and Readiness probes for all deployments are exposed to the values.yaml.
- Uses new Helm chart labels formating.
- Uses Bitnami container images:
  - non-root by default
  - published for debian-9 and ol-7
- This chart support the Harbor optional components Chartmuseum, Clair and Notary integrations.

## TL;DR;

```
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/harbor
```

## Introduction

This [Helm](https://github.com/kubernetes/helm) chart installs [Harbor](https://github.com/goharbor/harbor) in a Kubernetes cluster. Welcome to [contribute](CONTRIBUTING.md) to Helm Chart for Harbor.

## Prerequisites

- Kubernetes 1.12+
- Helm 2.11+ or Helm 3.0-beta3+
- PV provisioner support in the underlying infrastructure
- ReadWriteMany volumes for deployment scaling

## Installing the Chart

Install the Harbor helm chart with a release name `my-release`:

```bash
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/harbor
```

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete --purge my-release
```

Additionaly, if `persistence.resourcePolicy` is set to `keep`, you should manually delete the PVCs.

## Parameters

The following table lists the configurable parameters of the Harbor chart and the default values. They can be configured in `values.yaml` or set via `--set` flag during installation.

| Parameter                                                                   | Description                                                              | Default                                                 |
| --------------------------------------------------------------------------- |  ----------------------------------------------------------------------- | ------------------------------------------------------- |
| **Global**                                                                  |
| `global.imageRegistry`               | Global Docker image registry                                                                                                                              | `nil`                                                   |
| `global.imagePullSecrets`            | Global Docker registry secret names as an array                                                                                                           | `[]` (does not add image pull secrets to deployed pods) |
| `global.storageClass`                     | Global storage class for dynamic provisioning                                               | `nil`                                                        |
| **Expose**                                                                  |
| `service.type`                                                              | The way how to expose the service: `Ingress`, `ClusterIP`, `NodePort` or `LoadBalancer` | `ClusterIP`
| `service.tls.enabled`                                                       | Enable the tls or not                                                                   | `true`                                                  |
| `service.ingress.controller`                                                | The ingress controller type. Currently supports `default`, `gce` and `ncp`              | `default`                                               |
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
| `service.loadBalancer.annotations`                                          | The annotations attached to the loadBalancer service                     | {}                                                      |
| `service.loadBalancer.sourceRanges`                                         | List of IP address ranges to assign to loadBalancerSourceRanges          | []                                                      |
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
| `nameOverride`                                                              | String to partially override harbor.fullname template with a string (will prepend the release name) | `nil`                        |
| `fullnameOverride`                                                          | String to fully override harbor.fullname template with a string                                     | `nil`                        |
| `volumePermissions.enabled`          | Enable init container that changes volume permissions in the data directory (for cases where the default k8s `runAsUser` and `fsUser` values do not work) | `false`                                                      |
| `volumePermissions.image.registry`   | Init container volume-permissions image registry                                                                                                          | `docker.io`                                                  |
| `volumePermissions.image.repository` | Init container volume-permissions image name                                                                                                              | `bitnami/minideb`                                            |
| `volumePermissions.image.tag`        | Init container volume-permissions image tag                                                                                                               | `buster`                                                      |
| `volumePermissions.image.pullPolicy` | Init container volume-permissions image pull policy                                                                                                       | `Always`                                                     |
| `volumePermissions.resources`        | Init container resource requests/limit                                                                                                                    | `nil`                                                        |
| `externalURL`                                                               | The external URL for Harbor core service                                 | `https://core.harbor.domain`                            |
| `imagePullPolicy`                                                           | The image pull policy                                                    | `IfNotPresent`                                          |
| `logLevel`                                                                  | The log level                                                            | `debug`                                                 |
| `forcePassword`                                                             | Option to ensure all passwords and keys are set by the user              | `false`                                                 |
| `harborAdminPassword`                                                       | The initial password of Harbor admin. Change it from portal after launching Harbor | _random 10 character long alphanumeric string_ |
| `secretkey`                                                                 | The key used for encryption. Must be a string of 16 chars                | `not-a-secure-key`                                      |
| **Nginx** (if expose the service via `ingress`, the Nginx will not be used) |
| `nginxImage.registry`                                                       | Registry for Nginx image                                                 | `docker.io`                                             |
| `nginxImage.repository`                                                     | Repository for Nginx image                                               | `bitnami/nginx`                                         |
| `nginxImage.tag`                                                            | Tag for Nginx image                                                      | `{TAG_NAME}`                                            |
| `nginx.replicas`                                                            | The replica count                                                        | `1`                                                     |
| `nginx.resources`                                                           | The [resources] to allocate for container                                | undefined                                               |
| `nginx.nodeSelector`                                                        | Node labels for pod assignment                                           | `{}` (The value is evaluated as a template)             |
| `nginx.tolerations`                                                         | Tolerations for pod assignment                                           | `[]` (The value is evaluated as a template)             |
| `nginx.affinity`                                                            | Node/Pod affinities                                                      | `{}` (The value is evaluated as a template)             |
| `nginx.podAnnotations`                                                      | Annotations to add to the nginx pod                                      | `{}`                                                    |
| `nginx.behindReverseProxy`                                                  | If nginx is behind another reverse proxy, set to true                    | `false`                                                    |
| **Portal**                                                                  |
| `portalImage.registry`                                                      | Registry for portal image                                                | `docker.io`                                             |
| `portalImage.repository`                                                    | Repository for portal image                                              | `bitnami/harbor-portal`                                 |
| `portalImage.tag`                                                           | Tag for portal image                                                     | `{TAG_NAME}`                                            |
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
| `coreImage.registry`                                                        | Registry for core image                                                  | `docker.io`                                             |
| `coreImage.repository`                                                      | Repository for Harbor core image                                         | `bitnami/harbor-core`                                   |
| `coreImage.tag`                                                             | Tag for Harbor core image                                                | `{TAG_NAME}`                                            |
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
| `jobserviceImage.registry`                                                  | Registry for jobservice image                                            | `docker.io`                                             |
| `jobserviceImage.repository`                                                | Repository for jobservice image                                          | `bitnami/harbor-jobservice`                             |
| `jobserviceImage.tag`                                                       | Tag for jobservice image                                                 | `{TAG_NAME}`                                            |
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
| `registryImage.registry`                                                    | Registry for registry image                                              | `docker.io`                                             |
| `registryImage.repository`                                                  | Repository for registry image                                            | `bitnami/harbor-registry`                               |
| `registryImage.tag`                                                         | Tag for registry image                                                   | `{TAG_NAME}`                                            |
| `registryImage.pullPolicy`                                                  | Harbor Registry image pull policy                                        | `IfNotPresent`                                          |
| `registryImage.pullSecrets`                                                 | Specify docker-registry secret names as an array                         | `[]` (does not add image pull secrets to deployed pods) |
| `registryImage.debug`                                                       | Specify if debug logs should be enabled                                  | `false`                                                 |
| `registry.registry.resources`                                               | The [resources] to allocate for container                                | undefined                                               |
| `registry.registry.livenessProbe`                                           | Liveness probe configuration for Registry                                | `Check values.yaml file`                                |
| `registry.registry.readinessProbe`                                          | Readines probe configuration for Registry                                | `Check values.yaml file`                                |
| `registryctlImage.registry`                                                 | Registry for registryctl image                                           | `docker.io`                                             |
| `registryctlImage.repository`                                               | Repository for registryctl controller image                              | `bitnami/harbor-registryctl`                            |
| `registryctlImage.tag`                                                      | Tag for registrycrtl controller image                                    | `{TAG_NAME}`                                            |
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
| **Chartmuseum**                                                             |
| `chartMuseumImage.registry`                                                 | Registry for ChartMuseum image                                           | `docker.io`                                             |
| `chartMuseumImage.repository`                                               | Repository for clair image                                               | `bitnami/chartmuseum`                                   |
| `chartMuseumImage.tag`                                                      | Tag for ChartMuseum image                                                | `0.9.0-debian-9-r6`                                     |
| `chartMuseumImage.pullPolicy`                                               | ChartMuseum image pull policy                                            | `IfNotPresent`                                          |
| `chartMuseumImage.debug`                                                    | Specify if debug logs should be enabled                                  | `false`                                                 |
| `chartmuseum.enabled`                                                       | Enable ChartMuseum                                                       | `true`                                                  |
| `chartmuseum.replicas`                                                      | Number of ChartMuseum replicas                                           | `1`                                                     |
| `chartmuseum.port`                                                          | ChartMuseum listen port                                                  | `8080`                                                  |
| `chartmuseum.useRedisCache`                                                 | Specify if ChartMuseum will use redis cache                              | `true`                                                  |
| `chartmuseum.absoluteUrl`                                                   | Specify an absolute URL for ChartMuseum registry                         | `false`                                                 |
| `chartmuseum.chartRepoName`                                                 | Specify the endpoint for the chartmuseum registry. Only applicable if `chartmuseum.absoluteUrl` is `true` | `chartsRepo`           |
| `chartmuseum.depth`                                                         |  Support for multitenancy. More info [here](https://chartmuseum.com/docs/#multitenancy) | `1`                                      |
| `chartmuseum.logJson`                                                       | Print logs on JSON format                                                | `false`                                                 |
| `chartmuseum.disableMetrics`                                                | Disable prometheus metrics exposure                                      | `false`                                                 |
| `chartmuseum.disableApi`                                                    | Disable all the routes prefixed with `/api`                              | `false`                                                 |
| `chartmuseum.disableStatefiles`                                             | Disable use of index-cache.yaml                                          | `false`                                                 |
| `chartmuseum.allowOverwrite`                                                | Allow chart versions to be re-uploaded without force querystring         | `true`                                                  |
| `chartmuseum.anonymousGet`                                                  | Allow anonymous GET operations                                           | `false`                                                 |
| `chartmuseum.enableTLS`                                                     | Enable use of TLS access                                                 | `false`                                                 |
| `chartmuseum.contextPath`                                                   | Set the base context path for ChartMuseum                                | `nil`                                                   |
| `chartmuseum.indexLimit`                                                    | Limit the number of parallels indexes for ChartMuseum                    | `nil`                                                   |
| `chartmuseum.chartPostFormFieldName`                                        | Form field which will be queried for the chart file content              | `nil`                                                   |
| `chartmuseum.provPostFormFieldName`                                         | Form field which will be queried for the provenance file content         | `nil`                                                   |
| `chartmuseum.extraEnvVars`                                                  | Allow to pass extra environment variables to the chartmuseum image       | `nil`                                                   |
| `chartmuseum.livenessProbe`                                                 | Liveness probe configuration                                             | `Check values.yaml file`                                |
| `chartmuseum.readinessProbe`                                                | Readiness probe configuration                                            | `Check values.yaml file`                                |
| **Clair**                                                                   |
| `clairImage.registry`                                                       | Registry for clair image                                                 | `docker.io`                                             |
| `clairImage.repository`                                                     | Repository for clair image                                               | `bitnami/harbor-clair`                                  |
| `clairImage.tag`                                                            | Tag for clair image                                                      | `{TAG_NAME}`                                            |
| `clairImage.pullPolicy`                                                     | Harbor clair image pull policy                                   | `IfNotPresent`                                          |
| `clairImage.pullSecrets`                                                    | Specify docker-registry secret names as an array                         | `[]` (does not add image pull secrets to deployed pods) |
| `clairImage.debug`                                                          | Specify if debug logs should be enabled                                  | `false`                                                 |
| `clairAdapterImage.registry`                                                | Registry for clair adapter image                                         | `docker.io`                                             |
| `clairAdapterImage.repository`                                              | Repository for clair adapter image                                       | `bitnami/harbor-adapter-clair`                          |
| `clairAdapterImage.tag`                                                     | Tag for clair adapter image                                              | `{TAG_NAME}`                                            |
| `clairAdapterImage.pullPolicy`                                              | Harbor clair adapter image pull policy                                   | `IfNotPresent`                                          |
| `clairAdapterImage.pullSecrets`                                             | Specify docker-registry secret names as an array                         | `[]` (does not add image pull secrets to deployed pods) |
| `clairAdapterImage.debug`                                                   | Specify if debug logs should be enabled                                  | `false`                                                 |
| `clair.enabled`                                                             | Enable Clair                                                             | `true`                                                  |
| `clair.replicas`                                                            | The replica count                                                        | `1`                                                     |
| `clair.httpProxy`                                                           | The http proxy used to update vulnerabilities database from internet     | undefined                                               |
| `clair.httpsProxy`                                                          | The https proxy used to update vulnerabilities database from internet    | undefined                                               |
| `clair.updatersInterval`                                                    | The interval of clair updaters (hours), set to 0 to disable              | `12`                                                    |
| `clair.resource`                                                            | The [resources] to allocate for container                                | undefined                                               |
| `clair.adapter.resource`                                                    | The [resources] to allocate for container                                | undefined                                               |
| `clair.nodeSelector`                                                        | Node labels for pod assignment                                           | `{}` (The value is evaluated as a template)             |
| `clair.tolerations`                                                         | Tolerations for pod assignment                                           | `[]` (The value is evaluated as a template)             |
| `clair.affinity`                                                            | Node/Pod affinities                                                      | `{}` (The value is evaluated as a template)             |
| `clair.podAnnotations`                                                      | Annotations to add to the clair pod                                      | `{}`                                                    |
| `clair.livenessProbe`                                                       | Liveness probe configuration                                             | `Check values.yaml file`                                |
| `clair.readinessProbe`                                                      | Readiness probe configuration                                            | `Check values.yaml file`                                |
| **PostgreSQL**                                                              |
| `posgresql.enabled`                                                          | If external database is used, set it to `false`                          | `true`                                                  |
| `posgresql.postgresqlUsername`                                               | Postgresql username                                                      | `postgres`                                              |
| `posgresql.postgresqlPassword`                                               | Postgresql password                                                      | `not-a-secure-database-password`                        |
| `posgresql.replication.enabled`                                              | Enable replicated postgresql                                             | `false`                                                 |
| `posgresql.persistence.enabled`                                              | Enable persistence for PostgreSQL                                        | `true`                                                  |
| `posgresql.initdbScripts`                                                    | Initdb scripts to create Harbor databases                                | `See values.yaml file`                                  |
| `externalDatabase.host`                                                      | Host of the external database                                            | `localhost`                                             |
| `externalDatabase.port`                                                      | Port of the external database                                            | `5432`                                                  |
| `externalDatabase.user`                                                      | Existing username in the external db                                     | `bn_harbor`                                             |
| `externalDatabase.password`                                                  | Password for the above username                                          | `nil`                                                   |
| `externalDatabase.database`                                                  | Name of the existing database                                            | `bitnami_harbor`                                        |
| `externalDatabase.coreDatabase`                                              | External database name for core                                          | `nil`                                                   |
| `externalDatabase.clairDatabase`                                             | External database name for clair                                         | `nil`                                                   |
| `externalDatabase.notaryServerDatabase`                                      | External database name for notary server                                 | `nil`                                                   |
| `externalDatabase.notarySignerDatabase`                                      | External database name for notary signer                                 | `nil`                                                   |
| `externalDatabase.sslmode`                                                   | External database ssl mode                                               | `nil`                                                   |
| **Redis**                                                                    |
| `redis.enabled`                                                              | If external redis is used, set it to `false`                             | `true`                                                  |
| `redis.password`                                                             | Redis password                                                           | `nil`                                                   |
| `redis.usePassword`                                                          | Use redis password                                                       | `false`                                                 |
| `redis.cluster.enabled`                                                      | Enable cluster redis                                                     | `false`                                                 |
| `redis.master.persistence.enabled`                                           | Enable persistence for master Redis                                      | `true`                                                  |
| `redis.slave.persistence.enabled`                                            | Enable persistence for slave Redis                                       | `true`                                                  |
| `externalRedis.host`                                                         | Host of the external redis                                               | `localhost`                                             |
| `externalRedis.port`                                                         | Port of the external redis                                               | `6379`                                                  |
| `externalRedis.password`                                                     | Password for the external redis                                          | `nil`                                                   |
| `externalRedis.coreDatabaseIndex`                                            | Index for core database                                                  | `0`                                                     |
| `externalRedis.jobserviceDatabaseIndex`                                      | Index for jobservice database                                            | `1`                                                     |
| `externalRedis.registryDatabaseIndex`                                        | Index for registry database                                              | `2`                                                     |
| `externalRedis.chartmuseumDatabaseIndex`                                     | Index for chartmuseum database                                           | `3`                                                     |

[resources]: https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container/

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install my-release \
  --set harborAdminPassword=password \
    bitnami/harbor
```

The above command sets the Harbor administrator account password to `password`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install my-release -f values.yaml bitnami/harbor
```

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Production configuration

This chart includes a `values-production.yaml` file where you can find some parameters oriented to production configuration in comparison to the regular `values.yaml`. You can use this file instead of the default one.

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

### Configure the way how to expose Harbor service:

- **Ingress**: The ingress controller must be installed in the Kubernetes cluster.
  **Notes:** if the TLS is disabled, the port must be included in the command when pulling/pushing images. Refer to issue [#5291](https://github.com/goharbor/harbor/issues/5291) for the detail.
- **ClusterIP**: Exposes the service on a cluster-internal IP. Choosing this value makes the service only reachable from within the cluster.
- **NodePort**: Exposes the service on each Node’s IP at a static port (the NodePort). You’ll be able to contact the NodePort service, from outside the cluster, by requesting `NodeIP:NodePort`.
- **LoadBalancer**: Exposes the service externally using a cloud provider’s load balancer.

### Configure the external URL:

The external URL for Harbor core service is used to:

1. populate the docker/helm commands showed on portal
2. populate the token service URL returned to docker/notary client

Format: `protocol://domain[:port]`. Usually:

- if expose the service via `Ingress`, the `domain` should be the value of `service.ingress.hosts.core`
- if expose the service via `ClusterIP`, the `domain` should be the value of `service.clusterIP.name`
- if expose the service via `NodePort`, the `domain` should be the IP address of one Kubernetes node
- if expose the service via `LoadBalancer`, set the `domain` as your own domain name and add a CNAME record to map the domain name to the one you got from the cloud provider

If Harbor is deployed behind the proxy, set it as the URL of proxy.

### Configure data persistence:

- **Disable**: The data does not survive the termination of a pod.
- **Persistent Volume Claim(default)**: A default `StorageClass` is needed in the Kubernetes cluster to dynamically provision the volumes. Specify another StorageClass in the `storageClass` or set `existingClaim` if you have already existing persistent volumes to use.
- **External Storage(only for images and charts)**: For images and charts, the external storages are supported: `azure`, `gcs`, `s3` `swift` and `oss`.

### Configure the secrets:

- **Secret keys**: Secret keys are used for secure communication between components. Fill `core.secret`, `jobservice.secret` and `registry.secret` to configure.
- **Certificates**: Used for token encryption/decryption. Fill `core.secretName` to configure.

Secrets and certificates must be setup to avoid changes on every Helm upgrade (see: [#107](https://github.com/goharbor/harbor-helm/issues/107)).

### Adjust permissions of persistent volume mountpoint

As the images run as non-root by default, it is necessary to adjust the ownership of the persistent volumes so that the containers can write data into it.

By default, the chart is configured to use Kubernetes Security Context to automatically change the ownership of the volume. However, this feature does not work in all Kubernetes distributions.
As an alternative, this chart supports using an initContainer to change the ownership of the volume before mounting it in the final destination.

You can enable this initContainer by setting `volumePermissions.enabled` to `true`.

## Upgrade

## 3.0.0

Helm performs a lookup for the object based on its group (apps), version (v1), and kind (Deployment). Also known as its GroupVersionKind, or GVK. Changing the GVK is considered a compatibility breaker from Kubernetes' point of view, so you cannot "upgrade" those objects to the new GVK in-place. Earlier versions of Helm 3 did not perform the lookup correctly which has since been fixed to match the spec.

In c085d396a0515be7217d65e92f4fbd474840908b the `apiVersion` of the deployment resources was updated to `apps/v1` in tune with the api's deprecated, resulting in compatibility breakage.

This major version signifies this change.

## 2.0.0

In this version, two major changes were performed:

- This **chart depends on the Redis 5 chart instead of Redis 4**. There is a breaking change that will affect releases with `metrics.enabled: true`, since the default tag for the exporter image is now `v1.x.x`. This introduces many changes including metrics names. You'll want to use [this dashboard](https://github.com/oliver006/redis_exporter/blob/master/contrib/grafana_prometheus_redis_dashboard.json) now. Please see the [redis_exporter github page](https://github.com/oliver006/redis_exporter#upgrading-from-0x-to-1x) for more details.
- This **chart depends on the PostgreSQL 11 chart instead of PostgreSQL 10**. You can find the main difference and notable changes in the following links: [https://www.postgresql.org/about/news/1894/](https://www.postgresql.org/about/news/1894/) and [https://www.postgresql.org/about/featurematrix/](https://www.postgresql.org/about/featurematrix/).

For major releases of PostgreSQL, the internal data storage format is subject to change, thus complicating upgrades, you can see some errors like the following one in the logs:

```bash
Welcome to the Bitnami postgresql container
Subscribe to project updates by watching https://github.com/bitnami/bitnami-docker-postgresql
Submit issues and feature requests at https://github.com/bitnami/bitnami-docker-postgresql/issues
Send us your feedback at containers@bitnami.com

INFO  ==> ** Starting PostgreSQL setup **
NFO  ==> Validating settings in POSTGRESQL_* env vars..
INFO  ==> Initializing PostgreSQL database...
INFO  ==> postgresql.conf file not detected. Generating it...
INFO  ==> pg_hba.conf file not detected. Generating it...
INFO  ==> Deploying PostgreSQL with persisted data...
INFO  ==> Configuring replication parameters
INFO  ==> Loading custom scripts...
INFO  ==> Enabling remote connections
INFO  ==> Stopping PostgreSQL...
INFO  ==> ** PostgreSQL setup finished! **

INFO  ==> ** Starting PostgreSQL **
  [1] FATAL:  database files are incompatible with server
  [1] DETAIL:  The data directory was initialized by PostgreSQL version 10, which is not compatible with this version 11.3.
```

In this case, you should migrate the data from the old PostgreSQL chart to the new one following an approach similar to that described in [this section](https://www.postgresql.org/docs/current/upgrading.html#UPGRADING-VIA-PGDUMPALL) from the official documentation. Basically, create a database dump in the old chart, move and restore it in the new one.
