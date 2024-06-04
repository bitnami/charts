<!--- app-name: Kubeapps -->

# Bitnami package for Kubeapps

Kubeapps is a web-based UI for launching and managing applications on Kubernetes. It allows users to deploy trusted applications and operators to control users access to the cluster.

[Overview of Kubeapps](https://github.com/vmware-tanzu/kubeapps)

## TL;DR

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/kubeapps --namespace kubeapps --create-namespace
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.
> Check out the [getting started](https://github.com/vmware-tanzu/kubeapps/blob/main/site/content/docs/latest/tutorials/getting-started.md) to start deploying apps with Kubeapps.

Looking to use Kubeapps in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the enterprise edition of Bitnami Application Catalog.

## Introduction

This chart bootstraps a [Kubeapps](https://kubeapps.dev) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

With Kubeapps you can:

- Customize deployments through an intuitive, form-based user interface
- Inspect, upgrade and delete applications installed in the cluster
- Browse and deploy [Helm](https://github.com/helm/helm) charts from public or private chart repositories (including [VMware Marketplace&trade;](https://marketplace.cloud.vmware.com) and [Bitnami Application Catalog](https://bitnami.com/application-catalog))
- Browse and deploy [Kubernetes Operators](https://operatorhub.io/)
- Secure authentication to Kubeapps using a [standalone OAuth2/OIDC provider](https://github.com/vmware-tanzu/kubeapps/blob/main/site/content/docs/latest/tutorials/using-an-OIDC-provider.md) or [using Pinniped](https://github.com/vmware-tanzu/kubeapps/blob/main/site/content/docs/latest/howto/OIDC/using-an-OIDC-provider-with-pinniped.md)
- Secure authorization based on Kubernetes [Role-Based Access Control](https://github.com/vmware-tanzu/kubeapps/blob/main/site/content/docs/latest/howto/access-control.md)

**_Note:_** Kubeapps 2.0 and onwards supports Helm 3 only. While only the Helm 3 API is supported, in most cases, charts made for Helm 2 will still work.

It also packages the [Bitnami PostgreSQL chart](https://github.com/bitnami/charts/tree/main/bitnami/postgresql), which is required for bootstrapping a deployment for the database requirements of the Kubeapps application.

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+
- Administrative access to the cluster to create Custom Resource Definitions (CRDs)
- PV provisioner support in the underlying infrastructure (required for PostgreSQL database)

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/kubeapps --namespace kubeapps --create-namespace
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The command deploys Kubeapps on the Kubernetes cluster in the `kubeapps` namespace. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Caveat**: Only one Kubeapps installation is supported per namespace

Once you have installed Kubeapps follow the [Getting Started Guide](https://github.com/vmware-tanzu/kubeapps/blob/main/site/content/docs/latest/tutorials/getting-started.md) for additional information on how to access and use Kubeapps.

## Configuration and installation details

### Resource requests and limits

Bitnami charts allow setting resource requests and limits for all containers inside the chart deployment. These are inside the `resources` value (check parameter table). Setting requests is essential for production workloads and these should be adapted to your specific use case.

To make this process easier, the chart contains the `resourcesPreset` values, which automatically sets the `resources` section according to different presets. Check these presets in [the bitnami/common chart](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15). However, in production workloads using `resourcePreset` is discouraged as it may not fully adapt to your specific needs. Find more information on container resource management in the [official Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).

### Configuring Initial Repositories

By default, Kubeapps will track the [Bitnami Application Catalog](https://github.com/bitnami/charts). To change these defaults, override with your desired parameters the `apprepository.initialRepos` object present in the [values.yaml](https://github.com/bitnami/charts/tree/main/bitnami/kubeapps/values.yaml) file.

### Enabling Operators

Since v1.9.0 (and by default since v2.0), Kubeapps supports deploying and managing Operators within its dashboard. More information about how to enable and use this feature can be found in [this guide](https://github.com/vmware-tanzu/kubeapps/blob/main/site/content/docs/latest/tutorials/operators.md).

### Exposing Externally

> **Note**: The Kubeapps frontend sets up a proxy to the Kubernetes API service which means that when exposing the Kubeapps service to a network external to the Kubernetes cluster (perhaps on an internal or public network), the Kubernetes API will also be exposed for authenticated requests from that network. It is highly recommended that you [use an OAuth2/OIDC provider with Kubeapps](https://github.com/vmware-tanzu/kubeapps/blob/main/site/content/docs/latest/tutorials/using-an-OIDC-provider.md) to ensure that your authentication proxy is exposed rather than the Kubeapps frontend. This ensures that only the configured users trusted by your Identity Provider will be able to reach the Kubeapps frontend and therefore the Kubernetes API. Kubernetes service token authentication should only be used for users for demonstration purposes only, not production environments.

#### LoadBalancer Service

The simplest way to expose the Kubeapps Dashboard is to assign a LoadBalancer type to the Kubeapps frontend Service. For example, you can use the following parameter: `frontend.service.type=LoadBalancer`

Wait for your cluster to assign a LoadBalancer IP or Hostname to the `kubeapps` Service and access it on that address:

```console
kubectl get services --namespace kubeapps --watch
```

#### Ingress

This chart provides support for Ingress resources. If you have an ingress controller installed on your cluster, such as [nginx-ingress-controller](https://github.com/bitnami/charts/tree/main/bitnami/nginx-ingress-controller) or [contour](https://github.com/bitnami/charts/tree/main/bitnami/contour) you can utilize the ingress controller to serve your application.

To enable ingress integration, please set `ingress.enabled` to `true`

##### Hosts

Most likely you will only want to have one hostname that maps to this Kubeapps installation (use the `ingress.hostname` parameter to set the hostname), however, it is possible to have more than one host. To facilitate this, the `ingress.extraHosts` object is an array.

##### Annotations

For annotations, please see [this document](https://github.com/kubernetes/ingress-nginx/blob/main/docs/user-guide/nginx-configuration/annotations.md). Not all annotations are supported by all ingress controllers, but this document does a good job of indicating which annotation is supported by many popular ingress controllers. Annotations can be set using `ingress.annotations`.

##### TLS

This chart will facilitate the creation of TLS secrets for use with the ingress controller, however, this is not required. There are four common use cases:

- Helm generates/manages certificate secrets based on the parameters.
- The user generates/manages certificates separately.
- Helm creates self-signed certificates and generates/manages certificate secrets.
- An additional tool (like [cert-manager](https://github.com/jetstack/cert-manager/)) manages the secrets for the application.

In the first two cases, it is needed a certificate and a key. We would expect them to look like this:

- certificate files should look like (and there can be more than one certificate if there is a certificate chain)

  ```console
  -----BEGIN CERTIFICATE-----
  MIID6TCCAtGgAwIBAgIJAIaCwivkeB5EMA0GCSqGSIb3DQEBCwUAMFYxCzAJBgNV
  ...
  jScrvkiBO65F46KioCL9h5tDvomdU1aqpI/CBzhvZn1c0ZTf87tGQR8NK7v7
  -----END CERTIFICATE-----
  ```

- keys should look like:

  ```console
  -----BEGIN RSA PRIVATE KEY-----
  MIIEogIBAAKCAQEAvLYcyu8f3skuRyUgeeNpeDvYBCDcgq+LsWap6zbX5f8oLqp4
  ...
  wrj2wDbCDCFmfqnSJ+dKI3vFLlEz44sAV8jX/kd4Y6ZTQhlLbYc=
  -----END RSA PRIVATE KEY-----
  ```

- If you are going to use Helm to manage the certificates based on the parameters, please copy these values into the `certificate` and `key` values for a given `ingress.secrets` entry.
- In case you are going to manage TLS secrets separately, please know that you must use a TLS secret with name _INGRESS_HOSTNAME-tls_ (where _INGRESS_HOSTNAME_ is a placeholder to be replaced with the hostname you set using the `ingress.hostname` parameter).
- To use self-signed certificates created by Helm, set both `ingress.tls` and `ingress.selfSigned` to `true`.
- If your cluster has a [cert-manager](https://github.com/jetstack/cert-manager) add-on to automate the management and issuance of TLS certificates, set `ingress.certManager` boolean to true to enable the corresponding annotations for cert-manager.

## Parameters

### Global parameters

| Name                                                  | Description                                                                                                                                                                                                                                                                                                                                                         | Value  |
| ----------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------ |
| `global.imageRegistry`                                | Global Docker image registry                                                                                                                                                                                                                                                                                                                                        | `""`   |
| `global.imagePullSecrets`                             | Global Docker registry secret names as an array                                                                                                                                                                                                                                                                                                                     | `[]`   |
| `global.storageClass`                                 | Global StorageClass for Persistent Volume(s)                                                                                                                                                                                                                                                                                                                        | `""`   |
| `global.compatibility.openshift.adaptSecurityContext` | Adapt the securityContext sections of the deployment to make them compatible with Openshift restricted-v2 SCC: remove runAsUser, runAsGroup and fsGroup and let the platform use their allowed default IDs. Possible values: auto (apply if the detected running cluster is Openshift), force (perform the adaptation always), disabled (do not perform adaptation) | `auto` |

### Common parameters

| Name                     | Description                                                                             | Value          |
| ------------------------ | --------------------------------------------------------------------------------------- | -------------- |
| `kubeVersion`            | Override Kubernetes version                                                             | `""`           |
| `nameOverride`           | String to partially override common.names.fullname                                      | `""`           |
| `fullnameOverride`       | String to fully override common.names.fullname                                          | `""`           |
| `commonLabels`           | Labels to add to all deployed objects                                                   | `{}`           |
| `commonAnnotations`      | Annotations to add to all deployed objects                                              | `{}`           |
| `extraDeploy`            | Array of extra objects to deploy with the release                                       | `[]`           |
| `enableIPv6`             | Enable IPv6 configuration                                                               | `false`        |
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden) | `false`        |
| `diagnosticMode.command` | Command to override all containers in the deployment                                    | `["sleep"]`    |
| `diagnosticMode.args`    | Args to override all containers in the deployment                                       | `["infinity"]` |

### Traffic Exposure Parameters

| Name                       | Description                                                                                                                      | Value                    |
| -------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `ingress.enabled`          | Enable ingress record generation for Kubeapps                                                                                    | `false`                  |
| `ingress.apiVersion`       | Force Ingress API version (automatically detected if not set)                                                                    | `""`                     |
| `ingress.hostname`         | Default host for the ingress record                                                                                              | `kubeapps.local`         |
| `ingress.path`             | Default path for the ingress record                                                                                              | `/`                      |
| `ingress.pathType`         | Ingress path type                                                                                                                | `ImplementationSpecific` |
| `ingress.annotations`      | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                     |
| `ingress.tls`              | Enable TLS configuration for the host defined at `ingress.hostname` parameter                                                    | `false`                  |
| `ingress.selfSigned`       | Create a TLS secret for this ingress record using self-signed certificates generated by Helm                                     | `false`                  |
| `ingress.extraHosts`       | An array with additional hostname(s) to be covered with the ingress record                                                       | `[]`                     |
| `ingress.extraPaths`       | An array with additional arbitrary paths that may need to be added to the ingress under the main host                            | `[]`                     |
| `ingress.extraTls`         | TLS configuration for additional hostname(s) to be covered with this ingress record                                              | `[]`                     |
| `ingress.secrets`          | Custom TLS certificates as secrets                                                                                               | `[]`                     |
| `ingress.ingressClassName` | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                    | `""`                     |
| `ingress.extraRules`       | Additional rules to be covered with this ingress record                                                                          | `[]`                     |

### Kubeapps packaging options

| Name                       | Description                                                | Value   |
| -------------------------- | ---------------------------------------------------------- | ------- |
| `packaging.helm.enabled`   | Enable the standard Helm packaging.                        | `true`  |
| `packaging.carvel.enabled` | Enable support for the Carvel (kapp-controller) packaging. | `false` |
| `packaging.flux.enabled`   | Enable support for Flux (v2) packaging.                    | `false` |

### Frontend parameters

| Name                                                         | Description                                                                                                                                                                                                                         | Value                   |
| ------------------------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------- |
| `frontend.image.registry`                                    | NGINX image registry                                                                                                                                                                                                                | `REGISTRY_NAME`         |
| `frontend.image.repository`                                  | NGINX image repository                                                                                                                                                                                                              | `REPOSITORY_NAME/nginx` |
| `frontend.image.digest`                                      | NGINX image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                               | `""`                    |
| `frontend.image.pullPolicy`                                  | NGINX image pull policy                                                                                                                                                                                                             | `IfNotPresent`          |
| `frontend.image.pullSecrets`                                 | NGINX image pull secrets                                                                                                                                                                                                            | `[]`                    |
| `frontend.image.debug`                                       | Enable image debug mode                                                                                                                                                                                                             | `false`                 |
| `frontend.proxypassAccessTokenAsBearer`                      | Use access_token as the Bearer when talking to the k8s api server                                                                                                                                                                   | `false`                 |
| `frontend.proxypassExtraSetHeader`                           | Set an additional proxy header for all requests proxied via NGINX                                                                                                                                                                   | `""`                    |
| `frontend.largeClientHeaderBuffers`                          | Set large_client_header_buffers in NGINX config                                                                                                                                                                                     | `4 32k`                 |
| `frontend.replicaCount`                                      | Number of frontend replicas to deploy                                                                                                                                                                                               | `2`                     |
| `frontend.updateStrategy.type`                               | Frontend deployment strategy type.                                                                                                                                                                                                  | `RollingUpdate`         |
| `frontend.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if frontend.resources is set (frontend.resources is recommended for production). | `micro`                 |
| `frontend.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                   | `{}`                    |
| `frontend.extraEnvVars`                                      | Array with extra environment variables to add to the NGINX container                                                                                                                                                                | `[]`                    |
| `frontend.extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for the NGINX container                                                                                                                                                        | `""`                    |
| `frontend.extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for the NGINX container                                                                                                                                                           | `""`                    |
| `frontend.containerPorts.http`                               | NGINX HTTP container port                                                                                                                                                                                                           | `8080`                  |
| `frontend.podSecurityContext.enabled`                        | Enabled frontend pods' Security Context                                                                                                                                                                                             | `true`                  |
| `frontend.podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                                  | `Always`                |
| `frontend.podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                                      | `[]`                    |
| `frontend.podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                                         | `[]`                    |
| `frontend.podSecurityContext.fsGroup`                        | Set frontend pod's Security Context fsGroup                                                                                                                                                                                         | `1001`                  |
| `frontend.containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                                                                                                                                                | `true`                  |
| `frontend.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                                    | `nil`                   |
| `frontend.containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                                                                                                                          | `1001`                  |
| `frontend.containerSecurityContext.runAsGroup`               | Set containers' Security Context runAsGroup                                                                                                                                                                                         | `1001`                  |
| `frontend.containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                                                                                                                                       | `true`                  |
| `frontend.containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                                                                                                                                         | `false`                 |
| `frontend.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                                             | `true`                  |
| `frontend.containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                                                                                                                           | `false`                 |
| `frontend.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                                  | `["ALL"]`               |
| `frontend.containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                                    | `RuntimeDefault`        |
| `frontend.livenessProbe.enabled`                             | Enable livenessProbe                                                                                                                                                                                                                | `true`                  |
| `frontend.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                                             | `60`                    |
| `frontend.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                                    | `10`                    |
| `frontend.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                                   | `5`                     |
| `frontend.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                                                 | `6`                     |
| `frontend.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                                                 | `1`                     |
| `frontend.readinessProbe.enabled`                            | Enable readinessProbe                                                                                                                                                                                                               | `true`                  |
| `frontend.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                                            | `0`                     |
| `frontend.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                                   | `10`                    |
| `frontend.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                                  | `5`                     |
| `frontend.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                                                | `6`                     |
| `frontend.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                                                | `1`                     |
| `frontend.startupProbe.enabled`                              | Enable startupProbe                                                                                                                                                                                                                 | `false`                 |
| `frontend.startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                                              | `0`                     |
| `frontend.startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                                     | `10`                    |
| `frontend.startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                                    | `5`                     |
| `frontend.startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                                  | `6`                     |
| `frontend.startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                                  | `1`                     |
| `frontend.customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                                                                                                                                 | `{}`                    |
| `frontend.customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                                                                                                                                                | `{}`                    |
| `frontend.customStartupProbe`                                | Custom startupProbe that overrides the default one                                                                                                                                                                                  | `{}`                    |
| `frontend.lifecycleHooks`                                    | Custom lifecycle hooks for frontend containers                                                                                                                                                                                      | `{}`                    |
| `frontend.command`                                           | Override default container command (useful when using custom images)                                                                                                                                                                | `[]`                    |
| `frontend.args`                                              | Override default container args (useful when using custom images)                                                                                                                                                                   | `[]`                    |
| `frontend.podLabels`                                         | Extra labels for frontend pods                                                                                                                                                                                                      | `{}`                    |
| `frontend.podAnnotations`                                    | Annotations for frontend pods                                                                                                                                                                                                       | `{}`                    |
| `frontend.podAffinityPreset`                                 | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                                 | `""`                    |
| `frontend.podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                            | `soft`                  |
| `frontend.nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                           | `""`                    |
| `frontend.nodeAffinityPreset.key`                            | Node label key to match. Ignored if `affinity` is set                                                                                                                                                                               | `""`                    |
| `frontend.nodeAffinityPreset.values`                         | Node label values to match. Ignored if `affinity` is set                                                                                                                                                                            | `[]`                    |
| `frontend.affinity`                                          | Affinity for pod assignment                                                                                                                                                                                                         | `{}`                    |
| `frontend.nodeSelector`                                      | Node labels for pod assignment                                                                                                                                                                                                      | `{}`                    |
| `frontend.tolerations`                                       | Tolerations for pod assignment                                                                                                                                                                                                      | `[]`                    |
| `frontend.priorityClassName`                                 | Priority class name for frontend pods                                                                                                                                                                                               | `""`                    |
| `frontend.schedulerName`                                     | Name of the k8s scheduler (other than default)                                                                                                                                                                                      | `""`                    |
| `frontend.topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment                                                                                                                                                                                      | `[]`                    |
| `frontend.automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                                  | `true`                  |
| `frontend.hostAliases`                                       | Custom host aliases for frontend pods                                                                                                                                                                                               | `[]`                    |
| `frontend.extraVolumes`                                      | Optionally specify extra list of additional volumes for frontend pods                                                                                                                                                               | `[]`                    |
| `frontend.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for frontend container(s)                                                                                                                                                  | `[]`                    |
| `frontend.sidecars`                                          | Add additional sidecar containers to the frontend pod                                                                                                                                                                               | `[]`                    |
| `frontend.initContainers`                                    | Add additional init containers to the frontend pods                                                                                                                                                                                 | `[]`                    |
| `frontend.pdb.create`                                        | Enable/disable a Pod Disruption Budget creation                                                                                                                                                                                     | `false`                 |
| `frontend.pdb.minAvailable`                                  | Minimum number/percentage of pods that should remain scheduled                                                                                                                                                                      | `""`                    |
| `frontend.pdb.maxUnavailable`                                | Maximum number/percentage of pods that may be made unavailable. Defaults to `1` if both `frontend.pdb.minAvailable` and `frontend.pdb.maxUnavailable` are empty.                                                                    | `""`                    |
| `frontend.service.type`                                      | Frontend service type                                                                                                                                                                                                               | `ClusterIP`             |
| `frontend.service.ports.http`                                | Frontend service HTTP port                                                                                                                                                                                                          | `80`                    |
| `frontend.service.nodePorts.http`                            | Node port for HTTP                                                                                                                                                                                                                  | `""`                    |
| `frontend.service.clusterIP`                                 | Frontend service Cluster IP                                                                                                                                                                                                         | `""`                    |
| `frontend.service.loadBalancerIP`                            | Frontend service Load Balancer IP                                                                                                                                                                                                   | `""`                    |
| `frontend.service.loadBalancerSourceRanges`                  | Frontend service Load Balancer sources                                                                                                                                                                                              | `[]`                    |
| `frontend.service.externalTrafficPolicy`                     | Frontend service external traffic policy                                                                                                                                                                                            | `Cluster`               |
| `frontend.service.extraPorts`                                | Extra ports to expose (normally used with the `sidecar` value)                                                                                                                                                                      | `[]`                    |
| `frontend.service.annotations`                               | Additional custom annotations for frontend service                                                                                                                                                                                  | `{}`                    |
| `frontend.service.sessionAffinity`                           | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                                                                                                                                                                | `None`                  |
| `frontend.service.sessionAffinityConfig`                     | Additional settings for the sessionAffinity                                                                                                                                                                                         | `{}`                    |
| `frontend.networkPolicy.enabled`                             | Specifies whether a NetworkPolicy should be created                                                                                                                                                                                 | `true`                  |
| `frontend.networkPolicy.allowExternal`                       | Don't require server label for connections                                                                                                                                                                                          | `true`                  |
| `frontend.networkPolicy.allowExternalEgress`                 | Allow the pod to access any range of port and all destinations.                                                                                                                                                                     | `true`                  |
| `frontend.networkPolicy.kubeAPIServerPorts`                  | List of possible endpoints to kube-apiserver (limit to your cluster settings to increase security)                                                                                                                                  | `[]`                    |
| `frontend.networkPolicy.extraIngress`                        | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                                        | `[]`                    |
| `frontend.networkPolicy.extraEgress`                         | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                                        | `[]`                    |
| `frontend.networkPolicy.ingressNSMatchLabels`                | Labels to match to allow traffic from other namespaces                                                                                                                                                                              | `{}`                    |
| `frontend.networkPolicy.ingressNSPodMatchLabels`             | Pod labels to match to allow traffic from other namespaces                                                                                                                                                                          | `{}`                    |

### Dashboard parameters

| Name                                                          | Description                                                                                                                                                                                                                           | Value                                |
| ------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------ |
| `dashboard.enabled`                                           | Specifies whether Kubeapps Dashboard should be deployed or not                                                                                                                                                                        | `true`                               |
| `dashboard.image.registry`                                    | Dashboard image registry                                                                                                                                                                                                              | `REGISTRY_NAME`                      |
| `dashboard.image.repository`                                  | Dashboard image repository                                                                                                                                                                                                            | `REPOSITORY_NAME/kubeapps-dashboard` |
| `dashboard.image.digest`                                      | Dashboard image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                             | `""`                                 |
| `dashboard.image.pullPolicy`                                  | Dashboard image pull policy                                                                                                                                                                                                           | `IfNotPresent`                       |
| `dashboard.image.pullSecrets`                                 | Dashboard image pull secrets                                                                                                                                                                                                          | `[]`                                 |
| `dashboard.image.debug`                                       | Enable image debug mode                                                                                                                                                                                                               | `false`                              |
| `dashboard.customStyle`                                       | Custom CSS injected to the Dashboard to customize Kubeapps look and feel                                                                                                                                                              | `""`                                 |
| `dashboard.customAppViews`                                    | Package names to signal a custom app view                                                                                                                                                                                             | `[]`                                 |
| `dashboard.customComponents`                                  | Custom Form components injected into the BasicDeploymentForm                                                                                                                                                                          | `""`                                 |
| `dashboard.remoteComponentsUrl`                               | Remote URL that can be used to load custom components vs loading from the local filesystem                                                                                                                                            | `""`                                 |
| `dashboard.skipAvailablePackageDetails`                       | Skip the package details view and go straight to the installation view of the latest version                                                                                                                                          | `false`                              |
| `dashboard.customLocale`                                      | Custom translations injected to the Dashboard to customize the strings used in Kubeapps                                                                                                                                               | `""`                                 |
| `dashboard.defaultTheme`                                      | Default theme used in the Dashboard if the user has not selected any theme yet.                                                                                                                                                       | `""`                                 |
| `dashboard.replicaCount`                                      | Number of Dashboard replicas to deploy                                                                                                                                                                                                | `2`                                  |
| `dashboard.createNamespaceLabels`                             | Labels added to newly created namespaces                                                                                                                                                                                              | `{}`                                 |
| `dashboard.updateStrategy.type`                               | Dashboard deployment strategy type.                                                                                                                                                                                                   | `RollingUpdate`                      |
| `dashboard.extraEnvVars`                                      | Array with extra environment variables to add to the Dashboard container                                                                                                                                                              | `[]`                                 |
| `dashboard.extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for the Dashboard container                                                                                                                                                      | `""`                                 |
| `dashboard.extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for the Dashboard container                                                                                                                                                         | `""`                                 |
| `dashboard.containerPorts.http`                               | Dashboard HTTP container port                                                                                                                                                                                                         | `8080`                               |
| `dashboard.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if dashboard.resources is set (dashboard.resources is recommended for production). | `micro`                              |
| `dashboard.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                     | `{}`                                 |
| `dashboard.podSecurityContext.enabled`                        | Enabled Dashboard pods' Security Context                                                                                                                                                                                              | `true`                               |
| `dashboard.podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                                    | `Always`                             |
| `dashboard.podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                                        | `[]`                                 |
| `dashboard.podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                                           | `[]`                                 |
| `dashboard.podSecurityContext.fsGroup`                        | Set Dashboard pod's Security Context fsGroup                                                                                                                                                                                          | `1001`                               |
| `dashboard.containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                                                                                                                                                  | `true`                               |
| `dashboard.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                                      | `nil`                                |
| `dashboard.containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                                                                                                                            | `1001`                               |
| `dashboard.containerSecurityContext.runAsGroup`               | Set containers' Security Context runAsGroup                                                                                                                                                                                           | `1001`                               |
| `dashboard.containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                                                                                                                                         | `true`                               |
| `dashboard.containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                                                                                                                                           | `false`                              |
| `dashboard.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                                               | `true`                               |
| `dashboard.containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                                                                                                                             | `false`                              |
| `dashboard.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                                    | `["ALL"]`                            |
| `dashboard.containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                                      | `RuntimeDefault`                     |
| `dashboard.livenessProbe.enabled`                             | Enable livenessProbe                                                                                                                                                                                                                  | `true`                               |
| `dashboard.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                                               | `60`                                 |
| `dashboard.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                                      | `10`                                 |
| `dashboard.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                                     | `5`                                  |
| `dashboard.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                                                   | `6`                                  |
| `dashboard.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                                                   | `1`                                  |
| `dashboard.readinessProbe.enabled`                            | Enable readinessProbe                                                                                                                                                                                                                 | `true`                               |
| `dashboard.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                                              | `0`                                  |
| `dashboard.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                                     | `10`                                 |
| `dashboard.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                                    | `5`                                  |
| `dashboard.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                                                  | `6`                                  |
| `dashboard.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                                                  | `1`                                  |
| `dashboard.startupProbe.enabled`                              | Enable startupProbe                                                                                                                                                                                                                   | `true`                               |
| `dashboard.startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                                                | `0`                                  |
| `dashboard.startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                                       | `10`                                 |
| `dashboard.startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                                      | `5`                                  |
| `dashboard.startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                                    | `6`                                  |
| `dashboard.startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                                    | `1`                                  |
| `dashboard.customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                                                                                                                                   | `{}`                                 |
| `dashboard.customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                                                                                                                                                  | `{}`                                 |
| `dashboard.customStartupProbe`                                | Custom startupProbe that overrides the default one                                                                                                                                                                                    | `{}`                                 |
| `dashboard.lifecycleHooks`                                    | Custom lifecycle hooks for Dashboard containers                                                                                                                                                                                       | `{}`                                 |
| `dashboard.command`                                           | Override default container command (useful when using custom images)                                                                                                                                                                  | `[]`                                 |
| `dashboard.args`                                              | Override default container args (useful when using custom images)                                                                                                                                                                     | `[]`                                 |
| `dashboard.podLabels`                                         | Extra labels for Dashboard pods                                                                                                                                                                                                       | `{}`                                 |
| `dashboard.podAnnotations`                                    | Annotations for Dashboard pods                                                                                                                                                                                                        | `{}`                                 |
| `dashboard.podAffinityPreset`                                 | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                                   | `""`                                 |
| `dashboard.podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                              | `soft`                               |
| `dashboard.nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                             | `""`                                 |
| `dashboard.nodeAffinityPreset.key`                            | Node label key to match. Ignored if `affinity` is set                                                                                                                                                                                 | `""`                                 |
| `dashboard.nodeAffinityPreset.values`                         | Node label values to match. Ignored if `affinity` is set                                                                                                                                                                              | `[]`                                 |
| `dashboard.affinity`                                          | Affinity for pod assignment                                                                                                                                                                                                           | `{}`                                 |
| `dashboard.nodeSelector`                                      | Node labels for pod assignment                                                                                                                                                                                                        | `{}`                                 |
| `dashboard.tolerations`                                       | Tolerations for pod assignment                                                                                                                                                                                                        | `[]`                                 |
| `dashboard.priorityClassName`                                 | Priority class name for Dashboard pods                                                                                                                                                                                                | `""`                                 |
| `dashboard.schedulerName`                                     | Name of the k8s scheduler (other than default)                                                                                                                                                                                        | `""`                                 |
| `dashboard.topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment                                                                                                                                                                                        | `[]`                                 |
| `dashboard.automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                                    | `true`                               |
| `dashboard.hostAliases`                                       | Custom host aliases for Dashboard pods                                                                                                                                                                                                | `[]`                                 |
| `dashboard.extraVolumes`                                      | Optionally specify extra list of additional volumes for Dashboard pods                                                                                                                                                                | `[]`                                 |
| `dashboard.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for Dashboard container(s)                                                                                                                                                   | `[]`                                 |
| `dashboard.sidecars`                                          | Add additional sidecar containers to the Dashboard pod                                                                                                                                                                                | `[]`                                 |
| `dashboard.initContainers`                                    | Add additional init containers to the Dashboard pods                                                                                                                                                                                  | `[]`                                 |
| `dashboard.pdb.create`                                        | Enable/disable a Pod Disruption Budget creation                                                                                                                                                                                       | `false`                              |
| `dashboard.pdb.minAvailable`                                  | Minimum number/percentage of pods that should remain scheduled                                                                                                                                                                        | `""`                                 |
| `dashboard.pdb.maxUnavailable`                                | Maximum number/percentage of pods that may be made unavailable. Defaults to `1` if both `dashboard.pdb.minAvailable` and `dashboard.pdb.maxUnavailable` are empty.                                                                    | `""`                                 |
| `dashboard.service.ports.http`                                | Dashboard service HTTP port                                                                                                                                                                                                           | `8080`                               |
| `dashboard.service.annotations`                               | Additional custom annotations for Dashboard service                                                                                                                                                                                   | `{}`                                 |
| `dashboard.networkPolicy.enabled`                             | Specifies whether a NetworkPolicy should be created                                                                                                                                                                                   | `true`                               |
| `dashboard.networkPolicy.allowExternal`                       | Don't require server label for connections                                                                                                                                                                                            | `true`                               |
| `dashboard.networkPolicy.allowExternalEgress`                 | Allow the pod to access any range of port and all destinations.                                                                                                                                                                       | `true`                               |
| `dashboard.networkPolicy.kubeAPIServerPorts`                  | List of possible endpoints to kube-apiserver (limit to your cluster settings to increase security)                                                                                                                                    | `[]`                                 |
| `dashboard.networkPolicy.extraIngress`                        | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                                          | `[]`                                 |
| `dashboard.networkPolicy.extraEgress`                         | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                                          | `[]`                                 |
| `dashboard.networkPolicy.ingressNSMatchLabels`                | Labels to match to allow traffic from other namespaces                                                                                                                                                                                | `{}`                                 |
| `dashboard.networkPolicy.ingressNSPodMatchLabels`             | Pod labels to match to allow traffic from other namespaces                                                                                                                                                                            | `{}`                                 |

### AppRepository Controller parameters

| Name                                                              | Description                                                                                                                                                                                                                                   | Value                                               |
| ----------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------- |
| `apprepository.image.registry`                                    | Kubeapps AppRepository Controller image registry                                                                                                                                                                                              | `REGISTRY_NAME`                                     |
| `apprepository.image.repository`                                  | Kubeapps AppRepository Controller image repository                                                                                                                                                                                            | `REPOSITORY_NAME/kubeapps-apprepository-controller` |
| `apprepository.image.digest`                                      | Kubeapps AppRepository Controller image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                             | `""`                                                |
| `apprepository.image.pullPolicy`                                  | Kubeapps AppRepository Controller image pull policy                                                                                                                                                                                           | `IfNotPresent`                                      |
| `apprepository.image.pullSecrets`                                 | Kubeapps AppRepository Controller image pull secrets                                                                                                                                                                                          | `[]`                                                |
| `apprepository.syncImage.registry`                                | Kubeapps Asset Syncer image registry                                                                                                                                                                                                          | `REGISTRY_NAME`                                     |
| `apprepository.syncImage.repository`                              | Kubeapps Asset Syncer image repository                                                                                                                                                                                                        | `REPOSITORY_NAME/kubeapps-asset-syncer`             |
| `apprepository.syncImage.digest`                                  | Kubeapps Asset Syncer image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                         | `""`                                                |
| `apprepository.syncImage.pullPolicy`                              | Kubeapps Asset Syncer image pull policy                                                                                                                                                                                                       | `IfNotPresent`                                      |
| `apprepository.syncImage.pullSecrets`                             | Kubeapps Asset Syncer image pull secrets                                                                                                                                                                                                      | `[]`                                                |
| `apprepository.globalReposNamespaceSuffix`                        | Suffix for the namespace of global repos in the Helm plugin. Defaults to empty for backwards compatibility. Ignored if kubeappsapis.pluginConfig.helm.packages.v1alpha1.globalPackagingNamespace is set.                                      | `""`                                                |
| `apprepository.initialRepos`                                      | Initial chart repositories to configure                                                                                                                                                                                                       | `[]`                                                |
| `apprepository.customAnnotations`                                 | Custom annotations be added to each AppRepository-generated CronJob, Job and Pod                                                                                                                                                              | `{}`                                                |
| `apprepository.customLabels`                                      | Custom labels be added to each AppRepository-generated CronJob, Job and Pod                                                                                                                                                                   | `{}`                                                |
| `apprepository.initialReposProxy.enabled`                         | Enables the proxy                                                                                                                                                                                                                             | `false`                                             |
| `apprepository.initialReposProxy.httpProxy`                       | URL for the http proxy                                                                                                                                                                                                                        | `""`                                                |
| `apprepository.initialReposProxy.httpsProxy`                      | URL for the https proxy                                                                                                                                                                                                                       | `""`                                                |
| `apprepository.initialReposProxy.noProxy`                         | URL to exclude from using the proxy                                                                                                                                                                                                           | `""`                                                |
| `apprepository.crontab`                                           | Default schedule for syncing App repositories (defaults to every 10 minutes)                                                                                                                                                                  | `""`                                                |
| `apprepository.watchAllNamespaces`                                | Watch all namespaces to support separate AppRepositories per namespace                                                                                                                                                                        | `true`                                              |
| `apprepository.extraFlags`                                        | Additional command line flags for AppRepository Controller                                                                                                                                                                                    | `[]`                                                |
| `apprepository.replicaCount`                                      | Number of AppRepository Controller replicas to deploy                                                                                                                                                                                         | `1`                                                 |
| `apprepository.updateStrategy.type`                               | AppRepository Controller deployment strategy type.                                                                                                                                                                                            | `RollingUpdate`                                     |
| `apprepository.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if apprepository.resources is set (apprepository.resources is recommended for production). | `micro`                                             |
| `apprepository.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                             | `{}`                                                |
| `apprepository.podSecurityContext.enabled`                        | Enabled AppRepository Controller pods' Security Context                                                                                                                                                                                       | `true`                                              |
| `apprepository.podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                                            | `Always`                                            |
| `apprepository.podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                                                | `[]`                                                |
| `apprepository.podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                                                   | `[]`                                                |
| `apprepository.podSecurityContext.fsGroup`                        | Set AppRepository Controller pod's Security Context fsGroup                                                                                                                                                                                   | `1001`                                              |
| `apprepository.containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                                                                                                                                                          | `true`                                              |
| `apprepository.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                                              | `nil`                                               |
| `apprepository.containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                                                                                                                                    | `1001`                                              |
| `apprepository.containerSecurityContext.runAsGroup`               | Set containers' Security Context runAsGroup                                                                                                                                                                                                   | `1001`                                              |
| `apprepository.containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                                                                                                                                                 | `true`                                              |
| `apprepository.containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                                                                                                                                                   | `false`                                             |
| `apprepository.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                                                       | `true`                                              |
| `apprepository.containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                                                                                                                                     | `false`                                             |
| `apprepository.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                                            | `["ALL"]`                                           |
| `apprepository.containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                                              | `RuntimeDefault`                                    |
| `apprepository.lifecycleHooks`                                    | Custom lifecycle hooks for AppRepository Controller containers                                                                                                                                                                                | `{}`                                                |
| `apprepository.command`                                           | Override default container command (useful when using custom images)                                                                                                                                                                          | `[]`                                                |
| `apprepository.args`                                              | Override default container args (useful when using custom images)                                                                                                                                                                             | `[]`                                                |
| `apprepository.extraEnvVars`                                      | Array with extra environment variables to add to AppRepository Controller pod(s)                                                                                                                                                              | `[]`                                                |
| `apprepository.extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for AppRepository Controller pod(s)                                                                                                                                                      | `""`                                                |
| `apprepository.extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for AppRepository Controller pod(s)                                                                                                                                                         | `""`                                                |
| `apprepository.extraVolumes`                                      | Optionally specify extra list of additional volumes for the AppRepository Controller pod(s)                                                                                                                                                   | `[]`                                                |
| `apprepository.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the AppRepository Controller container(s)                                                                                                                                        | `[]`                                                |
| `apprepository.podLabels`                                         | Extra labels for AppRepository Controller pods                                                                                                                                                                                                | `{}`                                                |
| `apprepository.podAnnotations`                                    | Annotations for AppRepository Controller pods                                                                                                                                                                                                 | `{}`                                                |
| `apprepository.podAffinityPreset`                                 | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                                           | `""`                                                |
| `apprepository.podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                                      | `soft`                                              |
| `apprepository.nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                                     | `""`                                                |
| `apprepository.nodeAffinityPreset.key`                            | Node label key to match. Ignored if `affinity` is set                                                                                                                                                                                         | `""`                                                |
| `apprepository.nodeAffinityPreset.values`                         | Node label values to match. Ignored if `affinity` is set                                                                                                                                                                                      | `[]`                                                |
| `apprepository.affinity`                                          | Affinity for pod assignment                                                                                                                                                                                                                   | `{}`                                                |
| `apprepository.nodeSelector`                                      | Node labels for pod assignment                                                                                                                                                                                                                | `{}`                                                |
| `apprepository.tolerations`                                       | Tolerations for pod assignment                                                                                                                                                                                                                | `[]`                                                |
| `apprepository.priorityClassName`                                 | Priority class name for AppRepository Controller pods                                                                                                                                                                                         | `""`                                                |
| `apprepository.schedulerName`                                     | Name of the k8s scheduler (other than default)                                                                                                                                                                                                | `""`                                                |
| `apprepository.topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment                                                                                                                                                                                                | `[]`                                                |
| `apprepository.automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                                            | `true`                                              |
| `apprepository.hostAliases`                                       | Custom host aliases for AppRepository Controller pods                                                                                                                                                                                         | `[]`                                                |
| `apprepository.sidecars`                                          | Add additional sidecar containers to the AppRepository Controller pod(s)                                                                                                                                                                      | `[]`                                                |
| `apprepository.initContainers`                                    | Add additional init containers to the AppRepository Controller pod(s)                                                                                                                                                                         | `[]`                                                |
| `apprepository.pdb.create`                                        | Enable/disable a Pod Disruption Budget creation                                                                                                                                                                                               | `false`                                             |
| `apprepository.pdb.minAvailable`                                  | Minimum number/percentage of pods that should remain scheduled                                                                                                                                                                                | `""`                                                |
| `apprepository.pdb.maxUnavailable`                                | Maximum number/percentage of pods that may be made unavailable. Defaults to `1` if both `apprepository.pdb.minAvailable` and `apprepository.pdb.maxUnavailable` are empty.                                                                    | `""`                                                |
| `apprepository.networkPolicy.enabled`                             | Specifies whether a NetworkPolicy should be created                                                                                                                                                                                           | `true`                                              |
| `apprepository.networkPolicy.allowExternalEgress`                 | Allow the pod to access any range of port and all destinations.                                                                                                                                                                               | `true`                                              |
| `apprepository.networkPolicy.kubeAPIServerPorts`                  | List of possible endpoints to kube-apiserver (limit to your cluster settings to increase security)                                                                                                                                            | `[]`                                                |
| `apprepository.networkPolicy.extraIngress`                        | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                                                  | `[]`                                                |
| `apprepository.networkPolicy.extraEgress`                         | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                                                  | `[]`                                                |
| `apprepository.serviceAccount.create`                             | Specifies whether a ServiceAccount should be created                                                                                                                                                                                          | `true`                                              |
| `apprepository.serviceAccount.name`                               | Name of the service account to use. If not set and create is true, a name is generated using the fullname template.                                                                                                                           | `""`                                                |
| `apprepository.serviceAccount.automountServiceAccountToken`       | Automount service account token for the server service account                                                                                                                                                                                | `false`                                             |
| `apprepository.serviceAccount.annotations`                        | Annotations for service account. Evaluated as a template. Only used if `create` is `true`.                                                                                                                                                    | `{}`                                                |

### Auth Proxy parameters

| Name                                                          | Description                                                                                                                                                                                                                           | Value                          |
| ------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------ |
| `authProxy.enabled`                                           | Specifies whether Kubeapps should configure OAuth login/logout                                                                                                                                                                        | `false`                        |
| `authProxy.image.registry`                                    | OAuth2 Proxy image registry                                                                                                                                                                                                           | `REGISTRY_NAME`                |
| `authProxy.image.repository`                                  | OAuth2 Proxy image repository                                                                                                                                                                                                         | `REPOSITORY_NAME/oauth2-proxy` |
| `authProxy.image.digest`                                      | OAuth2 Proxy image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                          | `""`                           |
| `authProxy.image.pullPolicy`                                  | OAuth2 Proxy image pull policy                                                                                                                                                                                                        | `IfNotPresent`                 |
| `authProxy.image.pullSecrets`                                 | OAuth2 Proxy image pull secrets                                                                                                                                                                                                       | `[]`                           |
| `authProxy.external`                                          | Use an external Auth Proxy instead of deploying its own one                                                                                                                                                                           | `false`                        |
| `authProxy.oauthLoginURI`                                     | OAuth Login URI to which the Kubeapps frontend redirects for authn                                                                                                                                                                    | `/oauth2/start`                |
| `authProxy.oauthLogoutURI`                                    | OAuth Logout URI to which the Kubeapps frontend redirects for authn                                                                                                                                                                   | `/oauth2/sign_out`             |
| `authProxy.skipKubeappsLoginPage`                             | Skip the Kubeapps login page when using OIDC and directly redirect to the IdP                                                                                                                                                         | `false`                        |
| `authProxy.provider`                                          | OAuth provider                                                                                                                                                                                                                        | `""`                           |
| `authProxy.clientID`                                          | OAuth Client ID                                                                                                                                                                                                                       | `""`                           |
| `authProxy.clientSecret`                                      | OAuth Client secret                                                                                                                                                                                                                   | `""`                           |
| `authProxy.cookieSecret`                                      | Secret used by oauth2-proxy to encrypt any credentials                                                                                                                                                                                | `""`                           |
| `authProxy.existingOauth2Secret`                              | Name of an existing secret containing the OAuth client secrets, it should contain the keys clientID, clientSecret, and cookieSecret                                                                                                   | `""`                           |
| `authProxy.cookieRefresh`                                     | Duration after which to refresh the cookie                                                                                                                                                                                            | `2m`                           |
| `authProxy.scope`                                             | OAuth scope specification                                                                                                                                                                                                             | `openid email groups`          |
| `authProxy.emailDomain`                                       | Allowed email domains                                                                                                                                                                                                                 | `*`                            |
| `authProxy.extraFlags`                                        | Additional command line flags for oauth2-proxy                                                                                                                                                                                        | `[]`                           |
| `authProxy.lifecycleHooks`                                    | for the Auth Proxy container(s) to automate configuration before or after startup                                                                                                                                                     | `{}`                           |
| `authProxy.command`                                           | Override default container command (useful when using custom images)                                                                                                                                                                  | `[]`                           |
| `authProxy.args`                                              | Override default container args (useful when using custom images)                                                                                                                                                                     | `[]`                           |
| `authProxy.extraEnvVars`                                      | Array with extra environment variables to add to the Auth Proxy container                                                                                                                                                             | `[]`                           |
| `authProxy.extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for Auth Proxy containers(s)                                                                                                                                                     | `""`                           |
| `authProxy.extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for Auth Proxy containers(s)                                                                                                                                                        | `""`                           |
| `authProxy.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the Auth Proxy container(s)                                                                                                                                              | `[]`                           |
| `authProxy.containerPorts.proxy`                              | Auth Proxy HTTP container port                                                                                                                                                                                                        | `3000`                         |
| `authProxy.containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                                                                                                                                                  | `true`                         |
| `authProxy.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                                      | `nil`                          |
| `authProxy.containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                                                                                                                            | `1001`                         |
| `authProxy.containerSecurityContext.runAsGroup`               | Set containers' Security Context runAsGroup                                                                                                                                                                                           | `1001`                         |
| `authProxy.containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                                                                                                                                         | `true`                         |
| `authProxy.containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                                                                                                                                           | `false`                        |
| `authProxy.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                                               | `true`                         |
| `authProxy.containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                                                                                                                             | `false`                        |
| `authProxy.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                                    | `["ALL"]`                      |
| `authProxy.containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                                      | `RuntimeDefault`               |
| `authProxy.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if authProxy.resources is set (authProxy.resources is recommended for production). | `micro`                        |
| `authProxy.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                     | `{}`                           |

### Pinniped Proxy parameters

| Name                                                              | Description                                                                                                                                                                                                                                   | Value                                     |
| ----------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------- |
| `pinnipedProxy.enabled`                                           | Specifies whether Kubeapps should configure Pinniped Proxy                                                                                                                                                                                    | `false`                                   |
| `pinnipedProxy.image.registry`                                    | Pinniped Proxy image registry                                                                                                                                                                                                                 | `REGISTRY_NAME`                           |
| `pinnipedProxy.image.repository`                                  | Pinniped Proxy image repository                                                                                                                                                                                                               | `REPOSITORY_NAME/kubeapps-pinniped-proxy` |
| `pinnipedProxy.image.digest`                                      | Pinniped Proxy image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                                | `""`                                      |
| `pinnipedProxy.image.pullPolicy`                                  | Pinniped Proxy image pull policy                                                                                                                                                                                                              | `IfNotPresent`                            |
| `pinnipedProxy.image.pullSecrets`                                 | Pinniped Proxy image pull secrets                                                                                                                                                                                                             | `[]`                                      |
| `pinnipedProxy.defaultPinnipedNamespace`                          | Namespace in which pinniped concierge is installed                                                                                                                                                                                            | `pinniped-concierge`                      |
| `pinnipedProxy.defaultAuthenticatorType`                          | Authenticator type                                                                                                                                                                                                                            | `JWTAuthenticator`                        |
| `pinnipedProxy.defaultAuthenticatorName`                          | Authenticator name                                                                                                                                                                                                                            | `jwt-authenticator`                       |
| `pinnipedProxy.defaultPinnipedAPISuffix`                          | API suffix                                                                                                                                                                                                                                    | `pinniped.dev`                            |
| `pinnipedProxy.tls.existingSecret`                                | TLS secret with which to proxy requests                                                                                                                                                                                                       | `""`                                      |
| `pinnipedProxy.tls.caCertificate`                                 | TLS CA cert config map which clients of pinniped proxy should use with TLS requests                                                                                                                                                           | `""`                                      |
| `pinnipedProxy.lifecycleHooks`                                    | For the Pinniped Proxy container(s) to automate configuration before or after startup                                                                                                                                                         | `{}`                                      |
| `pinnipedProxy.command`                                           | Override default container command (useful when using custom images)                                                                                                                                                                          | `[]`                                      |
| `pinnipedProxy.args`                                              | Override default container args (useful when using custom images)                                                                                                                                                                             | `[]`                                      |
| `pinnipedProxy.extraEnvVars`                                      | Array with extra environment variables to add to Pinniped Proxy container(s)                                                                                                                                                                  | `[]`                                      |
| `pinnipedProxy.extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for Pinniped Proxy container(s)                                                                                                                                                          | `""`                                      |
| `pinnipedProxy.extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for Pinniped Proxy container(s)                                                                                                                                                             | `""`                                      |
| `pinnipedProxy.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the Pinniped Proxy container(s)                                                                                                                                                  | `[]`                                      |
| `pinnipedProxy.containerPorts.pinnipedProxy`                      | Pinniped Proxy container port                                                                                                                                                                                                                 | `3333`                                    |
| `pinnipedProxy.containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                                                                                                                                                          | `true`                                    |
| `pinnipedProxy.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                                              | `nil`                                     |
| `pinnipedProxy.containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                                                                                                                                    | `1001`                                    |
| `pinnipedProxy.containerSecurityContext.runAsGroup`               | Set containers' Security Context runAsGroup                                                                                                                                                                                                   | `1001`                                    |
| `pinnipedProxy.containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                                                                                                                                                 | `true`                                    |
| `pinnipedProxy.containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                                                                                                                                                   | `false`                                   |
| `pinnipedProxy.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                                                       | `true`                                    |
| `pinnipedProxy.containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                                                                                                                                     | `false`                                   |
| `pinnipedProxy.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                                            | `["ALL"]`                                 |
| `pinnipedProxy.containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                                              | `RuntimeDefault`                          |
| `pinnipedProxy.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if pinnipedProxy.resources is set (pinnipedProxy.resources is recommended for production). | `micro`                                   |
| `pinnipedProxy.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                             | `{}`                                      |
| `pinnipedProxy.service.ports.pinnipedProxy`                       | Pinniped Proxy service port                                                                                                                                                                                                                   | `3333`                                    |
| `pinnipedProxy.service.annotations`                               | Additional custom annotations for Pinniped Proxy service                                                                                                                                                                                      | `{}`                                      |

### Other Parameters

| Name          | Description                                               | Value  |
| ------------- | --------------------------------------------------------- | ------ |
| `clusters`    | List of clusters that Kubeapps can target for deployments | `[]`   |
| `rbac.create` | Specifies whether RBAC resources should be created        | `true` |

### Feature flags

| Name                                    | Description                                                                                                | Value   |
| --------------------------------------- | ---------------------------------------------------------------------------------------------------------- | ------- |
| `featureFlags.apiOnly.enabled`          | Enable ingress for API operations only. Access to "/" will not be possible, so Dashboard will be unusable. | `false` |
| `featureFlags.apiOnly.grpc.annotations` | Specific annotations for the GRPC ingress in API-only mode                                                 | `{}`    |
| `featureFlags.operators`                | Enable support for Operators in Kubeapps                                                                   | `false` |
| `featureFlags.schemaEditor.enabled`     | Enable a visual editor for customizing the package schemas                                                 | `false` |

### Database Parameters

| Name                                     | Description                                                                                                                                                                                                                             | Value        |
| ---------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------ |
| `postgresql.enabled`                     | Deploy a PostgreSQL server to satisfy the applications database requirements                                                                                                                                                            | `true`       |
| `postgresql.auth.username`               | Username for PostgreSQL server                                                                                                                                                                                                          | `postgres`   |
| `postgresql.auth.postgresPassword`       | Password for 'postgres' user                                                                                                                                                                                                            | `""`         |
| `postgresql.auth.database`               | Name for a custom database to create                                                                                                                                                                                                    | `assets`     |
| `postgresql.auth.existingSecret`         | Name of existing secret to use for PostgreSQL credentials                                                                                                                                                                               | `""`         |
| `postgresql.primary.persistence.enabled` | Enable PostgreSQL Primary data persistence using PVC                                                                                                                                                                                    | `false`      |
| `postgresql.architecture`                | PostgreSQL architecture (`standalone` or `replication`)                                                                                                                                                                                 | `standalone` |
| `postgresql.securityContext.enabled`     | Enabled PostgreSQL replicas pods' Security Context                                                                                                                                                                                      | `false`      |
| `postgresql.resourcesPreset`             | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if postgresql.resources is set (postgresql.resources is recommended for production). | `micro`      |
| `postgresql.resources`                   | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                       | `{}`         |

### kubeappsapis parameters

| Name                                                                                            | Description                                                                                                                                                                                                                                 | Value                              |
| ----------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------- |
| `kubeappsapis.enabledPlugins`                                                                   | Manually override which plugins are enabled for the Kubeapps-APIs service                                                                                                                                                                   | `[]`                               |
| `kubeappsapis.pluginConfig.core.packages.v1alpha1.versionsInSummary.major`                      | Number of major versions to display in the summary                                                                                                                                                                                          | `3`                                |
| `kubeappsapis.pluginConfig.core.packages.v1alpha1.versionsInSummary.minor`                      | Number of minor versions to display in the summary                                                                                                                                                                                          | `3`                                |
| `kubeappsapis.pluginConfig.core.packages.v1alpha1.versionsInSummary.patch`                      | Number of patch versions to display in the summary                                                                                                                                                                                          | `3`                                |
| `kubeappsapis.pluginConfig.core.packages.v1alpha1.timeoutSeconds`                               | Value to wait for Kubernetes commands to complete                                                                                                                                                                                           | `300`                              |
| `kubeappsapis.pluginConfig.helm.packages.v1alpha1.globalPackagingNamespace`                     | Custom global packaging namespace. Using this value will override the current "kubeapps release namespace + suffix" pattern and will create a new namespace if not exists.                                                                  | `""`                               |
| `kubeappsapis.pluginConfig.kappController.packages.v1alpha1.defaultUpgradePolicy`               | Default upgrade policy generating version constraints                                                                                                                                                                                       | `none`                             |
| `kubeappsapis.pluginConfig.kappController.packages.v1alpha1.defaultPrereleasesVersionSelection` | Default policy for allowing prereleases containing one of the identifiers                                                                                                                                                                   | `nil`                              |
| `kubeappsapis.pluginConfig.kappController.packages.v1alpha1.defaultAllowDowngrades`             | Default policy for allowing applications to be downgraded to previous versions                                                                                                                                                              | `false`                            |
| `kubeappsapis.pluginConfig.kappController.packages.v1alpha1.globalPackagingNamespace`           | Default global packaging namespace                                                                                                                                                                                                          | `kapp-controller-packaging-global` |
| `kubeappsapis.pluginConfig.flux.packages.v1alpha1.defaultUpgradePolicy`                         | Default upgrade policy generating version constraints                                                                                                                                                                                       | `none`                             |
| `kubeappsapis.pluginConfig.flux.packages.v1alpha1.noCrossNamespaceRefs`                         | Enable this flag to disallow cross-namespace references, useful when running Flux on multi-tenant clusters                                                                                                                                  | `false`                            |
| `kubeappsapis.pluginConfig.resources.packages.v1alpha1.trustedNamespaces.headerName`            | Optional header name for trusted namespaces                                                                                                                                                                                                 | `""`                               |
| `kubeappsapis.pluginConfig.resources.packages.v1alpha1.trustedNamespaces.headerPattern`         | Optional header pattern for trusted namespaces                                                                                                                                                                                              | `""`                               |
| `kubeappsapis.image.registry`                                                                   | Kubeapps-APIs image registry                                                                                                                                                                                                                | `REGISTRY_NAME`                    |
| `kubeappsapis.image.repository`                                                                 | Kubeapps-APIs image repository                                                                                                                                                                                                              | `REPOSITORY_NAME/kubeapps-apis`    |
| `kubeappsapis.image.digest`                                                                     | Kubeapps-APIs image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                               | `""`                               |
| `kubeappsapis.image.pullPolicy`                                                                 | Kubeapps-APIs image pull policy                                                                                                                                                                                                             | `IfNotPresent`                     |
| `kubeappsapis.image.pullSecrets`                                                                | Kubeapps-APIs image pull secrets                                                                                                                                                                                                            | `[]`                               |
| `kubeappsapis.replicaCount`                                                                     | Number of frontend replicas to deploy                                                                                                                                                                                                       | `2`                                |
| `kubeappsapis.updateStrategy.type`                                                              | KubeappsAPIs deployment strategy type.                                                                                                                                                                                                      | `RollingUpdate`                    |
| `kubeappsapis.extraFlags`                                                                       | Additional command line flags for KubeappsAPIs                                                                                                                                                                                              | `[]`                               |
| `kubeappsapis.qps`                                                                              | KubeappsAPIs Kubernetes API client QPS limit                                                                                                                                                                                                | `50.0`                             |
| `kubeappsapis.burst`                                                                            | KubeappsAPIs Kubernetes API client Burst limit                                                                                                                                                                                              | `100`                              |
| `kubeappsapis.terminationGracePeriodSeconds`                                                    | The grace time period for sig term                                                                                                                                                                                                          | `300`                              |
| `kubeappsapis.extraEnvVars`                                                                     | Array with extra environment variables to add to the KubeappsAPIs container                                                                                                                                                                 | `[]`                               |
| `kubeappsapis.extraEnvVarsCM`                                                                   | Name of existing ConfigMap containing extra env vars for the KubeappsAPIs container                                                                                                                                                         | `""`                               |
| `kubeappsapis.extraEnvVarsSecret`                                                               | Name of existing Secret containing extra env vars for the KubeappsAPIs container                                                                                                                                                            | `""`                               |
| `kubeappsapis.containerPorts.http`                                                              | KubeappsAPIs HTTP container port                                                                                                                                                                                                            | `50051`                            |
| `kubeappsapis.resourcesPreset`                                                                  | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if kubeappsapis.resources is set (kubeappsapis.resources is recommended for production). | `micro`                            |
| `kubeappsapis.resources`                                                                        | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                           | `{}`                               |
| `kubeappsapis.podSecurityContext.enabled`                                                       | Enabled KubeappsAPIs pods' Security Context                                                                                                                                                                                                 | `true`                             |
| `kubeappsapis.podSecurityContext.fsGroupChangePolicy`                                           | Set filesystem group change policy                                                                                                                                                                                                          | `Always`                           |
| `kubeappsapis.podSecurityContext.sysctls`                                                       | Set kernel settings using the sysctl interface                                                                                                                                                                                              | `[]`                               |
| `kubeappsapis.podSecurityContext.supplementalGroups`                                            | Set filesystem extra groups                                                                                                                                                                                                                 | `[]`                               |
| `kubeappsapis.podSecurityContext.fsGroup`                                                       | Set KubeappsAPIs pod's Security Context fsGroup                                                                                                                                                                                             | `1001`                             |
| `kubeappsapis.containerSecurityContext.enabled`                                                 | Enabled containers' Security Context                                                                                                                                                                                                        | `true`                             |
| `kubeappsapis.containerSecurityContext.seLinuxOptions`                                          | Set SELinux options in container                                                                                                                                                                                                            | `nil`                              |
| `kubeappsapis.containerSecurityContext.runAsUser`                                               | Set containers' Security Context runAsUser                                                                                                                                                                                                  | `1001`                             |
| `kubeappsapis.containerSecurityContext.runAsGroup`                                              | Set containers' Security Context runAsGroup                                                                                                                                                                                                 | `1001`                             |
| `kubeappsapis.containerSecurityContext.runAsNonRoot`                                            | Set container's Security Context runAsNonRoot                                                                                                                                                                                               | `true`                             |
| `kubeappsapis.containerSecurityContext.privileged`                                              | Set container's Security Context privileged                                                                                                                                                                                                 | `false`                            |
| `kubeappsapis.containerSecurityContext.readOnlyRootFilesystem`                                  | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                                                     | `true`                             |
| `kubeappsapis.containerSecurityContext.allowPrivilegeEscalation`                                | Set container's Security Context allowPrivilegeEscalation                                                                                                                                                                                   | `false`                            |
| `kubeappsapis.containerSecurityContext.capabilities.drop`                                       | List of capabilities to be dropped                                                                                                                                                                                                          | `["ALL"]`                          |
| `kubeappsapis.containerSecurityContext.seccompProfile.type`                                     | Set container's Security Context seccomp profile                                                                                                                                                                                            | `RuntimeDefault`                   |
| `kubeappsapis.livenessProbe.enabled`                                                            | Enable livenessProbe                                                                                                                                                                                                                        | `true`                             |
| `kubeappsapis.livenessProbe.initialDelaySeconds`                                                | Initial delay seconds for livenessProbe                                                                                                                                                                                                     | `60`                               |
| `kubeappsapis.livenessProbe.periodSeconds`                                                      | Period seconds for livenessProbe                                                                                                                                                                                                            | `10`                               |
| `kubeappsapis.livenessProbe.timeoutSeconds`                                                     | Timeout seconds for livenessProbe                                                                                                                                                                                                           | `5`                                |
| `kubeappsapis.livenessProbe.failureThreshold`                                                   | Failure threshold for livenessProbe                                                                                                                                                                                                         | `6`                                |
| `kubeappsapis.livenessProbe.successThreshold`                                                   | Success threshold for livenessProbe                                                                                                                                                                                                         | `1`                                |
| `kubeappsapis.readinessProbe.enabled`                                                           | Enable readinessProbe                                                                                                                                                                                                                       | `true`                             |
| `kubeappsapis.readinessProbe.initialDelaySeconds`                                               | Initial delay seconds for readinessProbe                                                                                                                                                                                                    | `0`                                |
| `kubeappsapis.readinessProbe.periodSeconds`                                                     | Period seconds for readinessProbe                                                                                                                                                                                                           | `10`                               |
| `kubeappsapis.readinessProbe.timeoutSeconds`                                                    | Timeout seconds for readinessProbe                                                                                                                                                                                                          | `5`                                |
| `kubeappsapis.readinessProbe.failureThreshold`                                                  | Failure threshold for readinessProbe                                                                                                                                                                                                        | `6`                                |
| `kubeappsapis.readinessProbe.successThreshold`                                                  | Success threshold for readinessProbe                                                                                                                                                                                                        | `1`                                |
| `kubeappsapis.startupProbe.enabled`                                                             | Enable startupProbe                                                                                                                                                                                                                         | `false`                            |
| `kubeappsapis.startupProbe.initialDelaySeconds`                                                 | Initial delay seconds for startupProbe                                                                                                                                                                                                      | `0`                                |
| `kubeappsapis.startupProbe.periodSeconds`                                                       | Period seconds for startupProbe                                                                                                                                                                                                             | `10`                               |
| `kubeappsapis.startupProbe.timeoutSeconds`                                                      | Timeout seconds for startupProbe                                                                                                                                                                                                            | `5`                                |
| `kubeappsapis.startupProbe.failureThreshold`                                                    | Failure threshold for startupProbe                                                                                                                                                                                                          | `6`                                |
| `kubeappsapis.startupProbe.successThreshold`                                                    | Success threshold for startupProbe                                                                                                                                                                                                          | `1`                                |
| `kubeappsapis.customLivenessProbe`                                                              | Custom livenessProbe that overrides the default one                                                                                                                                                                                         | `{}`                               |
| `kubeappsapis.customReadinessProbe`                                                             | Custom readinessProbe that overrides the default one                                                                                                                                                                                        | `{}`                               |
| `kubeappsapis.customStartupProbe`                                                               | Custom startupProbe that overrides the default one                                                                                                                                                                                          | `{}`                               |
| `kubeappsapis.lifecycleHooks`                                                                   | Custom lifecycle hooks for KubeappsAPIs containers                                                                                                                                                                                          | `{}`                               |
| `kubeappsapis.command`                                                                          | Override default container command (useful when using custom images)                                                                                                                                                                        | `[]`                               |
| `kubeappsapis.args`                                                                             | Override default container args (useful when using custom images)                                                                                                                                                                           | `[]`                               |
| `kubeappsapis.extraVolumes`                                                                     | Optionally specify extra list of additional volumes for the KubeappsAPIs pod(s)                                                                                                                                                             | `[]`                               |
| `kubeappsapis.extraVolumeMounts`                                                                | Optionally specify extra list of additional volumeMounts for the KubeappsAPIs container(s)                                                                                                                                                  | `[]`                               |
| `kubeappsapis.podLabels`                                                                        | Extra labels for KubeappsAPIs pods                                                                                                                                                                                                          | `{}`                               |
| `kubeappsapis.podAnnotations`                                                                   | Annotations for KubeappsAPIs pods                                                                                                                                                                                                           | `{}`                               |
| `kubeappsapis.podAffinityPreset`                                                                | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                                         | `""`                               |
| `kubeappsapis.podAntiAffinityPreset`                                                            | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                                    | `soft`                             |
| `kubeappsapis.nodeAffinityPreset.type`                                                          | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                                   | `""`                               |
| `kubeappsapis.nodeAffinityPreset.key`                                                           | Node label key to match. Ignored if `affinity` is set                                                                                                                                                                                       | `""`                               |
| `kubeappsapis.nodeAffinityPreset.values`                                                        | Node label values to match. Ignored if `affinity` is set                                                                                                                                                                                    | `[]`                               |
| `kubeappsapis.affinity`                                                                         | Affinity for pod assignment                                                                                                                                                                                                                 | `{}`                               |
| `kubeappsapis.nodeSelector`                                                                     | Node labels for pod assignment                                                                                                                                                                                                              | `{}`                               |
| `kubeappsapis.tolerations`                                                                      | Tolerations for pod assignment                                                                                                                                                                                                              | `[]`                               |
| `kubeappsapis.priorityClassName`                                                                | Priority class name for KubeappsAPIs pods                                                                                                                                                                                                   | `""`                               |
| `kubeappsapis.schedulerName`                                                                    | Name of the k8s scheduler (other than default)                                                                                                                                                                                              | `""`                               |
| `kubeappsapis.topologySpreadConstraints`                                                        | Topology Spread Constraints for pod assignment                                                                                                                                                                                              | `[]`                               |
| `kubeappsapis.automountServiceAccountToken`                                                     | Mount Service Account token in pod                                                                                                                                                                                                          | `true`                             |
| `kubeappsapis.hostAliases`                                                                      | Custom host aliases for KubeappsAPIs pods                                                                                                                                                                                                   | `[]`                               |
| `kubeappsapis.sidecars`                                                                         | Add additional sidecar containers to the KubeappsAPIs pod(s)                                                                                                                                                                                | `[]`                               |
| `kubeappsapis.initContainers`                                                                   | Add additional init containers to the KubeappsAPIs pod(s)                                                                                                                                                                                   | `[]`                               |
| `kubeappsapis.pdb.create`                                                                       | Enable/disable a Pod Disruption Budget creation                                                                                                                                                                                             | `false`                            |
| `kubeappsapis.pdb.minAvailable`                                                                 | Minimum number/percentage of pods that should remain scheduled                                                                                                                                                                              | `""`                               |
| `kubeappsapis.pdb.maxUnavailable`                                                               | Maximum number/percentage of pods that may be made unavailable. Defaults to `1` if both `kubeappsapis.pdb.minAvailable` and `kubeappsapis.pdb.maxUnavailable` are empty.                                                                    | `""`                               |
| `kubeappsapis.service.ports.http`                                                               | KubeappsAPIs service HTTP port                                                                                                                                                                                                              | `8080`                             |
| `kubeappsapis.service.annotations`                                                              | Additional custom annotations for KubeappsAPIs service                                                                                                                                                                                      | `{}`                               |
| `kubeappsapis.networkPolicy.enabled`                                                            | Specifies whether a NetworkPolicy should be created                                                                                                                                                                                         | `true`                             |
| `kubeappsapis.networkPolicy.allowExternal`                                                      | Don't require server label for connections                                                                                                                                                                                                  | `true`                             |
| `kubeappsapis.networkPolicy.allowExternalEgress`                                                | Allow the pod to access any range of port and all destinations.                                                                                                                                                                             | `true`                             |
| `kubeappsapis.networkPolicy.kubeAPIServerPorts`                                                 | List of possible endpoints to kube-apiserver (limit to your cluster settings to increase security)                                                                                                                                          | `[]`                               |
| `kubeappsapis.networkPolicy.extraIngress`                                                       | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                                                | `[]`                               |
| `kubeappsapis.networkPolicy.extraEgress`                                                        | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                                                | `[]`                               |
| `kubeappsapis.networkPolicy.ingressNSMatchLabels`                                               | Labels to match to allow traffic from other namespaces                                                                                                                                                                                      | `{}`                               |
| `kubeappsapis.networkPolicy.ingressNSPodMatchLabels`                                            | Pod labels to match to allow traffic from other namespaces                                                                                                                                                                                  | `{}`                               |
| `kubeappsapis.serviceAccount.create`                                                            | Specifies whether a ServiceAccount should be created                                                                                                                                                                                        | `true`                             |
| `kubeappsapis.serviceAccount.name`                                                              | Name of the service account to use. If not set and create is true, a name is generated using the fullname template.                                                                                                                         | `""`                               |
| `kubeappsapis.serviceAccount.automountServiceAccountToken`                                      | Automount service account token for the server service account                                                                                                                                                                              | `false`                            |
| `kubeappsapis.serviceAccount.annotations`                                                       | Annotations for service account. Evaluated as a template. Only used if `create` is `true`.                                                                                                                                                  | `{}`                               |

### OCI Catalog chart configuration

| Name                                                           | Description                                                                                                                                                                                                                             | Value                                  |
| -------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------- |
| `ociCatalog.enabled`                                           | Enable the OCI catalog gRPC service for cataloging                                                                                                                                                                                      | `false`                                |
| `ociCatalog.image.registry`                                    | OCI Catalog image registry                                                                                                                                                                                                              | `REGISTRY_NAME`                        |
| `ociCatalog.image.repository`                                  | OCI Catalog image repository                                                                                                                                                                                                            | `REPOSITORY_NAME/kubeapps-oci-catalog` |
| `ociCatalog.image.digest`                                      | OCI Catalog image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                             | `""`                                   |
| `ociCatalog.image.pullPolicy`                                  | OCI Catalog image pull policy                                                                                                                                                                                                           | `IfNotPresent`                         |
| `ociCatalog.image.pullSecrets`                                 | OCI Catalog image pull secrets                                                                                                                                                                                                          | `[]`                                   |
| `ociCatalog.image.debug`                                       | Enable image debug mode                                                                                                                                                                                                                 | `false`                                |
| `ociCatalog.extraFlags`                                        | Additional command line flags for OCI Catalog                                                                                                                                                                                           | `[]`                                   |
| `ociCatalog.extraEnvVars`                                      | Array with extra environment variables to add to the oci-catalog container                                                                                                                                                              | `[]`                                   |
| `ociCatalog.extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for the OCI Catalog container                                                                                                                                                      | `""`                                   |
| `ociCatalog.extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for the OCI Catalog container                                                                                                                                                         | `""`                                   |
| `ociCatalog.containerPorts.grpc`                               | OCI Catalog gRPC container port                                                                                                                                                                                                         | `50061`                                |
| `ociCatalog.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if ociCatalog.resources is set (ociCatalog.resources is recommended for production). | `micro`                                |
| `ociCatalog.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                       | `{}`                                   |
| `ociCatalog.containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                                                                                                                                                    | `true`                                 |
| `ociCatalog.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                                        | `nil`                                  |
| `ociCatalog.containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                                                                                                                              | `1001`                                 |
| `ociCatalog.containerSecurityContext.runAsGroup`               | Set containers' Security Context runAsGroup                                                                                                                                                                                             | `1001`                                 |
| `ociCatalog.containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                                                                                                                                           | `true`                                 |
| `ociCatalog.containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                                                                                                                                             | `false`                                |
| `ociCatalog.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                                                 | `true`                                 |
| `ociCatalog.containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                                                                                                                               | `false`                                |
| `ociCatalog.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                                      | `["ALL"]`                              |
| `ociCatalog.containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                                        | `RuntimeDefault`                       |
| `ociCatalog.livenessProbe.enabled`                             | Enable livenessProbe                                                                                                                                                                                                                    | `true`                                 |
| `ociCatalog.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                                                 | `60`                                   |
| `ociCatalog.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                                        | `10`                                   |
| `ociCatalog.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                                       | `5`                                    |
| `ociCatalog.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                                                     | `6`                                    |
| `ociCatalog.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                                                     | `1`                                    |
| `ociCatalog.readinessProbe.enabled`                            | Enable readinessProbe                                                                                                                                                                                                                   | `true`                                 |
| `ociCatalog.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                                                | `0`                                    |
| `ociCatalog.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                                       | `10`                                   |
| `ociCatalog.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                                      | `5`                                    |
| `ociCatalog.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                                                    | `6`                                    |
| `ociCatalog.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                                                    | `1`                                    |
| `ociCatalog.startupProbe.enabled`                              | Enable startupProbe                                                                                                                                                                                                                     | `false`                                |
| `ociCatalog.startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                                                  | `0`                                    |
| `ociCatalog.startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                                         | `10`                                   |
| `ociCatalog.startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                                        | `5`                                    |
| `ociCatalog.startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                                      | `6`                                    |
| `ociCatalog.startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                                      | `1`                                    |
| `ociCatalog.customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                                                                                                                                     | `{}`                                   |
| `ociCatalog.customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                                                                                                                                                    | `{}`                                   |
| `ociCatalog.customStartupProbe`                                | Custom startupProbe that overrides the default one                                                                                                                                                                                      | `{}`                                   |
| `ociCatalog.lifecycleHooks`                                    | Custom lifecycle hooks for OCI Catalog containers                                                                                                                                                                                       | `{}`                                   |
| `ociCatalog.command`                                           | Override default container command (useful when using custom images)                                                                                                                                                                    | `[]`                                   |
| `ociCatalog.args`                                              | Override default container args (useful when using custom images)                                                                                                                                                                       | `[]`                                   |
| `ociCatalog.extraVolumes`                                      | Optionally specify extra list of additional volumes for the OCI Catalog pod(s)                                                                                                                                                          | `[]`                                   |
| `ociCatalog.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the OCI Catalog container(s)                                                                                                                                               | `[]`                                   |

### Redis&reg; chart configuration

| Name                                | Description                                                                                                                                                                                                              | Value                                                    |
| ----------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | -------------------------------------------------------- |
| `redis.auth.enabled`                | Enable password authentication                                                                                                                                                                                           | `true`                                                   |
| `redis.auth.password`               | Redis&reg; password                                                                                                                                                                                                      | `""`                                                     |
| `redis.auth.existingSecret`         | The name of an existing secret with Redis&reg; credentials                                                                                                                                                               | `""`                                                     |
| `redis.architecture`                | Redis(R) architecture (`standalone` or `replication`)                                                                                                                                                                    | `standalone`                                             |
| `redis.master.extraFlags`           | Array with additional command line flags for Redis&reg; master                                                                                                                                                           | `["--maxmemory 200mb","--maxmemory-policy allkeys-lru"]` |
| `redis.master.disableCommands`      | Array with commands to deactivate on Redis&reg;                                                                                                                                                                          | `[]`                                                     |
| `redis.master.persistence.enabled`  | Enable Redis&reg; master data persistence using PVC                                                                                                                                                                      | `false`                                                  |
| `redis.master.resourcesPreset`      | Set container resources according to one common preset (allowed values: none, nano, small, medium, large, xlarge, 2xlarge). This is ignored if master.resources is set (master.resources is recommended for production). | `nano`                                                   |
| `redis.master.resources`            | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                        | `{}`                                                     |
| `redis.replica.replicaCount`        | Number of Redis&reg; replicas to deploy                                                                                                                                                                                  | `1`                                                      |
| `redis.replica.extraFlags`          | Array with additional command line flags for Redis&reg; replicas                                                                                                                                                         | `["--maxmemory 200mb","--maxmemory-policy allkeys-lru"]` |
| `redis.replica.disableCommands`     | Array with commands to deactivate on Redis&reg;                                                                                                                                                                          | `[]`                                                     |
| `redis.replica.persistence.enabled` | Enable Redis&reg; replica data persistence using PVC                                                                                                                                                                     | `false`                                                  |

```console
helm install kubeapps --namespace kubeapps \
  --set ingress.enabled=true \
    oci://REGISTRY_NAME/REPOSITORY_NAME/kubeapps
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The above command enables an Ingress Rule to expose Kubeapps.

Alternatively, a YAML file that specifies the values for parameters can be provided while installing the chart. For example,

```console
helm install kubeapps --namespace kubeapps -f custom-values.yaml oci://REGISTRY_NAME/REPOSITORY_NAME/kubeapps
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

## Troubleshooting

### How to install Kubeapps for demo purposes?

Install Kubeapps for exclusively **demo purposes** by simply following the [getting started](https://github.com/vmware-tanzu/kubeapps/blob/main/site/content/docs/latest/tutorials/getting-started.md) docs.

### How to install Kubeapps in production scenarios?

For any user-facing installation, you should [configure an OAuth2/OIDC provider](https://github.com/vmware-tanzu/kubeapps/blob/main/site/content/docs/latest/tutorials/using-an-OIDC-provider.md) to enable secure user authentication with Kubeapps and the cluster.
Please also refer to the [Access Control](https://github.com/vmware-tanzu/kubeapps/blob/main/site/content/docs/latest/howto/access-control.md) documentation to configure fine-grained access control for users.

### How to use Kubeapps?

Have a look at the [dashboard documentation](https://github.com/vmware-tanzu/kubeapps/blob/main/site/content/docs/latest/howto/dashboard.md) for knowing how to use the Kubeapps dashboard: deploying applications, listing and removing the applications running in your cluster and adding new repositories.

### How to uninstall Kubeapps

To uninstall/delete the `kubeapps` deployment:

```console
helm uninstall -n kubeapps kubeapps

# Optional: Only if there are no more instances of Kubeapps
$ kubectl delete crd apprepositories.kubeapps.com
```

The first command removes most of the Kubernetes components associated with the chart and deletes the release. After that, if there are no more instances of Kubeapps in the cluster you can manually delete the `apprepositories.kubeapps.com` CRD used by Kubeapps that is shared for the entire cluster.

> **NOTE**: If you delete the CRD for `apprepositories.kubeapps.com` it will delete the repositories for **all** the installed instances of `kubeapps`. This will break existing installations of `kubeapps` if they exist.

If you have dedicated a namespace only for Kubeapps you can completely clean the remaining completed/failed jobs or any stale resources by deleting the namespace

```console
kubectl delete namespace kubeapps
```

### How to configure Kubeapps with Ingress

The example below will match the URL `http://example.com` to the Kubeapps dashboard. For further configuration, please refer to your specific Ingress configuration docs (e.g., [NGINX](https://github.com/kubernetes/ingress-nginx) or [HAProxy](https://github.com/haproxytech/kubernetes-ingress)).

```console
helm install kubeapps oci://REGISTRY_NAME/REPOSITORY_NAME/kubeapps \
  --namespace kubeapps \
  --set ingress.enabled=true \
  --set ingress.hostname=example.com \
  --set ingress.annotations."kubernetes\.io/ingress\.class"=nginx # or your preferred ingress controller
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

If you are using LDAP via Dex with OIDC or you are getting an error message like `upstream sent too big header while reading response header from upstream` it means the cookie size is too big and can't be processed by the Ingress Controller.
You can work around this problem by setting the following Nginx ingress annotations (look for similar annotations in your preferred Ingress Controller):

```text
  # rest of the helm install ... command
  --set ingress.annotations."nginx\.ingress\.kubernetes\.io/proxy-read-timeout"=600
  --set ingress.annotations."nginx\.ingress\.kubernetes\.io/proxy-buffer-size"=8k
  --set ingress.annotations."nginx\.ingress\.kubernetes\.io/proxy-buffers"=4
```

#### Serving Kubeapps in a subpath

You may want to serve Kubeapps with a subpath, for instance `http://example.com/subpath`, you have to set the proper Ingress configuration. If you are using the ingress configuration provided by the Kubeapps chart, you will have to set the `ingress.hostname` and `path` parameters:

```console
helm install kubeapps oci://REGISTRY_NAME/REPOSITORY_NAME/kubeapps \
  --namespace kubeapps \
  --set ingress.enabled=true \
  --set ingress.hostname=example.com \
  --set ingress.path=/subpath \
  --set ingress.annotations."kubernetes\.io/ingress\.class"=nginx # or your preferred ingress controller
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

Besides, if you are using the OAuth2/OIDC login (more information at the [using an OIDC provider documentation](https://github.com/vmware-tanzu/kubeapps/blob/main/site/content/docs/latest/tutorials/using-an-OIDC-provider.md)), you will need, also, to configure the different URLs:

```console
helm install kubeapps oci://REGISTRY_NAME/REPOSITORY_NAME/kubeapps \
  --namespace kubeapps \
  # ... other OIDC and ingress flags
  --set authProxy.oauthLoginURI="/subpath/oauth2/login" \
  --set authProxy.oauthLogoutURI="/subpath/oauth2/logout" \
  --set authProxy.extraFlags="{<other flags>,--proxy-prefix=/subpath/oauth2}"
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

### Can Kubeapps install apps into more than one cluster?

Yes! Kubeapps 2.0+ supports multicluster environments. Have a look at the [Kubeapps dashboard documentation](https://github.com/vmware-tanzu/kubeapps/blob/main/site/content/docs/latest/howto/deploying-to-multiple-clusters.md) to know more.

### Can Kubeapps be installed without Internet connection?

Yes! Follow the [offline installation documentation](https://github.com/vmware-tanzu/kubeapps/blob/main/site/content/docs/latest/howto/offline-installation.md) to discover how to perform an installation in an air-gapped scenario.

### Does Kubeapps support private repositories?

Of course! Have a look at the [private package repositories documentation](https://github.com/vmware-tanzu/kubeapps/blob/main/site/content/docs/latest/howto/private-app-repository.md) to learn how to configure a private repository in Kubeapps.

### Is there any API documentation?

Yes! But it is not definitive and is still subject to change. Check out the [latest API online documentation](https://app.swaggerhub.com/apis/vmware-tanzu/Kubeapps) or download the Kubeapps [OpenAPI Specification yaml file](https://github.com/vmware-tanzu/kubeapps/blob/main/dashboard/public/openapi.yaml) from the repository.

### Why can't I configure global private repositories?

You can, but you will need to configure the `imagePullSecrets` manually.

Kubeapps does not allow you to add `imagePullSecrets` to an AppRepository that is available to the whole cluster because it would require that Kubeapps copies those secrets to the target namespace when a user deploys an app.

If you create a global AppRepository but the images are on a private registry requiring `imagePullSecrets`, the best way to configure that is to ensure your [Kubernetes nodes are configured with the required `imagePullSecrets`](https://kubernetes.io/docs/concepts/containers/images/#configuring-nodes-to-authenticate-to-a-private-registry) - this allows all users (of those nodes) to use those images in their deployments without ever requiring access to the secrets.

You could alternatively ensure that the `imagePullSecret` is available in all namespaces in which you want people to deploy, but this unnecessarily compromises the secret.

### Does Kubeapps support Operators?

Yes! You can get started by following the [operators documentation](https://github.com/vmware-tanzu/kubeapps/blob/main/site/content/docs/latest/tutorials/operators.md).

### Slow response when listing namespaces

Kubeapps uses the currently logged-in user credential to retrieve the list of all namespaces. If the user does not have permission to list namespaces, the backend will try again with its own service account. It will list all the namespaces and then will iterate through each namespace to check if the user has permissions to get secrets for each one.
This can lead to a slow response if the number of namespaces on the cluster is large.

To reduce this response time, you can increase the number of checks that Kubeapps will perform in parallel (per connection) setting the value: `kubeappsapis.burst=<desired_number>` and `kubeappsapis.QPS=<desired_number>`.

### Nginx Ipv6 error

When starting the application with the `--set enableIPv6=true` option, the Nginx server present in the services `kubeapps` and `kubeapps-internal-dashboard` may fail with the following:

```console
nginx: [emerg] socket() [::]:8080 failed (97: Address family not supported by protocol)
```

This usually means that your cluster is not compatible with IPv6. To deactivate it, install kubeapps with the flag: `--set enableIPv6=false`.

### Forbidden error while installing the Chart

If during installation you run into an error similar to:

```console
Error: release kubeapps failed: clusterroles.rbac.authorization.k8s.io "kubeapps-apprepository-controller" is forbidden: attempt to grant extra privileges: [{[get] [batch] [cronjobs] [] []...
```

Or:

```console
Error: namespaces "kubeapps" is forbidden: User "system:serviceaccount:kube-system:default" cannot get namespaces in the namespace "kubeapps"
```

It is possible, though uncommon, that your cluster does not have Role-Based Access Control (RBAC) enabled. To check if your cluster has RBAC you can run the following command:

```console
kubectl api-versions
```

If the above command does not include entries for `rbac.authorization.k8s.io` you should perform the chart installation by setting `rbac.create=false`:

```console
helm install --name kubeapps --namespace kubeapps oci://REGISTRY_NAME/REPOSITORY_NAME/kubeapps --set rbac.create=false
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

### Error while upgrading the Chart

It is possible that when upgrading Kubeapps an error appears. That can be caused by a breaking change in the new chart or because the current chart installation is in an inconsistent state. If you find issues upgrading Kubeapps you can follow these steps:

> Note: These steps assume that you have installed Kubeapps in the namespace `kubeapps` using the name `kubeapps`. If that is not the case replace the command with your namespace and/or name.
> Note: If you are upgrading from 2.3.1 see the [following section](#to-600).
> Note: If you are upgrading from 1.X to 2.X see the [following section](#to-400).

1. (Optional) Backup your personal repositories (if you have any):

    ```console
    kubectl get apprepository -A -o yaml > <repo name>.yaml
    ```

2. Delete Kubeapps:

    ```console
    helm del --purge kubeapps
    ```

3. (Optional) Delete the App Repositories CRD:

    > **Warning**: Do not run this step if you have more than one Kubeapps installation in your cluster.

    ```console
    kubectl delete crd apprepositories.kubeapps.com
    ```

4. (Optional) Clean the Kubeapps namespace:

    > **Warning**: Do not run this step if you have workloads other than Kubeapps in the `kubeapps` namespace.

    ```console
    kubectl delete namespace kubeapps
    ```

5. Install the latest version of Kubeapps (using any custom modifications you need):

    ```console
    helm repo update
    helm install --name kubeapps --namespace kubeapps oci://REGISTRY_NAME/REPOSITORY_NAME/kubeapps
    ```

    > Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

6. (Optional) Restore any repositories you backed up in the first step:

    ```console
    kubectl apply -f <repo name>.yaml
    ```

After that you should be able to access the new version of Kubeapps. If the above doesn't work for you or you run into any other issues please open an [issue](https://github.com/vmware-tanzu/kubeapps/issues/new).

### More questions?

Feel free to [open an issue](https://github.com/vmware-tanzu/kubeapps/issues/new) if you have any questions!

## Upgrading Kubeapps

You can upgrade Kubeapps from the Kubeapps web interface. Select the namespace in which Kubeapps is installed (`kubeapps` if you followed the instructions in this guide) and click on the "Upgrade" button. Select the new version and confirm.

You can also use the Helm CLI to upgrade Kubeapps, first ensure you have updated your local chart repository cache:

```console
helm repo update
```

Now upgrade Kubeapps:

```console
export RELEASE_NAME=kubeapps
helm upgrade $RELEASE_NAME oci://REGISTRY_NAME/REPOSITORY_NAME/kubeapps
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

If you find issues upgrading Kubeapps, check the [troubleshooting](#error-while-upgrading-the-chart) section.

### To 15.0.0

This major bump changes the following security defaults:

- `runAsGroup` is changed from `0` to `1001`
- `readOnlyRootFilesystem` is set to `true`
- `resourcesPreset` is changed from `none` to the minimum size working in our test suites (NOTE: `resourcesPreset` is not meant for production usage, but `resources` adapted to your use case).
- `global.compatibility.openshift.adaptSecurityContext` is changed from `disabled` to `auto`.
- The `networkPolicy` section has been normalized amongst all Bitnami charts. Compared to the previous approach, the values section has been simplified (check the Parameters section) and now it set to `enabled=true` by default. Egress traffic is allowed by default and ingress traffic is allowed by all pods but only to the ports set in `containerPorts`.
- The PostgreSQL subchart was updated to version 15.2.1, with the same security improvements.
- The Redis subchart was updated to version 19.0.2, with the same security improvements.

This could potentially break any customization or init scripts used in your deployment. If this is the case, change the default values to the previous ones.

### To 14.0.0

This major updates the PostgreSQL subchart to its newest major, 13.0.0. [Here](https://github.com/bitnami/charts/tree/master/bitnami/postgresql#to-1300) you can find more information about the changes introduced in that version.

### To 13.0.0

This major updates the Redis&reg; subchart to its newest major, 18.0.0. [Here](https://github.com/bitnami/charts/tree/main/bitnami/redis#to-1800) you can find more information about the changes introduced in that version.

NOTE: Due to an error in our release process, Redis&reg;' chart versions higher or equal than 17.15.4 already use Redis&reg; 7.2 by default.

### To 12.0.0

This major updates the PostgreSQL subchart to its newest major, 12.0.0. [Here](https://github.com/bitnami/charts/tree/master/bitnami/postgresql#to-1200) you can find more information about the changes introduced in that version.

### To 8.0.0

This major release renames several values in this chart and adds missing features, in order to get aligned with the rest of the assets in the Bitnami charts repository.

Additionally, it updates both the [PostgreSQL](https://github.com/bitnami/charts/tree/main/bitnami/postgresql) and the [Redis](https://github.com/bitnami/charts/tree/main/bitnami/redis) subcharts to their latest major versions, 11.0.0 and 16.0.0 respectively, where similar changes have been also performed.
Check [PostgreSQL Upgrading Notes](https://github.com/bitnami/charts/tree/master/bitnami/postgresql#to-1100) and [Redis Upgrading Notes](https://github.com/bitnami/charts/tree/main/bitnami/redis#to-1600) for more information.

The following values have been renamed:

- `frontend.service.port` renamed as `frontend.service.ports.http`.
- `frontend.service.nodePort` renamed as `frontend.service.nodePorts.http`.
- `frontend.containerPort` renamed as `frontend.containerPorts.http`.
- `dashboard.service.port` renamed as `dashboard.service.ports.http`.
- `dashboard.containerPort` renamed as `dashboard.containerPorts.http`.
- `apprepository.service.port` renamed as `apprepository.service.ports.http`.
- `apprepository.containerPort` renamed as `apprepository.containerPorts.http`.
- `kubeops.service.port` renamed as `kubeops.service.ports.http`.
- `kubeops.containerPort` renamed as `kubeops.containerPorts.http`.
- `assetsvc.service.port` renamed as `assetsvc.service.ports.http`.
- `assetsvc.containerPort` renamed as `assetsvc.containerPorts.http`.
- `authProxy.containerPort` renamed as `authProxy.containerPorts.proxy`.
- `authProxy.additionalFlags` renamed as `authProxy.extraFlags`,
- Pinniped Proxy service no longer uses `pinnipedProxy.containerPort`. Use `pinnipedProxy.service.ports.pinnipedProxy` to change the service port.
- `pinnipedProxy.containerPort` renamed as `pinnipedProxy.containerPorts.pinnipedProxy`.
- `postgresql.replication.enabled` has been removed. Use `postgresql.architecture` instead.
- `postgresql.postgresqlDatabase` renamed as `postgresql.auth.database`.
- `postgresql.postgresqlPassword` renamed as `postgresql.auth.password`.
- `postgresql.existingSecret` renamed as `postgresql.auth.existingSecret`.
- `redis.redisPassword` renamed as `redis.auth.password`.
- `redis.existingSecret` renamed as `redis.auth.existingSecret`.

Note also that if you have an existing Postgresql secret that is used for Kubeapps, you will need to update the key from `postgresql-password` to `postgres-password`.

### To 7.0.0

In this release, no breaking changes were included in Kubeapps (version 2.3.2). However, the chart adopted the standardizations included in the rest of the charts in the Bitnami catalog.

Most of these standardizations simply add new parameters that allow to add more customizations such as adding custom env. variables, volumes or sidecar containers. That said, some of them include breaking changes:

- Chart labels were adapted to follow the [Helm charts standard labels](https://helm.sh/docs/chart_best_practices/labels/#standard-labels).
- `securityContext.*` parameters are deprecated in favor of `XXX.podSecurityContext.*` and `XXX.containerSecurityContext.*`, where _XXX_ is placeholder you need to replace with the actual component(s). For instance, to modify the container security context for "kubeops" use `kubeops.podSecurityContext` and `kubeops.containerSecurityContext` parameters.

### To 6.0.0

Kubeapps 2.3.1 (Chart version 6.0.0) introduces some breaking changes. Helm-specific functionality has been removed in order to support other installation methods (like using YAML manifests, [`kapp`](https://carvel.dev/kapp) or [`kustomize`](https://kustomize.io/)). Because of that, there are some steps required before upgrading from a previous version:

1. Kubeapps will no longer create a database secret for you automatically but rather will rely on the default behavior of the PostgreSQL chart. If you try to upgrade Kubeapps and you installed it without setting a password, you will get the following error:

    ```console
    Error: UPGRADE FAILED: template: kubeapps/templates/NOTES.txt:73:4: executing "kubeapps/templates/NOTES.txt" at <include "common.errors.upgrade.passwords.empty" (dict "validationErrors" $passwordValidationErrors "context" $)>: error calling include: template: kubeapps/charts/common/templates/_errors.tpl:18:48: executing "common.errors.upgrade.passwords.empty" at <fail>: error calling fail:
    PASSWORDS ERROR: you must provide your current passwords when upgrade the release
        'postgresql.postgresqlPassword' must not be empty, please add '--set postgresql.postgresqlPassword=$POSTGRESQL_PASSWORD' to the command. To get the current value:
    ```

    The error gives you generic instructions for retrieving the PostgreSQL password, but if you have installed a Kubeapps version prior to 2.3.1, the name of the secret will differ. Run the following command:

    ```console
    export POSTGRESQL_PASSWORD=$(kubectl get secret --namespace "kubeapps" kubeapps-db -o jsonpath="{.data.postgresql-password}" | base64 -d)
    ```

    > NOTE: Replace the namespace in the command with the namespace in which you have deployed Kubeapps.

    Make sure that you have stored the password in the variable `$POSTGRESQL_PASSWORD` before continuing with the next issue.

2. The chart `initialRepos` are no longer installed using [Helm hooks](https://helm.sh/docs/topics/charts_hooks/), which caused these repos not to be handled by Helm after the first installation. Now they will be tracked for every update. However, if you do not delete the existing ones, it will fail to update with:

```console
Error: UPGRADE FAILED: rendered manifests contain a resource that already exists. Unable to continue with update: AppRepository "bitnami" in namespace "kubeapps" exists and cannot be imported into the current release: invalid ownership metadata; annotation validation error: missing key "meta.helm.sh/release-name": must be set to "kubeapps"; annotation validation error: missing key "meta.helm.sh/release-namespace": must be set to "kubeapps"
```

To bypass this issue, you will need to before delete all the initialRepos from the chart values (only the `bitnami` repo by default):

```console
kubectl delete apprepositories.kubeapps.com -n kubeapps bitnami
```

> NOTE: Replace the namespace in the command with the namespace in which you have deployed Kubeapps.

After that, you will be able to upgrade Kubeapps to 2.3.1 using the existing database secret:

> **WARNING**: Make sure that the variable `$POSTGRESQL_PASSWORD` is properly populated. Setting a wrong (or empty) password will corrupt the release.

```console
helm upgrade kubeapps oci://REGISTRY_NAME/REPOSITORY_NAME/kubeapps -n kubeapps --set postgresql.postgresqlPassword=$POSTGRESQL_PASSWORD
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

### To 5.0.0

[On November 13, 2020, Helm 2 support was formally finished](https://github.com/helm/charts#status-of-the-project), this major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm 3 and to be consistent with the Helm project itself regarding the Helm 2 EOL.

#### What changes were introduced in this major version?

- Previous versions of this Helm Chart use `apiVersion: v1` (installable by both Helm 2 and 3), this Helm Chart was updated to `apiVersion: v2` (installable by Helm 3 only). [Here](https://helm.sh/docs/topics/charts/#the-apiversion-field) you can find more information about the `apiVersion` field.
- Move dependency information from the _requirements.yaml_ to the _Chart.yaml_
- After running `helm dependency update`, a _Chart.lock_ file is generated containing the same structure used in the previous _requirements.lock_
- The different fields present in the _Chart.yaml_ file has been ordered alphabetically in a homogeneous way for all the Bitnami Helm Charts
- In the case of PostgreSQL subchart, apart from the same changes that are described in this section, there are also other major changes due to the _master/slave_ nomenclature was replaced by _primary/readReplica_. [Here](https://github.com/bitnami/charts/pull/4385) you can find more information about the changes introduced.

#### Considerations when upgrading to this version

- If you want to upgrade to this version using Helm 2, this scenario is not supported as this version does not support Helm 2 anymore
- If you installed the previous version with Helm 2 and wants to upgrade to this version with Helm 3, please refer to the [official Helm documentation](https://helm.sh/docs/topics/v2_v3_migration/#migration-use-cases) about migrating from Helm 2 to 3
- If you want to upgrade to this version from a previous one installed with Helm 3, you should not face any issues related to the new `apiVersion`. Due to the PostgreSQL major version bump, it is necessary to remove the existing statefulsets:

> Note: The command below assumes that Kubeapps has been deployed in the kubeapps namespace using "kubeapps" as release name, if that is not the case, adapt the command accordingly.

```console
kubectl delete statefulset -n kubeapps kubeapps-postgresql-master kubeapps-postgresql-slave
```

#### Useful links

- <https://docs.vmware.com/en/VMware-Tanzu-Application-Catalog/services/tutorials/GUID-resolve-helm2-helm3-post-migration-issues-index.html>
- <https://helm.sh/docs/topics/v2_v3_migration/>
- <https://helm.sh/blog/migrate-from-helm-v2-to-helm-v3/>

### To 4.0.0

Kubeapps 2.0 (Chart version 4.0.0) introduces some breaking changes:

- Helm 2 is no longer supported. If you are still using some Helm 2 charts, [migrate them with the available tools](https://helm.sh/docs/topics/v2_v3_migration/). Note that some charts (but not all of them) may require to be migrated to the [new Chart specification (v2)](https://helm.sh/docs/topics/charts/#the-apiversion-field). If you are facing any issue managing this migration and Kubeapps, please open a new issue!
- MongoDB&reg; is no longer supported. Since 2.0, the only database supported is PostgreSQL.
- PostgreSQL chart dependency has been upgraded to a new major version.

Due to the last point, it is necessary to run a command before upgrading to Kubeapps 2.0:

> Note: The command below assumes that Kubeapps has been deployed in the kubeapps namespace using "kubeapps" as release name, if that is not the case, adapt the command accordingly.

```console
kubectl delete statefulset -n kubeapps kubeapps-postgresql-master kubeapps-postgresql-slave
```

After that, you should be able to upgrade Kubeapps as always and the database will be repopulated.

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