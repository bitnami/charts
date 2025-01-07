<!--- app-name: Kibana -->

# Bitnami package for Kibana

Kibana is an open source, browser based analytics and search dashboard for Elasticsearch. Kibana strives to be easy to get started with, while also being flexible and powerful.

[Overview of Kibana](https://www.elastic.co/products/kibana)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/kibana --set elasticsearch.hosts[0]=<Hostname of your ES instance> --set elasticsearch.port=<port of your ES instance>
```

Looking to use Kibana in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the commercial edition of the Bitnami catalog.

## Introduction

This chart bootstraps a [Kibana](https://github.com/bitnami/containers/tree/main/bitnami/kibana) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+
- PV provisioner support in the underlying infrastructure
- ReadWriteMany volumes for deployment scaling

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/kibana \
  --set elasticsearch.hosts[0]=<Hostname of your ES instance> \
  --set elasticsearch.port=<port of your ES instance> \
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

This chart requires an Elasticsearch instance to work. You can use an already existing Elasticsearch instance. These commands deploy Kibana on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Configuration and installation details

### Resource requests and limits

Bitnami charts allow setting resource requests and limits for all containers inside the chart deployment. These are inside the `resources` value (check parameter table). Setting requests is essential for production workloads and these should be adapted to your specific use case.

To make this process easier, the chart contains the `resourcesPreset` values, which automatically sets the `resources` section according to different presets. Check these presets in [the bitnami/common chart](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15). However, in production workloads using `resourcesPreset` is discouraged as it may not fully adapt to your specific needs. Find more information on container resource management in the [official Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).

### [Rolling vs Immutable tags](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Update credentials

Bitnami charts configure credentials at first boot. Any further change in the secrets or credentials require manual intervention. Follow these instructions:

- Update the user password in Elasticsearch following [the upstream documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/reset-password.html)
- Update the password secret with the new values (replace the SECRET_NAME and PASSWORD)

```shell
kubectl create secret generic SECRET_NAME --from-literal=kibana-password=PASSWORD --dry-run -o yaml | kubectl apply -f -
```

### Prometheus metrics

This chart can be integrated with Prometheus by setting `metrics.enabled` to `true`. This will expose Kibana native Prometheus endpoint in the service. It will have the necessary annotations to be automatically scraped by Prometheus.

> **IMPORTANT**: For Prometheus metrics to work, make sure that the [kibana-prometheus-exporter](https://github.com/pjhampton/kibana-prometheus-exporter) plugin is installed. Check the [Install plugins](#install-plugins) section for instructions on how to install extra plugins.

#### Prometheus requirements

It is necessary to have a working installation of Prometheus or Prometheus Operator for the integration to work. Install the [Bitnami Prometheus helm chart](https://github.com/bitnami/charts/tree/main/bitnami/prometheus) or the [Bitnami Kube Prometheus helm chart](https://github.com/bitnami/charts/tree/main/bitnami/kube-prometheus) to easily have a working Prometheus in your cluster.

#### Integration with Prometheus Operator

The chart can deploy `ServiceMonitor` objects for integration with Prometheus Operator installations. To do so, set the value `metrics.serviceMonitor.enabled=true`. Ensure that the Prometheus Operator `CustomResourceDefinitions` are installed in the cluster or it will fail with the following error:

```text
no matches for kind "ServiceMonitor" in version "monitoring.coreos.com/v1"
```

Install the [Bitnami Kube Prometheus helm chart](https://github.com/bitnami/charts/tree/main/bitnami/kube-prometheus) for having the necessary CRDs and the Prometheus Operator.

### Change Kibana version

To modify the application version used in this chart, specify a different version of the image using the `image.tag` parameter and/or a different repository using the `image.repository` parameter.

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

### Securing traffic using TLS

Kibana can be configured with TLS by setting `tls.enabled=true`. The chart allows two configuration options:

- Provide your own secret using the `tls.existingSecret` value.
- Have the chart auto-generate the certificates using `tls.autoGenerated=true`.

### Add extra environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `extraEnvVars` property.

```yaml
extraEnvVars:
  - name: ELASTICSEARCH_VERSION
    value: 6
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values.

### Use custom initialization scripts

For advanced operations, the Bitnami Kibana chart allows using custom initialization scripts that will be mounted in `/docker-entrypoint.init-db`. Mount these extra scripts using a ConfigMap or a Secret (in case of sensitive data) and specify them via the `initScriptsCM` and `initScriptsSecret` chart parameters, as shown below:

```text
elasticsearch.hosts[0]=elasticsearch-host
elasticsearch.port=9200
initScriptsCM=special-scripts
initScriptsSecret=special-scripts-sensitive
```

### Install plugins

The Bitnami Kibana chart allows you to install a set of plugins at deployment time using the `plugins` chart parameter, as shown in the example below:

```text
elasticsearch.hosts[0]=elasticsearch-host
elasticsearch.port=9200
plugins[0]=https://github.com/fbaligand/kibana-enhanced-table/releases/download/v1.5.0/enhanced-table-1.5.0_7.3.2.zip
```

> **NOTE** Make sure that the plugin is available for the Kibana version you are deploying

### Import saved objects

If you have visualizations and dashboards (in NDJSON format) to import to Kibana, create a ConfigMap that includes them and then install the chart with the `savedObjects.configmap` chart parameter, as shown below:

```text
savedObjects.configmap=my-import
```

Alternatively, if the saved objects are available at a URL, import them with the `savedObjects.urls` chart parameter, as shown below:

```text
savedObjects.urls[0]=www.my-site.com/import.ndjson
```

### Use Sidecars and Init Containers

If additional containers are needed in the same pod (such as additional metrics or logging exporters), they can be defined using the `sidecars` config parameter.

```yaml
sidecars:
- name: your-image-name
  image: your-image
  imagePullPolicy: Always
  ports:
  - name: portname
    containerPort: 1234
```

If these sidecars export extra ports, extra port definitions can be added using the `service.extraPorts` parameter (where available), as shown in the example below:

```yaml
service:
  extraPorts:
  - name: extraPort
    port: 11311
    targetPort: 11311
```

> NOTE: This Helm chart already includes sidecar containers for the Prometheus exporters (where applicable). These can be activated by adding the `--enable-metrics=true` parameter at deployment time. The `sidecars` parameter should therefore only be used for any extra sidecar containers.

If additional init containers are needed in the same pod, they can be defined using the `initContainers` parameter. Here is an example:

```yaml
initContainers:
  - name: your-image-name
    image: your-image
    imagePullPolicy: Always
    ports:
      - name: portname
        containerPort: 1234
```

Learn more about [sidecar containers](https://kubernetes.io/docs/concepts/workloads/pods/) and [init containers](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/).

#### Add a sample Elasticsearch container as sidecar

This chart requires an Elasticsearch instance to work. For production, the options are to use an already existing Elasticsearch instance or deploy the [Elasticsearch chart](https://github.com/bitnami/charts/tree/main/bitnami/elasticsearch) with the [`global.kibanaEnabled=true` parameter](https://github.com/bitnami/charts/tree/main/bitnami/elasticsearch#enable-bundled-kibana).

For testing purposes, use a sidecar Elasticsearch container setting the following parameters during the Kibana chart installation:

```text
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

As an alternative, you can use one of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

### Backup and restore

To back up and restore Helm chart deployments on Kubernetes, you need to back up the persistent volumes from the source deployment and attach them to a new deployment using [Velero](https://velero.io/), a Kubernetes backup/restore tool. Find the instructions for using Velero in [this guide](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-backup-restore-deployments-velero-index.html).

## Persistence

The [Bitnami Kibana](https://github.com/bitnami/containers/tree/main/bitnami/kibana) image can persist data. If enabled, the persisted path is `/bitnami/kibana` by default.

The chart mounts a [Persistent Volume](https://kubernetes.io/docs/concepts/storage/persistent-volumes/) at this location. The volume is created using dynamic volume provisioning.

### Add extra volumes

The Bitnami Kibana chart supports mounting extra volumes (either PVCs, secrets or configmaps) by using the `extraVolumes` and `extraVolumeMounts` property. This can be combined with advanced operations like adding extra init containers and sidecars.

### Adjust permissions of persistent volume mountpoint

As the image run as non-root by default, it is necessary to adjust the ownership of the persistent volume so that the container can write data into it.

By default, the chart is configured to use Kubernetes Security Context to automatically change the ownership of the volume. However, this feature does not work in all Kubernetes distributions.
As an alternative, this chart supports using an initContainer to change the ownership of the volume before mounting it in the final destination.

You can enable this initContainer by setting `volumePermissions.enabled` to `true`.

## Parameters

### Global parameters

| Name                                                  | Description                                                                                                                                                                                                                                                                                                                                                         | Value   |
| ----------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `global.imageRegistry`                                | Global Docker image registry                                                                                                                                                                                                                                                                                                                                        | `""`    |
| `global.imagePullSecrets`                             | Global Docker registry secret names as an array                                                                                                                                                                                                                                                                                                                     | `[]`    |
| `global.defaultStorageClass`                          | Global default StorageClass for Persistent Volume(s)                                                                                                                                                                                                                                                                                                                | `""`    |
| `global.storageClass`                                 | DEPRECATED: use global.defaultStorageClass instead                                                                                                                                                                                                                                                                                                                  | `""`    |
| `global.security.allowInsecureImages`                 | Allows skipping image verification                                                                                                                                                                                                                                                                                                                                  | `false` |
| `global.compatibility.openshift.adaptSecurityContext` | Adapt the securityContext sections of the deployment to make them compatible with Openshift restricted-v2 SCC: remove runAsUser, runAsGroup and fsGroup and let the platform use their allowed default IDs. Possible values: auto (apply if the detected running cluster is Openshift), force (perform the adaptation always), disabled (do not perform adaptation) | `auto`  |

### Common parameters

| Name                     | Description                                                                                               | Value           |
| ------------------------ | --------------------------------------------------------------------------------------------------------- | --------------- |
| `kubeVersion`            | Force target Kubernetes version (using Helm capabilities if not set)                                      | `""`            |
| `nameOverride`           | String to partially override common.names.fullname template with a string (will prepend the release name) | `""`            |
| `fullnameOverride`       | String to fully override common.names.fullname template with a string                                     | `""`            |
| `commonAnnotations`      | Annotations to add to all deployed objects                                                                | `{}`            |
| `commonLabels`           | Labels to add to all deployed objects                                                                     | `{}`            |
| `extraDeploy`            | A list of extra kubernetes resources to be deployed                                                       | `[]`            |
| `clusterDomain`          | Kubernetes cluster domain name                                                                            | `cluster.local` |
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden)                   | `false`         |
| `diagnosticMode.command` | Command to override all containers in the the deployment(s)/statefulset(s)                                | `["sleep"]`     |
| `diagnosticMode.args`    | Args to override all containers in the the deployment(s)/statefulset(s)                                   | `["infinity"]`  |

### Kibana parameters

| Name                                                | Description                                                                                                                                                                                                                                           | Value                      |
| --------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------- |
| `image.registry`                                    | Kibana image registry                                                                                                                                                                                                                                 | `REGISTRY_NAME`            |
| `image.repository`                                  | Kibana image repository                                                                                                                                                                                                                               | `REPOSITORY_NAME/kibana`   |
| `image.digest`                                      | Kibana image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                                                | `""`                       |
| `image.pullPolicy`                                  | Kibana image pull policy                                                                                                                                                                                                                              | `IfNotPresent`             |
| `image.pullSecrets`                                 | Specify docker-registry secret names as an array                                                                                                                                                                                                      | `[]`                       |
| `image.debug`                                       | Enable %%MAIN_CONTAINER%% image debug mode                                                                                                                                                                                                            | `false`                    |
| `replicaCount`                                      | Number of replicas of the Kibana Pod                                                                                                                                                                                                                  | `1`                        |
| `updateStrategy.type`                               | Set up update strategy for Kibana installation.                                                                                                                                                                                                       | `RollingUpdate`            |
| `schedulerName`                                     | Alternative scheduler                                                                                                                                                                                                                                 | `""`                       |
| `priorityClassName`                                 | %%MAIN_CONTAINER_NAME%% pods' priorityClassName                                                                                                                                                                                                       | `""`                       |
| `terminationGracePeriodSeconds`                     | In seconds, time the given to the %%MAIN_CONTAINER_NAME%% pod needs to terminate gracefully                                                                                                                                                           | `""`                       |
| `topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment                                                                                                                                                                                                        | `[]`                       |
| `automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                                                    | `false`                    |
| `hostAliases`                                       | Add deployment host aliases                                                                                                                                                                                                                           | `[]`                       |
| `plugins`                                           | Array containing the Kibana plugins to be installed in deployment                                                                                                                                                                                     | `[]`                       |
| `savedObjects.urls`                                 | Array containing links to NDJSON files to be imported during Kibana initialization                                                                                                                                                                    | `[]`                       |
| `savedObjects.configmap`                            | Configmap containing NDJSON files to be imported during Kibana initialization (evaluated as a template)                                                                                                                                               | `""`                       |
| `extraConfiguration`                                | Extra settings to be added to the default kibana.yml configmap that the chart creates (unless replaced using `configurationCM`). Evaluated as a template                                                                                              | `{}`                       |
| `configurationCM`                                   | ConfigMap containing a kibana.yml file that will replace the default one specified in configuration.yaml                                                                                                                                              | `""`                       |
| `command`                                           | Override default container command (useful when using custom images)                                                                                                                                                                                  | `[]`                       |
| `args`                                              | Override default container args (useful when using custom images)                                                                                                                                                                                     | `[]`                       |
| `lifecycleHooks`                                    | for the %%MAIN_CONTAINER_NAME%% container(s) to automate configuration before or after startup                                                                                                                                                        | `{}`                       |
| `extraEnvVars`                                      | Array containing extra env vars to configure Kibana                                                                                                                                                                                                   | `[]`                       |
| `extraEnvVarsCM`                                    | ConfigMap containing extra env vars to configure Kibana                                                                                                                                                                                               | `""`                       |
| `extraEnvVarsSecret`                                | Secret containing extra env vars to configure Kibana (in case of sensitive data)                                                                                                                                                                      | `""`                       |
| `extraVolumes`                                      | Array to add extra volumes. Requires setting `extraVolumeMounts`                                                                                                                                                                                      | `[]`                       |
| `extraVolumeMounts`                                 | Array to add extra mounts. Normally used with `extraVolumes`                                                                                                                                                                                          | `[]`                       |
| `volumePermissions.enabled`                         | Enable init container that changes volume permissions in the data directory (for cases where the default k8s `runAsUser` and `fsUser` values do not work)                                                                                             | `false`                    |
| `volumePermissions.image.registry`                  | Init container volume-permissions image registry                                                                                                                                                                                                      | `REGISTRY_NAME`            |
| `volumePermissions.image.repository`                | Init container volume-permissions image name                                                                                                                                                                                                          | `REPOSITORY_NAME/os-shell` |
| `volumePermissions.image.digest`                    | Init container volume-permissions image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                     | `""`                       |
| `volumePermissions.image.pullPolicy`                | Init container volume-permissions image pull policy                                                                                                                                                                                                   | `IfNotPresent`             |
| `volumePermissions.image.pullSecrets`               | Init container volume-permissions image pull secrets                                                                                                                                                                                                  | `[]`                       |
| `volumePermissions.resourcesPreset`                 | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if volumePermissions.resources is set (volumePermissions.resources is recommended for production). | `nano`                     |
| `volumePermissions.resources`                       | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                                     | `{}`                       |
| `persistence.enabled`                               | Enable persistence                                                                                                                                                                                                                                    | `true`                     |
| `persistence.storageClass`                          | Kibana data Persistent Volume Storage Class                                                                                                                                                                                                           | `""`                       |
| `persistence.existingClaim`                         | Provide an existing `PersistentVolumeClaim`                                                                                                                                                                                                           | `""`                       |
| `persistence.accessModes`                           | Persistent Volume access modes                                                                                                                                                                                                                        | `["ReadWriteOnce"]`        |
| `persistence.size`                                  | Size for the PV                                                                                                                                                                                                                                       | `10Gi`                     |
| `persistence.annotations`                           | Persistent Volume Claim annotations                                                                                                                                                                                                                   | `{}`                       |
| `persistence.subPath`                               | The subdirectory of the volume to mount to, useful in dev environments and one PV for multiple services                                                                                                                                               | `""`                       |
| `persistence.selector`                              | Selector to match an existing Persistent Volume for Kibana data PVC                                                                                                                                                                                   | `{}`                       |
| `persistence.dataSource`                            | Custom PVC data source                                                                                                                                                                                                                                | `{}`                       |
| `startupProbe.enabled`                              | Enable/disable the startup probe                                                                                                                                                                                                                      | `false`                    |
| `startupProbe.initialDelaySeconds`                  | Delay before startup probe is initiated                                                                                                                                                                                                               | `120`                      |
| `startupProbe.periodSeconds`                        | How often to perform the probe                                                                                                                                                                                                                        | `10`                       |
| `startupProbe.timeoutSeconds`                       | When the probe times out                                                                                                                                                                                                                              | `5`                        |
| `startupProbe.failureThreshold`                     | Minimum consecutive failures for the probe to be considered failed after having succeeded.                                                                                                                                                            | `6`                        |
| `startupProbe.successThreshold`                     | Minimum consecutive successes for the probe to be considered successful after having failed.                                                                                                                                                          | `1`                        |
| `livenessProbe.enabled`                             | Enable/disable the Liveness probe                                                                                                                                                                                                                     | `true`                     |
| `livenessProbe.initialDelaySeconds`                 | Delay before liveness probe is initiated                                                                                                                                                                                                              | `120`                      |
| `livenessProbe.periodSeconds`                       | How often to perform the probe                                                                                                                                                                                                                        | `10`                       |
| `livenessProbe.timeoutSeconds`                      | When the probe times out                                                                                                                                                                                                                              | `5`                        |
| `livenessProbe.failureThreshold`                    | Minimum consecutive failures for the probe to be considered failed after having succeeded.                                                                                                                                                            | `6`                        |
| `livenessProbe.successThreshold`                    | Minimum consecutive successes for the probe to be considered successful after having failed.                                                                                                                                                          | `1`                        |
| `readinessProbe.enabled`                            | Enable/disable the Readiness probe                                                                                                                                                                                                                    | `true`                     |
| `readinessProbe.initialDelaySeconds`                | Delay before readiness probe is initiated                                                                                                                                                                                                             | `30`                       |
| `readinessProbe.periodSeconds`                      | How often to perform the probe                                                                                                                                                                                                                        | `10`                       |
| `readinessProbe.timeoutSeconds`                     | When the probe times out                                                                                                                                                                                                                              | `5`                        |
| `readinessProbe.failureThreshold`                   | Minimum consecutive failures for the probe to be considered failed after having succeeded.                                                                                                                                                            | `6`                        |
| `readinessProbe.successThreshold`                   | Minimum consecutive successes for the probe to be considered successful after having failed.                                                                                                                                                          | `1`                        |
| `customStartupProbe`                                | Custom liveness probe for the Web component                                                                                                                                                                                                           | `{}`                       |
| `customLivenessProbe`                               | Custom liveness probe for the Web component                                                                                                                                                                                                           | `{}`                       |
| `customReadinessProbe`                              | Custom readiness probe for the Web component                                                                                                                                                                                                          | `{}`                       |
| `forceInitScripts`                                  | Force execution of init scripts                                                                                                                                                                                                                       | `false`                    |
| `initScriptsCM`                                     | Configmap with init scripts to execute                                                                                                                                                                                                                | `""`                       |
| `initScriptsSecret`                                 | Secret with init scripts to execute (for sensitive data)                                                                                                                                                                                              | `""`                       |
| `service.ports.http`                                | Kubernetes Service port                                                                                                                                                                                                                               | `5601`                     |
| `service.type`                                      | Kubernetes Service type                                                                                                                                                                                                                               | `ClusterIP`                |
| `service.nodePorts.http`                            | Specify the nodePort value for the LoadBalancer and NodePort service types                                                                                                                                                                            | `""`                       |
| `service.clusterIP`                                 | %%MAIN_CONTAINER_NAME%% service Cluster IP                                                                                                                                                                                                            | `""`                       |
| `service.loadBalancerIP`                            | loadBalancerIP if Kibana service type is `LoadBalancer`                                                                                                                                                                                               | `""`                       |
| `service.loadBalancerSourceRanges`                  | %%MAIN_CONTAINER_NAME%% service Load Balancer sources                                                                                                                                                                                                 | `[]`                       |
| `service.externalTrafficPolicy`                     | Enable client source IP preservation                                                                                                                                                                                                                  | `Cluster`                  |
| `service.annotations`                               | Annotations for Kibana service (evaluated as a template)                                                                                                                                                                                              | `{}`                       |
| `service.labels`                                    | Extra labels for Kibana service                                                                                                                                                                                                                       | `{}`                       |
| `service.extraPorts`                                | Extra ports to expose in the service (normally used with the `sidecar` value)                                                                                                                                                                         | `[]`                       |
| `service.sessionAffinity`                           | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                                                                                                                                                                                  | `None`                     |
| `service.sessionAffinityConfig`                     | Additional settings for the sessionAffinity                                                                                                                                                                                                           | `{}`                       |
| `networkPolicy.enabled`                             | Specifies whether a NetworkPolicy should be created                                                                                                                                                                                                   | `true`                     |
| `networkPolicy.allowExternal`                       | Don't require server label for connections                                                                                                                                                                                                            | `true`                     |
| `networkPolicy.allowExternalEgress`                 | Allow the pod to access any range of port and all destinations.                                                                                                                                                                                       | `true`                     |
| `networkPolicy.extraIngress`                        | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                                                          | `[]`                       |
| `networkPolicy.extraEgress`                         | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                                                          | `[]`                       |
| `networkPolicy.ingressNSMatchLabels`                | Labels to match to allow traffic from other namespaces                                                                                                                                                                                                | `{}`                       |
| `networkPolicy.ingressNSPodMatchLabels`             | Pod labels to match to allow traffic from other namespaces                                                                                                                                                                                            | `{}`                       |
| `ingress.enabled`                                   | Enable ingress controller resource                                                                                                                                                                                                                    | `false`                    |
| `ingress.pathType`                                  | Ingress Path type                                                                                                                                                                                                                                     | `ImplementationSpecific`   |
| `ingress.apiVersion`                                | Override API Version (automatically detected if not set)                                                                                                                                                                                              | `""`                       |
| `ingress.hostname`                                  | Default host for the ingress resource. If specified as "*" no host rule is configured                                                                                                                                                                 | `kibana.local`             |
| `ingress.path`                                      | The Path to Kibana. You may need to set this to '/*' in order to use this with ALB ingress controllers.                                                                                                                                               | `/`                        |
| `ingress.annotations`                               | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations.                                                                                                                      | `{}`                       |
| `ingress.tls`                                       | Enable TLS configuration for the hostname defined at ingress.hostname parameter                                                                                                                                                                       | `false`                    |
| `ingress.selfSigned`                                | Create a TLS secret for this ingress record using self-signed certificates generated by Helm                                                                                                                                                          | `false`                    |
| `ingress.extraHosts`                                | The list of additional hostnames to be covered with this ingress record.                                                                                                                                                                              | `[]`                       |
| `ingress.extraPaths`                                | Additional arbitrary path/backend objects                                                                                                                                                                                                             | `[]`                       |
| `ingress.extraTls`                                  | The tls configuration for additional hostnames to be covered with this ingress record.                                                                                                                                                                | `[]`                       |
| `ingress.secrets`                                   | If you're providing your own certificates, please use this to add the certificates as secrets                                                                                                                                                         | `[]`                       |
| `ingress.ingressClassName`                          | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                                                                                                                                         | `""`                       |
| `ingress.extraRules`                                | The list of additional rules to be added to this ingress record. Evaluated as a template                                                                                                                                                              | `[]`                       |
| `serviceAccount.create`                             | Specifies whether a ServiceAccount should be created                                                                                                                                                                                                  | `true`                     |
| `serviceAccount.name`                               | Name of the service account to use. If not set and create is true, a name is generated using the fullname template.                                                                                                                                   | `""`                       |
| `serviceAccount.automountServiceAccountToken`       | Automount service account token for the server service account                                                                                                                                                                                        | `false`                    |
| `serviceAccount.annotations`                        | Annotations for service account. Evaluated as a template. Only used if `create` is `true`.                                                                                                                                                            | `{}`                       |
| `containerPorts.http`                               | Port to expose at container level                                                                                                                                                                                                                     | `5601`                     |
| `podSecurityContext.enabled`                        | Enabled %%MAIN_CONTAINER_NAME%% pods' Security Context                                                                                                                                                                                                | `true`                     |
| `podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                                                    | `Always`                   |
| `podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                                                        | `[]`                       |
| `podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                                                           | `[]`                       |
| `podSecurityContext.fsGroup`                        | Set %%MAIN_CONTAINER_NAME%% pod's Security Context fsGroup                                                                                                                                                                                            | `1001`                     |
| `containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                                                                                                                                                                  | `true`                     |
| `containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                                                      | `{}`                       |
| `containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                                                                                                                                            | `1001`                     |
| `containerSecurityContext.runAsGroup`               | Set containers' Security Context runAsGroup                                                                                                                                                                                                           | `1001`                     |
| `containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                                                                                                                                                         | `true`                     |
| `containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                                                                                                                                                           | `false`                    |
| `containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                                                               | `true`                     |
| `containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                                                                                                                                             | `false`                    |
| `containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                                                    | `["ALL"]`                  |
| `containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                                                      | `RuntimeDefault`           |
| `resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if resources is set (resources is recommended for production).                                     | `small`                    |
| `resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                                     | `{}`                       |
| `podAffinityPreset`                                 | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                                                   | `""`                       |
| `podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                                              | `soft`                     |
| `nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                                             | `""`                       |
| `nodeAffinityPreset.key`                            | Node label key to match Ignored if `affinity` is set.                                                                                                                                                                                                 | `""`                       |
| `nodeAffinityPreset.values`                         | Node label values to match. Ignored if `affinity` is set.                                                                                                                                                                                             | `[]`                       |
| `affinity`                                          | Affinity for pod assignment                                                                                                                                                                                                                           | `{}`                       |
| `nodeSelector`                                      | Node labels for pod assignment                                                                                                                                                                                                                        | `{}`                       |
| `tolerations`                                       | Tolerations for pod assignment                                                                                                                                                                                                                        | `[]`                       |
| `podAnnotations`                                    | Pod annotations                                                                                                                                                                                                                                       | `{}`                       |
| `podLabels`                                         | Extra labels to add to Pod                                                                                                                                                                                                                            | `{}`                       |
| `sidecars`                                          | Attach additional containers to the pod                                                                                                                                                                                                               | `[]`                       |
| `initContainers`                                    | Add additional init containers to the pod                                                                                                                                                                                                             | `[]`                       |
| `pdb.create`                                        | Enable/disable a Pod Disruption Budget creation                                                                                                                                                                                                       | `true`                     |
| `pdb.minAvailable`                                  | Minimum number/percentage of pods that should remain scheduled                                                                                                                                                                                        | `""`                       |
| `pdb.maxUnavailable`                                | Maximum number/percentage of pods that may be made unavailable. Defaults to `1` if both `pdb.minAvailable` and `pdb.maxUnavailable` are empty.                                                                                                        | `""`                       |
| `configuration`                                     | Kibana configuration                                                                                                                                                                                                                                  | `{}`                       |
| `metrics.enabled`                                   | Start a side-car prometheus exporter                                                                                                                                                                                                                  | `false`                    |
| `metrics.service.annotations`                       | Prometheus annotations for the Kibana service                                                                                                                                                                                                         | `{}`                       |
| `metrics.serviceMonitor.enabled`                    | If `true`, creates a Prometheus Operator ServiceMonitor (also requires `metrics.enabled` to be `true`)                                                                                                                                                | `false`                    |
| `metrics.serviceMonitor.namespace`                  | Namespace in which Prometheus is running                                                                                                                                                                                                              | `""`                       |
| `metrics.serviceMonitor.jobLabel`                   | The name of the label on the target service to use as the job name in prometheus.                                                                                                                                                                     | `""`                       |
| `metrics.serviceMonitor.interval`                   | Interval at which metrics should be scraped.                                                                                                                                                                                                          | `""`                       |
| `metrics.serviceMonitor.scrapeTimeout`              | Timeout after which the scrape is ended                                                                                                                                                                                                               | `""`                       |
| `metrics.serviceMonitor.relabelings`                | RelabelConfigs to apply to samples before scraping                                                                                                                                                                                                    | `[]`                       |
| `metrics.serviceMonitor.metricRelabelings`          | MetricRelabelConfigs to apply to samples before ingestion                                                                                                                                                                                             | `[]`                       |
| `metrics.serviceMonitor.selector`                   | Prometheus instance selector labels                                                                                                                                                                                                                   | `{}`                       |
| `metrics.serviceMonitor.labels`                     | Extra labels for the ServiceMonitor                                                                                                                                                                                                                   | `{}`                       |
| `metrics.serviceMonitor.honorLabels`                | honorLabels chooses the metric's labels on collisions with target labels                                                                                                                                                                              | `false`                    |

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

| Name                                                      | Description                                                                                                              | Value   |
| --------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------ | ------- |
| `elasticsearch.hosts`                                     | List of elasticsearch hosts to connect to.                                                                               | `[]`    |
| `elasticsearch.port`                                      | Elasticsearch port                                                                                                       | `""`    |
| `elasticsearch.security.auth.enabled`                     | Set to 'true' if Elasticsearch has authentication enabled                                                                | `false` |
| `elasticsearch.security.auth.kibanaPassword`              | Password of the 'kibana_system' user, used to authenticate Kibana connection with Elasticsearch.                         | `""`    |
| `elasticsearch.security.auth.existingSecret`              | Name of the existing secret containing the password for the 'kibana_system' user.                                        | `""`    |
| `elasticsearch.security.auth.createSystemUser`            | If enabled, Kibana will use Elasticsearch API to create the 'kibana_system' user at startup.                             | `false` |
| `elasticsearch.security.auth.elasticsearchPasswordSecret` | Name of the existing secret containing the password for the 'elastic' user.                                              | `""`    |
| `elasticsearch.security.tls.enabled`                      | Set to 'true' if Elasticsearch API uses TLS/SSL (HTTPS)                                                                  | `false` |
| `elasticsearch.security.tls.verificationMode`             | Verification mode for SSL communications.                                                                                | `full`  |
| `elasticsearch.security.tls.existingSecret`               | Name of the existing secret containing Elasticsearch Truststore or CA certificate. Required unless verificationMode=none | `""`    |
| `elasticsearch.security.tls.usePemCerts`                  | Set to 'true' to use PEM certificates instead of PKCS12.                                                                 | `false` |
| `elasticsearch.security.tls.truststorePassword`           | Password to access the PKCS12 trustore in case it is password-protected.                                                 | `""`    |
| `elasticsearch.security.tls.passwordsSecret`              | Name of a existing secret containing the Truststore password                                                             | `""`    |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
  --set admin.user=admin-user oci://REGISTRY_NAME/REPOSITORY_NAME/kibana
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The above command sets the Kibana admin user to `admin-user`.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml oci://REGISTRY_NAME/REPOSITORY_NAME/kibana
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.
> **Tip**: You can use the default [values.yaml](https://github.com/bitnami/charts/tree/main/bitnami/kibana/values.yaml)

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 11.4.0

This version introduces image verification for security purposes. To disable it, set `global.security.allowInsecureImages` to `true`. More details at [GitHub issue](https://github.com/bitnami/charts/issues/30850).

### To 11.0.0

This major bump changes the following security defaults:

- `runAsGroup` is changed from `0` to `1001`
- `readOnlyRootFilesystem` is set to `true`
- `resourcesPreset` is changed from `none` to the minimum size working in our test suites (NOTE: `resourcesPreset` is not meant for production usage, but `resources` adapted to your use case).
- `global.compatibility.openshift.adaptSecurityContext` is changed from `disabled` to `auto`.

This could potentially break any customization or init scripts used in your deployment. If this is the case, change the default values to the previous ones.

### To 10.0.0

This major release updates Kibana its latest verstion 8.x.x.
In addition, missing features have been added and values have been renamed, in order to get aligned with the rest of the assets in the Bitnami charts repository.

Affected values:

- `service.port` renamed as `service.ports.http`
- `service.nodePort` renamed as `service.nodePorts.http`
- `containerPort` renamed as `containerPorts.http`

Changes to Security related values:

- `elasticsearch.security.auth.kibanaUsername` has been removed. Kibana must be authenticates using the built-in user 'kibana_system'
- `elasticsearch.security.auth.kibanaPassword` has to provide the password for the kibana_system user, otherwise random password will be generated.
- `elasticsearch.security.auth.existingSecret` key kibana-password now references the password of the 'kibana_system' user.
- Two new values have been added: `elasticsearch.security.auth.createSystemUser` and `elasticsearchPasswordSecret`. If provided, the kibana container will use the 'elastic' user to create the 'kibana_system' user, using the password provided under `elasticsearch.security.auth.kibanaPassword`.

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

This version introduces `bitnami/common`, a [library chart](https://helm.sh/docs/topics/library_charts/#helm) as a dependency. More documentation about this new utility could be found [here](https://github.com/bitnami/charts/tree/main/bitnami/common#bitnami-common-library-chart). Please, make sure that you have updated the chart dependencies before executing any upgrade.

### To 6.0.0

[On November 13, 2020, Helm v2 support formally ended](https://github.com/helm/charts#status-of-the-project). This major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

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