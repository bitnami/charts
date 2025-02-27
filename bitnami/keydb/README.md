<!--- app-name: KeyDB -->

# Bitnami package for KeyDB

KeyDB is a high performance fork of Redis with a focus on multithreading, memory efficiency, and high throughput.

[Overview of KeyDB](https://github.com/Snapchat/KeyDB)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/keydb
```

Looking to use KeyDB in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the commercial edition of the Bitnami catalog.

## Introduction

Bitnami charts for Helm are carefully engineered, actively maintained and are the quickest and easiest way to deploy containers on a Kubernetes cluster that are ready to handle production workloads.

This chart bootstraps a [KeyDB](https://github.com/Snapchat/KeyDB) deployment in a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/keydb
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The command deploys KeyDB on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Configuration and installation details

### Cluster topologies

#### Default: Master - Replicas

When installing the chart with `architecture=replication`, it will deploy a KeyDB Master statefulset and a KeyDB Replica statefulset. The master is responsible for all write operations, while the replicas replicate the write operations from the master and serve read operations. Two services will be exposed:

- KeyDB Master service: Points to the master, where read-write operations can be performed
- KeyDB Replicas service: Points to the replicas, where only read operations are allowed by default.

In case the master crashes, the replicas will wait until the master node is respawned again by the Kubernetes Controller Manager.

#### Active Replicas

Similar to the Master-Replicas architecture, but with the ability to perform read and write operations on the replicas. This is achieved by setting `replica.activeReplica=true`. Find more information about how this mechanism works at the [KeyDB documentation](https://docs.keydb.dev/docs/active-rep).

#### Standalone

When installing the chart with `architecture=standalone`, it will deploy a standalone KeyDB Master statefulset. A single service will be exposed:

- KeyDB Master service: Points to the master, where read-write operations can be performed

#### Multi Master - Replicas

Similar to the Master-Replicas architecture, this architectures deploys both a KeyDB Master statefulset and a KeyDB Replica statefulset. However, in this architecture N Master replicas can be deployed, and KeyDB replicas are configured to follow multiple masters. This can be achieved by setting `master.replicaCount` to a value greater than 1 and setting `replica.activeReplica=true` (please note active replication is mandatory when using multi-master).

Find more information about how this mechanism works at the [KeyDB documentation](https://docs.keydb.dev/docs/multi-master).

### Prometheus metrics

This chart can be integrated with Prometheus by setting `metrics.enabled` to `true`. This will deploy a sidecar container with [redis_exporter](https://github.com/oliver006/redis_exporter) in all pods and a `metrics` service, which can be configured under the `metrics.service` section. This `metrics` service will have the necessary annotations to be automatically scraped by Prometheus.

#### Prometheus requirements

It is necessary to have a working installation of Prometheus or Prometheus Operator for the integration to work. Install the [Bitnami Prometheus helm chart](https://github.com/bitnami/charts/tree/main/bitnami/prometheus) or the [Bitnami Kube Prometheus helm chart](https://github.com/bitnami/charts/tree/main/bitnami/kube-prometheus) to easily have a working Prometheus in your cluster.

#### Integration with Prometheus Operator

The chart can deploy `ServiceMonitor` objects for integration with Prometheus Operator installations. To do so, set the value `metrics.serviceMonitor.enabled=true`. Ensure that the Prometheus Operator `CustomResourceDefinitions` are installed in the cluster or it will fail with the following error:

```text
no matches for kind "ServiceMonitor" in version "monitoring.coreos.com/v1"
```

Install the [Bitnami Kube Prometheus helm chart](https://github.com/bitnami/charts/tree/main/bitnami/kube-prometheus) for having the necessary CRDs and the Prometheus Operator.

### Update credentials

The Bitnami KeyDB chart, when upgrading, reuses the secret previously rendered by the chart or the one specified in `auth.existingSecret`. To update credentials, use one of the following:

- Run `helm upgrade` specifying a new password in `auth.password`
- Run `helm upgrade` specifying a new secret in `auth.existingSecret`

### Using a password file

To use a password file for KeyDB you need to create a secret containing the password and then deploy the chart using that secret. Follow these instructions:

- Create the secret:

```console
kubectl create secret generic keydb-password-secret --from-literal=keydb-password=KEYDB_PASSWORD
```

> Note: the replace the KEYDB_PASSWORD placeholder with the actual password to use.

- Deploy the Helm Chart using the secret name as parameter:

```text
auth.enabled=true
auth.existingSecret=keydb-password-secret
auth.existingSecretPasswordKey=keydb-password
auth.usePasswordFiles=true
```

### Securing traffic using TLS

This chart supports encrypting communications using TLS. To enable this feature, set the `tls.enabled`.

It is necessary to create a secret containing the TLS certificates and pass it to the chart via the `tls.existingCASecret`, `tls.master.existingSecret` and `tls.replica.existingSecret` (only for replication architecture) parameters. Every secret should contain a `tls.crt` and `tls.key` keys including the certificate and key files respectively. For example: create the CA secret with the certificates files:

```console
kubectl create secret generic ca-tls-secret --from-file=./tls.crt --from-file=./tls.key
```

You can manually create the required TLS certificates or relying on the chart auto-generation capabilities. The chart supports two different ways to auto-generate the required certificates:

- Using Helm capabilities. Enable this feature by setting `tls.autoGenerated.enabled` to `true` and `tls.autoGenerated.engine` to `helm`.
- Relying on CertManager (please note it's required to have CertManager installed in your K8s cluster). Enable this feature by setting `tls.autoGenerated.enabled` to `true` and `tls.autoGenerated.engine` to `cert-manager`. Please note it's supported to use an existing Issuer/ClusterIssuer for issuing the TLS certificates by setting the `tls.autoGenerated.certManager.existingIssuer` and `tls.autoGenerated.certManager.existingIssuerKind` parameters.

### Metrics

The chart optionally can start a metrics exporter for [prometheus](https://prometheus.io). Metrics can be scraped from within the cluster using something similar as the described in the [example Prometheus scrape configuration](https://github.com/prometheus/prometheus/blob/master/documentation/examples/prometheus-kubernetes.yml). If metrics are to be scraped from outside the cluster, the Kubernetes API proxy can be utilized to access the endpoint.

If you have enabled TLS by specifying `tls.enabled=true` you also need to specify TLS options to the metrics exporter. You can do that via `metrics.extraArgs`. You can find the metrics exporter CLI flags for TLS [here](https://github.com/oliver006/redis_exporter#command-line-flags). For example:

You can either specify `metrics.extraArgs.skip-tls-verification=true` to skip TLS verification or providing the following values under `metrics.extraArgs` for TLS client authentication:

```console
tls-client-key-file
tls-client-cert-file
tls-ca-cert-file
```

### [Rolling VS Immutable tags](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Resource requests and limits

Bitnami charts allow setting resource requests and limits for all containers inside the chart deployment. These are inside the `resources` value (check parameter table). Setting requests is essential for production workloads and these should be adapted to your specific use case.

To make this process easier, the chart contains the `resourcesPreset` values, which automatically sets the `resources` section according to different presets. Check these presets in [the bitnami/common chart](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15). However, in production workloads using `resourcesPreset` is discouraged as it may not fully adapt to your specific needs. Find more information on container resource management in the [official Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).

### Additional environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `extraEnvVars` property.

```yaml
master:
  extraEnvVars:
  - name: LOG_LEVEL
    value: error
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values.

### Sidecars

If additional containers are needed in the same pod as KeyDB (such as additional metrics or logging exporters), they can be defined using the `sidecars` parameter.

```yaml
master:
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
master:
  service:
    extraPorts:
    - name: extraPort
      port: 11311
      targetPort: 11311
```

> NOTE: This Helm chart already includes sidecar containers for the Prometheus exporters (where applicable). These can be activated by setting the `metrics.enabled` parameter to `true` at deployment time. The `sidecars` parameter should therefore only be used for any extra sidecar containers.

If additional init containers are needed in the same pod, they can be defined using the `initContainers` parameter. Here is an example:

```yaml
master:
  initContainers:
  - name: your-image-name
    image: your-image
    imagePullPolicy: Always
    ports:
      - name: portname
        containerPort: 1234
```

Learn more about [sidecar containers](https://kubernetes.io/docs/concepts/workloads/pods/) and [init containers](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/).

### Pod affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, use one of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

### Backup and restore

To back up and restore Helm chart deployments on Kubernetes, you need to back up the persistent volumes from the source deployment and attach them to a new deployment using [Velero](https://velero.io/), a Kubernetes backup/restore tool. Find the instructions for using Velero in [this guide](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-backup-restore-deployments-velero-index.html).

## Persistence

The [Bitnami KeyDB](https://github.com/bitnami/containers/tree/main/bitnami/keydb) image stores the KeyDB data and configurations at the `/bitnami/keydb/data` path of the container. Persistent Volume Claims are used to keep the data across deployments.

If you encounter errors when working with persistent volumes, refer to our [troubleshooting guide for persistent volumes](https://docs.bitnami.com/kubernetes/faq/troubleshooting/troubleshooting-persistence-volumes/).

## Parameters

### Global parameters

| Name                                                  | Description                                                                                                                                                                                                                                                                                                                                                         | Value   |
| ----------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `global.imageRegistry`                                | Global Docker image registry                                                                                                                                                                                                                                                                                                                                        | `""`    |
| `global.imagePullSecrets`                             | Global Docker registry secret names as an array                                                                                                                                                                                                                                                                                                                     | `[]`    |
| `global.defaultStorageClass`                          | Global default StorageClass for Persistent Volume(s)                                                                                                                                                                                                                                                                                                                | `""`    |
| `global.keydb.password`                               | Global KeyDB password (overrides `auth.password`)                                                                                                                                                                                                                                                                                                                   | `""`    |
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
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden) | `false`         |
| `diagnosticMode.command` | Command to override all containers in the chart release                                 | `["sleep"]`     |
| `diagnosticMode.args`    | Args to override all containers in the chart release                                    | `["infinity"]`  |

### KeyDB Image parameters

| Name                | Description                                                                                                                                      | Value                   |
| ------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------ | ----------------------- |
| `image.registry`    | KeyDB image registry                                                                                                                             | `REGISTRY_NAME`         |
| `image.repository`  | KeyDB image repository                                                                                                                           | `REPOSITORY_NAME/keydb` |
| `image.digest`      | KeyDB image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag image tag (immutable tags are recommended) | `""`                    |
| `image.pullPolicy`  | KeyDB image pull policy                                                                                                                          | `IfNotPresent`          |
| `image.pullSecrets` | KeyDB image pull secrets                                                                                                                         | `[]`                    |
| `image.debug`       | Enable KeyDB image debug mode                                                                                                                    | `false`                 |

### KeyDB common configuration parameters

| Name                                               | Description                                                                                            | Value         |
| -------------------------------------------------- | ------------------------------------------------------------------------------------------------------ | ------------- |
| `architecture`                                     | KeyDB architecture. Allowed values: `standalone` or `replication`                                      | `replication` |
| `auth.enabled`                                     | Enable password authentication                                                                         | `true`        |
| `auth.password`                                    | KeyDB password                                                                                         | `""`          |
| `auth.existingSecret`                              | The name of an existing secret with KeyDB credentials                                                  | `""`          |
| `auth.existingSecretPasswordKey`                   | Password key to be retrieved from existing secret                                                      | `""`          |
| `auth.usePasswordFiles`                            | Mount credentials as files instead of using an environment variable                                    | `true`        |
| `tls.enabled`                                      | Enable TLS communications                                                                              | `false`       |
| `tls.autoGenerated.enabled`                        | Enable automatic generation of certificates for TLS                                                    | `true`        |
| `tls.autoGenerated.engine`                         | Mechanism to generate the certificates (allowed values: helm, cert-manager)                            | `helm`        |
| `tls.autoGenerated.certManager.existingIssuer`     | The name of an existing Issuer to use for generating the certificates (only for `cert-manager` engine) | `""`          |
| `tls.autoGenerated.certManager.existingIssuerKind` | Existing Issuer kind, defaults to Issuer (only for `cert-manager` engine)                              | `""`          |
| `tls.autoGenerated.certManager.keyAlgorithm`       | Key algorithm for the certificates (only for `cert-manager` engine)                                    | `RSA`         |
| `tls.autoGenerated.certManager.keySize`            | Key size for the certificates (only for `cert-manager` engine)                                         | `2048`        |
| `tls.autoGenerated.certManager.duration`           | Duration for the certificates (only for `cert-manager` engine)                                         | `2160h`       |
| `tls.autoGenerated.certManager.renewBefore`        | Renewal period for the certificates (only for `cert-manager` engine)                                   | `360h`        |
| `tls.ca`                                           | CA certificate for TLS. Ignored if `tls.existingCASecret` is set                                       | `""`          |
| `tls.existingCASecret`                             | The name of an existing Secret containing the CA certificate for TLS                                   | `""`          |
| `tls.master.cert`                                  | TLS certificate for KeyDB master nodes. Ignored if `tls.master.existingSecret` is set                  | `""`          |
| `tls.master.key`                                   | TLS key for KeyDB master nodes. Ignored if `tls.master.existingSecret` is set                          | `""`          |
| `tls.master.existingSecret`                        | The name of an existing Secret containing the KeyDB master nodes certificates for TLS                  | `""`          |
| `tls.replica.cert`                                 | TLS certificate for KeyDB replica nodes. Ignored if `tls.replica.existingSecret` is set                | `""`          |
| `tls.replica.key`                                  | TLS key for KeyDB replica nodes. Ignored if `tls.replica.existingSecret` is set                        | `""`          |
| `tls.replica.existingSecret`                       | The name of an existing Secret containing the KeyDB replica nodes certificates for TLS                 | `""`          |
| `commonConfiguration`                              | Common configuration to be added to both master and replica nodes                                      | `""`          |

### KeyDB Master Configuration Parameters

| Name                                                       | Description                                                                                                                                                                                                             | Value                    |
| ---------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `master.replicaCount`                                      | Number of KeyDB master replicas to deploy                                                                                                                                                                               | `1`                      |
| `master.containerPorts.keydb`                              | Container port to open on KeyDB master nodes                                                                                                                                                                            | `6379`                   |
| `master.extraContainerPorts`                               | Optionally specify extra list of additional ports for KeyDB master containers                                                                                                                                           | `[]`                     |
| `master.livenessProbe.enabled`                             | Enable livenessProbe on KeyDB master containers                                                                                                                                                                         | `true`                   |
| `master.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                                 | `20`                     |
| `master.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                        | `5`                      |
| `master.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                       | `5`                      |
| `master.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                                     | `5`                      |
| `master.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                                     | `1`                      |
| `master.readinessProbe.enabled`                            | Enable readinessProbe on KeyDB master containers                                                                                                                                                                        | `true`                   |
| `master.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                                | `20`                     |
| `master.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                       | `5`                      |
| `master.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                      | `1`                      |
| `master.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                                    | `5`                      |
| `master.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                                    | `1`                      |
| `master.startupProbe.enabled`                              | Enable startupProbe on KeyDB master containers                                                                                                                                                                          | `false`                  |
| `master.startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                                  | `20`                     |
| `master.startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                         | `5`                      |
| `master.startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                        | `5`                      |
| `master.startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                      | `5`                      |
| `master.startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                      | `1`                      |
| `master.customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                                                                                                                     | `{}`                     |
| `master.customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                                                                                                                                    | `{}`                     |
| `master.customStartupProbe`                                | Custom startupProbe that overrides the default one                                                                                                                                                                      | `{}`                     |
| `master.resourcesPreset`                                   | Set KeyDB master container resources according to one common preset (allowed values: none, nano, small, medium, large, xlarge, 2xlarge). This is ignored if resources is set (resources is recommended for production). | `nano`                   |
| `master.resources`                                         | Set KeyDB master container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                          | `{}`                     |
| `master.podSecurityContext.enabled`                        | Enable KeyDB master pods' Security Context                                                                                                                                                                              | `true`                   |
| `master.podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy for KeyDB master pods                                                                                                                                                                | `Always`                 |
| `master.podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface for KeyDB master pods                                                                                                                                                    | `[]`                     |
| `master.podSecurityContext.supplementalGroups`             | Set filesystem extra groups for KeyDB master pods                                                                                                                                                                       | `[]`                     |
| `master.podSecurityContext.fsGroup`                        | Set fsGroup in KeyDB master pods' Security Context                                                                                                                                                                      | `1001`                   |
| `master.containerSecurityContext.enabled`                  | Enabled KeyDB master container' Security Context                                                                                                                                                                        | `true`                   |
| `master.containerSecurityContext.seLinuxOptions`           | Set SELinux options in KeyDB master container                                                                                                                                                                           | `{}`                     |
| `master.containerSecurityContext.runAsUser`                | Set runAsUser in KeyDB master container' Security Context                                                                                                                                                               | `1001`                   |
| `master.containerSecurityContext.runAsGroup`               | Set runAsGroup in KeyDB master container' Security Context                                                                                                                                                              | `1001`                   |
| `master.containerSecurityContext.runAsNonRoot`             | Set runAsNonRoot in KeyDB master container' Security Context                                                                                                                                                            | `true`                   |
| `master.containerSecurityContext.readOnlyRootFilesystem`   | Set readOnlyRootFilesystem in KeyDB master container' Security Context                                                                                                                                                  | `true`                   |
| `master.containerSecurityContext.privileged`               | Set privileged in KeyDB master container' Security Context                                                                                                                                                              | `false`                  |
| `master.containerSecurityContext.allowPrivilegeEscalation` | Set allowPrivilegeEscalation in KeyDB master container' Security Context                                                                                                                                                | `false`                  |
| `master.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped in KeyDB master container                                                                                                                                                            | `["ALL"]`                |
| `master.containerSecurityContext.seccompProfile.type`      | Set seccomp profile in KeyDB master container                                                                                                                                                                           | `RuntimeDefault`         |
| `master.configuration`                                     | Exclusive configuration for KeyDB master nodes (appended to common one)                                                                                                                                                 | `""`                     |
| `master.existingConfigmap`                                 | The name of an existing ConfigMap with your custom configuration for KeyDB master                                                                                                                                       | `""`                     |
| `master.disableCommands`                                   | Array with KeyDB commands to disable on master nodes                                                                                                                                                                    | `["FLUSHDB","FLUSHALL"]` |
| `master.command`                                           | Override default KeyDB master container command (useful when using custom images)                                                                                                                                       | `[]`                     |
| `master.args`                                              | Override default KeyDB master container args (useful when using custom images)                                                                                                                                          | `[]`                     |
| `master.automountServiceAccountToken`                      | Mount Service Account token in KeyDB master pods                                                                                                                                                                        | `false`                  |
| `master.hostAliases`                                       | KeyDB master pods host aliases                                                                                                                                                                                          | `[]`                     |
| `master.statefulsetAnnotations`                            | Annotations for KeyDB master statefulset                                                                                                                                                                                | `{}`                     |
| `master.podLabels`                                         | Extra labels for KeyDB master pods                                                                                                                                                                                      | `{}`                     |
| `master.podAnnotations`                                    | Annotations for KeyDB master pods                                                                                                                                                                                       | `{}`                     |
| `master.podAffinityPreset`                                 | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                     | `""`                     |
| `master.podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                | `soft`                   |
| `master.nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                               | `""`                     |
| `master.nodeAffinityPreset.key`                            | Node label key to match. Ignored if `affinity` is set                                                                                                                                                                   | `""`                     |
| `master.nodeAffinityPreset.values`                         | Node label values to match. Ignored if `affinity` is set                                                                                                                                                                | `[]`                     |
| `master.affinity`                                          | Affinity for KeyDB master pods assignment                                                                                                                                                                               | `{}`                     |
| `master.nodeSelector`                                      | Node labels for KeyDB master pods assignment                                                                                                                                                                            | `{}`                     |
| `master.tolerations`                                       | Tolerations for KeyDB master pods assignment                                                                                                                                                                            | `[]`                     |
| `master.updateStrategy.type`                               | KeyDB master strategy type                                                                                                                                                                                              | `RollingUpdate`          |
| `master.priorityClassName`                                 | KeyDB master pods' priorityClassName                                                                                                                                                                                    | `""`                     |
| `master.topologySpreadConstraints`                         | Topology Spread Constraints for KeyDB master pod assignment spread across your cluster among failure-domains                                                                                                            | `[]`                     |
| `master.schedulerName`                                     | Name of the k8s scheduler (other than default) for KeyDB master pods                                                                                                                                                    | `""`                     |
| `master.terminationGracePeriodSeconds`                     | Seconds KeyDB master pods need to terminate gracefully                                                                                                                                                                  | `""`                     |
| `master.lifecycleHooks`                                    | for KeyDB master containers to automate configuration before or after startup                                                                                                                                           | `{}`                     |
| `master.extraEnvVars`                                      | Array with extra environment variables to add to KeyDB master containers                                                                                                                                                | `[]`                     |
| `master.extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for KeyDB master containers                                                                                                                                        | `""`                     |
| `master.extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for KeyDB master containers                                                                                                                                           | `""`                     |
| `master.extraVolumes`                                      | Optionally specify extra list of additional volumes for the KeyDB master pods                                                                                                                                           | `[]`                     |
| `master.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the KeyDB master containers                                                                                                                                | `[]`                     |
| `master.sidecars`                                          | Add additional sidecar containers to the KeyDB master pods                                                                                                                                                              | `[]`                     |
| `master.initContainers`                                    | Add additional init containers to the KeyDB master pods                                                                                                                                                                 | `[]`                     |
| `master.pdb.create`                                        | Enable/disable a Pod Disruption Budget creation for KeyDB master pods                                                                                                                                                   | `true`                   |
| `master.pdb.minAvailable`                                  | Minimum number/percentage of KeyDB master pods that should remain scheduled                                                                                                                                             | `""`                     |
| `master.pdb.maxUnavailable`                                | Maximum number/percentage of KeyDB master pods that may be made unavailable. Defaults to `1` if both `pdb.minAvailable` and `pdb.maxUnavailable` are empty.                                                             | `""`                     |
| `master.autoscaling.vpa.enabled`                           | Enable VPA for KeyDB master pods                                                                                                                                                                                        | `false`                  |
| `master.autoscaling.vpa.annotations`                       | Annotations for VPA resource                                                                                                                                                                                            | `{}`                     |
| `master.autoscaling.vpa.controlledResources`               | VPA List of resources that the vertical pod autoscaler can control. Defaults to cpu and memory                                                                                                                          | `[]`                     |
| `master.autoscaling.vpa.maxAllowed`                        | VPA Max allowed resources for the pod                                                                                                                                                                                   | `{}`                     |
| `master.autoscaling.vpa.minAllowed`                        | VPA Min allowed resources for the pod                                                                                                                                                                                   | `{}`                     |
| `master.autoscaling.vpa.updatePolicy.updateMode`           | Autoscaling update policy                                                                                                                                                                                               | `Auto`                   |

### KeyDB Master Persistence Parameters

| Name                                                      | Description                                                                        | Value                 |
| --------------------------------------------------------- | ---------------------------------------------------------------------------------- | --------------------- |
| `master.persistence.enabled`                              | Enable persistence using Persistent Volume Claims                                  | `true`                |
| `master.persistence.mountPath`                            | Path to mount the data volume at on KeyDB master containers                        | `/bitnami/keydb/data` |
| `master.persistence.subPath`                              | The subdirectory of the volume to mount on KeyDB master containers                 | `""`                  |
| `master.persistence.medium`                               | Provide a medium for `emptyDir` volumes                                            | `""`                  |
| `master.persistence.sizeLimit`                            | Set this to enable a size limit for `emptyDir` volumes                             | `""`                  |
| `master.persistence.storageClass`                         | Storage class of backing PVC                                                       | `""`                  |
| `master.persistence.annotations`                          | Additional Persistent Volume Claim annotations                                     | `{}`                  |
| `master.persistence.accessModes`                          | Persistent Volume Access Modes                                                     | `["ReadWriteOnce"]`   |
| `master.persistence.size`                                 | Size of data volume                                                                | `8Gi`                 |
| `master.persistence.selector`                             | Selector to match an existing Persistent Volume for WordPress data PVC             | `{}`                  |
| `master.persistence.dataSource`                           | Custom PVC data source                                                             | `{}`                  |
| `master.persistence.existingClaim`                        | The name of an existing PVC to use for persistence (only if master.replicaCount=1) | `""`                  |
| `master.persistentVolumeClaimRetentionPolicy.enabled`     | Controls if and how PVCs are deleted during the lifecycle of a StatefulSet         | `false`               |
| `master.persistentVolumeClaimRetentionPolicy.whenScaled`  | Volume retention behavior when the replica count of the StatefulSet is reduced     | `Retain`              |
| `master.persistentVolumeClaimRetentionPolicy.whenDeleted` | Volume retention behavior that applies when the StatefulSet is deleted             | `Retain`              |

### KeyDB Master Traffic Exposure Parameters

| Name                                           | Description                                                                                                   | Value       |
| ---------------------------------------------- | ------------------------------------------------------------------------------------------------------------- | ----------- |
| `master.service.type`                          | KeyDB master service type                                                                                     | `ClusterIP` |
| `master.service.ports.keydb`                   | KeyDB master service port                                                                                     | `6379`      |
| `master.service.nodePorts.keydb`               | Node port for KeyDB master                                                                                    | `""`        |
| `master.service.clusterIP`                     | KeyDB master service Cluster IP                                                                               | `""`        |
| `master.service.loadBalancerIP`                | KeyDB master service Load Balancer IP                                                                         | `""`        |
| `master.service.loadBalancerSourceRanges`      | KeyDB master service Load Balancer sources                                                                    | `[]`        |
| `master.service.externalTrafficPolicy`         | KeyDB master service external traffic policy                                                                  | `Cluster`   |
| `master.service.annotations`                   | Additional custom annotations for KeyDB master service                                                        | `{}`        |
| `master.service.extraPorts`                    | Extra ports to expose in KeyDB master service (normally used with the `sidecars` value)                       | `[]`        |
| `master.service.sessionAffinity`               | Control where client requests go, to the same pod or round-robin                                              | `None`      |
| `master.service.sessionAffinityConfig`         | Additional settings for the sessionAffinity                                                                   | `{}`        |
| `master.service.headless.annotations`          | Annotations for the headless service.                                                                         | `{}`        |
| `master.networkPolicy.enabled`                 | Specifies whether a NetworkPolicy should be created for KeyDB master                                          | `true`      |
| `master.networkPolicy.allowExternal`           | Don't require server label for connections                                                                    | `true`      |
| `master.networkPolicy.allowExternalEgress`     | Allow the pod to access any range of port and all destinations.                                               | `true`      |
| `master.networkPolicy.addExternalClientAccess` | Allow access from pods with client label set to "true". Ignored if `networkPolicy.allowExternal` is true.     | `true`      |
| `master.networkPolicy.extraIngress`            | Add extra ingress rules to the NetworkPolicy                                                                  | `[]`        |
| `master.networkPolicy.extraEgress`             | Add extra ingress rules to the NetworkPolicy (ignored if allowExternalEgress=true)                            | `[]`        |
| `master.networkPolicy.ingressPodMatchLabels`   | Labels to match to allow traffic from other pods. Ignored if `networkPolicy.allowExternal` is true.           | `{}`        |
| `master.networkPolicy.ingressNSMatchLabels`    | Labels to match to allow traffic from other namespaces. Ignored if `networkPolicy.allowExternal` is true.     | `{}`        |
| `master.networkPolicy.ingressNSPodMatchLabels` | Pod labels to match to allow traffic from other namespaces. Ignored if `networkPolicy.allowExternal` is true. | `{}`        |

### KeyDB Replicas Configuration Parameters

| Name                                                        | Description                                                                                                                                                                                                               | Value                    |
| ----------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `replica.replicaCount`                                      | Number of KeyDB replicas to deploy                                                                                                                                                                                        | `1`                      |
| `replica.containerPorts.keydb`                              | Container port to open on KeyDB replicas nodes                                                                                                                                                                            | `6379`                   |
| `replica.extraContainerPorts`                               | Optionally specify extra list of additional ports for KeyDB replicas containers                                                                                                                                           | `[]`                     |
| `replica.livenessProbe.enabled`                             | Enable livenessProbe on KeyDB replicas containers                                                                                                                                                                         | `true`                   |
| `replica.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                                   | `20`                     |
| `replica.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                          | `5`                      |
| `replica.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                         | `5`                      |
| `replica.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                                       | `5`                      |
| `replica.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                                       | `1`                      |
| `replica.readinessProbe.enabled`                            | Enable readinessProbe on KeyDB replicas containers                                                                                                                                                                        | `true`                   |
| `replica.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                                  | `20`                     |
| `replica.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                         | `5`                      |
| `replica.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                        | `1`                      |
| `replica.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                                      | `5`                      |
| `replica.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                                      | `1`                      |
| `replica.startupProbe.enabled`                              | Enable startupProbe on KeyDB replicas containers                                                                                                                                                                          | `false`                  |
| `replica.startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                                    | `20`                     |
| `replica.startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                           | `5`                      |
| `replica.startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                          | `5`                      |
| `replica.startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                        | `5`                      |
| `replica.startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                        | `1`                      |
| `replica.customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                                                                                                                       | `{}`                     |
| `replica.customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                                                                                                                                      | `{}`                     |
| `replica.customStartupProbe`                                | Custom startupProbe that overrides the default one                                                                                                                                                                        | `{}`                     |
| `replica.resourcesPreset`                                   | Set KeyDB replicas container resources according to one common preset (allowed values: none, nano, small, medium, large, xlarge, 2xlarge). This is ignored if resources is set (resources is recommended for production). | `nano`                   |
| `replica.resources`                                         | Set KeyDB replicas container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                          | `{}`                     |
| `replica.podSecurityContext.enabled`                        | Enable KeyDB replicas pods' Security Context                                                                                                                                                                              | `true`                   |
| `replica.podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy for KeyDB replicas pods                                                                                                                                                                | `Always`                 |
| `replica.podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface for KeyDB replicas pods                                                                                                                                                    | `[]`                     |
| `replica.podSecurityContext.supplementalGroups`             | Set filesystem extra groups for KeyDB replicas pods                                                                                                                                                                       | `[]`                     |
| `replica.podSecurityContext.fsGroup`                        | Set fsGroup in KeyDB replicas pods' Security Context                                                                                                                                                                      | `1001`                   |
| `replica.containerSecurityContext.enabled`                  | Enabled KeyDB replicas container' Security Context                                                                                                                                                                        | `true`                   |
| `replica.containerSecurityContext.seLinuxOptions`           | Set SELinux options in KeyDB replicas container                                                                                                                                                                           | `{}`                     |
| `replica.containerSecurityContext.runAsUser`                | Set runAsUser in KeyDB replicas container' Security Context                                                                                                                                                               | `1001`                   |
| `replica.containerSecurityContext.runAsGroup`               | Set runAsGroup in KeyDB replicas container' Security Context                                                                                                                                                              | `1001`                   |
| `replica.containerSecurityContext.runAsNonRoot`             | Set runAsNonRoot in KeyDB replicas container' Security Context                                                                                                                                                            | `true`                   |
| `replica.containerSecurityContext.readOnlyRootFilesystem`   | Set readOnlyRootFilesystem in KeyDB replicas container' Security Context                                                                                                                                                  | `true`                   |
| `replica.containerSecurityContext.privileged`               | Set privileged in KeyDB replicas container' Security Context                                                                                                                                                              | `false`                  |
| `replica.containerSecurityContext.allowPrivilegeEscalation` | Set allowPrivilegeEscalation in KeyDB replicas container' Security Context                                                                                                                                                | `false`                  |
| `replica.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped in KeyDB replicas container                                                                                                                                                            | `["ALL"]`                |
| `replica.containerSecurityContext.seccompProfile.type`      | Set seccomp profile in KeyDB replicas container                                                                                                                                                                           | `RuntimeDefault`         |
| `replica.activeReplica`                                     | Configure replica as an active replica                                                                                                                                                                                    | `false`                  |
| `replica.configuration`                                     | Exclusive configuration for KeyDB replicas nodes (appended to common one)                                                                                                                                                 | `""`                     |
| `replica.existingConfigmap`                                 | The name of an existing ConfigMap with your custom configuration for KeyDB replicas                                                                                                                                       | `""`                     |
| `replica.disableCommands`                                   | Array with KeyDB commands to disable on master nodes                                                                                                                                                                      | `["FLUSHDB","FLUSHALL"]` |
| `replica.command`                                           | Override default KeyDB replicas container command (useful when using custom images)                                                                                                                                       | `[]`                     |
| `replica.args`                                              | Override default KeyDB replicas container args (useful when using custom images)                                                                                                                                          | `[]`                     |
| `replica.automountServiceAccountToken`                      | Mount Service Account token in KeyDB replicas pods                                                                                                                                                                        | `false`                  |
| `replica.hostAliases`                                       | KeyDB replicas pods host aliases                                                                                                                                                                                          | `[]`                     |
| `replica.statefulsetAnnotations`                            | Annotations for KeyDB replicas statefulset                                                                                                                                                                                | `{}`                     |
| `replica.podLabels`                                         | Extra labels for KeyDB replicas pods                                                                                                                                                                                      | `{}`                     |
| `replica.podAnnotations`                                    | Annotations for KeyDB replicas pods                                                                                                                                                                                       | `{}`                     |
| `replica.podAffinityPreset`                                 | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                       | `""`                     |
| `replica.podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                  | `soft`                   |
| `replica.nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                 | `""`                     |
| `replica.nodeAffinityPreset.key`                            | Node label key to match. Ignored if `affinity` is set                                                                                                                                                                     | `""`                     |
| `replica.nodeAffinityPreset.values`                         | Node label values to match. Ignored if `affinity` is set                                                                                                                                                                  | `[]`                     |
| `replica.affinity`                                          | Affinity for KeyDB replicas pods assignment                                                                                                                                                                               | `{}`                     |
| `replica.nodeSelector`                                      | Node labels for KeyDB replicas pods assignment                                                                                                                                                                            | `{}`                     |
| `replica.tolerations`                                       | Tolerations for KeyDB replicas pods assignment                                                                                                                                                                            | `[]`                     |
| `replica.updateStrategy.type`                               | KeyDB replicas strategy type                                                                                                                                                                                              | `RollingUpdate`          |
| `replica.priorityClassName`                                 | KeyDB replicas pods' priorityClassName                                                                                                                                                                                    | `""`                     |
| `replica.topologySpreadConstraints`                         | Topology Spread Constraints for KeyDB replicas pod assignment spread across your cluster among failure-domains                                                                                                            | `[]`                     |
| `replica.schedulerName`                                     | Name of the k8s scheduler (other than default) for KeyDB replicas pods                                                                                                                                                    | `""`                     |
| `replica.terminationGracePeriodSeconds`                     | Seconds KeyDB replicas pods need to terminate gracefully                                                                                                                                                                  | `""`                     |
| `replica.lifecycleHooks`                                    | for KeyDB replicas containers to automate configuration before or after startup                                                                                                                                           | `{}`                     |
| `replica.extraEnvVars`                                      | Array with extra environment variables to add to KeyDB replicas containers                                                                                                                                                | `[]`                     |
| `replica.extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for KeyDB replicas containers                                                                                                                                        | `""`                     |
| `replica.extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for KeyDB replicas containers                                                                                                                                           | `""`                     |
| `replica.extraVolumes`                                      | Optionally specify extra list of additional volumes for the KeyDB replicas pods                                                                                                                                           | `[]`                     |
| `replica.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the KeyDB replicas containers                                                                                                                                | `[]`                     |
| `replica.sidecars`                                          | Add additional sidecar containers to the KeyDB replicas pods                                                                                                                                                              | `[]`                     |
| `replica.initContainers`                                    | Add additional init containers to the KeyDB replicas pods                                                                                                                                                                 | `[]`                     |
| `replica.pdb.create`                                        | Enable/disable a Pod Disruption Budget creation for KeyDB replicas pods                                                                                                                                                   | `true`                   |
| `replica.pdb.minAvailable`                                  | Minimum number/percentage of KeyDB replicas pods that should remain scheduled                                                                                                                                             | `""`                     |
| `replica.pdb.maxUnavailable`                                | Maximum number/percentage of KeyDB replicas pods that may be made unavailable. Defaults to `1` if both `pdb.minAvailable` and `pdb.maxUnavailable` are empty.                                                             | `""`                     |
| `replica.autoscaling.vpa.enabled`                           | Enable VPA for KeyDB replicas pods                                                                                                                                                                                        | `false`                  |
| `replica.autoscaling.vpa.annotations`                       | Annotations for VPA resource                                                                                                                                                                                              | `{}`                     |
| `replica.autoscaling.vpa.controlledResources`               | VPA List of resources that the vertical pod autoscaler can control. Defaults to cpu and memory                                                                                                                            | `[]`                     |
| `replica.autoscaling.vpa.maxAllowed`                        | VPA Max allowed resources for the pod                                                                                                                                                                                     | `{}`                     |
| `replica.autoscaling.vpa.minAllowed`                        | VPA Min allowed resources for the pod                                                                                                                                                                                     | `{}`                     |
| `replica.autoscaling.vpa.updatePolicy.updateMode`           | Autoscaling update policy                                                                                                                                                                                                 | `Auto`                   |
| `replica.autoscaling.hpa.enabled`                           | Enable HPA for KeyDB Replicas pods                                                                                                                                                                                        | `false`                  |
| `replica.autoscaling.hpa.minReplicas`                       | Minimum number of replicas                                                                                                                                                                                                | `""`                     |
| `replica.autoscaling.hpa.maxReplicas`                       | Maximum number of replicas                                                                                                                                                                                                | `""`                     |
| `replica.autoscaling.hpa.targetCPU`                         | Target CPU utilization percentage                                                                                                                                                                                         | `""`                     |
| `replica.autoscaling.hpa.targetMemory`                      | Target Memory utilization percentage                                                                                                                                                                                      | `""`                     |

### KeyDB Replicas Persistence Parameters

| Name                                                       | Description                                                                         | Value                 |
| ---------------------------------------------------------- | ----------------------------------------------------------------------------------- | --------------------- |
| `replica.persistence.enabled`                              | Enable persistence using Persistent Volume Claims                                   | `true`                |
| `replica.persistence.mountPath`                            | Path to mount the data volume at on KeyDB replicas containers                       | `/bitnami/keydb/data` |
| `replica.persistence.subPath`                              | The subdirectory of the volume to mount on KeyDB replicas containers                | `""`                  |
| `replica.persistence.medium`                               | Provide a medium for `emptyDir` volumes                                             | `""`                  |
| `replica.persistence.sizeLimit`                            | Set this to enable a size limit for `emptyDir` volumes                              | `""`                  |
| `replica.persistence.storageClass`                         | Storage class of backing PVC                                                        | `""`                  |
| `replica.persistence.annotations`                          | Additional Persistent Volume Claim annotations                                      | `{}`                  |
| `replica.persistence.accessModes`                          | Persistent Volume Access Modes                                                      | `["ReadWriteOnce"]`   |
| `replica.persistence.size`                                 | Size of data volume                                                                 | `8Gi`                 |
| `replica.persistence.selector`                             | Selector to match an existing Persistent Volume for WordPress data PVC              | `{}`                  |
| `replica.persistence.dataSource`                           | Custom PVC data source                                                              | `{}`                  |
| `replica.persistence.existingClaim`                        | The name of an existing PVC to use for persistence (only if replica.replicaCount=1) | `""`                  |
| `replica.persistentVolumeClaimRetentionPolicy.enabled`     | Controls if and how PVCs are deleted during the lifecycle of a StatefulSet          | `false`               |
| `replica.persistentVolumeClaimRetentionPolicy.whenScaled`  | Volume retention behavior when the replica count of the StatefulSet is reduced      | `Retain`              |
| `replica.persistentVolumeClaimRetentionPolicy.whenDeleted` | Volume retention behavior that applies when the StatefulSet is deleted              | `Retain`              |

### KeyDB Replicas Traffic Exposure Parameters

| Name                                            | Description                                                                                                   | Value       |
| ----------------------------------------------- | ------------------------------------------------------------------------------------------------------------- | ----------- |
| `replica.service.type`                          | KeyDB replicas service type                                                                                   | `ClusterIP` |
| `replica.service.ports.keydb`                   | KeyDB replicas service port                                                                                   | `6379`      |
| `replica.service.nodePorts.keydb`               | Node port for KeyDB replicas                                                                                  | `""`        |
| `replica.service.clusterIP`                     | KeyDB replicas service Cluster IP                                                                             | `""`        |
| `replica.service.loadBalancerIP`                | KeyDB replicas service Load Balancer IP                                                                       | `""`        |
| `replica.service.loadBalancerSourceRanges`      | KeyDB replicas service Load Balancer sources                                                                  | `[]`        |
| `replica.service.externalTrafficPolicy`         | KeyDB replicas service external traffic policy                                                                | `Cluster`   |
| `replica.service.annotations`                   | Additional custom annotations for KeyDB replicas service                                                      | `{}`        |
| `replica.service.extraPorts`                    | Extra ports to expose in KeyDB replicas service (normally used with the `sidecars` value)                     | `[]`        |
| `replica.service.sessionAffinity`               | Control where client requests go, to the same pod or round-robin                                              | `None`      |
| `replica.service.sessionAffinityConfig`         | Additional settings for the sessionAffinity                                                                   | `{}`        |
| `replica.service.headless.annotations`          | Annotations for the headless service.                                                                         | `{}`        |
| `replica.networkPolicy.enabled`                 | Specifies whether a NetworkPolicy should be created for KeyDB replicas                                        | `true`      |
| `replica.networkPolicy.allowExternal`           | Don't require server label for connections                                                                    | `true`      |
| `replica.networkPolicy.allowExternalEgress`     | Allow the pod to access any range of port and all destinations.                                               | `true`      |
| `replica.networkPolicy.addExternalClientAccess` | Allow access from pods with client label set to "true". Ignored if `networkPolicy.allowExternal` is true.     | `true`      |
| `replica.networkPolicy.extraIngress`            | Add extra ingress rules to the NetworkPolicy                                                                  | `[]`        |
| `replica.networkPolicy.extraEgress`             | Add extra ingress rules to the NetworkPolicy (ignored if allowExternalEgress=true)                            | `[]`        |
| `replica.networkPolicy.ingressPodMatchLabels`   | Labels to match to allow traffic from other pods. Ignored if `networkPolicy.allowExternal` is true.           | `{}`        |
| `replica.networkPolicy.ingressNSMatchLabels`    | Labels to match to allow traffic from other namespaces. Ignored if `networkPolicy.allowExternal` is true.     | `{}`        |
| `replica.networkPolicy.ingressNSPodMatchLabels` | Pod labels to match to allow traffic from other namespaces. Ignored if `networkPolicy.allowExternal` is true. | `{}`        |

### Metrics Parameters

| Name                                                        | Description                                                                                                                                                                                                                       | Value                            |
| ----------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------- |
| `metrics.enabled`                                           | Start a sidecar Prometheus exporter to expose KeyDB metrics                                                                                                                                                                       | `false`                          |
| `metrics.image.registry`                                    | Redis Exporter image registry                                                                                                                                                                                                     | `REGISTRY_NAME`                  |
| `metrics.image.repository`                                  | Redis Exporter image repository                                                                                                                                                                                                   | `REPOSITORY_NAME/redis-exporter` |
| `metrics.image.digest`                                      | Redis Exporter image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                    | `""`                             |
| `metrics.image.pullPolicy`                                  | Redis Exporter image pull policy                                                                                                                                                                                                  | `IfNotPresent`                   |
| `metrics.image.pullSecrets`                                 | Redis Exporter image pull secrets                                                                                                                                                                                                 | `[]`                             |
| `metrics.containerPorts.http`                               | Metrics HTTP container port                                                                                                                                                                                                       | `9121`                           |
| `metrics.startupProbe.enabled`                              | Enable startupProbe on KeyDB replicas nodes                                                                                                                                                                                       | `false`                          |
| `metrics.startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                                            | `10`                             |
| `metrics.startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                                   | `10`                             |
| `metrics.startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                                  | `5`                              |
| `metrics.startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                                | `5`                              |
| `metrics.startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                                | `1`                              |
| `metrics.livenessProbe.enabled`                             | Enable livenessProbe on KeyDB replicas nodes                                                                                                                                                                                      | `true`                           |
| `metrics.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                                           | `10`                             |
| `metrics.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                                  | `10`                             |
| `metrics.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                                 | `5`                              |
| `metrics.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                                               | `5`                              |
| `metrics.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                                               | `1`                              |
| `metrics.readinessProbe.enabled`                            | Enable readinessProbe on KeyDB replicas nodes                                                                                                                                                                                     | `true`                           |
| `metrics.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                                          | `5`                              |
| `metrics.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                                 | `10`                             |
| `metrics.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                                | `1`                              |
| `metrics.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                                              | `3`                              |
| `metrics.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                                              | `1`                              |
| `metrics.customStartupProbe`                                | Custom startupProbe that overrides the default one                                                                                                                                                                                | `{}`                             |
| `metrics.customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                                                                                                                               | `{}`                             |
| `metrics.customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                                                                                                                                              | `{}`                             |
| `metrics.command`                                           | Override default metrics container init command (useful when using custom images)                                                                                                                                                 | `[]`                             |
| `metrics.keydbHost`                                         | A way to specify an alternative KeyDB hostname                                                                                                                                                                                    | `localhost`                      |
| `metrics.extraArgs`                                         | Extra arguments for KeyDB metrics exporter, for example:                                                                                                                                                                          | `{}`                             |
| `metrics.extraEnvVars`                                      | Array with extra environment variables to add to KeyDB metrics exporter                                                                                                                                                           | `[]`                             |
| `metrics.containerSecurityContext.enabled`                  | Enabled KeyDB metrics exporter containers' Security Context                                                                                                                                                                       | `true`                           |
| `metrics.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                                  | `{}`                             |
| `metrics.containerSecurityContext.runAsUser`                | Set KeyDB metrics exporter containers' Security Context runAsUser                                                                                                                                                                 | `1001`                           |
| `metrics.containerSecurityContext.runAsGroup`               | Set KeyDB metrics exporter containers' Security Context runAsGroup                                                                                                                                                                | `1001`                           |
| `metrics.containerSecurityContext.runAsNonRoot`             | Set KeyDB metrics exporter containers' Security Context runAsNonRoot                                                                                                                                                              | `true`                           |
| `metrics.containerSecurityContext.allowPrivilegeEscalation` | Set KeyDB metrics exporter containers' Security Context allowPrivilegeEscalation                                                                                                                                                  | `false`                          |
| `metrics.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context read-only root filesystem                                                                                                                                                                        | `true`                           |
| `metrics.containerSecurityContext.seccompProfile.type`      | Set KeyDB metrics exporter containers' Security Context seccompProfile                                                                                                                                                            | `RuntimeDefault`                 |
| `metrics.containerSecurityContext.capabilities.drop`        | Set KeyDB metrics exporter containers' Security Context capabilities to drop                                                                                                                                                      | `["ALL"]`                        |
| `metrics.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the KeyDB metrics sidecar                                                                                                                                            | `[]`                             |
| `metrics.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if metrics.resources is set (metrics.resources is recommended for production). | `nano`                           |
| `metrics.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                 | `{}`                             |
| `metrics.podLabels`                                         | Extra labels for KeyDB metrics exporter pods                                                                                                                                                                                      | `{}`                             |
| `metrics.podAnnotations`                                    | Annotations for KeyDB metrics exporter pods                                                                                                                                                                                       | `{}`                             |
| `metrics.service.port`                                      | Metrics service port                                                                                                                                                                                                              | `9121`                           |
| `metrics.service.annotations`                               | Annotations for the metrics service                                                                                                                                                                                               | `{}`                             |
| `metrics.serviceMonitor.enabled`                            | if `true`, creates a Prometheus Operator ServiceMonitor (also requires `metrics.enabled` to be `true`)                                                                                                                            | `false`                          |
| `metrics.serviceMonitor.namespace`                          | Namespace in which Prometheus is running                                                                                                                                                                                          | `""`                             |
| `metrics.serviceMonitor.annotations`                        | Additional custom annotations for the ServiceMonitor                                                                                                                                                                              | `{}`                             |
| `metrics.serviceMonitor.labels`                             | Extra labels for the ServiceMonitor                                                                                                                                                                                               | `{}`                             |
| `metrics.serviceMonitor.jobLabel`                           | The name of the label on the target service to use as the job name in Prometheus                                                                                                                                                  | `""`                             |
| `metrics.serviceMonitor.honorLabels`                        | honorLabels chooses the metric's labels on collisions with target labels                                                                                                                                                          | `false`                          |
| `metrics.serviceMonitor.interval`                           | Interval at which metrics should be scraped.                                                                                                                                                                                      | `""`                             |
| `metrics.serviceMonitor.scrapeTimeout`                      | Timeout after which the scrape is ended                                                                                                                                                                                           | `""`                             |
| `metrics.serviceMonitor.metricRelabelings`                  | Specify additional relabeling of metrics                                                                                                                                                                                          | `[]`                             |
| `metrics.serviceMonitor.relabelings`                        | Specify general relabeling                                                                                                                                                                                                        | `[]`                             |
| `metrics.serviceMonitor.selector`                           | Prometheus instance selector labels                                                                                                                                                                                               | `{}`                             |
| `metrics.prometheusRule.enabled`                            | Create a custom prometheusRule Resource for scraping metrics using PrometheusOperator                                                                                                                                             | `false`                          |
| `metrics.prometheusRule.namespace`                          | The namespace in which the prometheusRule will be created                                                                                                                                                                         | `""`                             |
| `metrics.prometheusRule.annotations`                        | Additional custom annotations for the prometheusRule                                                                                                                                                                              | `{}`                             |
| `metrics.prometheusRule.labels`                             | Extra labels for the prometheusRule                                                                                                                                                                                               | `{}`                             |
| `metrics.prometheusRule.rules`                              | Custom Prometheus rules                                                                                                                                                                                                           | `[]`                             |

### Other Parameters

| Name                                          | Description                                                                  | Value  |
| --------------------------------------------- | ---------------------------------------------------------------------------- | ------ |
| `serviceAccount.create`                       | Specifies whether a ServiceAccount should be created for KeyDB replicas pods | `true` |
| `serviceAccount.name`                         | The name of the ServiceAccount to use                                        | `""`   |
| `serviceAccount.annotations`                  | Additional Service Account annotations (evaluated as a template)             | `{}`   |
| `serviceAccount.automountServiceAccountToken` | Automount service account token for the server service account               | `true` |

### Init Container Parameters

| Name                                                        | Description                                                                                                                                                                                                                                         | Value                      |
| ----------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------- |
| `volumePermissions.enabled`                                 | Enable init container that changes the owner/group of the PV mount point to `runAsUser:fsGroup`                                                                                                                                                     | `false`                    |
| `volumePermissions.image.registry`                          | OS Shell + Utility image registry                                                                                                                                                                                                                   | `REGISTRY_NAME`            |
| `volumePermissions.image.repository`                        | OS Shell + Utility image repository                                                                                                                                                                                                                 | `REPOSITORY_NAME/os-shell` |
| `volumePermissions.image.pullPolicy`                        | OS Shell + Utility image pull policy                                                                                                                                                                                                                | `IfNotPresent`             |
| `volumePermissions.image.pullSecrets`                       | OS Shell + Utility image pull secrets                                                                                                                                                                                                               | `[]`                       |
| `volumePermissions.resourcesPreset`                         | Set init container resources according to one common preset (allowed values: none, nano, small, medium, large, xlarge, 2xlarge). This is ignored if volumePermissions.resources is set (volumePermissions.resources is recommended for production). | `nano`                     |
| `volumePermissions.resources`                               | Set init container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                              | `{}`                       |
| `volumePermissions.containerSecurityContext.enabled`        | Enabled init container' Security Context                                                                                                                                                                                                            | `true`                     |
| `volumePermissions.containerSecurityContext.seLinuxOptions` | Set SELinux options in init container                                                                                                                                                                                                               | `{}`                       |
| `volumePermissions.containerSecurityContext.runAsUser`      | Set init container's Security Context runAsUser                                                                                                                                                                                                     | `0`                        |

The above parameters map to the env variables defined in [bitnami/keydb](https://github.com/bitnami/containers/tree/main/bitnami/keydb). For more information please refer to the [bitnami/keydb](https://github.com/bitnami/containers/tree/main/bitnami/keydb) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
    --set auth.enabled=true \
    --set auth.password=secretpassword \
    oci://REGISTRY_NAME/REPOSITORY_NAME/keydb
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The above command sets the KeyDB server password to `secretpassword`.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml oci://REGISTRY_NAME/REPOSITORY_NAME/keydb
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.
> **Tip**: You can use the default [values.yaml](https://github.com/bitnami/charts/tree/main/bitnami/keydb/values.yaml)

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

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