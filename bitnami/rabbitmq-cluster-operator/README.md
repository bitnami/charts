<!--- app-name: RabbitMQ Cluster Operator -->

# Bitnami package for RabbitMQ Cluster Operator

The RabbitMQ Cluster Kubernetes Operator automates provisioning, management, and operations of RabbitMQ clusters running on Kubernetes.

[Overview of RabbitMQ Cluster Operator](https://github.com/rabbitmq/cluster-operator)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/rabbitmq-cluster-operator
```

Looking to use RabbitMQ Cluster Operator in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the enterprise edition of Bitnami Application Catalog.

## Introduction

Bitnami charts for Helm are carefully engineered, actively maintained and are the quickest and easiest way to deploy containers on a Kubernetes cluster that are ready to handle production workloads.

This chart bootstraps a [RabbitMQ Cluster Operator](https://www.rabbitmq.com/kubernetes/operator/operator-overview.html) Deployment in a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/rabbitmq-cluster-operator
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The command deploy the RabbitMQ Cluster Kubernetes Operator on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Differences between the Bitnami RabbitMQ chart and the Bitnami RabbitMQ Operator chart

In the Bitnami catalog we offer both the *bitnami/rabbitmq* and *bitnami/rabbitmq-operator* charts. Each solution covers different needs and use cases.

The *bitnami/rabbitmq* chart deploys a single RabbitMQ installation using a Kubernetes StatefulSet object (together with Services, PVCs, ConfigMaps, etc.). The figure below shows the deployed objects in the cluster after executing *helm install*:

```text
                    +--------------+             +-----+
                    |              |             |     |
 Service            |   RabbitMQ   +<------------+ PVC |
<-------------------+              |             |     |
                    |  StatefulSet |             +-----+
                    |              |
                    +-----------+--+
                                ^                +------------+
                                |                |            |
                                +----------------+ Configmaps |
                                                 | Secrets    |
                                                 +------------+

```

Its lifecycle is managed using Helm and, at the RabbitMQ container level, the following operations are automated: persistence management, configuration based on environment variables and plugin initialization. The StatefulSet do not require any ServiceAccounts with special RBAC privileges so this solution would fit better in more restricted Kubernetes installations.

The *bitnami/rabbitmq-operator* chart deploys a RabbitMQ Operator installation using a Kubernetes Deployment.  The figure below shows the RabbitMQ operator deployment after executing *helm install*:

```text
+--------------------+
|                    |      +---------------+
|  RabbitMQ Operator |      |               |
|                    |      |     RBAC      |
|     Deployment     |      | Privileges    |
+-------+------------+      +-------+-------+
        ^                           |
        |   +-----------------+     |
        +---+ Service Account +<----+
            +-----------------+
```

The operator will extend the Kubernetes API with the following object: *RabbitmqCluster*. From that moment, the user will be able to deploy objects of these kinds and the previously deployed Operator will take care of deploying all the required StatefulSets, ConfigMaps and Services for running a RabbitMQ instance. Its lifecycle is managed using *kubectl* on the RabbitmqCluster objects. The following figure shows the deployed objects after deploying a *RabbitmqCluster* object using *kubectl*:

```text
  +--------------------+
  |                    |      +---------------+
  |  RabbitMQ Operator |      |               |
  |                    |      |     RBAC      |
  |     Deployment     |      | Privileges    |
  +-------+------------+      +-------+-------+
  |     ^                           |
  |     |   +-----------------+     |
  |     +---+ Service Account +<----+
  |         +-----------------+
  |
  |
  |
  |
  |    -------------------------------------------------------------------------
  |    |                                                                       |
  |    |                        +--------------+             +-----+           |
  |    |                        |              |             |     |           |
  |--->|     Service            |   RabbitMQ   +<------------+ PVC |           |
       |    <-------------------+              |             |     |           |
       |                        |  StatefulSet |             +-----+           |
       |                        |              |                               |
       |                        +-----------+--+                               |
       |                                    ^                +------------+    |
       |                                    |                |            |    |
       |                                    +----------------+ Configmaps |    |
       |                                                     | Secrets    |    |
       |                                                     +------------+    |
       |                                                                       |
       |                                                                       |
       -------------------------------------------------------------------------

```

This solution allows to easily deploy multiple RabbitMQ instances compared to the *bitnami/rabbitmq* chart. As the operator automatically deploys RabbitMQ installations, the RabbitMQ Operator pods will require a ServiceAccount with privileges to create and destroy multiple Kubernetes objects. This may be problematic for Kubernetes clusters with strict role-based access policies.

## Parameters

### Global parameters

| Name                      | Description                                     | Value |
| ------------------------- | ----------------------------------------------- | ----- |
| `global.imageRegistry`    | Global Docker image registry                    | `""`  |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]`  |
| `global.storageClass`     | Global StorageClass for Persistent Volume(s)    | `""`  |

### Common parameters

| Name                     | Description                                          | Value           |
| ------------------------ | ---------------------------------------------------- | --------------- |
| `kubeVersion`            | Override Kubernetes version                          | `""`            |
| `nameOverride`           | String to partially override common.names.fullname   | `""`            |
| `fullnameOverride`       | String to fully override common.names.fullname       | `""`            |
| `commonLabels`           | Labels to add to all deployed objects                | `{}`            |
| `commonAnnotations`      | Annotations to add to all deployed objects           | `{}`            |
| `clusterDomain`          | Kubernetes cluster domain name                       | `cluster.local` |
| `extraDeploy`            | Array of extra objects to deploy with the release    | `[]`            |
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled) | `false`         |

### RabbitMQ Cluster Operator Parameters

| Name                                                                | Description                                                                                                                              | Value                                            |
| ------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------ |
| `rabbitmqImage.registry`                                            | RabbitMQ Image registry                                                                                                                  | `REGISTRY_NAME`                                  |
| `rabbitmqImage.repository`                                          | RabbitMQ Image repository                                                                                                                | `REPOSITORY_NAME/rabbitmq`                       |
| `rabbitmqImage.digest`                                              | RabbitMQ image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                 | `""`                                             |
| `rabbitmqImage.pullSecrets`                                         | RabbitMQ Image pull secrets                                                                                                              | `[]`                                             |
| `credentialUpdaterImage.registry`                                   | RabbitMQ Default User Credential Updater image registry                                                                                  | `REGISTRY_NAME`                                  |
| `credentialUpdaterImage.repository`                                 | RabbitMQ Default User Credential Updater image repository                                                                                | `REPOSITORY_NAME/rmq-default-credential-updater` |
| `credentialUpdaterImage.digest`                                     | RabbitMQ Default User Credential Updater image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag | `""`                                             |
| `credentialUpdaterImage.pullSecrets`                                | RabbitMQ Default User Credential Updater image pull secrets                                                                              | `[]`                                             |
| `clusterOperator.image.registry`                                    | RabbitMQ Cluster Operator image registry                                                                                                 | `REGISTRY_NAME`                                  |
| `clusterOperator.image.repository`                                  | RabbitMQ Cluster Operator image repository                                                                                               | `REPOSITORY_NAME/rabbitmq-cluster-operator`      |
| `clusterOperator.image.digest`                                      | RabbitMQ Cluster Operator image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                | `""`                                             |
| `clusterOperator.image.pullPolicy`                                  | RabbitMQ Cluster Operator image pull policy                                                                                              | `IfNotPresent`                                   |
| `clusterOperator.image.pullSecrets`                                 | RabbitMQ Cluster Operator image pull secrets                                                                                             | `[]`                                             |
| `clusterOperator.replicaCount`                                      | Number of RabbitMQ Cluster Operator replicas to deploy                                                                                   | `1`                                              |
| `clusterOperator.schedulerName`                                     | Alternative scheduler                                                                                                                    | `""`                                             |
| `clusterOperator.topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment                                                                                           | `[]`                                             |
| `clusterOperator.terminationGracePeriodSeconds`                     | In seconds, time the given to the %%MAIN_CONTAINER_NAME%% pod needs to terminate gracefully                                              | `""`                                             |
| `clusterOperator.livenessProbe.enabled`                             | Enable livenessProbe on RabbitMQ Cluster Operator nodes                                                                                  | `true`                                           |
| `clusterOperator.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                  | `5`                                              |
| `clusterOperator.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                         | `30`                                             |
| `clusterOperator.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                        | `5`                                              |
| `clusterOperator.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                      | `5`                                              |
| `clusterOperator.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                      | `1`                                              |
| `clusterOperator.readinessProbe.enabled`                            | Enable readinessProbe on RabbitMQ Cluster Operator nodes                                                                                 | `true`                                           |
| `clusterOperator.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                 | `5`                                              |
| `clusterOperator.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                        | `30`                                             |
| `clusterOperator.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                       | `5`                                              |
| `clusterOperator.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                     | `5`                                              |
| `clusterOperator.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                     | `1`                                              |
| `clusterOperator.startupProbe.enabled`                              | Enable startupProbe on RabbitMQ Cluster Operator nodes                                                                                   | `false`                                          |
| `clusterOperator.startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                   | `5`                                              |
| `clusterOperator.startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                          | `30`                                             |
| `clusterOperator.startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                         | `5`                                              |
| `clusterOperator.startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                       | `5`                                              |
| `clusterOperator.startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                       | `1`                                              |
| `clusterOperator.customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                                      | `{}`                                             |
| `clusterOperator.customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                                                     | `{}`                                             |
| `clusterOperator.customStartupProbe`                                | Custom startupProbe that overrides the default one                                                                                       | `{}`                                             |
| `clusterOperator.resources.limits`                                  | The resources limits for the RabbitMQ Cluster Operator containers                                                                        | `{}`                                             |
| `clusterOperator.resources.requests`                                | The requested resources for the RabbitMQ Cluster Operator containers                                                                     | `{}`                                             |
| `clusterOperator.podSecurityContext.enabled`                        | Enabled RabbitMQ Cluster Operator pods' Security Context                                                                                 | `true`                                           |
| `clusterOperator.podSecurityContext.fsGroup`                        | Set RabbitMQ Cluster Operator pod's Security Context fsGroup                                                                             | `1001`                                           |
| `clusterOperator.containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                                                     | `true`                                           |
| `clusterOperator.containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                               | `1001`                                           |
| `clusterOperator.containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                                            | `true`                                           |
| `clusterOperator.containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                                              | `false`                                          |
| `clusterOperator.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                  | `true`                                           |
| `clusterOperator.containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                                | `false`                                          |
| `clusterOperator.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                       | `["ALL"]`                                        |
| `clusterOperator.containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                         | `RuntimeDefault`                                 |
| `clusterOperator.command`                                           | Override default container command (useful when using custom images)                                                                     | `[]`                                             |
| `clusterOperator.args`                                              | Override default container args (useful when using custom images)                                                                        | `[]`                                             |
| `clusterOperator.hostAliases`                                       | RabbitMQ Cluster Operator pods host aliases                                                                                              | `[]`                                             |
| `clusterOperator.podLabels`                                         | Extra labels for RabbitMQ Cluster Operator pods                                                                                          | `{}`                                             |
| `clusterOperator.podAnnotations`                                    | Annotations for RabbitMQ Cluster Operator pods                                                                                           | `{}`                                             |
| `clusterOperator.podAffinityPreset`                                 | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                      | `""`                                             |
| `clusterOperator.podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                 | `soft`                                           |
| `clusterOperator.nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                | `""`                                             |
| `clusterOperator.nodeAffinityPreset.key`                            | Node label key to match. Ignored if `affinity` is set                                                                                    | `""`                                             |
| `clusterOperator.nodeAffinityPreset.values`                         | Node label values to match. Ignored if `affinity` is set                                                                                 | `[]`                                             |
| `clusterOperator.affinity`                                          | Affinity for RabbitMQ Cluster Operator pods assignment                                                                                   | `{}`                                             |
| `clusterOperator.nodeSelector`                                      | Node labels for RabbitMQ Cluster Operator pods assignment                                                                                | `{}`                                             |
| `clusterOperator.tolerations`                                       | Tolerations for RabbitMQ Cluster Operator pods assignment                                                                                | `[]`                                             |
| `clusterOperator.updateStrategy.type`                               | RabbitMQ Cluster Operator statefulset strategy type                                                                                      | `RollingUpdate`                                  |
| `clusterOperator.priorityClassName`                                 | RabbitMQ Cluster Operator pods' priorityClassName                                                                                        | `""`                                             |
| `clusterOperator.lifecycleHooks`                                    | for the RabbitMQ Cluster Operator container(s) to automate configuration before or after startup                                         | `{}`                                             |
| `clusterOperator.containerPorts.metrics`                            | RabbitMQ Cluster Operator container port (used for metrics)                                                                              | `9782`                                           |
| `clusterOperator.extraEnvVars`                                      | Array with extra environment variables to add to RabbitMQ Cluster Operator nodes                                                         | `[]`                                             |
| `clusterOperator.extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for RabbitMQ Cluster Operator nodes                                                 | `""`                                             |
| `clusterOperator.extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for RabbitMQ Cluster Operator nodes                                                    | `""`                                             |
| `clusterOperator.extraVolumes`                                      | Optionally specify extra list of additional volumes for the RabbitMQ Cluster Operator pod(s)                                             | `[]`                                             |
| `clusterOperator.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the RabbitMQ Cluster Operator container(s)                                  | `[]`                                             |
| `clusterOperator.sidecars`                                          | Add additional sidecar containers to the RabbitMQ Cluster Operator pod(s)                                                                | `[]`                                             |
| `clusterOperator.initContainers`                                    | Add additional init containers to the RabbitMQ Cluster Operator pod(s)                                                                   | `[]`                                             |
| `clusterOperator.rbac.create`                                       | Specifies whether RBAC resources should be created                                                                                       | `true`                                           |
| `clusterOperator.rbac.clusterRole.customRules`                      | Define custom access rules for the ClusterRole                                                                                           | `[]`                                             |
| `clusterOperator.serviceAccount.create`                             | Specifies whether a ServiceAccount should be created                                                                                     | `true`                                           |
| `clusterOperator.serviceAccount.name`                               | The name of the ServiceAccount to use.                                                                                                   | `""`                                             |
| `clusterOperator.serviceAccount.annotations`                        | Add annotations                                                                                                                          | `{}`                                             |
| `clusterOperator.serviceAccount.automountServiceAccountToken`       | Automount API credentials for a service account.                                                                                         | `true`                                           |

### RabbitMQ Cluster Operator Metrics parameters

| Name                                                       | Description                                                                        | Value                    |
| ---------------------------------------------------------- | ---------------------------------------------------------------------------------- | ------------------------ |
| `clusterOperator.metrics.service.enabled`                  | Create a service for accessing the metrics endpoint                                | `false`                  |
| `clusterOperator.metrics.service.type`                     | RabbitMQ Cluster Operator metrics service type                                     | `ClusterIP`              |
| `clusterOperator.metrics.service.ports.http`               | RabbitMQ Cluster Operator metrics service HTTP port                                | `80`                     |
| `clusterOperator.metrics.service.nodePorts.http`           | Node port for HTTP                                                                 | `""`                     |
| `clusterOperator.metrics.service.clusterIP`                | RabbitMQ Cluster Operator metrics service Cluster IP                               | `""`                     |
| `clusterOperator.metrics.service.extraPorts`               | Extra ports to expose (normally used with the `sidecar` value)                     | `[]`                     |
| `clusterOperator.metrics.service.loadBalancerIP`           | RabbitMQ Cluster Operator metrics service Load Balancer IP                         | `""`                     |
| `clusterOperator.metrics.service.loadBalancerSourceRanges` | RabbitMQ Cluster Operator metrics service Load Balancer sources                    | `[]`                     |
| `clusterOperator.metrics.service.externalTrafficPolicy`    | RabbitMQ Cluster Operator metrics service external traffic policy                  | `Cluster`                |
| `clusterOperator.metrics.service.annotations`              | Additional custom annotations for RabbitMQ Cluster Operator metrics service        | `{}`                     |
| `clusterOperator.metrics.service.sessionAffinity`          | Session Affinity for Kubernetes service, can be "None" or "ClientIP"               | `None`                   |
| `clusterOperator.metrics.service.sessionAffinityConfig`    | Additional settings for the sessionAffinity                                        | `{}`                     |
| `clusterOperator.metrics.serviceMonitor.enabled`           | Specify if a servicemonitor will be deployed for prometheus-operator               | `false`                  |
| `clusterOperator.metrics.serviceMonitor.namespace`         | Namespace which Prometheus is running in                                           | `""`                     |
| `clusterOperator.metrics.serviceMonitor.jobLabel`          | Specify the jobLabel to use for the prometheus-operator                            | `app.kubernetes.io/name` |
| `clusterOperator.metrics.serviceMonitor.honorLabels`       | Honor metrics labels                                                               | `false`                  |
| `clusterOperator.metrics.serviceMonitor.selector`          | Prometheus instance selector labels                                                | `{}`                     |
| `clusterOperator.metrics.serviceMonitor.scrapeTimeout`     | Timeout after which the scrape is ended                                            | `""`                     |
| `clusterOperator.metrics.serviceMonitor.interval`          | Scrape interval. If not set, the Prometheus default scrape interval is used        | `""`                     |
| `clusterOperator.metrics.serviceMonitor.metricRelabelings` | Specify additional relabeling of metrics                                           | `[]`                     |
| `clusterOperator.metrics.serviceMonitor.relabelings`       | Specify general relabeling                                                         | `[]`                     |
| `clusterOperator.metrics.serviceMonitor.labels`            | Extra labels for the ServiceMonitor                                                | `{}`                     |
| `clusterOperator.metrics.serviceMonitor.path`              | Define the path used by ServiceMonitor to scrap metrics                            | `""`                     |
| `clusterOperator.metrics.serviceMonitor.params`            | Define the HTTP URL parameters used by ServiceMonitor                              | `{}`                     |
| `clusterOperator.metrics.podMonitor.enabled`               | Create PodMonitor Resource for scraping metrics using PrometheusOperator           | `false`                  |
| `clusterOperator.metrics.podMonitor.jobLabel`              | Specify the jobLabel to use for the prometheus-operator                            | `app.kubernetes.io/name` |
| `clusterOperator.metrics.podMonitor.namespace`             | Namespace which Prometheus is running in                                           | `""`                     |
| `clusterOperator.metrics.podMonitor.honorLabels`           | Honor metrics labels                                                               | `false`                  |
| `clusterOperator.metrics.podMonitor.selector`              | Prometheus instance selector labels                                                | `{}`                     |
| `clusterOperator.metrics.podMonitor.interval`              | Specify the interval at which metrics should be scraped                            | `30s`                    |
| `clusterOperator.metrics.podMonitor.scrapeTimeout`         | Specify the timeout after which the scrape is ended                                | `30s`                    |
| `clusterOperator.metrics.podMonitor.additionalLabels`      | Additional labels that can be used so PodMonitors will be discovered by Prometheus | `{}`                     |
| `clusterOperator.metrics.podMonitor.path`                  | Define HTTP path to scrape for metrics.                                            | `""`                     |
| `clusterOperator.metrics.podMonitor.relabelings`           | Specify general relabeling                                                         | `[]`                     |
| `clusterOperator.metrics.podMonitor.metricRelabelings`     | Specify additional relabeling of metrics                                           | `[]`                     |
| `clusterOperator.metrics.podMonitor.params`                | Define the HTTP URL parameters used by PodMonitor                                  | `{}`                     |

### RabbitMQ Messaging Topology Operator Parameters

| Name                                                                    | Description                                                                                                                          | Value                                             |
| ----------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------- |
| `msgTopologyOperator.enabled`                                           | Deploy RabbitMQ Messaging Topology Operator as part of the installation                                                              | `true`                                            |
| `msgTopologyOperator.image.registry`                                    | RabbitMQ Messaging Topology Operator image registry                                                                                  | `REGISTRY_NAME`                                   |
| `msgTopologyOperator.image.repository`                                  | RabbitMQ Messaging Topology Operator image repository                                                                                | `REPOSITORY_NAME/rmq-messaging-topology-operator` |
| `msgTopologyOperator.image.digest`                                      | RabbitMQ Messaging Topology Operator image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag | `""`                                              |
| `msgTopologyOperator.image.pullPolicy`                                  | RabbitMQ Messaging Topology Operator image pull policy                                                                               | `IfNotPresent`                                    |
| `msgTopologyOperator.image.pullSecrets`                                 | RabbitMQ Messaging Topology Operator image pull secrets                                                                              | `[]`                                              |
| `msgTopologyOperator.replicaCount`                                      | Number of RabbitMQ Messaging Topology Operator replicas to deploy                                                                    | `1`                                               |
| `msgTopologyOperator.topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment                                                                                       | `[]`                                              |
| `msgTopologyOperator.schedulerName`                                     | Alternative scheduler                                                                                                                | `""`                                              |
| `msgTopologyOperator.terminationGracePeriodSeconds`                     | In seconds, time the given to the %%MAIN_CONTAINER_NAME%% pod needs to terminate gracefully                                          | `""`                                              |
| `msgTopologyOperator.hostNetwork`                                       | Boolean                                                                                                                              | `false`                                           |
| `msgTopologyOperator.dnsPolicy`                                         | Alternative DNS policy                                                                                                               | `ClusterFirst`                                    |
| `msgTopologyOperator.livenessProbe.enabled`                             | Enable livenessProbe on RabbitMQ Messaging Topology Operator nodes                                                                   | `true`                                            |
| `msgTopologyOperator.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                              | `5`                                               |
| `msgTopologyOperator.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                     | `30`                                              |
| `msgTopologyOperator.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                    | `5`                                               |
| `msgTopologyOperator.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                  | `5`                                               |
| `msgTopologyOperator.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                  | `1`                                               |
| `msgTopologyOperator.readinessProbe.enabled`                            | Enable readinessProbe on RabbitMQ Messaging Topology Operator nodes                                                                  | `true`                                            |
| `msgTopologyOperator.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                             | `5`                                               |
| `msgTopologyOperator.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                    | `30`                                              |
| `msgTopologyOperator.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                   | `5`                                               |
| `msgTopologyOperator.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                 | `5`                                               |
| `msgTopologyOperator.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                 | `1`                                               |
| `msgTopologyOperator.startupProbe.enabled`                              | Enable startupProbe on RabbitMQ Messaging Topology Operator nodes                                                                    | `false`                                           |
| `msgTopologyOperator.startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                               | `5`                                               |
| `msgTopologyOperator.startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                      | `30`                                              |
| `msgTopologyOperator.startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                     | `5`                                               |
| `msgTopologyOperator.startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                   | `5`                                               |
| `msgTopologyOperator.startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                   | `1`                                               |
| `msgTopologyOperator.customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                                  | `{}`                                              |
| `msgTopologyOperator.customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                                                 | `{}`                                              |
| `msgTopologyOperator.customStartupProbe`                                | Custom startupProbe that overrides the default one                                                                                   | `{}`                                              |
| `msgTopologyOperator.existingWebhookCertSecret`                         | name of a secret containing the certificates (use it to avoid certManager creating one)                                              | `""`                                              |
| `msgTopologyOperator.existingWebhookCertCABundle`                       | PEM-encoded CA Bundle of the existing secret provided in existingWebhookCertSecret (only if useCertManager=false)                    | `""`                                              |
| `msgTopologyOperator.resources.limits`                                  | The resources limits for the RabbitMQ Messaging Topology Operator containers                                                         | `{}`                                              |
| `msgTopologyOperator.resources.requests`                                | The requested resources for the RabbitMQ Messaging Topology Operator containers                                                      | `{}`                                              |
| `msgTopologyOperator.podSecurityContext.enabled`                        | Enabled RabbitMQ Messaging Topology Operator pods' Security Context                                                                  | `true`                                            |
| `msgTopologyOperator.podSecurityContext.fsGroup`                        | Set RabbitMQ Messaging Topology Operator pod's Security Context fsGroup                                                              | `1001`                                            |
| `msgTopologyOperator.containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                                                 | `true`                                            |
| `msgTopologyOperator.containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                           | `1001`                                            |
| `msgTopologyOperator.containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                                        | `true`                                            |
| `msgTopologyOperator.containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                                          | `false`                                           |
| `msgTopologyOperator.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                              | `true`                                            |
| `msgTopologyOperator.containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                            | `false`                                           |
| `msgTopologyOperator.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                   | `["ALL"]`                                         |
| `msgTopologyOperator.containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                     | `RuntimeDefault`                                  |
| `msgTopologyOperator.fullnameOverride`                                  | String to fully override rmqco.msgTopologyOperator.fullname template                                                                 | `""`                                              |
| `msgTopologyOperator.command`                                           | Override default container command (useful when using custom images)                                                                 | `[]`                                              |
| `msgTopologyOperator.args`                                              | Override default container args (useful when using custom images)                                                                    | `[]`                                              |
| `msgTopologyOperator.hostAliases`                                       | RabbitMQ Messaging Topology Operator pods host aliases                                                                               | `[]`                                              |
| `msgTopologyOperator.podLabels`                                         | Extra labels for RabbitMQ Messaging Topology Operator pods                                                                           | `{}`                                              |
| `msgTopologyOperator.podAnnotations`                                    | Annotations for RabbitMQ Messaging Topology Operator pods                                                                            | `{}`                                              |
| `msgTopologyOperator.podAffinityPreset`                                 | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                  | `""`                                              |
| `msgTopologyOperator.podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                             | `soft`                                            |
| `msgTopologyOperator.nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                            | `""`                                              |
| `msgTopologyOperator.nodeAffinityPreset.key`                            | Node label key to match. Ignored if `affinity` is set                                                                                | `""`                                              |
| `msgTopologyOperator.nodeAffinityPreset.values`                         | Node label values to match. Ignored if `affinity` is set                                                                             | `[]`                                              |
| `msgTopologyOperator.affinity`                                          | Affinity for RabbitMQ Messaging Topology Operator pods assignment                                                                    | `{}`                                              |
| `msgTopologyOperator.nodeSelector`                                      | Node labels for RabbitMQ Messaging Topology Operator pods assignment                                                                 | `{}`                                              |
| `msgTopologyOperator.tolerations`                                       | Tolerations for RabbitMQ Messaging Topology Operator pods assignment                                                                 | `[]`                                              |
| `msgTopologyOperator.updateStrategy.type`                               | RabbitMQ Messaging Topology Operator statefulset strategy type                                                                       | `RollingUpdate`                                   |
| `msgTopologyOperator.priorityClassName`                                 | RabbitMQ Messaging Topology Operator pods' priorityClassName                                                                         | `""`                                              |
| `msgTopologyOperator.lifecycleHooks`                                    | for the RabbitMQ Messaging Topology Operator container(s) to automate configuration before or after startup                          | `{}`                                              |
| `msgTopologyOperator.containerPorts.metrics`                            | RabbitMQ Messaging Topology Operator container port (used for metrics)                                                               | `8080`                                            |
| `msgTopologyOperator.extraEnvVars`                                      | Array with extra environment variables to add to RabbitMQ Messaging Topology Operator nodes                                          | `[]`                                              |
| `msgTopologyOperator.extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for RabbitMQ Messaging Topology Operator nodes                                  | `""`                                              |
| `msgTopologyOperator.extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for RabbitMQ Messaging Topology Operator nodes                                     | `""`                                              |
| `msgTopologyOperator.extraVolumes`                                      | Optionally specify extra list of additional volumes for the RabbitMQ Messaging Topology Operator pod(s)                              | `[]`                                              |
| `msgTopologyOperator.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the RabbitMQ Messaging Topology Operator container(s)                   | `[]`                                              |
| `msgTopologyOperator.sidecars`                                          | Add additional sidecar containers to the RabbitMQ Messaging Topology Operator pod(s)                                                 | `[]`                                              |
| `msgTopologyOperator.initContainers`                                    | Add additional init containers to the RabbitMQ Messaging Topology Operator pod(s)                                                    | `[]`                                              |
| `msgTopologyOperator.service.type`                                      | RabbitMQ Messaging Topology Operator webhook service type                                                                            | `ClusterIP`                                       |
| `msgTopologyOperator.service.ports.webhook`                             | RabbitMQ Messaging Topology Operator webhook service HTTP port                                                                       | `443`                                             |
| `msgTopologyOperator.service.nodePorts.http`                            | Node port for HTTP                                                                                                                   | `""`                                              |
| `msgTopologyOperator.service.clusterIP`                                 | RabbitMQ Messaging Topology Operator webhook service Cluster IP                                                                      | `""`                                              |
| `msgTopologyOperator.service.loadBalancerIP`                            | RabbitMQ Messaging Topology Operator webhook service Load Balancer IP                                                                | `""`                                              |
| `msgTopologyOperator.service.extraPorts`                                | Extra ports to expose (normally used with the `sidecar` value)                                                                       | `[]`                                              |
| `msgTopologyOperator.service.loadBalancerSourceRanges`                  | RabbitMQ Messaging Topology Operator webhook service Load Balancer sources                                                           | `[]`                                              |
| `msgTopologyOperator.service.externalTrafficPolicy`                     | RabbitMQ Messaging Topology Operator webhook service external traffic policy                                                         | `Cluster`                                         |
| `msgTopologyOperator.service.annotations`                               | Additional custom annotations for RabbitMQ Messaging Topology Operator webhook service                                               | `{}`                                              |
| `msgTopologyOperator.service.sessionAffinity`                           | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                                                                 | `None`                                            |
| `msgTopologyOperator.service.sessionAffinityConfig`                     | Additional settings for the sessionAffinity                                                                                          | `{}`                                              |
| `msgTopologyOperator.rbac.create`                                       | Specifies whether RBAC resources should be created                                                                                   | `true`                                            |
| `msgTopologyOperator.serviceAccount.create`                             | Specifies whether a ServiceAccount should be created                                                                                 | `true`                                            |
| `msgTopologyOperator.serviceAccount.name`                               | The name of the ServiceAccount to use.                                                                                               | `""`                                              |
| `msgTopologyOperator.serviceAccount.annotations`                        | Add annotations                                                                                                                      | `{}`                                              |
| `msgTopologyOperator.serviceAccount.automountServiceAccountToken`       | Automount API credentials for a service account.                                                                                     | `true`                                            |

### RabbitMQ Messaging Topology Operator parameters

| Name                                                           | Description                                                                        | Value                    |
| -------------------------------------------------------------- | ---------------------------------------------------------------------------------- | ------------------------ |
| `msgTopologyOperator.metrics.service.enabled`                  | Create a service for accessing the metrics endpoint                                | `false`                  |
| `msgTopologyOperator.metrics.service.type`                     | RabbitMQ Cluster Operator metrics service type                                     | `ClusterIP`              |
| `msgTopologyOperator.metrics.service.ports.http`               | RabbitMQ Cluster Operator metrics service HTTP port                                | `80`                     |
| `msgTopologyOperator.metrics.service.nodePorts.http`           | Node port for HTTP                                                                 | `""`                     |
| `msgTopologyOperator.metrics.service.clusterIP`                | RabbitMQ Cluster Operator metrics service Cluster IP                               | `""`                     |
| `msgTopologyOperator.metrics.service.extraPorts`               | Extra ports to expose (normally used with the `sidecar` value)                     | `[]`                     |
| `msgTopologyOperator.metrics.service.loadBalancerIP`           | RabbitMQ Cluster Operator metrics service Load Balancer IP                         | `""`                     |
| `msgTopologyOperator.metrics.service.loadBalancerSourceRanges` | RabbitMQ Cluster Operator metrics service Load Balancer sources                    | `[]`                     |
| `msgTopologyOperator.metrics.service.externalTrafficPolicy`    | RabbitMQ Cluster Operator metrics service external traffic policy                  | `Cluster`                |
| `msgTopologyOperator.metrics.service.annotations`              | Additional custom annotations for RabbitMQ Cluster Operator metrics service        | `{}`                     |
| `msgTopologyOperator.metrics.service.sessionAffinity`          | Session Affinity for Kubernetes service, can be "None" or "ClientIP"               | `None`                   |
| `msgTopologyOperator.metrics.service.sessionAffinityConfig`    | Additional settings for the sessionAffinity                                        | `{}`                     |
| `msgTopologyOperator.metrics.serviceMonitor.enabled`           | Specify if a servicemonitor will be deployed for prometheus-operator               | `false`                  |
| `msgTopologyOperator.metrics.serviceMonitor.namespace`         | Namespace which Prometheus is running in                                           | `""`                     |
| `msgTopologyOperator.metrics.serviceMonitor.jobLabel`          | Specify the jobLabel to use for the prometheus-operator                            | `app.kubernetes.io/name` |
| `msgTopologyOperator.metrics.serviceMonitor.selector`          | Prometheus instance selector labels                                                | `{}`                     |
| `msgTopologyOperator.metrics.serviceMonitor.honorLabels`       | Honor metrics labels                                                               | `false`                  |
| `msgTopologyOperator.metrics.serviceMonitor.scrapeTimeout`     | Timeout after which the scrape is ended                                            | `""`                     |
| `msgTopologyOperator.metrics.serviceMonitor.interval`          | Scrape interval. If not set, the Prometheus default scrape interval is used        | `""`                     |
| `msgTopologyOperator.metrics.serviceMonitor.metricRelabelings` | Specify additional relabeling of metrics                                           | `[]`                     |
| `msgTopologyOperator.metrics.serviceMonitor.relabelings`       | Specify general relabeling                                                         | `[]`                     |
| `msgTopologyOperator.metrics.serviceMonitor.labels`            | Extra labels for the ServiceMonitor                                                | `{}`                     |
| `msgTopologyOperator.metrics.podMonitor.enabled`               | Create PodMonitor Resource for scraping metrics using PrometheusOperator           | `false`                  |
| `msgTopologyOperator.metrics.podMonitor.jobLabel`              | Specify the jobLabel to use for the prometheus-operator                            | `app.kubernetes.io/name` |
| `msgTopologyOperator.metrics.podMonitor.namespace`             | Namespace which Prometheus is running in                                           | `""`                     |
| `msgTopologyOperator.metrics.podMonitor.honorLabels`           | Honor metrics labels                                                               | `false`                  |
| `msgTopologyOperator.metrics.podMonitor.selector`              | Prometheus instance selector labels                                                | `{}`                     |
| `msgTopologyOperator.metrics.podMonitor.interval`              | Specify the interval at which metrics should be scraped                            | `30s`                    |
| `msgTopologyOperator.metrics.podMonitor.scrapeTimeout`         | Specify the timeout after which the scrape is ended                                | `30s`                    |
| `msgTopologyOperator.metrics.podMonitor.additionalLabels`      | Additional labels that can be used so PodMonitors will be discovered by Prometheus | `{}`                     |
| `msgTopologyOperator.metrics.podMonitor.relabelings`           | Specify general relabeling                                                         | `[]`                     |
| `msgTopologyOperator.metrics.podMonitor.metricRelabelings`     | Specify additional relabeling of metrics                                           | `[]`                     |

### cert-manager parameters

| Name             | Description                                                       | Value   |
| ---------------- | ----------------------------------------------------------------- | ------- |
| `useCertManager` | Deploy cert-manager objects (Issuer and Certificate) for webhooks | `false` |

The above parameters map to the env variables defined in [bitnami/rabbitmq-cluster-operator](https://github.com/bitnami/containers/tree/main/bitnami/rabbitmq-cluster-operator). For more information please refer to the [bitnami/rabbitmq-cluster-operator](https://github.com/bitnami/containers/tree/main/bitnami/rabbitmq-cluster-operator) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
  --set livenessProbe.enabled=false \
    oci://REGISTRY_NAME/REPOSITORY_NAME/rabbitmq-cluster-operator
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The above command disables the Operator liveness probes.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml oci://REGISTRY_NAME/REPOSITORY_NAME/rabbitmq-cluster-operator
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.
> **Tip**: You can use the default [values.yaml](https://github.com/bitnami/charts/tree/main/bitnami/rabbitmq-cluster-operator/values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Additional environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `extraEnvVars` property.

```yaml
rabbitmq-cluster-operator:
  extraEnvVars:
    - name: LOG_LEVEL
      value: error
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values.

### Sidecars

If additional containers are needed in the same pod as rabbitmq-cluster-operator (such as additional metrics or logging exporters), they can be defined using the `sidecars` parameter. If these sidecars export extra ports, extra port definitions can be added using the `service.extraPorts` parameter. [Learn more about configuring and using sidecar containers](https://docs.bitnami.com/kubernetes/infrastructure/rabbitmq-cluster-operator/configuration/configure-sidecar-init-containers/).

### Pod affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, use one of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

### Deploying extra resources

There are cases where you may want to deploy extra objects, such your custom *RabbitmqCluster* objects. For covering this case, the chart allows adding the full specification of other objects using the `extraDeploy` parameter.

For instance, to deploy your custom *RabbitmqCluster* definition, you can install the RabbitMQ Cluster Operator using the values below:

```yaml
extraDeploy:
  - apiVersion: rabbitmq.com/v1beta1
    kind: RabbitmqCluster
    metadata:
      name: rabbitmq-custom-configuration
    spec:
      replicas: 1
      rabbitmq:
        additionalConfig: |
          log.console.level = debug
```

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### Upgrading CRDs

By design, the `helm upgrade` command will not upgrade the `CustomResourceDefinition` objects, as stated in their [official documentation](https://helm.sh/docs/chart_best_practices/custom_resource_definitions/#some-caveats-and-explanations). This is done to avoid the potential risks of upgrading CRD objects, such as data loss.

In order to upgrade the CRD objects, perform the following steps:

- Perform a backup of your running RabbitMQ instances following the [official documentation](https://www.rabbitmq.com/backup.html).

- Execute the following commands (replace the VERSION placeholder):

```console
helm fetch bitnami/rabbitmq-cluster-operator --version VERSION
tar xf rabbitmq-cluster-operator-VERSION.tar.gz
kubectl apply -f rabbitmq-cluster-operator/crds
```

### To 2.0.0

This new version adds the following components:

- RabbitMQ Messaging Topology Operator: all the settings are inside the `msgTopologyOperator` section.
- RabbitMQ Default User Credential Updater sidecar: this enables Hashicorp Vault integration for all `RabbitMQCluster` instances.
- `cert-manager` subchart: this is necessary for the RabbitMQ Messaging Topology Webhooks to work.

As a breaking change, all `rabbitmq-cluster-operator` deployment values were moved to the `clusterOperator` section.

No issues are expected during upgrades.

### To 1.0.0

The CRD was updated according to the latest changes in the upstream project. Thanks to the improvements in the latest changes, the CRD is not templated anymore and can be placed under the `crds` directory following [Helm best practices for CRDS](https://helm.sh/docs/chart_best_practices/custom_resource_definitions/).

You need to manually delete the old CRD before upgrading the release.

```console
kubectl delete crd rabbitmqclusters.rabbitmq.com
helm upgrade my-release oci://REGISTRY_NAME/REPOSITORY_NAME/rabbitmq-cluster-operator
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

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