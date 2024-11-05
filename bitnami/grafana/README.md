<!--- app-name: Grafana -->

# Bitnami package for Grafana

Grafana is an open source metric analytics and visualization suite for visualizing time series data that supports various types of data sources.

[Overview of Grafana](https://grafana.com/)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/grafana
```

Looking to use Grafana in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the commercial edition of the Bitnami catalog.

## Introduction

This chart bootstraps a [grafana](https://github.com/bitnami/containers/tree/main/bitnami/grafana) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Differences between the Bitnami Grafana chart and the Bitnami Grafana Operator chart

In the Bitnami catalog we offer both the bitnami/grafana and bitnami/grafana-operator charts. Each solution covers different needs and use cases.

The *bitnami/grafana* chart deploys a single Grafana installation using a Kubernetes Deployment object (together with Services, PVCs, ConfigMaps, etc.). The figure below shows the deployed objects in the cluster after executing *helm install*:

```text
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

```text
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

```text
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

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+
- PV provisioner support in the underlying infrastructure
- ReadWriteMany volumes for deployment scaling

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/grafana
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

These commands deploy grafana on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Configuration and installation details

### Resource requests and limits

Bitnami charts allow setting resource requests and limits for all containers inside the chart deployment. These are inside the `resources` value (check parameter table). Setting requests is essential for production workloads and these should be adapted to your specific use case.

To make this process easier, the chart contains the `resourcesPreset` values, which automatically sets the `resources` section according to different presets. Check these presets in [the bitnami/common chart](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15). However, in production workloads using `resourcePreset` is discouraged as it may not fully adapt to your specific needs. Find more information on container resource management in the [official Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).

### [Rolling VS Immutable tags](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html)

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
kubectl create secret generic datasource-secret --from-file=datasource-secret.yaml
kubectl create configmap my-dashboard-1 --from-file=my-dashboard-1.json
kubectl create configmap my-dashboard-2 --from-file=my-dashboard-2.json
```

> Note: the commands above assume you had previously exported your dashboards in the JSON files: *my-dashboard-1.json* and *my-dashboard-2.json*
> Note: the commands above assume you had previously created a datasource config file *datasource-secret.yaml*. Find an example at <https://grafana.com/docs/grafana/latest/administration/provisioning/#example-datasource-config-file>

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

### Installing Grafana Image Renderer Plugin

In order to install the [Grafana Image Renderer Plugin](https://github.com/grafana/grafana-image-renderer) so you rely on it to render images and save memory on Grafana pods, follow the steps below:

1. Create a Grafana Image Renderer deployment and service using the K8s manifests below:

```yaml
# deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: grafana-image-renderer
  namespace: default
  labels:
    app.kubernetes.io/name: grafana-image-renderer
    app.kubernetes.io/instance: grafana-image-renderer
    app.kubernetes.io/component: image-renderer-plugin
    app.kubernetes.io/part-of: grafana
spec:
  replicas: 1
  strategy:
    type: RollingUpdate
  selector:
    matchLabels:
      app.kubernetes.io/name: grafana-image-renderer
      app.kubernetes.io/instance: grafana-image-renderer
      app.kubernetes.io/component: image-renderer-plugin
  template:
    metadata:
      labels:
        app.kubernetes.io/name: grafana-image-renderer
        app.kubernetes.io/instance: grafana-image-renderer
        app.kubernetes.io/component: image-renderer-plugin
        app.kubernetes.io/part-of: grafana
    spec:
      securityContext:
        fsGroup: 1001
        runAsNonRoot: true
        runAsUser: 1001
      containers:
        - name: grafana-image-renderer
          image: docker.io/bitnami/grafana-image-renderer:3
          securityContext:
            runAsUser: 1001
          env:
            - name: HTTP_HOST
              value: "::"
            - name: HTTP_PORT
              value: "8080"
          ports:
            - name: http
              containerPort: 8080
              protocol: TCP
# service.yaml
apiVersion: v1
kind: Service
metadata:
  name: grafana-image-renderer
  namespace: default
  labels:
    app.kubernetes.io/name: grafana-image-renderer
    app.kubernetes.io/instance: grafana-image-renderer
    app.kubernetes.io/component: image-renderer-plugin
    app.kubernetes.io/part-of: grafana
spec:
  type: ClusterIP
  sessionAffinity: None
  ports:
    - port: 8080
      targetPort: http
      protocol: TCP
      name: http
  selector:
    app.kubernetes.io/name: grafana-image-renderer
    app.kubernetes.io/instance: grafana-image-renderer
    app.kubernetes.io/component: image-renderer-plugin
```

1. Upgrade your chart release adding the following block to your `values.yaml` file:

```yaml
imageRenderer:
  enabled: true
  serverURL: "http://grafana-image-renderer.default.svc.cluster.local:8080/render"
  callbackURL: "http://grafana.default.svc.cluster.local:3000/"
```

> Note: the steps above assume an installation in the `default` namespace. If you are installing the chart in a different namespace, adjust the manifests and the `serverURL` & `callbackURL` values accordingly.

### Supporting HA (High Availability)

To support HA Grafana just need an external database where store dashboards, users and other persistent data.
To configure the external database provide a configuration file containing the [database section](https://grafana.com/docs/installation/configuration/#database)

More information about Grafana HA [here](https://grafana.com/docs/tutorials/ha_setup/)

### Setting Pod's affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

## Persistence

The [Bitnami Grafana](https://github.com/bitnami/containers/tree/main/bitnami/grafana) image stores the Grafana data and configurations at the `/opt/bitnami/grafana/data` path of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Parameters](#parameters) section to configure the PVC or to disable persistence.

## Parameters

### Global parameters

| Name                                                  | Description                                                                                                                                                                                                                                                                                                                                                         | Value  |
| ----------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------ |
| `global.imageRegistry`                                | Global Docker image registry                                                                                                                                                                                                                                                                                                                                        | `""`   |
| `global.imagePullSecrets`                             | Global Docker registry secret names as an array                                                                                                                                                                                                                                                                                                                     | `[]`   |
| `global.defaultStorageClass`                          | Global default StorageClass for Persistent Volume(s)                                                                                                                                                                                                                                                                                                                | `""`   |
| `global.storageClass`                                 | DEPRECATED: use global.defaultStorageClass instead                                                                                                                                                                                                                                                                                                                  | `""`   |
| `global.compatibility.openshift.adaptSecurityContext` | Adapt the securityContext sections of the deployment to make them compatible with Openshift restricted-v2 SCC: remove runAsUser, runAsGroup and fsGroup and let the platform use their allowed default IDs. Possible values: auto (apply if the detected running cluster is Openshift), force (perform the adaptation always), disabled (do not perform adaptation) | `auto` |

### Common parameters

| Name                | Description                                                                             | Value           |
| ------------------- | --------------------------------------------------------------------------------------- | --------------- |
| `kubeVersion`       | Force target Kubernetes version (using Helm capabilities if not set)                    | `""`            |
| `extraDeploy`       | Array of extra objects to deploy with the release                                       | `[]`            |
| `nameOverride`      | String to partially override grafana.fullname template (will maintain the release name) | `""`            |
| `fullnameOverride`  | String to fully override grafana.fullname template                                      | `""`            |
| `clusterDomain`     | Default Kubernetes cluster domain                                                       | `cluster.local` |
| `commonLabels`      | Labels to add to all deployed objects                                                   | `{}`            |
| `commonAnnotations` | Annotations to add to all deployed objects                                              | `{}`            |

### Grafana parameters

| Name                               | Description                                                                                                                                          | Value                             |
| ---------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------- |
| `image.registry`                   | Grafana image registry                                                                                                                               | `REGISTRY_NAME`                   |
| `image.repository`                 | Grafana image repository                                                                                                                             | `REPOSITORY_NAME/grafana`         |
| `image.digest`                     | Grafana image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                              | `""`                              |
| `image.pullPolicy`                 | Grafana image pull policy                                                                                                                            | `IfNotPresent`                    |
| `image.pullSecrets`                | Grafana image pull secrets                                                                                                                           | `[]`                              |
| `admin.user`                       | Grafana admin username                                                                                                                               | `admin`                           |
| `admin.password`                   | Admin password. If a password is not provided a random password will be generated                                                                    | `""`                              |
| `admin.existingSecret`             | Name of the existing secret containing admin password                                                                                                | `""`                              |
| `admin.existingSecretPasswordKey`  | Password key on the existing secret                                                                                                                  | `password`                        |
| `smtp.enabled`                     | Enable SMTP configuration                                                                                                                            | `false`                           |
| `smtp.user`                        | SMTP user                                                                                                                                            | `user`                            |
| `smtp.password`                    | SMTP password                                                                                                                                        | `password`                        |
| `smtp.host`                        | Custom host for the smtp server                                                                                                                      | `""`                              |
| `smtp.fromAddress`                 | From address                                                                                                                                         | `""`                              |
| `smtp.fromName`                    | From name                                                                                                                                            | `""`                              |
| `smtp.skipVerify`                  | Enable skip verify                                                                                                                                   | `false`                           |
| `smtp.existingSecret`              | Name of existing secret containing SMTP credentials (user and password)                                                                              | `""`                              |
| `smtp.existingSecretUserKey`       | User key on the existing secret                                                                                                                      | `user`                            |
| `smtp.existingSecretPasswordKey`   | Password key on the existing secret                                                                                                                  | `password`                        |
| `plugins`                          | Grafana plugins to be installed in deployment time separated by commas                                                                               | `""`                              |
| `ldap.enabled`                     | Enable LDAP for Grafana                                                                                                                              | `false`                           |
| `ldap.allowSignUp`                 | Allows LDAP sign up for Grafana                                                                                                                      | `false`                           |
| `ldap.configuration`               | Specify content for ldap.toml configuration file                                                                                                     | `""`                              |
| `ldap.configMapName`               | Name of the ConfigMap with the ldap.toml configuration file for Grafana                                                                              | `""`                              |
| `ldap.secretName`                  | Name of the Secret with the ldap.toml configuration file for Grafana                                                                                 | `""`                              |
| `ldap.uri`                         | Server URI, eg. ldap://ldap_server:389                                                                                                               | `""`                              |
| `ldap.binddn`                      | DN of the account used to search in the LDAP server.                                                                                                 | `""`                              |
| `ldap.bindpw`                      | Password for binddn account.                                                                                                                         | `""`                              |
| `ldap.basedn`                      | Base DN path where binddn account will search for the users.                                                                                         | `""`                              |
| `ldap.searchAttribute`             | Field used to match with the user name (uid, samAccountName, cn, etc). This value will be ignored if 'ldap.searchFilter' is set                      | `uid`                             |
| `ldap.searchFilter`                | User search filter, for example "(cn=%s)" or "(sAMAccountName=%s)" or "(|(sAMAccountName=%s)(userPrincipalName=%s)"                                  | `""`                              |
| `ldap.extraConfiguration`          | Extra ldap configuration.                                                                                                                            | `""`                              |
| `ldap.tls.enabled`                 | Enabled TLS configuration.                                                                                                                           | `false`                           |
| `ldap.tls.startTls`                | Use STARTTLS instead of LDAPS.                                                                                                                       | `false`                           |
| `ldap.tls.skipVerify`              | Skip any SSL verification (hostanames or certificates)                                                                                               | `false`                           |
| `ldap.tls.certificatesMountPath`   | Where LDAP certifcates are mounted.                                                                                                                  | `/opt/bitnami/grafana/conf/ldap/` |
| `ldap.tls.certificatesSecret`      | Secret with LDAP certificates.                                                                                                                       | `""`                              |
| `ldap.tls.CAFilename`              | CA certificate filename. Should match with the CA entry key in the ldap.tls.certificatesSecret.                                                      | `""`                              |
| `ldap.tls.certFilename`            | Client certificate filename to authenticate against the LDAP server. Should match with certificate the entry key in the ldap.tls.certificatesSecret. | `""`                              |
| `ldap.tls.certKeyFilename`         | Client Key filename to authenticate against the LDAP server. Should match with certificate the entry key in the ldap.tls.certificatesSecret.         | `""`                              |
| `imageRenderer.enabled`            | Enable using a remote rendering service to render PNG images                                                                                         | `false`                           |
| `imageRenderer.serverURL`          | URL of the remote rendering service                                                                                                                  | `""`                              |
| `imageRenderer.callbackURL`        | URL of the callback service                                                                                                                          | `""`                              |
| `config.useGrafanaIniFile`         | Allows to load a `grafana.ini` file                                                                                                                  | `false`                           |
| `config.grafanaIniConfigMap`       | Name of the ConfigMap containing the `grafana.ini` file                                                                                              | `""`                              |
| `config.grafanaIniSecret`          | Name of the Secret containing the `grafana.ini` file                                                                                                 | `""`                              |
| `dashboardsProvider.enabled`       | Enable the use of a Grafana dashboard provider                                                                                                       | `false`                           |
| `dashboardsProvider.configMapName` | Name of a ConfigMap containing a custom dashboard provider                                                                                           | `""`                              |
| `dashboardsConfigMaps`             | Array with the names of a series of ConfigMaps containing dashboards files                                                                           | `[]`                              |
| `datasources.secretName`           | The name of an externally-managed secret containing custom datasource files.                                                                         | `""`                              |
| `datasources.secretDefinition`     | The contents of a secret defining a custom datasource file. Only used if datasources.secretName is empty or not defined.                             | `{}`                              |
| `notifiers.configMapName`          | Name of a ConfigMap containing Grafana notifiers configuration                                                                                       | `""`                              |
| `alerting.configMapName`           | Name of a ConfigMap containing Grafana alerting configuration                                                                                        | `""`                              |

### Grafana Deployment parameters

| Name                                                        | Description                                                                                                                                                                                                                       | Value            |
| ----------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| `grafana.replicaCount`                                      | Number of Grafana nodes                                                                                                                                                                                                           | `1`              |
| `grafana.updateStrategy.type`                               | Set up update strategy for Grafana installation.                                                                                                                                                                                  | `RollingUpdate`  |
| `grafana.automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                                | `false`          |
| `grafana.hostAliases`                                       | Add deployment host aliases                                                                                                                                                                                                       | `[]`             |
| `grafana.schedulerName`                                     | Alternative scheduler                                                                                                                                                                                                             | `""`             |
| `grafana.terminationGracePeriodSeconds`                     | In seconds, time the given to the Grafana pod needs to terminate gracefully                                                                                                                                                       | `""`             |
| `grafana.priorityClassName`                                 | Priority class name                                                                                                                                                                                                               | `""`             |
| `grafana.podLabels`                                         | Extra labels for Grafana pods                                                                                                                                                                                                     | `{}`             |
| `grafana.podAnnotations`                                    | Grafana Pod annotations                                                                                                                                                                                                           | `{}`             |
| `grafana.podAffinityPreset`                                 | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                               | `""`             |
| `grafana.podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                          | `soft`           |
| `grafana.containerPorts.grafana`                            | Grafana container port                                                                                                                                                                                                            | `3000`           |
| `grafana.extraPorts`                                        | Extra ports for Grafana deployment                                                                                                                                                                                                | `[]`             |
| `grafana.nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                         | `""`             |
| `grafana.nodeAffinityPreset.key`                            | Node label key to match Ignored if `affinity` is set.                                                                                                                                                                             | `""`             |
| `grafana.nodeAffinityPreset.values`                         | Node label values to match. Ignored if `affinity` is set.                                                                                                                                                                         | `[]`             |
| `grafana.affinity`                                          | Affinity for pod assignment                                                                                                                                                                                                       | `{}`             |
| `grafana.nodeSelector`                                      | Node labels for pod assignment                                                                                                                                                                                                    | `{}`             |
| `grafana.tolerations`                                       | Tolerations for pod assignment                                                                                                                                                                                                    | `[]`             |
| `grafana.topologySpreadConstraints`                         | Topology spread constraints rely on node labels to identify the topology domain(s) that each Node is in                                                                                                                           | `[]`             |
| `grafana.podSecurityContext.enabled`                        | Enable securityContext on for Grafana deployment                                                                                                                                                                                  | `true`           |
| `grafana.podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                                | `Always`         |
| `grafana.podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                                    | `[]`             |
| `grafana.podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                                       | `[]`             |
| `grafana.podSecurityContext.fsGroup`                        | Group to configure permissions for volumes                                                                                                                                                                                        | `1001`           |
| `grafana.containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                                                                                                                                              | `true`           |
| `grafana.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                                  | `{}`             |
| `grafana.containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                                                                                                                        | `1001`           |
| `grafana.containerSecurityContext.runAsGroup`               | Set containers' Security Context runAsGroup                                                                                                                                                                                       | `1001`           |
| `grafana.containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                                                                                                                                     | `true`           |
| `grafana.containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                                                                                                                                       | `false`          |
| `grafana.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                                           | `true`           |
| `grafana.containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                                                                                                                         | `false`          |
| `grafana.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                                | `["ALL"]`        |
| `grafana.containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                                  | `RuntimeDefault` |
| `grafana.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if grafana.resources is set (grafana.resources is recommended for production). | `nano`           |
| `grafana.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                 | `{}`             |
| `grafana.livenessProbe.enabled`                             | Enable livenessProbe                                                                                                                                                                                                              | `true`           |
| `grafana.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                                           | `120`            |
| `grafana.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                                  | `10`             |
| `grafana.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                                 | `5`              |
| `grafana.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                                               | `6`              |
| `grafana.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                                               | `1`              |
| `grafana.readinessProbe.enabled`                            | Enable readinessProbe                                                                                                                                                                                                             | `true`           |
| `grafana.readinessProbe.path`                               | Path for readinessProbe                                                                                                                                                                                                           | `/api/health`    |
| `grafana.readinessProbe.scheme`                             | Scheme for readinessProbe                                                                                                                                                                                                         | `HTTP`           |
| `grafana.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                                          | `30`             |
| `grafana.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                                 | `10`             |
| `grafana.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                                | `5`              |
| `grafana.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                                              | `6`              |
| `grafana.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                                              | `1`              |
| `grafana.startupProbe.enabled`                              | Enable startupProbe                                                                                                                                                                                                               | `false`          |
| `grafana.startupProbe.path`                                 | Path for readinessProbe                                                                                                                                                                                                           | `/api/health`    |
| `grafana.startupProbe.scheme`                               | Scheme for readinessProbe                                                                                                                                                                                                         | `HTTP`           |
| `grafana.startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                                            | `30`             |
| `grafana.startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                                   | `10`             |
| `grafana.startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                                  | `5`              |
| `grafana.startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                                | `6`              |
| `grafana.startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                                | `1`              |
| `grafana.customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                                                                                                                               | `{}`             |
| `grafana.customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                                                                                                                                              | `{}`             |
| `grafana.customStartupProbe`                                | Custom startupProbe that overrides the default one                                                                                                                                                                                | `{}`             |
| `grafana.lifecycleHooks`                                    | for the Grafana container(s) to automate configuration before or after startup                                                                                                                                                    | `{}`             |
| `grafana.sidecars`                                          | Attach additional sidecar containers to the Grafana pod                                                                                                                                                                           | `[]`             |
| `grafana.initContainers`                                    | Add additional init containers to the Grafana pod(s)                                                                                                                                                                              | `[]`             |
| `grafana.enableServiceLinks`                                | Whether information about services should be injected into pod's environment variable                                                                                                                                             | `true`           |
| `grafana.extraVolumes`                                      | Additional volumes for the Grafana pod                                                                                                                                                                                            | `[]`             |
| `grafana.extraVolumeMounts`                                 | Additional volume mounts for the Grafana container                                                                                                                                                                                | `[]`             |
| `grafana.extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for Grafana nodes                                                                                                                                                            | `""`             |
| `grafana.extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for Grafana nodes                                                                                                                                                               | `""`             |
| `grafana.extraEnvVars`                                      | Array containing extra env vars to configure Grafana                                                                                                                                                                              | `[]`             |
| `grafana.extraConfigmaps`                                   | Array to mount extra ConfigMaps to configure Grafana                                                                                                                                                                              | `[]`             |
| `grafana.command`                                           | Override default container command (useful when using custom images)                                                                                                                                                              | `[]`             |
| `grafana.args`                                              | Override default container args (useful when using custom images)                                                                                                                                                                 | `[]`             |
| `grafana.pdb.create`                                        | Enable/disable a Pod Disruption Budget creation                                                                                                                                                                                   | `true`           |
| `grafana.pdb.minAvailable`                                  | Minimum number/percentage of pods that should remain scheduled                                                                                                                                                                    | `""`             |
| `grafana.pdb.maxUnavailable`                                | Maximum number/percentage of pods that may be made unavailable. Defaults to `1` if both `grafana.pdb.minAvailable` and `grafana.pdb.maxUnavailable` are empty.                                                                    | `""`             |

### Persistence parameters

| Name                        | Description                                                                                               | Value           |
| --------------------------- | --------------------------------------------------------------------------------------------------------- | --------------- |
| `persistence.enabled`       | Enable persistence                                                                                        | `true`          |
| `persistence.annotations`   | Persistent Volume Claim annotations                                                                       | `{}`            |
| `persistence.accessMode`    | Persistent Volume Access Mode                                                                             | `ReadWriteOnce` |
| `persistence.accessModes`   | Persistent Volume Access Modes                                                                            | `[]`            |
| `persistence.storageClass`  | Storage class to use with the PVC                                                                         | `""`            |
| `persistence.existingClaim` | If you want to reuse an existing claim, you can pass the name of the PVC using the existingClaim variable | `""`            |
| `persistence.size`          | Size for the PV                                                                                           | `10Gi`          |

### RBAC parameters

| Name                                          | Description                                                                                                           | Value   |
| --------------------------------------------- | --------------------------------------------------------------------------------------------------------------------- | ------- |
| `serviceAccount.create`                       | Specifies whether a ServiceAccount should be created                                                                  | `true`  |
| `serviceAccount.name`                         | The name of the ServiceAccount to use. If not set and create is true, a name is generated using the fullname template | `""`    |
| `serviceAccount.annotations`                  | Annotations to add to the ServiceAccount Metadata                                                                     | `{}`    |
| `serviceAccount.automountServiceAccountToken` | Automount service account token for the application controller service account                                        | `false` |

### Traffic exposure parameters

| Name                                    | Description                                                                                                                      | Value                    |
| --------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `service.type`                          | Kubernetes Service type                                                                                                          | `ClusterIP`              |
| `service.clusterIP`                     | Grafana service Cluster IP                                                                                                       | `""`                     |
| `service.ports.grafana`                 | Grafana service port                                                                                                             | `3000`                   |
| `service.nodePorts.grafana`             | Specify the nodePort value for the LoadBalancer and NodePort service types                                                       | `""`                     |
| `service.loadBalancerIP`                | loadBalancerIP if Grafana service type is `LoadBalancer` (optional, cloud specific)                                              | `""`                     |
| `service.loadBalancerClass`             | loadBalancerClass if Grafana service type is `LoadBalancer` (optional, cloud specific)                                           | `""`                     |
| `service.loadBalancerSourceRanges`      | loadBalancerSourceRanges if Grafana service type is `LoadBalancer` (optional, cloud specific)                                    | `[]`                     |
| `service.annotations`                   | Provide any additional annotations which may be required.                                                                        | `{}`                     |
| `service.externalTrafficPolicy`         | Grafana service external traffic policy                                                                                          | `Cluster`                |
| `service.extraPorts`                    | Extra port to expose on Grafana service                                                                                          | `[]`                     |
| `service.sessionAffinity`               | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                                                             | `None`                   |
| `service.sessionAffinityConfig`         | Additional settings for the sessionAffinity                                                                                      | `{}`                     |
| `networkPolicy.enabled`                 | Specifies whether a NetworkPolicy should be created                                                                              | `true`                   |
| `networkPolicy.allowExternal`           | Don't require server label for connections                                                                                       | `true`                   |
| `networkPolicy.allowExternalEgress`     | Allow the pod to access any range of port and all destinations.                                                                  | `true`                   |
| `networkPolicy.addExternalClientAccess` | Allow access from pods with client label set to "true". Ignored if `networkPolicy.allowExternal` is true.                        | `true`                   |
| `networkPolicy.extraIngress`            | Add extra ingress rules to the NetworkPolicy                                                                                     | `[]`                     |
| `networkPolicy.extraEgress`             | Add extra ingress rules to the NetworkPolicy                                                                                     | `[]`                     |
| `networkPolicy.ingressPodMatchLabels`   | Labels to match to allow traffic from other pods. Ignored if `networkPolicy.allowExternal` is true.                              | `{}`                     |
| `networkPolicy.ingressNSMatchLabels`    | Labels to match to allow traffic from other namespaces. Ignored if `networkPolicy.allowExternal` is true.                        | `{}`                     |
| `networkPolicy.ingressNSPodMatchLabels` | Pod labels to match to allow traffic from other namespaces. Ignored if `networkPolicy.allowExternal` is true.                    | `{}`                     |
| `ingress.enabled`                       | Set to true to enable ingress record generation                                                                                  | `false`                  |
| `ingress.pathType`                      | Ingress Path type                                                                                                                | `ImplementationSpecific` |
| `ingress.apiVersion`                    | Override API Version (automatically detected if not set)                                                                         | `""`                     |
| `ingress.hostname`                      | When the ingress is enabled, a host pointing to this will be created                                                             | `grafana.local`          |
| `ingress.path`                          | Default path for the ingress resource                                                                                            | `/`                      |
| `ingress.annotations`                   | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                     |
| `ingress.tls`                           | Enable TLS configuration for the hostname defined at ingress.hostname parameter                                                  | `false`                  |
| `ingress.extraHosts`                    | The list of additional hostnames to be covered with this ingress record.                                                         | `[]`                     |
| `ingress.extraPaths`                    | Any additional arbitrary paths that may need to be added to the ingress under the main host.                                     | `[]`                     |
| `ingress.extraTls`                      | The tls configuration for additional hostnames to be covered with this ingress record.                                           | `[]`                     |
| `ingress.secrets`                       | If you're providing your own certificates, please use this to add the certificates as secrets                                    | `[]`                     |
| `ingress.secrets`                       | It is also possible to create and manage the certificates outside of this helm chart                                             | `[]`                     |
| `ingress.selfSigned`                    | Create a TLS secret for this ingress record using self-signed certificates generated by Helm                                     | `false`                  |
| `ingress.ingressClassName`              | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                    | `""`                     |
| `ingress.extraRules`                    | Additional rules to be covered with this ingress record                                                                          | `[]`                     |

### Metrics parameters

| Name                                       | Description                                                                                                                               | Value   |
| ------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `metrics.enabled`                          | Enable the export of Prometheus metrics                                                                                                   | `false` |
| `metrics.service.annotations`              | Annotations for Prometheus metrics service                                                                                                | `{}`    |
| `metrics.serviceMonitor.enabled`           | if `true`, creates a Prometheus Operator ServiceMonitor (also requires `metrics.enabled` to be `true`)                                    | `false` |
| `metrics.serviceMonitor.namespace`         | Namespace in which Prometheus is running                                                                                                  | `""`    |
| `metrics.serviceMonitor.interval`          | Interval at which metrics should be scraped.                                                                                              | `""`    |
| `metrics.serviceMonitor.scrapeTimeout`     | Timeout after which the scrape is ended                                                                                                   | `""`    |
| `metrics.serviceMonitor.selector`          | Prometheus instance selector labels                                                                                                       | `{}`    |
| `metrics.serviceMonitor.relabelings`       | RelabelConfigs to apply to samples before scraping                                                                                        | `[]`    |
| `metrics.serviceMonitor.metricRelabelings` | MetricRelabelConfigs to apply to samples before ingestion                                                                                 | `[]`    |
| `metrics.serviceMonitor.honorLabels`       | Labels to honor to add to the scrape endpoint                                                                                             | `false` |
| `metrics.serviceMonitor.labels`            | Additional custom labels for the ServiceMonitor                                                                                           | `{}`    |
| `metrics.serviceMonitor.jobLabel`          | The name of the label on the target service to use as the job name in prometheus.                                                         | `""`    |
| `metrics.prometheusRule.enabled`           | if `true`, creates a Prometheus Operator PrometheusRule (also requires `metrics.enabled` to be `true` and `metrics.prometheusRule.rules`) | `false` |
| `metrics.prometheusRule.namespace`         | Namespace for the PrometheusRule Resource (defaults to the Release Namespace)                                                             | `""`    |
| `metrics.prometheusRule.additionalLabels`  | Additional labels that can be used so PrometheusRule will be discovered by Prometheus                                                     | `{}`    |
| `metrics.prometheusRule.rules`             | PrometheusRule rules to configure                                                                                                         | `[]`    |

### Volume permissions init Container Parameters

| Name                                                        | Description                                                                                                                                                                                                                                           | Value                      |
| ----------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------- |
| `volumePermissions.enabled`                                 | Enable init container that changes the owner/group of the PV mount point to `runAsUser:fsGroup`                                                                                                                                                       | `false`                    |
| `volumePermissions.image.registry`                          | OS Shell + Utility image registry                                                                                                                                                                                                                     | `REGISTRY_NAME`            |
| `volumePermissions.image.repository`                        | OS Shell + Utility image repository                                                                                                                                                                                                                   | `REPOSITORY_NAME/os-shell` |
| `volumePermissions.image.digest`                            | OS Shell + Utility image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                                    | `""`                       |
| `volumePermissions.image.pullPolicy`                        | OS Shell + Utility image pull policy                                                                                                                                                                                                                  | `IfNotPresent`             |
| `volumePermissions.image.pullSecrets`                       | OS Shell + Utility image pull secrets                                                                                                                                                                                                                 | `[]`                       |
| `volumePermissions.resourcesPreset`                         | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if volumePermissions.resources is set (volumePermissions.resources is recommended for production). | `nano`                     |
| `volumePermissions.resources`                               | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                                     | `{}`                       |
| `volumePermissions.containerSecurityContext.seLinuxOptions` | Set SELinux options in container                                                                                                                                                                                                                      | `{}`                       |
| `volumePermissions.containerSecurityContext.runAsUser`      | Set init container's Security Context runAsUser                                                                                                                                                                                                       | `0`                        |

### Diagnostic Mode Parameters

| Name                     | Description                                                                             | Value          |
| ------------------------ | --------------------------------------------------------------------------------------- | -------------- |
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden) | `false`        |
| `diagnosticMode.command` | Command to override all containers in the deployment                                    | `["sleep"]`    |
| `diagnosticMode.args`    | Args to override all containers in the deployment                                       | `["infinity"]` |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
  --set admin.user=admin-user oci://REGISTRY_NAME/REPOSITORY_NAME/grafana
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The above command sets the Grafana admin user to `admin-user`.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml oci://REGISTRY_NAME/REPOSITORY_NAME/grafana
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.
> **Tip**: You can use the default [values.yaml](https://github.com/bitnami/charts/tree/main/bitnami/grafana/values.yaml)

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 11.0.0

This major release only bumps the Grafana version to 11.x. No major issues are expected during the upgrade. See the upstream documentation <https://grafana.com/docs/grafana/latest/whatsnew/whats-new-in-v11-0/> for more info about the changes included in this new major version of the application

### To 10.0.0

This major bump changes the following security defaults:

- `runAsGroup` is changed from `0` to `1001`
- `readOnlyRootFilesystem` is set to `true`
- `resourcesPreset` is changed from `none` to the minimum size working in our test suites (NOTE: `resourcesPreset` is not meant for production usage, but `resources` adapted to your use case).
- `global.compatibility.openshift.adaptSecurityContext` is changed from `disabled` to `auto`.

This could potentially break any customization or init scripts used in your deployment. If this is the case, change the default values to the previous ones.

### To 9.4.0

This version stops shipping the Grafana Image Renderer in the chart. In order to use this plugin, refer to the [Installing Grafana Image Renderer Plugin](#installing-grafana-image-renderer-plugin) instructions.

### To 8.0.0

This major release only bumps the Grafana version to 9.x. No major issues are expected during the upgrade. See the upstream changelog <https://grafana.com/docs/grafana/latest/release-notes/release-notes-9-0-0/> for more info about the changes included in this new major version of the application

### To 7.0.0

This major release renames several values in this chart and adds missing features, in order to be inline with the rest of assets in the Bitnami charts repository.

Since the volume access mode when persistence is enabled is `ReadWriteOnce` in order to upgrade the deployment you will need to either use the `Recreate` strategy or delete the old deployment.

```console
kubectl delete deployment <deployment-name>
helm upgrade <release-name> oci://REGISTRY_NAME/REPOSITORY_NAME/grafana
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

### To 4.1.0

This version also introduces `bitnami/common`, a [library chart](https://helm.sh/docs/topics/library_charts/#helm) as a dependency. More documentation about this new utility could be found [here](https://github.com/bitnami/charts/tree/main/bitnami/common#bitnami-common-library-chart). Please, make sure that you have updated the chart dependencies before executing any upgrade.

### To 4.0.0

[On November 13, 2020, Helm v2 support was formally finished](https://github.com/helm/charts#status-of-the-project), this major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

#### What changes were introduced in this major version?

- Previous versions of this Helm Chart use `apiVersion: v1` (installable by both Helm 2 and 3), this Helm Chart was updated to `apiVersion: v2` (installable by Helm 3 only). [Here](https://helm.sh/docs/topics/charts/#the-apiversion-field) you can find more information about the `apiVersion` field.
- The different fields present in the *Chart.yaml* file has been ordered alphabetically in a homogeneous way for all the Bitnami Helm Charts

#### Considerations when upgrading to this version

- If you want to upgrade to this version from a previous one installed with Helm v3, you shouldn't face any issues
- If you want to upgrade to this version using Helm v2, this scenario is not supported as this version doesn't support Helm v2 anymore
- If you installed the previous version with Helm v2 and wants to upgrade to this version with Helm v3, please refer to the [official Helm documentation](https://helm.sh/docs/topics/v2_v3_migration/#migration-use-cases) about migrating from Helm v2 to v3

#### Useful links

- <https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-resolve-helm2-helm3-post-migration-issues-index.html>
- <https://helm.sh/docs/topics/v2_v3_migration/>
- <https://helm.sh/blog/migrate-from-helm-v2-to-helm-v3/>

### To 3.0.0

Deployment label selector is immutable after it gets created, so you cannot "upgrade".

In <https://github.com/bitnami/charts/pull/2773> the deployment label selectors of the resources were updated to add the component name. Resulting in compatibility breakage.

In order to "upgrade" from a previous version, you will need to uninstall the existing chart manually.

This major version signifies this change.

## License

Copyright &copy; 2024 Broadcom. The term "Broadcom" refers to Broadcom Inc. and/or its subsidiaries.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

<http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.