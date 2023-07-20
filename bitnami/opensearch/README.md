<!--- app-name: Opensearch -->

# Bitnami Opensearch Stack

Opensearch is a distributed search and analytics engine. It is used for web search, log monitoring, and real-time analytics. Ideal for Big Data applications.

[Overview of Opensearch](https://www.open.co/products/opensearch)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/opensearch
```

## Introduction

This chart bootstraps a [Opensearch](https://github.com/bitnami/containers/tree/main/bitnami/opensearch) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

Looking to use Opensearch in production? Try [VMware Application Catalog](https://bitnami.com/enterprise), the enterprise edition of Bitnami Application Catalog.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/opensearch
```

These commands deploy Opensearch on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` release:

```console
helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release. Remove also the chart using `--purge` option:

```console
helm delete --purge my-release
```

## Parameters

### Global parameters

| Name                      | Description                                     | Value |
| ------------------------- | ----------------------------------------------- | ----- |
| `global.imageRegistry`    | Global Docker image registry                    | `""`  |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]`  |
| `global.storageClass`     | Global StorageClass for Persistent Volume(s)    | `""`  |

### Common parameters

| Name                     | Description                                                                             | Value           |
| ------------------------ | --------------------------------------------------------------------------------------- | --------------- |
| `kubeVersion`            | Override Kubernetes version                                                             | `""`            |
| `nameOverride`           | String to partially override common.names.fullname                                      | `""`            |
| `fullnameOverride`       | String to fully override common.names.fullname                                          | `""`            |
| `commonLabels`           | Labels to add to all deployed objects                                                   | `{}`            |
| `commonAnnotations`      | Annotations to add to all deployed objects                                              | `{}`            |
| `clusterDomain`          | Kubernetes cluster domain name                                                          | `cluster.local` |
| `extraDeploy`            | Array of extra objects to deploy with the release                                       | `[]`            |
| `namespaceOverride`      | String to fully override common.names.namespace                                         | `""`            |
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden) | `false`         |
| `diagnosticMode.command` | Command to override all containers in the deployment                                    | `["sleep"]`     |
| `diagnosticMode.args`    | Args to override all containers in the deployment                                       | `["infinity"]`  |

### Opensearch cluster Parameters

| Name                        | Description                                                                                                                                         | Value                |
| --------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------- |
| `clusterName`               | Opensearch cluster name                                                                                                                             | `open`               |
| `containerPorts.restAPI`    | Opensearch REST API port                                                                                                                            | `9200`               |
| `containerPorts.transport`  | Opensearch Transport port                                                                                                                           | `9300`               |
| `plugins`                   | Comma, semi-colon or space separated list of plugins to install at initialization                                                                   | `""`                 |
| `snapshotRepoPath`          | File System snapshot repository path                                                                                                                | `""`                 |
| `config`                    | Override opensearch configuration                                                                                                                   | `{}`                 |
| `extraConfig`               | Append extra configuration to the opensearch node configuration                                                                                     | `{}`                 |
| `extraHosts`                | A list of external hosts which are part of this cluster                                                                                             | `[]`                 |
| `extraVolumes`              | A list of volumes to be added to the pod                                                                                                            | `[]`                 |
| `extraVolumeMounts`         | A list of volume mounts to be added to the pod                                                                                                      | `[]`                 |
| `initScripts`               | Dictionary of init scripts. Evaluated as a template.                                                                                                | `{}`                 |
| `initScriptsCM`             | ConfigMap with the init scripts. Evaluated as a template.                                                                                           | `""`                 |
| `initScriptsSecret`         | Secret containing `/docker-entrypoint-initdb.d` scripts to be executed at initialization time that contain sensitive data. Evaluated as a template. | `""`                 |
| `extraEnvVars`              | Array containing extra env vars to be added to all pods (evaluated as a template)                                                                   | `[]`                 |
| `extraEnvVarsCM`            | ConfigMap containing extra env vars to be added to all pods (evaluated as a template)                                                               | `""`                 |
| `extraEnvVarsSecret`        | Secret containing extra env vars to be added to all pods (evaluated as a template)                                                                  | `""`                 |
| `sidecars`                  | Add additional sidecar containers to the all opensearch node pod(s)                                                                                 | `[]`                 |
| `initContainers`            | Add additional init containers to the all opensearch node pod(s)                                                                                    | `[]`                 |
| `useIstioLabels`            | Use this variable to add Istio labels to all pods                                                                                                   | `true`               |
| `image.registry`            | Opensearch image registry                                                                                                                           | `docker.io`          |
| `image.repository`          | Opensearch image repository                                                                                                                         | `bitnami/opensearch` |
| `image.tag`                 | Opensearch image tag (immutable tags are recommended)                                                                                               | `2.8.0-debian-11-r0` |
| `image.digest`              | Opensearch image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                          | `""`                 |
| `image.pullPolicy`          | Opensearch image pull policy                                                                                                                        | `IfNotPresent`       |
| `image.pullSecrets`         | Opensearch image pull secrets                                                                                                                       | `[]`                 |
| `image.debug`               | Enable Opensearch image debug mode                                                                                                                  | `false`              |
| `security.enabled`          | Enable X-Pack Security settings                                                                                                                     | `false`              |
| `security.adminPassword`    | Password for 'admin' user                                                                                                                           | `""`                 |
| `security.logstashPassword` | Password for Logstash                                                                                                                               | `""`                 |
| `security.existingSecret`   | Name of the existing secret containing the Opensearch password and                                                                                  | `""`                 |
| `security.fipsMode`         | Configure opensearch with FIPS 140 compliant mode                                                                                                   | `false`              |

### Opensearch admin parameters

| Name                                       | Description                                                                                             | Value                       |
| ------------------------------------------ | ------------------------------------------------------------------------------------------------------- | --------------------------- |
| `security.tls.admin.existingSecret`        | Existing secret containing the certificates for admin                                                   | `""`                        |
| `security.tls.restEncryption`              | Enable SSL/TLS encryption for Opensearch REST API.                                                      | `false`                     |
| `security.tls.autoGenerated`               | Create self-signed TLS certificates.                                                                    | `true`                      |
| `security.tls.verificationMode`            | Verification mode for SSL communications.                                                               | `full`                      |
| `security.tls.master.existingSecret`       | Existing secret containing the certificates for the master nodes                                        | `""`                        |
| `security.tls.data.existingSecret`         | Existing secret containing the certificates for the data nodes                                          | `""`                        |
| `security.tls.ingest.existingSecret`       | Existing secret containing the certificates for the ingest nodes                                        | `""`                        |
| `security.tls.coordinating.existingSecret` | Existing secret containing the certificates for the coordinating nodes                                  | `""`                        |
| `security.tls.keystoreFilename`            | Name of the keystore file                                                                               | `opensearch.keystore.jks`   |
| `security.tls.truststoreFilename`          | Name of the truststore                                                                                  | `opensearch.truststore.jks` |
| `security.tls.usePemCerts`                 | Use this variable if your secrets contain PEM certificates instead of JKS/PKCS12                        | `false`                     |
| `security.tls.passwordsSecret`             | Existing secret containing the Keystore and Truststore passwords, or key password if PEM certs are used | `""`                        |
| `security.tls.keystorePassword`            | Password to access the JKS/PKCS12 keystore or PEM key when they are password-protected.                 | `""`                        |
| `security.tls.truststorePassword`          | Password to access the JKS/PKCS12 truststore when they are password-protected.                          | `""`                        |
| `security.tls.keyPassword`                 | Password to access the PEM key when they are password-protected.                                        | `""`                        |
| `security.tls.secretKeystoreKey`           | Name of the secret key containing the Keystore password                                                 | `""`                        |
| `security.tls.secretTruststoreKey`         | Name of the secret key containing the Truststore password                                               | `""`                        |
| `security.tls.secretKey`                   | Name of the secret key containing the PEM key password                                                  | `""`                        |
| `security.tls.nodesDN`                     | A comma separated list of DN for nodes                                                                  | `""`                        |
| `security.tls.adminDN`                     | A comma separated list of DN for admins                                                                 | `""`                        |

### Traffic Exposure Parameters

| Name                               | Description                                                                                                                      | Value                    |
| ---------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `service.type`                     | Opensearch service type                                                                                                          | `ClusterIP`              |
| `service.ports.restAPI`            | Opensearch service REST API port                                                                                                 | `9200`                   |
| `service.ports.transport`          | Opensearch service transport port                                                                                                | `9300`                   |
| `service.nodePorts.restAPI`        | Node port for REST API                                                                                                           | `""`                     |
| `service.nodePorts.transport`      | Node port for REST API                                                                                                           | `""`                     |
| `service.clusterIP`                | Opensearch service Cluster IP                                                                                                    | `""`                     |
| `service.loadBalancerIP`           | Opensearch service Load Balancer IP                                                                                              | `""`                     |
| `service.loadBalancerSourceRanges` | Opensearch service Load Balancer sources                                                                                         | `[]`                     |
| `service.externalTrafficPolicy`    | Opensearch service external traffic policy                                                                                       | `Cluster`                |
| `service.annotations`              | Additional custom annotations for Opensearch service                                                                             | `{}`                     |
| `service.extraPorts`               | Extra ports to expose in Opensearch service (normally used with the `sidecars` value)                                            | `[]`                     |
| `service.sessionAffinity`          | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                                                             | `None`                   |
| `service.sessionAffinityConfig`    | Additional settings for the sessionAffinity                                                                                      | `{}`                     |
| `ingress.enabled`                  | Enable ingress record generation for Opensearch                                                                                  | `false`                  |
| `ingress.pathType`                 | Ingress path type                                                                                                                | `ImplementationSpecific` |
| `ingress.apiVersion`               | Force Ingress API version (automatically detected if not set)                                                                    | `""`                     |
| `ingress.hostname`                 | Default host for the ingress record                                                                                              | `opensearch.local`       |
| `ingress.path`                     | Default path for the ingress record                                                                                              | `/`                      |
| `ingress.annotations`              | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                     |
| `ingress.tls`                      | Enable TLS configuration for the host defined at `ingress.hostname` parameter                                                    | `false`                  |
| `ingress.selfSigned`               | Create a TLS secret for this ingress record using self-signed certificates generated by Helm                                     | `false`                  |
| `ingress.ingressClassName`         | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                    | `""`                     |
| `ingress.extraHosts`               | An array with additional hostname(s) to be covered with the ingress record                                                       | `[]`                     |
| `ingress.extraPaths`               | An array with additional arbitrary paths that may need to be added to the ingress under the main host                            | `[]`                     |
| `ingress.extraTls`                 | TLS configuration for additional hostname(s) to be covered with this ingress record                                              | `[]`                     |
| `ingress.secrets`                  | Custom TLS certificates as secrets                                                                                               | `[]`                     |
| `ingress.extraRules`               | Additional rules to be covered with this ingress record                                                                          | `[]`                     |

### Master-elegible nodes parameters

| Name                                                 | Description                                                                                                                                                            | Value               |
| ---------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------- |
| `master.masterOnly`                                  | Deploy the Opensearch master-elegible nodes as master-only nodes. Recommended for high-demand deployments.                                                             | `true`              |
| `master.replicaCount`                                | Number of master-elegible replicas to deploy                                                                                                                           | `2`                 |
| `master.extraRoles`                                  | Append extra roles to the node role                                                                                                                                    | `[]`                |
| `master.pdb.create`                                  | Enable/disable a Pod Disruption Budget creation                                                                                                                        | `false`             |
| `master.pdb.minAvailable`                            | Minimum number/percentage of pods that should remain scheduled                                                                                                         | `1`                 |
| `master.pdb.maxUnavailable`                          | Maximum number/percentage of pods that may be made unavailable                                                                                                         | `""`                |
| `master.nameOverride`                                | String to partially override opensearch.master.fullname                                                                                                                | `""`                |
| `master.fullnameOverride`                            | String to fully override opensearch.master.fullname                                                                                                                    | `""`                |
| `master.servicenameOverride`                         | String to fully override opensearch.master.servicename                                                                                                                 | `""`                |
| `master.annotations`                                 | Annotations for the master statefulset                                                                                                                                 | `{}`                |
| `master.updateStrategy.type`                         | Master-elegible nodes statefulset stategy type                                                                                                                         | `RollingUpdate`     |
| `master.resources.limits`                            | The resources limits for opensearch containers                                                                                                                         | `{}`                |
| `master.resources.requests`                          | The requested resources for opensearch containers                                                                                                                      | `{}`                |
| `master.heapSize`                                    | Opensearch master-eligible node heap size.                                                                                                                             | `128m`              |
| `master.podSecurityContext.enabled`                  | Enabled master-elegible pods' Security Context                                                                                                                         | `true`              |
| `master.podSecurityContext.fsGroup`                  | Set master-elegible pod's Security Context fsGroup                                                                                                                     | `1001`              |
| `master.podSecurityContext.seccompProfile.type`      | Set Proxy container's Security Context seccomp profile                                                                                                                 | `RuntimeDefault`    |
| `master.containerSecurityContext.enabled`            | Enabled master-elegible containers' Security Context                                                                                                                   | `true`              |
| `master.containerSecurityContext.runAsUser`          | Set master-elegible containers' Security Context runAsUser                                                                                                             | `1001`              |
| `master.containerSecurityContext.runAsNonRoot`       | Set master-elegible containers' Security Context runAsNonRoot                                                                                                          | `true`              |
| `master.containerSecurityContext.capabilities.drop`  | Set APISIX container's Security Context runAsNonRoot                                                                                                                   | `["ALL"]`           |
| `master.hostAliases`                                 | master-elegible pods host aliases                                                                                                                                      | `[]`                |
| `master.podLabels`                                   | Extra labels for master-elegible pods                                                                                                                                  | `{}`                |
| `master.podAnnotations`                              | Annotations for master-elegible pods                                                                                                                                   | `{}`                |
| `master.podAffinityPreset`                           | Pod affinity preset. Ignored if `master.affinity` is set. Allowed values: `soft` or `hard`                                                                             | `""`                |
| `master.podAntiAffinityPreset`                       | Pod anti-affinity preset. Ignored if `master.affinity` is set. Allowed values: `soft` or `hard`                                                                        | `""`                |
| `master.nodeAffinityPreset.type`                     | Node affinity preset type. Ignored if `master.affinity` is set. Allowed values: `soft` or `hard`                                                                       | `""`                |
| `master.nodeAffinityPreset.key`                      | Node label key to match. Ignored if `master.affinity` is set                                                                                                           | `""`                |
| `master.nodeAffinityPreset.values`                   | Node label values to match. Ignored if `master.affinity` is set                                                                                                        | `[]`                |
| `master.affinity`                                    | Affinity for master-elegible pods assignment                                                                                                                           | `{}`                |
| `master.nodeSelector`                                | Node labels for master-elegible pods assignment                                                                                                                        | `{}`                |
| `master.tolerations`                                 | Tolerations for master-elegible pods assignment                                                                                                                        | `[]`                |
| `master.priorityClassName`                           | master-elegible pods' priorityClassName                                                                                                                                | `""`                |
| `master.schedulerName`                               | Name of the k8s scheduler (other than default) for master-elegible pods                                                                                                | `""`                |
| `master.terminationGracePeriodSeconds`               | In seconds, time the given to the Opensearch Master pod needs to terminate gracefully                                                                                  | `""`                |
| `master.topologySpreadConstraints`                   | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template                                               | `[]`                |
| `master.podManagementPolicy`                         | podManagementPolicy to manage scaling operation of Opensearch master pods                                                                                              | `Parallel`          |
| `master.startupProbe.enabled`                        | Enable/disable the startup probe (master nodes pod)                                                                                                                    | `false`             |
| `master.startupProbe.initialDelaySeconds`            | Delay before startup probe is initiated (master nodes pod)                                                                                                             | `90`                |
| `master.startupProbe.periodSeconds`                  | How often to perform the probe (master nodes pod)                                                                                                                      | `10`                |
| `master.startupProbe.timeoutSeconds`                 | When the probe times out (master nodes pod)                                                                                                                            | `5`                 |
| `master.startupProbe.successThreshold`               | Minimum consecutive successes for the probe to be considered successful after having failed (master nodes pod)                                                         | `1`                 |
| `master.startupProbe.failureThreshold`               | Minimum consecutive failures for the probe to be considered failed after having succeeded                                                                              | `5`                 |
| `master.livenessProbe.enabled`                       | Enable/disable the liveness probe (master-eligible nodes pod)                                                                                                          | `true`              |
| `master.livenessProbe.initialDelaySeconds`           | Delay before liveness probe is initiated (master-eligible nodes pod)                                                                                                   | `90`                |
| `master.livenessProbe.periodSeconds`                 | How often to perform the probe (master-eligible nodes pod)                                                                                                             | `10`                |
| `master.livenessProbe.timeoutSeconds`                | When the probe times out (master-eligible nodes pod)                                                                                                                   | `5`                 |
| `master.livenessProbe.successThreshold`              | Minimum consecutive successes for the probe to be considered successful after having failed (master-eligible nodes pod)                                                | `1`                 |
| `master.livenessProbe.failureThreshold`              | Minimum consecutive failures for the probe to be considered failed after having succeeded                                                                              | `5`                 |
| `master.readinessProbe.enabled`                      | Enable/disable the readiness probe (master-eligible nodes pod)                                                                                                         | `true`              |
| `master.readinessProbe.initialDelaySeconds`          | Delay before readiness probe is initiated (master-eligible nodes pod)                                                                                                  | `90`                |
| `master.readinessProbe.periodSeconds`                | How often to perform the probe (master-eligible nodes pod)                                                                                                             | `10`                |
| `master.readinessProbe.timeoutSeconds`               | When the probe times out (master-eligible nodes pod)                                                                                                                   | `5`                 |
| `master.readinessProbe.successThreshold`             | Minimum consecutive successes for the probe to be considered successful after having failed (master-eligible nodes pod)                                                | `1`                 |
| `master.readinessProbe.failureThreshold`             | Minimum consecutive failures for the probe to be considered failed after having succeeded                                                                              | `5`                 |
| `master.customStartupProbe`                          | Override default startup probe                                                                                                                                         | `{}`                |
| `master.customLivenessProbe`                         | Override default liveness probe                                                                                                                                        | `{}`                |
| `master.customReadinessProbe`                        | Override default readiness probe                                                                                                                                       | `{}`                |
| `master.command`                                     | Override default container command (useful when using custom images)                                                                                                   | `[]`                |
| `master.args`                                        | Override default container args (useful when using custom images)                                                                                                      | `[]`                |
| `master.lifecycleHooks`                              | for the master-elegible container(s) to automate configuration before or after startup                                                                                 | `{}`                |
| `master.extraEnvVars`                                | Array with extra environment variables to add to master-elegible nodes                                                                                                 | `[]`                |
| `master.extraEnvVarsCM`                              | Name of existing ConfigMap containing extra env vars for master-elegible nodes                                                                                         | `""`                |
| `master.extraEnvVarsSecret`                          | Name of existing Secret containing extra env vars for master-elegible nodes                                                                                            | `""`                |
| `master.extraVolumes`                                | Optionally specify extra list of additional volumes for the master-elegible pod(s)                                                                                     | `[]`                |
| `master.extraVolumeMounts`                           | Optionally specify extra list of additional volumeMounts for the master-elegible container(s)                                                                          | `[]`                |
| `master.sidecars`                                    | Add additional sidecar containers to the master-elegible pod(s)                                                                                                        | `[]`                |
| `master.initContainers`                              | Add additional init containers to the master-elegible pod(s)                                                                                                           | `[]`                |
| `master.persistence.enabled`                         | Enable persistence using a `PersistentVolumeClaim`                                                                                                                     | `true`              |
| `master.persistence.storageClass`                    | Persistent Volume Storage Class                                                                                                                                        | `""`                |
| `master.persistence.existingClaim`                   | Existing Persistent Volume Claim                                                                                                                                       | `""`                |
| `master.persistence.existingVolume`                  | Existing Persistent Volume for use as volume match label selector to the `volumeClaimTemplate`. Ignored when `master.persistence.selector` is set.                     | `""`                |
| `master.persistence.selector`                        | Configure custom selector for existing Persistent Volume. Overwrites `master.persistence.existingVolume`                                                               | `{}`                |
| `master.persistence.annotations`                     | Persistent Volume Claim annotations                                                                                                                                    | `{}`                |
| `master.persistence.accessModes`                     | Persistent Volume Access Modes                                                                                                                                         | `["ReadWriteOnce"]` |
| `master.persistence.size`                            | Persistent Volume Size                                                                                                                                                 | `8Gi`               |
| `master.serviceAccount.create`                       | Specifies whether a ServiceAccount should be created                                                                                                                   | `false`             |
| `master.serviceAccount.name`                         | Name of the service account to use. If not set and create is true, a name is generated using the fullname template.                                                    | `""`                |
| `master.serviceAccount.automountServiceAccountToken` | Automount service account token for the server service account                                                                                                         | `false`             |
| `master.serviceAccount.annotations`                  | Annotations for service account. Evaluated as a template. Only used if `create` is `true`.                                                                             | `{}`                |
| `master.networkPolicy.enabled`                       | Enable creation of NetworkPolicy resources                                                                                                                             | `false`             |
| `master.networkPolicy.allowExternal`                 | The Policy model to apply                                                                                                                                              | `true`              |
| `master.networkPolicy.extraIngress`                  | Add extra ingress rules to the NetworkPolicy                                                                                                                           | `[]`                |
| `master.networkPolicy.extraEgress`                   | Add extra ingress rules to the NetworkPolicy                                                                                                                           | `[]`                |
| `master.networkPolicy.ingressNSMatchLabels`          | Labels to match to allow traffic from other namespaces                                                                                                                 | `{}`                |
| `master.networkPolicy.ingressNSPodMatchLabels`       | Pod labels to match to allow traffic from other namespaces                                                                                                             | `{}`                |
| `master.autoscaling.vpa.enabled`                     | Enable VPA                                                                                                                                                             | `false`             |
| `master.autoscaling.vpa.annotations`                 | Annotations for VPA resource                                                                                                                                           | `{}`                |
| `master.autoscaling.vpa.controlledResources`         | VPA List of resources that the vertical pod autoscaler can control. Defaults to cpu and memory                                                                         | `[]`                |
| `master.autoscaling.vpa.maxAllowed`                  | VPA Max allowed resources for the pod                                                                                                                                  | `{}`                |
| `master.autoscaling.vpa.minAllowed`                  | VPA Min allowed resources for the pod                                                                                                                                  | `{}`                |
| `master.autoscaling.vpa.updatePolicy.updateMode`     | Autoscaling update policy Specifies whether recommended updates are applied when a Pod is started and whether recommended updates are applied during the life of a Pod | `Auto`              |
| `master.autoscaling.hpa.enabled`                     | Enable HPA for APISIX Data Plane                                                                                                                                       | `false`             |
| `master.autoscaling.hpa.minReplicas`                 | Minimum number of APISIX Data Plane replicas                                                                                                                           | `3`                 |
| `master.autoscaling.hpa.maxReplicas`                 | Maximum number of APISIX Data Plane replicas                                                                                                                           | `11`                |
| `master.autoscaling.hpa.targetCPU`                   | Target CPU utilization percentage                                                                                                                                      | `""`                |
| `master.autoscaling.hpa.targetMemory`                | Target Memory utilization percentage                                                                                                                                   | `""`                |

### Data-only nodes parameters

| Name                                               | Description                                                                                                                                                            | Value               |
| -------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------- |
| `data.replicaCount`                                | Number of data-only replicas to deploy                                                                                                                                 | `2`                 |
| `data.extraRoles`                                  | Append extra roles to the node role                                                                                                                                    | `[]`                |
| `data.pdb.create`                                  | Enable/disable a Pod Disruption Budget creation                                                                                                                        | `false`             |
| `data.pdb.minAvailable`                            | Minimum number/percentage of pods that should remain scheduled                                                                                                         | `1`                 |
| `data.pdb.maxUnavailable`                          | Maximum number/percentage of pods that may be made unavailable                                                                                                         | `""`                |
| `data.nameOverride`                                | String to partially override opensearch.data.fullname                                                                                                                  | `""`                |
| `data.fullnameOverride`                            | String to fully override opensearch.data.fullname                                                                                                                      | `""`                |
| `data.servicenameOverride`                         | String to fully override opensearch.data.servicename                                                                                                                   | `""`                |
| `data.annotations`                                 | Annotations for the data statefulset                                                                                                                                   | `{}`                |
| `data.updateStrategy.type`                         | Data-only nodes statefulset stategy type                                                                                                                               | `RollingUpdate`     |
| `data.resources.limits`                            | The resources limits for the data containers                                                                                                                           | `{}`                |
| `data.resources.requests`                          | The requested resources for the data containers                                                                                                                        | `{}`                |
| `data.heapSize`                                    | Opensearch data node heap size.                                                                                                                                        | `1024m`             |
| `data.podSecurityContext.enabled`                  | Enabled data pods' Security Context                                                                                                                                    | `true`              |
| `data.podSecurityContext.fsGroup`                  | Set data pod's Security Context fsGroup                                                                                                                                | `1001`              |
| `data.podSecurityContext.seccompProfile.type`      | Set Proxy container's Security Context seccomp profile                                                                                                                 | `RuntimeDefault`    |
| `data.containerSecurityContext.enabled`            | Enabled data containers' Security Context                                                                                                                              | `true`              |
| `data.containerSecurityContext.runAsUser`          | Set data containers' Security Context runAsUser                                                                                                                        | `1001`              |
| `data.containerSecurityContext.runAsNonRoot`       | Set data containers' Security Context runAsNonRoot                                                                                                                     | `true`              |
| `data.containerSecurityContext.capabilities.drop`  | Set APISIX container's Security Context runAsNonRoot                                                                                                                   | `["ALL"]`           |
| `data.hostAliases`                                 | data pods host aliases                                                                                                                                                 | `[]`                |
| `data.podLabels`                                   | Extra labels for data pods                                                                                                                                             | `{}`                |
| `data.podAnnotations`                              | Annotations for data pods                                                                                                                                              | `{}`                |
| `data.podAffinityPreset`                           | Pod affinity preset. Ignored if `data.affinity` is set. Allowed values: `soft` or `hard`                                                                               | `""`                |
| `data.podAntiAffinityPreset`                       | Pod anti-affinity preset. Ignored if `data.affinity` is set. Allowed values: `soft` or `hard`                                                                          | `""`                |
| `data.nodeAffinityPreset.type`                     | Node affinity preset type. Ignored if `data.affinity` is set. Allowed values: `soft` or `hard`                                                                         | `""`                |
| `data.nodeAffinityPreset.key`                      | Node label key to match. Ignored if `data.affinity` is set                                                                                                             | `""`                |
| `data.nodeAffinityPreset.values`                   | Node label values to match. Ignored if `data.affinity` is set                                                                                                          | `[]`                |
| `data.affinity`                                    | Affinity for data pods assignment                                                                                                                                      | `{}`                |
| `data.nodeSelector`                                | Node labels for data pods assignment                                                                                                                                   | `{}`                |
| `data.tolerations`                                 | Tolerations for data pods assignment                                                                                                                                   | `[]`                |
| `data.priorityClassName`                           | data pods' priorityClassName                                                                                                                                           | `""`                |
| `data.schedulerName`                               | Name of the k8s scheduler (other than default) for data pods                                                                                                           | `""`                |
| `data.terminationGracePeriodSeconds`               | In seconds, time the given to the Opensearch data pod needs to terminate gracefully                                                                                    | `""`                |
| `data.topologySpreadConstraints`                   | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template                                               | `[]`                |
| `data.podManagementPolicy`                         | podManagementPolicy to manage scaling operation of Opensearch data pods                                                                                                | `Parallel`          |
| `data.startupProbe.enabled`                        | Enable/disable the startup probe (data nodes pod)                                                                                                                      | `false`             |
| `data.startupProbe.initialDelaySeconds`            | Delay before startup probe is initiated (data nodes pod)                                                                                                               | `90`                |
| `data.startupProbe.periodSeconds`                  | How often to perform the probe (data nodes pod)                                                                                                                        | `10`                |
| `data.startupProbe.timeoutSeconds`                 | When the probe times out (data nodes pod)                                                                                                                              | `5`                 |
| `data.startupProbe.successThreshold`               | Minimum consecutive successes for the probe to be considered successful after having failed (data nodes pod)                                                           | `1`                 |
| `data.startupProbe.failureThreshold`               | Minimum consecutive failures for the probe to be considered failed after having succeeded                                                                              | `5`                 |
| `data.livenessProbe.enabled`                       | Enable/disable the liveness probe (data nodes pod)                                                                                                                     | `true`              |
| `data.livenessProbe.initialDelaySeconds`           | Delay before liveness probe is initiated (data nodes pod)                                                                                                              | `90`                |
| `data.livenessProbe.periodSeconds`                 | How often to perform the probe (data nodes pod)                                                                                                                        | `10`                |
| `data.livenessProbe.timeoutSeconds`                | When the probe times out (data nodes pod)                                                                                                                              | `5`                 |
| `data.livenessProbe.successThreshold`              | Minimum consecutive successes for the probe to be considered successful after having failed (data nodes pod)                                                           | `1`                 |
| `data.livenessProbe.failureThreshold`              | Minimum consecutive failures for the probe to be considered failed after having succeeded                                                                              | `5`                 |
| `data.readinessProbe.enabled`                      | Enable/disable the readiness probe (data nodes pod)                                                                                                                    | `true`              |
| `data.readinessProbe.initialDelaySeconds`          | Delay before readiness probe is initiated (data nodes pod)                                                                                                             | `90`                |
| `data.readinessProbe.periodSeconds`                | How often to perform the probe (data nodes pod)                                                                                                                        | `10`                |
| `data.readinessProbe.timeoutSeconds`               | When the probe times out (data nodes pod)                                                                                                                              | `5`                 |
| `data.readinessProbe.successThreshold`             | Minimum consecutive successes for the probe to be considered successful after having failed (data nodes pod)                                                           | `1`                 |
| `data.readinessProbe.failureThreshold`             | Minimum consecutive failures for the probe to be considered failed after having succeeded                                                                              | `5`                 |
| `data.customStartupProbe`                          | Override default startup probe                                                                                                                                         | `{}`                |
| `data.customLivenessProbe`                         | Override default liveness probe                                                                                                                                        | `{}`                |
| `data.customReadinessProbe`                        | Override default readiness probe                                                                                                                                       | `{}`                |
| `data.command`                                     | Override default container command (useful when using custom images)                                                                                                   | `[]`                |
| `data.args`                                        | Override default container args (useful when using custom images)                                                                                                      | `[]`                |
| `data.lifecycleHooks`                              | for the data container(s) to automate configuration before or after startup                                                                                            | `{}`                |
| `data.extraEnvVars`                                | Array with extra environment variables to add to data nodes                                                                                                            | `[]`                |
| `data.extraEnvVarsCM`                              | Name of existing ConfigMap containing extra env vars for data nodes                                                                                                    | `""`                |
| `data.extraEnvVarsSecret`                          | Name of existing Secret containing extra env vars for data nodes                                                                                                       | `""`                |
| `data.extraVolumes`                                | Optionally specify extra list of additional volumes for the data pod(s)                                                                                                | `[]`                |
| `data.extraVolumeMounts`                           | Optionally specify extra list of additional volumeMounts for the data container(s)                                                                                     | `[]`                |
| `data.sidecars`                                    | Add additional sidecar containers to the data pod(s)                                                                                                                   | `[]`                |
| `data.initContainers`                              | Add additional init containers to the data pod(s)                                                                                                                      | `[]`                |
| `data.persistence.enabled`                         | Enable persistence using a `PersistentVolumeClaim`                                                                                                                     | `true`              |
| `data.persistence.storageClass`                    | Persistent Volume Storage Class                                                                                                                                        | `""`                |
| `data.persistence.existingClaim`                   | Existing Persistent Volume Claim                                                                                                                                       | `""`                |
| `data.persistence.existingVolume`                  | Existing Persistent Volume for use as volume match label selector to the `volumeClaimTemplate`. Ignored when `data.persistence.selector` is set.                       | `""`                |
| `data.persistence.selector`                        | Configure custom selector for existing Persistent Volume. Overwrites `data.persistence.existingVolume`                                                                 | `{}`                |
| `data.persistence.annotations`                     | Persistent Volume Claim annotations                                                                                                                                    | `{}`                |
| `data.persistence.accessModes`                     | Persistent Volume Access Modes                                                                                                                                         | `["ReadWriteOnce"]` |
| `data.persistence.size`                            | Persistent Volume Size                                                                                                                                                 | `8Gi`               |
| `data.serviceAccount.create`                       | Specifies whether a ServiceAccount should be created                                                                                                                   | `false`             |
| `data.serviceAccount.name`                         | Name of the service account to use. If not set and create is true, a name is generated using the fullname template.                                                    | `""`                |
| `data.serviceAccount.automountServiceAccountToken` | Automount service account token for the server service account                                                                                                         | `false`             |
| `data.serviceAccount.annotations`                  | Annotations for service account. Evaluated as a template. Only used if `create` is `true`.                                                                             | `{}`                |
| `data.networkPolicy.enabled`                       | Enable creation of NetworkPolicy resources                                                                                                                             | `false`             |
| `data.networkPolicy.allowExternal`                 | The Policy model to apply                                                                                                                                              | `true`              |
| `data.networkPolicy.extraIngress`                  | Add extra ingress rules to the NetworkPolicy                                                                                                                           | `[]`                |
| `data.networkPolicy.extraEgress`                   | Add extra ingress rules to the NetworkPolicy                                                                                                                           | `[]`                |
| `data.networkPolicy.ingressNSMatchLabels`          | Labels to match to allow traffic from other namespaces                                                                                                                 | `{}`                |
| `data.networkPolicy.ingressNSPodMatchLabels`       | Pod labels to match to allow traffic from other namespaces                                                                                                             | `{}`                |
| `data.autoscaling.vpa.enabled`                     | Enable VPA                                                                                                                                                             | `false`             |
| `data.autoscaling.vpa.annotations`                 | Annotations for VPA resource                                                                                                                                           | `{}`                |
| `data.autoscaling.vpa.controlledResources`         | VPA List of resources that the vertical pod autoscaler can control. Defaults to cpu and memory                                                                         | `[]`                |
| `data.autoscaling.vpa.maxAllowed`                  | VPA Max allowed resources for the pod                                                                                                                                  | `{}`                |
| `data.autoscaling.vpa.minAllowed`                  | VPA Min allowed resources for the pod                                                                                                                                  | `{}`                |
| `data.autoscaling.vpa.updatePolicy.updateMode`     | Autoscaling update policy Specifies whether recommended updates are applied when a Pod is started and whether recommended updates are applied during the life of a Pod | `Auto`              |
| `data.autoscaling.hpa.enabled`                     | Enable HPA for APISIX Data Plane                                                                                                                                       | `false`             |
| `data.autoscaling.hpa.minReplicas`                 | Minimum number of APISIX Data Plane replicas                                                                                                                           | `3`                 |
| `data.autoscaling.hpa.maxReplicas`                 | Maximum number of APISIX Data Plane replicas                                                                                                                           | `11`                |
| `data.autoscaling.hpa.targetCPU`                   | Target CPU utilization percentage                                                                                                                                      | `""`                |
| `data.autoscaling.hpa.targetMemory`                | Target Memory utilization percentage                                                                                                                                   | `""`                |

### Coordinating-only nodes parameters

| Name                                                       | Description                                                                                                                                                            | Value            |
| ---------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| `coordinating.replicaCount`                                | Number of coordinating-only replicas to deploy                                                                                                                         | `2`              |
| `coordinating.extraRoles`                                  | Append extra roles to the node role                                                                                                                                    | `[]`             |
| `coordinating.pdb.create`                                  | Enable/disable a Pod Disruption Budget creation                                                                                                                        | `false`          |
| `coordinating.pdb.minAvailable`                            | Minimum number/percentage of pods that should remain scheduled                                                                                                         | `1`              |
| `coordinating.pdb.maxUnavailable`                          | Maximum number/percentage of pods that may be made unavailable                                                                                                         | `""`             |
| `coordinating.nameOverride`                                | String to partially override opensearch.coordinating.fullname                                                                                                          | `""`             |
| `coordinating.fullnameOverride`                            | String to fully override opensearch.coordinating.fullname                                                                                                              | `""`             |
| `coordinating.servicenameOverride`                         | String to fully override opensearch.coordinating.servicename                                                                                                           | `""`             |
| `coordinating.annotations`                                 | Annotations for the coordinating-only statefulset                                                                                                                      | `{}`             |
| `coordinating.updateStrategy.type`                         | Coordinating-only nodes statefulset stategy type                                                                                                                       | `RollingUpdate`  |
| `coordinating.resources.limits`                            | The resources limits for the coordinating-only containers                                                                                                              | `{}`             |
| `coordinating.resources.requests`                          | The requested resources for the coordinating-only containers                                                                                                           | `{}`             |
| `coordinating.heapSize`                                    | Opensearch coordinating node heap size.                                                                                                                                | `128m`           |
| `coordinating.podSecurityContext.enabled`                  | Enabled coordinating-only pods' Security Context                                                                                                                       | `true`           |
| `coordinating.podSecurityContext.fsGroup`                  | Set coordinating-only pod's Security Context fsGroup                                                                                                                   | `1001`           |
| `coordinating.podSecurityContext.seccompProfile.type`      | Set Proxy container's Security Context seccomp profile                                                                                                                 | `RuntimeDefault` |
| `coordinating.containerSecurityContext.enabled`            | Enabled coordinating-only containers' Security Context                                                                                                                 | `true`           |
| `coordinating.containerSecurityContext.runAsUser`          | Set coordinating-only containers' Security Context runAsUser                                                                                                           | `1001`           |
| `coordinating.containerSecurityContext.runAsNonRoot`       | Set coordinating-only containers' Security Context runAsNonRoot                                                                                                        | `true`           |
| `coordinating.containerSecurityContext.capabilities.drop`  | Set APISIX container's Security Context runAsNonRoot                                                                                                                   | `["ALL"]`        |
| `coordinating.hostAliases`                                 | coordinating-only pods host aliases                                                                                                                                    | `[]`             |
| `coordinating.podLabels`                                   | Extra labels for coordinating-only pods                                                                                                                                | `{}`             |
| `coordinating.podAnnotations`                              | Annotations for coordinating-only pods                                                                                                                                 | `{}`             |
| `coordinating.podAffinityPreset`                           | Pod affinity preset. Ignored if `coordinating.affinity` is set. Allowed values: `soft` or `hard`                                                                       | `""`             |
| `coordinating.podAntiAffinityPreset`                       | Pod anti-affinity preset. Ignored if `coordinating.affinity` is set. Allowed values: `soft` or `hard`                                                                  | `""`             |
| `coordinating.nodeAffinityPreset.type`                     | Node affinity preset type. Ignored if `coordinating.affinity` is set. Allowed values: `soft` or `hard`                                                                 | `""`             |
| `coordinating.nodeAffinityPreset.key`                      | Node label key to match. Ignored if `coordinating.affinity` is set                                                                                                     | `""`             |
| `coordinating.nodeAffinityPreset.values`                   | Node label values to match. Ignored if `coordinating.affinity` is set                                                                                                  | `[]`             |
| `coordinating.affinity`                                    | Affinity for coordinating-only pods assignment                                                                                                                         | `{}`             |
| `coordinating.nodeSelector`                                | Node labels for coordinating-only pods assignment                                                                                                                      | `{}`             |
| `coordinating.tolerations`                                 | Tolerations for coordinating-only pods assignment                                                                                                                      | `[]`             |
| `coordinating.priorityClassName`                           | coordinating-only pods' priorityClassName                                                                                                                              | `""`             |
| `coordinating.schedulerName`                               | Name of the k8s scheduler (other than default) for coordinating-only pods                                                                                              | `""`             |
| `coordinating.terminationGracePeriodSeconds`               | In seconds, time the given to the Opensearch coordinating pod needs to terminate gracefully                                                                            | `""`             |
| `coordinating.topologySpreadConstraints`                   | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template                                               | `[]`             |
| `coordinating.podManagementPolicy`                         | podManagementPolicy to manage scaling operation of Opensearch coordinating pods                                                                                        | `Parallel`       |
| `coordinating.startupProbe.enabled`                        | Enable/disable the startup probe (coordinating-only nodes pod)                                                                                                         | `false`          |
| `coordinating.startupProbe.initialDelaySeconds`            | Delay before startup probe is initiated (coordinating-only nodes pod)                                                                                                  | `90`             |
| `coordinating.startupProbe.periodSeconds`                  | How often to perform the probe (coordinating-only nodes pod)                                                                                                           | `10`             |
| `coordinating.startupProbe.timeoutSeconds`                 | When the probe times out (coordinating-only nodes pod)                                                                                                                 | `5`              |
| `coordinating.startupProbe.successThreshold`               | Minimum consecutive successes for the probe to be considered successful after having failed (coordinating-only nodes pod)                                              | `1`              |
| `coordinating.startupProbe.failureThreshold`               | Minimum consecutive failures for the probe to be considered failed after having succeeded                                                                              | `5`              |
| `coordinating.livenessProbe.enabled`                       | Enable/disable the liveness probe (coordinating-only nodes pod)                                                                                                        | `true`           |
| `coordinating.livenessProbe.initialDelaySeconds`           | Delay before liveness probe is initiated (coordinating-only nodes pod)                                                                                                 | `90`             |
| `coordinating.livenessProbe.periodSeconds`                 | How often to perform the probe (coordinating-only nodes pod)                                                                                                           | `10`             |
| `coordinating.livenessProbe.timeoutSeconds`                | When the probe times out (coordinating-only nodes pod)                                                                                                                 | `5`              |
| `coordinating.livenessProbe.successThreshold`              | Minimum consecutive successes for the probe to be considered successful after having failed (coordinating-only nodes pod)                                              | `1`              |
| `coordinating.livenessProbe.failureThreshold`              | Minimum consecutive failures for the probe to be considered failed after having succeeded                                                                              | `5`              |
| `coordinating.readinessProbe.enabled`                      | Enable/disable the readiness probe (coordinating-only nodes pod)                                                                                                       | `true`           |
| `coordinating.readinessProbe.initialDelaySeconds`          | Delay before readiness probe is initiated (coordinating-only nodes pod)                                                                                                | `90`             |
| `coordinating.readinessProbe.periodSeconds`                | How often to perform the probe (coordinating-only nodes pod)                                                                                                           | `10`             |
| `coordinating.readinessProbe.timeoutSeconds`               | When the probe times out (coordinating-only nodes pod)                                                                                                                 | `5`              |
| `coordinating.readinessProbe.successThreshold`             | Minimum consecutive successes for the probe to be considered successful after having failed (coordinating-only nodes pod)                                              | `1`              |
| `coordinating.readinessProbe.failureThreshold`             | Minimum consecutive failures for the probe to be considered failed after having succeeded                                                                              | `5`              |
| `coordinating.customStartupProbe`                          | Override default startup probe                                                                                                                                         | `{}`             |
| `coordinating.customLivenessProbe`                         | Override default liveness probe                                                                                                                                        | `{}`             |
| `coordinating.customReadinessProbe`                        | Override default readiness probe                                                                                                                                       | `{}`             |
| `coordinating.command`                                     | Override default container command (useful when using custom images)                                                                                                   | `[]`             |
| `coordinating.args`                                        | Override default container args (useful when using custom images)                                                                                                      | `[]`             |
| `coordinating.lifecycleHooks`                              | for the coordinating-only container(s) to automate configuration before or after startup                                                                               | `{}`             |
| `coordinating.extraEnvVars`                                | Array with extra environment variables to add to coordinating-only nodes                                                                                               | `[]`             |
| `coordinating.extraEnvVarsCM`                              | Name of existing ConfigMap containing extra env vars for coordinating-only nodes                                                                                       | `""`             |
| `coordinating.extraEnvVarsSecret`                          | Name of existing Secret containing extra env vars for coordinating-only nodes                                                                                          | `""`             |
| `coordinating.extraVolumes`                                | Optionally specify extra list of additional volumes for the coordinating-only pod(s)                                                                                   | `[]`             |
| `coordinating.extraVolumeMounts`                           | Optionally specify extra list of additional volumeMounts for the coordinating-only container(s)                                                                        | `[]`             |
| `coordinating.sidecars`                                    | Add additional sidecar containers to the coordinating-only pod(s)                                                                                                      | `[]`             |
| `coordinating.initContainers`                              | Add additional init containers to the coordinating-only pod(s)                                                                                                         | `[]`             |
| `coordinating.serviceAccount.create`                       | Specifies whether a ServiceAccount should be created                                                                                                                   | `false`          |
| `coordinating.serviceAccount.name`                         | Name of the service account to use. If not set and create is true, a name is generated using the fullname template.                                                    | `""`             |
| `coordinating.serviceAccount.automountServiceAccountToken` | Automount service account token for the server service account                                                                                                         | `false`          |
| `coordinating.serviceAccount.annotations`                  | Annotations for service account. Evaluated as a template. Only used if `create` is `true`.                                                                             | `{}`             |
| `coordinating.networkPolicy.enabled`                       | Enable creation of NetworkPolicy resources                                                                                                                             | `false`          |
| `coordinating.networkPolicy.allowExternal`                 | The Policy model to apply                                                                                                                                              | `true`           |
| `coordinating.networkPolicy.extraIngress`                  | Add extra ingress rules to the NetworkPolicy                                                                                                                           | `[]`             |
| `coordinating.networkPolicy.extraEgress`                   | Add extra ingress rules to the NetworkPolicy                                                                                                                           | `[]`             |
| `coordinating.networkPolicy.ingressNSMatchLabels`          | Labels to match to allow traffic from other namespaces                                                                                                                 | `{}`             |
| `coordinating.networkPolicy.ingressNSPodMatchLabels`       | Pod labels to match to allow traffic from other namespaces                                                                                                             | `{}`             |
| `coordinating.autoscaling.vpa.enabled`                     | Enable VPA                                                                                                                                                             | `false`          |
| `coordinating.autoscaling.vpa.annotations`                 | Annotations for VPA resource                                                                                                                                           | `{}`             |
| `coordinating.autoscaling.vpa.controlledResources`         | VPA List of resources that the vertical pod autoscaler can control. Defaults to cpu and memory                                                                         | `[]`             |
| `coordinating.autoscaling.vpa.maxAllowed`                  | VPA Max allowed resources for the pod                                                                                                                                  | `{}`             |
| `coordinating.autoscaling.vpa.minAllowed`                  | VPA Min allowed resources for the pod                                                                                                                                  | `{}`             |
| `coordinating.autoscaling.vpa.updatePolicy.updateMode`     | Autoscaling update policy Specifies whether recommended updates are applied when a Pod is started and whether recommended updates are applied during the life of a Pod | `Auto`           |
| `coordinating.autoscaling.hpa.enabled`                     | Enable HPA for APISIX Data Plane                                                                                                                                       | `false`          |
| `coordinating.autoscaling.hpa.minReplicas`                 | Minimum number of APISIX Data Plane replicas                                                                                                                           | `3`              |
| `coordinating.autoscaling.hpa.maxReplicas`                 | Maximum number of APISIX Data Plane replicas                                                                                                                           | `11`             |
| `coordinating.autoscaling.hpa.targetCPU`                   | Target CPU utilization percentage                                                                                                                                      | `""`             |
| `coordinating.autoscaling.hpa.targetMemory`                | Target Memory utilization percentage                                                                                                                                   | `""`             |

### Ingest-only nodes parameters

| Name                                                 | Description                                                                                                                                                            | Value                     |
| ---------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------- |
| `ingest.enabled`                                     | Enable ingest nodes                                                                                                                                                    | `true`                    |
| `ingest.replicaCount`                                | Number of ingest-only replicas to deploy                                                                                                                               | `2`                       |
| `ingest.extraRoles`                                  | Append extra roles to the node role                                                                                                                                    | `[]`                      |
| `ingest.pdb.create`                                  | Enable/disable a Pod Disruption Budget creation                                                                                                                        | `false`                   |
| `ingest.pdb.minAvailable`                            | Minimum number/percentage of pods that should remain scheduled                                                                                                         | `1`                       |
| `ingest.pdb.maxUnavailable`                          | Maximum number/percentage of pods that may be made unavailable                                                                                                         | `""`                      |
| `ingest.nameOverride`                                | String to partially override opensearch.ingest.fullname                                                                                                                | `""`                      |
| `ingest.fullnameOverride`                            | String to fully override opensearch.ingest.fullname                                                                                                                    | `""`                      |
| `ingest.servicenameOverride`                         | String to fully override ingest.master.servicename                                                                                                                     | `""`                      |
| `ingest.annotations`                                 | Annotations for the ingest statefulset                                                                                                                                 | `{}`                      |
| `ingest.updateStrategy.type`                         | Ingest-only nodes statefulset stategy type                                                                                                                             | `RollingUpdate`           |
| `ingest.resources.limits`                            | The resources limits for the ingest-only containers                                                                                                                    | `{}`                      |
| `ingest.resources.requests`                          | The requested resources for the ingest-only containers                                                                                                                 | `{}`                      |
| `ingest.heapSize`                                    | Opensearch ingest-only node heap size.                                                                                                                                 | `128m`                    |
| `ingest.podSecurityContext.enabled`                  | Enabled ingest-only pods' Security Context                                                                                                                             | `true`                    |
| `ingest.podSecurityContext.fsGroup`                  | Set ingest-only pod's Security Context fsGroup                                                                                                                         | `1001`                    |
| `ingest.podSecurityContext.seccompProfile.type`      | Set Proxy container's Security Context seccomp profile                                                                                                                 | `RuntimeDefault`          |
| `ingest.containerSecurityContext.enabled`            | Enabled ingest-only containers' Security Context                                                                                                                       | `true`                    |
| `ingest.containerSecurityContext.runAsUser`          | Set ingest-only containers' Security Context runAsUser                                                                                                                 | `1001`                    |
| `ingest.containerSecurityContext.runAsNonRoot`       | Set ingest-only containers' Security Context runAsNonRoot                                                                                                              | `true`                    |
| `ingest.containerSecurityContext.capabilities.drop`  | Set APISIX container's Security Context runAsNonRoot                                                                                                                   | `["ALL"]`                 |
| `ingest.hostAliases`                                 | ingest-only pods host aliases                                                                                                                                          | `[]`                      |
| `ingest.podLabels`                                   | Extra labels for ingest-only pods                                                                                                                                      | `{}`                      |
| `ingest.podAnnotations`                              | Annotations for ingest-only pods                                                                                                                                       | `{}`                      |
| `ingest.podAffinityPreset`                           | Pod affinity preset. Ignored if `ingest.affinity` is set. Allowed values: `soft` or `hard`                                                                             | `""`                      |
| `ingest.podAntiAffinityPreset`                       | Pod anti-affinity preset. Ignored if `ingest.affinity` is set. Allowed values: `soft` or `hard`                                                                        | `""`                      |
| `ingest.nodeAffinityPreset.type`                     | Node affinity preset type. Ignored if `ingest.affinity` is set. Allowed values: `soft` or `hard`                                                                       | `""`                      |
| `ingest.nodeAffinityPreset.key`                      | Node label key to match. Ignored if `ingest.affinity` is set                                                                                                           | `""`                      |
| `ingest.nodeAffinityPreset.values`                   | Node label values to match. Ignored if `ingest.affinity` is set                                                                                                        | `[]`                      |
| `ingest.affinity`                                    | Affinity for ingest-only pods assignment                                                                                                                               | `{}`                      |
| `ingest.nodeSelector`                                | Node labels for ingest-only pods assignment                                                                                                                            | `{}`                      |
| `ingest.tolerations`                                 | Tolerations for ingest-only pods assignment                                                                                                                            | `[]`                      |
| `ingest.priorityClassName`                           | ingest-only pods' priorityClassName                                                                                                                                    | `""`                      |
| `ingest.schedulerName`                               | Name of the k8s scheduler (other than default) for ingest-only pods                                                                                                    | `""`                      |
| `ingest.terminationGracePeriodSeconds`               | In seconds, time the given to the Opensearch ingest pod needs to terminate gracefully                                                                                  | `""`                      |
| `ingest.topologySpreadConstraints`                   | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template                                               | `[]`                      |
| `ingest.podManagementPolicy`                         | podManagementPolicy to manage scaling operation of Opensearch ingest pods                                                                                              | `Parallel`                |
| `ingest.startupProbe.enabled`                        | Enable/disable the startup probe (ingest-only nodes pod)                                                                                                               | `false`                   |
| `ingest.startupProbe.initialDelaySeconds`            | Delay before startup probe is initiated (ingest-only nodes pod)                                                                                                        | `90`                      |
| `ingest.startupProbe.periodSeconds`                  | How often to perform the probe (ingest-only nodes pod)                                                                                                                 | `10`                      |
| `ingest.startupProbe.timeoutSeconds`                 | When the probe times out (ingest-only nodes pod)                                                                                                                       | `5`                       |
| `ingest.startupProbe.successThreshold`               | Minimum consecutive successes for the probe to be considered successful after having failed (ingest-only nodes pod)                                                    | `1`                       |
| `ingest.startupProbe.failureThreshold`               | Minimum consecutive failures for the probe to be considered failed after having succeeded                                                                              | `5`                       |
| `ingest.livenessProbe.enabled`                       | Enable/disable the liveness probe (ingest-only nodes pod)                                                                                                              | `true`                    |
| `ingest.livenessProbe.initialDelaySeconds`           | Delay before liveness probe is initiated (ingest-only nodes pod)                                                                                                       | `90`                      |
| `ingest.livenessProbe.periodSeconds`                 | How often to perform the probe (ingest-only nodes pod)                                                                                                                 | `10`                      |
| `ingest.livenessProbe.timeoutSeconds`                | When the probe times out (ingest-only nodes pod)                                                                                                                       | `5`                       |
| `ingest.livenessProbe.successThreshold`              | Minimum consecutive successes for the probe to be considered successful after having failed (ingest-only nodes pod)                                                    | `1`                       |
| `ingest.livenessProbe.failureThreshold`              | Minimum consecutive failures for the probe to be considered failed after having succeeded                                                                              | `5`                       |
| `ingest.readinessProbe.enabled`                      | Enable/disable the readiness probe (ingest-only nodes pod)                                                                                                             | `true`                    |
| `ingest.readinessProbe.initialDelaySeconds`          | Delay before readiness probe is initiated (ingest-only nodes pod)                                                                                                      | `90`                      |
| `ingest.readinessProbe.periodSeconds`                | How often to perform the probe (ingest-only nodes pod)                                                                                                                 | `10`                      |
| `ingest.readinessProbe.timeoutSeconds`               | When the probe times out (ingest-only nodes pod)                                                                                                                       | `5`                       |
| `ingest.readinessProbe.successThreshold`             | Minimum consecutive successes for the probe to be considered successful after having failed (ingest-only nodes pod)                                                    | `1`                       |
| `ingest.readinessProbe.failureThreshold`             | Minimum consecutive failures for the probe to be considered failed after having succeeded                                                                              | `5`                       |
| `ingest.customStartupProbe`                          | Override default startup probe                                                                                                                                         | `{}`                      |
| `ingest.customLivenessProbe`                         | Override default liveness probe                                                                                                                                        | `{}`                      |
| `ingest.customReadinessProbe`                        | Override default readiness probe                                                                                                                                       | `{}`                      |
| `ingest.command`                                     | Override default container command (useful when using custom images)                                                                                                   | `[]`                      |
| `ingest.args`                                        | Override default container args (useful when using custom images)                                                                                                      | `[]`                      |
| `ingest.lifecycleHooks`                              | for the ingest-only container(s) to automate configuration before or after startup                                                                                     | `{}`                      |
| `ingest.extraEnvVars`                                | Array with extra environment variables to add to ingest-only nodes                                                                                                     | `[]`                      |
| `ingest.extraEnvVarsCM`                              | Name of existing ConfigMap containing extra env vars for ingest-only nodes                                                                                             | `""`                      |
| `ingest.extraEnvVarsSecret`                          | Name of existing Secret containing extra env vars for ingest-only nodes                                                                                                | `""`                      |
| `ingest.extraVolumes`                                | Optionally specify extra list of additional volumes for the ingest-only pod(s)                                                                                         | `[]`                      |
| `ingest.extraVolumeMounts`                           | Optionally specify extra list of additional volumeMounts for the ingest-only container(s)                                                                              | `[]`                      |
| `ingest.sidecars`                                    | Add additional sidecar containers to the ingest-only pod(s)                                                                                                            | `[]`                      |
| `ingest.initContainers`                              | Add additional init containers to the ingest-only pod(s)                                                                                                               | `[]`                      |
| `ingest.serviceAccount.create`                       | Specifies whether a ServiceAccount should be created                                                                                                                   | `false`                   |
| `ingest.serviceAccount.name`                         | Name of the service account to use. If not set and create is true, a name is generated using the fullname template.                                                    | `""`                      |
| `ingest.serviceAccount.automountServiceAccountToken` | Automount service account token for the server service account                                                                                                         | `false`                   |
| `ingest.serviceAccount.annotations`                  | Annotations for service account. Evaluated as a template. Only used if `create` is `true`.                                                                             | `{}`                      |
| `ingest.networkPolicy.enabled`                       | Enable creation of NetworkPolicy resources                                                                                                                             | `false`                   |
| `ingest.networkPolicy.allowExternal`                 | The Policy model to apply                                                                                                                                              | `true`                    |
| `ingest.networkPolicy.extraIngress`                  | Add extra ingress rules to the NetworkPolicy                                                                                                                           | `[]`                      |
| `ingest.networkPolicy.extraEgress`                   | Add extra ingress rules to the NetworkPolicy                                                                                                                           | `[]`                      |
| `ingest.networkPolicy.ingressNSMatchLabels`          | Labels to match to allow traffic from other namespaces                                                                                                                 | `{}`                      |
| `ingest.networkPolicy.ingressNSPodMatchLabels`       | Pod labels to match to allow traffic from other namespaces                                                                                                             | `{}`                      |
| `ingest.autoscaling.vpa.enabled`                     | Enable VPA                                                                                                                                                             | `false`                   |
| `ingest.autoscaling.vpa.annotations`                 | Annotations for VPA resource                                                                                                                                           | `{}`                      |
| `ingest.autoscaling.vpa.controlledResources`         | VPA List of resources that the vertical pod autoscaler can control. Defaults to cpu and memory                                                                         | `[]`                      |
| `ingest.autoscaling.vpa.maxAllowed`                  | VPA Max allowed resources for the pod                                                                                                                                  | `{}`                      |
| `ingest.autoscaling.vpa.minAllowed`                  | VPA Min allowed resources for the pod                                                                                                                                  | `{}`                      |
| `ingest.autoscaling.vpa.updatePolicy.updateMode`     | Autoscaling update policy Specifies whether recommended updates are applied when a Pod is started and whether recommended updates are applied during the life of a Pod | `Auto`                    |
| `ingest.autoscaling.hpa.enabled`                     | Enable HPA for APISIX Data Plane                                                                                                                                       | `false`                   |
| `ingest.autoscaling.hpa.minReplicas`                 | Minimum number of APISIX Data Plane replicas                                                                                                                           | `3`                       |
| `ingest.autoscaling.hpa.maxReplicas`                 | Maximum number of APISIX Data Plane replicas                                                                                                                           | `11`                      |
| `ingest.autoscaling.hpa.targetCPU`                   | Target CPU utilization percentage                                                                                                                                      | `""`                      |
| `ingest.autoscaling.hpa.targetMemory`                | Target Memory utilization percentage                                                                                                                                   | `""`                      |
| `ingest.service.enabled`                             | Enable Ingest-only service                                                                                                                                             | `false`                   |
| `ingest.service.type`                                | Opensearch ingest-only service type                                                                                                                                    | `ClusterIP`               |
| `ingest.service.ports.restAPI`                       | Opensearch service REST API port                                                                                                                                       | `9200`                    |
| `ingest.service.ports.transport`                     | Opensearch service transport port                                                                                                                                      | `9300`                    |
| `ingest.service.nodePorts.restAPI`                   | Node port for REST API                                                                                                                                                 | `""`                      |
| `ingest.service.nodePorts.transport`                 | Node port for REST API                                                                                                                                                 | `""`                      |
| `ingest.service.clusterIP`                           | Opensearch ingest-only service Cluster IP                                                                                                                              | `""`                      |
| `ingest.service.loadBalancerIP`                      | Opensearch ingest-only service Load Balancer IP                                                                                                                        | `""`                      |
| `ingest.service.loadBalancerSourceRanges`            | Opensearch ingest-only service Load Balancer sources                                                                                                                   | `[]`                      |
| `ingest.service.externalTrafficPolicy`               | Opensearch ingest-only service external traffic policy                                                                                                                 | `Cluster`                 |
| `ingest.service.extraPorts`                          | Extra ports to expose (normally used with the `sidecar` value)                                                                                                         | `[]`                      |
| `ingest.service.annotations`                         | Additional custom annotations for Opensearch ingest-only service                                                                                                       | `{}`                      |
| `ingest.service.sessionAffinity`                     | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                                                                                                   | `None`                    |
| `ingest.service.sessionAffinityConfig`               | Additional settings for the sessionAffinity                                                                                                                            | `{}`                      |
| `ingest.ingress.enabled`                             | Enable ingress record generation for Opensearch                                                                                                                        | `false`                   |
| `ingest.ingress.pathType`                            | Ingress path type                                                                                                                                                      | `ImplementationSpecific`  |
| `ingest.ingress.apiVersion`                          | Force Ingress API version (automatically detected if not set)                                                                                                          | `""`                      |
| `ingest.ingress.hostname`                            | Default host for the ingress record                                                                                                                                    | `opensearch-ingest.local` |
| `ingest.ingress.path`                                | Default path for the ingress record                                                                                                                                    | `/`                       |
| `ingest.ingress.annotations`                         | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations.                                       | `{}`                      |
| `ingest.ingress.tls`                                 | Enable TLS configuration for the host defined at `ingress.hostname` parameter                                                                                          | `false`                   |
| `ingest.ingress.selfSigned`                          | Create a TLS secret for this ingress record using self-signed certificates generated by Helm                                                                           | `false`                   |
| `ingest.ingress.ingressClassName`                    | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                                                          | `""`                      |
| `ingest.ingress.extraHosts`                          | An array with additional hostname(s) to be covered with the ingress record                                                                                             | `[]`                      |
| `ingest.ingress.extraPaths`                          | An array with additional arbitrary paths that may need to be added to the ingress under the main host                                                                  | `[]`                      |
| `ingest.ingress.extraTls`                            | TLS configuration for additional hostname(s) to be covered with this ingress record                                                                                    | `[]`                      |
| `ingest.ingress.secrets`                             | Custom TLS certificates as secrets                                                                                                                                     | `[]`                      |
| `ingest.ingress.extraRules`                          | Additional rules to be covered with this ingress record                                                                                                                | `[]`                      |

### Init Container Parameters

| Name                                   | Description                                                                                                                                               | Value                   |
| -------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------- |
| `volumePermissions.enabled`            | Enable init container that changes volume permissions in the data directory (for cases where the default k8s `runAsUser` and `fsUser` values do not work) | `false`                 |
| `volumePermissions.image.registry`     | Init container volume-permissions image registry                                                                                                          | `docker.io`             |
| `volumePermissions.image.repository`   | Init container volume-permissions image name                                                                                                              | `bitnami/bitnami-shell` |
| `volumePermissions.image.tag`          | Init container volume-permissions image tag                                                                                                               | `11-debian-11-r131`     |
| `volumePermissions.image.digest`       | Init container volume-permissions image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                         | `""`                    |
| `volumePermissions.image.pullPolicy`   | Init container volume-permissions image pull policy                                                                                                       | `IfNotPresent`          |
| `volumePermissions.image.pullSecrets`  | Init container volume-permissions image pull secrets                                                                                                      | `[]`                    |
| `volumePermissions.resources.limits`   | The resources limits for the container                                                                                                                    | `{}`                    |
| `volumePermissions.resources.requests` | The requested resources for the container                                                                                                                 | `{}`                    |
| `sysctlImage.enabled`                  | Enable kernel settings modifier image                                                                                                                     | `true`                  |
| `sysctlImage.registry`                 | Kernel settings modifier image registry                                                                                                                   | `docker.io`             |
| `sysctlImage.repository`               | Kernel settings modifier image repository                                                                                                                 | `bitnami/bitnami-shell` |
| `sysctlImage.tag`                      | Kernel settings modifier image tag                                                                                                                        | `11-debian-11-r131`     |
| `sysctlImage.digest`                   | Kernel settings modifier image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                  | `""`                    |
| `sysctlImage.pullPolicy`               | Kernel settings modifier image pull policy                                                                                                                | `IfNotPresent`          |
| `sysctlImage.pullSecrets`              | Kernel settings modifier image pull secrets                                                                                                               | `[]`                    |
| `sysctlImage.resources.limits`         | The resources limits for the container                                                                                                                    | `{}`                    |
| `sysctlImage.resources.requests`       | The requested resources for the container                                                                                                                 | `{}`                    |

### Opensearch Dashborads Parameters

| Name                                                     | Description                                                                                                                                                            | Value                           |
| -------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------- |
| `dashboards.enabled`                                     | Enables Opensearch Dashboards deployment                                                                                                                               | `false`                         |
| `dashboards.image.registry`                              | Opensearch Dashboards image registry                                                                                                                                   | `docker.io`                     |
| `dashboards.image.repository`                            | Opensearch Dashboards image repository                                                                                                                                 | `bitnami/opensearch-dashboards` |
| `dashboards.image.tag`                                   | Opensearch Dashboards image tag (immutable tags are recommended)                                                                                                       | `2.8.0-debian-11-r0`            |
| `dashboards.image.digest`                                | Opensearch Dashboards image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                  | `""`                            |
| `dashboards.image.pullPolicy`                            | Opensearch Dashboards image pull policy                                                                                                                                | `IfNotPresent`                  |
| `dashboards.image.pullSecrets`                           | Opensearch Dashboards image pull secrets                                                                                                                               | `[]`                            |
| `dashboards.image.debug`                                 | Enable Opensearch Dashboards image debug mode                                                                                                                          | `false`                         |
| `dashboards.service.type`                                | Opensearch Dashboards service type                                                                                                                                     | `ClusterIP`                     |
| `dashboards.service.ports.http`                          | Opensearch Dashboards service web UI port                                                                                                                              | `5601`                          |
| `dashboards.service.nodePorts.http`                      | Node port for web UI                                                                                                                                                   | `""`                            |
| `dashboards.service.clusterIP`                           | Opensearch Dashboards service Cluster IP                                                                                                                               | `""`                            |
| `dashboards.service.loadBalancerIP`                      | Opensearch Dashboards service Load Balancer IP                                                                                                                         | `""`                            |
| `dashboards.service.loadBalancerSourceRanges`            | Opensearch Dashboards service Load Balancer sources                                                                                                                    | `[]`                            |
| `dashboards.service.externalTrafficPolicy`               | Opensearch Dashboards service external traffic policy                                                                                                                  | `Cluster`                       |
| `dashboards.service.annotations`                         | Additional custom annotations for Opensearch Dashboards service                                                                                                        | `{}`                            |
| `dashboards.service.extraPorts`                          | Extra ports to expose in Opensearch Dashboards service (normally used with the `sidecars` value)                                                                       | `[]`                            |
| `dashboards.service.sessionAffinity`                     | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                                                                                                   | `None`                          |
| `dashboards.service.sessionAffinityConfig`               | Additional settings for the sessionAffinity                                                                                                                            | `{}`                            |
| `dashboards.containerPorts.http`                         | Opensearch Dashboards HTTP port                                                                                                                                        | `5601`                          |
| `dashboards.password`                                    | Password for Opensearch Dashboards                                                                                                                                     | `""`                            |
| `dashboards.replicaCount`                                | Number of data-only replicas to deploy                                                                                                                                 | `1`                             |
| `dashboards.pdb.create`                                  | Enable/disable a Pod Disruption Budget creation                                                                                                                        | `false`                         |
| `dashboards.pdb.minAvailable`                            | Minimum number/percentage of pods that should remain scheduled                                                                                                         | `1`                             |
| `dashboards.pdb.maxUnavailable`                          | Maximum number/percentage of pods that may be made unavailable                                                                                                         | `""`                            |
| `dashboards.nameOverride`                                | String to partially override opensearch.dashboards.fullname                                                                                                            | `""`                            |
| `dashboards.fullnameOverride`                            | String to fully override opensearch.dashboards.fullname                                                                                                                | `""`                            |
| `dashboards.servicenameOverride`                         | String to fully override opensearch.dashboards.servicename                                                                                                             | `""`                            |
| `dashboards.updateStrategy.type`                         | Data-only nodes statefulset stategy type                                                                                                                               | `RollingUpdate`                 |
| `dashboards.resources.limits`                            | The resources limits for the data containers                                                                                                                           | `{}`                            |
| `dashboards.resources.requests`                          | The requested resources for the data containers                                                                                                                        | `{}`                            |
| `dashboards.heapSize`                                    | Opensearch data node heap size.                                                                                                                                        | `1024m`                         |
| `dashboards.podSecurityContext.enabled`                  | Enabled data pods' Security Context                                                                                                                                    | `true`                          |
| `dashboards.podSecurityContext.fsGroup`                  | Set dashboards pod's Security Context fsGroup                                                                                                                          | `1001`                          |
| `dashboards.podSecurityContext.seccompProfile.type`      | Set Proxy container's Security Context seccomp profile                                                                                                                 | `RuntimeDefault`                |
| `dashboards.containerSecurityContext.enabled`            | Enabled data containers' Security Context                                                                                                                              | `true`                          |
| `dashboards.containerSecurityContext.runAsUser`          | Set data containers' Security Context runAsUser                                                                                                                        | `1001`                          |
| `dashboards.containerSecurityContext.runAsNonRoot`       | Set data containers' Security Context runAsNonRoot                                                                                                                     | `true`                          |
| `dashboards.containerSecurityContext.capabilities.drop`  | Set APISIX container's Security Context runAsNonRoot                                                                                                                   | `["ALL"]`                       |
| `dashboards.hostAliases`                                 | data pods host aliases                                                                                                                                                 | `[]`                            |
| `dashboards.podLabels`                                   | Extra labels for data pods                                                                                                                                             | `{}`                            |
| `dashboards.podAnnotations`                              | Annotations for data pods                                                                                                                                              | `{}`                            |
| `dashboards.podAffinityPreset`                           | Pod affinity preset. Ignored if `dashboards.affinity` is set. Allowed values: `soft` or `hard`                                                                         | `""`                            |
| `dashboards.podAntiAffinityPreset`                       | Pod anti-affinity preset. Ignored if `dashboards.affinity` is set. Allowed values: `soft` or `hard`                                                                    | `""`                            |
| `dashboards.nodeAffinityPreset.type`                     | Node affinity preset type. Ignored if `dashboards.affinity` is set. Allowed values: `soft` or `hard`                                                                   | `""`                            |
| `dashboards.nodeAffinityPreset.key`                      | Node label key to match. Ignored if `dashboards.affinity` is set                                                                                                       | `""`                            |
| `dashboards.nodeAffinityPreset.values`                   | Node label values to match. Ignored if `dashboards.affinity` is set                                                                                                    | `[]`                            |
| `dashboards.affinity`                                    | Affinity for data pods assignment                                                                                                                                      | `{}`                            |
| `dashboards.nodeSelector`                                | Node labels for data pods assignment                                                                                                                                   | `{}`                            |
| `dashboards.tolerations`                                 | Tolerations for data pods assignment                                                                                                                                   | `[]`                            |
| `dashboards.priorityClassName`                           | data pods' priorityClassName                                                                                                                                           | `""`                            |
| `dashboards.schedulerName`                               | Name of the k8s scheduler (other than default) for data pods                                                                                                           | `""`                            |
| `dashboards.terminationGracePeriodSeconds`               | In seconds, time the given to the Opensearch data pod needs to terminate gracefully                                                                                    | `""`                            |
| `dashboards.topologySpreadConstraints`                   | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template                                               | `[]`                            |
| `dashboards.startupProbe.enabled`                        | Enable/disable the startup probe (data nodes pod)                                                                                                                      | `false`                         |
| `dashboards.startupProbe.initialDelaySeconds`            | Delay before startup probe is initiated (data nodes pod)                                                                                                               | `120`                           |
| `dashboards.startupProbe.periodSeconds`                  | How often to perform the probe (data nodes pod)                                                                                                                        | `10`                            |
| `dashboards.startupProbe.timeoutSeconds`                 | When the probe times out (data nodes pod)                                                                                                                              | `5`                             |
| `dashboards.startupProbe.successThreshold`               | Minimum consecutive successes for the probe to be considered successful after having failed (data nodes pod)                                                           | `1`                             |
| `dashboards.startupProbe.failureThreshold`               | Minimum consecutive failures for the probe to be considered failed after having succeeded                                                                              | `5`                             |
| `dashboards.livenessProbe.enabled`                       | Enable/disable the liveness probe (data nodes pod)                                                                                                                     | `true`                          |
| `dashboards.livenessProbe.initialDelaySeconds`           | Delay before liveness probe is initiated (data nodes pod)                                                                                                              | `120`                           |
| `dashboards.livenessProbe.periodSeconds`                 | How often to perform the probe (data nodes pod)                                                                                                                        | `10`                            |
| `dashboards.livenessProbe.timeoutSeconds`                | When the probe times out (data nodes pod)                                                                                                                              | `5`                             |
| `dashboards.livenessProbe.successThreshold`              | Minimum consecutive successes for the probe to be considered successful after having failed (data nodes pod)                                                           | `1`                             |
| `dashboards.livenessProbe.failureThreshold`              | Minimum consecutive failures for the probe to be considered failed after having succeeded                                                                              | `5`                             |
| `dashboards.readinessProbe.enabled`                      | Enable/disable the readiness probe (data nodes pod)                                                                                                                    | `true`                          |
| `dashboards.readinessProbe.initialDelaySeconds`          | Delay before readiness probe is initiated (data nodes pod)                                                                                                             | `120`                           |
| `dashboards.readinessProbe.periodSeconds`                | How often to perform the probe (data nodes pod)                                                                                                                        | `10`                            |
| `dashboards.readinessProbe.timeoutSeconds`               | When the probe times out (data nodes pod)                                                                                                                              | `5`                             |
| `dashboards.readinessProbe.successThreshold`             | Minimum consecutive successes for the probe to be considered successful after having failed (data nodes pod)                                                           | `1`                             |
| `dashboards.readinessProbe.failureThreshold`             | Minimum consecutive failures for the probe to be considered failed after having succeeded                                                                              | `5`                             |
| `dashboards.customStartupProbe`                          | Override default startup probe                                                                                                                                         | `{}`                            |
| `dashboards.customLivenessProbe`                         | Override default liveness probe                                                                                                                                        | `{}`                            |
| `dashboards.customReadinessProbe`                        | Override default readiness probe                                                                                                                                       | `{}`                            |
| `dashboards.command`                                     | Override default container command (useful when using custom images)                                                                                                   | `[]`                            |
| `dashboards.args`                                        | Override default container args (useful when using custom images)                                                                                                      | `[]`                            |
| `dashboards.lifecycleHooks`                              | for the data container(s) to automate configuration before or after startup                                                                                            | `{}`                            |
| `dashboards.extraEnvVars`                                | Array with extra environment variables to add to data nodes                                                                                                            | `[]`                            |
| `dashboards.extraEnvVarsCM`                              | Name of existing ConfigMap containing extra env vars for data nodes                                                                                                    | `""`                            |
| `dashboards.extraEnvVarsSecret`                          | Name of existing Secret containing extra env vars for data nodes                                                                                                       | `""`                            |
| `dashboards.extraVolumes`                                | Optionally specify extra list of additional volumes for the data pod(s)                                                                                                | `[]`                            |
| `dashboards.extraVolumeMounts`                           | Optionally specify extra list of additional volumeMounts for the data container(s)                                                                                     | `[]`                            |
| `dashboards.sidecars`                                    | Add additional sidecar containers to the data pod(s)                                                                                                                   | `[]`                            |
| `dashboards.initContainers`                              | Add additional init containers to the data pod(s)                                                                                                                      | `[]`                            |
| `dashboards.serviceAccount.create`                       | Specifies whether a ServiceAccount should be created                                                                                                                   | `false`                         |
| `dashboards.serviceAccount.name`                         | Name of the service account to use. If not set and create is true, a name is generated using the fullname template.                                                    | `""`                            |
| `dashboards.serviceAccount.automountServiceAccountToken` | Automount service account token for the server service account                                                                                                         | `false`                         |
| `dashboards.serviceAccount.annotations`                  | Annotations for service account. Evaluated as a template. Only used if `create` is `true`.                                                                             | `{}`                            |
| `dashboards.networkPolicy.enabled`                       | Enable creation of NetworkPolicy resources                                                                                                                             | `false`                         |
| `dashboards.networkPolicy.allowExternal`                 | The Policy model to apply                                                                                                                                              | `true`                          |
| `dashboards.networkPolicy.extraIngress`                  | Add extra ingress rules to the NetworkPolicy                                                                                                                           | `[]`                            |
| `dashboards.networkPolicy.extraEgress`                   | Add extra ingress rules to the NetworkPolicy                                                                                                                           | `[]`                            |
| `dashboards.networkPolicy.ingressNSMatchLabels`          | Labels to match to allow traffic from other namespaces                                                                                                                 | `{}`                            |
| `dashboards.networkPolicy.ingressNSPodMatchLabels`       | Pod labels to match to allow traffic from other namespaces                                                                                                             | `{}`                            |
| `dashboards.autoscaling.vpa.enabled`                     | Enable VPA                                                                                                                                                             | `false`                         |
| `dashboards.autoscaling.vpa.annotations`                 | Annotations for VPA resource                                                                                                                                           | `{}`                            |
| `dashboards.autoscaling.vpa.controlledResources`         | VPA List of resources that the vertical pod autoscaler can control. Defaults to cpu and memory                                                                         | `[]`                            |
| `dashboards.autoscaling.vpa.maxAllowed`                  | VPA Max allowed resources for the pod                                                                                                                                  | `{}`                            |
| `dashboards.autoscaling.vpa.minAllowed`                  | VPA Min allowed resources for the pod                                                                                                                                  | `{}`                            |
| `dashboards.autoscaling.vpa.updatePolicy.updateMode`     | Autoscaling update policy Specifies whether recommended updates are applied when a Pod is started and whether recommended updates are applied during the life of a Pod | `Auto`                          |
| `dashboards.autoscaling.hpa.enabled`                     | Enable HPA for APISIX Data Plane                                                                                                                                       | `false`                         |
| `dashboards.autoscaling.hpa.minReplicas`                 | Minimum number of APISIX Data Plane replicas                                                                                                                           | `3`                             |
| `dashboards.autoscaling.hpa.maxReplicas`                 | Maximum number of APISIX Data Plane replicas                                                                                                                           | `11`                            |
| `dashboards.autoscaling.hpa.targetCPU`                   | Target CPU utilization percentage                                                                                                                                      | `""`                            |
| `dashboards.autoscaling.hpa.targetMemory`                | Target Memory utilization percentage                                                                                                                                   | `""`                            |
| `dashboards.tls.enabled`                                 | Enable TLS for Opensearch Dashboards webserver                                                                                                                         | `false`                         |
| `dashboards.tls.existingSecret`                          | Existing secret containing the certificates for Opensearch Dashboards webserver                                                                                        | `""`                            |
| `dashboards.tls.autoGenerated`                           | Create self-signed TLS certificates.                                                                                                                                   | `true`                          |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
  --set name=my-open,client.service.port=8080 \
  oci://registry-1.docker.io/bitnamicharts/opensearch
```

The above command sets the Opensearch cluster name to `my-open` and REST port number to `8080`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml oci://registry-1.docker.io/bitnamicharts/opensearch
```

> **Tip**: You can use the default [values.yaml](values.yaml).

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Change OpenSearch version

To modify the OpenSearch version used in this chart you can specify a [valid image tag](https://hub.docker.com/r/bitnami/opensearch/tags/) using the `image.tag` parameter. For example, `image.tag=X.Y.Z`. This approach is also applicable to other images like exporters.

### Default kernel settings

Currently, Opensearch requires some changes in the kernel of the host machine to work as expected. If those values are not set in the underlying operating system, the OS containers fail to boot with ERROR messages. More information about these requirements can be found in the links below:

- [File Descriptor requirements](https://www.open.co/guide/en/opensearch/reference/current/file-descriptors.html)
- [Virtual memory requirements](https://www.open.co/guide/en/opensearch/reference/current/vm-max-map-count.html)

This chart uses a **privileged** initContainer to change those settings in the Kernel by running: `sysctl -w vm.max_map_count=262144 && sysctl -w fs.file-max=65536`.
You can disable the initContainer using the `sysctlImage.enabled=false` parameter.

### Enable bundled Kibana

This Opensearch chart contains Kibana as subchart, you can enable it just setting the `global.kibanaEnabled=true` parameter.
To see the notes with some operational instructions from the Kibana chart, please use the `--render-subchart-notes` as part of your `helm install` command, in this way you can see the Kibana and OS notes in your terminal.

When enabling the bundled kibana subchart, there are a few gotchas that you should be aware of listed below.

#### Opensearch rest Encryption

When enabling opensearch' rest endpoint encryption you will also need to set `kibana.opensearch.security.tls.enabled` to the SAME value along with some additional values shown below for an "out of the box experience":

```yaml
security:
  enabled: true
  # PASSWORD must be the same value passed to opensearch to get an "out of the box" experience
  openPassword: "<PASSWORD>"
  tls:
    # AutoGenerate TLS certs for open
    autoGenerated: true

kibana:
  opensearch:
    security:
      auth:
        enabled: true
        # default in the opensearch chart is open
        kibanaUsername: "<USERNAME>"
        kibanaPassword: "<PASSWORD>"
      tls:
        # Instruct kibana to connect to open over https
        enabled: true
        # Bit of a catch 22, as you will need to know the name upfront of your release
        existingSecret: RELEASENAME-opensearch-coordinating-crt # or just 'opensearch-coordinating-crt' if the release name happens to be 'opensearch'
        # As the certs are auto-generated, they are pemCerts so set to true
        usePemCerts: true
```

At a bare-minimum, when working with kibana and opensearch together the following values MUST be the same, otherwise things will fail:

```yaml
security:
  tls:
    restEncryption: true

# assumes global.kibanaEnabled=true
kibana:
  opensearch:
    security:
      tls:
        enabled: true
```

### Adding extra environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `extraEnvVars` property.

```yaml
extraEnvVars:
  - name: OPENSEARCH_VERSION
    value: 7.0
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values.

### Using custom init scripts

For advanced operations, the Bitnami Opensearch charts allows using custom init scripts that will be mounted inside `/docker-entrypoint.init-db`. You can include the file directly in your `values.yaml` with `initScripts`, or use a ConfigMap or a Secret (in case of sensitive data) for mounting these extra scripts. In this case you use the `initScriptsCM` and `initScriptsSecret` values.

```console
initScriptsCM=special-scripts
initScriptsSecret=special-scripts-sensitive
```

### Snapshot and restore operations

As it's described in the [official documentation](https://www.open.co/guide/en/opensearch/reference/current/snapshots-register-repository.html#snapshots-filesystem-repository), it's necessary to register a snapshot repository before you can perform snapshot and restore operations.

This chart allows you to configure Opensearch to use a shared file system to store snapshots. To do so, you need to mount a RWX volume on every Opensearch node, and set the parameter `snapshotRepoPath` with the path where the volume is mounted. In the example below, you can find the values to set when using a NFS Perstitent Volume:

```yaml
extraVolumes:
  - name: snapshot-repository
    nfs:
      server: nfs.example.com # Please change this to your NFS server
      path: /share1
extraVolumeMounts:
  - name: snapshot-repository
    mountPath: /snapshots
snapshotRepoPath: "/snapshots"
```

### Sidecars and Init Containers

If you have a need for additional containers to run within the same pod as Opensearch components (e.g. an additional metrics or logging exporter), you can do so via the `XXX.sidecars` parameter(s), where XXX is placeholder you need to replace with the actual component(s). Simply define your container according to the Kubernetes container spec.

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
```

### Setting Pod's affinity

This chart allows you to set your custom affinity using the `XXX.affinity` parameter(s). Find more information about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities) chart. To do so, set the `XXX.podAffinityPreset`, `XXX.podAntiAffinityPreset`, or `XXX.nodeAffinityPreset` parameters.

## Persistence

The [Bitnami Opensearch](https://github.com/bitnami/containers/tree/main/bitnami/opensearch) image stores the Opensearch data at the `/bitnami/opensearch/data` path of the container.

By default, the chart mounts a [Persistent Volume](https://kubernetes.io/docs/concepts/storage/persistent-volumes/) at this location. The volume is created using dynamic volume provisioning. See the [Parameters](#parameters) section to configure the PVC.

### Adjust permissions of persistent volume mountpoint

As the image run as non-root by default, it is necessary to adjust the ownership of the persistent volume so that the container can write data into it.

By default, the chart is configured to use Kubernetes Security Context to automatically change the ownership of the volume. However, this feature does not work in all Kubernetes distributions.
As an alternative, this chart supports using an initContainer to change the ownership of the volume before mounting it in the final destination.

You can enable this initContainer by setting `volumePermissions.enabled` to `true`.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## License

Copyright &copy; 2023 VMware, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

<http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
