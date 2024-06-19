<!--- app-name: Sealed Secrets -->

# Bitnami package for Sealed Secrets

Sealed Secrets are "one-way" encrypted K8s Secrets that can be created by anyone, but can only be decrypted by the controller running in the target cluster recovering the original object.

[Overview of Sealed Secrets](https://github.com/bitnami-labs/sealed-secrets)

## TL;DR

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/sealed-secrets
```

Looking to use Sealed Secrets in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the enterprise edition of Bitnami Application Catalog.

## Introduction

Bitnami charts for Helm are carefully engineered, actively maintained and are the quickest and easiest way to deploy containers on a Kubernetes cluster that are ready to handle production workloads.

This chart bootstraps a [Sealed Secret controller](https://github.com/bitnami-labs/sealed-secrets) Deployment in [Kubernetes](https://kubernetes.io) using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.16+
- Helm 3.8.0+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/sealed-secrets
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The command deploys the Sealed Secrets controller on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Configuration and installation details

### Resource requests and limits

Bitnami charts allow setting resource requests and limits for all containers inside the chart deployment. These are inside the `resources` value (check parameter table). Setting requests is essential for production workloads and these should be adapted to your specific use case.

To make this process easier, the chart contains the `resourcesPreset` values, which automatically sets the `resources` section according to different presets. Check these presets in [the bitnami/common chart](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15). However, in production workloads using `resourcePreset` is discouraged as it may not fully adapt to your specific needs. Find more information on container resource management in the [official Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).

### Using kubeseal

The easiest way to interact with the Sealed Secrets controller is using the **kubeseal** utility. You can install this CLI by downloading the binary from [sealed-secrets/releases](https://github.com/bitnami-labs/sealed-secrets/releases) page.

Once installed, you can start using it to encrypt your secrets or fetching the controller public certificate as shown in the example below:

```console
$ kubeseal --fetch-cert \
--controller-name=my-release \
--controller-namespace=my-release-namespace \
> pub-cert.pem
```

Refer to Sealed Secrets documentation for more information about [kubeseal usage](https://github.com/bitnami-labs/sealed-secrets#usage).

### [Rolling VS Immutable tags](https://docs.vmware.com/en/VMware-Tanzu-Application-Catalog/services/tutorials/GUID-understand-rolling-tags-containers-index.html)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Ingress

This chart provides support for Ingress resources. If you have an ingress controller installed on your cluster, such as [nginx-ingress-controller](https://github.com/bitnami/charts/tree/main/bitnami/nginx-ingress-controller) or [contour](https://github.com/bitnami/charts/tree/main/bitnami/contour) you can utilize the ingress controller to serve your application.To enable Ingress integration, set `ingress.enabled` to `true`.

The most common scenario is to have one host name mapped to the deployment. In this case, the `ingress.hostname` property can be used to set the host name. The `ingress.tls` parameter can be used to add the TLS configuration for this host.

However, it is also possible to have more than one host. To facilitate this, the `ingress.extraHosts` parameter (if available) can be set with the host names specified as an array. The `ingress.extraTLS` parameter (if available) can also be used to add the TLS configuration for extra hosts.

> NOTE: For each host specified in the `ingress.extraHosts` parameter, it is necessary to set a name, path, and any annotations that the Ingress controller should know about. Not all annotations are supported by all Ingress controllers, but [this annotation reference document](https://github.com/kubernetes/ingress-nginx/blob/master/docs/user-guide/nginx-configuration/annotations.md) lists the annotations supported by many popular Ingress controllers.

Adding the TLS parameter (where available) will cause the chart to generate HTTPS URLs, and the  application will be available on port 443. The actual TLS secrets do not have to be generated by this chart. However, if TLS is enabled, the Ingress record will not work until the TLS secret exists.

[Learn more about Ingress controllers](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/).

### TLS secrets

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

### Sidecars

If additional containers are needed in the same pod as Sealed Secrets (such as additional metrics or logging exporters), they can be defined using the `sidecars` parameter.

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

### Pod affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, use one of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

## Parameters

### Global parameters

| Name                                                  | Description                                                                                                                                                                                                                                                                                                                                                         | Value  |
| ----------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------ |
| `global.imageRegistry`                                | Global Docker image registry                                                                                                                                                                                                                                                                                                                                        | `""`   |
| `global.imagePullSecrets`                             | Global Docker registry secret names as an array                                                                                                                                                                                                                                                                                                                     | `[]`   |
| `global.storageClass`                                 | Global StorageClass for Persistent Volume(s)                                                                                                                                                                                                                                                                                                                        | `""`   |
| `global.compatibility.openshift.adaptSecurityContext` | Adapt the securityContext sections of the deployment to make them compatible with Openshift restricted-v2 SCC: remove runAsUser, runAsGroup and fsGroup and let the platform use their allowed default IDs. Possible values: auto (apply if the detected running cluster is Openshift), force (perform the adaptation always), disabled (do not perform adaptation) | `auto` |

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

| Name                                                | Description                                                                                                                                                                                                       | Value                            |
| --------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------- |
| `image.registry`                                    | Sealed Secrets image registry                                                                                                                                                                                     | `REGISTRY_NAME`                  |
| `image.repository`                                  | Sealed Secrets image repository                                                                                                                                                                                   | `REPOSITORY_NAME/sealed-secrets` |
| `image.digest`                                      | Sealed Secrets image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                    | `""`                             |
| `image.pullPolicy`                                  | Sealed Secrets image pull policy                                                                                                                                                                                  | `IfNotPresent`                   |
| `image.pullSecrets`                                 | Sealed Secrets image pull secrets                                                                                                                                                                                 | `[]`                             |
| `image.debug`                                       | Enable Sealed Secrets image debug mode                                                                                                                                                                            | `false`                          |
| `command`                                           | Override default container command (useful when using custom images)                                                                                                                                              | `[]`                             |
| `commandArgs`                                       | Additional args (doesn't override the default ones)                                                                                                                                                               | `[]`                             |
| `args`                                              | Override default container args (useful when using custom images)                                                                                                                                                 | `[]`                             |
| `revisionHistoryLimit`                              | Number of old history to retain to allow rollback (If not set, default Kubernetes value is set to 10)                                                                                                             | `""`                             |
| `createController`                                  | Specifies whether the Sealed Secrets controller should be created                                                                                                                                                 | `true`                           |
| `secretName`                                        | The name of an existing TLS secret containing the key used to encrypt secrets                                                                                                                                     | `""`                             |
| `updateStatus`                                      | Specifies whether the Sealed Secrets controller should update the status subresource                                                                                                                              | `true`                           |
| `skipRecreate`                                      | Specifies whether the Sealed Secrets controller should skip recreating removed secrets                                                                                                                            | `false`                          |
| `keyRenewPeriod`                                    | Specifies key renewal period. Default 30 days. e.g keyRenewPeriod: "720h30m"                                                                                                                                      | `""`                             |
| `rateLimit`                                         | Number of allowed sustained request per second for verify endpoint                                                                                                                                                | `""`                             |
| `rateLimitBurst`                                    | Number of requests allowed to exceed the rate limit per second for verify endpoint                                                                                                                                | `""`                             |
| `additionalNamespaces`                              | List of namespaces used to manage the Sealed Secrets                                                                                                                                                              | `[]`                             |
| `privateKeyAnnotations`                             | Map of annotations to be set on the sealing keypairs                                                                                                                                                              | `{}`                             |
| `privateKeyLabels`                                  | Map of labels to be set on the sealing keypairs                                                                                                                                                                   | `{}`                             |
| `logInfoStdout`                                     | Specifies whether the Sealed Secrets controller will log info to stdout                                                                                                                                           | `false`                          |
| `containerPorts.http`                               | Controller HTTP container port to open                                                                                                                                                                            | `8080`                           |
| `containerPorts.metrics`                            | Controller metrics container port                                                                                                                                                                                 | `8081`                           |
| `resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if resources is set (resources is recommended for production). | `nano`                           |
| `resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                 | `{}`                             |
| `livenessProbe.enabled`                             | Enable livenessProbe on Sealed Secret containers                                                                                                                                                                  | `true`                           |
| `livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                           | `5`                              |
| `livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                  | `10`                             |
| `livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                 | `1`                              |
| `livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                               | `3`                              |
| `livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                               | `1`                              |
| `readinessProbe.enabled`                            | Enable readinessProbe on Sealed Secret containers                                                                                                                                                                 | `true`                           |
| `readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                          | `5`                              |
| `readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                 | `10`                             |
| `readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                | `1`                              |
| `readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                              | `3`                              |
| `readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                              | `1`                              |
| `startupProbe.enabled`                              | Enable startupProbe on Sealed Secret containers                                                                                                                                                                   | `false`                          |
| `startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                            | `10`                             |
| `startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                   | `10`                             |
| `startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                  | `1`                              |
| `startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                | `15`                             |
| `startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                | `1`                              |
| `customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                                                                                                               | `{}`                             |
| `customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                                                                                                                              | `{}`                             |
| `customStartupProbe`                                | Custom startupProbe that overrides the default one                                                                                                                                                                | `{}`                             |
| `podSecurityContext.enabled`                        | Enabled Sealed Secret pods' Security Context                                                                                                                                                                      | `true`                           |
| `podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                | `Always`                         |
| `podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                    | `[]`                             |
| `podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                       | `[]`                             |
| `podSecurityContext.fsGroup`                        | Set Sealed Secret pod's Security Context fsGroup                                                                                                                                                                  | `1001`                           |
| `containerSecurityContext.enabled`                  | Enabled Sealed Secret containers' Security Context                                                                                                                                                                | `true`                           |
| `containerSecurityContext.allowPrivilegeEscalation` | Whether the Sealed Secret container can escalate privileges                                                                                                                                                       | `false`                          |
| `containerSecurityContext.capabilities.drop`        | Which privileges to drop in the Sealed Secret container                                                                                                                                                           | `["ALL"]`                        |
| `containerSecurityContext.readOnlyRootFilesystem`   | Whether the Sealed Secret container has a read-only root filesystem                                                                                                                                               | `true`                           |
| `containerSecurityContext.runAsNonRoot`             | Indicates that the Sealed Secret container must run as a non-root user                                                                                                                                            | `true`                           |
| `containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                  | `nil`                            |
| `containerSecurityContext.runAsUser`                | Set Sealed Secret containers' Security Context runAsUser                                                                                                                                                          | `1001`                           |
| `containerSecurityContext.runAsGroup`               | Set Sealed Secret containers' Security Context runAsGroup                                                                                                                                                         | `1001`                           |
| `containerSecurityContext.seccompProfile.type`      | Set Sealed Secret container's Security Context seccompProfile type                                                                                                                                                | `RuntimeDefault`                 |
| `automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                | `true`                           |
| `hostAliases`                                       | Sealed Secret pods host aliases                                                                                                                                                                                   | `[]`                             |
| `podLabels`                                         | Extra labels for Sealed Secret pods                                                                                                                                                                               | `{}`                             |
| `podAnnotations`                                    | Annotations for Sealed Secret pods                                                                                                                                                                                | `{}`                             |
| `podAffinityPreset`                                 | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                               | `""`                             |
| `podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                          | `soft`                           |
| `nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                         | `""`                             |
| `nodeAffinityPreset.key`                            | Node label key to match. Ignored if `affinity` is set                                                                                                                                                             | `""`                             |
| `nodeAffinityPreset.values`                         | Node label values to match. Ignored if `affinity` is set                                                                                                                                                          | `[]`                             |
| `affinity`                                          | Affinity for Sealed Secret pods assignment                                                                                                                                                                        | `{}`                             |
| `nodeSelector`                                      | Node labels for Sealed Secret pods assignment                                                                                                                                                                     | `{}`                             |
| `tolerations`                                       | Tolerations for Sealed Secret pods assignment                                                                                                                                                                     | `[]`                             |
| `updateStrategy.type`                               | Sealed Secret statefulset strategy type                                                                                                                                                                           | `RollingUpdate`                  |
| `priorityClassName`                                 | Sealed Secret pods' priorityClassName                                                                                                                                                                             | `""`                             |
| `topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template                                                                                          | `[]`                             |
| `schedulerName`                                     | Name of the k8s scheduler (other than default) for Sealed Secret pods                                                                                                                                             | `""`                             |
| `terminationGracePeriodSeconds`                     | Seconds the pod needs to terminate gracefully                                                                                                                                                                     | `""`                             |
| `lifecycleHooks`                                    | for the Sealed Secret container(s) to automate configuration before or after startup                                                                                                                              | `{}`                             |
| `extraEnvVars`                                      | Array with extra environment variables to add to Sealed Secret nodes                                                                                                                                              | `[]`                             |
| `extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for Sealed Secret nodes                                                                                                                                      | `""`                             |
| `extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for Sealed Secret nodes                                                                                                                                         | `""`                             |
| `extraVolumes`                                      | Optionally specify extra list of additional volumes for the Sealed Secret pod(s)                                                                                                                                  | `[]`                             |
| `extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the Sealed Secret container(s)                                                                                                                       | `[]`                             |
| `sidecars`                                          | Add additional sidecar containers to the Sealed Secret pod(s)                                                                                                                                                     | `{}`                             |
| `initContainers`                                    | Add additional init containers to the Sealed Secret pod(s)                                                                                                                                                        | `{}`                             |

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

| Name                                          | Description                                                                                                                                                                                           | Value   |
| --------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `rbac.create`                                 | Specifies whether RBAC resources should be created                                                                                                                                                    | `true`  |
| `rbac.pspEnabled`                             | PodSecurityPolicy                                                                                                                                                                                     | `false` |
| `rbac.clusterRole`                            | Specifies whether the Cluster Role resource should be created. If both rbac.clusterRole and rbac.namespacedRoles are set to false no RBAC will be created.                                            | `true`  |
| `rbac.clusterRoleName`                        | Specifies the name for the Cluster Role resource                                                                                                                                                      | `""`    |
| `rbac.namespacedRoles`                        | Specifies whether the namespaced Roles should be created (in each of the specified additionalNamespaces). If both rbac.clusterRole and rbac.namespacedRoles are set to false no RBAC will be created. | `false` |
| `rbac.namespacedRolesName`                    | Specifies the name for the namesapced Role resource                                                                                                                                                   | `""`    |
| `rbac.unsealer.rules`                         | Custom RBAC rules to set for unsealer ClusterRole                                                                                                                                                     | `[]`    |
| `rbac.keyAdmin.rules`                         | Custom RBAC rules to set for key-admin role                                                                                                                                                           | `[]`    |
| `rbac.serviceProxier.rules`                   | Custom RBAC rules to set for service-proxier role                                                                                                                                                     | `[]`    |
| `rbac.labels`                                 | Extra labels to be added to RBAC resources                                                                                                                                                            | `{}`    |
| `serviceAccount.create`                       | Specifies whether a ServiceAccount should be created                                                                                                                                                  | `true`  |
| `serviceAccount.name`                         | The name of the ServiceAccount to use.                                                                                                                                                                | `""`    |
| `serviceAccount.annotations`                  | Additional Service Account annotations (evaluated as a template)                                                                                                                                      | `{}`    |
| `serviceAccount.automountServiceAccountToken` | Automount service account token for the server service account                                                                                                                                        | `false` |
| `networkPolicy.enabled`                       | Specifies whether a NetworkPolicy should be created                                                                                                                                                   | `false` |
| `networkPolicy.allowExternal`                 | Don't require client label for connections                                                                                                                                                            | `true`  |
| `pdb.create`                                  | Enable a Pod Disruption Budget creation                                                                                                                                                               | `true`  |
| `pdb.minAvailable`                            | Minimum number/percentage of pods that should remain scheduled                                                                                                                                        | `""`    |
| `pdb.maxUnavailable`                          | Maximum number/percentage of pods that may be made unavailable. Defaults to `1` if both `pdb.minAvailable` and `pdb.maxUnavailable` are empty.                                                        | `""`    |

### Metrics parameters

| Name                                       | Description                                                                      | Value       |
| ------------------------------------------ | -------------------------------------------------------------------------------- | ----------- |
| `metrics.enabled`                          | Sealed Secrets toggle metrics service definition                                 | `false`     |
| `metrics.service.type`                     | Sealed Secrets metrics service type                                              | `ClusterIP` |
| `metrics.service.ports.metrics`            | Sealed Secrets metrics service port                                              | `8081`      |
| `metrics.service.externalTrafficPolicy`    | Sealed Secrets metrics service external traffic policy                           | `Cluster`   |
| `metrics.service.extraPorts`               | Extra ports to expose (normally used with the `sidecar` value)                   | `[]`        |
| `metrics.service.loadBalancerIP`           | Sealed Secrets metrics service Load Balancer IP                                  | `""`        |
| `metrics.service.loadBalancerSourceRanges` | Sealed Secrets metrics service Load Balancer sources                             | `[]`        |
| `metrics.service.annotations`              | Additional custom annotations for Sealed Secrets metrics service                 | `{}`        |
| `metrics.serviceMonitor.enabled`           | Specify if a ServiceMonitor will be deployed for Prometheus Operator             | `false`     |
| `metrics.serviceMonitor.namespace`         | Namespace in which Prometheus is running                                         | `""`        |
| `metrics.serviceMonitor.port.number`       | Port number for the serviceMonitor                                               | `8081`      |
| `metrics.serviceMonitor.port.name`         | Port name for the serviceMonitor                                                 | `metrics`   |
| `metrics.serviceMonitor.labels`            | Extra labels for the ServiceMonitor                                              | `{}`        |
| `metrics.serviceMonitor.annotations`       | Additional ServiceMonitor annotations (evaluated as a template)                  | `{}`        |
| `metrics.serviceMonitor.jobLabel`          | The name of the label on the target service to use as the job name in Prometheus | `""`        |
| `metrics.serviceMonitor.honorLabels`       | honorLabels chooses the metric's labels on collisions with target labels         | `false`     |
| `metrics.serviceMonitor.interval`          | Interval at which metrics should be scraped.                                     | `""`        |
| `metrics.serviceMonitor.scrapeTimeout`     | Timeout after which the scrape is ended                                          | `""`        |
| `metrics.serviceMonitor.metricRelabelings` | Specify additional relabeling of metrics                                         | `[]`        |
| `metrics.serviceMonitor.relabelings`       | Specify general relabeling                                                       | `[]`        |
| `metrics.serviceMonitor.selector`          | Prometheus instance selector labels                                              | `{}`        |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
  --set livenessProbe.successThreshold=5 \
    oci://REGISTRY_NAME/REPOSITORY_NAME/sealed-secrets
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The above command sets the `livenessProbe.successThreshold` to `5`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml oci://REGISTRY_NAME/REPOSITORY_NAME/sealed-secrets
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.
> **Tip**: You can use the default [values.yaml](https://github.com/bitnami/charts/tree/main/bitnami/sealed-secrets/values.yaml)

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 2.0.0

This major bump changes the following security defaults:

- `resourcesPreset` is changed from `none` to the minimum size working in our test suites (NOTE: `resourcesPreset` is not meant for production usage, but `resources` adapted to your use case).
- `global.compatibility.openshift.adaptSecurityContext` is changed from `disabled` to `auto`.

This could potentially break any customization or init scripts used in your deployment. If this is the case, change the default values to the previous ones.

### To 1.0.0

This major release renames several values in this chart and adds missing features, in order to be aligned with the rest of the assets in the Bitnami charts repository.

- `service.port` has been renamed as `service.ports.http`.
- `service.nodePort`has been renamed as `service.nodePorts.http`
- `containerPort`has been renamed as `containerPorts.http`
- `certManager`has been removed. Please use `ingress.annotations` instead

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