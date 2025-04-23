<!--- app-name: ClickHouse Operator -->

# Bitnami package for ClickHouse Operator

ClickHouse Operator is a production-ready operator that manages ClickHouse databases delivering robust features required for cost-efficient, real-time analytic applications.

[Overview of ClickHouse Operator](https://altinity.com/kubernetes-operator/)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/clickhouse-operator
```

Looking to use ClickHouse Operator in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the commercial edition of the Bitnami catalog.

## Introduction

Bitnami charts for Helm are carefully engineered, actively maintained and are the quickest and easiest way to deploy containers on a Kubernetes cluster that are ready to handle production workloads.

This chart bootstraps a [ClickHouse Operator](https://github.com/Altinity/clickhouse-operator) Deployment in a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+
- PV provisioner support in the underlying infrastructure
- ReadWriteMany volumes for deployment scaling

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/clickhouse-operator
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The command deploys ClickHouse Operator on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Configuration and installation details

### Configure the operator

The ClickHouse Operator chart is designed to be easily configurable. The default configuration is suitable for most use cases, but you can customize it to suit your needs.

The `configuration` parameter allows you to specify the content of the ClickHouse Operator configuration. By default, it is auto-generated based on other values. You can also use the `overrideConfiguration` parameter to override specific values in the configuration. You can also use the `chiTemplate` and `chkTemplate` parameters to specify the templates for ClickHouse installations and ClickHouse Keeper installation, respectively.

As an alternative, existing ConfigMaps containing the configuration can be used. To do so, the chart exposes parameter such as `existingConfigmap`, `existingChiTemplatesConfigmap` or `existingChkTemplatesConfigmap`.

Please refer to the [official documentation](https://github.com/Altinity/clickhouse-operator/blob/master/docs/operator_configuration.md) to learn more about the configuration options available for ClickHouse Operator.

### Additional environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `extraEnvVars` property.

```yaml
extraEnvVars:
  - name: LOG_LEVEL
    value: error
```

### Resource requests and limits

Bitnami charts allow setting resource requests and limits for all containers inside the chart deployment. These are inside the `resources` value (check parameter table). Setting requests is essential for production workloads and these should be adapted to your specific use case.

To make this process easier, the chart contains the `resourcesPreset` values, which automatically sets the `resources` section according to different presets. Check these presets in [the bitnami/common chart](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15). However, in production workloads using `resourcesPreset` is discouraged as it may not fully adapt to your specific needs. Find more information on container resource management in the [official Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values.

### [Rolling VS Immutable tags](https://docs.vmware.com/en/VMware-Tanzu-Application-Catalog/services/tutorials/GUID-understand-rolling-tags-containers-index.html)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Sidecars

If additional containers are needed in the same pod as ClickHouse Operator (such as additional logging exporters), they can be defined using the `sidecars` parameter.

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

### Pod affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, use one of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

### Prometheus metrics

This chart can be integrated with Prometheus by setting `metrics.enabled` to `true`. This will deploy a sidecar container with [ClickHouse Operator Metrics exporter](https://github.com/bitnami/containers/tree/main/bitnami/clickhouse-operator-metrics-exporter) in all pods and a K8s service, which can be configured under the `service` section. This service will have the necessary annotations to be automatically scraped by Prometheus.

#### Prometheus requirements

It is necessary to have a working installation of Prometheus or Prometheus Operator for the integration to work. Install the [Bitnami Prometheus helm chart](https://github.com/bitnami/charts/tree/main/bitnami/prometheus) or the [Bitnami Kube Prometheus helm chart](https://github.com/bitnami/charts/tree/main/bitnami/kube-prometheus) to easily have a working Prometheus in your cluster.

#### Integration with Prometheus Operator

The chart can deploy `ServiceMonitor` objects for integration with Prometheus Operator installations. To do so, set the value `metrics.serviceMonitor.enabled=true`. Ensure that the Prometheus Operator `CustomResourceDefinitions` are installed in the cluster or it will fail with the following error:

```text
no matches for kind "ServiceMonitor" in version "monitoring.coreos.com/v1"
```

Install the [Bitnami Kube Prometheus helm chart](https://github.com/bitnami/charts/tree/main/bitnami/kube-prometheus) for having the necessary CRDs and the Prometheus Operator.

### Deploying extra resources

Apart from the Operator, you may want to deploy ClickHouse Installation or ClickHouse Keeper Installation objects. For covering this case, the chart allows adding the full specification of other objects using the `extraDeploy` parameter. The following examples creates a ClickHouse Installation using the `default-clickhouse` pod template and a ClickHouse Keeper Installation using the `default-keeper` pod template:

```yaml
extraDeploy:
- apiVersion: clickhouse.altinity.com/v1
  kind: ClickHouseInstallation
  metadata:
    name: test
  spec:
    defaults:
      templates:
        podTemplate: default-clickhouse
        dataVolumeClaimTemplate: default-volume-claim
    configuration:
      settings:
        http_port: 8123
        tcp_port: 9000
        interserver_http_port: 9009
      users:
        default/networks/ip:
        - 0.0.0.0/0
        - '::/0'
      clusters:
      - name: cluster
        layout:
          replicasCount: 1
      zookeeper:
        nodes:
          - host: chk-test-cluster
            port: 2181
    templates:
      podTemplates:
      - name: default-clickhouse
        distribution: Unspecified
        spec:
          containers:
          - name: clickhouse
            image: docker.io/bitnami/clickhouse
            volumeMounts:
            - name: default-volume-claim
              mountPath: /bitnami/clickhouse
      volumeClaimTemplates:
      - name: default-volume-claim
        spec:
          accessModes:
          - ReadWriteOnce
          resources:
            requests:
              storage: 8Gi
- apiVersion: clickhouse-keeper.altinity.com/v1
  kind: ClickHouseKeeperInstallation
  metadata:
    name: test
  spec:
    defaults:
      templates:
        podTemplate: default-keeper
        dataVolumeClaimTemplate: default-volume-claim
    configuration:
      clusters:
        - name: cluster
          layout:
            replicasCount: 1
    templates:
      podTemplates:
      - name: default-keeper
        distribution: Unspecified
        spec:
          containers:
          - name: clickhouse-keeper
            image: docker.io/bitnami/clickhouse-keeper
            workingDir: /var/lib/clickhouse-keeper
            env:
            - name: CLICKHOUSE_KEEPER_SERVER_ID
              valueFrom:
                fieldRef:
                  fieldPath: metadata.name
            volumeMounts:
            - name: default-volume-claim
              mountPath: /bitnami/clickhouse-keeper
      volumeClaimTemplates:
      - name: default-volume-claim
        spec:
          accessModes:
          - ReadWriteOnce
          resources:
            requests:
              storage: 8Gi
- apiVersion: v1
  kind: Service
  metadata:
    name: chk-test-cluster
    labels:
      clickhouse-keeper.altinity.com/chk: test
      clickhouse-keeper.altinity.com/cluster: cluster
  spec:
    ports:
      - port: 2181
        name: client
    selector:
      clickhouse-keeper.altinity.com/chk: test
      clickhouse-keeper.altinity.com/cluster: cluster
      clickhouse-keeper.altinity.com/ready: "yes"
```

Check the [official quickstart guide](https://docs.altinity.com/altinitykubernetesoperator/kubernetesquickstartguide/quickcluster/) for more examples of how to deploy ClickHouse Installations.

## Parameters

### Global parameters

| Name                                                  | Description                                                                                                                                                                                                                                                                                                                                                         | Value   |
| ----------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `global.imageRegistry`                                | Global Docker image registry                                                                                                                                                                                                                                                                                                                                        | `""`    |
| `global.imagePullSecrets`                             | Global Docker registry secret names as an array                                                                                                                                                                                                                                                                                                                     | `[]`    |
| `global.defaultStorageClass`                          | Global default StorageClass for Persistent Volume(s)                                                                                                                                                                                                                                                                                                                | `""`    |
| `global.security.allowInsecureImages`                 | Allows skipping image verification                                                                                                                                                                                                                                                                                                                                  | `false` |
| `global.compatibility.openshift.adaptSecurityContext` | Adapt the securityContext sections of the deployment to make them compatible with Openshift restricted-v2 SCC: remove runAsUser, runAsGroup and fsGroup and let the platform use their allowed default IDs. Possible values: auto (apply if the detected running cluster is Openshift), force (perform the adaptation always), disabled (do not perform adaptation) | `auto`  |
| `global.compatibility.omitEmptySeLinuxOptions`        | If set to true, removes the seLinuxOptions from the securityContexts when it is set to an empty object                                                                                                                                                                                                                                                              | `false` |

### Common parameters

| Name                | Description                                                | Value           |
| ------------------- | ---------------------------------------------------------- | --------------- |
| `kubeVersion`       | Override Kubernetes version                                | `""`            |
| `apiVersions`       | Override Kubernetes API versions reported by .Capabilities | `[]`            |
| `nameOverride`      | String to partially override common.names.name             | `""`            |
| `fullnameOverride`  | String to fully override common.names.fullname             | `""`            |
| `namespaceOverride` | String to fully override common.names.namespace            | `""`            |
| `commonLabels`      | Labels to add to all deployed objects                      | `{}`            |
| `commonAnnotations` | Annotations to add to all deployed objects                 | `{}`            |
| `clusterDomain`     | Kubernetes cluster domain name                             | `cluster.local` |
| `extraDeploy`       | Array of extra objects to deploy with the release          | `[]`            |

### ClickHouse Operator Parameters

| Name                                                | Description                                                                                                                                                                                                                    | Value                                 |
| --------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------- |
| `image.registry`                                    | ClickHouse Operator image registry                                                                                                                                                                                             | `REGISTRY_NAME`                       |
| `image.repository`                                  | ClickHouse Operator image repository                                                                                                                                                                                           | `REPOSITORY_NAME/clickhouse-operator` |
| `image.digest`                                      | ClickHouse Operator image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag image tag (immutable tags are recommended)                                                                 | `""`                                  |
| `image.pullPolicy`                                  | ClickHouse Operator image pull policy                                                                                                                                                                                          | `IfNotPresent`                        |
| `image.pullSecrets`                                 | ClickHouse Operator image pull secrets                                                                                                                                                                                         | `[]`                                  |
| `clickHouseImage.registry`                          | ClickHouse image registry                                                                                                                                                                                                      | `REGISTRY_NAME`                       |
| `clickHouseImage.repository`                        | ClickHouse image repository                                                                                                                                                                                                    | `REPOSITORY_NAME/clickhouse`          |
| `clickHouseImage.digest`                            | ClickHouse image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag image tag (immutable tags are recommended)                                                                          | `""`                                  |
| `clickHouseImage.pullPolicy`                        | ClickHouse image pull policy                                                                                                                                                                                                   | `IfNotPresent`                        |
| `clickHouseImage.pullSecrets`                       | ClickHouse image pull secrets                                                                                                                                                                                                  | `[]`                                  |
| `keeperImage.registry`                              | ClickHouse Keeper image registry                                                                                                                                                                                               | `REGISTRY_NAME`                       |
| `keeperImage.repository`                            | ClickHouse Keeper image repository                                                                                                                                                                                             | `REPOSITORY_NAME/clickhouse-keeper`   |
| `keeperImage.digest`                                | ClickHouse Keeper image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag image tag (immutable tags are recommended)                                                                   | `""`                                  |
| `keeperImage.pullPolicy`                            | ClickHouse Keeper image pull policy                                                                                                                                                                                            | `IfNotPresent`                        |
| `keeperImage.pullSecrets`                           | ClickHouse Keeper image pull secrets                                                                                                                                                                                           | `[]`                                  |
| `auth.username`                                     | ClickHouse Admin username                                                                                                                                                                                                      | `default`                             |
| `auth.password`                                     | ClickHouse Admin password                                                                                                                                                                                                      | `""`                                  |
| `auth.existingSecret`                               | Name of a secret containing the Admin credentials                                                                                                                                                                              | `""`                                  |
| `auth.existingSecretUsernameKey`                    | Name of the key inside the existing secret containing the Admin username                                                                                                                                                       | `""`                                  |
| `auth.existingSecretPasswordKey`                    | Name of the key inside the existing secret containing the Admin password                                                                                                                                                       | `""`                                  |
| `replicaCount`                                      | Number of ClickHouse Operator replicas to deploy                                                                                                                                                                               | `1`                                   |
| `containerPorts.metrics`                            | ClickHouse Operator Metrics container port                                                                                                                                                                                     | `9999`                                |
| `extraContainerPorts`                               | Optionally specify extra list of additional ports for ClickHouse Operator containers                                                                                                                                           | `[]`                                  |
| `livenessProbe.enabled`                             | Enable livenessProbe on ClickHouse Operator containers                                                                                                                                                                         | `true`                                |
| `livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                                        | `5`                                   |
| `livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                               | `10`                                  |
| `livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                              | `5`                                   |
| `livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                                            | `5`                                   |
| `livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                                            | `1`                                   |
| `readinessProbe.enabled`                            | Enable readinessProbe on ClickHouse Operator containers                                                                                                                                                                        | `true`                                |
| `readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                                       | `5`                                   |
| `readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                              | `10`                                  |
| `readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                             | `5`                                   |
| `readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                                           | `5`                                   |
| `readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                                           | `1`                                   |
| `startupProbe.enabled`                              | Enable startupProbe on ClickHouse Operator containers                                                                                                                                                                          | `false`                               |
| `startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                                         | `5`                                   |
| `startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                                | `10`                                  |
| `startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                               | `5`                                   |
| `startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                             | `5`                                   |
| `startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                             | `1`                                   |
| `customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                                                                                                                            | `{}`                                  |
| `customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                                                                                                                                           | `{}`                                  |
| `customStartupProbe`                                | Custom startupProbe that overrides the default one                                                                                                                                                                             | `{}`                                  |
| `resourcesPreset`                                   | Set ClickHouse Operator container resources according to one common preset (allowed values: none, nano, small, medium, large, xlarge, 2xlarge). This is ignored if resources is set (resources is recommended for production). | `nano`                                |
| `resources`                                         | Set ClickHouse Operator container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                          | `{}`                                  |
| `podSecurityContext.enabled`                        | Enable ClickHouse Operator pods' Security Context                                                                                                                                                                              | `true`                                |
| `podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy for ClickHouse Operator pods                                                                                                                                                                | `Always`                              |
| `podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface for ClickHouse Operator pods                                                                                                                                                    | `[]`                                  |
| `podSecurityContext.supplementalGroups`             | Set filesystem extra groups for ClickHouse Operator pods                                                                                                                                                                       | `[]`                                  |
| `podSecurityContext.fsGroup`                        | Set fsGroup in ClickHouse Operator pods' Security Context                                                                                                                                                                      | `1001`                                |
| `containerSecurityContext.enabled`                  | Enabled ClickHouse Operator container' Security Context                                                                                                                                                                        | `true`                                |
| `containerSecurityContext.seLinuxOptions`           | Set SELinux options in ClickHouse Operator container                                                                                                                                                                           | `{}`                                  |
| `containerSecurityContext.runAsUser`                | Set runAsUser in ClickHouse Operator container' Security Context                                                                                                                                                               | `1001`                                |
| `containerSecurityContext.runAsGroup`               | Set runAsGroup in ClickHouse Operator container' Security Context                                                                                                                                                              | `1001`                                |
| `containerSecurityContext.runAsNonRoot`             | Set runAsNonRoot in ClickHouse Operator container' Security Context                                                                                                                                                            | `true`                                |
| `containerSecurityContext.readOnlyRootFilesystem`   | Set readOnlyRootFilesystem in ClickHouse Operator container' Security Context                                                                                                                                                  | `true`                                |
| `containerSecurityContext.privileged`               | Set privileged in ClickHouse Operator container' Security Context                                                                                                                                                              | `false`                               |
| `containerSecurityContext.allowPrivilegeEscalation` | Set allowPrivilegeEscalation in ClickHouse Operator container' Security Context                                                                                                                                                | `false`                               |
| `containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped in ClickHouse Operator container                                                                                                                                                            | `["ALL"]`                             |
| `containerSecurityContext.seccompProfile.type`      | Set seccomp profile in ClickHouse Operator container                                                                                                                                                                           | `RuntimeDefault`                      |
| `configuration`                                     | Specify content for ClickHouse Operator configuration (basic one auto-generated based on other values otherwise)                                                                                                               | `{}`                                  |
| `overrideConfiguration`                             | ClickHouse Operator configuration override. Values defined here takes precedence over the ones defined at `configuration`                                                                                                      | `{}`                                  |
| `existingConfigmap`                                 | The name of an existing ConfigMap with your custom configuration for ClickHouse Operator                                                                                                                                       | `""`                                  |
| `chiTemplate`                                       | ClickHouse Installation default template (basic one auto-generated based on other values otherwise)                                                                                                                            | `{}`                                  |
| `existingChiTemplatesConfigmap`                     | The name of an existing ConfigMap with your custom ClickHouse Installation templates                                                                                                                                           | `""`                                  |
| `chiConfigd`                                        | Configuration files for ClickHouse (basic ones auto-generated based on other values otherwise)                                                                                                                                 | `[]`                                  |
| `existingChiConfigdConfigmap`                       | The name of an existing ConfigMap with your custom configuration files for ClickHouse                                                                                                                                          | `""`                                  |
| `chiUsersd`                                         | Users configuration files for ClickHouse (basic ones auto-generated based on other values otherwise)                                                                                                                           | `[]`                                  |
| `existingChiUsersdConfigmap`                        | The name of an existing ConfigMap with your custom users configuration files for ClickHouse                                                                                                                                    | `""`                                  |
| `chkTemplate`                                       | ClickHouse Keeper Installation default template (basic one auto-generated based on other values otherwise)                                                                                                                     | `{}`                                  |
| `existingChkTemplatesConfigmap`                     | The name of an existing ConfigMap with your custom ClickHouse Keeper Installation templates                                                                                                                                    | `""`                                  |
| `chkConfigd`                                        | Configuration files for ClickHouse Keeper (basic ones auto-generated based on other values otherwise)                                                                                                                          | `[]`                                  |
| `existingChkConfigdConfigmap`                       | The name of an existing ConfigMap with your custom configuration files for ClickHouse Keeper                                                                                                                                   | `""`                                  |
| `chkUsersd`                                         | Users configuration files for ClickHouse Keeper (basic ones auto-generated based on other values otherwise)                                                                                                                    | `[]`                                  |
| `existingChkUsersdConfigmap`                        | The name of an existing ConfigMap with your custom users configuration files for ClickHouse Keeper                                                                                                                             | `""`                                  |
| `watchAllNamespaces`                                | Watch for ClickHouse Operator resources in all namespaces                                                                                                                                                                      | `false`                               |
| `watchNamespaces`                                   | Watch for ClickHouse Operator resources in the given namespaces                                                                                                                                                                | `[]`                                  |
| `command`                                           | Override default ClickHouse Operator container command (useful when using custom images)                                                                                                                                       | `[]`                                  |
| `args`                                              | Override default ClickHouse Operator container args (useful when using custom images)                                                                                                                                          | `[]`                                  |
| `automountServiceAccountToken`                      | Mount Service Account token in ClickHouse Operator pods                                                                                                                                                                        | `true`                                |
| `hostAliases`                                       | ClickHouse Operator pods host aliases                                                                                                                                                                                          | `[]`                                  |
| `deploymentAnnotations`                             | Annotations for ClickHouse Operator deployment                                                                                                                                                                                 | `{}`                                  |
| `podLabels`                                         | Extra labels for ClickHouse Operator pods                                                                                                                                                                                      | `{}`                                  |
| `podAnnotations`                                    | Annotations for ClickHouse Operator pods                                                                                                                                                                                       | `{}`                                  |
| `podAffinityPreset`                                 | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                            | `""`                                  |
| `podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                       | `soft`                                |
| `nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                      | `""`                                  |
| `nodeAffinityPreset.key`                            | Node label key to match. Ignored if `affinity` is set                                                                                                                                                                          | `""`                                  |
| `nodeAffinityPreset.values`                         | Node label values to match. Ignored if `affinity` is set                                                                                                                                                                       | `[]`                                  |
| `affinity`                                          | Affinity for ClickHouse Operator pods assignment                                                                                                                                                                               | `{}`                                  |
| `nodeSelector`                                      | Node labels for ClickHouse Operator pods assignment                                                                                                                                                                            | `{}`                                  |
| `tolerations`                                       | Tolerations for ClickHouse Operator pods assignment                                                                                                                                                                            | `[]`                                  |
| `updateStrategy.type`                               | ClickHouse Operator deployment strategy type                                                                                                                                                                                   | `RollingUpdate`                       |
| `priorityClassName`                                 | ClickHouse Operator pods' priorityClassName                                                                                                                                                                                    | `""`                                  |
| `topologySpreadConstraints`                         | Topology Spread Constraints for ClickHouse Operator pod assignment spread across your cluster among failure-domains                                                                                                            | `[]`                                  |
| `schedulerName`                                     | Name of the k8s scheduler (other than default) for ClickHouse Operator pods                                                                                                                                                    | `""`                                  |
| `terminationGracePeriodSeconds`                     | Seconds ClickHouse Operator pods need to terminate gracefully                                                                                                                                                                  | `""`                                  |
| `lifecycleHooks`                                    | for ClickHouse Operator containers to automate configuration before or after startup                                                                                                                                           | `{}`                                  |
| `extraEnvVars`                                      | Array with extra environment variables to add to ClickHouse Operator containers                                                                                                                                                | `[]`                                  |
| `extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for ClickHouse Operator containers                                                                                                                                        | `""`                                  |
| `extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for ClickHouse Operator containers                                                                                                                                           | `""`                                  |
| `extraVolumes`                                      | Optionally specify extra list of additional volumes for the ClickHouse Operator pods                                                                                                                                           | `[]`                                  |
| `extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the ClickHouse Operator containers                                                                                                                                | `[]`                                  |
| `sidecars`                                          | Add additional sidecar containers to the ClickHouse Operator pods                                                                                                                                                              | `[]`                                  |
| `initContainers`                                    | Add additional init containers to the ClickHouse Operator pods                                                                                                                                                                 | `[]`                                  |
| `pdb.create`                                        | Enable/disable a Pod Disruption Budget creation                                                                                                                                                                                | `true`                                |
| `pdb.minAvailable`                                  | Minimum number/percentage of pods that should remain scheduled                                                                                                                                                                 | `""`                                  |
| `pdb.maxUnavailable`                                | Maximum number/percentage of pods that may be made unavailable. Defaults to `1` if both `pdb.minAvailable` and `pdb.maxUnavailable` are empty.                                                                                 | `""`                                  |
| `autoscaling.vpa.enabled`                           | Enable VPA for ClickHouse Operator pods                                                                                                                                                                                        | `false`                               |
| `autoscaling.vpa.annotations`                       | Annotations for VPA resource                                                                                                                                                                                                   | `{}`                                  |
| `autoscaling.vpa.controlledResources`               | VPA List of resources that the vertical pod autoscaler can control. Defaults to cpu and memory                                                                                                                                 | `[]`                                  |
| `autoscaling.vpa.maxAllowed`                        | VPA Max allowed resources for the pod                                                                                                                                                                                          | `{}`                                  |
| `autoscaling.vpa.minAllowed`                        | VPA Min allowed resources for the pod                                                                                                                                                                                          | `{}`                                  |
| `autoscaling.vpa.updatePolicy.updateMode`           | Autoscaling update policy                                                                                                                                                                                                      | `Auto`                                |
| `autoscaling.hpa.enabled`                           | Enable HPA for ClickHouse Operator pods                                                                                                                                                                                        | `false`                               |
| `autoscaling.hpa.minReplicas`                       | Minimum number of replicas                                                                                                                                                                                                     | `""`                                  |
| `autoscaling.hpa.maxReplicas`                       | Maximum number of replicas                                                                                                                                                                                                     | `""`                                  |
| `autoscaling.hpa.targetCPU`                         | Target CPU utilization percentage                                                                                                                                                                                              | `""`                                  |
| `autoscaling.hpa.targetMemory`                      | Target Memory utilization percentage                                                                                                                                                                                           | `""`                                  |

### Traffic Exposure Parameters

| Name                                    | Description                                                                                                   | Value  |
| --------------------------------------- | ------------------------------------------------------------------------------------------------------------- | ------ |
| `service.ports.metrics`                 | ClickHouse Operator service metrics port                                                                      | `9999` |
| `service.ports.metricsExporter`         | ClickHouse Operator service metrics exporter port                                                             | `8888` |
| `service.clusterIP`                     | ClickHouse Operator service Cluster IP                                                                        | `""`   |
| `service.annotations`                   | Additional custom annotations for ClickHouse Operator service                                                 | `{}`   |
| `service.extraPorts`                    | Extra ports to expose in ClickHouse Operator service (normally used with the `sidecars` value)                | `[]`   |
| `networkPolicy.enabled`                 | Specifies whether a NetworkPolicy should be created                                                           | `true` |
| `networkPolicy.kubeAPIServerPorts`      | List of possible endpoints to kube-apiserver (limit to your cluster settings to increase security)            | `[]`   |
| `networkPolicy.allowExternal`           | Don't require server label for connections                                                                    | `true` |
| `networkPolicy.allowExternalEgress`     | Allow the pod to access any range of port and all destinations.                                               | `true` |
| `networkPolicy.addExternalClientAccess` | Allow access from pods with client label set to "true". Ignored if `networkPolicy.allowExternal` is true.     | `true` |
| `networkPolicy.extraIngress`            | Add extra ingress rules to the NetworkPolicy                                                                  | `[]`   |
| `networkPolicy.extraEgress`             | Add extra ingress rules to the NetworkPolicy (ignored if allowExternalEgress=true)                            | `[]`   |
| `networkPolicy.ingressPodMatchLabels`   | Labels to match to allow traffic from other pods. Ignored if `networkPolicy.allowExternal` is true.           | `{}`   |
| `networkPolicy.ingressNSMatchLabels`    | Labels to match to allow traffic from other namespaces. Ignored if `networkPolicy.allowExternal` is true.     | `{}`   |
| `networkPolicy.ingressNSPodMatchLabels` | Pod labels to match to allow traffic from other namespaces. Ignored if `networkPolicy.allowExternal` is true. | `{}`   |

### Other Parameters

| Name                                                        | Description                                                                                                                                                                                                                                                     | Value                                 |
| ----------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------- |
| `rbac.create`                                               | Specifies whether RBAC resources should be created                                                                                                                                                                                                              | `true`                                |
| `rbac.rules`                                                | Custom RBAC rules to set                                                                                                                                                                                                                                        | `[]`                                  |
| `serviceAccount.create`                                     | Specifies whether a ServiceAccount should be created                                                                                                                                                                                                            | `true`                                |
| `serviceAccount.name`                                       | The name of the ServiceAccount to use.                                                                                                                                                                                                                          | `""`                                  |
| `serviceAccount.annotations`                                | Additional Service Account annotations (evaluated as a template)                                                                                                                                                                                                | `{}`                                  |
| `serviceAccount.automountServiceAccountToken`               | Automount service account token for the server service account                                                                                                                                                                                                  | `true`                                |
| `metrics.enabled`                                           | Enable the export of Prometheus metrics using a exporter sidecar                                                                                                                                                                                                | `false`                               |
| `metrics.image.registry`                                    | ClickHouse Operator Metrics exporter image registry                                                                                                                                                                                                             | `REGISTRY_NAME`                       |
| `metrics.image.repository`                                  | ClickHouse Operator Metrics exporter image repository                                                                                                                                                                                                           | `REPOSITORY_NAME/clickhouse-operator` |
| `metrics.image.digest`                                      | ClickHouse Operator Metrics exporter image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag image tag (immutable tags are recommended)                                                                                 | `""`                                  |
| `metrics.image.pullPolicy`                                  | ClickHouse Operator Metrics exporter image pull policy                                                                                                                                                                                                          | `IfNotPresent`                        |
| `metrics.image.pullSecrets`                                 | ClickHouse Operator Metrics exporter image pull secrets                                                                                                                                                                                                         | `[]`                                  |
| `metrics.containerPorts.metrics`                            | ClickHouse Operator Metrics exporter container port                                                                                                                                                                                                             | `8888`                                |
| `metrics.extraContainerPorts`                               | Optionally specify extra list of additional ports for ClickHouse Operator Metrics exporter containers                                                                                                                                                           | `[]`                                  |
| `metrics.livenessProbe.enabled`                             | Enable livenessProbe on ClickHouse Operator Metrics exporter containers                                                                                                                                                                                         | `true`                                |
| `metrics.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                                                                         | `5`                                   |
| `metrics.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                                                                | `10`                                  |
| `metrics.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                                                               | `5`                                   |
| `metrics.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                                                                             | `5`                                   |
| `metrics.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                                                                             | `1`                                   |
| `metrics.readinessProbe.enabled`                            | Enable readinessProbe on ClickHouse Operator Metrics exporter containers                                                                                                                                                                                        | `true`                                |
| `metrics.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                                                                        | `5`                                   |
| `metrics.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                                                               | `10`                                  |
| `metrics.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                                                              | `5`                                   |
| `metrics.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                                                                            | `5`                                   |
| `metrics.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                                                                            | `1`                                   |
| `metrics.startupProbe.enabled`                              | Enable startupProbe on ClickHouse Operator Metrics exporter containers                                                                                                                                                                                          | `false`                               |
| `metrics.startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                                                                          | `5`                                   |
| `metrics.startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                                                                 | `10`                                  |
| `metrics.startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                                                                | `5`                                   |
| `metrics.startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                                                              | `5`                                   |
| `metrics.startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                                                              | `1`                                   |
| `metrics.customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                                                                                                                                                             | `{}`                                  |
| `metrics.customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                                                                                                                                                                            | `{}`                                  |
| `metrics.customStartupProbe`                                | Custom startupProbe that overrides the default one                                                                                                                                                                                                              | `{}`                                  |
| `metrics.resourcesPreset`                                   | Set ClickHouse Operator Metrics exporter container resources according to one common preset (allowed values: none, nano, small, medium, large, xlarge, 2xlarge). This is ignored if metrics.resources is set (metrics.resources is recommended for production). | `nano`                                |
| `metrics.resources`                                         | Set ClickHouse Operator Metrics exporter container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                          | `{}`                                  |
| `metrics.containerSecurityContext.enabled`                  | Enabled ClickHouse Operator Metrics exporter container' Security Context                                                                                                                                                                                        | `true`                                |
| `metrics.containerSecurityContext.seLinuxOptions`           | Set SELinux options in ClickHouse Operator Metrics exporter container                                                                                                                                                                                           | `{}`                                  |
| `metrics.containerSecurityContext.runAsUser`                | Set runAsUser in ClickHouse Operator Metrics exporter container' Security Context                                                                                                                                                                               | `1001`                                |
| `metrics.containerSecurityContext.runAsGroup`               | Set runAsGroup in ClickHouse Operator Metrics exporter container' Security Context                                                                                                                                                                              | `1001`                                |
| `metrics.containerSecurityContext.runAsNonRoot`             | Set runAsNonRoot in ClickHouse Operator Metrics exporter container' Security Context                                                                                                                                                                            | `true`                                |
| `metrics.containerSecurityContext.readOnlyRootFilesystem`   | Set readOnlyRootFilesystem in ClickHouse Operator Metrics exporter container' Security Context                                                                                                                                                                  | `true`                                |
| `metrics.containerSecurityContext.privileged`               | Set privileged in ClickHouse Operator Metrics exporter container' Security Context                                                                                                                                                                              | `false`                               |
| `metrics.containerSecurityContext.allowPrivilegeEscalation` | Set allowPrivilegeEscalation in ClickHouse Operator Metrics exporter container' Security Context                                                                                                                                                                | `false`                               |
| `metrics.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped in ClickHouse Operator Metrics exporter container                                                                                                                                                                            | `["ALL"]`                             |
| `metrics.containerSecurityContext.seccompProfile.type`      | Set seccomp profile in ClickHouse Operator Metrics exporter container                                                                                                                                                                                           | `RuntimeDefault`                      |
| `metrics.extraEnvVars`                                      | Array with extra environment variables to add to ClickHouse Operator Metrics exporter containers                                                                                                                                                                | `[]`                                  |
| `metrics.extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for ClickHouse Operator Metrics exporter containers                                                                                                                                                        | `""`                                  |
| `metrics.extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for ClickHouse Operator Metrics exporter containers                                                                                                                                                           | `""`                                  |
| `metrics.serviceMonitor.enabled`                            | if `true`, creates a Prometheus Operator ServiceMonitor (also requires `metrics.enabled` to be `true`)                                                                                                                                                          | `false`                               |
| `metrics.serviceMonitor.namespace`                          | Namespace in which Prometheus is running                                                                                                                                                                                                                        | `""`                                  |
| `metrics.serviceMonitor.annotations`                        | Additional custom annotations for the ServiceMonitor                                                                                                                                                                                                            | `{}`                                  |
| `metrics.serviceMonitor.labels`                             | Extra labels for the ServiceMonitor                                                                                                                                                                                                                             | `{}`                                  |
| `metrics.serviceMonitor.jobLabel`                           | The name of the label on the target service to use as the job name in Prometheus                                                                                                                                                                                | `""`                                  |
| `metrics.serviceMonitor.honorLabels`                        | honorLabels chooses the metric's labels on collisions with target labels                                                                                                                                                                                        | `false`                               |
| `metrics.serviceMonitor.interval`                           | Interval at which metrics should be scraped.                                                                                                                                                                                                                    | `""`                                  |
| `metrics.serviceMonitor.scrapeTimeout`                      | Timeout after which the scrape is ended                                                                                                                                                                                                                         | `""`                                  |
| `metrics.serviceMonitor.metricRelabelings`                  | Specify additional relabeling of metrics                                                                                                                                                                                                                        | `[]`                                  |
| `metrics.serviceMonitor.relabelings`                        | Specify general relabeling                                                                                                                                                                                                                                      | `[]`                                  |
| `metrics.serviceMonitor.selector`                           | Prometheus instance selector labels                                                                                                                                                                                                                             | `{}`                                  |

The above parameters map to the env variables defined in [bitnami/clickhouse-operator](https://github.com/bitnami/containers/tree/main/bitnami/clickhouse-operator). For more information please refer to the [bitnami/clickhouse-operator](https://github.com/bitnami/containers/tree/main/bitnami/clickhouse-operator) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
  --set watchAllNamespaces=true \
    oci://REGISTRY_NAME/REPOSITORY_NAME/clickhouse-operator
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The above command configures the ClickHouse Operator to watch for ClickHouseInstallation and ClickHouseKeeperInstallation objects in all namespaces.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml oci://REGISTRY_NAME/REPOSITORY_NAME/clickhouse-operator
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.
> **Tip**: You can use the default [values.yaml](https://github.com/bitnami/charts/blob/main/template/clickhouse-operator/values.yaml)

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
