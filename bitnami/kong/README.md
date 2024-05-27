<!--- app-name: Kong -->

# Bitnami package for Kong

Kong is an open source Microservice API gateway and platform designed for managing microservices requests of high-availability, fault-tolerance, and distributed systems.

[Overview of Kong](https://konghq.com/kong-community-edition/)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/kong
```

Looking to use Kong in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the enterprise edition of Bitnami Application Catalog.

## Introduction

This chart bootstraps a [kong](https://github.com/bitnami/containers/tree/main/bitnami/kong) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager. It also includes the [kong-ingress-controller](https://github.com/bitnami/containers/tree/main/bitnami/kong-ingress-controller) container for managing Ingress resources using Kong.

Extra functionalities beyond the Kong core are extended through plugins. Kong is built on top of reliable technologies like NGINX and provides an easy-to-use RESTful API to operate and configure the system.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/kong
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

These commands deploy kong on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Configuration and installation details

### Resource requests and limits

Bitnami charts allow setting resource requests and limits for all containers inside the chart deployment. These are inside the `resources` value (check parameter table). Setting requests is essential for production workloads and these should be adapted to your specific use case.

To make this process easier, the chart contains the `resourcesPreset` values, which automatically sets the `resources` section according to different presets. Check these presets in [the bitnami/common chart](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15). However, in production workloads using `resourcePreset` is discouraged as it may not fully adapt to your specific needs. Find more information on container resource management in the [official Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).

### [Rolling VS Immutable tags](https://docs.vmware.com/en/VMware-Tanzu-Application-Catalog/services/tutorials/GUID-understand-rolling-tags-containers-index.html)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Database backend

The Bitnami Kong chart allows setting two database backends: PostgreSQL or Cassandra. For each option, there are two extra possibilities: deploy a sub-chart with the database installation or use an existing one. The list below details the different options (replace the placeholders specified between _UNDERSCORES_):

- Deploy the PostgreSQL sub-chart (default)

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/kong
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

- Use an external PostgreSQL database

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/kong \
    --set postgresql.enabled=false \
    --set postgresql.external.host=_HOST_OF_YOUR_POSTGRESQL_INSTALLATION_ \
    --set postgresql.external.password=_PASSWORD_OF_YOUR_POSTGRESQL_INSTALLATION_ \
    --set postgresql.external.user=_USER_OF_YOUR_POSTGRESQL_INSTALLATION_
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

- Deploy the Cassandra sub-chart

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/kong \
    --set database=cassandra \
    --set postgresql.enabled=false \
    --set cassandra.enabled=true
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

- Use an existing Cassandra installation

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/kong \
    --set database=cassandra \
    --set postgresql.enabled=false \
    --set cassandra.enabled=false \
    --set cassandra.external.hosts[0]=_CONTACT_POINT_0_OF_YOUR_CASSANDRA_CLUSTER_ \
    --set cassandra.external.hosts[1]=_CONTACT_POINT_1_OF_YOUR_CASSANDRA_CLUSTER_ \
    ...
    --set cassandra.external.user=_USER_OF_YOUR_CASSANDRA_INSTALLATION_ \
    --set cassandra.external.password=_PASSWORD_OF_YOUR_CASSANDRA_INSTALLATION_
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

### DB-less

Kong 1.1 added the capability to run Kong without a database, using only in-memory storage for entities: we call this DB-less mode. When running Kong DB-less, the configuration of entities is done in a second configuration file, in YAML or JSON, using declarative configuration (ref. [Link](https://legacy-gateway--kongdocs.netlify.app/gateway-oss/1.1.x/db-less-and-declarative-config/)).
As is said in step 4 of [kong official docker installation](https://docs.konghq.com/gateway/latest/production/deployment-topologies/db-less-and-declarative-config/#declarative-configuration), just add the env variable "KONG_DATABASE=off".

#### How to enable it

1. Set `database` value with any value other than "postgresql" or "cassandra". For example `database: "off"`
2. Use `kong.extraEnvVars` value to set the `KONG_DATABASE` environment variable:

```yaml
kong.extraEnvVars:
- name: KONG_DATABASE
  value: "off"
```

### Sidecars and Init Containers

If you have a need for additional containers to run within the same pod as Kong (e.g. an additional metrics or logging exporter), you can do so via the `sidecars` config parameter. Simply define your container according to the Kubernetes container spec.

```yaml
sidecars:
  - name: your-image-name
    image: your-image
    imagePullPolicy: Always
    ports:
      - name: portname
       containerPort: 1234
```

Similarly, you can add extra init containers using the `initContainers` parameter.

```yaml
initContainers:
  - name: your-image-name
    image: your-image
    imagePullPolicy: Always
    ports:
      - name: portname
        containerPort: 1234
```

### Adding extra environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `kong.extraEnvVars` property.

```yaml
kong:
  extraEnvVars:
    - name: KONG_LOG_LEVEL
      value: error
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `kong.extraEnvVarsCM` or the `kong.extraEnvVarsSecret` values.

The Kong Ingress Controller and the Kong Migration job also allow this kind of configuration via the `ingressController.extraEnvVars`, `ingressController.extraEnvVarsCM`, `ingressController.extraEnvVarsSecret`, `migration.extraEnvVars`, `migration.extraEnvVarsCM` and `migration.extraEnvVarsSecret` values.

### Using custom init scripts

For advanced operations, the Bitnami Kong charts allows using custom init scripts that will be mounted in `/docker-entrypoint.init-db`. You can use a ConfigMap or a Secret (in case of sensitive data) for mounting these extra scripts. Then use the `kong.initScriptsCM` and `kong.initScriptsSecret` values.

```console
elasticsearch.hosts[0]=elasticsearch-host
elasticsearch.port=9200
initScriptsCM=special-scripts
initScriptsSecret=special-scripts-sensitive
```

### Deploying extra resources

There are cases where you may want to deploy extra objects, such as KongPlugins, KongConsumers, amongst others. For covering this case, the chart allows adding the full specification of other objects using the `extraDeploy` parameter. The following example would activate a plugin at deployment time.

```yaml
## Extra objects to deploy (value evaluated as a template)
##
extraDeploy:
  - |
    apiVersion: configuration.konghq.com/v1
    kind: KongPlugin
    metadata:
      name: {{ include "common.names.fullname" . }}-plugin-correlation
      namespace: {{ .Release.Namespace }}
      labels: {{- include "common.labels.standard" ( dict "customLabels" .Values.commonLabels "context" $ ) | nindent 6 }}
    config:
      header_name: my-request-id
    plugin: correlation-id
```

### Setting Pod's affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

## Parameters

### Global parameters

| Name                                                  | Description                                                                                                                                                                                                                                                                                                                                                         | Value  |
| ----------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------ |
| `global.imageRegistry`                                | Global Docker image registry                                                                                                                                                                                                                                                                                                                                        | `""`   |
| `global.imagePullSecrets`                             | Global Docker registry secret names as an array                                                                                                                                                                                                                                                                                                                     | `[]`   |
| `global.storageClass`                                 | Global StorageClass for Persistent Volume(s)                                                                                                                                                                                                                                                                                                                        | `""`   |
| `global.compatibility.openshift.adaptSecurityContext` | Adapt the securityContext sections of the deployment to make them compatible with Openshift restricted-v2 SCC: remove runAsUser, runAsGroup and fsGroup and let the platform use their allowed default IDs. Possible values: auto (apply if the detected running cluster is Openshift), force (perform the adaptation always), disabled (do not perform adaptation) | `auto` |

### Common parameters

| Name                     | Description                                                                                               | Value           |
| ------------------------ | --------------------------------------------------------------------------------------------------------- | --------------- |
| `kubeVersion`            | Force target Kubernetes version (using Helm capabilities if not set)                                      | `""`            |
| `nameOverride`           | String to partially override common.names.fullname template with a string (will prepend the release name) | `""`            |
| `fullnameOverride`       | String to fully override common.names.fullname template with a string                                     | `""`            |
| `commonAnnotations`      | Common annotations to add to all Kong resources (sub-charts are not considered). Evaluated as a template  | `{}`            |
| `commonLabels`           | Common labels to add to all Kong resources (sub-charts are not considered). Evaluated as a template       | `{}`            |
| `clusterDomain`          | Kubernetes cluster domain                                                                                 | `cluster.local` |
| `extraDeploy`            | Array of extra objects to deploy with the release (evaluated as a template).                              | `[]`            |
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden)                   | `false`         |
| `diagnosticMode.command` | Command to override all containers in the daemonset/deployment                                            | `["sleep"]`     |
| `diagnosticMode.args`    | Args to override all containers in the daemonset/deployment                                               | `["infinity"]`  |

### Kong common parameters

| Name                | Description                                                                                          | Value                  |
| ------------------- | ---------------------------------------------------------------------------------------------------- | ---------------------- |
| `image.registry`    | kong image registry                                                                                  | `REGISTRY_NAME`        |
| `image.repository`  | kong image repository                                                                                | `REPOSITORY_NAME/kong` |
| `image.digest`      | kong image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag | `""`                   |
| `image.pullPolicy`  | kong image pull policy                                                                               | `IfNotPresent`         |
| `image.pullSecrets` | Specify docker-registry secret names as an array                                                     | `[]`                   |
| `image.debug`       | Enable image debug mode                                                                              | `false`                |
| `database`          | Select which database backend Kong will use. Can be 'postgresql', 'cassandra' or 'off'               | `postgresql`           |

### Kong deployment / daemonset parameters

| Name                                                | Description                                                                                                                        | Value            |
| --------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| `useDaemonset`                                      | Use a daemonset instead of a deployment. `replicaCount` will not take effect.                                                      | `false`          |
| `replicaCount`                                      | Number of Kong replicas                                                                                                            | `2`              |
| `containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                                               | `true`           |
| `containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                   | `{}`             |
| `containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                         | `1001`           |
| `containerSecurityContext.runAsGroup`               | Set containers' Security Context runAsGroup                                                                                        | `1001`           |
| `containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                                      | `true`           |
| `containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                                        | `false`          |
| `containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                            | `true`           |
| `containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                          | `false`          |
| `containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                 | `["ALL"]`        |
| `containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                   | `RuntimeDefault` |
| `podSecurityContext.enabled`                        | Enabled Kong pods' Security Context                                                                                                | `true`           |
| `podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                 | `Always`         |
| `podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                     | `[]`             |
| `podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                        | `[]`             |
| `podSecurityContext.fsGroup`                        | Set Kong pod's Security Context fsGroup                                                                                            | `1001`           |
| `updateStrategy.type`                               | Kong update strategy                                                                                                               | `RollingUpdate`  |
| `updateStrategy.rollingUpdate`                      | Kong deployment rolling update configuration parameters                                                                            | `{}`             |
| `automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                 | `true`           |
| `hostAliases`                                       | Add deployment host aliases                                                                                                        | `[]`             |
| `topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template           | `[]`             |
| `priorityClassName`                                 | Priority Class Name                                                                                                                | `""`             |
| `schedulerName`                                     | Use an alternate scheduler, e.g. "stork".                                                                                          | `""`             |
| `terminationGracePeriodSeconds`                     | Seconds Kong pod needs to terminate gracefully                                                                                     | `""`             |
| `podAnnotations`                                    | Additional pod annotations                                                                                                         | `{}`             |
| `podLabels`                                         | Additional pod labels                                                                                                              | `{}`             |
| `podAffinityPreset`                                 | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                | `""`             |
| `podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                           | `soft`           |
| `nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                          | `""`             |
| `nodeAffinityPreset.key`                            | Node label key to match Ignored if `affinity` is set.                                                                              | `""`             |
| `nodeAffinityPreset.values`                         | Node label values to match. Ignored if `affinity` is set.                                                                          | `[]`             |
| `affinity`                                          | Affinity for pod assignment                                                                                                        | `{}`             |
| `nodeSelector`                                      | Node labels for pod assignment                                                                                                     | `{}`             |
| `tolerations`                                       | Tolerations for pod assignment                                                                                                     | `[]`             |
| `extraVolumes`                                      | Array of extra volumes to be added to the Kong deployment deployment (evaluated as template). Requires setting `extraVolumeMounts` | `[]`             |
| `initContainers`                                    | Add additional init containers to the Kong pods                                                                                    | `[]`             |
| `sidecars`                                          | Add additional sidecar containers to the Kong pods                                                                                 | `[]`             |
| `autoscaling.enabled`                               | Deploy a HorizontalPodAutoscaler object for the Kong deployment                                                                    | `false`          |
| `autoscaling.minReplicas`                           | Minimum number of replicas to scale back                                                                                           | `2`              |
| `autoscaling.maxReplicas`                           | Maximum number of replicas to scale out                                                                                            | `5`              |
| `autoscaling.metrics`                               | Metrics to use when deciding to scale the deployment (evaluated as a template)                                                     | `[]`             |
| `pdb.create`                                        | Deploy a PodDisruptionBudget object for Kong deployment                                                                            | `false`          |
| `pdb.minAvailable`                                  | Minimum available Kong replicas (expressed in percentage)                                                                          | `""`             |
| `pdb.maxUnavailable`                                | Maximum unavailable Kong replicas (expressed in percentage)                                                                        | `50%`            |

### Kong Container Parameters

| Name                                      | Description                                                                                                                                                                                                                 | Value    |
| ----------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- |
| `kong.command`                            | Override default container command (useful when using custom images)                                                                                                                                                        | `[]`     |
| `kong.args`                               | Override default container args (useful when using custom images)                                                                                                                                                           | `[]`     |
| `kong.initScriptsCM`                      | Configmap with init scripts to execute                                                                                                                                                                                      | `""`     |
| `kong.initScriptsSecret`                  | Configmap with init scripts to execute                                                                                                                                                                                      | `""`     |
| `kong.declarativeConfig`                  | Declarative configuration to be loaded by Kong (evaluated as a template)                                                                                                                                                    | `""`     |
| `kong.declarativeConfigCM`                | Configmap with declarative configuration to be loaded by Kong (evaluated as a template)                                                                                                                                     | `""`     |
| `kong.extraEnvVars`                       | Array containing extra env vars to configure Kong                                                                                                                                                                           | `[]`     |
| `kong.extraEnvVarsCM`                     | ConfigMap containing extra env vars to configure Kong                                                                                                                                                                       | `""`     |
| `kong.extraEnvVarsSecret`                 | Secret containing extra env vars to configure Kong (in case of sensitive data)                                                                                                                                              | `""`     |
| `kong.extraVolumeMounts`                  | Array of extra volume mounts to be added to the Kong Container (evaluated as template). Normally used with `extraVolumes`.                                                                                                  | `[]`     |
| `kong.containerPorts.proxyHttp`           | Kong proxy HTTP container port                                                                                                                                                                                              | `8000`   |
| `kong.containerPorts.proxyHttps`          | Kong proxy HTTPS container port                                                                                                                                                                                             | `8443`   |
| `kong.containerPorts.adminHttp`           | Kong admin HTTP container port                                                                                                                                                                                              | `8001`   |
| `kong.containerPorts.adminHttps`          | Kong admin HTTPS container port                                                                                                                                                                                             | `8444`   |
| `kong.resourcesPreset`                    | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if kong.resources is set (kong.resources is recommended for production). | `medium` |
| `kong.resources`                          | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                           | `{}`     |
| `kong.livenessProbe.enabled`              | Enable livenessProbe on Kong containers                                                                                                                                                                                     | `true`   |
| `kong.livenessProbe.initialDelaySeconds`  | Initial delay seconds for livenessProbe                                                                                                                                                                                     | `120`    |
| `kong.livenessProbe.periodSeconds`        | Period seconds for livenessProbe                                                                                                                                                                                            | `10`     |
| `kong.livenessProbe.timeoutSeconds`       | Timeout seconds for livenessProbe                                                                                                                                                                                           | `5`      |
| `kong.livenessProbe.failureThreshold`     | Failure threshold for livenessProbe                                                                                                                                                                                         | `6`      |
| `kong.livenessProbe.successThreshold`     | Success threshold for livenessProbe                                                                                                                                                                                         | `1`      |
| `kong.readinessProbe.enabled`             | Enable readinessProbe on Kong containers                                                                                                                                                                                    | `true`   |
| `kong.readinessProbe.initialDelaySeconds` | Initial delay seconds for readinessProbe                                                                                                                                                                                    | `30`     |
| `kong.readinessProbe.periodSeconds`       | Period seconds for readinessProbe                                                                                                                                                                                           | `10`     |
| `kong.readinessProbe.timeoutSeconds`      | Timeout seconds for readinessProbe                                                                                                                                                                                          | `5`      |
| `kong.readinessProbe.failureThreshold`    | Failure threshold for readinessProbe                                                                                                                                                                                        | `6`      |
| `kong.readinessProbe.successThreshold`    | Success threshold for readinessProbe                                                                                                                                                                                        | `1`      |
| `kong.startupProbe.enabled`               | Enable startupProbe on Kong containers                                                                                                                                                                                      | `false`  |
| `kong.startupProbe.initialDelaySeconds`   | Initial delay seconds for startupProbe                                                                                                                                                                                      | `10`     |
| `kong.startupProbe.periodSeconds`         | Period seconds for startupProbe                                                                                                                                                                                             | `15`     |
| `kong.startupProbe.timeoutSeconds`        | Timeout seconds for startupProbe                                                                                                                                                                                            | `3`      |
| `kong.startupProbe.failureThreshold`      | Failure threshold for startupProbe                                                                                                                                                                                          | `20`     |
| `kong.startupProbe.successThreshold`      | Success threshold for startupProbe                                                                                                                                                                                          | `1`      |
| `kong.customLivenessProbe`                | Override default liveness probe (kong container)                                                                                                                                                                            | `{}`     |
| `kong.customReadinessProbe`               | Override default readiness probe (kong container)                                                                                                                                                                           | `{}`     |
| `kong.customStartupProbe`                 | Override default startup probe (kong container)                                                                                                                                                                             | `{}`     |
| `kong.lifecycleHooks`                     | Lifecycle hooks (kong container)                                                                                                                                                                                            | `{}`     |

### Traffic Exposure Parameters

| Name                                    | Description                                                                                                                      | Value                    |
| --------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `service.type`                          | Kubernetes Service type                                                                                                          | `ClusterIP`              |
| `service.exposeAdmin`                   | Add the Kong Admin ports to the service                                                                                          | `false`                  |
| `service.disableHttpPort`               | Disable Kong proxy HTTP and Kong admin HTTP ports                                                                                | `false`                  |
| `service.ports.proxyHttp`               | Kong proxy service HTTP port                                                                                                     | `80`                     |
| `service.ports.proxyHttps`              | Kong proxy service HTTPS port                                                                                                    | `443`                    |
| `service.ports.adminHttp`               | Kong admin service HTTP port (only if service.exposeAdmin=true)                                                                  | `8001`                   |
| `service.ports.adminHttps`              | Kong admin service HTTPS port (only if service.exposeAdmin=true)                                                                 | `8444`                   |
| `service.nodePorts.proxyHttp`           | NodePort for the Kong proxy HTTP endpoint                                                                                        | `""`                     |
| `service.nodePorts.proxyHttps`          | NodePort for the Kong proxy HTTPS endpoint                                                                                       | `""`                     |
| `service.nodePorts.adminHttp`           | NodePort for the Kong admin HTTP endpoint                                                                                        | `""`                     |
| `service.nodePorts.adminHttps`          | NodePort for the Kong admin HTTPS endpoint                                                                                       | `""`                     |
| `service.sessionAffinity`               | Control where client requests go, to the same pod or round-robin                                                                 | `None`                   |
| `service.sessionAffinityConfig`         | Additional settings for the sessionAffinity                                                                                      | `{}`                     |
| `service.clusterIP`                     | Cluster internal IP of the service                                                                                               | `""`                     |
| `service.externalTrafficPolicy`         | external traffic policy managing client source IP preservation                                                                   | `""`                     |
| `service.loadBalancerIP`                | loadBalancerIP if kong service type is `LoadBalancer`                                                                            | `""`                     |
| `service.loadBalancerSourceRanges`      | Kong service Load Balancer sources                                                                                               | `[]`                     |
| `service.annotations`                   | Annotations for Kong service                                                                                                     | `{}`                     |
| `service.extraPorts`                    | Extra ports to expose (normally used with the `sidecar` value)                                                                   | `[]`                     |
| `networkPolicy.enabled`                 | Specifies whether a NetworkPolicy should be created                                                                              | `true`                   |
| `networkPolicy.allowExternal`           | Don't require server label for connections                                                                                       | `true`                   |
| `networkPolicy.allowExternalEgress`     | Allow the pod to access any range of port and all destinations.                                                                  | `true`                   |
| `networkPolicy.kubeAPIServerPorts`      | List of possible endpoints to kube-apiserver (limit to your cluster settings to increase security)                               | `[]`                     |
| `networkPolicy.extraIngress`            | Add extra ingress rules to the NetworkPolicy                                                                                     | `[]`                     |
| `networkPolicy.extraEgress`             | Add extra ingress rules to the NetworkPolicy                                                                                     | `[]`                     |
| `networkPolicy.ingressNSMatchLabels`    | Labels to match to allow traffic from other namespaces                                                                           | `{}`                     |
| `networkPolicy.ingressNSPodMatchLabels` | Pod labels to match to allow traffic from other namespaces                                                                       | `{}`                     |
| `ingress.enabled`                       | Enable ingress controller resource                                                                                               | `false`                  |
| `ingress.ingressClassName`              | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                    | `""`                     |
| `ingress.pathType`                      | Ingress path type                                                                                                                | `ImplementationSpecific` |
| `ingress.apiVersion`                    | Force Ingress API version (automatically detected if not set)                                                                    | `""`                     |
| `ingress.hostname`                      | Default host for the ingress resource                                                                                            | `kong.local`             |
| `ingress.path`                          | Ingress path                                                                                                                     | `/`                      |
| `ingress.annotations`                   | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                     |
| `ingress.tls`                           | Enable TLS configuration for the host defined at `ingress.hostname` parameter                                                    | `false`                  |
| `ingress.selfSigned`                    | Create a TLS secret for this ingress record using self-signed certificates generated by Helm                                     | `false`                  |
| `ingress.extraHosts`                    | The list of additional hostnames to be covered with this ingress record.                                                         | `[]`                     |
| `ingress.extraPaths`                    | Additional arbitrary path/backend objects                                                                                        | `[]`                     |
| `ingress.extraTls`                      | The tls configuration for additional hostnames to be covered with this ingress record.                                           | `[]`                     |
| `ingress.secrets`                       | If you're providing your own certificates, please use this to add the certificates as secrets                                    | `[]`                     |
| `ingress.extraRules`                    | Additional rules to be covered with this ingress record                                                                          | `[]`                     |

### Kong Ingress Controller Container Parameters

| Name                                                            | Description                                                                                                                                                                                                                                           | Value                                     |
| --------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------- |
| `ingressController.enabled`                                     | Enable/disable the Kong Ingress Controller                                                                                                                                                                                                            | `true`                                    |
| `ingressController.image.registry`                              | Kong Ingress Controller image registry                                                                                                                                                                                                                | `REGISTRY_NAME`                           |
| `ingressController.image.repository`                            | Kong Ingress Controller image name                                                                                                                                                                                                                    | `REPOSITORY_NAME/kong-ingress-controller` |
| `ingressController.image.digest`                                | Kong Ingress Controller image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                               | `""`                                      |
| `ingressController.image.pullPolicy`                            | Kong Ingress Controller image pull policy                                                                                                                                                                                                             | `IfNotPresent`                            |
| `ingressController.image.pullSecrets`                           | Specify docker-registry secret names as an array                                                                                                                                                                                                      | `[]`                                      |
| `ingressController.proxyReadyTimeout`                           | Maximum time (in seconds) to wait for the Kong container to be ready                                                                                                                                                                                  | `300`                                     |
| `ingressController.ingressClass`                                | Name of the class to register Kong Ingress Controller (useful when having other Ingress Controllers in the cluster)                                                                                                                                   | `kong`                                    |
| `ingressController.command`                                     | Override default container command (useful when using custom images)                                                                                                                                                                                  | `[]`                                      |
| `ingressController.args`                                        | Override default container args (useful when using custom images)                                                                                                                                                                                     | `[]`                                      |
| `ingressController.extraEnvVars`                                | Array containing extra env vars to configure Kong                                                                                                                                                                                                     | `[]`                                      |
| `ingressController.extraEnvVarsCM`                              | ConfigMap containing extra env vars to configure Kong Ingress Controller                                                                                                                                                                              | `""`                                      |
| `ingressController.extraEnvVarsSecret`                          | Secret containing extra env vars to configure Kong Ingress Controller (in case of sensitive data)                                                                                                                                                     | `""`                                      |
| `ingressController.extraVolumeMounts`                           | Array of extra volume mounts to be added to the Kong Ingress Controller container (evaluated as template). Normally used with `extraVolumes`.                                                                                                         | `[]`                                      |
| `ingressController.containerPorts.health`                       | Kong Ingress Controller health container port                                                                                                                                                                                                         | `10254`                                   |
| `ingressController.resourcesPreset`                             | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if ingressController.resources is set (ingressController.resources is recommended for production). | `nano`                                    |
| `ingressController.resources`                                   | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                                     | `{}`                                      |
| `ingressController.livenessProbe.enabled`                       | Enable livenessProbe on Kong Ingress Controller containers                                                                                                                                                                                            | `true`                                    |
| `ingressController.livenessProbe.initialDelaySeconds`           | Initial delay seconds for livenessProbe                                                                                                                                                                                                               | `120`                                     |
| `ingressController.livenessProbe.periodSeconds`                 | Period seconds for livenessProbe                                                                                                                                                                                                                      | `10`                                      |
| `ingressController.livenessProbe.timeoutSeconds`                | Timeout seconds for livenessProbe                                                                                                                                                                                                                     | `5`                                       |
| `ingressController.livenessProbe.failureThreshold`              | Failure threshold for livenessProbe                                                                                                                                                                                                                   | `6`                                       |
| `ingressController.livenessProbe.successThreshold`              | Success threshold for livenessProbe                                                                                                                                                                                                                   | `1`                                       |
| `ingressController.readinessProbe.enabled`                      | Enable readinessProbe on Kong Ingress Controller containers                                                                                                                                                                                           | `true`                                    |
| `ingressController.readinessProbe.initialDelaySeconds`          | Initial delay seconds for readinessProbe                                                                                                                                                                                                              | `30`                                      |
| `ingressController.readinessProbe.periodSeconds`                | Period seconds for readinessProbe                                                                                                                                                                                                                     | `10`                                      |
| `ingressController.readinessProbe.timeoutSeconds`               | Timeout seconds for readinessProbe                                                                                                                                                                                                                    | `5`                                       |
| `ingressController.readinessProbe.failureThreshold`             | Failure threshold for readinessProbe                                                                                                                                                                                                                  | `6`                                       |
| `ingressController.readinessProbe.successThreshold`             | Success threshold for readinessProbe                                                                                                                                                                                                                  | `1`                                       |
| `ingressController.startupProbe.enabled`                        | Enable startupProbe on Kong Ingress Controller containers                                                                                                                                                                                             | `false`                                   |
| `ingressController.startupProbe.initialDelaySeconds`            | Initial delay seconds for startupProbe                                                                                                                                                                                                                | `10`                                      |
| `ingressController.startupProbe.periodSeconds`                  | Period seconds for startupProbe                                                                                                                                                                                                                       | `15`                                      |
| `ingressController.startupProbe.timeoutSeconds`                 | Timeout seconds for startupProbe                                                                                                                                                                                                                      | `3`                                       |
| `ingressController.startupProbe.failureThreshold`               | Failure threshold for startupProbe                                                                                                                                                                                                                    | `20`                                      |
| `ingressController.startupProbe.successThreshold`               | Success threshold for startupProbe                                                                                                                                                                                                                    | `1`                                       |
| `ingressController.customLivenessProbe`                         | Override default liveness probe (Kong Ingress Controller container)                                                                                                                                                                                   | `{}`                                      |
| `ingressController.customReadinessProbe`                        | Override default readiness probe (Kong Ingress Controller container)                                                                                                                                                                                  | `{}`                                      |
| `ingressController.customStartupProbe`                          | Override default startup probe (Kong Ingress Controller container)                                                                                                                                                                                    | `{}`                                      |
| `ingressController.lifecycleHooks`                              | Lifecycle hooks (Kong Ingress Controller container)                                                                                                                                                                                                   | `{}`                                      |
| `ingressController.serviceAccount.create`                       | Enable the creation of a ServiceAccount for Kong pods                                                                                                                                                                                                 | `true`                                    |
| `ingressController.serviceAccount.name`                         | Name of the created ServiceAccount (name generated using common.names.fullname template otherwise)                                                                                                                                                    | `""`                                      |
| `ingressController.serviceAccount.automountServiceAccountToken` | Auto-mount the service account token in the pod                                                                                                                                                                                                       | `false`                                   |
| `ingressController.serviceAccount.annotations`                  | Additional custom annotations for the ServiceAccount                                                                                                                                                                                                  | `{}`                                      |
| `ingressController.rbac.create`                                 | Create the necessary RBAC resources for the Ingress Controller to work                                                                                                                                                                                | `true`                                    |
| `ingressController.rbac.rules`                                  | Custom RBAC rules                                                                                                                                                                                                                                     | `[]`                                      |

### Kong Migration job Parameters

| Name                                     | Description                                                                                                                                                                                                                           | Value  |
| ---------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------ |
| `migration.command`                      | Override default container command (useful when using custom images)                                                                                                                                                                  | `[]`   |
| `migration.args`                         | Override default container args (useful when using custom images)                                                                                                                                                                     | `[]`   |
| `migration.extraEnvVars`                 | Array containing extra env vars to configure the Kong migration job                                                                                                                                                                   | `[]`   |
| `migration.extraEnvVarsCM`               | ConfigMap containing extra env vars to configure the Kong migration job                                                                                                                                                               | `""`   |
| `migration.extraEnvVarsSecret`           | Secret containing extra env vars to configure the Kong migration job (in case of sensitive data)                                                                                                                                      | `""`   |
| `migration.extraVolumeMounts`            | Array of extra volume mounts to be added to the Kong Container (evaluated as template). Normally used with `extraVolumes`.                                                                                                            | `[]`   |
| `migration.resourcesPreset`              | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if migration.resources is set (migration.resources is recommended for production). | `nano` |
| `migration.resources`                    | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                     | `{}`   |
| `migration.automountServiceAccountToken` | Mount Service Account token in pod                                                                                                                                                                                                    | `true` |
| `migration.hostAliases`                  | Add deployment host aliases                                                                                                                                                                                                           | `[]`   |
| `migration.annotations`                  | Add annotations to the job                                                                                                                                                                                                            | `{}`   |
| `migration.podLabels`                    | Additional pod labels                                                                                                                                                                                                                 | `{}`   |
| `migration.podAnnotations`               | Additional pod annotations                                                                                                                                                                                                            | `{}`   |

### PostgreSQL Parameters

| Name                                            | Description                                                                                                                                                                                                                | Value                        |
| ----------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------- |
| `postgresql.enabled`                            | Switch to enable or disable the PostgreSQL helm chart                                                                                                                                                                      | `true`                       |
| `postgresql.auth.postgresPassword`              | Password for the "postgres" admin user                                                                                                                                                                                     | `""`                         |
| `postgresql.auth.username`                      | Name for a custom user to create                                                                                                                                                                                           | `kong`                       |
| `postgresql.auth.password`                      | Password for the custom user to create                                                                                                                                                                                     | `""`                         |
| `postgresql.auth.database`                      | Name for a custom database to create                                                                                                                                                                                       | `kong`                       |
| `postgresql.auth.existingSecret`                | Name of existing secret to use for PostgreSQL credentials                                                                                                                                                                  | `""`                         |
| `postgresql.auth.usePasswordFiles`              | Mount credentials as a files instead of using an environment variable                                                                                                                                                      | `false`                      |
| `postgresql.architecture`                       | PostgreSQL architecture (`standalone` or `replication`)                                                                                                                                                                    | `standalone`                 |
| `postgresql.image.registry`                     | PostgreSQL image registry                                                                                                                                                                                                  | `REGISTRY_NAME`              |
| `postgresql.image.repository`                   | PostgreSQL image repository                                                                                                                                                                                                | `REPOSITORY_NAME/postgresql` |
| `postgresql.image.digest`                       | PostgreSQL image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                 | `""`                         |
| `postgresql.primary.resourcesPreset`            | Set container resources according to one common preset (allowed values: none, nano, small, medium, large, xlarge, 2xlarge). This is ignored if primary.resources is set (primary.resources is recommended for production). | `nano`                       |
| `postgresql.primary.resources`                  | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                          | `{}`                         |
| `postgresql.external.host`                      | Database host                                                                                                                                                                                                              | `""`                         |
| `postgresql.external.port`                      | Database port number                                                                                                                                                                                                       | `5432`                       |
| `postgresql.external.user`                      | Non-root username for Kong                                                                                                                                                                                                 | `kong`                       |
| `postgresql.external.password`                  | Password for the non-root username for Kong                                                                                                                                                                                | `""`                         |
| `postgresql.external.database`                  | Kong database name                                                                                                                                                                                                         | `kong`                       |
| `postgresql.external.existingSecret`            | Name of an existing secret resource containing the database credentials                                                                                                                                                    | `""`                         |
| `postgresql.external.existingSecretPasswordKey` | Name of an existing secret key containing the database credentials                                                                                                                                                         | `""`                         |

### Cassandra Parameters

| Name                                           | Description                                                                                                                                                                                                | Value   |
| ---------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `cassandra.enabled`                            | Switch to enable or disable the Cassandra helm chart                                                                                                                                                       | `false` |
| `cassandra.dbUser.user`                        | Cassandra admin user                                                                                                                                                                                       | `kong`  |
| `cassandra.dbUser.password`                    | Password for `cassandra.dbUser.user`. Randomly generated if empty                                                                                                                                          | `""`    |
| `cassandra.dbUser.existingSecret`              | Name of existing secret to use for Cassandra credentials                                                                                                                                                   | `""`    |
| `cassandra.usePasswordFile`                    | Mount credentials as a files instead of using an environment variable                                                                                                                                      | `false` |
| `cassandra.replicaCount`                       | Number of Cassandra replicas                                                                                                                                                                               | `1`     |
| `cassandra.external.hosts`                     | List of Cassandra hosts                                                                                                                                                                                    | `[]`    |
| `cassandra.external.port`                      | Cassandra port number                                                                                                                                                                                      | `9042`  |
| `cassandra.external.user`                      | Username of the external cassandra installation                                                                                                                                                            | `""`    |
| `cassandra.external.password`                  | Password of the external cassandra installation                                                                                                                                                            | `""`    |
| `cassandra.external.existingSecret`            | Name of an existing secret resource containing the Cassandra credentials                                                                                                                                   | `""`    |
| `cassandra.external.existingSecretPasswordKey` | Name of an existing secret key containing the Cassandra credentials                                                                                                                                        | `""`    |
| `cassandra.resourcesPreset`                    | Set container resources according to one common preset (allowed values: none, nano, small, medium, large, xlarge, 2xlarge). This is ignored if resources is set (resources is recommended for production). | `large` |
| `cassandra.resources`                          | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                          | `{}`    |

### Metrics Parameters

| Name                                       | Description                                                                           | Value   |
| ------------------------------------------ | ------------------------------------------------------------------------------------- | ------- |
| `metrics.enabled`                          | Enable the export of Prometheus metrics                                               | `false` |
| `metrics.containerPorts.http`              | Prometheus metrics HTTP container port                                                | `9119`  |
| `metrics.service.sessionAffinity`          | Control where client requests go, to the same pod or round-robin                      | `None`  |
| `metrics.service.clusterIP`                | Cluster internal IP of the service                                                    | `""`    |
| `metrics.service.annotations`              | Annotations for Prometheus metrics service                                            | `{}`    |
| `metrics.service.ports.http`               | Prometheus metrics service HTTP port                                                  | `9119`  |
| `metrics.serviceMonitor.enabled`           | Create ServiceMonitor Resource for scraping metrics using PrometheusOperator          | `false` |
| `metrics.serviceMonitor.namespace`         | Namespace which Prometheus is running in                                              | `""`    |
| `metrics.serviceMonitor.interval`          | Interval at which metrics should be scraped                                           | `30s`   |
| `metrics.serviceMonitor.scrapeTimeout`     | Specify the timeout after which the scrape is ended                                   | `""`    |
| `metrics.serviceMonitor.labels`            | Additional labels that can be used so ServiceMonitor will be discovered by Prometheus | `{}`    |
| `metrics.serviceMonitor.selector`          | Prometheus instance selector labels                                                   | `{}`    |
| `metrics.serviceMonitor.relabelings`       | RelabelConfigs to apply to samples before scraping                                    | `[]`    |
| `metrics.serviceMonitor.metricRelabelings` | MetricRelabelConfigs to apply to samples before ingestion                             | `[]`    |
| `metrics.serviceMonitor.honorLabels`       | honorLabels chooses the metric's labels on collisions with target labels              | `false` |
| `metrics.serviceMonitor.jobLabel`          | The name of the label on the target service to use as the job name in prometheus.     | `""`    |
| `metrics.serviceMonitor.serviceAccount`    | Service account used by Prometheus Operator                                           | `""`    |
| `metrics.serviceMonitor.rbac.create`       | Create the necessary RBAC resources so Prometheus Operator can reach Kong's namespace | `true`  |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
  --set service.exposeAdmin=true oci://REGISTRY_NAME/REPOSITORY_NAME/kong
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The above command exposes the Kong admin ports inside the Kong service.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml oci://REGISTRY_NAME/REPOSITORY_NAME/kong
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.
> **Tip**: You can use the default [values.yaml](https://github.com/bitnami/charts/tree/main/bitnami/kong/values.yaml)

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

It's necessary to specify the existing passwords while performing a upgrade to ensure the secrets are not updated with invalid randomly generated passwords. Remember to specify the existing values of the `postgresql.postgresqlPassword` or `cassandra.password` parameters when upgrading the chart:

```console
helm upgrade my-release oci://REGISTRY_NAME/REPOSITORY_NAME/kong \
    --set database=postgresql
    --set postgresql.enabled=true
    --set
    --set postgresql.postgresqlPassword=[POSTGRESQL_PASSWORD]
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.
> Note: you need to substitute the placeholders _[POSTGRESQL_PASSWORD]_ with the values obtained from instructions in the installation notes.

### To 12.0.0

This major bump changes the following security defaults:

- `runAsGroup` is changed from `0` to `1001`
- `readOnlyRootFilesystem` is set to `true`
- `resourcesPreset` is changed from `none` to the minimum size working in our test suites (NOTE: `resourcesPreset` is not meant for production usage, but `resources` adapted to your use case).
- `global.compatibility.openshift.adaptSecurityContext` is changed from `disabled` to `auto`.

This could potentially break any customization or init scripts used in your deployment. If this is the case, change the default values to the previous ones.

### To 11.0.0

This major release bumps the PostgreSQL chart version to [14.x.x](https://github.com/bitnami/charts/pull/22750); no major issues are expected during the upgrade.

### To 10.0.0

This major updates the PostgreSQL subchart to its newest major, 13.0.0. [Here](https://github.com/bitnami/charts/tree/master/bitnami/postgresql#to-1300) you can find more information about the changes introduced in that version.

### To 9.0.0

This major updates the Cassandra subchart to its newest major, 10.0.0. [Here](https://github.com/bitnami/charts/pull/14076) you can find more information about the changes introduced in that version.

### To 8.0.0

This major updates the PostgreSQL subchart to its newest major, 12.0.0. [Here](https://github.com/bitnami/charts/tree/master/bitnami/postgresql#to-1200) you can find more information about the changes introduced in that version.

### To 6.0.0

The `postgresql` sub-chart was upgraded to `11.x.x`. Several values of the sub-chart were changed, so please check the [upgrade notes](https://github.com/bitnami/charts/tree/master/bitnami/postgresql#to-1100).

No issues are expected during the upgrade.

### To 5.0.0

The `cassandra` sub-chart was upgraded to `9.x.x`. Several values of the sub-chart were changed, so please check the [upgrade notes](https://github.com/bitnami/charts/tree/main/bitnami/cassandra#to-900).

No issues are expected during the upgrade.

### To 3.1.0

Kong Ingress Controller version was bumped to new major version, `1.x.x`. The associated CRDs were updated accordingly.

### To 3.0.0

[On November 13, 2020, Helm v2 support was formally finished](https://github.com/helm/charts#status-of-the-project), this major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

#### What changes were introduced in this major version?

- Previous versions of this Helm Chart use `apiVersion: v1` (installable by both Helm 2 and 3), this Helm Chart was updated to `apiVersion: v2` (installable by Helm 3 only). [Here](https://helm.sh/docs/topics/charts/#the-apiversion-field) you can find more information about the `apiVersion` field.
- Move dependency information from the _requirements.yaml_ to the _Chart.yaml_
- After running `helm dependency update`, a _Chart.lock_ file is generated containing the same structure used in the previous _requirements.lock_
- The different fields present in the _Chart.yaml_ file has been ordered alphabetically in a homogeneous way for all the Bitnami Helm Charts
- This chart depends on the **PostgreSQL 10** instead of **PostgreSQL 9**. Apart from the same changes that are described in this section, there are also other major changes due to the master/slave nomenclature was replaced by primary/readReplica. [Here](https://github.com/bitnami/charts/pull/4385) you can find more information about the changes introduced.

#### Considerations when upgrading to this version

- If you want to upgrade to this version using Helm v2, this scenario is not supported as this version doesn't support Helm v2 anymore
- If you installed the previous version with Helm v2 and wants to upgrade to this version with Helm v3, please refer to the [official Helm documentation](https://helm.sh/docs/topics/v2_v3_migration/#migration-use-cases) about migrating from Helm v2 to v3
- If you want to upgrade to this version from a previous one installed with Helm v3, it should be done reusing the PVC used to hold the PostgreSQL data on your previous release. To do so, follow the instructions below (the following example assumes that the release name is `kong`):

> NOTE: Please, create a backup of your database before running any of those actions.

##### Export secrets and required values to update

```console
export POSTGRESQL_PASSWORD=$(kubectl get secret --namespace default kong-postgresql -o jsonpath="{.data.password}" | base64 -d)
export POSTGRESQL_PVC=$(kubectl get pvc -l app.kubernetes.io/instance=kong,app.kubernetes.io/name=postgresql,role=master -o jsonpath="{.items[0].metadata.name}")
```

##### Delete statefulsets

Delete PostgreSQL statefulset. Notice the option `--cascade=false`:

```console
kubectl delete statefulsets.apps kong-postgresql --cascade=false
```

##### Upgrade the chart release

```console
helm upgrade kong oci://REGISTRY_NAME/REPOSITORY_NAME/kong \
    --set postgresql.postgresqlPassword=$POSTGRESQL_PASSWORD \
    --set postgresql.persistence.existingClaim=$POSTGRESQL_PVC
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

##### Force new statefulset to create a new pod for postgresql

```console
kubectl delete pod kong-postgresql-0
```

Finally, you should see the lines below in MariaDB container logs:

```console
$ kubectl logs $(kubectl get pods -l app.kubernetes.io/instance=postgresql,app.kubernetes.io/name=postgresql,role=primary -o jsonpath="{.items[0].metadata.name}")
...
postgresql 08:05:12.59 INFO  ==> Deploying PostgreSQL with persisted data...
...
```

#### Useful links

- <https://docs.vmware.com/en/VMware-Tanzu-Application-Catalog/services/tutorials/GUID-resolve-helm2-helm3-post-migration-issues-index.html>
- <https://helm.sh/docs/topics/v2_v3_migration/>
- <https://helm.sh/blog/migrate-from-helm-v2-to-helm-v3/>

### To 4.0.0

This major updates the Cassandra subchart to its newest major, 4.0.0. [Here](https://github.com/bitnami/charts/tree/main/bitnami/cassandra#to-800) you can find more information about the changes introduced in those versions.

### To 2.0.0

PostgreSQL and Cassandra dependencies versions were bumped to new major versions, `9.x.x` and `6.x.x` respectively. Both of these include breaking changes and hence backwards compatibility is no longer guaranteed.

In order to properly migrate your data to this new version:

- If you were using PostgreSQL as your database, please refer to the [PostgreSQL Upgrade Notes](https://github.com/bitnami/charts/tree/main/bitnami/postgresql#900).

- If you were using Cassandra as your database, please refer to the [Cassandra Upgrade Notes](https://github.com/bitnami/charts/tree/main/bitnami/cassandra#to-600).

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