<!--- app-name: ClickHouse -->

# Bitnami package for ClickHouse

ClickHouse is an open-source column-oriented OLAP database management system. Use it to boost your database performance while providing linear scalability and hardware efficiency.

[Overview of ClickHouse](https://clickhouse.com/)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/clickhouse
```

Looking to use ClickHouse in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the commercial edition of the Bitnami catalog.

## Introduction

Bitnami charts for Helm are carefully engineered, actively maintained and are the quickest and easiest way to deploy containers on a Kubernetes cluster that are ready to handle production workloads.

This chart bootstraps a [ClickHouse](https://github.com/clickhouse/clickhouse) Deployment in a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+
- PV provisioner support in the underlying infrastructure
- ReadWriteMany volumes for deployment scaling

> If you are using Kubernetes 1.18, the following code needs to be commented out.
> seccompProfile:
> type: "RuntimeDefault"

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/clickhouse
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The command deploys ClickHouse on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Configuration and installation details

### Resource requests and limits

Bitnami charts allow setting resource requests and limits for all containers inside the chart deployment. These are inside the `resources` value (check parameter table). Setting requests is essential for production workloads and these should be adapted to your specific use case.

To make this process easier, the chart contains the `resourcesPreset` values, which automatically sets the `resources` section according to different presets. Check these presets in [the bitnami/common chart](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15). However, in production workloads using `resourcesPreset` is discouraged as it may not fully adapt to your specific needs. Find more information on container resource management in the [official Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).

### Prometheus metrics

This chart can be integrated with Prometheus by setting `metrics.enabled` to `true`. This will expose Clickhouse native Prometheus endpoint in the service. It will have the necessary annotations to be automatically scraped by Prometheus.

#### Prometheus requirements

It is necessary to have a working installation of Prometheus or Prometheus Operator for the integration to work. Install the [Bitnami Prometheus helm chart](https://github.com/bitnami/charts/tree/main/bitnami/prometheus) or the [Bitnami Kube Prometheus helm chart](https://github.com/bitnami/charts/tree/main/bitnami/kube-prometheus) to easily have a working Prometheus in your cluster.

#### Integration with Prometheus Operator

The chart can deploy `ServiceMonitor` objects for integration with Prometheus Operator installations. To do so, set the value `metrics.serviceMonitor.enabled=true`. Ensure that the Prometheus Operator `CustomResourceDefinitions` are installed in the cluster or it will fail with the following error:

```text
no matches for kind "ServiceMonitor" in version "monitoring.coreos.com/v1"
```

Install the [Bitnami Kube Prometheus helm chart](https://github.com/bitnami/charts/tree/main/bitnami/kube-prometheus) for having the necessary CRDs and the Prometheus Operator.

### [Rolling VS Immutable tags](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Update credentials

Bitnami charts configure credentials at first boot. Any further change in the secrets or credentials require manual intervention. Follow these instructions:

- Update the user password following [the upstream documentation](https://clickhouse.com/docs/en/sql-reference/statements/alter/user)
- Update the password secret with the new values (replace the SECRET_NAME, and PASSWORD placeholders)

```shell
kubectl create secret generic SECRET_NAME --from-literal=admin-password=PASSWORD --dry-run -o yaml | kubectl apply -f -
```

### ClickHouse Keeper

By default, this chart deploys ClickHouse Keeper, a lightweight and easy-to-use alternative to Zookeeper as an independent StatefulSet. This is mandatory if you're using more than 1 ClickHouse replica or sharding.

### External Zookeeper support

You may want to have ClickHouse connect to an external Zoo[Keeper] rather than installing ClickHouse Keeper inside your cluster. Typical reasons for this are to use a managed database service, or to share a common database server for all your applications. To achieve this, the chart allows you to specify credentials for an external database with the [`externalZookeeper` parameter](#parameters). You should also disable the ClickHouse Keeper installation with the `keeper.enabled` option. Here is an example:

```console
keeper.enabled=false
externalZookeeper.servers[0]=myexternalhost
externalZookeeper.port=2888
```

### Ingress without TLS

For using ingress (example without TLS):

```yaml
ingress:
  ## If true, ClickHouse server Ingress will be created
  ##
  enabled: true

  ## ClickHouse server Ingress annotations
  ##
  annotations: {}
  #   kubernetes.io/ingress.class: nginx
  #   kubernetes.io/tls-acme: 'true'

  ## ClickHouse server Ingress hostnames
  ## Must be provided if Ingress is enabled
  ##
  hosts:
    - clickhouse.domain.com
```

### Ingress TLS

If your cluster allows automatic creation/retrieval of TLS certificates, please refer to the documentation for that mechanism.

To manually configure TLS, first create/retrieve a key & certificate pair for the address(es) you wish to protect. Then create a TLS secret (named `clickhouse-server-tls` in this example) in the namespace. Include the secret's name, along with the desired hostnames, in the Ingress TLS section of your custom `values.yaml` file:

```yaml
ingress:
  ## If true, ClickHouse server Ingress will be created
  ##
  enabled: true

  ## ClickHouse server Ingress annotations
  ##
  annotations: {}
  #   kubernetes.io/ingress.class: nginx
  #   kubernetes.io/tls-acme: 'true'

  ## ClickHouse server Ingress hostnames
  ## Must be provided if Ingress is enabled
  ##
  hosts:
    - clickhouse.domain.com

  ## ClickHouse server Ingress TLS configuration
  ## Secrets must be manually created in the namespace
  ##
  tls:
    - secretName: clickhouse-server-tls
      hosts:
        - clickhouse.domain.com
```

### Securing traffic using TLS

This chart supports encrypting communications with ClickHouse using TLS. To enable this feature, set the `tls.enabled`.

It is necessary to create a secret containing the TLS certificates and pass it to the chart via the `tls.existingCASecret` and `tls.server.existingSecret` parameters. Every secret should contain a `tls.crt` and `tls.key` keys including the certificate and key files respectively. For example: create the CA secret with the certificates files:

```console
kubectl create secret generic ca-tls-secret --from-file=./tls.crt --from-file=./tls.key
```

You can manually create the required TLS certificates or relying on the chart auto-generation capabilities. The chart supports two different ways to auto-generate the required certificates:

- Using Helm capabilities. Enable this feature by setting `tls.autoGenerated.enabled` to `true` and `tls.autoGenerated.engine` to `helm`.
- Relying on CertManager (please note it's required to have CertManager installed in your K8s cluster). Enable this feature by setting `tls.autoGenerated.enabled` to `true` and `tls.autoGenerated.engine` to `cert-manager`. Please note it's supported to use an existing Issuer/ClusterIssuer for issuing the TLS certificates by setting the `tls.autoGenerated.certManager.existingIssuer` and `tls.autoGenerated.certManager.existingIssuerKind` parameters.

### Additional environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `extraEnvVars` property.

```yaml
clickhouse:
  extraEnvVars:
    - name: LOG_LEVEL
      value: error
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values.

### Sidecars

If additional containers are needed in the same pod as ClickHouse (such as additional metrics or logging exporters), they can be defined using the `sidecars` parameter.

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

### Using custom scripts

For advanced operations, the Bitnami ClickHouse chart allows using custom init and start scripts that will be mounted in `/docker-entrypoint.initdb.d` and `/docker-entrypoint.startdb.d` . The `init` scripts will be run on the first boot whereas the `start` scripts will be run on every container start. For adding the scripts directly as values use the `initdbScripts` and `startdbScripts` values. For using Secrets use the `initdbScriptsSecret` and `startdbScriptsSecret`.

```yaml
initdbScriptsSecret: init-scripts-secret
startdbScriptsSecret: start-scripts-secret
```

### Pod affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, use one of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

### Backup and restore

To back up and restore Helm chart deployments on Kubernetes, you need to back up the persistent volumes from the source deployment and attach them to a new deployment using [Velero](https://velero.io/), a Kubernetes backup/restore tool. Find the instructions for using Velero in [this guide](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-backup-restore-deployments-velero-index.html).

## Persistence

The [Bitnami ClickHouse](https://github.com/bitnami/containers/tree/main/bitnami/clickhouse) image stores the ClickHouse data and configurations at the `/bitnami/clickhouse` path of the container. Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.

## Parameters

### Global parameters

| Name                                                  | Description                                                                                                                                                                                                                                                                                                                                                         | Value   |
| ----------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `global.imageRegistry`                                | Global Docker image registry                                                                                                                                                                                                                                                                                                                                        | `""`    |
| `global.imagePullSecrets`                             | Global Docker registry secret names as an array                                                                                                                                                                                                                                                                                                                     | `[]`    |
| `global.defaultStorageClass`                          | Global default StorageClass for Persistent Volume(s)                                                                                                                                                                                                                                                                                                                | `""`    |
| `global.security.allowInsecureImages`                 | Allows skipping image verification                                                                                                                                                                                                                                                                                                                                  | `false` |
| `global.compatibility.openshift.adaptSecurityContext` | Adapt the securityContext sections of the deployment to make them compatible with Openshift restricted-v2 SCC: remove runAsUser, runAsGroup and fsGroup and let the platform use their allowed default IDs. Possible values: auto (apply if the detected running cluster is Openshift), force (perform the adaptation always), disabled (do not perform adaptation) | `auto`  |

### Common parameters

| Name                     | Description                                                                             | Value           |
| ------------------------ | --------------------------------------------------------------------------------------- | --------------- |
| `kubeVersion`            | Override Kubernetes version                                                             | `""`            |
| `apiVersions`            | Override Kubernetes API versions reported by .Capabilities                              | `[]`            |
| `nameOverride`           | String to partially override common.names.name                                          | `""`            |
| `fullnameOverride`       | String to fully override common.names.fullname                                          | `""`            |
| `namespaceOverride`      | String to fully override common.names.namespace                                         | `""`            |
| `commonLabels`           | Labels to add to all deployed objects                                                   | `{}`            |
| `commonAnnotations`      | Annotations to add to all deployed objects                                              | `{}`            |
| `clusterDomain`          | Kubernetes cluster domain name                                                          | `cluster.local` |
| `extraDeploy`            | Array of extra objects to deploy with the release                                       | `[]`            |
| `usePasswordFiles`       | Mount credentials as files instead of using environment variables                       | `true`          |
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden) | `false`         |
| `diagnosticMode.command` | Command to override all containers in the deployment                                    | `["sleep"]`     |
| `diagnosticMode.args`    | Args to override all containers in the deployment                                       | `["infinity"]`  |

### Default Init Container Parameters

| Name                                                                                        | Description                                                                                                                                                                                                                                                                                                                            | Value                      |
| ------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------- |
| `defaultInitContainers.volumePermissions.enabled`                                           | Enable init container that changes the owner and group of the persistent volume                                                                                                                                                                                                                                                        | `false`                    |
| `defaultInitContainers.volumePermissions.image.registry`                                    | "volume-permissions" init-containers' image registry                                                                                                                                                                                                                                                                                   | `REGISTRY_NAME`            |
| `defaultInitContainers.volumePermissions.image.repository`                                  | "volume-permissions" init-containers' image repository                                                                                                                                                                                                                                                                                 | `REPOSITORY_NAME/os-shell` |
| `defaultInitContainers.volumePermissions.image.digest`                                      | "volume-permissions" init-containers' image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                                                                                                  | `""`                       |
| `defaultInitContainers.volumePermissions.image.pullPolicy`                                  | "volume-permissions" init-containers' image pull policy                                                                                                                                                                                                                                                                                | `IfNotPresent`             |
| `defaultInitContainers.volumePermissions.image.pullSecrets`                                 | "volume-permissions" init-containers' image pull secrets                                                                                                                                                                                                                                                                               | `[]`                       |
| `defaultInitContainers.volumePermissions.containerSecurityContext.enabled`                  | Enabled "volume-permissions" init-containers' Security Context                                                                                                                                                                                                                                                                         | `true`                     |
| `defaultInitContainers.volumePermissions.containerSecurityContext.seLinuxOptions`           | Set SELinux options in "volume-permissions" init-containers                                                                                                                                                                                                                                                                            | `{}`                       |
| `defaultInitContainers.volumePermissions.containerSecurityContext.runAsUser`                | Set runAsUser in "volume-permissions" init-containers' Security Context                                                                                                                                                                                                                                                                | `0`                        |
| `defaultInitContainers.volumePermissions.containerSecurityContext.privileged`               | Set privileged in "volume-permissions" init-containers' Security Context                                                                                                                                                                                                                                                               | `false`                    |
| `defaultInitContainers.volumePermissions.containerSecurityContext.allowPrivilegeEscalation` | Set allowPrivilegeEscalation in "volume-permissions" init-containers' Security Context                                                                                                                                                                                                                                                 | `false`                    |
| `defaultInitContainers.volumePermissions.containerSecurityContext.capabilities.add`         | List of capabilities to be added in "volume-permissions" init-containers                                                                                                                                                                                                                                                               | `[]`                       |
| `defaultInitContainers.volumePermissions.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped in "volume-permissions" init-containers                                                                                                                                                                                                                                                             | `["ALL"]`                  |
| `defaultInitContainers.volumePermissions.containerSecurityContext.seccompProfile.type`      | Set seccomp profile in "volume-permissions" init-containers                                                                                                                                                                                                                                                                            | `RuntimeDefault`           |
| `defaultInitContainers.volumePermissions.resourcesPreset`                                   | Set ClickHouse Keeper "volume-permissions" init container resources according to one common preset (allowed values: none, nano, small, medium, large, xlarge, 2xlarge). This is ignored if defaultInitContainers.volumePermissions.resources is set (defaultInitContainers.volumePermissions.resources is recommended for production). | `nano`                     |
| `defaultInitContainers.volumePermissions.resources`                                         | Set ClickHouse Keeper "volume-permissions" init container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                                                                          | `{}`                       |

### ClickHouse parameters

| Name                                                | Description                                                                                                                                                                                                       | Value                        |
| --------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------- |
| `image.registry`                                    | ClickHouse image registry                                                                                                                                                                                         | `REGISTRY_NAME`              |
| `image.repository`                                  | ClickHouse image repository                                                                                                                                                                                       | `REPOSITORY_NAME/clickhouse` |
| `image.digest`                                      | ClickHouse image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                        | `""`                         |
| `image.pullPolicy`                                  | ClickHouse image pull policy                                                                                                                                                                                      | `IfNotPresent`               |
| `image.pullSecrets`                                 | ClickHouse image pull secrets                                                                                                                                                                                     | `[]`                         |
| `image.debug`                                       | Enable ClickHouse image debug mode                                                                                                                                                                                | `false`                      |
| `clusterName`                                       | ClickHouse cluster name                                                                                                                                                                                           | `default`                    |
| `auth.username`                                     | ClickHouse Admin username                                                                                                                                                                                         | `default`                    |
| `auth.password`                                     | ClickHouse Admin password                                                                                                                                                                                         | `""`                         |
| `auth.existingSecret`                               | Name of a secret containing the Admin password                                                                                                                                                                    | `""`                         |
| `auth.existingSecretKey`                            | Name of the key inside the existing secret                                                                                                                                                                        | `""`                         |
| `tls.enabled`                                       | Enable TLS configuration for ClickHouse                                                                                                                                                                           | `false`                      |
| `tls.autoGenerated.enabled`                         | Enable automatic generation of TLS certificates                                                                                                                                                                   | `true`                       |
| `tls.autoGenerated.engine`                          | Mechanism to generate the certificates (allowed values: helm, cert-manager)                                                                                                                                       | `helm`                       |
| `tls.autoGenerated.certManager.existingIssuer`      | The name of an existing Issuer to use for generating the certificates (only for `cert-manager` engine)                                                                                                            | `""`                         |
| `tls.autoGenerated.certManager.existingIssuerKind`  | Existing Issuer kind, defaults to Issuer (only for `cert-manager` engine)                                                                                                                                         | `""`                         |
| `tls.autoGenerated.certManager.keyAlgorithm`        | Key algorithm for the certificates (only for `cert-manager` engine)                                                                                                                                               | `RSA`                        |
| `tls.autoGenerated.certManager.keySize`             | Key size for the certificates (only for `cert-manager` engine)                                                                                                                                                    | `2048`                       |
| `tls.autoGenerated.certManager.duration`            | Duration for the certificates (only for `cert-manager` engine)                                                                                                                                                    | `2160h`                      |
| `tls.autoGenerated.certManager.renewBefore`         | Renewal period for the certificates (only for `cert-manager` engine)                                                                                                                                              | `360h`                       |
| `tls.ca`                                            | CA certificate for TLS. Ignored if `tls.existingCASecret` is set                                                                                                                                                  | `""`                         |
| `tls.existingCASecret`                              | The name of an existing Secret containing the CA certificate for TLS                                                                                                                                              | `""`                         |
| `tls.server.cert`                                   | TLS certificate for ClickHouse servers. Ignored if `tls.server.existingSecret` is set                                                                                                                             | `""`                         |
| `tls.server.key`                                    | TLS key for ClickHouse servers. Ignored if `tls.server.existingSecret` is set                                                                                                                                     | `""`                         |
| `tls.server.existingSecret`                         | The name of an existing Secret containing the TLS certificates for ClickHouse servers                                                                                                                             | `""`                         |
| `logLevel`                                          | Logging level                                                                                                                                                                                                     | `information`                |
| `configuration`                                     | Specify content for ClickHouse configuration (basic one auto-generated based on other values otherwise)                                                                                                           | `{}`                         |
| `existingConfigmap`                                 | The name of an existing ConfigMap with your custom configuration for ClickHouse                                                                                                                                   | `""`                         |
| `configdFiles`                                      | Extra configuration files to be mounted at config.d                                                                                                                                                               | `{}`                         |
| `existingConfigdConfigmap`                          | The name of an existing ConfigMap with extra configuration files for ClickHouse                                                                                                                                   | `""`                         |
| `usersdFiles`                                       | Extra users configuration files to be mounted at users.d                                                                                                                                                          | `{}`                         |
| `existingUsersdConfigmap`                           | The name of an existing ConfigMap with extra users configuration files for ClickHouse                                                                                                                             | `""`                         |
| `initdbScripts`                                     | Dictionary of initdb scripts                                                                                                                                                                                      | `{}`                         |
| `initdbScriptsSecret`                               | ConfigMap with the initdb scripts (Note: Overrides `initdbScripts`)                                                                                                                                               | `""`                         |
| `startdbScripts`                                    | Dictionary of startdb scripts                                                                                                                                                                                     | `{}`                         |
| `startdbScriptsSecret`                              | ConfigMap with the startdb scripts (Note: Overrides `startdbScripts`)                                                                                                                                             | `""`                         |
| `shards`                                            | Number of ClickHouse shards to deploy                                                                                                                                                                             | `2`                          |
| `replicaCount`                                      | Number of ClickHouse replicas per shard to deploy                                                                                                                                                                 | `3`                          |
| `distributeReplicasByZone`                          | Schedules replicas of the same shard to different availability zones                                                                                                                                              | `false`                      |
| `containerPorts.http`                               | ClickHouse HTTP container port                                                                                                                                                                                    | `8123`                       |
| `containerPorts.https`                              | ClickHouse HTTPS container port                                                                                                                                                                                   | `8443`                       |
| `containerPorts.tcp`                                | ClickHouse TCP container port                                                                                                                                                                                     | `9000`                       |
| `containerPorts.tcpSecure`                          | ClickHouse TCP (secure) container port                                                                                                                                                                            | `9440`                       |
| `containerPorts.mysql`                              | ClickHouse MySQL container port                                                                                                                                                                                   | `9004`                       |
| `containerPorts.postgresql`                         | ClickHouse PostgreSQL container port                                                                                                                                                                              | `9005`                       |
| `containerPorts.interserver`                        | ClickHouse Interserver container port                                                                                                                                                                             | `9009`                       |
| `containerPorts.metrics`                            | ClickHouse metrics container port                                                                                                                                                                                 | `8001`                       |
| `livenessProbe.enabled`                             | Enable livenessProbe on ClickHouse containers                                                                                                                                                                     | `true`                       |
| `livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                           | `10`                         |
| `livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                  | `10`                         |
| `livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                 | `1`                          |
| `livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                               | `3`                          |
| `livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                               | `1`                          |
| `readinessProbe.enabled`                            | Enable readinessProbe on ClickHouse containers                                                                                                                                                                    | `true`                       |
| `readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                          | `10`                         |
| `readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                 | `10`                         |
| `readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                | `1`                          |
| `readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                              | `3`                          |
| `readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                              | `1`                          |
| `startupProbe.enabled`                              | Enable startupProbe on ClickHouse containers                                                                                                                                                                      | `false`                      |
| `startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                            | `10`                         |
| `startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                   | `10`                         |
| `startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                  | `1`                          |
| `startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                | `3`                          |
| `startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                | `1`                          |
| `customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                                                                                                               | `{}`                         |
| `customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                                                                                                                              | `{}`                         |
| `customStartupProbe`                                | Custom startupProbe that overrides the default one                                                                                                                                                                | `{}`                         |
| `resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if resources is set (resources is recommended for production). | `small`                      |
| `resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                 | `{}`                         |
| `podSecurityContext.enabled`                        | Enabled ClickHouse pods' Security Context                                                                                                                                                                         | `true`                       |
| `podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                | `Always`                     |
| `podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                    | `[]`                         |
| `podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                       | `[]`                         |
| `podSecurityContext.fsGroup`                        | Set ClickHouse pod's Security Context fsGroup                                                                                                                                                                     | `1001`                       |
| `containerSecurityContext.enabled`                  | Enable containers' Security Context                                                                                                                                                                               | `true`                       |
| `containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                  | `{}`                         |
| `containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                                                                                                        | `1001`                       |
| `containerSecurityContext.runAsGroup`               | Set containers' Security Context runAsGroup                                                                                                                                                                       | `1001`                       |
| `containerSecurityContext.runAsNonRoot`             | Set containers' Security Context runAsNonRoot                                                                                                                                                                     | `true`                       |
| `containerSecurityContext.readOnlyRootFilesystem`   | Set read only root file system pod's                                                                                                                                                                              | `true`                       |
| `containerSecurityContext.privileged`               | Set ClickHouse container's Security Context privileged                                                                                                                                                            | `false`                      |
| `containerSecurityContext.allowPrivilegeEscalation` | Set ClickHouse container's Security Context allowPrivilegeEscalation                                                                                                                                              | `false`                      |
| `containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                | `["ALL"]`                    |
| `containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                  | `RuntimeDefault`             |
| `command`                                           | Override default container command (useful when using custom images)                                                                                                                                              | `[]`                         |
| `args`                                              | Override default container args (useful when using custom images)                                                                                                                                                 | `[]`                         |
| `automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                | `false`                      |
| `hostAliases`                                       | ClickHouse pods host aliases                                                                                                                                                                                      | `[]`                         |
| `podLabels`                                         | Extra labels for ClickHouse pods                                                                                                                                                                                  | `{}`                         |
| `podAnnotations`                                    | Annotations for ClickHouse pods                                                                                                                                                                                   | `{}`                         |
| `podAffinityPreset`                                 | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                               | `""`                         |
| `podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                          | `soft`                       |
| `nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                         | `""`                         |
| `nodeAffinityPreset.key`                            | Node label key to match. Ignored if `affinity` is set                                                                                                                                                             | `""`                         |
| `nodeAffinityPreset.values`                         | Node label values to match. Ignored if `affinity` is set                                                                                                                                                          | `[]`                         |
| `affinity`                                          | Affinity for ClickHouse pods assignment                                                                                                                                                                           | `{}`                         |
| `nodeSelector`                                      | Node labels for ClickHouse pods assignment                                                                                                                                                                        | `{}`                         |
| `tolerations`                                       | Tolerations for ClickHouse pods assignment                                                                                                                                                                        | `[]`                         |
| `updateStrategy.type`                               | ClickHouse StatefulSet strategy type                                                                                                                                                                              | `RollingUpdate`              |
| `updateStrategy.rollingUpdate`                      | ClickHouse StatefulSet rolling update configuration parameters                                                                                                                                                    | `{}`                         |
| `podManagementPolicy`                               | Statefulset Pod management policy, it needs to be Parallel to be able to complete the cluster join                                                                                                                | `Parallel`                   |
| `priorityClassName`                                 | ClickHouse pods' priorityClassName                                                                                                                                                                                | `""`                         |
| `topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template                                                                                          | `[]`                         |
| `schedulerName`                                     | Name of the k8s scheduler (other than default) for ClickHouse pods                                                                                                                                                | `""`                         |
| `terminationGracePeriodSeconds`                     | Seconds Redmine pod needs to terminate gracefully                                                                                                                                                                 | `""`                         |
| `lifecycleHooks`                                    | for the ClickHouse container(s) to automate configuration before or after startup                                                                                                                                 | `{}`                         |
| `extraEnvVars`                                      | Array with extra environment variables to add to ClickHouse nodes                                                                                                                                                 | `[]`                         |
| `extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for ClickHouse nodes                                                                                                                                         | `""`                         |
| `extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for ClickHouse nodes                                                                                                                                            | `""`                         |
| `extraVolumes`                                      | Optionally specify extra list of additional volumes for the ClickHouse pod(s)                                                                                                                                     | `[]`                         |
| `extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the ClickHouse container(s)                                                                                                                          | `[]`                         |
| `extraVolumeClaimTemplates`                         | Optionally specify extra list of additional volumeClaimTemplates for the ClickHouse container(s)                                                                                                                  | `[]`                         |
| `sidecars`                                          | Add additional sidecar containers to the ClickHouse pod(s)                                                                                                                                                        | `[]`                         |
| `initContainers`                                    | Add additional init containers to the ClickHouse pod(s)                                                                                                                                                           | `[]`                         |
| `pdb.create`                                        | Enable/disable a Pod Disruption Budget creation                                                                                                                                                                   | `true`                       |
| `pdb.minAvailable`                                  | Minimum number/percentage of pods that should remain scheduled                                                                                                                                                    | `""`                         |
| `pdb.maxUnavailable`                                | Maximum number/percentage of pods that may be made unavailable. Defaults to `1` if both `pdb.minAvailable` and `pdb.maxUnavailable` are empty.                                                                    | `""`                         |
| `autoscaling.vpa.enabled`                           | Enable VPA                                                                                                                                                                                                        | `false`                      |
| `autoscaling.vpa.annotations`                       | Annotations for VPA resource                                                                                                                                                                                      | `{}`                         |
| `autoscaling.vpa.controlledResources`               | VPA List of resources that the vertical pod autoscaler can control. Defaults to cpu and memory                                                                                                                    | `[]`                         |
| `autoscaling.vpa.maxAllowed`                        | VPA Max allowed resources for the pod                                                                                                                                                                             | `{}`                         |
| `autoscaling.vpa.minAllowed`                        | VPA Min allowed resources for the pod                                                                                                                                                                             | `{}`                         |
| `autoscaling.vpa.updatePolicy.updateMode`           | Autoscaling update policy Specifies whether recommended updates are applied when a Pod is started and whether recommended updates are applied during the life of a Pod                                            | `Auto`                       |

### ClickHouse Traffic Exposure parameters

| Name                                    | Description                                                                                                                                                 | Value                    |
| --------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `service.type`                          | ClickHouse service type                                                                                                                                     | `ClusterIP`              |
| `service.perReplicaAccess`              | Enable per-replica service creation                                                                                                                         | `false`                  |
| `service.ports.http`                    | ClickHouse service HTTP port                                                                                                                                | `8123`                   |
| `service.ports.https`                   | ClickHouse service HTTPS port                                                                                                                               | `443`                    |
| `service.ports.tcp`                     | ClickHouse service TCP port                                                                                                                                 | `9000`                   |
| `service.ports.tcpSecure`               | ClickHouse service TCP (secure) port                                                                                                                        | `9440`                   |
| `service.ports.mysql`                   | ClickHouse service MySQL port                                                                                                                               | `9004`                   |
| `service.ports.postgresql`              | ClickHouse service PostgreSQL port                                                                                                                          | `9005`                   |
| `service.ports.interserver`             | ClickHouse service Interserver port                                                                                                                         | `9009`                   |
| `service.ports.metrics`                 | ClickHouse service metrics port                                                                                                                             | `8001`                   |
| `service.nodePorts.http`                | Node port for HTTP                                                                                                                                          | `""`                     |
| `service.nodePorts.https`               | Node port for HTTPS                                                                                                                                         | `""`                     |
| `service.nodePorts.tcp`                 | Node port for TCP                                                                                                                                           | `""`                     |
| `service.nodePorts.tcpSecure`           | Node port for TCP (with TLS)                                                                                                                                | `""`                     |
| `service.nodePorts.mysql`               | Node port for MySQL                                                                                                                                         | `""`                     |
| `service.nodePorts.postgresql`          | Node port for PostgreSQL                                                                                                                                    | `""`                     |
| `service.nodePorts.interserver`         | Node port for Interserver                                                                                                                                   | `""`                     |
| `service.nodePorts.metrics`             | Node port for metrics                                                                                                                                       | `""`                     |
| `service.clusterIP`                     | ClickHouse service Cluster IP                                                                                                                               | `""`                     |
| `service.loadBalancerIP`                | ClickHouse service Load Balancer IP (only if per-replica access is disabled)                                                                                | `""`                     |
| `service.loadBalancerIPs`               | Array of ClickHouse service Load Balancer IPs (only if per-replica access is enabled). Length must be the same as shards multiplied by replicaCount         | `[]`                     |
| `service.loadBalancerAnnotations`       | Array of ClickHouse service Load Balancer annotations (only if per-replica access is enabled). Length must be the same as shards multiplied by replicaCount | `[]`                     |
| `service.loadBalancerSourceRanges`      | ClickHouse service Load Balancer sources                                                                                                                    | `[]`                     |
| `service.externalTrafficPolicy`         | ClickHouse service external traffic policy                                                                                                                  | `Cluster`                |
| `service.annotations`                   | Additional custom annotations for ClickHouse service                                                                                                        | `{}`                     |
| `service.extraPorts`                    | Extra ports to expose in ClickHouse service (normally used with the `sidecars` value)                                                                       | `[]`                     |
| `service.sessionAffinity`               | Control where client requests go, to the same pod or round-robin                                                                                            | `None`                   |
| `service.sessionAffinityConfig`         | Additional settings for the sessionAffinity                                                                                                                 | `{}`                     |
| `service.headless.annotations`          | Annotations for the headless service.                                                                                                                       | `{}`                     |
| `ingress.enabled`                       | Enable ingress record generation for ClickHouse                                                                                                             | `false`                  |
| `ingress.pathType`                      | Ingress path type                                                                                                                                           | `ImplementationSpecific` |
| `ingress.apiVersion`                    | Force Ingress API version (automatically detected if not set)                                                                                               | `""`                     |
| `ingress.hostname`                      | Default host for the ingress record                                                                                                                         | `clickhouse.local`       |
| `ingress.ingressClassName`              | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                                               | `""`                     |
| `ingress.path`                          | Default path for the ingress record                                                                                                                         | `/`                      |
| `ingress.annotations`                   | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations.                            | `{}`                     |
| `ingress.tls`                           | Enable TLS configuration for the host defined at `ingress.hostname` parameter                                                                               | `false`                  |
| `ingress.selfSigned`                    | Create a TLS secret for this ingress record using self-signed certificates generated by Helm                                                                | `false`                  |
| `ingress.extraHosts`                    | An array with additional hostname(s) to be covered with the ingress record                                                                                  | `[]`                     |
| `ingress.extraPaths`                    | An array with additional arbitrary paths that may need to be added to the ingress under the main host                                                       | `[]`                     |
| `ingress.extraTls`                      | TLS configuration for additional hostname(s) to be covered with this ingress record                                                                         | `[]`                     |
| `ingress.secrets`                       | Custom TLS certificates as secrets                                                                                                                          | `[]`                     |
| `ingress.extraRules`                    | Additional rules to be covered with this ingress record                                                                                                     | `[]`                     |
| `networkPolicy.enabled`                 | Specifies whether a NetworkPolicy should be created                                                                                                         | `true`                   |
| `networkPolicy.allowExternal`           | Don't require client label for connections                                                                                                                  | `true`                   |
| `networkPolicy.allowExternalEgress`     | Allow the pod to access any range of port and all destinations.                                                                                             | `true`                   |
| `networkPolicy.addExternalClientAccess` | Allow access from pods with client label set to "true". Ignored if `networkPolicy.allowExternal` is true.                                                   | `true`                   |
| `networkPolicy.extraIngress`            | Add extra ingress rules to the NetworkPolicy                                                                                                                | `[]`                     |
| `networkPolicy.extraEgress`             | Add extra ingress rules to the NetworkPolicy                                                                                                                | `[]`                     |
| `networkPolicy.ingressNSMatchLabels`    | Labels to match to allow traffic from other namespaces                                                                                                      | `{}`                     |
| `networkPolicy.ingressNSPodMatchLabels` | Pod labels to match to allow traffic from other namespaces                                                                                                  | `{}`                     |

### ClickHouse Persistence parameters

| Name                                               | Description                                                                    | Value                 |
| -------------------------------------------------- | ------------------------------------------------------------------------------ | --------------------- |
| `persistentVolumeClaimRetentionPolicy.enabled`     | Controls if and how PVCs are deleted during the lifecycle of a StatefulSet     | `false`               |
| `persistentVolumeClaimRetentionPolicy.whenScaled`  | Volume retention behavior when the replica count of the StatefulSet is reduced | `Retain`              |
| `persistentVolumeClaimRetentionPolicy.whenDeleted` | Volume retention behavior that applies when the StatefulSet is deleted         | `Retain`              |
| `persistence.enabled`                              | Enable persistence using Persistent Volume Claims                              | `true`                |
| `persistence.existingClaim`                        | Name of an existing PVC to use                                                 | `""`                  |
| `persistence.storageClass`                         | Storage class of backing PVC                                                   | `""`                  |
| `persistence.labels`                               | Persistent Volume Claim labels                                                 | `{}`                  |
| `persistence.annotations`                          | Persistent Volume Claim annotations                                            | `{}`                  |
| `persistence.accessModes`                          | Persistent Volume Access Modes                                                 | `["ReadWriteOnce"]`   |
| `persistence.size`                                 | Size of data volume                                                            | `8Gi`                 |
| `persistence.selector`                             | Selector to match an existing Persistent Volume for ClickHouse data PVC        | `{}`                  |
| `persistence.dataSource`                           | Custom PVC data source                                                         | `{}`                  |
| `persistence.mountPath`                            | Mount path of the ClickHouse data volume                                       | `/bitnami/clickhouse` |

### ClickHouse Keeper parameters

| Name                                                       | Description                                                                                                                                                                                                                     | Value                               |
| ---------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------- |
| `keeper.enabled`                                           | Deploy ClickHouse Keeper to provide coordination capabilities                                                                                                                                                                   | `true`                              |
| `keeper.image.registry`                                    | ClickHouse Keeper image registry                                                                                                                                                                                                | `REGISTRY_NAME`                     |
| `keeper.image.repository`                                  | ClickHouse Keeper image repository                                                                                                                                                                                              | `REPOSITORY_NAME/clickhouse-keeper` |
| `keeper.image.digest`                                      | ClickHouse Keeper image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag image tag (immutable tags are recommended)                                                                    | `""`                                |
| `keeper.image.pullPolicy`                                  | ClickHouse Keeper image pull policy                                                                                                                                                                                             | `IfNotPresent`                      |
| `keeper.image.pullSecrets`                                 | ClickHouse Keeper image pull secrets                                                                                                                                                                                            | `[]`                                |
| `keeper.image.debug`                                       | Enable ClickHouse image debug mode                                                                                                                                                                                              | `false`                             |
| `keeper.replicaCount`                                      | Number of ClickHouse Keeper replicas to deploy                                                                                                                                                                                  | `3`                                 |
| `keeper.configuration`                                     | Specify content for ClickHouse Keeper configuration (basic one auto-generated based on other values otherwise)                                                                                                                  | `{}`                                |
| `keeper.existingConfigmap`                                 | The name of an existing ConfigMap with your custom configuration for ClickHouse Keeper                                                                                                                                          | `""`                                |
| `keeper.configdFiles`                                      | Extra configuration files to be mounted at keeper_config.d                                                                                                                                                                      | `{}`                                |
| `keeper.existingConfigdConfigmap`                          | The name of an existing ConfigMap with extra configuration files for ClickHouse Keeper                                                                                                                                          | `""`                                |
| `keeper.usersdFiles`                                       | Extra users configuration files to be mounted at users.d                                                                                                                                                                        | `{}`                                |
| `keeper.existingUsersdConfigmap`                           | The name of an existing ConfigMap with extra users configuration files for ClickHouse Keeper                                                                                                                                    | `""`                                |
| `keeper.containerPorts.tcp`                                | ClickHouse Keeper TCP container port                                                                                                                                                                                            | `9181`                              |
| `keeper.containerPorts.raft`                               | ClickHouse Keeper Raft container port                                                                                                                                                                                           | `9234`                              |
| `keeper.extraContainerPorts`                               | ClickHouse Keeper extra containerPorts                                                                                                                                                                                          | `[]`                                |
| `keeper.livenessProbe.enabled`                             | Enable livenessProbe on ClickHouse Keeper containers                                                                                                                                                                            | `true`                              |
| `keeper.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                                         | `10`                                |
| `keeper.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                                | `10`                                |
| `keeper.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                               | `1`                                 |
| `keeper.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                                             | `3`                                 |
| `keeper.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                                             | `1`                                 |
| `keeper.readinessProbe.enabled`                            | Enable readinessProbe on ClickHouse Keeper containers                                                                                                                                                                           | `true`                              |
| `keeper.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                                        | `10`                                |
| `keeper.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                               | `10`                                |
| `keeper.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                              | `1`                                 |
| `keeper.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                                            | `3`                                 |
| `keeper.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                                            | `1`                                 |
| `keeper.startupProbe.enabled`                              | Enable startupProbe on ClickHouse Keeper containers                                                                                                                                                                             | `false`                             |
| `keeper.startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                                          | `10`                                |
| `keeper.startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                                 | `10`                                |
| `keeper.startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                                | `1`                                 |
| `keeper.startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                              | `3`                                 |
| `keeper.startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                              | `1`                                 |
| `keeper.customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                                                                                                                             | `{}`                                |
| `keeper.customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                                                                                                                                            | `{}`                                |
| `keeper.customStartupProbe`                                | Custom startupProbe that overrides the default one                                                                                                                                                                              | `{}`                                |
| `keeper.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if keeper.resources is set (keeper.resources is recommended for production). | `small`                             |
| `keeper.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                               | `{}`                                |
| `keeper.podSecurityContext.enabled`                        | Enabled ClickHouse Keeper pods' Security Context                                                                                                                                                                                | `true`                              |
| `keeper.podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                              | `Always`                            |
| `keeper.podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                                  | `[]`                                |
| `keeper.podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                                     | `[]`                                |
| `keeper.podSecurityContext.fsGroup`                        | Set ClickHouse Keeper pod's Security Context fsGroup                                                                                                                                                                            | `1001`                              |
| `keeper.containerSecurityContext.enabled`                  | Enabled ClickHouse Keeper containers' Security Context                                                                                                                                                                          | `true`                              |
| `keeper.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                                | `{}`                                |
| `keeper.containerSecurityContext.runAsUser`                | Set ClickHouse Keeper containers' Security Context runAsUser                                                                                                                                                                    | `1001`                              |
| `keeper.containerSecurityContext.runAsGroup`               | Set ClickHouse Keeper containers' Security Context runAsGroup                                                                                                                                                                   | `1001`                              |
| `keeper.containerSecurityContext.runAsNonRoot`             | Set ClickHouse Keeper containers' Security Context runAsNonRoot                                                                                                                                                                 | `true`                              |
| `keeper.containerSecurityContext.privileged`               | Set web container's Security Context privileged                                                                                                                                                                                 | `false`                             |
| `keeper.containerSecurityContext.allowPrivilegeEscalation` | Set web container's Security Context allowPrivilegeEscalation                                                                                                                                                                   | `false`                             |
| `keeper.containerSecurityContext.readOnlyRootFilesystem`   | Set web container's Security Context readOnlyRootFilesystem                                                                                                                                                                     | `true`                              |
| `keeper.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                              | `["ALL"]`                           |
| `keeper.containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                                | `RuntimeDefault`                    |
| `keeper.command`                                           | Override default container command (useful when using custom images)                                                                                                                                                            | `[]`                                |
| `keeper.args`                                              | Override default container args (useful when using custom images)                                                                                                                                                               | `[]`                                |
| `keeper.extraEnvVars`                                      | Array with extra environment variables to add to ClickHouse Keeper container(s)                                                                                                                                                 | `[]`                                |
| `keeper.extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for ClickHouse Keeper container(s)                                                                                                                                         | `""`                                |
| `keeper.extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for ClickHouse Keeper container(s)                                                                                                                                            | `""`                                |
| `keeper.automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                              | `false`                             |
| `keeper.hostAliases`                                       | ClickHouse Keeper pods host aliases                                                                                                                                                                                             | `[]`                                |
| `keeper.podLabels`                                         | Extra labels for ClickHouse Keeper pods                                                                                                                                                                                         | `{}`                                |
| `keeper.podAnnotations`                                    | Annotations for ClickHouse Keeper pods                                                                                                                                                                                          | `{}`                                |
| `keeper.podAffinityPreset`                                 | Pod affinity preset. Ignored if `keeper.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                      | `""`                                |
| `keeper.podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `keeper.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                 | `soft`                              |
| `keeper.nodeAffinityPreset.key`                            | Node label key to match. Ignored if `keeper.affinity` is set.                                                                                                                                                                   | `""`                                |
| `keeper.nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `keeper.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                | `""`                                |
| `keeper.nodeAffinityPreset.values`                         | Node label values to match. Ignored if `keeper.affinity` is set.                                                                                                                                                                | `[]`                                |
| `keeper.affinity`                                          | Affinity for ClickHouse Keeper pods assignment                                                                                                                                                                                  | `{}`                                |
| `keeper.nodeSelector`                                      | Node labels for ClickHouse Keeper pods assignment                                                                                                                                                                               | `{}`                                |
| `keeper.tolerations`                                       | Tolerations for ClickHouse Keeper pods assignment                                                                                                                                                                               | `[]`                                |
| `keeper.updateStrategy.type`                               | ClickHouse Keeper StatefulSet strategy type                                                                                                                                                                                     | `RollingUpdate`                     |
| `keeper.updateStrategy.rollingUpdate`                      | ClickHouse Keeper StatefulSet rolling update configuration parameters                                                                                                                                                           | `{}`                                |
| `keeper.podManagementPolicy`                               | StatefulSet Pod management policy, it needs to be Parallel to be able to complete the cluster join                                                                                                                              | `Parallel`                          |
| `keeper.priorityClassName`                                 | ClickHouse Keeper pods' priorityClassName                                                                                                                                                                                       | `""`                                |
| `keeper.topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template                                                                                                        | `[]`                                |
| `keeper.schedulerName`                                     | Name of the k8s scheduler (other than default) for ClickHouse pods                                                                                                                                                              | `""`                                |
| `keeper.terminationGracePeriodSeconds`                     | Seconds Redmine pod needs to terminate gracefully                                                                                                                                                                               | `""`                                |
| `keeper.lifecycleHooks`                                    | for the ClickHouse Keeper container(s) to automate configuration before or after startup                                                                                                                                        | `{}`                                |
| `keeper.extraVolumes`                                      | Optionally specify extra list of additional volumes for the ClickHouse Keeper pod(s)                                                                                                                                            | `[]`                                |
| `keeper.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the ClickHouse Keeper container(s)                                                                                                                                 | `[]`                                |
| `keeper.sidecars`                                          | Add additional sidecar containers to the ClickHouse Keeper pod(s)                                                                                                                                                               | `[]`                                |
| `keeper.initContainers`                                    | Add additional init containers to the ClickHouse Keeper pod(s)                                                                                                                                                                  | `[]`                                |
| `keeper.pdb.create`                                        | Deploy a pdb object for the ClickHouse Keeper pods                                                                                                                                                                              | `true`                              |
| `keeper.pdb.minAvailable`                                  | Maximum number/percentage of unavailable ClickHouse Keeper replicas                                                                                                                                                             | `""`                                |
| `keeper.pdb.maxUnavailable`                                | Maximum number/percentage of unavailable ClickHouse Keeper replicas                                                                                                                                                             | `""`                                |
| `keeper.autoscaling.vpa.enabled`                           | Enable VPA                                                                                                                                                                                                                      | `false`                             |
| `keeper.autoscaling.vpa.annotations`                       | Annotations for VPA resource                                                                                                                                                                                                    | `{}`                                |
| `keeper.autoscaling.vpa.controlledResources`               | VPA List of resources that the vertical pod autoscaler can control. Defaults to cpu and memory                                                                                                                                  | `[]`                                |
| `keeper.autoscaling.vpa.maxAllowed`                        | VPA Max allowed resources for the pod                                                                                                                                                                                           | `{}`                                |
| `keeper.autoscaling.vpa.minAllowed`                        | VPA Min allowed resources for the pod                                                                                                                                                                                           | `{}`                                |
| `keeper.autoscaling.vpa.updatePolicy.updateMode`           | Autoscaling update policy Specifies whether recommended updates are applied when a Pod is started and whether recommended updates are applied during the life of a Pod                                                          | `Auto`                              |

### ClickHouse Keeper Traffic Exposure parameters

| Name                                           | Description                                                                                                      | Value       |
| ---------------------------------------------- | ---------------------------------------------------------------------------------------------------------------- | ----------- |
| `keeper.service.type`                          | ClickHouse Keeper service type                                                                                   | `ClusterIP` |
| `keeper.service.ports.tcp`                     | ClickHouse Keeper service TCP port                                                                               | `9181`      |
| `keeper.service.ports.raft`                    | ClickHouse Keeper service Raft port                                                                              | `9234`      |
| `keeper.service.nodePorts.tcp`                 | Node port for ClickHouse Keeper service TCP port                                                                 | `""`        |
| `keeper.service.nodePorts.raft`                | Node port for ClickHouse Keeper service Raft port                                                                | `""`        |
| `keeper.service.clusterIP`                     | ClickHouse Keeper service Cluster IP                                                                             | `""`        |
| `keeper.service.loadBalancerIP`                | ClickHouse Keeper service Load Balancer IP                                                                       | `""`        |
| `keeper.service.loadBalancerSourceRanges`      | ClickHouse Keeper service Load Balancer sources                                                                  | `[]`        |
| `keeper.service.externalTrafficPolicy`         | ClickHouse Keeper service external traffic policy                                                                | `Cluster`   |
| `keeper.service.annotations`                   | Additional custom annotations for ClickHouse Keeper service                                                      | `{}`        |
| `keeper.service.extraPorts`                    | Extra ports to expose in ClickHouse Keeper service (normally used with the `sidecars` value)                     | `[]`        |
| `keeper.service.sessionAffinity`               | Control where client requests go, to the same pod or round-robin                                                 | `None`      |
| `keeper.service.sessionAffinityConfig`         | Additional settings for the sessionAffinity                                                                      | `{}`        |
| `keeper.service.headless.annotations`          | Annotations for the headless service.                                                                            | `{}`        |
| `keeper.networkPolicy.enabled`                 | Specifies whether a NetworkPolicy should be created                                                              | `true`      |
| `keeper.networkPolicy.allowExternal`           | Don't require client label for connections                                                                       | `true`      |
| `keeper.networkPolicy.allowExternalEgress`     | Allow the pod to access any range of port and all destinations.                                                  | `true`      |
| `keeper.networkPolicy.addExternalClientAccess` | Allow access from pods with client label set to "true". Ignored if `keeper.networkPolicy.allowExternal` is true. | `true`      |
| `keeper.networkPolicy.extraIngress`            | Add extra ingress rules to the NetworkPolicy                                                                     | `[]`        |
| `keeper.networkPolicy.extraEgress`             | Add extra ingress rules to the NetworkPolicy                                                                     | `[]`        |
| `keeper.networkPolicy.ingressNSMatchLabels`    | Labels to match to allow traffic from other namespaces                                                           | `{}`        |
| `keeper.networkPolicy.ingressNSPodMatchLabels` | Pod labels to match to allow traffic from other namespaces                                                       | `{}`        |

### ClickHouse Keeper Persistence parameters

| Name                                                      | Description                                                                                                                                    | Value                        |
| --------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------- |
| `keeper.persistentVolumeClaimRetentionPolicy.enabled`     | Controls if and how PVCs are deleted during the lifecycle of a StatefulSet                                                                     | `false`                      |
| `keeper.persistentVolumeClaimRetentionPolicy.whenScaled`  | Volume retention behavior when the replica count of the StatefulSet is reduced                                                                 | `Retain`                     |
| `keeper.persistentVolumeClaimRetentionPolicy.whenDeleted` | Volume retention behavior that applies when the StatefulSet is deleted                                                                         | `Retain`                     |
| `keeper.persistence.enabled`                              | Enable ClickHouse Keeper data persistence using PVC                                                                                            | `true`                       |
| `keeper.persistence.existingClaim`                        | A manually managed Persistent Volume and Claim                                                                                                 | `""`                         |
| `keeper.persistence.storageClass`                         | PVC Storage Class for ClickHouse Keeper data volume                                                                                            | `""`                         |
| `keeper.persistence.accessModes`                          | Persistent Volume Access Modes                                                                                                                 | `["ReadWriteOnce"]`          |
| `keeper.persistence.size`                                 | PVC Storage Request for ClickHouse Keeper data volume                                                                                          | `8Gi`                        |
| `keeper.persistence.annotations`                          | Annotations for the PVC                                                                                                                        | `{}`                         |
| `keeper.persistence.labels`                               | Labels for the PVC                                                                                                                             | `{}`                         |
| `keeper.persistence.selector`                             | Selector to match an existing Persistent Volume for ClickHouse Keeper data PVC. If set, the PVC can't have a PV dynamically provisioned for it | `{}`                         |
| `keeper.persistence.dataSource`                           | Custom PVC data source                                                                                                                         | `{}`                         |
| `keeper.persistence.mountPath`                            | Mount path of the ClickHouse Keeper data volume                                                                                                | `/bitnami/clickhouse-keeper` |

### Other Parameters

| Name                                          | Description                                                      | Value   |
| --------------------------------------------- | ---------------------------------------------------------------- | ------- |
| `serviceAccount.create`                       | Specifies whether a ServiceAccount should be created             | `true`  |
| `serviceAccount.name`                         | The name of the ServiceAccount to use.                           | `""`    |
| `serviceAccount.annotations`                  | Additional Service Account annotations (evaluated as a template) | `{}`    |
| `serviceAccount.automountServiceAccountToken` | Automount service account token for the server service account   | `false` |

### Prometheus metrics parameters

| Name                                       | Description                                                                                            | Value   |
| ------------------------------------------ | ------------------------------------------------------------------------------------------------------ | ------- |
| `metrics.enabled`                          | Enable the export of Prometheus metrics                                                                | `false` |
| `metrics.podAnnotations`                   | Pod annotations for enabling Prometheus to access the metrics endpoint                                 | `{}`    |
| `metrics.serviceMonitor.enabled`           | if `true`, creates a Prometheus Operator ServiceMonitor (also requires `metrics.enabled` to be `true`) | `false` |
| `metrics.serviceMonitor.namespace`         | Namespace in which Prometheus is running                                                               | `""`    |
| `metrics.serviceMonitor.annotations`       | Additional custom annotations for the ServiceMonitor                                                   | `{}`    |
| `metrics.serviceMonitor.labels`            | Extra labels for the ServiceMonitor                                                                    | `{}`    |
| `metrics.serviceMonitor.jobLabel`          | The name of the label on the target service to use as the job name in Prometheus                       | `""`    |
| `metrics.serviceMonitor.honorLabels`       | honorLabels chooses the metric's labels on collisions with target labels                               | `false` |
| `metrics.serviceMonitor.interval`          | Interval at which metrics should be scraped.                                                           | `""`    |
| `metrics.serviceMonitor.scrapeTimeout`     | Timeout after which the scrape is ended                                                                | `""`    |
| `metrics.serviceMonitor.metricRelabelings` | Specify additional relabeling of metrics                                                               | `[]`    |
| `metrics.serviceMonitor.relabelings`       | Specify general relabeling                                                                             | `[]`    |
| `metrics.serviceMonitor.selector`          | Prometheus instance selector labels                                                                    | `{}`    |
| `metrics.prometheusRule.enabled`           | Create a PrometheusRule for Prometheus Operator                                                        | `false` |
| `metrics.prometheusRule.namespace`         | Namespace for the PrometheusRule Resource (defaults to the Release Namespace)                          | `""`    |
| `metrics.prometheusRule.additionalLabels`  | Additional labels that can be used so PrometheusRule will be discovered by Prometheus                  | `{}`    |
| `metrics.prometheusRule.rules`             | PrometheusRule definitions                                                                             | `[]`    |

### External ClickHouse Keeper / Zookeeper parameters

| Name                        | Description                                                   | Value  |
| --------------------------- | ------------------------------------------------------------- | ------ |
| `externalZookeeper.servers` | List of external ClickHouse Keeper / Zookeeper servers to use | `[]`   |
| `externalZookeeper.port`    | Port of the ClickHouse Keeper / Zookeeper servers             | `2888` |

See <https://github.com/bitnami/readme-generator-for-helm> to create the table.

The above parameters map to the env variables defined in [bitnami/clickhouse](https://github.com/bitnami/containers/tree/main/bitnami/clickhouse). For more information please refer to the [bitnami/clickhouse](https://github.com/bitnami/containers/tree/main/bitnami/clickhouse) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
  --set auth.username=admin \
  --set auth.password=password \
    oci://REGISTRY_NAME/REPOSITORY_NAME/clickhouse
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The above command sets the ClickHouse administrator account username and password to `admin` and `password` respectively.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml oci://REGISTRY_NAME/REPOSITORY_NAME/clickhouse
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.
> **Tip**: You can use the default [values.yaml](https://github.com/bitnami/charts/tree/main/bitnami/clickhouse/values.yaml)

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 9.0.0

This major release replaces ZooKeeper with ClickHouse Keeper by default, as a consequence, **ZooKeeper is no longer a chart dependency and every related parameter has been removed.**. In addition, ClickHouse Keeper is no longer started as an additional process on ClickHouse containers but as a separate StatefulSet. This means that the `keeper.*` parameters are now used to configure the ClickHouse Keeper StatefulSet.

> Note: It still possible to use existing ZooKeeper servers to provide coordination capabilities using the `externalZookeeper.*` parameters.

Other notable changes:

- `defaultConfigurationOverrides`, `extraOverrides` and `usersExtraOverrides` are deprecated in favor of `configuration`, `configdFiles` and `usersdFiles`, respectively.
- `existingOverridesConfigmap`, `extraOverridesConfigmap|extraOverridesSecret` and `usersExtraOverridesConfigmap|usersExtraOverridesSecret` are deprecated in favor of `existingConfigmap`, `existingConfigdConfigmap` and `existingUsersdConfigmap`, respectively.
- `tls.autoGenerated` boolean is now an object with extended configuration options.
- `externalAccess.service.*` parameters have been moved under `service.*` parameter. In order to create a service per replica, set `service.perReplicaAccess` to `true`.
- `volumePermissions` parameters have been moved under `defaultInitContainers` parameter.

In order to upgrade from `8.y.z` to this major version, if ZooKeeper was used on your existing release, you have two alternatives:

- Stop ZooKeeper servers and migrate the ZooKeeper data to ClickHouse Keeper data as explained in the [official documentation](https://clickhouse.com/docs/guides/sre/keeper/clickhouse-keeper#migration-from-zookeeper).
- Scale down your existing ZooKeeper StatefulSet to 0 replicas keeping its associated PVC(s). Then, deploy the Bitnami ZooKeeper Helm chart independently reusing PVC(s) that were used by your previous ZooKeeper servers. Finally, upgrade using the `externalZookeeper.*` parameters to connect to the existing ZooKeeper servers.

### To 7.1.0

This version introduces image verification for security purposes. To disable it, set `global.security.allowInsecureImages` to `true`. More details at [GitHub issue](https://github.com/bitnami/charts/issues/30850).

### To 7.0.0

This major updates the Zookeeper version from 3.8.x to 3.9.x. Instead of overwritting it in this chart values, it will automatically use the version defined in the zookeeper subchart.

### To 6.0.0

This major bump changes the following security defaults:

- `runAsGroup` is changed from `0` to `1001`
- `readOnlyRootFilesystem` is set to `true`
- `resourcesPreset` is changed from `none` to the minimum size working in our test suites (NOTE: `resourcesPreset` is not meant for production usage, but `resources` adapted to your use case).
- `global.compatibility.openshift.adaptSecurityContext` is changed from `disabled` to `auto`.
- The zookeeper subchart has been bumped to branch 13.x.x, with the same changes as described above.

This could potentially break any customization or init scripts used in your deployment. If this is the case, change the default values to the previous ones.

### To 2.0.0

This major updates the Zookeeper subchart to it newest major, 11.0.0. For more information on this subchart's major, please refer to [zookeeper upgrade notes](https://github.com/bitnami/charts/tree/main/bitnami/zookeeper#to-1100).

## License

Copyright &copy; 2025 Broadcom. The term "Broadcom" refers to Broadcom Inc. and/or its subsidiaries.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

<http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
