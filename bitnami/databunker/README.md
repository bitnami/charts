# Databunker

[Databunker](https://databunker.org/) is an open-source secure vault and SDK to store customer records built to comply with GDPR.


## TL;DR

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/databunker
```

## Introduction

This chart bootstraps a [Databunker](https://github.com/bitnami/bitnami-docker-databunker) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages the [Bitnami MariaDB chart](https://github.com/bitnami/charts/tree/master/bitnami/mariadb) which is required for bootstrapping a MariaDB deployment as a database for the Databunker application.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.12+
- Helm 1.12+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install my-release bitnami/databunker
```

The command deploys Databunker on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

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

| Name                | Description                                                                  | Value |
| ------------------- | ---------------------------------------------------------------------------- | ----- |
| `kubeVersion`       | Force target Kubernetes version (using Helm capabilities if not set)         | `""`  |
| `nameOverride`      | String to partially override databunker.fullname template                    | `""`  |
| `fullnameOverride`  | String to fully override databunker.fullname template                        | `""`  |
| `commonAnnotations` | Annotations to add to all deployed objects                                   | `{}`  |
| `commonLabels`      | Labels to add to all deployed objects                                        | `{}`  |
| `extraDeploy`       | Array of extra objects to deploy with the release (evaluated as a template). | `[]`  |


### Databunker parameters

| Name                                 | Description                                                                                                          | Value                 |
| ------------------------------------ | -------------------------------------------------------------------------------------------------------------------- | --------------------- |
| `image.registry`                     | Databunker image registry                                                                                            | `docker.io`           |
| `image.repository`                   | Databunker image repository                                                                                          | `bitnami/databunker`  |
| `image.tag`                          | Databunker image tag (immutable tags are recommended)                                                                | `latest`              |
| `image.pullPolicy`                   | Databunker image pull policy                                                                                         | `IfNotPresent`        |
| `image.pullSecrets`                  | Specify docker-registry secret names as an array                                                                     | `[]`                  |
| `image.debug`                        | Specify if debug logs should be enabled                                                                              | `false`               |
| `hostAliases`                        | Add deployment host aliases                                                                                          | `[]`                  |
| `replicaCount`                       | Number of Databunker Pods to run                                                                                     | `1`                   |
| `databunkerSkipInstall`              | Skip Databunker installation wizard. Useful for migrations and restoring from SQL dump                               | `false`               |
| `databunkerHost`                     | Databunker host to create application URLs                                                                           | `""`                  |
| `databunkerMasterkey`                | Databunker Master Key                                                                                                | `""`                  |
| `databunkerRoottoken`                | Databunker Root Token                                                                                                | `""`                  |
| `databunkerAdminEmail`               | Admin email                                                                                                          | `user@example.com`    |
| `databunkerExtraInstallArgs`         | Databunker extra install args                                                                                        | `""`                  |
| `command`                            | Override default container command (useful when using custom images)                                                 | `[]`                  |
| `args`                               | Override default container args (useful when using custom images)                                                    | `[]`                  |
| `updateStrategy.type`                | Update strategy - only really applicable for deployments with RWO PVs attached                                       | `RollingUpdate`       |
| `extraEnvVars`                       | Extra environment variables                                                                                          | `[]`                  |
| `extraEnvVarsCM`                     | ConfigMap containing extra env vars                                                                                  | `""`                  |
| `extraEnvVarsSecret`                 | Secret containing extra env vars (in case of sensitive data)                                                         | `""`                  |
| `extraVolumes`                       | Array of extra volumes to be added to the deployment (evaluated as template). Requires setting `extraVolumeMounts`   | `[]`                  |
| `extraVolumeMounts`                  | Array of extra volume mounts to be added to the container (evaluated as template). Normally used with `extraVolumes` | `[]`                  |
| `extraContainerPorts`                | Array of additional container ports for the Databunker container                                                        | `[]`                  |
| `initContainers`                     | Add additional init containers to the pod (evaluated as a template)                                                  | `[]`                  |
| `sidecars`                           | Attach additional containers to the pod (evaluated as a template)                                                    | `[]`                  |
| `tolerations`                        | Tolerations for pod assignment                                                                                       | `[]`                  |
| `existingSecret`                     | Name of a secret with the application password                                                                       | `""`                  |
| `containerPorts`                     | Container ports                                                                                                      | `{}`                  |
| `sessionAffinity`                    | Control where client requests go, to the same pod or round-robin                                                     | `None`                |
| `podAffinityPreset`                  | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                  | `""`                  |
| `podAntiAffinityPreset`              | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                             | `soft`                |
| `nodeAffinityPreset.type`            | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                            | `""`                  |
| `nodeAffinityPreset.key`             | Node label key to match Ignored if `affinity` is set.                                                                | `""`                  |
| `nodeAffinityPreset.values`          | Node label values to match. Ignored if `affinity` is set.                                                            | `[]`                  |
| `affinity`                           | Affinity for pod assignment                                                                                          | `{}`                  |
| `nodeSelector`                       | Node labels for pod assignment                                                                                       | `{}`                  |
| `resources.limits`                   | The resources limits for the Databunker container                                                                    | `{}`                  |
| `resources.requests`                 | The requested resourcesc for the Databunker container                                                                | `{}`                  |
| `podSecurityContext.enabled`         | Enable Databunker pods' Security Context                                                                             | `true`                |
| `podSecurityContext.fsGroup`         | Databunker pods' group ID                                                                                            | `1001`                |
| `containerSecurityContext.enabled`   | Enable Databunker containers' Security Context                                                                       | `true`                |
| `containerSecurityContext.runAsUser` | Databunker containers' Security Context                                                                              | `1001`                |
| `livenessProbe.enabled`              | Enable livenessProbe                                                                                                 | `true`                |
| `livenessProbe.path`                 | Request path for livenessProbe                                                                                       | `/status`             |
| `livenessProbe.initialDelaySeconds`  | Initial delay seconds for livenessProbe                                                                              | `300`                 |
| `livenessProbe.periodSeconds`        | Period seconds for livenessProbe                                                                                     | `10`                  |
| `livenessProbe.timeoutSeconds`       | Timeout seconds for livenessProbe                                                                                    | `5`                   |
| `livenessProbe.failureThreshold`     | Failure threshold for livenessProbe                                                                                  | `6`                   |
| `livenessProbe.successThreshold`     | Success threshold for livenessProbe                                                                                  | `1`                   |
| `readinessProbe.enabled`             | Enable readinessProbe                                                                                                | `true`                |
| `readinessProbe.path`                | Request path for readinessProbe                                                                                      | `/status`             |
| `readinessProbe.initialDelaySeconds` | Initial delay seconds for readinessProbe                                                                             | `30`                  |
| `readinessProbe.periodSeconds`       | Period seconds for readinessProbe                                                                                    | `5`                   |
| `readinessProbe.timeoutSeconds`      | Timeout seconds for readinessProbe                                                                                   | `3`                   |
| `readinessProbe.failureThreshold`    | Failure threshold for readinessProbe                                                                                 | `6`                   |
| `readinessProbe.successThreshold`    | Success threshold for readinessProbe                                                                                 | `1`                   |
| `startupProbe.enabled`               | Enable startupProbe                                                                                                  | `false`               |
| `startupProbe.path`                  | Request path for startupProbe                                                                                        | `/status`             |
| `startupProbe.initialDelaySeconds`   | Initial delay seconds for startupProbe                                                                               | `0`                   |
| `startupProbe.periodSeconds`         | Period seconds for startupProbe                                                                                      | `10`                  |
| `startupProbe.timeoutSeconds`        | Timeout seconds for startupProbe                                                                                     | `3`                   |
| `startupProbe.failureThreshold`      | Failure threshold for startupProbe                                                                                   | `60`                  |
| `startupProbe.successThreshold`      | Success threshold for startupProbe                                                                                   | `1`                   |
| `customLivenessProbe`                | Override default liveness probe                                                                                      | `{}`                  |
| `customReadinessProbe`               | Override default readiness probe                                                                                     | `{}`                  |
| `customStartupProbe`                 | Override default startup probe                                                                                       | `{}`                  |
| `lifecycleHooks`                     | LifecycleHook to set additional configuration at startup Evaluated as a template                                     | `{}`                  |
| `podAnnotations`                     | Pod annotations                                                                                                      | `{}`                  |
| `podLabels`                          | Add additional labels to the pod (evaluated as a template)                                                           | `{}`                  |


### NetworkPolicy parameters

| Name                                                          | Description                                                                                                                         | Value   |
| ------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `networkPolicy.enabled`                                       | Enable network policies                                                                                                             | `false` |
| `networkPolicy.metrics.enabled`                               | Enable network policy for metrics (prometheus)                                                                                      | `false` |
| `networkPolicy.metrics.namespaceSelector`                     | databunker Monitoring namespace selector labels. These labels will be used to identify the prometheus' namespace.                      | `{}`    |
| `networkPolicy.metrics.podSelector`                           | databunker Monitoring pod selector labels. These labels will be used to identify the Prometheus pods.                                  | `{}`    |
| `networkPolicy.ingress.enabled`                               | Enable network policy for Ingress Proxies                                                                                           | `false` |
| `networkPolicy.ingress.namespaceSelector`                     | databunker Ingress Proxy namespace selector labels. These labels will be used to identify the Ingress Proxy's namespace.               | `{}`    |
| `networkPolicy.ingress.podSelector`                           | databunker Ingress Proxy pods selector labels. These labels will be used to identify the Ingress Proxy pods.                           | `{}`    |
| `networkPolicy.ingressRules.backendOnlyAccessibleByFrontend`  | Enable ingress rule that makes the backend (mariadb, elasticsearch) only accessible by databunker's pods.                              | `false` |
| `networkPolicy.ingressRules.customBackendSelector`            | databunker Backend selector labels. These labels will be used to identify the backend pods.                                            | `{}`    |
| `networkPolicy.ingressRules.accessOnlyFrom.enabled`           | Enable ingress rule that makes databunker only accessible from a particular origin                                                     | `false` |
| `networkPolicy.ingressRules.accessOnlyFrom.namespaceSelector` | databunker Namespace selector label that is allowed to access databunker. This label will be used to identified the allowed namespace(s). | `{}`    |
| `networkPolicy.ingressRules.accessOnlyFrom.podSelector`       | databunker Pods selector label that is allowed to access databunker. This label will be used to identified the allowed pod(s).            | `{}`    |
| `networkPolicy.ingressRules.customRules`                      | databunker Custom network policy ingress rule                                                                                          | `{}`    |
| `networkPolicy.egressRules.denyConnectionsToExternal`         | Enable egress rule that denies outgoing traffic outside the cluster, except for DNS (port 53).                                      | `false` |
| `networkPolicy.egressRules.customRules`                       | databunker Custom network policy rule                                                                                                  | `{}`    |


### Database parameters

| Name                                        | Description                                                                              | Value                  |
| ------------------------------------------- | ---------------------------------------------------------------------------------------- | ---------------------- |
| `mariadb.enabled`                           | Whether to deploy a mariadb server to satisfy the applications database requirements.    | `true`                 |
| `mariadb.image.registry`                    | MariaDB image registry                                                                   | `docker.io`            |
| `mariadb.image.repository`                  | MariaDB image repository                                                                 | `bitnami/mariadb`      |
| `mariadb.image.tag`                         | MariaDB image tag (immutable tags are recommended)                                       | `10.3.32-debian-10-r2` |
| `mariadb.architecture`                      | MariaDB architecture. Allowed values: `standalone` or `replication`                      | `standalone`           |
| `mariadb.auth.rootPassword`                 | Password for the MariaDB `root` user                                                     | `""`                   |
| `mariadb.auth.database`                     | Database name to create                                                                  | `databunkerdb`         |
| `mariadb.auth.username`                     | Database user to create                                                                  | `bunkeruser`           |
| `mariadb.auth.password`                     | Password for the database                                                                | `""`                   |
| `mariadb.primary.persistence.enabled`       | Enable database persistence using PVC                                                    | `true`                 |
| `mariadb.primary.persistence.storageClass`  | MariaDB primary persistent volume storage Class                                          | `""`                   |
| `mariadb.primary.persistence.accessModes`   | Database Persistent Volume Access Modes                                                  | `["ReadWriteOnce"]`    |
| `mariadb.primary.persistence.size`          | Database Persistent Volume Size                                                          | `8Gi`                  |
| `mariadb.primary.persistence.hostPath`      | Set path in case you want to use local host path volumes (not recommended in production) | `""`                   |
| `mariadb.primary.persistence.existingClaim` | Name of an existing `PersistentVolumeClaim` for MariaDB primary replicas                 | `""`                   |
| `externalDatabase.host`                     | Host of the existing database                                                            | `""`                   |
| `externalDatabase.port`                     | Port of the existing database                                                            | `3306`                 |
| `externalDatabase.user`                     | Existing username in the external db                                                     | `databunkerdb`         |
| `externalDatabase.password`                 | Password for the above username                                                          | `""`                   |
| `externalDatabase.database`                 | Name of the existing database                                                            | `bunkeruser`           |
| `externalDatabase.existingSecret`           | The name of an existing secret with database credentials                                 | `""`                   |


### Traffic Exposure Parameters

| Name                               | Description                                                                                                                      | Value                    |
| ---------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `service.type`                     | Kubernetes Service type                                                                                                          | `LoadBalancer`           |
| `service.port`                     | Service HTTP port                                                                                                                | `8080`                   |
| `service.httpsPort`                | Service HTTPS port                                                                                                               | `8443`                   |
| `service.clusterIP`                | Static clusterIP or None for headless services                                                                                   | `""`                     |
| `service.loadBalancerSourceRanges` | Control hosts connecting to "LoadBalancer" only                                                                                  | `[]`                     |
| `service.loadBalancerIP`           | loadBalancerIP for the Databunker Service (optional, cloud specific)                                                                | `""`                     |
| `service.nodePorts.http`           | Kubernetes http node port                                                                                                        | `""`                     |
| `service.nodePorts.https`          | Kubernetes https node port                                                                                                       | `""`                     |
| `service.externalTrafficPolicy`    | Enable client source IP preservation                                                                                             | `Cluster`                |
| `ingress.enabled`                  | Enable ingress controller resource                                                                                               | `false`                  |
| `ingress.pathType`                 | Default path type for the ingress resource                                                                                       | `ImplementationSpecific` |
| `ingress.apiVersion`               | Override API Version (automatically detected if not set)                                                                         | `""`                     |
| `ingress.hostname`                 | Default host for the ingress resource                                                                                            | `databunker.local`          |
| `ingress.path`                     | Default path for the ingress resource                                                                                            | `/`                      |
| `ingress.annotations`              | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                     |
| `ingress.tls`                      | Enable TLS for `ingress.hostname` parameter                                                                                      | `false`                  |
| `ingress.extraHosts`               | The list of additional hostnames to be covered with this ingress record.                                                         | `[]`                     |
| `ingress.extraTls`                 | The tls configuration for additional hostnames to be covered with this ingress record.                                           | `[]`                     |
| `ingress.secrets`                  | If you're providing your own certificates, please use this to add the certificates as secrets                                    | `[]`                     |


### Metrics parameters

| Name                          | Description                                                | Value                     |
| ----------------------------- | ---------------------------------------------------------- | ------------------------- |
| `metrics.enabled`             | Start a side-car prometheus exporter                       | `false`                   |
| `metrics.image.registry`      | Apache exporter image registry                             | `docker.io`               |
| `metrics.image.repository`    | Apache exporter image repository                           | `bitnami/apache-exporter` |
| `metrics.image.tag`           | Apache exporter image tag (immutable tags are recommended) | `0.10.1-debian-10-r52`    |
| `metrics.image.pullPolicy`    | Image pull policy                                          | `IfNotPresent`            |
| `metrics.image.pullSecrets`   | Specify docker-registry secret names as an array           | `[]`                      |
| `metrics.resources.limits`    | The resources limits for the metrics container             | `{}`                      |
| `metrics.resources.requests`  | The requested resources for the metrics container          | `{}`                      |
| `metrics.service.type`        | Prometheus metrics service type                            | `ClusterIP`               |
| `metrics.service.port`        | Service Metrics port                                       | `9117`                    |
| `metrics.service.annotations` | Annotations for the Prometheus exporter service            | `{}`                      |


### Certificate injection parameters

| Name                                                 | Description                                                          | Value                                    |
| ---------------------------------------------------- | -------------------------------------------------------------------- | ---------------------------------------- |
| `certificates.customCertificate.certificateSecret`   | Secret containing the certificate and key to add                     | `""`                                     |
| `certificates.customCertificate.chainSecret.name`    | Name of the secret containing the certificate chain                  | `""`                                     |
| `certificates.customCertificate.chainSecret.key`     | Key of the certificate chain file inside the secret                  | `""`                                     |
| `certificates.customCertificate.certificateLocation` | Location in the container to store the certificate                   | `/etc/ssl/certs/ssl-cert-snakeoil.pem`   |
| `certificates.customCertificate.keyLocation`         | Location in the container to store the private key                   | `/etc/ssl/private/ssl-cert-snakeoil.key` |
| `certificates.customCertificate.chainLocation`       | Location in the container to store the certificate chain             | `/etc/ssl/certs/mychain.pem`             |
| `certificates.customCAs`                             | Defines a list of secrets to import into the container trust store   | `[]`                                     |
| `certificates.command`                               | Override default container command (useful when using custom images) | `[]`                                     |
| `certificates.args`                                  | Override default container args (useful when using custom images)    | `[]`                                     |
| `certificates.extraEnvVars`                          | Container sidecar extra environment variables (eg proxy)             | `[]`                                     |
| `certificates.extraEnvVarsCM`                        | ConfigMap containing extra env vars                                  | `""`                                     |
| `certificates.extraEnvVarsSecret`                    | Secret containing extra env vars (in case of sensitive data)         | `""`                                     |
| `certificates.image.registry`                        | Container sidecar registry                                           | `docker.io`                              |
| `certificates.image.repository`                      | Container sidecar image                                              | `bitnami/bitnami-shell`                  |
| `certificates.image.tag`                             | Container sidecar image tag (immutable tags are recommended)         | `10-debian-10-r250`                      |
| `certificates.image.pullPolicy`                      | Container sidecar image pull policy                                  | `IfNotPresent`                           |
| `certificates.image.pullSecrets`                     | Container sidecar image pull secrets                                 | `[]`                                     |


### Other Parameters

| Name                       | Description                          | Value   |
| -------------------------- | ------------------------------------ | ------- |
| `autoscaling.enabled`      | Enable autoscaling for replicas      | `false` |
| `autoscaling.minReplicas`  | Minimum number of replicas           | `1`     |
| `autoscaling.maxReplicas`  | Maximum number of replicas           | `11`    |
| `autoscaling.targetCPU`    | Target CPU utilization percentage    | `""`    |
| `autoscaling.targetMemory` | Target Memory utilization percentage | `""`    |


The above parameters map to the env variables defined in [securitybunker/databunker](https://github.com/securitybunker/databunker). For more information please refer to the [securitybunker/databunker](https://github.com/securitybunker/databunker) image documentation.

> **Note**:
>
> Optionally, you can specify the `service.loadBalancerIP` parameter to assign a reserved IP address to the Databunker service of the chart. However please note that this feature is only available on a few cloud providers (f.e. GKE).
>
> To reserve a public IP address on GKE:
>
> ```bash
> $ gcloud compute addresses create databunker-public-ip
> ```
>
> The reserved IP address can be associated to the Databunker service by specifying it as the value of the `service.loadBalancerIP` parameter while installing the chart.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install my-release \
  --set mariadb.primary.persistence.enabled=false \
    bitnami/databunker
```

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as master key, using Helm.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install my-release -f values.yaml bitnami/databunker
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Image

The `image` parameter allows specifying which image will be pulled for the chart.

#### Private registry

If you configure the `image` value to one in a private registry, you will need to [specify an image pull secret](https://kubernetes.io/docs/concepts/containers/images/#specifying-imagepullsecrets-on-a-pod).

1. Manually create image pull secret(s) in the namespace. See [this YAML example reference](https://kubernetes.io/docs/concepts/containers/images/#creating-a-secret-with-a-docker-config). Consult your image registry's documentation about getting the appropriate secret.
1. Note that the `imagePullSecrets` configuration value cannot currently be passed to helm using the `--set` parameter, so you must supply these using a `values.yaml` file, such as:

    ```yaml
    imagePullSecrets:
      - name: SECRET_NAME
    ```

1. Install the chart

### Ingress

This chart provides support for ingress resources. If you have an ingress controller installed on your cluster, such as [nginx-ingress-controller](https://github.com/bitnami/charts/tree/master/bitnami/nginx-ingress-controller) or [contour](https://github.com/bitnami/charts/tree/master/bitnami/contour) you can utilize the ingress controller to serve your application.

To enable ingress integration, please set `ingress.enabled` to `true`.

> Tip! Make sure you need to use the **ingress** controller before Databunker.
It works as a proxy and will decode the SSL traffic. Instead, you can easily configure Databunker to use imported or self-signed SSL certificates.


#### Hosts

Most likely you will only want to have one hostname that maps to this Databunker installation. If that's your case, the property `ingress.hostname` will set it. However, it is possible to have more than one host. To facilitate this, the `ingress.extraHosts` object can be specified as an array. You can also use `ingress.extraTLS` to add the TLS configuration for extra hosts.

For each host indicated at `ingress.extraHosts`, please indicate a `name`, `path`, and any `annotations` that you may want the ingress controller to know about.

For annotations, please see [this document](https://github.com/kubernetes/ingress-nginx/blob/master/docs/user-guide/nginx-configuration/annotations.md). Not all annotations are supported by all ingress controllers, but this document does a good job of indicating which annotation is supported by many popular ingress controllers.

### TLS Secrets

This chart will facilitate the creation of TLS secrets for use with the ingress controller, however, this is not required. There are three common use cases:

- Helm generates/manages certificate secrets.
- User generates/manages certificates separately.
- An additional tool (like [cert-manager](https://github.com/jetstack/cert-manager/)) manages the secrets for the application.

In the first two cases, it's needed a certificate and a key. We would expect them to look like this:

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

If you are going to manage TLS secrets outside of Helm, please know that you can create a TLS secret (named `databunker.service-tls` for example).

### Adding extra environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `extraEnvVars` property.

```yaml
extraEnvVars:
  - name: LOG_LEVEL
    value: DEBUG
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values.

### Sidecars and Init Containers

If you have a need for additional containers to run within the same pod as Databunker (e.g. an additional metrics or logging exporter), you can do so via the `sidecars` config parameter. Simply define your container according to the Kubernetes container spec.

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

### Using an external database

Sometimes you may want to have Databunker connect to an external database rather than installing one inside your cluster, e.g. to use a managed database service, or use run a single database server for all your applications. To do this, the chart allows you to specify credentials for an external database under the [`externalDatabase` parameter](#parameters). You should also disable the MariaDB installation with the `mariadb.enabled` option. For example with the following parameters:

```console
mariadb.enabled=false
externalDatabase.host=myexternalhost
externalDatabase.user=myuser
externalDatabase.password=mypassword
externalDatabase.database=mydatabase
externalDatabase.port=3306
```

Note also if you disable MariaDB per above you MUST supply values for the `externalDatabase` connection.

## CA Certificates

Custom CA self-signed certificate can be initialized during the chart deployment in automatic way using the ```openssl``` command.

```yaml
certificates:
  customCAs:
  - secret: databunker
```

## Loading external certificate

You can configure this chart to load certificates you created outside of container. This certificate will be saved in secret store and mapped to files in Databunker container:

```yaml
certificates:
  customCertificate:
    certificateSecret: "databunkertls"
    chainSecret:
      name: ""
      key: ""
    certificateLocation: /etc/ssl/certs/ssl-cert-snakeoil.pem
    keyLocation: /etc/ssl/private/ssl-cert-snakeoil.key
    chainLocation: /etc/ssl/certs/mychain.pem
```

> Tip! You can create a self-signed certificate and a secret containing your certificates using the following command:
```bash
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout tls.key -out tls.crt -subj "/CN=localhost"
kubectl create secret tls databunkertls --key="tls.key" --cert="tls.crt"
```

### Setting Pod's affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more infomation about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami’s Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Notable changes

### 1.0.2

In this major there were three main changes introduced:

- Optimize Databunker installation
