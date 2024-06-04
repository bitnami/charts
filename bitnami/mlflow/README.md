<!--- app-name: MLflow -->

# Bitnami package for MLflow

MLflow is an open-source platform designed to manage the end-to-end machine learning lifecycle. It allows you to track experiments, package code into reproducible runs, and share and deploy models.

[Overview of MLflow](https://mlflow.org/)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/mlflow
```

Looking to use MLflow in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the enterprise edition of Bitnami Application Catalog.

## Introduction

This chart bootstraps a [MLflow](https://github.com/bitnami/containers/tree/main/bitnami/mlflow) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Python is built for full integration into Python that enables you to use it with its libraries and main packages.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- PV provisioner support in the underlying infrastructure
- ReadWriteMany volumes for deployment scaling

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/mlflow
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The command deploys mlflow on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

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

### MLflow common Parameters

| Name                   | Description                                                                                                                                       | Value                    |
| ---------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `image.registry`       | mlflow image registry                                                                                                                             | `REGISTRY_NAME`          |
| `image.repository`     | mlflow image repository                                                                                                                           | `REPOSITORY_NAME/mlflow` |
| `image.digest`         | mlflow image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag image tag (immutable tags are recommended) | `""`                     |
| `image.pullPolicy`     | mlflow image pull policy                                                                                                                          | `IfNotPresent`           |
| `image.pullSecrets`    | mlflow image pull secrets                                                                                                                         | `[]`                     |
| `image.debug`          | Enable mlflow image debug mode                                                                                                                    | `false`                  |
| `gitImage.registry`    | Git image registry                                                                                                                                | `REGISTRY_NAME`          |
| `gitImage.repository`  | Git image repository                                                                                                                              | `REPOSITORY_NAME/git`    |
| `gitImage.digest`      | Git image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                               | `""`                     |
| `gitImage.pullPolicy`  | Git image pull policy                                                                                                                             | `IfNotPresent`           |
| `gitImage.pullSecrets` | Specify docker-registry secret names as an array                                                                                                  | `[]`                     |

### MLflow Tracking parameters

| Name                                                         | Description                                                                                                                                                                                                                         | Value            |
| ------------------------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| `tracking.enabled`                                           | Enable Tracking server                                                                                                                                                                                                              | `true`           |
| `tracking.replicaCount`                                      | Number of mlflow replicas to deploy                                                                                                                                                                                                 | `1`              |
| `tracking.containerPorts.http`                               | mlflow HTTP container port                                                                                                                                                                                                          | `5000`           |
| `tracking.livenessProbe.enabled`                             | Enable livenessProbe on mlflow containers                                                                                                                                                                                           | `true`           |
| `tracking.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                                             | `5`              |
| `tracking.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                                    | `10`             |
| `tracking.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                                   | `5`              |
| `tracking.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                                                 | `5`              |
| `tracking.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                                                 | `1`              |
| `tracking.readinessProbe.enabled`                            | Enable readinessProbe on mlflow containers                                                                                                                                                                                          | `true`           |
| `tracking.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                                            | `5`              |
| `tracking.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                                   | `10`             |
| `tracking.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                                  | `5`              |
| `tracking.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                                                | `5`              |
| `tracking.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                                                | `1`              |
| `tracking.startupProbe.enabled`                              | Enable startupProbe on mlflow containers                                                                                                                                                                                            | `false`          |
| `tracking.startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                                              | `5`              |
| `tracking.startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                                     | `10`             |
| `tracking.startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                                    | `5`              |
| `tracking.startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                                  | `5`              |
| `tracking.startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                                  | `1`              |
| `tracking.customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                                                                                                                                 | `{}`             |
| `tracking.customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                                                                                                                                                | `{}`             |
| `tracking.customStartupProbe`                                | Custom startupProbe that overrides the default one                                                                                                                                                                                  | `{}`             |
| `tracking.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if tracking.resources is set (tracking.resources is recommended for production). | `small`          |
| `tracking.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                   | `{}`             |
| `tracking.podSecurityContext.enabled`                        | Enabled mlflow pods' Security Context                                                                                                                                                                                               | `true`           |
| `tracking.podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                                  | `Always`         |
| `tracking.podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                                      | `[]`             |
| `tracking.podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                                         | `[]`             |
| `tracking.podSecurityContext.fsGroup`                        | Set mlflow pod's Security Context fsGroup                                                                                                                                                                                           | `1001`           |
| `tracking.containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                                                                                                                                                | `true`           |
| `tracking.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                                    | `{}`             |
| `tracking.containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                                                                                                                          | `1001`           |
| `tracking.containerSecurityContext.runAsGroup`               | Set containers' Security Context runAsGroup                                                                                                                                                                                         | `1001`           |
| `tracking.containerSecurityContext.privileged`               | Set containers' Security Context privileged                                                                                                                                                                                         | `false`          |
| `tracking.containerSecurityContext.runAsNonRoot`             | Set containers' Security Context runAsNonRoot                                                                                                                                                                                       | `true`           |
| `tracking.containerSecurityContext.readOnlyRootFilesystem`   | Set containers' Security Context runAsNonRoot                                                                                                                                                                                       | `true`           |
| `tracking.containerSecurityContext.allowPrivilegeEscalation` | Set container's privilege escalation                                                                                                                                                                                                | `false`          |
| `tracking.containerSecurityContext.capabilities.drop`        | Set container's Security Context runAsNonRoot                                                                                                                                                                                       | `["ALL"]`        |
| `tracking.containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                                    | `RuntimeDefault` |
| `tracking.auth.enabled`                                      | Enable basic authentication                                                                                                                                                                                                         | `true`           |
| `tracking.auth.username`                                     | Admin username                                                                                                                                                                                                                      | `user`           |
| `tracking.auth.password`                                     | Admin password                                                                                                                                                                                                                      | `""`             |
| `tracking.auth.existingSecret`                               | Name of a secret containing the admin password                                                                                                                                                                                      | `""`             |
| `tracking.auth.existingSecretUserKey`                        | Key inside the secret containing the admin password                                                                                                                                                                                 | `""`             |
| `tracking.auth.existingSecretPasswordKey`                    | Key inside the secret containing the admin password                                                                                                                                                                                 | `""`             |
| `tracking.auth.extraOverrides`                               | Add extra settings to the basic_auth.ini file                                                                                                                                                                                       | `{}`             |
| `tracking.auth.overridesConfigMap`                           | Name of a ConfigMap containing overrides to the basic_auth.ini file                                                                                                                                                                 | `""`             |
| `tracking.tls.enabled`                                       | Enable TLS traffic support                                                                                                                                                                                                          | `false`          |
| `tracking.tls.autoGenerated`                                 | Generate automatically self-signed TLS certificates                                                                                                                                                                                 | `false`          |
| `tracking.tls.certificatesSecret`                            | Name of an existing secret that contains the certificates                                                                                                                                                                           | `""`             |
| `tracking.tls.certFilename`                                  | Certificate filename                                                                                                                                                                                                                | `""`             |
| `tracking.tls.certKeyFilename`                               | Certificate key filename                                                                                                                                                                                                            | `""`             |
| `tracking.tls.certCAFilename`                                | CA Certificate filename                                                                                                                                                                                                             | `""`             |
| `tracking.command`                                           | Override default container command (useful when using custom images)                                                                                                                                                                | `[]`             |
| `tracking.args`                                              | Override default container args (useful when using custom images)                                                                                                                                                                   | `[]`             |
| `tracking.extraArgs`                                         | Add extra arguments together with the default ones                                                                                                                                                                                  | `[]`             |
| `tracking.runUpgradeDB`                                      | Add an init container to run mlflow db upgrade                                                                                                                                                                                      | `false`          |
| `tracking.automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                                  | `false`          |
| `tracking.hostAliases`                                       | mlflow pods host aliases                                                                                                                                                                                                            | `[]`             |
| `tracking.podLabels`                                         | Extra labels for mlflow pods                                                                                                                                                                                                        | `{}`             |
| `tracking.podAnnotations`                                    | Annotations for mlflow pods                                                                                                                                                                                                         | `{}`             |
| `tracking.podAffinityPreset`                                 | Pod affinity preset. Ignored if `.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                                | `""`             |
| `tracking.podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                           | `soft`           |
| `tracking.pdb.create`                                        | Enable/disable a Pod Disruption Budget creation                                                                                                                                                                                     | `false`          |
| `tracking.pdb.minAvailable`                                  | Minimum number/percentage of pods that should remain scheduled                                                                                                                                                                      | `""`             |
| `tracking.pdb.maxUnavailable`                                | Maximum number/percentage of pods that may be made unavailable                                                                                                                                                                      | `""`             |
| `tracking.autoscaling.hpa.enabled`                           | Enable HPA                                                                                                                                                                                                                          | `false`          |
| `tracking.autoscaling.hpa.minReplicas`                       | Minimum number of replicas                                                                                                                                                                                                          | `""`             |
| `tracking.autoscaling.hpa.maxReplicas`                       | Maximum number of replicas                                                                                                                                                                                                          | `""`             |
| `tracking.autoscaling.hpa.targetCPU`                         | Target CPU utilization percentage                                                                                                                                                                                                   | `""`             |
| `tracking.autoscaling.hpa.targetMemory`                      | Target Memory utilization percentage                                                                                                                                                                                                | `""`             |
| `tracking.autoscaling.vpa.enabled`                           | Enable VPA                                                                                                                                                                                                                          | `false`          |
| `tracking.autoscaling.vpa.annotations`                       | Annotations for VPA resource                                                                                                                                                                                                        | `{}`             |
| `tracking.autoscaling.vpa.controlledResources`               | VPA List of resources that the vertical pod autoscaler can control. Defaults to cpu and memory                                                                                                                                      | `[]`             |
| `tracking.autoscaling.vpa.maxAllowed`                        | VPA Max allowed resources for the pod                                                                                                                                                                                               | `{}`             |
| `tracking.autoscaling.vpa.minAllowed`                        | VPA Min allowed resources for the pod                                                                                                                                                                                               | `{}`             |
| `tracking.autoscaling.vpa.updatePolicy.updateMode`           | Autoscaling update policy Specifies whether recommended updates are applied when a Pod is started and whether recommended updates are applied during the life of a Pod                                                              | `Auto`           |
| `tracking.nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                          | `""`             |
| `tracking.nodeAffinityPreset.key`                            | Node label key to match. Ignored if `.affinity` is set                                                                                                                                                                              | `""`             |
| `tracking.nodeAffinityPreset.values`                         | Node label values to match. Ignored if `.affinity` is set                                                                                                                                                                           | `[]`             |
| `tracking.affinity`                                          | Affinity for mlflow pods assignment                                                                                                                                                                                                 | `{}`             |
| `tracking.nodeSelector`                                      | Node labels for mlflow pods assignment                                                                                                                                                                                              | `{}`             |
| `tracking.tolerations`                                       | Tolerations for mlflow pods assignment                                                                                                                                                                                              | `[]`             |
| `tracking.updateStrategy.type`                               | mlflow statefulset strategy type                                                                                                                                                                                                    | `RollingUpdate`  |
| `tracking.priorityClassName`                                 | mlflow pods' priorityClassName                                                                                                                                                                                                      | `""`             |
| `tracking.topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template                                                                                                            | `[]`             |
| `tracking.schedulerName`                                     | Name of the k8s scheduler (other than default) for mlflow pods                                                                                                                                                                      | `""`             |
| `tracking.terminationGracePeriodSeconds`                     | Seconds Redmine pod needs to terminate gracefully                                                                                                                                                                                   | `""`             |
| `tracking.lifecycleHooks`                                    | for the mlflow container(s) to automate configuration before or after startup                                                                                                                                                       | `{}`             |
| `tracking.extraEnvVars`                                      | Array with extra environment variables to add to mlflow nodes                                                                                                                                                                       | `[]`             |
| `tracking.extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for mlflow nodes                                                                                                                                                               | `""`             |
| `tracking.extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for mlflow nodes                                                                                                                                                                  | `""`             |
| `tracking.extraVolumes`                                      | Optionally specify extra list of additional volumes for the mlflow pod(s)                                                                                                                                                           | `[]`             |
| `tracking.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the mlflow container(s)                                                                                                                                                | `[]`             |
| `tracking.sidecars`                                          | Add additional sidecar containers to the mlflow pod(s)                                                                                                                                                                              | `[]`             |
| `tracking.enableDefaultInitContainers`                       | Add default init containers to the deployment                                                                                                                                                                                       | `true`           |
| `tracking.initContainers`                                    | Add additional init containers to the mlflow pod(s)                                                                                                                                                                                 | `[]`             |

### MLflow Tracking Traffic Exposure Parameters

| Name                                             | Description                                                                                                                      | Value                    |
| ------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `tracking.service.type`                          | mlflow service type                                                                                                              | `LoadBalancer`           |
| `tracking.service.ports.http`                    | mlflow service HTTP port                                                                                                         | `80`                     |
| `tracking.service.ports.https`                   | mlflow service HTTPS port                                                                                                        | `443`                    |
| `tracking.service.nodePorts.http`                | Node port for HTTP                                                                                                               | `""`                     |
| `tracking.service.nodePorts.https`               | Node port for HTTPS                                                                                                              | `""`                     |
| `tracking.service.clusterIP`                     | mlflow service Cluster IP                                                                                                        | `""`                     |
| `tracking.service.loadBalancerIP`                | mlflow service Load Balancer IP                                                                                                  | `""`                     |
| `tracking.service.loadBalancerSourceRanges`      | mlflow service Load Balancer sources                                                                                             | `[]`                     |
| `tracking.service.labels`                        | Add labels to the service object                                                                                                 | `{}`                     |
| `tracking.service.externalTrafficPolicy`         | mlflow service external traffic policy                                                                                           | `Cluster`                |
| `tracking.service.annotations`                   | Additional custom annotations for mlflow service                                                                                 | `{}`                     |
| `tracking.service.extraPorts`                    | Extra ports to expose in mlflow service (normally used with the `sidecars` value)                                                | `[]`                     |
| `tracking.service.sessionAffinity`               | Control where client requests go, to the same pod or round-robin                                                                 | `None`                   |
| `tracking.service.sessionAffinityConfig`         | Additional settings for the sessionAffinity                                                                                      | `{}`                     |
| `tracking.ingress.enabled`                       | Enable ingress record generation for mlflow                                                                                      | `false`                  |
| `tracking.ingress.pathType`                      | Ingress path type                                                                                                                | `ImplementationSpecific` |
| `tracking.ingress.hostname`                      | Default host for the ingress record                                                                                              | `mlflow.local`           |
| `tracking.ingress.ingressClassName`              | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                    | `""`                     |
| `tracking.ingress.path`                          | Default path for the ingress record                                                                                              | `/`                      |
| `tracking.ingress.annotations`                   | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                     |
| `tracking.ingress.tls`                           | Enable TLS configuration for the host defined at `ingress.hostname` parameter                                                    | `false`                  |
| `tracking.ingress.selfSigned`                    | Create a TLS secret for this ingress record using self-signed certificates generated by Helm                                     | `false`                  |
| `tracking.ingress.extraHosts`                    | An array with additional hostname(s) to be covered with the ingress record                                                       | `[]`                     |
| `tracking.ingress.extraPaths`                    | An array with additional arbitrary paths that may need to be added to the ingress under the main host                            | `[]`                     |
| `tracking.ingress.extraTls`                      | TLS configuration for additional hostname(s) to be covered with this ingress record                                              | `[]`                     |
| `tracking.ingress.secrets`                       | Custom TLS certificates as secrets                                                                                               | `[]`                     |
| `tracking.ingress.extraRules`                    | Additional rules to be covered with this ingress record                                                                          | `[]`                     |
| `tracking.networkPolicy.enabled`                 | Enable creation of NetworkPolicy resources                                                                                       | `true`                   |
| `tracking.networkPolicy.allowExternal`           | The Policy model to apply                                                                                                        | `true`                   |
| `tracking.networkPolicy.allowExternalEgress`     | Allow the pod to access any range of port and all destinations.                                                                  | `true`                   |
| `tracking.networkPolicy.extraIngress`            | Add extra ingress rules to the NetworkPolicy                                                                                     | `[]`                     |
| `tracking.networkPolicy.extraEgress`             | Add extra ingress rules to the NetworkPolicy                                                                                     | `[]`                     |
| `tracking.networkPolicy.ingressNSMatchLabels`    | Labels to match to allow traffic from other namespaces                                                                           | `{}`                     |
| `tracking.networkPolicy.ingressNSPodMatchLabels` | Pod labels to match to allow traffic from other namespaces                                                                       | `{}`                     |

### MLflow Tracking Persistence Parameters

| Name                                 | Description                                                                                             | Value               |
| ------------------------------------ | ------------------------------------------------------------------------------------------------------- | ------------------- |
| `tracking.persistence.enabled`       | Enable persistence using Persistent Volume Claims                                                       | `true`              |
| `tracking.persistence.mountPath`     | Path to mount the volume at.                                                                            | `/bitnami/mlflow`   |
| `tracking.persistence.subPath`       | The subdirectory of the volume to mount to, useful in dev environments and one PV for multiple services | `""`                |
| `tracking.persistence.storageClass`  | Storage class of backing PVC                                                                            | `""`                |
| `tracking.persistence.labels`        | Persistent Volume labels                                                                                | `{}`                |
| `tracking.persistence.annotations`   | Persistent Volume Claim annotations                                                                     | `{}`                |
| `tracking.persistence.accessModes`   | Persistent Volume Access Modes                                                                          | `["ReadWriteOnce"]` |
| `tracking.persistence.size`          | Size of data volume                                                                                     | `8Gi`               |
| `tracking.persistence.existingClaim` | The name of an existing PVC to use for persistence                                                      | `""`                |
| `tracking.persistence.selector`      | Selector to match an existing Persistent Volume for MLflow data PVC                                     | `{}`                |
| `tracking.persistence.dataSource`    | Custom PVC data source                                                                                  | `{}`                |

### MLflow Tracking Other Parameters

| Name                                                   | Description                                                      | Value   |
| ------------------------------------------------------ | ---------------------------------------------------------------- | ------- |
| `tracking.serviceAccount.create`                       | Specifies whether a ServiceAccount should be created             | `true`  |
| `tracking.serviceAccount.name`                         | The name of the ServiceAccount to use.                           | `""`    |
| `tracking.serviceAccount.annotations`                  | Additional Service Account annotations (evaluated as a template) | `{}`    |
| `tracking.serviceAccount.automountServiceAccountToken` | Automount service account token for the server service account   | `false` |

### MLflow Tracking Metrics Parameters

| Name                                                | Description                                                                                            | Value   |
| --------------------------------------------------- | ------------------------------------------------------------------------------------------------------ | ------- |
| `tracking.metrics.enabled`                          | Enable the export of Prometheus metrics                                                                | `false` |
| `tracking.metrics.annotations`                      | Annotations for the tracking service in order to scrape metrics                                        | `{}`    |
| `tracking.metrics.serviceMonitor.enabled`           | if `true`, creates a Prometheus Operator ServiceMonitor (also requires `metrics.enabled` to be `true`) | `false` |
| `tracking.metrics.serviceMonitor.namespace`         | Namespace in which Prometheus is running                                                               | `""`    |
| `tracking.metrics.serviceMonitor.annotations`       | Additional custom annotations for the ServiceMonitor                                                   | `{}`    |
| `tracking.metrics.serviceMonitor.labels`            | Extra labels for the ServiceMonitor                                                                    | `{}`    |
| `tracking.metrics.serviceMonitor.jobLabel`          | The name of the label on the target service to use as the job name in Prometheus                       | `""`    |
| `tracking.metrics.serviceMonitor.honorLabels`       | honorLabels chooses the metric's labels on collisions with target labels                               | `false` |
| `tracking.metrics.serviceMonitor.interval`          | Interval at which metrics should be scraped.                                                           | `""`    |
| `tracking.metrics.serviceMonitor.scrapeTimeout`     | Timeout after which the scrape is ended                                                                | `""`    |
| `tracking.metrics.serviceMonitor.metricRelabelings` | Specify additional relabeling of metrics                                                               | `[]`    |
| `tracking.metrics.serviceMonitor.relabelings`       | Specify general relabeling                                                                             | `[]`    |
| `tracking.metrics.serviceMonitor.selector`          | Prometheus instance selector labels                                                                    | `{}`    |

### MLflow Run Parameters

| Name                                                    | Description                                                                                                                                                                                                               | Value            |
| ------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| `run.enabled`                                           | Enable Run deployment                                                                                                                                                                                                     | `true`           |
| `run.useJob`                                            | Deploy as job                                                                                                                                                                                                             | `false`          |
| `run.backoffLimit`                                      | set backoff limit of the job                                                                                                                                                                                              | `10`             |
| `run.restartPolicy`                                     | set restart policy of the job                                                                                                                                                                                             | `OnFailure`      |
| `run.extraEnvVars`                                      | Array with extra environment variables to add to run nodes                                                                                                                                                                | `[]`             |
| `run.extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for run nodes                                                                                                                                                        | `""`             |
| `run.extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for run nodes                                                                                                                                                           | `""`             |
| `run.annotations`                                       | Annotations for the run deployment                                                                                                                                                                                        | `{}`             |
| `run.command`                                           | Override default container command (useful when using custom images)                                                                                                                                                      | `[]`             |
| `run.args`                                              | Override default container args (useful when using custom images)                                                                                                                                                         | `[]`             |
| `run.terminationGracePeriodSeconds`                     | Run termination grace period (in seconds)                                                                                                                                                                                 | `""`             |
| `run.customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                                                                                                                       | `{}`             |
| `run.customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                                                                                                                                      | `{}`             |
| `run.customStartupProbe`                                | Custom startupProbe that overrides the default one                                                                                                                                                                        | `{}`             |
| `run.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if run.resources is set (run.resources is recommended for production). | `small`          |
| `run.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                         | `{}`             |
| `run.podSecurityContext.enabled`                        | Enabled Run pods' Security Context                                                                                                                                                                                        | `true`           |
| `run.podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                        | `Always`         |
| `run.podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                            | `[]`             |
| `run.podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                               | `[]`             |
| `run.podSecurityContext.fsGroup`                        | Set Run pod's Security Context fsGroup                                                                                                                                                                                    | `1001`           |
| `run.containerSecurityContext.enabled`                  | Enabled Run containers' Security Context                                                                                                                                                                                  | `true`           |
| `run.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                          | `{}`             |
| `run.containerSecurityContext.runAsUser`                | Set Run containers' Security Context runAsUser                                                                                                                                                                            | `1001`           |
| `run.containerSecurityContext.runAsGroup`               | Set Run containers' Security Context runAsGroup                                                                                                                                                                           | `1001`           |
| `run.containerSecurityContext.runAsNonRoot`             | Set Run containers' Security Context runAsNonRoot                                                                                                                                                                         | `true`           |
| `run.containerSecurityContext.privileged`               | Set Run containers' Security Context privileged                                                                                                                                                                           | `false`          |
| `run.containerSecurityContext.readOnlyRootFilesystem`   | Set Run containers' Security Context runAsNonRoot                                                                                                                                                                         | `true`           |
| `run.containerSecurityContext.allowPrivilegeEscalation` | Set Run container's privilege escalation                                                                                                                                                                                  | `false`          |
| `run.containerSecurityContext.capabilities.drop`        | Set Run container's Security Context runAsNonRoot                                                                                                                                                                         | `["ALL"]`        |
| `run.containerSecurityContext.seccompProfile.type`      | Set Run container's Security Context seccomp profile                                                                                                                                                                      | `RuntimeDefault` |
| `run.lifecycleHooks`                                    | for the run container(s) to automate configuration before or after startup                                                                                                                                                | `{}`             |
| `run.runtimeClassName`                                  | Name of the runtime class to be used by pod(s)                                                                                                                                                                            | `""`             |
| `run.automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                        | `false`          |
| `run.hostAliases`                                       | run pods host aliases                                                                                                                                                                                                     | `[]`             |
| `run.labels`                                            | Extra labels for the run deployment                                                                                                                                                                                       | `{}`             |
| `run.podLabels`                                         | Extra labels for run pods                                                                                                                                                                                                 | `{}`             |
| `run.podAnnotations`                                    | Annotations for run pods                                                                                                                                                                                                  | `{}`             |
| `run.podAffinityPreset`                                 | Pod affinity preset. Ignored if `run.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                   | `""`             |
| `run.podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `run.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                              | `soft`           |
| `run.nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `run.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                             | `""`             |
| `run.nodeAffinityPreset.key`                            | Node label key to match. Ignored if `run.affinity` is set                                                                                                                                                                 | `""`             |
| `run.nodeAffinityPreset.values`                         | Node label values to match. Ignored if `run.affinity` is set                                                                                                                                                              | `[]`             |
| `run.affinity`                                          | Affinity for Run pods assignment                                                                                                                                                                                          | `{}`             |
| `run.nodeSelector`                                      | Node labels for Run pods assignment                                                                                                                                                                                       | `{}`             |
| `run.tolerations`                                       | Tolerations for Run pods assignment                                                                                                                                                                                       | `[]`             |
| `run.topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains                                                                                                                           | `[]`             |
| `run.priorityClassName`                                 | Run pods' priorityClassName                                                                                                                                                                                               | `""`             |
| `run.schedulerName`                                     | Kubernetes pod scheduler registry                                                                                                                                                                                         | `""`             |
| `run.updateStrategy.type`                               | Run statefulset strategy type                                                                                                                                                                                             | `RollingUpdate`  |
| `run.updateStrategy.rollingUpdate`                      | Run statefulset rolling update configuration parameters                                                                                                                                                                   | `{}`             |
| `run.extraVolumes`                                      | Optionally specify extra list of additional volumes for the Run pod(s)                                                                                                                                                    | `[]`             |
| `run.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the Run container(s)                                                                                                                                         | `[]`             |
| `run.sidecars`                                          | Add additional sidecar containers to the Run pod(s)                                                                                                                                                                       | `[]`             |
| `run.enableDefaultInitContainers`                       | Deploy default init containers                                                                                                                                                                                            | `true`           |
| `run.initContainers`                                    | Add additional init containers to the Run pod(s)                                                                                                                                                                          | `[]`             |
| `run.networkPolicy.enabled`                             | Enable creation of NetworkPolicy resources                                                                                                                                                                                | `true`           |
| `run.networkPolicy.allowExternal`                       | The Policy model to apply                                                                                                                                                                                                 | `true`           |
| `run.networkPolicy.allowExternalEgress`                 | Allow the pod to access any range of port and all destinations.                                                                                                                                                           | `true`           |
| `run.networkPolicy.extraIngress`                        | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                              | `[]`             |
| `run.networkPolicy.extraEgress`                         | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                              | `[]`             |
| `run.networkPolicy.ingressNSMatchLabels`                | Labels to match to allow traffic from other namespaces                                                                                                                                                                    | `{}`             |
| `run.networkPolicy.ingressNSPodMatchLabels`             | Pod labels to match to allow traffic from other namespaces                                                                                                                                                                | `{}`             |
| `run.source.type`                                       | Where the source comes from: Possible values: configmap, git, custom                                                                                                                                                      | `configmap`      |
| `run.source.launchCommand`                              | deepspeed command to run over the project                                                                                                                                                                                 | `""`             |
| `run.source.configMap`                                  | List of files of the project                                                                                                                                                                                              | `{}`             |
| `run.source.existingConfigMap`                          | Name of a configmap containing the files of the project                                                                                                                                                                   | `""`             |
| `run.source.git.repository`                             | Repository that holds the files                                                                                                                                                                                           | `""`             |
| `run.source.git.revision`                               | Revision from the repository to checkout                                                                                                                                                                                  | `""`             |
| `run.source.git.extraVolumeMounts`                      | Add extra volume mounts for the Git container                                                                                                                                                                             | `[]`             |
| `run.serviceAccount.create`                             | Enable creation of ServiceAccount for Run pods                                                                                                                                                                            | `true`           |
| `run.serviceAccount.name`                               | The name of the ServiceAccount to use                                                                                                                                                                                     | `""`             |
| `run.serviceAccount.automountServiceAccountToken`       | Allows auto mount of ServiceAccountToken on the serviceAccount created                                                                                                                                                    | `false`          |
| `run.serviceAccount.annotations`                        | Additional custom annotations for the ServiceAccount                                                                                                                                                                      | `{}`             |

### Mlflow Run persistence paramaters

| Name                            | Description                                                          | Value                  |
| ------------------------------- | -------------------------------------------------------------------- | ---------------------- |
| `run.persistence.enabled`       | Use a PVC to persist data                                            | `false`                |
| `run.persistence.storageClass`  | discourse & sidekiq data Persistent Volume Storage Class             | `""`                   |
| `run.persistence.existingClaim` | Use a existing PVC which must be created manually before bound       | `""`                   |
| `run.persistence.mountPath`     | Path to mount the volume at                                          | `/bitnami/mlflow/data` |
| `run.persistence.subPath`       | subPath to use for mounting the volume                               | `""`                   |
| `run.persistence.accessModes`   | Persistent Volume Access Mode                                        | `["ReadWriteOnce"]`    |
| `run.persistence.dataSource`    | Custom PVC data source                                               | `{}`                   |
| `run.persistence.selector`      | Selector to match an existing Persistent Volume for the run data PVC | `{}`                   |
| `run.persistence.size`          | Size of data volume                                                  | `8Gi`                  |
| `run.persistence.labels`        | Persistent Volume labels                                             | `{}`                   |
| `run.persistence.annotations`   | Persistent Volume annotations                                        | `{}`                   |

### Init Container Parameters

| Name                                                              | Description                                                                                                                                                                                                                                           | Value                      |
| ----------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------- |
| `volumePermissions.enabled`                                       | Enable init container that changes the owner/group of the PV mount point to `runAsUser:fsGroup`                                                                                                                                                       | `false`                    |
| `volumePermissions.image.registry`                                | OS Shell + Utility image registry                                                                                                                                                                                                                     | `REGISTRY_NAME`            |
| `volumePermissions.image.repository`                              | OS Shell + Utility image repository                                                                                                                                                                                                                   | `REPOSITORY_NAME/os-shell` |
| `volumePermissions.image.pullPolicy`                              | OS Shell + Utility image pull policy                                                                                                                                                                                                                  | `IfNotPresent`             |
| `volumePermissions.image.pullSecrets`                             | OS Shell + Utility image pull secrets                                                                                                                                                                                                                 | `[]`                       |
| `volumePermissions.resourcesPreset`                               | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if volumePermissions.resources is set (volumePermissions.resources is recommended for production). | `nano`                     |
| `volumePermissions.resources`                                     | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                                     | `{}`                       |
| `volumePermissions.containerSecurityContext.enabled`              | Set container security context settings                                                                                                                                                                                                               | `true`                     |
| `volumePermissions.containerSecurityContext.seLinuxOptions`       | Set SELinux options in container                                                                                                                                                                                                                      | `{}`                       |
| `volumePermissions.containerSecurityContext.runAsUser`            | Set init container's Security Context runAsUser                                                                                                                                                                                                       | `0`                        |
| `waitContainer.image.registry`                                    | Init container wait-container image registry                                                                                                                                                                                                          | `REGISTRY_NAME`            |
| `waitContainer.image.repository`                                  | Init container wait-container image name                                                                                                                                                                                                              | `REPOSITORY_NAME/os-shell` |
| `waitContainer.image.digest`                                      | Init container wait-container image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                         | `""`                       |
| `waitContainer.image.pullPolicy`                                  | Init container wait-container image pull policy                                                                                                                                                                                                       | `IfNotPresent`             |
| `waitContainer.image.pullSecrets`                                 | Specify docker-registry secret names as an array                                                                                                                                                                                                      | `[]`                       |
| `waitContainer.containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                                                                                                                                                                  | `true`                     |
| `waitContainer.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                                                      | `{}`                       |
| `waitContainer.containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                                                                                                                                            | `1001`                     |
| `waitContainer.containerSecurityContext.runAsGroup`               | Set containers' Security Context runAsGroup                                                                                                                                                                                                           | `1001`                     |
| `waitContainer.containerSecurityContext.runAsNonRoot`             | Set containers' Security Context runAsNonRoot                                                                                                                                                                                                         | `true`                     |
| `waitContainer.containerSecurityContext.privileged`               | Set containers' Security Context privileged                                                                                                                                                                                                           | `false`                    |
| `waitContainer.containerSecurityContext.readOnlyRootFilesystem`   | Set containers' Security Context runAsNonRoot                                                                                                                                                                                                         | `true`                     |
| `waitContainer.containerSecurityContext.allowPrivilegeEscalation` | Set container's privilege escalation                                                                                                                                                                                                                  | `false`                    |
| `waitContainer.containerSecurityContext.capabilities.drop`        | Set container's Security Context runAsNonRoot                                                                                                                                                                                                         | `["ALL"]`                  |
| `waitContainer.containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                                                      | `RuntimeDefault`           |

### PostgreSQL chart configuration

| Name                                          | Description                                               | Value            |
| --------------------------------------------- | --------------------------------------------------------- | ---------------- |
| `postgresql.enabled`                          | Switch to enable or disable the PostgreSQL helm chart     | `true`           |
| `postgresql.auth.username`                    | Name for a custom user to create                          | `bn_mlflow`      |
| `postgresql.auth.password`                    | Password for the custom user to create                    | `""`             |
| `postgresql.auth.database`                    | Name for a custom database to create                      | `bitnami_mlflow` |
| `postgresql.auth.existingSecret`              | Name of existing secret to use for PostgreSQL credentials | `""`             |
| `postgresql.architecture`                     | PostgreSQL architecture (`standalone` or `replication`)   | `standalone`     |
| `postgresql.primary.service.ports.postgresql` | PostgreSQL service port                                   | `5432`           |
| `postgresql.primary.initdb.scripts`           | Map with init scripts for the PostgreSQL database         | `{}`             |

### External PostgreSQL configuration

| Name                                         | Description                                                             | Value         |
| -------------------------------------------- | ----------------------------------------------------------------------- | ------------- |
| `externalDatabase.dialectDriver`             | Database Dialect(+Driver)                                               | `postgresql`  |
| `externalDatabase.host`                      | Database host                                                           | `""`          |
| `externalDatabase.port`                      | Database port number                                                    | `5432`        |
| `externalDatabase.user`                      | Non-root username                                                       | `postgres`    |
| `externalDatabase.password`                  | Password for the non-root username                                      | `""`          |
| `externalDatabase.database`                  | Database name                                                           | `mlflow`      |
| `externalDatabase.authDatabase`              | Database name for the auth module (only if tracking.auth.enabled=true)  | `mlflow_auth` |
| `externalDatabase.existingSecret`            | Name of an existing secret resource containing the database credentials | `""`          |
| `externalDatabase.existingSecretPasswordKey` | Name of an existing secret key containing the database credentials      | `db-password` |

### MinIO&reg; chart parameters

| Name                               | Description                                                                                                                       | Value                                               |
| ---------------------------------- | --------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------- |
| `minio`                            | For full list of MinIO&reg; values configurations please refere [here](https://github.com/bitnami/charts/tree/main/bitnami/minio) |                                                     |
| `minio.enabled`                    | Enable/disable MinIO&reg; chart installation                                                                                      | `true`                                              |
| `minio.auth.rootUser`              | MinIO&reg; root username                                                                                                          | `admin`                                             |
| `minio.auth.rootPassword`          | Password for MinIO&reg; root user                                                                                                 | `""`                                                |
| `minio.auth.existingSecret`        | Name of an existing secret containing the MinIO&reg; credentials                                                                  | `""`                                                |
| `minio.defaultBuckets`             | Comma, semi-colon or space separated list of MinIO&reg; buckets to create                                                         | `mlflow`                                            |
| `minio.provisioning.enabled`       | Enable/disable MinIO&reg; provisioning job                                                                                        | `true`                                              |
| `minio.provisioning.extraCommands` | Extra commands to run on MinIO&reg; provisioning job                                                                              | `["mc anonymous set download provisioning/mlflow"]` |
| `minio.tls.enabled`                | Enable/disable MinIO&reg; TLS support                                                                                             | `false`                                             |
| `minio.service.type`               | MinIO&reg; service type                                                                                                           | `ClusterIP`                                         |
| `minio.service.loadBalancerIP`     | MinIO&reg; service LoadBalancer IP                                                                                                | `""`                                                |
| `minio.service.ports.api`          | MinIO&reg; service port                                                                                                           | `80`                                                |

### External S3 parameters

| Name                                      | Description                                                        | Value           |
| ----------------------------------------- | ------------------------------------------------------------------ | --------------- |
| `externalS3.host`                         | External S3 host                                                   | `""`            |
| `externalS3.port`                         | External S3 port number                                            | `443`           |
| `externalS3.useCredentialsInSecret`       | Whether to use a secret to store the S3 credentials                | `true`          |
| `externalS3.accessKeyID`                  | External S3 access key ID                                          | `""`            |
| `externalS3.accessKeySecret`              | External S3 access key secret                                      | `""`            |
| `externalS3.existingSecret`               | Name of an existing secret resource containing the S3 credentials  | `""`            |
| `externalS3.existingSecretAccessKeyIDKey` | Name of an existing secret key containing the S3 access key ID     | `root-user`     |
| `externalS3.existingSecretKeySecretKey`   | Name of an existing secret key containing the S3 access key secret | `root-password` |
| `externalS3.protocol`                     | External S3 protocol                                               | `https`         |
| `externalS3.bucket`                       | External S3 bucket                                                 | `mlflow`        |
| `externalS3.serveArtifacts`               | Whether artifact serving is enabled                                | `true`          |

The MLflow chart supports three different ways to load your files in the `run` deployment. In order of priority, they are:

1. Existing config map
2. Add files in the values.yaml
3. Cloning a git repository

This means that if you specify a config map with your files, it won't check the files defined in `values.yaml` directory nor the git repository.

In order to use an existing config map, set the `run.source.existingConfigMap=my-config-map` parameter.

To add your files in the values.yaml file, set the `run.source.configmap` object with the files.

Finally, if you want to clone a git repository you can use those parameters:

```console
run.source.type=git
run.source.git.repository=https://github.com/my-user/my-project
run.source.git.revision=master
```

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 1.0.0

This major bump changes the following security defaults:

- `resourcesPreset` is changed from `none` to the minimum size working in our test suites (NOTE: `resourcesPreset` is not meant for production usage, but `resources` adapted to your use case).
- `global.compatibility.openshift.adaptSecurityContext` is changed from `disabled` to `auto`.

This could potentially break any customization or init scripts used in your deployment. If this is the case, change the default values to the previous ones.

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