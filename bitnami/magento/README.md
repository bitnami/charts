<!--- app-name: Magento -->

# Bitnami package for Magento

Magento is a powerful open source e-commerce platform. With easy customizations and rich features, it allows retailers to grow their online businesses in a cost-effective way.

[Overview of Magento](http://www.magento.com)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/magento
```

Looking to use Magento in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the enterprise edition of Bitnami Application Catalog.

## Introduction

This chart bootstraps a [Magento](https://github.com/bitnami/containers/tree/main/bitnami/magento) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages the [Bitnami MariaDB chart](https://github.com/bitnami/charts/tree/main/bitnami/mariadb) which is required for bootstrapping a MariaDB deployment as a database for the Magento application.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+
- PV provisioner support in the underlying infrastructure
- ReadWriteMany volumes for deployment scaling

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/magento
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The command deploys Magento on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Configuration and installation details

### Resource requests and limits

Bitnami charts allow setting resource requests and limits for all containers inside the chart deployment. These are inside the `resources` value (check parameter table). Setting requests is essential for production workloads and these should be adapted to your specific use case.

To make this process easier, the chart contains the `resourcesPreset` values, which automatically sets the `resources` section according to different presets. Check these presets in [the bitnami/common chart](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15). However, in production workloads using `resourcePreset` is discouraged as it may not fully adapt to your specific needs. Find more information on container resource management in the [official Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).

### [Rolling VS Immutable tags](https://docs.vmware.com/en/VMware-Tanzu-Application-Catalog/services/tutorials/GUID-understand-rolling-tags-containers-index.html)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Image

The `image` parameter allows specifying which image will be pulled for the chart.

#### Private registry

If you configure the `image` value to one in a private registry, you will need to [specify an image pull secret](https://kubernetes.io/docs/concepts/containers/images/#specifying-imagepullsecrets-on-a-pod).

1. Manually create image pull secret(s) in the namespace. See [this YAML example reference](https://kubernetes.io/docs/concepts/containers/images/#creating-a-secret-with-a-docker-config). Consult your image registry's documentation about getting the appropriate secret.
2. Note that the `imagePullSecrets` configuration value cannot currently be passed to helm using the `--set` parameter, so you must supply these using a `values.yaml` file, such as:

    ```yaml
    imagePullSecrets:
      - name: SECRET_NAME
    ```

3. Install the chart

### Ingress

This chart provides support for Ingress resources. If you have an ingress controller installed on your cluster, such as [nginx-ingress-controller](https://github.com/bitnami/charts/tree/main/bitnami/nginx-ingress-controller) or [contour](https://github.com/bitnami/charts/tree/main/bitnami/contour) you can utilize the ingress controller to serve your application.

To enable ingress integration, please set `ingress.enabled` to `true`.

#### Hosts

Most likely you will only want to have one hostname that maps to this Magento installation. If that's your case, the property `ingress.hostname` will set it. However, it is possible to have more than one host. To facilitate this, the `ingress.extraHosts` object can be specified as an array. You can also use `ingress.extraTLS` to add the TLS configuration for extra hosts.

For each host indicated at `ingress.extraHosts`, please indicate a `name`, `path`, and any `annotations` that you may want the ingress controller to know about.

For annotations, please see [this document](https://github.com/kubernetes/ingress-nginx/blob/main/docs/user-guide/nginx-configuration/annotations.md). Not all annotations are supported by all ingress controllers, but this document does a good job of indicating which annotation is supported by many popular ingress controllers.

### Certificates

#### TLS Secrets

This chart will facilitate the creation of TLS secrets for use with the ingress controller, however, this is not required. There are three common use cases:

- Helm generates/manages certificate secrets.
- User generates/manages certificates separately.
- An additional tool (like [cert-manager](https://github.com/jetstack/cert-manager/)) manages the secrets for the application.

In the first two cases, it's needed a certificate and a key. We would expect them to look like this:

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

If you are going to use Helm to manage the certificates, please copy these values into the `certificate` and `key` values for a given `ingress.secrets` entry.

If you are going to manage TLS secrets outside of Helm, please know that you can create a TLS secret (named `magento.local-tls` for example).

#### CA Certificates

Custom CA certificates not included in the base docker image can be added by means of existing secrets. The secret must exist in the same namespace and contain the desired CA certificates to import. By default, all found certificate files will be loaded.

```yaml
certificates:
  customCAs:
  - secret: my-ca-1
  - secret: my-ca-2
```

> Tip! You can create a secret containing your CA certificates using the following command:

```console
kubectl create secret generic my-ca-1 --from-file my-ca-1.crt
```

### Adding extra environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `extraEnvVars` property.

```yaml
extraEnvVars:
  - name: LOG_LEVEL
    value: DEBUG
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values.

### Sidecars and Init Containers

If you have a need for additional containers to run within the same pod as Magento (e.g. an additional metrics or logging exporter), you can do so via the `sidecars` config parameter. Simply define your container according to the Kubernetes container spec.

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

### Using an external database

Sometimes you may want to have Magento connect to an external database rather than installing one inside your cluster, e.g. to use a managed database service, or use run a single database server for all your applications. To do this, the chart allows you to specify credentials for an external database under the [`externalDatabase` parameter](#parameters). You should also disable the MariaDB installation with the `mariadb.enabled` option. For example with the following parameters:

```console
mariadb.enabled=false
externalDatabase.host=myexternalhost
externalDatabase.user=myuser
externalDatabase.password=mypassword
externalDatabase.database=mydatabase
externalDatabase.port=3306
```

Note also if you disable MariaDB per above you MUST supply values for the `externalDatabase` connection.

In case the database already contains data from a previous Magento installation, you need to set the `magentoSkipInstall` parameter to _true_. Otherwise, the container would execute the installation wizard and could modify the existing data in the database. This parameter force the container to not execute the Magento installation wizard. This is necessary in case you use a database that already has Magento data [+info](https://github.com/bitnami/containers/tree/main/bitnami/magento#connect-magento-docker-container-to-an-existing-database).

### Deploying extra resources

There are cases where you may want to deploy extra objects, such a ConfigMap containing your app's configuration or some extra deployment with a micro service used by your app. For covering this case, the chart allows adding the full specification of other objects using the `extraDeploy` parameter.

### Setting Pod's affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more infomation about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

## Persistence

The [Bitnami Magento](https://github.com/bitnami/containers/tree/main/bitnami/magento) image stores the Magento data and configurations at the `/bitnami/magento` and `/bitnami/apache` paths of the container.

Persistent Volume Claims are used to keep the data across deployments. There is a [known issue](https://github.com/kubernetes/kubernetes/issues/39178) in Kubernetes Clusters with EBS in different availability zones. Ensure your cluster is configured properly to create Volumes in the same availability zone where the nodes are running. Kuberentes 1.12 solved this issue with the [Volume Binding Mode](https://kubernetes.io/docs/concepts/storage/storage-classes/#volume-binding-mode).

See the [Parameters](#parameters) section to configure the PVC or to disable persistence.

### Existing PersistentVolumeClaim

1. Create the PersistentVolume
2. Create the PersistentVolumeClaim
3. Install the chart

    ```console
    helm install my-release --set persistence.existingClaim=PVC_NAME oci://REGISTRY_NAME/REPOSITORY_NAME/magento
    ```

    > Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

### Host path

#### System compatibility

- The local filesystem accessibility to a container in a pod with `hostPath` has been tested on OSX/MacOS with xhyve, and Linux with VirtualBox.
- Windows has not been tested with the supported VM drivers. Minikube does however officially support [Mounting Host Folders](https://minikube.sigs.k8s.io/docs/handbook/mount/) per pod. Or you may manually sync your container whenever host files are changed with tools like [docker-sync](https://github.com/EugenMayer/docker-sync) or [docker-bg-sync](https://github.com/cweagans/docker-bg-sync).

#### Mounting steps

1. The specified `hostPath` directory must already exist (create one if it does not).
2. Install the chart

    ```console
    helm install my-release --set persistence.hostPath=/PATH/TO/HOST/MOUNT oci://REGISTRY_NAME/REPOSITORY_NAME/magento
    ```

    > Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

    This will mount the `magento-data` volume into the `hostPath` directory. The site data will be persisted if the mount path contains valid data, else the site data will be initialized at first launch.
3. Because the container cannot control the host machine's directory permissions, you must set the Magento file directory permissions yourself and disable or clear Magento cache.

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
| `kubeVersion`            | Force target Kubernetes version (using Helm capabilities if not set)                    | `""`           |
| `nameOverride`           | String to partially override magento.fullname template                                  | `""`           |
| `fullnameOverride`       | String to fully override magento.fullname template                                      | `""`           |
| `namespaceOverride`      | String to fully override common.names.namespace                                         | `""`           |
| `commonAnnotations`      | Annotations to add to all deployed objects                                              | `{}`           |
| `commonLabels`           | Labels to add to all deployed objects                                                   | `{}`           |
| `extraDeploy`            | Array of extra objects to deploy with the release (evaluated as a template).            | `[]`           |
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden) | `false`        |
| `diagnosticMode.command` | Command to override all containers in the deployment                                    | `["sleep"]`    |
| `diagnosticMode.args`    | Args to override all containers in the deployment                                       | `["infinity"]` |

### Magento parameters

| Name                                                | Description                                                                                                                                                                                                       | Value                     |
| --------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------- |
| `image.registry`                                    | Magento image registry                                                                                                                                                                                            | `REGISTRY_NAME`           |
| `image.repository`                                  | Magento image repository                                                                                                                                                                                          | `REPOSITORY_NAME/magento` |
| `image.digest`                                      | Magento image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                           | `""`                      |
| `image.pullPolicy`                                  | Magento image pull policy                                                                                                                                                                                         | `IfNotPresent`            |
| `image.pullSecrets`                                 | Specify docker-registry secret names as an array                                                                                                                                                                  | `[]`                      |
| `image.debug`                                       | Specify if debug logs should be enabled                                                                                                                                                                           | `false`                   |
| `automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                | `false`                   |
| `hostAliases`                                       | Add deployment host aliases                                                                                                                                                                                       | `[]`                      |
| `replicaCount`                                      | Number of Magento Pods to run                                                                                                                                                                                     | `1`                       |
| `magentoSkipInstall`                                | Skip Magento installation wizard. Useful for migrations and restoring from SQL dump                                                                                                                               | `false`                   |
| `magentoHost`                                       | Magento host to create application URLs                                                                                                                                                                           | `""`                      |
| `magentoUsername`                                   | User of the application                                                                                                                                                                                           | `user`                    |
| `magentoPassword`                                   | Application password                                                                                                                                                                                              | `""`                      |
| `magentoEmail`                                      | Admin email                                                                                                                                                                                                       | `user@example.com`        |
| `magentoFirstName`                                  | Magento Admin First Name                                                                                                                                                                                          | `""`                      |
| `magentoLastName`                                   | Magento Admin Last Name                                                                                                                                                                                           | `""`                      |
| `magentoAdminUri`                                   | Magento prefix to access Magento Admin                                                                                                                                                                            | `""`                      |
| `magentoMode`                                       | Magento mode                                                                                                                                                                                                      | `""`                      |
| `magentoExtraInstallArgs`                           | Magento extra install args                                                                                                                                                                                        | `""`                      |
| `magentoDeployStaticContent`                        | Deploy static content during the first deployment, to optimize page load time                                                                                                                                     | `false`                   |
| `magentoUseHttps`                                   | Use SSL to access the Magento Store. Valid values: `true`, `false`                                                                                                                                                | `false`                   |
| `magentoUseSecureAdmin`                             | Use SSL to access the Magento Admin. Valid values: `true`, `false`                                                                                                                                                | `false`                   |
| `magentoSkipReindex`                                | Skip Magento Indexer reindex step during the initialization. Valid values: `true`, `false`                                                                                                                        | `false`                   |
| `allowEmptyPassword`                                | Allow DB blank passwords                                                                                                                                                                                          | `false`                   |
| `command`                                           | Override default container command (useful when using custom images)                                                                                                                                              | `[]`                      |
| `args`                                              | Override default container args (useful when using custom images)                                                                                                                                                 | `[]`                      |
| `updateStrategy.type`                               | Update strategy - only really applicable for deployments with RWO PVs attached                                                                                                                                    | `RollingUpdate`           |
| `extraEnvVars`                                      | Extra environment variables                                                                                                                                                                                       | `[]`                      |
| `extraEnvVarsCM`                                    | ConfigMap containing extra env vars                                                                                                                                                                               | `""`                      |
| `extraEnvVarsSecret`                                | Secret containing extra env vars (in case of sensitive data)                                                                                                                                                      | `""`                      |
| `extraVolumes`                                      | Array of extra volumes to be added to the deployment (evaluated as template). Requires setting `extraVolumeMounts`                                                                                                | `[]`                      |
| `extraVolumeMounts`                                 | Array of extra volume mounts to be added to the container (evaluated as template). Normally used with `extraVolumes`                                                                                              | `[]`                      |
| `extraContainerPorts`                               | Array of additional container ports for the Magento container                                                                                                                                                     | `[]`                      |
| `initContainers`                                    | Add additional init containers to the pod (evaluated as a template)                                                                                                                                               | `[]`                      |
| `sidecars`                                          | Attach additional containers to the pod (evaluated as a template)                                                                                                                                                 | `[]`                      |
| `tolerations`                                       | Tolerations for pod assignment                                                                                                                                                                                    | `[]`                      |
| `priorityClassName`                                 | %%MAIN_CONTAINER_NAME%% pods' priorityClassName                                                                                                                                                                   | `""`                      |
| `schedulerName`                                     | Name of the k8s scheduler (other than default)                                                                                                                                                                    | `""`                      |
| `terminationGracePeriodSeconds`                     | In seconds, time the given to the %%MAIN_CONTAINER_NAME%% pod needs to terminate gracefully                                                                                                                       | `""`                      |
| `topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment                                                                                                                                                                    | `[]`                      |
| `existingSecret`                                    | Name of a secret with the application password                                                                                                                                                                    | `""`                      |
| `containerPorts`                                    | Container ports                                                                                                                                                                                                   | `{}`                      |
| `podAffinityPreset`                                 | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                               | `""`                      |
| `podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                          | `soft`                    |
| `nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                         | `""`                      |
| `nodeAffinityPreset.key`                            | Node label key to match Ignored if `affinity` is set.                                                                                                                                                             | `""`                      |
| `nodeAffinityPreset.values`                         | Node label values to match. Ignored if `affinity` is set.                                                                                                                                                         | `[]`                      |
| `affinity`                                          | Affinity for pod assignment                                                                                                                                                                                       | `{}`                      |
| `nodeSelector`                                      | Node labels for pod assignment                                                                                                                                                                                    | `{}`                      |
| `resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if resources is set (resources is recommended for production). | `medium`                  |
| `resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                 | `{}`                      |
| `podSecurityContext.enabled`                        | Enable Magento pods' Security Context                                                                                                                                                                             | `true`                    |
| `podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                | `Always`                  |
| `podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                    | `[]`                      |
| `podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                       | `[]`                      |
| `podSecurityContext.fsGroup`                        | Magento pods' group ID                                                                                                                                                                                            | `1001`                    |
| `containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                                                                                                                              | `true`                    |
| `containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                  | `{}`                      |
| `containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                                                                                                        | `1001`                    |
| `containerSecurityContext.runAsGroup`               | Set containers' Security Context runAsGroup                                                                                                                                                                       | `0`                       |
| `containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                                                                                                                     | `true`                    |
| `containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                                                                                                                       | `false`                   |
| `containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                           | `false`                   |
| `containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                                                                                                         | `false`                   |
| `containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                | `["ALL"]`                 |
| `containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                  | `RuntimeDefault`          |
| `livenessProbe.enabled`                             | Enable livenessProbe                                                                                                                                                                                              | `true`                    |
| `livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                           | `300`                     |
| `livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                  | `10`                      |
| `livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                 | `5`                       |
| `livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                               | `6`                       |
| `livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                               | `1`                       |
| `readinessProbe.enabled`                            | Enable readinessProbe                                                                                                                                                                                             | `true`                    |
| `readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                          | `30`                      |
| `readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                 | `5`                       |
| `readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                | `3`                       |
| `readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                              | `6`                       |
| `readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                              | `1`                       |
| `startupProbe.enabled`                              | Enable startupProbe                                                                                                                                                                                               | `false`                   |
| `startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                            | `0`                       |
| `startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                   | `10`                      |
| `startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                  | `3`                       |
| `startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                | `60`                      |
| `startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                | `1`                       |
| `customLivenessProbe`                               | Override default liveness probe                                                                                                                                                                                   | `{}`                      |
| `customReadinessProbe`                              | Override default readiness probe                                                                                                                                                                                  | `{}`                      |
| `customStartupProbe`                                | Override default startup probe                                                                                                                                                                                    | `{}`                      |
| `lifecycleHooks`                                    | LifecycleHook to set additional configuration at startup Evaluated as a template                                                                                                                                  | `{}`                      |
| `podAnnotations`                                    | Pod annotations                                                                                                                                                                                                   | `{}`                      |
| `podLabels`                                         | Add additional labels to the pod (evaluated as a template)                                                                                                                                                        | `{}`                      |

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

### Database parameters

| Name                                        | Description                                                                                                                                                                                                                | Value                     |
| ------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------- |
| `mariadb.enabled`                           | Whether to deploy a mariadb server to satisfy the applications database requirements.                                                                                                                                      | `true`                    |
| `mariadb.image.registry`                    | MariaDB image registry                                                                                                                                                                                                     | `REGISTRY_NAME`           |
| `mariadb.image.repository`                  | MariaDB image repository                                                                                                                                                                                                   | `REPOSITORY_NAME/mariadb` |
| `mariadb.image.digest`                      | MariaDB image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                    | `""`                      |
| `mariadb.architecture`                      | MariaDB architecture. Allowed values: `standalone` or `replication`                                                                                                                                                        | `standalone`              |
| `mariadb.auth.rootPassword`                 | Password for the MariaDB `root` user                                                                                                                                                                                       | `""`                      |
| `mariadb.auth.database`                     | Database name to create                                                                                                                                                                                                    | `bitnami_magento`         |
| `mariadb.auth.username`                     | Database user to create                                                                                                                                                                                                    | `bn_magento`              |
| `mariadb.auth.password`                     | Password for the database                                                                                                                                                                                                  | `""`                      |
| `mariadb.primary.persistence.enabled`       | Enable database persistence using PVC                                                                                                                                                                                      | `true`                    |
| `mariadb.primary.persistence.storageClass`  | MariaDB primary persistent volume storage Class                                                                                                                                                                            | `""`                      |
| `mariadb.primary.persistence.accessModes`   | Database Persistent Volume Access Modes                                                                                                                                                                                    | `["ReadWriteOnce"]`       |
| `mariadb.primary.persistence.size`          | Database Persistent Volume Size                                                                                                                                                                                            | `8Gi`                     |
| `mariadb.primary.persistence.hostPath`      | Set path in case you want to use local host path volumes (not recommended in production)                                                                                                                                   | `""`                      |
| `mariadb.primary.persistence.existingClaim` | Name of an existing `PersistentVolumeClaim` for MariaDB primary replicas                                                                                                                                                   | `""`                      |
| `mariadb.primary.resourcesPreset`           | Set container resources according to one common preset (allowed values: none, nano, small, medium, large, xlarge, 2xlarge). This is ignored if primary.resources is set (primary.resources is recommended for production). | `micro`                   |
| `mariadb.primary.resources`                 | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                          | `{}`                      |
| `externalDatabase.host`                     | Host of the existing database                                                                                                                                                                                              | `""`                      |
| `externalDatabase.port`                     | Port of the existing database                                                                                                                                                                                              | `3306`                    |
| `externalDatabase.user`                     | Existing username in the external db                                                                                                                                                                                       | `bn_magento`              |
| `externalDatabase.password`                 | Password for the above username                                                                                                                                                                                            | `""`                      |
| `externalDatabase.database`                 | Name of the existing database                                                                                                                                                                                              | `bitnami_magento`         |
| `externalDatabase.existingSecret`           | Name of an existing secret resource containing the DB password                                                                                                                                                             | `""`                      |

### Elasticsearch parameters

| Name                                         | Description                                                                                                                                                                                                                          | Value                           |
| -------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------- |
| `elasticsearch.enabled`                      | Whether to deploy a elasticsearch server to use as magento's search engine                                                                                                                                                           | `true`                          |
| `elasticsearch.image.registry`               | Elasticsearch image registry                                                                                                                                                                                                         | `REGISTRY_NAME`                 |
| `elasticsearch.image.repository`             | Elasticsearch image repository                                                                                                                                                                                                       | `REPOSITORY_NAME/elasticsearch` |
| `elasticsearch.image.digest`                 | Elasticsearch image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                        | `""`                            |
| `elasticsearch.sysctlImage.enabled`          | Enable kernel settings modifier image for Elasticsearch                                                                                                                                                                              | `true`                          |
| `elasticsearch.master.replicaCount`          | Desired number of Elasticsearch master-eligible nodes                                                                                                                                                                                | `1`                             |
| `elasticsearch.master.resourcesPreset`       | Set container resources according to one common preset (allowed values: none, nano, small, medium, large, xlarge, 2xlarge). This is ignored if master.resources is set (master.resources is recommended for production).             | `small`                         |
| `elasticsearch.master.resources`             | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                    | `{}`                            |
| `elasticsearch.coordinating.replicaCount`    | Desired number of Elasticsearch coordinating-only nodes                                                                                                                                                                              | `1`                             |
| `elasticsearch.coordinating.resourcesPreset` | Set container resources according to one common preset (allowed values: none, nano, small, medium, large, xlarge, 2xlarge). This is ignored if coordinating.resources is set (coordinating.resources is recommended for production). | `small`                         |
| `elasticsearch.coordinating.resources`       | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                    | `{}`                            |
| `elasticsearch.data.replicaCount`            | Desired number of Elasticsearch data nodes                                                                                                                                                                                           | `1`                             |
| `elasticsearch.data.resourcesPreset`         | Set container resources according to one common preset (allowed values: none, nano, small, medium, large, xlarge, 2xlarge). This is ignored if data.resources is set (data.resources is recommended for production).                 | `medium`                        |
| `elasticsearch.data.resources`               | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                    | `{}`                            |
| `elasticsearch.ingest.replicaCount`          | Desired number of Elasticsearch ingest nodes                                                                                                                                                                                         | `1`                             |
| `elasticsearch.ingest.resourcesPreset`       | Set container resources according to one common preset (allowed values: none, nano, small, medium, large, xlarge, 2xlarge). This is ignored if ingest.resources is set (ingest.resources is recommended for production).             | `small`                         |
| `elasticsearch.ingest.resources`             | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                    | `{}`                            |
| `externalElasticsearch.host`                 | Host of the external elasticsearch server                                                                                                                                                                                            | `""`                            |
| `externalElasticsearch.port`                 | Port of the external elasticsearch server                                                                                                                                                                                            | `""`                            |

### Persistence parameters

| Name                        | Description                                                                                             | Value               |
| --------------------------- | ------------------------------------------------------------------------------------------------------- | ------------------- |
| `persistence.enabled`       | Enable persistence using PVC                                                                            | `true`              |
| `persistence.storageClass`  | PVC Storage Class for Magento volume                                                                    | `""`                |
| `persistence.accessModes`   | PVC Access Modes for Magento volume                                                                     | `["ReadWriteOnce"]` |
| `persistence.size`          | PVC Storage Request for Magento volume                                                                  | `8Gi`               |
| `persistence.existingClaim` | An Existing PVC name for Magento volume                                                                 | `""`                |
| `persistence.hostPath`      | Host mount path for Magento volume                                                                      | `""`                |
| `persistence.annotations`   | Persistent Volume Claim annotations                                                                     | `{}`                |
| `persistence.subPath`       | The subdirectory of the volume to mount to, useful in dev environments and one PV for multiple services | `""`                |
| `persistence.selector`      | Selector to match an existing Persistent Volume for Magento data PVC                                    | `{}`                |
| `persistence.dataSource`    | Custom PVC data source                                                                                  | `{}`                |

### Volume Permissions parameters

| Name                                          | Description                                                                                                                                                                                                                                           | Value                      |
| --------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------- |
| `volumePermissions.enabled`                   | Enable init container that changes volume permissions in the data directory (for cases where the default k8s `runAsUser` and `fsUser` values do not work)                                                                                             | `false`                    |
| `volumePermissions.image.registry`            | Init container volume-permissions image registry                                                                                                                                                                                                      | `REGISTRY_NAME`            |
| `volumePermissions.image.repository`          | Init container volume-permissions image repository                                                                                                                                                                                                    | `REPOSITORY_NAME/os-shell` |
| `volumePermissions.image.digest`              | Init container volume-permissions image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                     | `""`                       |
| `volumePermissions.image.pullPolicy`          | Init container volume-permissions image pull policy                                                                                                                                                                                                   | `IfNotPresent`             |
| `volumePermissions.image.pullSecrets`         | Specify docker-registry secret names as an array                                                                                                                                                                                                      | `[]`                       |
| `volumePermissions.resourcesPreset`           | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if volumePermissions.resources is set (volumePermissions.resources is recommended for production). | `none`                     |
| `volumePermissions.resources`                 | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                                     | `{}`                       |
| `serviceAccount.create`                       | Enable creation of ServiceAccount for Magento pod                                                                                                                                                                                                     | `true`                     |
| `serviceAccount.name`                         | The name of the ServiceAccount to use.                                                                                                                                                                                                                | `""`                       |
| `serviceAccount.automountServiceAccountToken` | Allows auto mount of ServiceAccountToken on the serviceAccount created                                                                                                                                                                                | `false`                    |
| `serviceAccount.annotations`                  | Additional custom annotations for the ServiceAccount                                                                                                                                                                                                  | `{}`                       |

### Traffic Exposure Parameters

| Name                               | Description                                                                                                                      | Value                    |
| ---------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `service.type`                     | Kubernetes Service type                                                                                                          | `LoadBalancer`           |
| `service.ports.http`               | Service HTTP port                                                                                                                | `80`                     |
| `service.ports.https`              | Service HTTPS port                                                                                                               | `443`                    |
| `service.nodePorts.http`           | Kubernetes http node port                                                                                                        | `""`                     |
| `service.nodePorts.https`          | Kubernetes https node port                                                                                                       | `""`                     |
| `service.clusterIP`                | Static clusterIP or None for headless services                                                                                   | `""`                     |
| `service.loadBalancerSourceRanges` | Control hosts connecting to "LoadBalancer" only                                                                                  | `[]`                     |
| `service.loadBalancerIP`           | loadBalancerIP for the Magento Service (optional, cloud specific)                                                                | `""`                     |
| `service.externalTrafficPolicy`    | Enable client source IP preservation                                                                                             | `Cluster`                |
| `service.extraPorts`               | Extra ports to expose (normally used with the `sidecar` value)                                                                   | `[]`                     |
| `service.annotations`              | Additional custom annotations for %%MAIN_CONTAINER_NAME%% service                                                                | `{}`                     |
| `service.sessionAffinity`          | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                                                             | `None`                   |
| `service.sessionAffinityConfig`    | Additional settings for the sessionAffinity                                                                                      | `{}`                     |
| `ingress.enabled`                  | Enable ingress controller resource                                                                                               | `false`                  |
| `ingress.pathType`                 | Default path type for the ingress resource                                                                                       | `ImplementationSpecific` |
| `ingress.apiVersion`               | Override API Version (automatically detected if not set)                                                                         | `""`                     |
| `ingress.hostname`                 | Default host for the ingress resource                                                                                            | `magento.local`          |
| `ingress.path`                     | Default path for the ingress resource                                                                                            | `/`                      |
| `ingress.annotations`              | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                     |
| `ingress.tls`                      | Enable TLS for `ingress.hostname` parameter                                                                                      | `false`                  |
| `ingress.selfSigned`               | Create a TLS secret for this ingress record using self-signed certificates generated by Helm                                     | `false`                  |
| `ingress.extraHosts`               | The list of additional hostnames to be covered with this ingress record.                                                         | `[]`                     |
| `ingress.extraPaths`               | An array with additional arbitrary paths that may need to be added to the ingress under the main host                            | `[]`                     |
| `ingress.extraRules`               | The list of additional rules to be added to this ingress record. Evaluated as a template                                         | `[]`                     |
| `ingress.extraTls`                 | The tls configuration for additional hostnames to be covered with this ingress record.                                           | `[]`                     |
| `ingress.secrets`                  | If you're providing your own certificates, please use this to add the certificates as secrets                                    | `[]`                     |
| `ingress.ingressClassName`         | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                    | `""`                     |

### Metrics parameters

| Name                          | Description                                                                                                                                                                                                                       | Value                             |
| ----------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------- |
| `metrics.enabled`             | Start a side-car prometheus exporter                                                                                                                                                                                              | `false`                           |
| `metrics.image.registry`      | Apache exporter image registry                                                                                                                                                                                                    | `REGISTRY_NAME`                   |
| `metrics.image.repository`    | Apache exporter image repository                                                                                                                                                                                                  | `REPOSITORY_NAME/apache-exporter` |
| `metrics.image.digest`        | Apache exporter image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                   | `""`                              |
| `metrics.image.pullPolicy`    | Image pull policy                                                                                                                                                                                                                 | `IfNotPresent`                    |
| `metrics.image.pullSecrets`   | Specify docker-registry secret names as an array                                                                                                                                                                                  | `[]`                              |
| `metrics.resourcesPreset`     | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if metrics.resources is set (metrics.resources is recommended for production). | `none`                            |
| `metrics.resources`           | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                 | `{}`                              |
| `metrics.service.type`        | Prometheus metrics service type                                                                                                                                                                                                   | `ClusterIP`                       |
| `metrics.service.port`        | Service Metrics port                                                                                                                                                                                                              | `9117`                            |
| `metrics.service.annotations` | Annotations for the Prometheus exporter service                                                                                                                                                                                   | `{}`                              |

### Certificate injection parameters

| Name                                                 | Description                                                                                                       | Value                                    |
| ---------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------- | ---------------------------------------- |
| `certificates.customCertificate.certificateSecret`   | Secret containing the certificate and key to add                                                                  | `""`                                     |
| `certificates.customCertificate.chainSecret.name`    | Name of the secret containing the certificate chain                                                               | `""`                                     |
| `certificates.customCertificate.chainSecret.key`     | Key of the certificate chain file inside the secret                                                               | `""`                                     |
| `certificates.customCertificate.certificateLocation` | Location in the container to store the certificate                                                                | `/etc/ssl/certs/ssl-cert-snakeoil.pem`   |
| `certificates.customCertificate.keyLocation`         | Location in the container to store the private key                                                                | `/etc/ssl/private/ssl-cert-snakeoil.key` |
| `certificates.customCertificate.chainLocation`       | Location in the container to store the certificate chain                                                          | `/etc/ssl/certs/mychain.pem`             |
| `certificates.customCAs`                             | Defines a list of secrets to import into the container trust store                                                | `[]`                                     |
| `certificates.command`                               | Override default container command (useful when using custom images)                                              | `[]`                                     |
| `certificates.args`                                  | Override default container args (useful when using custom images)                                                 | `[]`                                     |
| `certificates.extraEnvVars`                          | Container sidecar extra environment variables (eg proxy)                                                          | `[]`                                     |
| `certificates.extraEnvVarsCM`                        | ConfigMap containing extra env vars                                                                               | `""`                                     |
| `certificates.extraEnvVarsSecret`                    | Secret containing extra env vars (in case of sensitive data)                                                      | `""`                                     |
| `certificates.image.registry`                        | Container sidecar registry                                                                                        | `REGISTRY_NAME`                          |
| `certificates.image.repository`                      | Container sidecar image                                                                                           | `REPOSITORY_NAME/os-shell`               |
| `certificates.image.digest`                          | Container sidecar image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag | `""`                                     |
| `certificates.image.pullPolicy`                      | Container sidecar image pull policy                                                                               | `IfNotPresent`                           |
| `certificates.image.pullSecrets`                     | Container sidecar image pull secrets                                                                              | `[]`                                     |

### Other Parameters

| Name                       | Description                          | Value   |
| -------------------------- | ------------------------------------ | ------- |
| `autoscaling.enabled`      | Enable autoscaling for replicas      | `false` |
| `autoscaling.minReplicas`  | Minimum number of replicas           | `1`     |
| `autoscaling.maxReplicas`  | Maximum number of replicas           | `11`    |
| `autoscaling.targetCPU`    | Target CPU utilization percentage    | `""`    |
| `autoscaling.targetMemory` | Target Memory utilization percentage | `""`    |

The above parameters map to the env variables defined in [bitnami/magento](https://github.com/bitnami/containers/tree/main/bitnami/magento). For more information please refer to the [bitnami/magento](https://github.com/bitnami/containers/tree/main/bitnami/magento) image documentation.

> **Note**:
>
> For Magento to function correctly, you should specify the `magentoHost` parameter to specify the FQDN (recommended) or the public IP address of the Magento service.
>
> Optionally, you can specify the `service.loadBalancerIP` parameter to assign a reserved IP address to the Magento service of the chart. However please note that this feature is only available on a few cloud providers (f.e. GKE).
>
> To reserve a public IP address on GKE:
>
> ```console
> $ gcloud compute addresses create magento-public-ip
> ```
>
> The reserved IP address can be associated to the Magento service by specifying it as the value of the `service.loadBalancerIP` parameter while installing the chart.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
  --set magentoUsername=admin,magentoPassword=password,mariadb.auth.rootPassword=secretpassword \
    oci://REGISTRY_NAME/REPOSITORY_NAME/magento
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The above command sets the Magento administrator account username and password to `admin` and `password` respectively. Additionally, it sets the MariaDB `root` user password to `secretpassword`.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml oci://REGISTRY_NAME/REPOSITORY_NAME/magento
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.
> **Tip**: You can use the default [values.yaml](https://github.com/bitnami/charts/tree/main/bitnami/magento/values.yaml)

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Notable changes

### To 27.0.0

This major updates the Elasticsearch subchart to its newest major, 21.0.0, which removes support for elasticsearch-curator. Check [Elasticsearch Upgrading Notes](https://github.com/bitnami/charts/tree/main/bitnami/elasticsearch#to-2100) for more information.

### To 26.0.0

This major release bumps the and MariaDB chart version to [18.x.x](https://github.com/bitnami/charts/pull/24804); no major issues are expected during the upgrade.

### To 23.0.0

This major release bumps the MariaDB version to 10.6. Follow the [upstream instructions](https://mariadb.com/kb/en/upgrading/) for upgrading to MariaDB 10.6. No major issues are expected during the upgrade.

### 21.0.0

This major updates the Elasticsearch subchart to its newest major, 19.0.0, which removes support for elasticsearch-curator. Check [Elasticsearch Upgrading Notes](https://github.com/bitnami/charts/tree/main/bitnami/elasticsearch#to-1900) for more information.

### 19.0.0

This major updates the Elasticsearch subchart to its newest major, 17.0.0, which adds support for X-pack security features such as SSL/TLS encryption and password protection. Check [Elasticsearch Upgrading Notes](https://github.com/bitnami/charts/tree/main/bitnami/elasticsearch#to-1700) for more information.

### 18.0.0

Elasticsearch dependency version was bumped to a new major version changing the license of some of its components to the [Elastic License](https://www.elastic.co/licensing/elastic-license) that is not currently accepted as an Open Source license by the Open Source Initiative (OSI). Check [Elasticsearch Upgrading Notes](https://github.com/bitnami/charts/tree/main/bitnami/elasticsearch#to-1500) for more information.

Regular upgrade is compatible from previous versions.

### 17.0.0

In this major there were three main changes introduced:

- Parameter standarizations
- Migration to non-root
- Elasticsearch sub-chart 14.0.0 update

#### 1. Chart standarizations

This upgrade adapts the chart to the latest Bitnami good practices. Check the Parameters section for more information. In summary:

- Lots of new parameters were added, including SMTP configuration, for using existing DBs (`magentoSkipInstall`), configuring security context, etc.
- Some parameters were renamed or disappeared in favor of new ones in this major version. For example, `persistence.magento.*` parameters were deprecated in favor of `persistence.*`.
- This version also introduces `bitnami/common`, a [library chart](https://helm.sh/docs/topics/library_charts/#helm) as a dependency. More documentation about this new utility could be found [here](https://github.com/bitnami/charts/tree/main/bitnami/common#bitnami-common-library-chart). Please, make sure that you have updated the chart dependencies before executing any upgrade.

#### 2. Migration of the Magento image to non-root

The [Bitnami Magento](https://github.com/bitnami/containers/tree/main/bitnami/magento) image was migrated to a "non-root" user approach. Previously the container ran as the `root` user and the Apache daemon was started as the `daemon` user. From now on, both the container and the Apache daemon run as user `1001`. Consequences:

- The HTTP/HTTPS ports exposed by the container are now `8080/8443` instead of `80/443`.
- Backwards compatibility is not guaranteed. Uninstall & install the chart again to obtain the latest version.

#### 3. Elasticsearch sub-chart 14.0.0 update

This version of the Elasticsearch sub-chart standardizes the way of defining Ingress rules in the Kibana sub-chart.

### 14.0.0

This version updates the docker image to `2.3.5-debian-10-r57` version. That version persists the full `htdocs` folder. From now on, to upgrade the Magento version it is needed to follow the [official steps](https://devdocs.magento.com/guides/v2.3/comp-mgr/cli/cli-upgrade.html) manually.

### 13.0.0

Several changes were introduced that can break backwards compatibility:

- This version includes a new major version of the ElasticSearch chart bundled as dependency. You can find the release notes of the new ElasticSearch major version in [this section](https://github.com/bitnami/charts/tree/main/bitnami/elasticsearch#1200) of the ES README.
- Labels are adapted to follow the Helm charts best practices.

### 9.0.0

This version enabled by default an initContainer that modify some kernel settings to meet the Elasticsearch requirements.

Currently, Elasticsearch requires some changes in the kernel of the host machine to work as expected. If those values are not set in the underlying operating system, the ES containers fail to boot with ERROR messages. More information about these requirements can be found in the links below:

- [File Descriptor requirements](https://www.elastic.co/guide/en/elasticsearch/reference/current/file-descriptors.html)
- [Virtual memory requirements](https://www.elastic.co/guide/en/elasticsearch/reference/current/vm-max-map-count.html)

You can disable the initContainer using the `elasticsearch.sysctlImage.enabled=false` parameter.

## Upgrading

### To 24.0.0

This major bump changes the following security defaults:

- `resourcesPreset` is changed from `none` to the minimum size working in our test suites (NOTE: `resourcesPreset` is not meant for production usage, but `resources` adapted to your use case).
- `global.compatibility.openshift.adaptSecurityContext` is changed from `disabled` to `auto`.
- The `networkPolicy` section has been normalized amongst all Bitnami charts. Compared to the previous approach, the values section has been simplified (check the Parameters section) and now it set to `enabled=true` by default. Egress traffic is allowed by default and ingress traffic is allowed by all pods but only to the ports set in `containerPorts` and `extraContainerPorts`.

This could potentially break any customization or init scripts used in your deployment. If this is the case, change the default values to the previous ones.

Also, this major release bumps the MariaDB chart version to [18.x.x](https://github.com/bitnami/charts/pull/24804); no major issues are expected during the upgrade.

### To 22.0.0

This major release bumps the MariaDB version to 10.11. Follow the [upstream instructions](https://mariadb.com/kb/en/upgrading-from-mariadb-10-6-to-mariadb-10-11/) for upgrading from MariaDB 10.6 to 10.11. No major issues are expected during the upgrade.

### To 18.0.0

This major release renames several values in this chart and adds missing features, in order to get aligned with the rest of the assets in the Bitnami charts repository.

Additionally, it updates both the [Elasticsearch](https://github.com/bitnami/charts/tree/main/bitnami/elasticsearch) and the [MariaDB](https://github.com/bitnami/charts/tree/main/bitnami/mariadb) subcharts to their latest major versions, 18.0.0 and 10.0.0 respectively, where similar changes have been also performed.
Check [Elasticsearch Upgrading Notes](https://github.com/bitnami/charts/tree/main/bitnami/redis#to-1800) and [MariaDB Upgrading Notes](https://github.com/bitnami/charts/tree/main/bitnami/mariadb#to-1000) for more information.

The following values have been renamed:

- `service.port` renamed as `service.ports.http`.
- `service.httpsPort` renamed as `service.ports.https`.
- `persistence.accessMode` renamed as `persistence.accessModes` and has array type now.
- `sessionAffinity` renamed as `service.sessionAffinity`.

### To 17.0.0

To upgrade to `17.0.0`, backup Magento data and the previous MariaDB databases, install a new Magento chart and import the backups and data, ensuring the `1001` user has the appropriate permissions on the migrated volume.

You can disable the non-root behavior by setting the parameters `containerSecurityContext.runAsUser` to `root`.

For the Elasticsearch 14.0.0 sub-chart update, when enabling Kibana and configuring a single hostname for the Kibana Ingress rule, set the `kibana.ingress.hostname` value. When defining more than one, set the `kibana.ingress.extraHosts` array. Apart from this case, no issues are expected to appear when upgrading.

### To 16.0.0

- Chart labels were adapted to follow the [Helm charts standard labels](https://helm.sh/docs/chart_best_practices/labels/#standard-labels).
- This version also introduces `bitnami/common`, a [library chart](https://helm.sh/docs/topics/library_charts/#helm) as a dependency. More documentation about this new utility could be found [here](https://github.com/bitnami/charts/tree/main/bitnami/common#bitnami-common-library-chart). Please, make sure that you have updated the chart dependencies before executing any upgrade.

Consequences:

- Backwards compatibility is not guaranteed. However, you can easily workaround this issue by removing Magento deployment before upgrading (the following example assumes that the release name is `magento`):

```console
export APP_HOST=$(kubectl get svc --namespace default magento --template "{{ range (index .status.loadBalancer.ingress 0) }}{{ . }}{{ end }}")
export APP_PASSWORD=$(kubectl get secret --namespace default magento -o jsonpath="{.data.magento-password}" | base64 -d)
export MARIADB_ROOT_PASSWORD=$(kubectl get secret --namespace default magento-mariadb -o jsonpath="{.data.mariadb-root-password}" | base64 -d)
export MARIADB_PASSWORD=$(kubectl get secret --namespace default magento-mariadb -o jsonpath="{.data.mariadb-password}" | base64 -d)
kubectl delete deployments.apps magento
helm upgrade magento oci://REGISTRY_NAME/REPOSITORY_NAME/magento --set magentoHost=$APP_HOST,magentoPassword=$APP_PASSWORD,mariadb.auth.rootPassword=$MARIADB_ROOT_PASSWORD,mariadb.auth.password=$MARIADB_PASSWORD
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

### To 15.0.0

In this major there were two main changes introduced:

1. Adaptation to Helm v2 EOL
2. Updated MariaDB and Elasticsearch dependency versions

Please read the update notes carefully.

#### 1. Adaptation to Helm v2 EOL

[On November 13, 2020, Helm v2 support was formally finished](https://github.com/helm/charts#status-of-the-project), this major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

##### What changes were introduced in this major version?

- Previous versions of this Helm Chart use `apiVersion: v1` (installable by both Helm 2 and 3), this Helm Chart was updated to `apiVersion: v2` (installable by Helm 3 only). [Here](https://helm.sh/docs/topics/charts/#the-apiversion-field) you can find more information about the `apiVersion` field.
- Move dependency information from the _requirements.yaml_ to the _Chart.yaml_
- After running `helm dependency update`, a _Chart.lock_ file is generated containing the same structure used in the previous _requirements.lock_
- The different fields present in the _Chart.yaml_ file has been ordered alphabetically in a homogeneous way for all the Bitnami Helm Charts

##### Considerations when upgrading to this version

- If you want to upgrade to this version from a previous one installed with Helm v3, you shouldn't face any issues
- If you want to upgrade to this version using Helm v2, this scenario is not supported as this version doesn't support Helm v2 anymore
- If you installed the previous version with Helm v2 and wants to upgrade to this version with Helm v3, please refer to the [official Helm documentation](https://helm.sh/docs/topics/v2_v3_migration/#migration-use-cases) about migrating from Helm v2 to v3

##### Useful links

- <https://docs.vmware.com/en/VMware-Tanzu-Application-Catalog/services/tutorials/GUID-resolve-helm2-helm3-post-migration-issues-index.html>
- <https://helm.sh/docs/topics/v2_v3_migration/>
- <https://helm.sh/blog/migrate-from-helm-v2-to-helm-v3/>

#### 2. Updated MariaDB dependency version

In this major the MariaDB and Elasticsearch dependency versions were also bumped to a new major version that introduces several incompatilibites. Therefore, backwards compatibility is not guaranteed. Check [MariaDB Upgrading Notes](https://github.com/bitnami/charts/tree/main/bitnami/mariadb#to-800) for more information. Although it is using the latest `bitnami/mariadb` chart, given Magento `2.4` [current limitations](https://devdocs.magento.com/guides/v2.4/install-gde/system-requirements.html#database), the container image of MariaDB has been bumped to `10.4.x` instead of using the latest `10.5.x`.

To upgrade to `15.0.0`, it should be done reusing the PVCs used to hold data from MariaDB, Elasticsearch and Magento data on your previous release. To do so, follow the instructions below (the following example assumes that the release name is `magento` and that a `rootUser.password` was defined for MariaDB in `values.yaml` when the chart was first installed):

> NOTE: Please, create a backup of your database before running any of those actions. The steps below would be only valid if your application (e.g. any plugins or custom code) is compatible with MariaDB 10.4.x

Obtain the credentials and the names of the PVCs used to hold the MariaDB data on your current release:

```console
export MAGENTO_HOST=$(kubectl get svc --namespace default magento --template "{{ range (index .status.loadBalancer.ingress 0) }}{{ . }}{{ end }}")
export MAGENTO_PASSWORD=$(kubectl get secret --namespace default magento -o jsonpath="{.data.magento-password}" | base64 -d)
export MARIADB_ROOT_PASSWORD=$(kubectl get secret --namespace default magento-mariadb -o jsonpath="{.data.mariadb-root-password}" | base64 -d)
export MARIADB_PASSWORD=$(kubectl get secret --namespace default magento-mariadb -o jsonpath="{.data.mariadb-password}" | base64 -d)
export MARIADB_PVC=$(kubectl get pvc -l app=mariadb,component=master,release=magento -o jsonpath="{.items[0].metadata.name}")
```

Delete the Magento deployment and delete the MariaDB statefulset. Notice the option `--cascade=false` in the latter.

```console
kubectl delete deployments.apps magento
kubectl delete statefulsets.apps magento-mariadb --cascade=false
```

Now the upgrade works:

```console
helm upgrade magento oci://REGISTRY_NAME/REPOSITORY_NAME/magento --set mariadb.primary.persistence.existingClaim=$MARIADB_PVC --set mariadb.auth.rootPassword=$MARIADB_ROOT_PASSWORD --set mariadb.auth.password=$MARIADB_PASSWORD --set magentoPassword=$MAGENTO_PASSWORD --set magentoHost=$MAGENTO_HOST
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

You will have to delete the existing MariaDB pod and the new statefulset is going to create a new one

```console
kubectl delete pod magento-mariadb-0z
```

Finally, you should see the lines below in MariaDB container logs:

```console
$ kubectl logs $(kubectl get pods -l app.kubernetes.io/instance=magento,app.kubernetes.io/name=mariadb,app.kubernetes.io/component=primary -o jsonpath="{.items[0].metadata.name}")
...
mariadb 12:13:24.98 INFO  ==> Using persisted data
mariadb 12:13:25.01 INFO  ==> Running mysql_upgrade
...
```

### To 10.0.0

Helm performs a lookup for the object based on its group (apps), version (v1), and kind (Deployment). Also known as its GroupVersionKind, or GVK. Changing the GVK is considered a compatibility breaker from Kubernetes' point of view, so you cannot "upgrade" those objects to the new GVK in-place. Earlier versions of Helm 3 did not perform the lookup correctly which has since been fixed to match the spec.

In 4dfac075aacf74405e31ae5b27df4369e84eb0b0 the `apiVersion` of the deployment resources was updated to `apps/v1` in tune with the api's deprecated, resulting in compatibility breakage.

This major version signifies this change.

### To 5.0.0

Manual intervention is needed if configuring Elasticsearch 6 as Magento search engine is desired.

[Follow the Magento documentation](https://devdocs.magento.com/guides/v2.3/config-guide/elasticsearch/configure-magento.html) in order to configure Elasticsearch, setting **Search Engine** to **Elasticsearch 6.0+**. If using the Elasticsearch server included in this chart, `hostname` and `port` can be obtained with the following commands:

```console
kubectl get svc -l app=elasticsearch,component=client,release=RELEASE_NAME -o jsonpath="{.items[0].metadata.name}"
kubectl get svc -l app=elasticsearch,component=client,release=RELEASE_NAME -o jsonpath="{.items[0].spec.ports[0].port}"
```

Where `RELEASE_NAME` is the name of the release. Use `helm list` to find it.

### To 3.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 3.0.0. The following example assumes that the release name is magento:

```console
kubectl patch deployment magento-magento --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
kubectl delete statefulset magento-mariadb --cascade=false
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