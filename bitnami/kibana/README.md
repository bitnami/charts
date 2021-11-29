# Kibana

[Kibana](https://www.elastic.co/kibana/) is an open source, browser based analytics and search dashboard for Elasticsearch.

## TL;DR

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/kibana --set elasticsearch.hosts[0]=<Hostname of your ES instance> --set elasticsearch.port=<port of your ES instance>
```

## Introduction

This chart bootstraps a [Kibana](https://github.com/bitnami/bitnami-docker-kibana) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.12+
- Helm 3.1.0
- PV provisioner support in the underlying infrastructure
- ReadWriteMany volumes for deployment scaling

## Installing the Chart

This chart requires an Elasticsearch instance to work. You can use an already existing Elasticsearch instance.

 To install the chart with the release name `my-release`:

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release \
  --set elasticsearch.hosts[0]=<Hostname of your ES instance> \
  --set elasticsearch.port=<port of your ES instance> \
  bitnami/kibana
```

These commands deploy Kibana on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

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
| `global.storageClass`     | Global StorageClass for Persistent Volume(s)    | `""`  |


### Common parameters

| Name               | Description                                                                                               | Value |
| ------------------ | --------------------------------------------------------------------------------------------------------- | ----- |
| `kubeVersion`      | Force target Kubernetes version (using Helm capabilities if not set)                                      | `""`  |
| `nameOverride`     | String to partially override common.names.fullname template with a string (will prepend the release name) | `""`  |
| `fullnameOverride` | String to fully override common.names.fullname template with a string                                     | `""`  |
| `extraDeploy`      | Array of extra objects to deploy with the release                                                         | `[]`  |


### Kibana parameters

| Name                                   | Description                                                                                                                                               | Value                    |
| -------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `image.registry`                       | Kibana image registry                                                                                                                                     | `docker.io`              |
| `image.repository`                     | Kibana image repository                                                                                                                                   | `bitnami/kibana`         |
| `image.tag`                            | Kibana image tag (immutable tags are recommended)                                                                                                         | `7.15.2-debian-10-r0`    |
| `image.pullPolicy`                     | Kibana image pull policy                                                                                                                                  | `IfNotPresent`           |
| `image.pullSecrets`                    | Specify docker-registry secret names as an array                                                                                                          | `[]`                     |
| `replicaCount`                         | Number of replicas of the Kibana Pod                                                                                                                      | `1`                      |
| `updateStrategy.type`                  | Set up update strategy for Kibana installation.                                                                                                           | `RollingUpdate`          |
| `schedulerName`                        | Alternative scheduler                                                                                                                                     | `""`                     |
| `hostAliases`                          | Add deployment host aliases                                                                                                                               | `[]`                     |
| `plugins`                              | Array containing the Kibana plugins to be installed in deployment                                                                                         | `[]`                     |
| `savedObjects.urls`                    | Array containing links to NDJSON files to be imported during Kibana initialization                                                                        | `[]`                     |
| `savedObjects.configmap`               | Configmap containing NDJSON files to be imported during Kibana initialization (evaluated as a template)                                                   | `""`                     |
| `extraConfiguration`                   | Extra settings to be added to the default kibana.yml configmap that the chart creates (unless replaced using `configurationCM`). Evaluated as a template  | `{}`                     |
| `configurationCM`                      | ConfigMap containing a kibana.yml file that will replace the default one specified in configuration.yaml                                                  | `""`                     |
| `extraEnvVars`                         | Array containing extra env vars to configure Kibana                                                                                                       | `[]`                     |
| `extraEnvVarsCM`                       | ConfigMap containing extra env vars to configure Kibana                                                                                                   | `""`                     |
| `extraEnvVarsSecret`                   | Secret containing extra env vars to configure Kibana (in case of sensitive data)                                                                          | `""`                     |
| `extraVolumes`                         | Array to add extra volumes. Requires setting `extraVolumeMounts`                                                                                          | `[]`                     |
| `extraVolumeMounts`                    | Array to add extra mounts. Normally used with `extraVolumes`                                                                                              | `[]`                     |
| `volumePermissions.enabled`            | Enable init container that changes volume permissions in the data directory (for cases where the default k8s `runAsUser` and `fsUser` values do not work) | `false`                  |
| `volumePermissions.image.registry`     | Init container volume-permissions image registry                                                                                                          | `docker.io`              |
| `volumePermissions.image.repository`   | Init container volume-permissions image name                                                                                                              | `bitnami/bitnami-shell`  |
| `volumePermissions.image.tag`          | Init container volume-permissions image tag                                                                                                               | `10-debian-10-r248`      |
| `volumePermissions.image.pullPolicy`   | Init container volume-permissions image pull policy                                                                                                       | `IfNotPresent`           |
| `volumePermissions.image.pullSecrets`  | Init container volume-permissions image pull secrets                                                                                                      | `[]`                     |
| `volumePermissions.resources`          | Volume Permissions resources                                                                                                                              | `{}`                     |
| `persistence.enabled`                  | Enable persistence                                                                                                                                        | `true`                   |
| `persistence.storageClass`             | Kibana data Persistent Volume Storage Class                                                                                                               | `""`                     |
| `persistence.existingClaim`            | Provide an existing `PersistentVolumeClaim`                                                                                                               | `""`                     |
| `persistence.accessMode`               | Access mode to the PV                                                                                                                                     | `ReadWriteOnce`          |
| `persistence.size`                     | Size for the PV                                                                                                                                           | `10Gi`                   |
| `livenessProbe.enabled`                | Enable/disable the Liveness probe                                                                                                                         | `true`                   |
| `livenessProbe.initialDelaySeconds`    | Delay before liveness probe is initiated                                                                                                                  | `120`                    |
| `livenessProbe.periodSeconds`          | How often to perform the probe                                                                                                                            | `10`                     |
| `livenessProbe.timeoutSeconds`         | When the probe times out                                                                                                                                  | `5`                      |
| `livenessProbe.failureThreshold`       | Minimum consecutive failures for the probe to be considered failed after having succeeded.                                                                | `6`                      |
| `livenessProbe.successThreshold`       | Minimum consecutive successes for the probe to be considered successful after having failed.                                                              | `1`                      |
| `readinessProbe.enabled`               | Enable/disable the Readiness probe                                                                                                                        | `true`                   |
| `readinessProbe.initialDelaySeconds`   | Delay before readiness probe is initiated                                                                                                                 | `30`                     |
| `readinessProbe.periodSeconds`         | How often to perform the probe                                                                                                                            | `10`                     |
| `readinessProbe.timeoutSeconds`        | When the probe times out                                                                                                                                  | `5`                      |
| `readinessProbe.failureThreshold`      | Minimum consecutive failures for the probe to be considered failed after having succeeded.                                                                | `6`                      |
| `readinessProbe.successThreshold`      | Minimum consecutive successes for the probe to be considered successful after having failed.                                                              | `1`                      |
| `forceInitScripts`                     | Force execution of init scripts                                                                                                                           | `false`                  |
| `initScriptsCM`                        | Configmap with init scripts to execute                                                                                                                    | `""`                     |
| `initScriptsSecret`                    | Secret with init scripts to execute (for sensitive data)                                                                                                  | `""`                     |
| `service.port`                         | Kubernetes Service port                                                                                                                                   | `5601`                   |
| `service.type`                         | Kubernetes Service type                                                                                                                                   | `ClusterIP`              |
| `service.nodePort`                     | Specify the nodePort value for the LoadBalancer and NodePort service types                                                                                | `""`                     |
| `service.externalTrafficPolicy`        | Enable client source IP preservation                                                                                                                      | `Cluster`                |
| `service.annotations`                  | Annotations for Kibana service (evaluated as a template)                                                                                                  | `{}`                     |
| `service.labels`                       | Extra labels for Kibana service                                                                                                                           | `{}`                     |
| `service.loadBalancerIP`               | loadBalancerIP if Kibana service type is `LoadBalancer`                                                                                                   | `""`                     |
| `service.extraPorts`                   | Extra ports to expose in the service (normally used with the `sidecar` value)                                                                             | `[]`                     |
| `ingress.enabled`                      | Enable ingress controller resource                                                                                                                        | `false`                  |
| `ingress.pathType`                     | Ingress Path type                                                                                                                                         | `ImplementationSpecific` |
| `ingress.apiVersion`                   | Override API Version (automatically detected if not set)                                                                                                  | `""`                     |
| `ingress.hostname`                     | Default host for the ingress resource. If specified as "*" no host rule is configured                                                                     | `kibana.local`           |
| `ingress.path`                         | The Path to Kibana. You may need to set this to '/*' in order to use this with ALB ingress controllers.                                                   | `/`                      |
| `ingress.annotations`                  | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations.                          | `{}`                     |
| `ingress.tls`                          | Enable TLS configuration for the hostname defined at ingress.hostname parameter                                                                           | `false`                  |
| `ingress.extraHosts`                   | The list of additional hostnames to be covered with this ingress record.                                                                                  | `[]`                     |
| `ingress.extraPaths`                   | Additional arbitrary path/backend objects                                                                                                                 | `[]`                     |
| `ingress.extraTls`                     | The tls configuration for additional hostnames to be covered with this ingress record.                                                                    | `[]`                     |
| `ingress.secrets`                      | If you're providing your own certificates, please use this to add the certificates as secrets                                                             | `[]`                     |
| `serviceAccount.create`                | Enable creation of ServiceAccount for Kibana                                                                                                              | `true`                   |
| `serviceAccount.name`                  | Name of serviceAccount                                                                                                                                    | `""`                     |
| `serviceAccount.annotations`           | Additional custom annotations for the ServiceAccount                                                                                                      | `{}`                     |
| `containerPort`                        | Port to expose at container level                                                                                                                         | `5601`                   |
| `securityContext.enabled`              | Enable securityContext on for Kibana deployment                                                                                                           | `true`                   |
| `securityContext.fsGroup`              | Group to configure permissions for volumes                                                                                                                | `1001`                   |
| `securityContext.runAsUser`            | User for the security context                                                                                                                             | `1001`                   |
| `securityContext.runAsNonRoot`         | Set container's Security Context runAsNonRoot                                                                                                             | `true`                   |
| `resources.limits`                     | The resources limits for the container                                                                                                                    | `{}`                     |
| `resources.requests`                   | The requested resources for the container                                                                                                                 | `{}`                     |
| `podAffinityPreset`                    | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                       | `""`                     |
| `podAntiAffinityPreset`                | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                  | `soft`                   |
| `nodeAffinityPreset.type`              | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                 | `""`                     |
| `nodeAffinityPreset.key`               | Node label key to match Ignored if `affinity` is set.                                                                                                     | `""`                     |
| `nodeAffinityPreset.values`            | Node label values to match. Ignored if `affinity` is set.                                                                                                 | `[]`                     |
| `affinity`                             | Affinity for pod assignment                                                                                                                               | `{}`                     |
| `nodeSelector`                         | Node labels for pod assignment                                                                                                                            | `{}`                     |
| `tolerations`                          | Tolerations for pod assignment                                                                                                                            | `[]`                     |
| `podAnnotations`                       | Pod annotations                                                                                                                                           | `{}`                     |
| `podLabels`                            | Extra labels to add to Pod                                                                                                                                | `{}`                     |
| `sidecars`                             | Attach additional containers to the pod                                                                                                                   | `[]`                     |
| `initContainers`                       | Add additional init containers to the pod                                                                                                                 | `[]`                     |
| `configuration`                        | Kibana configuration                                                                                                                                      | `{}`                     |
| `metrics.enabled`                      | Start a side-car prometheus exporter                                                                                                                      | `false`                  |
| `metrics.service.annotations`          | Prometheus annotations for the Kibana service                                                                                                             | `{}`                     |
| `metrics.serviceMonitor.enabled`       | If `true`, creates a Prometheus Operator ServiceMonitor (also requires `metrics.enabled` to be `true`)                                                    | `false`                  |
| `metrics.serviceMonitor.namespace`     | Namespace in which Prometheus is running                                                                                                                  | `""`                     |
| `metrics.serviceMonitor.interval`      | Interval at which metrics should be scraped.                                                                                                              | `""`                     |
| `metrics.serviceMonitor.scrapeTimeout` | Timeout after which the scrape is ended                                                                                                                   | `""`                     |
| `metrics.serviceMonitor.selector`      | Prometheus instance selector labels                                                                                                                       | `{}`                     |


### Kibana server TLS configuration

| Name                   | Description                                                                    | Value   |
| ---------------------- | ------------------------------------------------------------------------------ | ------- |
| `tls.enabled`          | Enable SSL/TLS encryption for Kibana server (HTTPS)                            | `false` |
| `tls.autoGenerated`    | Create self-signed TLS certificates. Currently only supports PEM certificates. | `false` |
| `tls.existingSecret`   | Name of the existing secret containing Kibana server certificates              | `""`    |
| `tls.usePemCerts`      | Use this variable if your secrets contain PEM certificates instead of PKCS12   | `false` |
| `tls.keyPassword`      | Password to access the PEM key when it is password-protected.                  | `""`    |
| `tls.keystorePassword` | Password to access the PKCS12 keystore when it is password-protected.          | `""`    |
| `tls.passwordsSecret`  | Name of a existing secret containing the Keystore or PEM key password          | `""`    |


### Elasticsearch parameters

| Name                                            | Description                                                                                                              | Value     |
| ----------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------ | --------- |
| `elasticsearch.hosts`                           | List of elasticsearch hosts to connect to.                                                                               | `[]`      |
| `elasticsearch.port`                            | Elasticsearch port                                                                                                       | `""`      |
| `elasticsearch.security.auth.enabled`           | Set to 'true' if Elasticsearch has authentication enabled                                                                | `false`   |
| `elasticsearch.security.auth.kibanaUsername`    | Kibana server user to authenticate with Elasticsearch                                                                    | `elastic` |
| `elasticsearch.security.auth.kibanaPassword`    | Kibana server password to authenticate with Elasticsearch                                                                | `""`      |
| `elasticsearch.security.auth.existingSecret`    | Name of the existing secret containing the Password for the Kibana user                                                  | `""`      |
| `elasticsearch.security.tls.enabled`            | Set to 'true' if Elasticsearch API uses TLS/SSL (HTTPS)                                                                  | `false`   |
| `elasticsearch.security.tls.verificationMode`   | Verification mode for SSL communications.                                                                                | `full`    |
| `elasticsearch.security.tls.existingSecret`     | Name of the existing secret containing Elasticsearch Truststore or CA certificate. Required unless verificationMode=none | `""`      |
| `elasticsearch.security.tls.usePemCerts`        | Set to 'true' to use PEM certificates instead of PKCS12.                                                                 | `false`   |
| `elasticsearch.security.tls.truststorePassword` | Password to access the PKCS12 trustore in case it is password-protected.                                                 | `""`      |
| `elasticsearch.security.tls.passwordsSecret`    | Name of a existing secret containing the Truststore password                                                             | `""`      |


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

### [Rolling vs Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Change Kibana version

To modify the application version used in this chart, specify a different version of the image using the `image.tag` parameter and/or a different repository using the `image.repository` parameter. Refer to the [chart documentation for more information on these parameters and how to use them with images from a private registry](https://docs.bitnami.com/kubernetes/apps/kibana/configuration/change-image-version/).

### Use custom configuration

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

### Add extra environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `extraEnvVars` property.

```yaml
extraEnvVars:
  - name: ELASTICSEARCH_VERSION
    value: 6
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values.

### Use custom initialization scripts

For advanced operations, the Bitnami Kibana chart allows using custom initialization scripts that will be mounted in `/docker-entrypoint.init-db`. Mount these extra scripts using a ConfigMap or a Secret (in case of sensitive data) and specify them via the `initScriptsCM` and `initScriptsSecret` chart parameters. Refer to the [chart documentation on custom initialization scripts](https://docs.bitnami.com/kubernetes/apps/kibana/administration/use-custom-init-scripts/) for an example.

### Install plugins

The Bitnami Kibana chart allows you to install a set of plugins at deployment time using the `plugins` chart parameter. Refer to the [chart documentation on installing plugins](https://docs.bitnami.com/kubernetes/apps/kibana/configuration/install-plugins/) for an example.

```console
elasticsearch.hosts[0]=elasticsearch-host
elasticsearch.port=9200
plugins[0]=https://github.com/fbaligand/kibana-enhanced-table/releases/download/v1.5.0/enhanced-table-1.5.0_7.3.2.zip
```

> **NOTE** Make sure that the plugin is available for the Kibana version you are deploying

### Import saved objects

If you have visualizations and dashboards (in NDJSON format) to import to Kibana, create a ConfigMap that includes them and then install the chart with the `savedObjects.configmap` or  `savedObjects.urls` parameters. Refer to the [chart documentation on importing saved objects](https://docs.bitnami.com/kubernetes/apps/kibana/configuration/import-saved-objects/) for an example.

### Use Sidecars and Init Containers

If additional containers are needed in the same pod (such as additional metrics or logging exporters), they can be defined using the `sidecars` config parameter. Similarly, extra init containers can be added using the `initContainers` parameter.

Refer to the chart documentation for more information on, and examples of, configuring and using [sidecars and init containers](https://docs.bitnami.com/kubernetes/apps/kibana/configuration/configure-sidecar-init-containers/).

#### Add a sample Elasticsearch container as sidecar

This chart requires an Elasticsearch instance to work. For production, the options are to use an already existing Elasticsearch instance or deploy the [Elasticsearch chart](https://github.com/bitnami/charts/tree/master/bitnami/elasticsearch) with the [`global.kibanaEnabled=true` parameter](https://github.com/bitnami/charts/tree/master/bitnami/elasticsearch#enable-bundled-kibana).

For testing purposes, use a sidecar Elasticsearch container setting the following parameters during the Kibana chart installation:

```
elasticsearch.hosts[0]=localhost
elasticsearch.port=9200
sidecars[0].name=elasticsearch
sidecars[0].image=bitnami/elasticsearch:latest
sidecars[0].imagePullPolicy=IfNotPresent
sidecars[0].ports[0].name=http
sidecars[0].ports[0].containerPort=9200
```

### Set Pod affinity

This chart allows you to set custom Pod affinity using the `affinity` parameter. Find more information about Pod affinity in the [Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use one of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

## Persistence

The [Bitnami Kibana](https://github.com/bitnami/bitnami-docker-kibana) image can persist data. If enabled, the persisted path is `/bitnami/kibana` by default.

The chart mounts a [Persistent Volume](https://kubernetes.io/docs/concepts/storage/persistent-volumes/) at this location. The volume is created using dynamic volume provisioning.

### Add extra volumes

The Bitnami Kibana chart supports mounting extra volumes (either PVCs, secrets or configmaps) by using the `extraVolumes` and `extraVolumeMounts` property. This can be combined with advanced operations like adding extra init containers and sidecars.

### Adjust permissions of persistent volume mountpoint

As the image run as non-root by default, it is necessary to adjust the ownership of the persistent volume so that the container can write data into it.

By default, the chart is configured to use Kubernetes Security Context to automatically change the ownership of the volume. However, this feature does not work in all Kubernetes distributions.
As an alternative, this chart supports using an initContainer to change the ownership of the volume before mounting it in the final destination.

You can enable this initContainer by setting `volumePermissions.enabled` to `true`.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami’s Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 9.0.0

This version updates the settings used to communicate Kibana with Elasticsearch, adapting it to Elasticsearch X-Pack Security features.

Previous setting `elasticsearch.tls` has been replaced with `elasticsearch.security.tls.enabled`. Other settings regarding certificate verification can be found under `elasticsearch.security.tls.*`, such as verification method and custom truststore.

Additionally, support for the Kibana server using TLS/SSL encryption (HTTPS for port 5601) has been added.

### To 8.0.0

The Kibana container configuration logic was migrated to bash.

From this version onwards, Kibana container components are now licensed under the [Elastic License](https://www.elastic.co/licensing/elastic-license) that is not currently accepted as an Open Source license by the Open Source Initiative (OSI).

Also, from now on, the Helm Chart will include the X-Pack plugin installed by default.

Regular upgrade is compatible from previous versions.

### To 6.2.0

This version introduces `bitnami/common`, a [library chart](https://helm.sh/docs/topics/library_charts/#helm) as a dependency. More documentation about this new utility could be found [here](https://github.com/bitnami/charts/tree/master/bitnami/common#bitnami-common-library-chart). Please, make sure that you have updated the chart dependencies before executing any upgrade.

### To 6.0.0

[On November 13, 2020, Helm v2 support formally ended](https://github.com/helm/charts#status-of-the-project). This major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

[Learn more about this change and related upgrade considerations](https://docs.bitnami.com/kubernetes/apps/kibana/administration/upgrade-helm3/).

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
