<!--- app-name: NATS -->

# NATS packaged by Bitnami

NATS is an open source, lightweight and high-performance messaging system. It is ideal for distributed systems and supports modern cloud architectures and pub-sub, request-reply and queuing models.

[Overview of NATS](https://nats.io/)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.
                           
## TL;DR

```bash
$ helm repo add my-repo https://charts.bitnami.com/bitnami
$ helm install my-release my-repo/nats
```

## Introduction

This chart bootstraps a [NATS](https://github.com/bitnami/containers/tree/main/bitnami/nats) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install my-release my-repo/nats
```

The command deploys NATS on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

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


### Common parameters

| Name                     | Description                                                                                  | Value           |
| ------------------------ | -------------------------------------------------------------------------------------------- | --------------- |
| `kubeVersion`            | Force target Kubernetes version (using Helm capabilities if not set)                         | `""`            |
| `nameOverride`           | String to partially override common.names.fullname template (will maintain the release name) | `""`            |
| `fullnameOverride`       | String to fully override common.names.fullname template                                      | `""`            |
| `commonLabels`           | Add labels to all the deployed resources                                                     | `{}`            |
| `commonAnnotations`      | Add annotations to all the deployed resources                                                | `{}`            |
| `clusterDomain`          | Kubernetes Cluster Domain                                                                    | `cluster.local` |
| `extraDeploy`            | Array of extra objects to deploy with the release                                            | `[]`            |
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden)      | `false`         |
| `diagnosticMode.command` | Command to override all containers in the deployment                                         | `["sleep"]`     |
| `diagnosticMode.args`    | Args to override all containers in the deployment                                            | `["infinity"]`  |


### NATS parameters

| Name                     | Description                                                                                           | Value                |
| ------------------------ | ----------------------------------------------------------------------------------------------------- | -------------------- |
| `image.registry`         | NATS image registry                                                                                   | `docker.io`          |
| `image.repository`       | NATS image repository                                                                                 | `bitnami/nats`       |
| `image.tag`              | NATS image tag (immutable tags are recommended)                                                       | `2.9.3-debian-11-r0` |
| `image.digest`           | NATS image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag  | `""`                 |
| `image.pullPolicy`       | NATS image pull policy                                                                                | `IfNotPresent`       |
| `image.pullSecrets`      | NATS image pull secrets                                                                               | `[]`                 |
| `image.debug`            | Enable NATS image debug mode                                                                          | `false`              |
| `auth.enabled`           | Switch to enable/disable client authentication                                                        | `true`               |
| `auth.user`              | Client authentication user                                                                            | `nats_client`        |
| `auth.password`          | Client authentication password                                                                        | `""`                 |
| `auth.token`             | Client authentication token                                                                           | `""`                 |
| `auth.timeout`           | Client authentication timeout (seconds)                                                               | `1`                  |
| `auth.usersCredentials`  | Client authentication users credentials collection                                                    | `[]`                 |
| `auth.noAuthUser`        | Client authentication username from auth.usersCredentials map to be used when no credentials provided | `""`                 |
| `cluster.connectRetries` | Configure number of connect retries for implicit routes, otherwise leave blank                        | `""`                 |
| `cluster.auth.enabled`   | Switch to enable/disable cluster authentication                                                       | `true`               |
| `cluster.auth.user`      | Cluster authentication user                                                                           | `nats_cluster`       |
| `cluster.auth.password`  | Cluster authentication password                                                                       | `""`                 |
| `cluster.auth.token`     | Cluster authentication token                                                                          | `""`                 |
| `debug.enabled`          | Switch to enable/disable debug on logging                                                             | `false`              |
| `debug.trace`            | Switch to enable/disable trace debug level on logging                                                 | `false`              |
| `debug.logtime`          | Switch to enable/disable logtime on logging                                                           | `false`              |
| `maxConnections`         | Max. number of client connections                                                                     | `""`                 |
| `maxControlLine`         | Max. protocol control line                                                                            | `""`                 |
| `maxPayload`             | Max. payload                                                                                          | `""`                 |
| `writeDeadline`          | Duration the server can block on a socket write to a client                                           | `""`                 |
| `natsFilename`           | Filename used by several NATS files (binary, configuration file, and pid file)                        | `nats-server`        |
| `configuration`          | Specify content for NATS configuration file (generated based on other parameters otherwise)           | `""`                 |
| `existingSecret`         | The name of an existing Secret with your custom configuration for NATS                                | `""`                 |
| `command`                | Override default container command (useful when using custom images)                                  | `[]`                 |
| `args`                   | Override default container args (useful when using custom images)                                     | `[]`                 |
| `extraEnvVars`           | Extra environment variables to be set on NATS container                                               | `[]`                 |
| `extraEnvVarsCM`         | ConfigMap with extra environment variables                                                            | `""`                 |
| `extraEnvVarsSecret`     | Secret with extra environment variables                                                               | `""`                 |


### NATS deployment/statefulset parameters

| Name                                    | Description                                                                                           | Value           |
| --------------------------------------- | ----------------------------------------------------------------------------------------------------- | --------------- |
| `resourceType`                          | NATS cluster resource type under Kubernetes. Allowed values: `statefulset` (default) or `deployment`  | `statefulset`   |
| `replicaCount`                          | Number of NATS nodes                                                                                  | `1`             |
| `schedulerName`                         | Use an alternate scheduler, e.g. "stork".                                                             | `""`            |
| `priorityClassName`                     | Name of pod priority class                                                                            | `""`            |
| `updateStrategy.type`                   | StrategyType. Can be set to RollingUpdate or OnDelete                                                 | `RollingUpdate` |
| `containerPorts.client`                 | NATS client container port                                                                            | `4222`          |
| `containerPorts.cluster`                | NATS cluster container port                                                                           | `6222`          |
| `containerPorts.monitoring`             | NATS monitoring container port                                                                        | `8222`          |
| `podSecurityContext.enabled`            | Enabled NATS pods' Security Context                                                                   | `false`         |
| `podSecurityContext.fsGroup`            | Set NATS pod's Security Context fsGroup                                                               | `1001`          |
| `containerSecurityContext.enabled`      | Enabled NATS containers' Security Context                                                             | `false`         |
| `containerSecurityContext.runAsUser`    | Set NATS containers' Security Context runAsUser                                                       | `1001`          |
| `containerSecurityContext.runAsNonRoot` | Set NATS containers' Security Context runAsNonRoot                                                    | `true`          |
| `resources.limits`                      | The resources limits for the NATS containers                                                          | `{}`            |
| `resources.requests`                    | The requested resources for the NATS containers                                                       | `{}`            |
| `livenessProbe.enabled`                 | Enable livenessProbe                                                                                  | `true`          |
| `livenessProbe.initialDelaySeconds`     | Initial delay seconds for livenessProbe                                                               | `30`            |
| `livenessProbe.periodSeconds`           | Period seconds for livenessProbe                                                                      | `10`            |
| `livenessProbe.timeoutSeconds`          | Timeout seconds for livenessProbe                                                                     | `5`             |
| `livenessProbe.failureThreshold`        | Failure threshold for livenessProbe                                                                   | `6`             |
| `livenessProbe.successThreshold`        | Success threshold for livenessProbe                                                                   | `1`             |
| `readinessProbe.enabled`                | Enable readinessProbe                                                                                 | `true`          |
| `readinessProbe.initialDelaySeconds`    | Initial delay seconds for readinessProbe                                                              | `5`             |
| `readinessProbe.periodSeconds`          | Period seconds for readinessProbe                                                                     | `10`            |
| `readinessProbe.timeoutSeconds`         | Timeout seconds for readinessProbe                                                                    | `5`             |
| `readinessProbe.failureThreshold`       | Failure threshold for readinessProbe                                                                  | `6`             |
| `readinessProbe.successThreshold`       | Success threshold for readinessProbe                                                                  | `1`             |
| `startupProbe.enabled`                  | Enable startupProbe on NATS containers                                                                | `false`         |
| `startupProbe.initialDelaySeconds`      | Initial delay seconds for startupProbe                                                                | `5`             |
| `startupProbe.periodSeconds`            | Period seconds for startupProbe                                                                       | `10`            |
| `startupProbe.timeoutSeconds`           | Timeout seconds for startupProbe                                                                      | `5`             |
| `startupProbe.failureThreshold`         | Failure threshold for startupProbe                                                                    | `6`             |
| `startupProbe.successThreshold`         | Success threshold for startupProbe                                                                    | `1`             |
| `customLivenessProbe`                   | Override default liveness probe                                                                       | `{}`            |
| `customReadinessProbe`                  | Override default readiness probe                                                                      | `{}`            |
| `customStartupProbe`                    | Custom startupProbe that overrides the default one                                                    | `{}`            |
| `hostAliases`                           | Deployment pod host aliases                                                                           | `[]`            |
| `podLabels`                             | Extra labels for NATS pods                                                                            | `{}`            |
| `podAnnotations`                        | Annotations for NATS pods                                                                             | `{}`            |
| `podAffinityPreset`                     | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                   | `""`            |
| `podAntiAffinityPreset`                 | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`              | `soft`          |
| `nodeAffinityPreset.type`               | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`             | `""`            |
| `nodeAffinityPreset.key`                | Node label key to match. Ignored if `affinity` is set.                                                | `""`            |
| `nodeAffinityPreset.values`             | Node label values to match. Ignored if `affinity` is set.                                             | `[]`            |
| `affinity`                              | Affinity for pod assignment. Evaluated as a template.                                                 | `{}`            |
| `nodeSelector`                          | Node labels for pod assignment. Evaluated as a template.                                              | `{}`            |
| `tolerations`                           | Tolerations for pod assignment. Evaluated as a template.                                              | `[]`            |
| `topologySpreadConstraints`             | Topology Spread Constraints for NATS pods assignment spread across your cluster among failure-domains | `[]`            |
| `lifecycleHooks`                        | for the NATS container(s) to automate configuration before or after startup                           | `{}`            |
| `extraVolumes`                          | Optionally specify extra list of additional volumes for NATS pods                                     | `[]`            |
| `extraVolumeMounts`                     | Optionally specify extra list of additional volumeMounts for NATS container(s)                        | `[]`            |
| `initContainers`                        | Add additional init containers to the NATS pods                                                       | `[]`            |
| `sidecars`                              | Add additional sidecar containers to the NATS pods                                                    | `[]`            |


### Traffic Exposure parameters

| Name                               | Description                                                                                                                      | Value                    |
| ---------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `service.type`                     | NATS service type                                                                                                                | `ClusterIP`              |
| `service.ports.client`             | NATS client service port                                                                                                         | `4222`                   |
| `service.ports.cluster`            | NATS cluster service port                                                                                                        | `6222`                   |
| `service.ports.monitoring`         | NATS monitoring service port                                                                                                     | `8222`                   |
| `service.nodePorts.client`         | Node port for clients                                                                                                            | `""`                     |
| `service.nodePorts.cluster`        | Node port for clustering                                                                                                         | `""`                     |
| `service.nodePorts.monitoring`     | Node port for monitoring                                                                                                         | `""`                     |
| `service.sessionAffinity`          | Control where client requests go, to the same pod or round-robin                                                                 | `None`                   |
| `service.sessionAffinityConfig`    | Additional settings for the sessionAffinity                                                                                      | `{}`                     |
| `service.clusterIP`                | NATS service Cluster IP                                                                                                          | `""`                     |
| `service.loadBalancerIP`           | NATS service Load Balancer IP                                                                                                    | `""`                     |
| `service.loadBalancerSourceRanges` | NATS service Load Balancer sources                                                                                               | `[]`                     |
| `service.externalTrafficPolicy`    | NATS service external traffic policy                                                                                             | `Cluster`                |
| `service.annotations`              | Additional custom annotations for NATS service                                                                                   | `{}`                     |
| `service.extraPorts`               | Extra ports to expose in the NATS service (normally used with the `sidecar` value)                                               | `[]`                     |
| `ingress.enabled`                  | Set to true to enable ingress record generation                                                                                  | `false`                  |
| `ingress.pathType`                 | Ingress Path type                                                                                                                | `ImplementationSpecific` |
| `ingress.apiVersion`               | Override API Version (automatically detected if not set)                                                                         | `""`                     |
| `ingress.hostname`                 | When the ingress is enabled, a host pointing to this will be created                                                             | `nats.local`             |
| `ingress.path`                     | The Path to NATS. You may need to set this to '/*' in order to use this with ALB ingress controllers.                            | `/`                      |
| `ingress.ingressClassName`         | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                    | `""`                     |
| `ingress.annotations`              | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                     |
| `ingress.tls`                      | Enable TLS configuration for the host defined at `ingress.hostname` parameter                                                    | `false`                  |
| `ingress.selfSigned`               | Create a TLS secret for this ingress record using self-signed certificates generated by Helm                                     | `false`                  |
| `ingress.extraHosts`               | The list of additional hostnames to be covered with this ingress record.                                                         | `[]`                     |
| `ingress.extraPaths`               | Any additional arbitrary paths that may need to be added to the ingress under the main host.                                     | `[]`                     |
| `ingress.extraTls`                 | The tls configuration for additional hostnames to be covered with this ingress record.                                           | `[]`                     |
| `ingress.secrets`                  | If you're providing your own certificates, please use this to add the certificates as secrets                                    | `[]`                     |
| `ingress.extraRules`               | Additional rules to be covered with this ingress record                                                                          | `[]`                     |
| `networkPolicy.enabled`            | Enable creation of NetworkPolicy resources                                                                                       | `false`                  |
| `networkPolicy.allowExternal`      | The Policy model to apply                                                                                                        | `true`                   |
| `networkPolicy.additionalRules`    | Additional NetworkPolicy Ingress "from" rules to set. Note that all rules are OR-ed.                                             | `{}`                     |


### Metrics parameters

| Name                                       | Description                                                                                            | Value                   |
| ------------------------------------------ | ------------------------------------------------------------------------------------------------------ | ----------------------- |
| `metrics.enabled`                          | Enable Prometheus metrics via exporter side-car                                                        | `false`                 |
| `metrics.image.registry`                   | Prometheus metrics exporter image registry                                                             | `docker.io`             |
| `metrics.image.repository`                 | Prometheus metrics exporter image repository                                                           | `bitnami/nats-exporter` |
| `metrics.image.tag`                        | Prometheus metrics exporter image tag (immutable tags are recommended)                                 | `0.10.0-debian-11-r18`  |
| `metrics.image.digest`                     | Petete image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag | `""`                    |
| `metrics.image.pullPolicy`                 | Prometheus metrics image pull policy                                                                   | `IfNotPresent`          |
| `metrics.image.pullSecrets`                | Prometheus metrics image pull secrets                                                                  | `[]`                    |
| `metrics.resources`                        | Metrics exporter resource requests and limits                                                          | `{}`                    |
| `metrics.containerPort`                    | Prometheus metrics exporter port                                                                       | `7777`                  |
| `metrics.flags`                            | Flags to be passed to Prometheus metrics                                                               | `[]`                    |
| `metrics.service.type`                     | Kubernetes service type (`ClusterIP`, `NodePort` or `LoadBalancer`)                                    | `ClusterIP`             |
| `metrics.service.port`                     | Prometheus metrics service port                                                                        | `7777`                  |
| `metrics.service.loadBalancerIP`           | Use serviceLoadBalancerIP to request a specific static IP, otherwise leave blank                       | `""`                    |
| `metrics.service.annotations`              | Annotations for Prometheus metrics service                                                             | `{}`                    |
| `metrics.service.labels`                   | Labels for Prometheus metrics service                                                                  | `{}`                    |
| `metrics.serviceMonitor.enabled`           | Specify if a ServiceMonitor will be deployed for Prometheus Operator                                   | `false`                 |
| `metrics.serviceMonitor.namespace`         | Namespace in which Prometheus is running                                                               | `monitoring`            |
| `metrics.serviceMonitor.labels`            | Extra labels for the ServiceMonitor                                                                    | `{}`                    |
| `metrics.serviceMonitor.jobLabel`          | The name of the label on the target service to use as the job name in Prometheus                       | `""`                    |
| `metrics.serviceMonitor.interval`          | How frequently to scrape metrics                                                                       | `""`                    |
| `metrics.serviceMonitor.scrapeTimeout`     | Timeout after which the scrape is ended                                                                | `""`                    |
| `metrics.serviceMonitor.metricRelabelings` | Specify additional relabeling of metrics                                                               | `[]`                    |
| `metrics.serviceMonitor.relabelings`       | Specify general relabeling                                                                             | `[]`                    |
| `metrics.serviceMonitor.selector`          | Prometheus instance selector labels                                                                    | `{}`                    |


### Other parameters

| Name                 | Description                                                    | Value   |
| -------------------- | -------------------------------------------------------------- | ------- |
| `pdb.create`         | Enable/disable a Pod Disruption Budget creation                | `false` |
| `pdb.minAvailable`   | Minimum number/percentage of pods that should remain scheduled | `1`     |
| `pdb.maxUnavailable` | Maximum number/percentage of pods that may be made unavailable | `""`    |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install my-release \
  --set auth.enabled=true,auth.user=my-user,auth.password=T0pS3cr3t \
    my-repo/nats
```

The above command enables NATS client authentication with `my-user` as user and `T0pS3cr3t` as password credentials.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install my-release -f values.yaml my-repo/nats
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling vs Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Add extra environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `extraEnvVars` property.

```yaml
extraEnvVars:
  - name: LOG_LEVEL
    value: DEBUG
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values.

### Use Sidecars and Init Containers

If additional containers are needed in the same pod (such as additional metrics or logging exporters), they can be defined using the `sidecars` config parameter. Similarly, extra init containers can be added using the `initContainers` parameter.

Refer to the chart documentation for more information on, and examples of, configuring and using [sidecars and init containers](https://docs.bitnami.com/kubernetes/infrastructure/nats/configuration/configure-sidecar-init-containers/).

### Deploy extra resources

There are cases where you may want to deploy extra objects, such a ConfigMap containing your app's configuration or some extra deployment with a micro service used by your app. For covering this case, the chart allows adding the full specification of other objects using the `extraDeploy` parameter.

### Set Pod affinity

This chart allows you to set custom Pod affinity using the `affinity` parameter. Find more information about Pod affinity in the [Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

## Deploy chart with NATS version 1.x.x

NATS version 2.0.0 has renamed the server binary filename from `gnatsd` to `nats-server`. Therefore, the default values has been changed in the chart,
however, it is still possible to use the chart to deploy NATS version 1.x.x using the `natsFilename` property.

```bash
helm install nats-v1 --set natsFilename=gnatsd --set image.tag=1.4.1 my-repo/nats
```

### To 7.0.0

This new version updates the NATS image to a [new version that has support to configure NATS based on bash logic](https://github.com/bitnami/containers/tree/main/bitnami/nats#264-r13), although this chart overwrites the configuration file so that shouldn't affect the functionality. It also adds several standardizations that were missing in the chart:

- Add missing parameters such as `existingSecret`, `containerPorts.*`, `startupProbe.*` or `lifecycleHooks`.
- Add missing parameters to extend the services such as `service.extraPorts` or `service.sessionAffinity`.
- Add missing parameters to customize the ServiceMonitor for Prometheus Operator.

Other important changes:

- The NATS configuration file is no longer retrieved from a ConfigMap but a Secret instead.
- Regroup the client, cluster and monitoring service into a single service that exposes every port.

Consequences:

- Backwards compatibility is not guaranteed.

### To 6.0.0

- Some parameters were renamed or disappeared in favor of new ones on this major version. For instance:
  - `securityContext.*` is deprecated in favor of `podSecurityContext` and `containerSecurityContext`.
- Ingress configuration was adapted to follow the Helm charts best practices.
- Chart labels were also adapted to follow the [Helm charts standard labels](https://helm.sh/docs/chart_best_practices/labels/#standard-labels).
- This version also introduces `bitnami/common`, a [library chart](https://helm.sh/docs/topics/library_charts/#helm) as a dependency. More documentation about this new utility could be found [here](https://github.com/bitnami/charts/tree/master/bitnami/common#bitnami-common-library-chart). Please, make sure that you have updated the chart dependencies before executing any upgrade.

Consequences:

- Backwards compatibility is not guaranteed.

### To 5.0.0

[On November 13, 2020, Helm v2 support formally ended](https://github.com/helm/charts#status-of-the-project). This major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

[Learn more about this change and related upgrade considerations](https://docs.bitnami.com/kubernetes/infrastructure/nats/administration/upgrade-helm3/).

### To 1.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 1.0.0. The following example assumes that the release name is nats:

```console
$ kubectl delete statefulset nats-nats --cascade=false
```

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