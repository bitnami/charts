<!--- app-name: Jenkins -->

# Bitnami package for Jenkins

Jenkins is an open source Continuous Integration and Continuous Delivery (CI/CD) server designed to automate the building, testing, and deploying of any software project.

[Overview of Jenkins](http://jenkins-ci.org/)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/jenkins
```

Looking to use Jenkins in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the commercial edition of the Bitnami catalog.

## Introduction

This chart bootstraps a [Jenkins](https://github.com/bitnami/containers/tree/main/bitnami/jenkins) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+
- PV provisioner support in the underlying infrastructure
- ReadWriteMany volumes for deployment scaling

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/jenkins
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

These commands deploy Jenkins on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Configuration and installation details

### Resource requests and limits

Bitnami charts allow setting resource requests and limits for all containers inside the chart deployment. These are inside the `resources` value (check parameter table). Setting requests is essential for production workloads and these should be adapted to your specific use case.

To make this process easier, the chart contains the `resourcesPreset` values, which automatically sets the `resources` section according to different presets. Check these presets in [the bitnami/common chart](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15). However, in production workloads using `resourcePreset` is discouraged as it may not fully adapt to your specific needs. Find more information on container resource management in the [official Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).

### [Rolling vs Immutable tags](https://docs.vmware.com/en/VMware-Tanzu-Application-Catalog/services/tutorials/GUID-understand-rolling-tags-containers-index.html)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Configure Ingress

This chart provides support for Ingress resources. If you have an ingress controller installed on your cluster, such as [nginx-ingress-controller](https://github.com/bitnami/charts/tree/main/bitnami/nginx-ingress-controller) or [contour](https://github.com/bitnami/charts/tree/main/bitnami/contour) you can utilize the ingress controller to serve your application.To enable Ingress integration, set `ingress.enabled` to `true`.

The most common scenario is to have one host name mapped to the deployment. In this case, the `ingress.hostname` property can be used to set the host name. The `ingress.tls` parameter can be used to add the TLS configuration for this host.

However, it is also possible to have more than one host. To facilitate this, the `ingress.extraHosts` parameter (if available) can be set with the host names specified as an array. The `ingress.extraTLS` parameter (if available) can also be used to add the TLS configuration for extra hosts.

> NOTE: For each host specified in the `ingress.extraHosts` parameter, it is necessary to set a name, path, and any annotations that the Ingress controller should know about. Not all annotations are supported by all Ingress controllers, but [this annotation reference document](https://github.com/kubernetes/ingress-nginx/blob/master/docs/user-guide/nginx-configuration/annotations.md) lists the annotations supported by many popular Ingress controllers.

Adding the TLS parameter (where available) will cause the chart to generate HTTPS URLs, and the  application will be available on port 443. The actual TLS secrets do not have to be generated by this chart. However, if TLS is enabled, the Ingress record will not work until the TLS secret exists.

[Learn more about Ingress controllers](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/).

### Configure TLS Secrets for use with Ingress

This chart facilitates the creation of TLS secrets for use with the Ingress controller (although this is not mandatory). There are several common use cases:

- Generate certificate secrets based on chart parameters.
- Enable externally generated certificates.
- Manage application certificates via an external service (like [cert-manager](https://github.com/jetstack/cert-manager/)).
- Create self-signed certificates within the chart (if supported).

In the first two cases, a certificate and a key are needed. Files are expected in `.pem` format.

Here is an example of a certificate file:

> NOTE: There may be more than one certificate if there is a certificate chain.

```text
-----BEGIN CERTIFICATE-----
MIID6TCCAtGgAwIBAgIJAIaCwivkeB5EMA0GCSqGSIb3DQEBCwUAMFYxCzAJBgNV
...
jScrvkiBO65F46KioCL9h5tDvomdU1aqpI/CBzhvZn1c0ZTf87tGQR8NK7v7
-----END CERTIFICATE-----
```

Here is an example of a certificate key:

```text
-----BEGIN RSA PRIVATE KEY-----
MIIEogIBAAKCAQEAvLYcyu8f3skuRyUgeeNpeDvYBCDcgq+LsWap6zbX5f8oLqp4
...
wrj2wDbCDCFmfqnSJ+dKI3vFLlEz44sAV8jX/kd4Y6ZTQhlLbYc=
-----END RSA PRIVATE KEY-----
```

- If using Helm to manage the certificates based on the parameters, copy these values into the `certificate` and `key` values for a given `*.ingress.secrets` entry.
- If managing TLS secrets separately, it is necessary to create a TLS secret with name `INGRESS_HOSTNAME-tls` (where INGRESS_HOSTNAME is a placeholder to be replaced with the hostname you set using the `*.ingress.hostname` parameter).
- If your cluster has a [cert-manager](https://github.com/jetstack/cert-manager) add-on to automate the management and issuance of TLS certificates, add to `*.ingress.annotations` the [corresponding ones](https://cert-manager.io/docs/usage/ingress/#supported-annotations) for cert-manager.
- If using self-signed certificates created by Helm, set both `*.ingress.tls` and `*.ingress.selfSigned` to `true`.

### Configure extra environment variables

To add extra environment variables (useful for advanced operations like custom init scripts), use the `extraEnvVars` property.

```yaml
extraEnvVars:
  - name: LOG_LEVEL
    value: DEBUG
```

Alternatively, use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values.

### Configure Sidecars and Init Containers

If additional containers are needed in the same pod as Jenkins (such as additional metrics or logging exporters), they can be defined using the `sidecars` parameter.

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

> NOTE: This Helm chart already includes sidecar containers for the Prometheus exporters (where applicable). These can be activated by adding the `--enable-metrics=true` parameter at deployment time. The `sidecars` parameter should therefore only be used for any extra sidecar containers.

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

### Deploy extra resources

There are cases where you may want to deploy extra objects, such a ConfigMap containing your app's configuration or some extra deployment with a micro service used by your app. For covering this case, the chart allows adding the full specification of other objects using the `extraDeploy` parameter.

### Set Pod affinity

This chart allows you to set custom Pod affinity using the `XXX.affinity` parameter(s). Find more information about Pod affinity in the [Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities) chart. To do so, set the `XXX.podAffinityPreset`, `XXX.podAntiAffinityPreset`, or `XXX.nodeAffinityPreset` parameters.

## Persistence

The [Bitnami Jenkins](https://github.com/bitnami/containers/tree/main/bitnami/jenkins) image stores the Jenkins data and configurations at the `/bitnami/jenkins` path of the container. Persistent Volume Claims (PVCs) are used to keep the data across deployments.

If you encounter errors when working with persistent volumes, refer to our [troubleshooting guide for persistent volumes](https://docs.bitnami.com/kubernetes/faq/troubleshooting/troubleshooting-persistence-volumes/).
s

## Parameters

### Global parameters

| Name                                                  | Description                                                                                                                                                                                                                                                                                                                                                         | Value  |
| ----------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------ |
| `global.imageRegistry`                                | Global Docker image registry                                                                                                                                                                                                                                                                                                                                        | `""`   |
| `global.imagePullSecrets`                             | Global Docker registry secret names as an array                                                                                                                                                                                                                                                                                                                     | `[]`   |
| `global.defaultStorageClass`                          | Global default StorageClass for Persistent Volume(s)                                                                                                                                                                                                                                                                                                                | `""`   |
| `global.storageClass`                                 | DEPRECATED: use global.defaultStorageClass instead                                                                                                                                                                                                                                                                                                                  | `""`   |
| `global.compatibility.openshift.adaptSecurityContext` | Adapt the securityContext sections of the deployment to make them compatible with Openshift restricted-v2 SCC: remove runAsUser, runAsGroup and fsGroup and let the platform use their allowed default IDs. Possible values: auto (apply if the detected running cluster is Openshift), force (perform the adaptation always), disabled (do not perform adaptation) | `auto` |

### Common parameters

| Name                     | Description                                                                             | Value           |
| ------------------------ | --------------------------------------------------------------------------------------- | --------------- |
| `kubeVersion`            | Override Kubernetes version                                                             | `""`            |
| `nameOverride`           | String to partially override common.names.fullname                                      | `""`            |
| `fullnameOverride`       | String to fully override common.names.fullname                                          | `""`            |
| `replicaCount`           | Number of container replicas                                                            | `1`             |
| `commonLabels`           | Labels to add to all deployed objects                                                   | `{}`            |
| `commonAnnotations`      | Annotations to add to all deployed objects                                              | `{}`            |
| `clusterDomain`          | Kubernetes cluster domain name                                                          | `cluster.local` |
| `extraDeploy`            | Array of extra objects to deploy with the release                                       | `[]`            |
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden) | `false`         |
| `diagnosticMode.command` | Command to override all containers in the deployment                                    | `["sleep"]`     |
| `diagnosticMode.args`    | Args to override all containers in the deployment                                       | `["infinity"]`  |

### Jenkins Image parameters

| Name                | Description                                                                                             | Value                     |
| ------------------- | ------------------------------------------------------------------------------------------------------- | ------------------------- |
| `image.registry`    | Jenkins image registry                                                                                  | `REGISTRY_NAME`           |
| `image.repository`  | Jenkins image repository                                                                                | `REPOSITORY_NAME/jenkins` |
| `image.digest`      | Jenkins image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag | `""`                      |
| `image.pullPolicy`  | Jenkins image pull policy                                                                               | `IfNotPresent`            |
| `image.pullSecrets` | Jenkins image pull secrets                                                                              | `[]`                      |
| `image.debug`       | Enable image debug mode                                                                                 | `false`                   |

### Jenkins Configuration parameters

| Name                     | Description                                                                                                                                         | Value                   |
| ------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------- |
| `jenkinsUser`            | Jenkins username                                                                                                                                    | `user`                  |
| `jenkinsPassword`        | Jenkins user password                                                                                                                               | `""`                    |
| `jenkinsHost`            | Jenkins host to create application URLs                                                                                                             | `""`                    |
| `jenkinsHome`            | Jenkins home directory                                                                                                                              | `/bitnami/jenkins/home` |
| `javaOpts`               | Custom JVM parameters                                                                                                                               | `[]`                    |
| `disableInitialization`  | Skip performing the initial bootstrapping for Jenkins                                                                                               | `no`                    |
| `command`                | Override default container command (useful when using custom images)                                                                                | `[]`                    |
| `args`                   | Override default container args (useful when using custom images)                                                                                   | `[]`                    |
| `extraEnvVars`           | Array with extra environment variables to add to the Jenkins container                                                                              | `[]`                    |
| `extraEnvVarsCM`         | Name of existing ConfigMap containing extra env vars                                                                                                | `""`                    |
| `extraEnvVarsSecret`     | Name of existing Secret containing extra env vars                                                                                                   | `""`                    |
| `plugins`                | List of plugins to be installed during Jenkins first boot.                                                                                          | `[]`                    |
| `extraPlugins`           | List of plugins to install in addition to those listed in `plugins`                                                                                 | `[]`                    |
| `latestPlugins`          | Set to true to download the latest version of all dependencies, even if the version(s) of the requested plugin(s) are not the latest.               | `true`                  |
| `latestSpecifiedPlugins` | Set to true download the latest dependencies of any plugin that is requested to have the latest version.                                            | `false`                 |
| `skipImagePlugins`       | Set this value to true to skip installing plugins stored under /opt/bitnami/jenkins/plugins                                                         | `false`                 |
| `overridePlugins`        | Setting this value to true will remove all plugins from the jenkinsHome directory and install new plugins from scratch.                             | `false`                 |
| `overridePaths`          | Comma-separated list of relative paths to be removed from Jenkins home volume and/or mounted if present in the mounted content dir                  | `""`                    |
| `initScripts`            | Dictionary of scripts to be mounted at `/docker-entrypoint-initdb.d`. Evaluated as a template. Allows .sh and .groovy formats.                      | `{}`                    |
| `initScriptsCM`          | ConfigMap containing the `/docker-entrypoint-initdb.d` scripts. Evaluated as a template.                                                            | `""`                    |
| `initScriptsSecret`      | Secret containing `/docker-entrypoint-initdb.d` scripts to be executed at initialization time that contain sensitive data. Evaluated as a template. | `""`                    |
| `initHookScripts`        | Dictionary of scripts to be mounted at `$JENKINS_HOME/init.groovy.d`. Evaluated as a template. Allows .sh and .groovy formats.                      | `{}`                    |
| `initHookScriptsCM`      | ConfigMap containing the `$JENKINS_HOME/init.groovy.d` scripts. Evaluated as a template.                                                            | `""`                    |
| `initHookScriptsSecret`  | Secret containing `$JENKINS_HOME/init.groovy.d` scripts to be executed at initialization time that contain sensitive data. Evaluated as a template. | `""`                    |

### Jenkins TLS configuration

| Name                  | Description                                                                                                                                                                                                               | Value   |
| --------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `tls.autoGenerated`   | Create self-signed TLS certificates. Currently only supports PEM certificates.                                                                                                                                            | `false` |
| `tls.usePemCerts`     | Use this variable if your secrets contain PEM certificates instead of PKCS12                                                                                                                                              | `false` |
| `tls.existingSecret`  | Name of the existing secret containing the 'jenkins.jks' keystore, if usePemCerts is enabled, use keys 'tls.crt' and 'tls.key'.                                                                                           | `""`    |
| `tls.password`        | Password to access the JKS keystore when it is password-protected.                                                                                                                                                        | `""`    |
| `tls.passwordsSecret` | Name of the existing secret containing the JKS keystore password.                                                                                                                                                         | `""`    |
| `tls.resourcesPreset` | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if tls.resources is set (tls.resources is recommended for production). | `nano`  |
| `tls.resources`       | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                         | `{}`    |

### Jenkins Configuration as Code plugin settings (EXPERIMENTAL)

| Name                                                                        | Description                                                                                                                                                                                                                                                | Value                           |
| --------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------- |
| `configAsCode.enabled`                                                      | Enable configuration as code.                                                                                                                                                                                                                              | `false`                         |
| `configAsCode.extraConfigFiles`                                             | List of additional configuration-as-code files to be mounted                                                                                                                                                                                               | `{}`                            |
| `configAsCode.securityRealm`                                                | Content of the 'securityRealm' block                                                                                                                                                                                                                       | `{}`                            |
| `configAsCode.authorizationStrategy`                                        | Content of the 'authorizationStrategy' block                                                                                                                                                                                                               | `{}`                            |
| `configAsCode.security`                                                     | Content of the 'security' block                                                                                                                                                                                                                            | `{}`                            |
| `configAsCode.extraJenkins`                                                 | Append additional settings under the 'jenkins' block                                                                                                                                                                                                       | `{}`                            |
| `configAsCode.extraConfig`                                                  | Append additional settings at the root of the configuration-as-code file                                                                                                                                                                                   | `{}`                            |
| `configAsCode.extraKubernetes`                                              | Append additional settings under the Kubernetes cloud block                                                                                                                                                                                                | `{}`                            |
| `configAsCode.extraClouds`                                                  | Additional clouds                                                                                                                                                                                                                                          | `[]`                            |
| `configAsCode.existingConfigmap`                                            | Name of an existing configmap containing the config-as-code files.                                                                                                                                                                                         | `""`                            |
| `configAsCode.autoReload.enabled`                                           | Enable the creation of the autoReload sidecar container.                                                                                                                                                                                                   | `true`                          |
| `configAsCode.autoReload.initialDelay`                                      | In seconds, time                                                                                                                                                                                                                                           | `360`                           |
| `configAsCode.autoReload.reqRetries`                                        |                                                                                                                                                                                                                                                            | `12`                            |
| `configAsCode.autoReload.interval`                                          |                                                                                                                                                                                                                                                            | `10`                            |
| `configAsCode.autoReload.command`                                           |                                                                                                                                                                                                                                                            | `[]`                            |
| `configAsCode.autoReload.args`                                              |                                                                                                                                                                                                                                                            | `[]`                            |
| `configAsCode.autoReload.extraEnvVars`                                      |                                                                                                                                                                                                                                                            | `[]`                            |
| `configAsCode.autoReload.extraEnvVarsSecret`                                |                                                                                                                                                                                                                                                            | `""`                            |
| `configAsCode.autoReload.extraEnvVarsCM`                                    |                                                                                                                                                                                                                                                            | `""`                            |
| `configAsCode.autoReload.extraVolumeMounts`                                 |                                                                                                                                                                                                                                                            | `[]`                            |
| `configAsCode.autoReload.containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                                                                                                                                                                       | `true`                          |
| `configAsCode.autoReload.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                                                           | `{}`                            |
| `configAsCode.autoReload.containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                                                                                                                                                 | `1001`                          |
| `configAsCode.autoReload.containerSecurityContext.runAsGroup`               | Set containers' Security Context runAsGroup                                                                                                                                                                                                                | `1001`                          |
| `configAsCode.autoReload.containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                                                                                                                                                              | `true`                          |
| `configAsCode.autoReload.containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                                                                                                                                                                | `false`                         |
| `configAsCode.autoReload.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                                                                    | `true`                          |
| `configAsCode.autoReload.containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                                                                                                                                                  | `false`                         |
| `configAsCode.autoReload.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                                                         | `["ALL"]`                       |
| `configAsCode.autoReload.containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                                                           | `RuntimeDefault`                |
| `configAsCode.autoReload.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, small, medium, large, xlarge, 2xlarge). This is ignored if configAsCode.autoReload.resources is set (configAsCode.autoReload.resources is recommended for production). | `none`                          |
| `configAsCode.autoReload.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                                          | `{}`                            |
| `agent.enabled`                                                             | Set to true to enable the configuration of Jenkins kubernetes agents                                                                                                                                                                                       | `false`                         |
| `agent.image.registry`                                                      | Jenkins image registry                                                                                                                                                                                                                                     | `REGISTRY_NAME`                 |
| `agent.image.repository`                                                    | Jenkins image repository                                                                                                                                                                                                                                   | `REPOSITORY_NAME/jenkins-agent` |
| `agent.image.digest`                                                        | Jenkins image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                                                    | `""`                            |
| `agent.image.pullPolicy`                                                    | Jenkins image pull policy                                                                                                                                                                                                                                  | `IfNotPresent`                  |
| `agent.image.pullSecrets`                                                   | Jenkins image pull secrets                                                                                                                                                                                                                                 | `[]`                            |
| `agent.image.debug`                                                         | Enable image debug mode                                                                                                                                                                                                                                    | `false`                         |
| `agent.templateLabel`                                                       | Label for the Kubernetes agent template                                                                                                                                                                                                                    | `kubernetes-agent`              |
| `agent.podLabels`                                                           | Additional pod labels for the Jenkins agent pods                                                                                                                                                                                                           | `{}`                            |
| `agent.annotations`                                                         | Additional pod annotations for the Jenkins agent pods                                                                                                                                                                                                      | `{}`                            |
| `agent.sidecars`                                                            | Additional sidecar containers for the Jenkins agent pods                                                                                                                                                                                                   | `[]`                            |
| `agent.command`                                                             | Override default container command (useful when using custom images)                                                                                                                                                                                       | `""`                            |
| `agent.args`                                                                | Override default container args (useful when using custom images)                                                                                                                                                                                          | `""`                            |
| `agent.containerExtraEnvVars`                                               | Additional env vars for the Jenkins agent pods                                                                                                                                                                                                             | `[]`                            |
| `agent.podExtraEnvVars`                                                     | Additional env vars for the Jenkins agent pods                                                                                                                                                                                                             | `[]`                            |
| `agent.extraAgentTemplate`                                                  | Extend the default agent template                                                                                                                                                                                                                          | `{}`                            |
| `agent.extraTemplates`                                                      | Provide your own custom agent templates                                                                                                                                                                                                                    | `[]`                            |
| `agent.resourcesPreset`                                                     | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if agent.resources is set (agent.resources is recommended for production).                              | `small`                         |
| `agent.resources`                                                           | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                                          | `{}`                            |
| `agent.containerSecurityContext.enabled`                                    | Enable container security context                                                                                                                                                                                                                          | `false`                         |
| `agent.containerSecurityContext.seLinuxOptions`                             | Set SELinux options in container                                                                                                                                                                                                                           | `{}`                            |
| `agent.containerSecurityContext.runAsUser`                                  | User ID for the agent container                                                                                                                                                                                                                            | `""`                            |
| `agent.containerSecurityContext.runAsGroup`                                 | User ID for the agent container                                                                                                                                                                                                                            | `""`                            |
| `agent.containerSecurityContext.privileged`                                 | Decide if the container runs privileged.                                                                                                                                                                                                                   | `false`                         |

### Jenkins deployment parameters

| Name                                                | Description                                                                                                                                                                                                       | Value            |
| --------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| `updateStrategy.type`                               | Jenkins deployment strategy type                                                                                                                                                                                  | `RollingUpdate`  |
| `priorityClassName`                                 | Jenkins pod priority class name                                                                                                                                                                                   | `""`             |
| `schedulerName`                                     | Name of the k8s scheduler (other than default)                                                                                                                                                                    | `""`             |
| `topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment                                                                                                                                                                    | `[]`             |
| `automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                | `true`           |
| `hostAliases`                                       | Jenkins pod host aliases                                                                                                                                                                                          | `[]`             |
| `extraVolumes`                                      | Optionally specify extra list of additional volumes for Jenkins pods                                                                                                                                              | `[]`             |
| `extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for Jenkins container(s)                                                                                                                                 | `[]`             |
| `sidecars`                                          | Add additional sidecar containers to the Jenkins pod                                                                                                                                                              | `[]`             |
| `initContainers`                                    | Add additional init containers to the Jenkins pods                                                                                                                                                                | `[]`             |
| `pdb.create`                                        | Enable/disable a Pod Disruption Budget creation                                                                                                                                                                   | `true`           |
| `pdb.minAvailable`                                  | Minimum number/percentage of pods that should remain scheduled                                                                                                                                                    | `""`             |
| `pdb.maxUnavailable`                                | Maximum number/percentage of pods that may be made unavailable. Defaults to `1` if both `pdb.minAvailable` and `pdb.maxUnavailable` are empty.                                                                    | `""`             |
| `lifecycleHooks`                                    | Add lifecycle hooks to the Jenkins deployment                                                                                                                                                                     | `{}`             |
| `podLabels`                                         | Extra labels for Jenkins pods                                                                                                                                                                                     | `{}`             |
| `podAnnotations`                                    | Annotations for Jenkins pods                                                                                                                                                                                      | `{}`             |
| `podAffinityPreset`                                 | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                               | `""`             |
| `podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                          | `soft`           |
| `nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                         | `""`             |
| `nodeAffinityPreset.key`                            | Node label key to match. Ignored if `affinity` is set                                                                                                                                                             | `""`             |
| `nodeAffinityPreset.values`                         | Node label values to match. Ignored if `affinity` is set                                                                                                                                                          | `[]`             |
| `affinity`                                          | Affinity for pod assignment                                                                                                                                                                                       | `{}`             |
| `nodeSelector`                                      | Node labels for pod assignment                                                                                                                                                                                    | `{}`             |
| `tolerations`                                       | Tolerations for pod assignment                                                                                                                                                                                    | `[]`             |
| `resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if resources is set (resources is recommended for production). | `medium`         |
| `resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                 | `{}`             |
| `containerPorts.http`                               | Jenkins HTTP container port                                                                                                                                                                                       | `8080`           |
| `containerPorts.https`                              | Jenkins HTTPS container port                                                                                                                                                                                      | `8443`           |
| `containerPorts.agentListener`                      | Jenkins agent listener port, ignored if agent.enabled=false                                                                                                                                                       | `50000`          |
| `podSecurityContext.enabled`                        | Enabled Jenkins pods' Security Context                                                                                                                                                                            | `true`           |
| `podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                | `Always`         |
| `podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                    | `[]`             |
| `podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                       | `[]`             |
| `podSecurityContext.fsGroup`                        | Set Jenkins pod's Security Context fsGroup                                                                                                                                                                        | `1001`           |
| `containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                                                                                                                              | `true`           |
| `containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                  | `{}`             |
| `containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                                                                                                        | `1001`           |
| `containerSecurityContext.runAsGroup`               | Set containers' Security Context runAsGroup                                                                                                                                                                       | `1001`           |
| `containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                                                                                                                     | `true`           |
| `containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                                                                                                                       | `false`          |
| `containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                           | `true`           |
| `containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                                                                                                         | `false`          |
| `containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                | `["ALL"]`        |
| `containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                  | `RuntimeDefault` |
| `startupProbe.enabled`                              | Enable startupProbe                                                                                                                                                                                               | `false`          |
| `startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                            | `180`            |
| `startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                   | `10`             |
| `startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                  | `5`              |
| `startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                | `6`              |
| `startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                | `1`              |
| `livenessProbe.enabled`                             | Enable livenessProbe                                                                                                                                                                                              | `true`           |
| `livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                           | `180`            |
| `livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                  | `10`             |
| `livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                 | `5`              |
| `livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                               | `6`              |
| `livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                               | `1`              |
| `readinessProbe.enabled`                            | Enable readinessProbe                                                                                                                                                                                             | `true`           |
| `readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                          | `30`             |
| `readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                 | `5`              |
| `readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                | `3`              |
| `readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                              | `3`              |
| `readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                              | `1`              |
| `customStartupProbe`                                | Custom startupProbe that overrides the default one                                                                                                                                                                | `{}`             |
| `customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                                                                                                               | `{}`             |
| `customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                                                                                                                              | `{}`             |

### Traffic Exposure Parameters

| Name                                            | Description                                                                                                                      | Value                    |
| ----------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `service.type`                                  | Jenkins service type                                                                                                             | `LoadBalancer`           |
| `service.ports.http`                            | Jenkins service HTTP port                                                                                                        | `80`                     |
| `service.ports.https`                           | Jenkins service HTTPS port                                                                                                       | `443`                    |
| `service.nodePorts.http`                        | Node port for HTTP                                                                                                               | `""`                     |
| `service.nodePorts.https`                       | Node port for HTTPS                                                                                                              | `""`                     |
| `service.clusterIP`                             | Jenkins service Cluster IP                                                                                                       | `""`                     |
| `service.loadBalancerIP`                        | Jenkins service Load Balancer IP                                                                                                 | `""`                     |
| `service.loadBalancerSourceRanges`              | Jenkins service Load Balancer sources                                                                                            | `[]`                     |
| `service.externalTrafficPolicy`                 | Jenkins service external traffic policy                                                                                          | `Cluster`                |
| `service.annotations`                           | Additional custom annotations for Jenkins service                                                                                | `{}`                     |
| `service.extraPorts`                            | Extra ports to expose (normally used with the `sidecar` value)                                                                   | `[]`                     |
| `service.sessionAffinity`                       | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                                                             | `None`                   |
| `service.sessionAffinityConfig`                 | Additional settings for the sessionAffinity                                                                                      | `{}`                     |
| `networkPolicy.enabled`                         | Specifies whether a NetworkPolicy should be created                                                                              | `true`                   |
| `networkPolicy.allowExternal`                   | Don't require server label for connections                                                                                       | `true`                   |
| `networkPolicy.allowExternalEgress`             | Allow the pod to access any range of port and all destinations.                                                                  | `true`                   |
| `networkPolicy.kubeAPIServerPorts`              | List of possible endpoints to kube-apiserver (limit to your cluster settings to increase security)                               | `[]`                     |
| `networkPolicy.extraIngress`                    | Add extra ingress rules to the NetworkPolicy                                                                                     | `[]`                     |
| `networkPolicy.extraEgress`                     | Add extra ingress rules to the NetworkPolicy                                                                                     | `[]`                     |
| `networkPolicy.ingressNSMatchLabels`            | Labels to match to allow traffic from other namespaces                                                                           | `{}`                     |
| `networkPolicy.ingressNSPodMatchLabels`         | Pod labels to match to allow traffic from other namespaces                                                                       | `{}`                     |
| `agentListenerService.enabled`                  |                                                                                                                                  | `true`                   |
| `agentListenerService.type`                     | Jenkins service type                                                                                                             | `ClusterIP`              |
| `agentListenerService.ports.agentListener`      | Jenkins service agent listener port                                                                                              | `50000`                  |
| `agentListenerService.nodePorts.agentListener`  | Node port for agent listener                                                                                                     | `""`                     |
| `agentListenerService.clusterIP`                | Jenkins service Cluster IP                                                                                                       | `""`                     |
| `agentListenerService.loadBalancerIP`           | Jenkins service Load Balancer IP                                                                                                 | `""`                     |
| `agentListenerService.loadBalancerSourceRanges` | Jenkins service Load Balancer sources                                                                                            | `[]`                     |
| `agentListenerService.externalTrafficPolicy`    | Jenkins service external traffic policy                                                                                          | `Cluster`                |
| `agentListenerService.annotations`              | Additional custom annotations for Jenkins service                                                                                | `{}`                     |
| `agentListenerService.extraPorts`               | Extra ports to expose (normally used with the `sidecar` value)                                                                   | `[]`                     |
| `agentListenerService.sessionAffinity`          | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                                                             | `None`                   |
| `agentListenerService.sessionAffinityConfig`    | Additional settings for the sessionAffinity                                                                                      | `{}`                     |
| `ingress.enabled`                               | Enable ingress record generation for Jenkins                                                                                     | `false`                  |
| `ingress.pathType`                              | Ingress path type                                                                                                                | `ImplementationSpecific` |
| `ingress.apiVersion`                            | Force Ingress API version (automatically detected if not set)                                                                    | `""`                     |
| `ingress.hostname`                              | Default host for the ingress record                                                                                              | `jenkins.local`          |
| `ingress.path`                                  | Default path for the ingress record                                                                                              | `/`                      |
| `ingress.annotations`                           | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                     |
| `ingress.tls`                                   | Enable TLS configuration for the host defined at `ingress.hostname` parameter                                                    | `false`                  |
| `ingress.selfSigned`                            | Create a TLS secret for this ingress record using self-signed certificates generated by Helm                                     | `false`                  |
| `ingress.extraHosts`                            | An array with additional hostname(s) to be covered with the ingress record                                                       | `[]`                     |
| `ingress.extraPaths`                            | An array with additional arbitrary paths that may need to be added to the ingress under the main host                            | `[]`                     |
| `ingress.extraTls`                              | TLS configuration for additional hostname(s) to be covered with this ingress record                                              | `[]`                     |
| `ingress.secrets`                               | Custom TLS certificates as secrets                                                                                               | `[]`                     |
| `ingress.ingressClassName`                      | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                    | `""`                     |
| `ingress.extraRules`                            | Additional rules to be covered with this ingress record                                                                          | `[]`                     |

### Persistence Parameters

| Name                                               | Description                                                                                                                                                                                                                                           | Value                      |
| -------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------- |
| `persistence.enabled`                              | Enable persistence using Persistent Volume Claims                                                                                                                                                                                                     | `true`                     |
| `persistence.storageClass`                         | Persistent Volume storage class                                                                                                                                                                                                                       | `""`                       |
| `persistence.existingClaim`                        | Use a existing PVC which must be created manually before bound                                                                                                                                                                                        | `""`                       |
| `persistence.annotations`                          | Additional custom annotations for the PVC                                                                                                                                                                                                             | `{}`                       |
| `persistence.accessModes`                          | Persistent Volume access modes                                                                                                                                                                                                                        | `[]`                       |
| `persistence.size`                                 | Persistent Volume size                                                                                                                                                                                                                                | `8Gi`                      |
| `persistence.selector`                             | Selector to match an existing Persistent Volume for Ingester's data PVC                                                                                                                                                                               | `{}`                       |
| `volumePermissions.enabled`                        | Enable init container that changes the owner/group of the PV mount point to `runAsUser:fsGroup`                                                                                                                                                       | `false`                    |
| `volumePermissions.image.registry`                 | OS Shell + Utility image registry                                                                                                                                                                                                                     | `REGISTRY_NAME`            |
| `volumePermissions.image.repository`               | OS Shell + Utility image repository                                                                                                                                                                                                                   | `REPOSITORY_NAME/os-shell` |
| `volumePermissions.image.digest`                   | OS Shell + Utility image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                                    | `""`                       |
| `volumePermissions.image.pullPolicy`               | OS Shell + Utility image pull policy                                                                                                                                                                                                                  | `IfNotPresent`             |
| `volumePermissions.image.pullSecrets`              | OS Shell + Utility image pull secrets                                                                                                                                                                                                                 | `[]`                       |
| `volumePermissions.resourcesPreset`                | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if volumePermissions.resources is set (volumePermissions.resources is recommended for production). | `nano`                     |
| `volumePermissions.resources`                      | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                                     | `{}`                       |
| `volumePermissions.securityContext.seLinuxOptions` | Set SELinux options in container                                                                                                                                                                                                                      | `{}`                       |
| `volumePermissions.securityContext.runAsUser`      | Set init container's Security Context runAsUser                                                                                                                                                                                                       | `0`                        |

### Other Parameters

| Name                                          | Description                                                      | Value   |
| --------------------------------------------- | ---------------------------------------------------------------- | ------- |
| `rbac.create`                                 | Specifies whether RBAC resources should be created               | `true`  |
| `rbac.rules`                                  | Custom RBAC rules to set                                         | `[]`    |
| `serviceAccount.create`                       | Specifies whether a ServiceAccount should be created             | `true`  |
| `serviceAccount.name`                         | The name of the ServiceAccount to use.                           | `""`    |
| `serviceAccount.annotations`                  | Additional Service Account annotations (evaluated as a template) | `{}`    |
| `serviceAccount.automountServiceAccountToken` | Automount service account token for the server service account   | `false` |

The above parameters map to the env variables defined in [bitnami/jenkins](https://github.com/bitnami/containers/tree/main/bitnami/jenkins). For more information please refer to the [bitnami/jenkins](https://github.com/bitnami/containers/tree/main/bitnami/jenkins) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
  --set jenkinsUser=admin \
  --set jenkinsPassword=password \
  oci://REGISTRY_NAME/REPOSITORY_NAME/jenkins
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The above command sets the Jenkins administrator account username and password to `admin` and `password` respectively.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml oci://REGISTRY_NAME/REPOSITORY_NAME/jenkins
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.
> **Tip**: You can use the default [values.yaml](https://github.com/bitnami/charts/tree/main/bitnami/jenkins/values.yaml)

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 13.0.0

This major bump changes the following security defaults:

- `runAsGroup` is changed from `0` to `1001`
- `readOnlyRootFilesystem` is set to `true`
- `resourcesPreset` is changed from `none` to the minimum size working in our test suites (NOTE: `resourcesPreset` is not meant for production usage, but `resources` adapted to your use case).
- `global.compatibility.openshift.adaptSecurityContext` is changed from `disabled` to `auto`.

This could potentially break any customization or init scripts used in your deployment. If this is the case, change the default values to the previous ones.

### To 11.0.0

This major release no longer contains preinstalled plugins. In case you want to install a plugin you can follow the [official documentation](https://www.jenkins.io/doc/book/managing/plugins/)

### To 10.0.0

This major release is no longer contains the metrics section because the container `bitnami/enkins-exporter` has been deprecated due to the upstream project is not maintained.

### To 9.0.0

This major release renames several values in this chart and adds missing features, in order to be inline with the rest of assets in the Bitnami charts repository.

Affected values:

- `service.port` renamed as `service.ports.http`.
- `service.httpsPort` renamed as `service.ports.https`.
- `serviceMonitor.additionalLabels` renamed as `serviceMonitor.labels`.

### To 8.0.0

Due to recent changes in the container image (see [Notable changes](https://github.com/bitnami/containers/tree/main/bitnami/jenkins#notable-changes)), the major version of the chart has been bumped preemptively.

Upgrading from version `7.x.x` should be possible following the workaround below (the following example assumes that the release name is `jenkins`):

- Create a backup of your Jenkins data (e.g. using Velero to backup your PV)
- Remove Jenkins deployment:

```console
export JENKINS_PASSWORD=$(kubectl get secret --namespace default jenkins -o jsonpath="{.data.jenkins-password}" | base64 -d)
kubectl delete deployments.apps jenkins
```

- Upgrade your release and delete data that should not be persisted anymore:

```console
helm upgrade jenkins oci://REGISTRY_NAME/REPOSITORY_NAME/jenkins --set jenkinsPassword=$JENKINS_PASSWORD --set jenkinsHome=/bitnami/jenkins/jenkins_home
kubectl exec -it $(kubectl get pod -l app.kubernetes.io/instance=jenkins,app.kubernetes.io/name=jenkins -o jsonpath="{.items[0].metadata.name}") -- find /bitnami/jenkins -mindepth 1 -maxdepth 1 -not -name jenkins_home -exec rm -rf {} \;
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

### To 7.0.0

Chart labels were adapted to follow the [Helm charts standard labels](https://helm.sh/docs/chart_best_practices/labels/#standard-labels).

Consequences:

- Backwards compatibility is not guaranteed. However, you can easily workaround this issue by removing Jenkins deployment before upgrading (the following example assumes that the release name is `jenkins`):

```console
export JENKINS_PASSWORD=$(kubectl get secret --namespace default jenkins -o jsonpath="{.data.jenkins-password}" | base64 -d)
kubectl delete deployments.apps jenkins
helm upgrade jenkins oci://REGISTRY_NAME/REPOSITORY_NAME/jenkins --set jenkinsPassword=$JENKINS_PASSWORD
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

### To 6.1.0

This version also introduces `bitnami/common`, a [library chart](https://helm.sh/docs/topics/library_charts/#helm) as a dependency. More documentation about this new utility could be found [here](https://github.com/bitnami/charts/tree/main/bitnami/common#bitnami-common-library-chart). Please, make sure that you have updated the chart dependencies before executing any upgrade.

### To 6.0.0

[On November 13, 2020, Helm v2 support formally ended](https://github.com/helm/charts#status-of-the-project). This major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

### To 5.0.0

The [Bitnami Jenkins](https://github.com/bitnami/containers/tree/main/bitnami/jenkins) image was migrated to a "non-root" user approach. Previously the container ran as the `root` user and the Jenkins service was started as the `jenkins` user. From now on, both the container and the Jenkins service run as user `jenkins` (`uid=1001`). You can revert this behavior by setting the parameters `securityContext.runAsUser`, and `securityContext.fsGroup` to `root`.
Ingress configuration was also adapted to follow the Helm charts best practices.

Consequences:

- No "privileged" actions are allowed anymore.
- Backwards compatibility is not guaranteed when persistence is enabled.

To upgrade to `5.0.0`, install a new Jenkins chart, and migrate your Jenkins data ensuring the `jenkins` user has the appropriate permissions.

### To 4.0.0

Helm performs a lookup for the object based on its group (apps), version (v1), and kind (Deployment). Also known as its GroupVersionKind, or GVK. Changing the GVK is considered a compatibility breaker from Kubernetes' point of view, so you cannot "upgrade" those objects to the new GVK in-place. Earlier versions of Helm 3 did not perform the lookup correctly which has since been fixed to match the spec.

In 4dfac075aacf74405e31ae5b27df4369e84eb0b0 the `apiVersion` of the deployment resources was updated to `apps/v1` in tune with the api's deprecated, resulting in compatibility breakage.

This major version signifies this change.

### To 1.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 1.0.0. The following example assumes that the release name is jenkins:

```console
kubectl patch deployment jenkins --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
```

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