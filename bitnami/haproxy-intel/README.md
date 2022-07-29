<!--- app-name: HAProxy for Intel -->

# HAProxy for Intel packaged by Bitnami

HAProxy is a high-performance, open-source load balancer and reverse proxy for TCP and HTTP applications. This image is optimized with Intel(R) QuickAssist Technology OpenSSL* Engine (QAT_Engine).

[Overview of HAProxy for Intel](http://www.haproxy.org/)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/haproxy-intel --render-subchart-notes
```

## Introduction

Bitnami charts for Helm are carefully engineered, actively maintained and are the quickest and easiest way to deploy containers on a Kubernetes cluster that are ready to handle production workloads.

This chart bootstraps a [HAProxy](https://github.com/haproxytech/haproxy) Deployment in a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

[Learn more about the default configuration of the chart](https://docs.bitnami.com/kubernetes/infrastructure/haproxy/get-started/).

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release bitnami/haproxy-intel
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
| `global.imageRegistry`    | Global Docker image registry                    | `""`  |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]`  |
| `global.storageClass`     | Global StorageClass for Persistent Volume(s)    | `""`  |


### HAProxy chart parameters

| Name                        | Description                                        | Value                   |
| --------------------------- | -------------------------------------------------- | ----------------------- |
| `haproxy.image.registry`    | HAProxy image registry                             | `docker.io`             |
| `haproxy.image.repository`  | HAProxy image repository                           | `bitnami/haproxy-intel` |
| `haproxy.image.tag`         | HAProxy image tag (immutable tags are recommended) | `2.6.2-debian-11-r2`    |
| `haproxy.image.pullPolicy`  | HAProxy image pull policy                          | `IfNotPresent`          |
| `haproxy.image.pullSecrets` | HAProxy image pull secrets                         | `[]`                    |


HAProxy is installed as a subchart, meaning that the whole list of parameters is defined in [bitnami/haproxy](https://github.com/bitnami/charts/tree/master/bitnami/haproxy). Please, note that parameters from the subchart should be prefixed with `haproxy.` in this chart.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
  --set haproxy.service.type=LoadBalancer \
    bitnami/haproxy-intel --render-subchart-notes
```

The above command sets the HAProxy service type as LoadBalancer.

You can use the `configuration` or `existingConfigmap` parameters to set your own configuration file. You can read more about configuration in the [container's readme](https://github.com/bitnami/containers/tree/main/bitnami/haproxy-intel#configuration).

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml bitnami/haproxy-intel --render-subchart-notes
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Configure HAProxy

By default, HAProxy is deployed with a sample, non-functional, configuration. You will need to edit the following values to adapt it to your use case:

* Set the configuration to be injected in the `haproxy.cfg` file by changing the `haproxy.configuration` parameter. Alternatively, you can provide an existing ConfigMap with `haproxy.cfg` by using the `haproxy.existingConfigmap` parameter.
* Based on your HAProxy configuration, edit the `haproxy.containerPorts` and `haproxy.service.ports` parameters. In the `haproxy.containerPorts` parameter, set all the ports that the HAProxy configuration uses, and in the `haproxy.service.ports` parameter, set the ports to be externally exposed.

Refer to the [chart documentation for a more detailed configuration example](https://docs.bitnami.com/kubernetes/infrastructure/haproxy/get-started/configure-proxy).

### Add extra environment variables

To add extra environment variables (useful for advanced operations like custom init scripts), use the `haproxy.extraEnvVars` property.

```yaml
haproxy:
  extraEnvVars:
    - name: LOG_LEVEL
      value: error
```

Alternatively, use a ConfigMap or a Secret with the environment variables. To do so, use the `haproxy.extraEnvVarsCM` or the `haproxy.extraEnvVarsSecret` values.

### Use Sidecars and Init Containers

If additional containers are needed in the same pod (such as additional metrics or logging exporters), they can be defined using the `haproxy.sidecars` config parameter. Similarly, extra init containers can be added using the `haproxy.initContainers` parameter.

Refer to the chart documentation for more information on, and examples of, configuring and using [sidecars and init containers](https://docs.bitnami.com/kubernetes/infrastructure/haproxy/configuration/configure-sidecar-init-containers/).

### Set Pod affinity

This chart allows you to set custom Pod affinity using the `haproxy.affinity` parameter. Find more information about Pod affinity in the [Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, use one of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `haproxy.podAffinityPreset`, `haproxy.podAntiAffinityPreset`, or `haproxy.nodeAffinityPreset` parameters.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

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