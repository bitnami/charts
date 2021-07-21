# Nginx Ingress Controller

[nginx-ingress](https://github.com/kubernetes/ingress-nginx) is an Ingress controller that uses NGINX to manage external access to HTTP services in a Kubernetes cluster.

## TL;DR

```bash
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/nginx-ingress-controller
```

## Introduction

Bitnami charts for Helm are carefully engineered, actively maintained and are the quickest and easiest way to deploy containers on a Kubernetes cluster that are ready to handle production workloads.

This chart bootstraps a [nginx-ingress](https://github.com/kubernetes/ingress-nginx) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This Helm chart has been tested on top of [Bitnami Kubernetes Production Runtime](https://kubeprod.io/) (BKPR). Deploy BKPR to get automated TLS certificates, logging and monitoring for your applications.

## Prerequisites

- Kubernetes 1.12+
- Helm 3.1.0

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/nginx-ingress-controller
```

These commands deploy nginx-ingress-controller on the Kubernetes cluster in the default configuration.

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

| Name                | Description                                        | Value |
| ------------------- | -------------------------------------------------- | ----- |
| `nameOverride`      | String to partially override common.names.fullname | `""`  |
| `fullnameOverride`  | String to fully override common.names.fullname     | `""`  |
| `commonLabels`      | Add labels to all the deployed resources           | `{}`  |
| `commonAnnotations` | Add annotations to all the deployed resources      | `{}`  |
| `extraDeploy`       | Array of extra objects to deploy with the release  | `[]`  |


### Nginx Ingress Controller parameters

| Name                          | Description                                                                                                                                        | Value                              |
| ----------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------- |
| `image.registry`              | Nginx Ingress Controller image registry                                                                                                            | `docker.io`                        |
| `image.repository`            | Nginx Ingress Controller image repository                                                                                                          | `bitnami/nginx-ingress-controller` |
| `image.tag`                   | Nginx Ingress Controller image tag (immutable tags are recommended)                                                                                | `0.48.1-debian-10-r0`              |
| `image.pullPolicy`            | Nginx Ingress Controller image pull policy                                                                                                         | `IfNotPresent`                     |
| `image.pullSecrets`           | Specify docker-registry secret names as an array                                                                                                   | `[]`                               |
| `containerPorts`              | Controller container ports to open                                                                                                                 | `{}`                               |
| `hostAliases`                 | Deployment pod host aliases                                                                                                                        | `[]`                               |
| `config`                      | Custom configuration options for NGINX                                                                                                             | `{}`                               |
| `proxySetHeaders`             | Custom headers before sending traffic to backends                                                                                                  | `{}`                               |
| `addHeaders`                  | Custom headers before sending response traffic to the client                                                                                       | `{}`                               |
| `defaultBackendService`       | Default 404 backend service; required only if `defaultBackend.enabled = false`                                                                     | `""`                               |
| `electionID`                  | Election ID to use for status update                                                                                                               | `ingress-controller-leader`        |
| `reportNodeInternalIp`        | If using `hostNetwork=true`, setting `reportNodeInternalIp=true`, will pass the flag `report-node-internal-ip-address` to Nginx Ingress Controller | `false`                            |
| `ingressClass`                | Name of the ingress class to route through this controller                                                                                         | `nginx`                            |
| `publishService.enabled`      | Set the endpoint records on the Ingress objects to reflect those on the service                                                                    | `false`                            |
| `publishService.pathOverride` | Allows overriding of the publish service to bind to                                                                                                | `""`                               |
| `scope.enabled`               | Limit the scope of the controller. Defaults to `.Release.Namespace`                                                                                | `false`                            |
| `configMapNamespace`          | Allows customization of the configmap / nginx-configmap namespace                                                                                  | `""`                               |
| `tcpConfigMapNamespace`       | Allows customization of the tcp-services-configmap namespace                                                                                       | `""`                               |
| `udpConfigMapNamespace`       | Allows customization of the udp-services-configmap namespace                                                                                       | `""`                               |
| `maxmindLicenseKey`           | License key used to download Geolite2 database                                                                                                     | `""`                               |
| `dhParam`                     | A base64ed Diffie-Hellman parameter                                                                                                                | `""`                               |
| `tcp`                         | TCP service key:value pairs                                                                                                                        | `""`                               |
| `udp`                         | UDP service key:value pairs                                                                                                                        | `""`                               |
| `command`                     | Override default container command (useful when using custom images)                                                                               | `[]`                               |
| `args`                        | Override default container args (useful when using custom images)                                                                                  | `[]`                               |
| `extraArgs`                   | Additional command line arguments to pass to nginx-ingress-controller                                                                              | `{}`                               |
| `extraEnvVars`                | Extra environment variables to be set on Nginx Ingress container                                                                                   | `[]`                               |
| `extraEnvVarsCM`              | Name of a existing ConfigMap containing extra environment variables                                                                                | `""`                               |
| `extraEnvVarsSecret`          | Name of a existing Secret containing extra environment variables                                                                                   | `""`                               |


### Nginx Ingress deployment / daemonset parameters

| Name                                                | Description                                                                                             | Value          |
| --------------------------------------------------- | ------------------------------------------------------------------------------------------------------- | -------------- |
| `kind`                                              | Install as Deployment or DaemonSet                                                                      | `Deployment`   |
| `daemonset.useHostPort`                             | If `kind` is `DaemonSet`, this will enable `hostPort` for `TCP/80` and `TCP/443`                        | `false`        |
| `daemonset.hostPorts`                               | HTTP and HTTPS ports                                                                                    | `{}`           |
| `replicaCount`                                      | Desired number of Controller pods                                                                       | `1`            |
| `updateStrategy`                                    | Strategy to use to update Pods                                                                          | `{}`           |
| `revisionHistoryLimit`                              | The number of old history to retain to allow rollback                                                   | `10`           |
| `podSecurityContext.enabled`                        | Enable Controller pods' Security Context                                                                | `true`         |
| `podSecurityContext.fsGroup`                        | Group ID for the container filesystem                                                                   | `1001`         |
| `containerSecurityContext.enabled`                  | Enable Controller containers' Security Context                                                          | `true`         |
| `containerSecurityContext.allowPrivilegeEscalation` | Switch to allow priviledge escalation on the Controller container                                       | `true`         |
| `containerSecurityContext.runAsUser`                | User ID for the Controller container                                                                    | `1001`         |
| `containerSecurityContext.capabilities.drop`        | Linux Kernel capabilities that should be dropped                                                        | `[]`           |
| `containerSecurityContext.capabilities.add`         | Linux Kernel capabilities that should be added                                                          | `[]`           |
| `minReadySeconds`                                   | How many seconds a pod needs to be ready before killing the next, during update                         | `0`            |
| `resources.limits`                                  | The resources limits for the Controller container                                                       | `{}`           |
| `resources.requests`                                | The requested resources for the Controller container                                                    | `{}`           |
| `livenessProbe.enabled`                             | Enable livenessProbe                                                                                    | `true`         |
| `livenessProbe.httpGet.path`                        | Request path for livenessProbe                                                                          | `/healthz`     |
| `livenessProbe.httpGet.port`                        | Port for livenessProbe                                                                                  | `10254`        |
| `livenessProbe.httpGet.scheme`                      | Scheme for livenessProbe                                                                                | `HTTP`         |
| `livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                 | `10`           |
| `livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                        | `10`           |
| `livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                       | `1`            |
| `livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                     | `3`            |
| `livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                     | `1`            |
| `readinessProbe.enabled`                            | Enable readinessProbe                                                                                   | `true`         |
| `readinessProbe.httpGet.path`                       | Request path for readinessProbe                                                                         | `/healthz`     |
| `readinessProbe.httpGet.port`                       | Port for readinessProbe                                                                                 | `10254`        |
| `readinessProbe.httpGet.scheme`                     | Scheme for readinessProbe                                                                               | `HTTP`         |
| `readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                | `10`           |
| `readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                       | `10`           |
| `readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                      | `1`            |
| `readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                    | `3`            |
| `readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                    | `1`            |
| `customLivenessProbe`                               | Override default liveness probe                                                                         | `{}`           |
| `customReadinessProbe`                              | Override default readiness probe                                                                        | `{}`           |
| `lifecycle`                                         | LifecycleHooks to set additional configuration at startup                                               | `{}`           |
| `podLabels`                                         | Extra labels for Controller pods                                                                        | `{}`           |
| `podAnnotations`                                    | Annotations for Controller pods                                                                         | `{}`           |
| `priorityClassName`                                 | Controller priorityClassName                                                                            | `""`           |
| `hostNetwork`                                       | If the Nginx deployment / daemonset should run on the host's network namespace                          | `false`        |
| `dnsPolicy`                                         | By default, while using host network, name resolution uses the host's DNS                               | `ClusterFirst` |
| `terminationGracePeriodSeconds`                     | How many seconds to wait before terminating a pod                                                       | `60`           |
| `podAffinityPreset`                                 | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                     | `""`           |
| `podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                | `soft`         |
| `nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`               | `""`           |
| `nodeAffinityPreset.key`                            | Node label key to match. Ignored if `affinity` is set.                                                  | `""`           |
| `nodeAffinityPreset.values`                         | Node label values to match. Ignored if `affinity` is set.                                               | `[]`           |
| `affinity`                                          | Affinity for pod assignment. Evaluated as a template.                                                   | `{}`           |
| `nodeSelector`                                      | Node labels for pod assignment. Evaluated as a template.                                                | `{}`           |
| `tolerations`                                       | Tolerations for pod assignment. Evaluated as a template.                                                | `[]`           |
| `extraVolumes`                                      | Optionally specify extra list of additional volumes for Controller pods                                 | `[]`           |
| `extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for Controller container(s)                    | `[]`           |
| `initContainers`                                    | Add init containers to the controller pods                                                              | `[]`           |
| `sidecars`                                          | Add sidecars to the controller pods.                                                                    | `[]`           |
| `customTemplate`                                    | Override NGINX template                                                                                 | `{}`           |
| `topologySpreadConstraints`                         | Topology spread constraints rely on node labels to identify the topology domain(s) that each Node is in | `[]`           |
| `podSecurityPolicy.enabled`                         | If true, create & use Pod Security Policy resources                                                     | `false`        |


### Default backend parameters

| Name                                                | Description                                                                               | Value                 |
| --------------------------------------------------- | ----------------------------------------------------------------------------------------- | --------------------- |
| `defaultBackend.enabled`                            | Enable a default backend based on NGINX                                                   | `true`                |
| `defaultBackend.hostAliases`                        | Add deployment host aliases                                                               | `[]`                  |
| `defaultBackend.image.registry`                     | Default backend image registry                                                            | `docker.io`           |
| `defaultBackend.image.repository`                   | Default backend image repository                                                          | `bitnami/nginx`       |
| `defaultBackend.image.tag`                          | Default backend image tag (immutable tags are recommended)                                | `1.21.1-debian-10-r7` |
| `defaultBackend.image.pullPolicy`                   | Image pull policy                                                                         | `IfNotPresent`        |
| `defaultBackend.image.pullSecrets`                  | Specify docker-registry secret names as an array                                          | `[]`                  |
| `defaultBackend.extraArgs`                          | Additional command line arguments to pass to Nginx container                              | `{}`                  |
| `defaultBackend.containerPort`                      | HTTP container port number                                                                | `8080`                |
| `defaultBackend.serverBlockConfig`                  | NGINX backend default server block configuration                                          | `""`                  |
| `defaultBackend.replicaCount`                       | Desired number of default backend pods                                                    | `1`                   |
| `defaultBackend.podSecurityContext.enabled`         | Enable Default backend pods' Security Context                                             | `true`                |
| `defaultBackend.podSecurityContext.fsGroup`         | Group ID for the container filesystem                                                     | `1001`                |
| `defaultBackend.containerSecurityContext.enabled`   | Enable Default backend containers' Security Context                                       | `true`                |
| `defaultBackend.containerSecurityContext.runAsUser` | User ID for the Default backend container                                                 | `1001`                |
| `defaultBackend.resources.limits`                   | The resources limits for the Default backend container                                    | `{}`                  |
| `defaultBackend.resources.requests`                 | The requested resources for the Default backend container                                 | `{}`                  |
| `defaultBackend.livenessProbe.enabled`              | Enable livenessProbe                                                                      | `true`                |
| `defaultBackend.livenessProbe.httpGet.path`         | Request path for livenessProbe                                                            | `/healthz`            |
| `defaultBackend.livenessProbe.httpGet.port`         | Port for livenessProbe                                                                    | `http`                |
| `defaultBackend.livenessProbe.httpGet.scheme`       | Scheme for livenessProbe                                                                  | `HTTP`                |
| `defaultBackend.livenessProbe.initialDelaySeconds`  | Initial delay seconds for livenessProbe                                                   | `30`                  |
| `defaultBackend.livenessProbe.periodSeconds`        | Period seconds for livenessProbe                                                          | `10`                  |
| `defaultBackend.livenessProbe.timeoutSeconds`       | Timeout seconds for livenessProbe                                                         | `5`                   |
| `defaultBackend.livenessProbe.failureThreshold`     | Failure threshold for livenessProbe                                                       | `3`                   |
| `defaultBackend.livenessProbe.successThreshold`     | Success threshold for livenessProbe                                                       | `1`                   |
| `defaultBackend.readinessProbe.enabled`             | Enable readinessProbe                                                                     | `true`                |
| `defaultBackend.readinessProbe.httpGet.path`        | Request path for readinessProbe                                                           | `/healthz`            |
| `defaultBackend.readinessProbe.httpGet.port`        | Port for readinessProbe                                                                   | `http`                |
| `defaultBackend.readinessProbe.httpGet.scheme`      | Scheme for readinessProbe                                                                 | `HTTP`                |
| `defaultBackend.readinessProbe.initialDelaySeconds` | Initial delay seconds for readinessProbe                                                  | `0`                   |
| `defaultBackend.readinessProbe.periodSeconds`       | Period seconds for readinessProbe                                                         | `5`                   |
| `defaultBackend.readinessProbe.timeoutSeconds`      | Timeout seconds for readinessProbe                                                        | `5`                   |
| `defaultBackend.readinessProbe.failureThreshold`    | Failure threshold for readinessProbe                                                      | `6`                   |
| `defaultBackend.readinessProbe.successThreshold`    | Success threshold for readinessProbe                                                      | `1`                   |
| `defaultBackend.podLabels`                          | Extra labels for Controller pods                                                          | `{}`                  |
| `defaultBackend.podAnnotations`                     | Annotations for Controller pods                                                           | `{}`                  |
| `defaultBackend.priorityClassName`                  | priorityClassName                                                                         | `""`                  |
| `defaultBackend.podAffinityPreset`                  | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`       | `""`                  |
| `defaultBackend.podAntiAffinityPreset`              | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`  | `soft`                |
| `defaultBackend.nodeAffinityPreset.type`            | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard` | `""`                  |
| `defaultBackend.nodeAffinityPreset.key`             | Node label key to match. Ignored if `affinity` is set.                                    | `""`                  |
| `defaultBackend.nodeAffinityPreset.values`          | Node label values to match. Ignored if `affinity` is set.                                 | `[]`                  |
| `defaultBackend.affinity`                           | Affinity for pod assignment                                                               | `{}`                  |
| `defaultBackend.nodeSelector`                       | Node labels for pod assignment                                                            | `{}`                  |
| `defaultBackend.tolerations`                        | Tolerations for pod assignment                                                            | `[]`                  |
| `defaultBackend.service.type`                       | Kubernetes Service type for default backend                                               | `ClusterIP`           |
| `defaultBackend.service.port`                       | Default backend service port                                                              | `80`                  |
| `defaultBackend.pdb.create`                         | Enable/disable a Pod Disruption Budget creation for Default backend                       | `false`               |
| `defaultBackend.pdb.minAvailable`                   | Minimum number/percentage of Default backend pods that should remain scheduled            | `1`                   |
| `defaultBackend.pdb.maxUnavailable`                 | Maximum number/percentage of Default backend pods that may be made unavailable            | `""`                  |


### Traffic exposure parameters

| Name                               | Description                                                                                                                            | Value          |
| ---------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------- | -------------- |
| `service.type`                     | Kubernetes Service type for Controller                                                                                                 | `LoadBalancer` |
| `service.ports`                    | Service ports                                                                                                                          | `{}`           |
| `service.targetPorts`              | Map the controller service HTTP/HTTPS port                                                                                             | `{}`           |
| `service.nodePorts`                | Specify the nodePort value(s) for the LoadBalancer and NodePort service types.                                                         | `{}`           |
| `service.annotations`              | Annotations for controller service                                                                                                     | `{}`           |
| `service.labels`                   | Labels for controller service                                                                                                          | `{}`           |
| `service.clusterIP`                | Controller Internal Cluster Service IP (optional)                                                                                      | `""`           |
| `service.externalIPs`              | Controller Service external IP addresses                                                                                               | `[]`           |
| `service.loadBalancerIP`           | Kubernetes LoadBalancerIP to request for Controller (optional, cloud specific)                                                         | `""`           |
| `service.loadBalancerSourceRanges` | List of IP CIDRs allowed access to load balancer (if supported)                                                                        | `[]`           |
| `service.externalTrafficPolicy`    | Set external traffic policy to: "Local" to preserve source IP on providers supporting it                                               | `""`           |
| `service.healthCheckNodePort`      | Set this to the managed health-check port the kube-proxy will expose. If blank, a random port in the `NodePort` range will be assigned | `0`            |


### RBAC parameters

| Name                         | Description                                                 | Value  |
| ---------------------------- | ----------------------------------------------------------- | ------ |
| `serviceAccount.create`      | Enable the creation of a ServiceAccount for Controller pods | `true` |
| `serviceAccount.name`        | Name of the created ServiceAccount                          | `""`   |
| `serviceAccount.annotations` | Annotations for service account.                            | `{}`   |
| `rbac.create`                | Specifies whether RBAC rules should be created              | `true` |


### Other parameters

| Name                       | Description                                                               | Value   |
| -------------------------- | ------------------------------------------------------------------------- | ------- |
| `pdb.create`               | Enable/disable a Pod Disruption Budget creation for Controller            | `false` |
| `pdb.minAvailable`         | Minimum number/percentage of Controller pods that should remain scheduled | `1`     |
| `pdb.maxUnavailable`       | Maximum number/percentage of Controller pods that may be made unavailable | `""`    |
| `autoscaling.enabled`      | Enable autoscaling for Controller                                         | `false` |
| `autoscaling.minReplicas`  | Minimum number of Controller replicas                                     | `1`     |
| `autoscaling.maxReplicas`  | Maximum number of Controller replicas                                     | `11`    |
| `autoscaling.targetCPU`    | Target CPU utilization percentage                                         | `""`    |
| `autoscaling.targetMemory` | Target Memory utilization percentage                                      | `""`    |


### Metrics parameters

| Name                                      | Description                                                                   | Value       |
| ----------------------------------------- | ----------------------------------------------------------------------------- | ----------- |
| `metrics.enabled`                         | Enable exposing Controller statistics                                         | `false`     |
| `metrics.service.type`                    | Type of Prometheus metrics service to create                                  | `ClusterIP` |
| `metrics.service.port`                    | Service HTTP management port                                                  | `9913`      |
| `metrics.service.annotations`             | Annotations for the Prometheus exporter service                               | `{}`        |
| `metrics.serviceMonitor.enabled`          | Create ServiceMonitor resource for scraping metrics using PrometheusOperator  | `false`     |
| `metrics.serviceMonitor.namespace`        | Namespace in which Prometheus is running                                      | `""`        |
| `metrics.serviceMonitor.interval`         | Interval at which metrics should be scraped                                   | `30s`       |
| `metrics.serviceMonitor.scrapeTimeout`    | Specify the timeout after which the scrape is ended                           | `""`        |
| `metrics.serviceMonitor.selector`         | ServiceMonitor selector labels                                                | `{}`        |
| `metrics.prometheusRule.enabled`          | Create PrometheusRules resource for scraping metrics using PrometheusOperator | `false`     |
| `metrics.prometheusRule.additionalLabels` | Used to pass Labels that are required by the Installed Prometheus Operator    | `{}`        |
| `metrics.prometheusRule.namespace`        | Namespace which Prometheus is running in                                      | `""`        |
| `metrics.prometheusRule.rules`            | Rules to be prometheus in YAML format, check values for an example            | `[]`        |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install my-release \
    --set image.pullPolicy=Always \
    bitnami/nginx-ingress-controller
```

The above command sets the `image.pullPolicy` to `Always`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install my-release -f values.yaml bitnami/nginx-ingress-controller
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Sidecars and Init Containers

If you have a need for additional containers to run within the same pod as the NGINX Ingress Controller (e.g. an additional metrics or logging exporter), you can do so via the `sidecars` config parameter. Simply define your container according to the Kubernetes container spec.

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

## Notable changes

### 5.3.0

In this version you can indicate the key to download the GeoLite2 databases using the [parameter](#parameters) `maxmindLicenseKey`.

## Upgrading

### To 7.0.0

- Chart labels were adapted to follow the [Helm charts standard labels](https://helm.sh/docs/chart_best_practices/labels/#standard-labels).
- Several parameters were renamed or disappeared in favor of new ones on this major version. These are a few examples:
  - `*.securityContext` paramateres are deprecated in favor of `*.containerSecurityContext` ones.
  - `*.minAvailable` paramateres are deprecated in favor of `*.pdb.minAvailable` ones.
  - `extraContainers`  paramatere is deprecated in favor of `sidecars`.
- This version also introduces `bitnami/common`, a [library chart](https://helm.sh/docs/topics/library_charts/#helm) as a dependency. More documentation about this new utility could be found [here](https://github.com/bitnami/charts/tree/master/bitnami/common#bitnami-common-library-chart). Please, make sure that you have updated the chart dependencies before executing any upgrade.

Consequences:

- Backwards compatibility is not guaranteed. Uninstall & install the chart again to obtain the latest version.

### To 6.0.0

[On November 13, 2020, Helm v2 support was formally finished](https://github.com/helm/charts#status-of-the-project), this major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

#### What changes were introduced in this major version?

- Previous versions of this Helm Chart use `apiVersion: v1` (installable by both Helm 2 and 3), this Helm Chart was updated to `apiVersion: v2` (installable by Helm 3 only). [Here](https://helm.sh/docs/topics/charts/#the-apiversion-field) you can find more information about the `apiVersion` field.
- The different fields present in the *Chart.yaml* file has been ordered alphabetically in a homogeneous way for all the Bitnami Helm Charts

#### Considerations when upgrading to this version

- If you want to upgrade to this version from a previous one installed with Helm v3, you shouldn't face any issues
- If you want to upgrade to this version using Helm v2, this scenario is not supported as this version doesn't support Helm v2 anymore
- If you installed the previous version with Helm v2 and wants to upgrade to this version with Helm v3, please refer to the [official Helm documentation](https://helm.sh/docs/topics/v2_v3_migration/#migration-use-cases) about migrating from Helm v2 to v3

#### Useful links**

- https://docs.bitnami.com/tutorials/resolve-helm2-helm3-post-migration-issues/
- https://helm.sh/docs/topics/v2_v3_migration/
- https://helm.sh/blog/migrate-from-helm-v2-to-helm-v3/

### To 1.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 1.0.0. The following example assumes that the release name is nginx-ingress-controller:

```console
$ kubectl patch deployment nginx-ingress-controller-default-backend --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
# If using deployments
$ kubectl patch deployment nginx-ingress-controller --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
# If using daemonsets
$ kubectl patch daemonset nginx-ingress-controller --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
```
