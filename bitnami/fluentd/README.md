<!--- app-name: Fluentd -->

# Bitnami package for Fluentd

Fluentd collects events from various data sources and writes them to files, RDBMS, NoSQL, IaaS, SaaS, Hadoop and so on.

[Overview of Fluentd](https://www.fluentd.org)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/fluentd
```

Looking to use Fluentd in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the enterprise edition of Bitnami Application Catalog.

## Introduction

This chart bootstraps a [Fluentd](https://github.com/bitnami/containers/tree/main/bitnami/fluentd) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+
- PV provisioner support in the underlying infrastructure

> Note: Please, note that the forwarder runs the container as root by default setting the `forwarder.securityContext.runAsUser` to `0` (_root_ user)

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/fluentd
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

These commands deploy Fluentd on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Configuration and installation details

### Resource requests and limits

Bitnami charts allow setting resource requests and limits for all containers inside the chart deployment. These are inside the `resources` value (check parameter table). Setting requests is essential for production workloads and these should be adapted to your specific use case.

To make this process easier, the chart contains the `resourcesPreset` values, which automatically sets the `resources` section according to different presets. Check these presets in [the bitnami/common chart](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15). However, in production workloads using `resourcePreset` is discouraged as it may not fully adapt to your specific needs. Find more information on container resource management in the [official Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).

### [Rolling VS Immutable tags](https://docs.vmware.com/en/VMware-Tanzu-Application-Catalog/services/tutorials/GUID-understand-rolling-tags-containers-index.html)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Forwarding the logs to another service

By default, the aggregators in this chart will send the processed logs to the standard output. However, a common practice is to send them to another service, like Elasticsearch, instead. This can be achieved with this Helm Chart by mounting your own configuration files. For example:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: elasticsearch-output
data:
  fluentd.conf: |
    # Prometheus Exporter Plugin
    # input plugin that exports metrics
    <source>
      @type prometheus
      port 24231
    </source>

    # input plugin that collects metrics from MonitorAgent
    <source>
      @type prometheus_monitor
      <labels>
        host ${hostname}
      </labels>
    </source>

    # input plugin that collects metrics for output plugin
    <source>
      @type prometheus_output_monitor
      <labels>
        host ${hostname}
      </labels>
    </source>

    # Ignore fluentd own events
    <match fluent.**>
      @type null
    </match>

    # TCP input to receive logs from the forwarders
    <source>
      @type forward
      bind 0.0.0.0
      port 24224
    </source>

    # HTTP input for the liveness and readiness probes
    <source>
      @type http
      bind 0.0.0.0
      port 9880
    </source>

    # Throw the healthcheck to the standard output instead of forwarding it
    <match fluentd.healthcheck>
      @type stdout
    </match>

    # Send the logs to the standard output
    <match **>
      @type elasticsearch
      include_tag_key true
      host "#{ENV['ELASTICSEARCH_HOST']}"
      port "#{ENV['ELASTICSEARCH_PORT']}"
      logstash_format true

      <buffer>
        @type file
        path /opt/bitnami/fluentd/logs/buffers/logs.buffer
        flush_thread_count 2
        flush_interval 5s
      </buffer>
    </match>
```

As an example, using the above configmap, you should specify the required parameters when upgrading or installing the chart:

```console
aggregator.configMap=elasticsearch-output
aggregator.extraEnv[0].name=ELASTICSEARCH_HOST
aggregator.extraEnv[0].value=your-ip-here
aggregator.extraEnv[1].name=ELASTICSEARCH_PORT
aggregator.extraEnv[1].value=your-port-here
```

### Using custom init scripts

For advanced operations, the Bitnami Fluentd charts allows using custom init scripts that will be mounted inside `/docker-entrypoint.init-db`. You can include the file directly in your `values.yaml`, depending on where you are going to initialize your scripts with `aggregator.initScripts` (or `forwarder.initScripts`), or use a ConfigMap or a Secret (in case of sensitive data) for mounting these extra scripts. In this case you use the `aggregator.initScriptsCM` and `aggregator.initScriptsSecret` values (the same for `forwarder`).

```console
initScriptsCM=special-scripts
initScriptsSecret=special-scripts-sensitive
```

### Forwarder Security Context & Policy

By default, the **forwarder** `DaemonSet` from this chart **runs as the `root` user**, within the `root` group, assigning `root` file system permissions. This is different to the default behaviour of most Bitnami Helm charts where we [prefer to work with non-root containers](https://docs.vmware.com/en/VMware-Tanzu-Application-Catalog/services/tutorials/GUID-work-with-non-root-containers-index.html).

The default behaviour is to run as `root` because:

- the forwarder needs to mount `hostPath` volumes from the underlying node to read Docker container (& potentially other) logs
- in many Kubernetes node distributions, these log files are not readable by anyone other than `root`
- `fsGroup` doesn't work with `hostPath` volumes to allow the process to run non-root with alternate file system permissions

Since we would like the chart to work out-of-the-box for as many users as possible, the `forwarder` thus runs as root by default. You can read more about the motivation for this at [#1905](https://github.com/bitnami/charts/issues/1905) and [#2323](https://github.com/bitnami/charts/pull/2323), however you should be aware of this, and the risks of running root containers in general.

If you enable the forwarder's [bundled PodSecurityPolicy](https://github.com/bitnami/charts/tree/main/bitnami/fluentd/templates/forwarder-psp.yaml) with `forwarder.rbac.pspEnabled=true` it will allow the pod to run as `root` by default, while ensuring as many other privileges as possible are dropped.

#### Running as non-root

You can run as the `fluentd` user/group (non-root) with the below overrides if:

- you have control of the `hostPath` filesystem permissions on your nodes sufficient to allow the fluentd user to read from them
- don't need to write to the `hostPath`s

Note that if you have enabled the [bundled PodSecurityPolicy](https://github.com/bitnami/charts/tree/main/bitnami/fluentd/templates/forwarder-psp.yaml), it will adapt to the Chart values overrides.

```yaml
forwarder:
  daemonUser: fluentd
  daemonGroup: fluentd

  securityContext:
    runAsUser: 1001
    runAsGroup: 1001
    fsGroup: 1001
```

#### Pod Security Policy & Custom `hostPath`s

Mounting additional `hostPath`s is sometimes required to deal with `/var/lib` being symlinked on some Kubernetes environments. If you need to do so, the [bundled PodSecurityPolicy](https://github.com/bitnami/charts/tree/main/bitnami/fluentd/templates/forwarder-psp.yaml) will likely not meet your needs, as it whitelists only the standard `hostPath`s.

### Setting Pod's affinity

This chart allows you to set your custom affinity using the `XXX.affinity` parameter(s). Find more information about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities) chart. To do so, set the `XXX.podAffinityPreset`, `XXX.podAntiAffinityPreset`, or `XXX.nodeAffinityPreset` parameters.

## Parameters

### Global parameters

| Name                                                  | Description                                                                                                                                                                                                                                                                                                                                                         | Value  |
| ----------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------ |
| `global.imageRegistry`                                | Global Docker image registry                                                                                                                                                                                                                                                                                                                                        | `""`   |
| `global.imagePullSecrets`                             | Global Docker registry secret names as an array                                                                                                                                                                                                                                                                                                                     | `[]`   |
| `global.storageClass`                                 | Global StorageClass for Persistent Volume(s)                                                                                                                                                                                                                                                                                                                        | `""`   |
| `global.compatibility.openshift.adaptSecurityContext` | Adapt the securityContext sections of the deployment to make them compatible with Openshift restricted-v2 SCC: remove runAsUser, runAsGroup and fsGroup and let the platform use their allowed default IDs. Possible values: auto (apply if the detected running cluster is Openshift), force (perform the adaptation always), disabled (do not perform adaptation) | `auto` |

### Common parameters

| Name                     | Description                                                                                  | Value           |
| ------------------------ | -------------------------------------------------------------------------------------------- | --------------- |
| `kubeVersion`            | Force target Kubernetes version (using Helm capabilities if not set)                         | `""`            |
| `nameOverride`           | String to partially override common.names.fullname template (will maintain the release name) | `""`            |
| `fullnameOverride`       | String to fully override common.names.fullname template                                      | `""`            |
| `commonAnnotations`      | Annotations to add to all deployed objects                                                   | `{}`            |
| `commonLabels`           | Labels to add to all deployed objects                                                        | `{}`            |
| `clusterDomain`          | Cluster Domain                                                                               | `cluster.local` |
| `extraDeploy`            | Array of extra objects to deploy with the release                                            | `[]`            |
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden)      | `false`         |
| `diagnosticMode.command` | Command to override all containers in the deployment                                         | `["sleep"]`     |
| `diagnosticMode.args`    | Args to override all containers in the deployment                                            | `["infinity"]`  |

### Fluentd parameters

| Name                                                           | Description                                                                                                                                                                                                                             | Value                                                      |
| -------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------- |
| `image.registry`                                               | Fluentd image registry                                                                                                                                                                                                                  | `REGISTRY_NAME`                                            |
| `image.repository`                                             | Fluentd image repository                                                                                                                                                                                                                | `REPOSITORY_NAME/fluentd`                                  |
| `image.pullPolicy`                                             | Fluentd image pull policy                                                                                                                                                                                                               | `IfNotPresent`                                             |
| `image.pullSecrets`                                            | Fluentd image pull secrets                                                                                                                                                                                                              | `[]`                                                       |
| `image.debug`                                                  | Enable image debug mode                                                                                                                                                                                                                 | `false`                                                    |
| `forwarder.enabled`                                            | Enable forwarder daemonset                                                                                                                                                                                                              | `true`                                                     |
| `forwarder.image.registry`                                     | Fluentd forwarder image registry override                                                                                                                                                                                               | `""`                                                       |
| `forwarder.image.repository`                                   | Fluentd forwarder image repository override                                                                                                                                                                                             | `""`                                                       |
| `forwarder.daemonUser`                                         | Forwarder daemon user and group (set to root by default because it reads from host paths)                                                                                                                                               | `root`                                                     |
| `forwarder.daemonGroup`                                        | Fluentd forwarder daemon system group                                                                                                                                                                                                   | `root`                                                     |
| `forwarder.automountServiceAccountToken`                       | Mount Service Account token in pod                                                                                                                                                                                                      | `true`                                                     |
| `forwarder.hostAliases`                                        | Add deployment host aliases                                                                                                                                                                                                             | `[]`                                                       |
| `forwarder.podSecurityContext.enabled`                         | Enable security context for forwarder pods                                                                                                                                                                                              | `true`                                                     |
| `forwarder.podSecurityContext.fsGroupChangePolicy`             | Set filesystem group change policy                                                                                                                                                                                                      | `Always`                                                   |
| `forwarder.podSecurityContext.sysctls`                         | Set kernel settings using the sysctl interface                                                                                                                                                                                          | `[]`                                                       |
| `forwarder.podSecurityContext.supplementalGroups`              | Set filesystem extra groups                                                                                                                                                                                                             | `[]`                                                       |
| `forwarder.podSecurityContext.fsGroup`                         | Group ID for forwarder's containers filesystem                                                                                                                                                                                          | `0`                                                        |
| `forwarder.containerSecurityContext.enabled`                   | Enable security context for the forwarder container                                                                                                                                                                                     | `true`                                                     |
| `forwarder.containerSecurityContext.seLinuxOptions`            | Set SELinux options in container                                                                                                                                                                                                        | `{}`                                                       |
| `forwarder.containerSecurityContext.runAsUser`                 | User ID for forwarder's containers                                                                                                                                                                                                      | `0`                                                        |
| `forwarder.containerSecurityContext.runAsGroup`                | Group ID for forwarder's containers                                                                                                                                                                                                     | `0`                                                        |
| `forwarder.containerSecurityContext.privileged`                | Run as privileged                                                                                                                                                                                                                       | `false`                                                    |
| `forwarder.containerSecurityContext.allowPrivilegeEscalation`  | Allow Privilege Escalation                                                                                                                                                                                                              | `false`                                                    |
| `forwarder.containerSecurityContext.readOnlyRootFilesystem`    | Require the use of a read only root file system                                                                                                                                                                                         | `true`                                                     |
| `forwarder.containerSecurityContext.capabilities.drop`         | Drop capabilities for the securityContext                                                                                                                                                                                               | `[]`                                                       |
| `forwarder.containerSecurityContext.seccompProfile.type`       | Set container's Security Context seccomp profile                                                                                                                                                                                        | `RuntimeDefault`                                           |
| `forwarder.hostNetwork`                                        | Enable use of host network                                                                                                                                                                                                              | `false`                                                    |
| `forwarder.dnsPolicy`                                          | Pod-specific DNS policy                                                                                                                                                                                                                 | `""`                                                       |
| `forwarder.terminationGracePeriodSeconds`                      | Duration in seconds the pod needs to terminate gracefully                                                                                                                                                                               | `30`                                                       |
| `forwarder.extraGems`                                          | List of extra gems to be installed. Can be used to install additional fluentd plugins.                                                                                                                                                  | `[]`                                                       |
| `forwarder.configFile`                                         | Name of the config file that will be used by Fluentd at launch under the `/opt/bitnami/fluentd/conf` directory                                                                                                                          | `fluentd.conf`                                             |
| `forwarder.configMap`                                          | Name of the config map that contains the Fluentd configuration files                                                                                                                                                                    | `""`                                                       |
| `forwarder.configMapFiles`                                     | Files to be added to be config map. Ignored if `forwarder.configMap` is set                                                                                                                                                             | `{}`                                                       |
| `forwarder.extraArgs`                                          | Extra arguments for the Fluentd command line                                                                                                                                                                                            | `""`                                                       |
| `forwarder.extraEnvVars`                                       | Extra environment variables to pass to the container                                                                                                                                                                                    | `[]`                                                       |
| `forwarder.extraEnvVarsCM`                                     | Name of existing ConfigMap containing extra env vars for Fluentd Forwarder nodes                                                                                                                                                        | `""`                                                       |
| `forwarder.extraEnvVarsSecret`                                 | Name of existing Secret containing extra env vars for Fluentd Forwarder nodes                                                                                                                                                           | `""`                                                       |
| `forwarder.containerPorts`                                     | Ports the forwarder containers will listen on                                                                                                                                                                                           | `[]`                                                       |
| `forwarder.service.type`                                       | Kubernetes service type (`ClusterIP`, `NodePort`, or `LoadBalancer`) for the forwarders                                                                                                                                                 | `ClusterIP`                                                |
| `forwarder.service.ports`                                      | Array containing the forwarder service ports                                                                                                                                                                                            | `{}`                                                       |
| `forwarder.service.loadBalancerIP`                             | loadBalancerIP if service type is `LoadBalancer` (optional, cloud specific)                                                                                                                                                             | `""`                                                       |
| `forwarder.service.loadBalancerSourceRanges`                   | Addresses that are allowed when service is LoadBalancer                                                                                                                                                                                 | `[]`                                                       |
| `forwarder.service.externalTrafficPolicy`                      | Fluentd Forwarder service external traffic policy                                                                                                                                                                                       | `Cluster`                                                  |
| `forwarder.service.clusterIP`                                  | Static clusterIP or None for headless services                                                                                                                                                                                          | `""`                                                       |
| `forwarder.service.annotations`                                | Provide any additional annotations which may be required                                                                                                                                                                                | `{}`                                                       |
| `forwarder.service.sessionAffinity`                            | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                                                                                                                                                                    | `None`                                                     |
| `forwarder.service.sessionAffinityConfig`                      | Additional settings for the sessionAffinity                                                                                                                                                                                             | `{}`                                                       |
| `forwarder.networkPolicy.enabled`                              | Specifies whether a NetworkPolicy should be created                                                                                                                                                                                     | `true`                                                     |
| `forwarder.networkPolicy.allowExternal`                        | Don't require server label for connections                                                                                                                                                                                              | `true`                                                     |
| `forwarder.networkPolicy.allowExternalEgress`                  | Allow the pod to access any range of port and all destinations.                                                                                                                                                                         | `true`                                                     |
| `forwarder.networkPolicy.kubeAPIServerPorts`                   | List of possible endpoints to kube-apiserver (limit to your cluster settings to increase security)                                                                                                                                      | `[]`                                                       |
| `forwarder.networkPolicy.extraIngress`                         | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                                            | `[]`                                                       |
| `forwarder.networkPolicy.extraEgress`                          | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                                            | `[]`                                                       |
| `forwarder.networkPolicy.ingressNSMatchLabels`                 | Labels to match to allow traffic from other namespaces                                                                                                                                                                                  | `{}`                                                       |
| `forwarder.networkPolicy.ingressNSPodMatchLabels`              | Pod labels to match to allow traffic from other namespaces                                                                                                                                                                              | `{}`                                                       |
| `forwarder.startupProbe.enabled`                               | Enable startupProbe                                                                                                                                                                                                                     | `false`                                                    |
| `forwarder.startupProbe.httpGet.path`                          | Request path for startupProbe                                                                                                                                                                                                           | `/fluentd.healthcheck?json=%7B%22ping%22%3A+%22pong%22%7D` |
| `forwarder.startupProbe.httpGet.port`                          | Port for startupProbe                                                                                                                                                                                                                   | `http`                                                     |
| `forwarder.startupProbe.initialDelaySeconds`                   | Initial delay seconds for startupProbe                                                                                                                                                                                                  | `60`                                                       |
| `forwarder.startupProbe.periodSeconds`                         | Period seconds for startupProbe                                                                                                                                                                                                         | `10`                                                       |
| `forwarder.startupProbe.timeoutSeconds`                        | Timeout seconds for startupProbe                                                                                                                                                                                                        | `5`                                                        |
| `forwarder.startupProbe.failureThreshold`                      | Failure threshold for startupProbe                                                                                                                                                                                                      | `6`                                                        |
| `forwarder.startupProbe.successThreshold`                      | Success threshold for startupProbe                                                                                                                                                                                                      | `1`                                                        |
| `forwarder.livenessProbe.enabled`                              | Enable livenessProbe                                                                                                                                                                                                                    | `true`                                                     |
| `forwarder.livenessProbe.httpGet.path`                         | Request path for livenessProbe                                                                                                                                                                                                          | `/fluentd.healthcheck?json=%7B%22ping%22%3A+%22pong%22%7D` |
| `forwarder.livenessProbe.httpGet.port`                         | Port for livenessProbe                                                                                                                                                                                                                  | `http`                                                     |
| `forwarder.livenessProbe.initialDelaySeconds`                  | Initial delay seconds for livenessProbe                                                                                                                                                                                                 | `60`                                                       |
| `forwarder.livenessProbe.periodSeconds`                        | Period seconds for livenessProbe                                                                                                                                                                                                        | `10`                                                       |
| `forwarder.livenessProbe.timeoutSeconds`                       | Timeout seconds for livenessProbe                                                                                                                                                                                                       | `5`                                                        |
| `forwarder.livenessProbe.failureThreshold`                     | Failure threshold for livenessProbe                                                                                                                                                                                                     | `6`                                                        |
| `forwarder.livenessProbe.successThreshold`                     | Success threshold for livenessProbe                                                                                                                                                                                                     | `1`                                                        |
| `forwarder.readinessProbe.enabled`                             | Enable readinessProbe                                                                                                                                                                                                                   | `true`                                                     |
| `forwarder.readinessProbe.httpGet.path`                        | Request path for readinessProbe                                                                                                                                                                                                         | `/fluentd.healthcheck?json=%7B%22ping%22%3A+%22pong%22%7D` |
| `forwarder.readinessProbe.httpGet.port`                        | Port for readinessProbe                                                                                                                                                                                                                 | `http`                                                     |
| `forwarder.readinessProbe.initialDelaySeconds`                 | Initial delay seconds for readinessProbe                                                                                                                                                                                                | `5`                                                        |
| `forwarder.readinessProbe.periodSeconds`                       | Period seconds for readinessProbe                                                                                                                                                                                                       | `10`                                                       |
| `forwarder.readinessProbe.timeoutSeconds`                      | Timeout seconds for readinessProbe                                                                                                                                                                                                      | `5`                                                        |
| `forwarder.readinessProbe.failureThreshold`                    | Failure threshold for readinessProbe                                                                                                                                                                                                    | `6`                                                        |
| `forwarder.readinessProbe.successThreshold`                    | Success threshold for readinessProbe                                                                                                                                                                                                    | `1`                                                        |
| `forwarder.customStartupProbe`                                 | Custom liveness probe for the Fluend Forwarder                                                                                                                                                                                          | `{}`                                                       |
| `forwarder.customLivenessProbe`                                | Custom liveness probe for the Fluend Forwarder                                                                                                                                                                                          | `{}`                                                       |
| `forwarder.customReadinessProbe`                               | Custom rediness probe for the Fluend Forwarder                                                                                                                                                                                          | `{}`                                                       |
| `forwarder.updateStrategy.type`                                | Set up update strategy.                                                                                                                                                                                                                 | `RollingUpdate`                                            |
| `forwarder.resourcesPreset`                                    | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if forwarder.resources is set (forwarder.resources is recommended for production).   | `nano`                                                     |
| `forwarder.resources`                                          | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                       | `{}`                                                       |
| `forwarder.priorityClassName`                                  | Set Priority Class Name to allow priority control over other pods                                                                                                                                                                       | `""`                                                       |
| `forwarder.schedulerName`                                      | Name of the k8s scheduler (other than default)                                                                                                                                                                                          | `""`                                                       |
| `forwarder.topologySpreadConstraints`                          | Topology Spread Constraints for pod assignment                                                                                                                                                                                          | `[]`                                                       |
| `forwarder.podAffinityPreset`                                  | Forwarder Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                           | `""`                                                       |
| `forwarder.podAntiAffinityPreset`                              | Forwarder Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                      | `""`                                                       |
| `forwarder.nodeAffinityPreset.type`                            | Forwarder Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                     | `""`                                                       |
| `forwarder.nodeAffinityPreset.key`                             | Forwarder Node label key to match Ignored if `affinity` is set.                                                                                                                                                                         | `""`                                                       |
| `forwarder.nodeAffinityPreset.values`                          | Forwarder Node label values to match. Ignored if `affinity` is set.                                                                                                                                                                     | `[]`                                                       |
| `forwarder.affinity`                                           | Forwarder Affinity for pod assignment                                                                                                                                                                                                   | `{}`                                                       |
| `forwarder.nodeSelector`                                       | Forwarder Node labels for pod assignment                                                                                                                                                                                                | `{}`                                                       |
| `forwarder.tolerations`                                        | Forwarder Tolerations for pod assignment                                                                                                                                                                                                | `[]`                                                       |
| `forwarder.podAnnotations`                                     | Pod annotations                                                                                                                                                                                                                         | `{}`                                                       |
| `forwarder.podLabels`                                          | Extra labels to add to Pod                                                                                                                                                                                                              | `{}`                                                       |
| `forwarder.serviceAccount.create`                              | Specify whether a ServiceAccount should be created.                                                                                                                                                                                     | `true`                                                     |
| `forwarder.serviceAccount.name`                                | The name of the ServiceAccount to create                                                                                                                                                                                                | `""`                                                       |
| `forwarder.serviceAccount.annotations`                         | Additional Service Account annotations (evaluated as a template)                                                                                                                                                                        | `{}`                                                       |
| `forwarder.serviceAccount.automountServiceAccountToken`        | Automount service account token for the server service account                                                                                                                                                                          | `false`                                                    |
| `forwarder.rbac.create`                                        | Specify whether RBAC resources should be created and used, allowing the get, watch and list of pods/namespaces                                                                                                                          | `true`                                                     |
| `forwarder.rbac.pspEnabled`                                    | Whether to create a PodSecurityPolicy and bound it with RBAC. WARNING: PodSecurityPolicy is deprecated in Kubernetes v1.21 or later, unavailable in v1.25 or later                                                                      | `false`                                                    |
| `forwarder.persistence.enabled`                                | Enable persistence volume for the forwarder                                                                                                                                                                                             | `false`                                                    |
| `forwarder.persistence.hostPath.path`                          | Directory from the host node's filesystem to mount as hostPath volume for persistence.                                                                                                                                                  | `/opt/bitnami/fluentd/logs/buffers`                        |
| `forwarder.command`                                            | Override default container command (useful when using custom images)                                                                                                                                                                    | `[]`                                                       |
| `forwarder.args`                                               | Override default container args (useful when using custom images)                                                                                                                                                                       | `[]`                                                       |
| `forwarder.lifecycleHooks`                                     | Additional lifecycles to add to the pods                                                                                                                                                                                                | `{}`                                                       |
| `forwarder.initResourcePresets`                                | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if aggregator.resources is set (aggregator.resources is recommended for production). | `nano`                                                     |
| `forwarder.initResources`                                      | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                       | `{}`                                                       |
| `forwarder.initContainers`                                     | Additional init containers to add to the pods                                                                                                                                                                                           | `[]`                                                       |
| `forwarder.sidecars`                                           | Add sidecars to forwarder pods                                                                                                                                                                                                          | `[]`                                                       |
| `forwarder.extraVolumes`                                       | Extra volumes                                                                                                                                                                                                                           | `[]`                                                       |
| `forwarder.extraVolumeMounts`                                  | Mount extra volume(s)                                                                                                                                                                                                                   | `[]`                                                       |
| `forwarder.initScripts`                                        | Dictionary of init scripts. Evaluated as a template.                                                                                                                                                                                    | `{}`                                                       |
| `forwarder.initScriptsCM`                                      | ConfigMap with the init scripts. Evaluated as a template.                                                                                                                                                                               | `""`                                                       |
| `forwarder.initScriptsSecret`                                  | Secret containing `/docker-entrypoint-initdb.d` scripts to be executed at initialization time that contain sensitive data. Evaluated as a template.                                                                                     | `""`                                                       |
| `aggregator.enabled`                                           | Enable Fluentd aggregator statefulset                                                                                                                                                                                                   | `true`                                                     |
| `aggregator.image.registry`                                    | Fluentd aggregator image registry override                                                                                                                                                                                              | `""`                                                       |
| `aggregator.image.repository`                                  | Fluentd aggregator image repository override                                                                                                                                                                                            | `""`                                                       |
| `aggregator.replicaCount`                                      | Number of aggregator pods to deploy in the Stateful Set                                                                                                                                                                                 | `1`                                                        |
| `aggregator.podSecurityContext.enabled`                        | Enable security context for aggregator pods                                                                                                                                                                                             | `true`                                                     |
| `aggregator.podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                                      | `Always`                                                   |
| `aggregator.podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                                          | `[]`                                                       |
| `aggregator.podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                                             | `[]`                                                       |
| `aggregator.podSecurityContext.fsGroup`                        | Group ID for aggregator's containers filesystem                                                                                                                                                                                         | `1001`                                                     |
| `aggregator.automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                                      | `false`                                                    |
| `aggregator.hostAliases`                                       | Add deployment host aliases                                                                                                                                                                                                             | `[]`                                                       |
| `aggregator.containerSecurityContext.enabled`                  | Enable security context for the aggregator container                                                                                                                                                                                    | `true`                                                     |
| `aggregator.containerSecurityContext.privileged`               | Run as privileged                                                                                                                                                                                                                       | `false`                                                    |
| `aggregator.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                                        | `{}`                                                       |
| `aggregator.containerSecurityContext.runAsUser`                | User ID for aggregator's containers                                                                                                                                                                                                     | `1001`                                                     |
| `aggregator.containerSecurityContext.runAsGroup`               | Group ID for aggregator's containers                                                                                                                                                                                                    | `1001`                                                     |
| `aggregator.containerSecurityContext.allowPrivilegeEscalation` | Allow Privilege Escalation                                                                                                                                                                                                              | `false`                                                    |
| `aggregator.containerSecurityContext.readOnlyRootFilesystem`   | Require the use of a read only root file system                                                                                                                                                                                         | `true`                                                     |
| `aggregator.containerSecurityContext.capabilities.drop`        | Drop capabilities for the securityContext                                                                                                                                                                                               | `[]`                                                       |
| `aggregator.containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                                        | `RuntimeDefault`                                           |
| `aggregator.terminationGracePeriodSeconds`                     | Duration in seconds the pod needs to terminate gracefully                                                                                                                                                                               | `30`                                                       |
| `aggregator.extraGems`                                         | List of extra gems to be installed. Can be used to install additional fluentd plugins.                                                                                                                                                  | `[]`                                                       |
| `aggregator.configFile`                                        | Name of the config file that will be used by Fluentd at launch under the `/opt/bitnami/fluentd/conf` directory                                                                                                                          | `fluentd.conf`                                             |
| `aggregator.configMap`                                         | Name of the config map that contains the Fluentd configuration files                                                                                                                                                                    | `""`                                                       |
| `aggregator.configMapFiles`                                    | Files to be added to be config map. Ignored if `aggregator.configMap` is set                                                                                                                                                            | `{}`                                                       |
| `aggregator.port`                                              | Port the Aggregator container will listen for logs. Leave it blank to ignore.                                                                                                                                                           | `24224`                                                    |
| `aggregator.extraArgs`                                         | Extra arguments for the Fluentd command line                                                                                                                                                                                            | `""`                                                       |
| `aggregator.extraEnvVars`                                      | Extra environment variables to pass to the container                                                                                                                                                                                    | `[]`                                                       |
| `aggregator.extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for Fluentd Aggregator nodes                                                                                                                                                       | `""`                                                       |
| `aggregator.extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for Fluentd Aggregator nodes                                                                                                                                                          | `""`                                                       |
| `aggregator.containerPorts`                                    | Ports the aggregator containers will listen on                                                                                                                                                                                          | `[]`                                                       |
| `aggregator.service.type`                                      | Kubernetes service type (`ClusterIP`, `NodePort`, or `LoadBalancer`) for the aggregators                                                                                                                                                | `ClusterIP`                                                |
| `aggregator.service.ports`                                     | Array containing the aggregator service ports                                                                                                                                                                                           | `{}`                                                       |
| `aggregator.service.loadBalancerIP`                            | loadBalancerIP if service type is `LoadBalancer` (optional, cloud specific)                                                                                                                                                             | `""`                                                       |
| `aggregator.service.loadBalancerSourceRanges`                  | Addresses that are allowed when service is LoadBalancer                                                                                                                                                                                 | `[]`                                                       |
| `aggregator.service.clusterIP`                                 | Static clusterIP or None for headless services                                                                                                                                                                                          | `""`                                                       |
| `aggregator.service.annotations`                               | Provide any additional annotations which may be required                                                                                                                                                                                | `{}`                                                       |
| `aggregator.service.externalTrafficPolicy`                     | Fluentd Aggregator service external traffic policy                                                                                                                                                                                      | `Cluster`                                                  |
| `aggregator.service.sessionAffinity`                           | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                                                                                                                                                                    | `None`                                                     |
| `aggregator.service.sessionAffinityConfig`                     | Additional settings for the sessionAffinity                                                                                                                                                                                             | `{}`                                                       |
| `aggregator.service.annotationsHeadless`                       | Provide any additional annotations which may be required on headless service                                                                                                                                                            | `{}`                                                       |
| `aggregator.service.headless.annotations`                      | Annotations for the headless service.                                                                                                                                                                                                   | `{}`                                                       |
| `aggregator.networkPolicy.enabled`                             | Specifies whether a NetworkPolicy should be created                                                                                                                                                                                     | `true`                                                     |
| `aggregator.networkPolicy.allowExternal`                       | Don't require server label for connections                                                                                                                                                                                              | `true`                                                     |
| `aggregator.networkPolicy.allowExternalEgress`                 | Allow the pod to access any range of port and all destinations.                                                                                                                                                                         | `true`                                                     |
| `aggregator.networkPolicy.extraIngress`                        | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                                            | `[]`                                                       |
| `aggregator.networkPolicy.extraEgress`                         | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                                            | `[]`                                                       |
| `aggregator.networkPolicy.ingressNSMatchLabels`                | Labels to match to allow traffic from other namespaces                                                                                                                                                                                  | `{}`                                                       |
| `aggregator.networkPolicy.ingressNSPodMatchLabels`             | Pod labels to match to allow traffic from other namespaces                                                                                                                                                                              | `{}`                                                       |
| `aggregator.ingress.enabled`                                   | Set to true to enable ingress record generation                                                                                                                                                                                         | `false`                                                    |
| `aggregator.ingress.pathType`                                  | Ingress Path type. How the path matching is interpreted                                                                                                                                                                                 | `ImplementationSpecific`                                   |
| `aggregator.ingress.apiVersion`                                | Override API Version (automatically detected if not set)                                                                                                                                                                                | `""`                                                       |
| `aggregator.ingress.hostname`                                  | Default host for the ingress resource                                                                                                                                                                                                   | `fluentd.local`                                            |
| `aggregator.ingress.path`                                      | Default path for the ingress resource                                                                                                                                                                                                   | `/`                                                        |
| `aggregator.ingress.annotations`                               | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations.                                                                                                        | `{}`                                                       |
| `aggregator.ingress.tls`                                       | Enable TLS configuration for the hostname defined at ingress.hostname parameter                                                                                                                                                         | `false`                                                    |
| `aggregator.ingress.extraHosts`                                | The list of additional hostnames to be covered with this ingress record.                                                                                                                                                                | `[]`                                                       |
| `aggregator.ingress.extraPaths`                                | Any additional arbitrary paths that may need to be added to the ingress under the main host.                                                                                                                                            | `[]`                                                       |
| `aggregator.ingress.extraTls`                                  | The tls configuration for additional hostnames to be covered with this ingress record.                                                                                                                                                  | `[]`                                                       |
| `aggregator.ingress.secrets`                                   | If you're providing your own certificates, please use this to add the certificates as secrets                                                                                                                                           | `[]`                                                       |
| `aggregator.ingress.ingressClassName`                          | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                                                                                                                           | `""`                                                       |
| `aggregator.ingress.extraRules`                                | Additional rules to be covered with this ingress record                                                                                                                                                                                 | `[]`                                                       |
| `aggregator.startupProbe.enabled`                              | Enable startupProbe                                                                                                                                                                                                                     | `true`                                                     |
| `aggregator.startupProbe.httpGet.path`                         | Request path for startupProbe                                                                                                                                                                                                           | `/fluentd.healthcheck?json=%7B%22ping%22%3A+%22pong%22%7D` |
| `aggregator.startupProbe.httpGet.port`                         | Port for startupProbe                                                                                                                                                                                                                   | `http`                                                     |
| `aggregator.startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                                                  | `60`                                                       |
| `aggregator.startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                                         | `10`                                                       |
| `aggregator.startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                                        | `5`                                                        |
| `aggregator.startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                                      | `6`                                                        |
| `aggregator.startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                                      | `1`                                                        |
| `aggregator.livenessProbe.enabled`                             | Enable livenessProbe                                                                                                                                                                                                                    | `true`                                                     |
| `aggregator.livenessProbe.httpGet.path`                        | Request path for livenessProbe                                                                                                                                                                                                          | `/fluentd.healthcheck?json=%7B%22ping%22%3A+%22pong%22%7D` |
| `aggregator.livenessProbe.httpGet.port`                        | Port for livenessProbe                                                                                                                                                                                                                  | `http`                                                     |
| `aggregator.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                                                 | `60`                                                       |
| `aggregator.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                                        | `10`                                                       |
| `aggregator.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                                       | `5`                                                        |
| `aggregator.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                                                     | `6`                                                        |
| `aggregator.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                                                     | `1`                                                        |
| `aggregator.readinessProbe.enabled`                            | Enable readinessProbe                                                                                                                                                                                                                   | `true`                                                     |
| `aggregator.readinessProbe.httpGet.path`                       | Request path for readinessProbe                                                                                                                                                                                                         | `/fluentd.healthcheck?json=%7B%22ping%22%3A+%22pong%22%7D` |
| `aggregator.readinessProbe.httpGet.port`                       | Port for readinessProbe                                                                                                                                                                                                                 | `http`                                                     |
| `aggregator.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                                                | `5`                                                        |
| `aggregator.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                                       | `10`                                                       |
| `aggregator.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                                      | `5`                                                        |
| `aggregator.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                                                    | `6`                                                        |
| `aggregator.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                                                    | `1`                                                        |
| `aggregator.customStartupProbe`                                | Custom liveness probe for the Fluentd Aggregator                                                                                                                                                                                        | `{}`                                                       |
| `aggregator.customLivenessProbe`                               | Custom liveness probe for the Fluentd Aggregator                                                                                                                                                                                        | `{}`                                                       |
| `aggregator.customReadinessProbe`                              | Custom rediness probe for the Fluentd Aggregator                                                                                                                                                                                        | `{}`                                                       |
| `aggregator.updateStrategy.type`                               | Set up update strategy.                                                                                                                                                                                                                 | `RollingUpdate`                                            |
| `aggregator.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if aggregator.resources is set (aggregator.resources is recommended for production). | `nano`                                                     |
| `aggregator.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                       | `{}`                                                       |
| `aggregator.priorityClassName`                                 | Fluentd Aggregator pods' priorityClassName                                                                                                                                                                                              | `""`                                                       |
| `aggregator.schedulerName`                                     | Name of the k8s scheduler (other than default)                                                                                                                                                                                          | `""`                                                       |
| `aggregator.topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment                                                                                                                                                                                          | `[]`                                                       |
| `aggregator.podManagementPolicy`                               | podManagementPolicy to manage scaling operation of Fluentd Aggregator pods                                                                                                                                                              | `""`                                                       |
| `aggregator.podAffinityPreset`                                 | Aggregator Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                          | `""`                                                       |
| `aggregator.podAntiAffinityPreset`                             | Aggregator Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                     | `soft`                                                     |
| `aggregator.nodeAffinityPreset.type`                           | Aggregator Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                    | `""`                                                       |
| `aggregator.nodeAffinityPreset.key`                            | Aggregator Node label key to match Ignored if `affinity` is set.                                                                                                                                                                        | `""`                                                       |
| `aggregator.nodeAffinityPreset.values`                         | Aggregator Node label values to match. Ignored if `affinity` is set.                                                                                                                                                                    | `[]`                                                       |
| `aggregator.affinity`                                          | Aggregator Affinity for pod assignment                                                                                                                                                                                                  | `{}`                                                       |
| `aggregator.nodeSelector`                                      | Aggregator Node labels for pod assignment                                                                                                                                                                                               | `{}`                                                       |
| `aggregator.tolerations`                                       | Aggregator Tolerations for pod assignment                                                                                                                                                                                               | `[]`                                                       |
| `aggregator.podAnnotations`                                    | Pod annotations                                                                                                                                                                                                                         | `{}`                                                       |
| `aggregator.podLabels`                                         | Extra labels to add to Pod                                                                                                                                                                                                              | `{}`                                                       |
| `aggregator.serviceAccount.create`                             | Specify whether a ServiceAccount should be created                                                                                                                                                                                      | `true`                                                     |
| `aggregator.serviceAccount.name`                               | The name of the ServiceAccount to create                                                                                                                                                                                                | `""`                                                       |
| `aggregator.serviceAccount.annotations`                        | Additional Service Account annotations (evaluated as a template)                                                                                                                                                                        | `{}`                                                       |
| `aggregator.serviceAccount.automountServiceAccountToken`       | Automount service account token for the server service account                                                                                                                                                                          | `false`                                                    |
| `aggregator.autoscaling.enabled`                               | Create an Horizontal Pod Autoscaler                                                                                                                                                                                                     | `false`                                                    |
| `aggregator.autoscaling.minReplicas`                           | Minimum number of replicas for the HPA                                                                                                                                                                                                  | `2`                                                        |
| `aggregator.autoscaling.maxReplicas`                           | Maximum number of replicas for the HPA                                                                                                                                                                                                  | `5`                                                        |
| `aggregator.autoscaling.metrics`                               | Metrics for the HPA to manage the scaling                                                                                                                                                                                               | `[]`                                                       |
| `aggregator.autoscaling.behavior`                              | HPA Behavior                                                                                                                                                                                                                            | `{}`                                                       |
| `aggregator.persistence.enabled`                               | Enable persistence volume for the aggregator                                                                                                                                                                                            | `false`                                                    |
| `aggregator.persistence.storageClass`                          | Persistent Volume storage class                                                                                                                                                                                                         | `""`                                                       |
| `aggregator.persistence.accessModes`                           | Persistent Volume access modes                                                                                                                                                                                                          | `["ReadWriteOnce"]`                                        |
| `aggregator.persistence.size`                                  | Persistent Volume size                                                                                                                                                                                                                  | `10Gi`                                                     |
| `aggregator.persistence.selector`                              | Selector to match an existing Persistent Volume (this value is evaluated as a template)                                                                                                                                                 | `{}`                                                       |
| `aggregator.persistence.annotations`                           | Persistent Volume Claim annotations                                                                                                                                                                                                     | `{}`                                                       |
| `aggregator.command`                                           | Override default container command (useful when using custom images)                                                                                                                                                                    | `[]`                                                       |
| `aggregator.args`                                              | Override default container args (useful when using custom images)                                                                                                                                                                       | `[]`                                                       |
| `aggregator.lifecycleHooks`                                    | Additional lifecycles to add to the pods                                                                                                                                                                                                | `{}`                                                       |
| `aggregator.initResourcePresets`                               | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if aggregator.resources is set (aggregator.resources is recommended for production). | `nano`                                                     |
| `aggregator.initResources`                                     | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                       | `{}`                                                       |
| `aggregator.initContainers`                                    | Add init containers to aggregator pods                                                                                                                                                                                                  | `[]`                                                       |
| `aggregator.sidecars`                                          | Add sidecars to aggregator pods                                                                                                                                                                                                         | `[]`                                                       |
| `aggregator.extraVolumes`                                      | Extra volumes                                                                                                                                                                                                                           | `[]`                                                       |
| `aggregator.extraVolumeMounts`                                 | Mount extra volume(s)                                                                                                                                                                                                                   | `[]`                                                       |
| `aggregator.extraVolumeClaimTemplates`                         | Optionally specify extra list of additional volume claim templates for the Fluentd Aggregator pods in StatefulSet                                                                                                                       | `[]`                                                       |
| `aggregator.initScripts`                                       | Dictionary of init scripts. Evaluated as a template.                                                                                                                                                                                    | `{}`                                                       |
| `aggregator.initScriptsCM`                                     | ConfigMap with the init scripts. Evaluated as a template.                                                                                                                                                                               | `""`                                                       |
| `aggregator.initScriptsSecret`                                 | Secret containing `/docker-entrypoint-initdb.d` scripts to be executed at initialization time that contain sensitive data. Evaluated as a template.                                                                                     | `""`                                                       |
| `metrics.enabled`                                              | Enable the export of Prometheus metrics                                                                                                                                                                                                 | `false`                                                    |
| `metrics.service.type`                                         | Prometheus metrics service type                                                                                                                                                                                                         | `ClusterIP`                                                |
| `metrics.service.port`                                         | Prometheus metrics service port                                                                                                                                                                                                         | `24231`                                                    |
| `metrics.service.loadBalancerIP`                               | Load Balancer IP if the Prometheus metrics server type is `LoadBalancer`                                                                                                                                                                | `""`                                                       |
| `metrics.service.clusterIP`                                    | Prometheus metrics service Cluster IP                                                                                                                                                                                                   | `""`                                                       |
| `metrics.service.loadBalancerSourceRanges`                     | Prometheus metrics service Load Balancer sources                                                                                                                                                                                        | `[]`                                                       |
| `metrics.service.externalTrafficPolicy`                        | Prometheus metrics service external traffic policy                                                                                                                                                                                      | `Cluster`                                                  |
| `metrics.service.annotations`                                  | Annotations for the Prometheus Exporter service service                                                                                                                                                                                 | `{}`                                                       |
| `metrics.service.sessionAffinity`                              | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                                                                                                                                                                    | `None`                                                     |
| `metrics.service.sessionAffinityConfig`                        | Additional settings for the sessionAffinity                                                                                                                                                                                             | `{}`                                                       |
| `metrics.serviceMonitor.enabled`                               | if `true`, creates a Prometheus Operator ServiceMonitor (also requires `metrics.enabled` to be `true`)                                                                                                                                  | `false`                                                    |
| `metrics.serviceMonitor.namespace`                             | Namespace in which Prometheus is running                                                                                                                                                                                                | `""`                                                       |
| `metrics.serviceMonitor.interval`                              | Interval at which metrics should be scraped.                                                                                                                                                                                            | `""`                                                       |
| `metrics.serviceMonitor.scrapeTimeout`                         | Timeout after which the scrape is ended                                                                                                                                                                                                 | `""`                                                       |
| `metrics.serviceMonitor.jobLabel`                              | The name of the label on the target service to use as the job name in prometheus.                                                                                                                                                       | `""`                                                       |
| `metrics.serviceMonitor.relabelings`                           | RelabelConfigs to apply to samples before scraping                                                                                                                                                                                      | `[]`                                                       |
| `metrics.serviceMonitor.metricRelabelings`                     | MetricRelabelConfigs to apply to samples before ingestion                                                                                                                                                                               | `[]`                                                       |
| `metrics.serviceMonitor.selector`                              | Prometheus instance selector labels                                                                                                                                                                                                     | `{}`                                                       |
| `metrics.serviceMonitor.labels`                                | ServiceMonitor extra labels                                                                                                                                                                                                             | `{}`                                                       |
| `metrics.serviceMonitor.annotations`                           | ServiceMonitor annotations                                                                                                                                                                                                              | `{}`                                                       |
| `metrics.serviceMonitor.honorLabels`                           | honorLabels chooses the metric's labels on collisions with target labels                                                                                                                                                                | `false`                                                    |
| `metrics.serviceMonitor.path`                                  | path defines the path that promethues will use to pull metrics from the container                                                                                                                                                       | `/metrics`                                                 |
| `tls.enabled`                                                  | Enable TLS/SSL encrytion for internal communications                                                                                                                                                                                    | `false`                                                    |
| `tls.autoGenerated`                                            | Generate automatically self-signed TLS certificates.                                                                                                                                                                                    | `false`                                                    |
| `tls.forwarder.existingSecret`                                 | Name of the existing secret containing the TLS certificates for the Fluentd forwarder                                                                                                                                                   | `""`                                                       |
| `tls.aggregator.existingSecret`                                | Name of the existing secret containing the TLS certificates for the Fluentd aggregator                                                                                                                                                  | `""`                                                       |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
  --set aggregator.port=24444 oci://REGISTRY_NAME/REPOSITORY_NAME/fluentd
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The above command sets the aggregators to listen on port 24444.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml oci://REGISTRY_NAME/REPOSITORY_NAME/fluentd
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.
> **Tip**: You can use the default [values.yaml](https://github.com/bitnami/charts/tree/main/bitnami/fluentd/values.yaml)

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

This major release renames several values in this chart and adds missing features, in order to be inline with the rest of assets in the Bitnami charts repository.

Affected values:

- `aggregator.persistence.accessMode` has been renamed as `aggregator.persistence.accessModes` with type Array.
- `aggregator.lifecycle` and `forwarder.lifecycle` have been renamed as `aggregator.lifecycleHooks` and `forwarder.lifecycleHooks` respectively.
- `aggregator.extraEnv` and `forwarder.extraEnv` have been renamed as `aggregator.extraEnvVars` and `forwarder.extraEnvVars` respectively.
- `aggregator.securityContext` and `forwarder.securityContext` have been renamed as `aggregator.podSecurityContext` and `forwarder.podSecurityContext` respectively.
- `rbac.*` and `serviceAccount.*` have been definitely removed. Deprecation warning will no longer show.

Additionally also updates the Redis&reg; subchart to it newest major, 14.0.0, which contains similar changes.

### To 4.0.0

In this version, introduces changes to the `tls.*` settings.
The previous settings only would mount the TLS volume in the container, and have been removed as the Chart now includes `extraVolumes` and `extraVolumeMounts` which could be used for that purpose.
The new `tls.*` settings will now configure SSL/TLS certificates for the out_forward communications in the Fluentd Forwarder and in_forward in the Fluentd Aggregator, securing the communications between the Forwarder and the Aggretator.

### To 3.1.0

This version also introduces `bitnami/common`, a [library chart](https://helm.sh/docs/topics/library_charts/#helm) as a dependency. More documentation about this new utility could be found [here](https://github.com/bitnami/charts/tree/main/bitnami/common#bitnami-common-library-chart). Please, make sure that you have updated the chart dependencies before executing any upgrade.

### To 3.0.0

[On November 13, 2020, Helm v2 support was formally finished](https://github.com/helm/charts#status-of-the-project), this major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

#### What changes were introduced in this major version?

- Previous versions of this Helm Chart use `apiVersion: v1` (installable by both Helm 2 and 3), this Helm Chart was updated to `apiVersion: v2` (installable by Helm 3 only). [Here](https://helm.sh/docs/topics/charts/#the-apiversion-field) you can find more information about the `apiVersion` field.
- The different fields present in the _Chart.yaml_ file has been ordered alphabetically in a homogeneous way for all the Bitnami Helm Charts

#### Considerations when upgrading to this version

- If you want to upgrade to this version from a previous one installed with Helm v3, you shouldn't face any issues
- If you want to upgrade to this version using Helm v2, this scenario is not supported as this version doesn't support Helm v2 anymore
- If you installed the previous version with Helm v2 and wants to upgrade to this version with Helm v3, please refer to the [official Helm documentation](https://helm.sh/docs/topics/v2_v3_migration/#migration-use-cases) about migrating from Helm v2 to v3

#### Useful links

- <https://docs.vmware.com/en/VMware-Tanzu-Application-Catalog/services/tutorials/GUID-resolve-helm2-helm3-post-migration-issues-index.html>
- <https://helm.sh/docs/topics/v2_v3_migration/>
- <https://helm.sh/blog/migrate-from-helm-v2-to-helm-v3/>

### To 2.0.0

This version introduces the ability to create/customise a `ServiceAccount` to be used by the **aggregator**, making it possible to target the aggregator with [`PodSecurityPolicy`](https://kubernetes.io/docs/concepts/policy/pod-security-policy/) independent of the **forwarder**'s `ServiceAccount`.

The **forwarder** previously used the below top-level values to configure its own `ServiceAccount`, which have been moved under the `forwarder.` prefix to avoid confusion, and only created if `forwarder.enabled=true`. There is no functional change as a result of this, and if you did not override the defaults for `serviceAccount` or `rbac`, this change does not require any action from you.

If you are overriding the default values from the `1.x` chart, the chart will fail installation with your old overrides and warn you of the necessary changes.

```yaml
# before - 1.x
serviceAccount:
  create: true
  name: my-custom-service-account
  annotations:
    my-custom-annotation: my-custom-annotation-value
rbac:
  create: true

# after - 2.x
forwarder:
  # ...
  serviceAccount:
    create: true
    name: my-custom-service-account
    annotations:
      my-custom-annotation: my-custom-annotation-value
  rbac:
    create: true
```

### To 1.0.0

In this version of the chart the Fluentd forwarder daemon system user will be root by default. This is done to ensure that mounted host paths are readable by the forwarder. For more context, check this [support case](https://github.com/bitnami/charts/issues/1905).

No issues are expected in the upgrade process. However, please ensure that you add extra security measures in your cluster as you will be running root containers. If you want the daemon to be run as a user different from root, you can change the `forwarder.daemonUser` and `forwarder.daemonGroup` values. In this case make sure that the user you choose has sufficient permissions to read log files under `/var/lib/docker/containers` directory.

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