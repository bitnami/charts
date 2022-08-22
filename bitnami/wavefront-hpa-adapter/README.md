<!--- app-name: Wavefront HPA Adapter for Kubernetes -->

# Wavefront HPA Adapter for Kubernetes

Wavefront HPA Adapter for Kubernetes is a Kubernetes Horizontal Pod Autoscaler adapter. It allows to scale your Kubernetes workloads based on Wavefront metrics.

[Overview of Wavefront HPA Adapter for Kubernetes](https://github.com/wavefrontHQ/wavefront-kubernetes-adapter)


                           
## TL;DR

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/wavefront-hpa-adapter
```

## Introduction
Bitnami charts for Helm are carefully engineered, actively maintained and are the quickest and easiest way to deploy containers on a Kubernetes cluster that are ready to handle production workloads.

[Wavefront HPA Adapter for Kubernetes](https://github.com/wavefrontHQ/wavefront-kubernetes-adapter) Deployment in a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Wavefront HPA Adapter for Kubernetes enables Kubernetes workloads to be scaled based on Wavefront metrics.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/wavefront-hpa-adapter
```

These commands deploy wavefront-hpa-adapter on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` helm release:

```console
$ helm uninstall my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

### Global parameters

| Name                      | Description                                        | Value           |
| ------------------------- | -------------------------------------------------- | --------------- |
| `global.imageRegistry`    | Global Docker image registry                       | `""`            |
| `global.imagePullSecrets` | Global Docker registry secret names as an array    | `[]`            |
| `global.storageClass`     | Global StorageClass for Persistent Volume(s)       | `""`            |
| `kubeVersion`             | Override Kubernetes version                        | `""`            |
| `nameOverride`            | String to partially override common.names.fullname | `""`            |
| `fullnameOverride`        | String to fully override common.names.fullname     | `""`            |
| `commonLabels`            | Labels to add to all deployed objects              | `{}`            |
| `commonAnnotations`       | Annotations to add to all deployed objects         | `{}`            |
| `clusterDomain`           | Kubernetes cluster domain name                     | `cluster.local` |
| `extraDeploy`             | Array of extra objects to deploy with the release  | `[]`            |


### Wavefront HPA Adapter for Kubernetes deployment parameters

| Name                                              | Description                                                                                             | Value                                |
| ------------------------------------------------- | ------------------------------------------------------------------------------------------------------- | ------------------------------------ |
| `image.registry`                                  | Adapter image registry                                                                                  | `docker.io`                          |
| `image.repository`                                | Adapter image repository                                                                                | `bitnami/wavefront-hpa-adapter`      |
| `image.tag`                                       | Adapter image tag (immutable tags are recommended)                                                      | `0.9.9-scratch-r4`                   |
| `image.digest`                                    | Adapter image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag | `""`                                 |
| `image.pullPolicy`                                | Adapter image pull policy                                                                               | `IfNotPresent`                       |
| `image.pullSecrets`                               | Specify docker-registry secret names as an array                                                        | `[]`                                 |
| `image.debug`                                     | Enable image debug mode                                                                                 | `false`                              |
| `livenessProbe.enabled`                           | Enable livenessProbe                                                                                    | `true`                               |
| `livenessProbe.initialDelaySeconds`               | Initial delay seconds for livenessProbe                                                                 | `10`                                 |
| `livenessProbe.periodSeconds`                     | Period seconds for livenessProbe                                                                        | `10`                                 |
| `livenessProbe.timeoutSeconds`                    | Timeout seconds for livenessProbe                                                                       | `1`                                  |
| `livenessProbe.failureThreshold`                  | Failure threshold for livenessProbe                                                                     | `3`                                  |
| `livenessProbe.successThreshold`                  | Success threshold for livenessProbe                                                                     | `1`                                  |
| `readinessProbe.enabled`                          | Enable readinessProbe                                                                                   | `true`                               |
| `readinessProbe.initialDelaySeconds`              | Initial delay seconds for readinessProbe                                                                | `10`                                 |
| `readinessProbe.periodSeconds`                    | Period seconds for readinessProbe                                                                       | `10`                                 |
| `readinessProbe.timeoutSeconds`                   | Timeout seconds for readinessProbe                                                                      | `1`                                  |
| `readinessProbe.failureThreshold`                 | Failure threshold for readinessProbe                                                                    | `3`                                  |
| `readinessProbe.successThreshold`                 | Success threshold for readinessProbe                                                                    | `1`                                  |
| `startupProbe.enabled`                            | Enable startupProbe                                                                                     | `false`                              |
| `startupProbe.initialDelaySeconds`                | Initial delay seconds for startupProbe                                                                  | `10`                                 |
| `startupProbe.periodSeconds`                      | Period seconds for startupProbe                                                                         | `10`                                 |
| `startupProbe.timeoutSeconds`                     | Timeout seconds for startupProbe                                                                        | `1`                                  |
| `startupProbe.failureThreshold`                   | Failure threshold for startupProbe                                                                      | `3`                                  |
| `startupProbe.successThreshold`                   | Success threshold for startupProbe                                                                      | `1`                                  |
| `command`                                         | Override default container command (useful when using custom images)                                    | `[]`                                 |
| `args`                                            | Override default container args (useful when using custom images)                                       | `[]`                                 |
| `hostAliases`                                     | Add deployment host aliases                                                                             | `[]`                                 |
| `resources.limits`                                | The resources limits for the Adapter container                                                          | `{}`                                 |
| `resources.requests`                              | The requested resourcesc for the Adapter container                                                      | `{}`                                 |
| `containerSecurityContext.enabled`                | Enabled Adapter containers' Security Context                                                            | `true`                               |
| `containerSecurityContext.runAsUser`              | Set Adapter container's Security Context runAsUser                                                      | `1001`                               |
| `containerSecurityContext.runAsNonRoot`           | Set Adapter container's Security Context runAsNonRoot                                                   | `true`                               |
| `containerSecurityContext.readOnlyRootFilesystem` | mount / (root) as a readonly filesystem on Adapter container                                            | `true`                               |
| `podSecurityContext.enabled`                      | Enabled Adapter pods' Security Context                                                                  | `true`                               |
| `podSecurityContext.fsGroup`                      | Set Adapter pod's Security Context fsGroup                                                              | `1001`                               |
| `podAffinityPreset`                               | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                     | `""`                                 |
| `podAntiAffinityPreset`                           | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                | `soft`                               |
| `nodeAffinityPreset.type`                         | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`               | `""`                                 |
| `nodeAffinityPreset.key`                          | Node label key to match. Ignored if `affinity` is set                                                   | `""`                                 |
| `nodeAffinityPreset.values`                       | Node label values to match. Ignored if `affinity` is set                                                | `[]`                                 |
| `affinity`                                        | Affinity for pod assignment                                                                             | `{}`                                 |
| `nodeSelector`                                    | Node labels for pod assignment                                                                          | `{}`                                 |
| `tolerations`                                     | Tolerations for pod assignment                                                                          | `[]`                                 |
| `podLabels`                                       | Extra labels for Adapter pods                                                                           | `{}`                                 |
| `podAnnotations`                                  | Annotations for Adapter pods                                                                            | `{}`                                 |
| `priorityClassName`                               | Adapter pod priority                                                                                    | `""`                                 |
| `lifecycleHooks`                                  | Add lifecycle hooks to the Adapter deployment                                                           | `{}`                                 |
| `schedulerName`                                   | Alternative scheduler                                                                                   | `""`                                 |
| `topologySpreadConstraints`                       | Topology Spread Constraints for pod assignment                                                          | `[]`                                 |
| `customLivenessProbe`                             | Override default liveness probe                                                                         | `{}`                                 |
| `customReadinessProbe`                            | Override default readiness probe                                                                        | `{}`                                 |
| `customStartupProbe`                              | Override default startup probe                                                                          | `{}`                                 |
| `updateStrategy.type`                             | Adapter deployment update strategy                                                                      | `RollingUpdate`                      |
| `containerPorts.https`                            | Adapter container port                                                                                  | `6443`                               |
| `extraEnvVars`                                    | Add extra environment variables to the Adapter container                                                | `[]`                                 |
| `extraEnvVarsCM`                                  | Name of existing ConfigMap containing extra env vars                                                    | `""`                                 |
| `extraEnvVarsSecret`                              | Name of existing Secret containing extra env vars                                                       | `""`                                 |
| `extraVolumes`                                    | Optionally specify extra list of additional volumes for Adapter pods                                    | `[]`                                 |
| `extraVolumeMounts`                               | Optionally specify extra list of additional volumeMounts for Adapter container(s)                       | `[]`                                 |
| `initContainers`                                  | Add additional init containers to the Adapter pods                                                      | `[]`                                 |
| `sidecars`                                        | Add additional sidecar containers to the Adapter pod                                                    | `[]`                                 |
| `adapterMetricPrefix`                             | Adapter metric `prefix` parameter                                                                       | `kubernetes`                         |
| `adapterAPIClientTimeout`                         | Adapter API timeout                                                                                     | `10s`                                |
| `adapterMetricRelistInterval`                     | Adapter metric relist interval                                                                          | `10m`                                |
| `adapterLogLevel`                                 | Adapter log level                                                                                       | `info`                               |
| `adapterRules`                                    | Adapter array of rules                                                                                  | `[]`                                 |
| `adapterSSLCertDir`                               | Adapter SSL Certs directory                                                                             | `/etc/ssl/certs`                     |
| `adapterSSLCertsSecret`                           | Adapter SSL Certs secret (will use autogenerated if empty)                                              | `""`                                 |
| `wavefront.url`                                   | External Wavefront URL                                                                                  | `https://YOUR_CLUSTER.wavefront.com` |
| `wavefront.token`                                 | External Wavefront Token                                                                                | `YOUR_API_TOKEN`                     |


### Traffic Exposure Parameters

| Name                               | Description                                                          | Value       |
| ---------------------------------- | -------------------------------------------------------------------- | ----------- |
| `service.type`                     | Adapter service type                                                 | `ClusterIP` |
| `service.ports.https`              | Adapter service port                                                 | `443`       |
| `service.clusterIP`                | WordPress service Cluster IP                                         | `""`        |
| `service.annotations`              | Additional custom annotations for WordPress service                  | `{}`        |
| `service.extraPorts`               | Extra port to expose on WordPress service                            | `[]`        |
| `service.loadBalancerIP`           | Adapter service LoadBalancer IP                                      | `""`        |
| `service.loadBalancerSourceRanges` | loadBalancerIP source ranges for the Service                         | `[]`        |
| `service.nodePorts.http`           | NodePort for the HTTP endpoint                                       | `""`        |
| `service.externalTrafficPolicy`    | External traffic policy for the service                              | `Cluster`   |
| `service.sessionAffinity`          | Session Affinity for Kubernetes service, can be "None" or "ClientIP" | `None`      |
| `service.sessionAffinityConfig`    | Additional settings for the sessionAffinity                          | `{}`        |


### RBAC parameters

| Name                                          | Description                                                 | Value  |
| --------------------------------------------- | ----------------------------------------------------------- | ------ |
| `rbac.create`                                 | Weather to create & use RBAC resources or not               | `true` |
| `serviceAccount.create`                       | Enable the creation of a ServiceAccount for Reconciler pods | `true` |
| `serviceAccount.name`                         | Name of the created ServiceAccount                          | `""`   |
| `serviceAccount.automountServiceAccountToken` | Automount API credentials for a service account.            | `true` |
| `serviceAccount.annotations`                  | Add annotations to the service account                      | `{}`   |
| `apiService.create`                           | Create the APIService objects in Kubernetes API             | `true` |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install my-release \
  --set livenessProbe.successThreshold=5 \
    bitnami/wavefront-hpa-adapter
```

The above command sets the `livenessProbe.successThreshold` to `5`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install my-release -f values.yaml bitnami/wavefront-hpa-adapter
```

## Configuration and installation details

### [Rolling vs Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Connect to a Wavefront instance

Wavefront HPA for Kubernetes only works when it configured to use a Wavefront SaaS instance with a proper API token. This is done by setting the `wavefront.url` and `wavefront.token` values. Obtain an instance and an API token by signing up for an account through the [official Wavefront sign-up page](https://www.wavefront.com/sign-up).

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

```bash
$ helm upgrade my-release bitnami/wavefront-hpa-adapter
```

## To 1.0.0

Some of the chart values were changed to adapt to the latest Bitnami standards. More specifically:

- `containerPort` was changed to `containerPorts.http`
- `service.port` was changed to `service.ports.http`

No issues should be expected when upgrading.

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