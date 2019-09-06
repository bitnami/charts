# Grafana

[Grafana](https://grafana.com/) is an open source, feature rich metrics dashboard and graph editor for Graphite, Elasticsearch, OpenTSDB, Prometheus and InfluxDB.

## TL;DR;

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install bitnami/grafana
```

## Introduction

This chart bootstraps a [grafana](https://github.com/bitnami/bitnami-docker-grafana) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install --name my-release bitnami/grafana
```

These commands deploy grafana on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` statefulset:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release. Use the option `--purge` to delete all persistent volumes too.

## Configuration

The following tables lists the configurable parameters of the grafana chart and their default values.

| Parameter                                   | Description                                                                                 | Default                                                 |
| ------------------------------------------- | ------------------------------------------------------------------------------------------- | ------------------------------------------------------- |
| `global.imageRegistry`                      | Global Docker image registry                                                                | `nil`                                                   |
| `global.imagePullSecrets`                   | Global Docker registry secret names as an array                                             | `[]` (does not add image pull secrets to deployed pods) |
| `image.registry`                            | Grafana image registry                                                                      | `docker.io`                                             |
| `image.repository`                          | Grafana image name                                                                          | `bitnami/grafana`                                       |
| `image.tag`                                 | Grafana image tag                                                                           | `{TAG_NAME}`                                            |
| `image.pullPolicy`                          | Grafana image pull policy                                                                   | `IfNotPresent`                                          |
| `image.pullSecrets`                         | Specify docker-registry secret names as an array                                            | `[]` (does not add image pull secrets to deployed pods) |
| `nameOverride`                              | String to partially override grafana.fullname template with a string (will prepend the release name) | `nil`                                          |
| `fullnameOverride`                          | String to fully override grafana.fullname template with a string                            | `nil`                                                   |
| `replicaCount`                               | Number of replicas of the Grafana Pod                                                       | `1`                                                     |
| `updateStrategy`                            | Update strategy for deployment                                                              | `{type: "RollingUpdate"}`                                       |
| `schedulerName`                             | Alternative scheduler                                                                       | `nil`                                                   |
| `admin.user`                                | Grafana admin username                                                                      | `admin`                                                 |
| `admin.password`                            | Grafana admin password                                                                      | Randomly generated                                               |
| `smtp.enabled`                              | Enable SMTP configuration                                                                   | `false`                                                 |
| `smtp.existingSecret`                       | Secret with SMTP credentials                                                                | `nil`                                                   |
| `smtp.existingSecretUserKey`                | Key which value is the SMTP user in the SMTP secret                                         | `user`                                                  |
| `smtp.existingSecretPasswordKey`            | Key which values is the SMTP password in the SMTP secret                                    | `password`                                              |
| `plugins`                                   | Grafana plugins to be installed in deployment time separated by commas                      | `nil`                                                   |
| `ldap.enabled`                              | Enable LDAP for Grafana                                                                     | `false`                                                 |
| `ldap.allowSignUp`                          | Allows LDAP sign up for Grafana                                                             | `false`                                                 |
| `ldap.configMapName`                        | Name of the ConfigMap with the LDAP configuration file for Grafana                          | `nil`                                                   |
| `extraEnvVars`                              | Array containing extra env vars to configure Grafana                                        | `nil`                                                   |
| `extraConfigmaps`                           | Array to mount extra ConfigMaps to configure Grafana                                        | `nil`                                                   |
| `config.useGrafanaIniFile`                  | Allows to load a `grafana.ini` file                                                         | `false`                                                 |
| `config.grafanaIniConfigMap`                | Name of the ConfigMap containing the `grafana.ini` file                                     | `nil`                                                   |
| `config.useCustomIniFile`                   | Allows to load a `custom.ini` file                                                          | `false`                                                 |
| `config.customIniConfigMap`                 | Name of the ConfigMap containing the `custom.ini` file                                      | `nil`                                                   |
| `dashboardsProvider.enabled`                | Enable the use of a Grafana dashboard provider                                              | `false`                                                 |
| `dashboardsProvider.configMapName`          | Name of a ConfigMap containing a custom dashboard provider                                  | `nil`                                                   |
| `dashboardsConfigMaps`                      | Array with the names of a series of ConfigMaps containing dashboards files                  | `nil`                                                   |
| `datasources.secretName`                    | Secret name containing custom datasource files                                              | `nil`                                                   |
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
| `service.type`                              | Kubernetes Service type                                                                     | `ClusterIP`                                             |
| `service.webPort`                           | Grafana client port                                                                         | `80`                                                    |
| `service.clusterPort`                       | Grafana cluster port                                                                        | `7077`                                                  |
| `service.nodePort`                          | Port to bind to for NodePort service type (client port)                                     | `nil`                                                   |
| `service.annotations`                       | Annotations for Grafana service                                                             | `{}`                                                    |
| `service.loadBalancerIP`                    | loadBalancerIP if Grafana service type is `LoadBalancer`                                    | `nil`                                                   |
| `ingress.enabled`                           | Enable the use of the ingress controller to access the web UI                               | `false`                                                 |
| `ingress.annotations`                       | Annotations for the Grafana Ingress                                                         | `{}`                                                    |
| `ingress.hosts`                             | Add hosts to the ingress controller with name and path                                      | `name: grafana.local`, `path: /`                        |
| `ingress.tls`                               | Configure TLS for the Grafana Ingress                                                       | `[]`                                                    |
| `securityContext.enabled`                   | Enable securityContext on for Granafa deployment                                            | `true`                                                  |
| `securityContext.runAsUser`                 | User for the security context                                                               | `1001`                                                  |
| `securityContext.fsGroup`                   | Group to configure permissions for volumes                                                  | `1001`                                                  |
| `securityContext.runAsNonRoot`              | Run containers as non-root users                                                            | `true`                                                  |
| `resources`                                 | Configure resource requests and limits                                                      | `nil`                                                   |
| `nodeSelector`                              | Node labels for pod assignment                                                              | `{}`                                                    |
| `tolerations`                               | Tolerations for pod assignment                                                              | `[]`                                                    |
| `affinity`                                  | Affinity for pod assignment                                                                 | `{}`                                                    |
| `podAnnotations`                            | Pod annotations                                                                             | `{}`                                                    |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set admin.user=admin-user bitnami/grafana
```

The above command sets the Grafana admin user to `admin-user`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml bitnami/grafana
```

> **Tip**: You can use the default [values.yaml](values.yaml)

### Using custom configuration

Grafana support multiples configuration files. Using kubernetes you can mount a file using a ConfigMap. For example, to mount a custom `grafana.ini` file or `custom.ini` file you can create a ConfigMap like the following:

```
apiVersion: v1
kind: ConfigMap
metadata:
  name: myconfig
data:
  grafana.ini: |-
    # Raw text of the file
```

And now you need to pass the ConfigMap name, to the corresponding parameter:

```
$ helm install bitnami/grafana --set config.useGrafanaIniFile=true,config.grafanaIniConfigMap=myconfig
```

To provide dashboards on deployment time, Grafana needs a dashboards provider and the dashboards themselves.
A default provider is created if enabled, or you can mount your own provider using a ConfigMap, but have in mind that the path to the dashboard folder must be `/opt/bitnami/grafana/dashboards`.
  1. To create a dashboard, it is needed to have a datasource for it. The datasources must be created mounting a secret with all the datasource files in it. In this case, it is not a ConfigMap because the datasource could contain sensitive information.
  2. To load the dashboards themselves you need to create a ConfigMap for each one containing the `json` file that defines the dashboard and set the array with the ConfigMap names into the `dashboardsConfigMaps` parameter.
Note the difference between the datasources and the dashboards creation. For the datasources we can use just one secret with all of the files, while for the dashboards we need one ConfigMap per file.
For example, after the creation of the dashboard and datasource ConfigMap in the same way that the explained for the `grafana.ini` file, execute the following to deploy Grafana with custom dashboards:

```
$ helm install bitnami/grafana --set "dashboardsProvider.enabled=true,datasources.secretName=datasource-secret,dashboardsConfigMaps[0].configMapName=mydashboard,dashboardsConfigMaps[0].fileName=mydashboard.json"
```

### Production configuration

This chart includes a `values-production.yaml` file where you can find some parameters oriented to production configuration in comparison to the regular `values.yaml`.

```console
$ helm install --name my-release -f ./values-production.yaml bitnami/grafana
```

- Enable ingress controller
```diff
- ingress.enabled: false
+ ingress.enabled: true
```

### Supporting HA (High Availability)

To support HA Grafana just need an external database where store dashboards, users and other persistent data.
To configure the external database provide a configuration file containing the [database section](https://grafana.com/docs/installation/configuration/#database)

More information about Grafana HA [here](https://grafana.com/docs/tutorials/ha_setup/)

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

## Persistence

The [Bitnami Grafana](https://github.com/bitnami/bitnami-docker-grafana) image stores the Grafana data and configurations at the `/opt/bitnami/grafana/data` path of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Configuration](#configuration) section to configure the PVC or to disable persistence.
