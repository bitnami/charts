# Grafana

[Grafana](https://grafana.com/) is an open source, feature rich metrics dashboard and graph editor for Graphite, Elasticsearch, OpenTSDB, Prometheus and InfluxDB.

## TL;DR

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/grafana
```

## Introduction

This chart bootstraps a [grafana](https://github.com/bitnami/bitnami-docker-grafana) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.12+
- Helm 2.12+ or Helm 3.0-beta3+
- PV provisioner support in the underlying infrastructure
- ReadWriteMany volumes for deployment scaling

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/grafana
```

These commands deploy grafana on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release. Use the option `--purge` to delete all persistent volumes too.

## Parameters

The following tables lists the configurable parameters of the grafana chart and their default values.

### Global parameters

| Parameter                 | Description                                     | Default                                                 |
|---------------------------|-------------------------------------------------|---------------------------------------------------------|
| `global.imageRegistry`    | Global Docker image registry                    | `nil`                                                   |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]` (does not add image pull secrets to deployed pods) |
| `global.storageClass`     | Global storage class for dynamic provisioning   | `nil`                                                   |

### Common parameters

| Parameter           | Description                                   | Default         |
|---------------------|-----------------------------------------------|-----------------|
| `nameOverride`      | String to partially override grafana.fullname | `nil`           |
| `fullnameOverride`  | String to fully override grafana.fullname     | `nil`           |
| `clusterDomain`     | Default Kubernetes cluster domain             | `cluster.local` |

### Grafana parameters

| Parameter                              | Description                                                                 | Default                                                 |
|----------------------------------------|-----------------------------------------------------------------------------|---------------------------------------------------------|
| `image.registry`                       | Grafana image registry                                                      | `docker.io`                                             |
| `image.repository`                     | Grafana image name                                                          | `bitnami/grafana`                                       |
| `image.tag`                            | Grafana image tag                                                           | `{TAG_NAME}`                                            |
| `image.pullPolicy`                     | Grafana image pull policy                                                   | `IfNotPresent`                                          |
| `image.pullSecrets`                    | Specify docker-registry secret names as an array                            | `[]` (does not add image pull secrets to deployed pods) |
| `admin.user`                           | Grafana admin username                                                      | `admin`                                                 |
| `admin.password`                       | Grafana admin password                                                      | Randomly generated                                      |
| `admin.existingSecret`                 | Name of the existing secret containing admin password                       | `nil`                                                   |
| `admin.existingSecretPasswordKey`      | Password key on the existing secret                                         | `password`                                              |
| `smtp.enabled`                         | Enable SMTP configuration                                                   | `false`                                                 |
| `smtp.user`                            | SMTP user                                                                   | `user`                                                  |
| `smtp.password`                        | SMTP password                                                               | `password`                                              |
| `smtp.existingSecret`                  | Name of the existing secret with SMTP credentials                           | `nil`                                                   |
| `smtp.existingSecretUserKey`           | User key on the existing secret                                             | `user`                                                  |
| `smtp.existingSecretPasswordKey`       | Password key on the existing secret                                         | `password`                                              |
| `plugins`                              | Grafana plugins to be installed in deployment time separated by commas      | `nil`                                                   |
| `ldap.enabled`                         | Enable LDAP for Grafana                                                     | `false`                                                 |
| `ldap.allowSignUp`                     | Allows LDAP sign up for Grafana                                             | `false`                                                 |
| `ldap.configMapName`                   | Name of the ConfigMap with the LDAP configuration file for Grafana          | `nil`                                                   |
| `extraEnvVars`                         | Array containing extra env vars to configure Grafana                        | `{}`                                                    |
| `extraConfigmaps`                      | Array to mount extra ConfigMaps to configure Grafana                        | `{}`                                                    |
| `config.useGrafanaIniFile`             | Allows to load a `grafana.ini` file                                         | `false`                                                 |
| `config.grafanaIniConfigMap`           | Name of the ConfigMap containing the `grafana.ini` file                     | `nil`                                                   |
| `config.grafanaIniSecret`              | Name of the Secret containing the `grafana.ini` file                        | `nil`                                                   |
| `dashboardsProvider.enabled`           | Enable the use of a Grafana dashboard provider                              | `false`                                                 |
| `dashboardsProvider.configMapName`     | Name of a ConfigMap containing a custom dashboard provider                  | `nil` (evaluated as a template)                         |
| `dashboardsConfigMaps`                 | Array with the names of a series of ConfigMaps containing dashboards files  | `nil`                                                   |
| `datasources.secretName`               | Secret name containing custom datasource files                              | `nil`                                                   |

### Deployment parameters

| Parameter                      | Description                                              | Default                        |
|--------------------------------|----------------------------------------------------------|--------------------------------|
| `replicaCount`                 | Number of Grafana nodes                                  | `1`                            |
| `updateStrategy`               | Update strategy for the deployment                       | `{type: "RollingUpdate"}`      |
| `schedulerName`                | Alternative scheduler                                    | `nil`                          |
| `podLabels`                    | Grafana pod labels                                       | `{}` (evaluated as a template) |
| `podAnnotations`               | Grafana Pod annotations                                  | `{}` (evaluated as a template) |
| `affinity`                     | Affinity for pod assignment                              | `{}` (evaluated as a template) |
| `nodeSelector`                 | Node labels for pod assignment                           | `{}` (evaluated as a template) |
| `tolerations`                  | Tolerations for pod assignment                           | `[]` (evaluated as a template) |
| `livenessProbe`                | Liveness probe configuration for Grafana                 | `Check values.yaml file`       |
| `readinessProbe`               | Readiness probe configuration for Grafana                | `Check values.yaml file`       |
| `securityContext.enabled`      | Enable securityContext on for Grafana deployment         | `true`                         |
| `securityContext.runAsUser`    | User for the security context                            | `1001`                         |
| `securityContext.fsGroup`      | Group to configure permissions for volumes               | `1001`                         |
| `securityContext.runAsNonRoot` | Run containers as non-root users                         | `true`                         |
| `resources.limits`             | The resources limits for Grafana containers              | `{}`                           |
| `resources.requests`           | The requested resources for Grafana containers           | `{}`                           |
| `sidecars`                     | Attach additional sidecar containers to the Grafana pod  | `{}`                           |
| `extraVolumes`                 | Additional volumes for the Grafana pod                   | `[]`                           |
| `extraVolumeMounts`            | Additional volume mounts for the Grafana container       | `[]`                           |

### Persistence parameters

| Parameter                   | Description                       | Default         |
|-----------------------------|-----------------------------------|-----------------|
| `persistence.enabled`       | Enable persistence                | `true`          |
| `presistence.storageClass`  | Storage class to use with the PVC | `nil`           |
| `persistence.accessMode`    | Access mode to the PV             | `ReadWriteOnce` |
| `persistence.size`          | Size for the PV                   | `10Gi`          |

### RBAC parameters

| Parameter                    | Description                                        | Default                                         |
|------------------------------|----------------------------------------------------|-------------------------------------------------|
| `serviceAccount.create`      | Enable creation of ServiceAccount for Grafana pods | `true`                                          |
| `serviceAccount.name`        | Name of the created serviceAccount                 | Generated using the `grafana.fullname` template |
| `serviceAccount.annotations` | ServiceAccount Annotations                         | `{}`                                            |
### Exposure parameters

| Parameter                           | Description                                                                                                                                                                                                                           | Default             |
|-------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------|
| `service.type`                      | Kubernetes Service type                                                                                                                                                                                                               | `ClusterIP`         |
| `service.port`                      | Grafana service port                                                                                                                                                                                                                  | `3000`              |
| `service.nodePort`                  | Port to bind to for NodePort service type (client port)                                                                                                                                                                               | `nil`               |
| `service.annotations`               | Annotations for Grafana service                                                                                                                                                                                                       | `{}`                |
| `service.loadBalancerIP`            | loadBalancerIP if Grafana service type is `LoadBalancer`                                                                                                                                                                              | `nil`               |
| `service.loadBalancerSourceRanges`  | loadBalancerSourceRanges if Grafana service type is `LoadBalancer`                                                                                                                                                                    | `nil`               |
| `ingress.enabled`                   | Enable the use of the ingress controller to access the web UI                                                                                                                                                                         | `false`             |
| `ingress.certManager`               | Add annotations for cert-manager                                                                                                                                                                                                      | `false`             |
| `ingress.annotations`               | Annotations for the Grafana Ingress                                                                                                                                                                                                   | `{}`                |
| `ingress.hosts[0].name`             | Hostname to your Grafana installation                                                                                                                                                                                                 | `grafana.local`     |
| `ingress.hosts[0].paths`            | Path within the url structure                                                                                                                                                                                                         | `["/"]`             |
| `ingress.hosts[0].extraPaths`       | Ingress extra paths to prepend to every host configuration. Useful when configuring [custom actions with AWS ALB Ingress Controller](https://kubernetes-sigs.github.io/aws-alb-ingress-controller/guide/ingress/annotation/#actions). | `[]`                |
| `ingress.hosts[0].tls`              | Utilize TLS backend in ingress                                                                                                                                                                                                        | `false`             |
| `ingress.hosts[0].tlsHosts`         | Array of TLS hosts for ingress record (defaults to `ingress.hosts[0].name` if `nil`)                                                                                                                                                  | `nil`               |
| `ingress.hosts[0].tlsSecret`        | TLS Secret (certificates)                                                                                                                                                                                                             | `grafana.local-tls` |

### Metrics parameters

| Parameter                              | Description                                                                                            | Default                                                 |
|----------------------------------------|--------------------------------------------------------------------------------------------------------|---------------------------------------------------------|
| `metrics.enabled`                      | Enable the export of Prometheus metrics                                                                | `false`                                                 |
| `metrics.service.annotations`          | Annotations for Prometheus metrics service                                                             | `Check values.yaml file`                                |
| `metrics.serviceMonitor.enabled`       | if `true`, creates a Prometheus Operator ServiceMonitor (also requires `metrics.enabled` to be `true`) | `false`                                                 |
| `metrics.serviceMonitor.namespace`     | Namespace in which Prometheus is running                                                               | `nil`                                                   |
| `metrics.serviceMonitor.interval`      | Interval at which metrics should be scraped.                                                           | `nil` (Prometheus Operator default value)               |
| `metrics.serviceMonitor.scrapeTimeout` | Timeout after which the scrape is ended                                                                | `nil` (Prometheus Operator default value)               |
| `metrics.serviceMonitor.selector`      | Prometheus instance selector labels                                                                    | `nil`                                                   |

### Grafana Image Renderer parameters

| Parameter                                            | Description                                                                                            | Default                                                 |
|------------------------------------------------------|--------------------------------------------------------------------------------------------------------|---------------------------------------------------------|
| `imageRenderer.enabled`                              | Enable using a remote rendering service to render PNG images                                           | `false`                                                 |
| `imageRenderer.image.registry`                       | Grafana Image Renderer image registry                                                                  | `docker.io`                                             |
| `imageRenderer.image.repository`                     | Grafana Image Renderer image name                                                                      | `bitnami/grafana-image-renderer`                        |
| `imageRenderer.image.tag`                            | Grafana Image Renderer image tag                                                                       | `{TAG_NAME}`                                            |
| `imageRenderer.image.pullPolicy`                     | Grafana Image Renderer image pull policy                                                               | `IfNotPresent`                                          |
| `imageRenderer.image.pullSecrets`                    | Specify docker-registry secret names as an array                                                       | `[]` (does not add image pull secrets to deployed pods) |
| `imageRenderer.replicaCount`                         | Number of Grafana Image Renderer nodes                                                                 | `1`                                                     |
| `imageRenderer.podAnnotations`                       | Grafana Image Renderer Pod annotations                                                                 | `{}` (evaluated as a template)                          |
| `imageRenderer.affinity`                             | Affinity for pod assignment                                                                            | `{}` (evaluated as a template)                          |
| `imageRenderer.nodeSelector`                         | Node labels for pod assignment                                                                         | `{}` (evaluated as a template)                          |
| `imageRenderer.tolerations`                          | Tolerations for pod assignment                                                                         | `[]` (evaluated as a template)                          |
| `imageRenderer.securityContext.enabled`              | Enable securityContext on for Grafana Image Renderer deployment                                        | `true`                                                  |
| `imageRenderer.securityContext.runAsUser`            | User for the security context                                                                          | `1001`                                                  |
| `imageRenderer.securityContext.fsGroup`              | Group to configure permissions for volumes                                                             | `1001`                                                  |
| `imageRenderer.securityContext.runAsNonRoot`         | Run containers as non-root users                                                                       | `true`                                                  |
| `imageRenderer.service.port`                         | Grafana Image Renderer service port                                                                    | `8080`                                                  |
| `imageRenderer.metrics.enabled`                      | Enable the export of Prometheus metrics                                                                | `false`                                                 |
| `imageRenderer.metrics.annotations`                  | Annotations for Prometheus metrics service                                                             | `Check values.yaml file`                                |
| `imageRenderer.metrics.serviceMonitor.enabled`       | if `true`, creates a Prometheus Operator ServiceMonitor (also requires `metrics.enabled` to be `true`) | `false`                                                 |
| `imageRenderer.metrics.serviceMonitor.namespace`     | Namespace in which Prometheus is running                                                               | `nil`                                                   |
| `imageRenderer.metrics.serviceMonitor.interval`      | Interval at which metrics should be scraped.                                                           | `nil` (Prometheus Operator default value)               |
| `imageRenderer.metrics.serviceMonitor.scrapeTimeout` | Timeout after which the scrape is ended                                                                | `nil` (Prometheus Operator default value)               |
| `imageRenderer.metrics.serviceMonitor.selector`      | Prometheus instance selector labels                                                                    | `nil`                                                   |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install my-release \
  --set admin.user=admin-user bitnami/grafana
```

The above command sets the Grafana admin user to `admin-user`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
$ helm install my-release -f values.yaml bitnami/grafana
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Production configuration

This chart includes a `values-production.yaml` file where you can find some parameters oriented to production configuration in comparison to the regular `values.yaml`. You can use this file instead of the default one.

- Enable ingress controller:

```diff
- ingress.enabled: false
+ ingress.enabled: true
```

- Enable exposing Prometheus metrics:

```diff
- metrics.enabled: false
+ metrics.enabled: true
```

- Enable using remote image rendering:

```diff
- imageRenderer.enabled: false
+ imageRenderer.enabled: true
```

### Using custom configuration

Grafana supports multiples configuration files. Using kubernetes you can mount a file using a ConfigMap or a Secret. For example, to mount a custom `grafana.ini` file or `custom.ini` file you can create a ConfigMap like the following:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: myconfig
data:
  grafana.ini: |-
    # Raw text of the file
```

And now you need to pass the ConfigMap name, to the corresponding parameters: `config.useGrafanaIniFile=true` and `config.grafanaIniConfigMap=myconfig`.

To provide dashboards on deployment time, Grafana needs a dashboards provider and the dashboards themselves.
A default provider is created if enabled, or you can mount your own provider using a ConfigMap, but have in mind that the path to the dashboard folder must be `/opt/bitnami/grafana/dashboards`.
  1. To create a dashboard, it is needed to have a datasource for it. The datasources must be created mounting a secret with all the datasource files in it. In this case, it is not a ConfigMap because the datasource could contain sensitive information.
  2. To load the dashboards themselves you need to create a ConfigMap for each one containing the `json` file that defines the dashboard and set the array with the ConfigMap names into the `dashboardsConfigMaps` parameter.
Note the difference between the datasources and the dashboards creation. For the datasources we can use just one secret with all of the files, while for the dashboards we need one ConfigMap per file.

For example, create the dashboard ConfigMap(s) and datasource Secret as described below:

```console
$ kubectl create secret generic datasource-secret --from-file=datasource-secret.yaml
$ kubectl create configmap my-dashboard-1 --from-file=my-dashboard-1.json
$ kubectl create configmap my-dashboard-2 --from-file=my-dashboard-2.json
```

> Note: the commands above assume you had previously exported your dashboards in the JSON files: *my-dashboard-1.json* and *my-dashboard-2.json*

> Note: the commands above assume you had previously created a datasource config file *datasource-secret.yaml*. Find an example at https://grafana.com/docs/grafana/latest/administration/provisioning/#example-datasource-config-file

Once you have them, use the following parameters to deploy Grafana with 2 custom dashboards:

```console
dashboardsProvider.enabled=true
datasources.secretName=datasource-secret
dashboardsConfigMaps[0].configMapName=my-dashboard-1
dashboardsConfigMaps[0].fileName=my-dashboard-1.json
dashboardsConfigMaps[1].configMapName=my-dashboard-2
dashboardsConfigMaps[1].fileName=my-dashboard-2.json
```

More info at [Grafana documentation](https://grafana.com/docs/grafana/latest/administration/provisioning/#dashboards).

### LDAP configuration

To enable LDAP authentication it is necessary to provide a ConfigMap with the Grafana LDAP configuration file. For instance:

**configmap.yaml**:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: ldap-config
data:
  ldap.toml: |-
      [[servers]]
      # Ldap server host (specify multiple hosts space separated)
      host = "ldap"
      # Default port is 389 or 636 if use_ssl = true
      port = 389
      # Set to true if ldap server supports TLS
      use_ssl = false
      # Set to true if connect ldap server with STARTTLS pattern (create connection in insecure, then upgrade to secure connection with TLS)
      start_tls = false
      # set to true if you want to skip ssl cert validation
      ssl_skip_verify = false
      # set to the path to your root CA certificate or leave unset to use system defaults
      # root_ca_cert = "/path/to/certificate.crt"
      # Authentication against LDAP servers requiring client certificates
      # client_cert = "/path/to/client.crt"
      # client_key = "/path/to/client.key"

      # Search user bind dn
      bind_dn = "cn=admin,dc=example,dc=org"
      # Search user bind password
      # If the password contains # or ; you have to wrap it with triple quotes. Ex """#password;"""
      bind_password = 'admin'

      # User search filter, for example "(cn=%s)" or "(sAMAccountName=%s)" or "(uid=%s)"
      # Allow login from email or username, example "(|(sAMAccountName=%s)(userPrincipalName=%s))"
      search_filter = "(uid=%s)"

      # An array of base dns to search through
      search_base_dns = ["ou=People,dc=support,dc=example,dc=org"]

      # group_search_filter = "(&(objectClass=posixGroup)(memberUid=%s))"
      # group_search_filter_user_attribute = "distinguishedName"
      # group_search_base_dns = ["ou=groups,dc=grafana,dc=org"]

      # Specify names of the ldap attributes your ldap uses
      [servers.attributes]
      name = "givenName"
      surname = "sn"
      username = "cn"
      member_of = "memberOf"
      email =  "email"
```

Create the ConfigMap into the cluster and deploy the Grafana Helm Chart using the existing ConfigMap and the following parameters:

```console
ldap.enabled=true
ldap.configMapName=ldap-config
ldap.allowSignUp=true
```

### Supporting HA (High Availability)

To support HA Grafana just need an external database where store dashboards, users and other persistent data.
To configure the external database provide a configuration file containing the [database section](https://grafana.com/docs/installation/configuration/#database)

More information about Grafana HA [here](https://grafana.com/docs/tutorials/ha_setup/)

## Persistence

The [Bitnami Grafana](https://github.com/bitnami/bitnami-docker-grafana) image stores the Grafana data and configurations at the `/opt/bitnami/grafana/data` path of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Parameters](#parameters) section to configure the PVC or to disable persistence.

## Upgrading

### To 3.0.0

Deployment label selector is immutable after it gets created, so you cannot "upgrade".

In https://github.com/bitnami/charts/pull/2773 the deployment label selectors of the resources were updated to add the component name. Resulting in compatibility breakage.

In order to "upgrade" from a previous version, you will need to [uninstall](#uninstalling-the-chart) the existing chart manually.

This major version signifies this change.
