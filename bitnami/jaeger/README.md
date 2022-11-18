<!--- app-name: Jaeger -->

## Parameters

### Global parameters

| Name                      | Description                                     | Value |
| ------------------------- | ----------------------------------------------- | ----- |
| `global.imageRegistry`    | Global Docker image registry                    | `""`  |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]`  |
| `global.storageClass`     | Global StorageClass for Persistent Volume(s)    | `""`  |


### Common parameters

| Name                     | Description                                                                             | Value          |
| ------------------------ | --------------------------------------------------------------------------------------- | -------------- |
| `nameOverride`           | String to partially override common.names.fullname                                      | `""`           |
| `fullnameOverride`       | String to fully override common.names.fullname                                          | `""`           |
| `kubeVersion`            | Force target Kubernetes version (using Helm capabilities if not set)                    | `""`           |
| `commonLabels`           | Labels to add to all deployed objects (sub-charts are not considered)                   | `{}`           |
| `commonAnnotations`      | Annotations to add to all deployed objects                                              | `{}`           |
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden) | `false`        |
| `diagnosticMode.command` | Command to override all containers in the deployment                                    | `["sleep"]`    |
| `diagnosticMode.args`    | Args to override all containers in the deployment                                       | `["infinity"]` |


### Jaeger parameters

| Name                    | Description                                                                                                      | Value                 |
| ----------------------- | ---------------------------------------------------------------------------------------------------------------- | --------------------- |
| `image.registry`        | Jaeger image registry                                                                                            | `docker.io`           |
| `image.repository`      | Jaeger image repository                                                                                          | `bitnami/jaeger`      |
| `image.tag`             | Jaeger image tag (immutable tags are recommended)                                                                | `1.39.0-debian-11-r4` |
| `image.digest`          | Jaeger image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag           | `""`                  |
| `image.pullPolicy`      | image pull policy                                                                                                | `IfNotPresent`        |
| `image.pullSecrets`     | Jaeger image pull secrets                                                                                        | `[]`                  |
| `image.debug`           | Enable image debug mode                                                                                          | `false`               |
| `dbUser.user`           | Jaeger admin user                                                                                                | `jaeger`              |
| `dbUser.forcePassword`  | Force the user to provide a non                                                                                  | `false`               |
| `dbUser.password`       | Password for `dbUser.user`. Randomly generated if empty                                                          | `""`                  |
| `dbUser.existingSecret` | Use an existing secret object for `dbUser.user` password (will ignore `dbUser.password`)                         | `""`                  |
| `initDBConfigMap`       | ConfigMap with cql scripts. Useful for creating a keyspace and pre-populating data                               | `""`                  |
| `initDBSecret`          | Secret with cql script (with sensitive data). Useful for creating a keyspace and pre-populating data             | `""`                  |
| `existingConfiguration` | ConfigMap with custom jaeger configuration files. This overrides any other Jaeger configuration set in the chart | `""`                  |


### Query deployment parameters

| Name                                                | Description                                                                               | Value             |
| --------------------------------------------------- | ----------------------------------------------------------------------------------------- | ----------------- |
| `query.command`                                     | Command for running the container (set to default if not set). Use array form             | `[]`              |
| `query.args`                                        | Args for running the container (set to default if not set). Use array form                | `[]`              |
| `query.lifecycleHooks`                              | Override default etcd container hooks                                                     | `{}`              |
| `query.extraEnvVars`                                | Extra environment variables to be set on jaeger container                                 | `[]`              |
| `query.extraEnvVarsCM`                              | Name of existing ConfigMap containing extra env vars                                      | `""`              |
| `query.extraEnvVarsSecret`                          | Name of existing Secret containing extra env vars                                         | `""`              |
| `query.replicaCount`                                | Number of Jaeger replicas                                                                 | `1`               |
| `query.livenessProbe.enabled`                       | Enable livenessProbe on Query nodes                                                       | `true`            |
| `query.livenessProbe.initialDelaySeconds`           | Initial delay seconds for livenessProbe                                                   | `10`              |
| `query.livenessProbe.periodSeconds`                 | Period seconds for livenessProbe                                                          | `10`              |
| `query.livenessProbe.timeoutSeconds`                | Timeout seconds for livenessProbe                                                         | `1`               |
| `query.livenessProbe.failureThreshold`              | Failure threshold for livenessProbe                                                       | `3`               |
| `query.livenessProbe.successThreshold`              | Success threshold for livenessProbe                                                       | `1`               |
| `query.startupProbe.enabled`                        | Enable startupProbe on Query containers                                                   | `false`           |
| `query.startupProbe.initialDelaySeconds`            | Initial delay seconds for startupProbe                                                    | `10`              |
| `query.startupProbe.periodSeconds`                  | Period seconds for startupProbe                                                           | `10`              |
| `query.startupProbe.timeoutSeconds`                 | Timeout seconds for startupProbe                                                          | `1`               |
| `query.startupProbe.failureThreshold`               | Failure threshold for startupProbe                                                        | `15`              |
| `query.startupProbe.successThreshold`               | Success threshold for startupProbe                                                        | `1`               |
| `query.customLivenessProbe`                         | Custom livenessProbe that overrides the default one                                       | `{}`              |
| `query.customStartupProbe`                          | Override default startup probe                                                            | `{}`              |
| `query.resources.limits`                            | The resources limits for Jaeger containers                                                | `{}`              |
| `query.resources.requests`                          | The requested resources for Jaeger containers                                             | `{}`              |
| `query.extraVolumeMounts`                           | Optionally specify extra list of additional volumeMounts for jaeger container             | `[]`              |
| `query.service.type`                                | Jaeger service type                                                                       | `ClusterIP`       |
| `query.service.ports.api`                           | Port for API                                                                              | `16686`           |
| `query.service.ports.admin`                         | Port for admin                                                                            | `16687`           |
| `query.service.nodePorts.api`                       | Node port for API                                                                         | `""`              |
| `query.service.nodePorts.admin`                     | Node port for admin                                                                       | `""`              |
| `query.service.extraPorts`                          | Extra ports to expose in the service (normally used with the `sidecar` value)             | `[]`              |
| `query.service.loadBalancerIP`                      | LoadBalancerIP if service type is `LoadBalancer`                                          | `""`              |
| `query.service.loadBalancerSourceRanges`            | Service Load Balancer sources                                                             | `[]`              |
| `query.service.clusterIP`                           | Service Cluster IP                                                                        | `""`              |
| `query.service.externalTrafficPolicy`               | Service external traffic policy                                                           | `Cluster`         |
| `query.service.annotations`                         | Provide any additional annotations which may be required.                                 | `{}`              |
| `query.service.sessionAffinity`                     | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                      | `None`            |
| `query.service.sessionAffinityConfig`               | Additional settings for the sessionAffinity                                               | `{}`              |
| `query.serviceAccount.create`                       | Enables ServiceAccount                                                                    | `true`            |
| `query.serviceAccount.name`                         | ServiceAccount name                                                                       | `jaeger-query-sa` |
| `query.serviceAccount.annotations`                  | Annotations to add to all deployed objects                                                | `{}`              |
| `query.serviceAccount.automountServiceAccountToken` | Automount API credentials for a service account.                                          | `true`            |
| `query.podSecurityContext.enabled`                  | Enabled Jaeger pods' Security Context                                                     | `true`            |
| `query.podSecurityContext.fsGroup`                  | Set Jaeger pod's Security Context fsGroup                                                 | `1001`            |
| `query.containerSecurityContext.enabled`            | Enabled Jaeger containers' Security Context                                               | `true`            |
| `query.containerSecurityContext.runAsUser`          | Set Jaeger container's Security Context runAsUser                                         | `1001`            |
| `query.containerSecurityContext.runAsNonRoot`       | Force the container to be run as non root                                                 | `true`            |
| `query.podAnnotations`                              | Additional pod annotations                                                                | `{}`              |
| `query.podLabels`                                   | Additional pod labels                                                                     | `{}`              |
| `query.podAffinityPreset`                           | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`       | `""`              |
| `query.podAntiAffinityPreset`                       | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`  | `soft`            |
| `query.nodeAffinityPreset.type`                     | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard` | `""`              |
| `query.nodeAffinityPreset.key`                      | Node label key to match. Ignored if `affinity` is set                                     | `""`              |
| `query.nodeAffinityPreset.values`                   | Node label values to match. Ignored if `affinity` is set                                  | `[]`              |
| `query.affinity`                                    | Affinity for pod assignment                                                               | `{}`              |
| `query.nodeSelector`                                | Node labels for pod assignment                                                            | `{}`              |
| `query.tolerations`                                 | Tolerations for pod assignment                                                            | `[]`              |
| `query.topologySpreadConstraints`                   | Topology Spread Constraints for pod assignment                                            | `[]`              |
| `query.schedulerName`                               | Alternative scheduler                                                                     | `""`              |
| `query.updateStrategy.type`                         | Jaeger query deployment strategy type                                                     | `RollingUpdate`   |
| `query.updateStrategy.rollingUpdate`                | Jaeger query deployment rolling update configuration parameters                           | `{}`              |
| `query.extraVolumes`                                | Optionally specify extra list of additional volumes for jaeger container                  | `[]`              |
| `query.initContainers`                              | Add additional init containers to the jaeger pods                                         | `[]`              |
| `query.sidecars`                                    | Add additional sidecar containers to the jaeger pods                                      | `[]`              |


### Cassandra storage pod

| Name                | Description                   | Value  |
| ------------------- | ----------------------------- | ------ |
| `cassandra.enabled` | Enables cassandra storage pod | `true` |


