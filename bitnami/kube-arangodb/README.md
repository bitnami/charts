<!--- app-name: ArangoDB Kubernetes Operator -->

# Bitnami package for ArangoDB Kubernetes Operator

kube-arangodb is a Kubernetes Operator that manages ArangoDB clusters, ensuring automatic deployment, scaling, and healing of database instances.

[Overview of ArangoDB Kubernetes Operator](https://arangodb.com/)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/kube-arangodb
```

Looking to use ArangoDB Kubernetes Operator in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the commercial edition of the Bitnami catalog.

## Introduction

This chart bootstraps a [ArangoDB Kubernetes Operator](https://github.com/bitnami/containers/tree/main/bitnami/kube-arangodb) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release REGISTRY_NAME/REPOSITORY_NAME/kube-arangodb
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The command deploys ArangoDB Kubernetes Operator on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Configuration and installation details

### Enable kube-arangodb operators

kube-arangodb allows setting multiple operators, managing different areas of the ArangoDB database lyfecycle. This is configured under the `features` section. The following is an example of enabling different operators inside kube-arangodb.

```yaml
features:
  deployment: true
  deploymentReplications: true
  storage: false
  backup: false
  apps: false
  k8sToK8sClusterSync: false
  ml: false
  analytics: false
  networking: true
  scheduler: true
  platform: true
```

Check the [official kube-arangodb documentation](https://arangodb.github.io/kube-arangodb/docs/features/README.html) for the detailed settings of each feature.

### Update credentials

The Bitnami ArangoDB Kubernetes Operator chart, when upgrading, reuses the secret previously rendered by the chart or the one specified in `auth.existingSecret`. To update credentials, use one of the following:

- Run `helm upgrade` specifying a new password in `auth.password`
- Run `helm upgrade` specifying a new secret in `auth.existingSecret`

### Resource requests and limits

Bitnami charts allow setting resource requests and limits for all containers inside the chart deployment. These are inside the `resources` value (check parameter table). Setting requests is essential for production workloads and these should be adapted to your specific use case.

To make this process easier, the chart contains the `resourcesPreset` values, which automatically sets the `resources` section according to different presets. Check these presets in [the bitnami/common chart](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15). However, in production workloads using `resourcesPreset` is discouraged as it may not fully adapt to your specific needs. Find more information on container resource management in the [official Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).

### Backup and restore

To back up and restore Helm chart deployments on Kubernetes, you need to back up the persistent volumes from the source deployment and attach them to a new deployment using [Velero](https://velero.io/), a Kubernetes backup/restore tool. Find the instructions for using Velero in [this guide](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-backup-restore-deployments-velero-index.html).

### Prometheus metrics

This chart can be integrated with Prometheus by setting `metrics.enabled` to true. This will expose the kube-arangodb native Prometheus endpoint in both the containers and services. The services will also have the necessary annotations to be automatically scraped by Prometheus.

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

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values (also the one inside the `webhooks` section).

### Sidecars

If additional containers are needed in the same pod as kube-arangodb (such as additional metrics or logging exporters), they can be defined using the `sidecars` parameter:

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

### Ingress

This chart provides support for Ingress resources. If you have an ingress controller installed on your cluster, such as [nginx-ingress-controller](https://github.com/bitnami/charts/tree/main/bitnami/nginx-ingress-controller) or [contour](https://github.com/bitnami/charts/tree/main/bitnami/contour) you can utilize the ingress controller to serve your application.To enable Ingress integration, set `ingress.enabled` to `true`.

The most common scenario is to have one host name mapped to the deployment. In this case, the `ingress.hostname` property can be used to set the host name. The `ingress.tls` parameter can be used to add the TLS configuration for this host.

However, it is also possible to have more than one host. To facilitate this, the `ingress.extraHosts` parameter (if available) can be set with the host names specified as an array. The `ingress.extraTLS` parameter (if available) can also be used to add the TLS configuration for extra hosts.

> NOTE: For each host specified in the `ingress.extraHosts` parameter, it is necessary to set a name, path, and any annotations that the Ingress controller should know about. Not all annotations are supported by all Ingress controllers, but [this annotation reference document](https://github.com/kubernetes/ingress-nginx/blob/master/docs/user-guide/nginx-configuration/annotations.md) lists the annotations supported by many popular Ingress controllers.

Adding the TLS parameter (where available) will cause the chart to generate HTTPS URLs, and the  application will be available on port 443. The actual TLS secrets do not have to be generated by this chart. However, if TLS is enabled, the Ingress record will not work until the TLS secret exists.

[Learn more about Ingress controllers](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/).

### Deploying extra resources

Apart from the Operator, you may want to deploy ArangoDeployment objects.  For covering this case, the chart allows adding the full specification of other objects using the `extraDeploy` parameter. The following example would creates an ArangoDB Cluster:

```yaml
extraDeploy:
- apiVersion: "database.arangodb.com/v1"
  kind: "ArangoDeployment"
  metadata:
    name: "example-arangodb-cluster"
  spec:
    mode: Cluster
```

Check the [ArangoDB Kubernetes Operator official documentation](https://arangodb.github.io/kube-arangodb/) for the list of available objects.

### Pod affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, use one of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters (also the one inside the `webhooks` section).

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

| Name                                                | Description                                                                                                                                                                                                           | Value                           |
| --------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------- |
| `kubeVersion`                                       | Override Kubernetes version                                                                                                                                                                                           | `""`                            |
| `apiVersions`                                       | Override Kubernetes API versions reported by .Capabilities                                                                                                                                                            | `[]`                            |
| `nameOverride`                                      | String to partially override common.names.name                                                                                                                                                                        | `""`                            |
| `fullnameOverride`                                  | String to fully override common.names.fullname                                                                                                                                                                        | `""`                            |
| `namespaceOverride`                                 | String to fully override common.names.namespace                                                                                                                                                                       | `""`                            |
| `commonLabels`                                      | Labels to add to all deployed objects                                                                                                                                                                                 | `{}`                            |
| `commonAnnotations`                                 | Annotations to add to all deployed objects                                                                                                                                                                            | `{}`                            |
| `clusterDomain`                                     | Kubernetes cluster domain name                                                                                                                                                                                        | `cluster.local`                 |
| `extraDeploy`                                       | Array of extra objects to deploy with the release                                                                                                                                                                     | `[]`                            |
| `diagnosticMode.enabled`                            | Enable diagnostic mode (all probes will be disabled and the command will be overridden)                                                                                                                               | `false`                         |
| `diagnosticMode.command`                            | Command to override all containers in the deployment                                                                                                                                                                  | `["sleep"]`                     |
| `diagnosticMode.args`                               | Args to override all containers in the deployment                                                                                                                                                                     | `["infinity"]`                  |
| `image.registry`                                    | kube-arangodb Operator image registry                                                                                                                                                                                 | `REGISTRY_NAME`                 |
| `image.repository`                                  | kube-arangodb Operator image repository                                                                                                                                                                               | `REPOSITORY_NAME/kube-arangodb` |
| `image.digest`                                      | kube-arangodb Operator image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag image tag (immutable tags are recommended)                                                     | `""`                            |
| `image.pullPolicy`                                  | kube-arangodb Operator image pull policy                                                                                                                                                                              | `IfNotPresent`                  |
| `image.pullSecrets`                                 | kube-arangodb Operator image pull secrets                                                                                                                                                                             | `[]`                            |
| `image.debug`                                       | Enable kube-arangodb Operator image debug mode                                                                                                                                                                        | `false`                         |
| `arangodbImage.registry`                            | ArangoDB image registry                                                                                                                                                                                               | `REGISTRY_NAME`                 |
| `arangodbImage.repository`                          | ArangoDB image repository                                                                                                                                                                                             | `REPOSITORY_NAME/arangodb`      |
| `arangodbImage.digest`                              | ArangoDB image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                              | `""`                            |
| `replicaCount`                                      | Number of kube-arangodb Operator replicas to deploy                                                                                                                                                                   | `1`                             |
| `containerPorts.server`                             | kube-arangodb Operator server container port                                                                                                                                                                          | `8528`                          |
| `containerPorts.apiHttp`                            | kube-arangodb Operator API HTTP container port                                                                                                                                                                        | `8628`                          |
| `containerPorts.apiGrpc`                            | kube-arangodb Operator API GRPC container port                                                                                                                                                                        | `8728`                          |
| `livenessProbe.enabled`                             | Enable livenessProbe on kube-arangodb Operator containers                                                                                                                                                             | `true`                          |
| `livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                               | `5`                             |
| `livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                      | `10`                            |
| `livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                     | `5`                             |
| `livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                                   | `5`                             |
| `livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                                   | `1`                             |
| `readinessProbe.enabled`                            | Enable readinessProbe on kube-arangodb Operator containers                                                                                                                                                            | `true`                          |
| `readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                              | `5`                             |
| `readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                     | `10`                            |
| `readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                    | `5`                             |
| `readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                                  | `5`                             |
| `readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                                  | `1`                             |
| `startupProbe.enabled`                              | Enable startupProbe on kube-arangodb Operator containers                                                                                                                                                              | `false`                         |
| `startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                                | `5`                             |
| `startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                       | `10`                            |
| `startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                      | `5`                             |
| `startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                    | `5`                             |
| `startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                    | `1`                             |
| `customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                                                                                                                   | `{}`                            |
| `customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                                                                                                                                  | `{}`                            |
| `customStartupProbe`                                | Custom startupProbe that overrides the default one                                                                                                                                                                    | `{}`                            |
| `scope`                                             | Define namespace scope: Allowed values: legacy, namespaced                                                                                                                                                            | `legacy`                        |
| `allowChaos`                                        | Allow chaows in deployments                                                                                                                                                                                           | `false`                         |
| `enableAPI`                                         | Enable operator API endpoints                                                                                                                                                                                         | `true`                          |
| `enableCRDManagement`                               | Enable CRD Management by the operator                                                                                                                                                                                 | `true`                          |
| `extraArgs`                                         | Add extra arguments to the default command                                                                                                                                                                            | `[]`                            |
| `auth.username`                                     | Server admin username                                                                                                                                                                                                 | `user`                          |
| `auth.password`                                     | Server admin password (auto-generated if not set)                                                                                                                                                                     | `""`                            |
| `auth.existingSecret`                               | Name of a secret containing the admin credentials                                                                                                                                                                     | `""`                            |
| `features.deployment`                               | Enable deployment operator                                                                                                                                                                                            | `true`                          |
| `features.deploymentReplications`                   | Enable deployment-replicator operator                                                                                                                                                                                 | `true`                          |
| `features.storage`                                  | Enable storage operator                                                                                                                                                                                               | `false`                         |
| `features.backup`                                   | Enable backup operator                                                                                                                                                                                                | `false`                         |
| `features.apps`                                     | Enable apps operator                                                                                                                                                                                                  | `false`                         |
| `features.k8sToK8sClusterSync`                      | Enable Kubernetes to Kubernetes Sync operator                                                                                                                                                                         | `false`                         |
| `features.ml`                                       | Enable ML operator                                                                                                                                                                                                    | `false`                         |
| `features.analytics`                                | Enable analytics operator                                                                                                                                                                                             | `false`                         |
| `features.networking`                               | Enable networking operator                                                                                                                                                                                            | `true`                          |
| `features.scheduler`                                | Enable scheduler operator                                                                                                                                                                                             | `true`                          |
| `features.platform`                                 | Enable platform operator                                                                                                                                                                                              | `true`                          |
| `deploymentFeatures.ephemeralVolumes`               | Allow readOnlyRootFilesystem in the ArangoDB deployments                                                                                                                                                              | `true`                          |
| `deploymentFeatures.securedContainers`              | Deploy ArangoDB as non root                                                                                                                                                                                           | `true`                          |
| `resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if `resources` is set (`resources` is recommended for production). | `nano`                          |
| `resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                     | `{}`                            |
| `podSecurityContext.enabled`                        | Enabled kube-arangodb Operator pods' Security Context                                                                                                                                                                 | `true`                          |
| `podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                    | `Always`                        |
| `podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                        | `[]`                            |
| `podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                           | `[]`                            |
| `podSecurityContext.fsGroup`                        | Set kube-arangodb Operator pod's Security Context fsGroup                                                                                                                                                             | `1001`                          |
| `containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                                                                                                                                  | `true`                          |
| `containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                      | `{}`                            |
| `containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                                                                                                            | `1001`                          |
| `containerSecurityContext.runAsGroup`               | Set containers' Security Context runAsGroup                                                                                                                                                                           | `1001`                          |
| `containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                                                                                                                         | `true`                          |
| `containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                                                                                                                           | `false`                         |
| `containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                               | `true`                          |
| `containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                                                                                                             | `false`                         |
| `containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                    | `["ALL"]`                       |
| `containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                      | `RuntimeDefault`                |
| `command`                                           | Override default container command (useful when using custom images)                                                                                                                                                  | `[]`                            |
| `args`                                              | Override default container args (useful when using custom images)                                                                                                                                                     | `[]`                            |
| `automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                    | `true`                          |
| `hostAliases`                                       | kube-arangodb Operator pods host aliases                                                                                                                                                                              | `[]`                            |
| `podLabels`                                         | Extra labels for kube-arangodb Operator pods                                                                                                                                                                          | `{}`                            |
| `podAnnotations`                                    | Annotations for kube-arangodb Operator pods                                                                                                                                                                           | `{}`                            |
| `podAffinityPreset`                                 | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                   | `""`                            |
| `podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                              | `soft`                          |
| `pdb.create`                                        | Enable/disable a Pod Disruption Budget creation                                                                                                                                                                       | `true`                          |
| `pdb.minAvailable`                                  | Minimum number/percentage of pods that should remain scheduled                                                                                                                                                        | `""`                            |
| `pdb.maxUnavailable`                                | Maximum number/percentage of pods that may be made unavailable                                                                                                                                                        | `""`                            |
| `nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                             | `""`                            |
| `nodeAffinityPreset.key`                            | Node label key to match. Ignored if `affinity` is set                                                                                                                                                                 | `""`                            |
| `nodeAffinityPreset.values`                         | Node label values to match. Ignored if `affinity` is set                                                                                                                                                              | `[]`                            |
| `affinity`                                          | Affinity for kube-arangodb Operator pods assignment                                                                                                                                                                   | `{}`                            |
| `nodeSelector`                                      | Node labels for kube-arangodb Operator pods assignment                                                                                                                                                                | `{}`                            |
| `tolerations`                                       | Tolerations for kube-arangodb Operator pods assignment                                                                                                                                                                | `[]`                            |
| `updateStrategy.type`                               | kube-arangodb Operator statefulset strategy type                                                                                                                                                                      | `RollingUpdate`                 |
| `priorityClassName`                                 | kube-arangodb Operator pods' priorityClassName                                                                                                                                                                        | `""`                            |
| `topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template                                                                                              | `[]`                            |
| `schedulerName`                                     | Name of the k8s scheduler (other than default) for kube-arangodb Operator pods                                                                                                                                        | `""`                            |
| `terminationGracePeriodSeconds`                     | Seconds Redmine pod needs to terminate gracefully                                                                                                                                                                     | `""`                            |
| `lifecycleHooks`                                    | for the kube-arangodb Operator container(s) to automate configuration before or after startup                                                                                                                         | `{}`                            |
| `extraEnvVars`                                      | Array with extra environment variables to add to kube-arangodb Operator nodes                                                                                                                                         | `[]`                            |
| `extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for kube-arangodb Operator nodes                                                                                                                                 | `""`                            |
| `extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for kube-arangodb Operator nodes                                                                                                                                    | `""`                            |
| `extraVolumes`                                      | Optionally specify extra list of additional volumes for the kube-arangodb Operator pod(s)                                                                                                                             | `[]`                            |
| `extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the kube-arangodb Operator container(s)                                                                                                                  | `[]`                            |
| `sidecars`                                          | Add additional sidecar containers to the kube-arangodb Operator pod(s)                                                                                                                                                | `[]`                            |
| `initContainers`                                    | Add additional init containers to the kube-arangodb Operator pod(s)                                                                                                                                                   | `[]`                            |
| `autoscaling.vpa.enabled`                           | Enable VPA                                                                                                                                                                                                            | `false`                         |
| `autoscaling.vpa.annotations`                       | Annotations for VPA resource                                                                                                                                                                                          | `{}`                            |
| `autoscaling.vpa.controlledResources`               | VPA List of resources that the vertical pod autoscaler can control. Defaults to cpu and memory                                                                                                                        | `[]`                            |
| `autoscaling.vpa.maxAllowed`                        | VPA Max allowed resources for the pod                                                                                                                                                                                 | `{}`                            |
| `autoscaling.vpa.minAllowed`                        | VPA Min allowed resources for the pod                                                                                                                                                                                 | `{}`                            |
| `autoscaling.vpa.updatePolicy.updateMode`           | Autoscaling update policy Specifies whether recommended updates are applied when a Pod is started and whether recommended updates are applied during the life of a Pod                                                | `Auto`                          |
| `autoscaling.hpa.enabled`                           | Enable autoscaling for operator                                                                                                                                                                                       | `false`                         |
| `autoscaling.hpa.minReplicas`                       | Minimum number of operator replicas                                                                                                                                                                                   | `""`                            |
| `autoscaling.hpa.maxReplicas`                       | Maximum number of operator replicas                                                                                                                                                                                   | `""`                            |
| `autoscaling.hpa.targetCPU`                         | Target CPU utilization percentage                                                                                                                                                                                     | `""`                            |
| `autoscaling.hpa.targetMemory`                      | Target Memory utilization percentage                                                                                                                                                                                  | `""`                            |

### Traffic Exposure Parameters

| Name                                    | Description                                                                                                                      | Value                    |
| --------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `service.type`                          | kube-arangodb Operator service type                                                                                              | `LoadBalancer`           |
| `service.ports.server`                  | kube-arangodb Operator service server port                                                                                       | `443`                    |
| `service.ports.apiHttp`                 | kube-arangodb Operator service API HTTP port                                                                                     | `8628`                   |
| `service.ports.apiGrpc`                 | kube-arangodb Operator service API GRPC port                                                                                     | `8728`                   |
| `service.nodePorts.server`              | Node port for the server                                                                                                         | `""`                     |
| `service.nodePorts.apiHttp`             | Node port for the API HTTP                                                                                                       | `""`                     |
| `service.nodePorts.apiGrpc`             | Node port for the API GRPC                                                                                                       | `""`                     |
| `service.clusterIP`                     | kube-arangodb Operator service Cluster IP                                                                                        | `""`                     |
| `service.loadBalancerIP`                | kube-arangodb Operator service Load Balancer IP                                                                                  | `""`                     |
| `service.loadBalancerSourceRanges`      | kube-arangodb Operator service Load Balancer sources                                                                             | `[]`                     |
| `service.externalTrafficPolicy`         | kube-arangodb Operator service external traffic policy                                                                           | `Cluster`                |
| `service.labels`                        | Labels for the service                                                                                                           | `{}`                     |
| `service.annotations`                   | Additional custom annotations for kube-arangodb Operator service                                                                 | `{}`                     |
| `service.extraPorts`                    | Extra ports to expose in kube-arangodb Operator service (normally used with the `sidecars` value)                                | `[]`                     |
| `service.sessionAffinity`               | Control where web requests go, to the same pod or round-robin                                                                    | `None`                   |
| `service.sessionAffinityConfig`         | Additional settings for the sessionAffinity                                                                                      | `{}`                     |
| `ingress.enabled`                       | Enable ingress record generation for neo4j                                                                                       | `false`                  |
| `ingress.pathType`                      | Ingress path type                                                                                                                | `ImplementationSpecific` |
| `ingress.apiVersion`                    | Force Ingress API version (automatically detected if not set)                                                                    | `""`                     |
| `ingress.hostname`                      | Default host for the ingress record                                                                                              | `kube-arangodb.local`    |
| `ingress.ingressClassName`              | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                    | `""`                     |
| `ingress.path`                          | Default path for the ingress record                                                                                              | `/`                      |
| `ingress.annotations`                   | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                     |
| `ingress.tls`                           | Enable TLS configuration for the host defined at `ingress.hostname` parameter                                                    | `false`                  |
| `ingress.selfSigned`                    | Create a TLS secret for this ingress record using self-signed certificates generated by Helm                                     | `false`                  |
| `ingress.extraHosts`                    | An array with additional hostname(s) to be covered with the ingress record                                                       | `[]`                     |
| `ingress.extraPaths`                    | An array with additional arbitrary paths that may need to be added to the ingress under the main host                            | `[]`                     |
| `ingress.extraTls`                      | TLS configuration for additional hostname(s) to be covered with this ingress record                                              | `[]`                     |
| `ingress.secrets`                       | Custom TLS certificates as secrets                                                                                               | `[]`                     |
| `ingress.extraRules`                    | Additional rules to be covered with this ingress record                                                                          | `[]`                     |
| `networkPolicy.enabled`                 | Specifies whether a NetworkPolicy should be created                                                                              | `true`                   |
| `networkPolicy.kubeAPIServerPorts`      | List of possible endpoints to kube-apiserver (limit to your cluster settings to increase security)                               | `[]`                     |
| `networkPolicy.allowExternal`           | Don't require server label for connections                                                                                       | `true`                   |
| `networkPolicy.allowExternalEgress`     | Allow the pod to access any range of port and all destinations.                                                                  | `true`                   |
| `networkPolicy.extraIngress`            | Add extra ingress rules to the NetworkPolicy                                                                                     | `[]`                     |
| `networkPolicy.extraEgress`             | Add extra ingress rules to the NetworkPolicy                                                                                     | `[]`                     |
| `networkPolicy.ingressNSMatchLabels`    | Labels to match to allow traffic from other namespaces                                                                           | `{}`                     |
| `networkPolicy.ingressNSPodMatchLabels` | Pod labels to match to allow traffic from other namespaces                                                                       | `{}`                     |

### Webhook parameters

| Name                                                         | Description                                                                                                                                                                                                                             | Value            |
| ------------------------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| `webhooks.enabled`                                           | Add the webhook sidecar to the operator deployment                                                                                                                                                                                      | `true`           |
| `webhooks.validating.create`                                 | Create ValidatingWebhookConfiguration                                                                                                                                                                                                   | `true`           |
| `webhooks.mutating.create`                                   | Create MutatingWebhookConfiguration                                                                                                                                                                                                     | `true`           |
| `webhooks.command`                                           | Override default webhook container command (useful when using custom images)                                                                                                                                                            | `[]`             |
| `webhooks.args`                                              | Override default webhook container args (useful when using custom images)                                                                                                                                                               | `[]`             |
| `webhooks.extraArgs`                                         | Add extra arguments to the default command                                                                                                                                                                                              | `[]`             |
| `webhooks.lifecycleHooks`                                    | for the webhook container(s) to automate configuration before or after startup                                                                                                                                                          | `{}`             |
| `webhooks.extraEnvVars`                                      | Array with extra environment variables to add to webhook nodes                                                                                                                                                                          | `[]`             |
| `webhooks.extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for webhook nodes                                                                                                                                                                  | `""`             |
| `webhooks.extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for webhook nodes                                                                                                                                                                     | `""`             |
| `webhooks.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the webhook container(s)                                                                                                                                                   | `[]`             |
| `webhooks.containerPorts.webhook`                            | webhook container port                                                                                                                                                                                                                  | `8828`           |
| `webhooks.containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                                                                                                                                                    | `true`           |
| `webhooks.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                                        | `{}`             |
| `webhooks.containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                                                                                                                              | `1001`           |
| `webhooks.containerSecurityContext.runAsGroup`               | Set containers' Security Context runAsGroup                                                                                                                                                                                             | `1001`           |
| `webhooks.containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                                                                                                                                           | `true`           |
| `webhooks.containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                                                                                                                                             | `false`          |
| `webhooks.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                                                 | `true`           |
| `webhooks.containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                                                                                                                               | `false`          |
| `webhooks.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                                      | `["ALL"]`        |
| `webhooks.containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                                        | `RuntimeDefault` |
| `webhooks.livenessProbe.enabled`                             | Enable livenessProbe on webhook containers                                                                                                                                                                                              | `true`           |
| `webhooks.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                                                 | `5`              |
| `webhooks.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                                        | `10`             |
| `webhooks.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                                       | `5`              |
| `webhooks.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                                                     | `5`              |
| `webhooks.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                                                     | `1`              |
| `webhooks.readinessProbe.enabled`                            | Enable readinessProbe on webhook containers                                                                                                                                                                                             | `true`           |
| `webhooks.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                                                | `5`              |
| `webhooks.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                                       | `10`             |
| `webhooks.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                                      | `5`              |
| `webhooks.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                                                    | `5`              |
| `webhooks.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                                                    | `1`              |
| `webhooks.startupProbe.enabled`                              | Enable startupProbe on webhook containers                                                                                                                                                                                               | `false`          |
| `webhooks.startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                                                  | `5`              |
| `webhooks.startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                                         | `10`             |
| `webhooks.startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                                        | `5`              |
| `webhooks.startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                                      | `5`              |
| `webhooks.startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                                      | `1`              |
| `webhooks.customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                                                                                                                                     | `{}`             |
| `webhooks.customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                                                                                                                                                    | `{}`             |
| `webhooks.customStartupProbe`                                | Custom startupProbe that overrides the default one                                                                                                                                                                                      | `{}`             |
| `webhooks.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if `webhooks.resources` is set (`webhooks.resources` is recommended for production). | `nano`           |
| `webhooks.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                       | `{}`             |

### Webhook Traffic Exposure Parameters

| Name                             | Description                                                      | Value |
| -------------------------------- | ---------------------------------------------------------------- | ----- |
| `webhooks.service.ports.webhook` | kube-arangodb Operator service server port                       | `443` |
| `webhooks.service.clusterIP`     | kube-arangodb Operator service Cluster IP                        | `""`  |
| `webhooks.service.labels`        | Labels for the service                                           | `{}`  |
| `webhooks.service.annotations`   | Additional custom annotations for kube-arangodb Operator service | `{}`  |

### RBAC Parameters

| Name                                                   | Description                                                         | Value   |
| ------------------------------------------------------ | ------------------------------------------------------------------- | ------- |
| `rbac.create`                                          | Specifies whether RBAC resources should be created                  | `true`  |
| `rbac.extensions.acs`                                  | Enable additional RBAC settings for Arango Cluster Synchronizations | `true`  |
| `rbac.extensions.at`                                   | Enable additional RBAC settings for Arango Tasks                    | `true`  |
| `rbac.extensions.debug`                                | Enable additional RBAC settings for Debugging                       | `false` |
| `rbac.extensions.monitoring`                           | Enable additional RBAC settings for ServiceMonitors                 | `true`  |
| `serviceAccount.operator.create`                       | Specifies whether a ServiceAccount should be created                | `true`  |
| `serviceAccount.operator.name`                         | The name of the ServiceAccount to use.                              | `""`    |
| `serviceAccount.operator.annotations`                  | Additional Service Account annotations (evaluated as a template)    | `{}`    |
| `serviceAccount.operator.automountServiceAccountToken` | Automount service account token for the server service account      | `false` |
| `serviceAccount.job.create`                            | Specifies whether a ServiceAccount should be created                | `true`  |
| `serviceAccount.job.name`                              | The name of the ServiceAccount to use.                              | `""`    |
| `serviceAccount.job.annotations`                       | Additional Service Account annotations (evaluated as a template)    | `{}`    |
| `serviceAccount.job.automountServiceAccountToken`      | Automount service account token for the server service account      | `false` |

### Metrics Parameters

| Name                                       | Description                                                                                            | Value   |
| ------------------------------------------ | ------------------------------------------------------------------------------------------------------ | ------- |
| `metrics.enabled`                          | Enable the export of Prometheus metrics                                                                | `false` |
| `metrics.annotations`                      | Annotations for the service                                                                            | `{}`    |
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

The above parameters map to the env variables defined in [bitnami/kube-arangodb](https://github.com/bitnami/containers/tree/main/bitnami/kube-arangodb). For more information please refer to the [bitnami/kube-arangodb](https://github.com/bitnami/containers/tree/main/bitnami/kube-arangodb) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
  --set enableAPI=true \
    REGISTRY_NAME/REPOSITORY_NAME/kube-arangodb
```

The above command enables the kube-arangodb API Server.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml REGISTRY_NAME/REPOSITORY_NAME/kube-arangodb
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.
> **Tip**: You can use the default [values.yaml](https://github.com/bitnami/charts/tree/main/bitnami/kube-arangodb/values.yaml)

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