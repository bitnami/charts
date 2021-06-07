# Kibana

[Kibana](https://kibana.com/) is an open source, browser based analytics and search dashboard for Elasticsearch.

## TL;DR

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/kibana --set elasticsearch.hosts[0]=<Hostname of your ES instance> --set elasticsearch.port=<port of your ES instance>
```

## Introduction

This chart bootstraps a [kibana](https://github.com/bitnami/bitnami-docker-kibana) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.12+
- Helm 3.1.0
- PV provisioner support in the underlying infrastructure
- ReadWriteMany volumes for deployment scaling

## Installing the Chart

This chart requires a Elasticsearch instance to work. You can use an already existing Elasticsearch instance.

 To install the chart with the release name `my-release`:

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release \
  --set elasticsearch.hosts[0]=<Hostname of your ES instance> \
  --set elasticsearch.port=<port of your ES instance> \
  bitnami/kibana
```

These commands deploy kibana on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` statefulset:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release. Use the option `--purge` to delete all history too.

## Parameters

The following tables lists the configurable parameters of the kibana chart and their default values.

| Parameter                              | Description                                                                                                                                                                                                                                                                                                    | Default                                                                                                 |
|----------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------|
| `global.imageRegistry`                 | Global Docker image registry                                                                                                                                                                                                                                                                                   | `nil`                                                                                                   |
| `global.imagePullSecrets`              | Global Docker registry secret names as an array                                                                                                                                                                                                                                                                | `[]` (does not add image pull secrets to deployed pods)                                                 |
| `global.storageClass`                  | Global storage class for dynamic provisioning                                                                                                                                                                                                                                                                  | `nil`                                                                                                   |
| `image.registry`                       | Kibana image registry                                                                                                                                                                                                                                                                                          | `docker.io`                                                                                             |
| `image.repository`                     | Kibana image name                                                                                                                                                                                                                                                                                              | `bitnami/kibana`                                                                                        |
| `image.tag`                            | Kibana image tag                                                                                                                                                                                                                                                                                               | `{TAG_NAME}`                                                                                            |
| `image.pullPolicy`                     | Kibana image pull policy                                                                                                                                                                                                                                                                                       | `IfNotPresent`                                                                                          |
| `image.pullSecrets`                    | Specify docker-registry secret names as an array                                                                                                                                                                                                                                                               | `[]` (does not add image pull secrets to deployed pods)                                                 |
| `nameOverride`                         | String to partially override common.names.fullname template with a string (will prepend the release name)                                                                                                                                                                                                      | `nil`                                                                                                   |
| `fullnameOverride`                     | String to fully override common.names.fullname template with a string                                                                                                                                                                                                                                          | `nil`                                                                                                   |
| `replicaCount`                         | Number of replicas of the Kibana Pod                                                                                                                                                                                                                                                                           | `1`                                                                                                     |
| `updateStrategy`                       | Update strategy for deployment (evaluated as a template)                                                                                                                                                                                                                                                       | `{type: "RollingUpdate"}`                                                                               |
| `schedulerName`                        | Alternative scheduler                                                                                                                                                                                                                                                                                          | `nil`                                                                                                   |
| `plugins`                              | Array containing the Kibana plugins to be installed in deployment                                                                                                                                                                                                                                              | `[]`                                                                                                    |
| `savedObjects.urls`                    | Array containing links to NDJSON files to be imported during Kibana initialization                                                                                                                                                                                                                             | `[]`                                                                                                    |
| `savedObjects.configmap`               | Configmap containing NDJSON files to be imported during Kibana initialization (evaluated as a template)                                                                                                                                                                                                        | `[]`                                                                                                    |
| `hostAliases`                          | Add deployment host aliases                                                                                                                                                                                                                                                                                    | `[]`                                                                                                    |
| `extraConfiguration`                   | Extra settings to be added to the default kibana.yml configmap that the chart creates (unless replaced using `configurationCM`). Evaluated as a template                                                                                                                                                       | `nil`                                                                                                   |
| `configurationCM`                      | ConfigMap containing a kibana.yml file that will replace the default one specified in configuration.yaml                                                                                                                                                                                                       | `nil`                                                                                                   |
| `extraEnvVars`                         | Array containing extra env vars to configure Kibana                                                                                                                                                                                                                                                            | `nil`                                                                                                   |
| `extraEnvVarsCM`                       | ConfigMap containing extra env vars to configure Kibana                                                                                                                                                                                                                                                        | `nil`                                                                                                   |
| `extraEnvVarsSecret`                   | Secret containing extra env vars to configure Kibana (in case of sensitive data)                                                                                                                                                                                                                               | `nil`                                                                                                   |
| `extraVolumes`                         | Array of extra volumes to be added to the Kibana deployment (evaluated as template). Requires setting `extraVolumeMounts`                                                                                                                                                                                      | `nil`                                                                                                   |
| `extraVolumeMounts`                    | Array of extra volume mounts to be added to the Kibana deployment (evaluated as template). Normally used with `extraVolumes`.                                                                                                                                                                                  | `nil`                                                                                                   |
| `volumePermissions.enabled`            | Enable init container that changes volume permissions in the data directory (for cases where the default k8s `runAsUser` and `fsUser` values do not work)                                                                                                                                                      | `false`                                                                                                 |
| `volumePermissions.image.registry`     | Init container volume-permissions image registry                                                                                                                                                                                                                                                               | `docker.io`                                                                                             |
| `volumePermissions.image.repository`   | Init container volume-permissions image name                                                                                                                                                                                                                                                                   | `bitnami/bitnami-shell`                                                                                 |
| `volumePermissions.image.tag`          | Init container volume-permissions image tag                                                                                                                                                                                                                                                                    | `"10"`                                                                                                  |
| `volumePermissions.image.pullPolicy`   | Init container volume-permissions image pull policy                                                                                                                                                                                                                                                            | `Always`                                                                                                |
| `volumePermissions.resources`          | Init container resource requests/limit                                                                                                                                                                                                                                                                         | `nil`                                                                                                   |
| `persistence.enabled`                  | Enable persistence                                                                                                                                                                                                                                                                                             | `true`                                                                                                  |
| `presistence.storageClass`             | Storage class to use with the PVC                                                                                                                                                                                                                                                                              | `nil`                                                                                                   |
| `persistence.accessMode`               | Access mode to the PV                                                                                                                                                                                                                                                                                          | `ReadWriteOnce`                                                                                         |
| `persistence.size`                     | Size for the PV                                                                                                                                                                                                                                                                                                | `10Gi`                                                                                                  |
| `livenessProbe.enabled`                | Enable/disable the Liveness probe                                                                                                                                                                                                                                                                              | `true`                                                                                                  |
| `livenessProbe.initialDelaySeconds`    | Delay before liveness probe is initiated                                                                                                                                                                                                                                                                       | `60`                                                                                                    |
| `livenessProbe.periodSeconds`          | How often to perform the probe                                                                                                                                                                                                                                                                                 | `10`                                                                                                    |
| `livenessProbe.timeoutSeconds`         | When the probe times out                                                                                                                                                                                                                                                                                       | `5`                                                                                                     |
| `livenessProbe.successThreshold`       | Minimum consecutive successes for the probe to be considered successful after having failed.                                                                                                                                                                                                                   | `1`                                                                                                     |
| `livenessProbe.failureThreshold`       | Minimum consecutive failures for the probe to be considered failed after having succeeded.                                                                                                                                                                                                                     | `6`                                                                                                     |
| `readinessProbe.enabled`               | Enable/disable the Readiness probe                                                                                                                                                                                                                                                                             | `true`                                                                                                  |
| `readinessProbe.initialDelaySeconds`   | Delay before readiness probe is initiated                                                                                                                                                                                                                                                                      | `5`                                                                                                     |
| `readinessProbe.periodSeconds`         | How often to perform the probe                                                                                                                                                                                                                                                                                 | `10`                                                                                                    |
| `readinessProbe.timeoutSeconds`        | When the probe times out                                                                                                                                                                                                                                                                                       | `5`                                                                                                     |
| `readinessProbe.failureThreshold`      | Minimum consecutive failures for the probe to be considered failed after having succeeded.                                                                                                                                                                                                                     | `6`                                                                                                     |
| `readinessProbe.successThreshold`      | Minimum consecutive successes for the probe to be considered successful after having failed.                                                                                                                                                                                                                   | `1`                                                                                                     |
| `service.type`                         | Kubernetes Service type                                                                                                                                                                                                                                                                                        | `ClusterIP`                                                                                             |
| `service.nodePort`                     | Port to bind to for NodePort service type (client port)                                                                                                                                                                                                                                                        | `nil`                                                                                                   |
| `service.annotations`                  | Annotations for Kibana service (evaluated as a template)                                                                                                                                                                                                                                                       | `{}`                                                                                                    |
| `service.externalTrafficPolicy`        | Enable client source IP preservation                                                                                                                                                                                                                                                                           | `Cluster`                                                                                               |
| `service.loadBalancerIP`               | loadBalancerIP if Kibana service type is `LoadBalancer`                                                                                                                                                                                                                                                        | `nil`                                                                                                   |
| `service.extraPorts`                   | Extra ports to expose in the service (normally used with the `sidecar` value). Evaluated as a template.                                                                                                                                                                                                        | `nil`                                                                                                   |
| `forceInitScripts`                     | Force the execution of the init scripts located in `/docker-entrypoint-initdb.d`                                                                                                                                                                                                                               | `false`                                                                                                 |
| `initScriptsCM`                        | ConfigMap containing `/docker-entrypoint-initdb.d` scripts to be executed at initialization time (evaluated as a template)                                                                                                                                                                                     | `nil`                                                                                                   |
| `initScriptsSecret`                    | Secret containing `/docker-entrypoint-initdb.d` scripts to be executed at initialization time (that contain sensitive data). Evaluated as a template.                                                                                                                                                          | `nil`                                                                                                   |
| `ingress.enabled`                      | Enable ingress controller resource                                                                                                                                                                                                                                                                             | `false`                                                                                                 |
| `ingress.certManager`                  | Add annotations for cert-manager                                                                                                                                                                                                                                                                               | `false`                                                                                                 |
| `ingress.hostname`                     | Default host for the ingress resource.  If specified as "*" no host rule is configured.                                                                                                                                                                                                                        | `kibana.local`                                                                                          |
| `ingress.path`                         | Default path for the ingress resource                                                                                                                                                                                                                                                                          | `/`                                                                                                     |
| `ingress.tls`                          | Create TLS Secret                                                                                                                                                                                                                                                                                              | `false`                                                                                                 |
| `ingress.annotations`                  | Ingress annotations                                                                                                                                                                                                                                                                                            | `[]` (evaluated as a template)                                                                          |
| `ingress.extraHosts[0].name`           | Additional hostnames to be covered                                                                                                                                                                                                                                                                             | `nil`                                                                                                   |
| `ingress.extraHosts[0].path`           | Additional hostnames to be covered                                                                                                                                                                                                                                                                             | `nil`                                                                                                   |
| `ingress.extraPaths`                   | Additional arbitrary path/backend objects                                                                                                                                                                                                                                                                      | `nil`                                                                                                   |
| `ingress.extraTls[0].hosts[0]`         | TLS configuration for additional hostnames to be covered                                                                                                                                                                                                                                                       | `nil`                                                                                                   |
| `ingress.extraTls[0].secretName`       | TLS configuration for additional hostnames to be covered                                                                                                                                                                                                                                                       | `nil`                                                                                                   |
| `ingress.secrets[0].name`              | TLS Secret Name                                                                                                                                                                                                                                                                                                | `nil`                                                                                                   |
| `ingress.secrets[0].certificate`       | TLS Secret Certificate                                                                                                                                                                                                                                                                                         | `nil`                                                                                                   |
| `ingress.secrets[0].key`               | TLS Secret Key                                                                                                                                                                                                                                                                                                 | `nil`                                                                                                   |
| `securityContext.enabled`              | Enable securityContext on for Kibana deployment                                                                                                                                                                                                                                                                | `true`                                                                                                  |
| `securityContext.runAsUser`            | User for the security context                                                                                                                                                                                                                                                                                  | `1001`                                                                                                  |
| `securityContext.fsGroup`              | Group to configure permissions for volumes                                                                                                                                                                                                                                                                     | `1001`                                                                                                  |
| `containerPort`                        | Port to expose at container level                                                                                                                                                                                                                                                                              | `5601`                                                                                                  |
| `resources`                            | Configure resource requests and limits (evaluated as a template)                                                                                                                                                                                                                                               | `nil`                                                                                                   |
| `podAffinityPreset`                    | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                                                                                                            | `""`                                                                                                    |
| `podAntiAffinityPreset`                | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                                                                                                       | `soft`                                                                                                  |
| `nodeAffinityPreset.type`              | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                                                                                                      | `""`                                                                                                    |
| `nodeAffinityPreset.key`               | Node label key to match Ignored if `affinity` is set.                                                                                                                                                                                                                                                          | `""`                                                                                                    |
| `nodeAffinityPreset.values`            | Node label values to match. Ignored if `affinity` is set.                                                                                                                                                                                                                                                      | `[]`                                                                                                    |
| `affinity`                             | Affinity for pod assignment                                                                                                                                                                                                                                                                                    | `{}` (evaluated as a template)                                                                          |
| `nodeSelector`                         | Node labels for pod assignment                                                                                                                                                                                                                                                                                 | `{}` (evaluated as a template)                                                                          |
| `tolerations`                          | Tolerations for pod assignment                                                                                                                                                                                                                                                                                 | `[]` (evaluated as a template)                                                                          |
| `podAnnotations`                       | Pod annotations (evaluated as a template)                                                                                                                                                                                                                                                                      | `{}`                                                                                                    |
| `podLabels`                            | Extra labels to add to Pod                                                                                                                                                                                                                                                                                     | `{}`                                                                                                    |
| `sidecars`                             | Attach additional containers to the pod (evaluated as a template)                                                                                                                                                                                                                                              | `nil`                                                                                                   |
| `initContainers`                       | Add additional init containers to the pod (evaluated as a template)                                                                                                                                                                                                                                            | `nil`                                                                                                   |
| `metrics.enabled`                      | Start a side-car prometheus exporter                                                                                                                                                                                                                                                                           | `false`                                                                                                 |
| `metrics.service.annotations`          | Prometheus annotations for the Kibana service                                                                                                                                                                                                                                                                  | `{ prometheus.io/scrape: "true", prometheus.io/port: "80", prometheus.io/path: "_prometheus/metrics" }` |
| `metrics.serviceMonitor.enabled`       | if `true`, creates a Prometheus Operator ServiceMonitor (also requires `metrics.enabled` to be `true`)                                                                                                                                                                                                         | `false`                                                                                                 |
| `metrics.serviceMonitor.namespace`     | Namespace in which Prometheus is running                                                                                                                                                                                                                                                                       | `nil`                                                                                                   |
| `metrics.serviceMonitor.interval`      | Interval at which metrics should be scraped.                                                                                                                                                                                                                                                                   | `nil` (Prometheus Operator default value)                                                               |
| `metrics.serviceMonitor.scrapeTimeout` | Timeout after which the scrape is ended                                                                                                                                                                                                                                                                        | `nil` (Prometheus Operator default value)                                                               |
| `metrics.serviceMonitor.selector`      | Prometheus instance selector labels                                                                                                                                                                                                                                                                            | `nil`                                                                                                   |
| `elasticsearch.hosts`                  | Array containing the hostnames for the already existing Elasticsearch instances                                                                                                                                                                                                                                | `nil`                                                                                                   |
| `elasticsearch.port`                   | Port for the accessing external Elasticsearch instances                                                                                                                                                                                                                                                        | `nil`                                                                                                   |
| `elasticsearch.tls`                    | Is elasticsearch run with tls support                                                                                                                                                                                                                                                                          | `false`                                                                                                 |
| `configuration.server.basePath`        | Enables you to specify a path to mount Kibana at if you are running behind a proxy. Use the `configuration.server.rewriteBasePath` setting to tell Kibana if it should remove the basePath from requests it receives, and to prevent a deprecation warning at startup. This setting cannot end in a slash (/). | `""`                                                                                                    |
| `configuration.server.rewriteBasePath` | Specifies whether Kibana should rewrite requests that are prefixed with server.basePath or require that they are rewritten by your reverse proxy. This setting was effectively always false before Kibana 6.3 and will default to true starting in Kibana 7.0.                                                 | `false`                                                                                                 |
| `kubeVersion`                          | Force target Kubernetes version (using Helm capabilities if not set)                                                                                                                                                                                                                                           | `nil`                                                                                                   |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install my-release \
  --set admin.user=admin-user bitnami/kibana
```

The above command sets the Kibana admin user to `admin-user`.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
$ helm install my-release -f values.yaml bitnami/kibana
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Change Kibana version

To modify the Kibana version used in this chart you can specify a [valid image tag](https://hub.docker.com/r/bitnami/kibana/tags/) using the `image.tag` parameter. For example, `image.tag=X.Y.Z`. This approach is also applicable to other images like exporters.

### Using custom configuration

The Bitnami Kibana chart supports using custom configuration settings. For example, to mount a custom `kibana.yml` you can create a ConfigMap like the following:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: myconfig
data:
  kibana.yml: |-
    # Raw text of the file
```

And now you need to pass the ConfigMap name, to the corresponding parameter: `configurationCM=myconfig`

An alternative is to provide extra configuration settings to the default kibana.yml that the chart deploys. This is done using the `extraConfiguration` value:

```yaml
extraConfiguration:
  "server.maxPayloadBytes": 1048576
  "server.pingTimeout": 1500
```

### Adding extra environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `extraEnvVars` property.

```yaml
extraEnvVars:
  - name: ELASTICSEARCH_VERSION
    value: 6
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values.

### Using custom init scripts

For advanced operations, the Bitnami Kibana charts allows using custom init scripts that will be mounted in `/docker-entrypoint.init-db`. You can use a ConfigMap or a Secret (in case of sensitive data) for mounting these extra scripts. Then use the `initScriptsCM` and `initScriptsSecret` values.

```console
elasticsearch.hosts[0]=elasticsearch-host
elasticsearch.port=9200
initScriptsCM=special-scripts
initScriptsSecret=special-scripts-sensitive
```

### Installing plugins

The Bitnami Kibana chart allows you to install a set of plugins at deployment time using the `plugins` value:

```console
elasticsearch.hosts[0]=elasticsearch-host
elasticsearch.port=9200
plugins[0]=https://github.com/fbaligand/kibana-enhanced-table/releases/download/v1.5.0/enhanced-table-1.5.0_7.3.2.zip
```

> **NOTE** Make sure that the plugin is available for the Kibana version you are deploying

### Importing saved objects

If you have visualizations and dashboards (in NDJSON format) that you want to import to Kibana. You can create a ConfigMap that includes them and then install the chart with the `savedObjects.configmap` value: `savedObjects.configmap=my-import`

Alternatively, if it is available via URL, you can install the chart as follows: `savedObjects.urls[0]=www.my-site.com/import.ndjson`

### Sidecars and Init Containers

If you have a need for additional containers to run within the same pod as Kibana (e.g. an additional metrics or logging exporter), you can do so via the `sidecars` config parameter. Simply define your container according to the Kubernetes container spec.

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

#### Add a sample Elasticsearch container as sidecar

This chart requires an Elasticsearch instance to work. For production, you can use an already existing Elasticsearch instance or deploy the [Elasticsearch chart](https://github.com/bitnami/charts/tree/master/bitnami/elasticsearch) with the [`global.kibanaEnabled=true` parameter](https://github.com/bitnami/charts/tree/master/bitnami/elasticsearch#enable-bundled-kibana).

For the purpose of testing, you can use a sidecar Elasticsearch container setting the following parameters during the Kibana chart installation:

```
elasticsearch.hosts[0]=localhost
elasticsearch.port=9200
sidecars[0].name=elasticsearch
sidecars[0].image=bitnami/elasticsearch:latest
sidecars[0].imagePullPolicy=IfNotPresent
sidecars[0].ports[0].name=http
sidecars[0].ports[0].containerPort=9200
```

### Setting Pod's affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

## Persistence

The [Bitnami Kibana](https://github.com/bitnami/bitnami-docker-kibana) image can persist data. If enabled, the persisted path is `/bitnami/kibana` by default.

The chart mounts a [Persistent Volume](http://kubernetes.io/docs/user-guide/persistent-volumes/) at this location. The volume is created using dynamic volume provisioning.

### Adding extra volumes

The Bitnami Kibana chart supports mounting extra volumes (either PVCs, secrets or configmaps) by using the `extraVolumes` and `extraVolumeMounts` property. This can be combined with advanced operations like adding extra init containers and sidecars.

### Adjust permissions of persistent volume mountpoint

As the image run as non-root by default, it is necessary to adjust the ownership of the persistent volume so that the container can write data into it.

By default, the chart is configured to use Kubernetes Security Context to automatically change the ownership of the volume. However, this feature does not work in all Kubernetes distributions.
As an alternative, this chart supports using an initContainer to change the ownership of the volume before mounting it in the final destination.

You can enable this initContainer by setting `volumePermissions.enabled` to `true`.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami’s Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 8.0.0

The Kibana container configuration logic was migrated to bash.

From this version onwards, Kibana container components are now licensed under the [Elastic License](https://www.elastic.co/licensing/elastic-license) that is not currently accepted as an Open Source license by the Open Source Initiative (OSI).

Also, from now on, the Helm Chart will include the X-Pack plugin installed by default.

Regular upgrade is compatible from previous versions.

### To 6.2.0

This version introduces `bitnami/common`, a [library chart](https://helm.sh/docs/topics/library_charts/#helm) as a dependency. More documentation about this new utility could be found [here](https://github.com/bitnami/charts/tree/master/bitnami/common#bitnami-common-library-chart). Please, make sure that you have updated the chart dependencies before executing any upgrade.

### To 6.0.0

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

### To 5.0.0

This version does not include Elasticsearch as a bundled dependency. From now on, you should specify an external Elasticsearch instance using the `elasticsearch.hosts[]` and `elasticsearch.port` [parameters](#parameters).

### To 3.0.0

Helm performs a lookup for the object based on its group (apps), version (v1), and kind (Deployment). Also known as its GroupVersionKind, or GVK. Changing the GVK is considered a compatibility breaker from Kubernetes' point of view, so you cannot "upgrade" those objects to the new GVK in-place. Earlier versions of Helm 3 did not perform the lookup correctly which has since been fixed to match the spec.

In [4dfac075aacf74405e31ae5b27df4369e84eb0b0](https://github.com/bitnami/charts/commit/4dfac075aacf74405e31ae5b27df4369e84eb0b0) the `apiVersion` of the deployment resources was updated to `apps/v1` in tune with the api's deprecated, resulting in compatibility breakage.

This major version signifies this change.

### To 2.0.0

This version enabled by default an initContainer that modify some kernel settings to meet the Elasticsearch requirements.

Currently, Elasticsearch requires some changes in the kernel of the host machine to work as expected. If those values are not set in the underlying operating system, the ES containers fail to boot with ERROR messages. More information about these requirements can be found in the links below:

- [File Descriptor requirements](https://www.elastic.co/guide/en/elasticsearch/reference/current/file-descriptors.html)
- [Virtual memory requirements](https://www.elastic.co/guide/en/elasticsearch/reference/current/vm-max-map-count.html)

You can disable the initContainer using the `elasticsearch.sysctlImage.enabled=false` parameter.
