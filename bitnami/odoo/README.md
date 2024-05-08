<!--- app-name: Odoo -->

# Bitnami package for Odoo

Odoo is an open source ERP and CRM platform, formerly known as OpenERP, that can connect a wide variety of business operations such as sales, supply chain, finance, and project management.

[Overview of Odoo](https://www.odoo.com/)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/odoo
```

Looking to use Odoo in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the enterprise edition of Bitnami Application Catalog.

## Introduction

This chart bootstraps a [Odoo](https://github.com/bitnami/containers/tree/main/bitnami/odoo) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Odoo Apps can be used as stand-alone applications, but they also integrate seamlessly so you get a full-featured Open Source ERP when you install several Apps.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+
- PV provisioner support in the underlying infrastructure
- ReadWriteMany volumes for deployment scaling

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/odoo
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The command deploys Odoo on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Configuration and installation details

### Resource requests and limits

Bitnami charts allow setting resource requests and limits for all containers inside the chart deployment. These are inside the `resources` value (check parameter table). Setting requests is essential for production workloads and these should be adapted to your specific use case.

To make this process easier, the chart contains the `resourcesPreset` values, which automatically sets the `resources` section according to different presets. Check these presets in [the bitnami/common chart](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15). However, in production workloads using `resourcePreset` is discouraged as it may not fully adapt to your specific needs. Find more information on container resource management in the [official Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).

### [Rolling VS Immutable tags](https://docs.vmware.com/en/VMware-Tanzu-Application-Catalog/services/tutorials/GUID-understand-rolling-tags-containers-index.html)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Use a different Odoo version

To modify the application version used in this chart, specify a different version of the image using the `image.tag` parameter and/or a different repository using the `image.repository` parameter.

### Using an external database

Sometimes you may want to have Odoo connect to an external database rather than installing one inside your cluster, e.g. to use a managed database service, or use a single database server for all your applications. To do this, the chart allows you to specify credentials for an external database under the [`externalDatabase` parameter](#parameters). You should also disable the PostgreSQL installation with the `postgresql.enabled` option. For example using the following parameters:

```console
postgresql.enabled=false
externalDatabase.host=myexternalhost
externalDatabase.user=myuser
externalDatabase.password=mypassword
externalDatabase.port=3306
```

Note also if you disable PostgreSQL per above you MUST supply values for the `externalDatabase` connection.

### Sidecars and Init Containers

If you have a need for additional containers to run within the same pod as Odoo, you can do so via the `sidecars` config parameter. Simply define your container according to the Kubernetes container spec.

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

### Setting Pod's affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

## Persistence

The [Bitnami Odoo](https://github.com/bitnami/containers/tree/main/bitnami/odoo) image stores the Odoo data and configurations at the `/bitnami/odoo` path of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Parameters](#parameters) section to configure the PVC or to disable persistence.

## Parameters

### Global parameters

| Name                                                  | Description                                                                                                                                                                                                                                                                                                                                                         | Value      |
| ----------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------- |
| `global.imageRegistry`                                | Global Docker image registry                                                                                                                                                                                                                                                                                                                                        | `""`       |
| `global.imagePullSecrets`                             | Global Docker registry secret names as an array                                                                                                                                                                                                                                                                                                                     | `[]`       |
| `global.storageClass`                                 | Global StorageClass for Persistent Volume(s)                                                                                                                                                                                                                                                                                                                        | `""`       |
| `global.compatibility.openshift.adaptSecurityContext` | Adapt the securityContext sections of the deployment to make them compatible with Openshift restricted-v2 SCC: remove runAsUser, runAsGroup and fsGroup and let the platform use their allowed default IDs. Possible values: auto (apply if the detected running cluster is Openshift), force (perform the adaptation always), disabled (do not perform adaptation) | `disabled` |

### Common parameters

| Name                     | Description                                                                                          | Value                  |
| ------------------------ | ---------------------------------------------------------------------------------------------------- | ---------------------- |
| `kubeVersion`            | Override Kubernetes version                                                                          | `""`                   |
| `nameOverride`           | String to partially override common.names.fullname                                                   | `""`                   |
| `fullnameOverride`       | String to fully override common.names.fullname                                                       | `""`                   |
| `commonLabels`           | Labels to add to all deployed objects                                                                | `{}`                   |
| `commonAnnotations`      | Annotations to add to all deployed objects                                                           | `{}`                   |
| `clusterDomain`          | Default Kubernetes cluster domain                                                                    | `cluster.local`        |
| `extraDeploy`            | Array of extra objects to deploy with the release                                                    | `[]`                   |
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden)              | `false`                |
| `diagnosticMode.command` | Command to override all containers in the the statefulset                                            | `["sleep"]`            |
| `diagnosticMode.args`    | Args to override all containers in the the statefulset                                               | `["infinity"]`         |
| `image.registry`         | Odoo image registry                                                                                  | `REGISTRY_NAME`        |
| `image.repository`       | Odoo image repository                                                                                | `REPOSITORY_NAME/odoo` |
| `image.digest`           | Odoo image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag | `""`                   |
| `image.pullPolicy`       | Odoo image pull policy                                                                               | `IfNotPresent`         |
| `image.pullSecrets`      | Odoo image pull secrets                                                                              | `[]`                   |
| `image.debug`            | Enable image debug mode                                                                              | `false`                |

### Odoo Configuration parameters

| Name                    | Description                                                          | Value              |
| ----------------------- | -------------------------------------------------------------------- | ------------------ |
| `odooEmail`             | Odoo user email                                                      | `user@example.com` |
| `odooPassword`          | Odoo user password                                                   | `""`               |
| `odooSkipInstall`       | Skip Odoo installation wizard                                        | `false`            |
| `odooDatabaseFilter`    | Filter odoo database by using a regex                                | `.*`               |
| `loadDemoData`          | Whether to load demo data for all modules during initialization      | `false`            |
| `customPostInitScripts` | Custom post-init.d user scripts                                      | `{}`               |
| `smtpHost`              | SMTP server host                                                     | `""`               |
| `smtpPort`              | SMTP server port                                                     | `""`               |
| `smtpUser`              | SMTP username                                                        | `""`               |
| `smtpPassword`          | SMTP user password                                                   | `""`               |
| `smtpProtocol`          | SMTP protocol                                                        | `""`               |
| `existingSecret`        | Name of existing secret containing Odoo credentials                  | `""`               |
| `smtpExistingSecret`    | The name of an existing secret with SMTP credentials                 | `""`               |
| `allowEmptyPassword`    | Allow the container to be started with blank passwords               | `false`            |
| `command`               | Override default container command (useful when using custom images) | `[]`               |
| `args`                  | Override default container args (useful when using custom images)    | `[]`               |
| `extraEnvVars`          | Array with extra environment variables to add to the Odoo container  | `[]`               |
| `extraEnvVarsCM`        | Name of existing ConfigMap containing extra env vars                 | `""`               |
| `extraEnvVarsSecret`    | Name of existing Secret containing extra env vars                    | `""`               |

### Odoo deployment parameters

| Name                                                | Description                                                                                                                                                                                                       | Value                                                              |
| --------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------ |
| `replicaCount`                                      | Number of Odoo replicas to deploy                                                                                                                                                                                 | `1`                                                                |
| `containerPorts.http`                               | Odoo HTTP container port                                                                                                                                                                                          | `8069`                                                             |
| `extraContainerPorts`                               | Optionally specify extra list of additional ports for Odoo container(s)                                                                                                                                           | `[]`                                                               |
| `resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if resources is set (resources is recommended for production). | `large`                                                            |
| `resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                 | `{}`                                                               |
| `podSecurityContext.enabled`                        | Enabled Odoo pods' Security Context                                                                                                                                                                               | `true`                                                             |
| `podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                | `Always`                                                           |
| `podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                    | `[]`                                                               |
| `podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                       | `[]`                                                               |
| `podSecurityContext.fsGroup`                        | Set Odoo pod's Security Context fsGroup                                                                                                                                                                           | `0`                                                                |
| `containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                                                                                                                              | `true`                                                             |
| `containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                  | `{}`                                                               |
| `containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                                                                                                        | `0`                                                                |
| `containerSecurityContext.runAsGroup`               | Set containers' Security Context runAsGroup                                                                                                                                                                       | `0`                                                                |
| `containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                                                                                                                     | `false`                                                            |
| `containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                                                                                                                       | `false`                                                            |
| `containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                           | `false`                                                            |
| `containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                                                                                                         | `false`                                                            |
| `containerSecurityContext.capabilities.add`         | List of capabilities to be added                                                                                                                                                                                  | `["CHOWN","FOWNER","SYS_CHROOT","SETGID","SETUID","DAC_OVERRIDE"]` |
| `containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                | `["ALL"]`                                                          |
| `containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                  | `RuntimeDefault`                                                   |
| `livenessProbe.enabled`                             | Enable livenessProbe                                                                                                                                                                                              | `true`                                                             |
| `livenessProbe.path`                                | Path for to check for livenessProbe                                                                                                                                                                               | `/web/health`                                                      |
| `livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                           | `600`                                                              |
| `livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                  | `30`                                                               |
| `livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                 | `5`                                                                |
| `livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                               | `6`                                                                |
| `livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                               | `1`                                                                |
| `readinessProbe.enabled`                            | Enable readinessProbe                                                                                                                                                                                             | `true`                                                             |
| `readinessProbe.path`                               | Path to check for readinessProbe                                                                                                                                                                                  | `/web/health`                                                      |
| `readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                          | `30`                                                               |
| `readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                 | `10`                                                               |
| `readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                | `5`                                                                |
| `readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                              | `12`                                                               |
| `readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                              | `1`                                                                |
| `startupProbe.enabled`                              | Enable startupProbe                                                                                                                                                                                               | `false`                                                            |
| `startupProbe.path`                                 | Path to check for startupProbe                                                                                                                                                                                    | `/web/health`                                                      |
| `startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                            | `300`                                                              |
| `startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                   | `10`                                                               |
| `startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                  | `5`                                                                |
| `startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                | `6`                                                                |
| `startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                | `1`                                                                |
| `customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                                                                                                               | `{}`                                                               |
| `customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                                                                                                                              | `{}`                                                               |
| `customStartupProbe`                                | Custom startupProbe that overrides the default one                                                                                                                                                                | `{}`                                                               |
| `lifecycleHooks`                                    | LifecycleHooks to set additional configuration at startup                                                                                                                                                         | `{}`                                                               |
| `automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                | `false`                                                            |
| `hostAliases`                                       | Odoo pod host aliases                                                                                                                                                                                             | `[]`                                                               |
| `podLabels`                                         | Extra labels for Odoo pods                                                                                                                                                                                        | `{}`                                                               |
| `podAnnotations`                                    | Annotations for Odoo pods                                                                                                                                                                                         | `{}`                                                               |
| `podAffinityPreset`                                 | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                               | `""`                                                               |
| `podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                          | `soft`                                                             |
| `nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                         | `""`                                                               |
| `nodeAffinityPreset.key`                            | Node label key to match. Ignored if `affinity` is set                                                                                                                                                             | `""`                                                               |
| `nodeAffinityPreset.values`                         | Node label values to match. Ignored if `affinity` is set                                                                                                                                                          | `[]`                                                               |
| `affinity`                                          | Affinity for pod assignment                                                                                                                                                                                       | `{}`                                                               |
| `nodeSelector`                                      | Node labels for pod assignment                                                                                                                                                                                    | `{}`                                                               |
| `tolerations`                                       | Tolerations for pod assignment                                                                                                                                                                                    | `[]`                                                               |
| `topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template                                                                                          | `[]`                                                               |
| `priorityClassName`                                 | Odoo pods' Priority Class Name                                                                                                                                                                                    | `""`                                                               |
| `schedulerName`                                     | Use an alternate scheduler, e.g. "stork".                                                                                                                                                                         | `""`                                                               |
| `terminationGracePeriodSeconds`                     | Seconds Odoo pod needs to terminate gracefully                                                                                                                                                                    | `""`                                                               |
| `updateStrategy.type`                               | Odoo deployment strategy type                                                                                                                                                                                     | `RollingUpdate`                                                    |
| `updateStrategy.rollingUpdate`                      | Odoo deployment rolling update configuration parameters                                                                                                                                                           | `nil`                                                              |
| `extraVolumes`                                      | Optionally specify extra list of additional volumes for Odoo pods                                                                                                                                                 | `[]`                                                               |
| `extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for Odoo container(s)                                                                                                                                    | `[]`                                                               |
| `sidecars`                                          | Add additional sidecar containers to the Odoo pod                                                                                                                                                                 | `[]`                                                               |
| `initContainers`                                    | Add additional init containers to the Odoo pods                                                                                                                                                                   | `[]`                                                               |

### Traffic Exposure Parameters

| Name                               | Description                                                                                                                      | Value                    |
| ---------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `service.type`                     | Odoo service type                                                                                                                | `LoadBalancer`           |
| `service.ports.http`               | Odoo service HTTP port                                                                                                           | `80`                     |
| `service.nodePorts.http`           | NodePort for the Odoo HTTP endpoint                                                                                              | `""`                     |
| `service.sessionAffinity`          | Control where client requests go, to the same pod or round-robin                                                                 | `None`                   |
| `service.sessionAffinityConfig`    | Additional settings for the sessionAffinity                                                                                      | `{}`                     |
| `service.clusterIP`                | Odoo service Cluster IP                                                                                                          | `""`                     |
| `service.loadBalancerIP`           | Odoo service Load Balancer IP                                                                                                    | `""`                     |
| `service.loadBalancerSourceRanges` | Odoo service Load Balancer sources                                                                                               | `[]`                     |
| `service.externalTrafficPolicy`    | Odoo service external traffic policy                                                                                             | `Cluster`                |
| `service.annotations`              | Additional custom annotations for Odoo service                                                                                   | `{}`                     |
| `service.extraPorts`               | Extra port to expose on Odoo service                                                                                             | `[]`                     |
| `ingress.enabled`                  | Enable ingress record generation for Odoo                                                                                        | `false`                  |
| `ingress.ingressClassName`         | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                    | `""`                     |
| `ingress.pathType`                 | Ingress path type                                                                                                                | `ImplementationSpecific` |
| `ingress.apiVersion`               | Force Ingress API version (automatically detected if not set)                                                                    | `""`                     |
| `ingress.hostname`                 | Default host for the ingress record                                                                                              | `odoo.local`             |
| `ingress.path`                     | Default path for the ingress record                                                                                              | `/`                      |
| `ingress.annotations`              | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                     |
| `ingress.tls`                      | Enable TLS configuration for the host defined at `ingress.hostname` parameter                                                    | `false`                  |
| `ingress.selfSigned`               | Create a TLS secret for this ingress record using self-signed certificates generated by Helm                                     | `false`                  |
| `ingress.extraHosts`               | An array with additional hostname(s) to be covered with the ingress record                                                       | `[]`                     |
| `ingress.extraPaths`               | An array with additional arbitrary paths that may need to be added to the ingress under the main host                            | `[]`                     |
| `ingress.extraTls`                 | TLS configuration for additional hostname(s) to be covered with this ingress record                                              | `[]`                     |
| `ingress.secrets`                  | Custom TLS certificates as secrets                                                                                               | `[]`                     |
| `ingress.extraRules`               | Additional rules to be covered with this ingress record                                                                          | `[]`                     |

### Persistence Parameters

| Name                                                             | Description                                                                                                                                                                                                                                           | Value            |
| ---------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| `persistence.enabled`                                            | Enable persistence using Persistent Volume Claims                                                                                                                                                                                                     | `true`           |
| `persistence.resourcePolicy`                                     | Setting it to "keep" to avoid removing PVCs during a helm delete operation. Leaving it empty will delete PVCs after the chart deleted                                                                                                                 | `""`             |
| `persistence.storageClass`                                       | Persistent Volume storage class                                                                                                                                                                                                                       | `""`             |
| `persistence.accessModes`                                        | Persistent Volume access modes                                                                                                                                                                                                                        | `[]`             |
| `persistence.accessMode`                                         | Persistent Volume access mode (DEPRECATED: use `persistence.accessModes` instead)                                                                                                                                                                     | `ReadWriteOnce`  |
| `persistence.size`                                               | Persistent Volume size                                                                                                                                                                                                                                | `10Gi`           |
| `persistence.dataSource`                                         | Custom PVC data source                                                                                                                                                                                                                                | `{}`             |
| `persistence.annotations`                                        | Annotations for the PVC                                                                                                                                                                                                                               | `{}`             |
| `persistence.selector`                                           | Selector to match an existing Persistent Volume (this value is evaluated as a template)                                                                                                                                                               | `{}`             |
| `persistence.existingClaim`                                      | The name of an existing PVC to use for persistence                                                                                                                                                                                                    | `""`             |
| `volumePermissions.enabled`                                      | Enable init container that changes the owner/group of the PV mount point to `runAsUser:fsGroup`                                                                                                                                                       | `false`          |
| `volumePermissions.resourcesPreset`                              | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if volumePermissions.resources is set (volumePermissions.resources is recommended for production). | `nano`           |
| `volumePermissions.resources`                                    | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                                     | `{}`             |
| `volumePermissions.containerSecurityContext.enabled`             | Enable init container's Security Context                                                                                                                                                                                                              | `true`           |
| `volumePermissions.containerSecurityContext.seLinuxOptions`      | Set SELinux options in container                                                                                                                                                                                                                      | `{}`             |
| `volumePermissions.containerSecurityContext.runAsUser`           | Set init container's Security Context runAsUser                                                                                                                                                                                                       | `0`              |
| `volumePermissions.containerSecurityContext.seccompProfile.type` | Set container's Security Context seccomp profile                                                                                                                                                                                                      | `RuntimeDefault` |

### RBAC Parameters

| Name                                          | Description                                                                                              | Value   |
| --------------------------------------------- | -------------------------------------------------------------------------------------------------------- | ------- |
| `serviceAccount.create`                       | Specifies whether a ServiceAccount should be created                                                     | `true`  |
| `serviceAccount.name`                         | The name of the ServiceAccount to create (name generated using common.names.fullname template otherwise) | `""`    |
| `serviceAccount.automountServiceAccountToken` | Auto-mount the service account token in the pod                                                          | `false` |
| `serviceAccount.annotations`                  | Additional custom annotations for the ServiceAccount                                                     | `{}`    |

### Other Parameters

| Name                       | Description                                                    | Value   |
| -------------------------- | -------------------------------------------------------------- | ------- |
| `pdb.create`               | Enable a Pod Disruption Budget creation                        | `false` |
| `pdb.minAvailable`         | Minimum number/percentage of pods that should remain scheduled | `1`     |
| `pdb.maxUnavailable`       | Maximum number/percentage of pods that may be made unavailable | `""`    |
| `autoscaling.enabled`      | Enable Horizontal POD autoscaling for Odoo                     | `false` |
| `autoscaling.minReplicas`  | Minimum number of Odoo replicas                                | `1`     |
| `autoscaling.maxReplicas`  | Maximum number of Odoo replicas                                | `11`    |
| `autoscaling.targetCPU`    | Target CPU utilization percentage                              | `50`    |
| `autoscaling.targetMemory` | Target Memory utilization percentage                           | `50`    |

### Database Parameters

| Name                                                 | Description                                                              | Value          |
| ---------------------------------------------------- | ------------------------------------------------------------------------ | -------------- |
| `postgresql.enabled`                                 | Switch to enable or disable the PostgreSQL helm chart                    | `true`         |
| `postgresql.auth.username`                           | Name for a custom user to create                                         | `bn_odoo`      |
| `postgresql.auth.password`                           | Password for the custom user to create                                   | `""`           |
| `postgresql.auth.database`                           | Name for a custom database to create                                     | `bitnami_odoo` |
| `postgresql.auth.existingSecret`                     | Name of existing secret to use for PostgreSQL credentials                | `""`           |
| `postgresql.architecture`                            | PostgreSQL architecture (`standalone` or `replication`)                  | `standalone`   |
| `externalDatabase.host`                              | Database host                                                            | `""`           |
| `externalDatabase.port`                              | Database port number                                                     | `5432`         |
| `externalDatabase.user`                              | Non-root username for Odoo                                               | `bn_odoo`      |
| `externalDatabase.password`                          | Password for the non-root username for Odoo                              | `""`           |
| `externalDatabase.database`                          | Odoo database name                                                       | `bitnami_odoo` |
| `externalDatabase.create`                            | Enable PostgreSQL user and database creation (when using an external db) | `true`         |
| `externalDatabase.postgresqlPostgresUser`            | External Database admin username                                         | `postgres`     |
| `externalDatabase.postgresqlPostgresPassword`        | External Database admin password                                         | `""`           |
| `externalDatabase.existingSecret`                    | Name of an existing secret resource containing the database credentials  | `""`           |
| `externalDatabase.existingSecretPasswordKey`         | Name of an existing secret key containing the non-root credentials       | `""`           |
| `externalDatabase.existingSecretPostgresPasswordKey` | Name of an existing secret key containing the admin credentials          | `""`           |

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

The above parameters map to the env variables defined in [bitnami/odoo](https://github.com/bitnami/containers/tree/main/bitnami/odoo). For more information please refer to the [bitnami/odoo](https://github.com/bitnami/containers/tree/main/bitnami/odoo) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
  --set odooPassword=password,postgresql.postgresPassword=secretpassword \
    oci://REGISTRY_NAME/REPOSITORY_NAME/odoo
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The above command sets the Odoo administrator account password to `password` and the PostgreSQL `postgres` user password to `secretpassword`.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml oci://REGISTRY_NAME/REPOSITORY_NAME/odoo
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.
> **Tip**: You can use the default [values.yaml](https://github.com/bitnami/charts/tree/main/bitnami/odoo/values.yaml)

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 26.0.0

This major bump changes the following security defaults:

- `resourcesPreset` is changed from `none` to the minimum size working in our test suites (NOTE: `resourcesPreset` is not meant for production usage, but `resources` adapted to your use case).
- `global.compatibility.openshift.adaptSecurityContext` is changed from `disabled` to `auto`.
- The `networkPolicy` section has been normalized amongst all Bitnami charts. Compared to the previous approach, the values section has been simplified (check the Parameters section) and now it set to `enabled=true` by default. Egress traffic is allowed by default and ingress traffic is allowed by all pods but only to the ports set in `containerPorts` and `extraContainerPorts`.

This could potentially break any customization or init scripts used in your deployment. If this is the case, change the default values to the previous ones.

Also, this major release bumps the PostgreSQL chart version to [15.x.x](https://github.com/bitnami/charts/pull/24171).

### To 24.0.0

This major updates the PostgreSQL subchart to its newest major, 13.0.0. [Here](https://github.com/bitnami/charts/tree/master/bitnami/postgresql#to-1300) you can find more information about the changes introduced in that version.

### To 23.0.0

This major updates the PostgreSQL subchart to its newest major, 12.0.0. [Here](https://github.com/bitnami/charts/tree/master/bitnami/postgresql#to-1200) you can find more information about the changes introduced in that version.

### To 21.0.0

This major release updates the PostgreSQL subchart to its newest major *11.x.x*, which contain several changes in the supported values (check the [upgrade notes](https://github.com/bitnami/charts/tree/master/bitnami/postgresql#to-1100) to obtain more information).

#### Upgrading Instructions

To upgrade to *21.0.0* from *20.x*, it should be done reusing the PVC(s) used to hold the data on your previous release. To do so, follow the instructions below (the following example assumes that the release name is *odoo* and the release namespace *default*):

1. Obtain the credentials and the names of the PVCs used to hold the data on your current release:

```console
export ODOO_PASSWORD=$(kubectl get secret --namespace default odoo -o jsonpath="{.data.odoo-password}" | base64 --decode)
export POSTGRESQL_PASSWORD=$(kubectl get secret --namespace default odoo-postgresql -o jsonpath="{.data.postgresql-password}" | base64 --decode)
export POSTGRESQL_PVC=$(kubectl get pvc -l app.kubernetes.io/instance=odoo,app.kubernetes.io/name=postgresql,role=primary -o jsonpath="{.items[0].metadata.name}")
```

1. Delete the PostgreSQL statefulset (notice the option *--cascade=false*) and secret:

```console
kubectl delete statefulsets.apps --cascade=false odoo-postgresql
kubectl delete secret odoo-postgresql --namespace default
```

1. Upgrade your release using the same PostgreSQL version:

```console
CURRENT_PG_VERSION=$(kubectl exec odoo-postgresql-0 -- bash -c 'echo $BITNAMI_IMAGE_VERSION')
helm upgrade odoo bitnami/odoo \
  --set odooPassword=$ODOO_PASSWORD \
  --set postgresql.image.tag=$CURRENT_PG_VERSION \
  --set postgresql.auth.password=$POSTGRESQL_PASSWORD \
  --set postgresql.persistence.existingClaim=$POSTGRESQL_PVC
```

1. Delete the existing PostgreSQL pods and the new statefulset will create a new one:

```console
kubectl delete pod odoo-postgresql-0
```

### 19.0.0

The [Bitnami Odoo](https://github.com/bitnami/containers/tree/main/bitnami/odoo) image was refactored and now the source code is published in GitHub in the `rootfs` folder of the container image repository.

#### How to upgrade to version 19.0.0

To upgrade to *19.0.0* from *18.x*, it should be done enabling the "volumePermissions" init container. To do so, follow the instructions below (the following example assumes that the release name is *odoo* and the release namespace *default*):

1. Obtain the credentials and the names of the PVCs used to hold the data on your current release:

```console
export ODOO_PASSWORD=$(kubectl get secret --namespace default odoo -o jsonpath="{.data.odoo-password}" | base64 --decode)
export POSTGRESQL_PASSWORD=$(kubectl get secret --namespace default odoo-postgresql -o jsonpath="{.data.postgresql-password}" | base64 --decode)
export POSTGRESQL_PVC=$(kubectl get pvc -l app.kubernetes.io/instance=odoo,app.kubernetes.io/name=postgresql,role=primary -o jsonpath="{.items[0].metadata.name}")
```

1. Upgrade your release:

```console
helm upgrade odoo bitnami/odoo \
  --set odooPassword=$ODOO_PASSWORD \
  --set postgresql.auth.password=$POSTGRESQL_PASSWORD \
  --set postgresql.persistence.existingClaim=$POSTGRESQL_PVC \
  --set volumePermissions.enabled=true
```

Full compatibility is not guaranteed due to the amount of involved changes, however no breaking changes are expected aside from the ones mentioned above.

### To 18.0.0

This version standardizes the way of defining Ingress rules. When configuring a single hostname for the Ingress rule, set the `ingress.hostname` value. When defining more than one, set the `ingress.extraHosts` array. Apart from this case, no issues are expected to appear when upgrading.

### To 17.0.0

[On November 13, 2020, Helm v2 support was formally finished](https://github.com/helm/charts#status-of-the-project), this major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

#### What changes were introduced in this major version?

- Previous versions of this Helm Chart use `apiVersion: v1` (installable by both Helm 2 and 3), this Helm Chart was updated to `apiVersion: v2` (installable by Helm 3 only). [Here](https://helm.sh/docs/topics/charts/#the-apiversion-field) you can find more information about the `apiVersion` field.
- Move dependency information from the *requirements.yaml* to the *Chart.yaml*
- After running *helm dependency update*, a *Chart.lock* file is generated containing the same structure used in the previous *requirements.lock*
- The different fields present in the *Chart.yaml* file has been ordered alphabetically in a homogeneous way for all the Bitnami Helm Chart.
- Additionally updates the PostgreSQL subchart to its newest major *10.x.x*, which contains similar changes.

#### Considerations when upgrading to this version

- If you want to upgrade to this version using Helm v2, this scenario is not supported as this version does not support Helm v2 anymore.
- If you installed the previous version with Helm v2 and wants to upgrade to this version with Helm v3, please refer to the [official Helm documentation](https://helm.sh/docs/topics/v2_v3_migration/#migration-use-cases) about migrating from Helm v2 to v3.

#### Useful links

- [Bitnami Tutorial](https://docs.vmware.com/en/VMware-Tanzu-Application-Catalog/services/tutorials/GUID-resolve-helm2-helm3-post-migration-issues-index.html)
- [Helm docs](https://helm.sh/docs/topics/v2_v3_migration)
- [Helm Blog](https://helm.sh/blog/migrate-from-helm-v2-to-helm-v3)

#### How to upgrade to version 17.0.0

To upgrade to *17.0.0* from *16.x*, it should be done reusing the PVC(s) used to hold the data on your previous release. To do so, follow the instructions below (the following example assumes that the release name is *odoo* and the release namespace *default*):

1. Obtain the credentials and the names of the PVCs used to hold the data on your current release:

```console
export ODOO_PASSWORD=$(kubectl get secret --namespace default odoo -o jsonpath="{.data.odoo-password}" | base64 --decode)
export POSTGRESQL_PASSWORD=$(kubectl get secret --namespace default odoo-postgresql -o jsonpath="{.data.postgresql-password}" | base64 --decode)
export POSTGRESQL_PVC=$(kubectl get pvc -l app.kubernetes.io/instance=odoo,app.kubernetes.io/name=postgresql,role=master -o jsonpath="{.items[0].metadata.name}")
```

1. Delete the PostgreSQL statefulset (notice the option *--cascade=false*):

```console
kubectl delete statefulsets.apps --cascade=false odoo-postgresql
```

1. Upgrade your release:

```console
helm upgrade odoo bitnami/odoo \
  --set odooPassword=$ODOO_PASSWORD \
  --set postgresql.auth.password=$POSTGRESQL_PASSWORD \
  --set postgresql.persistence.existingClaim=$POSTGRESQL_PVC
```

1. Delete the existing PostgreSQL pods and the new statefulset will create a new one:

```console
kubectl delete pod odoo-postgresql-0
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