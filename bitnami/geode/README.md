<!--- app-name: Apache Geode -->

# Apache Geode packaged by Bitnami

Apache Geode is a data management platform that provides advanced capabilities for data-intensive applications.

[Overview of Apache Geode](https://geode.apache.org/)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.
                           
## TL;DR

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/geode
```

## Introduction

This chart bootstraps an [Apache Geode](https://github.com/bitnami/containers/tree/main/bitnami/geode) cluster on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release bitnami/geode
```

The command deploys geode on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

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
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden) | `false`         |
| `diagnosticMode.command` | Command to override all containers in the deployment                                    | `["sleep"]`     |
| `diagnosticMode.args`    | Args to override all containers in the deployment                                       | `["infinity"]`  |


### Apache Geode Common parameters

| Name                                     | Description                                                                                                  | Value                                                       |
| ---------------------------------------- | ------------------------------------------------------------------------------------------------------------ | ----------------------------------------------------------- |
| `image.registry`                         | Apache Geode image registry                                                                                  | `docker.io`                                                 |
| `image.repository`                       | Apache Geode image repository                                                                                | `bitnami/geode`                                             |
| `image.tag`                              | Apache Geode image tag (immutable tags are recommended)                                                      | `1.15.0-debian-11-r17`                                      |
| `image.digest`                           | Apache Geode image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag | `""`                                                        |
| `image.pullPolicy`                       | Apache Geode image pull policy                                                                               | `IfNotPresent`                                              |
| `image.pullSecrets`                      | Apache Geode image pull secrets                                                                              | `[]`                                                        |
| `image.debug`                            | Enable Apache Geode image debug mode                                                                         | `false`                                                     |
| `groups`                                 | List of Apache Geode member groups to belong to                                                              | `[]`                                                        |
| `auth.enabled`                           | Enable Apache Geode security                                                                                 | `true`                                                      |
| `auth.securityManager`                   | Fully qualified name of the class that implements the SecurityManager interface                              | `org.apache.geode.examples.security.ExampleSecurityManager` |
| `auth.username`                          | Username credential to use to connect with locators                                                          | `admin`                                                     |
| `auth.password`                          | Password credential to use to connect with locators                                                          | `""`                                                        |
| `auth.existingSecret`                    | Name of the existing secret containing to use to connect with locators                                       | `""`                                                        |
| `auth.tls.enabled`                       | Enable TLS authentication                                                                                    | `false`                                                     |
| `auth.tls.components`                    | List of components for which to enable TLS                                                                   | `[]`                                                        |
| `auth.tls.autoGenerated`                 | Generate automatically self-signed TLS certificates. Currently only supports PEM certificates                | `false`                                                     |
| `auth.tls.existingSecret`                | Name of the existing secret containing the TLS certificates for the Apache Geode nodes                       | `""`                                                        |
| `auth.tls.usePem`                        | Use PEM certificates as input instead of PKS12/JKS stores                                                    | `false`                                                     |
| `auth.tls.keystorePassword`              | Password to access they key stores when they are password-protected                                          | `""`                                                        |
| `auth.tls.truststorePassword`            | Password to access they trust store when it is password-protected                                            | `""`                                                        |
| `auth.tls.passwordsSecretName`           | Set the name of the secret that contains the passwords for the certificate files                             | `""`                                                        |
| `auth.tls.requireAuthentication`         | Enable two-way authentication                                                                                | `false`                                                     |
| `auth.tls.endpointIdentificationEnabled` | Enable server hostname validation using server certificates                                                  | `false`                                                     |
| `auth.tls.resources.limits`              | The resources limits for the TLS init container                                                              | `{}`                                                        |
| `auth.tls.resources.requests`            | The requested resources for the TLS init container                                                           | `{}`                                                        |


### Apache Geode Locator parameters

| Name                                            | Description                                                                                                 | Value               |
| ----------------------------------------------- | ----------------------------------------------------------------------------------------------------------- | ------------------- |
| `locator.logLevel`                              | Log level for Locator nodes                                                                                 | `info`              |
| `locator.initialHeapSize`                       | Initial size of the heap on Locator nodes                                                                   | `""`                |
| `locator.maxHeapSize`                           | Maximum size of the heap on Locator nodes                                                                   | `""`                |
| `locator.configuration`                         | Specify content for gemfire.properties on Locator nodes (auto-generated based on other env. vars otherwise) | `""`                |
| `locator.existingConfigmap`                     | The name of an existing ConfigMap with your custom configuration for Locator                                | `""`                |
| `locator.log4j`                                 | Specify content for log4j2.xml on Locator nodes (optional)                                                  | `""`                |
| `locator.existingLog4jConfigMap`                | Name of existing ConfigMap containing a custom log4j2.xml configuration for Locator                         | `""`                |
| `locator.replicaCount`                          | Number of Locator replicas to deploy                                                                        | `2`                 |
| `locator.podManagementPolicy`                   | Locator statefulset Pod Management Policy Type                                                              | `OrderedReady`      |
| `locator.containerPorts.locator`                | Locator multicast container port                                                                            | `10334`             |
| `locator.containerPorts.http`                   | Locator HTTP container port                                                                                 | `7070`              |
| `locator.containerPorts.rmi`                    | Locator RMI container port                                                                                  | `1099`              |
| `locator.containerPorts.metrics`                | Locator internal metrics container port                                                                     | `9915`              |
| `locator.livenessProbe.enabled`                 | Enable livenessProbe on Locator containers                                                                  | `true`              |
| `locator.livenessProbe.initialDelaySeconds`     | Initial delay seconds for livenessProbe                                                                     | `30`                |
| `locator.livenessProbe.periodSeconds`           | Period seconds for livenessProbe                                                                            | `10`                |
| `locator.livenessProbe.timeoutSeconds`          | Timeout seconds for livenessProbe                                                                           | `10`                |
| `locator.livenessProbe.failureThreshold`        | Failure threshold for livenessProbe                                                                         | `3`                 |
| `locator.livenessProbe.successThreshold`        | Success threshold for livenessProbe                                                                         | `1`                 |
| `locator.readinessProbe.enabled`                | Enable readinessProbe on Locator containers                                                                 | `true`              |
| `locator.readinessProbe.initialDelaySeconds`    | Initial delay seconds for readinessProbe                                                                    | `30`                |
| `locator.readinessProbe.periodSeconds`          | Period seconds for readinessProbe                                                                           | `10`                |
| `locator.readinessProbe.timeoutSeconds`         | Timeout seconds for readinessProbe                                                                          | `10`                |
| `locator.readinessProbe.failureThreshold`       | Failure threshold for readinessProbe                                                                        | `3`                 |
| `locator.readinessProbe.successThreshold`       | Success threshold for readinessProbe                                                                        | `1`                 |
| `locator.startupProbe.enabled`                  | Enable startupProbe on Locator containers                                                                   | `false`             |
| `locator.startupProbe.initialDelaySeconds`      | Initial delay seconds for startupProbe                                                                      | `30`                |
| `locator.startupProbe.periodSeconds`            | Period seconds for startupProbe                                                                             | `10`                |
| `locator.startupProbe.timeoutSeconds`           | Timeout seconds for startupProbe                                                                            | `1`                 |
| `locator.startupProbe.failureThreshold`         | Failure threshold for startupProbe                                                                          | `15`                |
| `locator.startupProbe.successThreshold`         | Success threshold for startupProbe                                                                          | `1`                 |
| `locator.customLivenessProbe`                   | Custom livenessProbe that overrides the default one                                                         | `{}`                |
| `locator.customReadinessProbe`                  | Custom readinessProbe that overrides the default one                                                        | `{}`                |
| `locator.customStartupProbe`                    | Custom startupProbe that overrides the default one                                                          | `{}`                |
| `locator.resources.limits`                      | The resources limits for the Locator containers                                                             | `{}`                |
| `locator.resources.requests`                    | The requested resources for the Locator containers                                                          | `{}`                |
| `locator.podSecurityContext.enabled`            | Enabled Locator pods' Security Context                                                                      | `true`              |
| `locator.podSecurityContext.fsGroup`            | Set Locator pod's Security Context fsGroup                                                                  | `1001`              |
| `locator.podSecurityContext.sysctls`            | List of namespaced sysctls used for the Locator pods                                                        | `[]`                |
| `locator.containerSecurityContext.enabled`      | Enabled Locator containers' Security Context                                                                | `true`              |
| `locator.containerSecurityContext.runAsUser`    | Set Locator containers' Security Context runAsUser                                                          | `1001`              |
| `locator.containerSecurityContext.runAsNonRoot` | Set Locator containers' Security Context runAsNonRoot                                                       | `true`              |
| `locator.command`                               | Override default container command (useful when using custom images)                                        | `[]`                |
| `locator.args`                                  | Override default container args (useful when using custom images)                                           | `[]`                |
| `locator.hostAliases`                           | Locator pods host aliases                                                                                   | `[]`                |
| `locator.podLabels`                             | Extra labels for Locator pods                                                                               | `{}`                |
| `locator.podAnnotations`                        | Annotations for Locator pods                                                                                | `{}`                |
| `locator.podAffinityPreset`                     | Pod affinity preset. Ignored if `locator.affinity` is set. Allowed values: `soft` or `hard`                 | `""`                |
| `locator.podAntiAffinityPreset`                 | Pod anti-affinity preset. Ignored if `locator.affinity` is set. Allowed values: `soft` or `hard`            | `soft`              |
| `locator.nodeAffinityPreset.type`               | Node affinity preset type. Ignored if `locator.affinity` is set. Allowed values: `soft` or `hard`           | `""`                |
| `locator.nodeAffinityPreset.key`                | Node label key to match. Ignored if `locator.affinity` is set                                               | `""`                |
| `locator.nodeAffinityPreset.values`             | Node label values to match. Ignored if `locator.affinity` is set                                            | `[]`                |
| `locator.affinity`                              | Affinity for Locator pods assignment                                                                        | `{}`                |
| `locator.nodeSelector`                          | Node labels for Locator pods assignment                                                                     | `{}`                |
| `locator.tolerations`                           | Tolerations for Locator pods assignment                                                                     | `[]`                |
| `locator.terminationGracePeriodSeconds`         | In seconds, time the given to the Locator pod needs to terminate gracefully                                 | `""`                |
| `locator.topologySpreadConstraints`             | Topology Spread Constraints for Locator pods assignment spread across your cluster among failure-domains    | `[]`                |
| `locator.updateStrategy.type`                   | Locator statefulset strategy type                                                                           | `RollingUpdate`     |
| `locator.priorityClassName`                     | Locator pods' priorityClassName                                                                             | `""`                |
| `locator.schedulerName`                         | Name of the k8s scheduler (other than default) for Locator pods                                             | `""`                |
| `locator.lifecycleHooks`                        | for the Locator container(s) to automate configuration before or after startup                              | `{}`                |
| `locator.extraFlags`                            | Additional command line flags to start Locator nodes                                                        | `[]`                |
| `locator.extraEnvVars`                          | Array with extra environment variables to add to Locator nodes                                              | `[]`                |
| `locator.extraEnvVarsCM`                        | Name of existing ConfigMap containing extra env vars for Locator nodes                                      | `""`                |
| `locator.extraEnvVarsSecret`                    | Name of existing Secret containing extra env vars for Locator nodes                                         | `""`                |
| `locator.extraVolumes`                          | Optionally specify extra list of additional volumes for the Locator pod(s)                                  | `[]`                |
| `locator.extraVolumeMounts`                     | Optionally specify extra list of additional volumeMounts for the Locator container(s)                       | `[]`                |
| `locator.sidecars`                              | Add additional sidecar containers to the Locator pod(s)                                                     | `[]`                |
| `locator.initContainers`                        | Add additional init containers to the Locator pod(s)                                                        | `[]`                |
| `locator.service.type`                          | Locator service type                                                                                        | `ClusterIP`         |
| `locator.service.ports.locator`                 | Locator multicast service port                                                                              | `10334`             |
| `locator.service.ports.http`                    | Locator HTTP service port                                                                                   | `7070`              |
| `locator.service.ports.rmi`                     | Locator RMI service port                                                                                    | `1099`              |
| `locator.service.nodePorts.locator`             | Node port for multicast                                                                                     | `""`                |
| `locator.service.nodePorts.http`                | Node port for HTTP                                                                                          | `""`                |
| `locator.service.sessionAffinity`               | Control where client requests go, to the same pod or round-robin                                            | `None`              |
| `locator.service.sessionAffinityConfig`         | Additional settings for the sessionAffinity                                                                 | `{}`                |
| `locator.service.clusterIP`                     | Locator service Cluster IP                                                                                  | `""`                |
| `locator.service.loadBalancerIP`                | Locator service Load Balancer IP                                                                            | `""`                |
| `locator.service.loadBalancerSourceRanges`      | Locator service Load Balancer sources                                                                       | `[]`                |
| `locator.service.externalTrafficPolicy`         | Locator service external traffic policy                                                                     | `Cluster`           |
| `locator.service.annotations`                   | Additional custom annotations for Locator service                                                           | `{}`                |
| `locator.service.extraPorts`                    | Extra ports to expose in the Locator service (normally used with the `sidecar` value)                       | `[]`                |
| `locator.persistence.enabled`                   | Enable persistence on Locator replicas using a `PersistentVolumeClaim`                                      | `true`              |
| `locator.persistence.storageClass`              | MariaDB secondary persistent volume storage Class                                                           | `""`                |
| `locator.persistence.annotations`               | MariaDB secondary persistent volume claim annotations                                                       | `{}`                |
| `locator.persistence.accessModes`               | MariaDB secondary persistent volume access Modes                                                            | `["ReadWriteOnce"]` |
| `locator.persistence.size`                      | MariaDB secondary persistent volume size                                                                    | `8Gi`               |


### Apache Geode Cache Server parameters

| Name                                             | Description                                                                                                                                 | Value               |
| ------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------- | ------------------- |
| `server.logLevel`                                | Log level for Cache Server nodes                                                                                                            | `info`              |
| `server.initialHeapSize`                         | Initial size of the heap on Cache Server nodes                                                                                              | `""`                |
| `server.maxHeapSize`                             | Maximum size of the heap on Cache Server nodes                                                                                              | `""`                |
| `server.configuration`                           | Specify content for gemfire.properties on Cache server nodes (auto-generated based on other env. vars otherwise)                            | `""`                |
| `server.existingConfigmap`                       | The name of an existing ConfigMap with your custom configuration for Cache server                                                           | `""`                |
| `server.log4j`                                   | Specify content for log4j2.xml on Cache server nodes (optional)                                                                             | `""`                |
| `server.existingLog4jConfigMap`                  | Name of existing ConfigMap containing a custom log4j2.xml configuration for Cache server                                                    | `""`                |
| `server.restoreRedundancyOnContainerTermination` | Use a PreStop hook on container termination to restore redundancy to partitioned regions and reassign which members host the primary copies | `true`              |
| `server.replicaCount`                            | Number of Cache Server replicas to deploy                                                                                                   | `3`                 |
| `server.podManagementPolicy`                     | Cache Server statefulset Pod Management Policy Type                                                                                         | `OrderedReady`      |
| `server.containerPorts.server`                   | Cache Server container port                                                                                                                 | `40404`             |
| `server.containerPorts.http`                     | Cache Server HTTP container port                                                                                                            | `7070`              |
| `server.containerPorts.rmi`                      | Cache Server RMI container port                                                                                                             | `1099`              |
| `server.containerPorts.metrics`                  | Cache Server internal metrics container port                                                                                                | `9915`              |
| `server.livenessProbe.enabled`                   | Enable livenessProbe on Cache server containers                                                                                             | `true`              |
| `server.livenessProbe.initialDelaySeconds`       | Initial delay seconds for livenessProbe                                                                                                     | `40`                |
| `server.livenessProbe.periodSeconds`             | Period seconds for livenessProbe                                                                                                            | `10`                |
| `server.livenessProbe.timeoutSeconds`            | Timeout seconds for livenessProbe                                                                                                           | `10`                |
| `server.livenessProbe.failureThreshold`          | Failure threshold for livenessProbe                                                                                                         | `3`                 |
| `server.livenessProbe.successThreshold`          | Success threshold for livenessProbe                                                                                                         | `1`                 |
| `server.readinessProbe.enabled`                  | Enable readinessProbe on Cache server containers                                                                                            | `true`              |
| `server.readinessProbe.initialDelaySeconds`      | Initial delay seconds for readinessProbe                                                                                                    | `40`                |
| `server.readinessProbe.periodSeconds`            | Period seconds for readinessProbe                                                                                                           | `10`                |
| `server.readinessProbe.timeoutSeconds`           | Timeout seconds for readinessProbe                                                                                                          | `10`                |
| `server.readinessProbe.failureThreshold`         | Failure threshold for readinessProbe                                                                                                        | `3`                 |
| `server.readinessProbe.successThreshold`         | Success threshold for readinessProbe                                                                                                        | `1`                 |
| `server.startupProbe.enabled`                    | Enable startupProbe on Cache server containers                                                                                              | `false`             |
| `server.startupProbe.initialDelaySeconds`        | Initial delay seconds for startupProbe                                                                                                      | `45`                |
| `server.startupProbe.periodSeconds`              | Period seconds for startupProbe                                                                                                             | `10`                |
| `server.startupProbe.timeoutSeconds`             | Timeout seconds for startupProbe                                                                                                            | `1`                 |
| `server.startupProbe.failureThreshold`           | Failure threshold for startupProbe                                                                                                          | `15`                |
| `server.startupProbe.successThreshold`           | Success threshold for startupProbe                                                                                                          | `1`                 |
| `server.customLivenessProbe`                     | Custom livenessProbe that overrides the default one                                                                                         | `{}`                |
| `server.customReadinessProbe`                    | Custom readinessProbe that overrides the default one                                                                                        | `{}`                |
| `server.customStartupProbe`                      | Custom startupProbe that overrides the default one                                                                                          | `{}`                |
| `server.resources.limits`                        | The resources limits for the Cache server containers                                                                                        | `{}`                |
| `server.resources.requests`                      | The requested resources for the Cache server containers                                                                                     | `{}`                |
| `server.podSecurityContext.enabled`              | Enabled Cache server pods' Security Context                                                                                                 | `true`              |
| `server.podSecurityContext.fsGroup`              | Set Cache server pod's Security Context fsGroup                                                                                             | `1001`              |
| `server.podSecurityContext.sysctls`              | List of namespaced sysctls used for the Cache server pods                                                                                   | `[]`                |
| `server.containerSecurityContext.enabled`        | Enabled Cache server containers' Security Context                                                                                           | `true`              |
| `server.containerSecurityContext.runAsUser`      | Set Cache server containers' Security Context runAsUser                                                                                     | `1001`              |
| `server.containerSecurityContext.runAsNonRoot`   | Set Cache server containers' Security Context runAsNonRoot                                                                                  | `true`              |
| `server.command`                                 | Override default container command (useful when using custom images)                                                                        | `[]`                |
| `server.args`                                    | Override default container args (useful when using custom images)                                                                           | `[]`                |
| `server.hostAliases`                             | Cache server pods host aliases                                                                                                              | `[]`                |
| `server.podLabels`                               | Extra labels for Cache server pods                                                                                                          | `{}`                |
| `server.podAnnotations`                          | Annotations for Cache server pods                                                                                                           | `{}`                |
| `server.podAffinityPreset`                       | Pod affinity preset. Ignored if `server.affinity` is set. Allowed values: `soft` or `hard`                                                  | `""`                |
| `server.podAntiAffinityPreset`                   | Pod anti-affinity preset. Ignored if `server.affinity` is set. Allowed values: `soft` or `hard`                                             | `soft`              |
| `server.nodeAffinityPreset.type`                 | Node affinity preset type. Ignored if `server.affinity` is set. Allowed values: `soft` or `hard`                                            | `""`                |
| `server.nodeAffinityPreset.key`                  | Node label key to match. Ignored if `server.affinity` is set                                                                                | `""`                |
| `server.nodeAffinityPreset.values`               | Node label values to match. Ignored if `server.affinity` is set                                                                             | `[]`                |
| `server.affinity`                                | Affinity for Cache server pods assignment                                                                                                   | `{}`                |
| `server.nodeSelector`                            | Node labels for Cache server pods assignment                                                                                                | `{}`                |
| `server.tolerations`                             | Tolerations for Cache server pods assignment                                                                                                | `[]`                |
| `server.terminationGracePeriodSeconds`           | In seconds, time the given to the Cache server pod needs to terminate gracefully                                                            | `""`                |
| `server.topologySpreadConstraints`               | Topology Spread Constraints for Cache server pods assignment spread across your cluster among failure-domains                               | `[]`                |
| `server.updateStrategy.type`                     | Cache server statefulset strategy type                                                                                                      | `RollingUpdate`     |
| `server.priorityClassName`                       | Cache server pods' priorityClassName                                                                                                        | `""`                |
| `server.schedulerName`                           | Name of the k8s scheduler (other than default) for Cache server pods                                                                        | `""`                |
| `server.lifecycleHooks`                          | for the Cache server container(s) to automate configuration before or after startup                                                         | `{}`                |
| `server.extraFlags`                              | Additional command line flags to start Cache server nodes                                                                                   | `[]`                |
| `server.extraEnvVars`                            | Array with extra environment variables to add to Cache server nodes                                                                         | `[]`                |
| `server.extraEnvVarsCM`                          | Name of existing ConfigMap containing extra env vars for Cache server nodes                                                                 | `""`                |
| `server.extraEnvVarsSecret`                      | Name of existing Secret containing extra env vars for Cache server nodes                                                                    | `""`                |
| `server.extraVolumes`                            | Optionally specify extra list of additional volumes for the Cache server pod(s)                                                             | `[]`                |
| `server.extraVolumeMounts`                       | Optionally specify extra list of additional volumeMounts for the Cache server container(s)                                                  | `[]`                |
| `server.sidecars`                                | Add additional sidecar containers to the Cache server pod(s)                                                                                | `[]`                |
| `server.initContainers`                          | Add additional init containers to the Cache server pod(s)                                                                                   | `[]`                |
| `server.service.ports.server`                    | Cache server multicast service port                                                                                                         | `40404`             |
| `server.service.ports.http`                      | Cache server HTTP service port                                                                                                              | `7070`              |
| `server.service.ports.rmi`                       | Cache server RMI service port                                                                                                               | `1099`              |
| `server.service.annotations`                     | Additional custom annotations for Cache server service                                                                                      | `{}`                |
| `server.persistence.enabled`                     | Enable persistence on Cache server replicas using a `PersistentVolumeClaim`                                                                 | `true`              |
| `server.persistence.storageClass`                | MariaDB secondary persistent volume storage Class                                                                                           | `""`                |
| `server.persistence.annotations`                 | MariaDB secondary persistent volume claim annotations                                                                                       | `{}`                |
| `server.persistence.accessModes`                 | MariaDB secondary persistent volume access Modes                                                                                            | `["ReadWriteOnce"]` |
| `server.persistence.size`                        | MariaDB secondary persistent volume size                                                                                                    | `8Gi`               |


### Traffic Exposure Parameters

| Name                       | Description                                                                                                                      | Value                    |
| -------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `ingress.enabled`          | Enable ingress record generation for Apache Geode                                                                                | `false`                  |
| `ingress.ingressClassName` | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                    | `""`                     |
| `ingress.pathType`         | Ingress path type                                                                                                                | `ImplementationSpecific` |
| `ingress.apiVersion`       | Force Ingress API version (automatically detected if not set)                                                                    | `""`                     |
| `ingress.hostname`         | Default host for the ingress record                                                                                              | `geode.local`            |
| `ingress.path`             | Default path for the ingress record                                                                                              | `/pulse`                 |
| `ingress.annotations`      | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                     |
| `ingress.tls`              | Enable TLS configuration for the host defined at `ingress.hostname` parameter                                                    | `false`                  |
| `ingress.selfSigned`       | Create a TLS secret for this ingress record using self-signed certificates generated by Helm                                     | `false`                  |
| `ingress.extraHosts`       | An array with additional hostname(s) to be covered with the ingress record                                                       | `[]`                     |
| `ingress.extraPaths`       | An array with additional arbitrary paths that may need to be added to the ingress under the main host                            | `[]`                     |
| `ingress.extraTls`         | TLS configuration for additional hostname(s) to be covered with this ingress record                                              | `[]`                     |
| `ingress.secrets`          | Custom TLS certificates as secrets                                                                                               | `[]`                     |
| `ingress.extraRules`       | Additional rules to be covered with this ingress record                                                                          | `[]`                     |


### Init Container Parameters

| Name                                                   | Description                                                                                                   | Value                   |
| ------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------- | ----------------------- |
| `volumePermissions.enabled`                            | Enable init container that changes the owner/group of the PV mount point to `runAsUser:fsGroup`               | `false`                 |
| `volumePermissions.image.registry`                     | Bitnami Shell image registry                                                                                  | `docker.io`             |
| `volumePermissions.image.repository`                   | Bitnami Shell image repository                                                                                | `bitnami/bitnami-shell` |
| `volumePermissions.image.tag`                          | Bitnami Shell image tag (immutable tags are recommended)                                                      | `11-debian-11-r24`      |
| `volumePermissions.image.digest`                       | Bitnami Shell image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag | `""`                    |
| `volumePermissions.image.pullPolicy`                   | Bitnami Shell image pull policy                                                                               | `IfNotPresent`          |
| `volumePermissions.image.pullSecrets`                  | Bitnami Shell image pull secrets                                                                              | `[]`                    |
| `volumePermissions.resources.limits`                   | The resources limits for the init container                                                                   | `{}`                    |
| `volumePermissions.resources.requests`                 | The requested resources for the init container                                                                | `{}`                    |
| `volumePermissions.containerSecurityContext.enabled`   | Enabled init container Security Context                                                                       | `true`                  |
| `volumePermissions.containerSecurityContext.runAsUser` | Set init container's Security Context runAsUser                                                               | `0`                     |


### Metrics parameters

| Name                                            | Description                                                                                                     | Value                |
| ----------------------------------------------- | --------------------------------------------------------------------------------------------------------------- | -------------------- |
| `metrics.enabled`                               | Expose Apache Geode metrics                                                                                     | `false`              |
| `metrics.image.registry`                        | Bitnami HAProxy image registry                                                                                  | `docker.io`          |
| `metrics.image.repository`                      | Bitnami HAProxy image repository                                                                                | `bitnami/haproxy`    |
| `metrics.image.tag`                             | Bitnami HAProxy image tag (immutable tags are recommended)                                                      | `2.6.2-debian-11-r9` |
| `metrics.image.digest`                          | Bitnami HAProxy image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag | `""`                 |
| `metrics.image.pullPolicy`                      | Bitnami HAProxy image pull policy                                                                               | `IfNotPresent`       |
| `metrics.image.pullSecrets`                     | Bitnami HAProxy image pull secrets                                                                              | `[]`                 |
| `metrics.containerPort`                         | Metrics container port                                                                                          | `9914`               |
| `metrics.livenessProbe.enabled`                 | Enable livenessProbe on Metrics containers                                                                      | `true`               |
| `metrics.livenessProbe.initialDelaySeconds`     | Initial delay seconds for livenessProbe                                                                         | `15`                 |
| `metrics.livenessProbe.periodSeconds`           | Period seconds for livenessProbe                                                                                | `10`                 |
| `metrics.livenessProbe.timeoutSeconds`          | Timeout seconds for livenessProbe                                                                               | `5`                  |
| `metrics.livenessProbe.failureThreshold`        | Failure threshold for livenessProbe                                                                             | `5`                  |
| `metrics.livenessProbe.successThreshold`        | Success threshold for livenessProbe                                                                             | `1`                  |
| `metrics.readinessProbe.enabled`                | Enable readinessProbe on Metrics containers                                                                     | `true`               |
| `metrics.readinessProbe.initialDelaySeconds`    | Initial delay seconds for readinessProbe                                                                        | `15`                 |
| `metrics.readinessProbe.periodSeconds`          | Period seconds for readinessProbe                                                                               | `10`                 |
| `metrics.readinessProbe.timeoutSeconds`         | Timeout seconds for readinessProbe                                                                              | `5`                  |
| `metrics.readinessProbe.failureThreshold`       | Failure threshold for readinessProbe                                                                            | `5`                  |
| `metrics.readinessProbe.successThreshold`       | Success threshold for readinessProbe                                                                            | `1`                  |
| `metrics.customLivenessProbe`                   | Custom livenessProbe that overrides the default one                                                             | `{}`                 |
| `metrics.customReadinessProbe`                  | Custom readinessProbe that overrides the default one                                                            | `{}`                 |
| `metrics.containerSecurityContext.enabled`      | Enabled Metrics containers' Security Context                                                                    | `true`               |
| `metrics.containerSecurityContext.runAsUser`    | Set Metrics containers' Security Context runAsUser                                                              | `1001`               |
| `metrics.containerSecurityContext.runAsNonRoot` | Set Metrics containers' Security Context runAsNonRoot                                                           | `true`               |
| `metrics.service.port`                          | Service HTTP management port                                                                                    | `9914`               |
| `metrics.service.annotations`                   | Annotations for enabling prometheus to access the metrics endpoints                                             | `{}`                 |
| `metrics.serviceMonitor.enabled`                | Specify if a ServiceMonitor will be deployed for Prometheus Operator                                            | `false`              |
| `metrics.serviceMonitor.namespace`              | Namespace in which Prometheus is running                                                                        | `""`                 |
| `metrics.serviceMonitor.labels`                 | Extra labels for the ServiceMonitor                                                                             | `{}`                 |
| `metrics.serviceMonitor.jobLabel`               | The name of the label on the target service to use as the job name in Prometheus                                | `""`                 |
| `metrics.serviceMonitor.interval`               | How frequently to scrape metrics                                                                                | `""`                 |
| `metrics.serviceMonitor.scrapeTimeout`          | Timeout after which the scrape is ended                                                                         | `""`                 |
| `metrics.serviceMonitor.metricRelabelings`      | Specify additional relabeling of metrics                                                                        | `[]`                 |
| `metrics.serviceMonitor.relabelings`            | Specify general relabeling                                                                                      | `[]`                 |
| `metrics.serviceMonitor.selector`               | Prometheus instance selector labels                                                                             | `{}`                 |
| `metrics.serviceMonitor.honorLabels`            | honorLabels chooses the metric's labels on collisions with target labels                                        | `false`              |


### Other Parameters

| Name                                          | Description                                                                                                         | Value   |
| --------------------------------------------- | ------------------------------------------------------------------------------------------------------------------- | ------- |
| `serviceAccount.create`                       | Specifies whether a ServiceAccount should be created                                                                | `true`  |
| `serviceAccount.name`                         | Name of the service account to use. If not set and create is true, a name is generated using the fullname template. | `""`    |
| `serviceAccount.automountServiceAccountToken` | Automount service account token for the server service account                                                      | `false` |
| `serviceAccount.annotations`                  | Annotations for service account. Evaluated as a template. Only used if `create` is `true`.                          | `{}`    |
| `networkPolicy.enabled`                       | Specifies whether a NetworkPolicy should be created                                                                 | `false` |
| `networkPolicy.allowExternal`                 | Don't require client label for connections                                                                          | `true`  |


The above parameters map to the env variables defined in [bitnami/geode](https://github.com/bitnami/containers/tree/main/bitnami/geode). For more information please refer to the [bitnami/geode](https://github.com/bitnami/containers/tree/main/bitnami/geode) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
    --set auth.username=admin \
    --set auth.password=password \
    bitnami/geode
```

The above command sets the credentials to access Locator nodes to `admin` and `password` respectively.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml bitnami/geode
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### Architecture

This chart an Apache Geode cluster including a _locator_ statefulset with N _Locator_ nodes, and a _server_ statefulset with M Cache server nodes. The schema below represents the architecture when you used an Ingress controller to expose the Apache Geode Pulse dashboard:

```
       ------------------
      |     Ingress      |
      |    Controller    |
       ------------------
               | / HTTP monitoring
               |   dashboard
        |------|
        |                            --------------------
        | (port 7070)               |    Geode client    |
        \/                          |        pods        |-----|
   -------------------               --------------------      |
  |     Locator       |                 |                      |
  |       svc         |                 |                      |
   -------------------                  | / server             | / write
       |                                |   discovery          |   read
      \/                                |                      |
 --------------                         |     --------------   |
|   Locator    |                        |    |   Locator    |  |
|              |<-----------------------|--->|              |  |
|     Pod      |                             |     Pod      |  |
 --------------                               --------------   |
      ^                                             ^          |
  |---|---------------------------------------------|          |
  |                                       |                    |
  | / configuration      --------------------------------------|
  |   service            |                |                    |
  |                      |                |                    |
 ---------------         |               ---------------       |
| Cache server  |        |              | Cache server  |      |
|               |<-------|              |               | <----|
|     Pod       |                       |     Pod       |
 ---------------                         ---------------
```

> Note: when using several Locator nodes, it is recommended to configure sticky sessions using `--set locator.service.sessionAffinity="ClientIP"` or configuring the IngressController accordingly to access the Pulse monitoring dashboard.

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Ingress

This chart provides support for Ingress resources. If you have an ingress controller installed on your cluster, such as [nginx-ingress-controller](https://github.com/bitnami/charts/tree/master/bitnami/nginx-ingress-controller) or [contour](https://github.com/bitnami/charts/tree/master/bitnami/contour) you can utilize the ingress controller to serve your application.

To enable Ingress integration, set `ingress.enabled` to `true`. The `ingress.hostname` property can be used to set the host name. The `ingress.tls` parameter can be used to add the TLS configuration for this host. It is also possible to have more than one host, with a separate TLS configuration for each host. [Learn more about configuring and using Ingress](https://docs.bitnami.com/kubernetes/infrastructure/geode/configuration/configure-ingress/).

### TLS secrets

The chart also facilitates the creation of TLS secrets for use with the Ingress controller, with different options for certificate management. [Learn more about TLS secrets](https://docs.bitnami.com/kubernetes/infrastructure/geode/administration/enable-tls-ingress/).

### Additional environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `XXX.extraEnvVars` parameter(s).

```yaml
locator:
  extraEnvVars:
    - name: LOG_LEVEL
      value: error
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `XXX.extraEnvVarsCM` or the `XXX.extraEnvVarsSecret` parameters.

> Note: XXX is placeholder you need to replace with the actual component(s).

### Sidecars

If additional containers are needed in the same pod as geode (such as additional metrics or logging exporters), they can be defined using the `XXX.sidecars` parameter(s). If these sidecars export extra ports, extra port definitions can be added using the `XXX.service.extraPorts` parameter. [Learn more about configuring and using sidecar containers](https://docs.bitnami.com/kubernetes/infrastructure/geode/configuration/configure-sidecar-init-containers/).

> Note: XXX is placeholder you need to replace with the actual component(s).

### Pod affinity

This chart allows you to set your custom affinity using the `XXX.affinity` parameter(s). Find more information about Pod affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, use one of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `XXX.podAffinityPreset`, `XXX.podAntiAffinityPreset`, or `XXX.nodeAffinityPreset` parameters.

> Note: XXX is placeholder you need to replace with the actual component(s).

## Persistence

The [Bitnami geode](https://github.com/bitnami/containers/tree/main/bitnami/geode) image stores the geode data and configurations at the `/bitnami/geode` path of the container. Persistent Volume Claims are used to keep the data across deployments.

### Adjust permissions of persistent volume mountpoint

As the image run as non-root by default, it is necessary to adjust the ownership of the persistent volume so that the container can write data into it.

By default, the chart is configured to use Kubernetes Security Context to automatically change the ownership of the volume. However, this feature does not work in all Kubernetes distributions.

As an alternative, this chart supports using an initContainer to change the ownership of the volume before mounting it in the final destination. You can enable this initContainer by setting `volumePermissions.enabled` to `true`.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## License

Copyright &copy; 2022 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.