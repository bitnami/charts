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

The following tables lists the configurable parameters of the kiam chart and their default values per section/component:

### Global parameters

| Parameter                 | Description                                     | Default                                                 |
|---------------------------|-------------------------------------------------|---------------------------------------------------------|
| `global.imageRegistry`    | Global Docker image registry                    | `nil`                                                   |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]` (does not add image pull secrets to deployed pods) |
| `global.storageClass`     | Global storage class for dynamic provisioning   | `nil`                                                   |

### Common parameters

| Parameter           | Description                                       | Default                        |
|---------------------|---------------------------------------------------|--------------------------------|
| `nameOverride`      | String to partially override kiam.fullname        | `nil`                          |
| `fullnameOverride`  | String to fully override kiam.fullname            | `nil`                          |
| `commonLabels`      | Labels to add to all deployed objects             | `{}`                           |
| `commonAnnotations` | Annotations to add to all deployed objects        | `{}`                           |
| `extraDeploy`       | Array of extra objects to deploy with the release | `[]` (evaluated as a template) |

### kiam image parameters

| Parameter           | Description                                      | Default                                                 |
|---------------------|--------------------------------------------------|---------------------------------------------------------|
| `image.registry`    | kiam image registry                              | `docker.io`                                             |
| `image.repository`  | kiam image name                                  | `bitnami/kiam`                                          |
| `image.tag`         | kiam image tag                                   | `{TAG_NAME}`                                            |
| `image.pullPolicy`  | kiam image pull policy                           | `IfNotPresent`                                          |
| `image.pullSecrets` | Specify docker-registry secret names as an array | `[]` (does not add image pull secrets to deployed pods) |

### kiam server parameters

| Parameter                                   | Description                                                                                 | Default                                  |
|---------------------------------------------|---------------------------------------------------------------------------------------------|------------------------------------------|
| `server.enabled`                            | Deploy the kiam server                                                                      | `true`                                   |
| `server.containerPort`                      | HTTPS port to expose at container level                                                     | `8443`                                   |
| `server.resourceType`                       | Specify how to deploy the server (allowed values: `daemonset` and `deployment`)             | `daemonset`                              |
| `server.replicaCount`                       | Number of replicas to deploy (when `server.resourceType` is `daemonset`)                    | `1`                                      |
| `server.logJsonOutput`                      | Use JSON format for logs                                                                    | `true`                                   |
| `server.extraArgs`                          | Extra arguments to add to the default kiam command                                          | `[]`                                     |
| `server.command`                            | Override kiam default command                                                               | `[]`                                     |
| `server.args`                               | Override kiam default args                                                                  | `[]`                                     |
| `server.logLevel`                           | Logging level                                                                               | `info`                                   |
| `server.sslCertHostPath`                    | Path to the host system SSL certificates (necessary for contacting the AWS metadata server) | `/etc/ssl/certs`                         |
| `server.tlsFiles.ca`                        | Base64-encoded CA to use with the container                                                 | `nil`                                    |
| `server.tlsFiles.cert`                      | Base64-encoded certificate to use with the container                                        | `nil`                                    |
| `server.tlsFiles.key`                       | Base64-encoded key to use with the container                                                | `nil`                                    |
| `server.tlsCerts.certFileName`              | Name of the certificate filename                                                            | `cert.pem`                               |
| `server.hostAliases`                        | Add deployment host aliases                                                                 | `[]`                                     |
| `server.tlsCerts.keyFileName`               | Name of the certificate filename                                                            | `key.pem`                                |
| `server.tlsCerts.caFileName`                | Name of the certificate filename                                                            | `ca.pem`                                 |
| `server.gatewayTimeoutCreation`             | Timeout when creating the kiam gateway                                                      | `1s`                                     |
| `server.podSecurityPolicy.create`           | Create a PodSecurityPolicy resources                                                        | `true`                                   |
| `server.podSecurityPolicy.allowedHostPaths` | Extra host paths to allow in the PodSecurityPolicy                                          | `[]`                                     |
| `server.tlsSecret`                          | Name of a secret with TLS certificates for the container                                    | `nil`                                    |
| `server.dnsPolicy`                          | Pod DNS policy                                                                              | `Default`                                |
| `server.extraEnvVars`                       | Array containing extra env vars to configure kiam server                                    | `nil`                                    |
| `server.extraEnvVarsCM`                     | ConfigMap containing extra env vars to configure kiam server                                | `nil`                                    |
| `server.extraEnvVarsSecret`                 | Secret containing extra env vars to configure kiam server (in case of sensitive data)       | `nil`                                    |
| `server.roleBaseArn`                        | Base ARN for IAM roles. If not set kiam will detect it automatically                        | `null`                                   |
| `server.cacheSyncInterval`                  | Cache synchronization interval                                                              | `1m`                                     |
| `server.containerSecurityContext`           | Container security podSecurityContext                                                       | `{ runAsUser: 1001, runAsNonRoot: true}` |
| `server.podSecurityContext`                 | Pod security context                                                                        | `{}`                                     |
| `server.assumeRoleArn`                      | IAM role for the server to assume                                                           | `nil`                                    |
| `server.sessionDuration`                    | Session duration for STS tokens                                                             | `15m`                                    |
| `server.useHostNetwork`                     | Use host networking (ports will be directly exposed in the host)                            | `false`                                  |
| `server.resources.limits`                   | The resources limits for the kiam container                                                 | `{}`                                     |
| `server.resources.requests`                 | The requested resources for the kiam container                                              | `{}`                                     |
| `server.lifecycleHooks`                     | LifecycleHooks to set additional configuration at startup.                                  | `{}` (evaluated as a template)           |
| `server.livenessProbe`                      | Liveness probe configuration for kiam                                                       | Check `values.yaml` file                 |
| `server.readinessProbe`                     | Readiness probe configuration for kiam                                                      | Check `values.yaml` file                 |
| `server.customLivenessProbe`                | Override default liveness probe                                                             | `nil`                                    |
| `server.customReadinessProbe`               | Override default readiness probe                                                            | `nil`                                    |
| `server.updateStrategy`                     | Strategy to use to update Pods                                                              | Check `values.yaml` file                 |
| `server.podAffinityPreset`                  | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`         | `""`                                     |
| `server.podAntiAffinityPreset`              | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`    | `soft`                                   |
| `server.nodeAffinityPreset.type`            | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`   | `""`                                     |
| `server.nodeAffinityPreset.key`             | Node label key to match. Ignored if `affinity` is set.                                      | `""`                                     |
| `server.nodeAffinityPreset.values`          | Node label values to match. Ignored if `affinity` is set.                                   | `[]`                                     |
| `server.affinity`                           | Affinity for pod assignment                                                                 | `{}` (evaluated as a template)           |
| `server.nodeSelector`                       | Node labels for pod assignment                                                              | `{}` (evaluated as a template)           |
| `server.tolerations`                        | Tolerations for pod assignment                                                              | `[]` (evaluated as a template)           |
| `server.podLabels`                          | Extra labels for kiam pods                                                                  | `{}`                                     |
| `server.podAnnotations`                     | Annotations for kiam pods                                                                   | `{}`                                     |
| `server.priorityClassName`                  | Server priorityClassName                                                                    | `nil`                                    |
| `server.lifecycleHooks`                     | LifecycleHooks to set additional configuration at startup.                                  | `{}` (evaluated as a template)           |
| `server.extraVolumeMounts`                  | Optionally specify extra list of additional volumeMounts for kiam container(s)              | `[]`                                     |
| `server.extraVolumes`                       | Optionally specify extra list of additional volumes for kiam pods                           | `[]`                                     |
| `server.initContainers`                     | Add additional init containers to the kiam pods                                             | `{}` (evaluated as a template)           |
| `server.sidecars`                           | Add additional sidecar containers to the kiam pods                                          | `{}` (evaluated as a template)           |

### kiam agent parameters

| Parameter                                   | Description                                                                                | Default                                  |
|---------------------------------------------|--------------------------------------------------------------------------------------------|------------------------------------------|
| `agent.enabled`                             | Deploy the kiam agent                                                                      | `true`                                   |
| `agent.containerPort`                       | HTTPS port to expose at container level                                                    | `8443`                                   |
| `agent.allowRouteRegExp`                    | Regexp with the allowed paths for agents to redirect                                       | `nil`                                    |
| `agent.iptables`                            | Have the agent modify the host iptables rules                                              | `false`                                  |
| `agent.iptablesRemoveOnShutdown`            | Remove iptables rules when shutting down the agent node                                    | `false`                                  |
| `agent.hostInterface`                       | Interface for agents for redirecting requests                                              | `cali+`                                  |
| `agent.logJsonOutput`                       | Use JSON format for logs                                                                   | `true`                                   |
| `agent.keepaliveParams.time`                | Keepalive time                                                                             | `nil`                                    |
| `agent.keepaliveParams.timeout`             | Keepalive timeout                                                                          | `nil`                                    |
| `agent.keepaliveParams.permitWithoutStream` | Permit keepalive without stream                                                            | `nil`                                    |
| `agent.enableDeepProbe`                     | Use the probes using the `/health` endpoint                                                | `false`                                  |
| `agent.extraArgs`                           | Extra arguments to add to the default kiam command                                         | `[]`                                     |
| `agent.command`                             | Override kiam default command                                                              | `[]`                                     |
| `agent.args`                                | Override kiam default args                                                                 | `[]`                                     |
| `agent.hostAliases`                         | Add deployment host aliases                                                                | `[]`                                     |
| `agent.logLevel`                            | Logging level                                                                              | `info`                                   |
| `agent.sslCertHostPath`                     | Path to the host system SSL certificates (necessary for contacting the AWS metadata agent) | `/etc/ssl/certs`                         |
| `agent.tlsFiles.ca`                         | Base64-encoded CA to use with the container                                                | `nil`                                    |
| `agent.tlsFiles.cert`                       | Base64-encoded certificate to use with the container                                       | `nil`                                    |
| `agent.tlsFiles.key`                        | Base64-encoded key to use with the container                                               | `nil`                                    |
| `agent.tlsCerts.certFileName`               | Name of the certificate filename                                                           | `cert.pem`                               |
| `agent.tlsCerts.keyFileName`                | Name of the certificate filename                                                           | `key.pem`                                |
| `agent.tlsCerts.caFileName`                 | Name of the certificate filename                                                           | `ca.pem`                                 |
| `agent.gatewayTimeoutCreation`              | Timeout when creating the kiam gateway                                                     | `1s`                                     |
| `agent.podSecurityPolicy.create`            | Create a PodSecurityPolicy resources                                                       | `false`                                  |
| `agent.podSecurityPolicy.allowedHostPaths`  | Extra host paths to allow in the PodSecurityPolicy                                         | `[]`                                     |
| `agent.tlsSecret`                           | Name of a secret with TLS certificates for the container                                   | `nil`                                    |
| `agent.dnsPolicy`                           | Pod DNS policy                                                                             | `ClusterFirstWithHostNet`                |
| `agent.extraEnvVars`                        | Array containing extra env vars to configure kiam agent                                    | `nil`                                    |
| `agent.extraEnvVarsCM`                      | ConfigMap containing extra env vars to configure kiam agent                                | `nil`                                    |
| `agent.extraEnvVarsSecret`                  | Secret containing extra env vars to configure kiam agent (in case of sensitive data)       | `nil`                                    |
| `agent.containerSecurityContext`            | Container security podSecurityContext                                                      | `{ runAsUser: 1001, runAsNonRoot: true}` |
| `agent.podSecurityContext`                  | Pod security context                                                                       | `{}`                                     |
| `agent.useHostNetwork`                      | Use host networking (ports will be directly exposed in the host)                           | `true`                                   |
| `agent.resources.limits`                    | The resources limits for the kiam container                                                | `{}`                                     |
| `agent.resources.requests`                  | The requested resources for the kiam container                                             | `{}`                                     |
| `agent.lifecycleHooks`                      | LifecycleHooks to set additional configuration at startup.                                 | `{}` (evaluated as a template)           |
| `agent.livenessProbe`                       | Liveness probe configuration for kiam                                                      | Check `values.yaml` file                 |
| `agent.readinessProbe`                      | Readiness probe configuration for kiam                                                     | Check `values.yaml` file                 |
| `agent.customLivenessProbe`                 | Override default liveness probe                                                            | `nil`                                    |
| `agent.customReadinessProbe`                | Override default readiness probe                                                           | `nil`                                    |
| `agent.updateStrategy`                      | Strategy to use to update Pods                                                             | Check `values.yaml` file                 |
| `agent.podAffinityPreset`                   | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`        | `""`                                     |
| `agent.podAntiAffinityPreset`               | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`   | `soft`                                   |
| `agent.nodeAffinityPreset.type`             | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`  | `""`                                     |
| `agent.nodeAffinityPreset.key`              | Node label key to match. Ignored if `affinity` is set.                                     | `""`                                     |
| `agent.nodeAffinityPreset.values`           | Node label values to match. Ignored if `affinity` is set.                                  | `[]`                                     |
| `agent.affinity`                            | Affinity for pod assignment                                                                | `{}` (evaluated as a template)           |
| `agent.nodeSelector`                        | Node labels for pod assignment                                                             | `{}` (evaluated as a template)           |
| `agent.tolerations`                         | Tolerations for pod assignment                                                             | `[]` (evaluated as a template)           |
| `agent.podLabels`                           | Extra labels for kiam pods                                                                 | `{}`                                     |
| `agent.podAnnotations`                      | Annotations for kiam pods                                                                  | `{}`                                     |
| `agent.priorityClassName`                   | Server priorityClassName                                                                   | `nil`                                    |
| `agent.lifecycleHooks`                      | LifecycleHooks to set additional configuration at startup.                                 | `{}` (evaluated as a template)           |
| `agent.extraVolumeMounts`                   | Optionally specify extra list of additional volumeMounts for kiam container(s)             | `[]`                                     |
| `agent.extraVolumes`                        | Optionally specify extra list of additional volumes for kiam pods                          | `[]`                                     |
| `agent.initContainers`                      | Add additional init containers to the kiam pods                                            | `{}` (evaluated as a template)           |
| `agent.sidecars`                            | Add additional sidecar containers to the kiam pods                                         | `{}` (evaluated as a template)           |

### Exposure parameters

| Parameter                                 | Description                                           | Default                        |
|-------------------------------------------|-------------------------------------------------------|--------------------------------|
| `server.service.type`                     | Kubernetes service type                               | `ClusterIP`                    |
| `server.service.port`                     | Service HTTPS port                                    | `8443`                         |
| `server.service.nodePorts.http`           | Service HTTPS NodePort                                | `nil`                          |
| `server.service.nodePorts.metrics`        | Service metrics NodePort                              | `nil`                          |
| `server.service.clusterIP`                | kiam service clusterIP IP                             | `None`                         |
| `server.service.externalTrafficPolicy`    | Enable client source IP preservation                  | `Cluster`                      |
| `server.service.loadBalancerIP`           | loadBalancerIP if service type is `LoadBalancer`      | `nil`                          |
| `server.service.loadBalancerSourceRanges` | Address that are allowed when service is LoadBalancer | `[]`                           |
| `server.service.annotations`              | Annotations for kiam service                          | `{}` (evaluated as a template) |
| `agent.service.type`                      | Kubernetes service type                               | `ClusterIP`                    |
| `agent.service.nodePorts.metrics`         | Service metrics NodePort                              | `nil`                          |
| `agent.service.clusterIP`                 | kiam service clusterIP IP                             | `None`                         |
| `agent.service.externalTrafficPolicy`     | Enable client source IP preservation                  | `Cluster`                      |
| `agent.service.loadBalancerIP`            | loadBalancerIP if service type is `LoadBalancer`      | `nil`                          |
| `agent.service.loadBalancerSourceRanges`  | Address that are allowed when service is LoadBalancer | `[]`                           |
| `agent.service.annotations`               | Annotations for kiam service                          | `{}` (evaluated as a template) |

### RBAC parameters

| Parameter                      | Description                                           | Default                                      |
|--------------------------------|-------------------------------------------------------|----------------------------------------------|
| `server.serviceAccount.name`   | Name of the created ServiceAccount                    | Generated using the `kiam.fullname` template |
| `server.serviceAccount.create` | Enable the creation of a ServiceAccount for kiam pods | `true`                                       |
| `agent.serviceAccount.name`    | Name of the created ServiceAccount                    | Generated using the `kiam.fullname` template |
| `agent.serviceAccount.create`  | Enable the creation of a ServiceAccount for kiam pods | `true`                                       |
| `rbac.create`                  | Weather to create & use RBAC resources or not         | `false`                                      |

### Metrics parameters

| Parameter                                         | Description                                                                  | Default                                                      |
|---------------------------------------------------|------------------------------------------------------------------------------|--------------------------------------------------------------|
| `agent.metrics.enabled`                           | Enable exposing kiam statistics                                              | `false`                                                      |
| `agent.metrics.port`                              | Service HTTP management port                                                 | `9990`                                                       |
| `agent.metrics.syncInterval`                      | Metrics synchronization interval statistics                                  | `5s`                                                         |
| `agent.metrics.annotations`                       | Annotations for enabling prometheus to access the metrics endpoints          | `{prometheus.io/scrape: "true", prometheus.io/port: "9990"}` |
| `agent.metrics.serviceMonitor.enabled`            | Create ServiceMonitor Resource for scraping metrics using PrometheusOperator | `false`                                                      |
| `agent.metrics.serviceMonitor.namespace`          | Namespace which Prometheus is running in                                     | `nil`                                                        |
| `agent.metrics.serviceMonitor.interval`           | Interval at which metrics should be scraped                                  | `30s`                                                        |
| `agent.metrics.serviceMonitor.scrapeTimeout`      | Specify the timeout after which the scrape is ended                          | `nil`                                                        |
| `agent.metrics.serviceMonitor.relabelings`        | Specify Relabelings to add to the scrape endpoint                            | `nil`                                                        |
| `agent.metrics.serviceMonitor.metricRelabelings`  | Specify Metric Relabelings to add to the scrape endpoint                     | `nil`                                                        |
| `agent.metrics.serviceMonitor.selector`           | metrics service selector                                                     | `nil`                                                        |
| `server.metrics.enabled`                          | Enable exposing kiam statistics                                              | `false`                                                      |
| `server.metrics.syncInterval`                     | Metrics synchronization interval statistics                                  | `5s`                                                         |
| `server.metrics.port`                             | Metrics port                                                                 | `9621`                                                       |
| `server.metrics.annotations`                      | Annotations for enabling prometheus to access the metrics endpoints          | `{prometheus.io/scrape: "true", prometheus.io/port: "9990"}` |
| `server.metrics.serviceMonitor.enabled`           | Create ServiceMonitor Resource for scraping metrics using PrometheusOperator | `false`                                                      |
| `server.metrics.serviceMonitor.namespace`         | Namespace which Prometheus is running in                                     | `nil`                                                        |
| `server.metrics.serviceMonitor.interval`          | Interval at which metrics should be scraped                                  | `30s`                                                        |
| `server.metrics.serviceMonitor.selector`          | metrics service selector                                                     | `nil`                                                        |
| `server.metrics.serviceMonitor.scrapeTimeout`     | Specify the timeout after which the scrape is ended                          | `nil`                                                        |
| `server.metrics.serviceMonitor.relabelings`       | Specify Relabelings to add to the scrape endpoint                            | `nil`                                                        |
| `server.metrics.serviceMonitor.metricRelabelings` | Specify Metric Relabellings to add to the scrape endpoint                    | `nil`                                                        |

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

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Adding extra environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `server.extraEnvVars` and `agent.extraEnvVars` property.

```yaml
server:
  extraEnvVars:
    - name: LOG_LEVEL
      value: error
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `server.extraEnvVarsCM`, `agent.extraEnvVarsCM` or the `server.extraEnvVarsSecret` and `agent.extraEnvVarsSecret` values.

### Sidecars and Init Containers

If you have a need for additional containers to run within the same pod as the kiam app (e.g. an additional metrics or logging exporter), you can do so via the `server.sidecars` and `agent.sidecars` config parameters. Simply define your container according to the Kubernetes container spec.

```yaml
server:
  sidecars:
    - name: your-image-name
      image: your-image
      imagePullPolicy: Always
      ports:
        - name: portname
        containerPort: 1234
```

Similarly, you can add extra init containers using the `server.initContainers` and `agent.initContainers` parameters.

```yaml
server:
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

This chart allows you to set your custom affinity using the `server.affinity` and `agent.affinity` parameters. Find more information about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `server.podAffinityPreset`, `agent.podAffinityPreset`, `server.podAntiAffinityPreset`, `agent.podAntiAffinityPreset`, or `server.nodeAffinityPreset` and `agent.nodeAffinityPreset` parameters.

### TLS Secrets

This chart will facilitate the creation of TLS secrets for use with kiam. There are three common use cases:

- Helm auto-generates the certificates.
- User specifies the certificates in the values.
- User generates/manages certificates separately.

By default the first use case will be applied. In second case, it's needed a certificate and a key. We would expect them to look like this:

- The certificate files should look like (there can be more than one certificate if there is a certificate chain)

    ```console
    -----BEGIN CERTIFICATE-----
    MIID6TCCAtGgAwIBAgIJAIaCwivkeB5EMA0GCSqGSIb3DQEBCwUAMFYxCzAJBgNV
    ...
    jScrvkiBO65F46KioCL9h5tDvomdU1aqpI/CBzhvZn1c0ZTf87tGQR8NK7v7
    -----END CERTIFICATE-----
    ```

- The keys should look like this:

    ```console
    -----BEGIN RSA PRIVATE KEY-----
    MIIEogIBAAKCAQEAvLYcyu8f3skuRyUgeeNpeDvYBCDcgq+LsWap6zbX5f8oLqp4
    ...
    wrj2wDbCDCFmfqnSJ+dKI3vFLlEz44sAV8jX/kd4Y6ZTQhlLbYc=
    -----END RSA PRIVATE KEY-----
    ```

If you are going to use the values file to manage the certificates, please copy these values into the `server.tlsFiles.cert`, `server.tlsFiles.ca` and `server.tlsFiles.key` or `agent.tlsFiles.cert`, `agent.tlsFiles.ca` and `agent.tlsFiles.key`.

If you are going to manage TLS secrets outside of Helm, please know that you can create a TLS secret (named `kiam.local-tls` for example) and set it using the `server.tlsSecret` or `agent.tlsSecret` values.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami’s Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).
