# Logstash

[Logstash](https://www.elastic.co/products/logstash) is an open source, server-side data processing pipeline that ingests data from a multitude of sources simultaneously, transforms it, and then sends it to your favorite "stash".

## TL;DR

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/logstash
```

## Introduction

This chart bootstraps a [logstash](https://github.com/bitnami/bitnami-docker-logstash) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

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
| `global.imageRegistry`    | Global Docker image registry                    | `nil` |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]`  |


### Common parameters

| Name               | Description                                                                              | Value           |
| ------------------ | ---------------------------------------------------------------------------------------- | --------------- |
| `kubeVersion`      | Force target Kubernetes version (using Helm capabilities if not set)                     | `nil`           |
| `nameOverride`     | String to partially override logstash.fullname template (will maintain the release name) | `nil`           |
| `fullnameOverride` | String to fully override logstash.fullname template                                      | `nil`           |
| `clusterDomain`    | Default Kubernetes cluster domain                                                        | `cluster.local` |
| `extraDeploy`      | Array of extra objects to deploy with the release (evaluated as a template).             | `nil`           |


### Logstash parameters

| Name                                          | Description                                                                                                          | Value                       |
| --------------------------------------------- | -------------------------------------------------------------------------------------------------------------------- | --------------------------- |
| `image.registry`                              | Logstash image registry                                                                                              | `docker.io`                 |
| `image.repository`                            | Logstash image repository                                                                                            | `bitnami/logstash`          |
| `image.tag`                                   | Logstash image tag (immutable tags are recommended)                                                                  | `7.13.2-debian-10-r0`       |
| `image.pullPolicy`                            | Logstash image pull policy                                                                                           | `IfNotPresent`              |
| `image.pullSecrets`                           | Specify docker-registry secret names as an array                                                                     | `[]`                        |
| `image.debug`                                 | Specify if debug logs should be enabled                                                                              | `false`                     |
| `hostAliases`                                 | Add deployment host aliases                                                                                          | `[]`                        |
| `configFileName`                              | Logstash configuration file name. It must match the name of the configuration file mounted as a configmap.           | `logstash.conf`             |
| `enableMonitoringAPI`                         | Whether to enable the Logstash Monitoring API or not  Kubernetes cluster domain                                      | `true`                      |
| `monitoringAPIPort`                           | Logstash Monitoring API Port                                                                                         | `9600`                      |
| `extraEnvVars`                                | Array containing extra env vars to configure Logstash                                                                | `nil`                       |
| `extraEnvVarsSecret`                          | To add secrets to environment                                                                                        | `nil`                       |
| `extraEnvVarsCM`                              | To add configmaps to environment                                                                                     | `nil`                       |
| `input`                                       | Input Plugins configuration                                                                                          | `""`                        |
| `filter`                                      | Filter Plugins configuration                                                                                         | `nil`                       |
| `output`                                      | Output Plugins configuration                                                                                         | `""`                        |
| `existingConfiguration`                       | Name of existing ConfigMap object with the Logstash configuration (`input`, `filter`, and `output` will be ignored). | `nil`                       |
| `enableMultiplePipelines`                     | Allows user to use multiple pipelines                                                                                | `false`                     |
| `extraVolumes`                                | Array to add extra volumes (evaluated as a template)                                                                 | `[]`                        |
| `extraVolumeMounts`                           | Array to add extra mounts (normally used with extraVolumes, evaluated as a template)                                 | `[]`                        |
| `containerPorts`                              | Array containing the ports to open in the Logstash container                                                         | `[]`                        |
| `replicaCount`                                | Number of Logstash replicas to deploy                                                                                | `1`                         |
| `updateStrategy`                              | Update strategy (`RollingUpdate`, or `OnDelete`)                                                                     | `RollingUpdate`             |
| `podManagementPolicy`                         | Pod management policy                                                                                                | `OrderedReady`              |
| `podAnnotations`                              | Pod annotations                                                                                                      | `{}`                        |
| `podAffinityPreset`                           | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                  | `""`                        |
| `podAntiAffinityPreset`                       | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                             | `soft`                      |
| `nodeAffinityPreset.type`                     | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                            | `""`                        |
| `nodeAffinityPreset.key`                      | Node label key to match. Ignored if `affinity` is set.                                                               | `""`                        |
| `nodeAffinityPreset.values`                   | Node label values to match. Ignored if `affinity` is set.                                                            | `[]`                        |
| `affinity`                                    | Affinity for pod assignment                                                                                          | `{}`                        |
| `nodeSelector`                                | Node labels for pod assignment                                                                                       | `{}`                        |
| `tolerations`                                 | Tolerations for pod assignment                                                                                       | `[]`                        |
| `priorityClassName`                           | Pod priority                                                                                                         | `nil`                       |
| `securityContext.enabled`                     | Enable security context for Logstash                                                                                 | `true`                      |
| `securityContext.fsGroup`                     | Group ID for the Logstash filesystem                                                                                 | `1001`                      |
| `securityContext.runAsUser`                   | User ID for the Logstash container                                                                                   | `1001`                      |
| `resources.limits`                            | The resources limits for the Logstash container                                                                      | `{}`                        |
| `resources.requests`                          | The requested resources for the Logstash container                                                                   | `{}`                        |
| `livenessProbe.httpGet.path`                  | Request path for livenessProbe                                                                                       | `/`                         |
| `livenessProbe.httpGet.port`                  | Port for livenessProbe                                                                                               | `monitoring`                |
| `livenessProbe.initialDelaySeconds`           | Initial delay seconds for livenessProbe                                                                              | `60`                        |
| `livenessProbe.periodSeconds`                 | Period seconds for livenessProbe                                                                                     | `nil`                       |
| `livenessProbe.timeoutSeconds`                | Timeout seconds for livenessProbe                                                                                    | `nil`                       |
| `livenessProbe.failureThreshold`              | Failure threshold for livenessProbe                                                                                  | `nil`                       |
| `livenessProbe.successThreshold`              | Success threshold for livenessProbe                                                                                  | `nil`                       |
| `readinessProbe.httpGet.path`                 | Request path for readinessProbe                                                                                      | `/`                         |
| `readinessProbe.httpGet.port`                 | Port for readinessProbe                                                                                              | `monitoring`                |
| `readinessProbe.initialDelaySeconds`          | Initial delay seconds for readinessProbe                                                                             | `60`                        |
| `readinessProbe.periodSeconds`                | Period seconds for readinessProbe                                                                                    | `nil`                       |
| `readinessProbe.timeoutSeconds`               | Timeout seconds for readinessProbe                                                                                   | `nil`                       |
| `readinessProbe.failureThreshold`             | Failure threshold for readinessProbe                                                                                 | `nil`                       |
| `readinessProbe.successThreshold`             | Success threshold for readinessProbe                                                                                 | `nil`                       |
| `lifecycle`                                   | Logstash pods' lifecycle hooks                                                                                       | `{}`                        |
| `service.type`                                | Kubernetes service type (`ClusterIP`, `NodePort`, or `LoadBalancer`)                                                 | `ClusterIP`                 |
| `service.ports.http`                          | Logstash svc ports                                                                                                   | `{}`                        |
| `service.loadBalancerIP`                      | loadBalancerIP if service type is `LoadBalancer`                                                                     | `nil`                       |
| `service.loadBalancerSourceRanges`            | Addresses that are allowed when service is LoadBalancer                                                              | `[]`                        |
| `service.externalTrafficPolicy`               | External traffic policy, configure to Local to preserve client source IP when using an external loadBalancer         | `""`                        |
| `service.clusterIP`                           | Static clusterIP or None for headless services                                                                       | `nil`                       |
| `service.annotations`                         | Annotations for Logstash service                                                                                     | `{}`                        |
| `persistence.enabled`                         | Enable Logstash data persistence using PVC                                                                           | `false`                     |
| `persistence.existingClaim`                   | A manually managed Persistent Volume and Claim                                                                       | `nil`                       |
| `persistence.storageClass`                    | PVC Storage Class for Logstash data volume                                                                           | `nil`                       |
| `persistence.accessModes`                     | PVC Access Mode for Logstash data volume                                                                             | `[]`                        |
| `persistence.size`                            | PVC Storage Request for Logstash data volume                                                                         | `2Gi`                       |
| `persistence.annotations`                     | Annotations for the PVC                                                                                              | `{}`                        |
| `persistence.mountPath`                       | Mount path of the Logstash data volume                                                                               | `/bitnami/logstash/data`    |
| `volumePermissions.enabled`                   | Enable init container that changes the owner and group of the persistent volume(s) mountpoint to `runAsUser:fsGroup` | `false`                     |
| `volumePermissions.securityContext.runAsUser` | User ID for the volumePermissions init container                                                                     | `0`                         |
| `volumePermissions.image.registry`            | Init container volume-permissions image registry                                                                     | `docker.io`                 |
| `volumePermissions.image.repository`          | Init container volume-permissions image repository                                                                   | `bitnami/bitnami-shell`     |
| `volumePermissions.image.tag`                 | Init container volume-permissions image tag (immutable tags are recommended)                                         | `10-debian-10-r107`         |
| `volumePermissions.image.pullPolicy`          | Init container volume-permissions image pull policy                                                                  | `Always`                    |
| `volumePermissions.image.pullSecrets`         | Specify docker-registry secret names as an array                                                                     | `[]`                        |
| `volumePermissions.resources.limits`          | Init container volume-permissions resource limits                                                                    | `{}`                        |
| `volumePermissions.resources.requests`        | Init container volume-permissions resource requests                                                                  | `{}`                        |
| `ingress.enabled`                             | Enable ingress controller resource                                                                                   | `false`                     |
| `ingress.certManager`                         | Set this to true in order to add the corresponding annotations for cert-manager                                      | `false`                     |
| `ingress.pathType`                            | Ingress Path type                                                                                                    | `ImplementationSpecific`    |
| `ingress.apiVersion`                          | Override API Version (automatically detected if not set)                                                             | `nil`                       |
| `ingress.hostname`                            | Default host for the ingress resource                                                                                | `logstash.local`            |
| `ingress.path`                                | The Path to Logstash. You may need to set this to '/*' in order to use this with ALB ingress controllers.            | `ImplementationSpecific`    |
| `ingress.annotations`                         | Ingress annotations                                                                                                  | `{}`                        |
| `ingress.tls`                                 | Enable TLS configuration for the hostname defined at ingress.hostname parameter                                      | `false`                     |
| `ingress.extraHosts`                          | The list of additional hostnames to be covered with this ingress record.                                             | `[]`                        |
| `ingress.extraPaths`                          | Any additional arbitrary paths that may need to be added to the ingress under the main host.                         | `[]`                        |
| `ingress.extraTls`                            | The tls configuration for additional hostnames to be covered with this ingress record.                               | `[]`                        |
| `ingress.secrets`                             | If you're providing your own certificates, please use this to add the certificates as secrets                        | `[]`                        |
| `metrics.enabled`                             | Enable the export of Prometheus metrics                                                                              | `false`                     |
| `metrics.image.registry`                      | Logstash Relay image registry                                                                                        | `docker.io`                 |
| `metrics.image.repository`                    | Logstash Relay image repository                                                                                      | `bitnami/logstash-exporter` |
| `metrics.image.tag`                           | Logstash Relay image tag (immutable tags are recommended)                                                            | `7.3.0-debian-10-r211`      |
| `metrics.image.pullPolicy`                    | Logstash Relay image pull policy                                                                                     | `IfNotPresent`              |
| `metrics.image.pullSecrets`                   | Specify docker-registry secret names as an array                                                                     | `[]`                        |
| `metrics.resources.limits`                    | The resources limits for the Logstash Prometheus Exporter container                                                  | `{}`                        |
| `metrics.resources.requests`                  | The requested resources for the Logstash Prometheus Exporter container                                               | `{}`                        |
| `metrics.serviceMonitor.enabled`              | if `true`, creates a Prometheus Operator ServiceMonitor (also requires `metrics.enabled` to be `true`)               | `false`                     |
| `metrics.serviceMonitor.namespace`            | Namespace in which Prometheus is running                                                                             | `nil`                       |
| `metrics.serviceMonitor.interval`             | Interval at which metrics should be scraped.                                                                         | `nil`                       |
| `metrics.serviceMonitor.scrapeTimeout`        | Timeout after which the scrape is ended                                                                              | `nil`                       |
| `metrics.serviceMonitor.selector`             | ServiceMonitor selector labels                                                                                       | `{}`                        |
| `metrics.livenessProbe.httpGet.path`          | Request path for livenessProbe                                                                                       | `/metrics`                  |
| `metrics.livenessProbe.httpGet.port`          | Port for livenessProbe                                                                                               | `metrics`                   |
| `metrics.livenessProbe.initialDelaySeconds`   | Initial delay seconds for livenessProbe                                                                              | `60`                        |
| `metrics.livenessProbe.periodSeconds`         | Period seconds for readinessProbe                                                                                    | `nil`                       |
| `metrics.livenessProbe.timeoutSeconds`        | Timeout seconds for readinessProbe                                                                                   | `nil`                       |
| `metrics.livenessProbe.failureThreshold`      | Failure threshold for readinessProbe                                                                                 | `nil`                       |
| `metrics.livenessProbe.successThreshold`      | Success threshold for readinessProbe                                                                                 | `nil`                       |
| `metrics.readinessProbe.httpGet.path`         | Request path for readinessProbe                                                                                      | `/metrics`                  |
| `metrics.readinessProbe.httpGet.port`         | Port for readinessProbe                                                                                              | `metrics`                   |
| `metrics.readinessProbe.initialDelaySeconds`  | Initial delay seconds for readinessProbe                                                                             | `60`                        |
| `metrics.readinessProbe.periodSeconds`        | Period seconds for readinessProbe                                                                                    | `nil`                       |
| `metrics.readinessProbe.timeoutSeconds`       | Timeout seconds for readinessProbe                                                                                   | `nil`                       |
| `metrics.readinessProbe.failureThreshold`     | Failure threshold for readinessProbe                                                                                 | `nil`                       |
| `metrics.readinessProbe.successThreshold`     | Success threshold for readinessProbe                                                                                 | `nil`                       |
| `metrics.service.type`                        | Kubernetes service type (`ClusterIP`, `NodePort` or `LoadBalancer`)                                                  | `ClusterIP`                 |
| `metrics.service.port`                        | Logstash Prometheus port                                                                                             | `9198`                      |
| `metrics.service.nodePort`                    | Kubernetes HTTP node port                                                                                            | `""`                        |
| `metrics.service.loadBalancerIP`              | loadBalancerIP if service type is `LoadBalancer`                                                                     | `nil`                       |
| `metrics.service.loadBalancerSourceRanges`    | Addresses that are allowed when service is LoadBalancer                                                              | `[]`                        |
| `metrics.service.clusterIP`                   | Static clusterIP or None for headless services                                                                       | `None`                      |
| `metrics.service.annotations`                 | Annotations for the Prometheus metrics service                                                                       | `{}`                        |
| `podDisruptionBudget.create`                  | If true, create a pod disruption budget for pods.                                                                    | `false`                     |
| `podDisruptionBudget.minAvailable`            | Minimum number / percentage of pods that should remain scheduled                                                     | `1`                         |
| `podDisruptionBudget.maxUnavailable`          | Maximum number / percentage of pods that may be made unavailable                                                     | `nil`                       |
| `initContainers`                              | Extra containers to run before logstash for initialization purposes like custom plugin install.                      | `[]`                        |


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

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Configure the way how to expose Logstash

- **Ingress**: The ingress controller must be installed in the Kubernetes cluster. Set `ingress.enabled=true` to expose Logstash through Ingress.
- **ClusterIP**: Exposes the service on a cluster-internal IP. Choosing this value makes the service only reachable from within the cluster. Set `service.type=ClusterIP` to choose this service type.
- **NodePort**: Exposes the service on each Node's IP at a static port (the NodePort). You’ll be able to contact the NodePort service, from outside the cluster, by requesting `NodeIP:NodePort`. Set `service.type=NodePort` to choose this service type.
- **LoadBalancer**: Exposes the service externally using a cloud provider's load balancer. Set `service.type=LoadBalancer` to choose this service type.

### Using custom configuration

By default, this Helm chart provides a very basic configuration for Logstash, which listen HTTP requests on port 8080 and writes them to stdout.

You can achieve any Logstash configuration by providing your custom configuration files. To do so, this helm chart supports to customize every configuration file.

You can specify the Logstash configuration using the `input`, `filter`, and `output` parameters. Each of them, allows you to specify the Input Plugins, Filter Plugins, and Output Plugins configuration, respectively.

In addition to these options, you can also set an external ConfigMap with all the configuration files. This is done by setting the `existingConfiguration` parameter. Note that this will override the two previous options.

### Using multiple pipelines

You can use [multiple pipelines](https://www.elastic.co/guide/en/logstash/master/multiple-pipelines.html) by setting the `enableMultiplePipelines` parameter to `true`.

In that case, you should place your `pipelines.yml` file in the "files/conf" directory (together with the rest of the desired configuration files). If the `enableMultiplePipelines` parameter is set to `true` but there is not any `pipelines.yml` file in the mounted volume, a dummy file is created using the default configuration file as a single pipeline.

You can also set an external ConfigMap with all the configuration files. This is done by setting the `existingConfiguration` parameter.

Find below a basic example placing the configuration files in the "files/conf" folder although the same approach can be followed by using a ConfigMap:

- ConfigMap with the configuration files:

```console
$ cat bye.conf
input {
  file {
    path => "/tmp/bye"
  }
}
output {
  stdout { }
}

$ cat hello.conf
input {
  file {
    path => "/tmp/hello"
  }
}
output {
  stdout { }
}

$ cat pipelines.yml
- pipeline.id: hello
  path.config: "/opt/bitnami/logstash/config/hello.conf"
- pipeline.id: bye
  path.config: "/opt/bitnami/logstash/config/bye.conf"

$ kubectl create cm multipleconfig --from-file=pipelines.yml --from-file=hello.conf --from-file=bye.conf
```

- Deploy the Helm Chart with the `enableMultiplePipelines` parameter:

```console
$ helm install logstash . --set enableMultiplePipelines=true --set existingConfiguration=multipleconfig

$ kubectl logs -f logstash-0
logstash 12:57:43.51 INFO  ==> ** Starting Logstash setup **
logstash 12:57:43.54 INFO  ==> Initializing Logstash server...
logstash 12:57:43.56 INFO  ==> Mounted config directory detected
logstash 12:57:43.62 INFO  ==> User's pipelines file detected.
logstash 12:57:43.63 INFO  ==> ** Logstash setup finished! **
logstash 12:57:43.64 INFO  ==> ** Starting Logstash **
logstash 12:57:43.64 INFO  ==> Starting logstash using pipelines file (pipelines.yml)
...
[2020-11-25T12:58:23,802][INFO ][logstash.javapipeline    ][bye] Pipeline started {"pipeline.id"=>"bye"}
[2020-11-25T12:58:23,810][INFO ][logstash.javapipeline    ][hello] Pipeline started {"pipeline.id"=>"hello"}
[2020-11-25T12:58:23,931][INFO ][logstash.agent           ] Pipelines running {:count=>2, :running_pipelines=>[:bye, :hello], :non_running_pipelines=>[]}
```

- According to the previous logs, both pipelines are being taken into account. Let's create some events in the tracked files and see the result in the Logstash output:
```console
$ kubectl exec -ti logstash-0 -- bash -c 'echo hi >> /tmp/hello'
$ kubectl exec -ti logstash-0 -- bash -c 'echo bye >> /tmp/bye'

$ kubectl logs -f logstash-0
...
[2020-11-25T12:58:24,535][INFO ][logstash.agent           ] Successfully started Logstash API endpoint {:port=>9600}
{
      "@version" => "1",
    "@timestamp" => 2020-11-25T12:59:39.624Z,
          "path" => "/tmp/hello",
          "host" => "logstash-0",
       "message" => "hi"
}
{
      "@version" => "1",
    "@timestamp" => 2020-11-25T12:59:54.351Z,
          "path" => "/tmp/bye",
          "host" => "logstash-0",
       "message" => "bye"
}
```
### Adding extra environment variables

In case you want to add extra environment variables from an external configmap or secrets, you can use the `extraEnvVarsCM` and `extraEnvVarsSecret` properties. Be aware that the secret and configmap should be already available in the namespace.

```yaml
extraEnvVarsSecret: logstash-secrets
extraEnvVarsCM: logstash-configmap
```

### Adding extra environment variables

In case you want to add extra environment variables, you can use the `extraEnvVars` property.

```yaml
extraEnvVars:
  - name: ELASTICSEARCH_HOST
    value: "x.y.z"
```

### Setting Pod's affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

## Persistence

The [Bitnami Logstash](https://github.com/bitnami/bitnami-docker-logstash) image stores the Logstash data at the `/bitnami/logstash/data` path of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
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
