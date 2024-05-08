<!--- app-name: Redmine -->

# Bitnami package for Redmine

Redmine is an open source management application. It includes a tracking issue system, Gantt charts for a visual view of projects and deadlines, and supports SCM integration for version control.

[Overview of Redmine](https://www.redmine.org/)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/redmine
```

Looking to use Redmine in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the enterprise edition of Bitnami Application Catalog.

## Introduction

This chart bootstraps a [Redmine](https://github.com/bitnami/containers/tree/main/bitnami/redmine) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages the [Bitnami MariaDB chart](https://github.com/bitnami/charts/tree/main/bitnami/mariadb) and the [PostgreSQL chart](https://github.com/bitnami/charts/tree/main/bitnami/postgresql) which are required for bootstrapping a MariaDB/PostgreSQL deployment for the database requirements of the Redmine application.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+
- PV provisioner support in the underlying infrastructure
- ReadWriteMany volumes for deployment scaling

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/redmine
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The command deploys Redmine on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Configuration and installation details

### Using PostgreSQL instead of MariaDB

This chart includes the option to use a PostgreSQL database for Redmine instead of MariaDB. To use this, set the `databaseType` parameter to `postgresql`:

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/redmine --set databaseType=postgresql
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

### Certificates

#### CA Certificates

Custom CA certificates not included in the base docker image can be added with
the following configuration. The secret must exist in the same namespace as the
deployment. Will load all certificates files it finds in the secret.

```yaml
certificates:
  customCAs:
    - secret: my-ca-1
    - secret: my-ca-2
```

##### CA Certificates Secret

Secret can be created with:

```console
kubectl create secret generic my-ca-1 --from-file my-ca-1.crt
```

#### TLS Certificate

A web server TLS Certificate can be injected into the container with the
following configuration. The certificate will be stored at the location
specified in the certificateLocation value.

```yaml
certificates:
  customCertificate:
    certificateSecret: my-secret
    certificateLocation: /ssl/server.pem
    keyLocation: /ssl/key.pem
    chainSecret:
      name: my-cert-chain
      key: chain.pem
```

##### TLS Certificate Secret

The certificate tls secret can be created with:

```console
kubectl create secret tls my-secret --cert tls.crt --key tls.key
```

The certificate chain is created with:

```console
kubectl create secret generic my-cert-chain --from-file chain.pem
```

### Resource requests and limits

Bitnami charts allow setting resource requests and limits for all containers inside the chart deployment. These are inside the `resources` value (check parameter table). Setting requests is essential for production workloads and these should be adapted to your specific use case.

To make this process easier, the chart contains the `resourcesPreset` values, which automatically sets the `resources` section according to different presets. Check these presets in [the bitnami/common chart](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15). However, in production workloads using `resourcePreset` is discouraged as it may not fully adapt to your specific needs. Find more information on container resource management in the [official Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).

### [Rolling VS Immutable tags](https://docs.vmware.com/en/VMware-Tanzu-Application-Catalog/services/tutorials/GUID-understand-rolling-tags-containers-index.html)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Replicas

Redmine writes uploaded files to a persistent volume. By default that volume cannot be shared between pods (RWO). In such a configuration the `replicas` option must be set to `1`. If the persistent volume supports more than one writer (RWX), ie NFS, `replicas` can be greater than `1`.

> **Important**: When running more than one instance of Redmine they must share the same `secret_key_base` to have sessions working acreoss all instances.
> This can be achieved by setting
>
> ```yaml
>   extraEnvVars:
>    - name: SECRET_KEY_BASE
>      value: someredminesecretkeybase
> ```

### Deploying to a sub-URI

(adapted from <https://github.com/bitnami/containers/tree/main/bitnami/redmine>)

On certain occasions, you may need that Redmine is available under a specific sub-URI path rather than the root. A common scenario to this problem may arise if you plan to set up your Redmine container behind a reverse proxy. To deploy your Redmine container using a certain sub-URI you just need to follow these steps:

#### Create a configmap containing an altered version of post-init.sh

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: redmine-init-configmap
  namespace: <same-namespace-as-the-chart>
  labels:
  ...
data:

  post-init.sh: |-
    #!/bin/bash

    # REPLACE WITH YOUR OWN SUB-URI
    SUB_URI_PATH='/redmine'

    #Config files where to apply changes
    config1=/opt/bitnami/redmine/config.ru
    config2=/opt/bitnami/redmine/config/environment.rb

    sed -i '$ d' ${config1}
    echo 'map ActionController::Base.config.try(:relative_url_root) || "/" do' >> ${config1}
    echo 'run Rails.application' >> ${config1}
    echo 'end' >> ${config1}
    echo 'Redmine::Utils::relative_url_root = "'${SUB_URI_PATH}'"' >> ${config2}

    SUB_URI_PATH=$(echo ${SUB_URI_PATH} | sed -e 's|/|\\/|g')
    sed -i -e "s/\(relative_url_root\ \=\ \"\).*\(\"\)/\1${SUB_URI_PATH}\2/" ${config2}
```

#### Add this confimap as a volume/volume mount in the chart values

```yaml
## Extra volumes to add to the deployment
##
extraVolumes:
  - name: redmine-init-volume
    configMap:
      name: redmine-init-configmap

## Extra volume mounts to add to the container
##
extraVolumeMounts:
  - name: "redmine-init-volume"
    mountPath: "/post-init.sh"
    subPath: post-init.sh
```

#### Change the probes URI

```yaml
## Configure extra options for liveness and readiness probes
## ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/#configure-probes)
##
livenessProbe:
  enabled: true
  path: /redmine/
---
readinessProbe:
  enabled: true
  path: /redmine/
```

## Persistence

The [Bitnami Redmine](https://github.com/bitnami/containers/tree/main/bitnami/redmine) image stores the Redmine data and configurations at the `/bitnami/redmine` path of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube. The volume is created using dynamic volume provisioning. Clusters configured with NFS mounts require manually managed volumes and claims.

See the [Parameters](#parameters) section to configure the PVC or to disable persistence.

### Existing PersistentVolumeClaims

The following example includes two PVCs, one for Redmine and another for MariaDB.

1. Create the PersistentVolume
2. Create the PersistentVolumeClaim
3. Create the directory, on a worker
4. Install the chart

```console
helm install test --set persistence.existingClaim=PVC_REDMINE,mariadb.persistence.existingClaim=PVC_MARIADB oci://REGISTRY_NAME/REPOSITORY_NAME/redmine
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

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
| `nameOverride`           | String to partially override common.names.fullname                                      | `""`            |
| `fullnameOverride`       | String to fully override common.names.fullname                                          | `""`            |
| `commonLabels`           | Labels to add to all deployed objects                                                   | `{}`            |
| `commonAnnotations`      | Annotations to add to all deployed objects                                              | `{}`            |
| `clusterDomain`          | Default Kubernetes cluster domain                                                       | `cluster.local` |
| `extraDeploy`            | Array of extra objects to deploy with the release                                       | `[]`            |
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden) | `false`         |
| `diagnosticMode.command` | Command to override all containers in the the deployment                                | `["sleep"]`     |
| `diagnosticMode.args`    | Args to override all containers in the the deployment                                   | `["infinity"]`  |

### Redmine Configuration parameters

| Name                    | Description                                                                                             | Value                     |
| ----------------------- | ------------------------------------------------------------------------------------------------------- | ------------------------- |
| `image.registry`        | Redmine image registry                                                                                  | `REGISTRY_NAME`           |
| `image.repository`      | Redmine image repository                                                                                | `REPOSITORY_NAME/redmine` |
| `image.digest`          | Redmine image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag | `""`                      |
| `image.pullPolicy`      | Redmine image pull policy                                                                               | `IfNotPresent`            |
| `image.pullSecrets`     | Redmine image pull secrets                                                                              | `[]`                      |
| `image.debug`           | Enable image debug mode                                                                                 | `false`                   |
| `redmineUsername`       | Redmine username                                                                                        | `user`                    |
| `redminePassword`       | Redmine user password                                                                                   | `""`                      |
| `redmineEmail`          | Redmine user email                                                                                      | `user@example.com`        |
| `redmineLanguage`       | Redmine default data language                                                                           | `en`                      |
| `allowEmptyPassword`    | Allow the container to be started with blank passwords                                                  | `false`                   |
| `smtpHost`              | SMTP server host                                                                                        | `""`                      |
| `smtpPort`              | SMTP server port                                                                                        | `""`                      |
| `smtpUser`              | SMTP username                                                                                           | `""`                      |
| `smtpPassword`          | SMTP user password                                                                                      | `""`                      |
| `smtpProtocol`          | SMTP protocol                                                                                           | `""`                      |
| `existingSecret`        | Name of existing secret containing Redmine credentials                                                  | `""`                      |
| `smtpExistingSecret`    | The name of an existing secret with SMTP credentials                                                    | `""`                      |
| `customPostInitScripts` | Custom post-init.d user scripts                                                                         | `{}`                      |
| `command`               | Override default container command (useful when using custom images)                                    | `[]`                      |
| `args`                  | Override default container args (useful when using custom images)                                       | `[]`                      |
| `extraEnvVars`          | Array with extra environment variables to add to the Redmine container                                  | `[]`                      |
| `extraEnvVarsCM`        | Name of existing ConfigMap containing extra env vars                                                    | `""`                      |
| `extraEnvVarsSecret`    | Name of existing Secret containing extra env vars                                                       | `""`                      |

### Redmine deployment parameters

| Name                                                | Description                                                                                                                                                                                                       | Value                                                              |
| --------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------ |
| `replicaCount`                                      | Number of Redmine replicas to deploy                                                                                                                                                                              | `1`                                                                |
| `containerPorts.http`                               | Redmine HTTP container port                                                                                                                                                                                       | `3000`                                                             |
| `resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if resources is set (resources is recommended for production). | `micro`                                                            |
| `resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                 | `{}`                                                               |
| `podSecurityContext.enabled`                        | Enabled Redmine pods' Security Context                                                                                                                                                                            | `true`                                                             |
| `podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                | `Always`                                                           |
| `podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                    | `[]`                                                               |
| `podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                       | `[]`                                                               |
| `podSecurityContext.fsGroup`                        | Set Redmine pod's Security Context fsGroup                                                                                                                                                                        | `0`                                                                |
| `containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                                                                                                                              | `true`                                                             |
| `containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                  | `{}`                                                               |
| `containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                                                                                                        | `0`                                                                |
| `containerSecurityContext.runAsGroup`               | Set containers' Security Context runAsGroup                                                                                                                                                                       | `0`                                                                |
| `containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                                                                                                                     | `false`                                                            |
| `containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                                                                                                                       | `false`                                                            |
| `containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                           | `false`                                                            |
| `containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                                                                                                         | `false`                                                            |
| `containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                | `["ALL"]`                                                          |
| `containerSecurityContext.capabilities.add`         | List of capabilities to be added                                                                                                                                                                                  | `["CHOWN","SYS_CHROOT","FOWNER","SETGID","SETUID","DAC_OVERRIDE"]` |
| `containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                  | `RuntimeDefault`                                                   |
| `livenessProbe.enabled`                             | Enable livenessProbe on Redmine containers                                                                                                                                                                        | `true`                                                             |
| `livenessProbe.path`                                | Path for to check for livenessProbe                                                                                                                                                                               | `/`                                                                |
| `livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                           | `300`                                                              |
| `livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                  | `10`                                                               |
| `livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                 | `5`                                                                |
| `livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                               | `6`                                                                |
| `livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                               | `1`                                                                |
| `readinessProbe.enabled`                            | Enable readinessProbe on Redmine containers                                                                                                                                                                       | `true`                                                             |
| `readinessProbe.path`                               | Path to check for readinessProbe                                                                                                                                                                                  | `/`                                                                |
| `readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                          | `5`                                                                |
| `readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                 | `10`                                                               |
| `readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                | `5`                                                                |
| `readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                              | `6`                                                                |
| `readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                              | `1`                                                                |
| `startupProbe.enabled`                              | Enable startupProbe on Redmine containers                                                                                                                                                                         | `false`                                                            |
| `startupProbe.path`                                 | Path to check for startupProbe                                                                                                                                                                                    | `/`                                                                |
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
| `hostAliases`                                       | Redmine pod host aliases                                                                                                                                                                                          | `[]`                                                               |
| `podLabels`                                         | Extra labels for Redmine pods                                                                                                                                                                                     | `{}`                                                               |
| `podAnnotations`                                    | Annotations for Redmine pods                                                                                                                                                                                      | `{}`                                                               |
| `podAffinityPreset`                                 | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                               | `""`                                                               |
| `podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                          | `soft`                                                             |
| `nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                         | `""`                                                               |
| `nodeAffinityPreset.key`                            | Node label key to match. Ignored if `affinity` is set                                                                                                                                                             | `""`                                                               |
| `nodeAffinityPreset.values`                         | Node label values to match. Ignored if `affinity` is set                                                                                                                                                          | `[]`                                                               |
| `affinity`                                          | Affinity for pod assignment                                                                                                                                                                                       | `{}`                                                               |
| `nodeSelector`                                      | Node labels for pod assignment                                                                                                                                                                                    | `{}`                                                               |
| `tolerations`                                       | Tolerations for pod assignment                                                                                                                                                                                    | `[]`                                                               |
| `priorityClassName`                                 | Redmine pods' Priority Class Name                                                                                                                                                                                 | `""`                                                               |
| `schedulerName`                                     | Alternate scheduler                                                                                                                                                                                               | `""`                                                               |
| `terminationGracePeriodSeconds`                     | Seconds Redmine pod needs to terminate gracefully                                                                                                                                                                 | `""`                                                               |
| `topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template                                                                                          | `[]`                                                               |
| `updateStrategy.type`                               | Redmine statefulset strategy type                                                                                                                                                                                 | `RollingUpdate`                                                    |
| `updateStrategy.rollingUpdate`                      | Redmine statefulset rolling update configuration parameters                                                                                                                                                       | `{}`                                                               |
| `extraVolumes`                                      | Optionally specify extra list of additional volumes for Redmine pods                                                                                                                                              | `[]`                                                               |
| `extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for Redmine container(s)                                                                                                                                 | `[]`                                                               |
| `initContainers`                                    | Add additional init containers to the Redmine pods                                                                                                                                                                | `[]`                                                               |
| `sidecars`                                          | Add additional sidecar containers to the Redmine pod                                                                                                                                                              | `[]`                                                               |

### Traffic Exposure Parameters

| Name                               | Description                                                                                                                      | Value                    |
| ---------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `service.type`                     | Redmine service type                                                                                                             | `LoadBalancer`           |
| `service.ports.http`               | Redmine service HTTP port                                                                                                        | `80`                     |
| `service.nodePorts.http`           | NodePort for the Redmine HTTP endpoint                                                                                           | `""`                     |
| `service.sessionAffinity`          | Control where client requests go, to the same pod or round-robin                                                                 | `None`                   |
| `service.sessionAffinityConfig`    | Additional settings for the sessionAffinity                                                                                      | `{}`                     |
| `service.clusterIP`                | Redmine service Cluster IP                                                                                                       | `""`                     |
| `service.loadBalancerIP`           | Redmine service Load Balancer IP                                                                                                 | `""`                     |
| `service.loadBalancerSourceRanges` | Redmine service Load Balancer sources                                                                                            | `[]`                     |
| `service.externalTrafficPolicy`    | Redmine service external traffic policy                                                                                          | `Cluster`                |
| `service.annotations`              | Additional custom annotations for Redmine service                                                                                | `{}`                     |
| `service.extraPorts`               | Extra port to expose on Redmine service                                                                                          | `[]`                     |
| `ingress.enabled`                  | Enable ingress record generation for Redmine                                                                                     | `false`                  |
| `ingress.ingressClassName`         | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                    | `""`                     |
| `ingress.pathType`                 | Ingress path type                                                                                                                | `ImplementationSpecific` |
| `ingress.apiVersion`               | Force Ingress API version (automatically detected if not set)                                                                    | `""`                     |
| `ingress.hostname`                 | Default host for the ingress record                                                                                              | `redmine.local`          |
| `ingress.path`                     | Default path for the ingress record                                                                                              | `/`                      |
| `ingress.annotations`              | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                     |
| `ingress.tls`                      | Enable TLS configuration for the host defined at `ingress.hostname` parameter                                                    | `false`                  |
| `ingress.selfSigned`               | Create a TLS secret for this ingress record using self-signed certificates generated by Helm                                     | `false`                  |
| `ingress.extraHosts`               | An array with additional hostname(s) to be covered with the ingress record                                                       | `[]`                     |
| `ingress.extraPaths`               | An array with additional arbitrary paths that may need to be added to the ingress under the main host                            | `[]`                     |
| `ingress.extraTls`                 | The tls configuration for additional hostnames to be covered with this ingress record.                                           | `[]`                     |
| `ingress.secrets`                  | If you're providing your own certificates, please use this to add the certificates as secrets                                    | `[]`                     |
| `ingress.extraRules`               | Additional rules to be covered with this ingress record                                                                          | `[]`                     |

### Persistence Parameters

| Name                                                        | Description                                                                                                                                                                                                                                           | Value   |
| ----------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `persistence.enabled`                                       | Enable persistence using Persistent Volume Claims                                                                                                                                                                                                     | `true`  |
| `persistence.storageClass`                                  | Persistent Volume storage class                                                                                                                                                                                                                       | `""`    |
| `persistence.accessModes`                                   | Persistent Volume access modes                                                                                                                                                                                                                        | `[]`    |
| `persistence.size`                                          | Persistent Volume size                                                                                                                                                                                                                                | `8Gi`   |
| `persistence.dataSource`                                    | Custom PVC data source                                                                                                                                                                                                                                | `{}`    |
| `persistence.annotations`                                   | Annotations for the PVC                                                                                                                                                                                                                               | `{}`    |
| `persistence.selector`                                      | Selector to match an existing Persistent Volume (this value is evaluated as a template)                                                                                                                                                               | `{}`    |
| `persistence.existingClaim`                                 | The name of an existing PVC to use for persistence                                                                                                                                                                                                    | `""`    |
| `volumePermissions.enabled`                                 | Enable init container that changes the owner/group of the PV mount point to `runAsUser:fsGroup`                                                                                                                                                       | `false` |
| `volumePermissions.resourcesPreset`                         | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if volumePermissions.resources is set (volumePermissions.resources is recommended for production). | `nano`  |
| `volumePermissions.resources`                               | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                                     | `{}`    |
| `volumePermissions.containerSecurityContext.enabled`        | Enable init container's Security Context                                                                                                                                                                                                              | `true`  |
| `volumePermissions.containerSecurityContext.seLinuxOptions` | Set SELinux options in container                                                                                                                                                                                                                      | `nil`   |
| `volumePermissions.containerSecurityContext.runAsUser`      | Set init container's Security Context runAsUser                                                                                                                                                                                                       | `0`     |

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
| `pdb.minAvailable`         | Minimum number/percentage of pods that should remain scheduled | `""`    |
| `pdb.maxUnavailable`       | Maximum number/percentage of pods that may be made unavailable | `""`    |
| `autoscaling.enabled`      | Enable Horizontal POD autoscaling for Redmine                  | `false` |
| `autoscaling.minReplicas`  | Minimum number of Redmine replicas                             | `1`     |
| `autoscaling.maxReplicas`  | Maximum number of Redmine replicas                             | `11`    |
| `autoscaling.targetCPU`    | Target CPU utilization percentage                              | `50`    |
| `autoscaling.targetMemory` | Target Memory utilization percentage                           | `50`    |

### Database Parameters

| Name                                         | Description                                                             | Value             |
| -------------------------------------------- | ----------------------------------------------------------------------- | ----------------- |
| `databaseType`                               | Redmine database type. Allowed values: `mariadb` and `postgresql`       | `mariadb`         |
| `mariadb.enabled`                            | Switch to enable or disable the MariaDB helm chart                      | `true`            |
| `mariadb.auth.rootPassword`                  | MariaDB root password                                                   | `""`              |
| `mariadb.auth.username`                      | MariaDB username                                                        | `bn_redmine`      |
| `mariadb.auth.password`                      | MariaDB password                                                        | `""`              |
| `mariadb.auth.existingSecret`                | Name of existing secret to use for MariaDB credentials                  | `""`              |
| `mariadb.architecture`                       | MariaDB architecture. Allowed values: `standalone` or `replication`     | `standalone`      |
| `postgresql.enabled`                         | Switch to enable or disable the PostgreSQL helm chart                   | `true`            |
| `postgresql.auth.username`                   | Name for a custom user to create                                        | `bn_redmine`      |
| `postgresql.auth.password`                   | Password for the custom user to create                                  | `""`              |
| `postgresql.auth.database`                   | Name for a custom database to create                                    | `bitnami_redmine` |
| `postgresql.auth.existingSecret`             | Name of existing secret to use for PostgreSQL credentials               | `""`              |
| `postgresql.architecture`                    | PostgreSQL architecture (`standalone` or `replication`)                 | `standalone`      |
| `externalDatabase.host`                      | Database host                                                           | `""`              |
| `externalDatabase.port`                      | Database port number                                                    | `5432`            |
| `externalDatabase.user`                      | Non-root username for Redmine                                           | `bn_redmine`      |
| `externalDatabase.password`                  | Password for the non-root username for Redmine                          | `""`              |
| `externalDatabase.database`                  | Redmine database name                                                   | `bitnami_redmine` |
| `externalDatabase.existingSecret`            | Name of an existing secret resource containing the database credentials | `""`              |
| `externalDatabase.existingSecretPasswordKey` | Name of an existing secret key containing the database credentials      | `""`              |

### Mail Receiver/Cron Job Parameters

| Name                                                   | Description                                                                                                                                   | Value         |
| ------------------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------- | ------------- |
| `mailReceiver.enabled`                                 | Whether to enable scheduled mail-to-task CronJob                                                                                              | `false`       |
| `mailReceiver.schedule`                                | Kubernetes CronJob schedule                                                                                                                   | `*/5 * * * *` |
| `mailReceiver.suspend`                                 | Whether to create suspended CronJob                                                                                                           | `true`        |
| `mailReceiver.mailProtocol`                            | Mail protocol to use for reading emails. Allowed values: `IMAP` and `POP3`                                                                    | `IMAP`        |
| `mailReceiver.host`                                    | Server to receive emails from                                                                                                                 | `""`          |
| `mailReceiver.port`                                    | TCP port on the `host`                                                                                                                        | `993`         |
| `mailReceiver.username`                                | Login to authenticate on the `host`                                                                                                           | `""`          |
| `mailReceiver.password`                                | Password to authenticate on the `host`                                                                                                        | `""`          |
| `mailReceiver.ssl`                                     | Whether use SSL/TLS to connect to the `host`                                                                                                  | `true`        |
| `mailReceiver.startTLS`                                | Whether use StartTLS to connect to the `host`                                                                                                 | `false`       |
| `mailReceiver.imapFolder`                              | IMAP only. Folder to read emails from                                                                                                         | `INBOX`       |
| `mailReceiver.moveOnSuccess`                           | IMAP only. Folder to move processed emails to                                                                                                 | `""`          |
| `mailReceiver.moveOnFailure`                           | IMAP only. Folder to move emails with processing errors to                                                                                    | `""`          |
| `mailReceiver.unknownUserAction`                       | Action to perform is an email received from unregistered user                                                                                 | `ignore`      |
| `mailReceiver.noPermissionCheck`                       | Whether skip permission check during creating a new task                                                                                      | `0`           |
| `mailReceiver.noAccountNotice`                         | Whether send an email to an unregistered user created during a new task creation                                                              | `1`           |
| `mailReceiver.defaultGroup`                            | Defines a group list to add created user to                                                                                                   | `""`          |
| `mailReceiver.project`                                 | Defines identifier of the target project for a new task                                                                                       | `""`          |
| `mailReceiver.projectFromSubaddress`                   | Defines email address to select project from subaddress                                                                                       | `""`          |
| `mailReceiver.status`                                  | Defines a new task status                                                                                                                     | `""`          |
| `mailReceiver.tracker`                                 | Defines a new task tracker                                                                                                                    | `""`          |
| `mailReceiver.category`                                | Defines a new task category                                                                                                                   | `""`          |
| `mailReceiver.priority`                                | Defines a new task priority                                                                                                                   | `""`          |
| `mailReceiver.assignedTo`                              | Defines a new task assignee                                                                                                                   | `""`          |
| `mailReceiver.allowOverride`                           | Defines if email content is allowed to set attributes values. Values is a comma separated list of attributes or `all` to allow all attributes | `""`          |
| `mailReceiver.command`                                 | Override default container command (useful when using custom images)                                                                          | `[]`          |
| `mailReceiver.args`                                    | Override default container args (useful when using custom images)                                                                             | `[]`          |
| `mailReceiver.extraEnvVars`                            | Extra environment variables to be set on mailReceiver container                                                                               | `[]`          |
| `mailReceiver.extraEnvVarsCM`                          | Name of existing ConfigMap containing extra env vars                                                                                          | `""`          |
| `mailReceiver.extraEnvVarsSecret`                      | Name of existing Secret containing extra env vars                                                                                             | `""`          |
| `mailReceiver.podSecurityContext.enabled`              | Enabled Redmine pods' Security Context                                                                                                        | `true`        |
| `mailReceiver.podSecurityContext.fsGroupChangePolicy`  | Set filesystem group change policy                                                                                                            | `Always`      |
| `mailReceiver.podSecurityContext.sysctls`              | Set kernel settings using the sysctl interface                                                                                                | `[]`          |
| `mailReceiver.podSecurityContext.supplementalGroups`   | Set filesystem extra groups                                                                                                                   | `[]`          |
| `mailReceiver.podSecurityContext.fsGroup`              | Set Redmine pod's Security Context fsGroup                                                                                                    | `1001`        |
| `mailReceiver.containerSecurityContext.enabled`        | mailReceiver Container securityContext                                                                                                        | `false`       |
| `mailReceiver.containerSecurityContext.seLinuxOptions` | Set SELinux options in container                                                                                                              | `nil`         |
| `mailReceiver.containerSecurityContext.runAsUser`      | User ID for the mailReceiver container                                                                                                        | `1001`        |
| `mailReceiver.containerSecurityContext.runAsNonRoot`   | Whether to run the mailReceiver container as a non-root user                                                                                  | `true`        |
| `mailReceiver.podAnnotations`                          | Additional pod annotations                                                                                                                    | `{}`          |
| `mailReceiver.podLabels`                               | Additional pod labels                                                                                                                         | `{}`          |
| `mailReceiver.podAffinityPreset`                       | Pod affinity preset. Ignored if `mailReceiver.affinity` is set. Allowed values: `soft` or `hard`                                              | `""`          |
| `mailReceiver.podAntiAffinityPreset`                   | Pod anti-affinity preset. Ignored if `mailReceiver.affinity` is set. Allowed values: `soft` or `hard`                                         | `soft`        |
| `mailReceiver.nodeAffinityPreset.type`                 | Node affinity preset. Ignored if `mailReceiver.affinity` is set. Allowed values: `soft` or `hard`                                             | `""`          |
| `mailReceiver.nodeAffinityPreset.key`                  | Node label key to match. Ignored if `mailReceiver.affinity` is set.                                                                           | `""`          |
| `mailReceiver.nodeAffinityPreset.values`               | Node label values to match. Ignored if `mailReceiver.affinity` is set.                                                                        | `[]`          |
| `mailReceiver.affinity`                                | Affinity for pod assignment                                                                                                                   | `{}`          |
| `mailReceiver.nodeSelector`                            | Node labels for pod assignment                                                                                                                | `{}`          |
| `mailReceiver.tolerations`                             | Tolerations for pod assignment                                                                                                                | `[]`          |
| `mailReceiver.priorityClassName`                       | Redmine pods' priority.                                                                                                                       | `""`          |
| `mailReceiver.initContainers`                          | Add additional init containers to the mailReceiver pods                                                                                       | `[]`          |
| `mailReceiver.sidecars`                                | Add additional sidecar containers to the mailReceiver pods                                                                                    | `[]`          |
| `mailReceiver.extraVolumes`                            | Optionally specify extra list of additional volumes for mailReceiver container                                                                | `[]`          |
| `mailReceiver.extraVolumeMounts`                       | Optionally specify extra list of additional volumeMounts for mailReceiver container                                                           | `[]`          |

### Custom Certificates parameters

| Name                                                 | Description                                                                                             | Value                                    |
| ---------------------------------------------------- | ------------------------------------------------------------------------------------------------------- | ---------------------------------------- |
| `certificates.customCertificate.certificateSecret`   | Secret containing the certificate and key to add                                                        | `""`                                     |
| `certificates.customCertificate.certificateLocation` | Location in the container to store the certificate                                                      | `/etc/ssl/certs/ssl-cert-snakeoil.pem`   |
| `certificates.customCertificate.keyLocation`         | Location in the container to store the private key                                                      | `/etc/ssl/private/ssl-cert-snakeoil.key` |
| `certificates.customCertificate.chainLocation`       | Location in the container to store the certificate chain                                                | `/etc/ssl/certs/mychain.pem`             |
| `certificates.customCertificate.chainSecret.name`    | Name of the secret containing the certificate chain                                                     | `""`                                     |
| `certificates.customCertificate.chainSecret.key`     | Key of the certificate chain file inside the secret                                                     | `""`                                     |
| `certificates.customCA`                              | Defines a list of secrets to import into the container trust store                                      | `[]`                                     |
| `certificates.image.registry`                        | Redmine image registry                                                                                  | `REGISTRY_NAME`                          |
| `certificates.image.repository`                      | Redmine image repository                                                                                | `REPOSITORY_NAME/os-shell`               |
| `certificates.image.digest`                          | Redmine image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag | `""`                                     |
| `certificates.image.pullPolicy`                      | Redmine image pull policy                                                                               | `IfNotPresent`                           |
| `certificates.image.pullSecrets`                     | Redmine image pull secrets                                                                              | `[]`                                     |
| `certificates.extraEnvVars`                          | Container sidecar extra environment variables (e.g. proxy)                                              | `[]`                                     |

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

The above parameters map to the env variables defined in [bitnami/redmine](https://github.com/bitnami/containers/tree/main/bitnami/redmine). For more information please refer to the [bitnami/redmine](https://github.com/bitnami/containers/tree/main/bitnami/redmine) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
  --set redmineUsername=admin,redminePassword=password,mariadb.mariadb.auth.rootPassword=secretpassword \
    oci://REGISTRY_NAME/REPOSITORY_NAME/redmine
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The above command sets the Redmine administrator account username and password to `admin` and `password` respectively. Additionally, it sets the MariaDB `root` user password to `secretpassword`.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml oci://REGISTRY_NAME/REPOSITORY_NAME/redmine
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.
> **Tip**: You can use the default [values.yaml](https://github.com/bitnami/charts/tree/main/bitnami/redmine/values.yaml)

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 28.0.0

This major bump changes the following security defaults:

- `resourcesPreset` is changed from `none` to the minimum size working in our test suites (NOTE: `resourcesPreset` is not meant for production usage, but `resources` adapted to your use case).
- `global.compatibility.openshift.adaptSecurityContext` is changed from `disabled` to `auto`.
- The `networkPolicy` section has been normalized amongst all Bitnami charts. Compared to the previous approach, the values section has been simplified (check the Parameters section) and now it set to `enabled=true` by default. Egress traffic is allowed by default and ingress traffic is allowed by all pods but only to the ports set in `containerPorts` and `extraContainerPorts`.

This could potentially break any customization or init scripts used in your deployment. If this is the case, change the default values to the previous ones.

Also, this major release bumps the MariaDB chart version to [18.x.x](https://github.com/bitnami/charts/pull/24804); no major issues are expected during the upgrade.

### To 27.0.0

This major release bumps the PostgreSQL chart version to [14.x.x](https://github.com/bitnami/charts/pull/22750) and MariaDB to [16.x.x](https://github.com/bitnami/charts/pull/23054); no major issues are expected during the upgrade.

### To 26.0.0

This major release bumps the MariaDB version to 11.2. No major issues are expected during the upgrade.

### To 25.0.0

This major release bumps the MariaDB version to 11.1. No major issues are expected during the upgrade.

### To 24.0.0

This major updates the PostgreSQL subchart to its newest major, 13.0.0. [Here](https://github.com/bitnami/charts/tree/master/bitnami/postgresql#to-1300) you can find more information about the changes introduced in that version.

### To 23.0.0

This major release bumps the MariaDB version to 11.0. Follow the [upstream instructions](https://mariadb.com/kb/en/upgrading-from-mariadb-10-11-to-mariadb-11-0/) for upgrading from MariaDB 10.11 to 11.0. No major issues are expected during the upgrade.

### To 22.0.0

This major release bumps the MariaDB version to 10.11. Follow the [upstream instructions](https://mariadb.com/kb/en/upgrading-from-mariadb-10-6-to-mariadb-10-11/) for upgrading from MariaDB 10.6 to 10.11. No major issues are expected during the upgrade.

### To 21.0.0

This major updates the PostgreSQL subchart to its newest major, 12.0.0. [Here](https://github.com/bitnami/charts/tree/master/bitnami/postgresql#to-1200) you can find more information about the changes introduced in that version.

### To 20.0.0

The MariaDB subchart has been updated to the latest version (now it uses 10.6). No major issues are expected during the upgrade.

### To 18.0.0

This major release updates the PostgreSQL subchart to its newest major *11.x.x*, which contain several changes in the supported values (check the [upgrade notes](https://github.com/bitnami/charts/tree/master/bitnami/postgresql#to-1100) to obtain more information).

#### How to upgrade to version 18.0.0

To upgrade to *18.0.0* from *17.x* using PostgreSQL as database, it should be done reusing the PVC(s) used to hold the data on your previous release. To do so, follow the instructions below (the following example assumes that the release name is *redmine* and the release namespace *default*):

1. Obtain the credentials and the names of the PVCs used to hold the data on your current release:

```console
export REDMINE_PASSWORD=$(kubectl get secret --namespace default redmine -o jsonpath="{.data.redmine-password}" | base64 --decode)
export POSTGRESQL_PASSWORD=$(kubectl get secret --namespace default redmine-postgresql -o jsonpath="{.data.postgresql-password}" | base64 --decode)
export POSTGRESQL_PVC=$(kubectl get pvc -l app.kubernetes.io/instance=redmine,app.kubernetes.io/name=postgresql,role=primary -o jsonpath="{.items[0].metadata.name}")
```

1. Delete the PostgreSQL statefulset (notice the option *--cascade=false*) and secret:

```console
kubectl delete statefulsets.apps --cascade=false redmine-postgresql
kubectl delete secret redmine-postgresql --namespace default
```

1. Upgrade your release using the same PostgreSQL version:

```console
CURRENT_PG_VERSION=$(kubectl exec redmine-postgresql-0 -- bash -c 'echo $BITNAMI_IMAGE_VERSION')
helm upgrade redmine bitnami/redmine \
  --set databaseType=postgresql \
  --set redminePassword=$REDMINE_PASSWORD \
  --set postgresql.image.tag=$CURRENT_PG_VERSION \
  --set postgresql.auth.password=$POSTGRESQL_PASSWORD \
  --set postgresql.persistence.existingClaim=$POSTGRESQL_PVC
```

1. Delete the existing PostgreSQL pods and the new statefulset will create a new one:

```console
kubectl delete pod redmine-postgresql-0
```

### 17.0.0

In this version, the `image` block is defined once and is used in the different templates, while in the previous version, the `image` block was duplicated for the main container and the mail receiver one:

```yaml
image:
  registry: docker.io
  repository: bitnami/redmine
  tag: 4.2.2
```

VS

```yaml
image:
  registry: docker.io
  repository: bitnami/redmine
  tag: 4.2.2
---
mailReceiver:
  image:
    registry: docker.io
    repository: bitnami/redmine
    tag: 4.2.2
```

See [PR#7114](https://github.com/bitnami/charts/pull/7114) for more info about the implemented changes

### To 16.0.0

The [Bitnami Redmine](https://github.com/bitnami/containers/tree/main/bitnami/redmine) image was refactored and now the source code is published in GitHub in the `rootfs` folder of the container image repository.

#### Upgrading Instructions

To upgrade to *16.0.0* from *15.x*, it should be done enabling the "volumePermissions" init container. To do so, follow the instructions below (the following example assumes that the release name is *redmine* and the release namespace *default*):

1. Obtain the credentials on your current release:

```console
export REDMINE_PASSWORD=$(kubectl get secret --namespace default redmine -o jsonpath="{.data.redmine-password}" | base64 --decode)
export MARIADB_ROOT_PASSWORD=$(kubectl get secret --namespace default example-mariadb -o jsonpath="{.data.mariadb-root-password}" | base64 --decode)
export MARIADB_PASSWORD=$(kubectl get secret --namespace default example-mariadb -o jsonpath="{.data.mariadb-password}" | base64 --decode)
```

1. Upgrade your release:

```console
helm upgrade redmine bitnami/redmine \
  --set redminePassword=$REDMINE_PASSWORD \
  --set mariadb.auth.rootPassword=$MARIADB_ROOT_PASSWORD \
  --set mariadb.auth.password=$MARIADB_PASSWORD \
  --set volumePermissions.enabled=true
```

### To 15.0.0

[On November 13, 2020, Helm v2 support was formally finished](https://github.com/helm/charts#status-of-the-project), this major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

#### What changes were introduced in this major version?

- Previous versions of this Helm Chart use `apiVersion: v1` (installable by both Helm 2 and 3), this Helm Chart was updated to `apiVersion: v2` (installable by Helm 3 only). [Here](https://helm.sh/docs/topics/charts/#the-apiversion-field) you can find more information about the `apiVersion` field.
- Move dependency information from the *requirements.yaml* to the *Chart.yaml*
- After running *helm dependency update*, a *Chart.lock* file is generated containing the same structure used in the previous *requirements.lock*
- The different fields present in the *Chart.yaml* file has been ordered alphabetically in a homogeneous way for all the Bitnami Helm Chart.
- Additionally updates the MariaDB & PostgreSQL subcharts to their newest major *9.x.x* and *10.x.x*, respectively, which contain similar changes.

#### Considerations when upgrading to this version

- If you want to upgrade to this version using Helm v2, this scenario is not supported as this version does not support Helm v2 anymore.
- If you installed the previous version with Helm v2 and wants to upgrade to this version with Helm v3, please refer to the [official Helm documentation](https://helm.sh/docs/topics/v2_v3_migration/#migration-use-cases) about migrating from Helm v2 to v3.

#### Useful links

- [Bitnami Tutorial](https://docs.vmware.com/en/VMware-Tanzu-Application-Catalog/services/tutorials/GUID-resolve-helm2-helm3-post-migration-issues-index.html)
- [Helm docs](https://helm.sh/docs/topics/v2_v3_migration)
- [Helm Blog](https://helm.sh/blog/migrate-from-helm-v2-to-helm-v3)

#### How to upgrade to version 15.0.0

To upgrade to *15.0.0* from *14.x*, it should be done reusing the credentials on your previous release. To do so, follow the instructions below (the following example assumes that the release name is *redmine* and the release namespace *default*):

1. Obtain the credentials on your current release:

```console
export REDMINE_PASSWORD=$(kubectl get secret --namespace default redmine -o jsonpath="{.data.redmine-password}" | base64 --decode)
export MARIADB_ROOT_PASSWORD=$(kubectl get secret --namespace default example-mariadb -o jsonpath="{.data.mariadb-root-password}" | base64 --decode)
export MARIADB_PASSWORD=$(kubectl get secret --namespace default example-mariadb -o jsonpath="{.data.mariadb-password}" | base64 --decode)
```

1. Upgrade your release:

```console
helm upgrade redmine bitnami/redmine \
  --set redminePassword=$REDMINE_PASSWORD \
  --set mariadb.auth.rootPassword=$MARIADB_ROOT_PASSWORD \
  --set mariadb.auth.password=$MARIADB_PASSWORD
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