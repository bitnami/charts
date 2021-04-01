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

The following tables lists the configurable parameters of the Nginx Ingress Controller chart chart and their default values per section/component:

### Global parameters

| Parameter                 | Description                                     | Default                                                 |
|---------------------------|-------------------------------------------------|---------------------------------------------------------|
| `global.imageRegistry`    | Global Docker image registry                    | `nil`                                                   |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]` (does not add image pull secrets to deployed pods) |

### Common parameters

| Parameter           | Description                                        | Default                        |
|---------------------|----------------------------------------------------|--------------------------------|
| `nameOverride`      | String to partially override common.names.fullname | `nil`                          |
| `fullnameOverride`  | String to fully override common.names.fullname     | `nil`                          |
| `commonLabels`      | Labels to add to all deployed objects              | `{}`                           |
| `commonAnnotations` | Annotations to add to all deployed objects         | `{}`                           |
| `extraDeploy`       | Array of extra objects to deploy with the release  | `[]` (evaluated as a template) |

### Nginx Ingress Controller parameters

| Parameter                     | Description                                                                                                                                        | Default                                                 |
|-------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------|
| `image.registry`              | Nginx Ingress Controller image registry                                                                                                            | `docker.io`                                             |
| `image.repository`            | Nginx Ingress Controller image name                                                                                                                | `bitnami/nginx-ingress-controller`                      |
| `image.tag`                   | Nginx Ingress Controller image tag                                                                                                                 | `{TAG_NAME}`                                            |
| `image.pullPolicy`            | Image pull policy                                                                                                                                  | `IfNotPresent`                                          |
| `image.pullSecrets`           | Specify docker-registry secret names as an array                                                                                                   | `[]` (does not add image pull secrets to deployed pods) |
| `containerPorts.http`         | The port that the controller container listens on for HTTP connections.                                                                            | `80`                                                    |
| `containerPorts.https`        | The port that the controller container listens on for HTTPS connections.                                                                           | `443`                                                   |
| `config`                      | Nginx ConfigMap entries                                                                                                                            | `{}`                                                    |
| `addHeaders`                  | Custom headers to be added before sending responses to the client                                                                                  | `{}`                                                    |
| `proxySetHeaders`             | Custom headers to be added before sending request to the backends for NGINX                                                                        | `{}`                                                    |
| `reportNodeInternalIp`        | If using `hostNetwork=true`, setting `reportNodeInternalIp=true`, will pass the flag `report-node-internal-ip-address` to Nginx Ingress Controller | `ClusterFirst`                                          |
| `defaultBackendService`       | Default 404 backend service; required only if `defaultBackend.enabled = false`                                                                     | `""`                                                    |
| `electionID`                  | Election ID to use for the status update                                                                                                           | `ingress-controller-leader`                             |
| `ingressClass`                | Name of the ingress class to route through this controller                                                                                         | `nginx`                                                 |
| `publishService.enabled`      | Set the endpoint records on the Ingress objects to reflect those on the service                                                                    | `false`                                                 |
| `publishService.pathOverride` | Override of the default publish-service name                                                                                                       | `""`                                                    |
| `hostAliases`                 | Add deployment host aliases                                                                                                                        | `[]`                                                    |
| `scope.enabled`               | Limit the scope of the ingress controller                                                                                                          | `false` (watch all namespaces)                          |
| `scope.namespace`             | Namespace to watch for ingress                                                                                                                     | `""` (use the release namespace)                        |
| `configMapNamespace`          | The nginx-configmap namespace name                                                                                                                 | `""`                                                    |
| `tcpConfigMapNamespace`       | The tcp-services-configmap namespace name                                                                                                          | `""`                                                    |
| `udpConfigMapNamespace`       | The udp-services-configmap namespace name                                                                                                          | `""`                                                    |
| `dhparam`                     | A base64 Diffie-Helman parameter                                                                                                                   | `nil`                                                   |
| `tcp`                         | TCP service key:value pairs                                                                                                                        | `{}`                                                    |
| `udp`                         | UDP service key:value pairs                                                                                                                        | `{}`                                                    |
| `maxmindLicenseKey`           | Maxmind license key to download GeoLite2 Databases                                                                                                 | `""`                                                    |
| `command`                     | Override default container command (useful when using custom images)                                                                               | `nil`                                                   |
| `args`                        | Override default container args (useful when using custom images)                                                                                  | `nil`                                                   |
| `extraArgs`                   | Additional command line arguments to pass to Nginx Ingress container                                                                               | `{}`                                                    |
| `extraEnvVars`                | Extra environment variables to be set on Nginx Ingress container                                                                                   | `[]`                                                    |
| `extraEnvVarsCM`              | Name of existing ConfigMap containing extra env vars                                                                                               | `nil`                                                   |
| `extraEnvVarsSecret`          | Name of existing Secret containing extra env vars                                                                                                  | `nil`                                                   |

### Nginx Ingress deployment / daemonset parameters

| Parameter                       | Description                                                                                             | Default                        |
|---------------------------------|---------------------------------------------------------------------------------------------------------|--------------------------------|
| `kind`                          | Install as Deployment or DaemonSet                                                                      | `Deployment`                   |
| `replicaCount`                  | Desired number of Controller pods                                                                       | `1`                            |
| `daemonset.useHostPort`         | If `kind` is `DaemonSet`, this will enable `hostPort` for `TCP/80` and `TCP/443`                        | `false`                        |
| `daemonset.hostPorts.http`      | If `daemonset.useHostPort` is `true` and this is non-empty, it sets the hostPort                        | `"80"`                         |
| `daemonset.hostPorts.https`     | If `daemonset.useHostPort` is `true` and this is non-empty, it sets the hostPort                        | `"443"`                        |
| `hostNetwork`                   | If the nginx deployment / daemonset should run on the host's network namespace                          | `false`                        |
| `dnsPolicy`                     | If using `hostNetwork=true`, change to `ClusterFirstWithHostNet`                                        | `ClusterFirst`                 |
| `podSecurityContext`            | Controller pods' Security Context                                                                       | Check `values.yaml` file       |
| `containerSecurityContext`      | Controller containers' Security Context                                                                 | Check `values.yaml` file       |
| `resources.limits`              | The resources limits for the Controller container                                                       | `{}`                           |
| `resources.requests`            | The requested resources for the Controller container                                                    | `{}`                           |
| `livenessProbe`                 | Liveness probe configuration for Controller                                                             | Check `values.yaml` file       |
| `readinessProbe`                | Readiness probe configuration for Controller                                                            | Check `values.yaml` file       |
| `customLivenessProbe`           | Override default liveness probe                                                                         | `nil`                          |
| `customReadinessProbe`          | Override default readiness probe                                                                        | `nil`                          |
| `revisionHistoryLimit`          | The number of old history to retain to allow rollback.                                                  | `10`                           |
| `updateStrategy`                | Strategy to use to update Pods                                                                          | Check `values.yaml` file       |
| `podAffinityPreset`             | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                     | `""`                           |
| `podAntiAffinityPreset`         | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                | `soft`                         |
| `nodeAffinityPreset.type`       | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`               | `""`                           |
| `nodeAffinityPreset.key`        | Node label key to match. Ignored if `affinity` is set.                                                  | `""`                           |
| `nodeAffinityPreset.values`     | Node label values to match. Ignored if `affinity` is set.                                               | `[]`                           |
| `affinity`                      | Affinity for pod assignment                                                                             | `{}` (evaluated as a template) |
| `nodeSelector`                  | Node labels for pod assignment                                                                          | `{}` (evaluated as a template) |
| `tolerations`                   | Tolerations for pod assignment                                                                          | `[]` (evaluated as a template) |
| `podLabels`                     | Extra labels for Controller pods                                                                        | `{}` (evaluated as a template) |
| `podAnnotations`                | Annotations for Controller pods                                                                         | `{}` (evaluated as a template) |
| `priorityClassName`             | Controller priorityClassName                                                                            | `nil`                          |
| `lifecycle`                     | LifecycleHooks to set additional configuration at startup.                                              | `{}` (evaluated as a template) |
| `terminationGracePeriodSeconds` | How many seconds to wait before terminating a pod                                                       | `60`                           |
| `topologySpreadConstraints`     | Topology spread constraints rely on node labels to identify the topology domain(s) that each Node is in | `{}`                           |
| `minReadySeconds`               | How many seconds a pod needs to be ready before killing the next, during update                         | `0`                            |
| `extraVolumeMounts`             | Optionally specify extra list of additional volumeMounts for Controller container(s)                    | `[]`                           |
| `extraVolumes`                  | Optionally specify extra list of additional volumes for Controller pods                                 | `[]`                           |
| `initContainers`                | Add additional init containers to the Controller pods                                                   | `{}` (evaluated as a template) |
| `sidecars`                      | Add additional sidecar containers to the Controller pods                                                | `{}` (evaluated as a template) |

### Default backend parameters

| Parameter                                  | Description                                                                               | Default                                                 |
|--------------------------------------------|-------------------------------------------------------------------------------------------|---------------------------------------------------------|
| `defaultBackend.enabled`                   | Enable a default backend based on NGINX                                                   | `true`                                                  |
| `defaultBackend.image.registry`            | Default backend image registry                                                            | `docker.io`                                             |
| `defaultBackend.hostAliases`               | Add deployment host aliases                                                               | `[]`                                                    |
| `defaultBackend.image.repository`          | Default backend image name                                                                | `bitnami/nginx`                                         |
| `defaultBackend.image.tag`                 | Default backend image tag                                                                 | `{TAG_NAME}`                                            |
| `defaultBackend.image.pullPolicy`          | Image pull policy                                                                         | `IfNotPresent`                                          |
| `defaultBackend.image.pullSecrets`         | Specify docker-registry secret names as an array                                          | `[]` (does not add image pull secrets to deployed pods) |
| `defaultBackend.extraArgs`                 | Additional command line arguments to pass to NGINX container                              | `{}`                                                    |
| `defaultBackend.containerPort`             | HTTP container port number                                                                | `8080`                                                  |
| `defaultBackend.replicaCount`              | Desired number of default backend pods                                                    | `1`                                                     |
| `defaultBackend.podSecurityContext`        | Default backend pods' Security Context                                                    | Check `values.yaml` file                                |
| `defaultBackend.containerSecurityContext`  | Default backend containers' Security Context                                              | Check `values.yaml` file                                |
| `defaultBackend.resources.limits`          | The resources limits for the Default backend container                                    | `{}`                                                    |
| `defaultBackend.resources.requests`        | The requested resources for the Default backend container                                 | `{}`                                                    |
| `defaultBackend.livenessProbe`             | Liveness probe configuration for Default backend                                          | Check `values.yaml` file                                |
| `defaultBackend.readinessProbe`            | Readiness probe configuration for Default backend                                         | Check `values.yaml` file                                |
| `defaultBackend.customLivenessProbe`       | Override default liveness probe                                                           | `nil`                                                   |
| `defaultBackend.customReadinessProbe`      | Override default readiness probe                                                          | `nil`                                                   |
| `defaultBackend.podAffinityPreset`         | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`       | `""`                                                    |
| `defaultBackend.podAntiAffinityPreset`     | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`  | `soft`                                                  |
| `defaultBackend.nodeAffinityPreset.type`   | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard` | `""`                                                    |
| `defaultBackend.nodeAffinityPreset.key`    | Node label key to match. Ignored if `affinity` is set.                                    | `""`                                                    |
| `defaultBackend.nodeAffinityPreset.values` | Node label values to match. Ignored if `affinity` is set.                                 | `[]`                                                    |
| `defaultBackend.affinity`                  | Affinity for pod assignment                                                               | `{}` (evaluated as a template)                          |
| `defaultBackend.nodeSelector`              | Node labels for pod assignment                                                            | `{}` (evaluated as a template)                          |
| `defaultBackend.tolerations`               | Tolerations for pod assignment                                                            | `[]` (evaluated as a template)                          |
| `defaultBackend.podLabels`                 | Extra labels for Controller pods                                                          | `{}` (evaluated as a template)                          |
| `defaultBackend.podAnnotations`            | Annotations for Controller pods                                                           | `{}` (evaluated as a template)                          |
| `customTemplate.configMapName`             | ConfigMap containing a custom NGINX template                                              | `""`                                                    |
| `customTemplate.configMapKey`              | ConfigMap key containing the NGINX template                                               | `""`                                                    |

### Exposure parameters

| Parameter                          | Description                                                                                                                            | Default        |
|------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------|----------------|
| `service.type`                     | Kubernetes Service type for Controller                                                                                                 | `LoadBalancer` |
| `service.annotations`              | Annotations for controller service                                                                                                     | `{}`           |
| `service.labels`                   | Labels for controller service                                                                                                          | `{}`           |
| `service.loadBalancerIP`           | Kubernetes LoadBalancerIP to request for Controller                                                                                    | `nil`          |
| `service.loadBalancerSourceRanges` | List of IP CIDRs allowed access to load balancer (if supported)                                                                        | `[]`           |
| `service.externalIPs`              | Controller Service external IP addresses                                                                                               | `[]`           |
| `service.clusterIP`                | Controller Internal Cluster Service IP                                                                                                 | `""`           |
| `service.omitClusterIP`            | To omit the `ClusterIP` from the controller service                                                                                    | `false`        |
| `service.ports.http`               | Controller Service HTTP port                                                                                                           | `80`           |
| `service.ports.https`              | Controller Service HTTPS port                                                                                                          | `443`           |
| `service.targetPorts.http`         | Map the controller service HTTP port                                                                                                   | `http`         |
| `service.targetPorts.https`        | Map the controller service HTTPS port                                                                                                  | `https`        |
| `service.externalTrafficPolicy`    | Enable client source IP preservation                                                                                                   | `Cluster`      |
| `service.nodePorts.http`           | Kubernetes http node port for Controller                                                                                               | `""`           |
| `service.nodePorts.https`          | Kubernetes https node port for Controller                                                                                              | `""`           |
| `service.nodePorts.tcp`            | Sets the nodePort for an entry referenced by its key from `tcp`                                                                        | `{}`           |
| `service.nodePorts.udp`            | Sets the nodePort for an entry referenced by its key from `udp`                                                                        | `{}`           |
| `service.healthCheckNodePort`      | Set this to the managed health-check port the kube-proxy will expose. If blank, a random port in the `NodePort` range will be assigned | `""`           |
| `defaultBackend.service.type`      | Kubernetes Service type for default backend                                                                                            | `ClusterIP`    |
| `defaultBackend.service.port`      | Default backend service port                                                                                                           | `80`           |

### RBAC parameters

| Parameter                    | Description                                                 | Default                                              |
|------------------------------|-------------------------------------------------------------|------------------------------------------------------|
| `serviceAccount.create`      | Enable the creation of a ServiceAccount for Controller pods | `true`                                               |
| `serviceAccount.name`        | Name of the created ServiceAccount                          | Generated using the `common.names.fullname` template |
| `serviceAccount.annotations` | Annotations for service account.                            | `{}`                                                 |
| `rbac.create`                | Weather to create & use RBAC resources or not               | `false`                                              |

### Other parameters

| Parameter                           | Description                                                                    | Default |
|-------------------------------------|--------------------------------------------------------------------------------|---------|
| `pdb.create`                        | Enable/disable a Pod Disruption Budget creation for Controller                 | `false` |
| `pdb.minAvailable`                  | Minimum number/percentage of Controller pods that should remain scheduled      | `1`     |
| `pdb.maxUnavailable`                | Maximum number/percentage of Controller pods that may be made unavailable      | `nil`   |
| `defaultBackend.pdb.create`         | Enable/disable a Pod Disruption Budget creation for Default backend            | `false` |
| `defaultBackend.pdb.minAvailable`   | Minimum number/percentage of Default backend pods that should remain scheduled | `1`     |
| `defaultBackend.pdb.maxUnavailable` | Maximum number/percentage of Default backend pods that may be made unavailable | `nil`   |
| `autoscaling.enabled`               | Enable autoscaling for Controller                                              | `false` |
| `autoscaling.minReplicas`           | Minimum number of Controller replicas                                          | `1`     |
| `autoscaling.maxReplicas`           | Maximum number of Controller replicas                                          | `11`    |
| `autoscaling.targetCPU`             | Target CPU utilization percentage                                              | `nil`   |
| `autoscaling.targetMemory`          | Target Memory utilization percentage                                           | `nil`   |

### Metrics parameters

| Parameter                                 | Description                                                                   | Default                                                      |
|-------------------------------------------|-------------------------------------------------------------------------------|--------------------------------------------------------------|
| `metrics.enabled`                         | Enable exposing Controller statistics                                         | `false`                                                      |
| `metrics.service.type`                    | Type of Prometheus metrics service to create                                  | `ClusterIP`                                                  |
| `metrics.service.port`                    | Service HTTP management port                                                  | `9913`                                                       |
| `metrics.service.annotations`             | Annotations for enabling prometheus to access the metrics endpoints           | `{prometheus.io/scrape: "true", prometheus.io/port: "9913"}` |
| `metrics.serviceMonitor.enabled`          | Create ServiceMonitor resource for scraping metrics using PrometheusOperator  | `false`                                                      |
| `metrics.serviceMonitor.namespace`        | Namespace which Prometheus is running in                                      | `nil`                                                        |
| `metrics.serviceMonitor.interval`         | Interval at which metrics should be scraped                                   | `30s`                                                        |
| `metrics.serviceMonitor.scrapeTimeout`    | Specify the timeout after which the scrape is ended                           | `nil`                                                        |
| `metrics.serviceMonitor.relabellings`     | Specify Metric Relabellings to add to the scrape endpoint                     | `nil`                                                        |
| `metrics.serviceMonitor.honorLabels`      | honorLabels chooses the metric's labels on collisions with target labels.     | `false`                                                      |
| `metrics.serviceMonitor.additionalLabels` | Used to pass Labels that are required by the Installed Prometheus Operator    | `{}`                                                         |
| `metrics.prometheusRule.enabled`          | Create PrometheusRules resource for scraping metrics using PrometheusOperator | `false`                                                      |
| `metrics.prometheusRule.additionalLabels` | Used to pass Labels that are required by the Installed Prometheus Operator    | `{}`                                                         |
| `metrics.prometheusRule.namespace`        | Namespace which Prometheus is running in                                      | `nil`                                                        |
| `metrics.prometheusRule.rules`            | Rules to be prometheus in YAML format, check values for an example.           | `[]`                                                         |

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
