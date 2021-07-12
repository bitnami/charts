# kiam

[kiam](https://github.com/uswitch/kiam) is a Kubernetes agent that allows to associate IAM roles to pods.

## TL;DR

```console
  helm repo add bitnami https://charts.bitnami.com/bitnami
  helm install my-release bitnami/kiam
```

> NOTE: KIAM has been designed to work on a Kubernetes cluster deployed on top of AWS, although it is possible to deploy it in other environments.

## Introduction

Bitnami charts for Helm are carefully engineered, actively maintained and are the quickest and easiest way to deploy containers on a Kubernetes cluster that are ready to handle production workloads.

This chart bootstraps a [kiam](https://github.com/bitnami/bitnami-docker-kiam) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This Helm chart has been tested on top of [Bitnami Kubernetes Production Runtime](https://kubeprod.io/) (BKPR). Deploy BKPR to get automated TLS certificates, logging and monitoring for your applications.

## Prerequisites

- Kubernetes 1.12+ in AWS
- Helm 3.1.0

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/kiam
```

These commands deploy a kiam application on the Kubernetes cluster in the default configuration.

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

| Name                | Description                                       | Value |
| ------------------- | ------------------------------------------------- | ----- |
| `nameOverride`      | Release name override                             | `nil` |
| `fullnameOverride`  | Release full name override                        | `nil` |
| `commonLabels`      | Labels to add to all deployed objects             | `{}`  |
| `commonAnnotations` | Annotations to add to all deployed objects        | `{}`  |
| `extraDeploy`       | Array of extra objects to deploy with the release | `[]`  |


### kiam image parameters

| Name                | Description                                      | Value                  |
| ------------------- | ------------------------------------------------ | ---------------------- |
| `image.registry`    | kiam image registry                              | `docker.io`            |
| `image.repository`  | kiam image name                                  | `bitnami/kiam`         |
| `image.tag`         | kiam image tag                                   | `3.6.0-debian-10-r228` |
| `image.pullPolicy`  | kiam image pull policy                           | `IfNotPresent`         |
| `image.pullSecrets` | Specify docker-registry secret names as an array | `[]`                   |


### kiam server parameters

| Name                                             | Description                                                                                     | Value            |
| ------------------------------------------------ | ----------------------------------------------------------------------------------------------- | ---------------- |
| `server.enabled`                                 | Deploy the kiam server                                                                          | `true`           |
| `server.containerPort`                           | HTTPS port to expose at container level                                                         | `8443`           |
| `server.resourceType`                            | Specify how to deploy the server (allowed values: `daemonset` and `deployment`)                 | `daemonset`      |
| `server.hostAliases`                             | Add deployment host aliases                                                                     | `[]`             |
| `server.useHostNetwork`                          | Use host networking (ports will be directly exposed in the host)                                | `false`          |
| `server.replicaCount`                            | Number of replicas to deploy (when `server.resourceType` is `daemonset`)                        | `1`              |
| `server.logJsonOutput`                           | Use JSON format for logs                                                                        | `true`           |
| `server.logLevel`                                | Logging level                                                                                   | `info`           |
| `server.sslCertHostPath`                         | Path to the host system SSL certificates (necessary for contacting the AWS metadata server)     | `/etc/ssl/certs` |
| `server.podSecurityPolicy.create`                |                                                                                                 | `true`           |
| `server.podSecurityPolicy.allowedHostPaths`      |                                                                                                 | `[]`             |
| `server.priorityClassName`                       | Server priorityClassName                                                                        | `""`             |
| `server.livenessProbe.enabled`                   | Enable livenessProbe                                                                            | `true`           |
| `server.livenessProbe.initialDelaySeconds`       | Initial delay seconds for livenessProbe                                                         | `5`              |
| `server.livenessProbe.periodSeconds`             | Period seconds for livenessProbe                                                                | `30`             |
| `server.livenessProbe.timeoutSeconds`            | Timeout seconds for livenessProbe                                                               | `5`              |
| `server.livenessProbe.failureThreshold`          | Failure threshold for livenessProbe                                                             | `5`              |
| `server.livenessProbe.successThreshold`          | Success threshold for livenessProbe                                                             | `1`              |
| `server.readinessProbe.enabled`                  | Enable readinessProbe                                                                           | `true`           |
| `server.readinessProbe.initialDelaySeconds`      | Initial delay seconds for readinessProbe                                                        | `5`              |
| `server.readinessProbe.periodSeconds`            | Period seconds for readinessProbe                                                               | `30`             |
| `server.readinessProbe.timeoutSeconds`           | Timeout seconds for readinessProbe                                                              | `5`              |
| `server.readinessProbe.failureThreshold`         | Failure threshold for readinessProbe                                                            | `5`              |
| `server.readinessProbe.successThreshold`         | Success threshold for readinessProbe                                                            | `1`              |
| `server.extraArgs`                               | Extra arguments to add to the default kiam command                                              | `{}`             |
| `server.command`                                 | Override kiam default command                                                                   | `[]`             |
| `server.args`                                    | Override kiam default args                                                                      | `[]`             |
| `server.tlsFiles`                                | Base64-encoded PEM values for server's CA certificate(s), certificate and private key           | `{}`             |
| `server.gatewayTimeoutCreation`                  | Timeout when creating the kiam gateway                                                          | `1s`             |
| `server.tlsSecret`                               | Name of a secret with TLS certificates for the container                                        | `nil`            |
| `server.dnsPolicy`                               | Pod DNS policy                                                                                  | `Default`        |
| `server.roleBaseArn`                             | Base ARN for IAM roles. If not set kiam will detect it automatically                            | `nil`            |
| `server.cacheSyncInterval`                       | Cache synchronization interval                                                                  | `1m`             |
| `server.assumeRoleArn`                           | IAM role for the server to assume                                                               | `nil`            |
| `server.sessionDuration`                         | Session duration for STS tokens                                                                 | `15m`            |
| `server.tlsCerts`                                | Agent TLS Certificate filenames                                                                 | `{}`             |
| `server.resources.limits`                        | The resources limits for the kiam container                                                     | `{}`             |
| `server.resources.requests`                      | The requested resources for the kiam container                                                  | `{}`             |
| `server.containerSecurityContext.enabled`        | Enabled kiam server containers' Security Context                                                | `true`           |
| `server.containerSecurityContext.runAsUser`      | Set kiam server container's Security Context runAsUser                                          | `1001`           |
| `server.containerSecurityContext.runAsNonRoot`   | Set kiam server container's Security Context runAsNonRoot                                       | `true`           |
| `server.containerSecurityContext.seLinuxOptions` | Set kiam server container's Security Context SE Linux options                                   | `nil`            |
| `server.podSecurityContext.enabled`              | Enabled kiam server pods' Security Context                                                      | `true`           |
| `server.podSecurityContext.fsGroup`              | Set kiam server pod's Security Context fsGroup                                                  | `1001`           |
| `server.podAffinityPreset`                       | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`             | `""`             |
| `server.podAntiAffinityPreset`                   | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`        | `soft`           |
| `server.nodeAffinityPreset.type`                 | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`       | `""`             |
| `server.nodeAffinityPreset.key`                  | Node label key to match. Ignored if `affinity` is set.                                          | `""`             |
| `server.nodeAffinityPreset.values`               | Node label values to match. Ignored if `affinity` is set.                                       | `[]`             |
| `server.affinity`                                | Affinity for pod assignment                                                                     | `{}`             |
| `server.nodeSelector`                            | Node labels for pod assignment                                                                  | `{}`             |
| `server.tolerations`                             | Tolerations for pod assignment                                                                  | `[]`             |
| `server.podLabels`                               | Extra labels for kiam pods                                                                      | `{}`             |
| `server.podAnnotations`                          | Annotations for kiam pods                                                                       | `{}`             |
| `server.lifecycleHooks`                          | lifecycleHooks for the kiam server container to automate configuration before or after startup. | `{}`             |
| `server.customLivenessProbe`                     | Override default liveness probe                                                                 | `{}`             |
| `server.customReadinessProbe`                    | Override default readiness probe                                                                | `{}`             |
| `server.updateStrategy.type`                     | Update strategy - only really applicable for deployments with RWO PVs attached                  | `RollingUpdate`  |
| `server.extraEnvVars`                            | Array containing extra env vars to configure kiam server                                        | `[]`             |
| `server.extraEnvVarsCM`                          | ConfigMap containing extra env vars to configure kiam server                                    | `nil`            |
| `server.extraEnvVarsSecret`                      | Secret containing extra env vars to configure kiam server (in case of sensitive data)           | `nil`            |
| `server.extraVolumes`                            | Optionally specify extra list of additional volumes for kiam pods                               | `[]`             |
| `server.extraVolumeMounts`                       | Optionally specify extra list of additional volumeMounts for kiam container(s)                  | `[]`             |
| `server.initContainers`                          | Add additional init containers to the kiam pods                                                 | `[]`             |
| `server.sidecars`                                | Add additional sidecar containers to the kiam pods                                              | `[]`             |


### kiam server exposure parameters

| Name                                      | Description                                                                  | Value       |
| ----------------------------------------- | ---------------------------------------------------------------------------- | ----------- |
| `server.service.type`                     | Kubernetes service type                                                      | `ClusterIP` |
| `server.service.port`                     | Service HTTPS port                                                           | `8443`      |
| `server.service.nodePorts`                | Specify the nodePort values for the LoadBalancer and NodePort service types. | `{}`        |
| `server.service.clusterIP`                | kiam service clusterIP IP                                                    | `None`      |
| `server.service.loadBalancerIP`           | loadBalancerIP if service type is `LoadBalancer`                             | `nil`       |
| `server.service.loadBalancerSourceRanges` | Address that are allowed when service is LoadBalancer                        | `[]`        |
| `server.service.externalTrafficPolicy`    | Enable client source IP preservation                                         | `Cluster`   |
| `server.service.annotations`              | Annotations for kiam service                                                 | `{}`        |


### kiam server Service Account parameters

| Name                           | Description                                           | Value  |
| ------------------------------ | ----------------------------------------------------- | ------ |
| `server.serviceAccount.create` | Enable the creation of a ServiceAccount for kiam pods | `true` |
| `server.serviceAccount.name`   | Name of the created ServiceAccount                    | `nil`  |


### kiam server metrics parameters

| Name                                              | Description                                                                  | Value   |
| ------------------------------------------------- | ---------------------------------------------------------------------------- | ------- |
| `server.metrics.enabled`                          | Enable exposing kiam statistics                                              | `false` |
| `server.metrics.port`                             | Metrics port                                                                 | `9621`  |
| `server.metrics.syncInterval`                     | Metrics synchronization interval statistics                                  | `5s`    |
| `server.metrics.annotations`                      | Annotations for enabling prometheus to access the metrics endpoints          | `{}`    |
| `server.metrics.serviceMonitor.enabled`           | Create ServiceMonitor Resource for scraping metrics using PrometheusOperator | `false` |
| `server.metrics.serviceMonitor.namespace`         | Namespace in which Prometheus is running                                     | `nil`   |
| `server.metrics.serviceMonitor.interval`          | Interval at which metrics should be scraped                                  | `30s`   |
| `server.metrics.serviceMonitor.metricRelabelings` | Specify Metric Relabellings to add to the scrape endpoint                    | `[]`    |
| `server.metrics.serviceMonitor.relabelings`       | Specify Relabelings to add to the scrape endpoint                            | `[]`    |
| `server.metrics.serviceMonitor.scrapeTimeout`     | Specify the timeout after which the scrape is ended                          | `nil`   |
| `server.metrics.serviceMonitor.selector`          | metrics service selector                                                     | `nil`   |


### kiam agent parameters

| Name                                            | Description                                                                                | Value                     |
| ----------------------------------------------- | ------------------------------------------------------------------------------------------ | ------------------------- |
| `agent.enabled`                                 | Deploy the kiam agent                                                                      | `true`                    |
| `agent.logJsonOutput`                           | Use JSON format for logs                                                                   | `true`                    |
| `agent.logLevel`                                | Logging level                                                                              | `info`                    |
| `agent.priorityClassName`                       | Server priorityClassName                                                                   | `""`                      |
| `agent.allowRouteRegExp`                        | Regexp with the allowed paths for agents to redirect                                       | `nil`                     |
| `agent.hostAliases`                             | Add deployment host aliases                                                                | `[]`                      |
| `agent.containerPort`                           | HTTPS port to expose at container level                                                    | `8183`                    |
| `agent.iptables`                                | Have the agent modify the host iptables rules                                              | `false`                   |
| `agent.iptablesRemoveOnShutdown`                | Remove iptables rules when shutting down the agent node                                    | `false`                   |
| `agent.hostInterface`                           | Interface for agents for redirecting requests                                              | `cali+`                   |
| `agent.keepaliveParams.permitWithoutStream`     | Permit keepalive without stream                                                            | `false`                   |
| `agent.keepaliveParams.time`                    | Keepalive time                                                                             | `nil`                     |
| `agent.keepaliveParams.timeout`                 | Keepalive timeout                                                                          | `nil`                     |
| `agent.enableDeepProbe`                         | Use the probes using the `/health` endpoint                                                | `false`                   |
| `agent.dnsPolicy`                               | Pod DNS policy                                                                             | `ClusterFirstWithHostNet` |
| `agent.sslCertHostPath`                         | Path to the host system SSL certificates (necessary for contacting the AWS metadata agent) | `/etc/ssl/certs`          |
| `agent.tlsFiles`                                | Base64-encoded PEM values for server's CA certificate(s), certificate and private key      | `{}`                      |
| `agent.podSecurityPolicy.create`                | Create a PodSecurityPolicy resources                                                       | `true`                    |
| `agent.podSecurityPolicy.allowedHostPaths`      | Extra host paths to allow in the PodSecurityPolicy                                         | `nil`                     |
| `agent.tlsSecret`                               | Name of a secret with TLS certificates for the container                                   | `nil`                     |
| `agent.useHostNetwork`                          | Use host networking (ports will be directly exposed in the host)                           | `true`                    |
| `agent.tlsCerts`                                | Agent TLS Certificate filenames                                                            | `{}`                      |
| `agent.livenessProbe.enabled`                   | Enable livenessProbe                                                                       | `true`                    |
| `agent.livenessProbe.initialDelaySeconds`       | Initial delay seconds for livenessProbe                                                    | `5`                       |
| `agent.livenessProbe.periodSeconds`             | Period seconds for livenessProbe                                                           | `30`                      |
| `agent.livenessProbe.timeoutSeconds`            | Timeout seconds for livenessProbe                                                          | `5`                       |
| `agent.livenessProbe.failureThreshold`          | Failure threshold for livenessProbe                                                        | `5`                       |
| `agent.livenessProbe.successThreshold`          | Success threshold for livenessProbe                                                        | `1`                       |
| `agent.readinessProbe.enabled`                  | Enable readinessProbe                                                                      | `true`                    |
| `agent.readinessProbe.initialDelaySeconds`      | Initial delay seconds for readinessProbe                                                   | `5`                       |
| `agent.readinessProbe.periodSeconds`            | Period seconds for readinessProbe                                                          | `30`                      |
| `agent.readinessProbe.timeoutSeconds`           | Timeout seconds for readinessProbe                                                         | `5`                       |
| `agent.readinessProbe.failureThreshold`         | Failure threshold for readinessProbe                                                       | `5`                       |
| `agent.readinessProbe.successThreshold`         | Success threshold for readinessProbe                                                       | `1`                       |
| `agent.extraArgs`                               | Extra arguments to add to the default kiam command                                         | `{}`                      |
| `agent.gatewayTimeoutCreation`                  | Timeout when creating the kiam gateway                                                     | `1s`                      |
| `agent.command`                                 | Override kiam default command                                                              | `[]`                      |
| `agent.args`                                    | Override kiam default args                                                                 | `[]`                      |
| `agent.resources.limits`                        | The resources limits for the kiam container                                                | `{}`                      |
| `agent.resources.requests`                      | The requested resources for the kiam container                                             | `{}`                      |
| `agent.containerSecurityContext.enabled`        | Enabled agent containers' Security Context                                                 | `true`                    |
| `agent.containerSecurityContext.runAsUser`      | Set agent container's Security Context runAsUser                                           | `1001`                    |
| `agent.containerSecurityContext.runAsNonRoot`   | Set agent container's Security Context runAsNonRoot                                        | `true`                    |
| `agent.containerSecurityContext.seLinuxOptions` | Set agent container's Security Context SE Linux options                                    | `nil`                     |
| `agent.podSecurityContext.enabled`              | Enabled agent pods' Security Context                                                       | `true`                    |
| `agent.podSecurityContext.fsGroup`              | Set agent pod's Security Context fsGroup                                                   | `1001`                    |
| `agent.podAffinityPreset`                       | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`        | `""`                      |
| `agent.podAntiAffinityPreset`                   | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`   | `soft`                    |
| `agent.nodeAffinityPreset.type`                 | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`  | `""`                      |
| `agent.nodeAffinityPreset.key`                  | Node label key to match. Ignored if `affinity` is set.                                     | `""`                      |
| `agent.nodeAffinityPreset.values`               | Node label values to match. Ignored if `affinity` is set.                                  | `[]`                      |
| `agent.affinity`                                | Affinity for pod assignment                                                                | `{}`                      |
| `agent.nodeSelector`                            | Node labels for pod assignment                                                             | `{}`                      |
| `agent.tolerations`                             | Tolerations for pod assignment                                                             | `[]`                      |
| `agent.podLabels`                               | Extra labels for kiam pods                                                                 | `{}`                      |
| `agent.podAnnotations`                          | Annotations for kiam pods                                                                  | `{}`                      |
| `agent.lifecycleHooks`                          | LifecycleHooks to set additional configuration at startup.                                 | `{}`                      |
| `agent.customLivenessProbe`                     | Override default liveness probe                                                            | `{}`                      |
| `agent.customReadinessProbe`                    | Override default readiness probe                                                           | `{}`                      |
| `agent.updateStrategy.type`                     | Update strategy - only really applicable for deployments with RWO PVs attached             | `RollingUpdate`           |
| `agent.extraEnvVars`                            | Array containing extra env vars to configure kiam agent                                    | `[]`                      |
| `agent.extraEnvVarsCM`                          | ConfigMap containing extra env vars to configure kiam agent                                | `nil`                     |
| `agent.extraEnvVarsSecret`                      | Secret containing extra env vars to configure kiam agent (in case of sensitive data)       | `nil`                     |
| `agent.extraVolumes`                            | Optionally specify extra list of additional volumes for kiam pods                          | `[]`                      |
| `agent.extraVolumeMounts`                       | Optionally specify extra list of additional volumeMounts for kiam container(s)             | `[]`                      |
| `agent.initContainers`                          | Add additional init containers to the kiam pods                                            | `[]`                      |
| `agent.sidecars`                                | Add additional sidecar containers to the kiam pods                                         | `[]`                      |


### kiam agent exposure parameters

| Name                                     | Description                                                                  | Value       |
| ---------------------------------------- | ---------------------------------------------------------------------------- | ----------- |
| `agent.service.type`                     | Kubernetes service type                                                      | `ClusterIP` |
| `agent.service.nodePorts`                | Specify the nodePort values for the LoadBalancer and NodePort service types. | `{}`        |
| `agent.service.clusterIP`                | kiam service clusterIP IP                                                    | `nil`       |
| `agent.service.loadBalancerIP`           | loadBalancerIP if service type is `LoadBalancer`                             | `nil`       |
| `agent.service.loadBalancerSourceRanges` | Address that are allowed when service is LoadBalancer                        | `[]`        |
| `agent.service.externalTrafficPolicy`    | Enable client source IP preservation                                         | `Cluster`   |
| `agent.service.annotations`              | Annotations for kiam service                                                 | `{}`        |


### kiam agent Service Account parameters

| Name                          | Description                                           | Value  |
| ----------------------------- | ----------------------------------------------------- | ------ |
| `agent.serviceAccount.create` | Enable the creation of a ServiceAccount for kiam pods | `true` |
| `agent.serviceAccount.name`   | Name of the created ServiceAccount                    | `nil`  |


### kiam agent metrics parameters

| Name                                             | Description                                                                  | Value   |
| ------------------------------------------------ | ---------------------------------------------------------------------------- | ------- |
| `agent.metrics.enabled`                          | Enable exposing kiam statistics                                              | `false` |
| `agent.metrics.port`                             | Service HTTP management port                                                 | `9620`  |
| `agent.metrics.syncInterval`                     | Metrics synchronization interval statistics                                  | `5s`    |
| `agent.metrics.annotations`                      | Annotations for enabling prometheus to access the metrics endpoints          | `{}`    |
| `agent.metrics.serviceMonitor.enabled`           | Create ServiceMonitor Resource for scraping metrics using PrometheusOperator | `false` |
| `agent.metrics.serviceMonitor.namespace`         | Namespace which Prometheus is running in                                     | `nil`   |
| `agent.metrics.serviceMonitor.interval`          | Interval at which metrics should be scraped                                  | `30s`   |
| `agent.metrics.serviceMonitor.metricRelabelings` | Specify Metric Relabelings to add to the scrape endpoint                     | `[]`    |
| `agent.metrics.serviceMonitor.relabelings`       | Specify Relabelings to add to the scrape endpoint                            | `[]`    |
| `agent.metrics.serviceMonitor.scrapeTimeout`     | Specify the timeout after which the scrape is ended                          | `nil`   |
| `agent.metrics.serviceMonitor.selector`          | metrics service selector                                                     | `nil`   |


### RBAC parameters

| Name          | Description                                     | Value  |
| ------------- | ----------------------------------------------- | ------ |
| `rbac.create` | Whether to create and use RBAC resources or not | `true` |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
helm install my-release --set server.resourceType=deployment bitnami/kiam
```

The above command sets the server nodes to be deployed as Deployment objects.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install my-release -f values.yaml bitnami/kiam
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling vs Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Add extra environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `server.extraEnvVars` and `agent.extraEnvVars` property.

```yaml
server:
  extraEnvVars:
    - name: LOG_LEVEL
      value: error
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `server.extraEnvVarsCM`, `agent.extraEnvVarsCM` or the `server.extraEnvVarsSecret` and `agent.extraEnvVarsSecret` values.

### Configure Sidecars and Init Containers

If additional containers are needed in the same pod as Kiam (such as additional metrics or logging exporters), they can be defined using the `sidecars` parameter. Similarly, you can add extra init containers using the `initContainers` parameter.

[Learn more about configuring and using sidecar and init containers](https://docs.bitnami.com/kubernetes/infrastructure/kiam/configuration/configure-sidecar-init-containers/).

### Deploy extra resources

There are cases where you may want to deploy extra objects, such a ConfigMap containing your app's configuration or some extra deployment with a micro service used by your app. For covering this case, the chart allows adding the full specification of other objects using the `extraDeploy` parameter.

### Set Pod affinity

This chart allows you to set your custom affinity using the `server.affinity` and `agent.affinity` parameters. Find more information about Pod affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `server.podAffinityPreset`, `agent.podAffinityPreset`, `server.podAntiAffinityPreset`, `agent.podAntiAffinityPreset`, or `server.nodeAffinityPreset` and `agent.nodeAffinityPreset` parameters.

### Configure TLS Secrets

This chart will facilitate the creation of TLS secrets for use with kiam. There are three common use cases:

- Helm auto-generates the certificates.
- User specifies the certificates in the values.
- User generates/manages certificates separately.

By default the first use case will be applied. In the second case, a certificate and a key are needed.

- The certificate files should look like the example below. There may be more than one certificate if there is a certificate chain.

    ```console
    -----BEGIN CERTIFICATE-----
    MIID6TCCAtGgAwIBAgIJAIaCwivkeB5EMA0GCSqGSIb3DQEBCwUAMFYxCzAJBgNV
    ...
    jScrvkiBO65F46KioCL9h5tDvomdU1aqpI/CBzhvZn1c0ZTf87tGQR8NK7v7
    -----END CERTIFICATE-----
    ```

- The certificate keys should look like this:

    ```console
    -----BEGIN RSA PRIVATE KEY-----
    MIIEogIBAAKCAQEAvLYcyu8f3skuRyUgeeNpeDvYBCDcgq+LsWap6zbX5f8oLqp4
    ...
    wrj2wDbCDCFmfqnSJ+dKI3vFLlEz44sAV8jX/kd4Y6ZTQhlLbYc=
    -----END RSA PRIVATE KEY-----
    ```

If using the values file to manage the certificates, copy the above values into the `server.tlsFiles.cert`, `server.tlsFiles.ca` and `server.tlsFiles.key` or `agent.tlsFiles.cert`, `agent.tlsFiles.ca` and `agent.tlsFiles.key` parameters respectively.

If managing TLS secrets outside of Helm, it is possible to create a TLS secret (named `kiam.local-tls`, for example) and set it using the `server.tlsSecret` or `agent.tlsSecret` parameters.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami’s Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).
