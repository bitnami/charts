<!--- app-name: Bitnami Object Storage based on MinIO&reg; Operator -->

# Bitnami package for Bitnami Object Storage based on MinIO&reg; Operator

MinIO&reg; Operator is a Kubernetes-native tool for deploying and managing high-performance, S3-compatible MinIO object storage across hybrid cloud infrastructures

[Overview of Bitnami Object Storage based on MinIO&reg; Operator](https://operator.min.io/)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/minio-operator
```

Looking to use Bitnami Object Storage based on MinIO&reg; Operator in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the commercial edition of the Bitnami catalog.

## Introduction

This chart bootstraps a [Bitnami Object Storage based on MinIO&reg; Operator](https://github.com/bitnami/containers/tree/main/bitnami/minio-operator) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release REGISTRY_NAME/REPOSITORY_NAME/minio-operator
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The command deploys Bitnami Object Storage based on MinIO&reg; Operator on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Configuration and installation details

### Configure the operator

The MinIO;reg; Operator allows configuration via environment variable. In case you want to add extra configuration settings, you can use the `extraEnvVars` property.

```yaml
extraEnvVars:
  - name: SUBNET_BASE_URL
    value: mynet.test
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values.

Find more configuration settings in the upstream [minio-operator](https://github.com/minio/operator/blob/master/docs/env-variables.md) documentation.

### Resource requests and limits

Bitnami charts allow setting resource requests and limits for all containers inside the chart deployment. These are inside the `resources` value (check parameter table). Setting requests is essential for production workloads and these should be adapted to your specific use case.

To make this process easier, the chart contains the `resourcesPreset` values, which automatically sets the `resources` section according to different presets. Check these presets in [the bitnami/common chart](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15). However, in production workloads using `resourcesPreset` is discouraged as it may not fully adapt to your specific needs. Find more information on container resource management in the [official Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).

### Backup and restore

To back up and restore Helm chart deployments on Kubernetes, you need to back up the persistent volumes from the source deployment and attach them to a new deployment using [Velero](https://velero.io/), a Kubernetes backup/restore tool. Find the instructions for using Velero in [this guide](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-backup-restore-deployments-velero-index.html).

### [Rolling VS Immutable tags](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Sidecars

If additional containers are needed in the same pod as minio-operator (such as additional metrics or logging exporters), they can be defined using the `sidecars` parameter:

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

Apart from the Operator, you may want to deploy MinIO;reg; Tenant objects.  For covering this case, the chart allows adding the full specification of other objects using the `extraDeploy` parameter. The following example creates a MinIO;reg; tenant with two secrets containing the console and API credentials:

```yaml
extraDeploy:
  apiVersion: v1
  kind: Secret
  metadata:
    name: storage-configuration
  stringData:
    config.env: |-
      export MINIO_ROOT_USER="minio"
      export MINIO_ROOT_PASSWORD="minio123"
      export MINIO_STORAGE_CLASS_STANDARD="EC:2"
      export MINIO_BROWSER="on"
  type: Opaque
- apiVersion: v1
  stringData:
    CONSOLE_ACCESS_KEY: console
    CONSOLE_SECRET_KEY: console123
  kind: Secret
  metadata:
    name: storage-user
  type: Opaque
- apiVersion: minio.min.io/v2
  kind: Tenant
  metadata:
    annotations:
      prometheus.io/path: /minio/v2/metrics/cluster
      prometheus.io/port: "9000"
      prometheus.io/scrape: "true"
    labels:
      app: minio
    name: my-minio
  spec:
    certConfig: {}
    configuration:
      name: storage-configuration
    env: []
    externalCaCertSecret: []
    externalCertSecret: []
    externalClientCertSecrets: []
    features:
      bucketDNS: false
      domains: {}
    mountPath: /export
    podManagementPolicy: Parallel
    pools:
    - affinity:
        nodeAffinity: {}
        podAffinity: {}
        podAntiAffinity: {}
      containerSecurityContext:
        allowPrivilegeEscalation: false
        capabilities:
          drop:
          - ALL
        runAsGroup: 1001
        runAsNonRoot: true
        runAsUser: 1001
        seccompProfile:
          type: RuntimeDefault
      name: pool-0
      nodeSelector: {}
      resources: {}
      securityContext:
        fsGroup: 1001
        fsGroupChangePolicy: OnRootMismatch
        runAsGroup: 1001
        runAsNonRoot: true
        runAsUser: 1001
      servers: 2
      tolerations: []
      topologySpreadConstraints: []
      volumeClaimTemplate:
        apiVersion: v1
        kind: persistentvolumeclaims
        metadata: {}
        spec:
          accessModes:
          - ReadWriteOnce
          resources:
            requests:
              storage: 8Gi
          storageClassName: standard
        status: {}
      volumesPerServer: 2
    priorityClassName: ""
    requestAutoCert: true
    serviceAccountName: ""
    serviceMetadata:
      consoleServiceAnnotations: {}
      consoleServiceLabels: {}
      minioServiceAnnotations: {}
      minioServiceLabels: {}
    subPath: ""
    users:
    - name: storage-user
```

Check the [Bitnami Object Storage based on MinIO&reg; Operator official documentation](https://min.io/docs/minio/kubernetes/upstream/operations/deploy-manage-tenants.html) for the list of available objects.

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
| `global.security.allowInsecureImages`                 | Allows skipping image verification                                                                                                                                                                                                                                                                                                                                  | `false` |
| `global.compatibility.openshift.adaptSecurityContext` | Adapt the securityContext sections of the deployment to make them compatible with Openshift restricted-v2 SCC: remove runAsUser, runAsGroup and fsGroup and let the platform use their allowed default IDs. Possible values: auto (apply if the detected running cluster is Openshift), force (perform the adaptation always), disabled (do not perform adaptation) | `auto`  |

### Common parameters

| Name                                                | Description                                                                                                                                                                                                                         | Value                                    |
| --------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------- |
| `kubeVersion`                                       | Override Kubernetes version                                                                                                                                                                                                         | `""`                                     |
| `apiVersions`                                       | Override Kubernetes API versions reported by .Capabilities                                                                                                                                                                          | `[]`                                     |
| `nameOverride`                                      | String to partially override common.names.name                                                                                                                                                                                      | `""`                                     |
| `fullnameOverride`                                  | String to fully override common.names.fullname                                                                                                                                                                                      | `""`                                     |
| `namespaceOverride`                                 | String to fully override common.names.namespace                                                                                                                                                                                     | `""`                                     |
| `commonLabels`                                      | Labels to add to all deployed objects                                                                                                                                                                                               | `{}`                                     |
| `commonAnnotations`                                 | Annotations to add to all deployed objects                                                                                                                                                                                          | `{}`                                     |
| `clusterDomain`                                     | Kubernetes cluster domain name                                                                                                                                                                                                      | `cluster.local`                          |
| `extraDeploy`                                       | Array of extra objects to deploy with the release                                                                                                                                                                                   | `[]`                                     |
| `image.registry`                                    | MinIO&reg; Operator image registry                                                                                                                                                                                                  | `REGISTRY_NAME`                          |
| `image.repository`                                  | MinIO&reg; Operator image repository                                                                                                                                                                                                | `REPOSITORY_NAME/minio-operator`         |
| `image.digest`                                      | MinIO&reg; Operator image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag image tag (immutable tags are recommended)                                                                      | `""`                                     |
| `image.pullPolicy`                                  | MinIO&reg; Operator image pull policy                                                                                                                                                                                               | `IfNotPresent`                           |
| `image.pullSecrets`                                 | MinIO&reg; Operator image pull secrets                                                                                                                                                                                              | `[]`                                     |
| `image.debug`                                       | Enable MinIO&reg; Operator image debug mode                                                                                                                                                                                         | `false`                                  |
| `sidecarImage.registry`                             | minio-operator-sidecar image registry                                                                                                                                                                                               | `REGISTRY_NAME`                          |
| `sidecarImage.repository`                           | minio-operator-sidecar image repository                                                                                                                                                                                             | `REPOSITORY_NAME/minio-operator-sidecar` |
| `sidecarImage.digest`                               | minio-operator-sidecar image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag image tag (immutable tags are recommended)                                                                   | `""`                                     |
| `minioImage.registry`                               | KES;reg; image registry                                                                                                                                                                                                             | `REGISTRY_NAME`                          |
| `minioImage.repository`                             | KES;reg; image repository                                                                                                                                                                                                           | `REPOSITORY_NAME/minio`                  |
| `minioImage.digest`                                 | KES;reg; image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                            | `""`                                     |
| `kesImage.registry`                                 | KES;reg; image registry                                                                                                                                                                                                             | `REGISTRY_NAME`                          |
| `kesImage.repository`                               | KES;reg; image repository                                                                                                                                                                                                           | `REPOSITORY_NAME/kes`                    |
| `kesImage.digest`                                   | KES;reg; image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                            | `""`                                     |
| `replicaCount`                                      | Number of MinIO;reg; Operator replicas to deploy                                                                                                                                                                                    | `1`                                      |
| `livenessProbe.enabled`                             | Enable livenessProbe on MinIO;reg; Operator containers                                                                                                                                                                              | `true`                                   |
| `livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                                             | `5`                                      |
| `livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                                    | `10`                                     |
| `livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                                   | `5`                                      |
| `livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                                                 | `5`                                      |
| `livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                                                 | `1`                                      |
| `readinessProbe.enabled`                            | Enable readinessProbe on MinIO;reg; Operator containers                                                                                                                                                                             | `true`                                   |
| `readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                                            | `5`                                      |
| `readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                                   | `10`                                     |
| `readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                                  | `5`                                      |
| `readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                                                | `5`                                      |
| `readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                                                | `1`                                      |
| `startupProbe.enabled`                              | Enable startupProbe on MinIO;reg; Operator containers                                                                                                                                                                               | `false`                                  |
| `startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                                              | `5`                                      |
| `startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                                     | `10`                                     |
| `startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                                    | `5`                                      |
| `startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                                  | `5`                                      |
| `startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                                  | `1`                                      |
| `customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                                                                                                                                 | `{}`                                     |
| `customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                                                                                                                                                | `{}`                                     |
| `customStartupProbe`                                | Custom startupProbe that overrides the default one                                                                                                                                                                                  | `{}`                                     |
| `watchAllNamespaces`                                | Watch for MinIO;reg; Operator resources in all namespaces                                                                                                                                                                           | `true`                                   |
| `watchNamespaces`                                   | Watch for MinIO;reg; Operator resources in the given namespaces                                                                                                                                                                     | `[]`                                     |
| `resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if operator.resources is set (operator.resources is recommended for production). | `nano`                                   |
| `resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                   | `{}`                                     |
| `podSecurityContext.enabled`                        | Enabled MinIO;reg; Operator pods' Security Context                                                                                                                                                                                  | `true`                                   |
| `podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                                  | `Always`                                 |
| `podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                                      | `[]`                                     |
| `podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                                         | `[]`                                     |
| `podSecurityContext.fsGroup`                        | Set MinIO;reg; Operator pod's Security Context fsGroup                                                                                                                                                                              | `1001`                                   |
| `containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                                                                                                                                                | `true`                                   |
| `containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                                    | `{}`                                     |
| `containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                                                                                                                          | `1001`                                   |
| `containerSecurityContext.runAsGroup`               | Set containers' Security Context runAsGroup                                                                                                                                                                                         | `1001`                                   |
| `containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                                                                                                                                       | `true`                                   |
| `containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                                                                                                                                         | `false`                                  |
| `containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                                             | `true`                                   |
| `containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                                                                                                                           | `false`                                  |
| `containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                                  | `["ALL"]`                                |
| `containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                                    | `RuntimeDefault`                         |
| `command`                                           | Override default container command (useful when using custom images)                                                                                                                                                                | `[]`                                     |
| `args`                                              | Override default container args (useful when using custom images)                                                                                                                                                                   | `[]`                                     |
| `extraArgs`                                         | Add extra arguments to the default command                                                                                                                                                                                          | `[]`                                     |
| `automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                                  | `true`                                   |
| `hostAliases`                                       | MinIO;reg; Operator pods host aliases                                                                                                                                                                                               | `[]`                                     |
| `podLabels`                                         | Extra labels for MinIO;reg; Operator pods                                                                                                                                                                                           | `{}`                                     |
| `podAnnotations`                                    | Annotations for MinIO;reg; Operator pods                                                                                                                                                                                            | `{}`                                     |
| `deploymentLabels`                                  | Add extra labels to the Deployment object                                                                                                                                                                                           | `{}`                                     |
| `deploymentAnnotations`                             | Add extra annotations to the Deployment object                                                                                                                                                                                      | `{}`                                     |
| `extraContainerPorts`                               | Optionally specify extra list of additional container ports                                                                                                                                                                         | `[]`                                     |
| `podAffinityPreset`                                 | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                                 | `""`                                     |
| `podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                            | `soft`                                   |
| `pdb.create`                                        | Enable/disable a Pod Disruption Budget creation                                                                                                                                                                                     | `true`                                   |
| `pdb.minAvailable`                                  | Minimum number/percentage of pods that should remain scheduled                                                                                                                                                                      | `""`                                     |
| `pdb.maxUnavailable`                                | Maximum number/percentage of pods that may be made unavailable                                                                                                                                                                      | `""`                                     |
| `nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                           | `""`                                     |
| `nodeAffinityPreset.key`                            | Node label key to match. Ignored if `affinity` is set                                                                                                                                                                               | `""`                                     |
| `nodeAffinityPreset.values`                         | Node label values to match. Ignored if `affinity` is set                                                                                                                                                                            | `[]`                                     |
| `affinity`                                          | Affinity for MinIO;reg; Operator pods assignment                                                                                                                                                                                    | `{}`                                     |
| `nodeSelector`                                      | Node labels for MinIO;reg; Operator pods assignment                                                                                                                                                                                 | `{}`                                     |
| `tolerations`                                       | Tolerations for MinIO;reg; Operator pods assignment                                                                                                                                                                                 | `[]`                                     |
| `updateStrategy.type`                               | MinIO;reg; Operator statefulset strategy type                                                                                                                                                                                       | `RollingUpdate`                          |
| `priorityClassName`                                 | MinIO;reg; Operator pods' priorityClassName                                                                                                                                                                                         | `""`                                     |
| `topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template                                                                                                            | `[]`                                     |
| `schedulerName`                                     | Name of the k8s scheduler (other than default) for MinIO;reg; Operator pods                                                                                                                                                         | `""`                                     |
| `terminationGracePeriodSeconds`                     | Seconds MinIO;reg Operator pod needs to terminate gracefully                                                                                                                                                                        | `""`                                     |
| `lifecycleHooks`                                    | for the MinIO;reg; Operator container(s) to automate configuration before or after startup                                                                                                                                          | `{}`                                     |
| `extraEnvVars`                                      | Array with extra environment variables to add to MinIO;reg; Operator nodes                                                                                                                                                          | `[]`                                     |
| `extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for MinIO;reg; Operator nodes                                                                                                                                                  | `""`                                     |
| `extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for MinIO;reg; Operator nodes                                                                                                                                                     | `""`                                     |
| `extraVolumes`                                      | Optionally specify extra list of additional volumes for the MinIO;reg; Operator pod(s)                                                                                                                                              | `[]`                                     |
| `extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the MinIO;reg; Operator container(s)                                                                                                                                   | `[]`                                     |
| `sidecars`                                          | Add additional sidecar containers to the MinIO;reg; Operator pod(s)                                                                                                                                                                 | `[]`                                     |
| `initContainers`                                    | Add additional init containers to the MinIO;reg; Operator pod(s)                                                                                                                                                                    | `[]`                                     |
| `autoscaling.vpa.enabled`                           | Enable VPA                                                                                                                                                                                                                          | `false`                                  |
| `autoscaling.vpa.annotations`                       | Annotations for VPA resource                                                                                                                                                                                                        | `{}`                                     |
| `autoscaling.vpa.controlledResources`               | VPA List of resources that the vertical pod autoscaler can control. Defaults to cpu and memory                                                                                                                                      | `[]`                                     |
| `autoscaling.vpa.maxAllowed`                        | VPA Max allowed resources for the pod                                                                                                                                                                                               | `{}`                                     |
| `autoscaling.vpa.minAllowed`                        | VPA Min allowed resources for the pod                                                                                                                                                                                               | `{}`                                     |
| `autoscaling.vpa.updatePolicy.updateMode`           | Autoscaling update policy Specifies whether recommended updates are applied when a Pod is started and whether recommended updates are applied during the life of a Pod                                                              | `Auto`                                   |
| `autoscaling.hpa.enabled`                           | Enable autoscaling for operator                                                                                                                                                                                                     | `false`                                  |
| `autoscaling.hpa.minReplicas`                       | Minimum number of operator replicas                                                                                                                                                                                                 | `""`                                     |
| `autoscaling.hpa.maxReplicas`                       | Maximum number of operator replicas                                                                                                                                                                                                 | `""`                                     |
| `autoscaling.hpa.targetCPU`                         | Target CPU utilization percentage                                                                                                                                                                                                   | `""`                                     |
| `autoscaling.hpa.targetMemory`                      | Target Memory utilization percentage                                                                                                                                                                                                | `""`                                     |

### MinIO;reg; Operator Traffic Exposure Parameters

| Name                               | Description                                                                                    | Value       |
| ---------------------------------- | ---------------------------------------------------------------------------------------------- | ----------- |
| `service.type`                     | MinIO;reg; Operator service type                                                               | `ClusterIP` |
| `service.nodePorts.http`           | Node port for http                                                                             | `""`        |
| `service.clusterIP`                | MinIO;reg; Operator service Cluster IP                                                         | `""`        |
| `service.loadBalancerIP`           | MinIO;reg; Operator service Load Balancer IP                                                   | `""`        |
| `service.loadBalancerSourceRanges` | MinIO;reg; Operator service Load Balancer sources                                              | `[]`        |
| `service.externalTrafficPolicy`    | MinIO;reg; Operator service external traffic policy                                            | `Cluster`   |
| `service.labels`                   | Labels for the service                                                                         | `{}`        |
| `service.annotations`              | Additional custom annotations for MinIO;reg; Operator service                                  | `{}`        |
| `service.extraPorts`               | Extra ports to expose in MinIO;reg; Operator service (normally used with the `sidecars` value) | `[]`        |
| `service.sessionAffinity`          | Control where web requests go, to the same pod or round-robin                                  | `None`      |
| `service.sessionAffinityConfig`    | Additional settings for the sessionAffinity                                                    | `{}`        |

### MinIO;reg; Operator Security Token Service (STS) Traffic Exposure Parameters

| Name                                    | Description                                                                                                                 | Value       |
| --------------------------------------- | --------------------------------------------------------------------------------------------------------------------------- | ----------- |
| `sts.enabled`                           | Enable Security Token Service (STS) in MinIO instances                                                                      | `true`      |
| `sts.service.type`                      | MinIO;reg; Operator Security Token Service (STS) service type                                                               | `ClusterIP` |
| `sts.service.nodePorts.sts`             | Node port for STS                                                                                                           | `""`        |
| `sts.service.clusterIP`                 | MinIO;reg; Operator Security Token Service (STS) service Cluster IP                                                         | `""`        |
| `sts.service.loadBalancerIP`            | MinIO;reg; Operator Security Token Service (STS) service Load Balancer IP                                                   | `""`        |
| `sts.service.loadBalancerSourceRanges`  | MinIO;reg; Operator Security Token Service (STS) service Load Balancer sources                                              | `[]`        |
| `sts.service.externalTrafficPolicy`     | MinIO;reg; Operator Security Token Service (STS) service external traffic policy                                            | `Cluster`   |
| `sts.service.labels`                    | Labels for the service                                                                                                      | `{}`        |
| `sts.service.annotations`               | Additional custom annotations for MinIO;reg; Operator Security Token Service (STS) service                                  | `{}`        |
| `sts.service.extraPorts`                | Extra ports to expose in MinIO;reg; Operator Security Token Service (STS) service (normally used with the `sidecars` value) | `[]`        |
| `sts.service.sessionAffinity`           | Control where web requests go, to the same pod or round-robin                                                               | `None`      |
| `sts.service.sessionAffinityConfig`     | Additional settings for the sessionAffinity                                                                                 | `{}`        |
| `networkPolicy.enabled`                 | Specifies whether a NetworkPolicy should be created                                                                         | `true`      |
| `networkPolicy.kubeAPIServerPorts`      | List of possible endpoints to kube-apiserver (limit to your cluster settings to increase security)                          | `[]`        |
| `networkPolicy.allowExternal`           | Don't require server label for connections                                                                                  | `true`      |
| `networkPolicy.allowExternalEgress`     | Allow the pod to access any range of port and all destinations.                                                             | `true`      |
| `networkPolicy.extraIngress`            | Add extra ingress rules to the NetworkPolicy                                                                                | `[]`        |
| `networkPolicy.extraEgress`             | Add extra ingress rules to the NetworkPolicy                                                                                | `[]`        |
| `networkPolicy.ingressNSMatchLabels`    | Labels to match to allow traffic from other namespaces                                                                      | `{}`        |
| `networkPolicy.ingressNSPodMatchLabels` | Pod labels to match to allow traffic from other namespaces                                                                  | `{}`        |

### MinIO;reg; Operator RBAC Parameters

| Name                                          | Description                                                      | Value   |
| --------------------------------------------- | ---------------------------------------------------------------- | ------- |
| `rbac.create`                                 | Specifies whether RBAC resources should be created               | `true`  |
| `rbac.rules`                                  | Custom RBAC rules to set                                         | `[]`    |
| `serviceAccount.create`                       | Specifies whether a ServiceAccount should be created             | `true`  |
| `serviceAccount.name`                         | The name of the ServiceAccount to use.                           | `""`    |
| `serviceAccount.annotations`                  | Additional Service Account annotations (evaluated as a template) | `{}`    |
| `serviceAccount.automountServiceAccountToken` | Automount service account token for the server service account   | `false` |

The above parameters map to the env variables defined in [bitnami/minio-operator](https://github.com/bitnami/containers/tree/main/bitnami/minio-operator). For more information please refer to the [bitnami/minio-operator](https://github.com/bitnami/containers/tree/main/bitnami/minio-operator) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
  --set apiserver.enabled=true \
    REGISTRY_NAME/REPOSITORY_NAME/minio-operator
```

The above command enables the MinIO&reg; Operator API Server.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml REGISTRY_NAME/REPOSITORY_NAME/minio-operator
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.
> **Tip**: You can use the default [values.yaml](https://github.com/bitnami/charts/tree/main/bitnami/minio-operator/values.yaml)

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