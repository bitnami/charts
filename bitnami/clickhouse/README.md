<!--- app-name: ClickHouse -->

# ClickHouse packaged by Bitnami

ClickHouse is an open-source column-oriented OLAP database management system. Use it to boost your database performance while providing linear scalability and hardware efficiency.

[Overview of ClickHouse](https://clickhouse.com/)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/clickhouse
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

## Introduction

Bitnami charts for Helm are carefully engineered, actively maintained and are the quickest and easiest way to deploy containers on a Kubernetes cluster that are ready to handle production workloads.

This chart bootstraps a [ClickHouse](https://github.com/clickhouse/clickhouse) Deployment in a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

[Learn more about the default configuration of the chart](https://docs.bitnami.com/kubernetes/infrastructure/clickhouse/get-started/).

Looking to use ClickHouse in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the enterprise edition of Bitnami Application Catalog.

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

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

### Global parameters

| Name                      | Description                                     | Value |
| ------------------------- | ----------------------------------------------- | ----- |
| `global.imageRegistry`    | Global Docker image registry                    | `""`  |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]`  |
| `global.storageClass`     | Global StorageClass for Persistent Volume(s)    | `""`  |

### Common parameters

| Name                     | Description                                                                             | Value           |
| ------------------------ | --------------------------------------------------------------------------------------- | --------------- |
| `kubeVersion`            | Override Kubernetes version                                                             | `""`            |
| `nameOverride`           | String to partially override common.names.name                                          | `""`            |
| `fullnameOverride`       | String to fully override common.names.fullname                                          | `""`            |
| `namespaceOverride`      | String to fully override common.names.namespace                                         | `""`            |
| `commonLabels`           | Labels to add to all deployed objects                                                   | `{}`            |
| `commonAnnotations`      | Annotations to add to all deployed objects                                              | `{}`            |
| `clusterDomain`          | Kubernetes cluster domain name                                                          | `cluster.local` |
| `extraDeploy`            | Array of extra objects to deploy with the release                                       | `[]`            |
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden) | `false`         |
| `diagnosticMode.command` | Command to override all containers in the deployment                                    | `["sleep"]`     |
| `diagnosticMode.args`    | Args to override all containers in the deployment                                       | `["infinity"]`  |

### ClickHouse Parameters

| Name                                                | Description                                                                                                | Value                        |
| --------------------------------------------------- | ---------------------------------------------------------------------------------------------------------- | ---------------------------- |
| `image.registry`                                    | ClickHouse image registry                                                                                  | `REGISTRY_NAME`              |
| `image.repository`                                  | ClickHouse image repository                                                                                | `REPOSITORY_NAME/clickhouse` |
| `image.digest`                                      | ClickHouse image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag | `""`                         |
| `image.pullPolicy`                                  | ClickHouse image pull policy                                                                               | `IfNotPresent`               |
| `image.pullSecrets`                                 | ClickHouse image pull secrets                                                                              | `[]`                         |
| `image.debug`                                       | Enable ClickHouse image debug mode                                                                         | `false`                      |
| `shards`                                            | Number of ClickHouse shards to deploy                                                                      | `2`                          |
| `replicaCount`                                      | Number of ClickHouse replicas per shard to deploy                                                          | `3`                          |
| `distributeReplicasByZone`                          | Schedules replicas of the same shard to different availability zones                                       | `false`                      |
| `containerPorts.http`                               | ClickHouse HTTP container port                                                                             | `8123`                       |
| `containerPorts.https`                              | ClickHouse HTTPS container port                                                                            | `8443`                       |
| `containerPorts.tcp`                                | ClickHouse TCP container port                                                                              | `9000`                       |
| `containerPorts.tcpSecure`                          | ClickHouse TCP (secure) container port                                                                     | `9440`                       |
| `containerPorts.keeper`                             | ClickHouse keeper TCP container port                                                                       | `2181`                       |
| `containerPorts.keeperSecure`                       | ClickHouse keeper TCP (secure) container port                                                              | `3181`                       |
| `containerPorts.keeperInter`                        | ClickHouse keeper interserver TCP container port                                                           | `9444`                       |
| `containerPorts.mysql`                              | ClickHouse MySQL container port                                                                            | `9004`                       |
| `containerPorts.postgresql`                         | ClickHouse PostgreSQL container port                                                                       | `9005`                       |
| `containerPorts.interserver`                        | ClickHouse Interserver container port                                                                      | `9009`                       |
| `containerPorts.metrics`                            | ClickHouse metrics container port                                                                          | `8001`                       |
| `livenessProbe.enabled`                             | Enable livenessProbe on ClickHouse containers                                                              | `true`                       |
| `livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                    | `10`                         |
| `livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                           | `10`                         |
| `livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                          | `1`                          |
| `livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                        | `3`                          |
| `livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                        | `1`                          |
| `readinessProbe.enabled`                            | Enable readinessProbe on ClickHouse containers                                                             | `true`                       |
| `readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                   | `10`                         |
| `readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                          | `10`                         |
| `readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                         | `1`                          |
| `readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                       | `3`                          |
| `readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                       | `1`                          |
| `startupProbe.enabled`                              | Enable startupProbe on ClickHouse containers                                                               | `false`                      |
| `startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                     | `10`                         |
| `startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                            | `10`                         |
| `startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                           | `1`                          |
| `startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                         | `3`                          |
| `startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                         | `1`                          |
| `customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                        | `{}`                         |
| `customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                       | `{}`                         |
| `customStartupProbe`                                | Custom startupProbe that overrides the default one                                                         | `{}`                         |
| `resources.limits`                                  | The resources limits for the ClickHouse containers                                                         | `{}`                         |
| `resources.requests`                                | The requested resources for the ClickHouse containers                                                      | `{}`                         |
| `podSecurityContext.enabled`                        | Enabled ClickHouse pods' Security Context                                                                  | `true`                       |
| `podSecurityContext.fsGroup`                        | Set ClickHouse pod's Security Context fsGroup                                                              | `1001`                       |
| `containerSecurityContext.enabled`                  | Enable containers' Security Context                                                                        | `true`                       |
| `containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                 | `1001`                       |
| `containerSecurityContext.runAsNonRoot`             | Set containers' Security Context runAsNonRoot                                                              | `true`                       |
| `containerSecurityContext.readOnlyRootFilesystem`   | Set read only root file system pod's                                                                       | `false`                      |
| `containerSecurityContext.privileged`               | Set contraller container's Security Context privileged                                                     | `false`                      |
| `containerSecurityContext.allowPrivilegeEscalation` | Set contraller container's Security Context allowPrivilegeEscalation                                       | `false`                      |
| `containerSecurityContext.capabilities.drop`        | List of capabilities to be droppedn                                                                        | `["ALL"]`                    |
| `containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                           | `RuntimeDefault`             |
| `auth.username`                                     | ClickHouse Admin username                                                                                  | `default`                    |
| `auth.password`                                     | ClickHouse Admin password                                                                                  | `""`                         |
| `auth.existingSecret`                               | Name of a secret containing the Admin password                                                             | `""`                         |
| `auth.existingSecretKey`                            | Name of the key inside the existing secret                                                                 | `""`                         |
| `logLevel`                                          | Logging level                                                                                              | `information`                |

### ClickHouse keeper configuration parameters

| Name                            | Description                                                                                                              | Value                   |
| ------------------------------- | ------------------------------------------------------------------------------------------------------------------------ | ----------------------- |
| `keeper.enabled`                | Deploy ClickHouse keeper. Support is experimental.                                                                       | `false`                 |
| `defaultConfigurationOverrides` | Default configuration overrides (evaluated as a template)                                                                | `""`                    |
| `existingOverridesConfigmap`    | The name of an existing ConfigMap with your custom configuration for ClickHouse                                          | `""`                    |
| `extraOverrides`                | Extra configuration overrides (evaluated as a template) apart from the default                                           | `""`                    |
| `extraOverridesConfigmap`       | The name of an existing ConfigMap with extra configuration for ClickHouse                                                | `""`                    |
| `extraOverridesSecret`          | The name of an existing ConfigMap with your custom configuration for ClickHouse                                          | `""`                    |
| `usersExtraOverrides`           | Users extra configuration overrides (evaluated as a template) apart from the default                                     | `""`                    |
| `usersExtraOverridesConfigmap`  | The name of an existing ConfigMap with users extra configuration for ClickHouse                                          | `""`                    |
| `usersExtraOverridesSecret`     | The name of an existing ConfigMap with your custom users configuration for ClickHouse                                    | `""`                    |
| `initdbScripts`                 | Dictionary of initdb scripts                                                                                             | `{}`                    |
| `initdbScriptsSecret`           | ConfigMap with the initdb scripts (Note: Overrides `initdbScripts`)                                                      | `""`                    |
| `startdbScripts`                | Dictionary of startdb scripts                                                                                            | `{}`                    |
| `startdbScriptsSecret`          | ConfigMap with the startdb scripts (Note: Overrides `startdbScripts`)                                                    | `""`                    |
| `command`                       | Override default container command (useful when using custom images)                                                     | `["/scripts/setup.sh"]` |
| `args`                          | Override default container args (useful when using custom images)                                                        | `[]`                    |
| `hostAliases`                   | ClickHouse pods host aliases                                                                                             | `[]`                    |
| `podLabels`                     | Extra labels for ClickHouse pods                                                                                         | `{}`                    |
| `podAnnotations`                | Annotations for ClickHouse pods                                                                                          | `{}`                    |
| `podAffinityPreset`             | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                      | `""`                    |
| `podAntiAffinityPreset`         | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                 | `soft`                  |
| `nodeAffinityPreset.type`       | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                | `""`                    |
| `nodeAffinityPreset.key`        | Node label key to match. Ignored if `affinity` is set                                                                    | `""`                    |
| `nodeAffinityPreset.values`     | Node label values to match. Ignored if `affinity` is set                                                                 | `[]`                    |
| `affinity`                      | Affinity for ClickHouse pods assignment                                                                                  | `{}`                    |
| `nodeSelector`                  | Node labels for ClickHouse pods assignment                                                                               | `{}`                    |
| `tolerations`                   | Tolerations for ClickHouse pods assignment                                                                               | `[]`                    |
| `updateStrategy.type`           | ClickHouse statefulset strategy type                                                                                     | `RollingUpdate`         |
| `podManagementPolicy`           | Statefulset Pod management policy, it needs to be Parallel to be able to complete the cluster join                       | `Parallel`              |
| `priorityClassName`             | ClickHouse pods' priorityClassName                                                                                       | `""`                    |
| `topologySpreadConstraints`     | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template | `[]`                    |
| `schedulerName`                 | Name of the k8s scheduler (other than default) for ClickHouse pods                                                       | `""`                    |
| `terminationGracePeriodSeconds` | Seconds Redmine pod needs to terminate gracefully                                                                        | `""`                    |
| `lifecycleHooks`                | for the ClickHouse container(s) to automate configuration before or after startup                                        | `{}`                    |
| `extraEnvVars`                  | Array with extra environment variables to add to ClickHouse nodes                                                        | `[]`                    |
| `extraEnvVarsCM`                | Name of existing ConfigMap containing extra env vars for ClickHouse nodes                                                | `""`                    |
| `extraEnvVarsSecret`            | Name of existing Secret containing extra env vars for ClickHouse nodes                                                   | `""`                    |
| `extraVolumes`                  | Optionally specify extra list of additional volumes for the ClickHouse pod(s)                                            | `[]`                    |
| `extraVolumeMounts`             | Optionally specify extra list of additional volumeMounts for the ClickHouse container(s)                                 | `[]`                    |
| `sidecars`                      | Add additional sidecar containers to the ClickHouse pod(s)                                                               | `[]`                    |
| `initContainers`                | Add additional init containers to the ClickHouse pod(s)                                                                  | `[]`                    |
| `tls.enabled`                   | Enable TLS traffic support                                                                                               | `false`                 |
| `tls.autoGenerated`             | Generate automatically self-signed TLS certificates                                                                      | `false`                 |
| `tls.certificatesSecret`        | Name of an existing secret that contains the certificates                                                                | `""`                    |
| `tls.certFilename`              | Certificate filename                                                                                                     | `""`                    |
| `tls.certKeyFilename`           | Certificate key filename                                                                                                 | `""`                    |
| `tls.certCAFilename`            | CA Certificate filename                                                                                                  | `""`                    |

### Traffic Exposure Parameters

| Name                                              | Description                                                                                                                      | Value                    |
| ------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `service.type`                                    | ClickHouse service type                                                                                                          | `ClusterIP`              |
| `service.ports.http`                              | ClickHouse service HTTP port                                                                                                     | `8123`                   |
| `service.ports.https`                             | ClickHouse service HTTPS port                                                                                                    | `443`                    |
| `service.ports.tcp`                               | ClickHouse service TCP port                                                                                                      | `9000`                   |
| `service.ports.tcpSecure`                         | ClickHouse service TCP (secure) port                                                                                             | `9440`                   |
| `service.ports.keeper`                            | ClickHouse keeper TCP container port                                                                                             | `2181`                   |
| `service.ports.keeperSecure`                      | ClickHouse keeper TCP (secure) container port                                                                                    | `3181`                   |
| `service.ports.keeperInter`                       | ClickHouse keeper interserver TCP container port                                                                                 | `9444`                   |
| `service.ports.mysql`                             | ClickHouse service MySQL port                                                                                                    | `9004`                   |
| `service.ports.postgresql`                        | ClickHouse service PostgreSQL port                                                                                               | `9005`                   |
| `service.ports.interserver`                       | ClickHouse service Interserver port                                                                                              | `9009`                   |
| `service.ports.metrics`                           | ClickHouse service metrics port                                                                                                  | `8001`                   |
| `service.nodePorts.http`                          | Node port for HTTP                                                                                                               | `""`                     |
| `service.nodePorts.https`                         | Node port for HTTPS                                                                                                              | `""`                     |
| `service.nodePorts.tcp`                           | Node port for TCP                                                                                                                | `""`                     |
| `service.nodePorts.tcpSecure`                     | Node port for TCP (with TLS)                                                                                                     | `""`                     |
| `service.nodePorts.keeper`                        | ClickHouse keeper TCP container port                                                                                             | `""`                     |
| `service.nodePorts.keeperSecure`                  | ClickHouse keeper TCP (secure) container port                                                                                    | `""`                     |
| `service.nodePorts.keeperInter`                   | ClickHouse keeper interserver TCP container port                                                                                 | `""`                     |
| `service.nodePorts.mysql`                         | Node port for MySQL                                                                                                              | `""`                     |
| `service.nodePorts.postgresql`                    | Node port for PostgreSQL                                                                                                         | `""`                     |
| `service.nodePorts.interserver`                   | Node port for Interserver                                                                                                        | `""`                     |
| `service.nodePorts.metrics`                       | Node port for metrics                                                                                                            | `""`                     |
| `service.clusterIP`                               | ClickHouse service Cluster IP                                                                                                    | `""`                     |
| `service.loadBalancerIP`                          | ClickHouse service Load Balancer IP                                                                                              | `""`                     |
| `service.loadBalancerSourceRanges`                | ClickHouse service Load Balancer sources                                                                                         | `[]`                     |
| `service.externalTrafficPolicy`                   | ClickHouse service external traffic policy                                                                                       | `Cluster`                |
| `service.annotations`                             | Additional custom annotations for ClickHouse service                                                                             | `{}`                     |
| `service.extraPorts`                              | Extra ports to expose in ClickHouse service (normally used with the `sidecars` value)                                            | `[]`                     |
| `service.sessionAffinity`                         | Control where client requests go, to the same pod or round-robin                                                                 | `None`                   |
| `service.sessionAffinityConfig`                   | Additional settings for the sessionAffinity                                                                                      | `{}`                     |
| `service.headless.annotations`                    | Annotations for the headless service.                                                                                            | `{}`                     |
| `externalAccess.enabled`                          | Enable Kubernetes external cluster access to ClickHouse                                                                          | `false`                  |
| `externalAccess.service.type`                     | Kubernetes Service type for external access. It can be NodePort, LoadBalancer or ClusterIP                                       | `LoadBalancer`           |
| `externalAccess.service.ports.http`               | ClickHouse service HTTP port                                                                                                     | `80`                     |
| `externalAccess.service.ports.https`              | ClickHouse service HTTPS port                                                                                                    | `443`                    |
| `externalAccess.service.ports.tcp`                | ClickHouse service TCP port                                                                                                      | `9000`                   |
| `externalAccess.service.ports.tcpSecure`          | ClickHouse service TCP (secure) port                                                                                             | `9440`                   |
| `externalAccess.service.ports.keeper`             | ClickHouse keeper TCP container port                                                                                             | `2181`                   |
| `externalAccess.service.ports.keeperSecure`       | ClickHouse keeper TCP (secure) container port                                                                                    | `3181`                   |
| `externalAccess.service.ports.keeperInter`        | ClickHouse keeper interserver TCP container port                                                                                 | `9444`                   |
| `externalAccess.service.ports.mysql`              | ClickHouse service MySQL port                                                                                                    | `9004`                   |
| `externalAccess.service.ports.postgresql`         | ClickHouse service PostgreSQL port                                                                                               | `9005`                   |
| `externalAccess.service.ports.interserver`        | ClickHouse service Interserver port                                                                                              | `9009`                   |
| `externalAccess.service.ports.metrics`            | ClickHouse service metrics port                                                                                                  | `8001`                   |
| `externalAccess.service.loadBalancerIPs`          | Array of load balancer IPs for each ClickHouse . Length must be the same as replicaCount                                         | `[]`                     |
| `externalAccess.service.loadBalancerAnnotations`  | Array of load balancer annotations for each ClickHouse . Length must be the same as shards multiplied by replicaCount            | `[]`                     |
| `externalAccess.service.loadBalancerSourceRanges` | Address(es) that are allowed when service is LoadBalancer                                                                        | `[]`                     |
| `externalAccess.service.nodePorts.http`           | Node port for HTTP                                                                                                               | `[]`                     |
| `externalAccess.service.nodePorts.https`          | Node port for HTTPS                                                                                                              | `[]`                     |
| `externalAccess.service.nodePorts.tcp`            | Node port for TCP                                                                                                                | `[]`                     |
| `externalAccess.service.nodePorts.tcpSecure`      | Node port for TCP (with TLS)                                                                                                     | `[]`                     |
| `externalAccess.service.nodePorts.keeper`         | ClickHouse keeper TCP container port                                                                                             | `[]`                     |
| `externalAccess.service.nodePorts.keeperSecure`   | ClickHouse keeper TCP container port (with TLS)                                                                                  | `[]`                     |
| `externalAccess.service.nodePorts.keeperInter`    | ClickHouse keeper interserver TCP container port                                                                                 | `[]`                     |
| `externalAccess.service.nodePorts.mysql`          | Node port for MySQL                                                                                                              | `[]`                     |
| `externalAccess.service.nodePorts.postgresql`     | Node port for PostgreSQL                                                                                                         | `[]`                     |
| `externalAccess.service.nodePorts.interserver`    | Node port for Interserver                                                                                                        | `[]`                     |
| `externalAccess.service.nodePorts.metrics`        | Node port for metrics                                                                                                            | `[]`                     |
| `externalAccess.service.labels`                   | Service labels for external access                                                                                               | `{}`                     |
| `externalAccess.service.annotations`              | Service annotations for external access                                                                                          | `{}`                     |
| `externalAccess.service.extraPorts`               | Extra ports to expose in the ClickHouse external service                                                                         | `[]`                     |
| `ingress.enabled`                                 | Enable ingress record generation for ClickHouse                                                                                  | `false`                  |
| `ingress.pathType`                                | Ingress path type                                                                                                                | `ImplementationSpecific` |
| `ingress.apiVersion`                              | Force Ingress API version (automatically detected if not set)                                                                    | `""`                     |
| `ingress.hostname`                                | Default host for the ingress record                                                                                              | `clickhouse.local`       |
| `ingress.ingressClassName`                        | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                    | `""`                     |
| `ingress.path`                                    | Default path for the ingress record                                                                                              | `/`                      |
| `ingress.annotations`                             | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                     |
| `ingress.tls`                                     | Enable TLS configuration for the host defined at `ingress.hostname` parameter                                                    | `false`                  |
| `ingress.selfSigned`                              | Create a TLS secret for this ingress record using self-signed certificates generated by Helm                                     | `false`                  |
| `ingress.extraHosts`                              | An array with additional hostname(s) to be covered with the ingress record                                                       | `[]`                     |
| `ingress.extraPaths`                              | An array with additional arbitrary paths that may need to be added to the ingress under the main host                            | `[]`                     |
| `ingress.extraTls`                                | TLS configuration for additional hostname(s) to be covered with this ingress record                                              | `[]`                     |
| `ingress.secrets`                                 | Custom TLS certificates as secrets                                                                                               | `[]`                     |
| `ingress.extraRules`                              | Additional rules to be covered with this ingress record                                                                          | `[]`                     |

### Persistence Parameters

| Name                        | Description                                                             | Value               |
| --------------------------- | ----------------------------------------------------------------------- | ------------------- |
| `persistence.enabled`       | Enable persistence using Persistent Volume Claims                       | `true`              |
| `persistence.existingClaim` | Name of an existing PVC to use                                          | `""`                |
| `persistence.storageClass`  | Storage class of backing PVC                                            | `""`                |
| `persistence.labels`        | Persistent Volume Claim labels                                          | `{}`                |
| `persistence.annotations`   | Persistent Volume Claim annotations                                     | `{}`                |
| `persistence.accessModes`   | Persistent Volume Access Modes                                          | `["ReadWriteOnce"]` |
| `persistence.size`          | Size of data volume                                                     | `8Gi`               |
| `persistence.selector`      | Selector to match an existing Persistent Volume for ClickHouse data PVC | `{}`                |
| `persistence.dataSource`    | Custom PVC data source                                                  | `{}`                |

### Init Container Parameters

| Name                                                   | Description                                                                                     | Value                      |
| ------------------------------------------------------ | ----------------------------------------------------------------------------------------------- | -------------------------- |
| `volumePermissions.enabled`                            | Enable init container that changes the owner/group of the PV mount point to `runAsUser:fsGroup` | `false`                    |
| `volumePermissions.image.registry`                     | OS Shell + Utility image registry                                                               | `REGISTRY_NAME`            |
| `volumePermissions.image.repository`                   | OS Shell + Utility image repository                                                             | `REPOSITORY_NAME/os-shell` |
| `volumePermissions.image.pullPolicy`                   | OS Shell + Utility image pull policy                                                            | `IfNotPresent`             |
| `volumePermissions.image.pullSecrets`                  | OS Shell + Utility image pull secrets                                                           | `[]`                       |
| `volumePermissions.resources.limits`                   | The resources limits for the init container                                                     | `{}`                       |
| `volumePermissions.resources.requests`                 | The requested resources for the init container                                                  | `{}`                       |
| `volumePermissions.containerSecurityContext.runAsUser` | Set init container's Security Context runAsUser                                                 | `0`                        |

### Other Parameters

| Name                                          | Description                                                                                            | Value   |
| --------------------------------------------- | ------------------------------------------------------------------------------------------------------ | ------- |
| `serviceAccount.create`                       | Specifies whether a ServiceAccount should be created                                                   | `true`  |
| `serviceAccount.name`                         | The name of the ServiceAccount to use.                                                                 | `""`    |
| `serviceAccount.annotations`                  | Additional Service Account annotations (evaluated as a template)                                       | `{}`    |
| `serviceAccount.automountServiceAccountToken` | Automount service account token for the server service account                                         | `true`  |
| `metrics.enabled`                             | Enable the export of Prometheus metrics                                                                | `false` |
| `metrics.podAnnotations`                      | Annotations for metrics scraping                                                                       | `{}`    |
| `metrics.serviceMonitor.enabled`              | if `true`, creates a Prometheus Operator ServiceMonitor (also requires `metrics.enabled` to be `true`) | `false` |
| `metrics.serviceMonitor.namespace`            | Namespace in which Prometheus is running                                                               | `""`    |
| `metrics.serviceMonitor.annotations`          | Additional custom annotations for the ServiceMonitor                                                   | `{}`    |
| `metrics.serviceMonitor.labels`               | Extra labels for the ServiceMonitor                                                                    | `{}`    |
| `metrics.serviceMonitor.jobLabel`             | The name of the label on the target service to use as the job name in Prometheus                       | `""`    |
| `metrics.serviceMonitor.honorLabels`          | honorLabels chooses the metric's labels on collisions with target labels                               | `false` |
| `metrics.serviceMonitor.interval`             | Interval at which metrics should be scraped.                                                           | `""`    |
| `metrics.serviceMonitor.scrapeTimeout`        | Timeout after which the scrape is ended                                                                | `""`    |
| `metrics.serviceMonitor.metricRelabelings`    | Specify additional relabeling of metrics                                                               | `[]`    |
| `metrics.serviceMonitor.relabelings`          | Specify general relabeling                                                                             | `[]`    |
| `metrics.serviceMonitor.selector`             | Prometheus instance selector labels                                                                    | `{}`    |
| `metrics.prometheusRule.enabled`              | Create a PrometheusRule for Prometheus Operator                                                        | `false` |
| `metrics.prometheusRule.namespace`            | Namespace for the PrometheusRule Resource (defaults to the Release Namespace)                          | `""`    |
| `metrics.prometheusRule.additionalLabels`     | Additional labels that can be used so PrometheusRule will be discovered by Prometheus                  | `{}`    |
| `metrics.prometheusRule.rules`                | PrometheusRule definitions                                                                             | `[]`    |

### External Zookeeper paramaters

| Name                        | Description                               | Value  |
| --------------------------- | ----------------------------------------- | ------ |
| `externalZookeeper.servers` | List of external zookeeper servers to use | `[]`   |
| `externalZookeeper.port`    | Port of the Zookeeper servers             | `2888` |

### Zookeeper subchart parameters

| Name                             | Description                   | Value                       |
| -------------------------------- | ----------------------------- | --------------------------- |
| `zookeeper.enabled`              | Deploy Zookeeper subchart     | `true`                      |
| `zookeeper.replicaCount`         | Number of Zookeeper instances | `3`                         |
| `zookeeper.service.ports.client` | Zookeeper client port         | `2181`                      |
| `zookeeper.image.registry`       | Zookeeper image registry      | `REGISTRY_NAME`             |
| `zookeeper.image.repository`     | Zookeeper image repository    | `REPOSITORY_NAME/zookeeper` |
| `zookeeper.image.pullPolicy`     | Zookeeper image pull policy   | `IfNotPresent`              |

See <https://github.com/bitnami-labs/readme-generator-for-helm> to create the table.

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
> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### ClickHouse keeper support

You can set `keeper.enabled` to use ClickHouse keeper. If `keeper.enabled=true`, Zookeeper settings will not be ignore.

### External Zookeeper support

You may want to have ClickHouse connect to an external zookeeper rather than installing one inside your cluster. Typical reasons for this are to use a managed database service, or to share a common database server for all your applications. To achieve this, the chart allows you to specify credentials for an external database with the [`externalZookeeper` parameter](#parameters). You should also disable the Zookeeper installation with the `zookeeper.enabled` option. Here is an example:

```console
zookeper.enabled=false
externalZookeeper.host=myexternalhost
externalZookeeper.user=myuser
externalZookeeper.password=mypassword
externalZookeeper.database=mydatabase
externalZookeeper.port=3306
```

### TLS secrets

The chart also facilitates the creation of TLS secrets for use with the Ingress controller, with different options for certificate management. [Learn more about TLS secrets](https://docs.bitnami.com/kubernetes/infrastructure/clickhouse/administration/enable-tls-ingress/)).

## Persistence

The [Bitnami ClickHouse](https://github.com/bitnami/containers/tree/main/bitnami/clickhouse) image stores the ClickHouse data and configurations at the `/bitnami` path of the container. Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.

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

If additional containers are needed in the same pod as ClickHouse (such as additional metrics or logging exporters), they can be defined using the `sidecars` parameter. If these sidecars export extra ports, extra port definitions can be added using the `service.extraPorts` parameter. [Learn more about configuring and using sidecar containers](https://docs.bitnami.com/kubernetes/infrastructure/clickhouse/configuration/configure-sidecar-init-containers/).

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

If your cluster allows automatic creation/retrieval of TLS certificates (e.g. [kube-lego](https://github.com/jetstack/kube-lego)), please refer to the documentation for that mechanism.

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

### Using custom scripts

For advanced operations, the Bitnami ClickHouse chart allows using custom init and start scripts that will be mounted in `/docker-entrypoint.initdb.d` and `/docker-entrypoint.startdb.d` . The `init` scripts will be run on the first boot whereas the `start` scripts will be run on every container start. For adding the scripts directly as values use the `initdbScripts` and `startdbScripts` values. For using Secrets use the `initdbScriptsSecret` and `startdbScriptsSecret`.

```yaml
initdbScriptsSecret: init-scripts-secret
startdbScriptsSecret: start-scripts-secret
```

### Pod affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, use one of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 2.0.0

This major updates the Zookeeper subchart to it newest major, 11.0.0. For more information on this subchart's major, please refer to [zookeeper upgrade notes](https://github.com/bitnami/charts/tree/main/bitnami/zookeeper#to-1100).

## License

Copyright &copy; 2023 VMware, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

<http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.