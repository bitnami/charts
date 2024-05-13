<!--- app-name: JupyterHub -->

# Bitnami package for JupyterHub

JupyterHub brings the power of notebooks to groups of users. It gives users access to computational environments and resources without burdening the users with installation and maintenance tasks.

[Overview of JupyterHub](https://jupyter.org/hub)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/jupyterhub
```

Looking to use JupyterHub in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the enterprise edition of Bitnami Application Catalog.

## Introduction

Bitnami charts for Helm are carefully engineered, actively maintained and are the quickest and easiest way to deploy containers on a Kubernetes cluster that are ready to handle production workloads.

This chart bootstraps a [JupyterHub](https://github.com/jupyterhub/jupyterhub) Deployment in a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Architecture

The JupyterHub chart deploys three basic elements:

- JupyterHub: Central element of the chart. Manages authentication and is responsible for creating the Jupyter Notebook instances (called Single User instances). As a consequence, the Hub requires special RBAC privileges in order to access the Kubernetes API to create and manage Deployments.
- Proxy: This is the external endpoint for users. It manages the communication with the Hub and the Single User instances.
- Image Puller: In order to improve the Single User instance boot time, a DaemonSet object is deployed that pre-pulls all the necessary images to run the Single User Notebooks.

The following diagram shows a deployed release of the chart:

```text
                                                         |
                                                         |
                                                         |
                                                         |
             ------------------                          |
             |                |                          |
             |  Image Puller  |<------Pull images to------
             |                |         all nodes
             ------------------

    -------------           ---------------
    |           |           |             |
    |   Proxy   |---------->|     Hub     |
    |           |           |             |
    -------------           ---------------
```

After accessing the hub and creating a Single User instance, the deployment looks as follows:

```text
                                                         |
                                                         |
                                                         |
                                                         |
              ----------------                           |
             |                |                          |
             |  Image Puller  |<------Pull images to-----
             |                |         all nodes
              ----------------
    -----------             -------------
   |           |           |             |
   |   Proxy   |---------->|     Hub     |
   |           |           |             |
    -----------             -------------
        |                          |
        |                          |
        |                          |
        |     ---------------      |
        |     | Single User |      |
         ---->|  Instance   |<-----
              ---------------
```

For more information, check the official [JupyterHub documentation](https://github.com/jupyterhub/jupyterhub).

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/jupyterhub
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

These commands deploy JupyterHub on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Configuration and installation details

### Resource requests and limits

Bitnami charts allow setting resource requests and limits for all containers inside the chart deployment. These are inside the `resources` value (check parameter table). Setting requests is essential for production workloads and these should be adapted to your specific use case.

To make this process easier, the chart contains the `resourcesPreset` values, which automatically sets the `resources` section according to different presets. Check these presets in [the bitnami/common chart](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15). However, in production workloads using `resourcePreset` is discouraged as it may not fully adapt to your specific needs. Find more information on container resource management in the [official Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).

### Understand the default configuration

This chart deploys three basic elements:

- JupyterHub: Central element of the chart. Manages authentication and is responsible for creating the Jupyter Notebook instances (called Single User instances). As a consequence, the Hub requires special RBAC privileges in order to access the Kubernetes API to create and manage Deployments.
- Proxy: This is the external endpoint for users. It manages the communication with the Hub and the Single User instances.
- Image Puller: In order to improve the Single User instance boot time, a DaemonSet object is deployed that pre-pulls all the necessary images to run the Single User Notebooks.

The following diagram shows a deployed release of the chart:

```text
                                                         |
                                                         |
                                                         |
                                                         |
             ------------------                          |
             |                |                          |
             |  Image Puller  |<------Pull images to------
             |                |         all nodes
             ------------------

    -------------           ---------------
    |           |           |             |
    |   Proxy   |---------->|     Hub     |
    |           |           |             |
    -------------           ---------------
```

After accessing the hub and creating a Single User instance, the deployment looks as follows:

```text
                                                         |
                                                         |
                                                         |
                                                         |
              ----------------                           |
             |                |                          |
             |  Image Puller  |<------Pull images to-----
             |                |         all nodes
              ----------------
    -----------             -------------
   |           |           |             |
   |   Proxy   |---------->|     Hub     |
   |           |           |             |
    -----------             -------------
        |                          |
        |                          |
        |                          |
        |     ---------------      |
        |     | Single User |      |
         ---->|  Instance   |<-----
              ---------------
```

For more information, check the official [JupyterHub documentation](https://github.com/jupyterhub/jupyterhub).

### [Rolling vs Immutable tags](https://docs.vmware.com/en/VMware-Tanzu-Application-Catalog/services/tutorials/GUID-understand-rolling-tags-containers-index.html)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Configure authentication

The chart configures the Hub [DummyAuthenticator](https://github.com/jupyterhub/dummyauthenticator) by default, with the password set in the `hub.password` (auto-generated if not set) chart parameter and `user` as the administrator user. In order to change the authentication mechanism, change the `hub.config.JupyterHub` section inside the `hub.configuration` value.

The following example sets the [NativeAuthenticator](https://github.com/jupyterhub/nativeauthenticator) authenticator, and configures an admin user called *test*.

```yaml
hub:
  configuration: |
    ...
    hub:
      config:
        JupyterHub:
          admin_access: true
          authenticator_class: nativeauthenticator.NativeAuthenticator
          Authenticator:
            admin_users:
              - test
    ...
```

When deploying, you will need to sign up to set the password for the `test`` user.

For more information on Authenticators, check the [official JupyterHub documentation](https://jupyterhub.readthedocs.io/en/stable/getting-started/authenticators-users-basics.html).

### Configure the Single User instances

As explained in this [section](#understand-the-default-configuration), the Hub is responsible for deploying the Single User instances. The configuration of these instances is passed to the Hub instance via the `hub.configuration` chart parameter.

In order to make the chart follow standards and to ease the generation of this configuration file, the chart has a `singleuser` section, which is then used for generating the `hub.configuration` value. This value can be easily overridden by modifying its default value or by providing a secret via the `hub.existingSecret` value. In this case, all the settings in the `singleuser` section will be ignored.

All the settings specified in the `hub.configuration` value are consumed by the `jupyter_config.py` script available in the [templates/hub/configmap.yaml](https://github.com/bitnami/charts/blob/main/bitnami/jupyterhub/templates/hub/configmap.yaml) file. This script can be changed by providing a custom ConfigMap via the `hub.existingConfigmap` value. The [official JupyterHub documentation](https://jupyterhub.readthedocs.io/en/stable/reference/config-examples.html) has more examples of the `jupyter_config.py` script.

### Restrict traffic using NetworkPolicies

The Bitnami JupyterHub chart enables NetworkPolicies by default. This restricts the communication between the three main components: the Proxy, the Hub and the Single User instances. There are two elements that were left open on purpose:

- Ingress access to the Proxy instance HTTP port: by default, it is open to any IP, as it is the entry point to the JupyterHub instance. This behavior can be changed by tweaking the `proxy.networkPolicy.extraIngress` value.
- Hub egress access: As the Hub requires access to the Kubernetes API, the Hub can access to any IP by default (depending on the Kubernetes platform, the Service IP ranges can vary and so there is no easy way to detect the Kubernetes API internal IP). This behavior can be changed by tweaking the `hub.networkPolicy.extraEgress` value.

### Use sidecars and init containers

If additional containers are needed in the same pod (such as additional metrics or logging exporters), they can be defined using the `proxy.sidecars`, `hub.sidecars` or `singleuser.sidecars` config parameters.

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

Similarly, extra init containers can be added using the `hub.initContainers`, `proxy.initContainers` and `singleuser.initContainers` parameters.

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

### Configure Ingress

This chart provides support for Ingress resources. If you have an ingress controller installed on your cluster, such as [nginx-ingress-controller](https://github.com/bitnami/charts/tree/main/bitnami/nginx-ingress-controller) or [contour](https://github.com/bitnami/charts/tree/main/bitnami/contour) you can utilize the ingress controller to serve your application.To enable Ingress integration, set `proxy.ingress.enabled` to `true`.

The most common scenario is to have one host name mapped to the deployment. In this case, the `proxy.ingress.hostname` property can be used to set the host name. The `proxy.ingress.tls` parameter can be used to add the TLS configuration for this host.

However, it is also possible to have more than one host. To facilitate this, the `proxy.ingress.extraHosts` parameter (if available) can be set with the host names specified as an array. The `proxy.ingress.extraTLS` parameter (if available) can also be used to add the TLS configuration for extra hosts.

> NOTE: For each host specified in the `proxy.ingress.extraHosts` parameter, it is necessary to set a name, path, and any annotations that the Ingress controller should know about. Not all annotations are supported by all Ingress controllers, but [this annotation reference document](https://github.com/kubernetes/ingress-nginx/blob/master/docs/user-guide/nginx-configuration/annotations.md) lists the annotations supported by many popular Ingress controllers.

Adding the TLS parameter (where available) will cause the chart to generate HTTPS URLs, and the  application will be available on port 443. The actual TLS secrets do not have to be generated by this chart. However, if TLS is enabled, the Ingress record will not work until the TLS secret exists.

[Learn more about Ingress controllers](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/).

### Configure TLS secrets

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

### Set pod affinity

This chart allows you to set your custom affinity using the `*.affinity` parameter(s).

As an alternative, you can use the preset configurations for pod affinity, pod anti-affinity, and node affinity available in the `bitnami/common` chart. To do so, set the `*.podAffinityPreset`, `*.podAntiAffinityPreset`, or `*.nodeAffinityPreset` parameters.

[Learn more about pod affinity](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

### Deploy extra resources

There are cases where you may want to deploy extra objects, such a ConfigMap containing your app's configuration or some extra deployment with a micro service used by your app. For covering this case, the chart allows adding the full specification of other objects using the `extraDeploy` parameter.

## Parameters

### Global parameters

| Name                                                  | Description                                                                                                                                                                                                                                                                                                                                                         | Value  |
| ----------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------ |
| `global.imageRegistry`                                | Global Docker image registry                                                                                                                                                                                                                                                                                                                                        | `""`   |
| `global.imagePullSecrets`                             | Global Docker registry secret names as an array                                                                                                                                                                                                                                                                                                                     | `[]`   |
| `global.storageClass`                                 | Global StorageClass for Persistent Volume(s)                                                                                                                                                                                                                                                                                                                        | `""`   |
| `global.compatibility.openshift.adaptSecurityContext` | Adapt the securityContext sections of the deployment to make them compatible with Openshift restricted-v2 SCC: remove runAsUser, runAsGroup and fsGroup and let the platform use their allowed default IDs. Possible values: auto (apply if the detected running cluster is Openshift), force (perform the adaptation always), disabled (do not perform adaptation) | `auto` |

### Common parameters

| Name                     | Description                                                                             | Value           |
| ------------------------ | --------------------------------------------------------------------------------------- | --------------- |
| `kubeVersion`            | Override Kubernetes version                                                             | `""`            |
| `nameOverride`           | String to partially override common.names.fullname (will maintain the release name)     | `""`            |
| `fullnameOverride`       | String to fully override common.names.fullname                                          | `""`            |
| `clusterDomain`          | Kubernetes Cluster Domain                                                               | `cluster.local` |
| `commonLabels`           | Labels to add to all deployed objects                                                   | `{}`            |
| `commonAnnotations`      | Annotations to add to all deployed objects                                              | `{}`            |
| `extraDeploy`            | Array of extra objects to deploy with the release                                       | `[]`            |
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden) | `false`         |
| `diagnosticMode.command` | Command to override all containers in the the deployment(s)/daemonset(s)                | `["sleep"]`     |
| `diagnosticMode.args`    | Args to override all containers in the the deployment(s)/daemonset(s)                   | `["infinity"]`  |

### Hub deployment parameters

| Name                                                    | Description                                                                                                                                                                                                               | Value                        |
| ------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------- |
| `hub.image.registry`                                    | Hub image registry                                                                                                                                                                                                        | `REGISTRY_NAME`              |
| `hub.image.repository`                                  | Hub image repository                                                                                                                                                                                                      | `REPOSITORY_NAME/jupyterhub` |
| `hub.image.digest`                                      | Hub image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                       | `""`                         |
| `hub.image.pullPolicy`                                  | Hub image pull policy                                                                                                                                                                                                     | `IfNotPresent`               |
| `hub.image.pullSecrets`                                 | Hub image pull secrets                                                                                                                                                                                                    | `[]`                         |
| `hub.baseUrl`                                           | Hub base URL                                                                                                                                                                                                              | `/`                          |
| `hub.adminUser`                                         | Hub Dummy authenticator admin user                                                                                                                                                                                        | `user`                       |
| `hub.password`                                          | Hub Dummy authenticator password                                                                                                                                                                                          | `""`                         |
| `hub.services`                                          | JupyterHub services interacting with the JupyterHub API                                                                                                                                                                   | `{}`                         |
| `hub.configuration`                                     | Hub configuration file (to be used by jupyterhub_config.py)                                                                                                                                                               | `""`                         |
| `hub.existingConfigmap`                                 | Configmap with Hub init scripts (replaces the scripts in templates/hub/configmap.yml)                                                                                                                                     | `""`                         |
| `hub.existingSecret`                                    | Secret with hub configuration (replaces the hub.configuration value) and proxy token                                                                                                                                      | `""`                         |
| `hub.command`                                           | Override Hub default command                                                                                                                                                                                              | `[]`                         |
| `hub.args`                                              | Override Hub default args                                                                                                                                                                                                 | `[]`                         |
| `hub.extraEnvVars`                                      | Add extra environment variables to the Hub container                                                                                                                                                                      | `[]`                         |
| `hub.extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars                                                                                                                                                                      | `""`                         |
| `hub.extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars                                                                                                                                                                         | `""`                         |
| `hub.containerPorts.http`                               | Hub container port                                                                                                                                                                                                        | `8081`                       |
| `hub.startupProbe.enabled`                              | Enable startupProbe on Hub containers                                                                                                                                                                                     | `true`                       |
| `hub.startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                                    | `10`                         |
| `hub.startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                           | `10`                         |
| `hub.startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                          | `3`                          |
| `hub.startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                        | `30`                         |
| `hub.startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                        | `1`                          |
| `hub.livenessProbe.enabled`                             | Enable livenessProbe on Hub containers                                                                                                                                                                                    | `true`                       |
| `hub.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                                   | `10`                         |
| `hub.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                          | `10`                         |
| `hub.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                         | `3`                          |
| `hub.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                                       | `30`                         |
| `hub.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                                       | `1`                          |
| `hub.readinessProbe.enabled`                            | Enable readinessProbe on Hub containers                                                                                                                                                                                   | `true`                       |
| `hub.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                                  | `10`                         |
| `hub.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                         | `10`                         |
| `hub.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                        | `3`                          |
| `hub.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                                      | `30`                         |
| `hub.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                                      | `1`                          |
| `hub.customStartupProbe`                                | Override default startup probe                                                                                                                                                                                            | `{}`                         |
| `hub.customLivenessProbe`                               | Override default liveness probe                                                                                                                                                                                           | `{}`                         |
| `hub.customReadinessProbe`                              | Override default readiness probe                                                                                                                                                                                          | `{}`                         |
| `hub.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if hub.resources is set (hub.resources is recommended for production). | `small`                      |
| `hub.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                         | `{}`                         |
| `hub.containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                                                                                                                                      | `true`                       |
| `hub.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                          | `{}`                         |
| `hub.containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                                                                                                                | `1001`                       |
| `hub.containerSecurityContext.runAsGroup`               | Set containers' Security Context runAsGroup                                                                                                                                                                               | `1001`                       |
| `hub.containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                                                                                                                             | `true`                       |
| `hub.containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                                                                                                                               | `false`                      |
| `hub.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                                   | `true`                       |
| `hub.containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                                                                                                                 | `false`                      |
| `hub.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                        | `["ALL"]`                    |
| `hub.containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                          | `RuntimeDefault`             |
| `hub.podSecurityContext.enabled`                        | Enabled Hub pods' Security Context                                                                                                                                                                                        | `true`                       |
| `hub.podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                        | `Always`                     |
| `hub.podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                            | `[]`                         |
| `hub.podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                               | `[]`                         |
| `hub.podSecurityContext.fsGroup`                        | Set Hub pod's Security Context fsGroup                                                                                                                                                                                    | `1001`                       |
| `hub.lifecycleHooks`                                    | LifecycleHooks for the Hub container to automate configuration before or after startup                                                                                                                                    | `{}`                         |
| `hub.automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                        | `true`                       |
| `hub.hostAliases`                                       | Add deployment host aliases                                                                                                                                                                                               | `[]`                         |
| `hub.podLabels`                                         | Add extra labels to the Hub pods                                                                                                                                                                                          | `{}`                         |
| `hub.podAnnotations`                                    | Add extra annotations to the Hub pods                                                                                                                                                                                     | `{}`                         |
| `hub.podAffinityPreset`                                 | Pod affinity preset. Ignored if `hub.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                   | `""`                         |
| `hub.podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `hub.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                              | `soft`                       |
| `hub.nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `hub.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                             | `""`                         |
| `hub.nodeAffinityPreset.key`                            | Node label key to match. Ignored if `hub.affinity` is set                                                                                                                                                                 | `""`                         |
| `hub.nodeAffinityPreset.values`                         | Node label values to match. Ignored if `hub.affinity` is set                                                                                                                                                              | `[]`                         |
| `hub.affinity`                                          | Affinity for pod assignment.                                                                                                                                                                                              | `{}`                         |
| `hub.nodeSelector`                                      | Node labels for pod assignment.                                                                                                                                                                                           | `{}`                         |
| `hub.tolerations`                                       | Tolerations for pod assignment.                                                                                                                                                                                           | `[]`                         |
| `hub.topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template                                                                                                  | `[]`                         |
| `hub.priorityClassName`                                 | Priority Class Name                                                                                                                                                                                                       | `""`                         |
| `hub.schedulerName`                                     | Use an alternate scheduler, e.g. "stork".                                                                                                                                                                                 | `""`                         |
| `hub.terminationGracePeriodSeconds`                     | Seconds Hub pod needs to terminate gracefully                                                                                                                                                                             | `""`                         |
| `hub.updateStrategy.type`                               | Update strategy - only really applicable for deployments with RWO PVs attached                                                                                                                                            | `RollingUpdate`              |
| `hub.updateStrategy.rollingUpdate`                      | Hub deployment rolling update configuration parameters                                                                                                                                                                    | `{}`                         |
| `hub.extraVolumes`                                      | Optionally specify extra list of additional volumes for Hub pods                                                                                                                                                          | `[]`                         |
| `hub.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for Hub container(s)                                                                                                                                             | `[]`                         |
| `hub.initContainers`                                    | Add additional init containers to the Hub pods                                                                                                                                                                            | `[]`                         |
| `hub.sidecars`                                          | Add additional sidecar containers to the Hub pod                                                                                                                                                                          | `[]`                         |
| `hub.pdb.create`                                        | Deploy Hub PodDisruptionBudget                                                                                                                                                                                            | `false`                      |
| `hub.pdb.minAvailable`                                  | Set minimum available hub instances                                                                                                                                                                                       | `""`                         |
| `hub.pdb.maxUnavailable`                                | Set maximum available hub instances                                                                                                                                                                                       | `""`                         |

### Hub RBAC parameters

| Name                                              | Description                                                            | Value   |
| ------------------------------------------------- | ---------------------------------------------------------------------- | ------- |
| `hub.serviceAccount.create`                       | Specifies whether a ServiceAccount should be created                   | `true`  |
| `hub.serviceAccount.name`                         | Override Hub service account name                                      | `""`    |
| `hub.serviceAccount.automountServiceAccountToken` | Allows auto mount of ServiceAccountToken on the serviceAccount created | `false` |
| `hub.serviceAccount.annotations`                  | Additional custom annotations for the ServiceAccount                   | `{}`    |
| `hub.rbac.create`                                 | Specifies whether RBAC resources should be created                     | `true`  |
| `hub.rbac.rules`                                  | Custom RBAC rules to set                                               | `[]`    |

### Hub Traffic Exposure Parameters

| Name                                        | Description                                                      | Value       |
| ------------------------------------------- | ---------------------------------------------------------------- | ----------- |
| `hub.networkPolicy.enabled`                 | Deploy Hub network policies                                      | `true`      |
| `hub.networkPolicy.allowExternal`           | Don't require server label for connections                       | `true`      |
| `hub.networkPolicy.allowExternalEgress`     | Allow the pod to access any range of port and all destinations.  | `true`      |
| `hub.networkPolicy.allowInterspaceAccess`   | Allow communication between pods in different namespaces         | `true`      |
| `hub.networkPolicy.extraIngress`            | Add extra ingress rules to the NetworkPolicy                     | `[]`        |
| `hub.networkPolicy.extraEgress`             | Add extra ingress rules to the NetworkPolicy                     | `""`        |
| `hub.networkPolicy.ingressNSMatchLabels`    | Labels to match to allow traffic from other namespaces           | `{}`        |
| `hub.networkPolicy.ingressNSPodMatchLabels` | Pod labels to match to allow traffic from other namespaces       | `{}`        |
| `hub.service.type`                          | Hub service type                                                 | `ClusterIP` |
| `hub.service.ports.http`                    | Hub service HTTP port                                            | `8081`      |
| `hub.service.nodePorts.http`                | NodePort for the HTTP endpoint                                   | `""`        |
| `hub.service.sessionAffinity`               | Control where client requests go, to the same pod or round-robin | `None`      |
| `hub.service.sessionAffinityConfig`         | Additional settings for the sessionAffinity                      | `{}`        |
| `hub.service.clusterIP`                     | Hub service Cluster IP                                           | `""`        |
| `hub.service.loadBalancerIP`                | Hub service Load Balancer IP                                     | `""`        |
| `hub.service.loadBalancerSourceRanges`      | Hub service Load Balancer sources                                | `[]`        |
| `hub.service.externalTrafficPolicy`         | Hub service external traffic policy                              | `Cluster`   |
| `hub.service.annotations`                   | Additional custom annotations for Hub service                    | `{}`        |
| `hub.service.extraPorts`                    | Extra port to expose on Hub service                              | `[]`        |

### Hub Metrics parameters

| Name                                           | Description                                                                                 | Value          |
| ---------------------------------------------- | ------------------------------------------------------------------------------------------- | -------------- |
| `hub.metrics.authenticatePrometheus`           | Use authentication for Prometheus                                                           | `false`        |
| `hub.metrics.serviceMonitor.enabled`           | If the operator is installed in your cluster, set to true to create a Service Monitor Entry | `false`        |
| `hub.metrics.serviceMonitor.namespace`         | Namespace which Prometheus is running in                                                    | `""`           |
| `hub.metrics.serviceMonitor.path`              | HTTP path to scrape for metrics                                                             | `/hub/metrics` |
| `hub.metrics.serviceMonitor.interval`          | Interval at which metrics should be scraped                                                 | `30s`          |
| `hub.metrics.serviceMonitor.scrapeTimeout`     | Specify the timeout after which the scrape is ended                                         | `""`           |
| `hub.metrics.serviceMonitor.labels`            | Additional labels that can be used so ServiceMonitor will be discovered by Prometheus       | `{}`           |
| `hub.metrics.serviceMonitor.selector`          | Prometheus instance selector labels                                                         | `{}`           |
| `hub.metrics.serviceMonitor.relabelings`       | RelabelConfigs to apply to samples before scraping                                          | `[]`           |
| `hub.metrics.serviceMonitor.metricRelabelings` | MetricRelabelConfigs to apply to samples before ingestion                                   | `[]`           |
| `hub.metrics.serviceMonitor.honorLabels`       | Specify honorLabels parameter to add the scrape endpoint                                    | `false`        |
| `hub.metrics.serviceMonitor.jobLabel`          | The name of the label on the target service to use as the job name in prometheus.           | `""`           |

### Proxy deployment parameters

| Name                                                      | Description                                                                                                                                                                                                                   | Value                                     |
| --------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------- |
| `proxy.image.registry`                                    | Proxy image registry                                                                                                                                                                                                          | `REGISTRY_NAME`                           |
| `proxy.image.repository`                                  | Proxy image repository                                                                                                                                                                                                        | `REPOSITORY_NAME/configurable-http-proxy` |
| `proxy.image.digest`                                      | Proxy image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                         | `""`                                      |
| `proxy.image.pullPolicy`                                  | Proxy image pull policy                                                                                                                                                                                                       | `IfNotPresent`                            |
| `proxy.image.pullSecrets`                                 | Proxy image pull secrets                                                                                                                                                                                                      | `[]`                                      |
| `proxy.image.debug`                                       | Activate verbose output                                                                                                                                                                                                       | `false`                                   |
| `proxy.secretToken`                                       | Proxy secret token (used for communication with the Hub)                                                                                                                                                                      | `""`                                      |
| `proxy.command`                                           | Override Proxy default command                                                                                                                                                                                                | `[]`                                      |
| `proxy.args`                                              | Override Proxy default args                                                                                                                                                                                                   | `[]`                                      |
| `proxy.extraEnvVars`                                      | Add extra environment variables to the Proxy container                                                                                                                                                                        | `[]`                                      |
| `proxy.extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars                                                                                                                                                                          | `""`                                      |
| `proxy.extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars                                                                                                                                                                             | `""`                                      |
| `proxy.containerPort.api`                                 | Proxy api container port                                                                                                                                                                                                      | `8001`                                    |
| `proxy.containerPort.metrics`                             | Proxy metrics container port                                                                                                                                                                                                  | `8002`                                    |
| `proxy.containerPort.http`                                | Proxy http container port                                                                                                                                                                                                     | `8000`                                    |
| `proxy.startupProbe.enabled`                              | Enable startupProbe on Proxy containers                                                                                                                                                                                       | `true`                                    |
| `proxy.startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                                        | `10`                                      |
| `proxy.startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                               | `10`                                      |
| `proxy.startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                              | `3`                                       |
| `proxy.startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                            | `30`                                      |
| `proxy.startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                            | `1`                                       |
| `proxy.livenessProbe.enabled`                             | Enable livenessProbe on Proxy containers                                                                                                                                                                                      | `true`                                    |
| `proxy.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                                       | `10`                                      |
| `proxy.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                              | `10`                                      |
| `proxy.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                             | `3`                                       |
| `proxy.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                                           | `30`                                      |
| `proxy.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                                           | `1`                                       |
| `proxy.readinessProbe.enabled`                            | Enable readinessProbe on Proxy containers                                                                                                                                                                                     | `true`                                    |
| `proxy.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                                      | `10`                                      |
| `proxy.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                             | `10`                                      |
| `proxy.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                            | `3`                                       |
| `proxy.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                                          | `30`                                      |
| `proxy.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                                          | `1`                                       |
| `proxy.customStartupProbe`                                | Override default startup probe                                                                                                                                                                                                | `{}`                                      |
| `proxy.customLivenessProbe`                               | Override default liveness probe                                                                                                                                                                                               | `{}`                                      |
| `proxy.customReadinessProbe`                              | Override default readiness probe                                                                                                                                                                                              | `{}`                                      |
| `proxy.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if proxy.resources is set (proxy.resources is recommended for production). | `nano`                                    |
| `proxy.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                             | `{}`                                      |
| `proxy.containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                                                                                                                                          | `true`                                    |
| `proxy.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                              | `{}`                                      |
| `proxy.containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                                                                                                                    | `1001`                                    |
| `proxy.containerSecurityContext.runAsGroup`               | Set containers' Security Context runAsGroup                                                                                                                                                                                   | `1001`                                    |
| `proxy.containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                                                                                                                                 | `true`                                    |
| `proxy.containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                                                                                                                                   | `false`                                   |
| `proxy.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                                       | `true`                                    |
| `proxy.containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                                                                                                                     | `false`                                   |
| `proxy.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                            | `["ALL"]`                                 |
| `proxy.containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                              | `RuntimeDefault`                          |
| `proxy.podSecurityContext.enabled`                        | Enabled Proxy pods' Security Context                                                                                                                                                                                          | `true`                                    |
| `proxy.podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                            | `Always`                                  |
| `proxy.podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                                | `[]`                                      |
| `proxy.podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                                   | `[]`                                      |
| `proxy.podSecurityContext.fsGroup`                        | Set Proxy pod's Security Context fsGroup                                                                                                                                                                                      | `1001`                                    |
| `proxy.lifecycleHooks`                                    | Add lifecycle hooks to the Proxy deployment                                                                                                                                                                                   | `{}`                                      |
| `proxy.automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                            | `false`                                   |
| `proxy.hostAliases`                                       | Add deployment host aliases                                                                                                                                                                                                   | `[]`                                      |
| `proxy.podLabels`                                         | Add extra labels to the Proxy pods                                                                                                                                                                                            | `{}`                                      |
| `proxy.podAnnotations`                                    | Add extra annotations to the Proxy pods                                                                                                                                                                                       | `{}`                                      |
| `proxy.podAffinityPreset`                                 | Pod affinity preset. Ignored if `proxy.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                     | `""`                                      |
| `proxy.podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `proxy.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                | `soft`                                    |
| `proxy.nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `proxy.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                               | `""`                                      |
| `proxy.nodeAffinityPreset.key`                            | Node label key to match. Ignored if `proxy.affinity` is set                                                                                                                                                                   | `""`                                      |
| `proxy.nodeAffinityPreset.values`                         | Node label values to match. Ignored if `proxy.affinity` is set                                                                                                                                                                | `[]`                                      |
| `proxy.affinity`                                          | Affinity for pod assignment. Evaluated as a template.                                                                                                                                                                         | `{}`                                      |
| `proxy.nodeSelector`                                      | Node labels for pod assignment. Evaluated as a template.                                                                                                                                                                      | `{}`                                      |
| `proxy.tolerations`                                       | Tolerations for pod assignment. Evaluated as a template.                                                                                                                                                                      | `[]`                                      |
| `proxy.topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template                                                                                                      | `[]`                                      |
| `proxy.priorityClassName`                                 | Priority Class Name                                                                                                                                                                                                           | `""`                                      |
| `proxy.schedulerName`                                     | Use an alternate scheduler, e.g. "stork".                                                                                                                                                                                     | `""`                                      |
| `proxy.terminationGracePeriodSeconds`                     | Seconds Proxy pod needs to terminate gracefully                                                                                                                                                                               | `""`                                      |
| `proxy.updateStrategy.type`                               | Update strategy - only really applicable for deployments with RWO PVs attached                                                                                                                                                | `RollingUpdate`                           |
| `proxy.updateStrategy.rollingUpdate`                      | Proxy deployment rolling update configuration parameters                                                                                                                                                                      | `{}`                                      |
| `proxy.extraVolumes`                                      | Optionally specify extra list of additional volumes for Proxy pods                                                                                                                                                            | `[]`                                      |
| `proxy.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for Proxy container(s)                                                                                                                                               | `[]`                                      |
| `proxy.initContainers`                                    | Add additional init containers to the Proxy pods                                                                                                                                                                              | `[]`                                      |
| `proxy.sidecars`                                          | Add additional sidecar containers to the Proxy pod                                                                                                                                                                            | `[]`                                      |
| `proxy.pdb.create`                                        | Deploy Proxy PodDisruptionBudget                                                                                                                                                                                              | `false`                                   |
| `proxy.pdb.minAvailable`                                  | Set minimum available proxy instances                                                                                                                                                                                         | `""`                                      |
| `proxy.pdb.maxUnavailable`                                | Set maximum available proxy instances                                                                                                                                                                                         | `""`                                      |

### Proxy RBAC Parameters

| Name                                                | Description                                                            | Value   |
| --------------------------------------------------- | ---------------------------------------------------------------------- | ------- |
| `proxy.serviceAccount.create`                       | Specifies whether a ServiceAccount should be created                   | `true`  |
| `proxy.serviceAccount.name`                         | Override Hub service account name                                      | `""`    |
| `proxy.serviceAccount.automountServiceAccountToken` | Allows auto mount of ServiceAccountToken on the serviceAccount created | `false` |
| `proxy.serviceAccount.annotations`                  | Additional custom annotations for the ServiceAccount                   | `{}`    |

### Proxy Traffic Exposure Parameters

| Name                                             | Description                                                                                                                      | Value                    |
| ------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `proxy.networkPolicy.enabled`                    | Deploy Proxy network policies                                                                                                    | `true`                   |
| `proxy.networkPolicy.allowExternal`              | Don't require server label for connections                                                                                       | `true`                   |
| `proxy.networkPolicy.allowExternalEgress`        | Allow the pod to access any range of port and all destinations.                                                                  | `true`                   |
| `proxy.networkPolicy.allowInterspaceAccess`      | Allow communication between pods in different namespaces                                                                         | `true`                   |
| `proxy.networkPolicy.extraIngress`               | Add extra ingress rules to the NetworkPolicy                                                                                     | `[]`                     |
| `proxy.networkPolicy.extraEgress`                | Add extra egress rules to the NetworkPolicy                                                                                      | `[]`                     |
| `proxy.networkPolicy.ingressNSMatchLabels`       | Labels to match to allow traffic from other namespaces                                                                           | `{}`                     |
| `proxy.networkPolicy.ingressNSPodMatchLabels`    | Pod labels to match to allow traffic from other namespaces                                                                       | `{}`                     |
| `proxy.service.api.type`                         | API service type                                                                                                                 | `ClusterIP`              |
| `proxy.service.api.ports.http`                   | API service HTTP port                                                                                                            | `8001`                   |
| `proxy.service.api.nodePorts.http`               | NodePort for the HTTP endpoint                                                                                                   | `""`                     |
| `proxy.service.api.sessionAffinity`              | Control where client requests go, to the same pod or round-robin                                                                 | `None`                   |
| `proxy.service.api.sessionAffinityConfig`        | Additional settings for the sessionAffinity                                                                                      | `{}`                     |
| `proxy.service.api.clusterIP`                    | Hub service Cluster IP                                                                                                           | `""`                     |
| `proxy.service.api.loadBalancerIP`               | Hub service Load Balancer IP                                                                                                     | `""`                     |
| `proxy.service.api.loadBalancerSourceRanges`     | Hub service Load Balancer sources                                                                                                | `[]`                     |
| `proxy.service.api.externalTrafficPolicy`        | Hub service external traffic policy                                                                                              | `Cluster`                |
| `proxy.service.api.annotations`                  | Additional custom annotations for Hub service                                                                                    | `{}`                     |
| `proxy.service.api.extraPorts`                   | Extra port to expose on Hub service                                                                                              | `[]`                     |
| `proxy.service.metrics.type`                     | Metrics service type                                                                                                             | `ClusterIP`              |
| `proxy.service.metrics.ports.http`               | Metrics service port                                                                                                             | `8002`                   |
| `proxy.service.metrics.nodePorts.http`           | NodePort for the HTTP endpoint                                                                                                   | `""`                     |
| `proxy.service.metrics.sessionAffinity`          | Control where client requests go, to the same pod or round-robin                                                                 | `None`                   |
| `proxy.service.metrics.sessionAffinityConfig`    | Additional settings for the sessionAffinity                                                                                      | `{}`                     |
| `proxy.service.metrics.clusterIP`                | Hub service Cluster IP                                                                                                           | `""`                     |
| `proxy.service.metrics.loadBalancerIP`           | Hub service Load Balancer IP                                                                                                     | `""`                     |
| `proxy.service.metrics.loadBalancerSourceRanges` | Hub service Load Balancer sources                                                                                                | `[]`                     |
| `proxy.service.metrics.externalTrafficPolicy`    | Hub service external traffic policy                                                                                              | `Cluster`                |
| `proxy.service.metrics.annotations`              | Additional custom annotations for Hub service                                                                                    | `{}`                     |
| `proxy.service.metrics.extraPorts`               | Extra port to expose on Hub service                                                                                              | `[]`                     |
| `proxy.service.public.type`                      | Public service type                                                                                                              | `LoadBalancer`           |
| `proxy.service.public.ports.http`                | Public service HTTP port                                                                                                         | `80`                     |
| `proxy.service.public.nodePorts.http`            | NodePort for the HTTP endpoint                                                                                                   | `""`                     |
| `proxy.service.public.sessionAffinity`           | Control where client requests go, to the same pod or round-robin                                                                 | `None`                   |
| `proxy.service.public.sessionAffinityConfig`     | Additional settings for the sessionAffinity                                                                                      | `{}`                     |
| `proxy.service.public.clusterIP`                 | Hub service Cluster IP                                                                                                           | `""`                     |
| `proxy.service.public.loadBalancerIP`            | Hub service Load Balancer IP                                                                                                     | `""`                     |
| `proxy.service.public.loadBalancerSourceRanges`  | Hub service Load Balancer sources                                                                                                | `[]`                     |
| `proxy.service.public.externalTrafficPolicy`     | Hub service external traffic policy                                                                                              | `Cluster`                |
| `proxy.service.public.annotations`               | Additional custom annotations for Hub service                                                                                    | `{}`                     |
| `proxy.service.public.extraPorts`                | Extra port to expose on Hub service                                                                                              | `[]`                     |
| `proxy.ingress.enabled`                          | Set to true to enable ingress record generation                                                                                  | `false`                  |
| `proxy.ingress.apiVersion`                       | Force Ingress API version (automatically detected if not set)                                                                    | `""`                     |
| `proxy.ingress.ingressClassName`                 | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                    | `""`                     |
| `proxy.ingress.pathType`                         | Ingress path type                                                                                                                | `ImplementationSpecific` |
| `proxy.ingress.hostname`                         | Set ingress rule hostname                                                                                                        | `jupyterhub.local`       |
| `proxy.ingress.path`                             | Path to the Proxy pod                                                                                                            | `/`                      |
| `proxy.ingress.annotations`                      | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                     |
| `proxy.ingress.tls`                              | Enable TLS configuration for the host defined at `ingress.hostname` parameter                                                    | `false`                  |
| `proxy.ingress.selfSigned`                       | Create a TLS secret for this ingress record using self-signed certificates generated by Helm                                     | `false`                  |
| `proxy.ingress.extraHosts`                       | An array with additional hostname(s) to be covered with the ingress record                                                       | `[]`                     |
| `proxy.ingress.extraPaths`                       | An array with additional arbitrary paths that may need to be added to the ingress under the main host                            | `[]`                     |
| `proxy.ingress.extraTls`                         | The tls configuration for additional hostnames to be covered with this ingress record.                                           | `[]`                     |
| `proxy.ingress.secrets`                          | Custom TLS certificates as secrets                                                                                               | `[]`                     |
| `proxy.ingress.extraRules`                       | Additional rules to be covered with this ingress record                                                                          | `[]`                     |

### Proxy Metrics parameters

| Name                                             | Description                                                                                 | Value      |
| ------------------------------------------------ | ------------------------------------------------------------------------------------------- | ---------- |
| `proxy.metrics.serviceMonitor.enabled`           | If the operator is installed in your cluster, set to true to create a Service Monitor Entry | `false`    |
| `proxy.metrics.serviceMonitor.namespace`         | Namespace which Prometheus is running in                                                    | `""`       |
| `proxy.metrics.serviceMonitor.path`              | HTTP path to scrape for metrics                                                             | `/metrics` |
| `proxy.metrics.serviceMonitor.interval`          | Interval at which metrics should be scraped                                                 | `30s`      |
| `proxy.metrics.serviceMonitor.scrapeTimeout`     | Specify the timeout after which the scrape is ended                                         | `""`       |
| `proxy.metrics.serviceMonitor.labels`            | Additional labels that can be used so ServiceMonitor will be discovered by Prometheus       | `{}`       |
| `proxy.metrics.serviceMonitor.selector`          | Prometheus instance selector labels                                                         | `{}`       |
| `proxy.metrics.serviceMonitor.relabelings`       | RelabelConfigs to apply to samples before scraping                                          | `[]`       |
| `proxy.metrics.serviceMonitor.metricRelabelings` | MetricRelabelConfigs to apply to samples before ingestion                                   | `[]`       |
| `proxy.metrics.serviceMonitor.honorLabels`       | Specify honorLabels parameter to add the scrape endpoint                                    | `false`    |
| `proxy.metrics.serviceMonitor.jobLabel`          | The name of the label on the target service to use as the job name in prometheus.           | `""`       |

### Image puller deployment parameters

| Name                                                            | Description                                                                                                                                                                                                                               | Value            |
| --------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| `imagePuller.enabled`                                           | Deploy ImagePuller daemonset                                                                                                                                                                                                              | `true`           |
| `imagePuller.command`                                           | Override ImagePuller default command                                                                                                                                                                                                      | `[]`             |
| `imagePuller.args`                                              | Override ImagePuller default args                                                                                                                                                                                                         | `[]`             |
| `imagePuller.extraEnvVars`                                      | Add extra environment variables to the ImagePuller container                                                                                                                                                                              | `[]`             |
| `imagePuller.extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars                                                                                                                                                                                      | `""`             |
| `imagePuller.extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars                                                                                                                                                                                         | `""`             |
| `imagePuller.livenessProbe.enabled`                             | Enable livenessProbe on ImagePuller containers                                                                                                                                                                                            | `true`           |
| `imagePuller.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                                                   | `1`              |
| `imagePuller.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                                          | `10`             |
| `imagePuller.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                                         | `3`              |
| `imagePuller.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                                                       | `30`             |
| `imagePuller.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                                                       | `1`              |
| `imagePuller.readinessProbe.enabled`                            | Enable readinessProbe on ImagePuller containers                                                                                                                                                                                           | `true`           |
| `imagePuller.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                                                  | `1`              |
| `imagePuller.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                                         | `10`             |
| `imagePuller.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                                        | `3`              |
| `imagePuller.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                                                      | `30`             |
| `imagePuller.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                                                      | `1`              |
| `imagePuller.startupProbe.enabled`                              | Enable startupProbe on ImagePuller containers                                                                                                                                                                                             | `false`          |
| `imagePuller.startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                                                    | `1`              |
| `imagePuller.startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                                           | `10`             |
| `imagePuller.startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                                          | `3`              |
| `imagePuller.startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                                        | `30`             |
| `imagePuller.startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                                        | `1`              |
| `imagePuller.customStartupProbe`                                | Override default startup probe                                                                                                                                                                                                            | `{}`             |
| `imagePuller.customLivenessProbe`                               | Override default liveness probe                                                                                                                                                                                                           | `{}`             |
| `imagePuller.customReadinessProbe`                              | Override default readiness probe                                                                                                                                                                                                          | `{}`             |
| `imagePuller.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if imagePuller.resources is set (imagePuller.resources is recommended for production). | `nano`           |
| `imagePuller.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                         | `{}`             |
| `imagePuller.containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                                                                                                                                                      | `true`           |
| `imagePuller.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                                          | `{}`             |
| `imagePuller.containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                                                                                                                                | `1001`           |
| `imagePuller.containerSecurityContext.runAsGroup`               | Set containers' Security Context runAsGroup                                                                                                                                                                                               | `1001`           |
| `imagePuller.containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                                                                                                                                             | `true`           |
| `imagePuller.containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                                                                                                                                               | `false`          |
| `imagePuller.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                                                   | `true`           |
| `imagePuller.containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                                                                                                                                 | `false`          |
| `imagePuller.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                                        | `["ALL"]`        |
| `imagePuller.containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                                          | `RuntimeDefault` |
| `imagePuller.podSecurityContext.enabled`                        | Enabled ImagePuller pods' Security Context                                                                                                                                                                                                | `true`           |
| `imagePuller.podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                                        | `Always`         |
| `imagePuller.podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                                            | `[]`             |
| `imagePuller.podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                                               | `[]`             |
| `imagePuller.podSecurityContext.fsGroup`                        | Set ImagePuller pod's Security Context fsGroup                                                                                                                                                                                            | `1001`           |
| `imagePuller.lifecycleHooks`                                    | Add lifecycle hooks to the ImagePuller deployment                                                                                                                                                                                         | `{}`             |
| `imagePuller.hostAliases`                                       | Add deployment host aliases                                                                                                                                                                                                               | `[]`             |
| `imagePuller.podLabels`                                         | Pod extra labels                                                                                                                                                                                                                          | `{}`             |
| `imagePuller.podAnnotations`                                    | Annotations for ImagePuller pods                                                                                                                                                                                                          | `{}`             |
| `imagePuller.podAffinityPreset`                                 | Pod affinity preset. Ignored if `imagePuller.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                           | `""`             |
| `imagePuller.podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `imagePuller.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                      | `soft`           |
| `imagePuller.nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `imagePuller.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                     | `""`             |
| `imagePuller.nodeAffinityPreset.key`                            | Node label key to match. Ignored if `imagePuller.affinity` is set                                                                                                                                                                         | `""`             |
| `imagePuller.nodeAffinityPreset.values`                         | Node label values to match. Ignored if `imagePuller.affinity` is set                                                                                                                                                                      | `[]`             |
| `imagePuller.affinity`                                          | Affinity for pod assignment. Evaluated as a template.                                                                                                                                                                                     | `{}`             |
| `imagePuller.nodeSelector`                                      | Node labels for pod assignment. Evaluated as a template.                                                                                                                                                                                  | `{}`             |
| `imagePuller.tolerations`                                       | Tolerations for pod assignment. Evaluated as a template.                                                                                                                                                                                  | `[]`             |
| `imagePuller.topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template                                                                                                                  | `[]`             |
| `imagePuller.priorityClassName`                                 | Priority Class Name                                                                                                                                                                                                                       | `""`             |
| `imagePuller.schedulerName`                                     | Use an alternate scheduler, e.g. "stork".                                                                                                                                                                                                 | `""`             |
| `imagePuller.terminationGracePeriodSeconds`                     | Seconds ImagePuller pod needs to terminate gracefully                                                                                                                                                                                     | `""`             |
| `imagePuller.updateStrategy.type`                               | Update strategy - only really applicable for deployments with RWO PVs attached                                                                                                                                                            | `RollingUpdate`  |
| `imagePuller.updateStrategy.rollingUpdate`                      | ImagePuller deployment rolling update configuration parameters                                                                                                                                                                            | `{}`             |
| `imagePuller.extraVolumes`                                      | Optionally specify extra list of additional volumes for ImagePuller pods                                                                                                                                                                  | `[]`             |
| `imagePuller.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for ImagePuller container(s)                                                                                                                                                     | `[]`             |
| `imagePuller.initContainers`                                    | Add additional init containers to the ImagePuller pods                                                                                                                                                                                    | `[]`             |
| `imagePuller.sidecars`                                          | Add additional sidecar containers to the ImagePuller pod                                                                                                                                                                                  | `[]`             |
| `imagePuller.serviceAccount.create`                             | Specifies whether a ServiceAccount should be created                                                                                                                                                                                      | `true`           |
| `imagePuller.serviceAccount.name`                               | Override image puller service account name                                                                                                                                                                                                | `""`             |
| `imagePuller.serviceAccount.automountServiceAccountToken`       | Allows auto mount of ServiceAccountToken on the serviceAccount created                                                                                                                                                                    | `false`          |
| `imagePuller.serviceAccount.annotations`                        | Additional custom annotations for the ServiceAccount                                                                                                                                                                                      | `{}`             |
| `imagePuller.networkPolicy.enabled`                             | Deploy imagePuller network policies                                                                                                                                                                                                       | `true`           |
| `imagePuller.networkPolicy.allowExternalEgress`                 | Allow the pod to access any range of port and all destinations.                                                                                                                                                                           | `true`           |
| `imagePuller.networkPolicy.extraIngress`                        | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                                              | `[]`             |
| `imagePuller.networkPolicy.extraEgress`                         | Add extra egress rules to the NetworkPolicy                                                                                                                                                                                               | `[]`             |

### Singleuser deployment parameters

| Name                                                           | Description                                                                                                                                                                                                                             | Value                                   |
| -------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------- |
| `singleuser.image.registry`                                    | Single User image registry                                                                                                                                                                                                              | `REGISTRY_NAME`                         |
| `singleuser.image.repository`                                  | Single User image repository                                                                                                                                                                                                            | `REPOSITORY_NAME/jupyter-base-notebook` |
| `singleuser.image.digest`                                      | Single User image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                             | `""`                                    |
| `singleuser.image.pullPolicy`                                  | Single User image pull policy                                                                                                                                                                                                           | `IfNotPresent`                          |
| `singleuser.image.pullSecrets`                                 | Single User image pull secrets                                                                                                                                                                                                          | `[]`                                    |
| `singleuser.notebookDir`                                       | Notebook directory (it will be the same as the PVC volume mount)                                                                                                                                                                        | `/opt/bitnami/jupyterhub-singleuser`    |
| `singleuser.allowPrivilegeEscalation`                          | Controls whether a process can gain more privileges than its parent process                                                                                                                                                             | `false`                                 |
| `singleuser.automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                                      | `false`                                 |
| `singleuser.command`                                           | Override Single User default command                                                                                                                                                                                                    | `[]`                                    |
| `singleuser.extraEnvVars`                                      | Extra environment variables that should be set for the user pods                                                                                                                                                                        | `[]`                                    |
| `singleuser.containerPorts.http`                               | Single User container port                                                                                                                                                                                                              | `8888`                                  |
| `singleuser.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if singleuser.resources is set (singleuser.resources is recommended for production). | `small`                                 |
| `singleuser.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                       | `{}`                                    |
| `singleuser.containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                                                                                                                                                    | `true`                                  |
| `singleuser.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                                        | `{}`                                    |
| `singleuser.containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                                                                                                                              | `1001`                                  |
| `singleuser.containerSecurityContext.runAsGroup`               | Set containers' Security Context runAsGroup                                                                                                                                                                                             | `1001`                                  |
| `singleuser.containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                                                                                                                                           | `true`                                  |
| `singleuser.containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                                                                                                                                             | `false`                                 |
| `singleuser.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                                                 | `true`                                  |
| `singleuser.containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                                                                                                                               | `false`                                 |
| `singleuser.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                                      | `["ALL"]`                               |
| `singleuser.containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                                        | `RuntimeDefault`                        |
| `singleuser.podSecurityContext.enabled`                        | Enabled Single User pods' Security Context                                                                                                                                                                                              | `true`                                  |
| `singleuser.podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                                      | `Always`                                |
| `singleuser.podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                                          | `[]`                                    |
| `singleuser.podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                                             | `[]`                                    |
| `singleuser.podSecurityContext.fsGroup`                        | Set Single User pod's Security Context fsGroup                                                                                                                                                                                          | `1001`                                  |
| `singleuser.podLabels`                                         | Extra labels for Single User pods                                                                                                                                                                                                       | `{}`                                    |
| `singleuser.podAnnotations`                                    | Annotations for Single User pods                                                                                                                                                                                                        | `{}`                                    |
| `singleuser.nodeSelector`                                      | Node labels for pod assignment. Evaluated as a template.                                                                                                                                                                                | `{}`                                    |
| `singleuser.tolerations`                                       | Tolerations for pod assignment. Evaluated as a template.                                                                                                                                                                                | `[]`                                    |
| `singleuser.priorityClassName`                                 | Single User pod priority class name                                                                                                                                                                                                     | `""`                                    |
| `singleuser.lifecycleHooks`                                    | Add lifecycle hooks to the Single User deployment to automate configuration before or after startup                                                                                                                                     | `{}`                                    |
| `singleuser.extraVolumes`                                      | Optionally specify extra list of additional volumes for Single User pods                                                                                                                                                                | `[]`                                    |
| `singleuser.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for Single User container(s)                                                                                                                                                   | `[]`                                    |
| `singleuser.initContainers`                                    | Add additional init containers to the Single User pods                                                                                                                                                                                  | `[]`                                    |
| `singleuser.sidecars`                                          | Add additional sidecar containers to the Single User pod                                                                                                                                                                                | `[]`                                    |

### Single User RBAC parameters

| Name                                                     | Description                                                            | Value   |
| -------------------------------------------------------- | ---------------------------------------------------------------------- | ------- |
| `singleuser.serviceAccount.create`                       | Specifies whether a ServiceAccount should be created                   | `true`  |
| `singleuser.serviceAccount.name`                         | Override Single User service account name                              | `""`    |
| `singleuser.serviceAccount.automountServiceAccountToken` | Allows auto mount of ServiceAccountToken on the serviceAccount created | `false` |
| `singleuser.serviceAccount.annotations`                  | Additional custom annotations for the ServiceAccount                   | `{}`    |

### Single User Persistence parameters

| Name                                  | Description                                                | Value               |
| ------------------------------------- | ---------------------------------------------------------- | ------------------- |
| `singleuser.persistence.enabled`      | Enable persistent volume creation on Single User instances | `true`              |
| `singleuser.persistence.storageClass` | Persistent Volumes storage class                           | `""`                |
| `singleuser.persistence.accessModes`  | Persistent Volumes access modes                            | `["ReadWriteOnce"]` |
| `singleuser.persistence.size`         | Persistent Volumes size                                    | `10Gi`              |
| `singleuser.profileList`              | Define JupyterHub profiles                                 | `[]`                |

### Traffic exposure parameters

| Name                                                | Description                                                     | Value   |
| --------------------------------------------------- | --------------------------------------------------------------- | ------- |
| `singleuser.networkPolicy.enabled`                  | Deploy Single User network policies                             | `true`  |
| `singleuser.networkPolicy.allowExternal`            | Don't require server label for connections                      | `true`  |
| `singleuser.networkPolicy.allowExternalEgress`      | Allow the pod to access any range of port and all destinations. | `true`  |
| `singleuser.networkPolicy.allowInterspaceAccess`    | Allow communication between pods in different namespaces        | `true`  |
| `singleuser.networkPolicy.allowCloudMetadataAccess` | Allow Single User pods to access Cloud Metada endpoints         | `false` |
| `singleuser.networkPolicy.extraIngress`             | Add extra ingress rules to the NetworkPolicy                    | `""`    |
| `singleuser.networkPolicy.extraEgress`              | Add extra egress rules to the NetworkPolicy                     | `""`    |
| `singleuser.networkPolicy.ingressNSMatchLabels`     | Labels to match to allow traffic from other namespaces          | `{}`    |
| `singleuser.networkPolicy.ingressNSPodMatchLabels`  | Pod labels to match to allow traffic from other namespaces      | `{}`    |

### Auxiliary image parameters

| Name                         | Description                                                                                               | Value                      |
| ---------------------------- | --------------------------------------------------------------------------------------------------------- | -------------------------- |
| `auxiliaryImage.registry`    | Auxiliary image registry                                                                                  | `REGISTRY_NAME`            |
| `auxiliaryImage.repository`  | Auxiliary image repository                                                                                | `REPOSITORY_NAME/os-shell` |
| `auxiliaryImage.digest`      | Auxiliary image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag | `""`                       |
| `auxiliaryImage.pullPolicy`  | Auxiliary image pull policy                                                                               | `IfNotPresent`             |
| `auxiliaryImage.pullSecrets` | Auxiliary image pull secrets                                                                              | `[]`                       |

### JupyterHub database parameters

| Name                                         | Description                                                             | Value                |
| -------------------------------------------- | ----------------------------------------------------------------------- | -------------------- |
| `postgresql.enabled`                         | Switch to enable or disable the PostgreSQL helm chart                   | `true`               |
| `postgresql.auth.username`                   | Name for a custom user to create                                        | `bn_jupyterhub`      |
| `postgresql.auth.password`                   | Password for the custom user to create                                  | `""`                 |
| `postgresql.auth.database`                   | Name for a custom database to create                                    | `bitnami_jupyterhub` |
| `postgresql.auth.existingSecret`             | Name of existing secret to use for PostgreSQL credentials               | `""`                 |
| `postgresql.architecture`                    | PostgreSQL architecture (`standalone` or `replication`)                 | `standalone`         |
| `postgresql.service.ports.postgresql`        | PostgreSQL service port                                                 | `5432`               |
| `externalDatabase.host`                      | Database host                                                           | `""`                 |
| `externalDatabase.port`                      | Database port number                                                    | `5432`               |
| `externalDatabase.user`                      | Non-root username for JupyterHub                                        | `postgres`           |
| `externalDatabase.password`                  | Password for the non-root username for JupyterHub                       | `""`                 |
| `externalDatabase.database`                  | JupyterHub database name                                                | `jupyterhub`         |
| `externalDatabase.existingSecret`            | Name of an existing secret resource containing the database credentials | `""`                 |
| `externalDatabase.existingSecretPasswordKey` | Name of an existing secret key containing the database credentials      | `""`                 |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
  --set proxy.livenessProbe.successThreshold=5 \
    oci://REGISTRY_NAME/REPOSITORY_NAME/jupyterhub
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The above command sets the `proxy.livenessProbe.successThreshold` to `5`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml oci://REGISTRY_NAME/REPOSITORY_NAME/jupyterhub
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 7.0.0

This major bump changes the following security defaults:

- `runAsGroup` is changed from `0` to `1001`
- `readOnlyRootFilesystem` is set to `true`
- `resourcesPreset` is changed from `none` to the minimum size working in our test suites (NOTE: `resourcesPreset` is not meant for production usage, but `resources` adapted to your use case).
- `global.compatibility.openshift.adaptSecurityContext` is changed from `disabled` to `auto`.
- The `networkPolicy` section has been normalized amongst all Bitnami charts. Compared to the previous approach, the values section has been simplified (check the Parameters section) and now it set to `enabled=true` by default. Egress traffic is allowed by default and ingress traffic is allowed by all pods but only to the ports set in `containerPorts`.

This could potentially break any customization or init scripts used in your deployment. If this is the case, change the default values to the previous ones.

### To 6.0.0

This major release bumps the PostgreSQL chart version to [14.x.x](https://github.com/bitnami/charts/pull/22750); no major issues are expected during the upgrade.

### To 5.0.0

This major updates the PostgreSQL subchart to its newest major, 13.0.0. [Here](https://github.com/bitnami/charts/tree/master/bitnami/postgresql#to-1300) you can find more information about the changes introduced in that version.

### To 3.0.0

This major updates the PostgreSQL subchart to its newest major, 12.0.0. [Here](https://github.com/bitnami/charts/tree/master/bitnami/postgresql#to-1200) you can find more information about the changes introduced in that version.

### To 1.0.0

This major release updates the PostgreSQL subchart to its newest major *11.x.x*, which contain several changes in the supported values (check the [upgrade notes](https://github.com/bitnami/charts/tree/master/bitnami/postgresql#to-1100) to obtain more information).

#### Upgrading Instructions

To upgrade to *1.0.0* from *0.x*, it should be done reusing the PVC(s) used to hold the data on your previous release. To do so, follow the instructions below (the following example assumes that the release name is *jupyterhub* and the release namespace *default*):

1. Obtain the credentials and the names of the PVCs used to hold the data on your current release:

```console
export JUPYTERHUB_PASSWORD=$(kubectl get secret --namespace default jupyterhub-hub -o jsonpath="{.data['values\.yaml']}" | base64 --decode | awk -F: '/password/ {gsub(/[ \t]+/, "", $2);print $2}' | tr -d '"')
export POSTGRESQL_PASSWORD=$(kubectl get secret --namespace default jupyterhub-postgresql -o jsonpath="{.data.postgresql-password}" | base64 --decode)
export POSTGRESQL_PVC=$(kubectl get pvc -l app.kubernetes.io/instance=jupyterhub,app.kubernetes.io/name=postgresql,role=primary -o jsonpath="{.items[0].metadata.name}")
```

1. Delete the PostgreSQL statefulset (notice the option *--cascade=false*) and secret:

```console
kubectl delete statefulsets.apps --cascade=false jupyterhub-postgresql
kubectl delete secret jupyterhub-postgresql --namespace default
```

1. Upgrade your release using the same PostgreSQL version:

```console
CURRENT_PG_VERSION=$(kubectl exec jupyterhub-postgresql-0 -- bash -c 'echo $BITNAMI_IMAGE_VERSION')
helm upgrade jupyterhub bitnami/jupyterhub \
  --set hub.password=$JUPYTERHUB_PASSWORD \
  --set postgresql.image.tag=$CURRENT_PG_VERSION \
  --set postgresql.auth.password=$POSTGRESQL_PASSWORD \
  --set postgresql.persistence.existingClaim=$POSTGRESQL_PVC
```

1. Delete the existing PostgreSQL pods and the new statefulset will create a new one:

```console
kubectl delete pod jupyterhub-postgresql-0
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