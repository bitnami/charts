<!--- app-name: Keycloak -->

# Keycloak packaged by Bitnami

Keycloak is a high performance Java-based identity and access management solution. It lets developers add an authentication layer to their applications with minimum effort.

[Overview of Keycloak](https://www.keycloak.org/)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
  helm repo add bitnami https://charts.bitnami.com/bitnami
  helm install my-release bitnami/keycloak
```

## Introduction

Bitnami charts for Helm are carefully engineered, actively maintained and are the quickest and easiest way to deploy containers on a Kubernetes cluster that are ready to handle production workloads.

This chart bootstraps a [Keycloak](https://github.com/bitnami/containers/tree/main/bitnami/keycloak) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+

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
| `global.imageRegistry`    | Global Docker image registry                    | `""`  |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]`  |
| `global.storageClass`     | Global StorageClass for Persistent Volume(s)    | `""`  |


### Common parameters

| Name                     | Description                                                                             | Value           |
| ------------------------ | --------------------------------------------------------------------------------------- | --------------- |
| `kubeVersion`            | Force target Kubernetes version (using Helm capabilities if not set)                    | `""`            |
| `nameOverride`           | String to partially override keycloak.fullname                                          | `""`            |
| `fullnameOverride`       | String to fully override keycloak.fullname                                              | `""`            |
| `namespaceOverride`      | String to fully override common.names.namespace                                         | `""`            |
| `commonLabels`           | Labels to add to all deployed objects                                                   | `{}`            |
| `commonAnnotations`      | Annotations to add to all deployed objects                                              | `{}`            |
| `clusterDomain`          | Default Kubernetes cluster domain                                                       | `cluster.local` |
| `extraDeploy`            | Array of extra objects to deploy with the release                                       | `[]`            |
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden) | `false`         |
| `diagnosticMode.command` | Command to override all containers in the the statefulset                               | `["sleep"]`     |
| `diagnosticMode.args`    | Args to override all containers in the the statefulset                                  | `["infinity"]`  |


### Keycloak parameters

| Name                             | Description                                                                                                                  | Value                  |
| -------------------------------- | ---------------------------------------------------------------------------------------------------------------------------- | ---------------------- |
| `image.registry`                 | Keycloak image registry                                                                                                      | `docker.io`            |
| `image.repository`               | Keycloak image repository                                                                                                    | `bitnami/keycloak`     |
| `image.tag`                      | Keycloak image tag (immutable tags are recommended)                                                                          | `18.0.2-debian-11-r19` |
| `image.pullPolicy`               | Keycloak image pull policy                                                                                                   | `IfNotPresent`         |
| `image.pullSecrets`              | Specify docker-registry secret names as an array                                                                             | `[]`                   |
| `image.debug`                    | Specify if debug logs should be enabled                                                                                      | `false`                |
| `auth.adminUser`                 | Keycloak administrator user                                                                                                  | `user`                 |
| `auth.adminPassword`             | Keycloak administrator password for the new user                                                                             | `""`                   |
| `auth.existingSecret`            | An already existing secret containing auth info                                                                              | `""`                   |
| `auth.existingSecretPerPassword` | Override `existingSecret` and other secret values                                                                            | `{}`                   |
| `auth.tls.enabled`               | Enable TLS encryption. Required for HTTPs traffic.                                                                           | `false`                |
| `auth.tls.autoGenerated`         | Generate automatically self-signed TLS certificates. Currently only supports PEM certificates                                | `false`                |
| `auth.tls.existingSecret`        | Existing secret containing the TLS certificates per Keycloak replica                                                         | `""`                   |
| `auth.tls.usePem`                | Use PEM certificates as input instead of PKS12/JKS stores                                                                    | `false`                |
| `auth.tls.truststoreFilename`    | Truststore specific filename inside the existing secret                                                                      | `""`                   |
| `auth.tls.keystoreFilename`      | Keystore specific filename inside the existing secret                                                                        | `""`                   |
| `auth.tls.jksSecret`             | DEPRECATED. Use `auth.tls.existingSecret` instead                                                                            | `""`                   |
| `auth.tls.keystorePassword`      | Password to access the keystore when it's password-protected                                                                 | `""`                   |
| `auth.tls.truststorePassword`    | Password to access the truststore when it's password-protected                                                               | `""`                   |
| `auth.tls.resources.limits`      | The resources limits for the TLS init container                                                                              | `{}`                   |
| `auth.tls.resources.requests`    | The requested resources for the TLS init container                                                                           | `{}`                   |
| `proxy`                          | reverse Proxy mode edge, reencrypt, passthrough or none                                                                      | `passthrough`          |
| `httpRelativePath`               | Set the path relative to '/' for serving resources. Useful if you are migrating from older version which were using '/auth/' | `/`                    |
| `configuration`                  | Keycloak Configuration. Auto-generated based on other parameters when not specified                                          | `""`                   |
| `existingConfigmap`              | Name of existing ConfigMap with Keycloak configuration                                                                       | `""`                   |
| `extraStartupArgs`               | Extra default startup args                                                                                                   | `""`                   |
| `initdbScripts`                  | Dictionary of initdb scripts                                                                                                 | `{}`                   |
| `initdbScriptsConfigMap`         | ConfigMap with the initdb scripts (Note: Overrides `initdbScripts`)                                                          | `""`                   |
| `command`                        | Override default container command (useful when using custom images)                                                         | `[]`                   |
| `args`                           | Override default container args (useful when using custom images)                                                            | `[]`                   |
| `extraEnvVars`                   | Extra environment variables to be set on Keycloak container                                                                  | `[]`                   |
| `extraEnvVarsCM`                 | Name of existing ConfigMap containing extra env vars                                                                         | `""`                   |
| `extraEnvVarsSecret`             | Name of existing Secret containing extra env vars                                                                            | `""`                   |


### Keycloak statefulset parameters

| Name                                    | Description                                                                                                              | Value           |
| --------------------------------------- | ------------------------------------------------------------------------------------------------------------------------ | --------------- |
| `replicaCount`                          | Number of Keycloak replicas to deploy                                                                                    | `1`             |
| `containerPorts.http`                   | Keycloak HTTP container port                                                                                             | `8080`          |
| `containerPorts.https`                  | Keycloak HTTPS container port                                                                                            | `8443`          |
| `podSecurityContext.enabled`            | Enabled Keycloak pods' Security Context                                                                                  | `true`          |
| `podSecurityContext.fsGroup`            | Set Keycloak pod's Security Context fsGroup                                                                              | `1001`          |
| `containerSecurityContext.enabled`      | Enabled Keycloak containers' Security Context                                                                            | `true`          |
| `containerSecurityContext.runAsUser`    | Set Keycloak container's Security Context runAsUser                                                                      | `1001`          |
| `containerSecurityContext.runAsNonRoot` | Set Keycloak container's Security Context runAsNonRoot                                                                   | `true`          |
| `resources.limits`                      | The resources limits for the Keycloak containers                                                                         | `{}`            |
| `resources.requests`                    | The requested resources for the Keycloak containers                                                                      | `{}`            |
| `livenessProbe.enabled`                 | Enable livenessProbe on Keycloak containers                                                                              | `true`          |
| `livenessProbe.initialDelaySeconds`     | Initial delay seconds for livenessProbe                                                                                  | `300`           |
| `livenessProbe.periodSeconds`           | Period seconds for livenessProbe                                                                                         | `1`             |
| `livenessProbe.timeoutSeconds`          | Timeout seconds for livenessProbe                                                                                        | `5`             |
| `livenessProbe.failureThreshold`        | Failure threshold for livenessProbe                                                                                      | `3`             |
| `livenessProbe.successThreshold`        | Success threshold for livenessProbe                                                                                      | `1`             |
| `readinessProbe.enabled`                | Enable readinessProbe on Keycloak containers                                                                             | `true`          |
| `readinessProbe.initialDelaySeconds`    | Initial delay seconds for readinessProbe                                                                                 | `30`            |
| `readinessProbe.periodSeconds`          | Period seconds for readinessProbe                                                                                        | `10`            |
| `readinessProbe.timeoutSeconds`         | Timeout seconds for readinessProbe                                                                                       | `1`             |
| `readinessProbe.failureThreshold`       | Failure threshold for readinessProbe                                                                                     | `3`             |
| `readinessProbe.successThreshold`       | Success threshold for readinessProbe                                                                                     | `1`             |
| `startupProbe.enabled`                  | Enable startupProbe on Keycloak containers                                                                               | `false`         |
| `startupProbe.initialDelaySeconds`      | Initial delay seconds for startupProbe                                                                                   | `30`            |
| `startupProbe.periodSeconds`            | Period seconds for startupProbe                                                                                          | `5`             |
| `startupProbe.timeoutSeconds`           | Timeout seconds for startupProbe                                                                                         | `1`             |
| `startupProbe.failureThreshold`         | Failure threshold for startupProbe                                                                                       | `60`            |
| `startupProbe.successThreshold`         | Success threshold for startupProbe                                                                                       | `1`             |
| `customLivenessProbe`                   | Custom Liveness probes for Keycloak                                                                                      | `{}`            |
| `customReadinessProbe`                  | Custom Rediness probes Keycloak                                                                                          | `{}`            |
| `customStartupProbe`                    | Custom Startup probes for Keycloak                                                                                       | `{}`            |
| `lifecycleHooks`                        | LifecycleHooks to set additional configuration at startup                                                                | `{}`            |
| `hostAliases`                           | Deployment pod host aliases                                                                                              | `[]`            |
| `podLabels`                             | Extra labels for Keycloak pods                                                                                           | `{}`            |
| `podAnnotations`                        | Annotations for Keycloak pods                                                                                            | `{}`            |
| `podAffinityPreset`                     | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                      | `""`            |
| `podAntiAffinityPreset`                 | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                 | `soft`          |
| `nodeAffinityPreset.type`               | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                | `""`            |
| `nodeAffinityPreset.key`                | Node label key to match. Ignored if `affinity` is set.                                                                   | `""`            |
| `nodeAffinityPreset.values`             | Node label values to match. Ignored if `affinity` is set.                                                                | `[]`            |
| `affinity`                              | Affinity for pod assignment                                                                                              | `{}`            |
| `nodeSelector`                          | Node labels for pod assignment                                                                                           | `{}`            |
| `tolerations`                           | Tolerations for pod assignment                                                                                           | `[]`            |
| `topologySpreadConstraints`             | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template | `[]`            |
| `podManagementPolicy`                   | Pod management policy for the Keycloak statefulset                                                                       | `Parallel`      |
| `priorityClassName`                     | Keycloak pods' Priority Class Name                                                                                       | `""`            |
| `schedulerName`                         | Use an alternate scheduler, e.g. "stork".                                                                                | `""`            |
| `terminationGracePeriodSeconds`         | Seconds Keycloak pod needs to terminate gracefully                                                                       | `""`            |
| `updateStrategy.type`                   | Keycloak statefulset strategy type                                                                                       | `RollingUpdate` |
| `updateStrategy.rollingUpdate`          | Keycloak statefulset rolling update configuration parameters                                                             | `{}`            |
| `extraVolumes`                          | Optionally specify extra list of additional volumes for Keycloak pods                                                    | `[]`            |
| `extraVolumeMounts`                     | Optionally specify extra list of additional volumeMounts for Keycloak container(s)                                       | `[]`            |
| `initContainers`                        | Add additional init containers to the Keycloak pods                                                                      | `[]`            |
| `sidecars`                              | Add additional sidecar containers to the Keycloak pods                                                                   | `[]`            |


### Exposure parameters

| Name                               | Description                                                                                                                      | Value                    |
| ---------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `service.type`                     | Kubernetes service type                                                                                                          | `LoadBalancer`           |
| `service.ports.http`               | Keycloak service HTTP port                                                                                                       | `80`                     |
| `service.ports.https`              | Keycloak service HTTPS port                                                                                                      | `443`                    |
| `service.nodePorts`                | Specify the nodePort values for the LoadBalancer and NodePort service types.                                                     | `{}`                     |
| `service.sessionAffinity`          | Control where client requests go, to the same pod or round-robin                                                                 | `None`                   |
| `service.sessionAffinityConfig`    | Additional settings for the sessionAffinity                                                                                      | `{}`                     |
| `service.clusterIP`                | Keycloak service clusterIP IP                                                                                                    | `""`                     |
| `service.loadBalancerIP`           | loadBalancerIP for the SuiteCRM Service (optional, cloud specific)                                                               | `""`                     |
| `service.loadBalancerSourceRanges` | Address that are allowed when service is LoadBalancer                                                                            | `[]`                     |
| `service.externalTrafficPolicy`    | Enable client source IP preservation                                                                                             | `Cluster`                |
| `service.annotations`              | Additional custom annotations for Keycloak service                                                                               | `{}`                     |
| `service.extraPorts`               | Extra port to expose on Keycloak service                                                                                         | `[]`                     |
| `ingress.enabled`                  | Enable ingress record generation for Keycloak                                                                                    | `false`                  |
| `ingress.ingressClassName`         | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                    | `""`                     |
| `ingress.pathType`                 | Ingress path type                                                                                                                | `ImplementationSpecific` |
| `ingress.apiVersion`               | Force Ingress API version (automatically detected if not set)                                                                    | `""`                     |
| `ingress.hostname`                 | Default host for the ingress record (evaluated as template)                                                                      | `keycloak.local`         |
| `ingress.path`                     | Default path for the ingress record                                                                                              | `/`                      |
| `ingress.servicePort`              | Backend service port to use                                                                                                      | `http`                   |
| `ingress.annotations`              | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                     |
| `ingress.tls`                      | Enable TLS configuration for the host defined at `ingress.hostname` parameter                                                    | `false`                  |
| `ingress.selfSigned`               | Create a TLS secret for this ingress record using self-signed certificates generated by Helm                                     | `false`                  |
| `ingress.extraHosts`               | An array with additional hostname(s) to be covered with the ingress record                                                       | `[]`                     |
| `ingress.extraPaths`               | Any additional arbitrary paths that may need to be added to the ingress under the main host.                                     | `[]`                     |
| `ingress.extraTls`                 | The tls configuration for additional hostnames to be covered with this ingress record.                                           | `[]`                     |
| `ingress.secrets`                  | If you're providing your own certificates, please use this to add the certificates as secrets                                    | `[]`                     |
| `ingress.extraRules`               | Additional rules to be covered with this ingress record                                                                          | `[]`                     |
| `networkPolicy.enabled`            | Enable the default NetworkPolicy policy                                                                                          | `false`                  |
| `networkPolicy.allowExternal`      | Don't require client label for connections                                                                                       | `true`                   |
| `networkPolicy.additionalRules`    | Additional NetworkPolicy rules                                                                                                   | `{}`                     |


### RBAC parameter

| Name                                          | Description                                               | Value   |
| --------------------------------------------- | --------------------------------------------------------- | ------- |
| `serviceAccount.create`                       | Enable the creation of a ServiceAccount for Keycloak pods | `true`  |
| `serviceAccount.name`                         | Name of the created ServiceAccount                        | `""`    |
| `serviceAccount.automountServiceAccountToken` | Auto-mount the service account token in the pod           | `true`  |
| `serviceAccount.annotations`                  | Additional custom annotations for the ServiceAccount      | `{}`    |
| `rbac.create`                                 | Whether to create and use RBAC resources or not           | `false` |
| `rbac.rules`                                  | Custom RBAC rules                                         | `[]`    |


### Other parameters

| Name                       | Description                                                    | Value   |
| -------------------------- | -------------------------------------------------------------- | ------- |
| `pdb.create`               | Enable/disable a Pod Disruption Budget creation                | `false` |
| `pdb.minAvailable`         | Minimum number/percentage of pods that should remain scheduled | `1`     |
| `pdb.maxUnavailable`       | Maximum number/percentage of pods that may be made unavailable | `""`    |
| `autoscaling.enabled`      | Enable autoscaling for Keycloak                                | `false` |
| `autoscaling.minReplicas`  | Minimum number of Keycloak replicas                            | `1`     |
| `autoscaling.maxReplicas`  | Maximum number of Keycloak replicas                            | `11`    |
| `autoscaling.targetCPU`    | Target CPU utilization percentage                              | `""`    |
| `autoscaling.targetMemory` | Target Memory utilization percentage                           | `""`    |


### Metrics parameters

| Name                                       | Description                                                                           | Value      |
| ------------------------------------------ | ------------------------------------------------------------------------------------- | ---------- |
| `metrics.enabled`                          | Enable exposing Keycloak statistics                                                   | `false`    |
| `metrics.service.ports.http`               | Metrics service HTTP port                                                             | `8080`     |
| `metrics.service.annotations`              | Annotations for enabling prometheus to access the metrics endpoints                   | `{}`       |
| `metrics.serviceMonitor.enabled`           | Create ServiceMonitor Resource for scraping metrics using PrometheusOperator          | `false`    |
| `metrics.serviceMonitor.path`              | Metrics service HTTP path                                                             | `/metrics` |
| `metrics.serviceMonitor.namespace`         | Namespace which Prometheus is running in                                              | `""`       |
| `metrics.serviceMonitor.interval`          | Interval at which metrics should be scraped                                           | `30s`      |
| `metrics.serviceMonitor.scrapeTimeout`     | Specify the timeout after which the scrape is ended                                   | `""`       |
| `metrics.serviceMonitor.labels`            | Additional labels that can be used so ServiceMonitor will be discovered by Prometheus | `{}`       |
| `metrics.serviceMonitor.selector`          | Prometheus instance selector labels                                                   | `{}`       |
| `metrics.serviceMonitor.relabelings`       | RelabelConfigs to apply to samples before scraping                                    | `[]`       |
| `metrics.serviceMonitor.metricRelabelings` | MetricRelabelConfigs to apply to samples before ingestion                             | `[]`       |
| `metrics.serviceMonitor.honorLabels`       | honorLabels chooses the metric's labels on collisions with target labels              | `false`    |
| `metrics.serviceMonitor.jobLabel`          | The name of the label on the target service to use as the job name in prometheus.     | `""`       |


### keycloak-config-cli parameters

| Name                                                      | Description                                                                                     | Value                         |
| --------------------------------------------------------- | ----------------------------------------------------------------------------------------------- | ----------------------------- |
| `keycloakConfigCli.enabled`                               | Whether to enable keycloak-config-cli job                                                       | `false`                       |
| `keycloakConfigCli.image.registry`                        | keycloak-config-cli container image registry                                                    | `docker.io`                   |
| `keycloakConfigCli.image.repository`                      | keycloak-config-cli container image repository                                                  | `bitnami/keycloak-config-cli` |
| `keycloakConfigCli.image.tag`                             | keycloak-config-cli container image tag                                                         | `5.3.1-debian-11-r1`          |
| `keycloakConfigCli.image.pullPolicy`                      | keycloak-config-cli container image pull policy                                                 | `IfNotPresent`                |
| `keycloakConfigCli.image.pullSecrets`                     | keycloak-config-cli container image pull secrets                                                | `[]`                          |
| `keycloakConfigCli.annotations`                           | Annotations for keycloak-config-cli job                                                         | `{}`                          |
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
| `keycloakConfigCli.extraEnvVarsCM`                        | ConfigMap with extra environment variables                                                      | `""`                          |
| `keycloakConfigCli.extraEnvVarsSecret`                    | Secret with extra environment variables                                                         | `""`                          |
| `keycloakConfigCli.extraVolumes`                          | Extra volumes to add to the job                                                                 | `[]`                          |
| `keycloakConfigCli.extraVolumeMounts`                     | Extra volume mounts to add to the container                                                     | `[]`                          |
| `keycloakConfigCli.configuration`                         | keycloak-config-cli realms configuration                                                        | `{}`                          |
| `keycloakConfigCli.existingConfigmap`                     | ConfigMap with keycloak-config-cli configuration. This will override `keycloakConfigCli.config` | `""`                          |


### Database parameters

| Name                                         | Description                                                             | Value              |
| -------------------------------------------- | ----------------------------------------------------------------------- | ------------------ |
| `postgresql.enabled`                         | Switch to enable or disable the PostgreSQL helm chart                   | `true`             |
| `postgresql.auth.username`                   | Name for a custom user to create                                        | `bn_keycloak`      |
| `postgresql.auth.password`                   | Password for the custom user to create                                  | `""`               |
| `postgresql.auth.database`                   | Name for a custom database to create                                    | `bitnami_keycloak` |
| `postgresql.auth.existingSecret`             | Name of existing secret to use for PostgreSQL credentials               | `""`               |
| `postgresql.architecture`                    | PostgreSQL architecture (`standalone` or `replication`)                 | `standalone`       |
| `externalDatabase.host`                      | Database host                                                           | `""`               |
| `externalDatabase.port`                      | Database port number                                                    | `5432`             |
| `externalDatabase.user`                      | Non-root username for Keycloak                                          | `bn_keycloak`      |
| `externalDatabase.password`                  | Password for the non-root username for Keycloak                         | `""`               |
| `externalDatabase.database`                  | Keycloak database name                                                  | `bitnami_keycloak` |
| `externalDatabase.existingSecret`            | Name of an existing secret resource containing the database credentials | `""`               |
| `externalDatabase.existingSecretPasswordKey` | Name of an existing secret key containing the database credentials      | `""`               |


### Keycloak Cache parameters

| Name            | Description                                                               | Value   |
| --------------- | ------------------------------------------------------------------------- | ------- |
| `cache.enabled` | Switch to enable or disable the keycloak distributed cache for kubernetes | `false` |


### Keycloak Logging parameters

| Name             | Description                                                     | Value     |
| ---------------- | --------------------------------------------------------------- | --------- |
| `logging.output` | Alternates between the default log output format or json format | `default` |


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

### [Rolling vs Immutable tags](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Use an external database

Sometimes, you may want to have the chart use an external database rather than using the one bundled with the chart. Common use cases include using a managed database service, or using a single database server for all your applications. This chart supports external databases through its `externalDatabase.*` parameters.

When using these parameters, it is necessary to disable installation of the bundled PostgreSQL database using the `postgresql.enabled=false` parameter.

An example of the parameters set when deploying the chart with an external database are shown below:
```
postgresql.enabled=false
externalDatabase.host=myexternalhost
externalDatabase.port=5432
externalDatabase.user=myuser
externalDatabase.password=mypassword
externalDatabase.database=mydatabase
```

### Add extra environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `extraEnvVars` property.

```yaml
extraEnvVars:
  - name: KEYCLOAK_LOG_LEVEL
    value: DEBUG
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values.

### Sidecars and Init Containers

If additional containers are needed in the same pod (such as additional metrics or logging exporters), they can be defined using the `sidecars` parameter. Here is an example:

```yaml
sidecars:
- name: your-image-name
  image: your-image
  imagePullPolicy: Always
  ports:
  - name: portname
    containerPort: 1234
```

If these sidecars export extra ports, extra port definitions can be added using the `service.extraPorts` parameter (where available), as shown in the example below:

```yaml
service:
...
  extraPorts:
  - name: extraPort
    port: 11311
    targetPort: 11311
```

If additional init containers are needed in the same pod, they can be defined using the `initContainers` parameter. Here is an example:

```yaml
initContainers:
  - name: your-image-name
    image: your-image
    imagePullPolicy: Always
    ports:
      - name: portname
        containerPort: 1234
```

Learn more about [sidecar containers](https://kubernetes.io/docs/concepts/workloads/pods/) and [init containers](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/).

### Initialize a fresh instance

The [Bitnami Keycloak](https://github.com/bitnami/containers/tree/main/bitnami/keycloak) image allows you to use your custom scripts to initialize a fresh instance. In order to execute the scripts, you can specify custom scripts using the `initdbScripts` parameter as dict.

In addition to this option, you can also set an external ConfigMap with all the initialization scripts. This is done by setting the `initdbScriptsConfigMap` parameter. Note that this will override the previous option.

The allowed extensions is `.sh`.

### Deploy extra resources

There are cases where you may want to deploy extra objects, such a ConfigMap containing your app's configuration or some extra deployment with a micro service used by your app. For covering this case, the chart allows adding the full specification of other objects using the `extraDeploy` parameter.

### Pod affinity

This chart allows you to set your custom affinity using the `*.affinity` parameter(s). Find more information about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `*.podAffinityPreset`, `*.podAntiAffinityPreset`, or `*.nodeAffinityPreset` parameters.

### Ingress

This chart provides support for Ingress resources. If you have an ingress controller installed on your cluster, such as [nginx-ingress-controller](https://github.com/bitnami/charts/tree/master/bitnami/nginx-ingress-controller) or [contour](https://github.com/bitnami/charts/tree/master/bitnami/contour) you can utilize the ingress controller to serve your application.

To enable Ingress integration, set `ingress.enabled` to `true`. The `ingress.hostname` property can be used to set the host name. The `ingress.tls` parameter can be used to add the TLS configuration for this host. It is also possible to have more than one host, with a separate TLS configuration for each host.

In general, to enable Ingress integration, set the `*.ingress.enabled` parameter to *true*.

The most common scenario is to have one host name mapped to the deployment. In this case, the `*.ingress.hostname` property can be used to set the host name. The `*.ingress.tls` parameter can be used to add the TLS configuration for this host.

However, it is also possible to have more than one host. To facilitate this, the `*.ingress.extraHosts` parameter (if available) can be set with the host names specified as an array. The `*.ingress.extraTLS` parameter (if available) can also be used to add the TLS configuration for extra hosts.

> NOTE: For each host specified in the `*.ingress.extraHosts` parameter, it is necessary to set a name, path, and any annotations that the Ingress controller should know about. Not all annotations are supported by all Ingress controllers, but [this annotation reference document](https://github.com/kubernetes/ingress-nginx/blob/master/docs/user-guide/nginx-configuration/annotations.md) lists the annotations supported by many popular Ingress controllers.

Adding the TLS parameter (where available) will cause the chart to generate HTTPS URLs, and the  application will be available on port 443. The actual TLS secrets do not have to be generated by this chart. However, if TLS is enabled, the Ingress record will not work until the TLS secret exists.

[Learn more about Ingress controllers](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/).

### TLS secrets

This chart facilitates the creation of TLS secrets for use with the Ingress controller (although this is not mandatory). There are several common use cases:

- Generate certificate secrets based on chart parameters.
- Enable externally generated certificates.
- Manage application certificates via an external service (like [cert-manager](https://github.com/jetstack/cert-manager/)).
- Create self-signed certificates within the chart.

In the first two cases, a certificate and a key are needed. Files are expected in `*.pem` format.

Here is an example of a certificate file:

> NOTE: There may be more than one certificate if there is a certificate chain.

```console
-----BEGIN CERTIFICATE-----
MIID6TCCAtGgAwIBAgIJAIaCwivkeB5EMA0GCSqGSIb3DQEBCwUAMFYxCzAJBgNV
...
jScrvkiBO65F46KioCL9h5tDvomdU1aqpI/CBzhvZn1c0ZTf87tGQR8NK7v7
-----END CERTIFICATE-----
```

Here is an example of a certificate key:

```console
-----BEGIN RSA PRIVATE KEY-----
MIIEogIBAAKCAQEAvLYcyu8f3skuRyUgeeNpeDvYBCDcgq+LsWap6zbX5f8oLqp4
...
wrj2wDbCDCFmfqnSJ+dKI3vFLlEz44sAV8jX/kd4Y6ZTQhlLbYc=
-----END RSA PRIVATE KEY-----
```

- If using Helm to manage the certificates based on the parameters, copy these values into the *certificate* and *key* values for a given `*.ingress.secrets` entry.
- If managing TLS secrets separately, it is necessary to create a TLS secret with name `INGRESS_HOSTNAME-tls` (where `INGRESS_HOSTNAME` is a placeholder to be replaced with the hostname you set using the `*.ingress.hostname` parameter).
- If your cluster has a [cert-manager](https://github.com/jetstack/cert-manager) add-on to automate the management and issuance of TLS certificates, add to `*.ingress.annotations` the [corresponding ones](https://cert-manager.io/docs/usage/ingress/#supported-annotations) for cert-manager.
- If using self-signed certificates created by Helm, set both `*.ingress.tls` and `*.ingress.selfSigned` to *true*.

### Use with ingress offloading SSL

If your ingress controller has the SSL Termination, you should set `proxy` to `edge`.

### Manage secrets and passwords

This chart provides several ways to manage passwords:

- Values passed to the chart
- An existing secret with all the passwords (via the `existingSecret` parameter)
- Multiple existing secrets with all the passwords (via the `existingSecretPerPassword` parameter)

#### Values passed to the chart

In this scenario, a new secret including all the passwords will be created during the chart installation.

When upgrading, it is necessary to provide the secrets to the chart as shown below. Replace the `KEYCLOAK_ADMIN_PASSWORD`, `KEYCLOAK_MANAGEMENT_PASSWORD`, `POSTGRESQL_PASSWORD` and `POSTGRESQL_PVC` placeholders with the correct passwords and PVC name.
```console
$ helm upgrade keycloak bitnami/keycloak \
    --set auth.adminPassword=KEYCLOAK_ADMIN_PASSWORD \
    --set auth.managementPassword=KEYCLOAK_MANAGEMENT_PASSWORD \
    --set postgresql.postgresqlPassword=POSTGRESQL_PASSWORD \
    --set postgresql.persistence.existingClaim=POSTGRESQL_PVC
```

#### An existing secret with all the passwords

> NOTE: When installing using an existing secret, passwords may be held in a single secret or separated in multiple secrets.

To use a single existing secret, use the `existingSecret` parameter, as shown below:
```yaml
existingSecret:
  name: mySecret
  keyMapping:
    admin-password: myPasswordKey
    management-password: myManagementPasswordKey
    tls-keystore-password: myTlsKeystorePasswordKey
    tls-truststore-password: myTlsTruststorePasswordKey
```

The `keyMapping` parameter links the passwords in the chart with the passwords stored in the existing secret.

#### Multiple existing secrets with all the passwords

Configuring multiple existing secrets can be done with the `auth.existingSecretPerPassword` parameter, as shown below:
```yaml
existingSecretPerPassword:
  keyMapping:
    adminPassword: KEYCLOAK_ADMIN_PASSWORD
    managementPassword: KEYCLOAK_MANAGEMENT_PASSWORD
    databasePassword: password
    tlsKeystorePassword: JKS_KEYSTORE_TRUSTSTORE_PASSWORD
    tlsTruststorePassword: JKS_KEYSTORE_TRUSTSTORE_PASSWORD
  adminPassword:
    name: mySecret
  managementPassword:
    name: mySecret
  databasePassword:
    name: myOtherSecret
  tlsKeystorePassword:
    name: mySecret
  tlsTruststorePassword:
    name: mySecret
```
In addition to the key mapping, a different secret name can be configured per password.

> NOTE: The `auth.existingSecretPerPassword` parameter will overwrite the configuration passed to the `auth.existingSecret` parameter.

### Use Keycloak as an authentication provider

Keycloak can be easily configured as an authentication service provider for other applications. It supports many popular protocols (such as OpenID Connect, OAuth 2.0, LDAP and SAML 2.0) and social networks (such as Google, Twitter and Facebook). Keycloak also provides integration libraries for common programming languages and server applications, including Java, Node.js, Apache, Tomcat and Wildfly.

To use Keycloak as an authentication service provider, it is necessary to configure a Keycloak realm, user and client. Our [tutorial on adding user authentication to applications with a scalable Keycloak deployment on Kubernetes](https://docs.bitnami.com/tutorials/integrate-keycloak-authentication-kubernetes) walks you through the entire process.

## Troubleshooting

Sometimes, due to unexpected issues, installations can become corrupted and get stuck in a *CrashLoopBackOff* restart loop. In these situations, it may be necessary to access the containers and perform manual operations to troubleshoot and fix the issues. To ease this task, the chart has a "Diagnostic mode" that will deploy all the containers with all probes and lifecycle hooks disabled. In addition to this, it will override all commands and arguments with `sleep infinity`.

To activate the "Diagnostic mode", upgrade the release with the following comman. Replace the `MY-RELEASE` placeholder with the release name:
```console
$ helm upgrade MY-RELEASE --set diagnosticMode.enabled=true
```
It is also possible to change the default `sleep infinity` command by setting the `diagnosticMode.command` and `diagnosticMode.args` values.

Once the chart has been deployed in "Diagnostic mode", access the containers by executing the following command and replacing the `MY-CONTAINER` placeholder with the container name:
```console
$ kubectl exec -ti MY-CONTAINER -- bash
```

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 8.0.0

This major release updates Keycloak to its major version `17`. Among other features, this new version has deprecated WildFly in favor of Quarkus, which introduces breaking changes like:

- Removal of `/auth` from the default context path.
- Changes in the configuration and deployment of custom providers.
- Significant changes in configuring Keycloak.

Please, refer to the official [Keycloak migration documentation](https://www.keycloak.org/docs/latest/upgrading/index.html#migrating-to-17-0-0) and [Migrating to Quarkus distribution document](https://www.keycloak.org/migration/migrating-to-quarkus) for a complete list of changes and further information.


### To 7.0.0

This major release updates the PostgreSQL subchart to its newest major *11.x.x*, which contain several changes in the supported values (check the [upgrade notes](https://github.com/bitnami/charts/tree/master/bitnami/postgresql#upgrading) to obtain more information).

#### Upgrading Instructions

To upgrade to *7.0.0* from *6.x*, it should be done reusing the PVC(s) used to hold the data on your previous release. To do so, follow the instructions below (the following example assumes that the release name is *keycloak* and the release namespace *default*):

1. Obtain the credentials and the names of the PVCs used to hold the data on your current release:
```console
export KEYCLOAK_PASSWORD=$(kubectl get secret --namespace default keycloak -o jsonpath="{.data.admin-password}" | base64 --decode)
export POSTGRESQL_PASSWORD=$(kubectl get secret --namespace default keycloak-postgresql -o jsonpath="{.data.postgresql-password}" | base64 --decode)
export POSTGRESQL_PVC=$(kubectl get pvc -l app.kubernetes.io/instance=keycloak,app.kubernetes.io/name=postgresql,role=primary -o jsonpath="{.items[0].metadata.name}")
```

2. Delete the PostgreSQL statefulset (notice the option *--cascade=false*) and secret:
```console
$ kubectl delete statefulsets.apps --cascade=false keycloak-postgresql
$ kubectl delete secret keycloak-postgresql --namespace default
```

3. Upgrade your release using the same PostgreSQL version:
```
CURRENT_PG_VERSION=$(kubectl exec keycloak-postgresql-0 -- bash -c 'echo $BITNAMI_IMAGE_VERSION')
helm upgrade keycloak bitnami/keycloak \
  --set auth.adminPassword=$KEYCLOAK_PASSWORD \
  --set postgresql.image.tag=$CURRENT_PG_VERSION \
  --set postgresql.auth.password=$POSTGRESQL_PASSWORD \
  --set postgresql.persistence.existingClaim=$POSTGRESQL_PVC
```

4. Delete the existing PostgreSQL pods and the new statefulset will create a new one:
```console
$ kubectl delete pod keycloak-postgresql-0
```

### To 1.0.0

[On November 13, 2020, Helm v2 support was formally finished](https://github.com/helm/charts#status-of-the-project), this major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

#### What changes were introduced in this major version?

- Previous versions of this Helm Chart use `apiVersion: v1` (installable by both Helm 2 and 3), this Helm Chart was updated to `apiVersion: v2` (installable by Helm 3 only). [Here](https://helm.sh/docs/topics/charts/#the-apiversion-field) you can find more information about the `apiVersion` field.
- Move dependency information from the *requirements.yaml* to the *Chart.yaml*
- After running *helm dependency update*, a *Chart.lock* file is generated containing the same structure used in the previous *requirements.lock*
- The different fields present in the *Chart.yaml* file has been ordered alphabetically in a homogeneous way for all the Bitnami Helm Chart.

#### Considerations when upgrading to this version

- If you want to upgrade to this version using Helm v2, this scenario is not supported as this version does not support Helm v2 anymore.
- If you installed the previous version with Helm v2 and wants to upgrade to this version with Helm v3, please refer to the [official Helm documentation](https://helm.sh/docs/topics/v2_v3_migration/#migration-use-cases) about migrating from Helm v2 to v3.

#### Useful links

- [Bitnami Tutorial](https://docs.bitnami.com/tutorials/resolve-helm2-helm3-post-migration-issues)
- [Helm docs](https://helm.sh/docs/topics/v2_v3_migration)
- [Helm Blog](https://helm.sh/blog/migrate-from-helm-v2-to-helm-v3)


## License

Copyright &copy; 2022 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
