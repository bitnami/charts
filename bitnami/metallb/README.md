# MetalLB

[MetalLB](https://metallb.universe.tf/faq/) is an open source, rock solid LoadBalancer. It handles the `ServiceType: Loadbalancer`.

## TL;DR

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/metallb
```

## Introduction
Bitnami charts for Helm are carefully engineered, actively maintained and are the quickest and easiest way to deploy containers on a Kubernetes cluster that are ready to handle production workloads.

This chart bootstraps a [MetalLB Controller](https://metallb.universe.tf/community/) Controller Deployment and a [MetalLB Speaker](https://metallb.universe.tf/community/) Daemonset on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This Helm chart has been tested on top of [Bitnami Kubernetes Production Runtime](https://kubeprod.io/) (BKPR). Deploy BKPR to get automated TLS certificates, logging and monitoring for your applications.

## Prerequisites

- Kubernetes 1.12+
- Helm 3.0-beta3+
- Virtual IPs for Layer 2 or Route Reflector for BGP setup.

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/metallb
```

These commands deploy metallb on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` helm release:

```console
$ helm uninstall my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

The following tables lists the configurable parameters of the metallb chart and their default values.

### Global parameters

| Parameter                                                | Description                                                                                          | Default                                                 |
|----------------------------------------------------------|------------------------------------------------------------------------------------------------------|---------------------------------------------------------|
| `global.imageRegistry`                                   | Global Docker image registry                                                                         | `nil`                                                   |
| `global.imagePullSecrets`                                | Global Docker registry secret names as an array                                                      | `[]` (does not add image pull secrets to deployed pods) |

### Common parameters

| Parameter                                                | Description                                                                                          | Default                                                 |
|----------------------------------------------------------|------------------------------------------------------------------------------------------------------|---------------------------------------------------------|
| `nameOverride`                                           | String to partially override metallb.fullname template with a string (will prepend the release name) | `nil`                                                   |
| `fullnameOverride`                                       | String to fully override metallb.fullname template with a string                                     | `nil`                                                   |
| `existingConfigMap`                                      | Specify an existing configMapName to use. (this is mutually exclusive with the configInline option)  | `nil`                                                   |
| `configInline`                                           | Specify the config for metallb as a new configMap inline.                                            | `{}` (does not create configMap)                        |
| `rbac.create`                                            | Specify if an rbac authorization should be created with the necessarry Rolebindings.                 | `true`                                                  |
| `prometheusRule.enabled`                                 | Enable for Prometheus alertmanager basic alerts.                                                     | `false`                                                 |
| `commonLabels`                                           | Add common Labels to all Resources of the helmchart                                                  | `{}`                                                    |
| `commonAnnotations`                                      | Add common Annotations to all Resources of the helmchart                                             | `{}`                                                    |
| `networkPolicy.enabled`                                  | Enable NetworkPolicy                                                                                 | `false`                                                 |
| `networkPolicy.ingressNSMatchLabels`                     | Allow connections from other namespaces                                                              | `{}`                                                    |
| `networkPolicy.ingressNSPodMatchLabels`                  | For other namespaces match by pod labels and namespace labels                                        | `{}`                                                    |

### Controller parameters

| Parameter                                                | Description                                                                                          | Default                                                 |
|----------------------------------------------------------|------------------------------------------------------------------------------------------------------|---------------------------------------------------------|
| `controller.image.registry`                              | MetalLB Controller image registry                                                                    | `docker.io`                                             |
| `controller.image.repository`                            | MetalLB Controller image name                                                                        | `bitnami/metallb-controller`                            |
| `controller.image.tag`                                   | MetalLB Controller image tag                                                                         | `{TAG_NAME}`                                            |
| `controller.image.pullPolicy`                            | MetalLB Controller image pull policy                                                                 | `IfNotPresent`                                          |
| `controller.image.pullSecrets`                           | Specify docker-registry secret names as an array                                                     | `[]` (does not add image pull secrets to deployed pods) |
| `controller.rbac.create`                                 | create specifies whether to install and use RBAC rules.                                              | `true`                                                  |
| `controller.psp.create`                                  | create specifies whether to install Pod Security Policies.                                           | `true`                                                  |
| `controller.resources.limits`                            | Specify resource limits which the container is not allowed to succeed.                               | `{}` (does not add resource limits to deployed pods)    |
| `controller.resources.requests`                          | Specify resource requests which the container needs to spawn.                                        | `{}` (does not add resource limits to deployed pods)    |
| `controller.nodeSelector`                                | Node labels for controller pod assignment                                                            | `{}`                                                    |
| `controller.tolerations`                                 | Tolerations for controller pod assignment                                                            | `[]`                                                    |
| `controller.affinity`                                    | Affinity for controller pod assignment                                                               | `{}`                                                    |
| `controller.podAnnotations`                              | Controller Pod annotations                                                                           | `{}`                                                    |
| `controller.podLabels`                                   | Controller Pod labels                                                                                | `{}`                                                    |
| `controller.podAffinityPreset`                           | Controller Pod affinitypreset                                                                        | `""`                                                    |
| `controller.podAntiAffinityPreset`                       | Controller Pod anti affinitypreset                                                                   | `soft`                                                  |
| `controller.nodeAffinityPreset.type`                     | Controller Pod Node affinity preset                                                                  | `""`                                                    |
| `controller.nodeAffinityPreset.key`                      | Controller Pod Node affinity label key to match                                                      | `""`                                                    |
| `controller.nodeAffinityPreset.values`                   | Controller Pod Node affinity label values to match                                                   | `[]`                                                    |
| `controller.serviceAccount.create`                       | create a serviceAccount for the controller pod                                                       | `true`                                                  |
| `controller.serviceAccount.name`                         | use the serviceAccount with the specified name                                                       | `""`                                                    |
| `controller.revisionHistoryLimit`                        | the revision history limit for the deployment.                                                       | `3`                                                     |
| `controller.terminationGracePeriodSeconds`               | the termination grace period for pods                                                                | `0`                                                     |
| `controller.containerPort.metrics`                       | Controller Pod metrics listening port                                                                | `7472`                                                  |
| `controller.livenessProbe.enabled`                       | Enable/disable the Liveness probe                                                                    | `true`                                                  |
| `controller.livenessProbe.failureThreshold`              | Delay before liveness probe is initiated                                                             | `3`                                                     |
| `controller.livenessProbe.initialDelaySeconds`           | How often to perform the probe                                                                       | `10`                                                    |
| `controller.livenessProbe.periodSeconds`                 | When the probe times out                                                                             | `10`                                                    |
| `controller.livenessProbe.successThreshold`              | Minimum consecutive successes for the probe to be considered successful after having failed.         | `1`                                                     |
| `controller.livenessProbe.timeoutSeconds`                | Minimum consecutive failures for the probe to be considered failed after having succeeded.           | `1`                                                     |
| `controller.readinessProbe.enabled`                      | Enable/disable the Readiness probe                                                                   | `true`                                                  |
| `controller.readinessProbe.failureThreshold`             | Delay before readiness probe is initiated                                                            | `3`                                                     |
| `controller.readinessProbe.initialDelaySeconds`          | How often to perform the probe                                                                       | `10`                                                    |
| `controller.readinessProbe.periodSeconds`                | When the probe times out                                                                             | `10`                                                    |
| `controller.readinessProbe.successThreshold`             | Minimum consecutive successes for the probe to be considered successful after having failed.         | `1`                                                     |
| `controller.readinessProbe.timeoutSeconds`               | Minimum consecutive failures for the probe to be considered failed after having succeeded.           | `1`                                                     |
| `controller.securityContext.enabled`                     | Enable pods' security context                                                                        | `true`                                                  |
| `controller.securityContext.runAsNonRoot`                | MetalLB Controller must runs as nonRoot.                                                             | `true`                                                  |
| `controller.securityContext.runAsUser`                   | User ID for the pods.                                                                                | `1001`                                                  |
| `controller.securityContext.fsGroup`                     | Group ID for the pods.                                                                               | `1001`                                                  |
| `controller.securityContext.allowPrivilegeEscalation`    | This defines if privilegeEscalation is allowed on that container                                     | `false`                                                 |
| `controller.securityContext.readOnlyRootFilesystem`      | This defines if the container can read the root fs on the host                                       | `true`                                                  |
| `controller.securityContext.capabilities.drop`           | Drop capabilities for the securityContext                                                            | `["ALL"]`                                               |
| `controller.prometheus.serviceMonitor.enabled`           | Specify if a servicemonitor will be deployed for prometheus-operator.                                | `false`                                                 |
| `controller.prometheus.serviceMonitor.jobLabel`          | Specify the jobLabel to use for the prometheus-operator                                              | `app.kubernetes.io/name`                                |
| `controller.prometheus.serviceMonitor.interval`          | Specify the scrape interval if not specified use defaul prometheus scrapeIntervall                   | `""`                                                    |
| `controller.prometheus.serviceMonitor.metricRelabelings` | Specify additional relabeling of metrics.                                                            | `[]`                                                    |
| `controller.prometheus.serviceMonitor.relabelings`       | Specify general relabeling.                                                                          | `[]`                                                    |

### Speaker parameters

| Parameter                                                | Description                                                                                          | Default                                                 |
|----------------------------------------------------------|------------------------------------------------------------------------------------------------------|---------------------------------------------------------|
| `speaker.image.registry`                                 | MetalLB Speaker image registry                                                                       | `docker.io`                                             |
| `speaker.image.repository`                               | MetalLB Speaker image name                                                                           | `bitnami/metallb-speaker`                               |
| `speaker.image.tag`                                      | MetalLB Speaker image tag                                                                            | `{TAG_NAME}`                                            |
| `speaker.image.pullPolicy`                               | MetalLB Speaker image pull policy                                                                    | `IfNotPresent`                                          |
| `speaker.image.pullSecrets`                              | Specify docker-registry secret names as an array                                                     | `[]` (does not add image pull secrets to deployed pods) |
| `speaker.rbac.create`                                    | create specifies whether to install and use RBAC rules.                                              | `true`                                                  |
| `speaker.psp.create`                                     | create specifies whether to install Pod Security Policies.                                           | `true`                                                  |
| `speaker.resources.limits`                               | Specify resource limits which the container is not allowed to succeed.                               | `{}` (does not add resource limits to deployed pods)    |
| `speaker.resources.requests`                             | Specify resource requests which the container needs to spawn.                                        | `{}` (does not add resource limits to deployed pods)    |
| `speaker.nodeSelector`                                   | Node labels for speaker pod assignment                                                               | `{}`                                                    |
| `speaker.tolerations`                                    | Tolerations for speaker pod assignment                                                               | `[]`                                                    |
| `speaker.affinity`                                       | Affinity for speaker pod assignment                                                                  | `{}`                                                    |
| `speaker.podAnnotations`                                 | Speaker Pod annotations                                                                              | `{}`                                                    |
| `speaker.podLabels`                                      | Speaker Pod labels                                                                                   | `{}`                                                    |
| `speaker.serviceAccount.create`                          | create a serviceAccount for the speaker pod                                                          | `true`                                                  |
| `speaker.serviceAccount.name`                            | use the serviceAccount with the specified name                                                       | ""                                                      |
| `speaker.daemonset.hostPorts.metrics`                    | the tcp port to listen on for the openmetrics endpoint.                                              | `7472`                                                  |
| `speaker.daemonset.terminationGracePeriodSeconds`        | The terminationGracePeriod in seconds for the daemonset to stop                                      | `2`                                                     |
| `speaker.securityContext.enabled`                        | Enable pods' security context                                                                        | `true`                                                  |
| `speaker.securityContext.runAsUser`                      | User ID for the pods.                                                                                | `0`                                                     |
| `speaker.securityContext.allowPrivilegeEscalation`       | Enables privilege Escalation context for the pod.                                                    | `false`                                                 |
| `speaker.securityContext.readOnlyRootFilesystem`         | Allows the pod to mount the RootFS as ReadOnly                                                       | `true`                                                  |
| `speaker.securityContext.capabilities.drop`              | Drop capabilities for the securityContext                                                            | `["ALL"]`                                               |
| `speaker.securityContext.capabilities.add`               | Add capabilities for the securityContext                                                             | `["NET_ADMIN", "NET_RAW", "SYS_ADMIN"]`                 |
| `speaker.secretName`                                     | References a Secret name for the member secret outside of the helm chart                             | `nil`                                                   |
| `speaker.secretKey`                                      | References a Secret key for the member secret outside of the helm chart                              | `nil`                                                   |
| `speaker.extraEnvVars`                                   | Extra environment variable to pass to the running container.                                         | `[]`                                                    |
| `speaker.livenessProbe.enabled`                          | Enable/disable the Liveness probe                                                                    | `true`                                                  |
| `speaker.livenessProbe.initialDelaySeconds`              | Delay before liveness probe is initiated                                                             | `60`                                                    |
| `speaker.livenessProbe.periodSeconds`                    | How often to perform the probe                                                                       | `10`                                                    |
| `speaker.livenessProbe.timeoutSeconds`                   | When the probe times out                                                                             | `5`                                                     |
| `speaker.livenessProbe.successThreshold`                 | Minimum consecutive successes for the probe to be considered successful after having failed.         | `1`                                                     |
| `speaker.livenessProbe.failureThreshold`                 | Minimum consecutive failures for the probe to be considered failed after having succeeded.           | `6`                                                     |
| `speaker.readinessProbe.enabled`                         | Enable/disable the Readiness probe                                                                   | `true`                                                  |
| `speaker.readinessProbe.failureThreshold`                | Delay before readiness probe is initiated                                                            | `3`                                                     |
| `speaker.readinessProbe.initialDelaySeconds`             | How often to perform the probe                                                                       | `10`                                                    |
| `speaker.readinessProbe.periodSeconds`                   | When the probe times out                                                                             | `10`                                                    |
| `speaker.readinessProbe.successThreshold`                | Minimum consecutive successes for the probe to be considered successful after having failed.         | `1`                                                     |
| `speaker.readinessProbe.timeoutSeconds`                  | Minimum consecutive failures for the probe to be considered failed after having succeeded.           | `1`                                                     |
| `speaker.prometheus.serviceMonitor.enabled`              | Specify if a servicemonitor will be deployed for prometheus-operator.                                | `false`                                                 |
| `speaker.prometheus.serviceMonitor.jobLabel`             | Specify the jobLabel to use for the prometheus-operator                                              | `app.kubernetes.io/name"`                               |
| `speaker.prometheus.serviceMonitor.interval`             | Specify the scrape interval if not specified use defaul prometheus scrapeIntervall                   | `""`                                                    |
| `speaker.prometheus.serviceMonitor.metricRelabelings`    | Specify additional relabeling of metrics.                                                            | `[]`                                                    |
| `speaker.prometheus.serviceMonitor.relabelings`          | Specify general relabeling.                                                                          | `[]`                                                    |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install my-release \
  --set livenessProbe.successThreshold=5 \
    bitnami/metallb
```
The above command sets the `livenessProbe.successThreshold` to `5`.

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

To configure [MetalLB](https://metallb.universe.tf) please look into the configuration section [MetalLB Configuration](https://metallb.universe.tf/configuration/).

### Example Layer 2 configuration

```yaml
configInline:
  # The address-pools section lists the IP addresses that MetalLB is
  # allowed to allocate, along with settings for how to advertise
  # those addresses over BGP once assigned. You can have as many
  # address pools as you want.
  address-pools:
  - # A name for the address pool. Services can request allocation
    # from a specific address pool using this name, by listing this
    # name under the 'metallb.universe.tf/address-pool' annotation.
    name: generic-cluster-pool
    # Protocol can be used to select how the announcement is done.
    # Supported values are bgp and layer2.
    protocol: layer2
    # A list of IP address ranges over which MetalLB has
    # authority. You can list multiple ranges in a single pool, they
    # will all share the same settings. Each range can be either a
    # CIDR prefix, or an explicit start-end range of IPs.
    addresses:
    - 10.27.50.30-10.27.50.35
```

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami’s Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading


### To 2.0.0

**What changes were introduced in this major version?**

- The `.Values.prometheus` section was moved into the components `.Values.controller.prometheus` and `.Values.speaker.prometheus`
- The `prometheus.prometheusRule` which is used to toggle the deployment of the metallb alerts is moved under the root of the `.Values.prometheusRule`
- A globel `.Values.psp.create` and `.Values.rbac.create` was introduced together with the option of toggeling for each component. (global option overwrites component options)
  - `Values.controller.rbac.create` and `Values.controller.psp.create`
  - `Values.speaker.rbac.create` and `Values.speaker.psp.create`

**Considerations when upgrading to this version**

- Check if you used the `prometheus` section in you deployment.
- If you do so, place the configuration you made into the sections `controller.prometheus` and `speaker.prometheus`.
- `prometheusRule` should stay under the root of your values.

### To 1.0.0

[On November 13, 2020, Helm v2 support was formally finished](https://github.com/helm/charts#status-of-the-project), this major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

**What changes were introduced in this major version?**

- Previous versions of this Helm Chart use `apiVersion: v1` (installable by both Helm 2 and 3), this Helm Chart was updated to `apiVersion: v2` (installable by Helm 3 only). [Here](https://helm.sh/docs/topics/charts/#the-apiversion-field) you can find more information about the `apiVersion` field.
- The different fields present in the *Chart.yaml* file has been ordered alphabetically in a homogeneous way for all the Bitnami Helm Charts

**Considerations when upgrading to this version**

- If you want to upgrade to this version from a previous one installed with Helm v3, you shouldn't face any issues
- If you want to upgrade to this version using Helm v2, this scenario is not supported as this version doesn't support Helm v2 anymore
- If you installed the previous version with Helm v2 and wants to upgrade to this version with Helm v3, please refer to the [official Helm documentation](https://helm.sh/docs/topics/v2_v3_migration/#migration-use-cases) about migrating from Helm v2 to v3

**Useful links**

- https://docs.bitnami.com/tutorials/resolve-helm2-helm3-post-migration-issues/
- https://helm.sh/docs/topics/v2_v3_migration/
- https://helm.sh/blog/migrate-from-helm-v2-to-helm-v3/
