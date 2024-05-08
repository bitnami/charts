<!--- app-name: Grafana Operator -->

# Bitnami package for Grafana Operator

Grafana Operator is a Kubernetes operator that enables the installation and management of Grafana instances, dashboards and plugins.

[Overview of Grafana Operator](https://github.com/integr8ly/grafana-operator)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/grafana-operator
```

Looking to use Grafana Operator in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the enterprise edition of Bitnami Application Catalog.

## Introduction

Bitnami charts for Helm are carefully engineered, actively maintained and are the quickest and easiest way to deploy containers on a Kubernetes cluster that are ready to handle production workloads.

This chart bootstraps a [Grafana Operator](https://github.com/integr8ly/grafana-operator/blob/master/documentation/deploy_grafana.md) Deployment [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Differences between the Bitnami Grafana chart and the Bitnami Grafana Operator chart

The Bitnami catalog offers both the `bitnami/grafana` and `bitnami/grafana-operator` charts. Each solution covers different needs and use cases.

- The `bitnami/grafana` chart deploys a single Grafana installation (with Grafana Image Renderer) using a Kubernetes Deployment object (together with Services, PVCs, ConfigMaps, etc.). Its lifecycle is managed using Helm and, at the Grafana container level, the following operations are automated: persistence management, configuration based on environment variables and plugin initialization. The chart also allows deploying dashboards and data sources using ConfigMaps. The Deployments do not require any ServiceAccounts with special RBAC privileges so this solution would fit better in more restricted Kubernetes installations.

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

- The `bitnami/grafana-operator` chart deploys a Grafana Operator installation using a Kubernetes Deployment. The operator will extend the Kubernetes API with the following objects: `Grafana`, `GrafanaDashboard` and `GrafanaDataSource`. From that moment, the user will be able to deploy objects of these kinds and the previously deployed Operator will take care of deploying all the required Deployments, ConfigMaps and Services for running a Grafana instance. Its lifecycle is managed using _kubectl_ on the Grafana, GrafanaDashboard and GrafanaDataSource objects.

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

The Operator will extend the Kubernetes API with the following objects: _Grafana_, _GrafanaDashboard_ and _GrafanaDataSource_. From that moment, the user will be able to deploy objects of these kinds and the previously deployed Operator will take care of deploying all the required Deployments, ConfigMaps and Services for running a Grafana instance. Its lifecycle is managed using _kubectl_ on the Grafana, GrafanaDashboard and GrafanaDataSource objects. The following figure shows the deployed objects after deploying a Grafana object using _kubectl_:

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

> Note: As the operator automatically deploys Grafana installations, the Grafana Operator pods will require a ServiceAccount with privileges to create and destroy multiple Kubernetes objects. This may be problematic for Kubernetes clusters with strict role-based access policies.

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/grafana-operator
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

These commands deploy grafana-operator on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Configuration and installation details

### Resource requests and limits

Bitnami charts allow setting resource requests and limits for all containers inside the chart deployment. These are inside the `resources` value (check parameter table). Setting requests is essential for production workloads and these should be adapted to your specific use case.

To make this process easier, the chart contains the `resourcesPreset` values, which automatically sets the `resources` section according to different presets. Check these presets in [the bitnami/common chart](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15). However, in production workloads using `resourcePreset` is discouraged as it may not fully adapt to your specific needs. Find more information on container resource management in the [official Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).

### [Rolling vs Immutable tags](https://docs.vmware.com/en/VMware-Tanzu-Application-Catalog/services/tutorials/GUID-understand-rolling-tags-containers-index.html)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Create Grafana Dashboards

After the installation, create Dashboards under a CRD of your Kubernetes cluster.

For more details regarding what is possible with those CRDs please have a look at [Working with Dashboards](https://github.com/integr8ly/grafana-operator/blob/master/documentation/dashboards.md).

### Deploy extra Grafana resources or objects

There are cases where you may want to deploy extra objects, such as custom _Grafana_, _GrafanaDashboard_ or _GrafanaDataSource_ objects. For covering this case, the chart allows adding the full specification of other objects using the `extraDeploy` parameter.

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

## Parameters

### Global parameters

| Name                                                  | Description                                                                                                                                                                                                                                                                                                                                                         | Value      |
| ----------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------- |
| `global.imageRegistry`                                | Global Docker image registry                                                                                                                                                                                                                                                                                                                                        | `""`       |
| `global.imagePullSecrets`                             | Global Docker registry secret names as an array                                                                                                                                                                                                                                                                                                                     | `[]`       |
| `global.compatibility.openshift.adaptSecurityContext` | Adapt the securityContext sections of the deployment to make them compatible with Openshift restricted-v2 SCC: remove runAsUser, runAsGroup and fsGroup and let the platform use their allowed default IDs. Possible values: auto (apply if the detected running cluster is Openshift), force (perform the adaptation always), disabled (do not perform adaptation) | `disabled` |

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

| Name                                                         | Description                                                                                                                                                                                                                         | Value                              |
| ------------------------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------- |
| `operator.enabled`                                           | Enable the deployment of the Grafana Operator                                                                                                                                                                                       | `true`                             |
| `operator.command`                                           | Default container command (useful when using custom images)                                                                                                                                                                         | `[]`                               |
| `operator.args`                                              | Default container args (useful when using custom images)                                                                                                                                                                            | `[]`                               |
| `operator.schedulerName`                                     | Alternative scheduler                                                                                                                                                                                                               | `""`                               |
| `operator.lifecycleHooks`                                    | for the grafana-operator container to automate configuration before or after startup                                                                                                                                                | `{}`                               |
| `operator.replicaCount`                                      | Number of grafana-operator Pod replicas                                                                                                                                                                                             | `1`                                |
| `operator.customLivenessProbe`                               | Override default liveness probe                                                                                                                                                                                                     | `{}`                               |
| `operator.customReadinessProbe`                              | Override default readiness probe                                                                                                                                                                                                    | `{}`                               |
| `operator.customStartupProbe`                                | Override default startup probe                                                                                                                                                                                                      | `{}`                               |
| `operator.extraVolumes`                                      | Optionally specify extra list of additional volumes for Grafana Operator pods                                                                                                                                                       | `[]`                               |
| `operator.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for Grafana Operator container(s)                                                                                                                                          | `[]`                               |
| `operator.initContainers`                                    | Add additional init containers to the Grafana Operator pods                                                                                                                                                                         | `[]`                               |
| `operator.sidecars`                                          | Add additional sidecar containers to the Grafana Operator pods                                                                                                                                                                      | `[]`                               |
| `operator.namespaceScope`                                    | If the operator should run in namespace-scope mode or not,                                                                                                                                                                          | `false`                            |
| `operator.watchNamespace`                                    | Override the namespace to watch                                                                                                                                                                                                     | `""`                               |
| `operator.topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment                                                                                                                                                                                      | `[]`                               |
| `operator.priorityClassName`                                 | %%MAIN_CONTAINER_NAME%% pods' priorityClassName                                                                                                                                                                                     | `""`                               |
| `operator.terminationGracePeriodSeconds`                     | In seconds, time the given to the %%MAIN_CONTAINER_NAME%% pod needs to terminate gracefully                                                                                                                                         | `""`                               |
| `operator.updateStrategy.type`                               | Set up update strategy for Grafana Operator installation.                                                                                                                                                                           | `Recreate`                         |
| `operator.image.registry`                                    | Grafana Operator image registry                                                                                                                                                                                                     | `REGISTRY_NAME`                    |
| `operator.image.repository`                                  | Grafana Operator image name                                                                                                                                                                                                         | `REPOSITORY_NAME/grafana-operator` |
| `operator.image.digest`                                      | Grafana Operator image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                    | `""`                               |
| `operator.image.pullPolicy`                                  | Grafana Operator image pull policy                                                                                                                                                                                                  | `IfNotPresent`                     |
| `operator.image.pullSecrets`                                 | Grafana Operator image pull secrets                                                                                                                                                                                                 | `[]`                               |
| `operator.leaderElect`                                       | Enables or disables the operator leader Election.                                                                                                                                                                                   | `true`                             |
| `operator.zapDevel`                                          | Enable zap development mode (changes defaults to console encoder, debug log level, disables sampling and stacktrace from 'warning' level)                                                                                           | `false`                            |
| `operator.zapEncoder`                                        | Zap log encoding ('json' or 'console')                                                                                                                                                                                              | `""`                               |
| `operator.zapLevel`                                          | Zap log level (one of 'debug', 'info', 'error' or any integer value > 0) (default info)                                                                                                                                             | `""`                               |
| `operator.zapSample`                                         | Enable zap log sampling. Sampling will be disabled for integer log levels > 1                                                                                                                                                       | `""`                               |
| `operator.zapStacktraceLevel`                                | Set the minimum log level that triggers stacktrace generation (default error)                                                                                                                                                       | `""`                               |
| `operator.zapTimeEncoding`                                   | Sets the zap time format ('epoch', 'millis', 'nano', or 'iso8601') (default )                                                                                                                                                       | `""`                               |
| `operator.extraArgs`                                         | Extra arguments for the grafana operator (Evaluated as a template)                                                                                                                                                                  | `[]`                               |
| `operator.rbac.create`                                       | Create specifies whether to install and use RBAC rules                                                                                                                                                                              | `true`                             |
| `operator.serviceAccount.create`                             | Specifies whether a service account should be created                                                                                                                                                                               | `true`                             |
| `operator.serviceAccount.name`                               | The name of the service account to use. If not set and create is true, a name is generated using the fullname template                                                                                                              | `""`                               |
| `operator.serviceAccount.annotations`                        | Add annotations                                                                                                                                                                                                                     | `{}`                               |
| `operator.serviceAccount.automountServiceAccountToken`       | Automount API credentials for a service account.                                                                                                                                                                                    | `false`                            |
| `operator.podSecurityContext.enabled`                        | Enable pods security context                                                                                                                                                                                                        | `true`                             |
| `operator.podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                                  | `Always`                           |
| `operator.podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                                      | `[]`                               |
| `operator.podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                                         | `[]`                               |
| `operator.podSecurityContext.fsGroup`                        | Group ID for the pods                                                                                                                                                                                                               | `1001`                             |
| `operator.containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                                                                                                                                                | `true`                             |
| `operator.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                                    | `{}`                               |
| `operator.containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                                                                                                                          | `1001`                             |
| `operator.containerSecurityContext.runAsGroup`               | Set containers' Security Context runAsGroup                                                                                                                                                                                         | `1001`                             |
| `operator.containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                                                                                                                                       | `true`                             |
| `operator.containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                                                                                                                                         | `false`                            |
| `operator.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                                             | `true`                             |
| `operator.containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                                                                                                                           | `false`                            |
| `operator.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                                  | `["ALL"]`                          |
| `operator.containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                                    | `RuntimeDefault`                   |
| `operator.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if operator.resources is set (operator.resources is recommended for production). | `nano`                             |
| `operator.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                   | `{}`                               |
| `operator.containerPorts.metrics`                            | Grafana Operator container port (used for metrics)                                                                                                                                                                                  | `8080`                             |
| `operator.containerPorts.health`                             | Grafana Operator container port (used for health probes)                                                                                                                                                                            | `8081`                             |
| `operator.automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                                  | `true`                             |
| `operator.hostAliases`                                       | Add deployment host aliases                                                                                                                                                                                                         | `[]`                               |
| `operator.extraEnvVars`                                      | Array with extra environment variables to add to RabbitMQ Cluster Operator nodes                                                                                                                                                    | `[]`                               |
| `operator.extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for RabbitMQ Cluster Operator nodes                                                                                                                                            | `""`                               |
| `operator.extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for RabbitMQ Cluster Operator nodes                                                                                                                                               | `""`                               |
| `operator.podAntiAffinityPreset`                             | Pod anti-affinity preset. Allowed values: `soft` or `hard`                                                                                                                                                                          | `soft`                             |
| `operator.nodeAffinityPreset.type`                           | Node affinity preset type. Allowed values: `soft` or `hard`                                                                                                                                                                         | `""`                               |
| `operator.nodeAffinityPreset.key`                            | Set nodeAffinity preset key                                                                                                                                                                                                         | `""`                               |
| `operator.nodeAffinityPreset.values`                         | Set nodeAffinity preset values                                                                                                                                                                                                      | `[]`                               |
| `operator.podAnnotations`                                    | Pod annotations                                                                                                                                                                                                                     | `{}`                               |
| `operator.podLabels`                                         | Additional pod labels                                                                                                                                                                                                               | `{}`                               |
| `operator.nodeSelector`                                      | Node labels for pod assignment                                                                                                                                                                                                      | `{}`                               |
| `operator.tolerations`                                       | Tolerations for controller pod assignment                                                                                                                                                                                           | `[]`                               |
| `operator.affinity`                                          | Affinity for controller pod assignment                                                                                                                                                                                              | `{}`                               |
| `operator.prometheus.serviceMonitor.enabled`                 | Specify if a ServiceMonitor will be deployed for prometheus-operator                                                                                                                                                                | `false`                            |
| `operator.prometheus.serviceMonitor.namespace`               | Namespace for the ServiceMonitor Resource (defaults to the Release Namespace)                                                                                                                                                       | `""`                               |
| `operator.prometheus.serviceMonitor.jobLabel`                | Specify the jobLabel to use for the prometheus-operator                                                                                                                                                                             | `app.kubernetes.io/name`           |
| `operator.prometheus.serviceMonitor.interval`                | Scrape interval. If not set, the Prometheus default scrape interval is used                                                                                                                                                         | `""`                               |
| `operator.prometheus.serviceMonitor.scrapeTimeout`           | Timeout after which the scrape is ended                                                                                                                                                                                             | `""`                               |
| `operator.prometheus.serviceMonitor.metricRelabelings`       | Specify additional relabeling of metrics                                                                                                                                                                                            | `[]`                               |
| `operator.prometheus.serviceMonitor.relabelings`             | Specify general relabeling                                                                                                                                                                                                          | `[]`                               |
| `operator.prometheus.serviceMonitor.selector`                | ServiceMonitor selector labels                                                                                                                                                                                                      | `{}`                               |
| `operator.prometheus.serviceMonitor.labels`                  | Extra labels for the ServiceMonitor                                                                                                                                                                                                 | `{}`                               |
| `operator.prometheus.serviceMonitor.honorLabels`             | honorLabels chooses the metric's labels on collisions with target labels                                                                                                                                                            | `false`                            |
| `operator.livenessProbe.enabled`                             | Enable livenessProbe                                                                                                                                                                                                                | `true`                             |
| `operator.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                                             | `10`                               |
| `operator.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                                    | `10`                               |
| `operator.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                                   | `1`                                |
| `operator.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                                                 | `3`                                |
| `operator.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                                                 | `1`                                |
| `operator.readinessProbe.enabled`                            | Enable readinessProbe                                                                                                                                                                                                               | `true`                             |
| `operator.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                                            | `10`                               |
| `operator.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                                   | `10`                               |
| `operator.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                                  | `1`                                |
| `operator.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                                                | `3`                                |
| `operator.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                                                | `1`                                |
| `operator.startupProbe.enabled`                              | Enable startupProbe                                                                                                                                                                                                                 | `true`                             |
| `operator.startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                                              | `10`                               |
| `operator.startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                                     | `10`                               |
| `operator.startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                                    | `1`                                |
| `operator.startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                                  | `3`                                |
| `operator.startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                                  | `1`                                |
| `operator.networkPolicy.enabled`                             | Specifies whether a NetworkPolicy should be created                                                                                                                                                                                 | `true`                             |
| `operator.networkPolicy.allowExternal`                       | Don't require server label for connections                                                                                                                                                                                          | `true`                             |
| `operator.networkPolicy.allowExternalEgress`                 | Allow the pod to access any range of port and all destinations.                                                                                                                                                                     | `true`                             |
| `operator.networkPolicy.kubeAPIServerPorts`                  | List of possible endpoints to kube-apiserver (limit to your cluster settings to increase security)                                                                                                                                  | `[]`                               |
| `operator.networkPolicy.extraIngress`                        | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                                        | `[]`                               |
| `operator.networkPolicy.extraEgress`                         | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                                        | `[]`                               |
| `operator.networkPolicy.ingressNSMatchLabels`                | Labels to match to allow traffic from other namespaces                                                                                                                                                                              | `{}`                               |
| `operator.networkPolicy.ingressNSPodMatchLabels`             | Pod labels to match to allow traffic from other namespaces                                                                                                                                                                          | `{}`                               |

### Grafana parameters

| Name                                                        | Description                                                                                                                                                                                                                       | Value                     |
| ----------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------- |
| `grafana.enabled`                                           | Enabled the deployment of the Grafana CRD object into the cluster                                                                                                                                                                 | `true`                    |
| `grafana.image.registry`                                    | Grafana image registry                                                                                                                                                                                                            | `REGISTRY_NAME`           |
| `grafana.image.repository`                                  | Grafana image name                                                                                                                                                                                                                | `REPOSITORY_NAME/grafana` |
| `grafana.image.digest`                                      | Grafana image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                           | `""`                      |
| `grafana.image.pullPolicy`                                  | Grafana image pull policy                                                                                                                                                                                                         | `IfNotPresent`            |
| `grafana.image.pullSecrets`                                 | Grafana image pull secrets                                                                                                                                                                                                        | `[]`                      |
| `grafana.serviceAccount`                                    | Additional service account configuration                                                                                                                                                                                          | `{}`                      |
| `grafana.podLabels`                                         | Additional pod labels to pods in the grafana deployment                                                                                                                                                                           | `{}`                      |
| `grafana.podSecurityContext.enabled`                        | Enable pods security context                                                                                                                                                                                                      | `true`                    |
| `grafana.podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                                | `Always`                  |
| `grafana.podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                                    | `[]`                      |
| `grafana.podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                                       | `[]`                      |
| `grafana.podSecurityContext.fsGroup`                        | Group ID for the pods                                                                                                                                                                                                             | `1001`                    |
| `grafana.containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                                                                                                                                              | `true`                    |
| `grafana.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                                  | `{}`                      |
| `grafana.containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                                                                                                                        | `1001`                    |
| `grafana.containerSecurityContext.runAsGroup`               | Set containers' Security Context runAsGroup                                                                                                                                                                                       | `0`                       |
| `grafana.containerSecurityContext.runAsGroup`               | Set containers' Security Context runAsGroup                                                                                                                                                                                       | `0`                       |
| `grafana.containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                                                                                                                                     | `true`                    |
| `grafana.containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                                                                                                                                       | `false`                   |
| `grafana.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                                           | `false`                   |
| `grafana.containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                                                                                                                         | `false`                   |
| `grafana.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                                | `["ALL"]`                 |
| `grafana.containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                                  | `RuntimeDefault`          |
| `grafana.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if grafana.resources is set (grafana.resources is recommended for production). | `none`                    |
| `grafana.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                 | `{}`                      |
| `grafana.replicaCount`                                      | Specify the amount of replicas running                                                                                                                                                                                            | `1`                       |
| `grafana.podAffinityPreset`                                 | Pod affinity preset                                                                                                                                                                                                               | `""`                      |
| `grafana.podAntiAffinityPreset`                             | Pod anti-affinity preset                                                                                                                                                                                                          | `soft`                    |
| `grafana.nodeAffinityPreset.type`                           | Set nodeAffinity preset type                                                                                                                                                                                                      | `""`                      |
| `grafana.nodeAffinityPreset.key`                            | Set nodeAffinity preset key                                                                                                                                                                                                       | `""`                      |
| `grafana.nodeAffinityPreset.values`                         | Set nodeAffinity preset values                                                                                                                                                                                                    | `[]`                      |
| `grafana.affinity`                                          | Affinity for controller pod assignment                                                                                                                                                                                            | `{}`                      |
| `grafana.nodeSelector`                                      | Node labels for controller pod assignment                                                                                                                                                                                         | `{}`                      |
| `grafana.tolerations`                                       | Tolerations for controller pod assignment                                                                                                                                                                                         | `[]`                      |
| `grafana.envFrom`                                           | Extra environment variable to pass to the running container                                                                                                                                                                       | `[]`                      |
| `grafana.client.timeout`                                    | The timeout in seconds for the Grafana Rest API on that instance                                                                                                                                                                  | `5`                       |
| `grafana.labels`                                            | Add additional labels to the grafana deployment, service and ingress resources                                                                                                                                                    | `{}`                      |
| `grafana.service.type`                                      | Kubernetes Service type                                                                                                                                                                                                           | `ClusterIP`               |
| `grafana.service.annotations`                               | Additional custom annotations for Grafana service                                                                                                                                                                                 | `{}`                      |
| `grafana.service.extraPorts`                                | Extra ports to expose in the Grafana service                                                                                                                                                                                      | `[]`                      |
| `grafana.ingress.enabled`                                   | If an ingress or OpenShift Route should be created                                                                                                                                                                                | `false`                   |
| `grafana.ingress.ingressClassName`                          | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                                                                                                                     | `""`                      |
| `grafana.ingress.host`                                      | The host under which the grafana instance should be reachable. If empty the parameter will not be set.                                                                                                                            | `grafana.local`           |
| `grafana.ingress.path`                                      | The path for the ingress instance to forward to the grafana app                                                                                                                                                                   | `/`                       |
| `grafana.ingress.pathType`                                  | The pathType for the ingress instance to forward to the grafana app                                                                                                                                                               | `ImplementationSpecific`  |
| `grafana.ingress.labels`                                    | Additional Labels for the ingress resource                                                                                                                                                                                        | `{}`                      |
| `grafana.ingress.annotations`                               | Additional Annotations for the ingress resource                                                                                                                                                                                   | `{}`                      |
| `grafana.ingress.tls`                                       | This enables tls support for the ingress resource                                                                                                                                                                                 | `false`                   |
| `grafana.ingress.tlsSecret`                                 | The name for the secret to use for the tls termination                                                                                                                                                                            | `grafana.local-tls`       |
| `grafana.persistence.enabled`                               | Enable persistent storage for the grafana deployment                                                                                                                                                                              | `false`                   |
| `grafana.persistence.storageClass`                          | Define the storageClass for the persistent storage if not defined default is used                                                                                                                                                 | `""`                      |
| `grafana.persistence.existingVolume`                        | Define the existingVolume for the persistent storage provisioned outside this chart                                                                                                                                               | `""`                      |
| `grafana.persistence.accessModes`                           | Define the accessModes for the persistent storage                                                                                                                                                                                 | `["ReadWriteOnce"]`       |
| `grafana.persistence.annotations`                           | Add annotations to the persistent volume                                                                                                                                                                                          | `{}`                      |
| `grafana.persistence.size`                                  | Define the size of the PersistentVolumeClaim to request for                                                                                                                                                                       | `10Gi`                    |
| `grafana.config`                                            | grafana.ini configuration for the instance for this to configure please look at upstream docs                                                                                                                                     | `{}`                      |
| `grafana.jsonnetLibrarySelector`                            | Configuring the read for jsonnetLibraries to pull in.                                                                                                                                                                             | `{}`                      |
| `grafana.livenessProbe.enabled`                             | Enable livenessProbe                                                                                                                                                                                                              | `true`                    |
| `grafana.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                                           | `120`                     |
| `grafana.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                                  | `10`                      |
| `grafana.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                                 | `5`                       |
| `grafana.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                                               | `6`                       |
| `grafana.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                                               | `1`                       |
| `grafana.readinessProbe.enabled`                            | Enable readinessProbe                                                                                                                                                                                                             | `true`                    |
| `grafana.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                                          | `30`                      |
| `grafana.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                                 | `10`                      |
| `grafana.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                                | `5`                       |
| `grafana.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                                              | `6`                       |
| `grafana.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                                              | `1`                       |
| `grafana.updateStrategy`                                    | Set up update strategy for Grafana installation.                                                                                                                                                                                  | `{}`                      |
| `grafana.extraVolumes`                                      | Optionally specify extra list of additional volumes for the grafana pod(s)                                                                                                                                                        | `[]`                      |
| `grafana.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the grafana container                                                                                                                                                | `[]`                      |
| `grafana.secrets`                                           | Optionally specify a list of secrets to be mounted to the grafana pod(s)                                                                                                                                                          | `[]`                      |
| `grafana.sidecars`                                          | Add additional sidecar containers to the grafana pod(s)                                                                                                                                                                           | `[]`                      |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
  --set livenessProbe.successThreshold=5 \
    oci://REGISTRY_NAME/REPOSITORY_NAME/grafana-operator
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The above command sets the `livenessProbe.successThreshold` to `5`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml oci://REGISTRY_NAME/REPOSITORY_NAME/grafana-operator
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

```console
helm upgrade my-release oci://REGISTRY_NAME/REPOSITORY_NAME/grafana-operator
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

### To 4.0.0

This major bump changes the following security defaults:

- `runAsGroup` is changed from `0` to `1001`
- `readOnlyRootFilesystem` is set to `true`
- `resourcesPreset` is changed from `none` to the minimum size working in our test suites (NOTE: `resourcesPreset` is not meant for production usage, but `resources` adapted to your use case).
- `global.compatibility.openshift.adaptSecurityContext` is changed from `disabled` to `auto`.

This could potentially break any customization or init scripts used in your deployment. If this is the case, change the default values to the previous ones.

### To 3.0.0

In this version use different apiVersion in CRDs `integreatly.org/v1alpha1` -> `grafana.integreatly.org/v1beta1`
Please check the [offical documentation|https://github.com/grafana-operator/grafana-operator/blob/master/docs/blog/v4-v5-migration.md] to migrate to version 3.

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