<!--- app-name: Discourse&reg; -->

# Discourse(R) packaged by Bitnami

Discourse is an open source discussion platform with built-in moderation and governance systems that let discussion communities protect themselves from bad actors even without official moderators.

[Overview of Discourse&reg;](http://www.discourse.org/)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/discourse
```

Looking to use Discoursereg; in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the enterprise edition of Bitnami Application Catalog.

## Introduction

This chart bootstraps a [Discourse](https://www.discourse.org/) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages [Bitnami Postgresql](https://github.com/bitnami/charts/tree/main/bitnami/postgresql) and [Bitnami Redis&reg;](https://github.com/bitnami/charts/tree/main/bitnami/redis) which are required as databases for the Discourse application.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+
- PV provisioner support in the underlying infrastructure
- ReadWriteMany volumes for deployment scaling

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/discourse
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The command deploys Discourse on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Configuration and installation details

### Resource requests and limits

Bitnami charts allow setting resource requests and limits for all containers inside the chart deployment. These are inside the `resources` value (check parameter table). Setting requests is essential for production workloads and these should be adapted to your specific use case.

To make this process easier, the chart contains the `resourcesPreset` values, which automatically sets the `resources` section according to different presets. Check these presets in [the bitnami/common chart](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15). However, in production workloads using `resourcePreset` is discouraged as it may not fully adapt to your specific needs. Find more information on container resource management in the [official Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).

### [Rolling VS Immutable tags](https://docs.vmware.com/en/VMware-Tanzu-Application-Catalog/services/tutorials/GUID-understand-rolling-tags-containers-index.html)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Setting up replication

By default, this Chart only deploys a single pod running Discourse. Should you want to increase the number of replicas, you may follow these simple steps to ensure everything works smoothly:

> **Tip**: Running these steps ensures the PostgreSQL instance is correctly populated. If you already have an initialised DB, you may directly create a release with the desired number of replicas. Remind to set `discourse.skipInstall` to `true`!

1. Create a conventional release, that will be scaled later:

    ```console
    helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/discourse
    ...
    ```

    > Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

2. Wait for the release to complete and Discourse to be running successfully.

    ```console
    $ kubectl get pods
    NAME                               READY   STATUS    RESTARTS   AGE
    my-release-discourse-744c48dd97-wx5h9   2/2     Running   0          5m11s
    my-release-postgresql-0                 1/1     Running   0          5m10s
    my-release-redis-master-0               1/1     Running   0          5m11s
    ```

3. Perform an upgrade specifying the number of replicas and the credentials used.

    ```console
    helm upgrade my-release --set replicaCount=2,discourse.skipInstall=true oci://REGISTRY_NAME/REPOSITORY_NAME/discourse
    ```

    > Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

    Note that for this to work properly, you need to provide ReadWriteMany PVCs. If you don't have a provisioner for this type of storage, we recommend that you install the NFS provisioner chart (with the correct parameters, such as `persistence.enabled=true` and `persistence.size=10Gi`) and map it to a RWO volume.

    Then you can deploy Discourse chart using the proper parameters:

    ```console
    persistence.storageClass=nfs
    postgresql.primary.persistence.storageClass=nfs
    ```

### Installing plugins

You can install custom Discourse plugins during the release installation listing the desired plugin repositories via the `discourse.plugins` parameter. For example:

```yaml
discourse:
  plugins:
  - https://github.com/discourse/discourse-oauth2-basic
```

> Note: By default, plugins are persisted after the 1st installation, therefore it's not possible to update them on subsequent upgrades. If you want plugins to be updated on every upgrade, set the `discourse.persistPlugins` parameter to `false`.

### Sidecars

If you have a need for additional containers to run within the same pod as Discourse (e.g. metrics or logging exporter), you can do so via the `sidecars` config parameter. Simply define your container according to the Kubernetes container spec.

```yaml
sidecars:
- name: your-image-name
  image: your-image
  imagePullPolicy: Always
  ports:
  - name: portname
   containerPort: 1234
```

If these sidecars export extra ports, you can add extra port definitions using the `service.extraPorts` value:

```yaml
service:
...
  extraPorts:
  - name: extraPort
    port: 11311
    targetPort: 11311
```

### Using an external database

Sometimes you may want to have Discourse connect to an external database rather than installing one inside your cluster, e.g. to use a managed database service, or use run a single database server for all your applications. To do this, the chart allows you to specify credentials for an external database under the [`externalDatabase` parameter](#parameters). You should also disable the PostgreSQL installation with the `postgresql.enabled` option. For example with the following parameters:

```console
postgresql.enabled=false
externalDatabase.host=myexternalhost
externalDatabase.user=myuser
externalDatabase.password=mypassword
externalDatabase.postgresUser=postgres
externalDatabase.postgresPassword=rootpassword
externalDatabase.database=mydatabase
externalDatabase.port=5432
```

Note also that if you disable PostgreSQL per above you MUST supply values for the `externalDatabase` connection.

In case the database already contains data from a previous Discourse installation, you need to set the `discourse.skipInstall` parameter to _true_. Otherwise, the container would execute the installation wizard and could modify the existing data in the database. This parameter force the container to not execute the Discourse installation wizard.

Similarly, you can specify an external Redis&reg; instance rather than installing one inside your cluster. First, you may disable the Redis&reg; installation with the `redis.enabled` option. As aforementioned, used the provided parameters to provide data about your instance:

```console
redis.enabled=false
externalRedis.host=myexternalhost
externalRedis.password=mypassword
externalRedis.port=5432
```

### Ingress

This chart provides support for Ingress resources. If you have an ingress controller installed on your cluster, such as [nginx-ingress-controller](https://github.com/bitnami/charts/tree/main/bitnami/nginx-ingress-controller) or [contour](https://github.com/bitnami/charts/tree/main/bitnami/contour) you can utilize the ingress controller to serve your application. To enable Ingress integration, set `ingress.enabled` to `true`.

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

### Setting Pod's affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

## Persistence

The [Bitnami Discourse](https://github.com/bitnami/containers/tree/main/bitnami/discourse) image stores the Discourse data and configurations at the `/bitnami` path of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Parameters](#parameters) section to configure the PVC or to disable persistence.

## Parameters

### Global parameters

| Name                                                  | Description                                                                                                                                                                                                                                                                                                                                                         | Value  |
| ----------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------ |
| `global.imageRegistry`                                | Global Docker image registry                                                                                                                                                                                                                                                                                                                                        | `""`   |
| `global.imagePullSecrets`                             | Global Docker registry secret names as an array                                                                                                                                                                                                                                                                                                                     | `[]`   |
| `global.storageClass`                                 | Global StorageClass for Persistent Volume(s)                                                                                                                                                                                                                                                                                                                        | `""`   |
| `global.compatibility.openshift.adaptSecurityContext` | Adapt the securityContext sections of the deployment to make them compatible with Openshift restricted-v2 SCC: remove runAsUser, runAsGroup and fsGroup and let the platform use their allowed default IDs. Possible values: auto (apply if the detected running cluster is Openshift), force (perform the adaptation always), disabled (do not perform adaptation) | `auto` |

### Common parameters

| Name                     | Description                                                                               | Value           |
| ------------------------ | ----------------------------------------------------------------------------------------- | --------------- |
| `kubeVersion`            | Force target Kubernetes version (using Helm capabilities if not set)                      | `""`            |
| `nameOverride`           | String to partially override discourse.fullname template (will maintain the release name) | `""`            |
| `fullnameOverride`       | String to fully override discourse.fullname template                                      | `""`            |
| `clusterDomain`          | Kubernetes Cluster Domain                                                                 | `cluster.local` |
| `commonLabels`           | Labels to be added to all deployed resources                                              | `{}`            |
| `commonAnnotations`      | Annotations to be added to all deployed resources                                         | `{}`            |
| `extraDeploy`            | Array of extra objects to deploy with the release                                         | `[]`            |
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden)   | `false`         |
| `diagnosticMode.command` | Command to override all containers in the the deployment(s)/statefulset(s)                | `["sleep"]`     |
| `diagnosticMode.args`    | Args to override all containers in the the deployment(s)/statefulset(s)                   | `["infinity"]`  |

### Discourse Common parameters

| Name                                     | Description                                                                                                              | Value                       |
| ---------------------------------------- | ------------------------------------------------------------------------------------------------------------------------ | --------------------------- |
| `image.registry`                         | Discourse image registry                                                                                                 | `REGISTRY_NAME`             |
| `image.repository`                       | Discourse image repository                                                                                               | `REPOSITORY_NAME/discourse` |
| `image.digest`                           | Discourse image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                | `""`                        |
| `image.pullPolicy`                       | Discourse image pull policy                                                                                              | `IfNotPresent`              |
| `image.pullSecrets`                      | Discourse image pull secrets                                                                                             | `[]`                        |
| `image.debug`                            | Enable image debug mode                                                                                                  | `false`                     |
| `auth.email`                             | Discourse admin user email                                                                                               | `user@example.com`          |
| `auth.username`                          | Discourse admin user                                                                                                     | `user`                      |
| `auth.password`                          | Discourse admin password. WARNING: Minimum length of 10 characters                                                       | `""`                        |
| `auth.existingSecret`                    | Name of an existing secret to use for Discourse credentials                                                              | `""`                        |
| `host`                                   | Hostname to create application URLs (include the port if =/= 80)                                                         | `""`                        |
| `siteName`                               | Discourse site name                                                                                                      | `My Site!`                  |
| `smtp.enabled`                           | Enable/disable SMTP                                                                                                      | `false`                     |
| `smtp.host`                              | SMTP host name                                                                                                           | `""`                        |
| `smtp.port`                              | SMTP port number                                                                                                         | `""`                        |
| `smtp.user`                              | SMTP account user name                                                                                                   | `""`                        |
| `smtp.password`                          | SMTP account password                                                                                                    | `""`                        |
| `smtp.protocol`                          | SMTP protocol (Allowed values: tls, ssl)                                                                                 | `""`                        |
| `smtp.auth`                              | SMTP authentication method                                                                                               | `""`                        |
| `smtp.existingSecret`                    | Name of an existing Kubernetes secret. The secret must have the following key configured: `smtp-password`                | `""`                        |
| `replicaCount`                           | Number of Discourse & Sidekiq replicas                                                                                   | `1`                         |
| `podSecurityContext.enabled`             | Enabled Discourse pods' Security Context                                                                                 | `true`                      |
| `podSecurityContext.fsGroupChangePolicy` | Set filesystem group change policy                                                                                       | `Always`                    |
| `podSecurityContext.sysctls`             | Set kernel settings using the sysctl interface                                                                           | `[]`                        |
| `podSecurityContext.supplementalGroups`  | Set filesystem extra groups                                                                                              | `[]`                        |
| `podSecurityContext.fsGroup`             | Set Discourse pod's Security Context fsGroup                                                                             | `0`                         |
| `automountServiceAccountToken`           | Mount Service Account token in pod                                                                                       | `false`                     |
| `hostAliases`                            | Add deployment host aliases                                                                                              | `[]`                        |
| `podAnnotations`                         | Additional pod annotations                                                                                               | `{}`                        |
| `podLabels`                              | Additional pod labels                                                                                                    | `{}`                        |
| `podAffinityPreset`                      | Pod affinity preset. Allowed values: soft, hard                                                                          | `""`                        |
| `podAntiAffinityPreset`                  | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                 | `soft`                      |
| `nodeAffinityPreset.type`                | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                | `""`                        |
| `nodeAffinityPreset.key`                 | Node label key to match Ignored if `affinity` is set.                                                                    | `""`                        |
| `nodeAffinityPreset.values`              | Node label values to match. Ignored if `affinity` is set.                                                                | `[]`                        |
| `affinity`                               | Affinity for pod assignment                                                                                              | `{}`                        |
| `nodeSelector`                           | Node labels for pod assignment.                                                                                          | `{}`                        |
| `tolerations`                            | Tolerations for pod assignment.                                                                                          | `[]`                        |
| `topologySpreadConstraints`              | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template | `[]`                        |
| `priorityClassName`                      | Priority Class Name                                                                                                      | `""`                        |
| `schedulerName`                          | Use an alternate scheduler, e.g. "stork".                                                                                | `""`                        |
| `terminationGracePeriodSeconds`          | Seconds Discourse pod needs to terminate gracefully                                                                      | `""`                        |
| `updateStrategy.type`                    | Discourse deployment strategy type                                                                                       | `RollingUpdate`             |
| `updateStrategy.rollingUpdate`           | Discourse deployment rolling update configuration parameters                                                             | `{}`                        |
| `sidecars`                               | Add additional sidecar containers to the Discourse pods                                                                  | `[]`                        |
| `initContainers`                         | Add additional init containers to the Discourse pods                                                                     | `[]`                        |
| `extraVolumeMounts`                      | Optionally specify extra list of additional volumeMounts for the Discourse pods                                          | `[]`                        |
| `extraVolumes`                           | Optionally specify extra list of additional volumes for the Discourse pods                                               | `[]`                        |

### Discourse container parameters

| Name                                                          | Description                                                                                                                                                                                                                           | Value                                                              |
| ------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------ |
| `discourse.skipInstall`                                       | Do not run the Discourse installation wizard                                                                                                                                                                                          | `false`                                                            |
| `discourse.plugins`                                           | List of plugins to be installed before the container initialization                                                                                                                                                                   | `[]`                                                               |
| `discourse.persistPlugins`                                    | Persist plugins across container restarts                                                                                                                                                                                             | `true`                                                             |
| `discourse.compatiblePlugins`                                 | Updates plugins to a compatible version on container initialization                                                                                                                                                                   | `true`                                                             |
| `discourse.command`                                           | Custom command to override image cmd                                                                                                                                                                                                  | `[]`                                                               |
| `discourse.args`                                              | Custom args for the custom command                                                                                                                                                                                                    | `[]`                                                               |
| `discourse.extraEnvVars`                                      | Array with extra environment variables to add Discourse pods                                                                                                                                                                          | `[]`                                                               |
| `discourse.extraEnvVarsCM`                                    | ConfigMap containing extra environment variables for Discourse pods                                                                                                                                                                   | `""`                                                               |
| `discourse.extraEnvVarsSecret`                                | Secret containing extra environment variables (in case of sensitive data) for Discourse pods                                                                                                                                          | `""`                                                               |
| `discourse.containerPorts.http`                               | Discourse HTTP container port                                                                                                                                                                                                         | `8080`                                                             |
| `discourse.extraContainerPorts`                               | Optionally specify extra list of additional ports for WordPress container(s)                                                                                                                                                          | `[]`                                                               |
| `discourse.livenessProbe.enabled`                             | Enable livenessProbe on Discourse containers                                                                                                                                                                                          | `true`                                                             |
| `discourse.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                                               | `500`                                                              |
| `discourse.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                                      | `10`                                                               |
| `discourse.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                                     | `5`                                                                |
| `discourse.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                                                   | `6`                                                                |
| `discourse.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                                                   | `1`                                                                |
| `discourse.readinessProbe.enabled`                            | Enable readinessProbe on Discourse containers                                                                                                                                                                                         | `true`                                                             |
| `discourse.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                                              | `180`                                                              |
| `discourse.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                                     | `10`                                                               |
| `discourse.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                                    | `5`                                                                |
| `discourse.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                                                  | `6`                                                                |
| `discourse.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                                                  | `1`                                                                |
| `discourse.startupProbe.enabled`                              | Enable startupProbe on Discourse containers                                                                                                                                                                                           | `false`                                                            |
| `discourse.startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                                                | `60`                                                               |
| `discourse.startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                                       | `10`                                                               |
| `discourse.startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                                      | `5`                                                                |
| `discourse.startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                                    | `15`                                                               |
| `discourse.startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                                    | `1`                                                                |
| `discourse.customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                                                                                                                                   | `{}`                                                               |
| `discourse.customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                                                                                                                                                  | `{}`                                                               |
| `discourse.customStartupProbe`                                | Custom startupProbe that overrides the default one                                                                                                                                                                                    | `{}`                                                               |
| `discourse.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if discourse.resources is set (discourse.resources is recommended for production). | `xlarge`                                                           |
| `discourse.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                     | `{}`                                                               |
| `discourse.containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                                                                                                                                                  | `true`                                                             |
| `discourse.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                                      | `{}`                                                               |
| `discourse.containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                                                                                                                            | `0`                                                                |
| `discourse.containerSecurityContext.runAsGroup`               | Set containers' Security Context runAsGroup                                                                                                                                                                                           | `0`                                                                |
| `discourse.containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                                                                                                                                         | `false`                                                            |
| `discourse.containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                                                                                                                                           | `false`                                                            |
| `discourse.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                                               | `false`                                                            |
| `discourse.containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                                                                                                                             | `false`                                                            |
| `discourse.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                                    | `["ALL"]`                                                          |
| `discourse.containerSecurityContext.capabilities.add`         | List of capabilities to be added                                                                                                                                                                                                      | `["CHOWN","SYS_CHROOT","FOWNER","SETGID","SETUID","DAC_OVERRIDE"]` |
| `discourse.containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                                      | `RuntimeDefault`                                                   |
| `discourse.lifecycleHooks`                                    | for the Discourse container(s) to automate configuration before or after startup                                                                                                                                                      | `{}`                                                               |
| `discourse.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the Discourse pods                                                                                                                                                       | `[]`                                                               |
| `persistence.enabled`                                         | Enable persistence using Persistent Volume Claims                                                                                                                                                                                     | `true`                                                             |
| `persistence.storageClass`                                    | Persistent Volume storage class                                                                                                                                                                                                       | `""`                                                               |
| `persistence.accessModes`                                     | Persistent Volume access modes                                                                                                                                                                                                        | `[]`                                                               |
| `persistence.accessMode`                                      | Persistent Volume access mode (DEPRECATED: use `persistence.accessModes` instead)                                                                                                                                                     | `ReadWriteOnce`                                                    |
| `persistence.size`                                            | Persistent Volume size                                                                                                                                                                                                                | `10Gi`                                                             |
| `persistence.existingClaim`                                   | The name of an existing PVC to use for persistence                                                                                                                                                                                    | `""`                                                               |
| `persistence.selector`                                        | Selector to match an existing Persistent Volume for Discourse data PVC                                                                                                                                                                | `{}`                                                               |
| `persistence.annotations`                                     | Persistent Volume Claim annotations                                                                                                                                                                                                   | `{}`                                                               |

### Sidekiq container parameters

| Name                                                        | Description                                                                                                                                                                                                                       | Value                                                                      |
| ----------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------- |
| `sidekiq.command`                                           | Custom command to override image cmd (evaluated as a template)                                                                                                                                                                    | `["/opt/bitnami/scripts/discourse/entrypoint.sh"]`                         |
| `sidekiq.args`                                              | Custom args for the custom command (evaluated as a template)                                                                                                                                                                      | `["/opt/bitnami/scripts/discourse-sidekiq/run.sh"]`                        |
| `sidekiq.extraEnvVars`                                      | Array with extra environment variables to add Sidekiq pods                                                                                                                                                                        | `[]`                                                                       |
| `sidekiq.extraEnvVarsCM`                                    | ConfigMap containing extra environment variables for Sidekiq pods                                                                                                                                                                 | `""`                                                                       |
| `sidekiq.extraEnvVarsSecret`                                | Secret containing extra environment variables (in case of sensitive data) for Sidekiq pods                                                                                                                                        | `""`                                                                       |
| `sidekiq.livenessProbe.enabled`                             | Enable livenessProbe on Sidekiq containers                                                                                                                                                                                        | `true`                                                                     |
| `sidekiq.livenessProbe.initialDelaySeconds`                 | Delay before liveness probe is initiated                                                                                                                                                                                          | `500`                                                                      |
| `sidekiq.livenessProbe.periodSeconds`                       | How often to perform the probe                                                                                                                                                                                                    | `10`                                                                       |
| `sidekiq.livenessProbe.timeoutSeconds`                      | When the probe times out                                                                                                                                                                                                          | `5`                                                                        |
| `sidekiq.livenessProbe.failureThreshold`                    | Minimum consecutive failures for the probe                                                                                                                                                                                        | `6`                                                                        |
| `sidekiq.livenessProbe.successThreshold`                    | Minimum consecutive successes for the probe                                                                                                                                                                                       | `1`                                                                        |
| `sidekiq.readinessProbe.enabled`                            | Enable readinessProbe on Sidekiq containers                                                                                                                                                                                       | `true`                                                                     |
| `sidekiq.readinessProbe.initialDelaySeconds`                | Delay before readiness probe is initiated                                                                                                                                                                                         | `30`                                                                       |
| `sidekiq.readinessProbe.periodSeconds`                      | How often to perform the probe                                                                                                                                                                                                    | `10`                                                                       |
| `sidekiq.readinessProbe.timeoutSeconds`                     | When the probe times out                                                                                                                                                                                                          | `5`                                                                        |
| `sidekiq.readinessProbe.failureThreshold`                   | Minimum consecutive failures for the probe                                                                                                                                                                                        | `6`                                                                        |
| `sidekiq.readinessProbe.successThreshold`                   | Minimum consecutive successes for the probe                                                                                                                                                                                       | `1`                                                                        |
| `sidekiq.startupProbe.enabled`                              | Enable startupProbe on Sidekiq containers                                                                                                                                                                                         | `false`                                                                    |
| `sidekiq.startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                                            | `60`                                                                       |
| `sidekiq.startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                                   | `10`                                                                       |
| `sidekiq.startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                                  | `5`                                                                        |
| `sidekiq.startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                                | `15`                                                                       |
| `sidekiq.startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                                | `1`                                                                        |
| `sidekiq.customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                                                                                                                               | `{}`                                                                       |
| `sidekiq.customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                                                                                                                                              | `{}`                                                                       |
| `sidekiq.customStartupProbe`                                | Custom startupProbe that overrides the default one                                                                                                                                                                                | `{}`                                                                       |
| `sidekiq.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if sidekiq.resources is set (sidekiq.resources is recommended for production). | `small`                                                                    |
| `sidekiq.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                 | `{}`                                                                       |
| `sidekiq.containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                                                                                                                                              | `true`                                                                     |
| `sidekiq.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                                  | `{}`                                                                       |
| `sidekiq.containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                                                                                                                        | `0`                                                                        |
| `sidekiq.containerSecurityContext.runAsGroup`               | Set containers' Security Context runAsGroup                                                                                                                                                                                       | `0`                                                                        |
| `sidekiq.containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                                                                                                                                     | `false`                                                                    |
| `sidekiq.containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                                                                                                                                       | `false`                                                                    |
| `sidekiq.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                                           | `false`                                                                    |
| `sidekiq.containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                                                                                                                         | `false`                                                                    |
| `sidekiq.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                                | `["ALL"]`                                                                  |
| `sidekiq.containerSecurityContext.capabilities.add`         | List of capabilities to be added                                                                                                                                                                                                  | `["CHOWN","CHMOD","SYS_CHROOT","FOWNER","SETGID","SETUID","DAC_OVERRIDE"]` |
| `sidekiq.containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                                  | `RuntimeDefault`                                                           |
| `sidekiq.lifecycleHooks`                                    | for the Sidekiq container(s) to automate configuration before or after startup                                                                                                                                                    | `{}`                                                                       |
| `sidekiq.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the Sidekiq pods                                                                                                                                                     | `[]`                                                                       |

### Traffic Exposure Parameters

| Name                               | Description                                                                                                                      | Value                    |
| ---------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `service.type`                     | Discourse service type                                                                                                           | `ClusterIP`              |
| `service.ports.http`               | Discourse service HTTP port                                                                                                      | `80`                     |
| `service.nodePorts.http`           | Node port for HTTP                                                                                                               | `""`                     |
| `service.sessionAffinity`          | Control where client requests go, to the same pod or round-robin                                                                 | `None`                   |
| `service.sessionAffinityConfig`    | Additional settings for the sessionAffinity                                                                                      | `{}`                     |
| `service.clusterIP`                | Discourse service Cluster IP                                                                                                     | `""`                     |
| `service.loadBalancerIP`           | Discourse service Load Balancer IP                                                                                               | `""`                     |
| `service.loadBalancerSourceRanges` | Discourse service Load Balancer sources                                                                                          | `[]`                     |
| `service.externalTrafficPolicy`    | Discourse service external traffic policy                                                                                        | `Cluster`                |
| `service.annotations`              | Additional custom annotations for Discourse service                                                                              | `{}`                     |
| `service.extraPorts`               | Extra port to expose on Discourse service                                                                                        | `[]`                     |
| `ingress.enabled`                  | Enable ingress record generation for Discourse                                                                                   | `false`                  |
| `ingress.ingressClassName`         | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                    | `""`                     |
| `ingress.pathType`                 | Ingress path type                                                                                                                | `ImplementationSpecific` |
| `ingress.apiVersion`               | Force Ingress API version (automatically detected if not set)                                                                    | `""`                     |
| `ingress.hostname`                 | Default host for the ingress record                                                                                              | `discourse.local`        |
| `ingress.path`                     | Default path for the ingress record                                                                                              | `/`                      |
| `ingress.annotations`              | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                     |
| `ingress.tls`                      | Enable TLS configuration for the host defined at `ingress.hostname` parameter                                                    | `false`                  |
| `ingress.selfSigned`               | Create a TLS secret for this ingress record using self-signed certificates generated by Helm                                     | `false`                  |
| `ingress.extraHosts`               | An array with additional hostname(s) to be covered with the ingress record                                                       | `[]`                     |
| `ingress.extraPaths`               | An array with additional arbitrary paths that may need to be added to the ingress under the main host                            | `[]`                     |
| `ingress.extraTls`                 | TLS configuration for additional hostname(s) to be covered with this ingress record                                              | `[]`                     |
| `ingress.secrets`                  | Custom TLS certificates as secrets                                                                                               | `[]`                     |
| `ingress.extraRules`               | Additional rules to be covered with this ingress record                                                                          | `[]`                     |

### Volume Permissions parameters

| Name                                                             | Description                                                                                                                                                                                                                                           | Value                      |
| ---------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------- |
| `volumePermissions.enabled`                                      | Enable init container that changes the owner and group of the persistent volume                                                                                                                                                                       | `false`                    |
| `volumePermissions.image.registry`                               | Init container volume-permissions image registry                                                                                                                                                                                                      | `REGISTRY_NAME`            |
| `volumePermissions.image.repository`                             | Init container volume-permissions image repository                                                                                                                                                                                                    | `REPOSITORY_NAME/os-shell` |
| `volumePermissions.image.digest`                                 | Init container volume-permissions image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                     | `""`                       |
| `volumePermissions.image.pullPolicy`                             | Init container volume-permissions image pull policy                                                                                                                                                                                                   | `IfNotPresent`             |
| `volumePermissions.image.pullSecrets`                            | Init container volume-permissions image pull secrets                                                                                                                                                                                                  | `[]`                       |
| `volumePermissions.resourcesPreset`                              | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if volumePermissions.resources is set (volumePermissions.resources is recommended for production). | `nano`                     |
| `volumePermissions.resources`                                    | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                                     | `{}`                       |
| `volumePermissions.containerSecurityContext.seLinuxOptions`      | Set SELinux options in container                                                                                                                                                                                                                      | `{}`                       |
| `volumePermissions.containerSecurityContext.runAsUser`           | User ID for the init container                                                                                                                                                                                                                        | `0`                        |
| `volumePermissions.containerSecurityContext.seccompProfile.type` | Set container's Security Context seccomp profile                                                                                                                                                                                                      | `RuntimeDefault`           |

### Other Parameters

| Name                                          | Description                                                            | Value   |
| --------------------------------------------- | ---------------------------------------------------------------------- | ------- |
| `serviceAccount.create`                       | Enable creation of ServiceAccount for Discourse pods                   | `true`  |
| `serviceAccount.name`                         | The name of the ServiceAccount to use.                                 | `""`    |
| `serviceAccount.automountServiceAccountToken` | Allows auto mount of ServiceAccountToken on the serviceAccount created | `false` |
| `serviceAccount.annotations`                  | Additional custom annotations for the ServiceAccount                   | `{}`    |

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

### Discourse database parameters

| Name                                                 | Description                                                                                                                                                                                                                | Value                 |
| ---------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------- |
| `postgresql.enabled`                                 | Switch to enable or disable the PostgreSQL helm chart                                                                                                                                                                      | `true`                |
| `postgresql.auth.enablePostgresUser`                 | Assign a password to the "postgres" admin user. Otherwise, remote access will be blocked for this user                                                                                                                     | `true`                |
| `postgresql.auth.postgresPassword`                   | Password for the "postgres" admin user                                                                                                                                                                                     | `bitnami`             |
| `postgresql.auth.username`                           | Name for a custom user to create                                                                                                                                                                                           | `bn_discourse`        |
| `postgresql.auth.password`                           | Password for the custom user to create                                                                                                                                                                                     | `""`                  |
| `postgresql.auth.database`                           | Name for a custom database to create                                                                                                                                                                                       | `bitnami_application` |
| `postgresql.auth.existingSecret`                     | Name of existing secret to use for PostgreSQL credentials                                                                                                                                                                  | `""`                  |
| `postgresql.architecture`                            | PostgreSQL architecture (`standalone` or `replication`)                                                                                                                                                                    | `standalone`          |
| `postgresql.primary.resourcesPreset`                 | Set container resources according to one common preset (allowed values: none, nano, small, medium, large, xlarge, 2xlarge). This is ignored if primary.resources is set (primary.resources is recommended for production). | `nano`                |
| `postgresql.primary.resources`                       | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                          | `{}`                  |
| `externalDatabase.host`                              | Database host                                                                                                                                                                                                              | `localhost`           |
| `externalDatabase.port`                              | Database port number                                                                                                                                                                                                       | `5432`                |
| `externalDatabase.user`                              | Non-root username for Discourse                                                                                                                                                                                            | `bn_discourse`        |
| `externalDatabase.password`                          | Password for the non-root username for Discourse                                                                                                                                                                           | `""`                  |
| `externalDatabase.database`                          | Discourse database name                                                                                                                                                                                                    | `bitnami_application` |
| `externalDatabase.create`                            | Switch to enable user/database creation during the installation stage                                                                                                                                                      | `true`                |
| `externalDatabase.postgresUser`                      | PostgreSQL admin user, used during the installation stage                                                                                                                                                                  | `""`                  |
| `externalDatabase.postgresPassword`                  | PostgreSQL admin password, used during the installation stage                                                                                                                                                              | `""`                  |
| `externalDatabase.existingSecret`                    | Name of an existing secret resource containing the database credentials                                                                                                                                                    | `""`                  |
| `externalDatabase.existingSecretPasswordKey`         | Name of an existing secret key containing the database credentials                                                                                                                                                         | `password`            |
| `externalDatabase.existingSecretPostgresPasswordKey` | Name of an existing secret key containing the database admin user credentials                                                                                                                                              | `postgres-password`   |

### Redis&reg; parameters

| Name                                      | Description                                                                                                                                                                                                              | Value            |
| ----------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ---------------- |
| `redis.enabled`                           | Switch to enable or disable the Redis&reg; helm                                                                                                                                                                          | `true`           |
| `redis.auth.enabled`                      | Enable password authentication                                                                                                                                                                                           | `true`           |
| `redis.auth.password`                     | Redis&reg; password                                                                                                                                                                                                      | `""`             |
| `redis.auth.existingSecret`               | The name of an existing secret with Redis&reg; credentials                                                                                                                                                               | `""`             |
| `redis.architecture`                      | Redis&reg; architecture. Allowed values: `standalone` or `replication`                                                                                                                                                   | `standalone`     |
| `redis.master.resourcesPreset`            | Set container resources according to one common preset (allowed values: none, nano, small, medium, large, xlarge, 2xlarge). This is ignored if master.resources is set (master.resources is recommended for production). | `nano`           |
| `redis.master.resources`                  | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                        | `{}`             |
| `externalRedis.host`                      | Redis&reg; host                                                                                                                                                                                                          | `localhost`      |
| `externalRedis.port`                      | Redis&reg; port number                                                                                                                                                                                                   | `6379`           |
| `externalRedis.password`                  | Redis&reg; password                                                                                                                                                                                                      | `""`             |
| `externalRedis.existingSecret`            | Name of an existing secret resource containing the Redis&trade credentials                                                                                                                                               | `""`             |
| `externalRedis.existingSecretPasswordKey` | Name of an existing secret key containing the Redis&trade credentials                                                                                                                                                    | `redis-password` |

The above parameters map to the env variables defined in [bitnami/discourse](https://github.com/bitnami/containers/tree/main/bitnami/discourse). For more information please refer to the [bitnami/discourse](https://github.com/bitnami/containers/tree/main/bitnami/discourse) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
  --set auth.username=admin,auth.password=password \
    oci://REGISTRY_NAME/REPOSITORY_NAME/discourse
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The above command sets the Discourse administrator account username and password to `admin` and `password` respectively.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml oci://REGISTRY_NAME/REPOSITORY_NAME/discourse
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.
> **Tip**: You can use the default [values.yaml](https://github.com/bitnami/charts/tree/main/bitnami/discourse/values.yaml)

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 13.0.0

This major bump changes the following security defaults:

- `resourcesPreset` is changed from `none` to the minimum size working in our test suites (NOTE: `resourcesPreset` is not meant for production usage, but `resources` adapted to your use case).
- `global.compatibility.openshift.adaptSecurityContext` is changed from `disabled` to `auto`.
- The `networkPolicy` section has been normalized amongst all Bitnami charts. Compared to the previous approach, the values section has been simplified (check the Parameters section) and now it set to `enabled=true` by default. Egress traffic is allowed by default and ingress traffic is allowed by all pods but only to the ports set in `containerPorts` and `extraContainerPorts`.

This could potentially break any customization or init scripts used in your deployment. If this is the case, change the default values to the previous ones.

### To 12.0.0

This major updates the PostgreSQL subchart to its newest major, 13.0.0. [Here](https://github.com/bitnami/charts/tree/master/bitnami/postgresql#to-1300) you can find more information about the changes introduced in that version.

### To 11.0.0

This major updates the Redis&reg; subchart to its newest major, 18.0.0. [Here](https://github.com/bitnami/charts/tree/main/bitnami/redis#to-1800) you can find more information about the changes introduced in that version.

NOTE: Due to an error in our release process, Redis&reg;' chart versions higher or equal than 17.15.4 already use Redis&reg; 7.2 by default.

### To 9.0.0

This major updates the PostgreSQL subchart to its newest major, 12.0.0. [Here](https://github.com/bitnami/charts/tree/master/bitnami/postgresql#to-1200) you can find more information about the changes introduced in that version.

### To 8.0.0

This major update the Redis&reg; subchart to its newest major, 17.0.0, which updates Redis&reg; from its version 6.2 to the latest 7.0.

### To 7.0.0

This major upgrades the Discourse version to _2.8.0_.

#### What changes were introduced in this major version?

This version includes a breaking change in the _lazy-yt_ plugin, and the recommendation is to remove it, or manually upgrade it.

#### Upgrading Instructions

To upgrade to _7.0.0_ from _6.x_, follow these steps below:

1. Upgrade to the latest version of the _bitnami/discourse_ chart with Diagnostics mode:

```console
helm upgrade --set diagnosticMode.enabled=true [...] bitnami/discourse
```

1. Remove or upgrade the _lazy-yt_ plugin. To remove it, execute the following command inside the _discourse_ container's shell:

```console
rm -rf /bitnami/discourse/plugins/lazy-yt
```

1. Ensure that the initialization scripts work:

```console
/opt/bitnami/scripts/discourse/entrypoint.sh /opt/bitnami/scripts/discourse/setup.sh
```

1. Upgrade the Helm deployment without Diagnostics mode.

### To 6.0.0

This major release renames several values in this chart and adds missing features, in order to be inline with the rest of assets in the Bitnami charts repository. Additionally updates the PostgreSQL & Redis subcharts to their newest major 11.x.x and 16.x.x, respectively, which contain similar changes.

- _discourse.host_ and _discourse.siteName_ were renamed to _host_ and _siteName_, respectively.
- _discourse.username_, _discourse.email_, _discourse.password_ and _discourse.existingSecret_ were regrouped under the _discourse.auth_ map.
- _discourse.smtp_ map has been renamed to _smtp_.
- _service.port_ and _service.nodePort_ were regrouped under the _service.ports_ and _service.nodePorts_ maps, respectively.
- _ingress_ map is completely redefined.

#### How to upgrade to version 6.0.0

To upgrade to _6.0.0_ from _5.x_, it should be done reusing the PVC(s) used to hold the data on your previous release. To do so, follow the instructions below (the following example assumes that the release name is _discourse_ and the release namespace _default_):

> NOTE: Please, create a backup of your database before running any of those actions.

1. Obtain the credentials and the names of the PVCs used to hold the data on your current release:

```console
export DISCOURSE_PASSWORD=$(kubectl get secret --namespace default discourse -o jsonpath="{.data.discourse-password}" | base64 --decode)
export POSTGRESQL_PASSWORD=$(kubectl get secret --namespace default discourse-postgresql -o jsonpath="{.data.postgresql-password}" | base64 --decode)
export REDIS_PASSWORD=$(kubectl get secret --namespace default discourse-redis -o jsonpath="{.data.redis-password}" | base64 --decode)
export POSTGRESQL_PVC=$(kubectl get pvc -l app.kubernetes.io/instance=discourse,app.kubernetes.io/name=postgresql,role=primary -o jsonpath="{.items[0].metadata.name}")
```

1. Delete the PostgreSQL statefulset (notice the option _--cascade=false_) and secret:

```console
kubectl delete statefulsets.apps --cascade=false discourse-postgresql
kubectl delete secret postgresql --namespace default
```

1. Upgrade your release using the same PostgreSQL version:

```console
CURRENT_PG_VERSION=$(kubectl exec discourse-postgresql-0 -- bash -c 'echo $BITNAMI_IMAGE_VERSION')
helm upgrade discourse bitnami/discourse \
  --set loadExamples=true \
  --set web.baseUrl=http://127.0.0.1:8080 \
  --set auth.password=$DISCOURSE_PASSWORD \
  --set postgresql.image.tag=$CURRENT_VERSION \
  --set postgresql.auth.password=$POSTGRESQL_PASSWORD \
  --set postgresql.persistence.existingClaim=$POSTGRESQL_PVC \
  --set redis.password=$REDIS_PASSWORD
```

1. Delete the existing PostgreSQL pods and the new statefulset will create a new one:

```console
kubectl delete pod discourse-postgresql-0
```

### To 5.0.0

This major update the Redis&reg; subchart to its newest major, 15.0.0. For more information on this subchart's major and the steps needed to migrate your data from your previous release, please refer to [Redis&reg; upgrade notes.](https://github.com/bitnami/charts/tree/main/bitnami/redis#to-1500).

### To 4.0.0

The [Bitnami Discourse](https://github.com/bitnami/containers/tree/main/bitnami/discourse) image was refactored and now the source code is published in GitHub in the `rootfs` folder of the container image repository.

#### How to upgrade to version 4.0.0

Upgrades from previous versions require to specify `--set volumePermissions.enabled=true` in order for all features to work properly:

```console
helm upgrade discourse bitnami/discourse \
    --set discourse.host=$DISCOURSE_HOST \
    --set discourse.password=$DISCOURSE_PASSWORD \
    --set postgresql.postgresqlPassword=$POSTGRESQL_PASSWORD \
    --set postgresql.persistence.existingClaim=$POSTGRESQL_PVC \
    --set volumePermissions.enabled=true
```

Full compatibility is not guaranteed due to the amount of involved changes, however no breaking changes are expected aside from the ones mentioned above.

### To 3.0.0

This major updates the Redis&reg; subchart to it newest major, 14.0.0, which contains breaking changes. For more information on this subchart's major and the steps needed to migrate your data from your previous release, please refer to [Redis&reg; upgrade notes.](https://github.com/bitnami/charts/tree/main/bitnami/redis#to-1400).

### To 2.0.0

[On November 13, 2020, Helm v2 support was formally finished](https://github.com/helm/charts#status-of-the-project), this major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

- Previous versions of this Helm Chart use `apiVersion: v1` (installable by both Helm 2 and 3), this Helm Chart was updated to `apiVersion: v2` (installable by Helm 3 only). [Here](https://helm.sh/docs/topics/charts/#the-apiversion-field) you can find more information about the `apiVersion` field.
- Move dependency information from the _requirements.yaml_ to the _Chart.yaml_
- After running _helm dependency update_, a _Chart.lock_ file is generated containing the same structure used in the previous _requirements.lock_
- The different fields present in the _Chart.yaml_ file has been ordered alphabetically in a homogeneous way for all the Bitnami Helm Chart.

#### Considerations when upgrading to this version

- If you want to upgrade to this version using Helm v2, this scenario is not supported as this version does not support Helm v2 anymore.
- If you installed the previous version with Helm v2 and wants to upgrade to this version with Helm v3, please refer to the [official Helm documentation](https://helm.sh/docs/topics/v2_v3_migration/#migration-use-cases) about migrating from Helm v2 to v3.

#### Useful links

- [Bitnami Tutorial](https://docs.vmware.com/en/VMware-Tanzu-Application-Catalog/services/tutorials/GUID-resolve-helm2-helm3-post-migration-issues-index.html)
- [Helm docs](https://helm.sh/docs/topics/v2_v3_migration)
- [Helm Blog](https://helm.sh/blog/migrate-from-helm-v2-to-helm-v3)

#### How to upgrade to version 2.0.0

To upgrade to _2.0.0_ from _1.x_, it should be done reusing the PVC(s) used to hold the data on your previous release. To do so, follow the instructions below (the following example assumes that the release name is _discourse_ and the release namespace _default_):

> NOTE: Please, create a backup of your database before running any of those actions.

1. Obtain the credentials and the names of the PVCs used to hold the data on your current release:

```console
export DISCOURSE_PASSWORD=$(kubectl get secret --namespace default discourse -o jsonpath="{.data.discourse-password}" | base64 --decode)
export DISCOURSE_FERNET_KEY=$(kubectl get secret --namespace default discourse -o jsonpath="{.data.discourse-fernetKey}" | base64 --decode)
export DISCOURSE_SECRET_KEY=$(kubectl get secret --namespace default discourse -o jsonpath="{.data.discourse-secretKey}" | base64 --decode)
export POSTGRESQL_PASSWORD=$(kubectl get secret --namespace default discourse-postgresql -o jsonpath="{.data.postgresql-password}" | base64 --decode)
export REDIS_PASSWORD=$(kubectl get secret --namespace default discourse-redis -o jsonpath="{.data.redis-password}" | base64 --decode)
export POSTGRESQL_PVC=$(kubectl get pvc -l app.kubernetes.io/instance=discourse,app.kubernetes.io/name=postgresql,role=primary -o jsonpath="{.items[0].metadata.name}")
```

1. Delete the Airflow worker & PostgreSQL statefulset (notice the option _--cascade=false_):

```console
kubectl delete statefulsets.apps --cascade=false discourse-postgresql
kubectl delete statefulsets.apps --cascade=false discourse-worker
```

1. Upgrade your release:

> NOTE: Please remember to migrate all the values to its new path following the above notes, e.g: `discourse.loadExamples` -> `loadExamples` or `discourse.baseUrl=http://127.0.0.1:8080` -> `web.baseUrl=http://127.0.0.1:8080`.

```console
helm upgrade discourse bitnami/discourse \
  --set loadExamples=true \
  --set web.baseUrl=http://127.0.0.1:8080 \
  --set auth.password=$DISCOURSE_PASSWORD \
  --set auth.fernetKey=$DISCOURSE_FERNET_KEY \
  --set auth.secretKey=$DISCOURSE_SECRET_KEY \
  --set postgresql.postgresqlPassword=$POSTGRESQL_PASSWORD \
  --set postgresql.persistence.existingClaim=$POSTGRESQL_PVC \
  --set redis.password=$REDIS_PASSWORD \
  --set redis.cluster.enabled=true
```

1. Delete the existing Airflow worker & PostgreSQL pods and the new statefulset will create a new one:

```console
kubectl delete pod discourse-postgresql-0
kubectl delete pod discourse-worker-0
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