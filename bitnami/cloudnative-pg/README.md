<!--- app-name: CloudNative-PG -->

# Bitnami package for CloudNative-PG

CloudNativePG is an open-source tool for managing PostgreSQL databases on Kubernetes, from setup to ongoing upkeep

[Overview of cloudnative-pg](https://cloudnative-pg.io)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/cloudnative-pg
```

Looking to use cloudnative-pg in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the commercial edition of the Bitnami catalog.

## Introduction

This chart bootstraps a [cloudnative-pg](https://github.com/bitnami/containers/tree/main/bitnami/cloudnative-pg) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release REGISTRY_NAME/REPOSITORY_NAME/cloudnative-pg
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The command deploys cloudnative-pg on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Configuration and installation details

### Operator configuration

The Bitnami cloudnative-pg chart allows [configuring the operator](https://cloudnative-pg.io/documentation/current/operator_conf/#available-options) using ConfigMaps and Secrets. This is done using the `configuration` and `secretConfiguration` parameters. Both are values are compatible, and the configuration in the `secretConfiguration` section takes precedence over the `configuration` section. In the example below we add extra configuration parameters to the operator:

```yaml
configuration:
  EXPIRING_CHECK_THRESHOLD: 12
secretConfiguration:
  CERTIFICATE_DURATION: 120
```

It is also possible to use existing ConfigMaps and Secrets using the `existingConfigMap` and `existingSecret` parameters (note that these are not compatible with the `configuration` and `secretConfiguration` parameters).

### Resource requests and limits

Bitnami charts allow setting resource requests and limits for all containers inside the chart deployment. These are inside the `resources` value (check parameter table). Setting requests is essential for production workloads and these should be adapted to your specific use case.

To make this process easier, the chart contains the `resourcesPreset` values, which automatically sets the `resources` section according to different presets. Check these presets in [the bitnami/common chart](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15). However, in production workloads using `resourcesPreset` is discouraged as it may not fully adapt to your specific needs. Find more information on container resource management in the [official Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).

### Backup and restore

To back up and restore Helm chart deployments on Kubernetes, you need to back up the persistent volumes from the source deployment and attach them to a new deployment using [Velero](https://velero.io/), a Kubernetes backup/restore tool. Find the instructions for using Velero in [this guide](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-backup-restore-deployments-velero-index.html).

### Prometheus metrics

This chart can be integrated with Prometheus by setting `metrics.enabled` to true. This will expose the cloudnative-pg native Prometheus endpoint in a `metrics` service, which can be configured under the `metrics.service` section. It will have the necessary annotations to be automatically scraped by Prometheus.

#### Prometheus requirements

It is necessary to have a working installation of Prometheus or Prometheus Operator for the integration to work. Install the [Bitnami Prometheus helm chart](https://github.com/bitnami/charts/tree/main/bitnami/prometheus) or the [Bitnami Kube Prometheus helm chart](https://github.com/bitnami/charts/tree/main/bitnami/kube-prometheus) to easily have a working Prometheus in your cluster.

#### Integration with Prometheus Operator

The chart can deploy `ServiceMonitor` objects for integration with Prometheus Operator installations. To do so, set the value `metrics.serviceMonitor.enabled=true`. Ensure that the Prometheus Operator `CustomResourceDefinitions` are installed in the cluster or it will fail with the following error:

```text
no matches for kind "ServiceMonitor" in version "monitoring.coreos.com/v1"
```

Install the [Bitnami Kube Prometheus helm chart](https://github.com/bitnami/charts/tree/main/bitnami/kube-prometheus) for having the necessary CRDs and the Prometheus Operator.

### [Rolling VS Immutable tags](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Additional environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `extraEnvVars` property:

```yaml
extraEnvVars:
  - name: LOG_LEVEL
    value: error
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values inside the `operator`, `apiserver` and `cluster` sections.

### Sidecars

If additional containers are needed in the same pod as cloudnative-pg (such as additional metrics or logging exporters), they can be defined using the `sidecars` parameter:

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

Check the [cloudnative-pg official documentation](https://cloudnative-pg.io/documentation/current/) for the list of available objects.

### Pod affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, use one of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters inside the `operator`, `apiserver` and `cluster` sections.

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

| Name                                                | Description                                                                                                                                                                                                                         | Value                            |
| --------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------- |
| `kubeVersion`                                       | Override Kubernetes version                                                                                                                                                                                                         | `""`                             |
| `nameOverride`                                      | String to partially override common.names.name                                                                                                                                                                                      | `""`                             |
| `fullnameOverride`                                  | String to fully override common.names.fullname                                                                                                                                                                                      | `""`                             |
| `namespaceOverride`                                 | String to fully override common.names.namespace                                                                                                                                                                                     | `""`                             |
| `commonLabels`                                      | Labels to add to all deployed objects                                                                                                                                                                                               | `{}`                             |
| `commonAnnotations`                                 | Annotations to add to all deployed objects                                                                                                                                                                                          | `{}`                             |
| `clusterDomain`                                     | Kubernetes cluster domain name                                                                                                                                                                                                      | `cluster.local`                  |
| `extraDeploy`                                       | Array of extra objects to deploy with the release                                                                                                                                                                                   | `[]`                             |
| `image.registry`                                    | cloudnative-pg Operator image registry                                                                                                                                                                                              | `REGISTRY_NAME`                  |
| `image.repository`                                  | cloudnative-pg Operator image repository                                                                                                                                                                                            | `REPOSITORY_NAME/cloudnative-pg` |
| `image.digest`                                      | cloudnative-pg Operator image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag image tag (immutable tags are recommended)                                                                  | `""`                             |
| `image.pullPolicy`                                  | cloudnative-pg Operator image pull policy                                                                                                                                                                                           | `IfNotPresent`                   |
| `image.pullSecrets`                                 | cloudnative-pg Operator image pull secrets                                                                                                                                                                                          | `[]`                             |
| `image.debug`                                       | Enable cloudnative-pg Operator image debug mode                                                                                                                                                                                     | `false`                          |
| `postgresqlImage.registry`                          | PostgreSQL image registry                                                                                                                                                                                                           | `REGISTRY_NAME`                  |
| `postgresqlImage.repository`                        | PostgreSQL image repository                                                                                                                                                                                                         | `REPOSITORY_NAME/postgresql`     |
| `postgresqlImage.digest`                            | PostgreSQL image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                          | `""`                             |
| `replicaCount`                                      | Number of cloudnative-pg Operator replicas to deploy                                                                                                                                                                                | `1`                              |
| `containerPorts.metrics`                            | cloudnative-pg Operator metrics container port                                                                                                                                                                                      | `8080`                           |
| `containerPorts.webhook`                            | cloudnative-pg Operator webhook container port                                                                                                                                                                                      | `9443`                           |
| `livenessProbe.enabled`                             | Enable livenessProbe on cloudnative-pg Operator containers                                                                                                                                                                          | `true`                           |
| `livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                                             | `5`                              |
| `livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                                    | `10`                             |
| `livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                                   | `5`                              |
| `livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                                                 | `5`                              |
| `livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                                                 | `1`                              |
| `readinessProbe.enabled`                            | Enable readinessProbe on cloudnative-pg Operator containers                                                                                                                                                                         | `true`                           |
| `readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                                            | `5`                              |
| `readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                                   | `10`                             |
| `readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                                  | `5`                              |
| `readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                                                | `5`                              |
| `readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                                                | `1`                              |
| `startupProbe.enabled`                              | Enable startupProbe on cloudnative-pg Operator containers                                                                                                                                                                           | `false`                          |
| `startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                                              | `5`                              |
| `startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                                     | `10`                             |
| `startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                                    | `5`                              |
| `startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                                  | `5`                              |
| `startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                                  | `1`                              |
| `customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                                                                                                                                 | `{}`                             |
| `customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                                                                                                                                                | `{}`                             |
| `customStartupProbe`                                | Custom startupProbe that overrides the default one                                                                                                                                                                                  | `{}`                             |
| `watchAllNamespaces`                                | Watch for cloudnative-pg resources in all namespaces                                                                                                                                                                                | `true`                           |
| `watchNamespaces`                                   | Watch for cloudnative-pg resources in the given namespaces                                                                                                                                                                          | `[]`                             |
| `maxConcurrentReconciles`                           | Maximum concurrent reconciles in the operator                                                                                                                                                                                       | `10`                             |
| `configuration`                                     | Add configuration settings to a configmap                                                                                                                                                                                           | `{}`                             |
| `secretConfiguration`                               | Add configuration settings to a secret                                                                                                                                                                                              | `{}`                             |
| `existingConfigMap`                                 | Name of a ConfigMap containing the operator configuration                                                                                                                                                                           | `""`                             |
| `existingSecret`                                    | Name of a Secret containing the operator secret configuration                                                                                                                                                                       | `""`                             |
| `resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if operator.resources is set (operator.resources is recommended for production). | `nano`                           |
| `resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                   | `{}`                             |
| `podSecurityContext.enabled`                        | Enabled cloudnative-pg Operator pods' Security Context                                                                                                                                                                              | `true`                           |
| `podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                                  | `Always`                         |
| `podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                                      | `[]`                             |
| `podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                                         | `[]`                             |
| `podSecurityContext.fsGroup`                        | Set cloudnative-pg Operator pod's Security Context fsGroup                                                                                                                                                                          | `1001`                           |
| `containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                                                                                                                                                | `true`                           |
| `containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                                    | `{}`                             |
| `containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                                                                                                                          | `1001`                           |
| `containerSecurityContext.runAsGroup`               | Set containers' Security Context runAsGroup                                                                                                                                                                                         | `1001`                           |
| `containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                                                                                                                                       | `true`                           |
| `containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                                                                                                                                         | `false`                          |
| `containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                                             | `true`                           |
| `containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                                                                                                                           | `false`                          |
| `containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                                  | `["ALL"]`                        |
| `containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                                    | `RuntimeDefault`                 |
| `command`                                           | Override default container command (useful when using custom images)                                                                                                                                                                | `[]`                             |
| `args`                                              | Override default container args (useful when using custom images)                                                                                                                                                                   | `[]`                             |
| `automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                                  | `true`                           |
| `hostAliases`                                       | cloudnative-pg Operator pods host aliases                                                                                                                                                                                           | `[]`                             |
| `podLabels`                                         | Extra labels for cloudnative-pg Operator pods                                                                                                                                                                                       | `{}`                             |
| `podAnnotations`                                    | Annotations for cloudnative-pg Operator pods                                                                                                                                                                                        | `{}`                             |
| `podAffinityPreset`                                 | Pod affinity preset. Ignored if `server.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                          | `""`                             |
| `podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `server.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                     | `soft`                           |
| `pdb.create`                                        | Enable/disable a Pod Disruption Budget creation                                                                                                                                                                                     | `true`                           |
| `pdb.minAvailable`                                  | Minimum number/percentage of pods that should remain scheduled                                                                                                                                                                      | `""`                             |
| `pdb.maxUnavailable`                                | Maximum number/percentage of pods that may be made unavailable                                                                                                                                                                      | `""`                             |
| `nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `server.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                    | `""`                             |
| `nodeAffinityPreset.key`                            | Node label key to match. Ignored if `server.affinity` is set                                                                                                                                                                        | `""`                             |
| `nodeAffinityPreset.values`                         | Node label values to match. Ignored if `server.affinity` is set                                                                                                                                                                     | `[]`                             |
| `affinity`                                          | Affinity for cloudnative-pg Operator pods assignment                                                                                                                                                                                | `{}`                             |
| `nodeSelector`                                      | Node labels for cloudnative-pg Operator pods assignment                                                                                                                                                                             | `{}`                             |
| `tolerations`                                       | Tolerations for cloudnative-pg Operator pods assignment                                                                                                                                                                             | `[]`                             |
| `updateStrategy.type`                               | cloudnative-pg Operator statefulset strategy type                                                                                                                                                                                   | `RollingUpdate`                  |
| `priorityClassName`                                 | cloudnative-pg Operator pods' priorityClassName                                                                                                                                                                                     | `""`                             |
| `topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template                                                                                                            | `[]`                             |
| `schedulerName`                                     | Name of the k8s scheduler (other than default) for cloudnative-pg Operator pods                                                                                                                                                     | `""`                             |
| `terminationGracePeriodSeconds`                     | Seconds Redmine pod needs to terminate gracefully                                                                                                                                                                                   | `""`                             |
| `lifecycleHooks`                                    | for the cloudnative-pg Operator container(s) to automate configuration before or after startup                                                                                                                                      | `{}`                             |
| `extraEnvVars`                                      | Array with extra environment variables to add to cloudnative-pg Operator nodes                                                                                                                                                      | `[]`                             |
| `extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for cloudnative-pg Operator nodes                                                                                                                                              | `""`                             |
| `extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for cloudnative-pg Operator nodes                                                                                                                                                 | `""`                             |
| `extraVolumes`                                      | Optionally specify extra list of additional volumes for the cloudnative-pg Operator pod(s)                                                                                                                                          | `[]`                             |
| `extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the cloudnative-pg Operator container(s)                                                                                                                               | `[]`                             |
| `sidecars`                                          | Add additional sidecar containers to the cloudnative-pg Operator pod(s)                                                                                                                                                             | `[]`                             |
| `initContainers`                                    | Add additional init containers to the cloudnative-pg Operator pod(s)                                                                                                                                                                | `[]`                             |
| `webhook.validating.create`                         | Create ValidatingWebhookConfiguration                                                                                                                                                                                               | `true`                           |
| `webhook.validating.failurePolicy`                  | Set failure policy of the validating webhook                                                                                                                                                                                        | `Fail`                           |
| `webhook.mutating.create`                           | Create MutatingWebhookConfiguration                                                                                                                                                                                                 | `true`                           |
| `webhook.mutating.failurePolicy`                    | Set failure policy of the mutating webhook                                                                                                                                                                                          | `Fail`                           |
| `autoscaling.vpa.enabled`                           | Enable VPA                                                                                                                                                                                                                          | `false`                          |
| `autoscaling.vpa.annotations`                       | Annotations for VPA resource                                                                                                                                                                                                        | `{}`                             |
| `autoscaling.vpa.controlledResources`               | VPA List of resources that the vertical pod autoscaler can control. Defaults to cpu and memory                                                                                                                                      | `[]`                             |
| `autoscaling.vpa.maxAllowed`                        | VPA Max allowed resources for the pod                                                                                                                                                                                               | `{}`                             |
| `autoscaling.vpa.minAllowed`                        | VPA Min allowed resources for the pod                                                                                                                                                                                               | `{}`                             |
| `autoscaling.vpa.updatePolicy.updateMode`           | Autoscaling update policy Specifies whether recommended updates are applied when a Pod is started and whether recommended updates are applied during the life of a Pod                                                              | `Auto`                           |
| `autoscaling.hpa.enabled`                           | Enable autoscaling for operator                                                                                                                                                                                                     | `false`                          |
| `autoscaling.hpa.minReplicas`                       | Minimum number of operator replicas                                                                                                                                                                                                 | `""`                             |
| `autoscaling.hpa.maxReplicas`                       | Maximum number of operator replicas                                                                                                                                                                                                 | `""`                             |
| `autoscaling.hpa.targetCPU`                         | Target CPU utilization percentage                                                                                                                                                                                                   | `""`                             |
| `autoscaling.hpa.targetMemory`                      | Target Memory utilization percentage                                                                                                                                                                                                | `""`                             |

### cloudnative-pg Operator Traffic Exposure Parameters

| Name                                    | Description                                                                                                                      | Value                    |
| --------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `service.type`                          | cloudnative-pg Operator service type                                                                                             | `ClusterIP`              |
| `service.ports.webhook`                 | cloudnative-pg Operator service webhook port                                                                                     | `443`                    |
| `service.nodePorts.webhook`             | Node port for webhook                                                                                                            | `""`                     |
| `service.clusterIP`                     | cloudnative-pg Operator service Cluster IP                                                                                       | `""`                     |
| `service.loadBalancerIP`                | cloudnative-pg Operator service Load Balancer IP                                                                                 | `""`                     |
| `service.loadBalancerSourceRanges`      | cloudnative-pg Operator service Load Balancer sources                                                                            | `[]`                     |
| `service.externalTrafficPolicy`         | cloudnative-pg Operator service external traffic policy                                                                          | `Cluster`                |
| `service.labels`                        | Labels for the service                                                                                                           | `{}`                     |
| `service.annotations`                   | Additional custom annotations for cloudnative-pg Operator service                                                                | `{}`                     |
| `service.extraPorts`                    | Extra ports to expose in cloudnative-pg Operator service (normally used with the `sidecars` value)                               | `[]`                     |
| `service.sessionAffinity`               | Control where web requests go, to the same pod or round-robin                                                                    | `None`                   |
| `service.sessionAffinityConfig`         | Additional settings for the sessionAffinity                                                                                      | `{}`                     |
| `networkPolicy.enabled`                 | Specifies whether a NetworkPolicy should be created                                                                              | `true`                   |
| `networkPolicy.kubeAPIServerPorts`      | List of possible endpoints to kube-apiserver (limit to your cluster settings to increase security)                               | `[]`                     |
| `networkPolicy.allowExternal`           | Don't require server label for connections                                                                                       | `true`                   |
| `networkPolicy.allowExternalEgress`     | Allow the pod to access any range of port and all destinations.                                                                  | `true`                   |
| `networkPolicy.extraIngress`            | Add extra ingress rules to the NetworkPolicy                                                                                     | `[]`                     |
| `networkPolicy.extraEgress`             | Add extra ingress rules to the NetworkPolicy                                                                                     | `[]`                     |
| `networkPolicy.ingressNSMatchLabels`    | Labels to match to allow traffic from other namespaces                                                                           | `{}`                     |
| `networkPolicy.ingressNSPodMatchLabels` | Pod labels to match to allow traffic from other namespaces                                                                       | `{}`                     |
| `ingress.enabled`                       | Enable ingress record generation for cloudnative-pg                                                                              | `false`                  |
| `ingress.pathType`                      | Ingress path type                                                                                                                | `ImplementationSpecific` |
| `ingress.apiVersion`                    | Force Ingress API version (automatically detected if not set)                                                                    | `""`                     |
| `ingress.hostname`                      | Default host for the ingress record                                                                                              | `cloudnative-pg.local`   |
| `ingress.ingressClassName`              | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                    | `""`                     |
| `ingress.path`                          | Default path for the ingress record                                                                                              | `/`                      |
| `ingress.annotations`                   | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                     |
| `ingress.tls`                           | Enable TLS configuration for the host defined at `client.ingress.hostname` parameter                                             | `false`                  |
| `ingress.selfSigned`                    | Create a TLS secret for this ingress record using self-signed certificates generated by Helm                                     | `false`                  |
| `ingress.extraHosts`                    | An array with additional hostname(s) to be covered with the ingress record                                                       | `[]`                     |
| `ingress.extraPaths`                    | An array with additional arbitrary paths that may need to be added to the ingress under the main host                            | `[]`                     |
| `ingress.extraTls`                      | TLS configuration for additional hostname(s) to be covered with this ingress record                                              | `[]`                     |
| `ingress.secrets`                       | Custom TLS certificates as secrets                                                                                               | `[]`                     |
| `ingress.extraRules`                    | Additional rules to be covered with this ingress record                                                                          | `[]`                     |

### cloudnative-pg Operator RBAC Parameters

| Name                                          | Description                                                      | Value   |
| --------------------------------------------- | ---------------------------------------------------------------- | ------- |
| `rbac.create`                                 | Specifies whether RBAC resources should be created               | `true`  |
| `rbac.rules`                                  | Custom RBAC rules to set                                         | `[]`    |
| `serviceAccount.create`                       | Specifies whether a ServiceAccount should be created             | `true`  |
| `serviceAccount.name`                         | The name of the ServiceAccount to use.                           | `""`    |
| `serviceAccount.annotations`                  | Additional Service Account annotations (evaluated as a template) | `{}`    |
| `serviceAccount.automountServiceAccountToken` | Automount service account token for the server service account   | `false` |

### cloudnative-pg Operator Metrics Parameters

| Name                                       | Description                                                                                            | Value   |
| ------------------------------------------ | ------------------------------------------------------------------------------------------------------ | ------- |
| `metrics.enabled`                          | Enable the export of Prometheus metrics                                                                | `false` |
| `metrics.service.ports.metrics`            | Meetrics service port                                                                                  | `80`    |
| `metrics.service.clusterIP`                | Static clusterIP or None for headless services                                                         | `""`    |
| `metrics.service.sessionAffinity`          | Control where client requests go, to the same pod or round-robin                                       | `None`  |
| `metrics.service.labels`                   | Labels for the metrics service                                                                         | `{}`    |
| `metrics.service.annotations`              | Annotations for the metrics service                                                                    | `{}`    |
| `metrics.serviceMonitor.enabled`           | if `true`, creates a Prometheus Operator ServiceMonitor (also requires `metrics.enabled` to be `true`) | `false` |
| `metrics.serviceMonitor.namespace`         | Namespace in which Prometheus is running                                                               | `""`    |
| `metrics.serviceMonitor.annotations`       | Additional custom annotations for the ServiceMonitor                                                   | `{}`    |
| `metrics.serviceMonitor.labels`            | Extra labels for the ServiceMonitor                                                                    | `{}`    |
| `metrics.serviceMonitor.jobLabel`          | The name of the label on the target service to use as the job name in Prometheus                       | `""`    |
| `metrics.serviceMonitor.honorLabels`       | honorLabels chooses the metric's labels on collisions with target labels                               | `false` |
| `metrics.serviceMonitor.interval`          | Interval at which metrics should be scraped.                                                           | `""`    |
| `metrics.serviceMonitor.scrapeTimeout`     | Timeout after which the scrape is ended                                                                | `""`    |
| `metrics.serviceMonitor.metricRelabelings` | Specify additional relabeling of metrics                                                               | `[]`    |
| `metrics.serviceMonitor.relabelings`       | Specify general relabeling                                                                             | `[]`    |
| `metrics.serviceMonitor.selector`          | Prometheus instance selector labels                                                                    | `{}`    |

The above parameters map to the env variables defined in [bitnami/cloudnative-pg](https://github.com/bitnami/containers/tree/main/bitnami/cloudnative-pg). For more information please refer to the [bitnami/cloudnative-pg](https://github.com/bitnami/containers/tree/main/bitnami/cloudnative-pg) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
  --set apiserver.enabled=true \
    REGISTRY_NAME/REPOSITORY_NAME/cloudnative-pg
```

The above command enables the cloudnative-pg API Server.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml REGISTRY_NAME/REPOSITORY_NAME/cloudnative-pg
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.
> **Tip**: You can use the default [values.yaml](https://github.com/bitnami/charts/tree/main/bitnami/cloudnative-pg/values.yaml)

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