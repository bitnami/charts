# rabbitmq-cluster-operator

[The RabbitMQ Cluster Kubernetes Operator](https://github.com/rabbitmq/cluster-operator) automates provisioning, management, and operations of RabbitMQ clusters running on Kubernetes.

## TL;DR

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/rabbitmq-cluster-operator
```

## Introduction

Bitnami charts for Helm are carefully engineered, actively maintained and are the quickest and easiest way to deploy containers on a Kubernetes cluster that are ready to handle production workloads.

This chart bootstraps a [RabbitMQ Cluster Operator](https://www.rabbitmq.com/kubernetes/operator/operator-overview.html) Deployment in a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This Helm chart has been tested on top of [Bitnami Kubernetes Production Runtime](https://kubeprod.io/) (BKPR). Deploy BKPR to get automated TLS certificates, logging and monitoring for your applications.

## Prerequisites

- Kubernetes 1.12+
- Helm 3.1.0
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release bitnami/rabbitmq-cluster-operators
```

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

```
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

```
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

```
  +--------------------+
  |                    |      +---------------+
  |  RabbitMQ Operator |      |               |
  |                    |      |     RBAC      |
  |     Deployment     |      | Privileges    |
  +-------+------------+      +-------+-------+
    │     ^                           |
    │     |   +-----------------+     |
    │     +---+ Service Account +<----+
    │         +-----------------+
    │
    │
    │
    │
    │    ┌───────────────────────────────────────────────────────────────────────┐
    │    │                                                                       │
    │    │                        +--------------+             +-----+           │
    │    │                        |              |             |     |           │
    └────►     Service            |   RabbitMQ   +<------------+ PVC |           │
         │    <-------------------+              |             |     |           │
         │                        |  StatefulSet |             +-----+           │
         │                        |              |                               │
         │                        +-----------+--+                               │
         │                                    ^                +------------+    │
         │                                    |                |            |    │
         │                                    +----------------+ Configmaps |    │
         │                                                     | Secrets    |    │
         │                                                     +------------+    │
         │                                                                       │
         │                                                                       │
         └───────────────────────────────────────────────────────────────────────┘

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

| Name                | Description                                        | Value           |
| ------------------- | -------------------------------------------------- | --------------- |
| `kubeVersion`       | Override Kubernetes version                        | `""`            |
| `nameOverride`      | String to partially override common.names.fullname | `""`            |
| `fullnameOverride`  | String to fully override common.names.fullname     | `""`            |
| `commonLabels`      | Labels to add to all deployed objects              | `{}`            |
| `commonAnnotations` | Annotations to add to all deployed objects         | `{}`            |
| `clusterDomain`     | Kubernetes cluster domain name                     | `cluster.local` |
| `extraDeploy`       | Array of extra objects to deploy with the release  | `[]`            |


### RabbitMQ Cluster Operator Parameters

| Name                                 | Description                                                                                             | Value                               |
| ------------------------------------ | ------------------------------------------------------------------------------------------------------- | ----------------------------------- |
| `image.registry`                     | RabbitMQ Cluster Operator image registry                                                                | `docker.io`                         |
| `image.repository`                   | RabbitMQ Cluster Operator image repository                                                              | `bitnami/rabbitmq-cluster-operator` |
| `image.tag`                          | RabbitMQ Cluster Operator image tag (immutable tags are recommended)                                    | `1.8.1-scratch-r0`                  |
| `image.pullPolicy`                   | RabbitMQ Cluster Operator image pull policy                                                             | `IfNotPresent`                      |
| `image.pullSecrets`                  | RabbitMQ Cluster Operator image pull secrets                                                            | `[]`                                |
| `rabbitmqImage.registry`             | RabbitMQ Image registry                                                                                 | `docker.io`                         |
| `rabbitmqImage.repository`           | RabbitMQ Image repository                                                                               | `bitnami/rabbitmq`                  |
| `rabbitmqImage.tag`                  | RabbitMQ Image tag (immutable tags are recommended)                                                     | `3.8.21-debian-10-r11`              |
| `rabbitmqImage.pullSecrets`          | RabbitMQ Image pull secrets                                                                             | `[]`                                |
| `replicaCount`                       | Number of RabbitMQ Cluster Operator replicas to deploy                                                  | `1`                                 |
| `livenessProbe.enabled`              | Enable livenessProbe on RabbitMQ Cluster Operator nodes                                                 | `true`                              |
| `livenessProbe.initialDelaySeconds`  | Initial delay seconds for livenessProbe                                                                 | `5`                                 |
| `livenessProbe.periodSeconds`        | Period seconds for livenessProbe                                                                        | `30`                                |
| `livenessProbe.timeoutSeconds`       | Timeout seconds for livenessProbe                                                                       | `5`                                 |
| `livenessProbe.failureThreshold`     | Failure threshold for livenessProbe                                                                     | `5`                                 |
| `livenessProbe.successThreshold`     | Success threshold for livenessProbe                                                                     | `1`                                 |
| `readinessProbe.enabled`             | Enable readinessProbe on RabbitMQ Cluster Operator nodes                                                | `true`                              |
| `readinessProbe.initialDelaySeconds` | Initial delay seconds for readinessProbe                                                                | `5`                                 |
| `readinessProbe.periodSeconds`       | Period seconds for readinessProbe                                                                       | `30`                                |
| `readinessProbe.timeoutSeconds`      | Timeout seconds for readinessProbe                                                                      | `5`                                 |
| `readinessProbe.failureThreshold`    | Failure threshold for readinessProbe                                                                    | `5`                                 |
| `readinessProbe.successThreshold`    | Success threshold for readinessProbe                                                                    | `1`                                 |
| `startupProbe.enabled`               | Enable startupProbe on RabbitMQ Cluster Operator nodes                                                  | `false`                             |
| `startupProbe.initialDelaySeconds`   | Initial delay seconds for startupProbe                                                                  | `5`                                 |
| `startupProbe.periodSeconds`         | Period seconds for startupProbe                                                                         | `30`                                |
| `startupProbe.timeoutSeconds`        | Timeout seconds for startupProbe                                                                        | `5`                                 |
| `startupProbe.failureThreshold`      | Failure threshold for startupProbe                                                                      | `5`                                 |
| `startupProbe.successThreshold`      | Success threshold for startupProbe                                                                      | `1`                                 |
| `customLivenessProbe`                | Custom livenessProbe that overrides the default one                                                     | `{}`                                |
| `customReadinessProbe`               | Custom readinessProbe that overrides the default one                                                    | `{}`                                |
| `customStartupProbe`                 | Custom startupProbe that overrides the default one                                                      | `{}`                                |
| `resources.limits`                   | The resources limits for the RabbitMQ Cluster Operator containers                                       | `{}`                                |
| `resources.requests`                 | The requested resources for the RabbitMQ Cluster Operator containers                                    | `{}`                                |
| `installCRDs`                        | Install RabbitMQ Cluster CRD                                                                            | `true`                              |
| `podSecurityContext.enabled`         | Enabled RabbitMQ Cluster Operator pods' Security Context                                                | `true`                              |
| `podSecurityContext.fsGroup`         | Set RabbitMQ Cluster Operator pod's Security Context fsGroup                                            | `1001`                              |
| `containerSecurityContext.enabled`   | Enabled RabbitMQ Cluster Operator containers' Security Context                                          | `true`                              |
| `containerSecurityContext.runAsUser` | Set RabbitMQ Cluster Operator containers' Security Context runAsUser                                    | `1001`                              |
| `command`                            | Override default container command (useful when using custom images)                                    | `[]`                                |
| `args`                               | Override default container args (useful when using custom images)                                       | `[]`                                |
| `hostAliases`                        | RabbitMQ Cluster Operator pods host aliases                                                             | `[]`                                |
| `podLabels`                          | Extra labels for RabbitMQ Cluster Operator pods                                                         | `{}`                                |
| `podAnnotations`                     | Annotations for RabbitMQ Cluster Operator pods                                                          | `{}`                                |
| `podAffinityPreset`                  | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                     | `""`                                |
| `podAntiAffinityPreset`              | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                | `soft`                              |
| `nodeAffinityPreset.type`            | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`               | `""`                                |
| `nodeAffinityPreset.key`             | Node label key to match. Ignored if `affinity` is set                                                   | `""`                                |
| `nodeAffinityPreset.values`          | Node label values to match. Ignored if `affinity` is set                                                | `[]`                                |
| `affinity`                           | Affinity for RabbitMQ Cluster Operator pods assignment                                                  | `{}`                                |
| `nodeSelector`                       | Node labels for RabbitMQ Cluster Operator pods assignment                                               | `{}`                                |
| `tolerations`                        | Tolerations for RabbitMQ Cluster Operator pods assignment                                               | `[]`                                |
| `updateStrategy.type`                | RabbitMQ Cluster Operator statefulset strategy type                                                     | `RollingUpdate`                     |
| `priorityClassName`                  | RabbitMQ Cluster Operator pods' priorityClassName                                                       | `""`                                |
| `lifecycleHooks`                     | for the RabbitMQ Cluster Operator container(s) to automate configuration before or after startup        | `{}`                                |
| `containerPort`                      | RabbitMQ Cluster Operator container port (used for metrics)                                             | `9782`                              |
| `extraEnvVars`                       | Array with extra environment variables to add to RabbitMQ Cluster Operator nodes                        | `[]`                                |
| `extraEnvVarsCM`                     | Name of existing ConfigMap containing extra env vars for RabbitMQ Cluster Operator nodes                | `""`                                |
| `extraEnvVarsSecret`                 | Name of existing Secret containing extra env vars for RabbitMQ Cluster Operator nodes                   | `""`                                |
| `extraVolumes`                       | Optionally specify extra list of additional volumes for the RabbitMQ Cluster Operator pod(s)            | `[]`                                |
| `extraVolumeMounts`                  | Optionally specify extra list of additional volumeMounts for the RabbitMQ Cluster Operator container(s) | `[]`                                |
| `sidecars`                           | Add additional sidecar containers to the RabbitMQ Cluster Operator pod(s)                               | `[]`                                |
| `initContainers`                     | Add additional init containers to the RabbitMQ Cluster Operator pod(s)                                  | `[]`                                |


### Other Parameters

| Name                    | Description                                          | Value  |
| ----------------------- | ---------------------------------------------------- | ------ |
| `rbac.create`           | Specifies whether RBAC resources should be created   | `true` |
| `serviceAccount.create` | Specifies whether a ServiceAccount should be created | `true` |
| `serviceAccount.name`   | The name of the ServiceAccount to use.               | `""`   |


### Metrics parameters

| Name                                       | Description                                                                 | Value                    |
| ------------------------------------------ | --------------------------------------------------------------------------- | ------------------------ |
| `metrics.enabled`                          | Create a service for accessing the metrics endpoint                         | `false`                  |
| `metrics.service.type`                     | RabbitMQ Cluster Operator metrics service type                              | `ClusterIP`              |
| `metrics.service.port`                     | RabbitMQ Cluster Operator metrics service HTTP port                         | `80`                     |
| `metrics.service.nodePorts.http`           | Node port for HTTP                                                          | `""`                     |
| `metrics.service.clusterIP`                | RabbitMQ Cluster Operator metrics service Cluster IP                        | `""`                     |
| `metrics.service.loadBalancerIP`           | RabbitMQ Cluster Operator metrics service Load Balancer IP                  | `""`                     |
| `metrics.service.loadBalancerSourceRanges` | RabbitMQ Cluster Operator metrics service Load Balancer sources             | `[]`                     |
| `metrics.service.externalTrafficPolicy`    | RabbitMQ Cluster Operator metrics service external traffic policy           | `Cluster`                |
| `metrics.service.annotations`              | Additional custom annotations for RabbitMQ Cluster Operator metrics service | `{}`                     |
| `metrics.serviceMonitor.enabled`           | Specify if a servicemonitor will be deployed for prometheus-operator        | `false`                  |
| `metrics.serviceMonitor.jobLabel`          | Specify the jobLabel to use for the prometheus-operator                     | `app.kubernetes.io/name` |
| `metrics.serviceMonitor.interval`          | Scrape interval. If not set, the Prometheus default scrape interval is used | `""`                     |
| `metrics.serviceMonitor.metricRelabelings` | Specify additional relabeling of metrics                                    | `[]`                     |
| `metrics.serviceMonitor.relabelings`       | Specify general relabeling                                                  | `[]`                     |


See [readme-generator-for-helm](https://github.com/bitnami-labs/readme-generator-for-helm) to create the table.

The above parameters map to the env variables defined in [bitnami/rabbitmq-cluster-operator](http://github.com/bitnami/bitnami-docker-rabbitmq-cluster-operator). For more information please refer to the [bitnami/rabbitmq-cluster-operator](http://github.com/bitnami/bitnami-docker-rabbitmq-cluster-operator) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
  --set livenessProbe.enabled=false \
    bitnami/rabbitmq-cluster-operator
```

The above command disables the Operator liveness probes.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml bitnami/rabbitmq-cluster-operator
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

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

If additional containers are needed in the same pod as rabbitmq-cluster-operator (such as additional metrics or logging exporters), they can be defined using the `sidecars` parameter. If these sidecars export extra ports, extra port definitions can be added using the `service.extraPorts` parameter. [Learn more about configuring and using sidecar containers](https://docs.bitnami.com/kubernetes/apps/rabbitmq-cluster-operator/administration/configure-use-sidecars/).

### Pod affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, use one of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.
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
