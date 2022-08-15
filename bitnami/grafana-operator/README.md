<!--- app-name: Grafana Operator -->

# Grafana Operator packaged by Bitnami

Grafana Operator is a Kubernetes operator that enables the installation and management of Grafana instances, dashboards and plugins.

[Overview of Grafana Operator](https://github.com/integr8ly/grafana-operator)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/grafana-operator
```

## Introduction

Bitnami charts for Helm are carefully engineered, actively maintained and are the quickest and easiest way to deploy containers on a Kubernetes cluster that are ready to handle production workloads.

This chart bootstraps a [Grafana Operator](https://github.com/integr8ly/grafana-operator/blob/master/documentation/deploy_grafana.md) Deployment [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/grafana-operator
```

These commands deploy grafana-operator on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` helm release:

```console
$ helm uninstall my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

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
| `global.imageRegistry`    | Global Docker image registry                    | `""`  |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]`  |


### Common parameters

| Name                | Description                                                                                               | Value           |
| ------------------- | --------------------------------------------------------------------------------------------------------- | --------------- |
| `kubeVersion`       | Force target Kubernetes version (using Helm capabilities if not set)                                      | `""`            |
| `nameOverride`      | String to partially override common.names.fullname template with a string (will prepend the release name) | `""`            |
| `fullnameOverride`  | String to fully override common.names.fullname template with a string                                     | `""`            |
| `namespaceOverride` | String to fully override common.names.namespace                                                           | `""`            |
| `extraDeploy`       | Array of extra objects to deploy with the release                                                         | `[]`            |
| `commonLabels`      | Common Labels which are applied to every resource deployed                                                | `{}`            |
| `commonAnnotations` | Common Annotations which are applied to every ressource deployed                                          | `{}`            |
| `clusterDomain`     | Kubernetes cluster domain name                                                                            | `cluster.local` |


### Grafana Operator parameters

| Name                                                         | Description                                                                                                                               | Value                      |
| ------------------------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------- | -------------------------- |
| `operator.enabled`                                           | Enable the deployment of the Grafana Operator                                                                                             | `true`                     |
| `operator.command`                                           | Default container command (useful when using custom images)                                                                               | `[]`                       |
| `operator.args`                                              | Default container args (useful when using custom images)                                                                                  | `[]`                       |
| `operator.schedulerName`                                     | Alternative scheduler                                                                                                                     | `""`                       |
| `operator.lifecycleHooks`                                    | for the grafana-operator container to automate configuration before or after startup                                                      | `{}`                       |
| `operator.replicaCount`                                      | Number of grafana-operator Pod replicas                                                                                                   | `1`                        |
| `operator.customLivenessProbe`                               | Override default liveness probe                                                                                                           | `{}`                       |
| `operator.customReadinessProbe`                              | Override default readiness probe                                                                                                          | `{}`                       |
| `operator.customStartupProbe`                                | Override default startup probe                                                                                                            | `{}`                       |
| `operator.extraVolumes`                                      | Optionally specify extra list of additional volumes for etcd pods                                                                         | `[]`                       |
| `operator.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for etcd container(s)                                                            | `[]`                       |
| `operator.initContainers`                                    | Add additional init containers to the etcd pods                                                                                           | `[]`                       |
| `operator.sidecars`                                          | Add additional sidecar containers to the etcd pods                                                                                        | `[]`                       |
| `operator.watchNamespace`                                    | Override the namespace to watch                                                                                                           | `""`                       |
| `operator.topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment                                                                                            | `[]`                       |
| `operator.priorityClassName`                                 | %%MAIN_CONTAINER_NAME%% pods' priorityClassName                                                                                           | `""`                       |
| `operator.terminationGracePeriodSeconds`                     | In seconds, time the given to the %%MAIN_CONTAINER_NAME%% pod needs to terminate gracefully                                               | `""`                       |
| `operator.updateStrategy.type`                               | Set up update strategy for Grafana Operator installation.                                                                                 | `Recreate`                 |
| `operator.image.registry`                                    | Grafana Operator image registry                                                                                                           | `docker.io`                |
| `operator.image.repository`                                  | Grafana Operator image name                                                                                                               | `bitnami/grafana-operator` |
| `operator.image.tag`                                         | Grafana Operator image tag                                                                                                                | `4.4.1-debian-10-r10`      |
| `operator.image.pullPolicy`                                  | Grafana Operator image pull policy                                                                                                        | `IfNotPresent`             |
| `operator.image.pullSecrets`                                 | Grafana Operator image pull secrets                                                                                                       | `[]`                       |
| `operator.leaderElect`                                       | Enables or disables the operator leader Election.                                                                                         | `true`                     |
| `operator.scanAllNamespaces`                                 | Specify if all namespace should be scanned for dashboards and datasources. (Creates ClusterRole)                                          | `false`                    |
| `operator.scanNamespaces`                                    | Specify the namespaces which should be scanned for dashboards and datasources (Creates ClusterRole)                                       | `[]`                       |
| `operator.zapDevel`                                          | Enable zap development mode (changes defaults to console encoder, debug log level, disables sampling and stacktrace from 'warning' level) | `false`                    |
| `operator.zapEncoder`                                        | Zap log encoding ('json' or 'console')                                                                                                    | `""`                       |
| `operator.zapLevel`                                          | Zap log level (one of 'debug', 'info', 'error' or any integer value > 0) (default info)                                                   | `""`                       |
| `operator.zapSample`                                         | Enable zap log sampling. Sampling will be disabled for integer log levels > 1                                                             | `""`                       |
| `operator.zapStacktraceLevel`                                | Set the minimum log level that triggers stacktrace generation (default error)                                                             | `""`                       |
| `operator.zapTimeEncoding`                                   | Sets the zap time format ('epoch', 'millis', 'nano', or 'iso8601') (default )                                                             | `""`                       |
| `operator.extraArgs`                                         | Extra arguments for the grafana operator (Evaluated as a template)                                                                        | `[]`                       |
| `operator.rbac.create`                                       | Create specifies whether to install and use RBAC rules                                                                                    | `true`                     |
| `operator.serviceAccount.create`                             | Specifies whether a service account should be created                                                                                     | `true`                     |
| `operator.serviceAccount.name`                               | The name of the service account to use. If not set and create is true, a name is generated using the fullname template                    | `""`                       |
| `operator.serviceAccount.annotations`                        | Add annotations                                                                                                                           | `{}`                       |
| `operator.serviceAccount.automountServiceAccountToken`       | Automount API credentials for a service account.                                                                                          | `true`                     |
| `operator.podSecurityContext.enabled`                        | Enable pods security context                                                                                                              | `true`                     |
| `operator.podSecurityContext.runAsUser`                      | User ID for the pods                                                                                                                      | `1001`                     |
| `operator.podSecurityContext.runAsGroup`                     | User ID for the pods                                                                                                                      | `1001`                     |
| `operator.podSecurityContext.runAsNonRoot`                   | Grafana Operator must run as nonRoot                                                                                                      | `true`                     |
| `operator.podSecurityContext.fsGroup`                        | Group ID for the pods                                                                                                                     | `1001`                     |
| `operator.podSecurityContext.supplementalGroups`             | Which group IDs containers add                                                                                                            | `[]`                       |
| `operator.containerSecurityContext.enabled`                  | Enable container security context                                                                                                         | `true`                     |
| `operator.containerSecurityContext.runAsUser`                | User ID for the operator container                                                                                                        | `1001`                     |
| `operator.containerSecurityContext.runAsGroup`               | User ID for the operator container                                                                                                        | `1001`                     |
| `operator.containerSecurityContext.runAsNonRoot`             | Force the container to be run as non-root                                                                                                 | `true`                     |
| `operator.containerSecurityContext.privileged`               | Decide if the container runs privileged.                                                                                                  | `false`                    |
| `operator.containerSecurityContext.readOnlyRootFilesystem`   | ReadOnlyRootFilesystem fot the operator container                                                                                         | `false`                    |
| `operator.containerSecurityContext.allowPrivilegeEscalation` | Allow Privilege Escalation for the operator container                                                                                     | `false`                    |
| `operator.resources`                                         | Container resource requests and limits                                                                                                    | `{}`                       |
| `operator.containerPorts.metrics`                            | Grafana Operator container port (used for metrics)                                                                                        | `8080`                     |
| `operator.hostAliases`                                       | Add deployment host aliases                                                                                                               | `[]`                       |
| `operator.extraEnvVars`                                      | Array with extra environment variables to add to RabbitMQ Cluster Operator nodes                                                          | `[]`                       |
| `operator.extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for RabbitMQ Cluster Operator nodes                                                  | `""`                       |
| `operator.extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for RabbitMQ Cluster Operator nodes                                                     | `""`                       |
| `operator.podAffinityPreset`                                 | Pod affinity preset                                                                                                                       | `""`                       |
| `operator.podAntiAffinityPreset`                             | Pod anti-affinity preset. Allowed values: `soft` or `hard`                                                                                | `soft`                     |
| `operator.nodeAffinityPreset.type`                           | Node affinity preset type. Allowed values: `soft` or `hard`                                                                               | `""`                       |
| `operator.nodeAffinityPreset.key`                            | Set nodeAffinity preset key                                                                                                               | `""`                       |
| `operator.nodeAffinityPreset.values`                         | Set nodeAffinity preset values                                                                                                            | `[]`                       |
| `operator.podAnnotations`                                    | Pod annotations                                                                                                                           | `{}`                       |
| `operator.podLabels`                                         | Additional pod labels                                                                                                                     | `{}`                       |
| `operator.nodeSelector`                                      | Node labels for pod assignment                                                                                                            | `{}`                       |
| `operator.tolerations`                                       | Tolerations for controller pod assignment                                                                                                 | `[]`                       |
| `operator.affinity`                                          | Affinity for controller pod assignment                                                                                                    | `{}`                       |
| `operator.prometheus.serviceMonitor.enabled`                 | Specify if a ServiceMonitor will be deployed for prometheus-operator                                                                      | `false`                    |
| `operator.prometheus.serviceMonitor.namespace`               | Namespace for the ServiceMonitor Resource (defaults to the Release Namespace)                                                             | `""`                       |
| `operator.prometheus.serviceMonitor.jobLabel`                | Specify the jobLabel to use for the prometheus-operator                                                                                   | `app.kubernetes.io/name`   |
| `operator.prometheus.serviceMonitor.interval`                | Scrape interval. If not set, the Prometheus default scrape interval is used                                                               | `""`                       |
| `operator.prometheus.serviceMonitor.scrapeTimeout`           | Timeout after which the scrape is ended                                                                                                   | `""`                       |
| `operator.prometheus.serviceMonitor.metricRelabelings`       | Specify additional relabeling of metrics                                                                                                  | `[]`                       |
| `operator.prometheus.serviceMonitor.relabelings`             | Specify general relabeling                                                                                                                | `[]`                       |
| `operator.prometheus.serviceMonitor.selector`                | ServiceMonitor selector labels                                                                                                            | `{}`                       |
| `operator.prometheus.serviceMonitor.labels`                  | Extra labels for the ServiceMonitor                                                                                                       | `{}`                       |
| `operator.prometheus.serviceMonitor.honorLabels`             | honorLabels chooses the metric's labels on collisions with target labels                                                                  | `false`                    |
| `operator.livenessProbe.enabled`                             | Enable livenessProbe                                                                                                                      | `true`                     |
| `operator.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                   | `10`                       |
| `operator.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                          | `10`                       |
| `operator.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                         | `1`                        |
| `operator.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                       | `3`                        |
| `operator.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                       | `1`                        |
| `operator.readinessProbe.enabled`                            | Enable readinessProbe                                                                                                                     | `true`                     |
| `operator.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                  | `10`                       |
| `operator.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                         | `10`                       |
| `operator.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                        | `1`                        |
| `operator.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                      | `3`                        |
| `operator.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                      | `1`                        |
| `operator.startupProbe.enabled`                              | Enable startupProbe                                                                                                                       | `true`                     |
| `operator.startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                    | `10`                       |
| `operator.startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                           | `10`                       |
| `operator.startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                          | `1`                        |
| `operator.startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                        | `3`                        |
| `operator.startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                        | `1`                        |


### Grafana parameters

| Name                                                        | Description                                                                                                | Value                    |
| ----------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------- | ------------------------ |
| `grafana.enabled`                                           | Enabled the deployment of the Grafana CRD object into the cluster                                          | `true`                   |
| `grafana.image.registry`                                    | Grafana image registry                                                                                     | `docker.io`              |
| `grafana.image.repository`                                  | Grafana image name                                                                                         | `bitnami/grafana`        |
| `grafana.image.tag`                                         | Grafana image tag                                                                                          | `8.5.3-debian-10-r0`     |
| `grafana.image.pullSecrets`                                 | Grafana image pull secrets                                                                                 | `[]`                     |
| `grafana.pluginsInitContainerImage.registry`                | Grafana Plugins image registry                                                                             | `""`                     |
| `grafana.pluginsInitContainerImage.repository`              | Grafana Plugins image name                                                                                 | `""`                     |
| `grafana.pluginsInitContainerImage.tag`                     | Grafana Plugins image tag                                                                                  | `""`                     |
| `grafana.pluginsInitContainerImage.pullSecrets`             | Grafana Plugins image pull secrets                                                                         | `[]`                     |
| `grafana.serviceAccount`                                    | Additional service account configuration                                                                   | `{}`                     |
| `grafana.podSecurityContext.enabled`                        | Enable pods security context                                                                               | `true`                   |
| `grafana.podSecurityContext.runAsUser`                      | User ID for the pods                                                                                       | `1001`                   |
| `grafana.podSecurityContext.runAsGroup`                     | User ID for the pods                                                                                       | `0`                      |
| `grafana.podSecurityContext.runAsNonRoot`                   | Grafana Operator must run as nonRoot                                                                       | `true`                   |
| `grafana.podSecurityContext.fsGroup`                        | Group ID for the pods                                                                                      | `1001`                   |
| `grafana.podSecurityContext.supplementalGroups`             | Which group IDs containers add                                                                             | `[]`                     |
| `grafana.containerSecurityContext.enabled`                  | Enable containers security context                                                                         | `true`                   |
| `grafana.containerSecurityContext.runAsUser`                | User ID for the containers                                                                                 | `1001`                   |
| `grafana.containerSecurityContext.runAsGroup`               | Group ID for the containers                                                                                | `0`                      |
| `grafana.containerSecurityContext.privileged`               | Decide if the container runs privileged.                                                                   | `false`                  |
| `grafana.containerSecurityContext.runAsNonRoot`             | Force the container to run as non-root                                                                     | `true`                   |
| `grafana.containerSecurityContext.allowPrivilegeEscalation` | Don't allow privilege escalation for the containers                                                        | `false`                  |
| `grafana.resources.limits`                                  | The resources limits for the container                                                                     | `{}`                     |
| `grafana.resources.requests`                                | The requested resources for the container                                                                  | `{}`                     |
| `grafana.replicaCount`                                      | Specify the amount of replicas running                                                                     | `1`                      |
| `grafana.skipCreateAdminAccount`                            | Prevent the operator from creating an admin secret                                                         | `false`                  |
| `grafana.podAffinityPreset`                                 | Pod affinity preset                                                                                        | `""`                     |
| `grafana.podAntiAffinityPreset`                             | Pod anti-affinity preset                                                                                   | `soft`                   |
| `grafana.nodeAffinityPreset.type`                           | Set nodeAffinity preset type                                                                               | `""`                     |
| `grafana.nodeAffinityPreset.key`                            | Set nodeAffinity preset key                                                                                | `""`                     |
| `grafana.nodeAffinityPreset.values`                         | Set nodeAffinity preset values                                                                             | `[]`                     |
| `grafana.affinity`                                          | Affinity for controller pod assignment                                                                     | `{}`                     |
| `grafana.nodeSelector`                                      | Node labels for controller pod assignment                                                                  | `{}`                     |
| `grafana.tolerations`                                       | Tolerations for controller pod assignment                                                                  | `[]`                     |
| `grafana.envFrom`                                           | Extra environment variable to pass to the running container                                                | `[]`                     |
| `grafana.client.timeout`                                    | The timeout in seconds for the Grafana Rest API on that instance                                           | `5`                      |
| `grafana.client.preferService`                              | If the API should be used via Ingress or via the internal service                                          | `true`                   |
| `grafana.labels`                                            | Add additional labels to the grafana deployment, service and ingress resources                             | `{}`                     |
| `grafana.service.type`                                      | Kubernetes Service type                                                                                    | `ClusterIP`              |
| `grafana.service.annotations`                               | Additional custom annotations for Grafana service                                                          | `{}`                     |
| `grafana.service.extraPorts`                                | Extra ports to expose in the Grafana service                                                               | `[]`                     |
| `grafana.ingress.enabled`                                   | If an ingress or OpenShift Route should be created                                                         | `false`                  |
| `grafana.ingress.ingressClassName`                          | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                              | `""`                     |
| `grafana.ingress.hostname`                                  | The hostname under which the grafana instance should be reachable. If empty the parameter will not be set. | `grafana.local`          |
| `grafana.ingress.path`                                      | The path for the ingress instance to forward to the grafana app                                            | `/`                      |
| `grafana.ingress.pathType`                                  | The pathType for the ingress instance to forward to the grafana app                                        | `ImplementationSpecific` |
| `grafana.ingress.labels`                                    | Additional Labels for the ingress resource                                                                 | `{}`                     |
| `grafana.ingress.annotations`                               | Additional Annotations for the ingress resource                                                            | `{}`                     |
| `grafana.ingress.tls`                                       | This enables tls support for the ingress resource                                                          | `false`                  |
| `grafana.ingress.tlsSecret`                                 | The name for the secret to use for the tls termination                                                     | `grafana.local-tls`      |
| `grafana.persistence.enabled`                               | Enable persistent storage for the grafana deployment                                                       | `false`                  |
| `grafana.persistence.storageClass`                          | Define the storageClass for the persistent storage if not defined default is used                          | `""`                     |
| `grafana.persistence.accessModes`                           | Define the accessModes for the persistent storage                                                          | `["ReadWriteOnce"]`      |
| `grafana.persistence.annotations`                           | Add annotations to the persistent volume                                                                   | `{}`                     |
| `grafana.persistence.size`                                  | Define the size of the PersistentVolumeClaim to request for                                                | `10Gi`                   |
| `grafana.config`                                            | grafana.ini configuration for the instance for this to configure please look at upstream docs              | `{}`                     |
| `grafana.configMaps`                                        | Extra configMaps to mount into the grafana pod                                                             | `[]`                     |
| `grafana.secrets`                                           | Extra secrets to mount into the grafana pod                                                                | `[]`                     |
| `grafana.jsonnetLibrarySelector`                            | Configuring the read for jsonnetLibraries to pull in.                                                      | `{}`                     |
| `grafana.dashboardLabelSelectors`                           | This selects dashboards on the label.                                                                      | `{}`                     |
| `grafana.dashboardNamespaceSelector`                        | Watch for dashboards only in the Namespaces that have the specified namespace label                        | `{}`                     |
| `grafana.livenessProbe.enabled`                             | Enable livenessProbe                                                                                       | `true`                   |
| `grafana.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                    | `120`                    |
| `grafana.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                           | `10`                     |
| `grafana.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                          | `5`                      |
| `grafana.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                        | `6`                      |
| `grafana.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                        | `1`                      |
| `grafana.readinessProbe.enabled`                            | Enable readinessProbe                                                                                      | `true`                   |
| `grafana.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                   | `30`                     |
| `grafana.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                          | `10`                     |
| `grafana.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                         | `5`                      |
| `grafana.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                       | `6`                      |
| `grafana.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                       | `1`                      |
| `grafana.updateStrategy`                                    | Set up update strategy for Grafana installation.                                                           | `{}`                     |
| `grafana.extraVolumes`                                      | Optionally specify extra list of additional volumes for the grafana pod(s)                                 | `[]`                     |
| `grafana.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the grafana container(s)                      | `[]`                     |
| `grafana.sidecars`                                          | Add additional sidecar containers to the grafana pod(s)                                                    | `[]`                     |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install my-release \
  --set livenessProbe.successThreshold=5 \
    bitnami/grafana-operator
```

The above command sets the `livenessProbe.successThreshold` to `5`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install my-release -f values.yaml bitnami/grafana-operator
```

## Configuration and installation details

### [Rolling vs Immutable tags](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Sidecars and Init Containers

If additional containers are needed in the same pod (such as additional metrics or logging exporters), they can be defined using the `sidecars` parameter. Here is an example:

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
...
  extraPorts:
  - name: extraPort
    port: 11311
    targetPort: 11311
```

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

### Pod affinity

This chart allows you to set your custom affinity using the `*.affinity` parameter(s). Find more information about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `*.podAffinityPreset`, `*.podAntiAffinityPreset`, or `*.nodeAffinityPreset` parameters.

### Ingress

This chart provides support for Ingress resources. If you have an ingress controller installed on your cluster, such as [nginx-ingress-controller](https://github.com/bitnami/charts/tree/master/bitnami/nginx-ingress-controller) or [contour](https://github.com/bitnami/charts/tree/master/bitnami/contour) you can utilize the ingress controller to serve your application.

To enable Ingress integration, set `ingress.enabled` to `true`. The `ingress.hostname` property can be used to set the host name. The `ingress.tls` parameter can be used to add the TLS configuration for this host. It is also possible to have more than one host, with a separate TLS configuration for each host.

In general, to enable Ingress integration, set the `*.ingress.enabled` parameter to *true*.

The most common scenario is to have one host name mapped to the deployment. In this case, the `*.ingress.hostname` property can be used to set the host name. The `*.ingress.tls` parameter can be used to add the TLS configuration for this host.

However, it is also possible to have more than one host. To facilitate this, the `*.ingress.extraHosts` parameter (if available) can be set with the host names specified as an array. The `*.ingress.extraTLS` parameter (if available) can also be used to add the TLS configuration for extra hosts.

> NOTE: For each host specified in the `*.ingress.extraHosts` parameter, it is necessary to set a name, path, and any annotations that the Ingress controller should know about. Not all annotations are supported by all Ingress controllers, but [this annotation reference document](https://github.com/kubernetes/ingress-nginx/blob/master/docs/user-guide/nginx-configuration/annotations.md) lists the annotations supported by many popular Ingress controllers.

Adding the TLS parameter (where available) will cause the chart to generate HTTPS URLs, and the  application will be available on port 443. The actual TLS secrets do not have to be generated by this chart. However, if TLS is enabled, the Ingress record will not work until the TLS secret exists.

[Learn more about Ingress controllers](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/).

### Create Grafana Dashboards

After the installation, create Dashboards under a CRD of your Kubernetes cluster.

For more details regarding what is possible with those CRDs please have a look at [Working with Dashboards](https://github.com/integr8ly/grafana-operator/blob/master/documentation/dashboards.md).

### Deploy extra Grafana resources or objects

There are cases where it may be necessary to deploy extra objects, such a ConfigMap containing application configuration or an extra deployment with a micro-service used by an application. For these cases, this chart supports adding the full specification of other objects via the *extraDeploy* parameter.

For instance, to deploy a custom Grafana definition, install the Grafana Operator chart using the values below:

```yaml
grafana:
  enabled: false
extraDeploy:
  - apiVersion: integreatly.org/v1alpha1
    baseImage: docker.io/bitnami/grafana:7
    kind: Grafana
    metadata:
      name: grafana
    spec:
      deployment:
        securityContext:
          runAsUser: 1001
          fsGroup: 1001
        containerSecurityContext:
          runAsUser: 1001
          fsGroup: 1001
          allowPrivilegeEscalation: false
      service:
        type: LoadBalancer
      ingress:
        enabled: false
      config:
        log:
          mode: "console"
          level: "warn"
        security:
          admin_user: "admin"
          admin_password: "hello"
        auth.anonymous:
          enabled: true
      dashboardLabelSelector:
        - matchExpressions:
            - { key: app, operator: In, values: [grafana] }
```

[Learn more about managing multiple Grafana instances and dashboards on Kubernetes with the Grafana Operator](https://docs.bitnami.com/tutorials/manage-multiple-grafana-operator).

## Troubleshooting

Sometimes, due to unexpected issues, installations can become corrupted and get stuck in a *CrashLoopBackOff* restart loop. In these situations, it may be necessary to access the containers and perform manual operations to troubleshoot and fix the issues. To ease this task, the chart has a "Diagnostic mode" that will deploy all the containers with all probes and lifecycle hooks disabled. In addition to this, it will override all commands and arguments with `sleep infinity`.

To activate the "Diagnostic mode", upgrade the release with the following comman. Replace the `MY-RELEASE` placeholder with the release name:
```console
$ helm upgrade MY-RELEASE --set diagnosticMode.enabled=true
```
It is also possible to change the default `sleep infinity` command by setting the `diagnosticMode.command` and `diagnosticMode.args` values.

Once the chart has been deployed in "Diagnostic mode", access the containers by executing the following command and replacing the `MY-CONTAINER` placeholder with the container name:
```console
$ kubectl exec -ti MY-CONTAINER -- bash
```

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

```bash
$ helm upgrade my-release bitnami/grafana-operator
```

### To 2.0.0

In this version the CRDs get updated from v1beta to v1 stable API. It also updates the operator image to the new major `v4.x.y` release.

The `values.yaml` does not need changes when updating to this major version of the chart

- CRDs were updated to the latest Grafana Operator 4.0.x release artifacts:
  - The apiVersion of CRDs was updated from `apiextensions.k8s.io/v1beta1` to `apiextensions.k8s.io/v1`.
  - Kubernetes 1.16 or higher is now required.

Some of the chart values were changed to adapt to the latest Bitnami standards. More specifically:

- `operator.args` was replaced with the standard value of overriding the container commands. The original `operator.args` contents were moved to `operator`.
- Several standard values were added such as `sidecars`, `initContainers`, `extraEnvVars`, amongst others.

No issues should be expected when upgrading.

### To 1.0.0

In this version, the `image` block is defined once and is used in the different templates, while in the previous version, the `image` block was duplicated for the grafana container and the grafana plugin init one

```yaml
image:
  registry: docker.io
  repository: bitnami/grafana
  tag: 7.5.10
```

VS

```yaml
image:
  registry: docker.io
  repository: bitnami/grafana
  tag: 7.5.10
---
grafanaPluginInit:
  image:
    registry: docker.io
    repository: bitnami/grafana
    tag: 7.5.10
```

See [PR#7114](https://github.com/bitnami/charts/pull/7114) for more info about the implemented changes

## License

Copyright &copy; 2022 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
