<!--- app-name: CloudNativePG -->

# Bitnami Secure Images Helm chart for CloudNativePG

CloudNativePG is an open-source tool for managing PostgreSQL databases on Kubernetes, from setup to ongoing upkeep.

[Overview of CloudNativePG](https://cloudnative-pg.io/)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/cloudnative-pg
```

Looking to use CloudNativePG in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the commercial edition of the Bitnami catalog.

## ⚠️ Important Notice: Upcoming changes to the Bitnami Catalog

Beginning August 28th, 2025, Bitnami will evolve its public catalog to offer a curated set of hardened, security-focused images under the new [Bitnami Secure Images initiative](https://news.broadcom.com/app-dev/broadcom-introduces-bitnami-secure-images-for-production-ready-containerized-applications). As part of this transition:

- Granting community users access for the first time to security-optimized versions of popular container images.
- Bitnami will begin deprecating support for non-hardened, Debian-based software images in its free tier and will gradually remove non-latest tags from the public catalog. As a result, community users will have access to a reduced number of hardened images. These images are published only under the “latest” tag and are intended for development purposes
- Starting August 28th, over two weeks, all existing container images, including older or versioned tags (e.g., 2.50.0, 10.6), will be migrated from the public catalog (docker.io/bitnami) to the “Bitnami Legacy” repository (docker.io/bitnamilegacy), where they will no longer receive updates.
- For production workloads and long-term support, users are encouraged to adopt Bitnami Secure Images, which include hardened containers, smaller attack surfaces, CVE transparency (via VEX/KEV), SBOMs, and enterprise support.

These changes aim to improve the security posture of all Bitnami users by promoting best practices for software supply chain integrity and up-to-date deployments. For more details, visit the [Bitnami Secure Images announcement](https://github.com/bitnami/containers/issues/83267).

## Introduction

This chart bootstraps a [CloudNativePG](https://github.com/bitnami/containers/tree/main/bitnami/cloudnative-pg) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release REGISTRY_NAME/REPOSITORY_NAME/cloudnative-pg
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The command deploys CloudNativePG on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Configuration and installation details

### Operator configuration

The Bitnami CloudNativePG chart allows [configuring the operator](https://cloudnative-pg.io/documentation/current/operator_conf/#available-options) using ConfigMaps and Secrets. This is done using the `operator.configuration` and `operator.secretConfiguration` parameters. Both are values are compatible, and the configuration in the `operator.secretConfiguration` section takes precedence over the `operator.configuration` section. In the example below we add extra configuration parameters to the operator:

```yaml
operator:
  configuration:
    EXPIRING_CHECK_THRESHOLD: 12
  secretConfiguration:
    CERTIFICATE_DURATION: 120
```

It is also possible to use existing ConfigMaps and Secrets using the `operator.existingConfigMap` and `operator.existingSecret` parameters (note that these are not compatible with the `operator.configuration` and `operator.secretConfiguration` parameters).

### Resource requests and limits

Bitnami charts allow setting resource requests and limits for all containers inside the chart deployment. These are inside the `*.resources` (under the `operator` and `pluginBarmanCloud` sections) value (check parameter table). Setting requests is essential for production workloads and these should be adapted to your specific use case.

To make this process easier, the chart contains the `*.resourcesPreset`  (under the `operator` and `pluginBarmanCloud` sections) values, which automatically sets the `*.resources`  (under the `operator` and `pluginBarmanCloud` sections) section according to different presets. Check these presets in [the bitnami/common chart](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15). However, in production workloads using `resourcesPreset` is discouraged as it may not fully adapt to your specific needs. Find more information on container resource management in the [official Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).

### Backup and restore

The Bitnami CloudNativePG chart includes the [plugin-barman-cloud](https://cloudnative-pg.io/plugin-barman-cloud/) for performing backup operations. This is enabled by setting `pluginBarmanCloud.enabled=true`:

```yaml
pluginBarmanCloud:
  enabled: true
```

Check the upstream [plugin-barman-cloud](https://cloudnative-pg.io/plugin-barman-cloud/docs/intro/) on how to deploy `BarmanObjectStore` objects and enabling backup operations.

### Prometheus metrics

This chart can be integrated with Prometheus by setting `*.metrics.enabled` (under the `operator` and `pluginBarmanCloud` sections) to true. This will expose the cloudnative-pg native Prometheus endpoint in a `metrics` service, which can be configured under the `*.metrics.service` (under the `operator` and `pluginBarmanCloud` sections) section. It will have the necessary annotations to be automatically scraped by Prometheus.

For the PostgreSQL instances themselves, the chart deploys a monitoring queries ConfigMap or Secret with basic queries. These can be cofigured under the `operator.metrics.monitoringQueries` section.

#### Prometheus requirements

It is necessary to have a working installation of Prometheus or Prometheus Operator for the integration to work. Install the [Bitnami Prometheus helm chart](https://github.com/bitnami/charts/tree/main/bitnami/prometheus) or the [Bitnami Kube Prometheus helm chart](https://github.com/bitnami/charts/tree/main/bitnami/kube-prometheus) to easily have a working Prometheus in your cluster.

#### Integration with Prometheus Operator

The chart can deploy `ServiceMonitor` objects for integration with Prometheus Operator installations. To do so, set the value `*.metrics.serviceMonitor.enabled=true` (under the `operator` and `pluginBarmanCloud` sections). Ensure that the Prometheus Operator `CustomResourceDefinitions` are installed in the cluster or it will fail with the following error:

```text
no matches for kind "ServiceMonitor" in version "monitoring.coreos.com/v1"
```

Install the [Bitnami Kube Prometheus helm chart](https://github.com/bitnami/charts/tree/main/bitnami/kube-prometheus) for having the necessary CRDs and the Prometheus Operator.

### [Rolling VS Immutable tags](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Additional environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `extraEnvVars` property inside the `operator` and `pluginBarmanCloud` sections:

```yaml
operator:
  extraEnvVars:
    - name: LOG_LEVEL
      value: error
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values inside the `operator` and `pluginBarmanCloud` sections.

### Sidecars

If additional containers are needed in the same pod as cloudnative-pg (such as additional metrics or logging exporters), they can be defined using the `sidecars` parameter inside the `operator` and `pluginBarmanCloud` sections:

```yaml
operator:
  sidecars:
  - name: your-image-name
    image: your-image
    imagePullPolicy: Always
    ports:
    - name: portname
      containerPort: 1234
```

If these sidecars export extra ports, extra port definitions can be added using the `*.service.extraPorts` parameter (where available), as shown in the example below:

```yaml
operator:
  service:
    extraPorts:
    - name: extraPort
      port: 11311
      targetPort: 11311
```

If additional init containers are needed in the same pod, they can be defined using the `initContainers` parameter inside the `operator` and `pluginBarmanCloud` sections. Here is an example:

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

### Deploying extra resources

Apart from the Operator, you may want to deploy PostgreSQL Cluster, ImageCatalog or other operator objects.  For covering this case, the chart allows adding the full specification of other objects using the `extraDeploy` parameter. The following example would creates a PostgreSQL Cluster object with a secret containing the credentials of a role:

```yaml
extraDeploy:
- apiVersion: v1
  kind: Secret
  metadata:
    name: my-cluster-example-user
    labels:
      cnpg.io/reload: "true"
  type: kubernetes.io/basic-auth
  stringData:
    username: my_user
    password: bitnami1234
- apiVersion: postgresql.cnpg.io/v1
  kind: Cluster
  metadata:
    name: my-cluster-example
  spec:
    instances: 3
    storage:
      size: 1Gi
    managed:
      roles:
        - name: my_user
          ensure: present
          comment: MY User
          login: true
          superuser: true
          passwordSecret:
            name: my-cluster-example-user
```

Check the [CloudNativePG official documentation](https://cloudnative-pg.io/documentation/current/) for the list of available objects.

### Pod affinity

This chart allows you to set your custom affinity using the `affinity` parameter inside the `operator` and `pluginBarmanCloud` sections. Find more information about Pod affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, use one of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters inside the `operator` and `pluginBarmanCloud` sections.

## Parameters

### Global parameters

| Name                                                  | Description                                                                                                                                                                                                                                                                                                                                                         | Value   |
| ----------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `global.imageRegistry`                                | Global Docker image registry                                                                                                                                                                                                                                                                                                                                        | `""`    |
| `global.imagePullSecrets`                             | Global Docker registry secret names as an array                                                                                                                                                                                                                                                                                                                     | `[]`    |
| `global.defaultStorageClass`                          | Global default StorageClass for Persistent Volume(s)                                                                                                                                                                                                                                                                                                                | `""`    |
| `global.security.allowInsecureImages`                 | Allows skipping image verification                                                                                                                                                                                                                                                                                                                                  | `false` |
| `global.compatibility.openshift.adaptSecurityContext` | Adapt the securityContext sections of the deployment to make them compatible with Openshift restricted-v2 SCC: remove runAsUser, runAsGroup and fsGroup and let the platform use their allowed default IDs. Possible values: auto (apply if the detected running cluster is Openshift), force (perform the adaptation always), disabled (do not perform adaptation) | `auto`  |

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

### cloudnative-pg operator parameters

| Name                                                         | Description                                                                                                                                                                                                                         | Value                            |
| ------------------------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------- |
| `operator.image.registry`                                    | cloudnative-pg Operator image registry                                                                                                                                                                                              | `REGISTRY_NAME`                  |
| `operator.image.repository`                                  | cloudnative-pg Operator image repository                                                                                                                                                                                            | `REPOSITORY_NAME/cloudnative-pg` |
| `operator.image.digest`                                      | cloudnative-pg Operator image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag image tag (immutable tags are recommended)                                                                  | `""`                             |
| `operator.image.pullPolicy`                                  | cloudnative-pg Operator image pull policy                                                                                                                                                                                           | `IfNotPresent`                   |
| `operator.image.pullSecrets`                                 | cloudnative-pg Operator image pull secrets                                                                                                                                                                                          | `[]`                             |
| `operator.image.debug`                                       | Enable cloudnative-pg Operator image debug mode                                                                                                                                                                                     | `false`                          |
| `operator.postgresqlImage.registry`                          | PostgreSQL image registry                                                                                                                                                                                                           | `REGISTRY_NAME`                  |
| `operator.postgresqlImage.repository`                        | PostgreSQL image repository                                                                                                                                                                                                         | `REPOSITORY_NAME/postgresql`     |
| `operator.postgresqlImage.digest`                            | PostgreSQL image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                          | `""`                             |
| `operator.replicaCount`                                      | Number of cloudnative-pg Operator replicas to deploy                                                                                                                                                                                | `1`                              |
| `operator.containerPorts.metrics`                            | cloudnative-pg Operator metrics container port                                                                                                                                                                                      | `8080`                           |
| `operator.containerPorts.webhook`                            | cloudnative-pg Operator webhook container port                                                                                                                                                                                      | `9443`                           |
| `operator.livenessProbe.enabled`                             | Enable livenessProbe on cloudnative-pg Operator containers                                                                                                                                                                          | `true`                           |
| `operator.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                                             | `5`                              |
| `operator.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                                    | `10`                             |
| `operator.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                                   | `5`                              |
| `operator.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                                                 | `5`                              |
| `operator.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                                                 | `1`                              |
| `operator.readinessProbe.enabled`                            | Enable readinessProbe on cloudnative-pg Operator containers                                                                                                                                                                         | `true`                           |
| `operator.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                                            | `5`                              |
| `operator.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                                   | `10`                             |
| `operator.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                                  | `5`                              |
| `operator.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                                                | `5`                              |
| `operator.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                                                | `1`                              |
| `operator.startupProbe.enabled`                              | Enable startupProbe on cloudnative-pg Operator containers                                                                                                                                                                           | `false`                          |
| `operator.startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                                              | `5`                              |
| `operator.startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                                     | `10`                             |
| `operator.startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                                    | `5`                              |
| `operator.startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                                  | `5`                              |
| `operator.startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                                  | `1`                              |
| `operator.customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                                                                                                                                 | `{}`                             |
| `operator.customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                                                                                                                                                | `{}`                             |
| `operator.customStartupProbe`                                | Custom startupProbe that overrides the default one                                                                                                                                                                                  | `{}`                             |
| `operator.watchAllNamespaces`                                | Watch for cloudnative-pg resources in all namespaces                                                                                                                                                                                | `true`                           |
| `operator.watchNamespaces`                                   | Watch for cloudnative-pg resources in the given namespaces                                                                                                                                                                          | `[]`                             |
| `operator.maxConcurrentReconciles`                           | Maximum concurrent reconciles in the operator                                                                                                                                                                                       | `10`                             |
| `operator.configuration`                                     | Add configuration settings to a configmap                                                                                                                                                                                           | `{}`                             |
| `operator.secretConfiguration`                               | Add configuration settings to a secret                                                                                                                                                                                              | `{}`                             |
| `operator.existingConfigMap`                                 | Name of a ConfigMap containing the operator configuration                                                                                                                                                                           | `""`                             |
| `operator.existingSecret`                                    | Name of a Secret containing the operator secret configuration                                                                                                                                                                       | `""`                             |
| `operator.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if operator.resources is set (operator.resources is recommended for production). | `nano`                           |
| `operator.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                   | `{}`                             |
| `operator.podSecurityContext.enabled`                        | Enabled cloudnative-pg Operator pods' Security Context                                                                                                                                                                              | `true`                           |
| `operator.podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                                  | `Always`                         |
| `operator.podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                                      | `[]`                             |
| `operator.podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                                         | `[]`                             |
| `operator.podSecurityContext.fsGroup`                        | Set cloudnative-pg Operator pod's Security Context fsGroup                                                                                                                                                                          | `1001`                           |
| `operator.containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                                                                                                                                                | `true`                           |
| `operator.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                                    | `{}`                             |
| `operator.containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                                                                                                                          | `1001`                           |
| `operator.containerSecurityContext.runAsGroup`               | Set containers' Security Context runAsGroup                                                                                                                                                                                         | `1001`                           |
| `operator.containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                                                                                                                                       | `true`                           |
| `operator.containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                                                                                                                                         | `false`                          |
| `operator.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                                             | `true`                           |
| `operator.containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                                                                                                                           | `false`                          |
| `operator.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                                  | `["ALL"]`                        |
| `operator.containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                                    | `RuntimeDefault`                 |
| `operator.command`                                           | Override default container command (useful when using custom images)                                                                                                                                                                | `[]`                             |
| `operator.args`                                              | Override default container args (useful when using custom images)                                                                                                                                                                   | `[]`                             |
| `operator.extraArgs`                                         | Additional command line arguments to pass to default command                                                                                                                                                                        | `[]`                             |
| `operator.automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                                  | `true`                           |
| `operator.hostAliases`                                       | cloudnative-pg Operator pods host aliases                                                                                                                                                                                           | `[]`                             |
| `operator.podLabels`                                         | Extra labels for cloudnative-pg Operator pods                                                                                                                                                                                       | `{}`                             |
| `operator.podAnnotations`                                    | Annotations for cloudnative-pg Operator pods                                                                                                                                                                                        | `{}`                             |
| `operator.podAffinityPreset`                                 | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                                 | `""`                             |
| `operator.podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                            | `soft`                           |
| `operator.pdb.create`                                        | Enable/disable a Pod Disruption Budget creation                                                                                                                                                                                     | `true`                           |
| `operator.pdb.minAvailable`                                  | Minimum number/percentage of pods that should remain scheduled                                                                                                                                                                      | `""`                             |
| `operator.pdb.maxUnavailable`                                | Maximum number/percentage of pods that may be made unavailable                                                                                                                                                                      | `""`                             |
| `operator.nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                           | `""`                             |
| `operator.nodeAffinityPreset.key`                            | Node label key to match. Ignored if `affinity` is set                                                                                                                                                                               | `""`                             |
| `operator.nodeAffinityPreset.values`                         | Node label values to match. Ignored if `affinity` is set                                                                                                                                                                            | `[]`                             |
| `operator.affinity`                                          | Affinity for cloudnative-pg Operator pods assignment                                                                                                                                                                                | `{}`                             |
| `operator.nodeSelector`                                      | Node labels for cloudnative-pg Operator pods assignment                                                                                                                                                                             | `{}`                             |
| `operator.tolerations`                                       | Tolerations for cloudnative-pg Operator pods assignment                                                                                                                                                                             | `[]`                             |
| `operator.updateStrategy.type`                               | cloudnative-pg Operator statefulset strategy type                                                                                                                                                                                   | `RollingUpdate`                  |
| `operator.priorityClassName`                                 | cloudnative-pg Operator pods' priorityClassName                                                                                                                                                                                     | `""`                             |
| `operator.topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template                                                                                                            | `[]`                             |
| `operator.schedulerName`                                     | Name of the k8s scheduler (other than default) for cloudnative-pg Operator pods                                                                                                                                                     | `""`                             |
| `operator.terminationGracePeriodSeconds`                     | Seconds Redmine pod needs to terminate gracefully                                                                                                                                                                                   | `""`                             |
| `operator.lifecycleHooks`                                    | for the cloudnative-pg Operator container(s) to automate configuration before or after startup                                                                                                                                      | `{}`                             |
| `operator.extraEnvVars`                                      | Array with extra environment variables to add to cloudnative-pg Operator nodes                                                                                                                                                      | `[]`                             |
| `operator.extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for cloudnative-pg Operator nodes                                                                                                                                              | `""`                             |
| `operator.extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for cloudnative-pg Operator nodes                                                                                                                                                 | `""`                             |
| `operator.extraVolumes`                                      | Optionally specify extra list of additional volumes for the cloudnative-pg Operator pod(s)                                                                                                                                          | `[]`                             |
| `operator.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the cloudnative-pg Operator container(s)                                                                                                                               | `[]`                             |
| `operator.sidecars`                                          | Add additional sidecar containers to the cloudnative-pg Operator pod(s)                                                                                                                                                             | `[]`                             |
| `operator.initContainers`                                    | Add additional init containers to the cloudnative-pg Operator pod(s)                                                                                                                                                                | `[]`                             |
| `operator.webhook.validating.create`                         | Create ValidatingWebhookConfiguration                                                                                                                                                                                               | `true`                           |
| `operator.webhook.validating.failurePolicy`                  | Set failure policy of the validating webhook                                                                                                                                                                                        | `Fail`                           |
| `operator.webhook.mutating.create`                           | Create MutatingWebhookConfiguration                                                                                                                                                                                                 | `true`                           |
| `operator.webhook.mutating.failurePolicy`                    | Set failure policy of the mutating webhook                                                                                                                                                                                          | `Fail`                           |
| `operator.autoscaling.vpa.enabled`                           | Enable VPA                                                                                                                                                                                                                          | `false`                          |
| `operator.autoscaling.vpa.annotations`                       | Annotations for VPA resource                                                                                                                                                                                                        | `{}`                             |
| `operator.autoscaling.vpa.controlledResources`               | VPA List of resources that the vertical pod autoscaler can control. Defaults to cpu and memory                                                                                                                                      | `[]`                             |
| `operator.autoscaling.vpa.maxAllowed`                        | VPA Max allowed resources for the pod                                                                                                                                                                                               | `{}`                             |
| `operator.autoscaling.vpa.minAllowed`                        | VPA Min allowed resources for the pod                                                                                                                                                                                               | `{}`                             |
| `operator.autoscaling.vpa.updatePolicy.updateMode`           | Autoscaling update policy Specifies whether recommended updates are applied when a Pod is started and whether recommended updates are applied during the life of a Pod                                                              | `Auto`                           |
| `operator.autoscaling.hpa.enabled`                           | Enable autoscaling for operator                                                                                                                                                                                                     | `false`                          |
| `operator.autoscaling.hpa.minReplicas`                       | Minimum number of operator replicas                                                                                                                                                                                                 | `""`                             |
| `operator.autoscaling.hpa.maxReplicas`                       | Maximum number of operator replicas                                                                                                                                                                                                 | `""`                             |
| `operator.autoscaling.hpa.targetCPU`                         | Target CPU utilization percentage                                                                                                                                                                                                   | `""`                             |
| `operator.autoscaling.hpa.targetMemory`                      | Target Memory utilization percentage                                                                                                                                                                                                | `""`                             |

### cloudnative-pg Operator Traffic Exposure Parameters

| Name                                             | Description                                                                                        | Value       |
| ------------------------------------------------ | -------------------------------------------------------------------------------------------------- | ----------- |
| `operator.service.type`                          | cloudnative-pg Operator service type                                                               | `ClusterIP` |
| `operator.service.ports.webhook`                 | cloudnative-pg Operator service webhook port                                                       | `443`       |
| `operator.service.nodePorts.webhook`             | Node port for webhook                                                                              | `""`        |
| `operator.service.clusterIP`                     | cloudnative-pg Operator service Cluster IP                                                         | `""`        |
| `operator.service.loadBalancerIP`                | cloudnative-pg Operator service Load Balancer IP                                                   | `""`        |
| `operator.service.loadBalancerSourceRanges`      | cloudnative-pg Operator service Load Balancer sources                                              | `[]`        |
| `operator.service.externalTrafficPolicy`         | cloudnative-pg Operator service external traffic policy                                            | `Cluster`   |
| `operator.service.labels`                        | Labels for the service                                                                             | `{}`        |
| `operator.service.annotations`                   | Additional custom annotations for cloudnative-pg Operator service                                  | `{}`        |
| `operator.service.extraPorts`                    | Extra ports to expose in cloudnative-pg Operator service (normally used with the `sidecars` value) | `[]`        |
| `operator.service.sessionAffinity`               | Control where web requests go, to the same pod or round-robin                                      | `None`      |
| `operator.service.sessionAffinityConfig`         | Additional settings for the sessionAffinity                                                        | `{}`        |
| `operator.networkPolicy.enabled`                 | Specifies whether a NetworkPolicy should be created                                                | `true`      |
| `operator.networkPolicy.kubeAPIServerPorts`      | List of possible endpoints to kube-apiserver (limit to your cluster settings to increase security) | `[]`        |
| `operator.networkPolicy.allowExternal`           | Don't require server label for connections                                                         | `true`      |
| `operator.networkPolicy.allowExternalEgress`     | Allow the pod to access any range of port and all destinations.                                    | `true`      |
| `operator.networkPolicy.extraIngress`            | Add extra ingress rules to the NetworkPolicy                                                       | `[]`        |
| `operator.networkPolicy.extraEgress`             | Add extra ingress rules to the NetworkPolicy                                                       | `[]`        |
| `operator.networkPolicy.ingressNSMatchLabels`    | Labels to match to allow traffic from other namespaces                                             | `{}`        |
| `operator.networkPolicy.ingressNSPodMatchLabels` | Pod labels to match to allow traffic from other namespaces                                         | `{}`        |

### cloudnative-pg Operator RBAC Parameters

| Name                                                   | Description                                                      | Value   |
| ------------------------------------------------------ | ---------------------------------------------------------------- | ------- |
| `operator.rbac.create`                                 | Specifies whether RBAC resources should be created               | `true`  |
| `operator.rbac.rules`                                  | Custom RBAC rules to set                                         | `[]`    |
| `operator.serviceAccount.create`                       | Specifies whether a ServiceAccount should be created             | `true`  |
| `operator.serviceAccount.name`                         | The name of the ServiceAccount to use.                           | `""`    |
| `operator.serviceAccount.annotations`                  | Additional Service Account annotations (evaluated as a template) | `{}`    |
| `operator.serviceAccount.automountServiceAccountToken` | Automount service account token for the server service account   | `false` |

### cloudnative-pg Operator Metrics Parameters

| Name                                                       | Description                                                                                            | Value   |
| ---------------------------------------------------------- | ------------------------------------------------------------------------------------------------------ | ------- |
| `operator.metrics.enabled`                                 | Enable the export of Prometheus metrics                                                                | `false` |
| `operator.metrics.monitoringQueries.useSecret`             | Use secret for the monitoring queries. Will use a ConfigMap if false                                   | `false` |
| `operator.metrics.monitoringQueries.overrideConfiguration` | Override sections of the default monitoring queries configuration                                      | `{}`    |
| `operator.metrics.monitoringQueries.existingQueries`       | Name of a ConfigMap or Secret with existing monitoring queries                                         | `""`    |
| `operator.metrics.service.ports.metrics`                   | Meetrics service port                                                                                  | `80`    |
| `operator.metrics.service.clusterIP`                       | Static clusterIP or None for headless services                                                         | `""`    |
| `operator.metrics.service.sessionAffinity`                 | Control where client requests go, to the same pod or round-robin                                       | `None`  |
| `operator.metrics.service.labels`                          | Labels for the metrics service                                                                         | `{}`    |
| `operator.metrics.service.annotations`                     | Annotations for the metrics service                                                                    | `{}`    |
| `operator.metrics.serviceMonitor.enabled`                  | if `true`, creates a Prometheus Operator ServiceMonitor (also requires `metrics.enabled` to be `true`) | `false` |
| `operator.metrics.serviceMonitor.namespace`                | Namespace in which Prometheus is running                                                               | `""`    |
| `operator.metrics.serviceMonitor.annotations`              | Additional custom annotations for the ServiceMonitor                                                   | `{}`    |
| `operator.metrics.serviceMonitor.labels`                   | Extra labels for the ServiceMonitor                                                                    | `{}`    |
| `operator.metrics.serviceMonitor.jobLabel`                 | The name of the label on the target service to use as the job name in Prometheus                       | `""`    |
| `operator.metrics.serviceMonitor.honorLabels`              | honorLabels chooses the metric's labels on collisions with target labels                               | `false` |
| `operator.metrics.serviceMonitor.interval`                 | Interval at which metrics should be scraped.                                                           | `""`    |
| `operator.metrics.serviceMonitor.scrapeTimeout`            | Timeout after which the scrape is ended                                                                | `""`    |
| `operator.metrics.serviceMonitor.metricRelabelings`        | Specify additional relabeling of metrics                                                               | `[]`    |
| `operator.metrics.serviceMonitor.relabelings`              | Specify general relabeling                                                                             | `[]`    |
| `operator.metrics.serviceMonitor.selector`                 | Prometheus instance selector labels                                                                    | `{}`    |

### plugin-barman-cloud parameters

| Name                                                                  | Description                                                                                                                                                                                                                | Value                                         |
| --------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------- |
| `pluginBarmanCloud.enabled`                                           | Enable the plugin for Barman Cloud                                                                                                                                                                                         | `true`                                        |
| `pluginBarmanCloud.image.registry`                                    | plugin-barman-cloud image registry                                                                                                                                                                                         | `REGISTRY_NAME`                               |
| `pluginBarmanCloud.image.repository`                                  | plugin-barman-cloud image repository                                                                                                                                                                                       | `REPOSITORY_NAME/plugin-barman-cloud`         |
| `pluginBarmanCloud.image.digest`                                      | plugin-barman-cloud image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag image tag (immutable tags are recommended)                                                             | `""`                                          |
| `pluginBarmanCloud.image.pullPolicy`                                  | plugin-barman-cloud image pull policy                                                                                                                                                                                      | `IfNotPresent`                                |
| `pluginBarmanCloud.image.pullSecrets`                                 | plugin-barman-cloud image pull secrets                                                                                                                                                                                     | `[]`                                          |
| `pluginBarmanCloud.image.debug`                                       | Enable plugin-barman-cloud image debug mode                                                                                                                                                                                | `false`                                       |
| `pluginBarmanCloud.sidecarImage.registry`                             | plugin-barman-cloud-sidecar image registry                                                                                                                                                                                 | `REGISTRY_NAME`                               |
| `pluginBarmanCloud.sidecarImage.repository`                           | plugin-barman-cloud-sidecar image repository                                                                                                                                                                               | `REPOSITORY_NAME/plugin-barman-cloud-sidecar` |
| `pluginBarmanCloud.sidecarImage.digest`                               | plugin-barman-cloud-sidecar image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                | `""`                                          |
| `pluginBarmanCloud.replicaCount`                                      | Number of plugin-barman-cloud replicas to deploy                                                                                                                                                                           | `1`                                           |
| `pluginBarmanCloud.containerPorts.metrics`                            | plugin-barman-cloud metrics container port                                                                                                                                                                                 | `8080`                                        |
| `pluginBarmanCloud.containerPorts.grpc`                               | plugin-barman-cloud grpc container port                                                                                                                                                                                    | `9443`                                        |
| `pluginBarmanCloud.containerPorts.health`                             | plugin-barman-cloud health container port                                                                                                                                                                                  | `8921`                                        |
| `pluginBarmanCloud.livenessProbe.enabled`                             | Enable livenessProbe on plugin-barman-cloud containers                                                                                                                                                                     | `true`                                        |
| `pluginBarmanCloud.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                                    | `5`                                           |
| `pluginBarmanCloud.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                           | `10`                                          |
| `pluginBarmanCloud.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                          | `5`                                           |
| `pluginBarmanCloud.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                                        | `5`                                           |
| `pluginBarmanCloud.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                                        | `1`                                           |
| `pluginBarmanCloud.readinessProbe.enabled`                            | Enable readinessProbe on plugin-barman-cloud containers                                                                                                                                                                    | `true`                                        |
| `pluginBarmanCloud.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                                   | `5`                                           |
| `pluginBarmanCloud.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                          | `10`                                          |
| `pluginBarmanCloud.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                         | `5`                                           |
| `pluginBarmanCloud.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                                       | `5`                                           |
| `pluginBarmanCloud.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                                       | `1`                                           |
| `pluginBarmanCloud.startupProbe.enabled`                              | Enable startupProbe on plugin-barman-cloud containers                                                                                                                                                                      | `false`                                       |
| `pluginBarmanCloud.startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                                     | `5`                                           |
| `pluginBarmanCloud.startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                            | `10`                                          |
| `pluginBarmanCloud.startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                           | `5`                                           |
| `pluginBarmanCloud.startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                         | `5`                                           |
| `pluginBarmanCloud.startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                         | `1`                                           |
| `pluginBarmanCloud.customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                                                                                                                        | `{}`                                          |
| `pluginBarmanCloud.customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                                                                                                                                       | `{}`                                          |
| `pluginBarmanCloud.customStartupProbe`                                | Custom startupProbe that overrides the default one                                                                                                                                                                         | `{}`                                          |
| `pluginBarmanCloud.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if.resources is set (operator.resources is recommended for production). | `nano`                                        |
| `pluginBarmanCloud.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                          | `{}`                                          |
| `pluginBarmanCloud.podSecurityContext.enabled`                        | Enabled plugin-barman-cloud pods' Security Context                                                                                                                                                                         | `true`                                        |
| `pluginBarmanCloud.podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                         | `Always`                                      |
| `pluginBarmanCloud.podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                             | `[]`                                          |
| `pluginBarmanCloud.podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                                | `[]`                                          |
| `pluginBarmanCloud.podSecurityContext.fsGroup`                        | Set plugin-barman-cloud pod's Security Context fsGroup                                                                                                                                                                     | `1001`                                        |
| `pluginBarmanCloud.containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                                                                                                                                       | `true`                                        |
| `pluginBarmanCloud.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                           | `{}`                                          |
| `pluginBarmanCloud.containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                                                                                                                 | `1001`                                        |
| `pluginBarmanCloud.containerSecurityContext.runAsGroup`               | Set containers' Security Context runAsGroup                                                                                                                                                                                | `1001`                                        |
| `pluginBarmanCloud.containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                                                                                                                              | `true`                                        |
| `pluginBarmanCloud.containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                                                                                                                                | `false`                                       |
| `pluginBarmanCloud.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                                    | `true`                                        |
| `pluginBarmanCloud.containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                                                                                                                  | `false`                                       |
| `pluginBarmanCloud.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                         | `["ALL"]`                                     |
| `pluginBarmanCloud.containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                           | `RuntimeDefault`                              |
| `pluginBarmanCloud.command`                                           | Override default container command (useful when using custom images)                                                                                                                                                       | `[]`                                          |
| `pluginBarmanCloud.args`                                              | Override default container args (useful when using custom images)                                                                                                                                                          | `[]`                                          |
| `pluginBarmanCloud.extraArgs`                                         | Additional command line arguments to pass to default command                                                                                                                                                               | `[]`                                          |
| `pluginBarmanCloud.automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                         | `true`                                        |
| `pluginBarmanCloud.hostAliases`                                       | plugin-barman-cloud pods host aliases                                                                                                                                                                                      | `[]`                                          |
| `pluginBarmanCloud.podLabels`                                         | Extra labels for plugin-barman-cloud pods                                                                                                                                                                                  | `{}`                                          |
| `pluginBarmanCloud.podAnnotations`                                    | Annotations for plugin-barman-cloud pods                                                                                                                                                                                   | `{}`                                          |
| `pluginBarmanCloud.podAffinityPreset`                                 | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                        | `""`                                          |
| `pluginBarmanCloud.podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                   | `soft`                                        |
| `pluginBarmanCloud.pdb.create`                                        | Enable/disable a Pod Disruption Budget creation                                                                                                                                                                            | `true`                                        |
| `pluginBarmanCloud.pdb.minAvailable`                                  | Minimum number/percentage of pods that should remain scheduled                                                                                                                                                             | `""`                                          |
| `pluginBarmanCloud.pdb.maxUnavailable`                                | Maximum number/percentage of pods that may be made unavailable                                                                                                                                                             | `""`                                          |
| `pluginBarmanCloud.nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                  | `""`                                          |
| `pluginBarmanCloud.nodeAffinityPreset.key`                            | Node label key to match. Ignored if `affinity` is set                                                                                                                                                                      | `""`                                          |
| `pluginBarmanCloud.nodeAffinityPreset.values`                         | Node label values to match. Ignored if `affinity` is set                                                                                                                                                                   | `[]`                                          |
| `pluginBarmanCloud.affinity`                                          | Affinity for plugin-barman-cloud pods assignment                                                                                                                                                                           | `{}`                                          |
| `pluginBarmanCloud.nodeSelector`                                      | Node labels for plugin-barman-cloud pods assignment                                                                                                                                                                        | `{}`                                          |
| `pluginBarmanCloud.tolerations`                                       | Tolerations for plugin-barman-cloud pods assignment                                                                                                                                                                        | `[]`                                          |
| `pluginBarmanCloud.updateStrategy.type`                               | plugin-barman-cloud statefulset strategy type                                                                                                                                                                              | `RollingUpdate`                               |
| `pluginBarmanCloud.priorityClassName`                                 | plugin-barman-cloud pods' priorityClassName                                                                                                                                                                                | `""`                                          |
| `pluginBarmanCloud.topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template                                                                                                   | `[]`                                          |
| `pluginBarmanCloud.schedulerName`                                     | Name of the k8s scheduler (other than default) for plugin-barman-cloud pods                                                                                                                                                | `""`                                          |
| `pluginBarmanCloud.terminationGracePeriodSeconds`                     | Seconds Redmine pod needs to terminate gracefully                                                                                                                                                                          | `""`                                          |
| `pluginBarmanCloud.lifecycleHooks`                                    | for the plugin-barman-cloud container(s) to automate configuration before or after startup                                                                                                                                 | `{}`                                          |
| `pluginBarmanCloud.extraEnvVars`                                      | Array with extra environment variables to add to plugin-barman-cloud nodes                                                                                                                                                 | `[]`                                          |
| `pluginBarmanCloud.extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for plugin-barman-cloud nodes                                                                                                                                         | `""`                                          |
| `pluginBarmanCloud.extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for plugin-barman-cloud nodes                                                                                                                                            | `""`                                          |
| `pluginBarmanCloud.extraVolumes`                                      | Optionally specify extra list of additional volumes for the plugin-barman-cloud pod(s)                                                                                                                                     | `[]`                                          |
| `pluginBarmanCloud.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the plugin-barman-cloud container(s)                                                                                                                          | `[]`                                          |
| `pluginBarmanCloud.sidecars`                                          | Add additional sidecar containers to the plugin-barman-cloud pod(s)                                                                                                                                                        | `[]`                                          |
| `pluginBarmanCloud.initContainers`                                    | Add additional init containers to the plugin-barman-cloud pod(s)                                                                                                                                                           | `[]`                                          |

### TLS/SSL parameters

| Name                                                                 | Description                                                                                                                                                            | Value   |
| -------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `pluginBarmanCloud.tls.server.existingSecret`                        | Existing secret that contains TLS certificates for the server                                                                                                          | `""`    |
| `pluginBarmanCloud.tls.server.cert`                                  | TLS certificate. Ignored if `pluginBarmanCloud.tls.server.existingSecret` is set                                                                                       | `""`    |
| `pluginBarmanCloud.tls.server.key`                                   | TLS key. Ignored if `pluginBarmanCloud.tls.server.existingSecret` is set                                                                                               | `""`    |
| `pluginBarmanCloud.tls.client.existingSecret`                        | Existing secret that contains TLS certificates for the client                                                                                                          | `""`    |
| `pluginBarmanCloud.tls.client.cert`                                  | TLS certificate. Ignored if `pluginBarmanCloud.tls.client.existingSecret` is set                                                                                       | `""`    |
| `pluginBarmanCloud.tls.client.key`                                   | TLS key. Ignored if `pluginBarmanCloud.tls.client.existingSecret` is set                                                                                               | `""`    |
| `pluginBarmanCloud.tls.autoGenerated.enabled`                        | Enable automatic generation of certificates for TLS                                                                                                                    | `true`  |
| `pluginBarmanCloud.tls.autoGenerated.engine`                         | Mechanism to generate the certificates (allowed values: helm, cert-manager)                                                                                            | `helm`  |
| `pluginBarmanCloud.tls.autoGenerated.certManager.existingIssuer`     | The name of an existing Issuer to use for generating the certificates (only for `cert-manager` engine)                                                                 | `""`    |
| `pluginBarmanCloud.tls.autoGenerated.certManager.existingIssuerKind` | Existing Issuer kind, defaults to Issuer (only for `cert-manager` engine)                                                                                              | `""`    |
| `pluginBarmanCloud.tls.autoGenerated.certManager.keyAlgorithm`       | Key algorithm for the certificates (only for `cert-manager` engine)                                                                                                    | `RSA`   |
| `pluginBarmanCloud.tls.autoGenerated.certManager.keySize`            | Key size for the certificates (only for `cert-manager` engine)                                                                                                         | `2048`  |
| `pluginBarmanCloud.tls.autoGenerated.certManager.duration`           | Duration for the certificates (only for `cert-manager` engine)                                                                                                         | `2160h` |
| `pluginBarmanCloud.tls.autoGenerated.certManager.renewBefore`        | Renewal period for the certificates (only for `cert-manager` engine)                                                                                                   | `360h`  |
| `pluginBarmanCloud.autoscaling.vpa.enabled`                          | Enable VPA                                                                                                                                                             | `false` |
| `pluginBarmanCloud.autoscaling.vpa.annotations`                      | Annotations for VPA resource                                                                                                                                           | `{}`    |
| `pluginBarmanCloud.autoscaling.vpa.controlledResources`              | VPA List of resources that the vertical pod autoscaler can control. Defaults to cpu and memory                                                                         | `[]`    |
| `pluginBarmanCloud.autoscaling.vpa.maxAllowed`                       | VPA Max allowed resources for the pod                                                                                                                                  | `{}`    |
| `pluginBarmanCloud.autoscaling.vpa.minAllowed`                       | VPA Min allowed resources for the pod                                                                                                                                  | `{}`    |
| `pluginBarmanCloud.autoscaling.vpa.updatePolicy.updateMode`          | Autoscaling update policy Specifies whether recommended updates are applied when a Pod is started and whether recommended updates are applied during the life of a Pod | `Auto`  |
| `pluginBarmanCloud.autoscaling.hpa.enabled`                          | Enable autoscaling for                                                                                                                                                 | `false` |
| `pluginBarmanCloud.autoscaling.hpa.minReplicas`                      | Minimum number of replicas                                                                                                                                             | `""`    |
| `pluginBarmanCloud.autoscaling.hpa.maxReplicas`                      | Maximum number of replicas                                                                                                                                             | `""`    |
| `pluginBarmanCloud.autoscaling.hpa.targetCPU`                        | Target CPU utilization percentage                                                                                                                                      | `""`    |
| `pluginBarmanCloud.autoscaling.hpa.targetMemory`                     | Target Memory utilization percentage                                                                                                                                   | `""`    |

### plugin-barman-cloud Traffic Exposure Parameters

| Name                                                      | Description                                                                                        | Value       |
| --------------------------------------------------------- | -------------------------------------------------------------------------------------------------- | ----------- |
| `pluginBarmanCloud.service.type`                          | plugin-barman-cloud service type                                                                   | `ClusterIP` |
| `pluginBarmanCloud.service.ports.grpc`                    | plugin-barman-cloud service webhook port                                                           | `9090`      |
| `pluginBarmanCloud.service.nodePorts.grpc`                | Node port for webhook                                                                              | `""`        |
| `pluginBarmanCloud.service.clusterIP`                     | plugin-barman-cloud service Cluster IP                                                             | `""`        |
| `pluginBarmanCloud.service.loadBalancerIP`                | plugin-barman-cloud service Load Balancer IP                                                       | `""`        |
| `pluginBarmanCloud.service.loadBalancerSourceRanges`      | plugin-barman-cloud service Load Balancer sources                                                  | `[]`        |
| `pluginBarmanCloud.service.externalTrafficPolicy`         | plugin-barman-cloud service external traffic policy                                                | `Cluster`   |
| `pluginBarmanCloud.service.labels`                        | Labels for the service                                                                             | `{}`        |
| `pluginBarmanCloud.service.annotations`                   | Additional custom annotations for plugin-barman-cloud service                                      | `{}`        |
| `pluginBarmanCloud.service.extraPorts`                    | Extra ports to expose in plugin-barman-cloud service (normally used with the `sidecars` value)     | `[]`        |
| `pluginBarmanCloud.service.sessionAffinity`               | Control where web requests go, to the same pod or round-robin                                      | `None`      |
| `pluginBarmanCloud.service.sessionAffinityConfig`         | Additional settings for the sessionAffinity                                                        | `{}`        |
| `pluginBarmanCloud.networkPolicy.enabled`                 | Specifies whether a NetworkPolicy should be created                                                | `true`      |
| `pluginBarmanCloud.networkPolicy.kubeAPIServerPorts`      | List of possible endpoints to kube-apiserver (limit to your cluster settings to increase security) | `[]`        |
| `pluginBarmanCloud.networkPolicy.allowExternal`           | Don't require server label for connections                                                         | `true`      |
| `pluginBarmanCloud.networkPolicy.allowExternalEgress`     | Allow the pod to access any range of port and all destinations.                                    | `true`      |
| `pluginBarmanCloud.networkPolicy.extraIngress`            | Add extra ingress rules to the NetworkPolicy                                                       | `[]`        |
| `pluginBarmanCloud.networkPolicy.extraEgress`             | Add extra ingress rules to the NetworkPolicy                                                       | `[]`        |
| `pluginBarmanCloud.networkPolicy.ingressNSMatchLabels`    | Labels to match to allow traffic from other namespaces                                             | `{}`        |
| `pluginBarmanCloud.networkPolicy.ingressNSPodMatchLabels` | Pod labels to match to allow traffic from other namespaces                                         | `{}`        |

### plugin-barman-cloud RBAC Parameters

| Name                                                            | Description                                                      | Value   |
| --------------------------------------------------------------- | ---------------------------------------------------------------- | ------- |
| `pluginBarmanCloud.rbac.create`                                 | Specifies whether RBAC resources should be created               | `true`  |
| `pluginBarmanCloud.rbac.rules`                                  | Custom RBAC rules to set                                         | `[]`    |
| `pluginBarmanCloud.serviceAccount.create`                       | Specifies whether a ServiceAccount should be created             | `true`  |
| `pluginBarmanCloud.serviceAccount.name`                         | The name of the ServiceAccount to use.                           | `""`    |
| `pluginBarmanCloud.serviceAccount.annotations`                  | Additional Service Account annotations (evaluated as a template) | `{}`    |
| `pluginBarmanCloud.serviceAccount.automountServiceAccountToken` | Automount service account token for the server service account   | `false` |

### plugin-barman-cloud Metrics Parameters

| Name                                                         | Description                                                                                   | Value   |
| ------------------------------------------------------------ | --------------------------------------------------------------------------------------------- | ------- |
| `pluginBarmanCloud.metrics.enabled`                          | Enable the export of Prometheus metrics                                                       | `false` |
| `pluginBarmanCloud.metrics.allowedServiceAccounts`           | Configure the allowed ServiceAccounts (with their namespace) to access the metrics endpoint   | `[]`    |
| `pluginBarmanCloud.metrics.service.ports.metrics`            | Meetrics service port                                                                         | `80`    |
| `pluginBarmanCloud.metrics.service.clusterIP`                | Static clusterIP or None for headless services                                                | `""`    |
| `pluginBarmanCloud.metrics.service.sessionAffinity`          | Control where client requests go, to the same pod or round-robin                              | `None`  |
| `pluginBarmanCloud.metrics.service.labels`                   | Labels for the metrics service                                                                | `{}`    |
| `pluginBarmanCloud.metrics.service.annotations`              | Annotations for the metrics service                                                           | `{}`    |
| `pluginBarmanCloud.metrics.serviceMonitor.enabled`           | if `true`, creates a Prometheus ServiceMonitor (also requires `metrics.enabled` to be `true`) | `false` |
| `pluginBarmanCloud.metrics.serviceMonitor.namespace`         | Namespace in which Prometheus is running                                                      | `""`    |
| `pluginBarmanCloud.metrics.serviceMonitor.annotations`       | Additional custom annotations for the ServiceMonitor                                          | `{}`    |
| `pluginBarmanCloud.metrics.serviceMonitor.labels`            | Extra labels for the ServiceMonitor                                                           | `{}`    |
| `pluginBarmanCloud.metrics.serviceMonitor.jobLabel`          | The name of the label on the target service to use as the job name in Prometheus              | `""`    |
| `pluginBarmanCloud.metrics.serviceMonitor.honorLabels`       | honorLabels chooses the metric's labels on collisions with target labels                      | `false` |
| `pluginBarmanCloud.metrics.serviceMonitor.interval`          | Interval at which metrics should be scraped.                                                  | `""`    |
| `pluginBarmanCloud.metrics.serviceMonitor.scrapeTimeout`     | Timeout after which the scrape is ended                                                       | `""`    |
| `pluginBarmanCloud.metrics.serviceMonitor.metricRelabelings` | Specify additional relabeling of metrics                                                      | `[]`    |
| `pluginBarmanCloud.metrics.serviceMonitor.relabelings`       | Specify general relabeling                                                                    | `[]`    |
| `pluginBarmanCloud.metrics.serviceMonitor.selector`          | Prometheus instance selector labels                                                           | `{}`    |

The above parameters map to the env variables defined in [bitnami/cloudnative-pg](https://github.com/bitnami/containers/tree/main/bitnami/cloudnative-pg). For more information please refer to the [bitnami/cloudnative-pg](https://github.com/bitnami/containers/tree/main/bitnami/cloudnative-pg) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
  --set pluginBarmanCloud.enabled=true \
    REGISTRY_NAME/REPOSITORY_NAME/cloudnative-pg
```

The above command enables the Barman Cloud Plugin.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml REGISTRY_NAME/REPOSITORY_NAME/cloudnative-pg
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.
> **Tip**: You can use the default [values.yaml](https://github.com/bitnami/charts/tree/main/bitnami/cloudnative-pg/values.yaml)

## Upgrading

### To 1.0.0

This version performs a major refactor of the chart values to include the `plugin-barman-cloud` component:

- All the CloudNativePG settings have been moved to the `operator.*` section.
- It includes a section `pluginBarmanCloud.*` section with all the parameters for the `plugin-barman-cloud` deployment. It is enabled by default.

No major issues are expected during upgrades, assuming that the all the parameter references have been migrated to the new structure.

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