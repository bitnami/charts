<!--- app-name: Supabase -->

# Bitnami package for Supabase

Supabase is an open source Firebase alternative. Provides all the necessary backend features to build your application in a scalable way. Uses PostgreSQL as datastore.

[Overview of Supabase](https://supabase.com/)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/supabase
```

Looking to use Supabase in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the enterprise edition of Bitnami Application Catalog.

## Introduction

Bitnami charts for Helm are carefully engineered, actively maintained and are the quickest and easiest way to deploy containers on a Kubernetes cluster that are ready to handle production workloads.

This chart bootstraps a [Supabase](https://www.supabase.com/) deployment in a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.
Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+
- PV provisioner support in the underlying infrastructure
- ReadWriteMany volumes for deployment scaling

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/supabase
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The command deploys Supabase on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Configuration and installation details

### Resource requests and limits

Bitnami charts allow setting resource requests and limits for all containers inside the chart deployment. These are inside the `resources` value (check parameter table). Setting requests is essential for production workloads and these should be adapted to your specific use case.

To make this process easier, the chart contains the `resourcesPreset` values, which automatically sets the `resources` section according to different presets. Check these presets in [the bitnami/common chart](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15). However, in production workloads using `resourcePreset` is discouraged as it may not fully adapt to your specific needs. Find more information on container resource management in the [official Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).

### [Rolling VS Immutable tags](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### External database support

You may want to have supabase connect to an external database rather than installing one inside your cluster. Typical reasons for this are to use a managed database service, or to share a common database server for all your applications. To achieve this, the chart allows you to specify credentials for an external database with the [`externalDatabase` parameter](#parameters). You should also disable the PostgreSQL installation with the `postgresql.enabled` option. Here is an example:

```console
postgresql.enabled=false
externalDatabase.host=myexternalhost
externalDatabase.user=myuser
externalDatabase.password=mypassword
externalDatabase.database=mydatabase
externalDatabase.port=5432
```

### Ingress

This chart provides support for Ingress resources. If you have an ingress controller installed on your cluster, such as [nginx-ingress-controller](https://github.com/bitnami/charts/tree/main/bitnami/nginx-ingress-controller) or [contour](https://github.com/bitnami/charts/tree/main/bitnami/contour) you can utilize the ingress controller to serve your application.To enable Ingress integration, set `studio.ingress.enabled` to `true`.

The most common scenario is to have one host name mapped to the deployment. In this case, the `studio.ingress.hostname` property can be used to set the host name. The `studio.ingress.tls` parameter can be used to add the TLS configuration for this host.

However, it is also possible to have more than one host. To facilitate this, the `studio.ingress.extraHosts` parameter (if available) can be set with the host names specified as an array. The `studio.ingress.extraTLS` parameter (if available) can also be used to add the TLS configuration for extra hosts.

> NOTE: For each host specified in the `studio.ingress.extraHosts` parameter, it is necessary to set a name, path, and any annotations that the Ingress controller should know about. Not all annotations are supported by all Ingress controllers, but [this annotation reference document](https://github.com/kubernetes/ingress-nginx/blob/master/docs/user-guide/nginx-configuration/annotations.md) lists the annotations supported by many popular Ingress controllers.

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

### Additional environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `extraEnvVars` property inside the different component sections.

```yaml
rest:
  extraEnvVars:
    - name: LOG_LEVEL
      value: error
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values inside the specific component sections.

### Sidecars

If additional containers are needed in the same pod as supabase (such as additional metrics or logging exporters), they can be defined using the `sidecars` parameter inside the component specific sections.

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

As an alternative, use one of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters inside the specific component sections.

## Persistence

The chart mounts a [Persistent Volume](https://kubernetes.io/docs/concepts/storage/persistent-volumes/) volume at `/bitnami/supabase-storage`. The volume is created using dynamic volume provisioning, by default. An existing PersistentVolumeClaim can also be defined.

If you encounter errors when working with persistent volumes, refer to our [troubleshooting guide for persistent volumes](https://docs.bitnami.com/kubernetes/faq/troubleshooting/troubleshooting-persistence-volumes/).

## Parameters

### Global parameters

| Name                                                  | Description                                                                                                                                                                                                                                                                                                                                                         | Value         |
| ----------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------- |
| `global.imageRegistry`                                | Global Docker image registry                                                                                                                                                                                                                                                                                                                                        | `""`          |
| `global.imagePullSecrets`                             | Global Docker registry secret names as an array                                                                                                                                                                                                                                                                                                                     | `[]`          |
| `global.storageClass`                                 | Global StorageClass for Persistent Volume(s)                                                                                                                                                                                                                                                                                                                        | `""`          |
| `global.jwt.existingSecret`                           | The name of the existing secret containing the JWT secret                                                                                                                                                                                                                                                                                                           | `""`          |
| `global.jwt.existingSecretKey`                        | The key in the existing secret containing the JWT secret                                                                                                                                                                                                                                                                                                            | `secret`      |
| `global.jwt.existingSecretAnonKey`                    | The key in the existing secret containing the JWT anon key                                                                                                                                                                                                                                                                                                          | `anon-key`    |
| `global.jwt.existingSecretServiceKey`                 | The key in the existing secret containing the JWT service key                                                                                                                                                                                                                                                                                                       | `service-key` |
| `global.compatibility.openshift.adaptSecurityContext` | Adapt the securityContext sections of the deployment to make them compatible with Openshift restricted-v2 SCC: remove runAsUser, runAsGroup and fsGroup and let the platform use their allowed default IDs. Possible values: auto (apply if the detected running cluster is Openshift), force (perform the adaptation always), disabled (do not perform adaptation) | `auto`        |

### Common parameters

| Name                     | Description                                                                             | Value           |
| ------------------------ | --------------------------------------------------------------------------------------- | --------------- |
| `kubeVersion`            | Override Kubernetes version                                                             | `""`            |
| `nameOverride`           | String to partially override common.names.name                                          | `""`            |
| `fullnameOverride`       | String to fully override common.names.fullname                                          | `""`            |
| `namespaceOverride`      | String to fully override common.names.namespace                                         | `""`            |
| `commonLabels`           | Labels to add to all deployed objects                                                   | `{}`            |
| `commonAnnotations`      | Annotations to add to all deployed objects                                              | `{}`            |
| `clusterDomain`          | Kubernetes cluster domain name                                                          | `cluster.local` |
| `extraDeploy`            | Array of extra objects to deploy with the release                                       | `[]`            |
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden) | `false`         |
| `diagnosticMode.command` | Command to override all containers in the deployment                                    | `["sleep"]`     |
| `diagnosticMode.args`    | Args to override all containers in the deployment                                       | `["infinity"]`  |

### Supabase Common parameters

| Name                                                                 | Description                                                                                                                                                                                                                                         | Value                     |
| -------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------- |
| `jwt.secret`                                                         | The secret string used to sign JWT tokens                                                                                                                                                                                                           | `""`                      |
| `jwt.anonKey`                                                        | JWT string for annonymous users                                                                                                                                                                                                                     | `""`                      |
| `jwt.serviceKey`                                                     | JWT string for service users                                                                                                                                                                                                                        | `""`                      |
| `jwt.autoGenerate.forceRun`                                          | Force the run of the JWT generation job                                                                                                                                                                                                             | `false`                   |
| `jwt.autoGenerate.image.registry`                                    | JWT CLI image registry                                                                                                                                                                                                                              | `REGISTRY_NAME`           |
| `jwt.autoGenerate.image.repository`                                  | JWT CLI image repository                                                                                                                                                                                                                            | `REPOSITORY_NAME/jwt-cli` |
| `jwt.autoGenerate.image.digest`                                      | JWT CLI image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag image tag (immutable tags are recommended)                                                                                                  | `""`                      |
| `jwt.autoGenerate.image.pullPolicy`                                  | JWT CLI image pull policy                                                                                                                                                                                                                           | `IfNotPresent`            |
| `jwt.autoGenerate.image.pullSecrets`                                 | JWT CLI image pull secrets                                                                                                                                                                                                                          | `[]`                      |
| `jwt.autoGenerate.kubectlImage.registry`                             | Kubectl image registry                                                                                                                                                                                                                              | `REGISTRY_NAME`           |
| `jwt.autoGenerate.kubectlImage.repository`                           | Kubectl image repository                                                                                                                                                                                                                            | `REPOSITORY_NAME/kubectl` |
| `jwt.autoGenerate.kubectlImage.digest`                               | Kubectl image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                                             | `""`                      |
| `jwt.autoGenerate.kubectlImage.pullPolicy`                           | Kubectl image pull policy                                                                                                                                                                                                                           | `IfNotPresent`            |
| `jwt.autoGenerate.kubectlImage.pullSecrets`                          | Kubectl image pull secrets                                                                                                                                                                                                                          | `[]`                      |
| `jwt.autoGenerate.backoffLimit`                                      | set backoff limit of the job                                                                                                                                                                                                                        | `10`                      |
| `jwt.autoGenerate.extraVolumes`                                      | Optionally specify extra list of additional volumes for the jwt init job                                                                                                                                                                            | `[]`                      |
| `jwt.autoGenerate.livenessProbe.enabled`                             | Enable livenessProbe on Supabase auth containers                                                                                                                                                                                                    | `true`                    |
| `jwt.autoGenerate.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                                                             | `5`                       |
| `jwt.autoGenerate.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                                                    | `10`                      |
| `jwt.autoGenerate.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                                                   | `5`                       |
| `jwt.autoGenerate.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                                                                 | `6`                       |
| `jwt.autoGenerate.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                                                                 | `1`                       |
| `jwt.autoGenerate.readinessProbe.enabled`                            | Enable readinessProbe on Supabase auth containers                                                                                                                                                                                                   | `true`                    |
| `jwt.autoGenerate.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                                                            | `5`                       |
| `jwt.autoGenerate.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                                                   | `10`                      |
| `jwt.autoGenerate.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                                                  | `5`                       |
| `jwt.autoGenerate.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                                                                | `6`                       |
| `jwt.autoGenerate.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                                                                | `1`                       |
| `jwt.autoGenerate.startupProbe.enabled`                              | Enable startupProbe on Supabase auth containers                                                                                                                                                                                                     | `false`                   |

### Supabase Rest Traffic Exposure Parameters

| Name                                         | Description                                                                              | Value       |
| -------------------------------------------- | ---------------------------------------------------------------------------------------- | ----------- |
| `rest.service.type`                          | Supabase rest service type                                                               | `ClusterIP` |
| `rest.service.ports.http`                    | Supabase rest service HTTP port                                                          | `80`        |
| `rest.service.nodePorts.http`                | Node port for HTTP                                                                       | `""`        |
| `rest.service.clusterIP`                     | Supabase rest service Cluster IP                                                         | `""`        |
| `rest.service.loadBalancerIP`                | Supabase rest service Load Balancer IP                                                   | `""`        |
| `rest.service.loadBalancerSourceRanges`      | Supabase rest service Load Balancer sources                                              | `[]`        |
| `rest.service.externalTrafficPolicy`         | Supabase rest service external traffic policy                                            | `Cluster`   |
| `rest.service.annotations`                   | Additional custom annotations for Supabase rest service                                  | `{}`        |
| `rest.service.extraPorts`                    | Extra ports to expose in Supabase rest service (normally used with the `sidecars` value) | `[]`        |
| `rest.service.sessionAffinity`               | Control where rest requests go, to the same pod or round-robin                           | `None`      |
| `rest.service.sessionAffinityConfig`         | Additional settings for the sessionAffinity                                              | `{}`        |
| `rest.networkPolicy.enabled`                 | Specifies whether a NetworkPolicy should be created                                      | `true`      |
| `rest.networkPolicy.allowExternal`           | Don't require client label for connections                                               | `true`      |
| `rest.networkPolicy.allowExternalEgress`     | Allow the pod to access any range of port and all destinations.                          | `true`      |
| `rest.networkPolicy.extraIngress`            | Add extra ingress rules to the NetworkPolice                                             | `[]`        |
| `rest.networkPolicy.extraEgress`             | Add extra ingress rules to the NetworkPolicy                                             | `[]`        |
| `rest.networkPolicy.ingressNSMatchLabels`    | Labels to match to allow traffic from other namespaces                                   | `{}`        |
| `rest.networkPolicy.ingressNSPodMatchLabels` | Pod labels to match to allow traffic from other namespaces                               | `{}`        |

### Supabase Storage Parameters

| Name                                                        | Description                                                                                                                                                                                                                       | Value                              |
| ----------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------- |
| `storage.enabled`                                           | Enable Supabase storage                                                                                                                                                                                                           | `true`                             |
| `storage.replicaCount`                                      | Number of Supabase storage replicas to deploy                                                                                                                                                                                     | `1`                                |
| `storage.defaultConfig`                                     | Default configuration for Supabase storage                                                                                                                                                                                        | `""`                               |
| `storage.extraConfig`                                       | Extra configuration for Supabase storage                                                                                                                                                                                          | `{}`                               |
| `storage.existingConfigmap`                                 | The name of an existing ConfigMap with the default configuration                                                                                                                                                                  | `""`                               |
| `storage.extraConfigExistingConfigmap`                      | The name of an existing ConfigMap with extra configuration                                                                                                                                                                        | `""`                               |
| `storage.image.registry`                                    | Storage image registry                                                                                                                                                                                                            | `REGISTRY_NAME`                    |
| `storage.image.repository`                                  | Storage image repository                                                                                                                                                                                                          | `REPOSITORY_NAME/supabase-storage` |
| `storage.image.digest`                                      | Storage image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag image tag (immutable tags are recommended)                                                                                | `""`                               |
| `storage.image.pullPolicy`                                  | Storage image pull policy                                                                                                                                                                                                         | `IfNotPresent`                     |
| `storage.image.pullSecrets`                                 | Storage image pull secrets                                                                                                                                                                                                        | `[]`                               |
| `storage.containerPorts.http`                               | Supabase storage HTTP container port                                                                                                                                                                                              | `5000`                             |
| `storage.livenessProbe.enabled`                             | Enable livenessProbe on Supabase storage containers                                                                                                                                                                               | `true`                             |
| `storage.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                                           | `5`                                |
| `storage.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                                  | `10`                               |
| `storage.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                                 | `5`                                |
| `storage.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                                               | `6`                                |
| `storage.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                                               | `1`                                |
| `storage.readinessProbe.enabled`                            | Enable readinessProbe on Supabase storage containers                                                                                                                                                                              | `true`                             |
| `storage.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                                          | `5`                                |
| `storage.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                                 | `10`                               |
| `storage.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                                | `5`                                |
| `storage.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                                              | `6`                                |
| `storage.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                                              | `1`                                |
| `storage.startupProbe.enabled`                              | Enable startupProbe on Supabase storage containers                                                                                                                                                                                | `false`                            |
| `storage.startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                                            | `5`                                |
| `storage.startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                                   | `10`                               |
| `storage.startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                                  | `5`                                |
| `storage.startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                                | `6`                                |
| `storage.startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                                | `1`                                |
| `storage.customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                                                                                                                               | `{}`                               |
| `storage.customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                                                                                                                                              | `{}`                               |
| `storage.customStartupProbe`                                | Custom startupProbe that overrides the default one                                                                                                                                                                                | `{}`                               |
| `storage.service.externalTrafficPolicy`         | Supabase storage service external traffic policy                                            | `Cluster`   |
| `storage.service.annotations`                   | Additional custom annotations for Supabase storage service                                  | `{}`        |
| `storage.service.extraPorts`                    | Extra ports to expose in Supabase storage service (normally used with the `sidecars` value) | `[]`        |
| `storage.service.sessionAffinity`               | Control where storage requests go, to the same pod or round-robin                           | `None`      |
| `storage.service.sessionAffinityConfig`         | Additional settings for the sessionAffinity                                                 | `{}`        |
| `storage.networkPolicy.enabled`                 | Specifies whether a NetworkPolicy should be created                                         | `true`      |
| `storage.networkPolicy.allowExternal`           | Don't require client label for connections                                                  | `true`      |
| `storage.networkPolicy.allowExternalEgress`     | Allow the pod to access any range of port and all destinations.                             | `true`      |
| `storage.networkPolicy.extraIngress`            | Add extra ingress rules to the NetworkPolice                                                | `[]`        |
| `storage.networkPolicy.extraEgress`             | Add extra ingress rules to the NetworkPolicy                                                | `[]`        |
| `storage.networkPolicy.ingressNSMatchLabels`    | Labels to match to allow traffic from other namespaces                                      | `{}`        |
| `storage.networkPolicy.ingressNSPodMatchLabels` | Pod labels to match to allow traffic from other namespaces                                  | `{}`        |

### Storage Persistence Parameters

| Name                                | Description                                                                                             | Value                       |
| ----------------------------------- | ------------------------------------------------------------------------------------------------------- | --------------------------- |
| `storage.persistence.enabled`       | Enable persistence using Persistent Volume Claims                                                       | `true`                      |
| `storage.persistence.mountPath`     | Path to mount the volume at.                                                                            | `/bitnami/supabase-storage` |
| `storage.persistence.subPath`       | The subdirectory of the volume to mount to, useful in dev environments and one PV for multiple services | `""`                        |
| `storage.persistence.storageClass`  | Storage class of backing PVC                                                                            | `""`                        |
| `storage.persistence.annotations`   | Persistent Volume Claim annotations                                                                     | `{}`                        |
| `storage.persistence.accessModes`   | Persistent Volume Access Modes                                                                          | `["ReadWriteOnce"]`         |
| `storage.persistence.size`          | Size of data volume                                                                                     | `8Gi`                       |
| `storage.persistence.existingClaim` | The name of an existing PVC to use for persistence                                                      | `""`                        |
| `storage.persistence.selector`      | Selector to match an existing Persistent Volume for Supabase data PVC                                   | `{}`                        |
| `storage.persistence.dataSource`    | Custom PVC data source                                                                                  | `{}`                        |

### Supabase Studio Parameters

| Name                                                       | Description                                                                                                                                                                                                                     | Value                             |
| ---------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------- |
| `studio.enabled`                                           | Enable Supabase studio                                                                                                                                                                                                          | `true`                            |
| `studio.publicURL`                                         | Supabase studio public URL                                                                                                                                                                                                      | `""`                              |
| `studio.replicaCount`                                      | Number of Supabase studio replicas to deploy                                                                                                                                                                                    | `1`                               |
| `studio.defaultConfig`                                     | Supabase studio default configuration                                                                                                                                                                                           | `""`                              |
| `studio.extraConfig`                                       | Supabase studio extra configuration                                                                                                                                                                                             | `{}`                              |
| `studio.existingConfigmap`                                 | The name of an existing ConfigMap with the default configuration                                                                                                                                                                | `""`                              |
| `studio.extraConfigExistingConfigmap`                      | The name of an existing ConfigMap with extra configuration                                                                                                                                                                      | `""`                              |
| `studio.image.registry`                                    | Studio image registry                                                                                                                                                                                                           | `REGISTRY_NAME`                   |
| `studio.image.repository`                                  | Studio image repository                                                                                                                                                                                                         | `REPOSITORY_NAME/supabase-studio` |
| `studio.image.digest`                                      | Studio image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag image tag (immutable tags are recommended)                                                                               | `""`                              |
| `studio.image.pullPolicy`                                  | Studio image pull policy                                                                                                                                                                                                        | `IfNotPresent`                    |
| `studio.image.pullSecrets`                                 | Studio image pull secrets                                                                                                                                                                                                       | `[]`                              |
| `studio.containerPorts.http`                               | Supabase studio HTTP container port                                                                                                                                                                                             | `3000`                            |
| `studio.livenessProbe.enabled`                             | Enable livenessProbe on Supabase studio containers                                                                                                                                                                              | `true`                            |
| `studio.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                                         | `5`                               |
| `studio.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                                | `10`                              |
| `studio.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                               | `5`                               |
| `studio.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                                             | `6`                               |
| `studio.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                                             | `1`                               |
| `studio.readinessProbe.enabled`                            | Enable readinessProbe on Supabase studio containers                                                                                                                                                                             | `true`                            |
| `studio.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                                        | `5`                               |
| `studio.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                               | `10`                              |
| `studio.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                              | `5`                               |
| `studio.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                                            | `6`                               |
| `studio.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                                            | `1`                               |
| `studio.startupProbe.enabled`                              | Enable startupProbe on Supabase studio containers                                                                                                                                                                               | `false`                           |
| `studio.startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                                          | `5`                               |
| `studio.startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                                 | `10`                              |
| `studio.startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                                | `5`                               |
| `studio.startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                              | `6`                               |
| `studio.startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                              | `1`                               |
| `studio.customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                                                                                                                             | `{}`                              |
| `studio.customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                                                                                                                                            | `{}`                              |
| `studio.customStartupProbe`                                | Custom startupProbe that overrides the default one                                                                                                                                                                              | `{}`                              |
| `studio.hostAliases`                                       | Supabase studio pods host aliases                                                                                                                                                                                               | `[]`                              |
| `studio.podLabels`                                         | Extra labels for Supabase studio pods                                                                                                                                                                                           | `{}`                              |
| `studio.podAnnotations`                                    | Annotations for Supabase studio pods                                                                                                                                                                                            | `{}`                              |
| `studio.podAffinityPreset`                                 | Pod affinity preset. Ignored if `studio.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                      | `""`                              |
| `studio.podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `studio.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                 | `soft`                            |
| `studio.nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `studio.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                | `""`                              |
| `studio.nodeAffinityPreset.key`                            | Node label key to match. Ignored if `studio.affinity` is set                                                                                                                                                                    | `""`                              |
| `studio.nodeAffinityPreset.values`                         | Node label values to match. Ignored if `studio.affinity` is set                                                                                                                                                                 | `[]`                              |
| `studio.affinity`                                          | Affinity for Supabase studio pods assignment                                                                                                                                                                                    | `{}`                              |
| `studio.nodeSelector`                                      | Node labels for Supabase studio pods assignment                                                                                                                                                                                 | `{}`                              |
| `studio.tolerations`                                       | Tolerations for Supabase studio pods assignment                                                                                                                                                                                 | `[]`                              |
| `studio.updateStrategy.type`                               | Supabase studio statefulset strategy type                                                                                                                                                                                       | `RollingUpdate`                   |
| `studio.priorityClassName`                                 | Supabase studio pods' priorityClassName                                                                                                                                                                                         | `""`                              |
| `studio.topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template                                                                                                        | `[]`                              |
| `studio.schedulerName`                                     | Name of the k8s scheduler (other than default) for Supabase studio pods                                                                                                                                                         | `""`                              |
| `studio.terminationGracePeriodSeconds`                     | Seconds Redmine pod needs to terminate gracefully                                                                                                                                                                               | `""`                              |
| `studio.lifecycleHooks`                                    | for the Supabase studio container(s) to automate configuration before or after startup                                                                                                                                          | `{}`                              |
| `studio.extraEnvVars`                                      | Array with extra environment variables to add to Supabase studio nodes                                                                                                                                                          | `[]`                              |
| `studio.extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for Supabase studio nodes                                                                                                                                                  | `""`                              |
| `studio.extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for Supabase studio nodes                                                                                                                                                     | `""`                              |
| `studio.extraVolumes`                                      | Optionally specify extra list of additional volumes for the Supabase studio pod(s)                                                                                                                                              | `[]`                              |
| `studio.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the Supabase studio container(s)                                                                                                                                   | `[]`                              |
| `studio.sidecars`                                          | Add additional sidecar containers to the Supabase studio pod(s)                                                                                                                                                                 | `[]`                              |
| `studio.initContainers`                                    | Add additional init containers to the Supabase studio pod(s)                                                                                                                                                                    | `[]`                              |

### Supabase Studio Traffic Exposure Parameters

| Name                                           | Description                                                                                                                      | Value                    |
| ---------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `studio.service.type`                          | Supabase studio service type                                                                                                     | `ClusterIP`              |
| `studio.service.ports.http`                    | Supabase studio service HTTP port                                                                                                | `80`                     |
| `studio.service.nodePorts.http`                | Node port for HTTP                                                                                                               | `""`                     |
| `studio.service.clusterIP`                     | Supabase studio service Cluster IP                                                                                               | `""`                     |
| `studio.service.loadBalancerIP`                | Supabase studio service Load Balancer IP                                                                                         | `""`                     |
| `studio.service.loadBalancerSourceRanges`      | Supabase studio service Load Balancer sources                                                                                    | `[]`                     |
| `studio.service.externalTrafficPolicy`         | Supabase studio service external traffic policy                                                                                  | `Cluster`                |
| `studio.service.annotations`                   | Additional custom annotations for Supabase studio service                                                                        | `{}`                     |
| `studio.service.extraPorts`                    | Extra ports to expose in Supabase studio service (normally used with the `sidecars` value)                                       | `[]`                     |
| `studio.service.sessionAffinity`               | Control where studio requests go, to the same pod or round-robin                                                                 | `None`                   |
| `studio.service.sessionAffinityConfig`         | Additional settings for the sessionAffinity                                                                                      | `{}`                     |
| `studio.networkPolicy.enabled`                 | Specifies whether a NetworkPolicy should be created                                                                              | `true`                   |
| `studio.networkPolicy.allowExternal`           | Don't require client label for connections                                                                                       | `true`                   |
| `studio.networkPolicy.allowExternalEgress`     | Allow the pod to access any range of port and all destinations.                                                                  | `true`                   |
| `studio.networkPolicy.extraIngress`            | Add extra ingress rules to the NetworkPolice                                                                                     | `[]`                     |
| `studio.networkPolicy.extraEgress`             | Add extra ingress rules to the NetworkPolicy                                                                                     | `[]`                     |
| `studio.networkPolicy.ingressNSMatchLabels`    | Labels to match to allow traffic from other namespaces                                                                           | `{}`                     |
| `studio.networkPolicy.ingressNSPodMatchLabels` | Pod labels to match to allow traffic from other namespaces                                                                       | `{}`                     |
| `studio.ingress.enabled`                       | Enable ingress record generation for Supabase                                                                                    | `false`                  |
| `studio.ingress.pathType`                      | Ingress path type                                                                                                                | `ImplementationSpecific` |
| `studio.ingress.hostname`                      | Default host for the ingress record                                                                                              | `supabase-studio.local`  |
| `studio.ingress.ingressClassName`              | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                    | `""`                     |
| `studio.ingress.path`                          | Default path for the ingress record                                                                                              | `/`                      |
| `studio.ingress.annotations`                   | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                     |
| `studio.ingress.tls`                           | Enable TLS configuration for the host defined at `studio.ingress.hostname` parameter                                             | `false`                  |
| `studio.ingress.selfSigned`                    | Create a TLS secret for this ingress record using self-signed certificates generated by Helm                                     | `false`                  |
| `studio.ingress.extraHosts`                    | An array with additional hostname(s) to be covered with the ingress record                                                       | `[]`                     |
| `studio.ingress.extraPaths`                    | An array with additional arbitrary paths that may need to be added to the ingress under the main host                            | `[]`                     |
| `studio.ingress.extraTls`                      | TLS configuration for additional hostname(s) to be covered with this ingress record                                              | `[]`                     |
| `studio.ingress.secrets`                       | Custom TLS certificates as secrets                                                                                               | `[]`                     |
| `studio.ingress.extraRules`                    | Additional rules to be covered with this ingress record                                                                          | `[]`                     |

### Init Container Parameters

| Name                                                        | Description                                                                                                                                                                                                                                           | Value                               |
| ----------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------- |
| `volumePermissions.enabled`                                 | Enable init container that changes the owner/group of the PV mount point to `runAsUser:fsGroup`                                                                                                                                                       | `false`                             |
| `volumePermissions.image.registry`                          | OS Shell + Utility image registry                                                                                                                                                                                                                     | `REGISTRY_NAME`                     |
| `volumePermissions.image.repository`                        | OS Shell + Utility image repository                                                                                                                                                                                                                   | `REPOSITORY_NAME/os-shell`          |
| `volumePermissions.image.pullPolicy`                        | OS Shell + Utility image pull policy                                                                                                                                                                                                                  | `IfNotPresent`                      |
| `volumePermissions.image.pullSecrets`                       | OS Shell + Utility image pull secrets                                                                                                                                                                                                                 | `[]`                                |
| `volumePermissions.containerSecurityContext.runAsUser`      | Set init container's Security Context runAsUser                                                                                                                                                                                                       | `0`                                 |
| `psqlImage.registry`                                        | PostgreSQL client image registry                                                                                                                                                                                                                      | `REGISTRY_NAME`                     |
| `psqlImage.repository`                                      | PostgreSQL client image repository                                                                                                                                                                                                                    | `REPOSITORY_NAME/supabase-postgres` |
| `psqlImage.digest`                                          | PostgreSQL client image digest (overrides image tag)                                                                                                                                                                                                  | `""`                                |
| `psqlImage.pullPolicy`                                      | PostgreSQL client image pull policy                                                                                                                                                                                                                   | `IfNotPresent`                      |
| `psqlImage.pullSecrets`                                     | PostgreSQL client image pull secrets                                                                                                                                                                                                                  | `[]`                                |
| `psqlImage.debug`                                           | Enable PostgreSQL client image debug mode                                                                                                                                                                                                             | `false`                             |

### Other Parameters

| Name                                          | Description                                                      | Value   |
| --------------------------------------------- | ---------------------------------------------------------------- | ------- |
| `rbac.create`                                 | Specifies whether RBAC resources should be created               | `true`  |
| `serviceAccount.create`                       | Specifies whether a ServiceAccount should be created             | `true`  |
| `serviceAccount.name`                         | The name of the ServiceAccount to use.                           | `""`    |
| `serviceAccount.annotations`                  | Additional Service Account annotations (evaluated as a template) | `{}`    |
| `serviceAccount.automountServiceAccountToken` | Automount service account token for the server service account   | `false` |

### Kong sub-chart parameters

| Name                             | Description                                                                                                                                                                                                          | Value            |
| -------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| `kong.enabled`                   | Enable Kong                                                                                                                                                                                                          | `true`           |
| `kong.database`                  | Database to use                                                                                                                                                                                                      | `off`            |
| `kong.initContainers`            | Add additional init containers to the Kong pods                                                                                                                                                                      | `""`             |
| `kong.ingressController.enabled` | Enable Kong Ingress Controller                                                                                                                                                                                       | `false`          |
| `kong.kong.extraVolumeMounts`    | Additional volumeMounts to the Kong container                                                                                                                                                                        | `[]`             |
| `kong.kong.extraEnvVars`         | Additional environment variables to set                                                                                                                                                                              | `[]`             |
| `kong.kong.resourcesPreset`      | Set container resources according to one common preset (allowed values: none, nano, small, medium, large, xlarge, 2xlarge). This is ignored if kong.resources is set (kong.resources is recommended for production). | `medium`         |
| `kong.kong.resources`            | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                    | `{}`             |
| `kong.extraVolumes`              | Additional volumes to the Kong pods                                                                                                                                                                                  | `[]`             |
| `kong.ingress.enabled`           | Enable Ingress rule                                                                                                                                                                                                  | `false`          |
| `kong.ingress.hostname`          | Kong Ingress hostname                                                                                                                                                                                                | `supabase.local` |
| `kong.ingress.tls`               | Enable TLS for Kong Ingress                                                                                                                                                                                          | `false`          |
| `kong.service.loadBalancerIP`    | Kubernetes service LoadBalancer IP                                                                                                                                                                                   | `""`             |
| `kong.service.type`              | Kubernetes service type                                                                                                                                                                                              | `LoadBalancer`   |
| `kong.service.ports.proxyHttp`   | Kong service port                                                                                                                                                                                                    | `80`             |
| `kong.postgresql.enabled`        | Switch to enable or disable the PostgreSQL helm chart inside the Kong subchart                                                                                                                                       | `false`          |

### PostgreSQL sub-chart parameters

| Name                                          | Description                                                                                                                                                                                                                | Value                                                                                                                        |
| --------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------- |
| `postgresql.enabled`                          | Switch to enable or disable the PostgreSQL helm chart                                                                                                                                                                      | `true`                                                                                                                       |
| `postgresql.auth.existingSecret`              | Name of existing secret to use for PostgreSQL credentials                                                                                                                                                                  | `""`                                                                                                                         |
| `postgresql.architecture`                     | PostgreSQL architecture (`standalone` or `replication`)                                                                                                                                                                    | `standalone`                                                                                                                 |
| `postgresql.service.ports.postgresql`         | PostgreSQL service port                                                                                                                                                                                                    | `5432`                                                                                                                       |
| `postgresql.image.registry`                   | PostgreSQL image registry                                                                                                                                                                                                  | `REGISTRY_NAME`                                                                                                              |
| `postgresql.image.repository`                 | PostgreSQL image repository                                                                                                                                                                                                | `REPOSITORY_NAME/supabase-postgres`                                                                                          |
| `postgresql.image.digest`                     | PostgreSQL image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                 | `""`                                                                                                                         |
| `postgresql.image.pullPolicy`                 | PostgreSQL image pull policy                                                                                                                                                                                               | `IfNotPresent`                                                                                                               |
| `postgresql.image.pullSecrets`                | Specify image pull secrets                                                                                                                                                                                                 | `[]`                                                                                                                         |
| `postgresql.image.debug`                      | Specify if debug values should be set                                                                                                                                                                                      | `false`                                                                                                                      |
| `postgresql.postgresqlSharedPreloadLibraries` | Set the shared_preload_libraries parameter in postgresql.conf                                                                                                                                                              | `pg_stat_statements, pg_stat_monitor, pgaudit, plpgsql, plpgsql_check, pg_cron, pg_net, pgsodium, timescaledb, auto_explain` |
| `postgresql.auth.postgresPassword`            | PostgreSQL admin password                                                                                                                                                                                                  | `""`                                                                                                                         |
| `postgresql.auth.existingSecret`              | Name of existing secret to use for PostgreSQL credentials                                                                                                                                                                  | `""`                                                                                                                         |
| `postgresql.architecture`                     | PostgreSQL architecture (`standalone` or `replication`)                                                                                                                                                                    | `standalone`                                                                                                                 |
| `postgresql.service.ports.postgresql`         | PostgreSQL service port                                                                                                                                                                                                    | `5432`                                                                                                                       |
| `postgresql.primary.resourcesPreset`          | Set container resources according to one common preset (allowed values: none, nano, small, medium, large, xlarge, 2xlarge). This is ignored if primary.resources is set (primary.resources is recommended for production). | `nano`                                                                                                                       |
| `postgresql.primary.resources`                | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                          | `{}`                                                                                                                         |
| `externalDatabase.host`                       | Database host                                                                                                                                                                                                              | `""`                                                                                                                         |
| `externalDatabase.port`                       | Database port number                                                                                                                                                                                                       | `5432`                                                                                                                       |
| `externalDatabase.user`                       | Non-root username for PostgreSQL                                                                                                                                                                                           | `supabase_admin`                                                                                                             |
| `externalDatabase.password`                   | Password for the non-root username for PostgreSQL                                                                                                                                                                          | `""`                                                                                                                         |
| `externalDatabase.database`                   | PostgreSQL database name                                                                                                                                                                                                   | `postgres`                                                                                                                   |
| `externalDatabase.existingSecret`             | Name of an existing secret resource containing the database credentials                                                                                                                                                    | `""`                                                                                                                         |
| `externalDatabase.existingSecretPasswordKey`  | Name of an existing secret key containing the database credentials                                                                                                                                                         | `""`                                                                                                                         |

The above parameters map to the env variables defined in [bitnami/supabase-studio](https://github.com/bitnami/containers/tree/main/bitnami/supabase-studio). For more information please refer to the [bitnami/supabase-studio](https://github.com/bitnami/containers/tree/main/bitnami/supabase-studio) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install my-release \
  --set postgresql.auth.postgresPassword=secretpassword \
    oci://REGISTRY_NAME/REPOSITORY_NAME/supabase
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The above command sets the PostgreSQL `postgres` user password to `secretpassword`.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml oci://REGISTRY_NAME/REPOSITORY_NAME/supabase
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.
> **Tip**: You can use the default [values.yaml](https://github.com/bitnami/charts/tree/main/bitnami/supabase/values.yaml)

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 3.0.0

This major bump changes the following security defaults:

- `runAsGroup` is changed from `0` to `1001`
- `readOnlyRootFilesystem` is set to `true`
- `resourcesPreset` is changed from `none` to the minimum size working in our test suites (NOTE: `resourcesPreset` is not meant for production usage, but `resources` adapted to your use case).
- `global.compatibility.openshift.adaptSecurityContext` is changed from `disabled` to `auto`.

This could potentially break any customization or init scripts used in your deployment. If this is the case, change the default values to the previous ones.

### To 2.0.0

This major updates the Kong subchart to its newest major, 10.0.0. [Here](https://github.com/bitnami/charts/tree/master/bitnami/kong#to-1000) you can find more information about the changes introduced in that version.

### To 1.0.0

This major updates the PostgreSQL subchart to its newest major, 13.0.0. [Here](https://github.com/bitnami/charts/tree/master/bitnami/postgresql#to-1300) you can find more information about the changes introduced in that version.

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