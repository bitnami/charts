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

| Name                | Description                                                                                            | Value                 |
| ------------------- | ------------------------------------------------------------------------------------------------------ | --------------------- |
| `image.registry`    | Jaeger image registry                                                                                  | `docker.io`           |
| `image.repository`  | Jaeger image repository                                                                                | `bitnami/jaeger`      |
| `image.tag`         | Jaeger image tag (immutable tags are recommended)                                                      | `1.39.0-debian-11-r4` |
| `image.digest`      | Jaeger image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag | `""`                  |
| `image.pullPolicy`  | image pull policy                                                                                      | `IfNotPresent`        |
| `image.pullSecrets` | Jaeger image pull secrets                                                                              | `[]`                  |
| `image.debug`       | Enable image debug mode                                                                                | `false`               |


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
| `query.readinessProbe.enabled`                      | Enable readinessProbe                                                                     | `false`           |
| `query.readinessProbe.initialDelaySeconds`          | Initial delay seconds for readinessProbe                                                  | `10`              |
| `query.readinessProbe.periodSeconds`                | Period seconds for readinessProbe                                                         | `10`              |
| `query.readinessProbe.timeoutSeconds`               | Timeout seconds for readinessProbe                                                        | `1`               |
| `query.readinessProbe.failureThreshold`             | Failure threshold for readinessProbe                                                      | `15`              |
| `query.readinessProbe.successThreshold`             | Success threshold for readinessProbe                                                      | `1`               |
| `query.customLivenessProbe`                         | Custom livenessProbe that overrides the default one                                       | `{}`              |
| `query.customStartupProbe`                          | Override default startup probe                                                            | `{}`              |
| `query.customReadinessProbe`                        | Override default readiness probe                                                          | `{}`              |
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
| `query.priorityClassName`                           | Server priorityClassName                                                                  | `""`              |
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


### Collector deployment parameters

| Name                                                    | Description                                                                                | Value                 |
| ------------------------------------------------------- | ------------------------------------------------------------------------------------------ | --------------------- |
| `collector.command`                                     | Command for running the container (set to default if not set). Use array form              | `[]`                  |
| `collector.args`                                        | Args for running the container (set to default if not set). Use array form                 | `[]`                  |
| `collector.lifecycleHooks`                              | Override default etcd container hooks                                                      | `{}`                  |
| `collector.extraEnvVars`                                | Extra environment variables to be set on jaeger container                                  | `[]`                  |
| `collector.extraEnvVarsCM`                              | Name of existing ConfigMap containing extra env vars                                       | `""`                  |
| `collector.extraEnvVarsSecret`                          | Name of existing Secret containing extra env vars                                          | `""`                  |
| `collector.replicaCount`                                | Number of Jaeger replicas                                                                  | `1`                   |
| `collector.livenessProbe.enabled`                       | Enable livenessProbe on collector nodes                                                    | `true`                |
| `collector.livenessProbe.initialDelaySeconds`           | Initial delay seconds for livenessProbe                                                    | `10`                  |
| `collector.livenessProbe.periodSeconds`                 | Period seconds for livenessProbe                                                           | `10`                  |
| `collector.livenessProbe.timeoutSeconds`                | Timeout seconds for livenessProbe                                                          | `1`                   |
| `collector.livenessProbe.failureThreshold`              | Failure threshold for livenessProbe                                                        | `3`                   |
| `collector.livenessProbe.successThreshold`              | Success threshold for livenessProbe                                                        | `1`                   |
| `collector.startupProbe.enabled`                        | Enable startupProbe on collector containers                                                | `false`               |
| `collector.startupProbe.initialDelaySeconds`            | Initial delay seconds for startupProbe                                                     | `10`                  |
| `collector.startupProbe.periodSeconds`                  | Period seconds for startupProbe                                                            | `10`                  |
| `collector.startupProbe.timeoutSeconds`                 | Timeout seconds for startupProbe                                                           | `1`                   |
| `collector.startupProbe.failureThreshold`               | Failure threshold for startupProbe                                                         | `15`                  |
| `collector.startupProbe.successThreshold`               | Success threshold for startupProbe                                                         | `1`                   |
| `collector.readinessProbe.enabled`                      | Enable readinessProbe                                                                      | `false`               |
| `collector.readinessProbe.initialDelaySeconds`          | Initial delay seconds for readinessProbe                                                   | `10`                  |
| `collector.readinessProbe.periodSeconds`                | Period seconds for readinessProbe                                                          | `10`                  |
| `collector.readinessProbe.timeoutSeconds`               | Timeout seconds for readinessProbe                                                         | `1`                   |
| `collector.readinessProbe.failureThreshold`             | Failure threshold for readinessProbe                                                       | `15`                  |
| `collector.readinessProbe.successThreshold`             | Success threshold for readinessProbe                                                       | `1`                   |
| `collector.customLivenessProbe`                         | Custom livenessProbe that overrides the default one                                        | `{}`                  |
| `collector.customStartupProbe`                          | Override default startup probe                                                             | `{}`                  |
| `collector.customReadinessProbe`                        | Override default readiness probe                                                           | `{}`                  |
| `collector.resources.limits`                            | The resources limits for Jaeger containers                                                 | `{}`                  |
| `collector.resources.requests`                          | The requested resources for Jaeger containers                                              | `{}`                  |
| `collector.extraVolumeMounts`                           | Optionally specify extra list of additional volumeMounts for jaeger container              | `[]`                  |
| `collector.service.type`                                | Jaeger service type                                                                        | `ClusterIP`           |
| `collector.service.ports.zipkin`                        | can accept Zipkin spans in Thrift, JSON and Proto (disabled by default)                    | `9411`                |
| `collector.service.ports.grpc`                          | used by jaeger-agent to send spans in model.proto format                                   | `14250`               |
| `collector.service.ports.binary`                        | can accept spans directly from clients in jaeger.thrift format over binary thrift protocol | `14268`               |
| `collector.service.ports.admin`                         | Admin port: health check at / and metrics at /metrics                                      | `14269`               |
| `collector.service.nodePorts.zipkin`                    | can accept Zipkin spans in Thrift, JSON and Proto (disabled by default)                    | `""`                  |
| `collector.service.nodePorts.grpc`                      | used by jaeger-agent to send spans in model.proto format                                   | `""`                  |
| `collector.service.nodePorts.binary`                    | can accept spans directly from clients in jaeger.thrift format over binary thrift protocol | `""`                  |
| `collector.service.nodePorts.admin`                     | Admin port: health check at / and metrics at /metrics                                      | `""`                  |
| `collector.service.extraPorts`                          | Extra ports to expose in the service (normally used with the `sidecar` value)              | `[]`                  |
| `collector.service.loadBalancerIP`                      | LoadBalancerIP if service type is `LoadBalancer`                                           | `""`                  |
| `collector.service.loadBalancerSourceRanges`            | Service Load Balancer sources                                                              | `[]`                  |
| `collector.service.clusterIP`                           | Service Cluster IP                                                                         | `""`                  |
| `collector.service.externalTrafficPolicy`               | Service external traffic policy                                                            | `Cluster`             |
| `collector.service.annotations`                         | Provide any additional annotations which may be required.                                  | `{}`                  |
| `collector.service.sessionAffinity`                     | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                       | `None`                |
| `collector.service.sessionAffinityConfig`               | Additional settings for the sessionAffinity                                                | `{}`                  |
| `collector.serviceAccount.create`                       | Enables ServiceAccount                                                                     | `true`                |
| `collector.serviceAccount.name`                         | ServiceAccount name                                                                        | `jaeger-collector-sa` |
| `collector.serviceAccount.annotations`                  | Annotations to add to all deployed objects                                                 | `{}`                  |
| `collector.serviceAccount.automountServiceAccountToken` | Automount API credentials for a service account.                                           | `true`                |
| `collector.podSecurityContext.enabled`                  | Enabled Jaeger pods' Security Context                                                      | `true`                |
| `collector.podSecurityContext.fsGroup`                  | Set Jaeger pod's Security Context fsGroup                                                  | `1001`                |
| `collector.containerSecurityContext.enabled`            | Enabled Jaeger containers' Security Context                                                | `true`                |
| `collector.containerSecurityContext.runAsUser`          | Set Jaeger container's Security Context runAsUser                                          | `1001`                |
| `collector.containerSecurityContext.runAsNonRoot`       | Force the container to be run as non root                                                  | `true`                |
| `collector.podAnnotations`                              | Additional pod annotations                                                                 | `{}`                  |
| `collector.podLabels`                                   | Additional pod labels                                                                      | `{}`                  |
| `collector.podAffinityPreset`                           | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`        | `""`                  |
| `collector.podAntiAffinityPreset`                       | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`   | `soft`                |
| `collector.nodeAffinityPreset.type`                     | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`  | `""`                  |
| `collector.nodeAffinityPreset.key`                      | Node label key to match. Ignored if `affinity` is set                                      | `""`                  |
| `collector.nodeAffinityPreset.values`                   | Node label values to match. Ignored if `affinity` is set                                   | `[]`                  |
| `collector.priorityClassName`                           | Server priorityClassName                                                                   | `""`                  |
| `collector.affinity`                                    | Affinity for pod assignment                                                                | `{}`                  |
| `collector.nodeSelector`                                | Node labels for pod assignment                                                             | `{}`                  |
| `collector.tolerations`                                 | Tolerations for pod assignment                                                             | `[]`                  |
| `collector.topologySpreadConstraints`                   | Topology Spread Constraints for pod assignment                                             | `[]`                  |
| `collector.schedulerName`                               | Alternative scheduler                                                                      | `""`                  |
| `collector.updateStrategy.type`                         | Jaeger collector deployment strategy type                                                  | `RollingUpdate`       |
| `collector.updateStrategy.rollingUpdate`                | Jaeger collector deployment rolling update configuration parameters                        | `{}`                  |
| `collector.extraVolumes`                                | Optionally specify extra list of additional volumes for jaeger container                   | `[]`                  |
| `collector.initContainers`                              | Add additional init containers to the jaeger pods                                          | `[]`                  |
| `collector.sidecars`                                    | Add additional sidecar containers to the jaeger pods                                       | `[]`                  |


### agent deployment parameters

| Name                                                | Description                                                                                                    | Value             |
| --------------------------------------------------- | -------------------------------------------------------------------------------------------------------------- | ----------------- |
| `agent.command`                                     | Command for running the container (set to default if not set). Use array form                                  | `[]`              |
| `agent.args`                                        | Args for running the container (set to default if not set). Use array form                                     | `[]`              |
| `agent.lifecycleHooks`                              | Override default etcd container hooks                                                                          | `{}`              |
| `agent.extraEnvVars`                                | Extra environment variables to be set on jaeger container                                                      | `[]`              |
| `agent.extraEnvVarsCM`                              | Name of existing ConfigMap containing extra env vars                                                           | `""`              |
| `agent.extraEnvVarsSecret`                          | Name of existing Secret containing extra env vars                                                              | `""`              |
| `agent.replicaCount`                                | Number of Jaeger replicas                                                                                      | `1`               |
| `agent.livenessProbe.enabled`                       | Enable livenessProbe on agent nodes                                                                            | `true`            |
| `agent.livenessProbe.initialDelaySeconds`           | Initial delay seconds for livenessProbe                                                                        | `10`              |
| `agent.livenessProbe.periodSeconds`                 | Period seconds for livenessProbe                                                                               | `10`              |
| `agent.livenessProbe.timeoutSeconds`                | Timeout seconds for livenessProbe                                                                              | `1`               |
| `agent.livenessProbe.failureThreshold`              | Failure threshold for livenessProbe                                                                            | `3`               |
| `agent.livenessProbe.successThreshold`              | Success threshold for livenessProbe                                                                            | `1`               |
| `agent.startupProbe.enabled`                        | Enable startupProbe on agent containers                                                                        | `false`           |
| `agent.startupProbe.initialDelaySeconds`            | Initial delay seconds for startupProbe                                                                         | `10`              |
| `agent.startupProbe.periodSeconds`                  | Period seconds for startupProbe                                                                                | `10`              |
| `agent.startupProbe.timeoutSeconds`                 | Timeout seconds for startupProbe                                                                               | `1`               |
| `agent.startupProbe.failureThreshold`               | Failure threshold for startupProbe                                                                             | `15`              |
| `agent.startupProbe.successThreshold`               | Success threshold for startupProbe                                                                             | `1`               |
| `agent.readinessProbe.enabled`                      | Enable readinessProbe                                                                                          | `false`           |
| `agent.readinessProbe.initialDelaySeconds`          | Initial delay seconds for readinessProbe                                                                       | `10`              |
| `agent.readinessProbe.periodSeconds`                | Period seconds for readinessProbe                                                                              | `10`              |
| `agent.readinessProbe.timeoutSeconds`               | Timeout seconds for readinessProbe                                                                             | `1`               |
| `agent.readinessProbe.failureThreshold`             | Failure threshold for readinessProbe                                                                           | `15`              |
| `agent.readinessProbe.successThreshold`             | Success threshold for readinessProbe                                                                           | `1`               |
| `agent.customLivenessProbe`                         | Custom livenessProbe that overrides the default one                                                            | `{}`              |
| `agent.customStartupProbe`                          | Override default startup probe                                                                                 | `{}`              |
| `agent.customReadinessProbe`                        | Override default readiness probe                                                                               | `{}`              |
| `agent.resources.limits`                            | The resources limits for Jaeger containers                                                                     | `{}`              |
| `agent.resources.requests`                          | The requested resources for Jaeger containers                                                                  | `{}`              |
| `agent.extraVolumeMounts`                           | Optionally specify extra list of additional volumeMounts for jaeger container                                  | `[]`              |
| `agent.service.type`                                | Jaeger service type                                                                                            | `ClusterIP`       |
| `agent.service.ports.compact`                       | accept jaeger.thrift in compact Thrift protocol used by most current Jaeger clients                            | `6831`            |
| `agent.service.ports.binary`                        | accept jaeger.thrift in binary Thrift protocol used by Node.js Jaeger client                                   | `6832`            |
| `agent.service.ports.config`                        | Serve configs, sampling strategies                                                                             | `5778`            |
| `agent.service.ports.zipkin`                        | Accept zipkin.thrift in compact Thrift protocol (deprecated; only used by very old Jaeger clients, circa 2016) | `5775`            |
| `agent.service.ports.admin`                         | Admin port: health check at / and metrics at /metrics                                                          | `14271`           |
| `agent.service.nodePorts.compact`                   | accept jaeger.thrift in compact Thrift protocol used by most current Jaeger clients                            | `""`              |
| `agent.service.nodePorts.binary`                    | accept jaeger.thrift in binary Thrift protocol used by Node.js Jaeger client                                   | `""`              |
| `agent.service.nodePorts.config`                    | Serve configs, sampling strategies                                                                             | `""`              |
| `agent.service.nodePorts.zipkin`                    | Accept zipkin.thrift in compact Thrift protocol (deprecated; only used by very old Jaeger clients, circa 2016) | `""`              |
| `agent.service.nodePorts.admin`                     | Admin port: health check at / and metrics at /metrics                                                          | `""`              |
| `agent.service.extraPorts`                          | Extra ports to expose in the service (normally used with the `sidecar` value)                                  | `[]`              |
| `agent.service.loadBalancerIP`                      | LoadBalancerIP if service type is `LoadBalancer`                                                               | `""`              |
| `agent.service.loadBalancerSourceRanges`            | Service Load Balancer sources                                                                                  | `[]`              |
| `agent.service.clusterIP`                           | Service Cluster IP                                                                                             | `""`              |
| `agent.service.externalTrafficPolicy`               | Service external traffic policy                                                                                | `Cluster`         |
| `agent.service.annotations`                         | Provide any additional annotations which may be required.                                                      | `{}`              |
| `agent.service.sessionAffinity`                     | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                                           | `None`            |
| `agent.service.sessionAffinityConfig`               | Additional settings for the sessionAffinity                                                                    | `{}`              |
| `agent.serviceAccount.create`                       | Enables ServiceAccount                                                                                         | `true`            |
| `agent.serviceAccount.name`                         | ServiceAccount name                                                                                            | `jaeger-agent-sa` |
| `agent.serviceAccount.annotations`                  | Annotations to add to all deployed objects                                                                     | `{}`              |
| `agent.serviceAccount.automountServiceAccountToken` | Automount API credentials for a service account.                                                               | `true`            |
| `agent.podSecurityContext.enabled`                  | Enabled Jaeger pods' Security Context                                                                          | `true`            |
| `agent.podSecurityContext.fsGroup`                  | Set Jaeger pod's Security Context fsGroup                                                                      | `1001`            |
| `agent.containerSecurityContext.enabled`            | Enabled Jaeger containers' Security Context                                                                    | `true`            |
| `agent.containerSecurityContext.runAsUser`          | Set Jaeger container's Security Context runAsUser                                                              | `1001`            |
| `agent.containerSecurityContext.runAsNonRoot`       | Force the container to be run as non root                                                                      | `true`            |
| `agent.podAnnotations`                              | Additional pod annotations                                                                                     | `{}`              |
| `agent.podLabels`                                   | Additional pod labels                                                                                          | `{}`              |
| `agent.podAffinityPreset`                           | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                            | `""`              |
| `agent.podAntiAffinityPreset`                       | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                       | `soft`            |
| `agent.nodeAffinityPreset.type`                     | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                      | `""`              |
| `agent.nodeAffinityPreset.key`                      | Node label key to match. Ignored if `affinity` is set                                                          | `""`              |
| `agent.nodeAffinityPreset.values`                   | Node label values to match. Ignored if `affinity` is set                                                       | `[]`              |
| `agent.priorityClassName`                           | Server priorityClassName                                                                                       | `""`              |
| `agent.affinity`                                    | Affinity for pod assignment                                                                                    | `{}`              |
| `agent.nodeSelector`                                | Node labels for pod assignment                                                                                 | `{}`              |
| `agent.tolerations`                                 | Tolerations for pod assignment                                                                                 | `[]`              |
| `agent.topologySpreadConstraints`                   | Topology Spread Constraints for pod assignment                                                                 | `[]`              |
| `agent.schedulerName`                               | Alternative scheduler                                                                                          | `""`              |
| `agent.updateStrategy.type`                         | Jaeger agent deployment strategy type                                                                          | `RollingUpdate`   |
| `agent.updateStrategy.rollingUpdate`                | Jaeger agent deployment rolling update configuration parameters                                                | `{}`              |
| `agent.extraVolumes`                                | Optionally specify extra list of additional volumes for jaeger container                                       | `[]`              |
| `agent.initContainers`                              | Add additional init containers to the jaeger pods                                                              | `[]`              |
| `agent.sidecars`                                    | Add additional sidecar containers to the jaeger pods                                                           | `[]`              |
| `migration.podLabels`                               | Additional pod labels                                                                                          | `{}`              |
| `migration.podAnnotations`                          | Additional pod annotations                                                                                     | `{}`              |
| `migration.annotations`                             | Provide any additional annotations which may be required.                                                      | `{}`              |
| `migration.podSecurityContext.enabled`              | Enabled Jaeger pods' Security Context                                                                          | `true`            |
| `migration.podSecurityContext.fsGroup`              | Set Jaeger pod's Security Context fsGroup                                                                      | `1001`            |
| `migration.extraEnvVarsCM`                          | Name of existing ConfigMap containing extra env vars                                                           | `""`              |
| `migration.extraEnvVarsSecret`                      | Name of existing Secret containing extra env vars                                                              | `""`              |
| `migration.extraVolumeMounts`                       | Optionally specify extra list of additional volumeMounts for jaeger container                                  | `[]`              |
| `migration.resources.limits`                        | The resources limits for Jaeger containers                                                                     | `{}`              |
| `migration.resources.requests`                      | The requested resources for Jaeger containers                                                                  | `{}`              |
| `migration.extraVolumes`                            | Optionally specify extra list of additional volumes for jaeger container                                       | `[]`              |


### Cassandra storage pod

| Name                       | Description                                | Value                             |
| -------------------------- | ------------------------------------------ | --------------------------------- |
| `cassandra.enabled`        | Enables cassandra storage pod              | `true`                            |
| `cassandra.migrationImage` | Set the image to use for the migration job | `bitnami/cassandra:4.0-debian-11` |
| `cassandra.keyspace`       | Name for cassandra's jaeger keyspace       | `jaeger_v1_dc1`                   |


