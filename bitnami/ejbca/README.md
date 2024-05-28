<!--- app-name: EJBCA -->

# Bitnami package for EJBCA

EJBCA is an enterprise class PKI Certificate Authority software, built using Java (JEE) technology.

[Overview of EJBCA](http://www.ejbca.org)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/ejbca
```

Looking to use EJBCA in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the enterprise edition of Bitnami Application Catalog.

## Introduction

This chart bootstraps a [EJBCA](https://www.ejbca.org/) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages [Bitnami MariaDB](https://github.com/bitnami/charts/tree/main/bitnami/mariadb) as the required databases for the EJBCA application.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/ejbca
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The command deploys EJBCA on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Configuration and installation details

### Resource requests and limits

Bitnami charts allow setting resource requests and limits for all containers inside the chart deployment. These are inside the `resources` value (check parameter table). Setting requests is essential for production workloads and these should be adapted to your specific use case.

To make this process easier, the chart contains the `resourcesPreset` values, which automatically sets the `resources` section according to different presets. Check these presets in [the bitnami/common chart](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15). However, in production workloads using `resourcePreset` is discouraged as it may not fully adapt to your specific needs. Find more information on container resource management in the [official Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).

### [Rolling vs Immutable tags](https://docs.vmware.com/en/VMware-Tanzu-Application-Catalog/services/tutorials/GUID-understand-rolling-tags-containers-index.html)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Set up replication

By default, this chart only deploys a single pod running EJBCA. To increase the number of replicas, follow the steps below:

1. Create a conventional release with only one replica. This will be scaled later.
2. Wait for the release to complete and for EJBCA to be running. Verify access to the main page of the application.
3. Perform an upgrade specifying the number of replicas and the credentials that were previously used. Set the parameters `replicaCount`, `ejbcaAdminPassword` and `mariadb.auth.password` accordingly.

For example, for a release using `secretPassword` and `dbPassword` to scale up to a total of `2` replicas, the aforementioned parameters should hold these values `replicaCount=2`, `ejbcaAdminPassword=secretPassword`, `mariadb.auth.password=dbPassword`.

> **Tip**: You can modify the file [values.yaml](https://github.com/bitnami/charts/tree/main/bitnami/ejbca/values.yaml)

### Configure Sidecars and Init Containers

If additional containers are needed in the same pod as EJBCA (such as additional metrics or logging exporters), they can be defined using the `sidecars` parameter.

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

### Use an external database

Sometimes, you may want to have EJBCA connect to an external database rather than a database within your cluster - for example, when using a managed database service, or when running a single database server for all your applications. To do this, set the `mariadb.enabled` parameter to `false` and specify the credentials for the external database using the `externalDatabase.*` parameters. Here is an example:

```text
mysql.enabled=false
externalDatabase.host=myexternalhost
externalDatabase.user=myuser
externalDatabase.password=mypassword
externalDatabase.database=mydatabase
externalDatabase.port=3306
```

### Set Pod affinity

This chart allows you to set custom Pod affinity using the `affinity` parameter. Find more information about Pod affinity in the [Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

### Use a different EJBCA version

To modify the application version used in this chart, specify a different version of the image using the `image.tag` parameter and/or a different repository using the `image.repository` parameter.

## Persistence

The [Bitnami EJBCA](https://github.com/bitnami/containers/tree/main/bitnami/discourse) image stores the EJBCA data and configurations at the `/bitnami` path of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube. See the [Parameters](#parameters) section to configure the PVC or to disable persistence.

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
| `nameOverride`           | String to partially override ebjca.fullname template (will maintain the release name)   | `""`           |
| `fullnameOverride`       | String to fully override ebjca.fullname template                                        | `""`           |
| `namespaceOverride`      | String to fully override common.names.namespace                                         | `""`           |
| `commonLabels`           | Add labels to all the deployed resources                                                | `{}`           |
| `commonAnnotations`      | Annotations to be added to all deployed resources                                       | `{}`           |
| `extraDeploy`            | Array of extra objects to deploy with the release                                       | `[]`           |
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden) | `false`        |
| `diagnosticMode.command` | Command to override all containers in the deployment                                    | `["sleep"]`    |
| `diagnosticMode.args`    | Args to override all containers in the deployment                                       | `["infinity"]` |

### EJBCA parameters

| Name                                                | Description                                                                                                                                                                                                       | Value                   |
| --------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------- |
| `image.registry`                                    | EJBCA image registry                                                                                                                                                                                              | `REGISTRY_NAME`         |
| `image.repository`                                  | EJBCA image name                                                                                                                                                                                                  | `REPOSITORY_NAME/ejbca` |
| `image.digest`                                      | EJBCA image image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                       | `""`                    |
| `image.pullPolicy`                                  | EJBCA image pull policy                                                                                                                                                                                           | `IfNotPresent`          |
| `image.pullSecrets`                                 | Specify docker-registry secret names as an array                                                                                                                                                                  | `[]`                    |
| `image.debug`                                       | Enable image debug mode                                                                                                                                                                                           | `false`                 |
| `replicaCount`                                      | Number of EJBCA replicas to deploy                                                                                                                                                                                | `1`                     |
| `extraVolumeMounts`                                 | Additional volume mounts (used along with `extraVolumes`)                                                                                                                                                         | `[]`                    |
| `extraVolumes`                                      | Array of extra volumes to be added deployment. Requires setting `extraVolumeMounts`                                                                                                                               | `[]`                    |
| `podAnnotations`                                    | Additional pod annotations                                                                                                                                                                                        | `{}`                    |
| `podLabels`                                         | Additional pod labels                                                                                                                                                                                             | `{}`                    |
| `podSecurityContext.enabled`                        | Enable security context for EJBCA container                                                                                                                                                                       | `true`                  |
| `podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                | `Always`                |
| `podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                    | `[]`                    |
| `podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                       | `[]`                    |
| `podSecurityContext.fsGroup`                        | Group ID for the volumes of the pod                                                                                                                                                                               | `1001`                  |
| `podAffinityPreset`                                 | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                               | `""`                    |
| `podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                          | `soft`                  |
| `nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                         | `""`                    |
| `nodeAffinityPreset.key`                            | Node label key to match Ignored if `affinity` is set.                                                                                                                                                             | `""`                    |
| `nodeAffinityPreset.values`                         | Node label values to match. Ignored if `affinity` is set.                                                                                                                                                         | `[]`                    |
| `affinity`                                          | Affinity for pod assignment                                                                                                                                                                                       | `{}`                    |
| `nodeSelector`                                      | Node labels for pod assignment                                                                                                                                                                                    | `{}`                    |
| `tolerations`                                       | Tolerations for pod assignment                                                                                                                                                                                    | `[]`                    |
| `updateStrategy.type`                               | EJBCA deployment strategy type.                                                                                                                                                                                   | `RollingUpdate`         |
| `persistence.enabled`                               | Whether to enable persistence based on Persistent Volume Claims                                                                                                                                                   | `true`                  |
| `persistence.accessModes`                           | Persistent Volume access modes                                                                                                                                                                                    | `[]`                    |
| `persistence.size`                                  | Size of the PVC to request                                                                                                                                                                                        | `2Gi`                   |
| `persistence.storageClass`                          | PVC Storage Class                                                                                                                                                                                                 | `""`                    |
| `persistence.existingClaim`                         | Name of an existing PVC to reuse                                                                                                                                                                                  | `""`                    |
| `persistence.annotations`                           | Persistent Volume Claim annotations                                                                                                                                                                               | `{}`                    |
| `sidecars`                                          | Attach additional sidecar containers to the pod                                                                                                                                                                   | `[]`                    |
| `initContainers`                                    | Additional init containers to add to the pods                                                                                                                                                                     | `[]`                    |
| `pdb.create`                                        | Enable/disable a Pod Disruption Budget creation                                                                                                                                                                   | `true`                  |
| `pdb.minAvailable`                                  | Minimum number/percentage of pods that should remain scheduled                                                                                                                                                    | `""`                    |
| `pdb.maxUnavailable`                                | Maximum number/percentage of pods that may be made unavailable                                                                                                                                                    | `""`                    |
| `automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                | `false`                 |
| `hostAliases`                                       | Add deployment host aliases                                                                                                                                                                                       | `[]`                    |
| `priorityClassName`                                 | EJBCA pods' priorityClassName                                                                                                                                                                                     | `""`                    |
| `schedulerName`                                     | Name of the k8s scheduler (other than default)                                                                                                                                                                    | `""`                    |
| `topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment                                                                                                                                                                    | `[]`                    |
| `ejbcaAdminUsername`                                | EJBCA administrator username                                                                                                                                                                                      | `bitnami`               |
| `ejbcaAdminPassword`                                | Password for the administrator account                                                                                                                                                                            | `""`                    |
| `existingSecret`                                    | Alternatively, you can provide the name of an existing secret containing                                                                                                                                          | `""`                    |
| `ejbcaJavaOpts`                                     | Options used to launch the WildFly server                                                                                                                                                                         | `""`                    |
| `ejbcaCA.name`                                      | Name of the CA EJBCA will instantiate by default                                                                                                                                                                  | `ManagementCA`          |
| `ejbcaCA.baseDN`                                    | Base DomainName of the CA EJBCA will instantiate by default                                                                                                                                                       | `""`                    |
| `ejbcaKeystoreExistingSecret`                       | Name of an existing Secret containing a Keystore object                                                                                                                                                           | `""`                    |
| `extraEnvVars`                                      | Array with extra environment variables to add to EJBCA nodes                                                                                                                                                      | `[]`                    |
| `extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for EJBCA nodes                                                                                                                                              | `""`                    |
| `extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for EJBCA nodes                                                                                                                                                 | `""`                    |
| `command`                                           | Custom command to override image cmd                                                                                                                                                                              | `[]`                    |
| `args`                                              | Custom args for the custom command                                                                                                                                                                                | `[]`                    |
| `lifecycleHooks`                                    | for the EJBCA container(s) to automate configuration before or after startup                                                                                                                                      | `{}`                    |
| `resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if resources is set (resources is recommended for production). | `xlarge`                |
| `resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                 | `{}`                    |
| `containerSecurityContext.enabled`                  | Enabled EJBCA containers' Security Context                                                                                                                                                                        | `true`                  |
| `containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                  | `nil`                   |
| `containerSecurityContext.runAsUser`                | Set EJBCA containers' Security Context runAsUser                                                                                                                                                                  | `1001`                  |
| `containerSecurityContext.runAsGroup`               | Set EJBCA containers' Security Context runAsGroup                                                                                                                                                                 | `1001`                  |
| `containerSecurityContext.runAsNonRoot`             | Set Controller container's Security Context runAsNonRoot                                                                                                                                                          | `true`                  |
| `containerSecurityContext.privileged`               | Set primary container's Security Context privileged                                                                                                                                                               | `false`                 |
| `containerSecurityContext.readOnlyRootFilesystem`   | Set primary container's Security Context readOnlyRootFilesystem                                                                                                                                                   | `true`                  |
| `containerSecurityContext.allowPrivilegeEscalation` | Set primary container's Security Context allowPrivilegeEscalation                                                                                                                                                 | `false`                 |
| `containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                | `["ALL"]`               |
| `containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                  | `RuntimeDefault`        |
| `startupProbe.enabled`                              | Enable/disable startupProbe                                                                                                                                                                                       | `false`                 |
| `startupProbe.initialDelaySeconds`                  | Delay before startup probe is initiated                                                                                                                                                                           | `500`                   |
| `startupProbe.periodSeconds`                        | How often to perform the probe                                                                                                                                                                                    | `10`                    |
| `startupProbe.timeoutSeconds`                       | When the probe times out                                                                                                                                                                                          | `5`                     |
| `startupProbe.failureThreshold`                     | Minimum consecutive failures for the probe                                                                                                                                                                        | `6`                     |
| `startupProbe.successThreshold`                     | Minimum consecutive successes for the probe                                                                                                                                                                       | `1`                     |
| `livenessProbe.enabled`                             | Enable/disable livenessProbe                                                                                                                                                                                      | `true`                  |
| `livenessProbe.initialDelaySeconds`                 | Delay before liveness probe is initiated                                                                                                                                                                          | `500`                   |
| `livenessProbe.periodSeconds`                       | How often to perform the probe                                                                                                                                                                                    | `10`                    |
| `livenessProbe.timeoutSeconds`                      | When the probe times out                                                                                                                                                                                          | `5`                     |
| `livenessProbe.failureThreshold`                    | Minimum consecutive failures for the probe                                                                                                                                                                        | `6`                     |
| `livenessProbe.successThreshold`                    | Minimum consecutive successes for the probe                                                                                                                                                                       | `1`                     |
| `readinessProbe.enabled`                            | Enable/disable readinessProbe                                                                                                                                                                                     | `true`                  |
| `readinessProbe.initialDelaySeconds`                | Delay before readiness probe is initiated                                                                                                                                                                         | `500`                   |
| `readinessProbe.periodSeconds`                      | How often to perform the probe                                                                                                                                                                                    | `10`                    |
| `readinessProbe.timeoutSeconds`                     | When the probe times out                                                                                                                                                                                          | `5`                     |
| `readinessProbe.failureThreshold`                   | Minimum consecutive failures for the probe                                                                                                                                                                        | `6`                     |
| `readinessProbe.successThreshold`                   | Minimum consecutive successes for the probe                                                                                                                                                                       | `1`                     |
| `customStartupProbe`                                | Custom startup probe to execute (when the main one is disabled)                                                                                                                                                   | `{}`                    |
| `customLivenessProbe`                               | Custom liveness probe to execute (when the main one is disabled)                                                                                                                                                  | `{}`                    |
| `customReadinessProbe`                              | Custom readiness probe to execute (when the main one is disabled)                                                                                                                                                 | `{}`                    |
| `containerPorts`                                    | EJBCA Container ports to open                                                                                                                                                                                     | `{}`                    |
| `extraContainerPorts`                               | Optionally specify extra list of additional ports for EJBCA container(s)                                                                                                                                          | `[]`                    |
| `serviceAccount.create`                             | Enable creation of ServiceAccount for EJBCA pod                                                                                                                                                                   | `true`                  |
| `serviceAccount.name`                               | The name of the ServiceAccount to use.                                                                                                                                                                            | `""`                    |
| `serviceAccount.automountServiceAccountToken`       | Allows auto mount of ServiceAccountToken on the serviceAccount created                                                                                                                                            | `false`                 |
| `serviceAccount.annotations`                        | Additional custom annotations for the ServiceAccount                                                                                                                                                              | `{}`                    |

### Service parameters

| Name                               | Description                                                                   | Value          |
| ---------------------------------- | ----------------------------------------------------------------------------- | -------------- |
| `service.type`                     | Kubernetes Service type                                                       | `LoadBalancer` |
| `service.ports.http`               | Service HTTP port                                                             | `8080`         |
| `service.ports.https`              | Service HTTPS port                                                            | `8443`         |
| `service.advertisedHttpsPort`      | Port number used in the rendered URLs for the admistrator login.              | `443`          |
| `service.httpsTargetPort`          | Service Target HTTPS port                                                     | `https`        |
| `service.nodePorts`                | Node Ports to expose                                                          | `{}`           |
| `service.clusterIP`                | EJBCA service Cluster IP                                                      | `""`           |
| `service.loadBalancerIP`           | EJBCA service Load Balancer IP                                                | `""`           |
| `service.externalTrafficPolicy`    | Enable client source IP preservation                                          | `Cluster`      |
| `service.annotations`              | Service annotations                                                           | `{}`           |
| `service.loadBalancerSourceRanges` | Limits which cidr blocks can connect to service's load balancer               | `[]`           |
| `service.extraPorts`               | Extra ports to expose in the service (normally used with the `sidecar` value) | `[]`           |
| `service.sessionAffinity`          | Session Affinity for Kubernetes service, can be "None" or "ClientIP"          | `None`         |
| `service.sessionAffinityConfig`    | Additional settings for the sessionAffinity                                   | `{}`           |

### Ingress parameters

| Name                       | Description                                                                                                                      | Value                    |
| -------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `ingress.enabled`          | Enable ingress controller resource                                                                                               | `false`                  |
| `ingress.pathType`         | Ingress Path type                                                                                                                | `ImplementationSpecific` |
| `ingress.apiVersion`       | Override API Version (automatically detected if not set)                                                                         | `""`                     |
| `ingress.hostname`         | Default host for the ingress resource                                                                                            | `ejbca.local`            |
| `ingress.path`             | The Path to EJBCA. You may need to set this to '/*' in order to use this                                                         | `/`                      |
| `ingress.annotations`      | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                     |
| `ingress.tls`              | Enable TLS configuration for the hostname defined at ingress.hostname parameter                                                  | `false`                  |
| `ingress.extraHosts`       | The list of additional hostnames to be covered with this ingress record.                                                         | `[]`                     |
| `ingress.extraPaths`       | Any additional arbitrary paths that may need to be added to the ingress under the main host.                                     | `[]`                     |
| `ingress.extraTls`         | The tls configuration for additional hostnames to be covered with this ingress record.                                           | `[]`                     |
| `ingress.secrets`          | If you're providing your own certificates, please use this to add the certificates as secrets                                    | `[]`                     |
| `ingress.ingressClassName` | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                    | `""`                     |
| `ingress.extraRules`       | Additional rules to be covered with this ingress record                                                                          | `[]`                     |

### Database parameters

| Name                                        | Description                                                                                                                                                                                                                | Value           |
| ------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------- |
| `mariadb.enabled`                           | Whether to deploy a mariadb server to satisfy the applications database requirements.                                                                                                                                      | `true`          |
| `mariadb.architecture`                      | MariaDB architecture (`standalone` or `replication`)                                                                                                                                                                       | `standalone`    |
| `mariadb.auth.rootPassword`                 | Password for the MariaDB `root` user                                                                                                                                                                                       | `""`            |
| `mariadb.auth.database`                     | Database name to create                                                                                                                                                                                                    | `bitnami_ejbca` |
| `mariadb.auth.username`                     | Database user to create                                                                                                                                                                                                    | `bn_ejbca`      |
| `mariadb.auth.password`                     | Password for the database                                                                                                                                                                                                  | `""`            |
| `mariadb.primary.persistence.enabled`       | Enable database persistence using PVC                                                                                                                                                                                      | `true`          |
| `mariadb.primary.persistence.storageClass`  | MariaDB primary persistent volume storage Class                                                                                                                                                                            | `""`            |
| `mariadb.primary.persistence.accessMode`    | Persistent Volume access mode                                                                                                                                                                                              | `ReadWriteOnce` |
| `mariadb.primary.persistence.size`          | Database Persistent Volume Size                                                                                                                                                                                            | `8Gi`           |
| `mariadb.primary.persistence.hostPath`      | Set path in case you want to use local host path volumes (not recommended in production)                                                                                                                                   | `""`            |
| `mariadb.primary.persistence.existingClaim` | Name of an existing `PersistentVolumeClaim` for MariaDB primary replicas                                                                                                                                                   | `""`            |
| `mariadb.primary.resourcesPreset`           | Set container resources according to one common preset (allowed values: none, nano, small, medium, large, xlarge, 2xlarge). This is ignored if primary.resources is set (primary.resources is recommended for production). | `micro`         |
| `mariadb.primary.resources`                 | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                          | `{}`            |
| `externalDatabase.host`                     | Host of the external database                                                                                                                                                                                              | `localhost`     |
| `externalDatabase.user`                     | non-root Username for EJBCA Database                                                                                                                                                                                       | `bn_ejbca`      |
| `externalDatabase.password`                 | Password for the above username                                                                                                                                                                                            | `""`            |
| `externalDatabase.existingSecret`           | Name of an existing secret resource containing the DB password in a 'mariadb-password' key                                                                                                                                 | `""`            |
| `externalDatabase.database`                 | Name of the existing database                                                                                                                                                                                              | `bitnami_ejbca` |
| `externalDatabase.port`                     | Database port number                                                                                                                                                                                                       | `3306`          |

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

The above parameters map to the env variables defined in [bitnami/ejbca](https://github.com/bitnami/containers/tree/main/bitnami/ejbca). For more information please refer to the [bitnami/ejbca](https://github.com/bitnami/containers/tree/main/bitnami/ejbca) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
  --set ejbcaAdminUsername=admin,ejbcaAdminPassword=password,mariadb.auth.password=secretpassword \
    oci://REGISTRY_NAME/REPOSITORY_NAME/discourse
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The above command sets the EJBCA administrator account username and password to `admin` and `password` respectively. Additionally, it sets the MariaDB `bn_ejbca` user password to `secretpassword`.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml oci://REGISTRY_NAME/REPOSITORY_NAME/ejbca
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.
> **Tip**: You can use the default [values.yaml](https://github.com/bitnami/charts/tree/main/bitnami/ejbca/values.yaml)

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 14.0.0

This major release bumps the MariaDB chart version to [18.x.x](https://github.com/bitnami/charts/pull/24804); no major issues are expected during the upgrade.

### To 13.0.0

This major bump changes the following security defaults:

- `runAsGroup` is changed from `0` to `1001`
- `readOnlyRootFilesystem` is set to `true`
- `resourcesPreset` is changed from `none` to the minimum size working in our test suites (NOTE: `resourcesPreset` is not meant for production usage, but `resources` adapted to your use case).
- `global.compatibility.openshift.adaptSecurityContext` is changed from `disabled` to `auto`.
- The `networkPolicy` section has been normalized amongst all Bitnami charts. Compared to the previous approach, the values section has been simplified (check the Parameters section) and now it set to `enabled=true` by default. Egress traffic is allowed by default and ingress traffic is allowed by all pods but only to the ports set in `containerPorts` and `extraContainerPorts`.

This could potentially break any customization or init scripts used in your deployment. If this is the case, change the default values to the previous ones.

### To 12.0.0

This major release bumps the MariaDB chart version to 16.x. No major issues are expected during the upgrade.

### To 11.0.0

This major release bumps the MariaDB version to 11.2. No major issues are expected during the upgrade.

### To 10.0.0

This major release bumps the MariaDB version to 11.1. No major issues are expected during the upgrade.

### To 9.0.0

This major release only bumps the EJBCA version to 8.x. No major issues are expected during the upgrade. Refer to [upstream upgrade notes](https://doc.primekey.com/ejbca/ejbca-release-information/ejbca-upgrade-notes/ejbca-8-0-upgrade-notes) for more info about the changes included in this new major version of the application.

### To 8.0.0

This major release bumps the MariaDB version to 11.0. Follow the [upstream instructions](https://mariadb.com/kb/en/upgrading-from-mariadb-10-11-to-mariadb-11-0/) for upgrading from MariaDB 10.11 to 11.0. No major issues are expected during the upgrade.

### To 7.0.0

This major release bumps the MariaDB version to 10.11. Follow the [upstream instructions](https://mariadb.com/kb/en/upgrading-from-mariadb-10-6-to-mariadb-10-11/) for upgrading from MariaDB 10.6 to 10.11. No major issues are expected during the upgrade.

### To 6.0.0

The MariaDB subchart has been updated to the latest version (now it uses 10.6). No major issues are expected during the upgrade.

### To 5.0.0

This major release renames several values in this chart and adds missing features, in order to be inline with the rest of assets in the Bitnami charts repository.

Affected values:

- `service.port` was deprecated, we recommend using`service.ports.http` instead.
- `service.httpsPort` was deprecated, we recommend using`service.port.https` instead.
- `extraEnv` renamed as `extraEnvVars`
- `persistence.accessMode` has been deprecated, we recommend using `persistence.accessModes` instead.

Additionally, updates the MariaDB subchart to it newest major, 10.0.0, which contains similar changes.

### To 2.0.0

[On November 13, 2020, Helm v2 support formally ended](https://github.com/helm/charts#status-of-the-project). This major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

### To 1.0.0

MariaDB dependency version was bumped to a new major version that introduces several incompatilibites. Therefore, backwards compatibility is not guaranteed unless an external database is used. Check [MariaDB Upgrading Notes](https://github.com/bitnami/charts/tree/main/bitnami/mariadb#to-800) for more information.

To upgrade to `1.0.0`, you have two alternatives:

- Install a new EJBCA chart, and migrate your EJBCA following [the official documentation](https://doc.primekey.com/ejbca/ejbca-operations/ejbca-operations-guide/ca-operations-guide/ejbca-maintenance/backup-and-restore).
- Reuse the PVC used to hold the MariaDB data on your previous release. To do so, follow the instructions below (the following example assumes that the release name is `ejbca`):

> NOTE: Please, create a backup of your database before running any of those actions. The steps below would be only valid if your application (e.g. any plugins or custom code) is compatible with MariaDB 10.5.x

Obtain the credentials and the name of the PVC used to hold the MariaDB data on your current release:

```console
export EJBCA_ADMIN_PASSWORD=$(kubectl get secret --namespace default ejbca -o jsonpath="{.data.ejbca-admin-password}" | base64 -d)
export MARIADB_ROOT_PASSWORD=$(kubectl get secret --namespace default ejbca-mariadb -o jsonpath="{.data.mariadb-root-password}" | base64 -d)
export MARIADB_PASSWORD=$(kubectl get secret --namespace default ejbca-mariadb -o jsonpath="{.data.mariadb-password}" | base64 -d)
export MARIADB_PVC=$(kubectl get pvc -l app=mariadb,component=master,release=ejbca -o jsonpath="{.items[0].metadata.name}")
```

Upgrade your release (maintaining the version) disabling MariaDB and scaling EJBCA replicas to 0:

```console
helm upgrade ejbca oci://REGISTRY_NAME/REPOSITORY_NAME/ejbca --set ejbcaAdminPassword=$EJBCA_ADMIN_PASSWORD --set replicaCount=0 --set mariadb.enabled=false --version 0.4.0
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

Finally, upgrade you release to 1.0.0 reusing the existing PVC, and enabling back MariaDB:

```console
helm upgrade ejbca oci://REGISTRY_NAME/REPOSITORY_NAME/ejbca --set mariadb.primary.persistence.existingClaim=$MARIADB_PVC --set mariadb.auth.rootPassword=$MARIADB_ROOT_PASSWORD --set mariadb.auth.password=$MARIADB_PASSWORD --set ejbcaAdminPassword=$EJBCA_ADMIN_PASSWORD
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

You should see the lines below in MariaDB container logs:

```console
$ kubectl logs $(kubectl get pods -l app.kubernetes.io/instance=ejbca,app.kubernetes.io/name=mariadb,app.kubernetes.io/component=primary -o jsonpath="{.items[0].metadata.name}")
...
mariadb 12:13:24.98 INFO  ==> Using persisted data
mariadb 12:13:25.01 INFO  ==> Running mysql_upgrade
...
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