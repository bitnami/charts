# Kibana

[Kibana](https://kibana.com/) is an open source, browser based analytics and search dashboard for Elasticsearch.

## TL;DR;

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami

# Option 1: With an existing Elasticsearch instance
$ helm install bitnami/kibana --set elasticsearch.external.hosts[0]=<Hostname of your ES instance> --set elasticsearch.external.port=<port of your ES instance>

# Option 2: With a bundled Elasticsearch instance
$ helm install bitnami/kibana --set elasticsearch.enabled=true
```

## Introduction

This chart bootstraps a [kibana](https://github.com/bitnami/bitnami-docker-kibana) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

## Installing the Chart

This chart requires a Elasticsearch instance to work. The chart offers two options:

- Use an already existing Elasticsearch instance.
- Deploy a new Elasticsearch instance together with Kibana. This is the default option when deploying the chart.

 To install the chart with the release name `my-release`:

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami

# Option 1: With an existing Elasticsearch instance
$ helm install bitnami/kibana --name my-release \
  --set elasticsearch.external.hosts[0]=<Hostname of your ES instance> \
  --set elasticsearch.external.port=<port of your ES instance>

# Option 2: With a bundled Elasticsearch instance
$ helm install bitnami/kibana --name my-release \
  --set elasticsearch.enabled=true
```

These commands deploy kibana on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` statefulset:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release. Use the option `--purge` to delete all history too.

## Configuration

The following tables lists the configurable parameters of the kibana chart and their default values.

| Parameter                                   | Description                                                                                 | Default                                                 |
| ------------------------------------------- | ------------------------------------------------------------------------------------------- | ------------------------------------------------------- |
| `global.imageRegistry`                      | Global Docker image registry                                                                | `nil`                                                   |
| `global.imagePullSecrets`                   | Global Docker registry secret names as an array                                             | `[]` (does not add image pull secrets to deployed pods) |
| `global.storageClass`                | Global storage class for dynamic provisioning                                                                                                             | `nil`                                                        |
| `image.registry`                            | Kibana image registry                                                                      | `docker.io`                                             |
| `image.repository`                          | Kibana image name                                                                          | `bitnami/kibana`                                       |
| `image.tag`                                 | Kibana image tag                                                                           | `{TAG_NAME}`                                            |
| `image.pullPolicy`                          | Kibana image pull policy                                                                   | `IfNotPresent`                                          |
| `image.pullSecrets`                         | Specify docker-registry secret names as an array                                            | `[]` (does not add image pull secrets to deployed pods) |
| `nameOverride`                              | String to partially override kibana.fullname template with a string (will prepend the release name) | `nil`                                          |
| `fullnameOverride`                          | String to fully override kibana.fullname template with a string                            | `nil`                                                   |
| `replicaCount`                               | Number of replicas of the Kibana Pod                                                       | `1`                                                     |
| `updateStrategy`                            | Update strategy for deployment (evaluated as a template)                                                             | `{type: "RollingUpdate"}`                                       |
| `schedulerName`                             | Alternative scheduler                                                                       | `nil`                                                   |
| `plugins`                                   | Array containing the Kibana plugins to be installed in deployment                       | `[]`                                                   |
| `savedObjects.urls`                                   | Array containing links to NDJSON files to be imported during Kibana initialization                       | `[]`                                                   |
| `savedObjects.configmap`                                   | Configmap containing NDJSON files to be imported during Kibana initialization (evaluated as a template)                       | `[]`                                                   |
| `extraConfiguration`                              | Extra settings to be added to the default kibana.yml configmap that the chart creates (unless replaced using `configurationCM`). Evaluated as a template                    | `nil`                                                   |
| `configurationCM`                              | ConfigMap containing a kibana.yml file that will replace the default one specified in configuration.yaml                    | `nil`                                                   |
| `extraEnvVars`                              | Array containing extra env vars to configure Kibana                                        | `nil`                                                   |
| `extraEnvVarsCM`                              | ConfigMap containing extra env vars to configure Kibana                                        | `nil`                                                   |
| `extraEnvVarsSecret`                              | Secret containing extra env vars to configure Kibana (in case of sensitive data)                                        | `nil`                                                   |
| `extraVolumes`                           | Array of extra volumes to be added to the Kibana deployment (evaluated as template). Requires setting `extraVolumeMounts`                                        | `nil`                                                   |
| `extraVolumeMounts`                           | Array of extra volume mounts to be added to the Kibana deployment (evaluated as template). Normally used with `extraVolumes`.                                        | `nil`                                                   |
| `volumePermissions.enabled`          | Enable init container that changes volume permissions in the data directory (for cases where the default k8s `runAsUser` and `fsUser` values do not work) | `false`                                                 |
| `volumePermissions.image.registry`   | Init container volume-permissions image registry                                                                                                          | `docker.io`                                             |
| `volumePermissions.image.repository` | Init container volume-permissions image name                                                                                                              | `bitnami/minideb`                                       |
| `volumePermissions.image.tag`        | Init container volume-permissions image tag                                                                                                               | `stretch`                                                |
| `volumePermissions.image.pullPolicy` | Init container volume-permissions image pull policy                                                                                                       | `Always`                                                |
| `volumePermissions.resources`        | Init container resource requests/limit                                                                                                                    | `nil`                                                   |
| `persistence.enabled`                       | Enable persistence                                                                          | `true`                                                  |
| `presistence.storageClass`                  | Storage class to use with the PVC                                                           | `nil`                                                   |
| `persistence.accessMode`                    | Access mode to the PV                                                                       | `ReadWriteOnce`                                         |
| `persistence.size`                          | Size for the PV                                                                             | `10Gi`                                                  |
| `livenessProbe.enabled`                     | Enable/disable the Liveness probe                                                           | `true`                                                  |
| `livenessProbe.initialDelaySeconds`         | Delay before liveness probe is initiated                                                    | `60`                                                    |
| `livenessProbe.periodSeconds`               | How often to perform the probe                                                              | `10`                                                    |
| `livenessProbe.timeoutSeconds`              | When the probe times out                                                                    | `5`                                                     |
| `livenessProbe.successThreshold`            | Minimum consecutive successes for the probe to be considered successful after having failed.| `1`                                                     |
| `livenessProbe.failureThreshold`            | Minimum consecutive failures for the probe to be considered failed after having succeeded.  | `6`                                                     |
| `readinessProbe.enabled`                    | Enable/disable the Readiness probe                                                          | `true`                                                  |
| `readinessProbe.initialDelaySeconds`        | Delay before readiness probe is initiated                                                   | `5`                                                     |
| `readinessProbe.periodSeconds`              | How often to perform the probe                                                              | `10`                                                    |
| `readinessProbe.timeoutSeconds`             | When the probe times out                                                                    | `5`                                                     |
| `readinessProbe.failureThreshold`           | Minimum consecutive failures for the probe to be considered failed after having succeeded.  | `6`                                                     |
| `readinessProbe.successThreshold`           | Minimum consecutive successes for the probe to be considered successful after having failed.| `1`                                                     |
| `service.type`                              | Kubernetes Service type                                                                     | | `ClusterIP`                                             |
| `service.nodePort`                          | Port to bind to for NodePort service type (client port)                                     | `nil`                                                   |
| `service.annotations`                       | Annotations for Kibana service (evaluated as a template)                                                            | `{}`                                                    |
| `service.externalTrafficPolicy`  | Enable client source IP preservation                                          | `Cluster`                                                    |
| `service.loadBalancerIP`                    | loadBalancerIP if Kibana service type is `LoadBalancer`                                    | `nil`                                                   |
| `service.extraPorts`             | Extra ports to expose in the service (normally used with the `sidecar` value). Evaluated as a template. | `nil`                                                        |
| `forceInitScripts`                       | Force the execution of the init scripts located in `/docker-entrypoint-initdb.d`                                                                          | `false`                                                  |
| `initScriptsCM`                       | ConfigMap containing `/docker-entrypoint-initdb.d` scripts to be executed at initialization time (evaluated as a template)                                                                          | `nil`                                                  |
| `initScriptsSecret`                       | Secret containing `/docker-entrypoint-initdb.d` scripts to be executed at initialization time (that contain sensitive data). Evaluated as a template.                                                                        | `nil`                                                  |
| `ingress.enabled`                           | Enable the use of the ingress controller to access the web UI                               | `false`                                                 |
| `ingress.annotations`                       | Annotations for the Kibana Ingress                                                         | `{}`                                                    |
| `ingress.hosts`                             | Add hosts to the ingress controller with name and path                                      | `name: kibana.local`, `path: /`                        |
| `ingress.tls`                               | Configure TLS for the Kibana Ingress                                                       | `[]`                                                    |
| `securityContext.enabled`                   | Enable securityContext on for Kibana deployment                                            | `true`                                                  |
| `securityContext.runAsUser`                 | User for the security context                                                               | `1001`                                                  |
| `securityContext.fsGroup`                   | Group to configure permissions for volumes                                                  | `1001`                                                  |
| `resources`                                 | Configure resource requests and limits (evaluated as a template)                                                     | `nil`                                                   |
| `nodeSelector`                              | Node labels for pod assignment (evaluated as a template)                                                             | `{}`                                                    |
| `tolerations`                               | Tolerations for pod assignment (evaluated as a template)                                                             | `[]`                                                    |
| `affinity`                                  | Affinity for pod assignment (evaluated as a template)                                                                | `{}`                                                    |
| `podAnnotations`                            | Pod annotations (evaluated as a template)                                                                            | `{}`                                                    |
| `sidecars`                       | Attach additional containers to the pod (evaluated as a template)                                      | `nil`                                                        |
| `initContainers`                       | Add additional init containers to the pod (evaluated as a template)                                      | `nil`                                                        |
| `metrics.enabled`                | Start a side-car prometheus exporter                                          | `false`                                                      |
| `metrics.service.annotations`                | Prometheus annotations for the Kibana service                                          | `{ prometheus.io/scrape: "true", prometheus.io/port: "80", prometheus.io/path: "_prometheus/metrics" }`                                                      |
| `elasticsearch.enabled`                | Use bundled Elasticsearch                                           | `true`                                                      |
| `elasticsearch.external.hosts`                | Array containing the hostnames for the already existing Elasticsearch instances                                          | `nil`                                                      |
| `elasticsearch.external.port`                | Port for the accessing external Elasticsearch instances                                          | `nil`                                                      |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set admin.user=admin-user bitnami/kibana
```

The above command sets the Kibana admin user to `admin-user`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml bitnami/kibana
```

> **Tip**: You can use the default [values.yaml](values.yaml)

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

And now you need to pass the ConfigMap name, to the corresponding parameter:

```console
$ helm install bitnami/kibana --set configurationCM=myconfig
```

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

For advanced operations, the Bitnami Kibana charts allows using custom init scripts that will be mounted in `/docker-entrypoint.init-db`. You can use a ConfigMap or a Secret (in case of sensitive data) for mounting these extra scripts.

```console
$ kubectl create configmap special-scripts \
  --from-file=01_install_kibana_theme.sh \
  --from-file=02_add_special_agent.sh

$ kubectl create secret generic special-scripts-sensitive \
  --from-file=03_install_company_certificates.sh
```

Then use the `initScriptsCM` and `initScriptsSecret` values.

```console
$ helm install bitnami/kibana --name my-release \
  --set elasticsearch.enabled=false \
 --set elasticsearch.external.hosts[0]=elasticsearch-host \
 --set elasticsearch.external.port=9200 \
 --set initScriptsCM=special-scripts \
 --set initScriptsSecret=special-scripts-sensitive
```

### Installing plugins

The Bitnami Kibana chart allows you to install a set of plugins at deployment time using the `plugins` value:

```console
$ helm install bitnami/kibana --name my-release \
  --set elasticsearch.enabled=false \
  --set elasticsearch.external.hosts[0]=elasticsearch-host \
  --set elasticsearch.external.port=9200 \
  --set plugins[0]=https://github.com/fbaligand/kibana-enhanced-table/releases/download/v1.5.0/enhanced-table-1.5.0_7.3.2.zip
```

> **NOTE** Make sure that the plugin is available for the Kibana version you are deploying

### Importing saved objects

If you have visualizations and dashboards (in NDJSON format) that you want to import to Kibana. You can create a ConfigMap that includes them.

```console
$ kubectl create configmap my-import --from-file=my-exported-data.ndjson
```

Then install the chart with the `savedObjects.configmap` value:

```console
helm install bitnami/kibana --name my-release \
  --set savedObjects.configmap=my-import
```

Alternatively, if it is available via URL, you can install the chart as follows

```console
helm install bitnami/kibana --name my-release \
  --set savedObjects.urls[0]=www.my-site.com/import.ndjson
```

## Sidecars and Init Containers

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

### Production configuration

This chart includes a `values-production.yaml` file where you can find some parameters oriented to production configuration in comparison to the regular `values.yaml`.

```console
$ helm install --name my-release -f ./values-production.yaml --set elasticsearch.enabled=false --set elasticsearch.external.hosts[0]=elasticsearch-host --set elasticsearch.external.port=9200 bitnami/kibana
```

- Disable bundled Elasticsearch

```diff
- elasticsearch.enabled: true
+ elasticsearch.enabled: false
```

- Enable metrics scraping

```diff
- metrics.enabled: false
+ metrics.enabled: true
```

## Persistence

The [Bitnami Kibana](https://github.com/bitnami/bitnami-docker-kibana) image can persist data. If enabled, the persisted path is `/bitnami/kibana` by default.

The chart mounts a [Persistent Volume](http://kubernetes.io/docs/user-guide/persistent-volumes/) at this location. The volume is created using dynamic volume provisioning.

## Adding extra volumes

The Bitnami Kibana chart supports mounting extra volumes (either PVCs, secrets or configmaps) by using the `extraVolumes` and `extraVolumeMounts` property. This can be combined with advanced operations like adding extra init containers and sidecars.

### Adjust permissions of persistent volume mountpoint

As the image run as non-root by default, it is necessary to adjust the ownership of the persistent volume so that the container can write data into it.

By default, the chart is configured to use Kubernetes Security Context to automatically change the ownership of the volume. However, this feature does not work in all Kubernetes distributions.
As an alternative, this chart supports using an initContainer to change the ownership of the volume before mounting it in the final destination.

You can enable this initContainer by setting `volumePermissions.enabled` to `true`.

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.
