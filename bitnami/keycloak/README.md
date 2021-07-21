# Keycloak

[Keycloak](https://www.keycloak.org) is a high performance Java-based identity and access management solution. It lets developers add an authentication layer to their applications with minimum effort.

## TL;DR

```console
  helm repo add bitnami https://charts.bitnami.com/bitnami
  helm install my-release bitnami/keycloak
```

## Introduction

Bitnami charts for Helm are carefully engineered, actively maintained and are the quickest and easiest way to deploy containers on a Kubernetes cluster that are ready to handle production workloads.

This chart bootstraps a [Keycloak](https://github.com/bitnami/bitnami-docker-keycloak) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This Helm chart has been tested on top of [Bitnami Kubernetes Production Runtime](https://kubeprod.io/) (BKPR). Deploy BKPR to get automated TLS certificates, logging and monitoring for your applications.

## Prerequisites

- Kubernetes 1.12+
- Helm 3.1.0

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/keycloak
```

These commands deploy a Keycloak application on the Kubernetes cluster in the default configuration.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

### Global parameters

| Name                      | Description                                     | Value |
| ------------------------- | ----------------------------------------------- | ----- |
| `global.imageRegistry`    | Global Docker image registry                    | `nil` |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]`  |
| `global.storageClass`     | Global StorageClass for Persistent Volume(s)    | `nil` |


### Common parameters

| Name                | Description                                                          | Value           |
| ------------------- | -------------------------------------------------------------------- | --------------- |
| `kubeVersion`       | Force target Kubernetes version (using Helm capabilities if not set) | `nil`           |
| `nameOverride`      | String to partially override keycloak.fullname                       | `nil`           |
| `fullnameOverride`  | String to fully override keycloak.fullname                           | `nil`           |
| `hostAliases`       | Add deployment host aliases                                          | `[]`            |
| `commonLabels`      | Labels to add to all deployed objects                                | `{}`            |
| `commonAnnotations` | Annotations to add to all deployed objects                           | `{}`            |
| `clusterDomain`     | Default Kubernetes cluster domain                                    | `cluster.local` |
| `extraDeploy`       | Array of extra objects to deploy with the release                    | `[]`            |


### Keycloak parameters

| Name                              | Description                                                                                   | Value                  |
| --------------------------------- | --------------------------------------------------------------------------------------------- | ---------------------- |
| `image.registry`                  | Keycloak image registry                                                                       | `docker.io`            |
| `image.repository`                | Keycloak image repository                                                                     | `bitnami/keycloak`     |
| `image.tag`                       | Keycloak image tag (immutable tags are recommended)                                           | `13.0.1-debian-10-r18` |
| `image.pullPolicy`                | Keycloak image pull policy                                                                    | `IfNotPresent`         |
| `image.pullSecrets`               | Specify docker-registry secret names as an array                                              | `[]`                   |
| `image.debug`                     | Specify if debug logs should be enabled                                                       | `false`                |
| `auth.createAdminUser`            | Create administrator user on boot                                                             | `true`                 |
| `auth.adminUser`                  | Keycloak administrator user                                                                   | `user`                 |
| `auth.adminPassword`              | Keycloak administrator password for the new user                                              | `""`                   |
| `auth.managementUser`             | Wildfly management user                                                                       | `manager`              |
| `auth.managementPassword`         | Wildfly management password                                                                   | `""`                   |
| `auth.existingSecret`             | An already existing secret containing auth info                                               | `nil`                  |
| `auth.existingSecretPerPassword`  | Override `existingSecret` and other secret values                                             | `nil`                  |
| `auth.tls.enabled`                | Enable TLS encryption                                                                         | `false`                |
| `auth.tls.autoGenerated`          | Generate automatically self-signed TLS certificates. Currently only supports PEM certificates | `false`                |
| `auth.tls.existingSecret`         | Existing secret containing the TLS certificates per Keycloak replica                          | `nil`                  |
| `auth.tls.jksSecret`              | DEPRECATED. Use `auth.tls.existingSecret` instead                                             | `nil`                  |
| `auth.tls.keystorePassword`       | Password to access the keystore when it's password-protected                                  | `""`                   |
| `auth.tls.truststorePassword`     | Password to access the truststore when it's password-protected                                | `""`                   |
| `auth.tls.resources.limits`       | The resources limits for the TLS init container                                               | `{}`                   |
| `auth.tls.resources.requests`     | The requested resources for the TLS init container                                            | `{}`                   |
| `proxyAddressForwarding`          | Enable Proxy Address Forwarding                                                               | `false`                |
| `serviceDiscovery.enabled`        | Enable Service Discovery for Keycloak (required if `replicaCount` > `1`)                      | `false`                |
| `serviceDiscovery.protocol`       | Sets the protocol that Keycloak nodes would use to discover new peers                         | `kubernetes.KUBE_PING` |
| `serviceDiscovery.properties`     | Properties for the discovery protocol set in `serviceDiscovery.protocol` parameter            | `[]`                   |
| `serviceDiscovery.transportStack` | Transport stack for the discovery protocol set in `serviceDiscovery.protocol` parameter       | `tcp`                  |
| `cache.ownersCount`               | Number of nodes that will replicate cached data                                               | `1`                    |
| `cache.authOwnersCount`           | Number of nodes that will replicate cached authentication data                                | `1`                    |
| `configuration`                   | Keycloak Configuration. Auto-generated based on other parameters when not specified           | `nil`                  |
| `existingConfigmap`               | Name of existing ConfigMap with Keycloak configuration                                        | `nil`                  |
| `extraStartupArgs`                | Extra default startup args                                                                    | `nil`                  |
| `initdbScripts`                   | Dictionary of initdb scripts                                                                  | `{}`                   |
| `initdbScriptsConfigMap`          | ConfigMap with the initdb scripts (Note: Overrides `initdbScripts`)                           | `nil`                  |
| `command`                         | Override default container command (useful when using custom images)                          | `[]`                   |
| `args`                            | Override default container args (useful when using custom images)                             | `[]`                   |
| `extraEnvVars`                    | Extra environment variables to be set on Keycloak container                                   | `[]`                   |
| `extraEnvVarsCM`                  | Name of existing ConfigMap containing extra env vars                                          | `nil`                  |
| `extraEnvVarsSecret`              | Name of existing Secret containing extra env vars                                             | `nil`                  |


### keycloak-config-cli parameters

| Name                                                      | Description                                                                                     | Value                         |
| --------------------------------------------------------- | ----------------------------------------------------------------------------------------------- | ----------------------------- |
| `keycloakConfigCli.enabled`                               | Whether to enable keycloak-config-cli                                                           | `false`                       |
| `keycloakConfigCli.image.registry`                        | keycloak-config-cli container image registry                                                    | `docker.io`                   |
| `keycloakConfigCli.image.repository`                      | keycloak-config-cli container image repository                                                  | `bitnami/keycloak-config-cli` |
| `keycloakConfigCli.image.tag`                             | keycloak-config-cli container image tag                                                         | `3.4.0-debian-10-r26`         |
| `keycloakConfigCli.image.pullPolicy`                      | keycloak-config-cli container image pull policy                                                 | `IfNotPresent`                |
| `keycloakConfigCli.image.pullSecrets`                     | keycloak-config-cli container image pull secrets                                                | `[]`                          |
| `keycloakConfigCli.annotations`                           | Annotations for keycloak-config-cli job                                                         | `undefined`                   |
| `keycloakConfigCli.command`                               | Command for running the container (set to default if not set). Use array form                   | `[]`                          |
| `keycloakConfigCli.args`                                  | Args for running the container (set to default if not set). Use array form                      | `[]`                          |
| `keycloakConfigCli.hostAliases`                           | Job pod host aliases                                                                            | `[]`                          |
| `keycloakConfigCli.resources.limits`                      | The resources limits for the keycloak-config-cli container                                      | `{}`                          |
| `keycloakConfigCli.resources.requests`                    | The requested resources for the keycloak-config-cli container                                   | `{}`                          |
| `keycloakConfigCli.containerSecurityContext.enabled`      | Enabled keycloak-config-cli containers' Security Context                                        | `true`                        |
| `keycloakConfigCli.containerSecurityContext.runAsUser`    | Set keycloak-config-cli container's Security Context runAsUser                                  | `1001`                        |
| `keycloakConfigCli.containerSecurityContext.runAsNonRoot` | Set keycloak-config-cli container's Security Context runAsNonRoot                               | `true`                        |
| `keycloakConfigCli.podSecurityContext.enabled`            | Enabled keycloak-config-cli pods' Security Context                                              | `true`                        |
| `keycloakConfigCli.podSecurityContext.fsGroup`            | Set keycloak-config-cli pod's Security Context fsGroup                                          | `1001`                        |
| `keycloakConfigCli.backoffLimit`                          | Number of retries before considering a Job as failed                                            | `1`                           |
| `keycloakConfigCli.podLabels`                             | Pod extra labels                                                                                | `{}`                          |
| `keycloakConfigCli.podAnnotations`                        | Annotations for job pod                                                                         | `{}`                          |
| `keycloakConfigCli.extraEnvVars`                          | Additional environment variables to set                                                         | `[]`                          |
| `keycloakConfigCli.extraEnvVarsCM`                        | ConfigMap with extra environment variables                                                      | `nil`                         |
| `keycloakConfigCli.extraEnvVarsSecret`                    | Secret with extra environment variables                                                         | `nil`                         |
| `keycloakConfigCli.extraVolumes`                          | Extra volumes to add to the job                                                                 | `[]`                          |
| `keycloakConfigCli.extraVolumeMounts`                     | Extra volume mounts to add to the container                                                     | `[]`                          |
| `keycloakConfigCli.configuration`                         | keycloak-config-cli realms configuration                                                        | `{}`                          |
| `keycloakConfigCli.existingConfigmap`                     | ConfigMap with keycloak-config-cli configuration. This will override `keycloakConfigCli.config` | `nil`                         |


### Keycloak deployment/statefulset parameters

| Name                                    | Description                                                                               | Value                 |
| --------------------------------------- | ----------------------------------------------------------------------------------------- | --------------------- |
| `replicaCount`                          | Number of Keycloak replicas to deploy                                                     | `1`                   |
| `containerPorts`                        | Keycloak container ports to open                                                          | `{}`                  |
| `podSecurityContext.enabled`            | Enabled Keykloak pods' Security Context                                                   | `true`                |
| `podSecurityContext.fsGroup`            | Set Keykloak pod's Security Context fsGroup                                               | `1001`                |
| `containerSecurityContext.enabled`      | Enabled Keykloak containers' Security Context                                             | `true`                |
| `containerSecurityContext.runAsUser`    | Set Keykloak container's Security Context runAsUser                                       | `1001`                |
| `containerSecurityContext.runAsNonRoot` | Set Keykloak container's Security Context runAsNonRoot                                    | `true`                |
| `resources.limits`                      | The resources limits for the Keycloak container                                           | `{}`                  |
| `resources.requests`                    | The requested resources for the Keycloak container                                        | `{}`                  |
| `livenessProbe.enabled`                 | Enable livenessProbe                                                                      | `true`                |
| `livenessProbe.httpGet.path`            | Request path for livenessProbe                                                            | `/auth/`              |
| `livenessProbe.httpGet.port`            | Port for livenessProbe                                                                    | `http`                |
| `livenessProbe.initialDelaySeconds`     | Initial delay seconds for livenessProbe                                                   | `300`                 |
| `livenessProbe.periodSeconds`           | Period seconds for livenessProbe                                                          | `1`                   |
| `livenessProbe.timeoutSeconds`          | Timeout seconds for livenessProbe                                                         | `5`                   |
| `livenessProbe.failureThreshold`        | Failure threshold for livenessProbe                                                       | `3`                   |
| `livenessProbe.successThreshold`        | Success threshold for livenessProbe                                                       | `1`                   |
| `readinessProbe.enabled`                | Enable readinessProbe                                                                     | `true`                |
| `readinessProbe.httpGet.path`           | Request path for readinessProbe                                                           | `/auth/realms/master` |
| `readinessProbe.httpGet.port`           | Port for readinessProbe                                                                   | `http`                |
| `readinessProbe.initialDelaySeconds`    | Initial delay seconds for readinessProbe                                                  | `30`                  |
| `readinessProbe.periodSeconds`          | Period seconds for readinessProbe                                                         | `10`                  |
| `readinessProbe.timeoutSeconds`         | Timeout seconds for readinessProbe                                                        | `1`                   |
| `readinessProbe.failureThreshold`       | Failure threshold for readinessProbe                                                      | `3`                   |
| `readinessProbe.successThreshold`       | Success threshold for readinessProbe                                                      | `1`                   |
| `customLivenessProbe`                   | Custom Liveness probes for Keycloak                                                       | `{}`                  |
| `customReadinessProbe`                  | Custom Rediness probes Keycloak                                                           | `{}`                  |
| `updateStrategy.type`                   | StrategyType                                                                              | `RollingUpdate`       |
| `podAffinityPreset`                     | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`       | `""`                  |
| `podAntiAffinityPreset`                 | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`  | `soft`                |
| `nodeAffinityPreset.type`               | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard` | `""`                  |
| `nodeAffinityPreset.key`                | Node label key to match. Ignored if `affinity` is set.                                    | `""`                  |
| `nodeAffinityPreset.values`             | Node label values to match. Ignored if `affinity` is set.                                 | `[]`                  |
| `affinity`                              | Affinity for pod assignment                                                               | `{}`                  |
| `nodeSelector`                          | Node labels for pod assignment                                                            | `{}`                  |
| `tolerations`                           | Tolerations for pod assignment                                                            | `[]`                  |
| `podLabels`                             | Extra labels for Keycloak pods                                                            | `{}`                  |
| `podAnnotations`                        | Annotations for Keycloak pods                                                             | `{}`                  |
| `priorityClassName`                     | Keycloak pods' priority.                                                                  | `nil`                 |
| `lifecycleHooks`                        | LifecycleHooks to set additional configuration at startup                                 | `{}`                  |
| `extraVolumes`                          | Optionally specify extra list of additional volumes for Keycloak pods                     | `[]`                  |
| `extraVolumeMounts`                     | Optionally specify extra list of additional volumeMounts for Keycloak container(s)        | `[]`                  |
| `initContainers`                        | Add additional init containers to the Keycloak pods                                       | `{}`                  |
| `sidecars`                              | Add additional sidecar containers to the Keycloak pods                                    | `{}`                  |


### Exposure parameters

| Name                               | Description                                                                                   | Value                    |
| ---------------------------------- | --------------------------------------------------------------------------------------------- | ------------------------ |
| `service.type`                     | Kubernetes service type                                                                       | `LoadBalancer`           |
| `service.port`                     | Service HTTP port                                                                             | `80`                     |
| `service.httpsPort`                | HTTPS Port                                                                                    | `443`                    |
| `service.nodePorts`                | Specify the nodePort values for the LoadBalancer and NodePort service types.                  | `{}`                     |
| `service.clusterIP`                | Keycloak service clusterIP IP                                                                 | `nil`                    |
| `service.loadBalancerIP`           | loadBalancerIP for the SuiteCRM Service (optional, cloud specific)                            | `nil`                    |
| `service.loadBalancerSourceRanges` | Address that are allowed when service is LoadBalancer                                         | `[]`                     |
| `service.externalTrafficPolicy`    | Enable client source IP preservation                                                          | `Cluster`                |
| `service.annotations`              | Annotations for Keycloak service                                                              | `{}`                     |
| `ingress.enabled`                  | Enable ingress controller resource                                                            | `false`                  |
| `ingress.certManager`              | Add annotations for cert-manager                                                              | `false`                  |
| `ingress.hostname`                 | Default host for the ingress resource                                                         | `keycloak.local`         |
| `ingress.apiVersion`               | Force Ingress API version (automatically detected if not set)                                 | `nil`                    |
| `ingress.ingressClassName`         | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                 | `nil`                    |
| `ingress.path`                     | Ingress path                                                                                  | `/`                      |
| `ingress.pathType`                 | Ingress path type                                                                             | `ImplementationSpecific` |
| `ingress.annotations`              | Ingress annotations                                                                           | `{}`                     |
| `ingress.tls`                      | Enable TLS configuration for the hostname defined at `ingress.hostname` parameter             | `false`                  |
| `ingress.extraHosts`               | The list of additional hostnames to be covered with this ingress record.                      | `[]`                     |
| `ingress.extraTls`                 | The tls configuration for additional hostnames to be covered with this ingress record.        | `[]`                     |
| `ingress.secrets`                  | If you're providing your own certificates, please use this to add the certificates as secrets | `[]`                     |
| `ingress.servicePort`              | Service port to be used                                                                       | `http`                   |
| `networkPolicy.enabled`            | Enable the default NetworkPolicy policy                                                       | `false`                  |
| `networkPolicy.allowExternal`      | Don't require client label for connections                                                    | `true`                   |
| `networkPolicy.additionalRules`    | Additional NetworkPolicy rules                                                                | `{}`                     |


### RBAC parameters

| Name                    | Description                                               | Value   |
| ----------------------- | --------------------------------------------------------- | ------- |
| `serviceAccount.create` | Enable the creation of a ServiceAccount for Keycloak pods | `true`  |
| `serviceAccount.name`   | Name of the created ServiceAccount                        | `""`    |
| `rbac.create`           | Whether to create and use RBAC resources or not           | `false` |
| `rbac.rules`            | Custom RBAC rules                                         | `[]`    |


### Other parameters

| Name                       | Description                                                    | Value   |
| -------------------------- | -------------------------------------------------------------- | ------- |
| `pdb.create`               | Enable/disable a Pod Disruption Budget creation                | `false` |
| `pdb.minAvailable`         | Minimum number/percentage of pods that should remain scheduled | `1`     |
| `pdb.maxUnavailable`       | Maximum number/percentage of pods that may be made unavailable | `nil`   |
| `autoscaling.enabled`      | Enable autoscaling for Keycloak                                | `false` |
| `autoscaling.minReplicas`  | Minimum number of Keycloak replicas                            | `1`     |
| `autoscaling.maxReplicas`  | Maximum number of Keycloak replicas                            | `11`    |
| `autoscaling.targetCPU`    | Target CPU utilization percentage                              | `nil`   |
| `autoscaling.targetMemory` | Target Memory utilization percentage                           | `nil`   |


### Metrics parameters

| Name                                      | Description                                                                         | Value   |
| ----------------------------------------- | ----------------------------------------------------------------------------------- | ------- |
| `metrics.enabled`                         | Enable exposing Keycloak statistics                                                 | `false` |
| `metrics.service.port`                    | Service HTTP management port                                                        | `9990`  |
| `metrics.service.annotations`             | Annotations for enabling prometheus to access the metrics endpoints                 | `{}`    |
| `metrics.serviceMonitor.enabled`          | Create ServiceMonitor Resource for scraping metrics using PrometheusOperator        | `false` |
| `metrics.serviceMonitor.namespace`        | Namespace which Prometheus is running in                                            | `nil`   |
| `metrics.serviceMonitor.interval`         | Interval at which metrics should be scraped                                         | `30s`   |
| `metrics.serviceMonitor.scrapeTimeout`    | Specify the timeout after which the scrape is ended                                 | `nil`   |
| `metrics.serviceMonitor.relabellings`     | Specify Metric Relabellings to add to the scrape endpoint                           | `nil`   |
| `metrics.serviceMonitor.honorLabels`      | honorLabels chooses the metric's labels on collisions with target labels            | `false` |
| `metrics.serviceMonitor.release`          | Used to pass Labels release that sometimes should be custom for Prometheus Operator | `nil`   |
| `metrics.serviceMonitor.additionalLabels` | Used to pass Labels that are required by the installed Prometheus Operator          | `{}`    |


### Database parameters

| Name                              | Description                                                                   | Value              |
| --------------------------------- | ----------------------------------------------------------------------------- | ------------------ |
| `postgresql.enabled`              | Deploy a PostgreSQL server to satisfy the applications database requirements  | `true`             |
| `postgresql.postgresqlUsername`   | Keycloak PostgreSQL user (has superuser privileges if username is `postgres`) | `bn_keycloak`      |
| `postgresql.postgresqlPassword`   | Keycloak PostgreSQL password - ignored if existingSecret is provided          | `some-password`    |
| `postgresql.postgresqlDatabase`   | Name of the database to create                                                | `bitnami_keycloak` |
| `postgresql.existingSecret`       | Use an existing secret file with the PostgreSQL password                      | `nil`              |
| `postgresql.persistence.enabled`  | Enable database persistence using PVC                                         | `true`             |
| `externalDatabase.host`           | Host of the external database                                                 | `""`               |
| `externalDatabase.port`           | Database port                                                                 | `5432`             |
| `externalDatabase.user`           | non admin username for Keycloak Database                                      | `bn_keycloak`      |
| `externalDatabase.password`       | Database password                                                             | `""`               |
| `externalDatabase.database`       | Database name                                                                 | `bitnami_keycloak` |
| `externalDatabase.existingSecret` | Use an existing secret file with the external PostgreSQL credentials          | `nil`              |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
helm install my-release --set auth.adminPassword=secretpassword bitnami/keycloak
```

The above command sets the Keycloak administrator password to `secretpassword`.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install my-release -f values.yaml bitnami/keycloak
```

> **Tip**: You can use the default [values.yaml](values.yaml)

Keycloak realms, users and clients can be created from the Keycloak administration panel. Refer to the [tutorial on adding user authentication to applications with Keycloak](https://docs.bitnami.com/tutorials/integrate-keycloak-authentication-kubernetes) for more details on these operations.

## Configuration and installation details

### [Rolling vs Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Use an external database

Sometimes, you may want to have Keycloak connect to an external database rather than a database within your cluster - for example, when using a managed database service, or when running a single database server for all your applications. To do this, set the `postgresql.enabled` parameter to `false` and specify the credentials for the external database using the `externalDatabase.*` parameters.

Refer to the [chart documentation on using an external database](https://docs.bitnami.com/kubernetes/apps/keycloak/configuration/use-external-database) for more details and an example.

### Add extra environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `extraEnvVars` property.

```yaml
extraEnvVars:
  - name: KEYCLOAK_LOG_LEVEL
    value: DEBUG
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values.

### Use Sidecars and Init Containers

If additional containers are needed in the same pod (such as additional metrics or logging exporters), they can be defined using the `sidecars` config parameter. Similarly, extra init containers can be added using the `initContainers` parameter.

Refer to the chart documentation for more information on, and examples of, configuring and using [sidecars and init containers](https://docs.bitnami.com/kubernetes/apps/keycloak/configuration/configure-sidecar-init-containers/).

### Initialize a fresh instance

The [Bitnami Keycloak](https://github.com/bitnami/bitnami-docker-keycloak) image allows you to use your custom scripts to initialize a fresh instance. In order to execute the scripts, you can specify custom scripts using the `initdbScripts` parameter as dict.

In addition to this option, you can also set an external ConfigMap with all the initialization scripts. This is done by setting the `initdbScriptsConfigMap` parameter. Note that this will override the previous option.

The allowed extensions is `.sh`.

### Deploy extra resources

There are cases where you may want to deploy extra objects, such a ConfigMap containing your app's configuration or some extra deployment with a micro service used by your app. For covering this case, the chart allows adding the full specification of other objects using the `extraDeploy` parameter.

### Set Pod affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

### Configure Ingress

This chart provides support for Ingress resources. If you have an ingress controller installed on your cluster, such as [nginx-ingress-controller](https://github.com/bitnami/charts/tree/master/bitnami/nginx-ingress-controller) or [contour](https://github.com/bitnami/charts/tree/master/bitnami/contour) you can utilize the ingress controller to serve your application.

To enable Ingress integration, set `ingress.enabled` to `true`. The `ingress.hostname` property can be used to set the host name. The `ingress.tls` parameter can be used to add the TLS configuration for this host. It is also possible to have more than one host, with a separate TLS configuration for each host. [Learn more about configuring and using Ingress](https://docs.bitnami.com/kubernetes/apps/keycloak/configuration/configure-ingress/).

### Configure TLS Secrets for use with Ingress

The chart also facilitates the creation of TLS secrets for use with the Ingress controller, with different options for certificate management. [Learn more about TLS secrets](https://docs.bitnami.com/kubernetes/apps/keycloak/administration/enable-tls-ingress/).

### Manage secrets and passwords

This chart provides several ways to manage passwords:

* Values passed to the chart
* An existing secret with all the passwords (via the `existingSecret` parameter)
* Multiple existing secrets with all the passwords (via the `existingSecretPerPassword` parameter)

Refer to the [chart documentation on managing passwords](https://docs.bitnami.com/kubernetes/apps/keycloak/configuration/manage-passwords/) for examples of each method.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami’s Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 1.0.0

[On November 13, 2020, Helm v2 support formally ended](https://github.com/helm/charts#status-of-the-project). This major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

[Learn more about this change and related upgrade considerations](https://docs.bitnami.com/kubernetes/apps/keycloak/administration/upgrade-helm3/).
