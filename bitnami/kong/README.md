# Kong

[Kong](https://konghq.com/kong/) is a scalable, open source API layer (aka API gateway or API middleware) that runs in front of any RESTful API. Extra functionalities beyond the core platform are extended through plugins. Kong is built on top of reliable technologies like NGINX and provides an easy-to-use RESTful API to operate and configure the system.

## TL;DR;

```console
  helm repo add bitnami https://charts.bitnami.com/bitnami
  helm install my-release bitnami/kong
```

## Introduction

This chart bootstraps a [kong](https://github.com/bitnami/bitnami-docker-kong) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager. It also includes the [kong-ingress-controller](https://github.com/bitnami/bitnami-docker-kong-ingress-controller) container for managing Ingress resources using Kong.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.12+
- Helm 2.11+ or Helm 3.0-beta3+
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
  helm repo add bitnami https://charts.bitnami.com/bitnami
  helm install my-release bitnami/kong
```

These commands deploy kong on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
  helm delete my-release
```
## Parameters

The following tables list the configurable parameters of the kong chart and their default values per section/component:

### Global Parameters
| Parameter                              | Description                                                                                            | Default                                                 |
|----------------------------------------|--------------------------------------------------------------------------------------------------------|---------------------------------------------------------|
| `global.imageRegistry`                 | Global Docker image registry                                                                           | `nil`                                                   |
| `global.imagePullSecrets`              | Global Docker registry secret names as an array                                                        | `[]` (does not add image pull secrets to deployed pods) |
| `global.storageClass`     | Global storage class for dynamic provisioning                                                                  | `nil`                                                   |

### Common Parameters

| Parameter                              | Description                                                                                            | Default                                                 |
|----------------------------------------|--------------------------------------------------------------------------------------------------------|---------------------------------------------------------|
| `nameOverride`                         | String to partially override kong.fullname template with a string (will prepend the release name)   | `nil`                                                   |
| `fullnameOverride`                     | String to fully override kong.fullname template with a string                                       | `nil`                                                   |
| `clusterDomain`                      | Kubernetes cluster domain                                                                                                                                 | `cluster.local`                                         |

### Deployment Parameters

| Parameter                              | Description                                                                                            | Default                                                 |
|----------------------------------------|--------------------------------------------------------------------------------------------------------|---------------------------------------------------------|
| `image.registry`                       | kong image registry                                                                                 | `docker.io`                                             |
| `image.repository`                     | kong image name                                                                                     | `bitnami/kong`                                       |
| `image.tag`                            | kong image tag                                                                                      | `{TAG_NAME}`                                            |
| `image.pullPolicy`                     | kong image pull policy                                                                              | `IfNotPresent`                                          |
| `image.pullSecrets`                    | Specify docker-registry secret names as an array                                                       | `[]` (does not add image pull secrets to deployed pods) |
| `replicaCount`                         | Number of replicas of the kong Pod                                                                  | `2`                                                     |
| `updateStrategy`                       | Update strategy for deployment                                                                         | `{type: "RollingUpdate"}`                               |
| `schedulerName`                        | Alternative scheduler                                                                                  | `nil`                                                   |
| `database`                        | Select which database backend Kong will use. Can be 'postgresql' or 'cassandra'                                                                                  | `postgresql`                                                   |
| `containerSecurityContext`            | Container security podSecurityContext                                                                           | `{ runAsUser: 1001, runAsNonRoot: true}`                                                  |
| `podSecurityContext`         | Pod security context                                                                       | `{}`                                                  |
| `nodeSelector`                         | Node labels for pod assignment                                                                         | `{}`                                                    |
| `tolerations`                          | Tolerations for pod assignment                                                                         | `[]`                                                    |
| `affinity`                             | Affinity for pod assignment                                                                            | `{}`                                                    |
| `podAnnotations`                       | Pod annotations                                                                                        | `{}`                                                    |
| `sidecars`                             | Attach additional containers to the pod (evaluated as a template)                                                                                         | `nil`                                                                                                   |             |
| `initContainers`                       | Add additional init containers to the pod (evaluated as a template)                                                                                       | `nil`                                                                                                   |             |
| `pdb.enabled`                       | Deploy a pdb object for the Kong pod                                                                                       | `false`                                                                                                   |             |
| `pdb.maxUnavailable`                       | Maximum unavailable Kong replicas (expressed in percentage)                                                                                       | `50%`                                                                                                   |             |
| `autoscaling.enabled`                       | Deploy a HorizontalPodAutoscaler object for the Kong deployment                                                                                       | `false`                                                                                                   |             |
| `autoscaling.apiVersion`                       | API Version of the HPA object (for compatibility with Openshift)                                                                                       | `v1beta1`                                                                                                   |             |
| `autoscaling.minReplicas`                       | Minimum number of replicas to scale back                                                                                       | `2`                                                                                                   |             |
| `autoscaling.maxReplicas`                       | Maximum number of replicas to scale out                                                                                       | `2`                                                                                                   |             |
| `autoscaling.metrics`                       | Metrics to use when deciding to scale the deployment (evaluated as a template)                                                                                       | `Check values.yaml`                                                                                                   |             |
| `extraVolumes`                         | Array of extra volumes to be added to the Kong deployment deployment (evaluated as template). Requires setting `extraVolumeMounts`                                 | `nil`                                                                                                   |             |
| `kong.livenessProbe`    | Liveness probe  (kong container)                                               | `Check values.yaml`                                                    |
| `kong.readinessProbe`               | Readiness probe (kong contaienr)                                                                   | `Check values.yaml`                                                  |
| `kong.resources`                            | Configure resource requests and limits (kong container)                                                                | `nil`                                                   |
| `kong.extraVolumeMounts`                    | Array of extra volume mounts to be added to the Kong Container (evaluated as template). Normally used with `extraVolumes`.                             | `nil`                                                                                                   |             |
| `ingressController.livenessProbe`    | Liveness probe (kong ingress controller container)                                                               | `Check values.yaml`                                                    |
| `ingressController.readinessProbe`               | Readiness probe (kong ingress controller container)                                                                   | `Check values.yaml`                                                  |
| `ingressController.resources`                            | Configure resource requests and limits (kong ingress controller container)                                                                | `nil`                                                   |
| `ingressController.extraVolumeMounts`                    | Array of extra volume mounts to be added to the Kong Ingress Controller container (evaluated as template). Normally used with `extraVolumes`.                             | `nil`                                                                                                   |             |
| `migration.resources`                            | Configure resource requests and limits  (migration container)                                                               | `nil`                                                   |
| `migration.extraVolumeMounts`                    | Array of extra volume mounts to be added to the Kong Container (evaluated as template). Normally used with `extraVolumes`.                             | `nil`                                                                                                   |             |

### Traffic Exposure Parameters

| Parameter                              | Description                                                                                            | Default                                                 |
|----------------------------------------|--------------------------------------------------------------------------------------------------------|---------------------------------------------------------|
| `service.type`                         | Kubernetes Service type                                                                                | `ClusterIP`                                             |
| `service.exposeAdmin`                         | Add the Kong Admin ports to the service                                                                                | `false`                                             |
| `service.proxyHttpPort`                      | kong proxy HTTP service port port                                                                                    | `80`                                                    |
| `service.proxyHttpsPort`                      | kong proxy HTTPS service port port                                                                                    | `443`                                                    |
| `service.adminHttpPort`                      | kong admin HTTPS service port (only if service.exposeAdmin=true)                                                                                     | `8001`                                                    |
| `service.adminHttpsPort`                      | kong admin HTTPS service port (only if service.exposeAdmin=true)                                                                                    | `8443`                                                    |
| `service.proxyHttpNodePort`                     | Port to bind to for NodePort service type (proxy HTTP)                                                | `nil`                                                   |
| `service.proxyHttpsNodePort`                     | Port to bind to for NodePort service type (proxy HTTPS)                                                | `nil`                                                   |
| `service.adminHttpNodePort`                     | Port to bind to for NodePort service type (admin HTTP)                                                | `nil`                                                   |
| `service.aminHttpsNodePort`                     | Port to bind to for NodePort service type (proxy HTTP)                                                | `nil`                                                   |
| `service.annotations`                  | Annotations for kong service                                                                        | `{}`                                                    |
| `service.loadBalancerIP`               | loadBalancerIP if kong service type is `LoadBalancer`                                               | `nil`                                                   |
| `ingress.enabled`                      | Enable the use of the ingress controller to access the web UI                                          | `false`                                                 |
| `ingress.certManager`                  | Add annotations for cert-manager                                                                       | `false`                                                 |
| `ingress.annotations`                  | Annotations for the kong Ingress                                                                    | `{}`                                                    |
| `ingress.hosts[0].name`                | Hostname to your kong installation                                                                  | `kong.local`                                         |
| `ingress.hosts[0].paths`               | Path within the url structure                                                                          | `["/"]`                                                 |
| `ingress.hosts[0].tls`                 | Utilize TLS backend in ingress                                                                         | `false`                                                 |
| `ingress.hosts[0].tlsHosts`            | Array of TLS hosts for ingress record (defaults to `ingress.hosts[0].name` if `nil`)                   | `nil`                                                   |
| `ingress.hosts[0].servicePort`            | Which service port inside the kong service to redirect                   | `nil`                                                   |
| `ingress.hosts[0].tlsSecret`           | TLS Secret (certificates)                                                                              | `kong.local-tls`                                     |

### Kong Container Parameters

| Parameter                              | Description                                                                                            | Default                                                 |
|----------------------------------------|--------------------------------------------------------------------------------------------------------|---------------------------------------------------------|
| `kong.extraEnvVars`                         | Array containing extra env vars to configure Kong                                                                                                       | `nil`                                                                                                   |             |
| `kong.extraEnvVarsCM`                       | ConfigMap containing extra env vars to configure Kong                                                                                                   | `nil`                                                                                                   |             |
| `kong.extraEnvVarsSecret`                   | Secret containing extra env vars to configure Kong (in case of sensitive data)                                                                          | `nil`                                                                                                   |             |
| `kong.command`                    | Override default container command (useful when using custom images)                             | `nil`                                                                                                   |             |
| `kong.args`                    | Override default container args (useful when using custom images)                             | `nil`                                                                                                   |             |
| `kong.initScriptsCM`                        | ConfigMap containing `/docker-entrypoint-initdb.d` scripts to be executed at initialization time (evaluated as a template)                                | `nil`                                                                                                   |             |
| `kong.initScriptsSecret`                    | Secret containing `/docker-entrypoint-initdb.d` scripts to be executed at initialization time (that contain sensitive data). Evaluated as a template.     | `nil`                                                                                                   |             |

### Kong Migration job Parameters

| Parameter                              | Description                                                                                            | Default                                                 |
|----------------------------------------|--------------------------------------------------------------------------------------------------------|---------------------------------------------------------|
| `migration.image.registry`                       | Kong migration job image registry                                                                                 | `docker.io`                                             |
| `migration.image.repository`                     | Kong migration job image name                                                                                     | `bitnami/kong`                                       |
| `migration.image.tag`                            | Kong migration job image tag                                                                                      | `{TAG_NAME}`                                            |
| `migration.image.pullPolicy`                     | kong migration job image pull policy                                                                              | `IfNotPresent`                                          |
| `migration.image.pullSecrets`                    | Specify docker-registry secret names as an array                                                       | `[]` (does not add image pull secrets to deployed pods) |
| `migration.extraEnvVars`                         | Array containing extra env vars to configure the Kong migration job                                                                                                       | `nil`                                                                                                   |             |
| `migration.extraEnvVarsCM`                       | ConfigMap containing extra env vars to configure the Kong migration job                                                                                                   | `nil`                                                                                                   |             |
| `migration.extraEnvVarsSecret`                   | Secret containing extra env vars to configure the Kong migration job (in case of sensitive data)                                                                          | `nil`                                                                                                   |             |
| `migration.command`                    | Override default container command (useful when using custom images)                             | `nil`                                                                                                   |             |
| `migration.args`                    | Override default container args (useful when using custom images)                             | `nil`                                                                                                   |             |

### Kong Ingress Controller Container Parameters

| Parameter                              | Description                                                                                            | Default                                                 |
|----------------------------------------|--------------------------------------------------------------------------------------------------------|---------------------------------------------------------|
| `ingressController.enabled`                | Enable/disable the Kong Ingress Controller                                                                      | `true`                                                  |
| `ingressController.image.registry`                       | Kong Ingress Controller image registry                                                                                 | `docker.io`                                             |
| `ingressController.image.repository`                     | Kong Ingress Controller image name                                                                                     | `bitnami/kong`                                       |
| `ingressController.image.tag`                            | Kong Ingress Controller image tag                                                                                      | `{TAG_NAME}`                                            |
| `ingressController.image.pullPolicy`                     | kong ingress controller image pull policy                                                                              | `IfNotPresent`                                          |
| `ingressController.image.pullSecrets`                    | Specify docker-registry secret names as an array                                                       | `[]` (does not add image pull secrets to deployed pods) |
| `ingressController.proxyReadyTimeout`                | Maximum time (in seconds) to wait for the Kong container to be ready                                                                      | `300`                                                  |
| `ingressController.extraEnvVars`                         | Array containing extra env vars to configure Kong                                                                                                       | `nil`                                                                                                   |             |
| `ingressController.extraEnvVarsCM`                       | ConfigMap containing extra env vars to configure Kong Ingress Controller                                                                                                   | `nil`                                                                                                   |             |
| `ingressController.extraEnvVarsSecret`                   | Secret containing extra env vars to configure Kong Ingress Controller (in case of sensitive data)                                                                          | `nil`                                                                                                   |             |
| `ingressController.rbac.create`                    | Create the necessary Service Accounts, Roles and Rolebindings for the Ingress Controller to work                             | `true`                                                                                                   |             |
| `ingressController.rbac.existingServiceAccount`                    | Use an existing service account for all the RBAC operations                             | `nil`                                                                                                   |             |
| `ingressController.installCRDs`                    | Install CustomResourceDefinitions (for Helm 2 support)                             | `false`                                                                                                   |             |
| `ingressController.customResourceDeletePolicy`                    | Add custom CRD resource delete policy (for Helm 2 support)                             | `nil`                                                                                                   |             |
| `ingressController.rbac.existingServiceAccount`                    | Use an existing service account for all the RBAC operations                             | `nil`                                                                                                   |             |
| `ingressController.ingressClass`                    | Name of the class to register Kong Ingress Controller (useful when having other Ingress Controllers in the cluster)                             | `nil`                                                                                                   |             |
| `ingressController.command`                    | Override default container command (useful when using custom images)                             | `nil`                                                                                                   |             |
| `ingressController.args`                    | Override default container args (useful when using custom images)                             | `nil`                                                                                                   |             |

### PostgreSQL Parameters
| Parameter                              | Description                                                                                            | Default                                                 |
|----------------------------------------|--------------------------------------------------------------------------------------------------------|---------------------------------------------------------|
| `postgresql.enabled`                      | Deploy the PostgreSQL sub-chart                                                     | `false`                                                 |
| `postgresql.usePasswordFile`          | Mount the PostgreSQL secret as a file                                                             | `no`                                |
| `postgresql.existingSecret`          | Use an existing secret file with the PostgreSQL password (can be used with the bundled chart or with an existing installation)                                                             | `nil`                                |
| `postgresql.postgresqlDatabase`          | Database name to be used by Kong                                                             | `kong`                                |
| `postgresql.postgresqlUsername`          | Username to be created by the PostgreSQL bundled chart                                                             | `kong`                                |
| `postgresql.external.host`          | Host of an external PostgreSQL installation                                                             | `nil`                                |
| `postgresql.external.user`          | Username of the external PostgreSQL installation                                                             | `nil`                                |
| `postgresql.external.password`          | Password of the external PostgreSQL installation                                                             | `nil`                                |

### Cassandra Parameters
| Parameter                              | Description                                                                                            | Default                                                 |
|----------------------------------------|--------------------------------------------------------------------------------------------------------|---------------------------------------------------------|
| `cassandra.enabled`                      | Deploy the Cassandra sub-chart                                                     | `false`                                                 |
| `cassandra.usePasswordFile`          | Mount the Cassandra secret as a file                                                             | `no`                                |
| `cassandra.existingSecret`          | Use an existing secret file with the Cassandra password (can be used with the bundled chart or with an existing installation)                                                             | `nil`                                |
| `cassandra.dbUser.user`          | Username to be created by the cassandra bundled chart                                                             | `kong`                                |
| `cassandra.external.hosts`          | Hosts of an external cassandra installation                                                             | `nil`                                |
| `cassandra.external.port`          | Port of an external cassandra installation                                                             | `nil`                                |
| `cassandra.external.user`          | Username of the external cassandra installation                                                             | `nil`                                |
| `cassandra.external.password`          | Password of the external cassandra installation                                                             | `nil`                                |


### Metrics Parameters

| Parameter                              | Description                                                                                            | Default                                                 |
|----------------------------------------|--------------------------------------------------------------------------------------------------------|---------------------------------------------------------|

| `metrics.enabled`                      | Enable the export of Prometheus metrics                                                                | `false`                                                 |
| `metrics.service.type`          | Type of the Prometheus metrics service                                                             | `ClusterIP file`                                |
| `metrics.service.port`          | Port of the Prometheus metrics service                                                             | `9119`                                 |
| `metrics.service.annotations`          | Port for Prometheus metrics service                                                             | `9119`                                |
| `metrics.service.annotations`          | Annotations for Prometheus metrics service                                                             | `Check values.yaml file`                                |
| `metrics.serviceMonitor.enabled`       | if `true`, creates a Prometheus Operator ServiceMonitor (also requires `metrics.enabled` to be `true`) | `false`                                                 |
| `metrics.serviceMonitor.namespace`     | Namespace in which Prometheus is running                                                               | `nil`                                                   |
| `metrics.serviceMonitor.interval`      | Interval at which metrics should be scraped.                                                           | `nil` (Prometheus Operator default value)               |
| `metrics.serviceMonitor.scrapeTimeout` | Timeout after which the scrape is ended                                                                | `nil` (Prometheus Operator default value)               |
| `metrics.serviceMonitor.selector`      | Prometheus instance selector labels                                                                    | `nil`                                                   |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
  helm install my-release \
  --set service.exposeAdmin=true bitnami/kong
```

The above command exposes the Kong admin ports inside the Kong service.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
  helm install my-release -f values.yaml bitnami/kong
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Production configuration

This chart includes a `values-production.yaml` file where you can find some parameters oriented to production configuration in comparison to the regular `values.yaml`. You can use this file instead of the default one.

- Enable exposing Prometheus metrics:

```diff
- metrics.enabled: false
+ metrics.enabled: true
```

- Enable Pod Disruption Budget:

```diff
- pdb.enabled: false
+ pdb.enabled: true
```

- Increase number of replicas to 4:

```diff
- replicaCount: 2
+ replicaCount: 4
```

- Enable exposing Prometheus metrics:

```diff
- metrics.enabled: false
+ metrics.enabled: true
```
### Database backend

The Bitnami Kong chart allows setting two database backends: PostgreSQL or Cassandra. For each option, there are two extra possibilites: deploy a sub-chart with the database installation or use an existing one. The list below details the different options (replace the placeholders specified between _UNDERSCORES_):

- Deploy the PostgreSQL sub-chart (default)

```console
  helm install my-release bitnami/kong
```

- Use an external PostgreSQL database

```console
  helm install my-release bitnami/kong \
    --set postgresql.enabled=false \
    --set postgresql.external.host=_HOST_OF_YOUR_POSTGRESQL_INSTALLATION_ \
    --set postgresql.external.password=_PASSWORD_OF_YOUR_POSTGRESQL_INSTALLATION_ \
    --set postgresql.external.user=_USER_OF_YOUR_POSTGRESQL_INSTALLATION_
```

- Deploy the Cassandra sub-chart

```console
  helm install my-release bitnami/kong \
    --set database=cassandra \
    --set postgresql.enabled=false \
    --set cassandra.enabled=true
```

- Use an existing Cassandra installation

```console
  helm install my-release bitnami/kong \
    --set database=cassandra \
    --set postgresql.enabled=false \
    --set cassandra.enabled=false \
    --set cassandra.external.hosts[0]=_CONTACT_POINT_0_OF_YOUR_CASSANDRA_CLUSTER_ \
    --set cassandra.external.hosts[1]=_CONTACT_POINT_1_OF_YOUR_CASSANDRA_CLUSTER_ \
    ...
    --set cassandra.external.user=_USER_OF_YOUR_CASSANDRA_INSTALLATION_ \
    --set cassandra.external.password=_PASSWORD_OF_YOUR_CASSANDRA_INSTALLATION_
```

### Sidecars and Init Containers

If you have a need for additional containers to run within the same pod as Kong (e.g. an additional metrics or logging exporter), you can do so via the `sidecars` config parameter. Simply define your container according to the Kubernetes container spec.

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

### Adding extra environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `kong.extraEnvVars` property.

```yaml
kong:
  extraEnvVars:
    - name: KONG_LOG_LEVEL
      value: error
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `kong.extraEnvVarsCM` or the `kong.extraEnvVarsSecret` values.

The Kong Ingress Controller and the Kong Migration job also allow this kind of configuration via the `ingressController.extraEnvVars`, `ingressController.extraEnvVarsCM`, `ingressController.extraEnvVarsSecret`, `migration.extraEnvVars`, `migration.extraEnvVarsCM` and `migration.extraEnvVarsSecret` values.

### Using custom init scripts

For advanced operations, the Bitnami Kong charts allows using custom init scripts that will be mounted in `/docker-entrypoint.init-db`. You can use a ConfigMap or a Secret (in case of sensitive data) for mounting these extra scripts. Then use the `kong.initScriptsCM` and `kong.initScriptsSecret` values.

```console
elasticsearch.hosts[0]=elasticsearch-host
elasticsearch.port=9200
initScriptsCM=special-scripts
initScriptsSecret=special-scripts-sensitive
```

## Upgrade

It's necessary to specify the existing passwords while performing a upgrade to ensure the secrets are not updated with invalid randomly generated passwords. Remember to specify the existing values of the `postgresql.postgresqlPassword` or `cassandra.password` parameters when upgrading the chart:

```bash
$ helm upgrade my-release bitnami/kong \
    --set database=postgresql
    --set postgresql.enabled=true
    --set
    --set postgresql.postgresqlPassword=[POSTGRESQL_PASSWORD]
```

> Note: you need to substitute the placeholders _[POSTGRESQL_PASSWORD]_ with the values obtained from instructions in the installation notes.


