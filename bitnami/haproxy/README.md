# HAProxy

[HAProxy](http://www.haproxy.org/) is a TCP proxy and a HTTP reverse proxy. It supports SSL termination and offloading, TCP and HTTP normalization, traffic regulation, caching and protection against DDoS attacks.

## TL;DR

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/haproxy
```

## Introduction

Bitnami charts for Helm are carefully engineered, actively maintained and are the quickest and easiest way to deploy containers on a Kubernetes cluster that are ready to handle production workloads.

This chart bootstraps a [HAProxy](https://github.com/haproxytech/haproxy) Deployment in a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This Helm chart has been tested on top of [Bitnami Kubernetes Production Runtime](https://kubeprod.io/) (BKPR). Deploy BKPR to get automated TLS certificates, logging and monitoring for your applications.

[Learn more about the default configuration of the chart](https://docs.bitnami.com/kubernetes/infrastructure/haproxy/get-started/understand-default-configuration/).

## Prerequisites

- Kubernetes 1.12+
- Helm 3.1.0

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release bitnami/haproxy
```

The command deploys haproxy on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

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
| `global.imageRegistry`    | Global Docker image registry                    | `nil` |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]`  |
| `global.storageClass`     | Global StorageClass for Persistent Volume(s)    | `nil` |


### Common parameters

| Name                | Description                                        | Value           |
| ------------------- | -------------------------------------------------- | --------------- |
| `kubeVersion`       | Override Kubernetes version                        | `nil`           |
| `nameOverride`      | String to partially override common.names.fullname | `nil`           |
| `fullnameOverride`  | String to fully override common.names.fullname     | `nil`           |
| `commonLabels`      | Labels to add to all deployed objects              | `{}`            |
| `commonAnnotations` | Annotations to add to all deployed objects         | `{}`            |
| `clusterDomain`     | Kubernetes cluster domain name                     | `cluster.local` |
| `extraDeploy`       | Array of extra objects to deploy with the release  | `[]`            |


### Traffic Exposure Parameters

| Name                               | Description                                       | Value          |
| ---------------------------------- | ------------------------------------------------- | -------------- |
| `service.type`                     | haproxy service type                              | `LoadBalancer` |
| `service.ports`                    | List of haproxy service ports                     | `[]`           |
| `service.clusterIP`                | haproxy service Cluster IP                        | `nil`          |
| `service.loadBalancerIP`           | haproxy service Load Balancer IP                  | `nil`          |
| `service.loadBalancerSourceRanges` | haproxy service Load Balancer sources             | `[]`           |
| `service.externalTrafficPolicy`    | haproxy service external traffic policy           | `Cluster`      |
| `service.annotations`              | Additional custom annotations for haproxy service | `{}`           |


### HAProxy Parameters

| Name                                 | Description                                                                               | Value                 |
| ------------------------------------ | ----------------------------------------------------------------------------------------- | --------------------- |
| `image.registry`                     | HAProxy image registry                                                                    | `docker.io`           |
| `image.repository`                   | HAProxy image repository                                                                  | `bitnami/haproxy`     |
| `image.tag`                          | HAProxy image tag (immutable tags are recommended)                                        | `2.4.0-debian-10-r28` |
| `image.pullPolicy`                   | HAProxy image pull policy                                                                 | `IfNotPresent`        |
| `image.pullSecrets`                  | HAProxy image pull secrets                                                                | `[]`                  |
| `replicaCount`                       | Number of haproxy replicas to deploy                                                      | `1`                   |
| `livenessProbe.enabled`              | Enable livenessProbe on haproxy nodes                                                     | `true`                |
| `livenessProbe.initialDelaySeconds`  | Initial delay seconds for livenessProbe                                                   | `15`                  |
| `livenessProbe.periodSeconds`        | Period seconds for livenessProbe                                                          | `10`                  |
| `livenessProbe.timeoutSeconds`       | Timeout seconds for livenessProbe                                                         | `5`                   |
| `livenessProbe.failureThreshold`     | Failure threshold for livenessProbe                                                       | `5`                   |
| `livenessProbe.successThreshold`     | Success threshold for livenessProbe                                                       | `1`                   |
| `readinessProbe.enabled`             | Enable readinessProbe on haproxy nodes                                                    | `true`                |
| `readinessProbe.initialDelaySeconds` | Initial delay seconds for readinessProbe                                                  | `15`                  |
| `readinessProbe.periodSeconds`       | Period seconds for readinessProbe                                                         | `10`                  |
| `readinessProbe.timeoutSeconds`      | Timeout seconds for readinessProbe                                                        | `5`                   |
| `readinessProbe.failureThreshold`    | Failure threshold for readinessProbe                                                      | `5`                   |
| `readinessProbe.successThreshold`    | Success threshold for readinessProbe                                                      | `1`                   |
| `customLivenessProbe`                | Custom livenessProbe that overrides the default one                                       | `{}`                  |
| `customReadinessProbe`               | Custom readinessProbe that overrides the default one                                      | `{}`                  |
| `resources.limits`                   | The resources limits for the haproxy containers                                           | `{}`                  |
| `resources.requests`                 | The requested resources for the haproxy containers                                        | `{}`                  |
| `podSecurityContext.enabled`         | Enabled haproxy pods' Security Context                                                    | `true`                |
| `podSecurityContext.fsGroup`         | Set haproxy pod's Security Context fsGroup                                                | `1001`                |
| `containerSecurityContext.enabled`   | Enabled haproxy containers' Security Context                                              | `true`                |
| `containerSecurityContext.runAsUser` | Set haproxy containers' Security Context runAsUser                                        | `1001`                |
| `pdb.create`                         | Enable a Pod Disruption Budget creation                                                   | `false`               |
| `pdb.minAvailable`                   | Minimum number/percentage of pods that should remain scheduled                            | `1`                   |
| `pdb.maxUnavailable`                 | Maximum number/percentage of pods that may be made unavailable                            | `nil`                 |
| `autoscaling.enabled`                | Enable Horizontal POD autoscaling for HAProxy                                             | `false`               |
| `autoscaling.minReplicas`            | Minimum number of HAProxy replicas                                                        | `1`                   |
| `autoscaling.maxReplicas`            | Maximum number of HAProxy replicas                                                        | `11`                  |
| `autoscaling.targetCPU`              | Target CPU utilization percentage                                                         | `50`                  |
| `autoscaling.targetMemory`           | Target Memory utilization percentage                                                      | `50`                  |
| `command`                            | Override default container command (useful when using custom images)                      | `[]`                  |
| `args`                               | Override default container args (useful when using custom images)                         | `[]`                  |
| `hostAliases`                        | haproxy pods host aliases                                                                 | `[]`                  |
| `podLabels`                          | Extra labels for haproxy pods                                                             | `{}`                  |
| `podAnnotations`                     | Annotations for haproxy pods                                                              | `{}`                  |
| `podAffinityPreset`                  | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`       | `""`                  |
| `podAntiAffinityPreset`              | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`  | `soft`                |
| `nodeAffinityPreset.type`            | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard` | `""`                  |
| `nodeAffinityPreset.key`             | Node label key to match. Ignored if `affinity` is set                                     | `""`                  |
| `nodeAffinityPreset.values`          | Node label values to match. Ignored if `affinity` is set                                  | `[]`                  |
| `configuration`                      | haproxy configuration                                                                     | `""`                  |
| `containerPorts`                     | List of container ports to enable in the haproxy container                                | `[]`                  |
| `existingConfigmap`                  | configmap with HAProxy configuration                                                      | `""`                  |
| `affinity`                           | Affinity for haproxy pods assignment                                                      | `{}`                  |
| `nodeSelector`                       | Node labels for haproxy pods assignment                                                   | `{}`                  |
| `tolerations`                        | Tolerations for haproxy pods assignment                                                   | `[]`                  |
| `updateStrategy.type`                | haproxy statefulset strategy type                                                         | `RollingUpdate`       |
| `priorityClassName`                  | haproxy pods' priorityClassName                                                           | `""`                  |
| `lifecycleHooks`                     | for the haproxy container(s) to automate configuration before or after startup            | `{}`                  |
| `extraEnvVars`                       | Array with extra environment variables to add to haproxy nodes                            | `[]`                  |
| `extraEnvVarsCM`                     | Name of existing ConfigMap containing extra env vars for haproxy nodes                    | `nil`                 |
| `extraEnvVarsSecret`                 | Name of existing Secret containing extra env vars for haproxy nodes                       | `nil`                 |
| `extraVolumes`                       | Optionally specify extra list of additional volumes for the haproxy pod(s)                | `[]`                  |
| `extraVolumeMounts`                  | Optionally specify extra list of additional volumeMounts for the haproxy container(s)     | `[]`                  |
| `sidecars`                           | Add additional sidecar containers to the haproxy pod(s)                                   | `[]`                  |
| `initContainers`                     | Add additional init containers to the haproxy pod(s)                                      | `{}`                  |


### Other Parameters

| Name                     | Description                                                                             | Value   |
| ------------------------ | --------------------------------------------------------------------------------------- | ------- |
| `serviceAccount.create`  | Specifies whether a ServiceAccount should be created                                    | `true`  |
| `serviceAccount.name`    | The name of the ServiceAccount to use.                                                  | `""`    |
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden) | `false` |
| `diagnosticMode.command` | Command to override all containers in the deployment                                    | `[]`    |
| `diagnosticMode.args`    | Args to override all containers in the deployment                                       | `[]`    |


The above parameters map to the env variables defined in [bitnami/haproxy](http://github.com/bitnami/bitnami-docker-haproxy). For more information please refer to the [bitnami/haproxy](http://github.com/bitnami/bitnami-docker-haproxy) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
  --set service.type=LoadBalancer \
    bitnami/haproxy
```

The above command sets the HAProxy service type as LoadBalancer.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml bitnami/haproxy
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Configuring HAProxy

By default, HAProxy is deployed with a sample, non-functional, configuration. You will need to edit the following several values to adapt it to your use case:

First, set the set the configuration to be injected in the `haproxy.cfg` file by changing the `configuration` value. Alternatively, you can provide an existing ConfigMap with `haproxy.cfg` by using the `existingConfigmap` value. The example below configures HAProxy to forward all requests to port 8080 to a service called `service1:8080` (which we assume it is accessible from inside the cluster).

```yaml
configuration: |
  global
    log 127.0.0.1 local2
    maxconn 4096

  defaults
    mode http
    log global
    option httplog
    option dontlognull
    option http-server-close
    option forwardfor except 127.0.0.0/8
    option redispatch
    retries 3
    timeout http-request 20s
    timeout queue 1m
    timeout connect 10s
    timeout client 1m
    timeout server 1m
    timeout http-keep-alive 30s
    timeout check 10s
    maxconn 3000

  frontend fe_http
    option forwardfor except 127.0.0.1
    option httpclose
    bind *:8080
    default_backend be_http

  backend be_http
    balance roundrobin
    server nginx service:8080 check port 8080
```

After that, and based on your HAProxy configuration, edit the `containerPorts` and `service.ports` values. In `containerPorts` set all the ports that the HAProxy configuration uses, and set the ports you want to externally expose in the `service.ports` value. For the example above, it would look like this:

```yaml
service:
  - name: http
    port: 80 # We use port 80 in the service
    targetPort: http

containerPorts:
  - name: http
    containerPort: 8080
```

### Additional environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `extraEnvVars` property.

```yaml
extraEnvVars:
  - name: LOG_LEVEL
    value: error
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values.

### Sidecars

If additional containers are needed in the same pod as haproxy (such as additional metrics or logging exporters), they can be defined using the `sidecars` parameter. If these sidecars export extra ports, extra port definitions can be added using the `service.extraPorts` parameter. [Learn more about configuring and using sidecar containers](https://docs.bitnami.com/kubernetes/apps/haproxy/administration/configure-use-sidecars/).

### Pod affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, use one of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).
