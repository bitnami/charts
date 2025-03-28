<!--- app-name: ScyllaDB -->

# Bitnami package for ScyllaDB

ScyllaDB is an open-source, distributed NoSQL wide-column data store. Written in C++, it is designed for high throughput and low latency, compatible with Apache Cassandra.

[Overview of ScyllaDB](https://www.scylladb.com/)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/scylladb
```

Looking to use ScyllaDB in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the commercial edition of the Bitnami catalog.

## Introduction

This chart bootstraps an [ScyllaDB](https://github.com/bitnami/containers/tree/main/bitnami/scylladb) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/scylladb
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

These commands deploy one node with ScyllaDB on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Configuration and installation details

### Resource requests and limits

Bitnami charts allow setting resource requests and limits for all containers inside the chart deployment. These are inside the `resources` value (check parameter table). Setting requests is essential for production workloads and these should be adapted to your specific use case.

To make this process easier, the chart contains the `resourcesPreset` values, which automatically sets the `resources` section according to different presets. Check these presets in [the bitnami/common chart](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15). However, in production workloads using `resourcesPreset` is discouraged as it may not fully adapt to your specific needs. Find more information on container resource management in the [official Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).

### Update credentials

Bitnami charts configure credentials at first boot. Any further change in the secrets or credentials require manual intervention. Follow these instructions:

- Update the user password following [the upstream documentation](https://docs.scylladb.com)
- Update the password secret with the new values (replace the SECRET_NAME and PASSWORD placeholders)

```shell
kubectl create secret generic SECRET_NAME --from-literal=scylladb-password=PASSWORD --dry-run -o yaml | kubectl apply -f -
```

### Prometheus metrics

This chart can be integrated with Prometheus by setting `metrics.enabled` to `true`. This will expose ScyllaDB native Prometheus in all pods and via the ScyllaDB service. This service will have the necessary annotations to be automatically scraped by Prometheus.

#### Prometheus requirements

It is necessary to have a working installation of Prometheus or Prometheus Operator for the integration to work. Install the [Bitnami Prometheus helm chart](https://github.com/bitnami/charts/tree/main/bitnami/prometheus) or the [Bitnami Kube Prometheus helm chart](https://github.com/bitnami/charts/tree/main/bitnami/kube-prometheus) to easily have a working Prometheus in your cluster.

#### Integration with Prometheus Operator

The chart can deploy `ServiceMonitor` objects for integration with Prometheus Operator installations. To do so, set the value `metrics.serviceMonitor.enabled=true`. Ensure that the Prometheus Operator `CustomResourceDefinitions` are installed in the cluster or it will fail with the following error:

```text
no matches for kind "ServiceMonitor" in version "monitoring.coreos.com/v1"
```

Install the [Bitnami Kube Prometheus helm chart](https://github.com/bitnami/charts/tree/main/bitnami/kube-prometheus) for having the necessary CRDs and the Prometheus Operator.

### [Rolling vs Immutable tags](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Securing Traffic using TLS

This chart supports TLS between client and server and between nodes, as explained below:

- For internode cluster encryption, set the `tls.internodeEncryption` chart parameter to a value different from `none`. Available values are `all`, `dc` or `rack`.
- For client-server encryption, set the `tls.clientEncryption` chart parameter to `true`.

In both cases, it is also necessary to create a secret containing the certificate. This secret is to be passed to the chart via the `tls.existingSecret` parameter at deployment-time, as shown below:

```text
tls.internodeEncryption=all
tls.clientEncryption=true
tls.existingSecret=my-exisiting-stores
```

You can manually create the required TLS certificates or relying on the chart auto-generation capabilities. The chart supports two different ways to auto-generate the required certificates:

- Using Helm capabilities. Enable this feature by setting `tls.autoGenerated.enabled` to `true` and `tls.autoGenerated.engine` to `helm`.
- Relying on CertManager (please note it's required to have CertManager installed in your K8s cluster). Enable this feature by setting `tls.autoGenerated.enabled` to `true` and `tls.autoGenerated.engine` to `cert-manager`. Please note it's supported to use an existing Issuer/ClusterIssuer for issuing the TLS certificates by setting the `tls.autoGenerated.certManager.existingIssuer` and `tls.autoGenerated.certManager.existingIssuerKind` parameters.

### Initialize the database

The [ScyllaDB](https://github.com/bitnami/containers/tree/main/bitnami/scylladb) image supports the use of custom scripts to initialize a fresh instance. This may be done by creating a Kubernetes ConfigMap that includes the necessary `.sh` or `.cql` scripts and passing this ConfigMap to the chart via the `initDBConfigMap` parameter.

### Use a custom configuration file

This chart also supports mounting custom configuration file(s) for ScyllaDB. This is achieved by setting the `existingConfiguration` parameter with the name of a ConfigMap that includes the custom configuration file(s). Here is an example of deploying the chart with a custom configuration file stored in a ConfigMap named `scylladb-configuration`:

```text
existingConfiguration=scylladb-configuration
```

> NOTE: This ConfigMap will override other ScyllaDB configuration variables set in the chart.

### Set pod affinity

This chart allows you to set custom pod affinity using the `XXX.affinity` parameter(s). Find more information about pod affinity in the [Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities) chart. To do so, set the `XXX.podAffinityPreset`, `XXX.podAntiAffinityPreset`, or `XXX.nodeAffinityPreset` parameters.

### Backup and restore

To back up and restore Helm chart deployments on Kubernetes, you need to back up the persistent volumes from the source deployment and attach them to a new deployment using [Velero](https://velero.io/), a Kubernetes backup/restore tool. Find the instructions for using Velero in [this guide](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-backup-restore-deployments-velero-index.html).

## Persistence

The [Bitnami ScyllaDB](https://github.com/bitnami/containers/tree/main/bitnami/scylladb) image stores the ScyllaDB data at the `/bitnami/scylladb` path of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Parameters](#parameters) section to configure the PVC or to disable persistence.

If you encounter errors when working with persistent volumes, refer to our [troubleshooting guide for persistent volumes](https://docs.bitnami.com/kubernetes/faq/troubleshooting/troubleshooting-persistence-volumes/).

### Adjust permissions of persistent volume mountpoint

As the image run as non-root by default, it is necessary to adjust the ownership of the persistent volume so that the container can write data into it. There are two approaches to achieve this:

- Use Kubernetes SecurityContexts by setting the `podSecurityContext.enabled` and `containerSecurityContext.enabled` to `true`. This option is enabled by default in the chart. However, this feature does not work in all Kubernetes distributions.
- Use an init container to change the ownership of the volume before mounting it in the final destination. Enable this container by setting the `volumePermissions.enabled` parameter to `true`.

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

| Name                     | Description                                                                             | Value           |
| ------------------------ | --------------------------------------------------------------------------------------- | --------------- |
| `apiVersions`            | Override Kubernetes API versions reported by .Capabilities                              | `[]`            |
| `nameOverride`           | String to partially override common.names.fullname                                      | `""`            |
| `fullnameOverride`       | String to fully override common.names.fullname                                          | `""`            |
| `kubeVersion`            | Force target Kubernetes version (using Helm capabilities if not set)                    | `""`            |
| `commonLabels`           | Labels to add to all deployed objects (sub-charts are not considered)                   | `{}`            |
| `commonAnnotations`      | Annotations to add to all deployed objects                                              | `{}`            |
| `clusterDomain`          | Kubernetes cluster domain name                                                          | `cluster.local` |
| `extraDeploy`            | Array of extra objects to deploy with the release                                       | `[]`            |
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden) | `false`         |
| `diagnosticMode.command` | Command to override all containers in the deployment                                    | `["sleep"]`     |
| `diagnosticMode.args`    | Args to override all containers in the deployment                                       | `["infinity"]`  |

### Scylladb parameters

| Name                     | Description                                                                                                            | Value                      |
| ------------------------ | ---------------------------------------------------------------------------------------------------------------------- | -------------------------- |
| `image.registry`         | Scylladb image registry                                                                                                | `REGISTRY_NAME`            |
| `image.repository`       | Scylladb image repository                                                                                              | `REPOSITORY_NAME/scylladb` |
| `image.digest`           | Scylladb image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag               | `""`                       |
| `image.pullPolicy`       | image pull policy                                                                                                      | `IfNotPresent`             |
| `image.pullSecrets`      | Scylladb image pull secrets                                                                                            | `[]`                       |
| `image.debug`            | Enable image debug mode                                                                                                | `false`                    |
| `dbUser.user`            | Scylladb admin user                                                                                                    | `cassandra`                |
| `dbUser.forcePassword`   | Force the user to provide a non                                                                                        | `false`                    |
| `dbUser.password`        | Password for `dbUser.user`. Randomly generated if empty                                                                | `""`                       |
| `dbUser.existingSecret`  | Use an existing secret object for `dbUser.user` password (will ignore `dbUser.password`)                               | `""`                       |
| `initDBConfigMap`        | ConfigMap with cql scripts. Useful for creating a keyspace and pre-populating data                                     | `""`                       |
| `initDBSecret`           | Secret with cql script (with sensitive data). Useful for creating a keyspace and pre-populating data                   | `""`                       |
| `existingConfiguration`  | ConfigMap with custom scylla.yaml configuration file. This overrides any other Scylladb configuration set in the chart | `""`                       |
| `cluster.name`           | Scylladb cluster name                                                                                                  | `scylladb`                 |
| `cluster.seedCount`      | Number of seed nodes                                                                                                   | `1`                        |
| `cluster.numTokens`      | Number of tokens for each node                                                                                         | `256`                      |
| `cluster.datacenter`     | Datacenter name                                                                                                        | `dc1`                      |
| `cluster.rack`           | Rack name                                                                                                              | `rack1`                    |
| `cluster.endpointSnitch` | Endpoint Snitch                                                                                                        | `SimpleSnitch`             |
| `cluster.extraSeeds`     | For an external/second scylladb ring.                                                                                  | `[]`                       |
| `cluster.enableUDF`      | Enable User defined functions                                                                                          | `false`                    |
| `jvm.extraOpts`          | Set the value for Java Virtual Machine extra options                                                                   | `""`                       |
| `jvm.maxHeapSize`        | Set Java Virtual Machine maximum heap size (MAX_HEAP_SIZE). Calculated automatically if `nil`                          | `""`                       |
| `jvm.newHeapSize`        | Set Java Virtual Machine new heap size (HEAP_NEWSIZE). Calculated automatically if `nil`                               | `""`                       |
| `command`                | Command for running the container (set to default if not set). Use array form                                          | `[]`                       |
| `args`                   | Args for running the container (set to default if not set). Use array form                                             | `[]`                       |
| `extraEnvVars`           | Extra environment variables to be set on scylladb container                                                            | `[]`                       |
| `extraEnvVarsCM`         | Name of existing ConfigMap containing extra env vars                                                                   | `""`                       |
| `extraEnvVarsSecret`     | Name of existing Secret containing extra env vars                                                                      | `""`                       |

### Statefulset parameters

| Name                                                | Description                                                                                                                                                                                                       | Value            |
| --------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| `replicaCount`                                      | Number of Scylladb replicas                                                                                                                                                                                       | `1`              |
| `updateStrategy.type`                               | updateStrategy for Scylladb statefulset                                                                                                                                                                           | `RollingUpdate`  |
| `nameResolutionThreshold`                           | Failure threshold for internal hostnames resolution                                                                                                                                                               | `5`              |
| `nameResolutionTimeout`                             | Timeout seconds between probes for internal hostnames resolution                                                                                                                                                  | `5`              |
| `automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                | `false`          |
| `hostAliases`                                       | Add deployment host aliases                                                                                                                                                                                       | `[]`             |
| `podManagementPolicy`                               | StatefulSet pod management policy                                                                                                                                                                                 | `OrderedReady`   |
| `priorityClassName`                                 | Scylladb pods' priority.                                                                                                                                                                                          | `""`             |
| `podAnnotations`                                    | Additional pod annotations                                                                                                                                                                                        | `{}`             |
| `statefulsetLabels`                                 | Labels for statefulset                                                                                                                                                                                            | `{}`             |
| `statefulsetAnnotations`                            | Annotations for statefulset                                                                                                                                                                                       | `{}`             |
| `podLabels`                                         | Additional pod labels                                                                                                                                                                                             | `{}`             |
| `podAffinityPreset`                                 | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                               | `""`             |
| `podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                          | `soft`           |
| `nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                         | `""`             |
| `nodeAffinityPreset.key`                            | Node label key to match. Ignored if `affinity` is set                                                                                                                                                             | `""`             |
| `nodeAffinityPreset.values`                         | Node label values to match. Ignored if `affinity` is set                                                                                                                                                          | `[]`             |
| `affinity`                                          | Affinity for pod assignment                                                                                                                                                                                       | `{}`             |
| `nodeSelector`                                      | Node labels for pod assignment                                                                                                                                                                                    | `{}`             |
| `tolerations`                                       | Tolerations for pod assignment                                                                                                                                                                                    | `[]`             |
| `topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment                                                                                                                                                                    | `[]`             |
| `podSecurityContext.enabled`                        | Enabled Scylladb pods' Security Context                                                                                                                                                                           | `true`           |
| `podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                | `Always`         |
| `podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                    | `[]`             |
| `podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                       | `[]`             |
| `podSecurityContext.fsGroup`                        | Set Scylladb pod's Security Context fsGroup                                                                                                                                                                       | `1001`           |
| `containerSecurityContext.enabled`                  | Enabled Scylladb containers' Security Context                                                                                                                                                                     | `true`           |
| `containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                  | `{}`             |
| `containerSecurityContext.runAsUser`                | Set Scylladb containers' Security Context runAsUser                                                                                                                                                               | `1001`           |
| `containerSecurityContext.runAsGroup`               | Set Scylladb containers' Security Context runAsGroup                                                                                                                                                              | `1001`           |
| `containerSecurityContext.allowPrivilegeEscalation` | Set Scylladb containers' Security Context allowPrivilegeEscalation                                                                                                                                                | `false`          |
| `containerSecurityContext.capabilities.drop`        | Set Scylladb containers' Security Context capabilities to be dropped                                                                                                                                              | `["ALL"]`        |
| `containerSecurityContext.readOnlyRootFilesystem`   | Set Scylladb containers' Security Context readOnlyRootFilesystem                                                                                                                                                  | `true`           |
| `containerSecurityContext.runAsNonRoot`             | Set Scylladb containers' Security Context runAsNonRoot                                                                                                                                                            | `true`           |
| `containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                                                                                                                       | `false`          |
| `containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                  | `RuntimeDefault` |
| `resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if resources is set (resources is recommended for production). | `large`          |
| `resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                 | `{}`             |
| `livenessProbe.enabled`                             | Enable livenessProbe                                                                                                                                                                                              | `true`           |
| `livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                           | `100`            |
| `livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                  | `30`             |
| `livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                 | `30`             |
| `livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                               | `5`              |
| `livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                               | `1`              |
| `readinessProbe.enabled`                            | Enable readinessProbe                                                                                                                                                                                             | `true`           |
| `readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                          | `60`             |
| `readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                 | `10`             |
| `readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                | `30`             |
| `readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                              | `5`              |
| `readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                              | `1`              |
| `startupProbe.enabled`                              | Enable startupProbe                                                                                                                                                                                               | `false`          |
| `startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                            | `0`              |
| `startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                   | `10`             |
| `startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                  | `5`              |
| `startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                | `60`             |
| `startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                | `1`              |
| `customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                                                                                                               | `{}`             |
| `customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                                                                                                                              | `{}`             |
| `customStartupProbe`                                | Override default startup probe                                                                                                                                                                                    | `{}`             |
| `lifecycleHooks`                                    | Override default container hooks                                                                                                                                                                                  | `{}`             |
| `schedulerName`                                     | Alternative scheduler                                                                                                                                                                                             | `""`             |
| `terminationGracePeriodSeconds`                     | In seconds, time the given to the Scylladb pod needs to terminate gracefully                                                                                                                                      | `""`             |
| `extraVolumes`                                      | Optionally specify extra list of additional volumes for scylladb container                                                                                                                                        | `[]`             |
| `extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for scylladb container                                                                                                                                   | `[]`             |
| `initContainers`                                    | Add additional init containers to the scylladb pods                                                                                                                                                               | `[]`             |
| `sidecars`                                          | Add additional sidecar containers to the scylladb pods                                                                                                                                                            | `[]`             |
| `pdb.create`                                        | Enable/disable a Pod Disruption Budget creation                                                                                                                                                                   | `true`           |
| `pdb.minAvailable`                                  | Mininimum number of pods that must still be available after the eviction                                                                                                                                          | `""`             |
| `pdb.maxUnavailable`                                | Max number of pods that can be unavailable after the eviction                                                                                                                                                     | `""`             |
| `hostNetwork`                                       | Enable HOST Network                                                                                                                                                                                               | `false`          |
| `containerPorts.intra`                              | Intra Port on the Host and Container                                                                                                                                                                              | `7000`           |
| `containerPorts.tls`                                | TLS Port on the Host and Container                                                                                                                                                                                | `7001`           |
| `containerPorts.jmx`                                | JMX Port on the Host and Container                                                                                                                                                                                | `7199`           |
| `containerPorts.cql`                                | CQL Port on the Host and Container                                                                                                                                                                                | `9042`           |
| `containerPorts.cqlShard`                           | CQL Port (Shard) on the Host and Container                                                                                                                                                                        | `19042`          |
| `containerPorts.api`                                | REST API port on the Host and Container                                                                                                                                                                           | `10000`          |
| `containerPorts.metrics`                            | Metrics port on the Host and Container                                                                                                                                                                            | `9180`           |
| `extraContainerPorts`                               | Optionally specify extra list of additional ports for the container                                                                                                                                               | `[]`             |
| `hostPorts.intra`                                   | Intra Port on the Host                                                                                                                                                                                            | `""`             |
| `hostPorts.tls`                                     | TLS Port on the Host                                                                                                                                                                                              | `""`             |
| `hostPorts.jmx`                                     | JMX Port on the Host                                                                                                                                                                                              | `""`             |
| `hostPorts.cql`                                     | CQL Port on the Host                                                                                                                                                                                              | `""`             |
| `hostPorts.cqlShard`                                | CQL (Sharded) Port on the Host                                                                                                                                                                                    | `""`             |
| `hostPorts.api`                                     | REST API Port on the Host                                                                                                                                                                                         | `""`             |
| `hostPorts.metrics`                                 | Metrics Port on the Host                                                                                                                                                                                          | `""`             |

### JMX Proxy Deployment Parameters

| Name                                                         | Description                                                                                                                                                                                                                         | Value            |
| ------------------------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| `jmxProxy.enabled`                                           | Enable JMX Proxy sidecar                                                                                                                                                                                                            | `false`          |
| `jmxProxy.extraEnvVars`                                      | Array with extra environment variables to add to JMX Proxy sidecar                                                                                                                                                                  | `[]`             |
| `jmxProxy.extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for JMX Proxy sidecar                                                                                                                                                          | `""`             |
| `jmxProxy.extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for JMX Proxy sidecar                                                                                                                                                             | `""`             |
| `jmxProxy.command`                                           | Override default container command (useful when using custom images)                                                                                                                                                                | `[]`             |
| `jmxProxy.args`                                              | Override default container args (useful when using custom images)                                                                                                                                                                   | `[]`             |
| `jmxProxy.livenessProbe.enabled`                             | Enable livenessProbe on JMX Proxy sidecar                                                                                                                                                                                           | `true`           |
| `jmxProxy.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                                             | `5`              |
| `jmxProxy.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                                    | `10`             |
| `jmxProxy.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                                   | `5`              |
| `jmxProxy.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                                                 | `5`              |
| `jmxProxy.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                                                 | `1`              |
| `jmxProxy.readinessProbe.enabled`                            | Enable readinessProbe on JMX Proxy sidecar                                                                                                                                                                                          | `true`           |
| `jmxProxy.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                                            | `5`              |
| `jmxProxy.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                                   | `20`             |
| `jmxProxy.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                                  | `30`             |
| `jmxProxy.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                                                | `5`              |
| `jmxProxy.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                                                | `1`              |
| `jmxProxy.startupProbe.enabled`                              | Enable startupProbe on JMX Proxy containers                                                                                                                                                                                         | `false`          |
| `jmxProxy.startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                                              | `5`              |
| `jmxProxy.startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                                     | `10`             |
| `jmxProxy.startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                                    | `5`              |
| `jmxProxy.startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                                  | `5`              |
| `jmxProxy.startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                                  | `1`              |
| `jmxProxy.customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                                                                                                                                 | `{}`             |
| `jmxProxy.customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                                                                                                                                                | `{}`             |
| `jmxProxy.customStartupProbe`                                | Custom startupProbe that overrides the default one                                                                                                                                                                                  | `{}`             |
| `jmxProxy.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if jmxProxy.resources is set (jmxProxy.resources is recommended for production). | `micro`          |
| `jmxProxy.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                   | `{}`             |
| `jmxProxy.containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                                                                                                                                                | `true`           |
| `jmxProxy.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                                    | `{}`             |
| `jmxProxy.containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                                                                                                                          | `1001`           |
| `jmxProxy.containerSecurityContext.runAsGroup`               | Set containers' Security Context runAsGroup                                                                                                                                                                                         | `1001`           |
| `jmxProxy.containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                                                                                                                                       | `true`           |
| `jmxProxy.containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                                                                                                                                         | `false`          |
| `jmxProxy.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                                             | `true`           |
| `jmxProxy.containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                                                                                                                           | `false`          |
| `jmxProxy.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                                  | `["ALL"]`        |
| `jmxProxy.containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                                    | `RuntimeDefault` |
| `jmxProxy.lifecycleHooks`                                    | for the JMX Proxy container(s) to automate configuration before or after startup                                                                                                                                                    | `{}`             |
| `jmxProxy.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the JMX Proxy container(s)                                                                                                                                             | `[]`             |
| `jmxProxy.extraContainerPorts`                               | Optionally specify extra list of additional ports for the container                                                                                                                                                                 | `[]`             |

### Autoscaling

| Name                                  | Description                                                                                    | Value   |
| ------------------------------------- | ---------------------------------------------------------------------------------------------- | ------- |
| `autoscaling.vpa.enabled`             | Enable VPA                                                                                     | `false` |
| `autoscaling.vpa.annotations`         | Annotations for VPA resource                                                                   | `{}`    |
| `autoscaling.vpa.controlledResources` | VPA List of resources that the vertical pod autoscaler can control. Defaults to cpu and memory | `[]`    |
| `autoscaling.vpa.maxAllowed`          | VPA Max allowed resources for the pod                                                          | `{}`    |
| `autoscaling.vpa.minAllowed`          | VPA Min allowed resources for the pod                                                          | `{}`    |

### VPA update policy

| Name                                                | Description                                                                                                                                                            | Value   |
| --------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `autoscaling.vpa.updatePolicy.updateMode`           | Autoscaling update policy Specifies whether recommended updates are applied when a Pod is started and whether recommended updates are applied during the life of a Pod | `Auto`  |
| `autoscaling.hpa.annotations`                       | Annotations for HPA resource                                                                                                                                           | `{}`    |
| `autoscaling.hpa.enabled`                           | Enable HPA                                                                                                                                                             | `false` |
| `autoscaling.hpa.minReplicas`                       | Min replicas                                                                                                                                                           | `1`     |
| `autoscaling.hpa.maxReplicas`                       | Max replicas                                                                                                                                                           | `3`     |
| `autoscaling.hpa.targetCPUUtilizationPercentage`    | Target CPU utilization percentage                                                                                                                                      | `75`    |
| `autoscaling.hpa.targetMemoryUtilizationPercentage` | Target Memory utilization percentage                                                                                                                                   | `""`    |
| `autoscaling.hpa.customRules`                       | Custom rules                                                                                                                                                           | `[]`    |
| `autoscaling.hpa.behavior`                          | HPA Behavior                                                                                                                                                           | `{}`    |

### RBAC parameters

| Name                                          | Description                                               | Value   |
| --------------------------------------------- | --------------------------------------------------------- | ------- |
| `serviceAccount.create`                       | Enable the creation of a ServiceAccount for Scylladb pods | `true`  |
| `serviceAccount.name`                         | The name of the ServiceAccount to use.                    | `""`    |
| `serviceAccount.annotations`                  | Annotations for Scylladb Service Account                  | `{}`    |
| `serviceAccount.automountServiceAccountToken` | Automount API credentials for a service account.          | `false` |

### Traffic Exposure Parameters

| Name                                    | Description                                                                                        | Value       |
| --------------------------------------- | -------------------------------------------------------------------------------------------------- | ----------- |
| `service.type`                          | Scylladb service type                                                                              | `ClusterIP` |
| `service.ports.cql`                     | Scylladb service CQL Port                                                                          | `9042`      |
| `service.ports.cqlShard`                | Scylladb service CQL Port (sharded)                                                                | `19042`     |
| `service.ports.metrics`                 | Scylladb service metrics port                                                                      | `8080`      |
| `service.nodePorts.cql`                 | Node port for CQL                                                                                  | `""`        |
| `service.nodePorts.cqlShard`            | Node port for CQL (sharded)                                                                        | `""`        |
| `service.nodePorts.metrics`             | Node port for metrics                                                                              | `""`        |
| `service.extraPorts`                    | Extra ports to expose in the service (normally used with the `sidecar` value)                      | `[]`        |
| `service.loadBalancerIP`                | LoadBalancerIP if service type is `LoadBalancer`                                                   | `""`        |
| `service.loadBalancerSourceRanges`      | Service Load Balancer sources                                                                      | `[]`        |
| `service.clusterIP`                     | Service Cluster IP                                                                                 | `""`        |
| `service.externalTrafficPolicy`         | Service external traffic policy                                                                    | `Cluster`   |
| `service.annotations`                   | Provide any additional annotations which may be required.                                          | `{}`        |
| `service.sessionAffinity`               | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                               | `None`      |
| `service.sessionAffinityConfig`         | Additional settings for the sessionAffinity                                                        | `{}`        |
| `service.headless.annotations`          | Annotations for the headless service.                                                              | `{}`        |
| `service.internal.enabled`              | Create a service per pod (this improves the cluster stability when scaling or performing upgrades) | `true`      |
| `service.internal.labels`               | Labels for the internal services.                                                                  | `{}`        |
| `service.internal.annotations`          | Annotations for the internal services.                                                             | `{}`        |
| `service.internal.extraPorts`           | Extra ports to expose in the service (normally used with the `sidecar` value)                      | `[]`        |
| `networkPolicy.enabled`                 | Specifies whether a NetworkPolicy should be created                                                | `true`      |
| `networkPolicy.allowExternal`           | Don't require server label for connections                                                         | `true`      |
| `networkPolicy.allowExternalEgress`     | Allow the pod to access any range of port and all destinations.                                    | `true`      |
| `networkPolicy.extraIngress`            | Add extra ingress rules to the NetworkPolicy                                                       | `[]`        |
| `networkPolicy.extraEgress`             | Add extra ingress rules to the NetworkPolicy (ignored if allowExternalEgress=true)                 | `[]`        |
| `networkPolicy.ingressNSMatchLabels`    | Labels to match to allow traffic from other namespaces                                             | `{}`        |
| `networkPolicy.ingressNSPodMatchLabels` | Pod labels to match to allow traffic from other namespaces                                         | `{}`        |

### Persistence parameters

| Name                                 | Description                                                                                                                                         | Value               |
| ------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------- |
| `persistence.enabled`                | Enable Scylladb data persistence using PVC, use a Persistent Volume Claim, If false, use emptyDir                                                   | `true`              |
| `persistence.existingClaim`          | Name of an existing PVC to use                                                                                                                      | `""`                |
| `persistence.storageClass`           | PVC Storage Class for Scylladb data volume                                                                                                          | `""`                |
| `persistence.commitStorageClass`     | PVC Storage Class for Scylladb Commit Log volume                                                                                                    | `""`                |
| `persistence.annotations`            | Persistent Volume Claim annotations                                                                                                                 | `{}`                |
| `persistence.accessModes`            | Persistent Volume Access Mode                                                                                                                       | `["ReadWriteOnce"]` |
| `persistence.mountPath`              | The path the data volume will be mounted at                                                                                                         | `/bitnami/scylladb` |
| `persistence.size`                   | PVC Storage Request for Scylladb data volume                                                                                                        | `8Gi`               |
| `persistence.commitLog.storageClass` | PVC Storage Class for Scylladb Commit Log volume                                                                                                    | `""`                |
| `persistence.commitLog.annotations`  | Persistent Volume Claim annotations                                                                                                                 | `{}`                |
| `persistence.commitLog.accessModes`  | Persistent Volume Access Mode                                                                                                                       | `["ReadWriteOnce"]` |
| `persistence.commitLog.size`         | PVC Storage Request for Scylladb data volume                                                                                                        | `2Gi`               |
| `persistence.commitLog.mountPath`    | The path the commit log volume will be mounted at. Unset by default. Set it to '/bitnami/scylladb/commitlog' to enable a separate commit log volume | `""`                |

### Volume Permissions parameters

| Name                                               | Description                                                                                                                                                                                                                                           | Value                      |
| -------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------- |
| `volumePermissions.enabled`                        | Enable init container that changes the owner and group of the persistent volume                                                                                                                                                                       | `false`                    |
| `volumePermissions.image.registry`                 | Init container volume image registry                                                                                                                                                                                                                  | `REGISTRY_NAME`            |
| `volumePermissions.image.repository`               | Init container volume image repository                                                                                                                                                                                                                | `REPOSITORY_NAME/os-shell` |
| `volumePermissions.image.digest`                   | Init container volume image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                                 | `""`                       |
| `volumePermissions.image.pullPolicy`               | Init container volume pull policy                                                                                                                                                                                                                     | `IfNotPresent`             |
| `volumePermissions.image.pullSecrets`              | Specify docker-registry secret names as an array                                                                                                                                                                                                      | `[]`                       |
| `volumePermissions.resourcesPreset`                | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if volumePermissions.resources is set (volumePermissions.resources is recommended for production). | `nano`                     |
| `volumePermissions.resources`                      | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                                     | `{}`                       |
| `volumePermissions.securityContext.seLinuxOptions` | Set SELinux options in container                                                                                                                                                                                                                      | `{}`                       |
| `volumePermissions.securityContext.runAsUser`      | User ID for the init container                                                                                                                                                                                                                        | `0`                        |

### Metrics parameters

| Name                                       | Description                                                                                            | Value        |
| ------------------------------------------ | ------------------------------------------------------------------------------------------------------ | ------------ |
| `metrics.enabled`                          | Start a side-car prometheus exporter                                                                   | `false`      |
| `metrics.podAnnotations`                   | Metrics exporter pod Annotation and Labels                                                             | `{}`         |
| `metrics.serviceMonitor.enabled`           | If `true`, creates a Prometheus Operator ServiceMonitor (also requires `metrics.enabled` to be `true`) | `false`      |
| `metrics.serviceMonitor.namespace`         | Namespace in which Prometheus is running                                                               | `monitoring` |
| `metrics.serviceMonitor.interval`          | Interval at which metrics should be scraped.                                                           | `""`         |
| `metrics.serviceMonitor.scrapeTimeout`     | Timeout after which the scrape is ended                                                                | `""`         |
| `metrics.serviceMonitor.selector`          | Prometheus instance selector labels                                                                    | `{}`         |
| `metrics.serviceMonitor.metricRelabelings` | Specify Metric Relabelings to add to the scrape endpoint                                               | `[]`         |
| `metrics.serviceMonitor.relabelings`       | RelabelConfigs to apply to samples before scraping                                                     | `[]`         |
| `metrics.serviceMonitor.honorLabels`       | Specify honorLabels parameter to add the scrape endpoint                                               | `false`      |
| `metrics.serviceMonitor.jobLabel`          | The name of the label on the target service to use as the job name in prometheus.                      | `""`         |
| `metrics.serviceMonitor.labels`            | Used to pass Labels that are required by the installed Prometheus Operator                             | `{}`         |

### TLS/SSL parameters

| Name                                               | Description                                                                                                                                                                                                                     | Value                      |
| -------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------- |
| `tls.internodeEncryption`                          | Set internode encryption                                                                                                                                                                                                        | `none`                     |
| `tls.clientEncryption`                             | Set client-server encryption                                                                                                                                                                                                    | `false`                    |
| `tls.existingSecret`                               | Existing secret that contains TLS certificates                                                                                                                                                                                  | `""`                       |
| `tls.existingCASecret`                             | Existing secret that contains CA certificates                                                                                                                                                                                   | `""`                       |
| `tls.certFilename`                                 | The secret key from the existingSecret if 'cert' key different from the default (tls.crt)                                                                                                                                       | `tls.crt`                  |
| `tls.certKeyFilename`                              | The secret key from the existingSecret if 'key' key different from the default (tls.key)                                                                                                                                        | `tls.key`                  |
| `tls.certCAFilename`                               | The secret key from the existingSecret if 'ca' key different from the default (ca.crt)                                                                                                                                          | `""`                       |
| `tls.autoGenerated.enabled`                        | Enable automatic generation of certificates for TLS                                                                                                                                                                             | `true`                     |
| `tls.autoGenerated.engine`                         | Mechanism to generate the certificates (allowed values: helm, cert-manager)                                                                                                                                                     | `helm`                     |
| `tls.autoGenerated.certManager.existingIssuer`     | The name of an existing Issuer to use for generating the certificates (only for `cert-manager` engine)                                                                                                                          | `""`                       |
| `tls.autoGenerated.certManager.existingIssuerKind` | Existing Issuer kind, defaults to Issuer (only for `cert-manager` engine)                                                                                                                                                       | `""`                       |
| `tls.autoGenerated.certManager.keyAlgorithm`       | Key algorithm for the certificates (only for `cert-manager` engine)                                                                                                                                                             | `RSA`                      |
| `tls.autoGenerated.certManager.keySize`            | Key size for the certificates (only for `cert-manager` engine)                                                                                                                                                                  | `2048`                     |
| `tls.autoGenerated.certManager.duration`           | Duration for the certificates (only for `cert-manager` engine)                                                                                                                                                                  | `2160h`                    |
| `tls.autoGenerated.certManager.renewBefore`        | Renewal period for the certificates (only for `cert-manager` engine)                                                                                                                                                            | `360h`                     |
| `sysctl.enabled`                                   | Enable init container to modify Kernel settings                                                                                                                                                                                 | `false`                    |
| `sysctl.image.registry`                            | OS Shell + Utility image registry                                                                                                                                                                                               | `REGISTRY_NAME`            |
| `sysctl.image.repository`                          | OS Shell + Utility image repository                                                                                                                                                                                             | `REPOSITORY_NAME/os-shell` |
| `sysctl.image.digest`                              | OS Shell + Utility image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                              | `""`                       |
| `sysctl.image.pullPolicy`                          | OS Shell + Utility image pull policy                                                                                                                                                                                            | `IfNotPresent`             |
| `sysctl.image.pullSecrets`                         | OS Shell + Utility image pull secrets                                                                                                                                                                                           | `[]`                       |
| `sysctl.sysctls`                                   | Map with sysctl settings to change. These are translated to sysctl -w <key> = <value>                                                                                                                                           | `{}`                       |
| `sysctl.resourcesPreset`                           | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if sysctl.resources is set (sysctl.resources is recommended for production). | `nano`                     |
| `sysctl.resources`                                 | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                               | `{}`                       |

The above parameters map to the env variables defined in [bitnami/scylladb](https://github.com/bitnami/containers/tree/main/bitnami/scylladb). For more information please refer to the [bitnami/scylladb](https://github.com/bitnami/containers/tree/main/bitnami/scylladb) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
    --set dbUser.user=admin,dbUser.password=password \
    oci://REGISTRY_NAME/REPOSITORY_NAME/scylladb
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml oci://REGISTRY_NAME/REPOSITORY_NAME/scylladb
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.
> **Tip**: You can use the default [values.yaml](https://github.com/bitnami/charts/tree/main/bitnami/scylladb/values.yaml)

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 3.1.0

This version introduces image verification for security purposes. To disable it, set `global.security.allowInsecureImages` to `true`. More details at [GitHub issue](https://github.com/bitnami/charts/issues/30850).

It's necessary to set the `dbUser.password` parameter when upgrading for readiness/liveness probes to work properly. When you install this chart for the first time, some notes will be displayed providing the credentials you must use. Please note down the password and run the command below to upgrade your chart:

```console
helm upgrade my-release oci://REGISTRY_NAME/REPOSITORY_NAME/scylladb --set dbUser.password=[PASSWORD]
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

| Note: you need to substitute the placeholder *[PASSWORD]* with the value obtained in the installation notes.

### To 3.0.0

This major version updates ScyllaDB to version 6.2. From now on, scylla-jmx becomes an optional package and is not installed by default. `jmxProxy.enabled`  has been set to `false`, and the whole JMX logic is deprecated and plan to be removed in a future release.

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