# Grafana

[Grafana](https://grafana.com/) is an open source, feature rich metrics dashboard and graph editor for Graphite, Elasticsearch, OpenTSDB, Prometheus and InfluxDB<sup>TM</sup>.

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
- Helm 3.1.0
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

## Differences between the Bitnami Grafana chart and the Bitnami Grafana Operator chart

In the Bitnami catalog we offer both the bitnami/grafana and bitnami/grafana-operator charts. Each solution covers different needs and use cases.

The *bitnami/grafana* chart deploys a single Grafana installation (with grafana-image-renderer) using a Kubernetes Deployment object (together with Services, PVCs, ConfigMaps, etc.). The figure below shows the deployed objects in the cluster after executing *helm install*:

```
                    +--------------+             +-----+
                    |              |             |     |
 Service & Ingress  |    Grafana   +<------------+ PVC |
<-------------------+              |             |     |
                    |  Deployment  |             +-----+
                    |              |
                    +-----------+--+
                                ^                +------------+
                                |                |            |
                                +----------------+ Configmaps |
                                                 |   Secrets  |
                                                 |            |
                                                 +------------+

```

Its lifecycle is managed using Helm and, at the Grafana container level, the following operations are automated: persistence management, configuration based on environment variables and plugin initialization. The chart also allows deploying dashboards and data sources using ConfigMaps. The Deployments do not require any ServiceAccounts with special RBAC privileges so this solution would fit better in more restricted Kubernetes installations.

The *bitnami/grafana-operator* chart deploys a Grafana Operator installation using a Kubernetes Deployment.  The figure below shows the Grafana operator deployment after executing *helm install*:

```
+--------------------+
|                    |      +---------------+
|  Grafana Operator  |      |               |
|                    |      |     RBAC      |
|    Deployment      |      |   Privileges  |
|                    |      |               |
+-------+------------+      +-------+-------+
        ^                           |
        |   +-----------------+     |
        +---+ Service Account +<----+
            +-----------------+
```

The operator will extend the Kubernetes API with the following objects: *Grafana*, *GrafanaDashboards* and *GrafanaDataSources*. From that moment, the user will be able to deploy objects of these kinds and the previously deployed Operator will take care of deploying all the required Deployments, ConfigMaps and Services for running a Grafana instance. Its lifecycle is managed using *kubectl* on the Grafana, GrafanaDashboards and GrafanaDataSource objects. The following figure shows the deployed objects after
 deploying a *Grafana* object using *kubectl*:

```
+--------------------+
|                    |      +---------------+
|  Grafana Operator  |      |               |
|                    |      |     RBAC      |
|    Deployment      |      |   Privileges  |
|                    |      |               |
+--+----+------------+      +-------+-------+
   |    ^                           |
   |    |   +-----------------+     |
   |    +---+ Service Account +<----+
   |        +-----------------+
   |
   |
   |
   |
   |                                                   Grafana
   |                     +---------------------------------------------------------------------------+
   |                     |                                                                           |
   |                     |                          +--------------+             +-----+             |
   |                     |                          |              |             |     |             |
   +-------------------->+       Service & Ingress  |    Grafana   +<------------+ PVC |             |
                         |      <-------------------+              |             |     |             |
                         |                          |  Deployment  |             +-----+             |
                         |                          |              |                                 |
                         |                          +-----------+--+                                 |
                         |                                      ^                +------------+      |
                         |                                      |                |            |      |
                         |                                      +----------------+ Configmaps |      |
                         |                                                       |   Secrets  |      |
                         |                                                       |            |      |
                         |                                                       +------------+      |
                         |                                                                           |
                         +---------------------------------------------------------------------------+

```

This solution allows to easily deploy multiple Grafana instances compared to the *bitnami/grafana* chart. As the operator automatically deploys Grafana installations, the Grafana Operator pods will require a ServiceAccount with privileges to create and destroy mulitple Kubernetes objects. This may be problematic for Kubernetes clusters with strict role-based access policies.

## Parameters

### Global parameters

| Name                      | Description                                     | Value |
| ------------------------- | ----------------------------------------------- | ----- |
| `global.imageRegistry`    | Global Docker image registry                    | `nil` |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]`  |
| `global.storageClass`     | Global StorageClass for Persistent Volume(s)    | `nil` |


### Common parameters

| Name               | Description                                                                             | Value           |
| ------------------ | --------------------------------------------------------------------------------------- | --------------- |
| `kubeVersion`      | Force target Kubernetes version (using Helm capabilities if not set)                    | `nil`           |
| `extraDeploy`      | Array of extra objects to deploy with the release                                       | `[]`            |
| `nameOverride`     | String to partially override grafana.fullname template (will maintain the release name) | `nil`           |
| `fullnameOverride` | String to fully override grafana.fullname template                                      | `nil`           |
| `clusterDomain`    | Default Kubernetes cluster domain                                                       | `cluster.local` |


### Grafana parameters

| Name                               | Description                                                                       | Value                |
| ---------------------------------- | --------------------------------------------------------------------------------- | -------------------- |
| `image.registry`                   | Grafana image registry                                                            | `docker.io`          |
| `image.repository`                 | Grafana image repository                                                          | `bitnami/grafana`    |
| `image.tag`                        | Grafana image tag (immutable tags are recommended)                                | `8.0.4-debian-10-r0` |
| `image.pullPolicy`                 | Grafana image pull policy                                                         | `IfNotPresent`       |
| `image.pullSecrets`                | Grafana image pull secrets                                                        | `[]`                 |
| `hostAliases`                      | Add deployment host aliases                                                       | `[]`                 |
| `admin.user`                       | Grafana admin username                                                            | `admin`              |
| `admin.password`                   | Admin password. If a password is not provided a random password will be generated | `nil`                |
| `admin.existingSecret`             | Name of the existing secret containing admin password                             | `nil`                |
| `admin.existingSecretPasswordKey`  | Password key on the existing secret                                               | `password`           |
| `smtp.enabled`                     | Enable SMTP configuration                                                         | `false`              |
| `smtp.user`                        | SMTP user                                                                         | `user`               |
| `smtp.password`                    | SMTP password                                                                     | `password`           |
| `smtp.host`                        | Custom host for the smtp server                                                   | `nil`                |
| `smtp.existingSecret`              | Name of existing secret containing SMTP credentials (user and password)           | `nil`                |
| `smtp.existingSecretUserKey`       | User key on the existing secret                                                   | `user`               |
| `smtp.existingSecretPasswordKey`   | Password key on the existing secret                                               | `password`           |
| `plugins`                          | Grafana plugins to be installed in deployment time separated by commas            | `nil`                |
| `ldap.enabled`                     | Enable LDAP for Grafana                                                           | `false`              |
| `ldap.allowSignUp`                 | Allows LDAP sign up for Grafana                                                   | `false`              |
| `ldap.configMapName`               | Name of the ConfigMap with the LDAP configuration file for Grafana                | `nil`                |
| `extraEnvVars`                     | Array containing extra env vars to configure Grafana                              | `{}`                 |
| `extraConfigmaps`                  | Array to mount extra ConfigMaps to configure Grafana                              | `{}`                 |
| `config.useGrafanaIniFile`         | Allows to load a `grafana.ini` file                                               | `false`              |
| `config.grafanaIniConfigMap`       | Name of the ConfigMap containing the `grafana.ini` file                           | `nil`                |
| `config.grafanaIniSecret`          | Name of the Secret containing the `grafana.ini` file                              | `nil`                |
| `dashboardsProvider.enabled`       | Enable the use of a Grafana dashboard provider                                    | `false`              |
| `dashboardsProvider.configMapName` | Name of a ConfigMap containing a custom dashboard provider                        | `nil`                |
| `dashboardsConfigMaps`             | Array with the names of a series of ConfigMaps containing dashboards files        | `[]`                 |
| `datasources.secretName`           | Secret name containing custom datasource files                                    | `nil`                |


### Deployment parameters

| Name                                 | Description                                                                               | Value           |
| ------------------------------------ | ----------------------------------------------------------------------------------------- | --------------- |
| `replicaCount`                       | Number of Grafana nodes                                                                   | `1`             |
| `updateStrategy.type`                | Set up update strategy for Grafana installation.                                          | `RollingUpdate` |
| `schedulerName`                      | Alternative scheduler                                                                     | `nil`           |
| `priorityClassName`                  | Priority class name                                                                       | `""`            |
| `podLabels`                          | Extra labels for Grafana pods                                                             | `{}`            |
| `podAnnotations`                     | Grafana Pod annotations                                                                   | `{}`            |
| `podAffinityPreset`                  | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`       | `""`            |
| `podAntiAffinityPreset`              | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`  | `soft`          |
| `nodeAffinityPreset.type`            | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard` | `""`            |
| `nodeAffinityPreset.key`             | Node label key to match Ignored if `affinity` is set.                                     | `""`            |
| `nodeAffinityPreset.values`          | Node label values to match. Ignored if `affinity` is set.                                 | `[]`            |
| `affinity`                           | Affinity for pod assignment                                                               | `{}`            |
| `nodeSelector`                       | Node labels for pod assignment                                                            | `{}`            |
| `tolerations`                        | Tolerations for pod assignment                                                            | `[]`            |
| `securityContext.enabled`            | Enable securityContext on for Grafana deployment                                          | `true`          |
| `securityContext.fsGroup`            | Group to configure permissions for volumes                                                | `1001`          |
| `securityContext.runAsUser`          | User for the security context                                                             | `1001`          |
| `securityContext.runAsNonRoot`       | Run containers as non-root users                                                          | `true`          |
| `resources.limits`                   | The resources limits for Grafana containers                                               | `{}`            |
| `resources.requests`                 | The requested resources for Grafana containers                                            | `{}`            |
| `livenessProbe.enabled`              | Enable livenessProbe                                                                      | `true`          |
| `livenessProbe.initialDelaySeconds`  | Initial delay seconds for livenessProbe                                                   | `120`           |
| `livenessProbe.periodSeconds`        | Period seconds for livenessProbe                                                          | `10`            |
| `livenessProbe.timeoutSeconds`       | Timeout seconds for livenessProbe                                                         | `5`             |
| `livenessProbe.failureThreshold`     | Failure threshold for livenessProbe                                                       | `6`             |
| `livenessProbe.successThreshold`     | Success threshold for livenessProbe                                                       | `1`             |
| `readinessProbe.enabled`             | Enable readinessProbe                                                                     | `true`          |
| `readinessProbe.initialDelaySeconds` | Initial delay seconds for readinessProbe                                                  | `30`            |
| `readinessProbe.periodSeconds`       | Period seconds for readinessProbe                                                         | `10`            |
| `readinessProbe.timeoutSeconds`      | Timeout seconds for readinessProbe                                                        | `5`             |
| `readinessProbe.failureThreshold`    | Failure threshold for readinessProbe                                                      | `6`             |
| `readinessProbe.successThreshold`    | Success threshold for readinessProbe                                                      | `1`             |
| `sidecars`                           | Attach additional sidecar containers to the Grafana pod                                   | `{}`            |
| `extraVolumes`                       | Additional volumes for the Grafana pod                                                    | `[]`            |
| `extraVolumeMounts`                  | Additional volume mounts for the Grafana container                                        | `[]`            |


### Persistence parameters

| Name                        | Description                                                                                               | Value           |
| --------------------------- | --------------------------------------------------------------------------------------------------------- | --------------- |
| `persistence.enabled`       | Enable persistence                                                                                        | `true`          |
| `persistence.accessMode`    | Access mode to the PV                                                                                     | `ReadWriteOnce` |
| `persistence.storageClass`  | Storage class to use with the PVC                                                                         | `nil`           |
| `persistence.existingClaim` | If you want to reuse an existing claim, you can pass the name of the PVC using the existingClaim variable | `nil`           |
| `persistence.size`          | Size for the PV                                                                                           | `10Gi`          |


### RBAC parameters

| Name                         | Description                                                                                                           | Value  |
| ---------------------------- | --------------------------------------------------------------------------------------------------------------------- | ------ |
| `serviceAccount.create`      | Specifies whether a ServiceAccount should be created                                                                  | `true` |
| `serviceAccount.name`        | The name of the ServiceAccount to use. If not set and create is true, a name is generated using the fullname template | `nil`  |
| `serviceAccount.annotations` | Annotations to add to the ServiceAccount Metadata                                                                     | `{}`   |


### Traffic exposure parameters

| Name                               | Description                                                                                   | Value                    |
| ---------------------------------- | --------------------------------------------------------------------------------------------- | ------------------------ |
| `service.type`                     | Kubernetes Service type                                                                       | `ClusterIP`              |
| `service.port`                     | Grafana service port                                                                          | `3000`                   |
| `service.nodePort`                 | Specify the nodePort value for the LoadBalancer and NodePort service types                    | `nil`                    |
| `service.loadBalancerIP`           | loadBalancerIP if Grafana service type is `LoadBalancer` (optional, cloud specific)           | `nil`                    |
| `service.loadBalancerSourceRanges` | loadBalancerSourceRanges if Grafana service type is `LoadBalancer` (optional, cloud specific) | `[]`                     |
| `service.annotations`              | Provide any additional annotations which may be required.                                     | `{}`                     |
| `ingress.enabled`                  | Set to true to enable ingress record generation                                               | `false`                  |
| `ingress.certManager`              | Set this to true in order to add the corresponding annotations for cert-manager               | `false`                  |
| `ingress.pathType`                 | Ingress Path type                                                                             | `ImplementationSpecific` |
| `ingress.apiVersion`               | Override API Version (automatically detected if not set)                                      | `nil`                    |
| `ingress.hostname`                 | When the ingress is enabled, a host pointing to this will be created                          | `grafana.local`          |
| `ingress.path`                     | Default path for the ingress resource                                                         | `ImplementationSpecific` |
| `ingress.annotations`              | Ingress annotations                                                                           | `{}`                     |
| `ingress.tls`                      | Enable TLS configuration for the hostname defined at ingress.hostname parameter               | `false`                  |
| `ingress.extraHosts`               | The list of additional hostnames to be covered with this ingress record.                      | `[]`                     |
| `ingress.extraPaths`               | Any additional arbitrary paths that may need to be added to the ingress under the main host.  | `[]`                     |
| `ingress.extraTls`                 | The tls configuration for additional hostnames to be covered with this ingress record.        | `[]`                     |
| `ingress.secrets`                  | If you're providing your own certificates, please use this to add the certificates as secrets | `[]`                     |
| `ingress.secrets`                  | It is also possible to create and manage the certificates outside of this helm chart          | `[]`                     |


### Metrics parameters

| Name                                   | Description                                                                                            | Value   |
| -------------------------------------- | ------------------------------------------------------------------------------------------------------ | ------- |
| `metrics.enabled`                      | Enable the export of Prometheus metrics                                                                | `false` |
| `metrics.service.annotations`          | Annotations for Prometheus metrics service                                                             | `{}`    |
| `metrics.serviceMonitor.enabled`       | if `true`, creates a Prometheus Operator ServiceMonitor (also requires `metrics.enabled` to be `true`) | `false` |
| `metrics.serviceMonitor.namespace`     | Namespace in which Prometheus is running                                                               | `nil`   |
| `metrics.serviceMonitor.interval`      | Interval at which metrics should be scraped.                                                           | `nil`   |
| `metrics.serviceMonitor.scrapeTimeout` | Timeout after which the scrape is ended                                                                | `nil`   |
| `metrics.serviceMonitor.selector`      | Prometheus instance selector labels                                                                    | `{}`    |


### Grafana Image Renderer parameters

| Name                                                 | Description                                                                                            | Value                            |
| ---------------------------------------------------- | ------------------------------------------------------------------------------------------------------ | -------------------------------- |
| `imageRenderer.enabled`                              | Enable using a remote rendering service to render PNG images                                           | `false`                          |
| `imageRenderer.image.registry`                       | Grafana Image Renderer image registry                                                                  | `docker.io`                      |
| `imageRenderer.image.repository`                     | Grafana Image Renderer image repository                                                                | `bitnami/grafana-image-renderer` |
| `imageRenderer.image.tag`                            | Grafana Image Renderer image tag (immutable tags are recommended)                                      | `3.0.1-debian-10-r6`             |
| `imageRenderer.image.pullPolicy`                     | Grafana Image Renderer image pull policy                                                               | `IfNotPresent`                   |
| `imageRenderer.image.pullSecrets`                    | Grafana image Renderer pull secrets                                                                    | `[]`                             |
| `imageRenderer.replicaCount`                         | Number of Grafana Image Renderer Pod replicas                                                          | `1`                              |
| `imageRenderer.podAnnotations`                       | Grafana Image Renderer Pod annotations                                                                 | `{}`                             |
| `imageRenderer.nodeSelector`                         | Node labels for pod assignment                                                                         | `{}`                             |
| `imageRenderer.tolerations`                          | Tolerations for pod assignment                                                                         | `[]`                             |
| `imageRenderer.affinity`                             | Affinity for pod assignment                                                                            | `{}`                             |
| `imageRenderer.resources.limits`                     | The resources limits for Grafana Image Renderer containers                                             | `{}`                             |
| `imageRenderer.resources.requests`                   | The requested resources for Grafana Image Renderer containers                                          | `{}`                             |
| `imageRenderer.securityContext.enabled`              | Enable securityContext on for Grafana Image Renderer deployment                                        | `true`                           |
| `imageRenderer.securityContext.fsGroup`              | Group to configure permissions for volumes                                                             | `1001`                           |
| `imageRenderer.securityContext.runAsUser`            | User for the security context                                                                          | `1001`                           |
| `imageRenderer.securityContext.runAsNonRoot`         | Run containers as non-root users                                                                       | `true`                           |
| `imageRenderer.service.port`                         | Grafana Image Renderer metrics port                                                                    | `8080`                           |
| `imageRenderer.metrics.enabled`                      | Enable the export of Prometheus metrics                                                                | `false`                          |
| `imageRenderer.metrics.annotations`                  | Prometheus annotations                                                                                 | `{}`                             |
| `imageRenderer.metrics.serviceMonitor.enabled`       | if `true`, creates a Prometheus Operator ServiceMonitor (also requires `metrics.enabled` to be `true`) | `false`                          |
| `imageRenderer.metrics.serviceMonitor.namespace`     | Namespace in which Prometheus is running                                                               | `nil`                            |
| `imageRenderer.metrics.serviceMonitor.interval`      | Interval at which metrics should be scraped.                                                           | `nil`                            |
| `imageRenderer.metrics.serviceMonitor.scrapeTimeout` | Timeout after which the scrape is ended                                                                | `nil`                            |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install my-release \
  --set admin.user=admin-user bitnami/grafana
```

The above command sets the Grafana admin user to `admin-user`.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
$ helm install my-release -f values.yaml bitnami/grafana
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

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

### Setting Pod's affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

## Persistence

The [Bitnami Grafana](https://github.com/bitnami/bitnami-docker-grafana) image stores the Grafana data and configurations at the `/opt/bitnami/grafana/data` path of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Parameters](#parameters) section to configure the PVC or to disable persistence.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami’s Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 4.1.0

This version also introduces `bitnami/common`, a [library chart](https://helm.sh/docs/topics/library_charts/#helm) as a dependency. More documentation about this new utility could be found [here](https://github.com/bitnami/charts/tree/master/bitnami/common#bitnami-common-library-chart). Please, make sure that you have updated the chart dependencies before executing any upgrade.

### To 4.0.0

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

### To 3.0.0

Deployment label selector is immutable after it gets created, so you cannot "upgrade".

In https://github.com/bitnami/charts/pull/2773 the deployment label selectors of the resources were updated to add the component name. Resulting in compatibility breakage.

In order to "upgrade" from a previous version, you will need to [uninstall](#uninstalling-the-chart) the existing chart manually.

This major version signifies this change.
