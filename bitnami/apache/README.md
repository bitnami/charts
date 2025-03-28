<!--- app-name: Apache -->

# Bitnami package for Apache

Apache HTTP Server is an open-source HTTP server. The goal of this project is to provide a secure, efficient and extensible server that provides HTTP services in sync with the current HTTP standards.

[Overview of Apache](https://httpd.apache.org/)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/apache
```

Looking to use Apache in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the commercial edition of the Bitnami catalog.

## Introduction

Bitnami charts for Helm are carefully engineered, actively maintained and are the quickest and easiest way to deploy containers on a Kubernetes cluster that are ready to handle production workloads.

This chart bootstraps a [Apache](https://github.com/bitnami/containers/tree/main/bitnami/apache) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

The Apache HTTP Server ("httpd") was launched in 1995 and it has been the most popular web server on the Internet since April 1996. It has celebrated its 20th birthday as a project in February 2015.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/apache
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

These commands deploy Apache on the Kubernetes cluster in the default configuration.

> **Tip**: List all releases using `helm list`

## Configuration and installation details

### Resource requests and limits

Bitnami charts allow setting resource requests and limits for all containers inside the chart deployment. These are inside the `resources` value (check parameter table). Setting requests is essential for production workloads and these should be adapted to your specific use case.

To make this process easier, the chart contains the `resourcesPreset` values, which automatically sets the `resources` section according to different presets. Check these presets in [the bitnami/common chart](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15). However, in production workloads using `resourcesPreset` is discouraged as it may not fully adapt to your specific needs. Find more information on container resource management in the [official Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).

### [Rolling VS Immutable tags](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Backup and restore

To back up and restore Helm chart deployments on Kubernetes, you need to back up the persistent volumes from the source deployment and attach them to a new deployment using [Velero](https://velero.io/), a Kubernetes backup/restore tool. Find the instructions for using Velero in [this guide](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-backup-restore-deployments-velero-index.html).

### Deploying a custom web application

The Apache chart allows you to deploy a custom web application using one of the following methods:

- Cloning from a git repository: Set `cloneHtdocsFromGit.enabled` to `true` and set the repository and branch using the `cloneHtdocsFromGit.repository` and  `cloneHtdocsFromGit.branch` parameters. A sidecar will also pull the latest changes in an interval set by `cloneHtdocsFromGit.interval`.
- Providing a ConfigMap: Set the `htdocsConfigMap` value to mount a ConfigMap in the Apache htdocs folder.
- Using an existing PVC: Set the `htdocsPVC` value to mount an PersistentVolumeClaim with the web application content.

Here is an example of deploying a web application from a Git repository using the first method:

```text
cloneHtdocsFromGit.enabled=true
cloneHtdocsFromGit.repository=https://github.com/mdn/beginner-html-site-styled.git
cloneHtdocsFromGit.branch=master
```

To use a custom `httpd.conf` file, mount it using the `httpdConfConfigMap` parameter, which references a Kubernetes ConfigMap with the contents of the `httpd.conf` file. Alternatively, copy the `httpd.conf` file to `files/httpd.conf` in the current working directory to mount it in the container.

To mount different virtual host configurations, use the `vhostsConfigMap` value. This is a pointer to a Kubernetes ConfigMap with the desired Apache virtual host configurations. You can also copy the virtual host configurations under the `files/vhosts/` directory in your current working directory to mount them as a ConfigMap in the container.

### Setting Pod's affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod affinity in the [Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use  the preset configurations for pod affinity, pod anti-affinity, and node affinity available in the [bitnami/common](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

### Prometheus metrics

This chart can be integrated with Prometheus by setting `metrics.enabled` to `true`. This will deploy a sidecar container with [apache-exporter](https://github.com/Lusitaniae/apache_exporter) in all pods and a `metrics` service, which can be configured under the `metrics.service` section. This `metrics` service will have the necessary annotations to be automatically scraped by Prometheus.

#### Prometheus requirements

It is necessary to have a working installation of Prometheus or Prometheus Operator for the integration to work. Install the [Bitnami Prometheus helm chart](https://github.com/bitnami/charts/tree/main/bitnami/prometheus) or the [Bitnami Kube Prometheus helm chart](https://github.com/bitnami/charts/tree/main/bitnami/kube-prometheus) to easily have a working Prometheus in your cluster.

#### Integration with Prometheus Operator

The chart can deploy `ServiceMonitor` objects for integration with Prometheus Operator installations. To do so, set the value `metrics.serviceMonitor.enabled=true`. Ensure that the Prometheus Operator `CustomResourceDefinitions` are installed in the cluster or it will fail with the following error:

```text
no matches for kind "ServiceMonitor" in version "monitoring.coreos.com/v1"
```

Install the [Bitnami Kube Prometheus helm chart](https://github.com/bitnami/charts/tree/main/bitnami/kube-prometheus) for having the necessary CRDs and the Prometheus Operator.

## Parameters

### Global parameters

| Name                                                  | Description                                                                                                                                                                                                                                                                                                                                                         | Value   |
| ----------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `global.imageRegistry`                                | Global Docker image registry                                                                                                                                                                                                                                                                                                                                        | `""`    |
| `global.imagePullSecrets`                             | Global Docker registry secret names as an array                                                                                                                                                                                                                                                                                                                     | `[]`    |
| `global.defaultStorageClass`                          | Global default StorageClass for Persistent Volume(s)                                                                                                                                                                                                                                                                                                                | `""`    |
| `global.storageClass`                                 | DEPRECATED: use global.defaultStorageClass instead                                                                                                                                                                                                                                                                                                                  | `""`    |
| `global.compatibility.openshift.adaptSecurityContext` | Adapt the securityContext sections of the deployment to make them compatible with Openshift restricted-v2 SCC: remove runAsUser, runAsGroup and fsGroup and let the platform use their allowed default IDs. Possible values: auto (apply if the detected running cluster is Openshift), force (perform the adaptation always), disabled (do not perform adaptation) | `auto`  |
| `global.security.allowInsecureImages`                 | By default, this chart verifies that the original container images that were designed, tested, and validated are used. This option makes the chart skip the verification step and proceed                                                                                                                                                                           | `false` |

### Common parameters

| Name                | Description                                        | Value |
| ------------------- | -------------------------------------------------- | ----- |
| `kubeVersion`       | Override Kubernetes version                        | `""`  |
| `nameOverride`      | String to partially override common.names.fullname | `""`  |
| `fullnameOverride`  | String to fully override common.names.fullname     | `""`  |
| `commonLabels`      | Labels to add to all deployed objects              | `{}`  |
| `commonAnnotations` | Annotations to add to all deployed objects         | `{}`  |
| `extraDeploy`       | Array of extra objects to deploy with the release  | `[]`  |

### Apache parameters

| Name                                                | Description                                                                                                                                                                                                                                             | Value                    |
| --------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `image.registry`                                    | Apache image registry                                                                                                                                                                                                                                   | `REGISTRY_NAME`          |
| `image.repository`                                  | Apache image repository                                                                                                                                                                                                                                 | `REPOSITORY_NAME/apache` |
| `image.digest`                                      | Apache image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                                                  | `""`                     |
| `image.pullPolicy`                                  | Apache image pull policy                                                                                                                                                                                                                                | `IfNotPresent`           |
| `image.pullSecrets`                                 | Apache image pull secrets                                                                                                                                                                                                                               | `[]`                     |
| `image.debug`                                       | Enable image debug mode                                                                                                                                                                                                                                 | `false`                  |
| `git.registry`                                      | Git image registry                                                                                                                                                                                                                                      | `REGISTRY_NAME`          |
| `git.repository`                                    | Git image name                                                                                                                                                                                                                                          | `REPOSITORY_NAME/git`    |
| `git.digest`                                        | Git image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                                                     | `""`                     |
| `git.pullPolicy`                                    | Git image pull policy                                                                                                                                                                                                                                   | `IfNotPresent`           |
| `git.pullSecrets`                                   | Specify docker-registry secret names as an array                                                                                                                                                                                                        | `[]`                     |
| `replicaCount`                                      | Number of replicas of the Apache deployment                                                                                                                                                                                                             | `1`                      |
| `revisionHistoryLimit`                              | The number of old history to retain to allow rollback                                                                                                                                                                                                   | `10`                     |
| `podAffinityPreset`                                 | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                                                     | `""`                     |
| `podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                                                | `soft`                   |
| `nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                                               | `""`                     |
| `nodeAffinityPreset.key`                            | Node label key to match. Ignored if `affinity` is set                                                                                                                                                                                                   | `""`                     |
| `nodeAffinityPreset.values`                         | Node label values to match. Ignored if `affinity` is set                                                                                                                                                                                                | `[]`                     |
| `affinity`                                          | Affinity for pod assignment                                                                                                                                                                                                                             | `{}`                     |
| `nodeSelector`                                      | Node labels for pod assignment                                                                                                                                                                                                                          | `{}`                     |
| `tolerations`                                       | Tolerations for pod assignment                                                                                                                                                                                                                          | `[]`                     |
| `topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template                                                                                                                                | `[]`                     |
| `extraPodSpec`                                      | Optionally specify extra PodSpec                                                                                                                                                                                                                        | `{}`                     |
| `cloneHtdocsFromGit.enabled`                        | Get the server static content from a git repository                                                                                                                                                                                                     | `false`                  |
| `cloneHtdocsFromGit.repository`                     | Repository to clone static content from                                                                                                                                                                                                                 | `""`                     |
| `cloneHtdocsFromGit.branch`                         | Branch inside the git repository                                                                                                                                                                                                                        | `""`                     |
| `cloneHtdocsFromGit.enableAutoRefresh`              | Enables an automatic git pull with a sidecar container                                                                                                                                                                                                  | `true`                   |
| `cloneHtdocsFromGit.interval`                       | Interval for sidecar container pull from the repository                                                                                                                                                                                                 | `60`                     |
| `cloneHtdocsFromGit.resourcesPreset`                | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if cloneHtdocsFromGit.resources is set (cloneHtdocsFromGit.resources is recommended for production). | `nano`                   |
| `cloneHtdocsFromGit.resources`                      | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                                       | `{}`                     |
| `cloneHtdocsFromGit.extraVolumeMounts`              | Add extra volume mounts for the GIT containers                                                                                                                                                                                                          | `[]`                     |
| `htdocsConfigMap`                                   | Name of a config map with the server static content                                                                                                                                                                                                     | `""`                     |
| `htdocsPVC`                                         | Name of a PVC with the server static content                                                                                                                                                                                                            | `""`                     |
| `vhostsConfigMap`                                   | Name of a config map with the virtual hosts content                                                                                                                                                                                                     | `""`                     |
| `httpdConfConfigMap`                                | Name of a config map with the httpd.conf file contents                                                                                                                                                                                                  | `""`                     |
| `podLabels`                                         | Extra labels for Apache pods                                                                                                                                                                                                                            | `{}`                     |
| `podAnnotations`                                    | Pod annotations                                                                                                                                                                                                                                         | `{}`                     |
| `automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                                                      | `false`                  |
| `hostAliases`                                       | Add deployment host aliases                                                                                                                                                                                                                             | `[]`                     |
| `priorityClassName`                                 | Apache Server pods' priorityClassName                                                                                                                                                                                                                   | `""`                     |
| `schedulerName`                                     | Name of the k8s scheduler (other than default)                                                                                                                                                                                                          | `""`                     |
| `podSecurityContext.enabled`                        | Enabled Apache Server pods' Security Context                                                                                                                                                                                                            | `true`                   |
| `podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                                                      | `Always`                 |
| `podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                                                          | `[]`                     |
| `podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                                                             | `[]`                     |
| `podSecurityContext.fsGroup`                        | Set Apache Server pod's Security Context fsGroup                                                                                                                                                                                                        | `1001`                   |
| `containerSecurityContext.enabled`                  | Enabled Apache Server containers' Security Context                                                                                                                                                                                                      | `true`                   |
| `containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                                                        | `{}`                     |
| `containerSecurityContext.runAsUser`                | Set Apache Server containers' Security Context runAsUser                                                                                                                                                                                                | `1001`                   |
| `containerSecurityContext.runAsGroup`               | Set Apache Server containers' Security Context runAsGroup                                                                                                                                                                                               | `1001`                   |
| `containerSecurityContext.runAsNonRoot`             | Set Controller container's Security Context runAsNonRoot                                                                                                                                                                                                | `true`                   |
| `containerSecurityContext.privileged`               | Set primary container's Security Context privileged                                                                                                                                                                                                     | `false`                  |
| `containerSecurityContext.allowPrivilegeEscalation` | Set primary container's Security Context allowPrivilegeEscalation                                                                                                                                                                                       | `false`                  |
| `containerSecurityContext.readOnlyRootFilesystem`   | Set primary container's Security Context readOnlyRootFilesystem                                                                                                                                                                                         | `true`                   |
| `containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                                                      | `["ALL"]`                |
| `containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                                                        | `RuntimeDefault`         |
| `command`                                           | Override default container command (useful when using custom images)                                                                                                                                                                                    | `[]`                     |
| `args`                                              | Override default container args (useful when using custom images)                                                                                                                                                                                       | `[]`                     |
| `lifecycleHooks`                                    | for the Apache server container(s) to automate configuration before or after startup                                                                                                                                                                    | `{}`                     |
| `resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if resources is set (resources is recommended for production).                                       | `nano`                   |
| `resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                                       | `{}`                     |
| `startupProbe.enabled`                              | Enable startupProbe                                                                                                                                                                                                                                     | `false`                  |
| `startupProbe.path`                                 | Path to access on the HTTP server                                                                                                                                                                                                                       | `/`                      |
| `startupProbe.port`                                 | Port for startupProbe                                                                                                                                                                                                                                   | `http`                   |
| `startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                                                                  | `180`                    |
| `startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                                                         | `20`                     |
| `startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                                                        | `5`                      |
| `startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                                                      | `6`                      |
| `startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                                                      | `1`                      |
| `livenessProbe.enabled`                             | Enable liveness probe                                                                                                                                                                                                                                   | `true`                   |
| `livenessProbe.port`                                | Port for livenessProbe                                                                                                                                                                                                                                  | `http`                   |
| `livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                                                                 | `180`                    |
| `livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                                                        | `20`                     |
| `livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                                                       | `5`                      |
| `livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                                                                     | `6`                      |
| `livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                                                                     | `1`                      |
| `readinessProbe.enabled`                            | Enable readiness probe                                                                                                                                                                                                                                  | `true`                   |
| `readinessProbe.path`                               | Path to access on the HTTP server                                                                                                                                                                                                                       | `/`                      |
| `readinessProbe.port`                               | Port for readinessProbe                                                                                                                                                                                                                                 | `http`                   |
| `readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                                                                | `30`                     |
| `readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                                                       | `10`                     |
| `readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                                                      | `5`                      |
| `readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                                                                    | `6`                      |
| `readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                                                                    | `1`                      |
| `customStartupProbe`                                | Custom liveness probe for the Web component                                                                                                                                                                                                             | `{}`                     |
| `customLivenessProbe`                               | Custom liveness probe for the Web component                                                                                                                                                                                                             | `{}`                     |
| `customReadinessProbe`                              | Custom rediness probe for the Web component                                                                                                                                                                                                             | `{}`                     |
| `extraVolumes`                                      | Array to add extra volumes (evaluated as a template)                                                                                                                                                                                                    | `[]`                     |
| `extraVolumeMounts`                                 | Array to add extra mounts (normally used with extraVolumes, evaluated as a template)                                                                                                                                                                    | `[]`                     |
| `extraEnvVars`                                      | Array to add extra environment variables                                                                                                                                                                                                                | `[]`                     |
| `extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for Apache server nodes                                                                                                                                                                            | `""`                     |
| `extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for Apache server nodes                                                                                                                                                                               | `""`                     |
| `containerPorts.http`                               | Apache server HTTP container port                                                                                                                                                                                                                       | `8080`                   |
| `containerPorts.https`                              | Apache server HTTPS container port                                                                                                                                                                                                                      | `8443`                   |
| `initContainers`                                    | Add additional init containers to the Apache pods                                                                                                                                                                                                       | `[]`                     |
| `sidecars`                                          | Add additional sidecar containers to the Apache pods                                                                                                                                                                                                    | `[]`                     |
| `updateStrategy.type`                               | Apache Server deployment strategy type.                                                                                                                                                                                                                 | `RollingUpdate`          |

### Other Parameters

| Name                       | Description                                                    | Value   |
| -------------------------- | -------------------------------------------------------------- | ------- |
| `pdb.create`               | Enable a Pod Disruption Budget creation                        | `true`  |
| `pdb.minAvailable`         | Minimum number/percentage of pods that should remain scheduled | `""`    |
| `pdb.maxUnavailable`       | Maximum number/percentage of pods that may be made unavailable | `""`    |
| `autoscaling.enabled`      | Enable Horizontal POD autoscaling for Apache                   | `false` |
| `autoscaling.minReplicas`  | Minimum number of Apache replicas                              | `1`     |
| `autoscaling.maxReplicas`  | Maximum number of Apache replicas                              | `11`    |
| `autoscaling.targetCPU`    | Target CPU utilization percentage                              | `50`    |
| `autoscaling.targetMemory` | Target Memory utilization percentage                           | `50`    |

### Traffic Exposure Parameters

| Name                                    | Description                                                                                                                      | Value                    |
| --------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `service.type`                          | Apache Service type                                                                                                              | `LoadBalancer`           |
| `service.ports.http`                    | Apache service HTTP port                                                                                                         | `80`                     |
| `service.ports.https`                   | Apache service HTTPS port                                                                                                        | `443`                    |
| `service.nodePorts.http`                | Node port for HTTP                                                                                                               | `""`                     |
| `service.nodePorts.https`               | Node port for HTTPS                                                                                                              | `""`                     |
| `service.clusterIP`                     | Apache service Cluster IP                                                                                                        | `""`                     |
| `service.loadBalancerIP`                | Apache service Load Balancer IP                                                                                                  | `""`                     |
| `service.loadBalancerSourceRanges`      | Apache service Load Balancer sources                                                                                             | `[]`                     |
| `service.annotations`                   | Additional custom annotations for Apache service                                                                                 | `{}`                     |
| `service.externalTrafficPolicy`         | Apache service external traffic policy                                                                                           | `Cluster`                |
| `service.extraPorts`                    | Extra ports to expose (normally used with the `sidecar` value)                                                                   | `[]`                     |
| `service.sessionAffinity`               | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                                                             | `None`                   |
| `service.sessionAffinityConfig`         | Additional settings for the sessionAffinity                                                                                      | `{}`                     |
| `networkPolicy.enabled`                 | Specifies whether a NetworkPolicy should be created                                                                              | `true`                   |
| `networkPolicy.allowExternal`           | Don't require server label for connections                                                                                       | `true`                   |
| `networkPolicy.allowExternalEgress`     | Allow the pod to access any range of port and all destinations.                                                                  | `true`                   |
| `networkPolicy.extraIngress`            | Add extra ingress rules to the NetworkPolicy                                                                                     | `[]`                     |
| `networkPolicy.extraEgress`             | Add extra ingress rules to the NetworkPolicy (ignored if allowExternalEgress=true)                                               | `[]`                     |
| `networkPolicy.ingressNSMatchLabels`    | Labels to match to allow traffic from other namespaces                                                                           | `{}`                     |
| `networkPolicy.ingressNSPodMatchLabels` | Pod labels to match to allow traffic from other namespaces                                                                       | `{}`                     |
| `ingress.enabled`                       | Enable ingress record generation for Apache                                                                                      | `false`                  |
| `ingress.selfSigned`                    | Create a TLS secret for this ingress record using self-signed certificates generated by Helm                                     | `false`                  |
| `ingress.pathType`                      | Ingress path type                                                                                                                | `ImplementationSpecific` |
| `ingress.apiVersion`                    | Force Ingress API version (automatically detected if not set)                                                                    | `""`                     |
| `ingress.ingressClassName`              | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                    | `""`                     |
| `ingress.hostname`                      | Default host for the ingress record                                                                                              | `example.local`          |
| `ingress.path`                          | Default path for the ingress record                                                                                              | `/`                      |
| `ingress.annotations`                   | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                     |
| `ingress.tls`                           | Enable TLS configuration for the host defined at `ingress.hostname` parameter                                                    | `false`                  |
| `ingress.extraHosts`                    | An array with additional hostname(s) to be covered with the ingress record                                                       | `[]`                     |
| `ingress.extraPaths`                    | An array with additional arbitrary paths that may need to be added to the ingress under the main host                            | `[]`                     |
| `ingress.extraTls`                      | TLS configuration for additional hostname(s) to be covered with this ingress record                                              | `[]`                     |
| `ingress.secrets`                       | Custom TLS certificates as secrets                                                                                               | `[]`                     |
| `ingress.extraRules`                    | Additional rules to be covered with this ingress record                                                                          | `[]`                     |

### Metrics Parameters

| Name                                          | Description                                                                                                                                                                                                                       | Value                             |
| --------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------- |
| `metrics.enabled`                             | Start a sidecar prometheus exporter to expose Apache metrics                                                                                                                                                                      | `false`                           |
| `metrics.image.registry`                      | Apache Exporter image registry                                                                                                                                                                                                    | `REGISTRY_NAME`                   |
| `metrics.image.repository`                    | Apache Exporter image repository                                                                                                                                                                                                  | `REPOSITORY_NAME/apache-exporter` |
| `metrics.image.digest`                        | Apache Exporter image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                   | `""`                              |
| `metrics.image.pullPolicy`                    | Apache Exporter image pull policy                                                                                                                                                                                                 | `IfNotPresent`                    |
| `metrics.image.pullSecrets`                   | Apache Exporter image pull secrets                                                                                                                                                                                                | `[]`                              |
| `metrics.image.debug`                         | Apache Exporter image debug mode                                                                                                                                                                                                  | `false`                           |
| `metrics.podAnnotations`                      | Additional custom annotations for Apache exporter service                                                                                                                                                                         | `{}`                              |
| `metrics.resourcesPreset`                     | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if metrics.resources is set (metrics.resources is recommended for production). | `none`                            |
| `metrics.resources`                           | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                 | `{}`                              |
| `metrics.containerPort`                       | Apache Prometheus Exporter container port                                                                                                                                                                                         | `9141`                            |
| `metrics.service.port`                        | Metrics service port                                                                                                                                                                                                              | `9117`                            |
| `metrics.service.annotations`                 | Additional custom annotations for Metrics service                                                                                                                                                                                 | `{}`                              |
| `metrics.serviceMonitor.enabled`              | if `true`, creates a Prometheus Operator PodMonitor (also requires `metrics.enabled` to be `true`)                                                                                                                                | `false`                           |
| `metrics.serviceMonitor.namespace`            | Namespace for the PodMonitor Resource (defaults to the Release Namespace)                                                                                                                                                         | `""`                              |
| `metrics.serviceMonitor.interval`             | Interval at which metrics should be scraped.                                                                                                                                                                                      | `""`                              |
| `metrics.serviceMonitor.scrapeTimeout`        | Timeout after which the scrape is ended                                                                                                                                                                                           | `""`                              |
| `metrics.serviceMonitor.labels`               | Labels that can be used so PodMonitor will be discovered by Prometheus                                                                                                                                                            | `{}`                              |
| `metrics.serviceMonitor.relabelings`          | RelabelConfigs to apply to samples before scraping                                                                                                                                                                                | `[]`                              |
| `metrics.serviceMonitor.metricRelabelings`    | MetricRelabelConfigs to apply to samples before ingestion                                                                                                                                                                         | `[]`                              |
| `metrics.prometheusRule.enabled`              | if `true`, creates a Prometheus Operator PrometheusRule (also requires `metrics.enabled` to be `true` and `metrics.prometheusRule.rules`)                                                                                         | `false`                           |
| `metrics.prometheusRule.namespace`            | Namespace for the PrometheusRule Resource (defaults to the Release Namespace)                                                                                                                                                     | `""`                              |
| `metrics.prometheusRule.labels`               | Labels that can be used so PrometheusRule will be discovered by Prometheus                                                                                                                                                        | `{}`                              |
| `metrics.prometheusRule.rules`                | Prometheus Rule definitions                                                                                                                                                                                                       | `[]`                              |
| `serviceAccount.create`                       | Enable creation of ServiceAccount for Apache pod                                                                                                                                                                                  | `true`                            |
| `serviceAccount.name`                         | The name of the ServiceAccount to use.                                                                                                                                                                                            | `""`                              |
| `serviceAccount.automountServiceAccountToken` | Allows auto mount of ServiceAccountToken on the serviceAccount created                                                                                                                                                            | `false`                           |
| `serviceAccount.annotations`                  | Additional custom annotations for the ServiceAccount                                                                                                                                                                              | `{}`                              |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
  --set imagePullPolicy=Always \
    oci://REGISTRY_NAME/REPOSITORY_NAME/apache
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The above command sets the `imagePullPolicy` to `Always`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml oci://REGISTRY_NAME/REPOSITORY_NAME/apache
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.
> **Tip**: You can use the default [values.yaml](https://github.com/bitnami/charts/tree/main/bitnami/apache/values.yaml)

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 11.3.0

Starting from this minor version, the Bitnami Airflow chart verifies that the original container images that were designed, tested, and validated are used.
This container image verification can be skipped by setting the global parameter `global.security.allowInsecureImages` to `true`. Further information can be obtained at [this GitHub issue](https://github.com/bitnami/charts/issues/30850).

### To 11.0.0

This major bump changes the following security defaults:

- `runAsGroup` is changed from `0` to `1001`
- `readOnlyRootFilesystem` is set to `true`
- `resourcesPreset` is changed from `none` to the minimum size working in our test suites (NOTE: `resourcesPreset` is not meant for production usage, but `resources` adapted to your use case).
- `global.compatibility.openshift.adaptSecurityContext` is changed from `disabled` to `auto`.

This could potentially break any customization or init scripts used in your deployment. If this is the case, change the default values to the previous ones.

### To 10.0.0

This major release standardizes the input values and features for the ingress object. Refer to [this section](#traffic-exposure-parameters) for the complete list of parameters accepted.

### To 9.0.0

This major release renames several values in this chart and adds missing features, in order to be inline with the rest of assets in the Bitnami charts repository.

Affected values:

- `service.port` was deprecated, we recommend using `service.ports.http` instead.
- `service.httpsPort` was deprecated, we recommend using `service.ports.https` instead.
- `ingress.tls` is no longer evaluated as a template.

### To 8.0.0

[On November 13, 2020, Helm v2 support formally ended](https://github.com/helm/charts#status-of-the-project). This major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

### To 7.4.0

This version introduces `bitnami/common`, a [library chart](https://helm.sh/docs/topics/library_charts/#helm) as a dependency. More documentation about this new utility could be found [here](https://github.com/bitnami/charts/tree/main/bitnami/common#bitnami-common-library-chart). Please, make sure that you have updated the chart dependencies before executing any upgrade.

### To 7.0.0

This release updates the Bitnami Apache container to `2.4.41-debian-9-r40`, which is based on Bash instead of Node.js.

### To 6.0.0

This release allows you to use your custom static application. In order to do so, check [this section](#deploying-a-custom-web-application).

### To 2.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 2.0.0. The following example assumes that the release name is apache:

```console
kubectl patch deployment apache --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
```

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