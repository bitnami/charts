<!--- app-name: Logstash -->

# Logstash

[Logstash](https://www.elastic.co/products/logstash) is an open source, server-side data processing pipeline that ingests data from a multitude of sources simultaneously, transforms it, and then sends it to your favorite "stash".

## TL;DR

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/logstash
```

## Introduction

This chart bootstraps a [logstash](https://github.com/bitnami/bitnami-docker-logstash) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.12+
- Helm 3.1.0

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/logstash
```

These commands deploy logstash on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` statefulset:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release. Use the option `--purge` to delete all history too.

## Parameters

### Global parameters

| Name                      | Description                                     | Value |
| ------------------------- | ----------------------------------------------- | ----- |
| `global.imageRegistry`    | Global Docker image registry                    | `""`  |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]`  |


### Common parameters

| Name                     | Description                                                                              | Value           |
| ------------------------ | ---------------------------------------------------------------------------------------- | --------------- |
| `kubeVersion`            | Force target Kubernetes version (using Helm capabilities if not set)                     | `""`            |
| `nameOverride`           | String to partially override logstash.fullname template (will maintain the release name) | `""`            |
| `fullnameOverride`       | String to fully override logstash.fullname template                                      | `""`            |
| `clusterDomain`          | Default Kubernetes cluster domain                                                        | `cluster.local` |
| `extraDeploy`            | Array of extra objects to deploy with the release (evaluated as a template).             | `[]`            |
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden)  | `false`         |
| `diagnosticMode.command` | Command to override all containers in the deployment                                     | `["sleep"]`     |
| `diagnosticMode.args`    | Args to override all containers in the deployment                                        | `["infinity"]`  |


### Logstash parameters

| Name                                          | Description                                                                                                                      | Value                       |
| --------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | --------------------------- |
| `image.registry`                              | Logstash image registry                                                                                                          | `docker.io`                 |
| `image.repository`                            | Logstash image repository                                                                                                        | `bitnami/logstash`          |
| `image.tag`                                   | Logstash image tag (immutable tags are recommended)                                                                              | `7.15.2-debian-10-r12`      |
| `image.pullPolicy`                            | Logstash image pull policy                                                                                                       | `IfNotPresent`              |
| `image.pullSecrets`                           | Specify docker-registry secret names as an array                                                                                 | `[]`                        |
| `image.debug`                                 | Specify if debug logs should be enabled                                                                                          | `false`                     |
| `hostAliases`                                 | Add deployment host aliases                                                                                                      | `[]`                        |
| `configFileName`                              | Logstash configuration file name. It must match the name of the configuration file mounted as a configmap.                       | `logstash.conf`             |
| `enableMonitoringAPI`                         | Whether to enable the Logstash Monitoring API or not  Kubernetes cluster domain                                                  | `true`                      |
| `monitoringAPIPort`                           | Logstash Monitoring API Port                                                                                                     | `9600`                      |
| `extraEnvVars`                                | Array containing extra env vars to configure Logstash                                                                            | `[]`                        |
| `extraEnvVarsSecret`                          | To add secrets to environment                                                                                                    | `""`                        |
| `extraEnvVarsCM`                              | To add configmaps to environment                                                                                                 | `""`                        |
| `input`                                       | Input Plugins configuration                                                                                                      | `""`                        |
| `filter`                                      | Filter Plugins configuration                                                                                                     | `""`                        |
| `output`                                      | Output Plugins configuration                                                                                                     | `""`                        |
| `existingConfiguration`                       | Name of existing ConfigMap object with the Logstash configuration (`input`, `filter`, and `output` will be ignored).             | `""`                        |
| `enableMultiplePipelines`                     | Allows user to use multiple pipelines                                                                                            | `false`                     |
| `extraVolumes`                                | Array to add extra volumes (evaluated as a template)                                                                             | `[]`                        |
| `extraVolumeMounts`                           | Array to add extra mounts (normally used with extraVolumes, evaluated as a template)                                             | `[]`                        |
| `containerPorts`                              | Array containing the ports to open in the Logstash container                                                                     | `[]`                        |
| `replicaCount`                                | Number of Logstash replicas to deploy                                                                                            | `1`                         |
| `updateStrategy`                              | Update strategy (`RollingUpdate`, or `OnDelete`)                                                                                 | `RollingUpdate`             |
| `podManagementPolicy`                         | Pod management policy                                                                                                            | `OrderedReady`              |
| `podAnnotations`                              | Pod annotations                                                                                                                  | `{}`                        |
| `podAffinityPreset`                           | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                              | `""`                        |
| `podAntiAffinityPreset`                       | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                         | `soft`                      |
| `nodeAffinityPreset.type`                     | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                        | `""`                        |
| `nodeAffinityPreset.key`                      | Node label key to match. Ignored if `affinity` is set.                                                                           | `""`                        |
| `nodeAffinityPreset.values`                   | Node label values to match. Ignored if `affinity` is set.                                                                        | `[]`                        |
| `affinity`                                    | Affinity for pod assignment                                                                                                      | `{}`                        |
| `nodeSelector`                                | Node labels for pod assignment                                                                                                   | `{}`                        |
| `tolerations`                                 | Tolerations for pod assignment                                                                                                   | `[]`                        |
| `priorityClassName`                           | Pod priority                                                                                                                     | `""`                        |
| `securityContext.enabled`                     | Enable security context for Logstash                                                                                             | `true`                      |
| `securityContext.fsGroup`                     | Group ID for the Logstash filesystem                                                                                             | `1001`                      |
| `securityContext.runAsUser`                   | User ID for the Logstash container                                                                                               | `1001`                      |
| `resources.limits`                            | The resources limits for the Logstash container                                                                                  | `{}`                        |
| `resources.requests`                          | The requested resources for the Logstash container                                                                               | `{}`                        |
| `livenessProbe.httpGet.path`                  | Request path for livenessProbe                                                                                                   | `/`                         |
| `livenessProbe.httpGet.port`                  | Port for livenessProbe                                                                                                           | `monitoring`                |
| `livenessProbe.initialDelaySeconds`           | Initial delay seconds for livenessProbe                                                                                          | `60`                        |
| `livenessProbe.periodSeconds`                 | Period seconds for livenessProbe                                                                                                 | `10`                        |
| `livenessProbe.timeoutSeconds`                | Timeout seconds for livenessProbe                                                                                                | `5`                         |
| `livenessProbe.failureThreshold`              | Failure threshold for livenessProbe                                                                                              | `6`                         |
| `livenessProbe.successThreshold`              | Success threshold for livenessProbe                                                                                              | `1`                         |
| `readinessProbe.httpGet.path`                 | Request path for readinessProbe                                                                                                  | `/`                         |
| `readinessProbe.httpGet.port`                 | Port for readinessProbe                                                                                                          | `monitoring`                |
| `readinessProbe.initialDelaySeconds`          | Initial delay seconds for readinessProbe                                                                                         | `60`                        |
| `readinessProbe.periodSeconds`                | Period seconds for readinessProbe                                                                                                | `10`                        |
| `readinessProbe.timeoutSeconds`               | Timeout seconds for readinessProbe                                                                                               | `5`                         |
| `readinessProbe.failureThreshold`             | Failure threshold for readinessProbe                                                                                             | `6`                         |
| `readinessProbe.successThreshold`             | Success threshold for readinessProbe                                                                                             | `1`                         |
| `lifecycle`                                   | Logstash pods' lifecycle hooks                                                                                                   | `{}`                        |
| `service.type`                                | Kubernetes service type (`ClusterIP`, `NodePort`, or `LoadBalancer`)                                                             | `ClusterIP`                 |
| `service.ports.http`                          | Logstash svc ports                                                                                                               | `{}`                        |
| `service.loadBalancerIP`                      | loadBalancerIP if service type is `LoadBalancer`                                                                                 | `""`                        |
| `service.loadBalancerSourceRanges`            | Addresses that are allowed when service is LoadBalancer                                                                          | `[]`                        |
| `service.externalTrafficPolicy`               | External traffic policy, configure to Local to preserve client source IP when using an external loadBalancer                     | `""`                        |
| `service.clusterIP`                           | Static clusterIP or None for headless services                                                                                   | `""`                        |
| `service.annotations`                         | Annotations for Logstash service                                                                                                 | `{}`                        |
| `persistence.enabled`                         | Enable Logstash data persistence using PVC                                                                                       | `false`                     |
| `persistence.existingClaim`                   | A manually managed Persistent Volume and Claim                                                                                   | `""`                        |
| `persistence.storageClass`                    | PVC Storage Class for Logstash data volume                                                                                       | `""`                        |
| `persistence.accessModes`                     | PVC Access Mode for Logstash data volume                                                                                         | `["ReadWriteOnce"]`         |
| `persistence.size`                            | PVC Storage Request for Logstash data volume                                                                                     | `2Gi`                       |
| `persistence.annotations`                     | Annotations for the PVC                                                                                                          | `{}`                        |
| `persistence.mountPath`                       | Mount path of the Logstash data volume                                                                                           | `/bitnami/logstash/data`    |
| `volumePermissions.enabled`                   | Enable init container that changes the owner and group of the persistent volume(s) mountpoint to `runAsUser:fsGroup`             | `false`                     |
| `volumePermissions.securityContext.runAsUser` | User ID for the volumePermissions init container                                                                                 | `0`                         |
| `volumePermissions.image.registry`            | Init container volume-permissions image registry                                                                                 | `docker.io`                 |
| `volumePermissions.image.repository`          | Init container volume-permissions image repository                                                                               | `bitnami/bitnami-shell`     |
| `volumePermissions.image.tag`                 | Init container volume-permissions image tag (immutable tags are recommended)                                                     | `10-debian-10-r259`         |
| `volumePermissions.image.pullPolicy`          | Init container volume-permissions image pull policy                                                                              | `IfNotPresent`              |
| `volumePermissions.image.pullSecrets`         | Specify docker-registry secret names as an array                                                                                 | `[]`                        |
| `volumePermissions.resources.limits`          | Init container volume-permissions resource limits                                                                                | `{}`                        |
| `volumePermissions.resources.requests`        | Init container volume-permissions resource requests                                                                              | `{}`                        |
| `ingress.enabled`                             | Enable ingress controller resource                                                                                               | `false`                     |
| `ingress.pathType`                            | Ingress Path type                                                                                                                | `ImplementationSpecific`    |
| `ingress.apiVersion`                          | Override API Version (automatically detected if not set)                                                                         | `""`                        |
| `ingress.hostname`                            | Default host for the ingress resource                                                                                            | `logstash.local`            |
| `ingress.path`                                | The Path to Logstash. You may need to set this to '/*' in order to use this with ALB ingress controllers.                        | `/`                         |
| `ingress.annotations`                         | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                        |
| `ingress.tls`                                 | Enable TLS configuration for the hostname defined at ingress.hostname parameter                                                  | `false`                     |
| `ingress.extraHosts`                          | The list of additional hostnames to be covered with this ingress record.                                                         | `[]`                        |
| `ingress.extraPaths`                          | Any additional arbitrary paths that may need to be added to the ingress under the main host.                                     | `[]`                        |
| `ingress.extraTls`                            | The tls configuration for additional hostnames to be covered with this ingress record.                                           | `[]`                        |
| `ingress.secrets`                             | If you're providing your own certificates, please use this to add the certificates as secrets                                    | `[]`                        |
| `metrics.enabled`                             | Enable the export of Prometheus metrics                                                                                          | `false`                     |
| `metrics.image.registry`                      | Logstash Relay image registry                                                                                                    | `docker.io`                 |
| `metrics.image.repository`                    | Logstash Relay image repository                                                                                                  | `bitnami/logstash-exporter` |
| `metrics.image.tag`                           | Logstash Relay image tag (immutable tags are recommended)                                                                        | `7.3.0-debian-10-r360`      |
| `metrics.image.pullPolicy`                    | Logstash Relay image pull policy                                                                                                 | `IfNotPresent`              |
| `metrics.image.pullSecrets`                   | Specify docker-registry secret names as an array                                                                                 | `[]`                        |
| `metrics.resources.limits`                    | The resources limits for the Logstash Prometheus Exporter container                                                              | `{}`                        |
| `metrics.resources.requests`                  | The requested resources for the Logstash Prometheus Exporter container                                                           | `{}`                        |
| `metrics.serviceMonitor.enabled`              | if `true`, creates a Prometheus Operator ServiceMonitor (also requires `metrics.enabled` to be `true`)                           | `false`                     |
| `metrics.serviceMonitor.namespace`            | Namespace in which Prometheus is running                                                                                         | `""`                        |
| `metrics.serviceMonitor.interval`             | Interval at which metrics should be scraped.                                                                                     | `""`                        |
| `metrics.serviceMonitor.scrapeTimeout`        | Timeout after which the scrape is ended                                                                                          | `""`                        |
| `metrics.serviceMonitor.selector`             | ServiceMonitor selector labels                                                                                                   | `{}`                        |
| `metrics.livenessProbe.httpGet.path`          | Request path for livenessProbe                                                                                                   | `/metrics`                  |
| `metrics.livenessProbe.httpGet.port`          | Port for livenessProbe                                                                                                           | `metrics`                   |
| `metrics.livenessProbe.initialDelaySeconds`   | Initial delay seconds for livenessProbe                                                                                          | `60`                        |
| `metrics.livenessProbe.periodSeconds`         | Period seconds for readinessProbe                                                                                                | `10`                        |
| `metrics.livenessProbe.timeoutSeconds`        | Timeout seconds for readinessProbe                                                                                               | `5`                         |
| `metrics.livenessProbe.failureThreshold`      | Failure threshold for readinessProbe                                                                                             | `6`                         |
| `metrics.livenessProbe.successThreshold`      | Success threshold for readinessProbe                                                                                             | `1`                         |
| `metrics.readinessProbe.httpGet.path`         | Request path for readinessProbe                                                                                                  | `/metrics`                  |
| `metrics.readinessProbe.httpGet.port`         | Port for readinessProbe                                                                                                          | `metrics`                   |
| `metrics.readinessProbe.initialDelaySeconds`  | Initial delay seconds for readinessProbe                                                                                         | `60`                        |
| `metrics.readinessProbe.periodSeconds`        | Period seconds for readinessProbe                                                                                                | `10`                        |
| `metrics.readinessProbe.timeoutSeconds`       | Timeout seconds for readinessProbe                                                                                               | `5`                         |
| `metrics.readinessProbe.failureThreshold`     | Failure threshold for readinessProbe                                                                                             | `6`                         |
| `metrics.readinessProbe.successThreshold`     | Success threshold for readinessProbe                                                                                             | `1`                         |
| `metrics.service.type`                        | Kubernetes service type (`ClusterIP`, `NodePort` or `LoadBalancer`)                                                              | `ClusterIP`                 |
| `metrics.service.port`                        | Logstash Prometheus port                                                                                                         | `9198`                      |
| `metrics.service.nodePort`                    | Kubernetes HTTP node port                                                                                                        | `""`                        |
| `metrics.service.loadBalancerIP`              | loadBalancerIP if service type is `LoadBalancer`                                                                                 | `""`                        |
| `metrics.service.loadBalancerSourceRanges`    | Addresses that are allowed when service is LoadBalancer                                                                          | `[]`                        |
| `metrics.service.clusterIP`                   | Static clusterIP or None for headless services                                                                                   | `""`                        |
| `metrics.service.annotations`                 | Annotations for the Prometheus metrics service                                                                                   | `{}`                        |
| `podDisruptionBudget.create`                  | If true, create a pod disruption budget for pods.                                                                                | `false`                     |
| `podDisruptionBudget.minAvailable`            | Minimum number / percentage of pods that should remain scheduled                                                                 | `1`                         |
| `podDisruptionBudget.maxUnavailable`          | Maximum number / percentage of pods that may be made unavailable                                                                 | `""`                        |
| `initContainers`                              | Extra containers to run before logstash for initialization purposes like custom plugin install.                                  | `[]`                        |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install my-release \
  --set enableMonitoringAPI=false bitnami/logstash
```

The above command disables the Logstash Monitoring API.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
$ helm install my-release -f values.yaml bitnami/logstash
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling vs Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Expose the Logstash service

The service(s) created by the deployment can be exposed within or outside the cluster using any of the following approaches:

- **Ingress**: Set `ingress.enabled=true` to expose Logstash through Ingress.
- **ClusterIP**: Set `service.type=ClusterIP` to choose this service type.
- **NodePort**: Set `service.type=NodePort` to choose this service type.
- **LoadBalancer**: Set `service.type=LoadBalancer` to choose this service type.

For more information, refer to the [chart documentation on exposing the Logstash service](https://docs.bitnami.com/kubernetes/apps/logstash/get-started/expose-service/).

### Use custom configuration

By default, this Helm chart provides a basic configuration for Logstash: listening to HTTP requests on port 8080 and writing them to the standard output.

This Logstash configuration can be adjusted using the *input*, *filter*, and *output* parameters, which allow specification of the input, filter and output plugins configuration respectively. In addition to these options, the chart also supports reading configuration from an external ConfigMap via the *existingConfiguration* parameter.

Refer to the [chart documentation for more information on customizing the Logstash deployment](https://docs.bitnami.com/kubernetes/apps/logstash/configuration/customize-deployment/).

### Create and use multiple pipelines

The chart supports the use of [multiple pipelines](https://www.elastic.co/guide/en/logstash/master/multiple-pipelines.html) by setting the *enableMultiplePipelines* parameter to *true*.

To do this, place the *pipelines.yml* file in the *files/conf* directory, together with the rest of the desired configuration files. If the *enableMultiplePipelines* parameter is set to *true* but the *pipelines.yml* file does not exist in the mounted volume, a dummy file is created using the default configuration (a single pipeline).

The chart also supports setting an external ConfigMap with all the configuration files via the *existingConfiguration* parameter.

For more information and an example, refer to the chart documentation on [using multiple pipelines](https://docs.bitnami.com/kubernetes/apps/logstash/configuration/use-multiple-pipelines/).

### Add extra environment variables

To add extra environment variables, use the `extraEnvVars` property.

```yaml
extraEnvVars:
  - name: ELASTICSEARCH_HOST
    value: "x.y.z"
```

To add extra environment variables from an external ConfigMap or secret, use the `extraEnvVarsCM` and `extraEnvVarsSecret` properties. Note that the secret and ConfigMap should be already available in the namespace.

```yaml
extraEnvVarsSecret: logstash-secrets
extraEnvVarsCM: logstash-configmap
```

### Set Pod affinity

This chart allows you to set custom Pod affinity using the `affinity` parameter. Find more information about Pod affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, use one of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

## Persistence

The [Bitnami Logstash](https://github.com/bitnami/bitnami-docker-logstash) image stores the Logstash data at the `/bitnami/logstash/data` path of the container.

Persistent Volume Claims (PVCs) are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.

See the [Parameters](#parameters) section to configure the PVC or to disable persistence.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami’s Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 3.0.0

This version standardizes the way of defining Ingress rules. When configuring a single hostname for the Ingress rule, set the `ingress.hostname` value. When defining more than one, set the `ingress.extraHosts` array. Apart from this case, no issues are expected to appear when upgrading.

### To 2.0.0

This version drops support of including files in the `files/` folder, as it was working only under certain circumstances and the chart already provides alternative mechanisms like the `input` , `output` and `filter`, the `existingConfiguration` or the `extraDeploy` values.

### To 1.2.0

This version introduces `bitnami/common`, a [library chart](https://helm.sh/docs/topics/library_charts/#helm) as a dependency. More documentation about this new utility could be found [here](https://github.com/bitnami/charts/tree/master/bitnami/common#bitnami-common-library-chart). Please, make sure that you have updated the chart dependencies before executing any upgrade.

### To 1.0.0

[On November 13, 2020, Helm v2 support formally ended](https://github.com/helm/charts#status-of-the-project). Subsequently, a major version of the chart was released to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

[Learn more about this change and related upgrade considerations](https://docs.bitnami.com/kubernetes/apps/logstash/administration/upgrade-helm3/).

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
