<!--- app-name: Sealed Secrets -->

# Sealed Secrets packaged by Bitnami

Sealed Secrets are "one-way" encrypted K8s Secrets that can be created by anyone, but can only be decrypted by the controller running in the target cluster recovering the original object.

[Overview of Sealed Secrets](https://github.com/bitnami-labs/sealed-secrets)


                           
## TL;DR

```console
$ helm repo add my-repo https://charts.bitnami.com/bitnami
$ helm install my-release my-repo/sealed-secrets
```

## Introduction

Bitnami charts for Helm are carefully engineered, actively maintained and are the quickest and easiest way to deploy containers on a Kubernetes cluster that are ready to handle production workloads.

This chart bootstraps a [Sealed Secret controller](https://github.com/bitnami-labs/sealed-secrets) Deployment in [Kubernetes](http://kubernetes.io) using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.16+
- Helm 3.1.0

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release my-repo/sealed-secrets
```

The command deploys the Sealed Secrets controller on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

### Global parameters

| Name                      | Description                                     | Value |
| ------------------------- | ----------------------------------------------- | ----- |
| `global.imageRegistry`    | Global Docker image registry                    | `""`  |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]`  |
| `global.storageClass`     | Global StorageClass for Persistent Volume(s)    | `""`  |


### Common parameters

| Name                | Description                                        | Value           |
| ------------------- | -------------------------------------------------- | --------------- |
| `kubeVersion`       | Override Kubernetes version                        | `""`            |
| `nameOverride`      | String to partially override common.names.fullname | `""`            |
| `fullnameOverride`  | String to fully override common.names.fullname     | `""`            |
| `namespaceOverride` | String to fully override common.names.namespace    | `""`            |
| `commonLabels`      | Labels to add to all deployed objects              | `{}`            |
| `commonAnnotations` | Annotations to add to all deployed objects         | `{}`            |
| `clusterDomain`     | Kubernetes cluster domain name                     | `cluster.local` |
| `extraDeploy`       | Array of extra objects to deploy with the release  | `[]`            |


### Sealed Secrets Parameters

| Name                                                | Description                                                                                                              | Value                    |
| --------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------ | ------------------------ |
| `image.registry`                                    | Sealed Secrets image registry                                                                                            | `docker.io`              |
| `image.repository`                                  | Sealed Secrets image repository                                                                                          | `bitnami/sealed-secrets` |
| `image.tag`                                         | Sealed Secrets image tag (immutable tags are recommended)                                                                | `0.19.2-scratch-r0`      |
| `image.digest`                                      | Sealed Secrets image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag           | `""`                     |
| `image.pullPolicy`                                  | Sealed Secrets image pull policy                                                                                         | `IfNotPresent`           |
| `image.pullSecrets`                                 | Sealed Secrets image pull secrets                                                                                        | `[]`                     |
| `image.debug`                                       | Enable Sealed Secrets image debug mode                                                                                   | `false`                  |
| `command`                                           | Override default container command (useful when using custom images)                                                     | `[]`                     |
| `commandArgs`                                       | Additional args (doesn't override the default ones)                                                                      | `[]`                     |
| `args`                                              | Override default container args (useful when using custom images)                                                        | `[]`                     |
| `containerPorts.http`                               | Controller HTTP container port to open                                                                                   | `8080`                   |
| `resources.limits`                                  | The resources limits for the Sealed Secret containers                                                                    | `{}`                     |
| `resources.requests`                                | The requested resources for the Sealed Secret containers                                                                 | `{}`                     |
| `livenessProbe.enabled`                             | Enable livenessProbe on Sealed Secret containers                                                                         | `true`                   |
| `livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                  | `5`                      |
| `livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                         | `10`                     |
| `livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                        | `1`                      |
| `livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                      | `3`                      |
| `livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                      | `1`                      |
| `readinessProbe.enabled`                            | Enable readinessProbe on Sealed Secret containers                                                                        | `true`                   |
| `readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                 | `5`                      |
| `readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                        | `10`                     |
| `readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                       | `1`                      |
| `readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                     | `3`                      |
| `readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                     | `1`                      |
| `startupProbe.enabled`                              | Enable startupProbe on Sealed Secret containers                                                                          | `false`                  |
| `startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                   | `10`                     |
| `startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                          | `10`                     |
| `startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                         | `1`                      |
| `startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                       | `15`                     |
| `startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                       | `1`                      |
| `customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                      | `{}`                     |
| `customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                                     | `{}`                     |
| `customStartupProbe`                                | Custom startupProbe that overrides the default one                                                                       | `{}`                     |
| `podSecurityContext.enabled`                        | Enabled Sealed Secret pods' Security Context                                                                             | `true`                   |
| `podSecurityContext.fsGroup`                        | Set Sealed Secret pod's Security Context fsGroup                                                                         | `1001`                   |
| `podSecurityContext.seccompProfile.type`            | Set Sealed Secret pod's Security Context seccompProfile type                                                             | `RuntimeDefault`         |
| `containerSecurityContext.enabled`                  | Enabled Sealed Secret containers' Security Context                                                                       | `true`                   |
| `containerSecurityContext.allowPrivilegeEscalation` | Whether the Sealed Secret container can escalate privileges                                                              | `false`                  |
| `containerSecurityContext.capabilities.drop`        | Which privileges to drop in the Sealed Secret container                                                                  | `["ALL"]`                |
| `containerSecurityContext.readOnlyRootFilesystem`   | Whether the Sealed Secret container has a read-only root filesystem                                                      | `true`                   |
| `containerSecurityContext.runAsNonRoot`             | Indicates that the Sealed Secret container must run as a non-root user                                                   | `true`                   |
| `containerSecurityContext.runAsUser`                | Set Sealed Secret containers' Security Context runAsUser                                                                 | `1001`                   |
| `containerSecurityContext.seccompProfile.type`      | Set Sealed Secret container's Security Context seccompProfile type                                                       | `RuntimeDefault`         |
| `hostAliases`                                       | Sealed Secret pods host aliases                                                                                          | `[]`                     |
| `podLabels`                                         | Extra labels for Sealed Secret pods                                                                                      | `{}`                     |
| `podAnnotations`                                    | Annotations for Sealed Secret pods                                                                                       | `{}`                     |
| `podAffinityPreset`                                 | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                      | `""`                     |
| `podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                 | `soft`                   |
| `nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                | `""`                     |
| `nodeAffinityPreset.key`                            | Node label key to match. Ignored if `affinity` is set                                                                    | `""`                     |
| `nodeAffinityPreset.values`                         | Node label values to match. Ignored if `affinity` is set                                                                 | `[]`                     |
| `affinity`                                          | Affinity for Sealed Secret pods assignment                                                                               | `{}`                     |
| `nodeSelector`                                      | Node labels for Sealed Secret pods assignment                                                                            | `{}`                     |
| `tolerations`                                       | Tolerations for Sealed Secret pods assignment                                                                            | `[]`                     |
| `updateStrategy.type`                               | Sealed Secret statefulset strategy type                                                                                  | `RollingUpdate`          |
| `priorityClassName`                                 | Sealed Secret pods' priorityClassName                                                                                    | `""`                     |
| `topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template | `[]`                     |
| `schedulerName`                                     | Name of the k8s scheduler (other than default) for Sealed Secret pods                                                    | `""`                     |
| `terminationGracePeriodSeconds`                     | Seconds the pod needs to terminate gracefully                                                                            | `""`                     |
| `lifecycleHooks`                                    | for the Sealed Secret container(s) to automate configuration before or after startup                                     | `{}`                     |
| `extraEnvVars`                                      | Array with extra environment variables to add to Sealed Secret nodes                                                     | `[]`                     |
| `extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for Sealed Secret nodes                                             | `""`                     |
| `extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for Sealed Secret nodes                                                | `""`                     |
| `extraVolumes`                                      | Optionally specify extra list of additional volumes for the Sealed Secret pod(s)                                         | `[]`                     |
| `extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the Sealed Secret container(s)                              | `[]`                     |
| `sidecars`                                          | Add additional sidecar containers to the Sealed Secret pod(s)                                                            | `{}`                     |
| `initContainers`                                    | Add additional init containers to the Sealed Secret pod(s)                                                               | `{}`                     |


### Traffic Exposure Parameters

| Name                               | Description                                                                                           | Value                    |
| ---------------------------------- | ----------------------------------------------------------------------------------------------------- | ------------------------ |
| `service.type`                     | Sealed Secret service type                                                                            | `ClusterIP`              |
| `service.ports.http`               | Sealed Secret service HTTP port number                                                                | `8080`                   |
| `service.ports.name`               | Sealed Secret service HTTP port name                                                                  | `http`                   |
| `service.nodePorts.http`           | Node port for HTTP                                                                                    | `""`                     |
| `service.clusterIP`                | Sealed Secret service Cluster IP                                                                      | `""`                     |
| `service.loadBalancerIP`           | Sealed Secret service Load Balancer IP                                                                | `""`                     |
| `service.loadBalancerSourceRanges` | Sealed Secret service Load Balancer sources                                                           | `[]`                     |
| `service.externalTrafficPolicy`    | Sealed Secret service external traffic policy                                                         | `Cluster`                |
| `service.annotations`              | Additional custom annotations for Sealed Secret service                                               | `{}`                     |
| `service.extraPorts`               | Extra ports to expose in Sealed Secret service (normally used with the `sidecars` value)              | `[]`                     |
| `service.sessionAffinity`          | Control where client requests go, to the same pod or round-robin                                      | `None`                   |
| `service.sessionAffinityConfig`    | Additional settings for the sessionAffinity                                                           | `{}`                     |
| `ingress.enabled`                  | Enable ingress record generation for Sealed Secret                                                    | `false`                  |
| `ingress.pathType`                 | Ingress path type                                                                                     | `ImplementationSpecific` |
| `ingress.apiVersion`               | Force Ingress API version (automatically detected if not set)                                         | `""`                     |
| `ingress.ingressClassName`         | IngressClass that will be be used to implement the Ingress                                            | `""`                     |
| `ingress.hostname`                 | Default host for the ingress record                                                                   | `sealed-secrets.local`   |
| `ingress.path`                     | Default path for the ingress record                                                                   | `/`                      |
| `ingress.annotations`              | Additional custom annotations for the ingress record                                                  | `{}`                     |
| `ingress.tls`                      | Enable TLS configuration for the host defined at `ingress.hostname` parameter                         | `false`                  |
| `ingress.selfSigned`               | Create a TLS secret for this ingress record using self-signed certificates generated by Helm          | `false`                  |
| `ingress.extraHosts`               | An array with additional hostname(s) to be covered with the ingress record                            | `[]`                     |
| `ingress.extraPaths`               | An array with additional arbitrary paths that may need to be added to the ingress under the main host | `[]`                     |
| `ingress.extraTls`                 | TLS configuration for additional hostname(s) to be covered with this ingress record                   | `[]`                     |
| `ingress.secrets`                  | Custom TLS certificates as secrets                                                                    | `[]`                     |
| `ingress.extraRules`               | Additional rules to be covered with this ingress record                                               | `[]`                     |


### Other Parameters

| Name                                          | Description                                                      | Value   |
| --------------------------------------------- | ---------------------------------------------------------------- | ------- |
| `rbac.create`                                 | Specifies whether RBAC resources should be created               | `true`  |
| `rbac.pspEnabled`                             | PodSecurityPolicy                                                | `false` |
| `rbac.unsealer.rules`                         | Custom RBAC rules to set for unsealer ClusterRole                | `[]`    |
| `rbac.keyAdmin.rules`                         | Custom RBAC rules to set for key-admin role                      | `[]`    |
| `rbac.serviceProxier.rules`                   | Custom RBAC rules to set for service-proxier role                | `[]`    |
| `serviceAccount.create`                       | Specifies whether a ServiceAccount should be created             | `true`  |
| `serviceAccount.name`                         | The name of the ServiceAccount to use.                           | `""`    |
| `serviceAccount.annotations`                  | Additional Service Account annotations (evaluated as a template) | `{}`    |
| `serviceAccount.automountServiceAccountToken` | Automount service account token for the server service account   | `true`  |
| `networkPolicy.enabled`                       | Specifies whether a NetworkPolicy should be created              | `false` |
| `networkPolicy.allowExternal`                 | Don't require client label for connections                       | `true`  |


### Metrics parameters

| Name                                       | Description                                                                      | Value   |
| ------------------------------------------ | -------------------------------------------------------------------------------- | ------- |
| `metrics.serviceMonitor.enabled`           | Specify if a ServiceMonitor will be deployed for Prometheus Operator             | `false` |
| `metrics.serviceMonitor.namespace`         | Namespace in which Prometheus is running                                         | `""`    |
| `metrics.serviceMonitor.labels`            | Extra labels for the ServiceMonitor                                              | `{}`    |
| `metrics.serviceMonitor.annotations`       | Additional ServiceMonitor annotations (evaluated as a template)                  | `{}`    |
| `metrics.serviceMonitor.jobLabel`          | The name of the label on the target service to use as the job name in Prometheus | `""`    |
| `metrics.serviceMonitor.honorLabels`       | honorLabels chooses the metric's labels on collisions with target labels         | `false` |
| `metrics.serviceMonitor.interval`          | Interval at which metrics should be scraped.                                     | `""`    |
| `metrics.serviceMonitor.scrapeTimeout`     | Timeout after which the scrape is ended                                          | `""`    |
| `metrics.serviceMonitor.metricRelabelings` | Specify additional relabeling of metrics                                         | `[]`    |
| `metrics.serviceMonitor.relabelings`       | Specify general relabeling                                                       | `[]`    |
| `metrics.serviceMonitor.selector`          | Prometheus instance selector labels                                              | `{}`    |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install my-release \
  --set livenessProbe.successThreshold=5 \
    my-repo/sealed-secrets
```

The above command sets the `livenessProbe.successThreshold` to `5`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml my-repo/sealed-secrets
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### Using kubeseal

The easiest way to interact with the Sealed Secrets controller is using the **kubeseal** utility. You can install this CLI by downloading the binary from [sealed-secrets/releases](https://github.com/bitnami-labs/sealed-secrets/releases) page.

Once installed, you can start using it to encrypt your secrets or fetching the controller public certificate as shown in the example below:

```bash
kubeseal --fetch-cert \
--controller-name=my-release \
--controller-namespace=my-release-namespace \
> pub-cert.pem
```

Refer to Sealed Secrets documentation for more information about [kubeseal usage](https://github.com/bitnami-labs/sealed-secrets#usage).

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Ingress

This chart provides support for Ingress resources. If you have an ingress controller installed on your cluster, such as [nginx-ingress-controller](https://github.com/bitnami/charts/tree/main/bitnami/nginx-ingress-controller) or [contour](https://github.com/bitnami/charts/tree/main/bitnami/contour) you can utilize the ingress controller to serve your application.

To enable Ingress integration, set `ingress.enabled` to `true`. The `ingress.hostname` property can be used to set the host name. The `ingress.tls` parameter can be used to add the TLS configuration for this host. It is also possible to have more than one host, with a separate TLS configuration for each host. [Learn more about configuring and using Ingress](https://docs.bitnami.com/kubernetes/infrastructure/sealed-secrets/configuration/configure-ingress/).

### TLS secrets

The chart also facilitates the creation of TLS secrets for use with the Ingress controller, with different options for certificate management. [Learn more about TLS secrets](https://docs.bitnami.com/kubernetes/infrastructure/sealed-secrets/administration/enable-tls-ingress/).

### Sidecars

If additional containers are needed in the same pod as Sealed Secrets (such as additional metrics or logging exporters), they can be defined using the `sidecars` parameter. If these sidecars export extra ports, extra port definitions can be added using the `service.extraPorts` parameter. [Learn more about configuring and using sidecar containers](https://docs.bitnami.com/kubernetes/infrastructure/sealed-secrets/configuration/configure-sidecar-init-containers/).

### Pod affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, use one of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 1.0.0

This major release renames several values in this chart and adds missing features, in order to be aligned with the rest of the assets in the Bitnami charts repository.

- `service.port` has been renamed as `service.ports.http`.
- `service.nodePort`has been renamed as `service.nodePorts.http`
- `containerPort`has been renamed as `containerPorts.http`
- `certManager`has been removed. Please use `ingress.annotations` instead

## License

Copyright &copy; 2022 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.