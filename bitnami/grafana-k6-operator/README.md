<!--- app-name: Grafana k6 Operator -->

# Grafana k6 Operator

Grafana k6 Operator is a Kubernetes operator that enables running distributed k6 load tests in a cluster, automating test execution and scaling for performance validation

[Overview of Grafana k6 Operator](https://k6.io/)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/grafana-k6-operator
```

Looking to use Grafana k6 Operator in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the commercial edition of the Bitnami catalog.

## Introduction

This chart bootstraps a [Grafana k6 Operator](https://github.com/bitnami/containers/tree/main/bitnami/grafana-k6-operator) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release REGISTRY_NAME/REPOSITORY_NAME/grafana-k6-operator
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The command deploys Grafana k6 Operator on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Configuration and installation details

### Resource requests and limits

Bitnami charts allow setting resource requests and limits for all containers inside the chart deployment. These are inside the `resources` value (check parameter table). Setting requests is essential for production workloads and these should be adapted to your specific use case.

To make this process easier, the chart contains the `resourcesPreset` values, which automatically sets the `resources` section according to different presets. Check these presets in [the bitnami/common chart](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15). However, in production workloads using `resourcesPreset` is discouraged as it may not fully adapt to your specific needs. Find more information on container resource management in the [official Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).

### Prometheus metrics

This chart can be integrated with Prometheus by setting `metrics.enabled` to true. This will expose the Grafana k6 Operator native Prometheus endpoint in a `metrics` service, which can be configured under the `metrics.service` section. It will have the necessary annotations to be automatically scraped by Prometheus.

It is possible to set RBAC-based authentication to this endpoint by setting `authProxy.enabled=true`, this will deploy a sidecar with `kube-rbac-proxy` and only the authorized ServiceAccounts will be able to access the metrics.

#### Prometheus requirements

It is necessary to have a working installation of Prometheus or Prometheus Operator for the integration to work. Install the [Bitnami Prometheus helm chart](https://github.com/bitnami/charts/tree/main/bitnami/prometheus) or the [Bitnami Kube Prometheus helm chart](https://github.com/bitnami/charts/tree/main/bitnami/kube-prometheus) to easily have a working Prometheus in your cluster.

#### Integration with Prometheus Operator

The chart can deploy `ServiceMonitor` objects for integration with Prometheus Operator installations. To do so, set the value `metrics.serviceMonitor.enabled=true`. Ensure that the Prometheus Operator `CustomResourceDefinitions` are installed in the cluster or it will fail with the following error:

```text
no matches for kind "ServiceMonitor" in version "monitoring.coreos.com/v1"
```

Install the [Bitnami Kube Prometheus helm chart](https://github.com/bitnami/charts/tree/main/bitnami/kube-prometheus) for having the necessary CRDs and the Prometheus Operator.

### Backup and restore

To back up and restore Helm chart deployments on Kubernetes, you need to back up the persistent volumes from the source deployment and attach them to a new deployment using [Velero](https://velero.io/), a Kubernetes backup/restore tool. Find the instructions for using Velero in [this guide](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-backup-restore-deployments-velero-index.html).

### [Rolling VS Immutable tags](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Sidecars

If additional containers are needed in the same pod as grafana-k6-operator (such as additional metrics or logging exporters), they can be defined using the `sidecars` parameter:

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

Apart from the Operator, you may want to deploy `TestRun` objects.  For covering this case, the chart allows adding the full specification of other objects using the `extraDeploy` parameter. The following example creates a `TestRun` object with a ConfigMap with the testing code:

```yaml
extraDeploy:
- apiVersion: k6.io/v1alpha1
  kind: TestRun
  metadata:
    name: testrun-sample
  spec:
    parallelism: 2
    script:
      configMap:
        name: k6-test
        file: test.js
- apiVersion: v1
  kind: ConfigMap
  metadata:
    name: k6-test
  data:
    test.js: |
      import http from 'k6/http';
      import { Rate } from 'k6/metrics';
      import { check, sleep } from 'k6';

      const failRate = new Rate('failed_requests');

      export let options = {
        stages: [
          { target: 200, duration: '30s' },
          { target: 0, duration: '30s' },
        ],
        thresholds: {
          failed_requests: ['rate<=0'],
          http_req_duration: ['p(95)<500'],
        },
      };

      export default function () {
        const result = http.get('https://quickpizza.grafana.com');
        check(result, {
          'http response status code is 200': result.status === 200,
        });
        failRate.add(result.status !== 200);
        sleep(1);
      }
```

Check the [Grafana k6 Operator official documentation](https://min.io/docs/minio/kubernetes/upstream/operations/deploy-manage-tenants.html) for the list of available objects.

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

| Name                                                | Description                                                                                                                                                                                                                         | Value                                 |
| --------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------- |
| `kubeVersion`                                       | Override Kubernetes version                                                                                                                                                                                                         | `""`                                  |
| `apiVersions`                                       | Override Kubernetes API versions reported by .Capabilities                                                                                                                                                                          | `[]`                                  |
| `nameOverride`                                      | String to partially override common.names.name                                                                                                                                                                                      | `""`                                  |
| `fullnameOverride`                                  | String to fully override common.names.fullname                                                                                                                                                                                      | `""`                                  |
| `namespaceOverride`                                 | String to fully override common.names.namespace                                                                                                                                                                                     | `""`                                  |
| `commonLabels`                                      | Labels to add to all deployed objects                                                                                                                                                                                               | `{}`                                  |
| `commonAnnotations`                                 | Annotations to add to all deployed objects                                                                                                                                                                                          | `{}`                                  |
| `clusterDomain`                                     | Kubernetes cluster domain name                                                                                                                                                                                                      | `cluster.local`                       |
| `extraDeploy`                                       | Array of extra objects to deploy with the release                                                                                                                                                                                   | `[]`                                  |
| `image.registry`                                    | Grafana k6 Operator image registry                                                                                                                                                                                                  | `REGISTRY_NAME`                       |
| `image.repository`                                  | Grafana k6 Operator image repository                                                                                                                                                                                                | `REPOSITORY_NAME/grafana-k6-operator` |
| `image.digest`                                      | Grafana k6 Operator image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag image tag (immutable tags are recommended)                                                                      | `""`                                  |
| `image.pullPolicy`                                  | Grafana k6 Operator image pull policy                                                                                                                                                                                               | `IfNotPresent`                        |
| `image.pullSecrets`                                 | Grafana k6 Operator image pull secrets                                                                                                                                                                                              | `[]`                                  |
| `starterImage.registry`                             | os-shell image registry                                                                                                                                                                                                             | `REGISTRY_NAME`                       |
| `starterImage.repository`                           | os-shell image repository                                                                                                                                                                                                           | `REPOSITORY_NAME/os-shell`            |
| `starterImage.digest`                               | os-shell image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag image tag (immutable tags are recommended)                                                                                 | `""`                                  |
| `runnerImage.registry`                              | Grafana k6 image registry                                                                                                                                                                                                           | `REGISTRY_NAME`                       |
| `runnerImage.repository`                            | Grafana k6 image repository                                                                                                                                                                                                         | `REPOSITORY_NAME/grafana-k6`          |
| `runnerImage.digest`                                | Grafana k6 image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                          | `""`                                  |
| `replicaCount`                                      | Number of Grafana k6 Operator replicas to deploy                                                                                                                                                                                    | `1`                                   |
| `containerPorts.metrics`                            | Metrics container port                                                                                                                                                                                                              | `8080`                                |
| `containerPorts.health`                             | Health container port                                                                                                                                                                                                               | `8081`                                |
| `livenessProbe.enabled`                             | Enable livenessProbe on Grafana k6 Operator containers                                                                                                                                                                              | `true`                                |
| `livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                                             | `5`                                   |
| `livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                                    | `10`                                  |
| `livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                                   | `5`                                   |
| `livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                                                 | `5`                                   |
| `livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                                                 | `1`                                   |
| `readinessProbe.enabled`                            | Enable readinessProbe on Grafana k6 Operator containers                                                                                                                                                                             | `true`                                |
| `readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                                            | `5`                                   |
| `readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                                   | `10`                                  |
| `readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                                  | `5`                                   |
| `readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                                                | `5`                                   |
| `readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                                                | `1`                                   |
| `startupProbe.enabled`                              | Enable startupProbe on Grafana k6 Operator containers                                                                                                                                                                               | `false`                               |
| `startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                                              | `5`                                   |
| `startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                                     | `10`                                  |
| `startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                                    | `5`                                   |
| `startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                                  | `5`                                   |
| `startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                                  | `1`                                   |
| `customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                                                                                                                                 | `{}`                                  |
| `customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                                                                                                                                                | `{}`                                  |
| `customStartupProbe`                                | Custom startupProbe that overrides the default one                                                                                                                                                                                  | `{}`                                  |
| `watchAllNamespaces`                                | Watch for Grafana k6 Operator resources in all namespaces                                                                                                                                                                           | `true`                                |
| `resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if operator.resources is set (operator.resources is recommended for production). | `nano`                                |
| `resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                   | `{}`                                  |
| `podSecurityContext.enabled`                        | Enabled Grafana k6 Operator pods' Security Context                                                                                                                                                                                  | `true`                                |
| `podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                                  | `Always`                              |
| `podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                                      | `[]`                                  |
| `podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                                         | `[]`                                  |
| `podSecurityContext.fsGroup`                        | Set Grafana k6 Operator pod's Security Context fsGroup                                                                                                                                                                              | `1001`                                |
| `containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                                                                                                                                                | `true`                                |
| `containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                                    | `{}`                                  |
| `containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                                                                                                                          | `1001`                                |
| `containerSecurityContext.runAsGroup`               | Set containers' Security Context runAsGroup                                                                                                                                                                                         | `1001`                                |
| `containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                                                                                                                                       | `true`                                |
| `containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                                                                                                                                         | `false`                               |
| `containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                                             | `true`                                |
| `containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                                                                                                                           | `false`                               |
| `containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                                  | `["ALL"]`                             |
| `containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                                    | `RuntimeDefault`                      |
| `command`                                           | Override default container command (useful when using custom images)                                                                                                                                                                | `[]`                                  |
| `args`                                              | Override default container args (useful when using custom images)                                                                                                                                                                   | `[]`                                  |
| `extraArgs`                                         | Add extra arguments to the default command                                                                                                                                                                                          | `[]`                                  |
| `automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                                  | `true`                                |
| `hostAliases`                                       | Grafana k6 Operator pods host aliases                                                                                                                                                                                               | `[]`                                  |
| `podLabels`                                         | Extra labels for Grafana k6 Operator pods                                                                                                                                                                                           | `{}`                                  |
| `podAnnotations`                                    | Annotations for Grafana k6 Operator pods                                                                                                                                                                                            | `{}`                                  |
| `deploymentLabels`                                  | Add extra labels to the Deployment object                                                                                                                                                                                           | `{}`                                  |
| `deploymentAnnotations`                             | Add extra annotations to the Deployment object                                                                                                                                                                                      | `{}`                                  |
| `extraContainerPorts`                               | Optionally specify extra list of additional container ports                                                                                                                                                                         | `[]`                                  |
| `podAffinityPreset`                                 | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                                 | `""`                                  |
| `podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                            | `soft`                                |
| `pdb.create`                                        | Enable/disable a Pod Disruption Budget creation                                                                                                                                                                                     | `true`                                |
| `pdb.minAvailable`                                  | Minimum number/percentage of pods that should remain scheduled                                                                                                                                                                      | `""`                                  |
| `pdb.maxUnavailable`                                | Maximum number/percentage of pods that may be made unavailable                                                                                                                                                                      | `""`                                  |
| `nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                           | `""`                                  |
| `nodeAffinityPreset.key`                            | Node label key to match. Ignored if `affinity` is set                                                                                                                                                                               | `""`                                  |
| `nodeAffinityPreset.values`                         | Node label values to match. Ignored if `affinity` is set                                                                                                                                                                            | `[]`                                  |
| `affinity`                                          | Affinity for Grafana k6 Operator pods assignment                                                                                                                                                                                    | `{}`                                  |
| `nodeSelector`                                      | Node labels for Grafana k6 Operator pods assignment                                                                                                                                                                                 | `{}`                                  |
| `tolerations`                                       | Tolerations for Grafana k6 Operator pods assignment                                                                                                                                                                                 | `[]`                                  |
| `updateStrategy.type`                               | Grafana k6 Operator statefulset strategy type                                                                                                                                                                                       | `RollingUpdate`                       |
| `priorityClassName`                                 | Grafana k6 Operator pods' priorityClassName                                                                                                                                                                                         | `""`                                  |
| `topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template                                                                                                            | `[]`                                  |
| `schedulerName`                                     | Name of the k8s scheduler (other than default) for Grafana k6 Operator pods                                                                                                                                                         | `""`                                  |
| `terminationGracePeriodSeconds`                     | Seconds Grafana k6 Operator pod needs to terminate gracefully                                                                                                                                                                       | `""`                                  |
| `lifecycleHooks`                                    | for the Grafana k6 Operator container(s) to automate configuration before or after startup                                                                                                                                          | `{}`                                  |
| `extraEnvVars`                                      | Array with extra environment variables to add to Grafana k6 Operator nodes                                                                                                                                                          | `[]`                                  |
| `extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for Grafana k6 Operator nodes                                                                                                                                                  | `""`                                  |
| `extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for Grafana k6 Operator nodes                                                                                                                                                     | `""`                                  |
| `extraVolumes`                                      | Optionally specify extra list of additional volumes for the Grafana k6 Operator pod(s)                                                                                                                                              | `[]`                                  |
| `extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the Grafana k6 Operator container(s)                                                                                                                                   | `[]`                                  |
| `sidecars`                                          | Add additional sidecar containers to the Grafana k6 Operator pod(s)                                                                                                                                                                 | `[]`                                  |
| `initContainers`                                    | Add additional init containers to the Grafana k6 Operator pod(s)                                                                                                                                                                    | `[]`                                  |
| `autoscaling.vpa.enabled`                           | Enable VPA                                                                                                                                                                                                                          | `false`                               |
| `autoscaling.vpa.annotations`                       | Annotations for VPA resource                                                                                                                                                                                                        | `{}`                                  |
| `autoscaling.vpa.controlledResources`               | VPA List of resources that the vertical pod autoscaler can control. Defaults to cpu and memory                                                                                                                                      | `[]`                                  |
| `autoscaling.vpa.maxAllowed`                        | VPA Max allowed resources for the pod                                                                                                                                                                                               | `{}`                                  |
| `autoscaling.vpa.minAllowed`                        | VPA Min allowed resources for the pod                                                                                                                                                                                               | `{}`                                  |
| `autoscaling.vpa.updatePolicy.updateMode`           | Autoscaling update policy Specifies whether recommended updates are applied when a Pod is started and whether recommended updates are applied during the life of a Pod                                                              | `Auto`                                |
| `autoscaling.hpa.enabled`                           | Enable autoscaling for operator                                                                                                                                                                                                     | `false`                               |
| `autoscaling.hpa.minReplicas`                       | Minimum number of operator replicas                                                                                                                                                                                                 | `""`                                  |
| `autoscaling.hpa.maxReplicas`                       | Maximum number of operator replicas                                                                                                                                                                                                 | `""`                                  |
| `autoscaling.hpa.targetCPU`                         | Target CPU utilization percentage                                                                                                                                                                                                   | `""`                                  |
| `autoscaling.hpa.targetMemory`                      | Target Memory utilization percentage                                                                                                                                                                                                | `""`                                  |

### Grafana k6 Operator Traffic Exposure Parameters

| Name                                    | Description                                                                                        | Value  |
| --------------------------------------- | -------------------------------------------------------------------------------------------------- | ------ |
| `networkPolicy.enabled`                 | Specifies whether a NetworkPolicy should be created                                                | `true` |
| `networkPolicy.kubeAPIServerPorts`      | List of possible endpoints to kube-apiserver (limit to your cluster settings to increase security) | `[]`   |
| `networkPolicy.allowExternal`           | Don't require server label for connections                                                         | `true` |
| `networkPolicy.allowExternalEgress`     | Allow the pod to access any range of port and all destinations.                                    | `true` |
| `networkPolicy.extraIngress`            | Add extra ingress rules to the NetworkPolicy                                                       | `[]`   |
| `networkPolicy.extraEgress`             | Add extra ingress rules to the NetworkPolicy                                                       | `[]`   |
| `networkPolicy.ingressNSMatchLabels`    | Labels to match to allow traffic from other namespaces                                             | `{}`   |
| `networkPolicy.ingressNSPodMatchLabels` | Pod labels to match to allow traffic from other namespaces                                         | `{}`   |

### Grafana k6 Operator RBAC Parameters

| Name                                          | Description                                                      | Value   |
| --------------------------------------------- | ---------------------------------------------------------------- | ------- |
| `rbac.create`                                 | Specifies whether RBAC resources should be created               | `true`  |
| `rbac.rules`                                  | Custom RBAC rules to set                                         | `[]`    |
| `serviceAccount.create`                       | Specifies whether a ServiceAccount should be created             | `true`  |
| `serviceAccount.name`                         | The name of the ServiceAccount to use.                           | `""`    |
| `serviceAccount.annotations`                  | Additional Service Account annotations (evaluated as a template) | `{}`    |
| `serviceAccount.automountServiceAccountToken` | Automount service account token for the server service account   | `false` |

### Prometheus metrics parameters

| Name                                                                  | Description                                                                                                                                                                                                                | Value                             |
| --------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------- |
| `metrics.enabled`                                                     | Enable the export of Prometheus metrics                                                                                                                                                                                    | `false`                           |
| `metrics.authProxy.enabled`                                           |                                                                                                                                                                                                                            | `false`                           |
| `metrics.authProxy.image.registry`                                    | kube-auth-proxy image registry                                                                                                                                                                                             | `REGISTRY_NAME`                   |
| `metrics.authProxy.image.repository`                                  | kube-auth-proxy image repository                                                                                                                                                                                           | `REPOSITORY_NAME/kube-auth-proxy` |
| `metrics.authProxy.image.digest`                                      | kube-auth-proxy image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                            | `""`                              |
| `metrics.authProxy.image.pullPolicy`                                  | kube-auth-proxy image pull policy                                                                                                                                                                                          | `IfNotPresent`                    |
| `metrics.authProxy.image.pullSecrets`                                 | Specify docker-registry secret names as an array                                                                                                                                                                           | `[]`                              |
| `metrics.authProxy.command`                                           | Override default container command (useful when using custom images)                                                                                                                                                       | `[]`                              |
| `metrics.authProxy.args`                                              | Override default container args (useful when using custom images)                                                                                                                                                          | `[]`                              |
| `metrics.authProxy.extraArgs`                                         | Add extra arguments to the default container args section                                                                                                                                                                  | `[]`                              |
| `metrics.authProxy.containerSecurityContext.enabled`                  | Enable Prometheus kube-auth-proxy containers' Security Context                                                                                                                                                             | `true`                            |
| `metrics.authProxy.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                           | `{}`                              |
| `metrics.authProxy.containerSecurityContext.runAsUser`                | Set Prometheus kube-auth-proxy containers' Security Context runAsUser                                                                                                                                                      | `1001`                            |
| `metrics.authProxy.containerSecurityContext.runAsGroup`               | Group ID for the Prometheus kube-auth-proxy container                                                                                                                                                                      | `1001`                            |
| `metrics.authProxy.containerSecurityContext.runAsNonRoot`             | Set Prometheus kube-auth-proxy containers' Security Context runAsNonRoot                                                                                                                                                   | `true`                            |
| `metrics.authProxy.containerSecurityContext.privileged`               | Set Prometheus kube-auth-proxy container's Security Context privileged                                                                                                                                                     | `false`                           |
| `metrics.authProxy.containerSecurityContext.allowPrivilegeEscalation` | Set Prometheus kube-auth-proxy containers' Security Context allowPrivilegeEscalation                                                                                                                                       | `false`                           |
| `metrics.authProxy.containerSecurityContext.readOnlyRootFilesystem`   | Set Prometheus kube-auth-proxy containers' Security Context readOnlyRootFilesystem                                                                                                                                         | `true`                            |
| `metrics.authProxy.containerSecurityContext.capabilities.drop`        | Set Prometheus kube-auth-proxy containers' Security Context capabilities to be dropped                                                                                                                                     | `["ALL"]`                         |
| `metrics.authProxy.containerSecurityContext.seccompProfile.type`      | Set Prometheus kube-auth-proxy container's Security Context seccomp profile                                                                                                                                                | `RuntimeDefault`                  |
| `metrics.authProxy.containerPorts.https`                              | kube-auth-proxy container port                                                                                                                                                                                             | `8443`                            |
| `metrics.authProxy.extraContainerPorts`                               | Optionally specify extra list of additional container ports                                                                                                                                                                | `[]`                              |
| `metrics.authProxy.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for kube-auth-proxy                                                                                                                                               | `[]`                              |
| `metrics.authProxy.customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                                                                                                                        | `{}`                              |
| `metrics.authProxy.customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                                                                                                                                       | `{}`                              |
| `metrics.authProxy.customStartupProbe`                                | Custom startupProbe that overrides the default one                                                                                                                                                                         | `{}`                              |
| `metrics.authProxy.lifecycleHooks`                                    | for the kube-auth-proxy containers' to automate configuration before or after startup                                                                                                                                      | `{}`                              |
| `metrics.authProxy.extraEnvVars`                                      | Array with extra environment variables to add to kube-auth-proxy containers                                                                                                                                                | `[]`                              |
| `metrics.authProxy.extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for ClickHouse Operator Metrics exporter containers                                                                                                                   | `""`                              |
| `metrics.authProxy.extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for ClickHouse Operator Metrics exporter containers                                                                                                                      | `""`                              |
| `metrics.authProxy.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, small, medium, large, xlarge, 2xlarge). This is ignored if metrics.resources is set (metrics.resources is recommended for production). | `micro`                           |
| `metrics.authProxy.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                          | `{}`                              |
| `metrics.authProxy.livenessProbe.enabled`                             | Enable livenessProbe                                                                                                                                                                                                       | `true`                            |
| `metrics.authProxy.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                                    | `60`                              |
| `metrics.authProxy.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                           | `10`                              |
| `metrics.authProxy.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                          | `30`                              |
| `metrics.authProxy.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                                        | `3`                               |
| `metrics.authProxy.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                                        | `1`                               |
| `metrics.authProxy.readinessProbe.enabled`                            | Enable readinessProbe                                                                                                                                                                                                      | `true`                            |
| `metrics.authProxy.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                                   | `30`                              |
| `metrics.authProxy.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                          | `10`                              |
| `metrics.authProxy.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                         | `30`                              |
| `metrics.authProxy.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                                       | `3`                               |
| `metrics.authProxy.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                                       | `1`                               |
| `metrics.authProxy.startupProbe.enabled`                              | Enable startupProbe                                                                                                                                                                                                        | `true`                            |
| `metrics.authProxy.startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                                     | `30`                              |
| `metrics.authProxy.startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                            | `10`                              |
| `metrics.authProxy.startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                           | `30`                              |
| `metrics.authProxy.startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                         | `3`                               |
| `metrics.authProxy.startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                         | `1`                               |
| `metrics.service.ports.metrics`                                       | kube-auth-proxy service port                                                                                                                                                                                               | `443`                             |
| `metrics.service.clusterIP`                                           | Static clusterIP or None for headless services                                                                                                                                                                             | `""`                              |
| `metrics.service.sessionAffinity`                                     | Control where client requests go, to the same pod or round-robin                                                                                                                                                           | `None`                            |
| `metrics.service.labels`                                              | labels for the metrics service                                                                                                                                                                                             | `{}`                              |
| `metrics.service.annotations`                                         | Annotations for the metrics service                                                                                                                                                                                        | `{}`                              |
| `metrics.serviceMonitor.enabled`                                      | if `true`, creates a Prometheus Operator ServiceMonitor (also requires `metrics.enabled` to be `true`)                                                                                                                     | `false`                           |
| `metrics.serviceMonitor.namespace`                                    | Namespace in which Prometheus is running                                                                                                                                                                                   | `""`                              |
| `metrics.serviceMonitor.annotations`                                  | Additional custom annotations for the ServiceMonitor                                                                                                                                                                       | `{}`                              |
| `metrics.serviceMonitor.labels`                                       | Extra labels for the ServiceMonitor                                                                                                                                                                                        | `{}`                              |
| `metrics.serviceMonitor.jobLabel`                                     | The name of the label on the target service to use as the job name in Prometheus                                                                                                                                           | `""`                              |
| `metrics.serviceMonitor.honorLabels`                                  | honorLabels chooses the metric's labels on collisions with target labels                                                                                                                                                   | `false`                           |
| `metrics.serviceMonitor.interval`                                     | Interval at which metrics should be scraped.                                                                                                                                                                               | `""`                              |
| `metrics.serviceMonitor.scrapeTimeout`                                | Timeout after which the scrape is ended                                                                                                                                                                                    | `""`                              |
| `metrics.serviceMonitor.metricRelabelings`                            | Specify additional relabeling of metrics                                                                                                                                                                                   | `[]`                              |
| `metrics.serviceMonitor.relabelings`                                  | Specify general relabeling                                                                                                                                                                                                 | `[]`                              |
| `metrics.serviceMonitor.selector`                                     | Prometheus instance selector labels                                                                                                                                                                                        | `{}`                              |

The above parameters map to the env variables defined in [bitnami/grafana-k6-operator](https://github.com/bitnami/containers/tree/main/bitnami/grafana-k6-operator). For more information please refer to the [bitnami/grafana-k6-operator](https://github.com/bitnami/containers/tree/main/bitnami/grafana-k6-operator) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
  --set apiserver.enabled=true \
    REGISTRY_NAME/REPOSITORY_NAME/grafana-k6-operator
```

The above command enables the Grafana k6 Operator API Server.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml REGISTRY_NAME/REPOSITORY_NAME/grafana-k6-operator
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.
> **Tip**: You can use the default [values.yaml](https://github.com/bitnami/charts/tree/main/bitnami/grafana-k6-operator/values.yaml)

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