<!--- app-name: Apache Cassandra -->

# Bitnami package for Apache Cassandra

Apache Cassandra is an open source distributed database management system designed to handle large amounts of data across many servers, providing high availability with no single point of failure.

[Overview of Apache Cassandra](http://cassandra.apache.org/)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/cassandra
```

Looking to use Apache Cassandra in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the enterprise edition of Bitnami Application Catalog.

## Introduction

This chart bootstraps an [Apache Cassandra](https://github.com/bitnami/containers/tree/main/bitnami/cassandra) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/cassandra
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

These commands deploy one node with Apache Cassandra on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Configuration and installation details

### Resource requests and limits

Bitnami charts allow setting resource requests and limits for all containers inside the chart deployment. These are inside the `resources` value (check parameter table). Setting requests is essential for production workloads and these should be adapted to your specific use case.

To make this process easier, the chart contains the `resourcesPreset` values, which automatically sets the `resources` section according to different presets. Check these presets in [the bitnami/common chart](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15). However, in production workloads using `resourcePreset` is discouraged as it may not fully adapt to your specific needs. Find more information on container resource management in the [official Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).

### [Rolling vs Immutable tags](https://docs.vmware.com/en/VMware-Tanzu-Application-Catalog/services/tutorials/GUID-understand-rolling-tags-containers-index.html)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Enable TLS

This chart supports TLS between client and server and between nodes, as explained below:

- For internode cluster encryption, set the `tls.internodeEncryption` chart parameter to a value different from `none`. Available values are `all`, `dc` or `rack`.
- For client-server encryption, set the `tls.clientEncryption` chart parameter to `true`.

In both cases, it is also necessary to create a secret containing the keystore and truststore certificates and their corresponding protection passwords. This secret is to be passed to the chart via the `tls.existingSecret` parameter at deployment-time, as shown below:

```text
tls.internodeEncryption=all
tls.clientEncryption=true
tls.existingSecret=my-exisiting-stores
tls.passwordsSecret=my-stores-password
```

> TIP: The secret may be created in the standard way with the `--from-file=./keystore`, `--from-file=./truststore`, `--from-literal=keystore-password=KEYSTORE_PASSWORD` and `--from-literal=truststore-password=TRUSTSTORE_PASSWORD` options. This assumes that the stores are in the current working directory and the KEYSTORE_PASSWORD and TRUSTSTORE_PASSWORD placeholders are replaced with the correct keystore and truststore passwords respectively. Example:

```console
kubectl create secret generic my-exisiting-stores --from-file=./keystore --from-file=./truststore
kubectl create secret generic my-stores-password --from-literal=keystore-password=KEYSTORE_PASSWORD --from-literal=truststore-password=TRUSTSTORE_PASSWORD
```

Keystore and Truststore files can be dinamycally created from the certificates files. In this case a secret with the tls.crt, tls.key and ca.crt in pem format is required. The following example shows how the secret can be created and assumes that all certificate files are in the working directory:

```console
kubectl create secret tls my-certs --cert ./tls.crt --key ./tls.key
kubectl patch secret my-certs -p="{\"data\":{\"ca.crt\": \"$(cat ./ca.crt | base64 )\"}}"
```

To enable this feature `tls.autoGenerated` must be set and the new secret should be set in `tls.certificateSecret`:

```text
tls.internodeEncryption=all
tls.clientEncryption=true
tls.autoGenerated=true
tls.certificatesSecret=my-certs
tls.passwordsSecret=my-stores-password
```

### Initialize the database

The [Apache Cassandra](https://github.com/bitnami/containers/tree/main/bitnami/cassandra) image supports the use of custom scripts to initialize a fresh instance. This may be done by creating a Kubernetes ConfigMap that includes the necessary `.sh` or `.cql` scripts and passing this ConfigMap to the chart via the `initDBConfigMap` parameter.

### Use a custom configuration file

This chart also supports mounting custom configuration file(s) for Apache Cassandra. This is achieved by setting the `existingConfiguration` parameter with the name of a ConfigMap that includes the custom configuration file(s). Here is an example of deploying the chart with a custom configuration file stored in a ConfigMap named `cassandra-configuration`:

```text
existingConfiguration=cassandra-configuration
```

> NOTE: This ConfigMap will override other Apache Cassandra configuration variables set in the chart.

### Backup and restore

Refer to our detailed tutorial on [backing up and restoring Bitnami Apache Cassandra deployments on Kubernetes](https://docs.vmware.com/en/VMware-Tanzu-Application-Catalog/services/tutorials/GUID-backup-restore-data-cassandra-kubernetes-index.html).

### Set pod affinity

This chart allows you to set custom pod affinity using the `XXX.affinity` parameter(s). Find more information about pod affinity in the [Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities) chart. To do so, set the `XXX.podAffinityPreset`, `XXX.podAntiAffinityPreset`, or `XXX.nodeAffinityPreset` parameters.

## Persistence

The [Bitnami Apache Cassandra](https://github.com/bitnami/containers/tree/main/bitnami/cassandra) image stores the Apache Cassandra data at the `/bitnami/cassandra` path of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Parameters](#parameters) section to configure the PVC or to disable persistence.

If you encounter errors when working with persistent volumes, refer to our [troubleshooting guide for persistent volumes](https://docs.bitnami.com/kubernetes/faq/troubleshooting/troubleshooting-persistence-volumes/).

### Adjust permissions of persistent volume mountpoint

As the image run as non-root by default, it is necessary to adjust the ownership of the persistent volume so that the container can write data into it. There are two approaches to achieve this:

- Use Kubernetes SecurityContexts by setting the `podSecurityContext.enabled` and `containerSecurityContext.enabled` to `true`. This option is enabled by default in the chart. However, this feature does not work in all Kubernetes distributions.
- Use an init container to change the ownership of the volume before mounting it in the final destination. Enable this container by setting the `volumePermissions.enabled` parameter to `true`.

## Parameters

### Global parameters

| Name                                                  | Description                                                                                                                                                                                                                                                                                                                                                         | Value  |
| ----------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------ |
| `global.imageRegistry`                                | Global Docker image registry                                                                                                                                                                                                                                                                                                                                        | `""`   |
| `global.imagePullSecrets`                             | Global Docker registry secret names as an array                                                                                                                                                                                                                                                                                                                     | `[]`   |
| `global.storageClass`                                 | Global StorageClass for Persistent Volume(s)                                                                                                                                                                                                                                                                                                                        | `""`   |
| `global.compatibility.openshift.adaptSecurityContext` | Adapt the securityContext sections of the deployment to make them compatible with Openshift restricted-v2 SCC: remove runAsUser, runAsGroup and fsGroup and let the platform use their allowed default IDs. Possible values: auto (apply if the detected running cluster is Openshift), force (perform the adaptation always), disabled (do not perform adaptation) | `auto` |

### Common parameters

| Name                     | Description                                                                             | Value           |
| ------------------------ | --------------------------------------------------------------------------------------- | --------------- |
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

### Cassandra parameters

| Name                          | Description                                                                                                            | Value                       |
| ----------------------------- | ---------------------------------------------------------------------------------------------------------------------- | --------------------------- |
| `image.registry`              | Cassandra image registry                                                                                               | `REGISTRY_NAME`             |
| `image.repository`            | Cassandra image repository                                                                                             | `REPOSITORY_NAME/cassandra` |
| `image.digest`                | Cassandra image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag              | `""`                        |
| `image.pullPolicy`            | image pull policy                                                                                                      | `IfNotPresent`              |
| `image.pullSecrets`           | Cassandra image pull secrets                                                                                           | `[]`                        |
| `image.debug`                 | Enable image debug mode                                                                                                | `false`                     |
| `dbUser.user`                 | Cassandra admin user                                                                                                   | `cassandra`                 |
| `dbUser.forcePassword`        | Force the user to provide a non                                                                                        | `false`                     |
| `dbUser.password`             | Password for `dbUser.user`. Randomly generated if empty                                                                | `""`                        |
| `dbUser.existingSecret`       | Use an existing secret object for `dbUser.user` password (will ignore `dbUser.password`)                               | `""`                        |
| `initDBConfigMap`             | ConfigMap with cql scripts. Useful for creating a keyspace and pre-populating data                                     | `""`                        |
| `initDBSecret`                | Secret with cql script (with sensitive data). Useful for creating a keyspace and pre-populating data                   | `""`                        |
| `existingConfiguration`       | ConfigMap with custom cassandra configuration files. This overrides any other Cassandra configuration set in the chart | `""`                        |
| `cluster.name`                | Cassandra cluster name                                                                                                 | `cassandra`                 |
| `cluster.seedCount`           | Number of seed nodes                                                                                                   | `1`                         |
| `cluster.numTokens`           | Number of tokens for each node                                                                                         | `256`                       |
| `cluster.datacenter`          | Datacenter name                                                                                                        | `dc1`                       |
| `cluster.rack`                | Rack name                                                                                                              | `rack1`                     |
| `cluster.endpointSnitch`      | Endpoint Snitch                                                                                                        | `SimpleSnitch`              |
| `cluster.internodeEncryption` | DEPRECATED: use tls.internode and tls.client instead. Encryption values.                                               | `none`                      |
| `cluster.clientEncryption`    | Client Encryption                                                                                                      | `false`                     |
| `cluster.extraSeeds`          | For an external/second cassandra ring.                                                                                 | `[]`                        |
| `cluster.enableUDF`           | Enable User defined functions                                                                                          | `false`                     |
| `jvm.extraOpts`               | Set the value for Java Virtual Machine extra options                                                                   | `""`                        |
| `jvm.maxHeapSize`             | Set Java Virtual Machine maximum heap size (MAX_HEAP_SIZE). Calculated automatically if `nil`                          | `""`                        |
| `jvm.newHeapSize`             | Set Java Virtual Machine new heap size (HEAP_NEWSIZE). Calculated automatically if `nil`                               | `""`                        |
| `command`                     | Command for running the container (set to default if not set). Use array form                                          | `[]`                        |
| `args`                        | Args for running the container (set to default if not set). Use array form                                             | `[]`                        |
| `extraEnvVars`                | Extra environment variables to be set on cassandra container                                                           | `[]`                        |
| `extraEnvVarsCM`              | Name of existing ConfigMap containing extra env vars                                                                   | `""`                        |
| `extraEnvVarsSecret`          | Name of existing Secret containing extra env vars                                                                      | `""`                        |

### Statefulset parameters

| Name                                                | Description                                                                                                                                                                                                       | Value            |
| --------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| `replicaCount`                                      | Number of Cassandra replicas                                                                                                                                                                                      | `1`              |
| `updateStrategy.type`                               | updateStrategy for Cassandra statefulset                                                                                                                                                                          | `RollingUpdate`  |
| `automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                | `false`          |
| `hostAliases`                                       | Add deployment host aliases                                                                                                                                                                                       | `[]`             |
| `podManagementPolicy`                               | StatefulSet pod management policy                                                                                                                                                                                 | `OrderedReady`   |
| `priorityClassName`                                 | Cassandra pods' priority.                                                                                                                                                                                         | `""`             |
| `podAnnotations`                                    | Additional pod annotations                                                                                                                                                                                        | `{}`             |
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
| `podSecurityContext.enabled`                        | Enabled Cassandra pods' Security Context                                                                                                                                                                          | `true`           |
| `podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                | `Always`         |
| `podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                    | `[]`             |
| `podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                       | `[]`             |
| `podSecurityContext.fsGroup`                        | Set Cassandra pod's Security Context fsGroup                                                                                                                                                                      | `1001`           |
| `containerSecurityContext.enabled`                  | Enabled Cassandra containers' Security Context                                                                                                                                                                    | `true`           |
| `containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                  | `{}`             |
| `containerSecurityContext.runAsUser`                | Set Cassandra containers' Security Context runAsUser                                                                                                                                                              | `1001`           |
| `containerSecurityContext.runAsGroup`               | Set Cassandra containers' Security Context runAsGroup                                                                                                                                                             | `1001`           |
| `containerSecurityContext.allowPrivilegeEscalation` | Set Cassandra containers' Security Context allowPrivilegeEscalation                                                                                                                                               | `false`          |
| `containerSecurityContext.capabilities.drop`        | Set Cassandra containers' Security Context capabilities to be dropped                                                                                                                                             | `["ALL"]`        |
| `containerSecurityContext.readOnlyRootFilesystem`   | Set Cassandra containers' Security Context readOnlyRootFilesystem                                                                                                                                                 | `true`           |
| `containerSecurityContext.runAsNonRoot`             | Set Cassandra containers' Security Context runAsNonRoot                                                                                                                                                           | `true`           |
| `containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                                                                                                                       | `false`          |
| `containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                  | `RuntimeDefault` |
| `resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if resources is set (resources is recommended for production). | `large`          |
| `resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                 | `{}`             |
| `livenessProbe.enabled`                             | Enable livenessProbe                                                                                                                                                                                              | `true`           |
| `livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                           | `60`             |
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
| `lifecycleHooks`                                    | Override default etcd container hooks                                                                                                                                                                             | `{}`             |
| `schedulerName`                                     | Alternative scheduler                                                                                                                                                                                             | `""`             |
| `terminationGracePeriodSeconds`                     | In seconds, time the given to the Cassandra pod needs to terminate gracefully                                                                                                                                     | `""`             |
| `extraVolumes`                                      | Optionally specify extra list of additional volumes for cassandra container                                                                                                                                       | `[]`             |
| `extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for cassandra container                                                                                                                                  | `[]`             |
| `initContainers`                                    | Add additional init containers to the cassandra pods                                                                                                                                                              | `[]`             |
| `sidecars`                                          | Add additional sidecar containers to the cassandra pods                                                                                                                                                           | `[]`             |
| `pdb.create`                                        | Enable/disable a Pod Disruption Budget creation                                                                                                                                                                   | `false`          |
| `pdb.minAvailable`                                  | Mininimum number of pods that must still be available after the eviction                                                                                                                                          | `1`              |
| `pdb.maxUnavailable`                                | Max number of pods that can be unavailable after the eviction                                                                                                                                                     | `""`             |
| `hostNetwork`                                       | Enable HOST Network                                                                                                                                                                                               | `false`          |
| `containerPorts.intra`                              | Intra Port on the Host and Container                                                                                                                                                                              | `7000`           |
| `containerPorts.tls`                                | TLS Port on the Host and Container                                                                                                                                                                                | `7001`           |
| `containerPorts.jmx`                                | JMX Port on the Host and Container                                                                                                                                                                                | `7199`           |
| `containerPorts.cql`                                | CQL Port on the Host and Container                                                                                                                                                                                | `9042`           |
| `hostPorts.intra`                                   | Intra Port on the Host                                                                                                                                                                                            | `""`             |
| `hostPorts.tls`                                     | TLS Port on the Host                                                                                                                                                                                              | `""`             |
| `hostPorts.jmx`                                     | JMX Port on the Host                                                                                                                                                                                              | `""`             |
| `hostPorts.cql`                                     | CQL Port on the Host                                                                                                                                                                                              | `""`             |

### RBAC parameters

| Name                                          | Description                                                | Value   |
| --------------------------------------------- | ---------------------------------------------------------- | ------- |
| `serviceAccount.create`                       | Enable the creation of a ServiceAccount for Cassandra pods | `true`  |
| `serviceAccount.name`                         | The name of the ServiceAccount to use.                     | `""`    |
| `serviceAccount.annotations`                  | Annotations for Cassandra Service Account                  | `{}`    |
| `serviceAccount.automountServiceAccountToken` | Automount API credentials for a service account.           | `false` |

### Traffic Exposure Parameters

| Name                                    | Description                                                                        | Value       |
| --------------------------------------- | ---------------------------------------------------------------------------------- | ----------- |
| `service.type`                          | Cassandra service type                                                             | `ClusterIP` |
| `service.ports.cql`                     | Cassandra service CQL Port                                                         | `9042`      |
| `service.ports.metrics`                 | Cassandra service metrics port                                                     | `8080`      |
| `service.nodePorts.cql`                 | Node port for CQL                                                                  | `""`        |
| `service.nodePorts.metrics`             | Node port for metrics                                                              | `""`        |
| `service.extraPorts`                    | Extra ports to expose in the service (normally used with the `sidecar` value)      | `[]`        |
| `service.loadBalancerIP`                | LoadBalancerIP if service type is `LoadBalancer`                                   | `""`        |
| `service.loadBalancerSourceRanges`      | Service Load Balancer sources                                                      | `[]`        |
| `service.clusterIP`                     | Service Cluster IP                                                                 | `""`        |
| `service.externalTrafficPolicy`         | Service external traffic policy                                                    | `Cluster`   |
| `service.annotations`                   | Provide any additional annotations which may be required.                          | `{}`        |
| `service.sessionAffinity`               | Session Affinity for Kubernetes service, can be "None" or "ClientIP"               | `None`      |
| `service.sessionAffinityConfig`         | Additional settings for the sessionAffinity                                        | `{}`        |
| `service.headless.annotations`          | Annotations for the headless service.                                              | `{}`        |
| `networkPolicy.enabled`                 | Specifies whether a NetworkPolicy should be created                                | `true`      |
| `networkPolicy.allowExternal`           | Don't require server label for connections                                         | `true`      |
| `networkPolicy.allowExternalEgress`     | Allow the pod to access any range of port and all destinations.                    | `true`      |
| `networkPolicy.extraIngress`            | Add extra ingress rules to the NetworkPolicy                                       | `[]`        |
| `networkPolicy.extraEgress`             | Add extra ingress rules to the NetworkPolicy (ignored if allowExternalEgress=true) | `[]`        |
| `networkPolicy.ingressNSMatchLabels`    | Labels to match to allow traffic from other namespaces                             | `{}`        |
| `networkPolicy.ingressNSPodMatchLabels` | Pod labels to match to allow traffic from other namespaces                         | `{}`        |

### Persistence parameters

| Name                             | Description                                                                                                                                          | Value                |
| -------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------- |
| `persistence.enabled`            | Enable Cassandra data persistence using PVC, use a Persistent Volume Claim, If false, use emptyDir                                                   | `true`               |
| `persistence.existingClaim`      | Name of an existing PVC to use                                                                                                                       | `""`                 |
| `persistence.storageClass`       | PVC Storage Class for Cassandra data volume                                                                                                          | `""`                 |
| `persistence.commitStorageClass` | PVC Storage Class for Cassandra Commit Log volume                                                                                                    | `""`                 |
| `persistence.annotations`        | Persistent Volume Claim annotations                                                                                                                  | `{}`                 |
| `persistence.accessModes`        | Persistent Volume Access Mode                                                                                                                        | `["ReadWriteOnce"]`  |
| `persistence.size`               | PVC Storage Request for Cassandra data volume                                                                                                        | `8Gi`                |
| `persistence.commitLogsize`      | PVC Storage Request for Cassandra commit log volume. Unset by default                                                                                | `2Gi`                |
| `persistence.mountPath`          | The path the data volume will be mounted at                                                                                                          | `/bitnami/cassandra` |
| `persistence.commitLogMountPath` | The path the commit log volume will be mounted at. Unset by default. Set it to '/bitnami/cassandra/commitlog' to enable a separate commit log volume | `""`                 |

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

| Name                                         | Description                                                                                                                                                                                                                       | Value                                |
| -------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------ |
| `metrics.enabled`                            | Start a side-car prometheus exporter                                                                                                                                                                                              | `false`                              |
| `metrics.image.registry`                     | Cassandra exporter image registry                                                                                                                                                                                                 | `REGISTRY_NAME`                      |
| `metrics.image.repository`                   | Cassandra exporter image name                                                                                                                                                                                                     | `REPOSITORY_NAME/cassandra-exporter` |
| `metrics.image.digest`                       | Cassandra exporter image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                | `""`                                 |
| `metrics.image.pullPolicy`                   | image pull policy                                                                                                                                                                                                                 | `IfNotPresent`                       |
| `metrics.image.pullSecrets`                  | Specify docker-registry secret names as an array                                                                                                                                                                                  | `[]`                                 |
| `metrics.resourcesPreset`                    | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if metrics.resources is set (metrics.resources is recommended for production). | `nano`                               |
| `metrics.resources`                          | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                 | `{}`                                 |
| `metrics.readinessProbe.initialDelaySeconds` | Initial delay seconds for readinessProbe                                                                                                                                                                                          | `20`                                 |
| `metrics.readinessProbe.periodSeconds`       | Period seconds for readinessProbe                                                                                                                                                                                                 | `10`                                 |
| `metrics.readinessProbe.timeoutSeconds`      | Timeout seconds for readinessProbe                                                                                                                                                                                                | `45`                                 |
| `metrics.readinessProbe.failureThreshold`    | Failure threshold for readinessProbe                                                                                                                                                                                              | `3`                                  |
| `metrics.readinessProbe.successThreshold`    | Success threshold for readinessProbe                                                                                                                                                                                              | `1`                                  |
| `metrics.extraVolumeMounts`                  | Optionally specify extra list of additional volumeMounts for cassandra-exporter container                                                                                                                                         | `[]`                                 |
| `metrics.podAnnotations`                     | Metrics exporter pod Annotation and Labels                                                                                                                                                                                        | `{}`                                 |
| `metrics.serviceMonitor.enabled`             | If `true`, creates a Prometheus Operator ServiceMonitor (also requires `metrics.enabled` to be `true`)                                                                                                                            | `false`                              |
| `metrics.serviceMonitor.namespace`           | Namespace in which Prometheus is running                                                                                                                                                                                          | `monitoring`                         |
| `metrics.serviceMonitor.interval`            | Interval at which metrics should be scraped.                                                                                                                                                                                      | `""`                                 |
| `metrics.serviceMonitor.scrapeTimeout`       | Timeout after which the scrape is ended                                                                                                                                                                                           | `""`                                 |
| `metrics.serviceMonitor.selector`            | Prometheus instance selector labels                                                                                                                                                                                               | `{}`                                 |
| `metrics.serviceMonitor.metricRelabelings`   | Specify Metric Relabelings to add to the scrape endpoint                                                                                                                                                                          | `[]`                                 |
| `metrics.serviceMonitor.relabelings`         | RelabelConfigs to apply to samples before scraping                                                                                                                                                                                | `[]`                                 |
| `metrics.serviceMonitor.honorLabels`         | Specify honorLabels parameter to add the scrape endpoint                                                                                                                                                                          | `false`                              |
| `metrics.serviceMonitor.jobLabel`            | The name of the label on the target service to use as the job name in prometheus.                                                                                                                                                 | `""`                                 |
| `metrics.serviceMonitor.labels`              | Used to pass Labels that are required by the installed Prometheus Operator                                                                                                                                                        | `{}`                                 |
| `metrics.containerPorts.http`                | HTTP Port on the Host and Container                                                                                                                                                                                               | `8080`                               |
| `metrics.containerPorts.jmx`                 | JMX Port on the Host and Container                                                                                                                                                                                                | `5555`                               |
| `metrics.hostPorts.http`                     | HTTP Port on the Host                                                                                                                                                                                                             | `""`                                 |
| `metrics.hostPorts.jmx`                      | JMX Port on the Host                                                                                                                                                                                                              | `""`                                 |
| `metrics.configuration`                      | Configure Cassandra-exporter with a custom config.yml file                                                                                                                                                                        | `""`                                 |

### TLS/SSL parameters

| Name                          | Description                                                                                                                                                                                                               | Value   |
| ----------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `tls.internodeEncryption`     | Set internode encryption                                                                                                                                                                                                  | `none`  |
| `tls.clientEncryption`        | Set client-server encryption                                                                                                                                                                                              | `false` |
| `tls.autoGenerated`           | Generate automatically self-signed TLS certificates. Currently only supports PEM certificates                                                                                                                             | `false` |
| `tls.existingSecret`          | Existing secret that contains Cassandra Keystore and truststore                                                                                                                                                           | `""`    |
| `tls.passwordsSecret`         | Secret containing the Keystore and Truststore passwords if needed                                                                                                                                                         | `""`    |
| `tls.keystorePassword`        | Password for the keystore, if needed.                                                                                                                                                                                     | `""`    |
| `tls.truststorePassword`      | Password for the truststore, if needed.                                                                                                                                                                                   | `""`    |
| `tls.resourcesPreset`         | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if tls.resources is set (tls.resources is recommended for production). | `nano`  |
| `tls.resources`               | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                         | `{}`    |
| `tls.certificatesSecret`      | Secret with the TLS certificates.                                                                                                                                                                                         | `""`    |
| `tls.tlsEncryptionSecretName` | Secret with the encryption of the TLS certificates                                                                                                                                                                        | `""`    |

The above parameters map to the env variables defined in [bitnami/cassandra](https://github.com/bitnami/containers/tree/main/bitnami/cassandra). For more information please refer to the [bitnami/cassandra](https://github.com/bitnami/containers/tree/main/bitnami/cassandra) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
    --set dbUser.user=admin,dbUser.password=password \
    oci://REGISTRY_NAME/REPOSITORY_NAME/cassandra
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml oci://REGISTRY_NAME/REPOSITORY_NAME/cassandra
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.
> **Tip**: You can use the default [values.yaml](https://github.com/bitnami/charts/tree/main/bitnami/cassandra/values.yaml)

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

It's necessary to set the `dbUser.password` parameter when upgrading for readiness/liveness probes to work properly. When you install this chart for the first time, some notes will be displayed providing the credentials you must use. Please note down the password and run the command below to upgrade your chart:

```console
helm upgrade my-release oci://REGISTRY_NAME/REPOSITORY_NAME/cassandra --set dbUser.password=[PASSWORD]
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

| Note: you need to substitute the placeholder *[PASSWORD]* with the value obtained in the installation notes.

### To 10.0.0

This major bump changes the following security defaults:

- `runAsGroup` is changed from `0` to `1001`
- `readOnlyRootFilesystem` is set to `true`
- `resourcesPreset` is changed from `none` to the minimum size working in our test suites (NOTE: `resourcesPreset` is not meant for production usage, but `resources` adapted to your use case).
- `global.compatibility.openshift.adaptSecurityContext` is changed from `disabled` to `auto`.

This could potentially break any customization or init scripts used in your deployment. If this is the case, change the default values to the previous ones.

### To 9.0.0

This major release renames several values in this chart and adds missing features, in order to be inline with the rest of assets in the Bitnami charts repository.

Affected values:

- `serviceMonitor.labels` renamed as `serviceMonitor.selector`.
- `service.port` renamed as `service.ports.cql`.
- `service.metricsPort` renamed as `service.ports.metrics`.
- `service.nodePort` renamed as `service.nodePorts.cql`.
- `updateStrategy` changed from String type (previously default to 'rollingUpdate') to Object type, allowing users to configure other updateStrategy parameters, similar to other charts.
- Removed value `rollingUpdatePartition`, now configured using `updateStrategy` setting `updateStrategy.rollingUpdate.partition`.

### To 8.0.0

Cassandra's version was bumped to `4.0`, [the new major](https://cassandra.apache.org/_/blog/Apache-Cassandra-4.0-is-Here.html) considered LTS. Among other features, this release removes support for [Thrift](https://issues.apache.org/jira/browse/CASSANDRA-11115), which means that the following properties of the chart will no longer be available:

- `cluster.enableRPC`
- `service.thriftPort`
- `service.nodePorts.thrift`
- `containerPorts.thrift`

For this version, there have been [intensive efforts](https://cwiki.apache.org/confluence/display/CASSANDRA/4.0+Quality%3A+Components+and+Test+Plans) from Apache to ensure that a safe cluster upgrade can be performed. Nevertheless, a backup creation prior to undergoing the upgrade process is recommended. Please, refer to the [official guide](https://cassandra.apache.org/doc/latest/operating/backups.html#snapshots) for further information.

### To 7.0.0

[On November 13, 2020, Helm v2 support was formally finished](https://github.com/helm/charts#status-of-the-project), this major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

### To 6.0.0

- Several parameters were renamed or disappeared in favor of new ones on this major version:
  - `securityContext.*` is deprecated in favor of `podSecurityContext` and `containerSecurityContext`.
  - Parameters prefixed with `statefulset.` were renamed removing the prefix. E.g. `statefulset.rollingUpdatePartition` -> renamed to `rollingUpdatePartition`.
  - `cluster.replicaCount` is renamed to `replicaCount`.
  - `cluster.domain` is renamed to `clusterDomain`.
- Chart labels were adapted to follow the [Helm charts standard labels](https://helm.sh/docs/chart_best_practices/labels/#standard-labels).
- This version also introduces `bitnami/common`, a [library chart](https://helm.sh/docs/topics/library_charts/#helm) as a dependency. More documentation about this new utility could be found [here](https://github.com/bitnami/charts/tree/main/bitnami/common#bitnami-common-library-chart). Please, make sure that you have updated the chart dependencies before executing any upgrade.

Consequences:

- Backwards compatibility is not guaranteed. To upgrade to `6.0.0`, install a new release of the Cassandra chart, and migrate the data from your previous release. To do so, create an snapshot of the database, and restore it on the new database. Check [this guide](https://cassandra.apache.org/doc/latest/operating/backups.html#snapshots) for more information.

### To 5.4.0

The `minimumAvailable` option has been renamed to `minAvailable` for consistency with other charts. This is not a breaking change as `minimumAvailable` never worked before because of an error in chart templates.

### To 5.0.0

An issue in StatefulSet manifest of the 4.x chart series rendered chart upgrades to be broken. The 5.0.0 series fixes this issue. To upgrade to the 5.x series you need to manually delete the Cassandra StatefulSet before executing the `helm upgrade` command.

```console
kubectl delete sts -l release=<RELEASE_NAME>
helm upgrade <RELEASE_NAME> ...
```

### To 4.0.0

This release changes uses Bitnami Cassandra container `3.11.4-debian-9-r188`, based on Bash.

### To 2.0.0

This release make it possible to specify custom initialization scripts in both cql and sh files.

#### Breaking changes

- `startupCQL` has been removed. Instead, for initializing the database, see [this section](#initialize-the-database).

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