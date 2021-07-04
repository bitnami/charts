# grafana-operator

[Grafana Operator](https://github.com/integr8ly/grafana-operator) is an Operator which introduces Lifecycle Management for Grafana Dashboards and Plugins.

## TL;DR

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/grafana-operator
```

## Introduction
Bitnami charts for Helm are carefully engineered, actively maintained and are the quickest and easiest way to deploy containers on a Kubernetes cluster that are ready to handle production workloads.

This chart bootstraps a [Grafana Operator](https://github.com/integr8ly/grafana-operator/blob/master/documentation/deploy_grafana.md) Deployment [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This Helm chart has been tested on top of [Bitnami Kubernetes Production Runtime](https://kubeprod.io/) (BKPR). Deploy BKPR to get automated TLS certificates, logging and monitoring for your applications.

## Prerequisites

- Kubernetes 1.12+
- Helm 3.1.0

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

In the Bitnami catalog we offer both the *bitnami/grafana* and *bitnami/grafana-operator* charts. Each solution covers different needs and use cases.

The *bitnami/grafana* chart deploys a single Grafana installation (with Grafana Image Renderer) using a Kubernetes Deployment object (together with Services, PVCs, ConfigMaps, etc.). The figure below shows the deployed objects in the cluster after executing *helm install*:

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

The operator will extend the Kubernetes API with the following objects: *Grafana*, *GrafanaDashboards* and *GrafanaDataSources*. From that moment, the user will be able to deploy objects of these kinds and the previously deployed Operator will take care of deploying all the required Deployments, ConfigMaps and Services for running a Grafana instance. Its lifecycle is managed using *kubectl* on the Grafana, GrafanaDashboards and GrafanaDataSource objects. The following figure shows the deployed objects after deploying a *Grafana* object using *kubectl*:

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

This solution allows to easily deploy multiple Grafana instances compared to the *bitnami/grafana* chart. As the operator automatically deploys Grafana installations, the Grafana Operator pods will require a ServiceAccount with privileges to create and destroy multiple Kubernetes objects. This may be problematic for Kubernetes clusters with strict role-based access policies.

## Parameters

### Global parameters

| Name                      | Description                                     | Value |
| ------------------------- | ----------------------------------------------- | ----- |
| `global.imageRegistry`    | Global Docker image registry                    | `nil` |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]`  |


### Common parameters

| Name                | Description                                                                                               | Value |
| ------------------- | --------------------------------------------------------------------------------------------------------- | ----- |
| `nameOverride`      | String to partially override common.names.fullname template with a string (will prepend the release name) | `nil` |
| `fullnameOverride`  | String to fully override common.names.fullname template with a string                                     | `nil` |
| `extraDeploy`       | Array of extra objects to deploy with the release                                                         | `[]`  |
| `commonLabels`      | Common Labels which are applied to every resource deployed                                                | `{}`  |
| `commonAnnotations` | Common Annotations which are applied to every ressource deployed                                          | `{}`  |


### Grafana Operator parameters

| Name                                                         | Description                                                                                                            | Value                      |
| ------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------- | -------------------------- |
| `operator.enabled`                                           | Enable the deployment of the Grafana Operator                                                                          | `true`                     |
| `operator.replicaCount`                                      | Number of grafana-operator Pod replicas                                                                                | `1`                        |
| `operator.updateStrategy.type`                               | Set up update strategy for Grafana installation.                                                                       | `Recreate`                 |
| `operator.image.registry`                                    | Grafana Operator image registry                                                                                        | `docker.io`                |
| `operator.image.repository`                                  | Grafana Operator image name                                                                                            | `bitnami/grafana-operator` |
| `operator.image.tag`                                         | Grafana Operator image tag                                                                                             | `3.10.2-debian-10-r0`      |
| `operator.image.pullPolicy`                                  | Grafana Operator image pull policy                                                                                     | `IfNotPresent`             |
| `operator.image.pullSecrets`                                 | Grafana Operator image pull secrets                                                                                    | `[]`                       |
| `operator.args.scanAllNamespaces`                            | Specify if all namespace should be scanned for dashboards and datasources. (Creates ClusterRole)                       | `false`                    |
| `operator.args.scanNamespaces`                               | Specify the namespaces which should be scanned for dashboards and datasources (Creates ClusterRole)                    | `[]`                       |
| `operator.rbac.create`                                       | Create specifies whether to install and use RBAC rules                                                                 | `true`                     |
| `operator.serviceAccount.create`                             | Specifies whether a service account should be created                                                                  | `true`                     |
| `operator.serviceAccount.name`                               | The name of the service account to use. If not set and create is true, a name is generated using the fullname template | `nil`                      |
| `operator.podSecurityContext.enabled`                        | Enable pods security context                                                                                           | `true`                     |
| `operator.podSecurityContext.runAsUser`                      | User ID for the pods                                                                                                   | `1001`                     |
| `operator.podSecurityContext.runAsGroup`                     | User ID for the pods                                                                                                   | `1001`                     |
| `operator.podSecurityContext.runAsNonRoot`                   | Grafana Operator must run as nonRoot                                                                                   | `true`                     |
| `operator.podSecurityContext.fsGroup`                        | Group ID for the pods                                                                                                  | `1001`                     |
| `operator.podSecurityContext.supplementalGroups`             | Which group IDs containers add                                                                                         | `[]`                       |
| `operator.containerSecurityContext.enabled`                  | Enable container security context                                                                                      | `true`                     |
| `operator.containerSecurityContext.runAsUser`                | User ID for the operator container                                                                                     | `1001`                     |
| `operator.containerSecurityContext.runAsGroup`               | User ID for the operator container                                                                                     | `1001`                     |
| `operator.containerSecurityContext.readOnlyRootFilesystem`   | ReadOnlyRootFilesystem fot the operator container                                                                      | `false`                    |
| `operator.containerSecurityContext.allowPrivilegeEscalation` | Allow Privilege Escalation for the operator container                                                                  | `false`                    |
| `operator.resources`                                         | Container resource requests and limits                                                                                 | `{}`                       |
| `operator.hostAliases`                                       | Add deployment host aliases                                                                                            | `[]`                       |
| `operator.podAffinityPreset`                                 | Pod affinity preset                                                                                                    | `""`                       |
| `operator.podAntiAffinityPreset`                             | Pod anti-affinity preset. Allowed values: `soft` or `hard`                                                             | `soft`                     |
| `operator.nodeAffinityPreset.type`                           | Node affinity preset type. Allowed values: `soft` or `hard`                                                            | `""`                       |
| `operator.nodeAffinityPreset.key`                            | Set nodeAffinity preset key                                                                                            | `""`                       |
| `operator.nodeAffinityPreset.values`                         | Set nodeAffinity preset values                                                                                         | `[]`                       |
| `operator.podAnnotations`                                    | Pod annotations                                                                                                        | `{}`                       |
| `operator.podLabels`                                         | Additional pod labels                                                                                                  | `{}`                       |
| `operator.nodeSelector`                                      | Node labels for pod assignment                                                                                         | `{}`                       |
| `operator.tolerations`                                       | Tolerations for controller pod assignment                                                                              | `[]`                       |
| `operator.affinity`                                          | Affinity for controller pod assignment                                                                                 | `{}`                       |
| `operator.prometheus.serviceMonitor.enabled`                 | Specify if a servicemonitor will be deployed for prometheus-operator                                                   | `false`                    |
| `operator.prometheus.serviceMonitor.jobLabel`                | Specify the jobLabel to use for the prometheus-operator                                                                | `app.kubernetes.io/name`   |
| `operator.prometheus.serviceMonitor.interval`                | Scrape interval. If not set, the Prometheus default scrape interval is used                                            | `""`                       |
| `operator.prometheus.serviceMonitor.metricRelabelings`       | Specify additional relabeling of metrics                                                                               | `[]`                       |
| `operator.prometheus.serviceMonitor.relabelings`             | Specify general relabeling                                                                                             | `[]`                       |
| `operator.livenessProbe.enabled`                             | Enable livenessProbe                                                                                                   | `true`                     |
| `operator.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                | `10`                       |
| `operator.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                       | `10`                       |
| `operator.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                      | `1`                        |
| `operator.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                    | `3`                        |
| `operator.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                    | `1`                        |
| `operator.readinessProbe.enabled`                            | Enable readinessProbe                                                                                                  | `true`                     |
| `operator.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                               | `10`                       |
| `operator.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                      | `10`                       |
| `operator.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                     | `1`                        |
| `operator.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                   | `3`                        |
| `operator.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                   | `1`                        |


### Grafana parameters

| Name                                                        | Description                                                                                   | Value                |
| ----------------------------------------------------------- | --------------------------------------------------------------------------------------------- | -------------------- |
| `grafana.enabled`                                           | Enabled the deployment of the Grafana CRD object into the cluster                             | `true`               |
| `grafana.image.registry`                                    | Grafana image registry                                                                        | `docker.io`          |
| `grafana.image.repository`                                  | Grafana image name                                                                            | `bitnami/grafana`    |
| `grafana.image.tag`                                         | Grafana image tag                                                                             | `7.5.9-debian-10-r1` |
| `grafana.image.pullSecrets`                                 | Grafana image pull secrets                                                                    | `[]`                 |
| `grafana.podSecurityContext.enabled`                        | Enable pods security context                                                                  | `true`               |
| `grafana.podSecurityContext.runAsUser`                      | User ID for the pods                                                                          | `1001`               |
| `grafana.podSecurityContext.runAsGroup`                     | User ID for the pods                                                                          | `1001`               |
| `grafana.podSecurityContext.runAsNonRoot`                   | Grafana Operator must run as nonRoot                                                          | `true`               |
| `grafana.podSecurityContext.fsGroup`                        | Group ID for the pods                                                                         | `1001`               |
| `grafana.podSecurityContext.supplementalGroups`             | Which group IDs containers add                                                                | `[]`                 |
| `grafana.containerSecurityContext.enabled`                  | Enable containers security context                                                            | `true`               |
| `grafana.containerSecurityContext.runAsUser`                | User ID for the containers                                                                    | `1001`               |
| `grafana.containerSecurityContext.runAsGroup`               | Group ID for the containers                                                                   | `1001`               |
| `grafana.containerSecurityContext.fsGroup`                  | Filesystem Group ID for the containers                                                        | `1001`               |
| `grafana.containerSecurityContext.allowPrivilegeEscalation` | Don't allow privilege escalation for the containers                                           | `false`              |
| `grafana.resources.limits`                                  | The resources limits for the container                                                        | `{}`                 |
| `grafana.resources.requests`                                | The requested resources for the container                                                     | `{}`                 |
| `grafana.replicaCount`                                      | Specify the amount of replicas running                                                        | `1`                  |
| `grafana.podAffinityPreset`                                 | Pod affinity preset                                                                           | `""`                 |
| `grafana.podAntiAffinityPreset`                             | Pod anti-affinity preset                                                                      | `soft`               |
| `grafana.nodeAffinityPreset.type`                           | Set nodeAffinity preset type                                                                  | `""`                 |
| `grafana.nodeAffinityPreset.key`                            | Set nodeAffinity preset key                                                                   | `""`                 |
| `grafana.nodeAffinityPreset.values`                         | Set nodeAffinity preset values                                                                | `[]`                 |
| `grafana.affinity`                                          | Affinity for controller pod assignment                                                        | `{}`                 |
| `grafana.nodeSelector`                                      | Node labels for controller pod assignment                                                     | `{}`                 |
| `grafana.tolerations`                                       | Tolerations for controller pod assignment                                                     | `[]`                 |
| `grafana.envFrom`                                           | Extra environment variable to pass to the running container                                   | `[]`                 |
| `grafana.client.timeout`                                    | The timeout in seconds for the Grafana Rest API on that instance                              | `5`                  |
| `grafana.client.preferService`                              | If the API should be used via Ingress or via the internal service                             | `true`               |
| `grafana.ingress.enabled`                                   | If an ingress or OpenShift Route should be created                                            | `false`              |
| `grafana.ingress.hostname`                                  | The hostname under which the grafana instance should be reachable                             | `grafana.local`      |
| `grafana.ingress.path`                                      | The path for the ingress instance to forward to the grafana app                               | `/`                  |
| `grafana.ingress.labels`                                    | Additional Labels for the ingress resource                                                    | `{}`                 |
| `grafana.ingress.annotations`                               | Additional Annotations for the ingress resource                                               | `{}`                 |
| `grafana.ingress.tls`                                       | This enables tls support for the ingress resource                                             | `false`              |
| `grafana.ingress.tlsSecret`                                 | The name for the secret to use for the tls termination                                        | `grafana.local-tls`  |
| `grafana.persistence.enabled`                               | Enable persistent storage for the grafana deployment                                          | `false`              |
| `grafana.persistence.storageClass`                          | Define the storageClass for the persistent storage if not defined default is used             | `nil`                |
| `grafana.persistence.accessMode`                            | Define the accessMode for the persistent storage                                              | `ReadWriteOnce`      |
| `grafana.persistence.size`                                  | Define the size of the PersistentVolumeClaim to request for                                   | `10Gi`               |
| `grafana.config`                                            | grafana.ini configuration for the instance for this to configure please look at upstream docs | `{}`                 |
| `grafana.configMaps`                                        | Extra configMaps to mount into the grafana pod                                                | `[]`                 |
| `grafana.secrets`                                           | Extra secrets to mount into the grafana pod                                                   | `[]`                 |
| `grafana.jsonnetLibrarySelector`                            | Configuring the read for jsonnetLibraries to pull in.                                         | `{}`                 |
| `grafana.dashboardLabelSelectors`                           | This selects dashboards on the label.                                                         | `{}`                 |
| `grafana.livenessProbe.enabled`                             | Enable livenessProbe                                                                          | `true`               |
| `grafana.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                       | `120`                |
| `grafana.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                              | `10`                 |
| `grafana.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                             | `5`                  |
| `grafana.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                           | `6`                  |
| `grafana.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                           | `1`                  |
| `grafana.readinessProbe.enabled`                            | Enable readinessProbe                                                                         | `true`               |
| `grafana.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                      | `30`                 |
| `grafana.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                             | `10`                 |
| `grafana.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                            | `5`                  |
| `grafana.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                          | `6`                  |
| `grafana.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                          | `1`                  |


### PluginInit parameters

| Name                                  | Description                            | Value                |
| ------------------------------------- | -------------------------------------- | -------------------- |
| `grafanaPluginInit.image.registry`    | Grafana Plugin Init image registry     | `docker.io`          |
| `grafanaPluginInit.image.repository`  | Grafana Plugin Init image name         | `bitnami/grafana`    |
| `grafanaPluginInit.image.tag`         | Grafana Plugin Init image tag          | `7.5.9-debian-10-r1` |
| `grafanaPluginInit.image.pullSecrets` | Grafana Plugin Init image pull secrets | `[]`                 |


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

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Documentation for the Configuration of Dashboards

After the installation you can create your Dashboards under a CRD of your kubernetes cluster.

For more details regarding what is possible with those CRDs please have a look at [Working with Dashboards](https://github.com/integr8ly/grafana-operator/blob/master/documentation/dashboards.md).

### Deploying extra resources

There are cases where you may want to deploy extra objects, such your custom *Grafana*, *GrafanaDashboards* or *GrafanaDataSource* objects. For covering this case, the chart allows adding the full specification of other objects using the `extraDeploy` parameter.

For instance, to deploy your custom *Grafana* definition, you can install the Grafana Operator using the values below:

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

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami’s Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

```bash
$ helm upgrade my-release bitnami/grafana-operator
```
