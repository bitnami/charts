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

| Name                      | Description                                     | Value       |
| ------------------------- | ----------------------------------------------- | ----------- |
| `global.imageRegistry`    | Global Docker image registry                    | `nil`       |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `undefined` |
| `global.storageClass`     | Global StorageClass for Persistent Volume(s)    | `nil`       |


### Common parameters

| Name                | Description                                        | Value           |
| ------------------- | -------------------------------------------------- | --------------- |
| `kubeVersion`       | Override Kubernetes version                        | `nil`           |
| `nameOverride`      | String to partially override common.names.fullname | `nil`           |
| `fullnameOverride`  | String to fully override common.names.fullname     | `nil`           |
| `commonLabels`      | Labels to add to all deployed objects              | `undefined`     |
| `commonAnnotations` | Annotations to add to all deployed objects         | `undefined`     |
| `clusterDomain`     | Kubernetes cluster domain name                     | `cluster.local` |
| `extraDeploy`       | Array of extra objects to deploy with the release  | `undefined`     |


### Traffic Exposure Parameters

| Name                               | Description                                                                                           | Value                    |
| ---------------------------------- | ----------------------------------------------------------------------------------------------------- | ------------------------ |
| `service.type`                     | OAuth2 Proxy service type                                                                             | `LoadBalancer`           |
| `service.port`                     | OAuth2 Proxy service HTTP port                                                                        | `8080`                   |
| `service.nodePorts.http`           | Node port for HTTP                                                                                    | `nil`                    |
| `service.clusterIP`                | OAuth2 Proxy service Cluster IP                                                                       | `nil`                    |
| `service.loadBalancerIP`           | OAuth2 Proxy service Load Balancer IP                                                                 | `nil`                    |
| `service.loadBalancerSourceRanges` | OAuth2 Proxy service Load Balancer sources                                                            | `undefined`              |
| `service.externalTrafficPolicy`    | OAuth2 Proxy service external traffic policy                                                          | `Cluster`                |
| `service.annotations`              | Additional custom annotations for OAuth2 Proxy service                                                | `undefined`              |
| `ingress.enabled`                  | Enable ingress record generation for WordPress                                                        | `false`                  |
| `ingress.certManager`              | Add the corresponding annotations for cert-manager integration                                        | `false`                  |
| `ingress.pathType`                 | Ingress path type                                                                                     | `ImplementationSpecific` |
| `ingress.apiVersion`               | Force Ingress API version (automatically detected if not set)                                         | `nil`                    |
| `ingress.hostname`                 | Default host for the ingress record                                                                   | `oaut2-proxy.local`      |
| `ingress.path`                     | Default path for the ingress record                                                                   | `ImplementationSpecific` |
| `ingress.annotations`              | Additional custom annotations for the ingress record                                                  | `undefined`              |
| `ingress.tls`                      | Enable TLS configuration for the host defined at `ingress.hostname` parameter                         | `false`                  |
| `ingress.extraHosts`               | An array with additional hostname(s) to be covered with the ingress record                            | `undefined`              |
| `ingress.extraPaths`               | An array with additional arbitrary paths that may need to be added to the ingress under the main host | `undefined`              |
| `ingress.extraTls`                 | TLS configuration for additional hostname(s) to be covered with this ingress record                   | `undefined`              |


### OAuth2 Proxy Image parameters

| Name                | Description                                             | Value                  |
| ------------------- | ------------------------------------------------------- | ---------------------- |
| `image.registry`    | OAuth2 Proxy image registry                             | `docker.io`            |
| `image.repository`  | OAuth2 Proxy image repository                           | `bitnami/oauth2-proxy` |
| `image.tag`         | OAuth2 Proxy image tag (immutable tags are recommended) | `7.1.3-debian-10-r25`  |
| `image.pullPolicy`  | OAuth2 Proxy image pull policy                          | `IfNotPresent`         |
| `image.pullSecrets` | OAuth2 Proxy image pull secrets                         | `undefined`            |
| `image.debug`       | Enable image debug mode                                 | `false`                |


### Oauth client configuration specifics

| Name                                        | Description                       | Value                                                        |
| ------------------------------------------- | --------------------------------- | ------------------------------------------------------------ |
| `config.clientID`                           | OAuth client ID                   | `XXXXXXX`                                                    |
| `config.clientSecret`                       | OAuth client secret               | `XXXXXXXX`                                                   |
| `config.cookieSecret`                       | OAuth cookie secret               | `XXXXXXXXXX`                                                 |
| `config.google`                             | Google service account            | `undefined`                                                  |
| `config.configFile`                         | Default configuration             | `email_domains = [ "*" ]
upstreams = [ "file:///dev/null" ]` |
| `authenticatedEmailsFile.enabled`           | Enable authenticated emails file  | `false`                                                      |
| `authenticatedEmailsFile.persistence`       | Defines file method               | `configmap`                                                  |
| `authenticatedEmailsFile.restricted_access` | Restricted access list            | `foo`                                                        |
| `authenticatedEmailsFile.template`          | Name of the configmap             | `""`                                                         |
| `htpasswdFile.enabled`                      | Enable htpasswd file              | `false`                                                      |
| `htpasswdFile.existingSecret`               | Existing secret for htpasswd file | `""`                                                         |
| `htpasswdFile.entries`                      | htpasswd file entries             | `undefined`                                                  |


### OAuth2 Proxy deployment parameters

| Name                                 | Description                                                                                | Value           |
| ------------------------------------ | ------------------------------------------------------------------------------------------ | --------------- |
| `replicaCount`                       | Number of OAuth2 Proxy replicas to deploy                                                  | `1`             |
| `livenessProbe.enabled`              | Enable livenessProbe on OAuth2 Proxy nodes                                                 | `true`          |
| `livenessProbe.httpGet.path`         | httpGet path                                                                               | `/ping`         |
| `livenessProbe.httpGet.port`         | httpGet port                                                                               | `http`          |
| `livenessProbe.httpGet.scheme`       | httpGet scheme                                                                             | `HTTP`          |
| `livenessProbe.initialDelaySeconds`  | Initial delay seconds for livenessProbe                                                    | `0`             |
| `livenessProbe.periodSeconds`        | Period seconds for livenessProbe                                                           | `10`            |
| `livenessProbe.timeoutSeconds`       | Timeout seconds for livenessProbe                                                          | `1`             |
| `livenessProbe.failureThreshold`     | Failure threshold for livenessProbe                                                        | `5`             |
| `livenessProbe.successThreshold`     | Success threshold for livenessProbe                                                        | `1`             |
| `readinessProbe.enabled`             | Enable readinessProbe on OAuth2 Proxy nodes                                                | `true`          |
| `readinessProbe.httpGet.path`        | httpGet path                                                                               | `/ping`         |
| `readinessProbe.httpGet.port`        | httpGet port                                                                               | `http`          |
| `readinessProbe.httpGet.scheme`      | httpGet scheme                                                                             | `HTTP`          |
| `readinessProbe.initialDelaySeconds` | Initial delay seconds for readinessProbe                                                   | `0`             |
| `readinessProbe.periodSeconds`       | Period seconds for readinessProbe                                                          | `10`            |
| `readinessProbe.timeoutSeconds`      | Timeout seconds for readinessProbe                                                         | `1`             |
| `readinessProbe.failureThreshold`    | Failure threshold for readinessProbe                                                       | `5`             |
| `readinessProbe.successThreshold`    | Success threshold for readinessProbe                                                       | `1`             |
| `customLivenessProbe`                | Custom livenessProbe that overrides the default one                                        | `undefined`     |
| `customReadinessProbe`               | Custom readinessProbe that overrides the default one                                       | `undefined`     |
| `resources.limits`                   | The resources limits for the OAuth2 Proxy containers                                       | `undefined`     |
| `resources.requests`                 | The requested resources for the OAuth2 Proxy containers                                    | `undefined`     |
| `podDisruptionBudget`                | Configure pod disruptions                                                                  | `undefined`     |
| `podSecurityContext.enabled`         | Enabled OAuth2 Proxy pods' Security Context                                                | `true`          |
| `podSecurityContext.fsGroup`         | Set OAuth2 Proxy pod's Security Context fsGroup                                            | `1001`          |
| `containerSecurityContext.enabled`   | Enabled OAuth2 Proxy containers' Security Context                                          | `true`          |
| `containerSecurityContext.runAsUser` | Set OAuth2 Proxy containers' Security Context runAsUser                                    | `1001`          |
| `command`                            | Override default container command (useful when using custom images)                       | `undefined`     |
| `args`                               | Override default container args (useful when using custom images)                          | `undefined`     |
| `hostAliases`                        | OAuth2 Proxy pods host aliases                                                             | `undefined`     |
| `podLabels`                          | Extra labels for OAuth2 Proxy pods                                                         | `undefined`     |
| `podAnnotations`                     | Annotations for OAuth2 Proxy pods                                                          | `undefined`     |
| `podAffinityPreset`                  | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`        | `""`            |
| `podAntiAffinityPreset`              | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`   | `soft`          |
| `nodeAffinityPreset.type`            | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`  | `""`            |
| `nodeAffinityPreset.key`             | Node label key to match. Ignored if `affinity` is set                                      | `""`            |
| `nodeAffinityPreset.values`          | Node label values to match. Ignored if `affinity` is set                                   | `undefined`     |
| `affinity`                           | Affinity for OAuth2 Proxy pods assignment                                                  | `undefined`     |
| `nodeSelector`                       | Node labels for OAuth2 Proxy pods assignment                                               | `undefined`     |
| `tolerations`                        | Tolerations for OAuth2 Proxy pods assignment                                               | `undefined`     |
| `updateStrategy.type`                | OAuth2 Proxy statefulset strategy type                                                     | `RollingUpdate` |
| `priorityClassName`                  | OAuth2 Proxy pods' priorityClassName                                                       | `""`            |
| `lifecycleHooks`                     | for the OAuth2 Proxy container(s) to automate configuration before or after startup        | `undefined`     |
| `proxyVarsAsSecrets`                 | Whether to use secrets instead of environment values for setting up OAUTH2_PROXY variables | `true`          |
| `extraEnvVars`                       | Array with extra environment variables to add to OAuth2 Proxy nodes                        | `undefined`     |
| `extraEnvVarsCM`                     | Name of existing ConfigMap containing extra env vars for OAuth2 Proxy nodes                | `nil`           |
| `extraEnvVarsSecret`                 | Name of existing Secret containing extra env vars for OAuth2 Proxy nodes                   | `nil`           |
| `extraVolumes`                       | Optionally specify extra list of additional volumes for the OAuth2 Proxy pod(s)            | `undefined`     |
| `extraVolumeMounts`                  | Optionally specify extra list of additional volumeMounts for the OAuth2 Proxy container(s) | `undefined`     |
| `sidecars`                           | Add additional sidecar containers to the OAuth2 Proxy pod(s)                               | `undefined`     |
| `initContainers`                     | Add additional init containers to the OAuth2 Proxy pod(s)                                  | `undefined`     |
| `serviceAccount.create`              | Specifies whether a ServiceAccount should be created                                       | `true`          |
| `serviceAccount.name`                | The name of the ServiceAccount to use                                                      | `""`            |

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
