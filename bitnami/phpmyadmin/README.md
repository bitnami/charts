<!--- app-name: phpMyAdmin -->

# Bitnami package for phpMyAdmin

phpMyAdmin is a free software tool written in PHP, intended to handle the administration of MySQL over the Web. phpMyAdmin supports a wide range of operations on MySQL and MariaDB.

[Overview of phpMyAdmin](https://www.phpmyadmin.net/)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/phpmyadmin
```

Looking to use phpMyAdmin in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the enterprise edition of Bitnami Application Catalog.

## Introduction

This chart bootstraps a [phpMyAdmin](https://github.com/bitnami/containers/tree/main/bitnami/phpmyadmin) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

As a portable web application written primarily in PHP, phpMyAdmin has become one of the most popular MySQL administration tools, especially for web hosting services.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/phpmyadmin
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The command deploys phpMyAdmin on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Configuration and installation details

### Resource requests and limits

Bitnami charts allow setting resource requests and limits for all containers inside the chart deployment. These are inside the `resources` value (check parameter table). Setting requests is essential for production workloads and these should be adapted to your specific use case.

To make this process easier, the chart contains the `resourcesPreset` values, which automatically sets the `resources` section according to different presets. Check these presets in [the bitnami/common chart](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15). However, in production workloads using `resourcePreset` is discouraged as it may not fully adapt to your specific needs. Find more information on container resource management in the [official Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).

### [Rolling VS Immutable tags](https://docs.vmware.com/en/VMware-Tanzu-Application-Catalog/services/tutorials/GUID-understand-rolling-tags-containers-index.html)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Ingress

This chart provides support for Ingress resources. If you have an ingress controller installed on your cluster, such as [nginx-ingress-controller](https://github.com/bitnami/charts/tree/main/bitnami/nginx-ingress-controller) or [contour](https://github.com/bitnami/charts/tree/main/bitnami/contour) you can utilize the ingress controller to serve your application.

To enable ingress integration, please set `ingress.enabled` to `true`.

#### Hosts

Most likely you will only want to have one hostname that maps to this phpMyAdmin installation. If that's your case, the property `ingress.hostname` will set it. However, it is possible to have more than one host. To facilitate this, the `ingress.extraHosts` object can be specified as an array. You can also use `ingress.extraTLS` to add the TLS configuration for extra hosts.

For each host indicated at `ingress.extraHosts`, please indicate a `name`, `path`, and any `annotations` that you may want the ingress controller to know about.

For annotations, please see [this document](https://github.com/kubernetes/ingress-nginx/blob/main/docs/user-guide/nginx-configuration/annotations.md). Not all annotations are supported by all ingress controllers, but this document does a good job of indicating which annotation is supported by many popular ingress controllers.

### TLS Secrets

This chart will facilitate the creation of TLS secrets for use with the ingress controller, however, this is not required. There are some common use cases:

- Helm generates and manages certificate secrets (default).
- User generates certificates and helm manages secrets.
- User generates and manages certificates separately.
- An additional tool (like [cert-manager](https://github.com/jetstack/cert-manager/)) manages the secrets for the application.

In the second case, a certificate and a key are needed. We would expect them to look like this:

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

If you are going to generate certificates yourself and want helm to manage the secret, please copy these values into the `certificate` and `key` values for a given `ingress.secrets` entry.

If you want to manage TLS secrets outside of Helm, please know that you can create a TLS secret and pass its name via the parameter `ingress.existingSecretName`.

To make use of cert-manager, you need to add the the `cert-manager.io/cluster-issuer:` annotation to the ingress object via `ingress.annotations`.

### Adding extra environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `extraEnvVars` property.

```yaml
extraEnvVars:
  - name: LOG_LEVEL
    value: DEBUG
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values.

### Sidecars and Init Containers

If you have a need for additional containers to run within the same pod as the PhpMyAdmin app (e.g. an additional metrics or logging exporter), you can do so via the `sidecars` config parameter. Simply define your container according to the Kubernetes container spec.

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

### Deploying extra resources

There are cases where you may want to deploy extra objects, such a ConfigMap containing your app's configuration or some extra deployment with a micro service used by your app. For covering this case, the chart allows adding the full specification of other objects using the `extraDeploy` parameter.

### Setting Pod's affinity

This chart allows you to set your custom affinity using the `XXX.affinity` parameter(s). Find more information about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `XpodAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

## Parameters

### Global parameters

| Name                                                  | Description                                                                                                                                                                                                                                                                                                                                                         | Value      |
| ----------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------- |
| `global.imageRegistry`                                | Global Docker image registry                                                                                                                                                                                                                                                                                                                                        | `""`       |
| `global.imagePullSecrets`                             | Global Docker registry secret names as an array                                                                                                                                                                                                                                                                                                                     | `[]`       |
| `global.compatibility.openshift.adaptSecurityContext` | Adapt the securityContext sections of the deployment to make them compatible with Openshift restricted-v2 SCC: remove runAsUser, runAsGroup and fsGroup and let the platform use their allowed default IDs. Possible values: auto (apply if the detected running cluster is Openshift), force (perform the adaptation always), disabled (do not perform adaptation) | `disabled` |

### Common parameters

| Name                | Description                                                                                  | Value           |
| ------------------- | -------------------------------------------------------------------------------------------- | --------------- |
| `kubeVersion`       | Force target Kubernetes version (using Helm capabilities if not set)                         | `""`            |
| `nameOverride`      | String to partially override common.names.fullname template (will maintain the release name) | `""`            |
| `fullnameOverride`  | String to fully override common.names.fullname template                                      | `""`            |
| `commonLabels`      | Add labels to all the deployed resources                                                     | `{}`            |
| `commonAnnotations` | Add annotations to all the deployed resources                                                | `{}`            |
| `clusterDomain`     | Kubernetes Cluster Domain                                                                    | `cluster.local` |
| `extraDeploy`       | Array of extra objects to deploy with the release                                            | `[]`            |

### phpMyAdmin parameters

| Name                 | Description                                                                                                | Value                        |
| -------------------- | ---------------------------------------------------------------------------------------------------------- | ---------------------------- |
| `image.registry`     | phpMyAdmin image registry                                                                                  | `REGISTRY_NAME`              |
| `image.repository`   | phpMyAdmin image repository                                                                                | `REPOSITORY_NAME/phpmyadmin` |
| `image.digest`       | phpMyAdmin image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag | `""`                         |
| `image.pullPolicy`   | Image pull policy                                                                                          | `IfNotPresent`               |
| `image.pullSecrets`  | Specify docker-registry secret names as an array                                                           | `[]`                         |
| `image.debug`        | Enable phpmyadmin image debug mode                                                                         | `false`                      |
| `command`            | Override default container command (useful when using custom images)                                       | `[]`                         |
| `args`               | Override default container args (useful when using custom images)                                          | `[]`                         |
| `lifecycleHooks`     | for the phpmyadmin container(s) to automate configuration before or after startup                          | `{}`                         |
| `extraEnvVars`       | Extra environment variables to be set on PhpMyAdmin container                                              | `[]`                         |
| `extraEnvVarsCM`     | Name of a existing ConfigMap containing extra env vars                                                     | `""`                         |
| `extraEnvVarsSecret` | Name of a existing Secret containing extra env vars                                                        | `""`                         |

### phpMyAdmin deployment parameters

| Name                                                | Description                                                                                                                                                                                                       | Value            |
| --------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| `automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                | `false`          |
| `hostAliases`                                       | Deployment pod host aliases                                                                                                                                                                                       | `[]`             |
| `containerPorts.http`                               | HTTP port to expose at container level                                                                                                                                                                            | `8080`           |
| `containerPorts.https`                              | HTTPS port to expose at container level                                                                                                                                                                           | `8443`           |
| `extraContainerPorts`                               | Optionally specify extra list of additional ports for phpMyAdmin container(s)                                                                                                                                     | `[]`             |
| `updateStrategy.type`                               | Strategy to use to update Pods                                                                                                                                                                                    | `RollingUpdate`  |
| `podSecurityContext.enabled`                        | Enable phpMyAdmin pods' Security Context                                                                                                                                                                          | `true`           |
| `podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                | `Always`         |
| `podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                    | `[]`             |
| `podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                       | `[]`             |
| `podSecurityContext.fsGroup`                        | User ID for the container                                                                                                                                                                                         | `1001`           |
| `containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                                                                                                                              | `true`           |
| `containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                  | `nil`            |
| `containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                                                                                                        | `1001`           |
| `containerSecurityContext.runAsGroup`               | Set containers' Security Context runAsGroup                                                                                                                                                                       | `1001`           |
| `containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                                                                                                                     | `true`           |
| `containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                                                                                                                       | `false`          |
| `containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                           | `true`           |
| `containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                                                                                                         | `false`          |
| `containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                | `["ALL"]`        |
| `containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                  | `RuntimeDefault` |
| `replicas`                                          | Number of replicas                                                                                                                                                                                                | `1`              |
| `resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if resources is set (resources is recommended for production). | `micro`          |
| `resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                 | `{}`             |
| `startupProbe.enabled`                              | Enable startupProbe                                                                                                                                                                                               | `false`          |
| `startupProbe.httpGet.path`                         | Request path for startupProbe                                                                                                                                                                                     | `/`              |
| `startupProbe.httpGet.port`                         | Port for startupProbe                                                                                                                                                                                             | `http`           |
| `startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                            | `30`             |
| `startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                   | `10`             |
| `startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                  | `30`             |
| `startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                | `6`              |
| `startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                | `1`              |
| `livenessProbe.enabled`                             | Enable livenessProbe                                                                                                                                                                                              | `true`           |
| `livenessProbe.tcpSocket.port`                      | Port for livenessProbe                                                                                                                                                                                            | `http`           |
| `livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                           | `30`             |
| `livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                  | `10`             |
| `livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                 | `30`             |
| `livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                               | `6`              |
| `livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                               | `1`              |
| `readinessProbe.enabled`                            | Enable readinessProbe                                                                                                                                                                                             | `true`           |
| `readinessProbe.httpGet.path`                       | Request path for readinessProbe                                                                                                                                                                                   | `/`              |
| `readinessProbe.httpGet.port`                       | Port for readinessProbe                                                                                                                                                                                           | `http`           |
| `readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                          | `30`             |
| `readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                 | `10`             |
| `readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                | `30`             |
| `readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                              | `6`              |
| `readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                              | `1`              |
| `customStartupProbe`                                | Override default startup probe                                                                                                                                                                                    | `{}`             |
| `customLivenessProbe`                               | Override default liveness probe                                                                                                                                                                                   | `{}`             |
| `customReadinessProbe`                              | Override default readiness probe                                                                                                                                                                                  | `{}`             |
| `podLabels`                                         | Extra labels for PhpMyAdmin pods                                                                                                                                                                                  | `{}`             |
| `podAnnotations`                                    | Annotations for PhpMyAdmin pods                                                                                                                                                                                   | `{}`             |
| `podAffinityPreset`                                 | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                               | `""`             |
| `podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                          | `soft`           |
| `nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                         | `""`             |
| `nodeAffinityPreset.key`                            | Node label key to match. Ignored if `affinity` is set.                                                                                                                                                            | `""`             |
| `nodeAffinityPreset.values`                         | Node label values to match. Ignored if `affinity` is set.                                                                                                                                                         | `[]`             |
| `affinity`                                          | Affinity for pod assignment. Evaluated as a template.                                                                                                                                                             | `{}`             |
| `nodeSelector`                                      | Node labels for pod assignment. Evaluated as a template.                                                                                                                                                          | `{}`             |
| `tolerations`                                       | Tolerations for pod assignment. Evaluated as a template.                                                                                                                                                          | `[]`             |
| `priorityClassName`                                 | phpmyadmin pods' priorityClassName                                                                                                                                                                                | `""`             |
| `schedulerName`                                     | Name of the k8s scheduler (other than default)                                                                                                                                                                    | `""`             |
| `topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment                                                                                                                                                                    | `[]`             |
| `extraVolumes`                                      | Optionally specify extra list of additional volumes for PhpMyAdmin pods                                                                                                                                           | `[]`             |
| `extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for PhpMyAdmin container(s)                                                                                                                              | `[]`             |
| `initContainers`                                    | Add init containers to the PhpMyAdmin pods                                                                                                                                                                        | `[]`             |
| `sidecars`                                          | Add sidecar containers to the PhpMyAdmin pods                                                                                                                                                                     | `[]`             |

### Traffic Exposure parameters

| Name                               | Description                                                                                                                      | Value                    |
| ---------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `service.type`                     | Kubernetes Service type                                                                                                          | `ClusterIP`              |
| `service.ports.http`               | Service HTTP port                                                                                                                | `80`                     |
| `service.ports.https`              | Service HTTPS port                                                                                                               | `443`                    |
| `service.nodePorts.http`           | Kubernetes http node port                                                                                                        | `""`                     |
| `service.nodePorts.https`          | Kubernetes https node port                                                                                                       | `""`                     |
| `service.clusterIP`                | PhpMyAdmin service clusterIP IP                                                                                                  | `""`                     |
| `service.loadBalancerIP`           | Load balancer IP for the phpMyAdmin Service (optional, cloud specific)                                                           | `""`                     |
| `service.loadBalancerSourceRanges` | Addresses that are allowed when service is LoadBalancer                                                                          | `[]`                     |
| `service.externalTrafficPolicy`    | Enable client source IP preservation                                                                                             | `Cluster`                |
| `service.extraPorts`               | Extra ports to expose (normally used with the `sidecar` value)                                                                   | `[]`                     |
| `service.annotations`              | Provide any additional annotations that may be required for the PhpMyAdmin service                                               | `{}`                     |
| `service.sessionAffinity`          | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                                                             | `None`                   |
| `service.sessionAffinityConfig`    | Additional settings for the sessionAffinity                                                                                      | `{}`                     |
| `ingress.enabled`                  | Set to true to enable ingress record generation                                                                                  | `false`                  |
| `ingress.apiVersion`               | Force Ingress API version (automatically detected if not set)                                                                    | `""`                     |
| `ingress.hostname`                 | When the ingress is enabled, a host pointing to this will be created                                                             | `phpmyadmin.local`       |
| `ingress.pathType`                 | Ingress path type                                                                                                                | `ImplementationSpecific` |
| `ingress.path`                     | Default path for the ingress record                                                                                              | `/`                      |
| `ingress.extraPaths`               | An array with additional arbitrary paths that may need to be added to the ingress under the main host                            | `[]`                     |
| `ingress.annotations`              | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                     |
| `ingress.tls`                      | Enable TLS configuration for the hostname defined at `ingress.hostname` parameter                                                | `false`                  |
| `ingress.extraHosts`               | The list of additional hostnames to be covered with this ingress record.                                                         | `[]`                     |
| `ingress.extraTls`                 | The tls configuration for additional hostnames to be covered with this ingress record.                                           | `[]`                     |
| `ingress.secrets`                  | If you're providing your own certificates and want to manage the secret via helm,                                                | `[]`                     |
| `ingress.existingSecretName`       | If you're providing your own certificate and want to manage the secret yourself,                                                 | `""`                     |
| `ingress.ingressClassName`         | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                    | `""`                     |
| `ingress.extraRules`               | Additional rules to be covered with this ingress record                                                                          | `[]`                     |

### Database parameters

| Name                       | Description                                                       | Value   |
| -------------------------- | ----------------------------------------------------------------- | ------- |
| `db.allowArbitraryServer`  | Enable connection to arbitrary MySQL server                       | `true`  |
| `db.port`                  | Database port to use to connect                                   | `3306`  |
| `db.chartName`             | Database suffix if included in the same release                   | `""`    |
| `db.host`                  | Database Hostname. Ignored when `db.chartName` is set.            | `""`    |
| `db.bundleTestDB`          | Deploy a MariaDB instance for testing purposes                    | `false` |
| `db.enableSsl`             | Enable SSL for the connection between phpMyAdmin and the database | `false` |
| `db.ssl.clientKey`         | Client key file when using SSL                                    | `""`    |
| `db.ssl.clientCertificate` | Client certificate file when using SSL                            | `""`    |
| `db.ssl.caCertificate`     | CA file when using SSL                                            | `""`    |
| `db.ssl.ciphers`           | List of allowable ciphers for connections when using SSL          | `[]`    |
| `db.ssl.verify`            | Enable SSL certificate validation                                 | `true`  |
| `mariadb`                  | MariaDB chart configuration                                       | `{}`    |

### Other Parameters

| Name                                          | Description                                                            | Value   |
| --------------------------------------------- | ---------------------------------------------------------------------- | ------- |
| `serviceAccount.create`                       | Enable creation of ServiceAccount for PhpMyAdmin pod                   | `true`  |
| `serviceAccount.name`                         | The name of the ServiceAccount to use.                                 | `""`    |
| `serviceAccount.automountServiceAccountToken` | Allows auto mount of ServiceAccountToken on the serviceAccount created | `false` |
| `serviceAccount.annotations`                  | Additional custom annotations for the ServiceAccount                   | `{}`    |

### Metrics parameters

| Name                                       | Description                                                                                                                                                                                                                       | Value                             |
| ------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------- |
| `metrics.enabled`                          | Start a side-car prometheus exporter                                                                                                                                                                                              | `false`                           |
| `metrics.image.registry`                   | Apache exporter image registry                                                                                                                                                                                                    | `REGISTRY_NAME`                   |
| `metrics.image.repository`                 | Apache exporter image repository                                                                                                                                                                                                  | `REPOSITORY_NAME/apache-exporter` |
| `metrics.image.digest`                     | Apache exporter image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                   | `""`                              |
| `metrics.image.pullPolicy`                 | Image pull policy                                                                                                                                                                                                                 | `IfNotPresent`                    |
| `metrics.image.pullSecrets`                | Specify docker-registry secret names as an array                                                                                                                                                                                  | `[]`                              |
| `metrics.resourcesPreset`                  | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if metrics.resources is set (metrics.resources is recommended for production). | `nano`                            |
| `metrics.resources`                        | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                 | `{}`                              |
| `metrics.service.type`                     | Prometheus metrics service type                                                                                                                                                                                                   | `ClusterIP`                       |
| `metrics.service.port`                     | Prometheus metrics service port                                                                                                                                                                                                   | `9117`                            |
| `metrics.service.annotations`              | Annotations for Prometheus metrics service                                                                                                                                                                                        | `{}`                              |
| `metrics.service.clusterIP`                | phpmyadmin service Cluster IP                                                                                                                                                                                                     | `""`                              |
| `metrics.service.loadBalancerIP`           | Load Balancer IP if the Prometheus metrics server type is `LoadBalancer`                                                                                                                                                          | `""`                              |
| `metrics.service.loadBalancerSourceRanges` | phpmyadmin service Load Balancer sources                                                                                                                                                                                          | `[]`                              |
| `metrics.service.externalTrafficPolicy`    | phpmyadmin service external traffic policy                                                                                                                                                                                        | `Cluster`                         |
| `metrics.service.sessionAffinity`          | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                                                                                                                                                              | `None`                            |
| `metrics.service.sessionAffinityConfig`    | Additional settings for the sessionAffinity                                                                                                                                                                                       | `{}`                              |
| `metrics.serviceMonitor.enabled`           | Create ServiceMonitor Resource for scraping metrics using PrometheusOperator                                                                                                                                                      | `false`                           |
| `metrics.serviceMonitor.namespace`         | Specify the namespace in which the serviceMonitor resource will be created                                                                                                                                                        | `""`                              |
| `metrics.serviceMonitor.jobLabel`          | The name of the label on the target service to use as the job name in prometheus.                                                                                                                                                 | `""`                              |
| `metrics.serviceMonitor.interval`          | Specify the interval at which metrics should be scraped                                                                                                                                                                           | `30s`                             |
| `metrics.serviceMonitor.scrapeTimeout`     | Specify the timeout after which the scrape is ended                                                                                                                                                                               | `""`                              |
| `metrics.serviceMonitor.relabelings`       | RelabelConfigs to apply to samples before scraping                                                                                                                                                                                | `[]`                              |
| `metrics.serviceMonitor.metricRelabelings` | Specify Metric Relabelings to add to the scrape endpoint                                                                                                                                                                          | `[]`                              |
| `metrics.serviceMonitor.labels`            | Extra labels for the ServiceMonitor                                                                                                                                                                                               | `{}`                              |
| `metrics.serviceMonitor.honorLabels`       | Specify honorLabels parameter to add the scrape endpoint                                                                                                                                                                          | `false`                           |
| `metrics.serviceMonitor.selector`          | ServiceMonitor selector labels                                                                                                                                                                                                    | `{}`                              |

### NetworkPolicy parameters

| Name                                    | Description                                                     | Value  |
| --------------------------------------- | --------------------------------------------------------------- | ------ |
| `networkPolicy.enabled`                 | Specifies whether a NetworkPolicy should be created             | `true` |
| `networkPolicy.allowExternal`           | Don't require server label for connections                      | `true` |
| `networkPolicy.allowExternalEgress`     | Allow the pod to access any range of port and all destinations. | `true` |
| `networkPolicy.extraIngress`            | Add extra ingress rules to the NetworkPolicy                    | `[]`   |
| `networkPolicy.extraEgress`             | Add extra ingress rules to the NetworkPolicy                    | `[]`   |
| `networkPolicy.ingressNSMatchLabels`    | Labels to match to allow traffic from other namespaces          | `{}`   |
| `networkPolicy.ingressNSPodMatchLabels` | Pod labels to match to allow traffic from other namespaces      | `{}`   |

For more information please refer to the [bitnami/phpmyadmin](https://github.com/bitnami/containers/tree/main/bitnami/phpmyadmin) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
  --set db.host=mymariadb,db.port=3306 oci://REGISTRY_NAME/REPOSITORY_NAME/phpmyadmin
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The above command sets the phpMyAdmin to connect to a database in `mymariadb` host and `3306` port respectively.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml oci://REGISTRY_NAME/REPOSITORY_NAME/phpmyadmin
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.
> **Tip**: You can use the default [values.yaml](https://github.com/bitnami/charts/tree/main/bitnami/phpmyadmin/values.yaml)

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 16.0.0

This major bump changes the following security defaults:

- `runAsGroup` is changed from `0` to `1001`
- `readOnlyRootFilesystem` is set to `true`
- `resourcesPreset` is changed from `none` to the minimum size working in our test suites (NOTE: `resourcesPreset` is not meant for production usage, but `resources` adapted to your use case).
- `global.compatibility.openshift.adaptSecurityContext` is changed from `disabled` to `auto`.
- The `networkPolicy` section has been normalized amongst all Bitnami charts. Compared to the previous approach, the values section has been simplified (check the Parameters section) and now it set to `enabled=true` by default. Egress traffic is allowed by default and ingress traffic is allowed by all pods but only to the ports set in `containerPorts` and `extraContainerPorts`.

This could potentially break any customization or init scripts used in your deployment. If this is the case, change the default values to the previous ones.

### To 15.0.0

This major release bumps the MariaDB chart version to [18.x.x](https://github.com/bitnami/charts/pull/24804); no major issues are expected during the upgrade.

### To 14.0.0

This major release bumps the MariaDB version to 11.2. No major issues are expected during the upgrade.

### To 13.0.0

This major release bumps the MariaDB version to 11.1. No major issues are expected during the upgrade.

### To 12.0.0

This major release bumps the MariaDB version to 11.0. Follow the [upstream instructions](https://mariadb.com/kb/en/upgrading-from-mariadb-10-11-to-mariadb-11-0/) for upgrading from MariaDB 10.11 to 11.0. No major issues are expected during the upgrade.

### To 11.0.0

This major release bumps the MariaDB version to 10.11. Follow the [upstream instructions](https://mariadb.com/kb/en/upgrading-from-mariadb-10-6-to-mariadb-10-11/) for upgrading from MariaDB 10.6 to 10.11. No major issues are expected during the upgrade.

### To 10.0.0

This major release bumps the MariaDB version to 10.6. Follow the [upstream instructions](https://mariadb.com/kb/en/upgrading-from-mariadb-105-to-mariadb-106/) for upgrading from MariaDB 10.5 to 10.6. No major issues are expected during the upgrade.

### To 9.0.0

This major release renames several values in this chart and adds missing features, in order to be inline with the rest of assets in the Bitnami charts repository.

Affected values:

- `service.port` was deprecated. We recommend using `service.ports.http` instead.
- `service.httpsPort` was deprecated. We recommend using `service.ports.https` instead.
- `metrics.serviceMonitor.additionalLabels` renamed as `metrics.serviceMonitor.labels`

Additionally updates the MariaDB subchart to it newest major, 10.0.0, which contains similar changes. Check [MariaDB Upgrading Notes](https://github.com/bitnami/charts/tree/main/bitnami/mariadb#to-1000) for more information.

### To 8.0.0

- Chart labels were adapted to follow the [Helm charts standard labels](https://helm.sh/docs/chart_best_practices/labels/#standard-labels).

Consequences:

- Backwards compatibility is not guaranteed. However, you can easily workaround this issue by removing PhpMyAdmin deployment before upgrading (the following example assumes that the release name is `phpmyadmin`):

```console
export MARIADB_ROOT_PASSWORD=$(kubectl get secret --namespace default phpmyadmin-mariadb -o jsonpath="{.data.mariadb-root-password}" | base64 -d)
export MARIADB_PASSWORD=$(kubectl get secret --namespace default phpmyadmin-mariadb -o jsonpath="{.data.mariadb-password}" | base64 -d)
kubectl delete deployments.apps phpmyadmin
helm upgrade phpmyadmin oci://REGISTRY_NAME/REPOSITORY_NAME/phpmyadmin --set mariadb.auth.rootPassword=$MARIADB_ROOT_PASSWORD,mariadb.auth.password=$MARIADB_PASSWORD
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

### To 7.0.0

In this major there were two main changes introduced:

1. Adaptation to Helm v2 EOL
2. Updated MariaDB dependency version

Please read the update notes carefully.

#### 1. Adaptation to Helm v2 EOL

[On November 13, 2020, Helm v2 support was formally finished](https://github.com/helm/charts#status-of-the-project), this major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

##### What changes were introduced in this major version?

- Previous versions of this Helm Chart use `apiVersion: v1` (installable by both Helm 2 and 3), this Helm Chart was updated to `apiVersion: v2` (installable by Helm 3 only). [Here](https://helm.sh/docs/topics/charts/#the-apiversion-field) you can find more information about the `apiVersion` field.
- Move dependency information from the *requirements.yaml* to the *Chart.yaml*
- After running `helm dependency update`, a *Chart.lock* file is generated containing the same structure used in the previous *requirements.lock*
- The different fields present in the *Chart.yaml* file has been ordered alphabetically in a homogeneous way for all the Bitnami Helm Charts

##### Considerations when upgrading to this version

- If you want to upgrade to this version from a previous one installed with Helm v3, you shouldn't face any issues
- If you want to upgrade to this version using Helm v2, this scenario is not supported as this version doesn't support Helm v2 anymore
- If you installed the previous version with Helm v2 and wants to upgrade to this version with Helm v3, please refer to the [official Helm documentation](https://helm.sh/docs/topics/v2_v3_migration/#migration-use-cases) about migrating from Helm v2 to v3

##### Useful links

- <https://docs.vmware.com/en/VMware-Tanzu-Application-Catalog/services/tutorials/GUID-resolve-helm2-helm3-post-migration-issues-index.html>
- <https://helm.sh/docs/topics/v2_v3_migration/>
- <https://helm.sh/blog/migrate-from-helm-v2-to-helm-v3/>

#### 2. Updated MariaDB dependency version

In this major the MariaDB dependency version was also bumped to a new major version that introduces several incompatilibites. Therefore, backwards compatibility is not guaranteed unless an external database is used. Check [MariaDB Upgrading Notes](https://github.com/bitnami/charts/tree/main/bitnami/mariadb#to-800) for more information.

To upgrade to `7.0.0`, it should be done reusing the PVCs used to hold both the MariaDB and phpMyAdmin data on your previous release. To do so, follow the instructions below (the following example assumes that the release name is `phpmyadmin` and that `db.bundleTestDB=true` when the chart was first installed):

> NOTE: Please, create a backup of your database before running any of those actions. The steps below would be only valid if your application (e.g. any plugins or custom code) is compatible with MariaDB 10.5.x

Obtain the credentials and the names of the PVCs used to hold both the MariaDB and phpMyAdmin data on your current release:

```console
export MARIADB_ROOT_PASSWORD=$(kubectl get secret --namespace default phpmyadmin-mariadb -o jsonpath="{.data.mariadb-root-password}" | base64 -d)
export MARIADB_PASSWORD=$(kubectl get secret --namespace default phpmyadmin-mariadb -o jsonpath="{.data.mariadb-password}" | base64 -d)
export MARIADB_PVC=$(kubectl get pvc -l app=mariadb,component=master,release=phpmyadmin -o jsonpath="{.items[0].metadata.name}")
```

Delete the phpMyAdmin deployment and delete the MariaDB statefulsets:

```console
  kubectl delete deployments.apps phpmyadmin

  kubectl delete statefulsets.apps phpmyadmin-mariadb-master

  kubectl delete statefulsets.apps phpmyadmin-mariadb-slave

```

Now the upgrade works:

```console
helm upgrade phpmyadmin oci://REGISTRY_NAME/REPOSITORY_NAME/phpmyadmin --set mariadb.primary.persistence.existingClaim=$MARIADB_PVC --set mariadb.auth.rootPassword=$MARIADB_ROOT_PASSWORD --set mariadb.auth.password=$MARIADB_PASSWORD --set db.bundleTestDB=true
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

Finally, you should see the lines below in MariaDB container logs:

```console
$ kubectl logs $(kubectl get pods -l app.kubernetes.io/instance=phpmyadmin,app.kubernetes.io/name=mariadb,app.kubernetes.io/component=primary -o jsonpath="{.items[0].metadata.name}")
...
mariadb 12:13:24.98 INFO  ==> Using persisted data
mariadb 12:13:25.01 INFO  ==> Running mysql_upgrade
...
```

### To 6.0.0

The [Bitnami phpMyAdmin](https://github.com/bitnami/containers/tree/main/bitnami/phpmyadmin) image was migrated to a "non-root" user approach. Previously the container ran as the `root` user and the Apache daemon was started as the `daemon` user. From now on, both the container and the Apache daemon run as user `1001`. You can revert this behavior by setting the parameters `containerSecurityContext.runAsUser` to `root`.
Chart labels and Ingress configuration were also adapted to follow the Helm charts best practices.

Consequences:

- The HTTP/HTTPS ports exposed by the container are now `8080/8443` instead of `80/443`.
- No writing permissions will be granted on `config.inc.php` by default.
- Backwards compatibility is not guaranteed.

To upgrade to `6.0.0`, backup your previous MariaDB databases, install a new phpMyAdmin chart and import the MariaDB backups.

This version also introduces `bitnami/common`, a [library chart](https://helm.sh/docs/topics/library_charts/#helm) as a dependency. More documentation about this new utility could be found [here](https://github.com/bitnami/charts/tree/main/bitnami/common#bitnami-common-library-chart). Please, make sure that you have updated the chart dependencies before executing any upgrade.

### To 1.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to `1.0.0`. The following example assumes that the release name is `phpmyadmin`:

```console
kubectl patch deployment phpmyadmin-phpmyadmin --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
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