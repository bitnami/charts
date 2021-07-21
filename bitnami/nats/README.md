# NATS

[NATS](https://nats.io/) is an open-source, cloud-native messaging system. It provides a lightweight server that is written in the Go programming language.

## TL;DR

```bash
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/nats
```

## Introduction

This chart bootstraps a [NATS](https://github.com/bitnami/bitnami-docker-nats) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This chart has been tested to work with NGINX Ingress, cert-manager, fluentd and Prometheus on top of the [BKPR](https://kubeprod.io/).

## Prerequisites

- Kubernetes 1.12+
- Helm 3.1.0

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install my-release bitnami/nats
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

| Name                | Description                                                                                  | Value           |
| ------------------- | -------------------------------------------------------------------------------------------- | --------------- |
| `kubeVersion`       | Force target Kubernetes version (using Helm capabilities if not set)                         | `""`            |
| `nameOverride`      | String to partially override common.names.fullname template (will maintain the release name) | `""`            |
| `fullnameOverride`  | String to fully override common.names.fullname template                                      | `""`            |
| `commonLabels`      | Add labels to all the deployed resources                                                     | `{}`            |
| `commonAnnotations` | Add annotations to all the deployed resources                                                | `{}`            |
| `clusterDomain`     | Kubernetes Cluster Domain                                                                    | `cluster.local` |
| `extraDeploy`       | Array of extra objects to deploy with the release                                            | `[]`            |


### NATS parameters

| Name                   | Description                                                                    | Value                |
| ---------------------- | ------------------------------------------------------------------------------ | -------------------- |
| `image.registry`       | NATS image registry                                                            | `docker.io`          |
| `image.repository`     | NATS image repository                                                          | `bitnami/nats`       |
| `image.tag`            | NATS image tag (immutable tags are recommended)                                | `2.3.2-debian-10-r0` |
| `image.pullPolicy`     | Image pull policy                                                              | `IfNotPresent`       |
| `image.pullSecrets`    | Specify docker-registry secret names as an array                               | `[]`                 |
| `auth.enabled`         | Switch to enable/disable client authentication                                 | `true`               |
| `auth.user`            | Client authentication user                                                     | `nats_client`        |
| `auth.password`        | Client authentication password                                                 | `""`                 |
| `auth.token`           | Client authentication token                                                    | `""`                 |
| `auth.timeout`         | Client authentication timeout (seconds)                                        | `1`                  |
| `clusterAuth.enabled`  | Switch to enable/disable cluster authentication                                | `true`               |
| `clusterAuth.user`     | Cluster authentication user                                                    | `nats_cluster`       |
| `clusterAuth.password` | Cluster authentication password                                                | `""`                 |
| `clusterAuth.token`    | Cluster authentication token                                                   | `""`                 |
| `debug.enabled`        | Switch to enable/disable debug on logging                                      | `false`              |
| `debug.trace`          | Switch to enable/disable trace debug level on logging                          | `false`              |
| `debug.logtime`        | Switch to enable/disable logtime on logging                                    | `false`              |
| `maxConnections`       | Max. number of client connections                                              | `""`                 |
| `maxControlLine`       | Max. protocol control line                                                     | `""`                 |
| `maxPayload`           | Max. payload                                                                   | `""`                 |
| `writeDeadline`        | Duration the server can block on a socket write to a client                    | `""`                 |
| `natsFilename`         | Filename used by several NATS files (binary, configurarion file, and pid file) | `nats-server`        |
| `command`              | Override default container command (useful when using custom images)           | `[]`                 |
| `args`                 | Override default container args (useful when using custom images)              | `[]`                 |
| `hostAliases`          | Deployment pod host aliases                                                    | `[]`                 |
| `extraFlags`           | Extra flags to be passed to NATS                                               | `{}`                 |
| `extraEnvVars`         | Extra environment variables to be set on NATS container                        | `[]`                 |
| `extraEnvVarsCM`       | ConfigMap with extra environment variables                                     | `""`                 |
| `extraEnvVarsSecret`   | Secret with extra environment variables                                        | `""`                 |


### NATS deployment/statefulset parameters

| Name                                 | Description                                                                                          | Value           |
| ------------------------------------ | ---------------------------------------------------------------------------------------------------- | --------------- |
| `resourceType`                       | NATS cluster resource type under Kubernetes. Allowed values: `statefulset` (default) or `deployment` | `statefulset`   |
| `replicaCount`                       | Number of NATS nodes                                                                                 | `1`             |
| `schedulerName`                      | Use an alternate scheduler, e.g. "stork".                                                            | `""`            |
| `priorityClassName`                  | Name of pod priority class                                                                           | `""`            |
| `updateStrategy.type`                | StrategyType. Can be set to RollingUpdate or OnDelete                                                | `RollingUpdate` |
| `podSecurityContext`                 | NATS pods' Security Context                                                                          | `{}`            |
| `containerSecurityContext`           | NATS containers' Security Context                                                                    | `{}`            |
| `resources.limits`                   | The resources limits for the NATS container                                                          | `{}`            |
| `resources.requests`                 | The requested resources for the NATS container                                                       | `{}`            |
| `livenessProbe.enabled`              | Enable livenessProbe                                                                                 | `true`          |
| `livenessProbe.httpGet.path`         | Request path for livenessProbe                                                                       | `/`             |
| `livenessProbe.httpGet.port`         | Port for livenessProbe                                                                               | `monitoring`    |
| `livenessProbe.initialDelaySeconds`  | Initial delay seconds for livenessProbe                                                              | `30`            |
| `livenessProbe.periodSeconds`        | Period seconds for livenessProbe                                                                     | `10`            |
| `livenessProbe.timeoutSeconds`       | Timeout seconds for livenessProbe                                                                    | `5`             |
| `livenessProbe.failureThreshold`     | Failure threshold for livenessProbe                                                                  | `6`             |
| `livenessProbe.successThreshold`     | Success threshold for livenessProbe                                                                  | `1`             |
| `readinessProbe.enabled`             | Enable readinessProbe                                                                                | `true`          |
| `readinessProbe.httpGet.path`        | Request path for readinessProbe                                                                      | `/`             |
| `readinessProbe.httpGet.port`        | Port for readinessProbe                                                                              | `monitoring`    |
| `readinessProbe.initialDelaySeconds` | Initial delay seconds for readinessProbe                                                             | `5`             |
| `readinessProbe.periodSeconds`       | Period seconds for readinessProbe                                                                    | `10`            |
| `readinessProbe.timeoutSeconds`      | Timeout seconds for readinessProbe                                                                   | `5`             |
| `readinessProbe.failureThreshold`    | Failure threshold for readinessProbe                                                                 | `6`             |
| `readinessProbe.successThreshold`    | Success threshold for readinessProbe                                                                 | `1`             |
| `customLivenessProbe`                | Override default liveness probe                                                                      | `{}`            |
| `customReadinessProbe`               | Override default readiness probe                                                                     | `{}`            |
| `podLabels`                          | Extra labels for NATS pods                                                                           | `{}`            |
| `podAnnotations`                     | Annotations for NATS pods                                                                            | `{}`            |
| `podAffinityPreset`                  | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                  | `""`            |
| `podAntiAffinityPreset`              | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`             | `soft`          |
| `nodeAffinityPreset.type`            | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`            | `""`            |
| `nodeAffinityPreset.key`             | Node label key to match. Ignored if `affinity` is set.                                               | `""`            |
| `nodeAffinityPreset.values`          | Node label values to match. Ignored if `affinity` is set.                                            | `[]`            |
| `affinity`                           | Affinity for pod assignment. Evaluated as a template.                                                | `{}`            |
| `nodeSelector`                       | Node labels for pod assignment. Evaluated as a template.                                             | `{}`            |
| `tolerations`                        | Tolerations for pod assignment. Evaluated as a template.                                             | `[]`            |
| `extraVolumes`                       | Optionally specify extra list of additional volumes for NATS pods                                    | `[]`            |
| `extraVolumeMounts`                  | Optionally specify extra list of additional volumeMounts for NATS container(s)                       | `[]`            |
| `initContainers`                     | Add additional init containers to the NATS pods                                                      | `[]`            |
| `sidecars`                           | Add additional sidecar containers to the NATS pods                                                   | `[]`            |


### Traffic Exposure parameters

| Name                                | Description                                                                                           | Value                    |
| ----------------------------------- | ----------------------------------------------------------------------------------------------------- | ------------------------ |
| `client.service.type`               | Kubernetes Service type (NATS client)                                                                 | `ClusterIP`              |
| `client.service.port`               | NATS client port                                                                                      | `4222`                   |
| `client.service.nodePort`           | Port to bind to for the LoadBalancer and NodePort service type (NATS client)                          | `""`                     |
| `client.service.annotations`        | Annotations for NATS client service                                                                   | `{}`                     |
| `client.service.loadBalancerIP`     | loadBalancerIP if NATS client service type is `LoadBalancer`, otherwise leave blank                   | `""`                     |
| `cluster.connectRetries`            | Configure number of connect retries for implicit routes, otherwise leave blank                        | `""`                     |
| `cluster.service.type`              | Kubernetes Service type (NATS cluster)                                                                | `ClusterIP`              |
| `cluster.service.port`              | NATS cluster port                                                                                     | `6222`                   |
| `cluster.service.nodePort`          | Port to bind to for NodePort service type (NATS cluster)                                              | `""`                     |
| `cluster.service.annotations`       | Annotations for NATS cluster service                                                                  | `{}`                     |
| `cluster.service.loadBalancerIP`    | loadBalancerIP if NATS cluster service type is `LoadBalancer`                                         | `""`                     |
| `monitoring.service.type`           | Kubernetes Service type (NATS monitoring)                                                             | `ClusterIP`              |
| `monitoring.service.port`           | NATS monitoring port                                                                                  | `8222`                   |
| `monitoring.service.nodePort`       | Port to bind to for NodePort service type (NATS monitoring)                                           | `""`                     |
| `monitoring.service.annotations`    | Annotations for NATS monitoring service                                                               | `{}`                     |
| `monitoring.service.loadBalancerIP` | Use loadBalancerIP to request a specific static IP, otherwise leave blank                             | `""`                     |
| `ingress.enabled`                   | Set to true to enable ingress record generation                                                       | `false`                  |
| `ingress.certManager`               | Set this to true in order to add the corresponding annotations for cert-manager                       | `false`                  |
| `ingress.pathType`                  | Ingress Path type                                                                                     | `ImplementationSpecific` |
| `ingress.apiVersion`                | Override API Version (automatically detected if not set)                                              | `""`                     |
| `ingress.hostname`                  | When the ingress is enabled, a host pointing to this will be created                                  | `nats.local`             |
| `ingress.path`                      | The Path to NATS. You may need to set this to '/*' in order to use this with ALB ingress controllers. | `ImplementationSpecific` |
| `ingress.annotations`               | Ingress annotations                                                                                   | `{}`                     |
| `ingress.tls`                       | Enable TLS configuration for the hostname defined at ingress.hostname parameter                       | `false`                  |
| `ingress.extraHosts`                | The list of additional hostnames to be covered with this ingress record.                              | `[]`                     |
| `ingress.extraPaths`                | Any additional arbitrary paths that may need to be added to the ingress under the main host.          | `[]`                     |
| `ingress.extraTls`                  | The tls configuration for additional hostnames to be covered with this ingress record.                | `[]`                     |
| `ingress.secrets`                   | If you're providing your own certificates, please use this to add the certificates as secrets         | `[]`                     |
| `networkPolicy.enabled`             | Enable creation of NetworkPolicy resources                                                            | `false`                  |
| `networkPolicy.allowExternal`       | The Policy model to apply                                                                             | `true`                   |
| `networkPolicy.additionalRules`     | Additional NetworkPolicy Ingress "from" rules to set. Note that all rules are OR-ed.                  | `{}`                     |


### Metrics parameters

| Name                               | Description                                                                                            | Value                   |
| ---------------------------------- | ------------------------------------------------------------------------------------------------------ | ----------------------- |
| `metrics.enabled`                  | Enable Prometheus metrics via exporter side-car                                                        | `false`                 |
| `metrics.image.registry`           | Prometheus metrics exporter image registry                                                             | `docker.io`             |
| `metrics.image.repository`         | Prometheus metrics exporter image repository                                                           | `bitnami/nats-exporter` |
| `metrics.image.tag`                | Prometheus metrics exporter image tag (immutable tags are recommended)                                 | `0.8.0-debian-10-r10`   |
| `metrics.image.pullPolicy`         | Prometheus metrics image pull policy                                                                   | `IfNotPresent`          |
| `metrics.image.pullSecrets`        | Prometheus metrics image pull secrets                                                                  | `[]`                    |
| `metrics.resources`                | Metrics exporter resource requests and limits                                                          | `{}`                    |
| `metrics.containerPort`            | Prometheus metrics exporter port                                                                       | `7777`                  |
| `metrics.flags`                    | Flags to be passed to Prometheus metrics                                                               | `[]`                    |
| `metrics.service.type`             | Kubernetes service type (`ClusterIP`, `NodePort` or `LoadBalancer`)                                    | `ClusterIP`             |
| `metrics.service.port`             | Prometheus metrics service port                                                                        | `7777`                  |
| `metrics.service.loadBalancerIP`   | Use serviceLoadBalancerIP to request a specific static IP, otherwise leave blank                       | `""`                    |
| `metrics.service.annotations`      | Annotations for Prometheus metrics service                                                             | `{}`                    |
| `metrics.service.labels`           | Labels for Prometheus metrics service                                                                  | `{}`                    |
| `metrics.serviceMonitor.enabled`   | if `true`, creates a Prometheus Operator ServiceMonitor (also requires `metrics.enabled` to be `true`) | `false`                 |
| `metrics.serviceMonitor.namespace` | Specify a namespace if needed. Fallback to the Prometheus default unless specified                     | `""`                    |
| `metrics.serviceMonitor.interval`  | Interval at which metrics should be scraped.                                                           | `""`                    |
| `metrics.serviceMonitor.selector`  | Prometheus instance selector labels                                                                    | `{}`                    |


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
    bitnami/nats
```

The above command enables NATS client authentication with `my-user` as user and `T0pS3cr3t` as password credentials.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install my-release -f values.yaml bitnami/nats
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Adding extra environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `extraEnvVars` property.

```yaml
extraEnvVars:
  - name: LOG_LEVEL
    value: DEBUG
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values.

### Sidecars and Init Containers

If you have a need for additional containers to run within the same pod as the NATS app (e.g. an additional metrics or logging exporter), you can do so via the `sidecars` config parameter. Simply define your container according to the Kubernetes container spec.

```yaml
sidecars:
  - name: your-image-name
    image: your-image
    imagePullPolicy: Always
    ports:
      - name: portname
       containerPort: 1234
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

### Deploying extra resources

There are cases where you may want to deploy extra objects, such a ConfigMap containing your app's configuration or some extra deployment with a micro service used by your app. For covering this case, the chart allows adding the full specification of other objects using the `extraDeploy` parameter.

### Setting Pod's affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami’s Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

## Deploy chart with NATS version 1.x.x

NATS version 2.0.0 has renamed the server binary filename from `gnatsd` to `nats-server`. Therefore, the default values has been changed in the chart,
however, it is still possible to use the chart to deploy NATS version 1.x.x using the `natsFilename` property.

```bash
helm install nats-v1 --set natsFilename=gnatsd --set image.tag=1.4.1 bitnami/nats
```

### To 6.0.0

- Some parameters were renamed or disappeared in favor of new ones on this major version. For instance:
  - `securityContext.*` is deprecated in favor of `podSecurityContext` and `containerSecurityContext`.
- Ingress configuration was adapted to follow the Helm charts best practices.
- Chart labels were also adapted to follow the [Helm charts standard labels](https://helm.sh/docs/chart_best_practices/labels/#standard-labels).
- This version also introduces `bitnami/common`, a [library chart](https://helm.sh/docs/topics/library_charts/#helm) as a dependency. More documentation about this new utility could be found [here](https://github.com/bitnami/charts/tree/master/bitnami/common#bitnami-common-library-chart). Please, make sure that you have updated the chart dependencies before executing any upgrade.

Consequences:

- Backwards compatibility is not guaranteed.

### To 5.0.0

[On November 13, 2020, Helm v2 support was formally finished](https://github.com/helm/charts#status-of-the-project), this major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

**What changes were introduced in this major version?**

- Previous versions of this Helm Chart use `apiVersion: v1` (installable by both Helm 2 and 3), this Helm Chart was updated to `apiVersion: v2` (installable by Helm 3 only). [Here](https://helm.sh/docs/topics/charts/#the-apiversion-field) you can find more information about the `apiVersion` field.
- The different fields present in the *Chart.yaml* file has been ordered alphabetically in a homogeneous way for all the Bitnami Helm Charts

**Considerations when upgrading to this version**

- If you want to upgrade to this version from a previous one installed with Helm v3, you shouldn't face any issues
- If you want to upgrade to this version using Helm v2, this scenario is not supported as this version doesn't support Helm v2 anymore
- If you installed the previous version with Helm v2 and wants to upgrade to this version with Helm v3, please refer to the [official Helm documentation](https://helm.sh/docs/topics/v2_v3_migration/#migration-use-cases) about migrating from Helm v2 to v3

**Useful links**

- https://docs.bitnami.com/tutorials/resolve-helm2-helm3-post-migration-issues/
- https://helm.sh/docs/topics/v2_v3_migration/
- https://helm.sh/blog/migrate-from-helm-v2-to-helm-v3/

### To 1.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 1.0.0. The following example assumes that the release name is nats:

```console
$ kubectl delete statefulset nats-nats --cascade=false
```
