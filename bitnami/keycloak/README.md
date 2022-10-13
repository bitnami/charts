<!--- app-name: Keycloak -->

# Keycloak packaged by Bitnami

Keycloak is a high performance Java-based identity and access management solution. It lets developers add an authentication layer to their applications with minimum effort.

[Overview of Keycloak](https://www.keycloak.org/)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.
                           
## TL;DR

```console
  helm repo add my-repo https://charts.bitnami.com/bitnami
  helm install my-release my-repo/keycloak
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
$ helm repo add my-repo https://charts.bitnami.com/bitnami
$ helm install my-release my-repo/keycloak
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

| Name                             | Description                                                                                                                  | Value                 |
| -------------------------------- | ---------------------------------------------------------------------------------------------------------------------------- | --------------------- |
| `image.registry`                 | Keycloak image registry                                                                                                      | `docker.io`           |
| `image.repository`               | Keycloak image repository                                                                                                    | `bitnami/keycloak`    |
| `image.tag`                      | Keycloak image tag (immutable tags are recommended)                                                                          | `19.0.3-debian-11-r2` |
| `image.digest`                   | Keycloak image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                     | `""`                  |
| `image.pullPolicy`               | Keycloak image pull policy                                                                                                   | `IfNotPresent`        |
| `image.pullSecrets`              | Specify docker-registry secret names as an array                                                                             | `[]`                  |
| `image.debug`                    | Specify if debug logs should be enabled                                                                                      | `false`               |
| `auth.adminUser`                 | Keycloak administrator user                                                                                                  | `user`                |
| `auth.adminPassword`             | Keycloak administrator password for the new user                                                                             | `""`                  |
| `auth.existingSecret`            | An already existing secret containing auth info                                                                              | `""`                  |
| `auth.existingSecretPerPassword` | Override `existingSecret` and other secret values                                                                            | `{}`                  |
| `auth.tls.enabled`               | Enable TLS encryption. Required for HTTPs traffic.                                                                           | `false`               |
| `auth.tls.autoGenerated`         | Generate automatically self-signed TLS certificates. Currently only supports PEM certificates                                | `false`               |
| `auth.tls.existingSecret`        | Existing secret containing the TLS certificates per Keycloak replica                                                         | `""`                  |
| `auth.tls.usePem`                | Use PEM certificates as input instead of PKS12/JKS stores                                                                    | `false`               |
| `auth.tls.truststoreFilename`    | Truststore specific filename inside the existing secret                                                                      | `""`                  |
| `auth.tls.keystoreFilename`      | Keystore specific filename inside the existing secret                                                                        | `""`                  |
| `auth.tls.jksSecret`             | DEPRECATED. Use `auth.tls.existingSecret` instead                                                                            | `""`                  |
| `auth.tls.keystorePassword`      | Password to access the keystore when it's password-protected                                                                 | `""`                  |
| `auth.tls.truststorePassword`    | Password to access the truststore when it's password-protected                                                               | `""`                  |
| `auth.tls.resources.limits`      | The resources limits for the TLS init container                                                                              | `{}`                  |
| `auth.tls.resources.requests`    | The requested resources for the TLS init container                                                                           | `{}`                  |
| `proxy`                          | reverse Proxy mode edge, reencrypt, passthrough or none                                                                      | `passthrough`         |
| `httpRelativePath`               | Set the path relative to '/' for serving resources. Useful if you are migrating from older version which were using '/auth/' | `/`                   |
| `configuration`                  | Keycloak Configuration. Auto-generated based on other parameters when not specified                                          | `""`                  |
| `existingConfigmap`              | Name of existing ConfigMap with Keycloak configuration                                                                       | `""`                  |
| `extraStartupArgs`               | Extra default startup args                                                                                                   | `""`                  |
| `initdbScripts`                  | Dictionary of initdb scripts                                                                                                 | `{}`                  |
| `initdbScriptsConfigMap`         | ConfigMap with the initdb scripts (Note: Overrides `initdbScripts`)                                                          | `""`                  |
| `command`                        | Override default container command (useful when using custom images)                                                         | `[]`                  |
| `args`                           | Override default container args (useful when using custom images)                                                            | `[]`                  |
| `extraEnvVars`                   | Extra environment variables to be set on Keycloak container                                                                  | `[]`                  |
| `extraEnvVarsCM`                 | Name of existing ConfigMap containing extra env vars                                                                         | `""`                  |
| `extraEnvVarsSecret`             | Name of existing Secret containing extra env vars                                                                            | `""`                  |


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
| `service.http.enabled`             | Enable http port on service                                                                                                      | `true`                   |
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

| Name                                       | Description                                                                                                               | Value   |
| ------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------- | ------- |
| `metrics.enabled`                          | Enable exposing Keycloak statistics                                                                                       | `false` |
| `metrics.service.ports.http`               | Metrics service HTTP port                                                                                                 | `8080`  |
| `metrics.service.annotations`              | Annotations for enabling prometheus to access the metrics endpoints                                                       | `{}`    |
| `metrics.serviceMonitor.enabled`           | Create ServiceMonitor Resource for scraping metrics using PrometheusOperator                                              | `false` |
| `metrics.serviceMonitor.port`              | Metrics service HTTP port                                                                                                 | `http`  |
| `metrics.serviceMonitor.endpoints`         | The endpoint configuration of the ServiceMonitor. Path is mandatory. Interval, timeout and labellings can be overwritten. | `[]`    |
| `metrics.serviceMonitor.path`              | Metrics service HTTP path. Deprecated: Use @param metrics.serviceMonitor.endpoints instead                                | `""`    |
| `metrics.serviceMonitor.namespace`         | Namespace which Prometheus is running in                                                                                  | `""`    |
| `metrics.serviceMonitor.interval`          | Interval at which metrics should be scraped                                                                               | `30s`   |
| `metrics.serviceMonitor.scrapeTimeout`     | Specify the timeout after which the scrape is ended                                                                       | `""`    |
| `metrics.serviceMonitor.labels`            | Additional labels that can be used so ServiceMonitor will be discovered by Prometheus                                     | `{}`    |
| `metrics.serviceMonitor.selector`          | Prometheus instance selector labels                                                                                       | `{}`    |
| `metrics.serviceMonitor.relabelings`       | RelabelConfigs to apply to samples before scraping                                                                        | `[]`    |
| `metrics.serviceMonitor.metricRelabelings` | MetricRelabelConfigs to apply to samples before ingestion                                                                 | `[]`    |
| `metrics.serviceMonitor.honorLabels`       | honorLabels chooses the metric's labels on collisions with target labels                                                  | `false` |
| `metrics.serviceMonitor.jobLabel`          | The name of the label on the target service to use as the job name in prometheus.                                         | `""`    |
| `metrics.prometheusRule.enabled`           | Create PrometheusRule Resource for scraping metrics using PrometheusOperator                                              | `false` |
| `metrics.prometheusRule.namespace`         | Namespace which Prometheus is running in                                                                                  | `""`    |
| `metrics.prometheusRule.labels`            | Additional labels that can be used so PrometheusRule will be discovered by Prometheus                                     | `{}`    |
| `metrics.prometheusRule.groups`            | Groups, containing the alert rules.                                                                                       | `{}`    |


### keycloak-config-cli parameters

| Name                                                      | Description                                                                                                                   | Value                         |
| --------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------- | ----------------------------- |
| `keycloakConfigCli.enabled`                               | Whether to enable keycloak-config-cli job                                                                                     | `false`                       |
| `keycloakConfigCli.image.registry`                        | keycloak-config-cli container image registry                                                                                  | `docker.io`                   |
| `keycloakConfigCli.image.repository`                      | keycloak-config-cli container image repository                                                                                | `bitnami/keycloak-config-cli` |
| `keycloakConfigCli.image.tag`                             | keycloak-config-cli container image tag                                                                                       | `5.3.1-debian-11-r23`         |
| `keycloakConfigCli.image.digest`                          | keycloak-config-cli container image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag | `""`                          |
| `keycloakConfigCli.image.pullPolicy`                      | keycloak-config-cli container image pull policy                                                                               | `IfNotPresent`                |
| `keycloakConfigCli.image.pullSecrets`                     | keycloak-config-cli container image pull secrets                                                                              | `[]`                          |
| `keycloakConfigCli.annotations`                           | Annotations for keycloak-config-cli job                                                                                       | `{}`                          |
| `keycloakConfigCli.command`                               | Command for running the container (set to default if not set). Use array form                                                 | `[]`                          |
| `keycloakConfigCli.args`                                  | Args for running the container (set to default if not set). Use array form                                                    | `[]`                          |
| `keycloakConfigCli.hostAliases`                           | Job pod host aliases                                                                                                          | `[]`                          |
| `keycloakConfigCli.resources.limits`                      | The resources limits for the keycloak-config-cli container                                                                    | `{}`                          |
| `keycloakConfigCli.resources.requests`                    | The requested resources for the keycloak-config-cli container                                                                 | `{}`                          |
| `keycloakConfigCli.containerSecurityContext.enabled`      | Enabled keycloak-config-cli containers' Security Context                                                                      | `true`                        |
| `keycloakConfigCli.containerSecurityContext.runAsUser`    | Set keycloak-config-cli container's Security Context runAsUser                                                                | `1001`                        |
| `keycloakConfigCli.containerSecurityContext.runAsNonRoot` | Set keycloak-config-cli container's Security Context runAsNonRoot                                                             | `true`                        |
| `keycloakConfigCli.podSecurityContext.enabled`            | Enabled keycloak-config-cli pods' Security Context                                                                            | `true`                        |
| `keycloakConfigCli.podSecurityContext.fsGroup`            | Set keycloak-config-cli pod's Security Context fsGroup                                                                        | `1001`                        |
| `keycloakConfigCli.backoffLimit`                          | Number of retries before considering a Job as failed                                                                          | `1`                           |
| `keycloakConfigCli.podLabels`                             | Pod extra labels                                                                                                              | `{}`                          |
| `keycloakConfigCli.podAnnotations`                        | Annotations for job pod                                                                                                       | `{}`                          |
| `keycloakConfigCli.extraEnvVars`                          | Additional environment variables to set                                                                                       | `[]`                          |
| `keycloakConfigCli.extraEnvVarsCM`                        | ConfigMap with extra environment variables                                                                                    | `""`                          |
| `keycloakConfigCli.extraEnvVarsSecret`                    | Secret with extra environment variables                                                                                       | `""`                          |
| `keycloakConfigCli.extraVolumes`                          | Extra volumes to add to the job                                                                                               | `[]`                          |
| `keycloakConfigCli.extraVolumeMounts`                     | Extra volume mounts to add to the container                                                                                   | `[]`                          |
| `keycloakConfigCli.initContainers`                        | Add additional init containers to the Keycloak config cli pod                                                                 | `[]`                          |
| `keycloakConfigCli.sidecars`                              | Add additional sidecar containers to the Keycloak config cli pod                                                              | `[]`                          |
| `keycloakConfigCli.configuration`                         | keycloak-config-cli realms configuration                                                                                      | `{}`                          |
| `keycloakConfigCli.existingConfigmap`                     | ConfigMap with keycloak-config-cli configuration. This will override `keycloakConfigCli.config`                               | `""`                          |


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
helm install my-release --set auth.adminPassword=secretpassword my-repo/keycloak
```

The above command sets the Keycloak administrator password to `secretpassword`.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install my-release -f values.yaml my-repo/keycloak
```

> **Tip**: You can use the default [values.yaml](values.yaml)

Keycloak realms, users and clients can be created from the Keycloak administration panel. Refer to the [tutorial on adding user authentication to applications with Keycloak](https://docs.bitnami.com/tutorials/integrate-keycloak-authentication-kubernetes) for more details on these operations.

## Configuration and installation details

### [Rolling vs Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Use an external database

Sometimes, you may want to have Keycloak connect to an external PostgreSQL database rather than a database within your cluster - for example, when using a managed database service, or when running a single database server for all your applications. To do this, set the `postgresql.enabled` parameter to `false` and specify the credentials for the external database using the `externalDatabase.*` parameters.

Refer to the [chart documentation on using an external database](https://docs.bitnami.com/kubernetes/apps/keycloak/configuration/use-external-database) for more details and an example.

> NOTE: Only PostgreSQL database server is supported as external database

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

The [Bitnami Keycloak](https://github.com/bitnami/containers/tree/main/bitnami/keycloak) image allows you to use your custom scripts to initialize a fresh instance. In order to execute the scripts, you can specify custom scripts using the `initdbScripts` parameter as dict.

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

### Use with ingress offloading SSL

If your ingress controller has the SSL Termination, you should set `proxy` to `edge`.

### Manage secrets and passwords

This chart provides several ways to manage passwords:

* Values passed to the chart
* An existing secret with all the passwords (via the `existingSecret` parameter)
* Multiple existing secrets with all the passwords (via the `existingSecretPerPassword` parameter)

Refer to the [chart documentation on managing passwords](https://docs.bitnami.com/kubernetes/apps/keycloak/configuration/manage-passwords/) for examples of each method.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

Refer to the [chart documentation for more information about how to upgrade from previous releases](https://docs.bitnami.com/kubernetes/apps/keycloak/administration/upgrade/).

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