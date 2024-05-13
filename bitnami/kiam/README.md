<!--- app-name: Kiam -->

# Bitnami package for Kiam

kiam is a proxy that captures AWS Metadata API requests. It allows AWS IAM roles to be set for Kubernetes workloads.

[Overview of Kiam](https://github.com/uswitch/kiam)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/kiam
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.
> NOTE: KIAM has been designed to work on a Kubernetes cluster deployed on top of AWS, although it is possible to deploy it in other environments.

Looking to use Kiam in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the enterprise edition of Bitnami Application Catalog.

## Introduction

Bitnami charts for Helm are carefully engineered, actively maintained and are the quickest and easiest way to deploy containers on a Kubernetes cluster that are ready to handle production workloads.

This chart bootstraps a [kiam](https://github.com/bitnami/containers/tree/main/bitnami/kiam) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.23+ in AWS
- Helm 3.8.0+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/kiam
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

These commands deploy a kiam application on the Kubernetes cluster in the default configuration.

> **Tip**: List all releases using `helm list`

## Configuration and installation details

### Resource requests and limits

Bitnami charts allow setting resource requests and limits for all containers inside the chart deployment. These are inside the `resources` value (check parameter table). Setting requests is essential for production workloads and these should be adapted to your specific use case.

To make this process easier, the chart contains the `resourcesPreset` values, which automatically sets the `resources` section according to different presets. Check these presets in [the bitnami/common chart](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15). However, in production workloads using `resourcePreset` is discouraged as it may not fully adapt to your specific needs. Find more information on container resource management in the [official Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).

### [Rolling vs Immutable tags](https://docs.vmware.com/en/VMware-Tanzu-Application-Catalog/services/tutorials/GUID-understand-rolling-tags-containers-index.html)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Add extra environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `server.extraEnvVars` and `agent.extraEnvVars` property.

```yaml
server:
  extraEnvVars:
    - name: LOG_LEVEL
      value: error
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `server.extraEnvVarsCM`, `agent.extraEnvVarsCM` or the `server.extraEnvVarsSecret` and `agent.extraEnvVarsSecret` values.

### Configure Sidecars and Init Containers

If additional containers are needed in the same pod as Kiam (such as additional metrics or logging exporters), they can be defined using the `sidecars` parameter.

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

### Deploy extra resources

There are cases where you may want to deploy extra objects, such a ConfigMap containing your app's configuration or some extra deployment with a micro service used by your app. For covering this case, the chart allows adding the full specification of other objects using the `extraDeploy` parameter.

### Set Pod affinity

This chart allows you to set your custom affinity using the `server.affinity` and `agent.affinity` parameters. Find more information about Pod affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities) chart. To do so, set the `server.podAffinityPreset`, `agent.podAffinityPreset`, `server.podAntiAffinityPreset`, `agent.podAntiAffinityPreset`, or `server.nodeAffinityPreset` and `agent.nodeAffinityPreset` parameters.

### Configure TLS Secrets

This chart will facilitate the creation of TLS secrets for use with kiam. There are three common use cases:

- Helm auto-generates the certificates.
- User specifies the certificates in the values.
- User generates/manages certificates separately.

By default the first use case will be applied. In the second case, a certificate and a key are needed.

- The certificate files should look like the example below. There may be more than one certificate if there is a certificate chain.

    ```console
    -----BEGIN CERTIFICATE-----
    MIID6TCCAtGgAwIBAgIJAIaCwivkeB5EMA0GCSqGSIb3DQEBCwUAMFYxCzAJBgNV
    ...
    jScrvkiBO65F46KioCL9h5tDvomdU1aqpI/CBzhvZn1c0ZTf87tGQR8NK7v7
    -----END CERTIFICATE-----
    ```

- The certificate keys should look like this:

    ```console
    -----BEGIN RSA PRIVATE KEY-----
    MIIEogIBAAKCAQEAvLYcyu8f3skuRyUgeeNpeDvYBCDcgq+LsWap6zbX5f8oLqp4
    ...
    wrj2wDbCDCFmfqnSJ+dKI3vFLlEz44sAV8jX/kd4Y6ZTQhlLbYc=
    -----END RSA PRIVATE KEY-----
    ```

If using the values file to manage the certificates, copy the above values into the `server.tlsFiles.cert`, `server.tlsFiles.ca` and `server.tlsFiles.key` or `agent.tlsFiles.cert`, `agent.tlsFiles.ca` and `agent.tlsFiles.key` parameters respectively.

If managing TLS secrets outside of Helm, it is possible to create a TLS secret (named `kiam.local-tls`, for example) and set it using the `server.tlsSecret` or `agent.tlsSecret` parameters.

## Parameters

### Global parameters

| Name                                                  | Description                                                                                                                                                                                                                                                                                                                                                         | Value  |
| ----------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------ |
| `global.imageRegistry`                                | Global Docker image registry                                                                                                                                                                                                                                                                                                                                        | `""`   |
| `global.imagePullSecrets`                             | Global Docker registry secret names as an array                                                                                                                                                                                                                                                                                                                     | `[]`   |
| `global.storageClass`                                 | Global StorageClass for Persistent Volume(s)                                                                                                                                                                                                                                                                                                                        | `""`   |
| `global.compatibility.openshift.adaptSecurityContext` | Adapt the securityContext sections of the deployment to make them compatible with Openshift restricted-v2 SCC: remove runAsUser, runAsGroup and fsGroup and let the platform use their allowed default IDs. Possible values: auto (apply if the detected running cluster is Openshift), force (perform the adaptation always), disabled (do not perform adaptation) | `auto` |

### Common parameters

| Name                     | Description                                                                             | Value          |
| ------------------------ | --------------------------------------------------------------------------------------- | -------------- |
| `kubeVersion`            | Force target Kubernetes version (using Helm capabilities if not set)                    | `""`           |
| `nameOverride`           | Release name override                                                                   | `""`           |
| `fullnameOverride`       | Release full name override                                                              | `""`           |
| `commonLabels`           | Labels to add to all deployed objects                                                   | `{}`           |
| `commonAnnotations`      | Annotations to add to all deployed objects                                              | `{}`           |
| `extraDeploy`            | Array of extra objects to deploy with the release                                       | `[]`           |
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden) | `false`        |
| `diagnosticMode.command` | Command to override all containers in the the deployment(s)/statefulset(s)              | `["sleep"]`    |
| `diagnosticMode.args`    | Args to override all containers in the the deployment(s)/statefulset(s)                 | `["infinity"]` |

### kiam image parameters

| Name                | Description                                                                                          | Value                  |
| ------------------- | ---------------------------------------------------------------------------------------------------- | ---------------------- |
| `image.registry`    | kiam image registry                                                                                  | `REGISTRY_NAME`        |
| `image.repository`  | kiam image name                                                                                      | `REPOSITORY_NAME/kiam` |
| `image.digest`      | kiam image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag | `""`                   |
| `image.pullPolicy`  | kiam image pull policy                                                                               | `IfNotPresent`         |
| `image.pullSecrets` | Specify docker-registry secret names as an array                                                     | `[]`                   |

### kiam server parameters

| Name                                                       | Description                                                                                                                                                                                                                     | Value            |
| ---------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| `server.enabled`                                           | Deploy the kiam server                                                                                                                                                                                                          | `true`           |
| `server.containerPort`                                     | HTTPS port to expose at container level                                                                                                                                                                                         | `8443`           |
| `server.resourceType`                                      | Specify how to deploy the server (allowed values: `daemonset` and `deployment`)                                                                                                                                                 | `daemonset`      |
| `server.automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                              | `true`           |
| `server.hostAliases`                                       | Add deployment host aliases                                                                                                                                                                                                     | `[]`             |
| `server.useHostNetwork`                                    | Use host networking (ports will be directly exposed in the host)                                                                                                                                                                | `false`          |
| `server.replicaCount`                                      | Number of replicas to deploy (when `server.resourceType` is `daemonset`)                                                                                                                                                        | `1`              |
| `server.logJsonOutput`                                     | Use JSON format for logs                                                                                                                                                                                                        | `true`           |
| `server.logLevel`                                          | Logging level                                                                                                                                                                                                                   | `info`           |
| `server.sslCertHostPath`                                   | Path to the host system SSL certificates (necessary for contacting the AWS metadata server)                                                                                                                                     | `/etc/ssl/certs` |
| `server.podSecurityPolicy.create`                          | Whether to create a PodSecurityPolicy. WARNING: PodSecurityPolicy is deprecated in Kubernetes v1.21 or later, unavailable in v1.25 or later                                                                                     | `true`           |
| `server.podSecurityPolicy.allowedHostPaths`                | Extra host paths to allow in the PodSecurityPolicy                                                                                                                                                                              | `[]`             |
| `server.priorityClassName`                                 | Server priorityClassName                                                                                                                                                                                                        | `""`             |
| `server.schedulerName`                                     | Name of the k8s scheduler (other than default)                                                                                                                                                                                  | `""`             |
| `server.topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment                                                                                                                                                                                  | `[]`             |
| `server.startupProbe.enabled`                              | Enable startupProbe                                                                                                                                                                                                             | `false`          |
| `server.startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                                          | `5`              |
| `server.startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                                 | `30`             |
| `server.startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                                | `5`              |
| `server.startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                              | `5`              |
| `server.startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                              | `1`              |
| `server.livenessProbe.enabled`                             | Enable livenessProbe                                                                                                                                                                                                            | `true`           |
| `server.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                                         | `5`              |
| `server.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                                | `30`             |
| `server.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                               | `5`              |
| `server.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                                             | `5`              |
| `server.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                                             | `1`              |
| `server.readinessProbe.enabled`                            | Enable readinessProbe                                                                                                                                                                                                           | `true`           |
| `server.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                                        | `5`              |
| `server.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                               | `30`             |
| `server.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                              | `5`              |
| `server.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                                            | `5`              |
| `server.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                                            | `1`              |
| `server.customStartupProbe`                                | Override default startup probe                                                                                                                                                                                                  | `{}`             |
| `server.customLivenessProbe`                               | Override default liveness probe                                                                                                                                                                                                 | `{}`             |
| `server.customReadinessProbe`                              | Override default readiness probe                                                                                                                                                                                                | `{}`             |
| `server.extraArgs`                                         | Extra arguments to add to the default kiam command                                                                                                                                                                              | `{}`             |
| `server.command`                                           | Override kiam default command                                                                                                                                                                                                   | `[]`             |
| `server.args`                                              | Override kiam default args                                                                                                                                                                                                      | `[]`             |
| `server.tlsFiles`                                          | Base64-encoded PEM values for server's CA certificate(s), certificate and private key                                                                                                                                           | `{}`             |
| `server.gatewayTimeoutCreation`                            | Timeout when creating the kiam gateway                                                                                                                                                                                          | `1s`             |
| `server.tlsSecret`                                         | Name of a secret with TLS certificates for the container                                                                                                                                                                        | `""`             |
| `server.dnsPolicy`                                         | Pod DNS policy                                                                                                                                                                                                                  | `Default`        |
| `server.roleBaseArn`                                       | Base ARN for IAM roles. If not set kiam will detect it automatically                                                                                                                                                            | `""`             |
| `server.cacheSyncInterval`                                 | Cache synchronization interval                                                                                                                                                                                                  | `1m`             |
| `server.assumeRoleArn`                                     | IAM role for the server to assume                                                                                                                                                                                               | `""`             |
| `server.sessionDuration`                                   | Session duration for STS tokens                                                                                                                                                                                                 | `15m`            |
| `server.tlsCerts`                                          | Agent TLS Certificate filenames                                                                                                                                                                                                 | `{}`             |
| `server.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if server.resources is set (server.resources is recommended for production). | `nano`           |
| `server.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                               | `{}`             |
| `server.containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                                                                                                                                            | `true`           |
| `server.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                                | `{}`             |
| `server.containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                                                                                                                      | `1001`           |
| `server.containerSecurityContext.runAsGroup`               | Set containers' Security Context runAsGroup                                                                                                                                                                                     | `1001`           |
| `server.containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                                                                                                                                   | `false`          |
| `server.containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                                                                                                                                     | `false`          |
| `server.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                                         | `true`           |
| `server.containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                                                                                                                       | `false`          |
| `server.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                              | `["ALL"]`        |
| `server.containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                                | `RuntimeDefault` |
| `server.podSecurityContext.enabled`                        | Enabled kiam server pods' Security Context                                                                                                                                                                                      | `true`           |
| `server.podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                              | `Always`         |
| `server.podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                                  | `[]`             |
| `server.podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                                     | `[]`             |
| `server.podSecurityContext.fsGroup`                        | Set kiam server pod's Security Context fsGroup                                                                                                                                                                                  | `1001`           |
| `server.podAffinityPreset`                                 | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                             | `""`             |
| `server.podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                        | `soft`           |
| `server.nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                       | `""`             |
| `server.nodeAffinityPreset.key`                            | Node label key to match. Ignored if `affinity` is set.                                                                                                                                                                          | `""`             |
| `server.nodeAffinityPreset.values`                         | Node label values to match. Ignored if `affinity` is set.                                                                                                                                                                       | `[]`             |
| `server.affinity`                                          | Affinity for pod assignment                                                                                                                                                                                                     | `{}`             |
| `server.nodeSelector`                                      | Node labels for pod assignment                                                                                                                                                                                                  | `{}`             |
| `server.tolerations`                                       | Tolerations for pod assignment                                                                                                                                                                                                  | `[]`             |
| `server.podLabels`                                         | Extra labels for kiam pods                                                                                                                                                                                                      | `{}`             |
| `server.podAnnotations`                                    | Annotations for kiam pods                                                                                                                                                                                                       | `{}`             |
| `server.lifecycleHooks`                                    | lifecycleHooks for the kiam server container to automate configuration before or after startup.                                                                                                                                 | `{}`             |
| `server.updateStrategy.type`                               | Update strategy - only really applicable for deployments with RWO PVs attached                                                                                                                                                  | `RollingUpdate`  |
| `server.extraEnvVars`                                      | Array containing extra env vars to configure kiam server                                                                                                                                                                        | `[]`             |
| `server.extraEnvVarsCM`                                    | ConfigMap containing extra env vars to configure kiam server                                                                                                                                                                    | `""`             |
| `server.extraEnvVarsSecret`                                | Secret containing extra env vars to configure kiam server (in case of sensitive data)                                                                                                                                           | `""`             |
| `server.extraVolumes`                                      | Optionally specify extra list of additional volumes for kiam pods                                                                                                                                                               | `[]`             |
| `server.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for kiam container(s)                                                                                                                                                  | `[]`             |
| `server.initContainers`                                    | Add additional init containers to the kiam pods                                                                                                                                                                                 | `[]`             |
| `server.sidecars`                                          | Add additional sidecar containers to the kiam pods                                                                                                                                                                              | `[]`             |

### kiam server exposure parameters

| Name                                           | Description                                                                                        | Value       |
| ---------------------------------------------- | -------------------------------------------------------------------------------------------------- | ----------- |
| `server.service.type`                          | Kubernetes service type                                                                            | `ClusterIP` |
| `server.service.port`                          | Service grpc-lb port                                                                               | `8443`      |
| `server.service.nodePorts`                     | Specify the nodePort values for the LoadBalancer and NodePort service types.                       | `{}`        |
| `server.service.clusterIP`                     | kiam service clusterIP IP                                                                          | `None`      |
| `server.service.loadBalancerIP`                | loadBalancerIP if service type is `LoadBalancer`                                                   | `""`        |
| `server.service.loadBalancerSourceRanges`      | Address that are allowed when service is LoadBalancer                                              | `[]`        |
| `server.service.extraPorts`                    | Extra ports to expose (normally used with the `sidecar` value)                                     | `[]`        |
| `server.service.externalTrafficPolicy`         | Enable client source IP preservation                                                               | `Cluster`   |
| `server.service.annotations`                   | Annotations for kiam service                                                                       | `{}`        |
| `server.service.sessionAffinity`               | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                               | `None`      |
| `server.service.sessionAffinityConfig`         | Additional settings for the sessionAffinity                                                        | `{}`        |
| `server.networkPolicy.enabled`                 | Specifies whether a NetworkPolicy should be created                                                | `true`      |
| `server.networkPolicy.allowExternal`           | Don't require server label for connections                                                         | `true`      |
| `server.networkPolicy.allowExternalEgress`     | Allow the pod to access any range of port and all destinations.                                    | `true`      |
| `server.networkPolicy.kubeAPIServerPorts`      | List of possible endpoints to kube-apiserver (limit to your cluster settings to increase security) | `[]`        |
| `server.networkPolicy.extraIngress`            | Add extra ingress rules to the NetworkPolicy                                                       | `[]`        |
| `server.networkPolicy.extraEgress`             | Add extra ingress rules to the NetworkPolicy                                                       | `[]`        |
| `server.networkPolicy.ingressNSMatchLabels`    | Labels to match to allow traffic from other namespaces                                             | `{}`        |
| `server.networkPolicy.ingressNSPodMatchLabels` | Pod labels to match to allow traffic from other namespaces                                         | `{}`        |

### kiam server Service Account parameters

| Name                                                 | Description                                                                                                         | Value   |
| ---------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------- | ------- |
| `server.serviceAccount.create`                       | Specifies whether a ServiceAccount should be created                                                                | `true`  |
| `server.serviceAccount.name`                         | Name of the service account to use. If not set and create is true, a name is generated using the fullname template. | `""`    |
| `server.serviceAccount.automountServiceAccountToken` | Automount service account token for the server service account                                                      | `false` |
| `server.serviceAccount.annotations`                  | Annotations for service account. Evaluated as a template. Only used if `create` is `true`.                          | `{}`    |

### kiam server metrics parameters

| Name                                              | Description                                                                       | Value   |
| ------------------------------------------------- | --------------------------------------------------------------------------------- | ------- |
| `server.metrics.enabled`                          | Enable exposing kiam statistics                                                   | `false` |
| `server.metrics.port`                             | Metrics port                                                                      | `9621`  |
| `server.metrics.syncInterval`                     | Metrics synchronization interval statistics                                       | `5s`    |
| `server.metrics.annotations`                      | Annotations for enabling prometheus to access the metrics endpoints               | `{}`    |
| `server.metrics.serviceMonitor.enabled`           | Create ServiceMonitor Resource for scraping metrics using PrometheusOperator      | `false` |
| `server.metrics.serviceMonitor.namespace`         | Namespace in which Prometheus is running                                          | `""`    |
| `server.metrics.serviceMonitor.jobLabel`          | The name of the label on the target service to use as the job name in prometheus. | `""`    |
| `server.metrics.serviceMonitor.interval`          | Interval at which metrics should be scraped                                       | `30s`   |
| `server.metrics.serviceMonitor.metricRelabelings` | Specify Metric Relabellings to add to the scrape endpoint                         | `[]`    |
| `server.metrics.serviceMonitor.relabelings`       | Specify Relabelings to add to the scrape endpoint                                 | `[]`    |
| `server.metrics.serviceMonitor.scrapeTimeout`     | Specify the timeout after which the scrape is ended                               | `""`    |
| `server.metrics.serviceMonitor.selector`          | metrics service selector                                                          | `{}`    |
| `server.metrics.serviceMonitor.labels`            | Extra labels for the ServiceMonitor                                               | `{}`    |
| `server.metrics.serviceMonitor.honorLabels`       | honorLabels chooses the metric's labels on collisions with target labels          | `false` |

### kiam agent parameters

| Name                                                      | Description                                                                                                                                                                                                                   | Value                     |
| --------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------- |
| `agent.enabled`                                           | Deploy the kiam agent                                                                                                                                                                                                         | `true`                    |
| `agent.logJsonOutput`                                     | Use JSON format for logs                                                                                                                                                                                                      | `true`                    |
| `agent.logLevel`                                          | Logging level                                                                                                                                                                                                                 | `info`                    |
| `agent.priorityClassName`                                 | Server priorityClassName                                                                                                                                                                                                      | `""`                      |
| `agent.schedulerName`                                     | Name of the k8s scheduler (other than default)                                                                                                                                                                                | `""`                      |
| `agent.topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment                                                                                                                                                                                | `[]`                      |
| `agent.allowRouteRegExp`                                  | Regexp with the allowed paths for agents to redirect                                                                                                                                                                          | `""`                      |
| `agent.automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                            | `false`                   |
| `agent.hostAliases`                                       | Add deployment host aliases                                                                                                                                                                                                   | `[]`                      |
| `agent.containerPort`                                     | HTTPS port to expose at container level                                                                                                                                                                                       | `8183`                    |
| `agent.iptables`                                          | Have the agent modify the host iptables rules                                                                                                                                                                                 | `false`                   |
| `agent.iptablesRemoveOnShutdown`                          | Remove iptables rules when shutting down the agent node                                                                                                                                                                       | `false`                   |
| `agent.hostInterface`                                     | Interface for agents for redirecting requests                                                                                                                                                                                 | `cali+`                   |
| `agent.keepaliveParams.permitWithoutStream`               | Permit keepalive without stream                                                                                                                                                                                               | `false`                   |
| `agent.keepaliveParams.time`                              | Keepalive time                                                                                                                                                                                                                | `""`                      |
| `agent.keepaliveParams.timeout`                           | Keepalive timeout                                                                                                                                                                                                             | `""`                      |
| `agent.enableDeepProbe`                                   | Use the probes using the `/health` endpoint                                                                                                                                                                                   | `false`                   |
| `agent.dnsPolicy`                                         | Pod DNS policy                                                                                                                                                                                                                | `ClusterFirstWithHostNet` |
| `agent.sslCertHostPath`                                   | Path to the host system SSL certificates (necessary for contacting the AWS metadata agent)                                                                                                                                    | `/etc/ssl/certs`          |
| `agent.tlsFiles`                                          | Base64-encoded PEM values for server's CA certificate(s), certificate and private key                                                                                                                                         | `{}`                      |
| `agent.podSecurityPolicy.create`                          | Whether to create a PodSecurityPolicy. WARNING: PodSecurityPolicy is deprecated in Kubernetes v1.21 or later, unavailable in v1.25 or later                                                                                   | `true`                    |
| `agent.podSecurityPolicy.allowedHostPaths`                | Extra host paths to allow in the PodSecurityPolicy                                                                                                                                                                            | `[]`                      |
| `agent.tlsSecret`                                         | Name of a secret with TLS certificates for the container                                                                                                                                                                      | `""`                      |
| `agent.useHostNetwork`                                    | Use host networking (ports will be directly exposed in the host)                                                                                                                                                              | `true`                    |
| `agent.tlsCerts`                                          | Agent TLS Certificate filenames                                                                                                                                                                                               | `{}`                      |
| `agent.startupProbe.enabled`                              | Enable startupProbe                                                                                                                                                                                                           | `false`                   |
| `agent.startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                                        | `5`                       |
| `agent.startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                               | `30`                      |
| `agent.startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                              | `5`                       |
| `agent.startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                            | `5`                       |
| `agent.startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                            | `1`                       |
| `agent.livenessProbe.enabled`                             | Enable livenessProbe                                                                                                                                                                                                          | `true`                    |
| `agent.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                                       | `5`                       |
| `agent.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                              | `30`                      |
| `agent.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                             | `5`                       |
| `agent.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                                           | `5`                       |
| `agent.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                                           | `1`                       |
| `agent.readinessProbe.enabled`                            | Enable readinessProbe                                                                                                                                                                                                         | `true`                    |
| `agent.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                                      | `5`                       |
| `agent.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                             | `30`                      |
| `agent.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                            | `5`                       |
| `agent.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                                          | `5`                       |
| `agent.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                                          | `1`                       |
| `agent.customStartupProbe`                                | Override default startup probe                                                                                                                                                                                                | `{}`                      |
| `agent.customLivenessProbe`                               | Override default liveness probe                                                                                                                                                                                               | `{}`                      |
| `agent.customReadinessProbe`                              | Override default readiness probe                                                                                                                                                                                              | `{}`                      |
| `agent.extraArgs`                                         | Extra arguments to add to the default kiam command                                                                                                                                                                            | `{}`                      |
| `agent.gatewayTimeoutCreation`                            | Timeout when creating the kiam gateway                                                                                                                                                                                        | `1s`                      |
| `agent.command`                                           | Override kiam default command                                                                                                                                                                                                 | `[]`                      |
| `agent.args`                                              | Override kiam default args                                                                                                                                                                                                    | `[]`                      |
| `agent.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if agent.resources is set (agent.resources is recommended for production). | `nano`                    |
| `agent.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                             | `{}`                      |
| `agent.containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                                                                                                                                          | `true`                    |
| `agent.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                              | `{}`                      |
| `agent.containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                                                                                                                    | `0`                       |
| `agent.containerSecurityContext.runAsGroup`               | Set containers' Security Context runAsGroup                                                                                                                                                                                   | `0`                       |
| `agent.containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                                                                                                                                 | `false`                   |
| `agent.containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                                                                                                                                   | `false`                   |
| `agent.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                                       | `true`                    |
| `agent.containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                                                                                                                     | `false`                   |
| `agent.containerSecurityContext.capabilities.add`         | List of capabilities to be added                                                                                                                                                                                              | `["NET_ADMIN"]`           |
| `agent.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                            | `["ALL"]`                 |
| `agent.containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                              | `RuntimeDefault`          |
| `agent.podSecurityContext.enabled`                        | Enabled agent pods' Security Context                                                                                                                                                                                          | `true`                    |
| `agent.podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                            | `Always`                  |
| `agent.podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                                | `[]`                      |
| `agent.podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                                   | `[]`                      |
| `agent.podSecurityContext.fsGroup`                        | Set agent pod's Security Context fsGroup                                                                                                                                                                                      | `1001`                    |
| `agent.podAffinityPreset`                                 | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                           | `""`                      |
| `agent.podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                      | `soft`                    |
| `agent.nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                     | `""`                      |
| `agent.nodeAffinityPreset.key`                            | Node label key to match. Ignored if `affinity` is set.                                                                                                                                                                        | `""`                      |
| `agent.nodeAffinityPreset.values`                         | Node label values to match. Ignored if `affinity` is set.                                                                                                                                                                     | `[]`                      |
| `agent.affinity`                                          | Affinity for pod assignment                                                                                                                                                                                                   | `{}`                      |
| `agent.nodeSelector`                                      | Node labels for pod assignment                                                                                                                                                                                                | `{}`                      |
| `agent.tolerations`                                       | Tolerations for pod assignment                                                                                                                                                                                                | `[]`                      |
| `agent.podLabels`                                         | Extra labels for kiam pods                                                                                                                                                                                                    | `{}`                      |
| `agent.podAnnotations`                                    | Annotations for kiam pods                                                                                                                                                                                                     | `{}`                      |
| `agent.lifecycleHooks`                                    | LifecycleHooks to set additional configuration at startup.                                                                                                                                                                    | `{}`                      |
| `agent.updateStrategy.type`                               | Update strategy - only really applicable for deployments with RWO PVs attached                                                                                                                                                | `RollingUpdate`           |
| `agent.extraEnvVars`                                      | Array containing extra env vars to configure kiam agent                                                                                                                                                                       | `[]`                      |
| `agent.extraEnvVarsCM`                                    | ConfigMap containing extra env vars to configure kiam agent                                                                                                                                                                   | `""`                      |
| `agent.extraEnvVarsSecret`                                | Secret containing extra env vars to configure kiam agent (in case of sensitive data)                                                                                                                                          | `""`                      |
| `agent.extraVolumes`                                      | Optionally specify extra list of additional volumes for kiam pods                                                                                                                                                             | `[]`                      |
| `agent.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for kiam container(s)                                                                                                                                                | `[]`                      |
| `agent.initContainers`                                    | Add additional init containers to the kiam pods                                                                                                                                                                               | `[]`                      |
| `agent.sidecars`                                          | Add additional sidecar containers to the kiam pods                                                                                                                                                                            | `[]`                      |

### kiam agent exposure parameters

| Name                                          | Description                                                                  | Value       |
| --------------------------------------------- | ---------------------------------------------------------------------------- | ----------- |
| `agent.service.type`                          | Kubernetes service type                                                      | `ClusterIP` |
| `agent.service.nodePorts`                     | Specify the nodePort values for the LoadBalancer and NodePort service types. | `{}`        |
| `agent.service.clusterIP`                     | kiam service clusterIP IP                                                    | `""`        |
| `agent.service.loadBalancerIP`                | loadBalancerIP if service type is `LoadBalancer`                             | `""`        |
| `agent.service.loadBalancerSourceRanges`      | Address that are allowed when service is LoadBalancer                        | `[]`        |
| `agent.service.externalTrafficPolicy`         | Enable client source IP preservation                                         | `Cluster`   |
| `agent.service.extraPorts`                    | Extra ports to expose (normally used with the `sidecar` value)               | `[]`        |
| `agent.service.annotations`                   | Annotations for kiam service                                                 | `{}`        |
| `agent.service.sessionAffinity`               | Session Affinity for Kubernetes service, can be "None" or "ClientIP"         | `None`      |
| `agent.service.sessionAffinityConfig`         | Additional settings for the sessionAffinity                                  | `{}`        |
| `agent.networkPolicy.enabled`                 | Specifies whether a NetworkPolicy should be created                          | `true`      |
| `agent.networkPolicy.allowExternal`           | Don't require server label for connections                                   | `true`      |
| `agent.networkPolicy.allowExternalEgress`     | Allow the pod to access any range of port and all destinations.              | `true`      |
| `agent.networkPolicy.extraIngress`            | Add extra ingress rules to the NetworkPolicy                                 | `[]`        |
| `agent.networkPolicy.extraEgress`             | Add extra ingress rules to the NetworkPolicy                                 | `[]`        |
| `agent.networkPolicy.ingressNSMatchLabels`    | Labels to match to allow traffic from other namespaces                       | `{}`        |
| `agent.networkPolicy.ingressNSPodMatchLabels` | Pod labels to match to allow traffic from other namespaces                   | `{}`        |

### kiam agent Service Account parameters

| Name                                                | Description                                                                                                         | Value   |
| --------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------- | ------- |
| `agent.serviceAccount.create`                       | Specifies whether a ServiceAccount should be created                                                                | `true`  |
| `agent.serviceAccount.name`                         | Name of the service account to use. If not set and create is true, a name is generated using the fullname template. | `""`    |
| `agent.serviceAccount.automountServiceAccountToken` | Automount service account token for the server service account                                                      | `false` |
| `agent.serviceAccount.annotations`                  | Annotations for service account. Evaluated as a template. Only used if `create` is `true`.                          | `{}`    |

### kiam agent metrics parameters

| Name                                             | Description                                                                       | Value   |
| ------------------------------------------------ | --------------------------------------------------------------------------------- | ------- |
| `agent.metrics.enabled`                          | Enable exposing kiam statistics                                                   | `false` |
| `agent.metrics.port`                             | Service HTTP management port                                                      | `9620`  |
| `agent.metrics.syncInterval`                     | Metrics synchronization interval statistics                                       | `5s`    |
| `agent.metrics.annotations`                      | Annotations for enabling prometheus to access the metrics endpoints               | `{}`    |
| `agent.metrics.serviceMonitor.enabled`           | Create ServiceMonitor Resource for scraping metrics using PrometheusOperator      | `false` |
| `agent.metrics.serviceMonitor.namespace`         | Namespace which Prometheus is running in                                          | `""`    |
| `agent.metrics.serviceMonitor.jobLabel`          | The name of the label on the target service to use as the job name in prometheus. | `""`    |
| `agent.metrics.serviceMonitor.interval`          | Interval at which metrics should be scraped                                       | `30s`   |
| `agent.metrics.serviceMonitor.metricRelabelings` | Specify Metric Relabelings to add to the scrape endpoint                          | `[]`    |
| `agent.metrics.serviceMonitor.relabelings`       | Specify Relabelings to add to the scrape endpoint                                 | `[]`    |
| `agent.metrics.serviceMonitor.scrapeTimeout`     | Specify the timeout after which the scrape is ended                               | `""`    |
| `agent.metrics.serviceMonitor.selector`          | metrics service selector                                                          | `{}`    |
| `agent.metrics.serviceMonitor.labels`            | Extra labels for the ServiceMonitor                                               | `{}`    |
| `agent.metrics.serviceMonitor.honorLabels`       | honorLabels chooses the metric's labels on collisions with target labels          | `false` |

### RBAC parameters

| Name          | Description                                     | Value  |
| ------------- | ----------------------------------------------- | ------ |
| `rbac.create` | Whether to create and use RBAC resources or not | `true` |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release --set server.resourceType=deployment oci://REGISTRY_NAME/REPOSITORY_NAME/kiam
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The above command sets the server nodes to be deployed as Deployment objects.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml oci://REGISTRY_NAME/REPOSITORY_NAME/kiam
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.
> **Tip**: You can use the default [values.yaml](https://github.com/bitnami/charts/tree/main/bitnami/kiam/values.yaml)

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 2.0.0

This major bump changes the following security defaults:

- `runAsGroup` is changed from `0` to `1001`
- `readOnlyRootFilesystem` is set to `true`
- `resourcesPreset` is changed from `none` to the minimum size working in our test suites (NOTE: `resourcesPreset` is not meant for production usage, but `resources` adapted to your use case).
- `global.compatibility.openshift.adaptSecurityContext` is changed from `disabled` to `auto`.

This could potentially break any customization or init scripts used in your deployment. If this is the case, change the default values to the previous ones.

### To 1.0.0

Kiam version was updated from `3.6.0` to `4.0.0`, there are no relevant changes in the chart itself. According to the official documentation, this new major introduces the following breaking changes at application level:

>- The role policy is now applied after the role ARN has been resolved, this may cause compatibility issues with existing `iam.amazonaws.com/permitted` restrictions.
>- StatsD metrics have been removed.
>- A number of agent flags have changed.

For further information, you may check the [official notes](https://github.com/uswitch/kiam/blob/master/docs/UPGRADING.md) covering upgrade details.

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