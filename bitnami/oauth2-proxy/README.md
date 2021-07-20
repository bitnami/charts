# OAuth2 Proxy

[oauth2-proxy](https://github.com/oauth2-proxy/oauth2-proxy) is a reverse proxy and static file server that provides authentication using Providers (Google, GitHub, and others) to validate accounts by email, domain or group.

## TL;DR

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/oauth2-proxy
```

## Introduction

Bitnami charts for Helm are carefully engineered, actively maintained and are the quickest and easiest way to deploy containers on a Kubernetes cluster that are ready to handle production workloads.

This chart bootstraps a [OAuth2 Proxy](https://github.com/oauth2-proxy/oauth2-proxy) Deployment in a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This Helm chart has been tested on top of [Bitnami Kubernetes Production Runtime](https://kubeprod.io/) (BKPR). Deploy BKPR to get automated TLS certificates, logging and monitoring for your applications.

## Prerequisites

- Kubernetes 1.12+
- Helm 3.1.0
- PV provisioner support in the underlying infrastructure
- ReadWriteMany volumes for deployment scaling

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release bitnami/oauth2-proxys
```

The command deploys OAuth2 Proxy on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
helm delete my-release
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

| Name                     | Description                                                                             | Value           |
| ------------------------ | --------------------------------------------------------------------------------------- | --------------- |
| `kubeVersion`            | Override Kubernetes version                                                             | `""`            |
| `nameOverride`           | String to partially override common.names.fullname                                      | `""`            |
| `fullnameOverride`       | String to fully override common.names.fullname                                          | `""`            |
| `commonLabels`           | Labels to add to all deployed objects                                                   | `{}`            |
| `commonAnnotations`      | Annotations to add to all deployed objects                                              | `{}`            |
| `clusterDomain`          | Kubernetes cluster domain name                                                          | `cluster.local` |
| `extraDeploy`            | Array of extra objects to deploy with the release                                       | `[]`            |
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden) | `false`         |
| `diagnosticMode.command` | Command to override all containers in the deployment                                    | `[]`            |
| `diagnosticMode.args`    | Args to override all containers in the deployment                                       | `[]`            |


### Traffic Exposure Parameters

| Name                               | Description                                                                                           | Value                    |
| ---------------------------------- | ----------------------------------------------------------------------------------------------------- | ------------------------ |
| `service.type`                     | OAuth2 Proxy service type                                                                             | `ClusterIP`              |
| `service.port`                     | OAuth2 Proxy service HTTP port                                                                        | `80`                     |
| `service.nodePorts.http`           | Node port for HTTP                                                                                    | `""`                     |
| `service.clusterIP`                | OAuth2 Proxy service Cluster IP                                                                       | `""`                     |
| `service.loadBalancerIP`           | OAuth2 Proxy service Load Balancer IP                                                                 | `""`                     |
| `service.loadBalancerSourceRanges` | OAuth2 Proxy service Load Balancer sources                                                            | `[]`                     |
| `service.externalTrafficPolicy`    | OAuth2 Proxy service external traffic policy                                                          | `Cluster`                |
| `service.annotations`              | Additional custom annotations for OAuth2 Proxy service                                                | `{}`                     |
| `ingress.enabled`                  | Enable ingress record generation for WordPress                                                        | `false`                  |
| `ingress.certManager`              | Add the corresponding annotations for cert-manager integration                                        | `false`                  |
| `ingress.pathType`                 | Ingress path type                                                                                     | `ImplementationSpecific` |
| `ingress.apiVersion`               | Force Ingress API version (automatically detected if not set)                                         | `""`                     |
| `ingress.hostname`                 | Default host for the ingress record                                                                   | `oaut2-proxy.local`      |
| `ingress.path`                     | Default path for the ingress record                                                                   | `ImplementationSpecific` |
| `ingress.annotations`              | Additional custom annotations for the ingress record                                                  | `{}`                     |
| `ingress.tls`                      | Enable TLS configuration for the host defined at `ingress.hostname` parameter                         | `false`                  |
| `ingress.extraHosts`               | An array with additional hostname(s) to be covered with the ingress record                            | `[]`                     |
| `ingress.extraPaths`               | An array with additional arbitrary paths that may need to be added to the ingress under the main host | `[]`                     |
| `ingress.extraTls`                 | TLS configuration for additional hostname(s) to be covered with this ingress record                   | `[]`                     |


### OAuth2 Proxy Image parameters

| Name                | Description                                             | Value                  |
| ------------------- | ------------------------------------------------------- | ---------------------- |
| `image.registry`    | OAuth2 Proxy image registry                             | `docker.io`            |
| `image.repository`  | OAuth2 Proxy image repository                           | `bitnami/oauth2-proxy` |
| `image.tag`         | OAuth2 Proxy image tag (immutable tags are recommended) | `7.1.3-debian-10-r69`  |
| `image.pullPolicy`  | OAuth2 Proxy image pull policy                          | `IfNotPresent`         |
| `image.pullSecrets` | OAuth2 Proxy image pull secrets                         | `[]`                   |


### OAuth2 Proxy configuration parameters

| Name                                                   | Description                                         | Value                                                         |
| ------------------------------------------------------ | --------------------------------------------------- | ------------------------------------------------------------- |
| `configuration.clientID`                               | OAuth client ID                                     | `XXXXXXX`                                                     |
| `configuration.clientSecret`                           | OAuth client secret                                 | `XXXXXXXX`                                                    |
| `configuration.cookieSecret`                           | OAuth cookie secret                                 | `XXXXXXXXXXXXXXXX`                                            |
| `configuration.existingSecret`                         | Secret with the client ID, secret and cookie secret | `""`                                                          |
| `configuration.google.enabled`                         | Enable Google service account                       | `false`                                                       |
| `configuration.google.adminEmail`                      | Google admin email                                  | `""`                                                          |
| `configuration.google.serviceAccountJson`              | Google Service account JSON                         | `""`                                                          |
| `configuration.google.existingSecret`                  | Existing secret containing Google Service Account   | `""`                                                          |
| `configuration.content`                                | Default configuration                               | `email_domains = [ "*" ] upstreams = [ "file:///dev/null" ]`  |
| `configuration.existingConfigmap`                      | Configmap with the OAuth2 Proxy configuration       | `""`                                                          |
| `configuration.authenticatedEmailsFile.enabled`        | Enable authenticated emails file                    | `false`                                                       |
| `configuration.authenticatedEmailsFile.content`        | Restricted access list (one email per line)         | `""`                                                          |
| `configuration.authenticatedEmailsFile.existingSecret` | Secret with the authenticated emails file           | `""`                                                          |
| `configuration.htpasswdFile.enabled`                   | Enable htpasswd file                                | `false`                                                       |
| `configuration.htpasswdFile.existingSecret`            | Existing secret for htpasswd file                   | `""`                                                          |
| `configuration.htpasswdFile.content`                   | htpasswd file entries (one row per user)            | `""`                                                          |

### OAuth2 Proxy deployment parameters

| Name                                 | Description                                                                                | Value           |
| ------------------------------------ | ------------------------------------------------------------------------------------------ | --------------- |
| `containerPort`                      | OAuth2 Proxy port number                                                                   | `4180`          |
| `replicaCount`                       | Number of OAuth2 Proxy replicas to deploy                                                  | `1`             |
| `extraArgs`                          | add extra args to the default command                                                      | `[]`            |
| `livenessProbe.enabled`              | Enable livenessProbe on OAuth2 Proxy nodes                                                 | `true`          |
| `livenessProbe.initialDelaySeconds`  | Initial delay seconds for livenessProbe                                                    | `0`             |
| `livenessProbe.periodSeconds`        | Period seconds for livenessProbe                                                           | `10`            |
| `livenessProbe.timeoutSeconds`       | Timeout seconds for livenessProbe                                                          | `1`             |
| `livenessProbe.failureThreshold`     | Failure threshold for livenessProbe                                                        | `5`             |
| `livenessProbe.successThreshold`     | Success threshold for livenessProbe                                                        | `1`             |
| `readinessProbe.enabled`             | Enable readinessProbe on OAuth2 Proxy nodes                                                | `true`          |
| `readinessProbe.initialDelaySeconds` | Initial delay seconds for readinessProbe                                                   | `0`             |
| `readinessProbe.periodSeconds`       | Period seconds for readinessProbe                                                          | `10`            |
| `readinessProbe.timeoutSeconds`      | Timeout seconds for readinessProbe                                                         | `1`             |
| `readinessProbe.failureThreshold`    | Failure threshold for readinessProbe                                                       | `5`             |
| `readinessProbe.successThreshold`    | Success threshold for readinessProbe                                                       | `1`             |
| `customLivenessProbe`                | Custom livenessProbe that overrides the default one                                        | `{}`            |
| `customReadinessProbe`               | Custom readinessProbe that overrides the default one                                       | `{}`            |
| `resources.limits`                   | The resources limits for the OAuth2 Proxy containers                                       | `{}`            |
| `resources.requests`                 | The requested resources for the OAuth2 Proxy containers                                    | `{}`            |
| `pdb.create`                         | Enable a Pod Disruption Budget creation                                                    | `false`         |
| `pdb.minAvailable`                   | Minimum number/percentage of pods that should remain scheduled                             | `1`             |
| `pdb.maxUnavailable`                 | Maximum number/percentage of pods that may be made unavailable                             | `1`             |
| `podSecurityContext.enabled`         | Enabled OAuth2 Proxy pods' Security Context                                                | `true`          |
| `podSecurityContext.fsGroup`         | Set OAuth2 Proxy pod's Security Context fsGroup                                            | `1001`          |
| `containerSecurityContext.enabled`   | Enabled OAuth2 Proxy containers' Security Context                                          | `true`          |
| `containerSecurityContext.runAsUser` | Set OAuth2 Proxy containers' Security Context runAsUser                                    | `1001`          |
| `command`                            | Override default container command (useful when using custom images)                       | `[]`            |
| `args`                               | Override default container args (useful when using custom images)                          | `[]`            |
| `hostAliases`                        | OAuth2 Proxy pods host aliases                                                             | `[]`            |
| `podLabels`                          | Extra labels for OAuth2 Proxy pods                                                         | `{}`            |
| `podAnnotations`                     | Annotations for OAuth2 Proxy pods                                                          | `{}`            |
| `podAffinityPreset`                  | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`        | `""`            |
| `podAntiAffinityPreset`              | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`   | `soft`          |
| `nodeAffinityPreset.type`            | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`  | `""`            |
| `nodeAffinityPreset.key`             | Node label key to match. Ignored if `affinity` is set                                      | `""`            |
| `nodeAffinityPreset.values`          | Node label values to match. Ignored if `affinity` is set                                   | `[]`            |
| `affinity`                           | Affinity for OAuth2 Proxy pods assignment                                                  | `{}`            |
| `nodeSelector`                       | Node labels for OAuth2 Proxy pods assignment                                               | `{}`            |
| `tolerations`                        | Tolerations for OAuth2 Proxy pods assignment                                               | `[]`            |
| `updateStrategy.type`                | OAuth2 Proxy statefulset strategy type                                                     | `RollingUpdate` |
| `priorityClassName`                  | OAuth2 Proxy pods' priorityClassName                                                       | `""`            |
| `lifecycleHooks`                     | for the OAuth2 Proxy container(s) to automate configuration before or after startup        | `{}`            |
| `extraEnvVars`                       | Array with extra environment variables to add to OAuth2 Proxy nodes                        | `[]`            |
| `extraEnvVarsCM`                     | Name of existing ConfigMap containing extra env vars for OAuth2 Proxy nodes                | `""`            |
| `extraEnvVarsSecret`                 | Name of existing Secret containing extra env vars for OAuth2 Proxy nodes                   | `""`            |
| `extraVolumes`                       | Optionally specify extra list of additional volumes for the OAuth2 Proxy pod(s)            | `[]`            |
| `extraVolumeMounts`                  | Optionally specify extra list of additional volumeMounts for the OAuth2 Proxy container(s) | `[]`            |
| `sidecars`                           | Add additional sidecar containers to the OAuth2 Proxy pod(s)                               | `{}`            |
| `initContainers`                     | Add additional init containers to the OAuth2 Proxy pod(s)                                  | `{}`            |
| `serviceAccount.create`              | Specifies whether a ServiceAccount should be created                                       | `true`          |
| `serviceAccount.name`                | The name of the ServiceAccount to use                                                      | `""`            |


### External Redis(TM) parameters

| Name                           | Description                                               | Value  |
| ------------------------------ | --------------------------------------------------------- | ------ |
| `externalRedis.host`           | External Redis(TM) server host                            | `""`   |
| `externalRedis.password`       | External Redis(TM) user password                          | `""`   |
| `externalRedis.port`           | External Redis(TM) server port                            | `6379` |
| `externalRedis.existingSecret` | The name of an existing secret with Redis(TM) credentials | `""`   |


### Redis(TM) sub-chart parameters

| Name                                   | Description                                               | Value        |
| -------------------------------------- | --------------------------------------------------------- | ------------ |
| `redis.enabled`                        | Deploy Redis(TM) sub-chart                                | `true`       |
| `redis.architecture`                   | Redis(TM) architecture                                    | `standalone` |
| `redis.master.service.port`            | Redis(TM) (without Sentinel) service port                 | `6379`       |
| `redis.replica.replicaCount`           | Number of Redis(TM) replicas                              | `3`          |
| `redis.auth.enabled`                   | Enable Redis(TM) authentication                           | `true`       |
| `redis.auth.existingSecret`            | Secret with Redis(TM) credentials                         | `""`         |
| `redis.auth.existingSecretPasswordKey` | Key inside the existing secret with Redis(TM) credentials | `""`         |
| `redis.auth.sentinel`                  | Enable authentication in the Sentinel nodes               | `true`       |
| `redis.sentinel.enabled`               | Enable Redis(TM) sentinel in the deployment               | `false`      |
| `redis.sentinel.masterSet`             | Name of the Redis(TM) Sentinel master set                 | `mymaster`   |
| `redis.sentinel.service.port`          | Redis(TM) (with Sentinel) service port                    | `6379`       |
| `redis.sentinel.service.sentinelPort`  | Redis(TM) (with Sentinel) sentinel service port           | `26379`      |


See https://github.com/bitnami-labs/readmenator to create the table

The above parameters map to the env variables defined in [bitnami/oauth2-proxy](http://github.com/bitnami/bitnami-docker-oauth2-proxy). For more information please refer to the [bitnami/oauth2-proxy](http://github.com/bitnami/bitnami-docker-oauth2-proxy) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
  --set replicaCount=2 \
    bitnami/oauth2-proxy
```

The above command increase the default number of replicas.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml bitnami/oauth2-proxy
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Ingress

This chart provides support for Ingress resources. If an Ingress controller, such as [nginx-ingress](https://kubeapps.com/charts/stable/nginx-ingress) or [traefik](https://kubeapps.com/charts/stable/traefik), that Ingress controller can be used to serve OAuth2 Proxy.

To enable Ingress integration, set `ingress.enabled` to `true`. The `ingress.hostname` property can be used to set the host name. The `ingress.tls` parameter can be used to add the TLS configuration for this host. It is also possible to have more than one host, with a separate TLS configuration for each host. [Learn more about configuring and using Ingress](https://docs.bitnami.com/kubernetes/apps/oauth2-proxy/configuration/configure-use-ingress/).

### TLS secrets

The chart also facilitates the creation of TLS secrets for use with the Ingress controller, with different options for certificate management. [Learn more about TLS secrets](https://docs.bitnami.com/kubernetes/apps/oauth2-proxy/administration/enable-tls/).

## Persistence

The [Bitnami OAuth2 Proxy](https://github.com/bitnami/bitnami-docker-oauth2-proxy) image stores the OAuth2 Proxy data and configurations at the `/bitnami` path of the container. Persistent Volume Claims are used to keep the data across deployments. [Learn more about persistence in the chart documentation](https://docs.bitnami.com/kubernetes/apps/oauth2-proxy/configuration/chart-persistence/).

### Additional environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `extraEnvVars` property.

```yaml
extraEnvVars:
  - name: LOG_LEVEL
    value: error
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values.

### Sidecars

If additional containers are needed in the same pod as OAuth2 Proxy (such as additional metrics or logging exporters), they can be defined using the `sidecars` parameter. If these sidecars export extra ports, extra port definitions can be added using the `service.extraPorts` parameter. [Learn more about configuring and using sidecar containers](https://docs.bitnami.com/kubernetes/apps/oauth2-proxy/administration/configure-use-sidecars/).

### Pod affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, use one of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).
