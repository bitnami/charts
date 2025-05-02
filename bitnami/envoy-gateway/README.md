<!--- app-name: Envoy Gateway -->

# Bitnami package for Envoy Gateway

Envoy Gateway simplifies traffic management by extending Envoy Proxy's features, offering Kubernetes Gateway API integration for secure, scalable, and observable application routing.

[Overview of Envoy Gateway](https://gateway.envoyproxy.io/)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/envoy-gateway
```

Looking to use Envoy Gateway in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the commercial edition of the Bitnami catalog.

## Introduction

This chart bootstraps a [Envoy Gateway](https://github.com/bitnami/containers/tree/main/bitnami/envoy-gateway) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release REGISTRY_NAME/REPOSITORY_NAME/envoy-gateway
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The command deploys Envoy Gateway on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Configuration and installation details

### Operator configuration

The Bitnami Envoy Gateway chart allows [configuring the operator](https://gateway.envoyproxy.io/docs/api/extension_types/#envoygateway) using ConfigMaps. This is done using the `overrideConfiguration` parameter, which merges the provided settings with the default configuration. In the example below we add extra configuration parameters to the operator:

```yaml
overrideConfiguration:
  admin:
    enableDumpConfig: false
```

It is also possible to use an existing ConfigMap using the `existingConfigMap` parameter (note that this is not compatible with the `overrideConfiguration` parameter).

### Certificate Generation Job

The chart provides a certificate generation job, which uses the Envoy Operator `certgen` command provide to create all the necessary TLS secrets. This is enabled by setting `certgen.enabled=true` and all the Job settings can be configured under the `certgen` section.

### Resource requests and limits

Bitnami charts allow setting resource requests and limits for all containers inside the chart deployment. These are inside the `resources` value (check parameter table). Setting requests is essential for production workloads and these should be adapted to your specific use case.

To make this process easier, the chart contains the `resourcesPreset` values, which automatically sets the `resources` section according to different presets. Check these presets in [the bitnami/common chart](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15). However, in production workloads using `resourcesPreset` is discouraged as it may not fully adapt to your specific needs. Find more information on container resource management in the [official Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).

### Prometheus metrics

This chart can be integrated with Prometheus by setting `metrics.enabled` to true. This will expose the envoy-gateway native Prometheus endpoint in both the container and service. It will have the necessary annotations to be automatically scraped by Prometheus.

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

If additional containers are needed in the same pod as envoy-gateway (such as additional metrics or logging exporters), they can be defined using the `sidecars` parameter:

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

Apart from the Operator, you may want to deploy Gateway, HTTPRoutes or other operator objects.  For covering this case, the chart allows adding the full specification of other objects using the `extraDeploy` parameter. The following example deploys a GatewayClasse, a Gateway, HTTPRoutes and a service (adapted from the upstream [quickstart](https://gateway.envoyproxy.io/latest/tasks/quickstart/) documentation):

```yaml
extraDeploy:
- apiVersion: gateway.networking.k8s.io/v1
  kind: GatewayClass
  metadata:
    name: eg
  spec:
    controllerName: gateway.envoyproxy.io/gatewayclass-controller
- apiVersion: gateway.networking.k8s.io/v1
  kind: Gateway
  metadata:
    name: eg
  spec:
    gatewayClassName: eg
    listeners:
      - name: http
        protocol: HTTP
        port: 80
- apiVersion: v1
  kind: ServiceAccount
  metadata:
    name: backend
- apiVersion: v1
  kind: Service
  metadata:
    name: backend
    labels:
      app: backend
      service: backend
  spec:
    ports:
      - name: http
        port: 80
        targetPort: 8080
    selector:
      app: backend
- apiVersion: apps/v1
  kind: Deployment
  metadata:
    name: backend
  spec:
    replicas: 1
    selector:
      matchLabels:
        app: backend
        version: v1
    template:
      metadata:
        labels:
          app: backend
          version: v1
      spec:
        serviceAccountName: backend
        containers:
          - image: bitnami/nginx
            imagePullPolicy: Always
            name: backend
            ports:
              - containerPort: 8080
- apiVersion: gateway.networking.k8s.io/v1
  kind: HTTPRoute
  metadata:
    name: backend
  spec:
    parentRefs:
      - name: eg
    hostnames:
      - "www.example.com"
    rules:
      - backendRefs:
          - group: ""
            kind: Service
            name: backend
            port: 80
            weight: 1
        matches:
          - path:
              type: PathPrefix
              value: /
```

Check the [Envoy Gateway official documentation](https://envoy-gateway.io/documentation/current/) for the list of available objects.

### Pod affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, use one of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

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

| Name                     | Description                                                                             | Value           |
| ------------------------ | --------------------------------------------------------------------------------------- | --------------- |
| `kubeVersion`            | Override Kubernetes version                                                             | `""`            |
| `apiVersions`            | Override Kubernetes API versions reported by .Capabilities                              | `[]`            |
| `nameOverride`           | String to partially override common.names.name                                          | `""`            |
| `fullnameOverride`       | String to fully override common.names.fullname                                          | `""`            |
| `namespaceOverride`      | String to fully override common.names.namespace                                         | `""`            |
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden) | `false`         |
| `diagnosticMode.command` | Command to override all containers in the deployment                                    | `["sleep"]`     |
| `diagnosticMode.args`    | Args to override all containers in the deployment                                       | `["infinity"]`  |
| `commonLabels`           | Labels to add to all deployed objects                                                   | `{}`            |
| `commonAnnotations`      | Annotations to add to all deployed objects                                              | `{}`            |
| `clusterDomain`          | Kubernetes cluster domain name                                                          | `cluster.local` |
| `extraDeploy`            | Array of extra objects to deploy with the release                                       | `[]`            |

### Envoy Gateway parameters

| Name                                                | Description                                                                                                                                                                                                       | Value                                           |
| --------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------- |
| `image.registry`                                    | Envoy Gateway image registry                                                                                                                                                                                      | `REGISTRY_NAME`                                 |
| `image.repository`                                  | Envoy Gateway image repository                                                                                                                                                                                    | `REPOSITORY_NAME/envoy-gateway`                 |
| `image.digest`                                      | Envoy Gateway image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag image tag (immutable tags are recommended)                                                          | `""`                                            |
| `image.pullPolicy`                                  | Envoy Gateway image pull policy                                                                                                                                                                                   | `IfNotPresent`                                  |
| `image.pullSecrets`                                 | Envoy Gateway image pull secrets                                                                                                                                                                                  | `[]`                                            |
| `ratelimitImage.registry`                           | Envoy Rate Limit image registry                                                                                                                                                                                   | `REGISTRY_NAME`                                 |
| `ratelimitImage.repository`                         | Envoy Rate Limit image repository                                                                                                                                                                                 | `REPOSITORY_NAME/postgresql`                    |
| `ratelimitImage.digest`                             | Envoy Rate Limit image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                  | `""`                                            |
| `ratelimitImage.pullPolicy`                         | Rate Limit image pull policy                                                                                                                                                                                      | `IfNotPresent`                                  |
| `envoyImage.registry`                               | Envoy image registry                                                                                                                                                                                              | `REGISTRY_NAME`                                 |
| `envoyImage.repository`                             | Envoy image repository                                                                                                                                                                                            | `REPOSITORY_NAME/postgresql`                    |
| `envoyImage.digest`                                 | Envoy image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                             | `""`                                            |
| `replicaCount`                                      | Number of Envoy Gateway replicas to deploy                                                                                                                                                                        | `1`                                             |
| `livenessProbe.enabled`                             | Enable livenessProbe on Envoy Gateway containers                                                                                                                                                                  | `true`                                          |
| `livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                           | `5`                                             |
| `livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                  | `10`                                            |
| `livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                 | `5`                                             |
| `livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                               | `5`                                             |
| `livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                               | `1`                                             |
| `readinessProbe.enabled`                            | Enable readinessProbe on Envoy Gateway containers                                                                                                                                                                 | `true`                                          |
| `readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                          | `5`                                             |
| `readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                 | `10`                                            |
| `readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                | `5`                                             |
| `readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                              | `5`                                             |
| `readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                              | `1`                                             |
| `startupProbe.enabled`                              | Enable startupProbe on Envoy Gateway containers                                                                                                                                                                   | `false`                                         |
| `startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                            | `5`                                             |
| `startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                   | `10`                                            |
| `startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                  | `5`                                             |
| `startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                | `5`                                             |
| `startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                | `1`                                             |
| `customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                                                                                                               | `{}`                                            |
| `customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                                                                                                                              | `{}`                                            |
| `customStartupProbe`                                | Custom startupProbe that overrides the default one                                                                                                                                                                | `{}`                                            |
| `watchAllNamespaces`                                | Watch for envoy-gateway resources in all namespaces                                                                                                                                                               | `true`                                          |
| `watchNamespaces`                                   | Watch for envoy-gateway resources in the given namespaces                                                                                                                                                         | `[]`                                            |
| `logLevel`                                          | Set logging level                                                                                                                                                                                                 | `info`                                          |
| `exposeAdmin`                                       | Expose admin port                                                                                                                                                                                                 | `false`                                         |
| `controllerName`                                    | Gateway Controller name                                                                                                                                                                                           | `gateway.envoyproxy.io/gatewayclass-controller` |
| `containerPorts.admin`                              | Container port for the admin interface                                                                                                                                                                            | `19000`                                         |
| `extraContainerPorts`                               | Optionally specify extra list of additional ports for Envoy Gateway container                                                                                                                                     | `[]`                                            |
| `overrideConfiguration`                             | Add configuration settings to a configmap                                                                                                                                                                         | `{}`                                            |
| `existingConfigMap`                                 | Name of a ConfigMap containing the operator configuration                                                                                                                                                         | `""`                                            |
| `existingTLSSecret`                                 | Name of a Secret containing the control plane                                                                                                                                                                     | `""`                                            |
| `resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if resources is set (resources is recommended for production). | `nano`                                          |
| `resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                 | `{}`                                            |
| `podSecurityContext.enabled`                        | Enabled Envoy Gateway pods' Security Context                                                                                                                                                                      | `true`                                          |
| `podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                | `Always`                                        |
| `podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                    | `[]`                                            |
| `podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                       | `[]`                                            |
| `podSecurityContext.fsGroup`                        | Set Envoy Gateway pod's Security Context fsGroup                                                                                                                                                                  | `1001`                                          |
| `containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                                                                                                                              | `true`                                          |
| `containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                  | `{}`                                            |
| `containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                                                                                                        | `1001`                                          |
| `containerSecurityContext.runAsGroup`               | Set containers' Security Context runAsGroup                                                                                                                                                                       | `1001`                                          |
| `containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                                                                                                                     | `true`                                          |
| `containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                                                                                                                       | `false`                                         |
| `containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                           | `true`                                          |
| `containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                                                                                                         | `false`                                         |
| `containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                | `["ALL"]`                                       |
| `containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                  | `RuntimeDefault`                                |
| `command`                                           | Override default container command (useful when using custom images)                                                                                                                                              | `[]`                                            |
| `args`                                              | Override default container args (useful when using custom images)                                                                                                                                                 | `[]`                                            |
| `automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                | `true`                                          |
| `hostAliases`                                       | Envoy Gateway pods host aliases                                                                                                                                                                                   | `[]`                                            |
| `podLabels`                                         | Extra labels for Envoy Gateway pods                                                                                                                                                                               | `{}`                                            |
| `podAnnotations`                                    | Annotations for Envoy Gateway pods                                                                                                                                                                                | `{}`                                            |
| `podAffinityPreset`                                 | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                               | `""`                                            |
| `podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                          | `soft`                                          |
| `pdb.create`                                        | Enable/disable a Pod Disruption Budget creation                                                                                                                                                                   | `true`                                          |
| `pdb.minAvailable`                                  | Minimum number/percentage of pods that should remain scheduled                                                                                                                                                    | `""`                                            |
| `pdb.maxUnavailable`                                | Maximum number/percentage of pods that may be made unavailable                                                                                                                                                    | `""`                                            |
| `nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                         | `""`                                            |
| `nodeAffinityPreset.key`                            | Node label key to match. Ignored if `affinity` is set                                                                                                                                                             | `""`                                            |
| `nodeAffinityPreset.values`                         | Node label values to match. Ignored if `affinity` is set                                                                                                                                                          | `[]`                                            |
| `affinity`                                          | Affinity for Envoy Gateway pods assignment                                                                                                                                                                        | `{}`                                            |
| `nodeSelector`                                      | Node labels for Envoy Gateway pods assignment                                                                                                                                                                     | `{}`                                            |
| `tolerations`                                       | Tolerations for Envoy Gateway pods assignment                                                                                                                                                                     | `[]`                                            |
| `updateStrategy.type`                               | Envoy Gateway statefulset strategy type                                                                                                                                                                           | `RollingUpdate`                                 |
| `priorityClassName`                                 | Envoy Gateway pods' priorityClassName                                                                                                                                                                             | `""`                                            |
| `topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template                                                                                          | `[]`                                            |
| `schedulerName`                                     | Name of the k8s scheduler (other than default) for Envoy Gateway pods                                                                                                                                             | `""`                                            |
| `terminationGracePeriodSeconds`                     | Seconds Redmine pod needs to terminate gracefully                                                                                                                                                                 | `""`                                            |
| `lifecycleHooks`                                    | for the Envoy Gateway container(s) to automate configuration before or after startup                                                                                                                              | `{}`                                            |
| `extraEnvVars`                                      | Array with extra environment variables to add to Envoy Gateway nodes                                                                                                                                              | `[]`                                            |
| `extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for Envoy Gateway nodes                                                                                                                                      | `""`                                            |
| `extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for Envoy Gateway nodes                                                                                                                                         | `""`                                            |
| `extraVolumes`                                      | Optionally specify extra list of additional volumes for the Envoy Gateway pod(s)                                                                                                                                  | `[]`                                            |
| `extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the Envoy Gateway container(s)                                                                                                                       | `[]`                                            |
| `sidecars`                                          | Add additional sidecar containers to the Envoy Gateway pod(s)                                                                                                                                                     | `[]`                                            |
| `initContainers`                                    | Add additional init containers to the Envoy Gateway pod(s)                                                                                                                                                        | `[]`                                            |
| `autoscaling.vpa.enabled`                           | Enable VPA                                                                                                                                                                                                        | `false`                                         |
| `autoscaling.vpa.annotations`                       | Annotations for VPA resource                                                                                                                                                                                      | `{}`                                            |
| `autoscaling.vpa.controlledResources`               | VPA List of resources that the vertical pod autoscaler can control. Defaults to cpu and memory                                                                                                                    | `[]`                                            |
| `autoscaling.vpa.maxAllowed`                        | VPA Max allowed resources for the pod                                                                                                                                                                             | `{}`                                            |
| `autoscaling.vpa.minAllowed`                        | VPA Min allowed resources for the pod                                                                                                                                                                             | `{}`                                            |
| `autoscaling.vpa.updatePolicy.updateMode`           | Autoscaling update policy Specifies whether recommended updates are applied when a Pod is started and whether recommended updates are applied during the life of a Pod                                            | `Auto`                                          |
| `autoscaling.hpa.enabled`                           | Enable autoscaling for Envoy Gateway                                                                                                                                                                              | `false`                                         |
| `autoscaling.hpa.minReplicas`                       | Minimum number of Envoy Gateway replicas                                                                                                                                                                          | `""`                                            |
| `autoscaling.hpa.maxReplicas`                       | Maximum number of Envoy Gateway replicas                                                                                                                                                                          | `""`                                            |
| `autoscaling.hpa.targetCPU`                         | Target CPU utilization percentage                                                                                                                                                                                 | `""`                                            |
| `autoscaling.hpa.targetMemory`                      | Target Memory utilization percentage                                                                                                                                                                              | `""`                                            |

### Envoy Gateway Traffic Exposure Parameters

| Name                                    | Description                                                                                        | Value       |
| --------------------------------------- | -------------------------------------------------------------------------------------------------- | ----------- |
| `service.type`                          | Envoy Gateway service type                                                                         | `ClusterIP` |
| `service.ports.admin`                   | Envoy Gateway service admin port                                                                   | `19000`     |
| `service.ports.metrics`                 | Envoy Gateway service metrics port                                                                 | `19001`     |
| `service.nodePorts.grpc`                | Node port for grpc                                                                                 | `""`        |
| `service.nodePorts.ratelimit`           | Node port for rate limit                                                                           | `""`        |
| `service.nodePorts.wasm`                | Node port for wasm                                                                                 | `""`        |
| `service.nodePorts.metrics`             | Node port for metrics                                                                              | `""`        |
| `service.nodePorts.admin`               | Node port for admin                                                                                | `""`        |
| `service.clusterIP`                     | Envoy Gateway service Cluster IP                                                                   | `""`        |
| `service.loadBalancerIP`                | Envoy Gateway service Load Balancer IP                                                             | `""`        |
| `service.loadBalancerSourceRanges`      | Envoy Gateway service Load Balancer sources                                                        | `[]`        |
| `service.externalTrafficPolicy`         | Envoy Gateway service external traffic policy                                                      | `Cluster`   |
| `service.labels`                        | Labels for the service                                                                             | `{}`        |
| `service.annotations`                   | Additional custom annotations for Envoy Gateway service                                            | `{}`        |
| `service.extraPorts`                    | Extra ports to expose in Envoy Gateway service (normally used with the `sidecars` value)           | `[]`        |
| `service.sessionAffinity`               | Control where web requests go, to the same pod or round-robin                                      | `None`      |
| `service.sessionAffinityConfig`         | Additional settings for the sessionAffinity                                                        | `{}`        |
| `networkPolicy.enabled`                 | Specifies whether a NetworkPolicy should be created                                                | `true`      |
| `networkPolicy.kubeAPIServerPorts`      | List of possible endpoints to kube-apiserver (limit to your cluster settings to increase security) | `[]`        |
| `networkPolicy.allowExternal`           | Don't require server label for connections                                                         | `true`      |
| `networkPolicy.allowExternalEgress`     | Allow the pod to access any range of port and all destinations.                                    | `true`      |
| `networkPolicy.extraIngress`            | Add extra ingress rules to the NetworkPolicy                                                       | `[]`        |
| `networkPolicy.extraEgress`             | Add extra ingress rules to the NetworkPolicy                                                       | `[]`        |
| `networkPolicy.ingressNSMatchLabels`    | Labels to match to allow traffic from other namespaces                                             | `{}`        |
| `networkPolicy.ingressNSPodMatchLabels` | Pod labels to match to allow traffic from other namespaces                                         | `{}`        |

### Envoy Gateway RBAC Parameters

| Name                                          | Description                                                      | Value   |
| --------------------------------------------- | ---------------------------------------------------------------- | ------- |
| `rbac.create`                                 | Specifies whether RBAC resources should be created               | `true`  |
| `rbac.rules`                                  | Custom RBAC rules to set                                         | `[]`    |
| `serviceAccount.create`                       | Specifies whether a ServiceAccount should be created             | `true`  |
| `serviceAccount.name`                         | The name of the ServiceAccount to use.                           | `""`    |
| `serviceAccount.annotations`                  | Additional Service Account annotations (evaluated as a template) | `{}`    |
| `serviceAccount.automountServiceAccountToken` | Automount service account token for the server service account   | `false` |

### Certificate Job parameters

| Name                                                        | Description                                                                                                                                                                                                                                                | Value            |
| ----------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| `certgen.enabled`                                           | Enables the Certificate Generation init job, which is in charge of initialising the database, admin user credentials, DB upgrade, etc.                                                                                                                     | `true`           |
| `certgen.extraEnvVars`                                      | Array with extra environment variables to add to Certificate Generation init-job containers                                                                                                                                                                | `[]`             |
| `certgen.extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for Certificate Generation init-job containers                                                                                                                                                        | `""`             |
| `certgen.extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for Certificate Generation init-job containers                                                                                                                                                           | `""`             |
| `certgen.extraVolumes`                                      | Optionally specify extra list of additional volumes for the Certificate Generation init-job pods                                                                                                                                                           | `[]`             |
| `certgen.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the Certificate Generation init-job containers                                                                                                                                                | `[]`             |
| `certgen.tolerations`                                       | Tolerations for certgen pods assignment                                                                                                                                                                                                                    | `[]`             |
| `certgen.sidecars`                                          | Add additional sidecar containers to the Certificate Generation init-job pods                                                                                                                                                                              | `[]`             |
| `certgen.initContainers`                                    | Add additional init containers to the Certificate Generation init-job pods                                                                                                                                                                                 | `[]`             |
| `certgen.affinity`                                          | Affinity for certgen pods assignment                                                                                                                                                                                                                       | `{}`             |
| `certgen.nodeSelector`                                      | Node labels for certgen pods assignment                                                                                                                                                                                                                    | `{}`             |
| `certgen.command`                                           | Override default Certificate Generation init-job container command (useful when using custom images)                                                                                                                                                       | `[]`             |
| `certgen.args`                                              | Override default Certificate Generation init-job container args (useful when using custom images)                                                                                                                                                          | `[]`             |
| `certgen.resourcesPreset`                                   | Set Certificate Generation init-job container resources according to one common preset (allowed values: none, nano, small, medium, large, xlarge, 2xlarge). This is ignored if certgen.resources is set (certgen.resources is recommended for production). | `nano`           |
| `certgen.resources`                                         | Set Certificate Generation init-job container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                          | `{}`             |
| `certgen.livenessProbe.enabled`                             | Enable livenessProbe on certgen containers                                                                                                                                                                                                                 | `true`           |
| `certgen.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                                                                    | `5`              |
| `certgen.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                                                           | `10`             |
| `certgen.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                                                          | `5`              |
| `certgen.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                                                                        | `5`              |
| `certgen.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                                                                        | `1`              |
| `certgen.readinessProbe.enabled`                            | Enable readinessProbe on certgen containers                                                                                                                                                                                                                | `true`           |
| `certgen.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                                                                   | `5`              |
| `certgen.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                                                          | `10`             |
| `certgen.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                                                         | `5`              |
| `certgen.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                                                                       | `5`              |
| `certgen.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                                                                       | `1`              |
| `certgen.startupProbe.enabled`                              | Enable startupProbe on certgen containers                                                                                                                                                                                                                  | `false`          |
| `certgen.startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                                                                     | `5`              |
| `certgen.startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                                                            | `10`             |
| `certgen.startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                                                           | `5`              |
| `certgen.startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                                                         | `5`              |
| `certgen.startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                                                         | `1`              |
| `certgen.customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                                                                                                                                                        | `{}`             |
| `certgen.customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                                                                                                                                                                       | `{}`             |
| `certgen.customStartupProbe`                                | Custom startupProbe that overrides the default one                                                                                                                                                                                                         | `{}`             |
| `certgen.podSecurityContext.enabled`                        | Enable Certificate Generation init-job pods' Security Context                                                                                                                                                                                              | `true`           |
| `certgen.podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy for Certificate Generation init-job pods                                                                                                                                                                                | `Always`         |
| `certgen.podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface for Certificate Generation init-job pods                                                                                                                                                                    | `[]`             |
| `certgen.podSecurityContext.supplementalGroups`             | Set filesystem extra groups for Certificate Generation init-job pods                                                                                                                                                                                       | `[]`             |
| `certgen.podSecurityContext.fsGroup`                        | Set fsGroup in Certificate Generation init-job pods' Security Context                                                                                                                                                                                      | `1001`           |
| `certgen.containerSecurityContext.enabled`                  | Enabled Certificate Generation init-job container' Security Context                                                                                                                                                                                        | `true`           |
| `certgen.containerSecurityContext.seLinuxOptions`           | Set SELinux options in Certificate Generation init-job container                                                                                                                                                                                           | `{}`             |
| `certgen.containerSecurityContext.runAsUser`                | Set runAsUser in Certificate Generation init-job container' Security Context                                                                                                                                                                               | `1001`           |
| `certgen.containerSecurityContext.runAsGroup`               | Set runAsGroup in Certificate Generation init-job container' Security Context                                                                                                                                                                              | `1001`           |
| `certgen.containerSecurityContext.runAsNonRoot`             | Set runAsNonRoot in Certificate Generation init-job container' Security Context                                                                                                                                                                            | `true`           |
| `certgen.containerSecurityContext.readOnlyRootFilesystem`   | Set readOnlyRootFilesystem in Certificate Generation init-job container' Security Context                                                                                                                                                                  | `false`          |
| `certgen.containerSecurityContext.privileged`               | Set privileged in Certificate Generation init-job container' Security Context                                                                                                                                                                              | `false`          |
| `certgen.containerSecurityContext.allowPrivilegeEscalation` | Set allowPrivilegeEscalation in Certificate Generation init-job container' Security Context                                                                                                                                                                | `false`          |
| `certgen.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped in Certificate Generation init-job container                                                                                                                                                                            | `["ALL"]`        |
| `certgen.containerSecurityContext.seccompProfile.type`      | Set seccomp profile in Certificate Generation init-job container                                                                                                                                                                                           | `RuntimeDefault` |
| `certgen.backoffLimit`                                      | set backoff limit of the job                                                                                                                                                                                                                               | `10`             |
| `certgen.parallelism`                                       | set parallelism limit of the job                                                                                                                                                                                                                           | `1`              |
| `certgen.completions`                                       | set completions limit of the job                                                                                                                                                                                                                           | `1`              |
| `certgen.automountServiceAccountToken`                      | Mount Service Account token in Certificate Generation init-job pods                                                                                                                                                                                        | `true`           |
| `certgen.hostAliases`                                       | Certificate Generation init-job pods host aliases                                                                                                                                                                                                          | `[]`             |
| `certgen.annotations`                                       | Annotations for Certificate Generation object                                                                                                                                                                                                              | `{}`             |
| `certgen.labels`                                            | Extra labels for Certificate Generation                                                                                                                                                                                                                    | `{}`             |
| `certgen.podLabels`                                         | Extra labels for Certificate Generation init-job pods                                                                                                                                                                                                      | `{}`             |
| `certgen.podAnnotations`                                    | Annotations for Certificate Generation init-job pods                                                                                                                                                                                                       | `{}`             |
| `certgen.serviceAccount.create`                             | Specifies whether a ServiceAccount should be created                                                                                                                                                                                                       | `true`           |
| `certgen.serviceAccount.name`                               | The name of the ServiceAccount to use.                                                                                                                                                                                                                     | `""`             |
| `certgen.serviceAccount.annotations`                        | Additional Service Account annotations (evaluated as a template)                                                                                                                                                                                           | `{}`             |
| `certgen.serviceAccount.automountServiceAccountToken`       | Automount service account token for the server service account                                                                                                                                                                                             | `false`          |
| `certgen.networkPolicy.enabled`                             | Specifies whether a NetworkPolicy should be created                                                                                                                                                                                                        | `true`           |
| `certgen.networkPolicy.kubeAPIServerPorts`                  | List of possible endpoints to kube-apiserver (limit to your cluster settings to increase security)                                                                                                                                                         | `[]`             |
| `certgen.networkPolicy.allowExternal`                       | Don't require server label for connections                                                                                                                                                                                                                 | `true`           |
| `certgen.networkPolicy.allowExternalEgress`                 | Allow the pod to access any range of port and all destinations.                                                                                                                                                                                            | `true`           |
| `certgen.networkPolicy.extraIngress`                        | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                                                               | `[]`             |
| `certgen.networkPolicy.extraEgress`                         | Add extra ingress rules to the NetworkPolicy (ignored if allowExternalEgress=true)                                                                                                                                                                         | `[]`             |

### Envoy Gateway Metrics Parameters

| Name                                       | Description                                                                                            | Value   |
| ------------------------------------------ | ------------------------------------------------------------------------------------------------------ | ------- |
| `metrics.enabled`                          | Enable the export of Prometheus metrics                                                                | `false` |
| `metrics.annotations`                      | Add extra annotations to the resources                                                                 | `{}`    |
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

The above parameters map to the env variables defined in [bitnami/envoy-gateway](https://github.com/bitnami/containers/tree/main/bitnami/envoy-gateway). For more information please refer to the [bitnami/envoy-gateway](https://github.com/bitnami/containers/tree/main/bitnami/envoy-gateway) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
  --set metrics.enabled=true \
    REGISTRY_NAME/REPOSITORY_NAME/envoy-gateway
```

The above command enables metrics scraping with Prometheus.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml REGISTRY_NAME/REPOSITORY_NAME/envoy-gateway
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.
> **Tip**: You can use the default [values.yaml](https://github.com/bitnami/charts/tree/main/bitnami/envoy-gateway/values.yaml)

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