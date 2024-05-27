<!--- app-name: Logstash -->

# Bitnami package for Logstash

Logstash is an open source data processing engine. It ingests data from multiple sources, processes it, and sends the output to final destination in real-time. It is a core component of the ELK stack.

[Overview of Logstash](http://logstash.net)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/logstash
```

Looking to use Logstash in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the enterprise edition of Bitnami Application Catalog.

## Introduction

This chart bootstraps a [logstash](https://github.com/bitnami/containers/tree/main/bitnami/logstash) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/logstash
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

These commands deploy logstash on the Kubernetes cluster in the default configuration. The [configuration](#configuration-and-installation-details) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Configuration and installation details

### Resource requests and limits

Bitnami charts allow setting resource requests and limits for all containers inside the chart deployment. These are inside the `resources` value (check parameter table). Setting requests is essential for production workloads and these should be adapted to your specific use case.

To make this process easier, the chart contains the `resourcesPreset` values, which automatically sets the `resources` section according to different presets. Check these presets in [the bitnami/common chart](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15). However, in production workloads using `resourcePreset` is discouraged as it may not fully adapt to your specific needs. Find more information on container resource management in the [official Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).

### [Rolling vs Immutable tags](https://docs.vmware.com/en/VMware-Tanzu-Application-Catalog/services/tutorials/GUID-understand-rolling-tags-containers-index.html)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Expose the Logstash service

The service(s) created by the deployment can be exposed within or outside the cluster using any of the following approaches:

- **Ingress**: This requires an Ingress controller to be installed in the Kubernetes cluster. Set `ingress.enabled=true` to expose the corresponding service(s) through Ingress.
- **ClusterIP**: This exposes the service(s) on a cluster-internal IP address. This approach makes the corresponding service(s) reachable only from within the cluster. Set `service.type=ClusterIP` to choose this approach.
- **NodePort**: This exposes the service() on each node's IP address at a static port (the NodePort). This approach makes the corresponding service(s) reachable from outside the cluster by requesting the static port using the node's IP address, such as *NODE-IP:NODE-PORT*. Set `service.type=NodePort` to choose this approach.
- **LoadBalancer**: This exposes the service(s) externally using a cloud provider's load balancer. Set `service.type=LoadBalancer` to choose this approach.

### Use custom configuration

By default, this Helm chart provides a basic configuration for Logstash: listening to HTTP requests on port 8080 and writing them to the standard output.

This Logstash configuration can be adjusted using the *input*, *filter*, and *output* parameters, which allow specification of the input, filter and output plugins configuration respectively. In addition to these options, the chart also supports reading configuration from an external ConfigMap via the *existingConfiguration* parameter. Note that this will override the parameters discussed previously.

### Create and use multiple pipelines

The chart supports the use of [multiple pipelines](https://www.elastic.co/guide/en/logstash/master/multiple-pipelines.html) by setting the `enableMultiplePipelines` parameter to `true`.

To do this, place the `pipelines.yml` file in the `files/conf` directory, together with the rest of the desired configuration files. If the `enableMultiplePipelines` parameter is set to `true` but the `pipelines.yml` file does not exist in the mounted volume, a dummy file is created using the default configuration (a single pipeline).

The chart also supports setting an external ConfigMap with all the configuration filesvia the `existingConfiguration` parameter.

Here is an example of creating multiple pipelines using a ConfigMap:

- Create a ConfigMap with the configuration files:

  ```bash
  $ cat bye.conf
  input {
    file {
      path => "/tmp/bye"
    }
  }
  output {
    stdout { }
  }

  $ cat hello.conf
  input {
    file {
      path => "/tmp/hello"
    }
  }
  output {
    stdout { }
  }

  $ cat pipelines.yml
  - pipeline.id: hello
    path.config: "/opt/bitnami/logstash/config/hello.conf"
  - pipeline.id: bye
    path.config: "/opt/bitnami/logstash/config/bye.conf"

  $ kubectl create cm multipleconfig --from-file=pipelines.yml --from-file=hello.conf --from-file=bye.conf
  ```

- Deploy the Helm chart with the `enableMultiplePipelines` parameter:

  ```bash
  helm install logstash . --set enableMultiplePipelines=true --set existingConfiguration=multipleconfig
  ```

- Create dummy events in the tracked files and check the result in the Logstash output:

  ```bash
  kubectl exec -ti logstash-0 -- bash -c 'echo hi >> /tmp/hello'
  kubectl exec -ti logstash-0 -- bash -c 'echo bye >> /tmp/bye'
  ```

### Add extra environment variables

To add extra environment variables, use the `extraEnvVars` property.

```yaml
extraEnvVars:
  - name: ELASTICSEARCH_HOST
    value: "x.y.z"
```

To add extra environment variables from an external ConfigMap or secret, use the `extraEnvVarsCM` and `extraEnvVarsSecret` properties. Note that the secret and ConfigMap should be already available in the namespace.

```yaml
extraEnvVarsSecret: logstash-secrets
extraEnvVarsCM: logstash-configmap
```

### Set Pod affinity

This chart allows you to set custom Pod affinity using the `affinity` parameter. Find more information about Pod affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, use one of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

## Persistence

The [Bitnami Logstash](https://github.com/bitnami/containers/tree/main/bitnami/logstash) image stores the Logstash data at the `/bitnami/logstash/data` path of the container.

Persistent Volume Claims (PVCs) are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.

See the [Parameters](#parameters) section to configure the PVC or to disable persistence.

## Parameters

### Global parameters

| Name                                                  | Description                                                                                                                                                                                                                                                                                                                                                         | Value  |
| ----------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------ |
| `global.imageRegistry`                                | Global Docker image registry                                                                                                                                                                                                                                                                                                                                        | `""`   |
| `global.imagePullSecrets`                             | Global Docker registry secret names as an array                                                                                                                                                                                                                                                                                                                     | `[]`   |
| `global.storageClass`                                 | Global StorageClass for Persistent Volume(s)                                                                                                                                                                                                                                                                                                                        | `""`   |
| `global.compatibility.openshift.adaptSecurityContext` | Adapt the securityContext sections of the deployment to make them compatible with Openshift restricted-v2 SCC: remove runAsUser, runAsGroup and fsGroup and let the platform use their allowed default IDs. Possible values: auto (apply if the detected running cluster is Openshift), force (perform the adaptation always), disabled (do not perform adaptation) | `auto` |

### Common parameters

| Name                     | Description                                                                              | Value           |
| ------------------------ | ---------------------------------------------------------------------------------------- | --------------- |
| `kubeVersion`            | Force target Kubernetes version (using Helm capabilities if not set)                     | `""`            |
| `nameOverride`           | String to partially override logstash.fullname template (will maintain the release name) | `""`            |
| `fullnameOverride`       | String to fully override logstash.fullname template                                      | `""`            |
| `clusterDomain`          | Default Kubernetes cluster domain                                                        | `cluster.local` |
| `commonAnnotations`      | Annotations to add to all deployed objects                                               | `{}`            |
| `commonLabels`           | Labels to add to all deployed objects                                                    | `{}`            |
| `extraDeploy`            | Array of extra objects to deploy with the release (evaluated as a template).             | `[]`            |
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden)  | `false`         |
| `diagnosticMode.command` | Command to override all containers in the deployment                                     | `["sleep"]`     |
| `diagnosticMode.args`    | Args to override all containers in the deployment                                        | `["infinity"]`  |

### Logstash parameters

| Name                                                | Description                                                                                                                                                                                                                                           | Value                      |
| --------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------- |
| `image.registry`                                    | Logstash image registry                                                                                                                                                                                                                               | `REGISTRY_NAME`            |
| `image.repository`                                  | Logstash image repository                                                                                                                                                                                                                             | `REPOSITORY_NAME/logstash` |
| `image.digest`                                      | Logstash image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                                              | `""`                       |
| `image.pullPolicy`                                  | Logstash image pull policy                                                                                                                                                                                                                            | `IfNotPresent`             |
| `image.pullSecrets`                                 | Specify docker-registry secret names as an array                                                                                                                                                                                                      | `[]`                       |
| `image.debug`                                       | Specify if debug logs should be enabled                                                                                                                                                                                                               | `false`                    |
| `automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                                                    | `false`                    |
| `hostAliases`                                       | Add deployment host aliases                                                                                                                                                                                                                           | `[]`                       |
| `configFileName`                                    | Logstash configuration file name. It must match the name of the configuration file mounted as a configmap.                                                                                                                                            | `logstash.conf`            |
| `enableMonitoringAPI`                               | Whether to enable the Logstash Monitoring API or not  Kubernetes cluster domain                                                                                                                                                                       | `true`                     |
| `monitoringAPIPort`                                 | Logstash Monitoring API Port                                                                                                                                                                                                                          | `9600`                     |
| `extraEnvVars`                                      | Array containing extra env vars to configure Logstash                                                                                                                                                                                                 | `[]`                       |
| `extraEnvVarsSecret`                                | To add secrets to environment                                                                                                                                                                                                                         | `""`                       |
| `extraEnvVarsCM`                                    | To add configmaps to environment                                                                                                                                                                                                                      | `""`                       |
| `input`                                             | Input Plugins configuration                                                                                                                                                                                                                           | `""`                       |
| `filter`                                            | Filter Plugins configuration                                                                                                                                                                                                                          | `""`                       |
| `output`                                            | Output Plugins configuration                                                                                                                                                                                                                          | `""`                       |
| `existingConfiguration`                             | Name of existing ConfigMap object with the Logstash configuration (`input`, `filter`, and `output` will be ignored).                                                                                                                                  | `""`                       |
| `extraConfigurationFiles`                           | Extra configuration files to be added to the configuration ConfigMap and mounted at /bitnami/logstash/config. Rendered as a template.                                                                                                                 | `{}`                       |
| `enableMultiplePipelines`                           | Allows user to use multiple pipelines                                                                                                                                                                                                                 | `false`                    |
| `extraVolumes`                                      | Array to add extra volumes (evaluated as a template)                                                                                                                                                                                                  | `[]`                       |
| `extraVolumeMounts`                                 | Array to add extra mounts (normally used with extraVolumes, evaluated as a template)                                                                                                                                                                  | `[]`                       |
| `serviceAccount.create`                             | Enable creation of ServiceAccount for Logstash pods                                                                                                                                                                                                   | `true`                     |
| `serviceAccount.name`                               | The name of the service account to use. If not set and `create` is `true`, a name is generated                                                                                                                                                        | `""`                       |
| `serviceAccount.automountServiceAccountToken`       | Allows automount of ServiceAccountToken on the serviceAccount created                                                                                                                                                                                 | `false`                    |
| `serviceAccount.annotations`                        | Additional custom annotations for the ServiceAccount                                                                                                                                                                                                  | `{}`                       |
| `containerPorts`                                    | Array containing the ports to open in the Logstash container (evaluated as a template)                                                                                                                                                                | `[]`                       |
| `initContainers`                                    | Add additional init containers to the Logstash pod(s)                                                                                                                                                                                                 | `[]`                       |
| `sidecars`                                          | Add additional sidecar containers to the Logstash pod(s)                                                                                                                                                                                              | `[]`                       |
| `replicaCount`                                      | Number of Logstash replicas to deploy                                                                                                                                                                                                                 | `1`                        |
| `updateStrategy.type`                               | Update strategy type (`RollingUpdate`, or `OnDelete`)                                                                                                                                                                                                 | `RollingUpdate`            |
| `podManagementPolicy`                               | Pod management policy                                                                                                                                                                                                                                 | `OrderedReady`             |
| `podAnnotations`                                    | Pod annotations                                                                                                                                                                                                                                       | `{}`                       |
| `podLabels`                                         | Extra labels for Logstash pods                                                                                                                                                                                                                        | `{}`                       |
| `podAffinityPreset`                                 | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                                                   | `""`                       |
| `podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                                              | `soft`                     |
| `nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                                             | `""`                       |
| `nodeAffinityPreset.key`                            | Node label key to match. Ignored if `affinity` is set.                                                                                                                                                                                                | `""`                       |
| `nodeAffinityPreset.values`                         | Node label values to match. Ignored if `affinity` is set.                                                                                                                                                                                             | `[]`                       |
| `affinity`                                          | Affinity for pod assignment                                                                                                                                                                                                                           | `{}`                       |
| `nodeSelector`                                      | Node labels for pod assignment                                                                                                                                                                                                                        | `{}`                       |
| `tolerations`                                       | Tolerations for pod assignment                                                                                                                                                                                                                        | `[]`                       |
| `priorityClassName`                                 | Pod priority                                                                                                                                                                                                                                          | `""`                       |
| `schedulerName`                                     | Name of the k8s scheduler (other than default)                                                                                                                                                                                                        | `""`                       |
| `terminationGracePeriodSeconds`                     | In seconds, time the given to the Logstash pod needs to terminate gracefully                                                                                                                                                                          | `""`                       |
| `topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment                                                                                                                                                                                                        | `[]`                       |
| `podSecurityContext.enabled`                        | Enabled Logstash pods' Security Context                                                                                                                                                                                                               | `true`                     |
| `podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                                                    | `Always`                   |
| `podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                                                        | `[]`                       |
| `podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                                                           | `[]`                       |
| `podSecurityContext.fsGroup`                        | Set Logstash pod's Security Context fsGroup                                                                                                                                                                                                           | `1001`                     |
| `containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                                                                                                                                                                  | `true`                     |
| `containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                                                      | `{}`                       |
| `containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                                                                                                                                            | `1001`                     |
| `containerSecurityContext.runAsGroup`               | Set containers' Security Context runAsGroup                                                                                                                                                                                                           | `1001`                     |
| `containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                                                                                                                                                         | `true`                     |
| `containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                                                                                                                                                           | `false`                    |
| `containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                                                               | `true`                     |
| `containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                                                                                                                                             | `false`                    |
| `containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                                                    | `["ALL"]`                  |
| `containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                                                      | `RuntimeDefault`           |
| `command`                                           | Override default container command (useful when using custom images)                                                                                                                                                                                  | `[]`                       |
| `args`                                              | Override default container args (useful when using custom images)                                                                                                                                                                                     | `[]`                       |
| `lifecycleHooks`                                    | for the Logstash container(s) to automate configuration before or after startup                                                                                                                                                                       | `{}`                       |
| `resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if resources is set (resources is recommended for production).                                     | `small`                    |
| `resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                                     | `{}`                       |
| `startupProbe.enabled`                              | Enable startupProbe                                                                                                                                                                                                                                   | `false`                    |
| `startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                                                                | `60`                       |
| `startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                                                       | `10`                       |
| `startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                                                      | `5`                        |
| `startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                                                    | `6`                        |
| `startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                                                    | `1`                        |
| `livenessProbe.enabled`                             | Enable livenessProbe                                                                                                                                                                                                                                  | `true`                     |
| `livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                                                               | `60`                       |
| `livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                                                      | `10`                       |
| `livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                                                     | `5`                        |
| `livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                                                                   | `6`                        |
| `livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                                                                   | `1`                        |
| `readinessProbe.enabled`                            | Enable readinessProbe                                                                                                                                                                                                                                 | `true`                     |
| `readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                                                              | `60`                       |
| `readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                                                     | `10`                       |
| `readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                                                    | `5`                        |
| `readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                                                                  | `6`                        |
| `readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                                                                  | `1`                        |
| `customStartupProbe`                                | Custom startup probe for the Web component                                                                                                                                                                                                            | `{}`                       |
| `customLivenessProbe`                               | Custom liveness probe for the Web component                                                                                                                                                                                                           | `{}`                       |
| `customReadinessProbe`                              | Custom readiness probe for the Web component                                                                                                                                                                                                          | `{}`                       |
| `service.type`                                      | Kubernetes service type (`ClusterIP`, `NodePort`, or `LoadBalancer`)                                                                                                                                                                                  | `ClusterIP`                |
| `service.ports`                                     | Logstash service ports (evaluated as a template)                                                                                                                                                                                                      | `[]`                       |
| `service.loadBalancerIP`                            | loadBalancerIP if service type is `LoadBalancer`                                                                                                                                                                                                      | `""`                       |
| `service.loadBalancerSourceRanges`                  | Addresses that are allowed when service is LoadBalancer                                                                                                                                                                                               | `[]`                       |
| `service.externalTrafficPolicy`                     | External traffic policy, configure to Local to preserve client source IP when using an external loadBalancer                                                                                                                                          | `""`                       |
| `service.clusterIP`                                 | Static clusterIP or None for headless services                                                                                                                                                                                                        | `""`                       |
| `service.annotations`                               | Annotations for Logstash service                                                                                                                                                                                                                      | `{}`                       |
| `service.sessionAffinity`                           | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                                                                                                                                                                                  | `None`                     |
| `service.sessionAffinityConfig`                     | Additional settings for the sessionAffinity                                                                                                                                                                                                           | `{}`                       |
| `service.headless.annotations`                      | Annotations for the headless service.                                                                                                                                                                                                                 | `{}`                       |
| `networkPolicy.enabled`                             | Enable creation of NetworkPolicy resources                                                                                                                                                                                                            | `true`                     |
| `networkPolicy.allowExternal`                       | The Policy model to apply                                                                                                                                                                                                                             | `true`                     |
| `networkPolicy.allowExternalEgress`                 | Allow the pod to access any range of port and all destinations.                                                                                                                                                                                       | `true`                     |
| `networkPolicy.extraIngress`                        | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                                                          | `[]`                       |
| `networkPolicy.extraEgress`                         | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                                                          | `[]`                       |
| `networkPolicy.ingressNSMatchLabels`                | Labels to match to allow traffic from other namespaces                                                                                                                                                                                                | `{}`                       |
| `networkPolicy.ingressNSPodMatchLabels`             | Pod labels to match to allow traffic from other namespaces                                                                                                                                                                                            | `{}`                       |
| `persistence.enabled`                               | Enable Logstash data persistence using PVC                                                                                                                                                                                                            | `false`                    |
| `persistence.existingClaim`                         | A manually managed Persistent Volume and Claim                                                                                                                                                                                                        | `""`                       |
| `persistence.storageClass`                          | PVC Storage Class for Logstash data volume                                                                                                                                                                                                            | `""`                       |
| `persistence.accessModes`                           | PVC Access Mode for Logstash data volume                                                                                                                                                                                                              | `["ReadWriteOnce"]`        |
| `persistence.size`                                  | PVC Storage Request for Logstash data volume                                                                                                                                                                                                          | `2Gi`                      |
| `persistence.annotations`                           | Annotations for the PVC                                                                                                                                                                                                                               | `{}`                       |
| `persistence.mountPath`                             | Mount path of the Logstash data volume                                                                                                                                                                                                                | `/bitnami/logstash/data`   |
| `persistence.selector`                              | Selector to match an existing Persistent Volume for Logstash data PVC                                                                                                                                                                                 | `{}`                       |
| `volumePermissions.enabled`                         | Enable init container that changes the owner and group of the persistent volume(s) mountpoint to `runAsUser:fsGroup`                                                                                                                                  | `false`                    |
| `volumePermissions.securityContext.seLinuxOptions`  | Set SELinux options in container                                                                                                                                                                                                                      | `{}`                       |
| `volumePermissions.securityContext.runAsUser`       | User ID for the volumePermissions init container                                                                                                                                                                                                      | `0`                        |
| `volumePermissions.image.registry`                  | Init container volume-permissions image registry                                                                                                                                                                                                      | `REGISTRY_NAME`            |
| `volumePermissions.image.repository`                | Init container volume-permissions image repository                                                                                                                                                                                                    | `REPOSITORY_NAME/os-shell` |
| `volumePermissions.image.digest`                    | Init container volume-permissions image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                     | `""`                       |
| `volumePermissions.image.pullPolicy`                | Init container volume-permissions image pull policy                                                                                                                                                                                                   | `IfNotPresent`             |
| `volumePermissions.image.pullSecrets`               | Specify docker-registry secret names as an array                                                                                                                                                                                                      | `[]`                       |
| `volumePermissions.resourcesPreset`                 | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if volumePermissions.resources is set (volumePermissions.resources is recommended for production). | `nano`                     |
| `volumePermissions.resources`                       | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                                     | `{}`                       |
| `ingress.enabled`                                   | Enable ingress controller resource                                                                                                                                                                                                                    | `false`                    |
| `ingress.selfSigned`                                | Create a TLS secret for this ingress record using self-signed certificates generated by Helm                                                                                                                                                          | `false`                    |
| `ingress.pathType`                                  | Ingress Path type                                                                                                                                                                                                                                     | `ImplementationSpecific`   |
| `ingress.apiVersion`                                | Override API Version (automatically detected if not set)                                                                                                                                                                                              | `""`                       |
| `ingress.hostname`                                  | Default host for the ingress resource                                                                                                                                                                                                                 | `logstash.local`           |
| `ingress.path`                                      | The Path to Logstash. You may need to set this to '/*' in order to use this with ALB ingress controllers.                                                                                                                                             | `/`                        |
| `ingress.annotations`                               | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations.                                                                                                                      | `{}`                       |
| `ingress.tls`                                       | Enable TLS configuration for the hostname defined at ingress.hostname parameter                                                                                                                                                                       | `false`                    |
| `ingress.extraHosts`                                | The list of additional hostnames to be covered with this ingress record.                                                                                                                                                                              | `[]`                       |
| `ingress.extraPaths`                                | Any additional arbitrary paths that may need to be added to the ingress under the main host.                                                                                                                                                          | `[]`                       |
| `ingress.extraRules`                                | The list of additional rules to be added to this ingress record. Evaluated as a template                                                                                                                                                              | `[]`                       |
| `ingress.extraTls`                                  | The tls configuration for additional hostnames to be covered with this ingress record.                                                                                                                                                                | `[]`                       |
| `ingress.secrets`                                   | If you're providing your own certificates, please use this to add the certificates as secrets                                                                                                                                                         | `[]`                       |
| `ingress.ingressClassName`                          | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                                                                                                                                         | `""`                       |
| `pdb.create`                                        | If true, create a pod disruption budget for pods.                                                                                                                                                                                                     | `true`                     |
| `pdb.minAvailable`                                  | Minimum number / percentage of pods that should remain scheduled                                                                                                                                                                                      | `1`                        |
| `pdb.maxUnavailable`                                | Maximum number / percentage of pods that may be made unavailable                                                                                                                                                                                      | `""`                       |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
  --set enableMonitoringAPI=false oci://REGISTRY_NAME/REPOSITORY_NAME/logstash
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The above command disables the Logstash Monitoring API.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml oci://REGISTRY_NAME/REPOSITORY_NAME/logstash
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.
> **Tip**: You can use the default [values.yaml](https://github.com/bitnami/charts/tree/main/bitnami/logstash/values.yaml)

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 6.0.0

This major bump changes the following security defaults:

- `runAsGroup` is changed from `0` to `1001`
- `readOnlyRootFilesystem` is set to `true`
- `resourcesPreset` is changed from `none` to the minimum size working in our test suites (NOTE: `resourcesPreset` is not meant for production usage, but `resources` adapted to your use case).
- `global.compatibility.openshift.adaptSecurityContext` is changed from `disabled` to `auto`.

This could potentially break any customization or init scripts used in your deployment. If this is the case, change the default values to the previous ones.

### To 5.0.0

This major release is no longer contains the metrics section because the container `bitnami/logstash-exporter` has been deprecated due to the upstream project is not maintained.

### To 4.0.0

This major release updates the chart to use Logstash 8. In addition, this chart has been standardized adding missing values and renaming others, in order to get aligned with the rest of the assets in the Bitnami charts repository.

The following values have been renamed:

- `securityContext` has been splitted between `containerSecurityContext` and `podSecurityContext`.
- Liveness and readiness probes httpGet field can not be modified. For customization, use customLivenessProbe and customReadinessProbe instead.
- `lifecycle` renamed as `lifecycleHooks`.
- `service.ports` is now evaluated as a template with array structure.
- Enabling `ingress.tls` no longer auto generates certificates. Use `ingress.selfSigned` to enable the creation of autogenerated certificates.
- `podDisruptionBudget.*` renamed as `pdb.*`.

### To 3.0.0

This version standardizes the way of defining Ingress rules. When configuring a single hostname for the Ingress rule, set the `ingress.hostname` value. When defining more than one, set the `ingress.extraHosts` array. Apart from this case, no issues are expected to appear when upgrading.

### To 2.0.0

This version drops support of including files in the `files/` folder, as it was working only under certain circumstances and the chart already provides alternative mechanisms like the `input` , `output` and `filter`, the `existingConfiguration` or the `extraDeploy` values.

### To 1.2.0

This version introduces `bitnami/common`, a [library chart](https://helm.sh/docs/topics/library_charts/#helm) as a dependency. More documentation about this new utility could be found [here](https://github.com/bitnami/charts/tree/main/bitnami/common#bitnami-common-library-chart). Please, make sure that you have updated the chart dependencies before executing any upgrade.

### To 1.0.0

[On November 13, 2020, Helm v2 support formally ended](https://github.com/helm/charts#status-of-the-project). Subsequently, a major version of the chart was released to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

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