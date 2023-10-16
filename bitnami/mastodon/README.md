<!--- app-name: Mastodon -->

# Mastodon packaged by Bitnami

Mastodon is self-hosted social network server based on ActivityPub. Written in Ruby, features real-time updates, multimedia attachments and no vendor lock-in.

[Overview of Mastodon](https://joinmastodon.org/)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/mastodon
```

## Introduction

Bitnami charts for Helm are carefully engineered, actively maintained and are the quickest and easiest way to deploy containers on a Kubernetes cluster that are ready to handle production workloads.

This chart bootstraps an [Mastodon](https://www.mastodon.com/) Deployment in a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm charts in clusters.

[Learn more about the default configuration of the chart](https://docs.bitnami.com/kubernetes/apps/mastodon/get-started/).

Looking to use Mastodon in production? Try [VMware Application Catalog](https://bitnami.com/enterprise), the enterprise edition of Bitnami Application Catalog.

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/mastodon
```

The command deploys Mastodon on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

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

| Name                     | Description                                                                                                                                         | Value                |
| ------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------- |
| `kubeVersion`            | Override Kubernetes version                                                                                                                         | `""`                 |
| `nameOverride`           | String to partially override common.names.name                                                                                                      | `""`                 |
| `fullnameOverride`       | String to fully override common.names.fullname                                                                                                      | `""`                 |
| `namespaceOverride`      | String to fully override common.names.namespace                                                                                                     | `""`                 |
| `commonLabels`           | Labels to add to all deployed objects                                                                                                               | `{}`                 |
| `commonAnnotations`      | Annotations to add to all deployed objects                                                                                                          | `{}`                 |
| `clusterDomain`          | Kubernetes cluster domain name                                                                                                                      | `cluster.local`      |
| `extraDeploy`            | Array of extra objects to deploy with the release                                                                                                   | `[]`                 |
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden)                                                             | `false`              |
| `diagnosticMode.command` | Command to override all containers in the deployment                                                                                                | `["sleep"]`          |
| `diagnosticMode.args`    | Args to override all containers in the deployment                                                                                                   | `["infinity"]`       |
| `image.registry`         | Mastodon image registry                                                                                                                             | `docker.io`          |
| `image.repository`       | Mastodon image repository                                                                                                                           | `bitnami/mastodon`   |
| `image.tag`              | Mastodon image tag (immutable tags are recommended)                                                                                                 | `4.2.1-debian-11-r1` |
| `image.digest`           | Mastodon image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag image tag (immutable tags are recommended) | `""`                 |
| `image.pullPolicy`       | Mastodon image pull policy                                                                                                                          | `IfNotPresent`       |
| `image.pullSecrets`      | Mastodon image pull secrets                                                                                                                         | `[]`                 |
| `image.debug`            | Enable Mastodon image debug mode                                                                                                                    | `false`              |

### Mastodon common parameters

| Name                             | Description                                                                                                                  | Value                                |
| -------------------------------- | ---------------------------------------------------------------------------------------------------------------------------- | ------------------------------------ |
| `environment`                    | Mastodon Rails and Node environment. Should be one of 'production',                                                          | `production`                         |
| `adminUser`                      | Mastodon admin username                                                                                                      | `user`                               |
| `adminEmail`                     | Mastodon admin email                                                                                                         | `user@changeme.com`                  |
| `adminPassword`                  | Mastodon admin password                                                                                                      | `""`                                 |
| `defaultConfig`                  | Default configuration for Mastodon in the form of environment variables                                                      | `""`                                 |
| `defaultSecretConfig`            | Default secret configuration for Mastodon in the form of environment variables                                               | `""`                                 |
| `extraConfig`                    | Extra configuration for Mastodon in the form of environment variables                                                        | `{}`                                 |
| `extraSecretConfig`              | Extra secret configuration for Mastodon in the form of environment variables                                                 | `{}`                                 |
| `existingConfigmap`              | The name of an existing ConfigMap with your default configuration for Mastodon                                               | `""`                                 |
| `existingSecret`                 | The name of an existing Secret with your default configuration for Mastodon                                                  | `""`                                 |
| `extraConfigExistingConfigmap`   | The name of an existing ConfigMap with your extra configuration for Mastodon                                                 | `""`                                 |
| `extraConfigExistingSecret`      | The name of an existing Secret with your extra configuration for Mastodon                                                    | `""`                                 |
| `enableSearches`                 | Enable the search engine (uses Elasticsearch under the hood)                                                                 | `true`                               |
| `enableS3`                       | Enable the S3 storage engine                                                                                                 | `true`                               |
| `forceHttpsS3Protocol`           | Force Mastodon's S3_PROTOCOL to be https (Useful when TLS is terminated using cert-manager/Ingress)                          | `false`                              |
| `useSecureWebSocket`             | Set Mastodon's STREAMING_API_BASE_URL to use secure websocket (wss:// instead of ws://)                                      | `false`                              |
| `local_https`                    | Set this instance to advertise itself to the fediverse using HTTPS rather than HTTP URLs. This should almost always be true. | `true`                               |
| `localDomain`                    | The domain name used by accounts on this instance. Unless you're using                                                       | `""`                                 |
| `webDomain`                      | Optional alternate domain used when you want to host Mastodon at a                                                           | `""`                                 |
| `defaultLocale`                  | Set the default locale for this instance                                                                                     | `en`                                 |
| `s3AliasHost`                    | S3 alias host for Mastodon (will use 'http://webDomain/bucket' if not set)                                                   | `""`                                 |
| `smtp.server`                    | SMTP server                                                                                                                  | `""`                                 |
| `smtp.port`                      | SMTP port                                                                                                                    | `587`                                |
| `smtp.from_address`              | From address for sent emails                                                                                                 | `""`                                 |
| `smtp.domain`                    | SMTP domain                                                                                                                  | `""`                                 |
| `smtp.reply_to`                  | Reply-To value for sent emails                                                                                               | `""`                                 |
| `smtp.delivery_method`           | SMTP delivery method                                                                                                         | `smtp`                               |
| `smtp.ca_file`                   | SMTP CA file location                                                                                                        | `/etc/ssl/certs/ca-certificates.crt` |
| `smtp.openssl_verify_mode`       | OpenSSL verify mode                                                                                                          | `none`                               |
| `smtp.enable_starttls_auto`      | Automatically enable StartTLS                                                                                                | `true`                               |
| `smtp.tls`                       | SMTP TLS                                                                                                                     | `false`                              |
| `smtp.auth_method`               | SMTP auth method (set to "none" to disable SMTP auth)                                                                        | `plain`                              |
| `smtp.login`                     | SMTP auth username                                                                                                           | `""`                                 |
| `smtp.password`                  | SMTP auth password                                                                                                           | `""`                                 |
| `smtp.existingSecret`            | Name of an existing secret resource containing the SMTP                                                                      | `""`                                 |
| `smtp.existingSecretLoginKey`    | Name of the key for the SMTP login credential                                                                                | `""`                                 |
| `smtp.existingSecretPasswordKey` | Name of the key for the SMTP password credential                                                                             | `""`                                 |

### Mastodon Web Parameters

| Name                                                    | Description                                                                                                              | Value            |
| ------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------ | ---------------- |
| `web.replicaCount`                                      | Number of Mastodon web replicas to deploy                                                                                | `1`              |
| `web.containerPorts.http`                               | Mastodon web HTTP container port                                                                                         | `3000`           |
| `web.livenessProbe.enabled`                             | Enable livenessProbe on Mastodon web containers                                                                          | `true`           |
| `web.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                  | `10`             |
| `web.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                         | `10`             |
| `web.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                        | `5`              |
| `web.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                      | `6`              |
| `web.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                      | `1`              |
| `web.readinessProbe.enabled`                            | Enable readinessProbe on Mastodon web containers                                                                         | `true`           |
| `web.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                 | `10`             |
| `web.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                        | `10`             |
| `web.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                       | `5`              |
| `web.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                     | `6`              |
| `web.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                     | `1`              |
| `web.startupProbe.enabled`                              | Enable startupProbe on Mastodon web containers                                                                           | `false`          |
| `web.startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                   | `10`             |
| `web.startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                          | `10`             |
| `web.startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                         | `5`              |
| `web.startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                       | `6`              |
| `web.startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                       | `1`              |
| `web.customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                      | `{}`             |
| `web.customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                                     | `{}`             |
| `web.customStartupProbe`                                | Custom startupProbe that overrides the default one                                                                       | `{}`             |
| `web.resources.limits`                                  | The resources limits for the Mastodon web containers                                                                     | `{}`             |
| `web.resources.requests`                                | The requested resources for the Mastodon web containers                                                                  | `{}`             |
| `web.podSecurityContext.enabled`                        | Enabled Mastodon web pods' Security Context                                                                              | `true`           |
| `web.podSecurityContext.fsGroup`                        | Set Mastodon web pod's Security Context fsGroup                                                                          | `1001`           |
| `web.podSecurityContext.seccompProfile.type`            | Set container's Security Context seccomp profile                                                                         | `RuntimeDefault` |
| `web.containerSecurityContext.enabled`                  | Enabled Mastodon web containers' Security Context                                                                        | `true`           |
| `web.containerSecurityContext.runAsUser`                | Set Mastodon web containers' Security Context runAsUser                                                                  | `1001`           |
| `web.containerSecurityContext.runAsNonRoot`             | Set Mastodon web containers' Security Context runAsNonRoot                                                               | `true`           |
| `web.containerSecurityContext.readOnlyRootFilesystem`   | Set Mastodon web containers' Security Context runAsNonRoot                                                               | `false`          |
| `web.containerSecurityContext.allowPrivilegeEscalation` | Set container's privilege escalation                                                                                     | `false`          |
| `web.containerSecurityContext.capabilities.drop`        | Set container's Security Context runAsNonRoot                                                                            | `["ALL"]`        |
| `web.command`                                           | Override default container command (useful when using custom images)                                                     | `[]`             |
| `web.args`                                              | Override default container args (useful when using custom images)                                                        | `[]`             |
| `web.hostAliases`                                       | Mastodon web pods host aliases                                                                                           | `[]`             |
| `web.podLabels`                                         | Extra labels for Mastodon web pods                                                                                       | `{}`             |
| `web.podAnnotations`                                    | Annotations for Mastodon web pods                                                                                        | `{}`             |
| `web.podAffinityPreset`                                 | Pod affinity preset. Ignored if `web.affinity` is set. Allowed values: `soft` or `hard`                                  | `""`             |
| `web.podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `web.affinity` is set. Allowed values: `soft` or `hard`                             | `soft`           |
| `web.nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `web.affinity` is set. Allowed values: `soft` or `hard`                            | `""`             |
| `web.nodeAffinityPreset.key`                            | Node label key to match. Ignored if `web.affinity` is set                                                                | `""`             |
| `web.nodeAffinityPreset.values`                         | Node label values to match. Ignored if `web.affinity` is set                                                             | `[]`             |
| `web.affinity`                                          | Affinity for Mastodon web pods assignment                                                                                | `{}`             |
| `web.nodeSelector`                                      | Node labels for Mastodon web pods assignment                                                                             | `{}`             |
| `web.tolerations`                                       | Tolerations for Mastodon web pods assignment                                                                             | `[]`             |
| `web.updateStrategy.type`                               | Mastodon web statefulset strategy type                                                                                   | `RollingUpdate`  |
| `web.priorityClassName`                                 | Mastodon web pods' priorityClassName                                                                                     | `""`             |
| `web.topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template | `[]`             |
| `web.schedulerName`                                     | Name of the k8s scheduler (other than default) for Mastodon web pods                                                     | `""`             |
| `web.terminationGracePeriodSeconds`                     | Seconds Redmine pod needs to terminate gracefully                                                                        | `""`             |
| `web.lifecycleHooks`                                    | for the Mastodon web container(s) to automate configuration before or after startup                                      | `{}`             |
| `web.extraEnvVars`                                      | Array with extra environment variables to add to Mastodon web nodes                                                      | `[]`             |
| `web.extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for Mastodon web nodes                                              | `""`             |
| `web.extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for Mastodon web nodes                                                 | `""`             |
| `web.extraVolumes`                                      | Optionally specify extra list of additional volumes for the Mastodon web pod(s)                                          | `[]`             |
| `web.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the Mastodon web container(s)                               | `[]`             |
| `web.sidecars`                                          | Add additional sidecar containers to the Mastodon web pod(s)                                                             | `[]`             |
| `web.initContainers`                                    | Add additional init containers to the Mastodon web pod(s)                                                                | `[]`             |

### Mastodon Web Traffic Exposure Parameters

| Name                                   | Description                                                                             | Value       |
| -------------------------------------- | --------------------------------------------------------------------------------------- | ----------- |
| `web.service.type`                     | Mastodon web service type                                                               | `ClusterIP` |
| `web.service.ports.http`               | Mastodon web service HTTP port                                                          | `80`        |
| `web.service.nodePorts.http`           | Node port for HTTP                                                                      | `""`        |
| `web.service.clusterIP`                | Mastodon web service Cluster IP                                                         | `""`        |
| `web.service.loadBalancerIP`           | Mastodon web service Load Balancer IP                                                   | `""`        |
| `web.service.loadBalancerSourceRanges` | Mastodon web service Load Balancer sources                                              | `[]`        |
| `web.service.externalTrafficPolicy`    | Mastodon web service external traffic policy                                            | `Cluster`   |
| `web.service.annotations`              | Additional custom annotations for Mastodon web service                                  | `{}`        |
| `web.service.extraPorts`               | Extra ports to expose in Mastodon web service (normally used with the `sidecars` value) | `[]`        |
| `web.service.sessionAffinity`          | Control where web requests go, to the same pod or round-robin                           | `None`      |
| `web.service.sessionAffinityConfig`    | Additional settings for the sessionAffinity                                             | `{}`        |

### Mastodon Sidekiq Parameters

| Name                                                        | Description                                                                                                              | Value            |
| ----------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------ | ---------------- |
| `sidekiq.replicaCount`                                      | Number of Mastodon sidekiq replicas to deploy                                                                            | `1`              |
| `sidekiq.livenessProbe.enabled`                             | Enable livenessProbe on Mastodon sidekiq containers                                                                      | `true`           |
| `sidekiq.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                  | `10`             |
| `sidekiq.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                         | `10`             |
| `sidekiq.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                        | `5`              |
| `sidekiq.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                      | `6`              |
| `sidekiq.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                      | `1`              |
| `sidekiq.readinessProbe.enabled`                            | Enable readinessProbe on Mastodon sidekiq containers                                                                     | `true`           |
| `sidekiq.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                 | `10`             |
| `sidekiq.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                        | `10`             |
| `sidekiq.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                       | `5`              |
| `sidekiq.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                     | `6`              |
| `sidekiq.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                     | `1`              |
| `sidekiq.startupProbe.enabled`                              | Enable startupProbe on Mastodon sidekiq containers                                                                       | `false`          |
| `sidekiq.startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                   | `10`             |
| `sidekiq.startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                          | `10`             |
| `sidekiq.startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                         | `5`              |
| `sidekiq.startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                       | `6`              |
| `sidekiq.startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                       | `1`              |
| `sidekiq.customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                      | `{}`             |
| `sidekiq.customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                                     | `{}`             |
| `sidekiq.customStartupProbe`                                | Custom startupProbe that overrides the default one                                                                       | `{}`             |
| `sidekiq.resources.limits`                                  | The resources limits for the Mastodon sidekiq containers                                                                 | `{}`             |
| `sidekiq.resources.requests`                                | The requested resources for the Mastodon sidekiq containers                                                              | `{}`             |
| `sidekiq.podSecurityContext.enabled`                        | Enabled Mastodon sidekiq pods' Security Context                                                                          | `true`           |
| `sidekiq.podSecurityContext.fsGroup`                        | Set Mastodon sidekiq pod's Security Context fsGroup                                                                      | `1001`           |
| `sidekiq.podSecurityContext.seccompProfile.type`            | Set container's Security Context seccomp profile                                                                         | `RuntimeDefault` |
| `sidekiq.containerSecurityContext.enabled`                  | Enabled Mastodon sidekiq containers' Security Context                                                                    | `true`           |
| `sidekiq.containerSecurityContext.runAsUser`                | Set Mastodon sidekiq containers' Security Context runAsUser                                                              | `1001`           |
| `sidekiq.containerSecurityContext.runAsNonRoot`             | Set Mastodon sidekiq containers' Security Context runAsNonRoot                                                           | `true`           |
| `sidekiq.containerSecurityContext.readOnlyRootFilesystem`   | Set Mastodon sidekiq containers' Security Context runAsNonRoot                                                           | `false`          |
| `sidekiq.containerSecurityContext.allowPrivilegeEscalation` | Set container's privilege escalation                                                                                     | `false`          |
| `sidekiq.containerSecurityContext.capabilities.drop`        | Set container's Security Context runAsNonRoot                                                                            | `["ALL"]`        |
| `sidekiq.command`                                           | Override default container command (useful when using custom images)                                                     | `[]`             |
| `sidekiq.args`                                              | Override default container args (useful when using custom images)                                                        | `[]`             |
| `sidekiq.hostAliases`                                       | Mastodon sidekiq pods host aliases                                                                                       | `[]`             |
| `sidekiq.podLabels`                                         | Extra labels for Mastodon sidekiq pods                                                                                   | `{}`             |
| `sidekiq.podAnnotations`                                    | Annotations for Mastodon sidekiq pods                                                                                    | `{}`             |
| `sidekiq.podAffinityPreset`                                 | Pod affinity preset. Ignored if `sidekiq.affinity` is set. Allowed values: `soft` or `hard`                              | `""`             |
| `sidekiq.podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `sidekiq.affinity` is set. Allowed values: `soft` or `hard`                         | `soft`           |
| `sidekiq.nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `sidekiq.affinity` is set. Allowed values: `soft` or `hard`                        | `""`             |
| `sidekiq.nodeAffinityPreset.key`                            | Node label key to match. Ignored if `sidekiq.affinity` is set                                                            | `""`             |
| `sidekiq.nodeAffinityPreset.values`                         | Node label values to match. Ignored if `sidekiq.affinity` is set                                                         | `[]`             |
| `sidekiq.affinity`                                          | Affinity for Mastodon sidekiq pods assignment                                                                            | `{}`             |
| `sidekiq.nodeSelector`                                      | Node labels for Mastodon sidekiq pods assignment                                                                         | `{}`             |
| `sidekiq.tolerations`                                       | Tolerations for Mastodon sidekiq pods assignment                                                                         | `[]`             |
| `sidekiq.updateStrategy.type`                               | Mastodon sidekiq statefulset strategy type                                                                               | `RollingUpdate`  |
| `sidekiq.priorityClassName`                                 | Mastodon sidekiq pods' priorityClassName                                                                                 | `""`             |
| `sidekiq.topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template | `[]`             |
| `sidekiq.schedulerName`                                     | Name of the k8s scheduler (other than default) for Mastodon sidekiq pods                                                 | `""`             |
| `sidekiq.terminationGracePeriodSeconds`                     | Seconds Redmine pod needs to terminate gracefully                                                                        | `""`             |
| `sidekiq.lifecycleHooks`                                    | for the Mastodon sidekiq container(s) to automate configuration before or after startup                                  | `{}`             |
| `sidekiq.extraEnvVars`                                      | Array with extra environment variables to add to Mastodon sidekiq nodes                                                  | `[]`             |
| `sidekiq.extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for Mastodon sidekiq nodes                                          | `""`             |
| `sidekiq.extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for Mastodon sidekiq nodes                                             | `""`             |
| `sidekiq.extraVolumes`                                      | Optionally specify extra list of additional volumes for the Mastodon sidekiq pod(s)                                      | `[]`             |
| `sidekiq.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the Mastodon sidekiq container(s)                           | `[]`             |
| `sidekiq.sidecars`                                          | Add additional sidecar containers to the Mastodon sidekiq pod(s)                                                         | `[]`             |
| `sidekiq.initContainers`                                    | Add additional init containers to the Mastodon sidekiq pod(s)                                                            | `[]`             |

### Mastodon Streaming Parameters

| Name                                                          | Description                                                                                                              | Value            |
| ------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------ | ---------------- |
| `streaming.replicaCount`                                      | Number of Mastodon streaming replicas to deploy                                                                          | `1`              |
| `streaming.containerPorts.http`                               | Mastodon streaming HTTP container port                                                                                   | `8080`           |
| `streaming.livenessProbe.enabled`                             | Enable livenessProbe on Mastodon streaming containers                                                                    | `true`           |
| `streaming.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                  | `10`             |
| `streaming.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                         | `10`             |
| `streaming.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                        | `5`              |
| `streaming.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                      | `6`              |
| `streaming.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                      | `1`              |
| `streaming.readinessProbe.enabled`                            | Enable readinessProbe on Mastodon streaming containers                                                                   | `true`           |
| `streaming.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                 | `10`             |
| `streaming.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                        | `10`             |
| `streaming.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                       | `5`              |
| `streaming.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                     | `6`              |
| `streaming.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                     | `1`              |
| `streaming.startupProbe.enabled`                              | Enable startupProbe on Mastodon streaming containers                                                                     | `false`          |
| `streaming.startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                   | `10`             |
| `streaming.startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                          | `10`             |
| `streaming.startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                         | `5`              |
| `streaming.startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                       | `6`              |
| `streaming.startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                       | `1`              |
| `streaming.customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                      | `{}`             |
| `streaming.customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                                     | `{}`             |
| `streaming.customStartupProbe`                                | Custom startupProbe that overrides the default one                                                                       | `{}`             |
| `streaming.resources.limits`                                  | The resources limits for the Mastodon streaming containers                                                               | `{}`             |
| `streaming.resources.requests`                                | The requested resources for the Mastodon streaming containers                                                            | `{}`             |
| `streaming.podSecurityContext.enabled`                        | Enabled Mastodon streaming pods' Security Context                                                                        | `true`           |
| `streaming.podSecurityContext.fsGroup`                        | Set Mastodon streaming pod's Security Context fsGroup                                                                    | `1001`           |
| `streaming.podSecurityContext.seccompProfile.type`            | Set container's Security Context seccomp profile                                                                         | `RuntimeDefault` |
| `streaming.containerSecurityContext.enabled`                  | Enabled Mastodon streaming containers' Security Context                                                                  | `true`           |
| `streaming.containerSecurityContext.runAsUser`                | Set Mastodon streaming containers' Security Context runAsUser                                                            | `1001`           |
| `streaming.containerSecurityContext.runAsNonRoot`             | Set Mastodon streaming containers' Security Context runAsNonRoot                                                         | `true`           |
| `streaming.containerSecurityContext.readOnlyRootFilesystem`   | Set Mastodon streaming containers' Security Context runAsNonRoot                                                         | `false`          |
| `streaming.containerSecurityContext.allowPrivilegeEscalation` | Set container's privilege escalation                                                                                     | `false`          |
| `streaming.containerSecurityContext.capabilities.drop`        | Set container's Security Context runAsNonRoot                                                                            | `["ALL"]`        |
| `streaming.command`                                           | Override default container command (useful when using custom images)                                                     | `[]`             |
| `streaming.args`                                              | Override default container args (useful when using custom images)                                                        | `[]`             |
| `streaming.hostAliases`                                       | Mastodon streaming pods host aliases                                                                                     | `[]`             |
| `streaming.podLabels`                                         | Extra labels for Mastodon streaming pods                                                                                 | `{}`             |
| `streaming.podAnnotations`                                    | Annotations for Mastodon streaming pods                                                                                  | `{}`             |
| `streaming.podAffinityPreset`                                 | Pod affinity preset. Ignored if `streaming.affinity` is set. Allowed values: `soft` or `hard`                            | `""`             |
| `streaming.podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `streaming.affinity` is set. Allowed values: `soft` or `hard`                       | `soft`           |
| `streaming.nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `streaming.affinity` is set. Allowed values: `soft` or `hard`                      | `""`             |
| `streaming.nodeAffinityPreset.key`                            | Node label key to match. Ignored if `streaming.affinity` is set                                                          | `""`             |
| `streaming.nodeAffinityPreset.values`                         | Node label values to match. Ignored if `streaming.affinity` is set                                                       | `[]`             |
| `streaming.affinity`                                          | Affinity for Mastodon streaming pods assignment                                                                          | `{}`             |
| `streaming.nodeSelector`                                      | Node labels for Mastodon streaming pods assignment                                                                       | `{}`             |
| `streaming.tolerations`                                       | Tolerations for Mastodon streaming pods assignment                                                                       | `[]`             |
| `streaming.updateStrategy.type`                               | Mastodon streaming statefulset strategy type                                                                             | `RollingUpdate`  |
| `streaming.priorityClassName`                                 | Mastodon streaming pods' priorityClassName                                                                               | `""`             |
| `streaming.topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template | `[]`             |
| `streaming.schedulerName`                                     | Name of the k8s scheduler (other than default) for Mastodon streaming pods                                               | `""`             |
| `streaming.terminationGracePeriodSeconds`                     | Seconds Redmine pod needs to terminate gracefully                                                                        | `""`             |
| `streaming.lifecycleHooks`                                    | for the Mastodon streaming container(s) to automate configuration before or after startup                                | `{}`             |
| `streaming.extraEnvVars`                                      | Array with extra environment variables to add to Mastodon streaming nodes                                                | `[]`             |
| `streaming.extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for Mastodon streaming nodes                                        | `""`             |
| `streaming.extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for Mastodon streaming nodes                                           | `""`             |
| `streaming.extraVolumes`                                      | Optionally specify extra list of additional volumes for the Mastodon streaming pod(s)                                    | `[]`             |
| `streaming.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the Mastodon streaming container(s)                         | `[]`             |
| `streaming.sidecars`                                          | Add additional sidecar containers to the Mastodon streaming pod(s)                                                       | `[]`             |
| `streaming.initContainers`                                    | Add additional init containers to the Mastodon streaming pod(s)                                                          | `[]`             |

### Mastodon Streaming Traffic Exposure Parameters

| Name                                         | Description                                                                                   | Value       |
| -------------------------------------------- | --------------------------------------------------------------------------------------------- | ----------- |
| `streaming.service.type`                     | Mastodon streaming service type                                                               | `ClusterIP` |
| `streaming.service.ports.http`               | Mastodon streaming service HTTP port                                                          | `80`        |
| `streaming.service.nodePorts.http`           | Node port for HTTP                                                                            | `""`        |
| `streaming.service.clusterIP`                | Mastodon streaming service Cluster IP                                                         | `""`        |
| `streaming.service.loadBalancerIP`           | Mastodon streaming service Load Balancer IP                                                   | `""`        |
| `streaming.service.loadBalancerSourceRanges` | Mastodon streaming service Load Balancer sources                                              | `[]`        |
| `streaming.service.externalTrafficPolicy`    | Mastodon streaming service external traffic policy                                            | `Cluster`   |
| `streaming.service.annotations`              | Additional custom annotations for Mastodon streaming service                                  | `{}`        |
| `streaming.service.extraPorts`               | Extra ports to expose in Mastodon streaming service (normally used with the `sidecars` value) | `[]`        |
| `streaming.service.sessionAffinity`          | Control where streaming requests go, to the same pod or round-robin                           | `None`      |
| `streaming.service.sessionAffinityConfig`    | Additional settings for the sessionAffinity                                                   | `{}`        |

### Mastodon Media Management Cronjob Parameters

| Name                                                | Description                                                                            | Value        |
| --------------------------------------------------- | -------------------------------------------------------------------------------------- | ------------ |
| `tootctlMediaManagement.enabled`                    | Enable Cronjob to manage all media caches                                              | `false`      |
| `tootctlMediaManagement.removeAttachments`          | Enable removing attachements                                                           | `true`       |
| `tootctlMediaManagement.removeAttachmentsDays`      | Number of days old media attachments must be for removal                               | `30`         |
| `tootctlMediaManagement.removeCustomEmoji`          | Enable removal of cached remote emoji files                                            | `false`      |
| `tootctlMediaManagement.removePreviewCards`         | Enable removal of cached preview cards                                                 | `false`      |
| `tootctlMediaManagement.removePreviewCardsDays`     | Number of days old preview cards must be for removal                                   | `30`         |
| `tootctlMediaManagement.removeAvatars`              | Enable removal of cached remote avatar images                                          | `false`      |
| `tootctlMediaManagement.removeAvatarsDays`          | Number of days old avatar images must be for removal                                   | `30`         |
| `tootctlMediaManagement.removeHeaders`              | Enable removal of cached profile header images                                         | `false`      |
| `tootctlMediaManagement.removeHeadersDays`          | Number of days old header images must be for removal                                   | `30`         |
| `tootctlMediaManagement.removeOrphans`              | Enable removal of cached orphan files                                                  | `false`      |
| `tootctlMediaManagement.includeFollows`             | Enable removal of cached avatar and header when local users are following the accounts | `false`      |
| `tootctlMediaManagement.cronSchedule`               | Cron job schedule to run tootctl media commands                                        | `14 3 * * *` |
| `tootctlMediaManagement.failedJobsHistoryLimit`     | Number of failed jobs to keep                                                          | `3`          |
| `tootctlMediaManagement.successfulJobsHistoryLimit` | Number of successful jobs to keep                                                      | `3`          |
| `tootctlMediaManagement.concurrencyPolicy`          | Concurrency Policy.  Should be Allow, Forbid or Replace                                | `Allow`      |

### Mastodon Migration job Parameters

| Name                                                        | Description                                                                                                                    | Value            |
| ----------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------ | ---------------- |
| `initJob.precompileAssets`                                  | Execute rake assets:precompile as part of the job                                                                              | `true`           |
| `initJob.migrateDB`                                         | Execute rake db:migrate as part of the job                                                                                     | `true`           |
| `initJob.migrateElasticsearch`                              | Execute rake chewy:upgrade as part of the job                                                                                  | `true`           |
| `initJob.createAdmin`                                       | Create admin user as part of the job                                                                                           | `true`           |
| `initJob.backoffLimit`                                      | set backoff limit of the job                                                                                                   | `10`             |
| `initJob.extraVolumes`                                      | Optionally specify extra list of additional volumes for the Mastodon init job                                                  | `[]`             |
| `initJob.containerSecurityContext.enabled`                  | Enabled Mastodon init job containers' Security Context                                                                         | `true`           |
| `initJob.containerSecurityContext.runAsUser`                | Set Mastodon init job containers' Security Context runAsUser                                                                   | `1001`           |
| `initJob.containerSecurityContext.runAsNonRoot`             | Set Mastodon init job containers' Security Context runAsNonRoot                                                                | `true`           |
| `initJob.containerSecurityContext.readOnlyRootFilesystem`   | Set Mastodon init job containers' Security Context runAsNonRoot                                                                | `false`          |
| `initJob.containerSecurityContext.allowPrivilegeEscalation` | Set container's privilege escalation                                                                                           | `false`          |
| `initJob.containerSecurityContext.capabilities.drop`        | Set container's Security Context runAsNonRoot                                                                                  | `["ALL"]`        |
| `initJob.podSecurityContext.enabled`                        | Enabled Mastodon init job pods' Security Context                                                                               | `true`           |
| `initJob.podSecurityContext.fsGroup`                        | Set Mastodon init job pod's Security Context fsGroup                                                                           | `1001`           |
| `initJob.podSecurityContext.seccompProfile.type`            | Set container's Security Context seccomp profile                                                                               | `RuntimeDefault` |
| `initJob.extraEnvVars`                                      | Array containing extra env vars to configure the Mastodon init job                                                             | `[]`             |
| `initJob.extraEnvVarsCM`                                    | ConfigMap containing extra env vars to configure the Mastodon init job                                                         | `""`             |
| `initJob.extraEnvVarsSecret`                                | Secret containing extra env vars to configure the Mastodon init job (in case of sensitive data)                                | `""`             |
| `initJob.extraVolumeMounts`                                 | Array of extra volume mounts to be added to the Mastodon Container (evaluated as template). Normally used with `extraVolumes`. | `[]`             |
| `initJob.resources.limits`                                  | The resources limits for the container                                                                                         | `{}`             |
| `initJob.resources.requests`                                | The requested resources for the container                                                                                      | `{}`             |
| `initJob.hostAliases`                                       | Add deployment host aliases                                                                                                    | `[]`             |
| `initJob.annotations`                                       | Add annotations to the job                                                                                                     | `{}`             |
| `initJob.podLabels`                                         | Additional pod labels                                                                                                          | `{}`             |
| `initJob.podAnnotations`                                    | Additional pod annotations                                                                                                     | `{}`             |

### Persistence Parameters (only when S3 is disabled)

| Name                        | Description                                                                                             | Value               |
| --------------------------- | ------------------------------------------------------------------------------------------------------- | ------------------- |
| `persistence.enabled`       | Enable persistence using Persistent Volume Claims                                                       | `false`             |
| `persistence.mountPath`     | Path to mount the volume at.                                                                            | `/bitnami/mastodon` |
| `persistence.subPath`       | The subdirectory of the volume to mount to, useful in dev environments and one PV for multiple services | `""`                |
| `persistence.storageClass`  | Storage class of backing PVC                                                                            | `""`                |
| `persistence.annotations`   | Persistent Volume Claim annotations                                                                     | `{}`                |
| `persistence.accessModes`   | Persistent Volume Access Modes                                                                          | `["ReadWriteOnce"]` |
| `persistence.size`          | Size of data volume                                                                                     | `8Gi`               |
| `persistence.existingClaim` | The name of an existing PVC to use for persistence                                                      | `""`                |
| `persistence.selector`      | Selector to match an existing Persistent Volume for WordPress data PVC                                  | `{}`                |
| `persistence.dataSource`    | Custom PVC data source                                                                                  | `{}`                |

### Init Container Parameters

| Name                                                   | Description                                                                                     | Value              |
| ------------------------------------------------------ | ----------------------------------------------------------------------------------------------- | ------------------ |
| `volumePermissions.enabled`                            | Enable init container that changes the owner/group of the PV mount point to `runAsUser:fsGroup` | `false`            |
| `volumePermissions.image.registry`                     | OS Shell + Utility image registry                                                               | `docker.io`        |
| `volumePermissions.image.repository`                   | OS Shell + Utility image repository                                                             | `bitnami/os-shell` |
| `volumePermissions.image.tag`                          | OS Shell + Utility image tag (immutable tags are recommended)                                   | `11-debian-11-r90` |
| `volumePermissions.image.pullPolicy`                   | OS Shell + Utility image pull policy                                                            | `IfNotPresent`     |
| `volumePermissions.image.pullSecrets`                  | OS Shell + Utility image pull secrets                                                           | `[]`               |
| `volumePermissions.resources.limits`                   | The resources limits for the init container                                                     | `{}`               |
| `volumePermissions.resources.requests`                 | The requested resources for the init container                                                  | `{}`               |
| `volumePermissions.containerSecurityContext.runAsUser` | Set init container's Security Context runAsUser                                                 | `0`                |

### Other Parameters

| Name                                          | Description                                                             | Value         |
| --------------------------------------------- | ----------------------------------------------------------------------- | ------------- |
| `serviceAccount.create`                       | Specifies whether a ServiceAccount should be created                    | `true`        |
| `serviceAccount.name`                         | The name of the ServiceAccount to use.                                  | `""`          |
| `serviceAccount.annotations`                  | Additional Service Account annotations (evaluated as a template)        | `{}`          |
| `serviceAccount.automountServiceAccountToken` | Automount service account token for the server service account          | `true`        |
| `externalDatabase.host`                       | Database host                                                           | `""`          |
| `externalDatabase.port`                       | Database port number                                                    | `5432`        |
| `externalDatabase.user`                       | Non-root username for JupyterHub                                        | `postgres`    |
| `externalDatabase.password`                   | Password for the non-root username for JupyterHub                       | `""`          |
| `externalDatabase.database`                   | JupyterHub database name                                                | `mastodon`    |
| `externalDatabase.existingSecret`             | Name of an existing secret resource containing the database credentials | `""`          |
| `externalDatabase.existingSecretPasswordKey`  | Name of an existing secret key containing the database credentials      | `db-password` |

### External Redis parameters

| Name                                      | Description                                                          | Value  |
| ----------------------------------------- | -------------------------------------------------------------------- | ------ |
| `externalRedis.host`                      | Redis host                                                           | `""`   |
| `externalRedis.port`                      | Redis port number                                                    | `6379` |
| `externalRedis.password`                  | Password for the Redis                                               | `""`   |
| `externalRedis.existingSecret`            | Name of an existing secret resource containing the Redis credentials | `""`   |
| `externalRedis.existingSecretPasswordKey` | Name of an existing secret key containing the Redis credentials      | `""`   |

### External S3 parameters

| Name                                      | Description                                                        | Value           |
| ----------------------------------------- | ------------------------------------------------------------------ | --------------- |
| `externalS3.host`                         | External S3 host                                                   | `""`            |
| `externalS3.port`                         | External S3 port number                                            | `443`           |
| `externalS3.accessKeyID`                  | External S3 access key ID                                          | `""`            |
| `externalS3.accessKeySecret`              | External S3 access key secret                                      | `""`            |
| `externalS3.existingSecret`               | Name of an existing secret resource containing the S3 credentials  | `""`            |
| `externalS3.existingSecretAccessKeyIDKey` | Name of an existing secret key containing the S3 access key ID     | `root-user`     |
| `externalS3.existingSecretKeySecretKey`   | Name of an existing secret key containing the S3 access key secret | `root-password` |
| `externalS3.protocol`                     | External S3 protocol                                               | `https`         |
| `externalS3.bucket`                       | External S3 bucket                                                 | `mastodon`      |
| `externalS3.region`                       | External S3 region                                                 | `us-east-1`     |

### External elasticsearch configuration

| Name                                              | Description                                                                  | Value                    |
| ------------------------------------------------- | ---------------------------------------------------------------------------- | ------------------------ |
| `externalElasticsearch.host`                      | Host of the external elasticsearch server                                    | `""`                     |
| `externalElasticsearch.port`                      | Port of the external elasticsearch server                                    | `""`                     |
| `externalElasticsearch.password`                  | Password for the external elasticsearch server                               | `""`                     |
| `externalElasticsearch.existingSecret`            | Name of an existing secret resource containing the elasticsearch credentials | `""`                     |
| `externalElasticsearch.existingSecretPasswordKey` | Name of an existing secret key containing the elasticsearch credentials      | `elasticsearch-password` |

### Redis sub-chart parameters

| Name                               | Description                                    | Value        |
| ---------------------------------- | ---------------------------------------------- | ------------ |
| `redis.enabled`                    | Deploy Redis subchart                          | `true`       |
| `redis.architecture`               | Set Redis architecture                         | `standalone` |
| `redis.existingSecret`             | Name of a secret containing redis credentials  | `""`         |
| `redis.master.service.ports.redis` | Redis port                                     | `6379`       |
| `redis.auth.enabled`               | Enable Redis auth                              | `true`       |
| `redis.auth.password`              | Redis password                                 | `""`         |
| `redis.auth.existingSecret`        | Name of a secret containing the Redis password | `""`         |

### PostgreSQL chart configuration

| Name                                          | Description                                               | Value              |
| --------------------------------------------- | --------------------------------------------------------- | ------------------ |
| `postgresql.enabled`                          | Switch to enable or disable the PostgreSQL helm chart     | `true`             |
| `postgresql.auth.username`                    | Name for a custom user to create                          | `bn_mastodon`      |
| `postgresql.auth.password`                    | Password for the custom user to create                    | `""`               |
| `postgresql.auth.database`                    | Name for a custom database to create                      | `bitnami_mastodon` |
| `postgresql.auth.existingSecret`              | Name of existing secret to use for PostgreSQL credentials | `""`               |
| `postgresql.architecture`                     | PostgreSQL architecture (`standalone` or `replication`)   | `standalone`       |
| `postgresql.primary.service.ports.postgresql` | PostgreSQL service port                                   | `5432`             |

### MinIO&reg; chart parameters

| Name                               | Description                                                                                                                       | Value                                                  |
| ---------------------------------- | --------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------ |
| `minio`                            | For full list of MinIO&reg; values configurations please refere [here](https://github.com/bitnami/charts/tree/main/bitnami/minio) |                                                        |
| `minio.enabled`                    | Enable/disable MinIO&reg; chart installation                                                                                      | `true`                                                 |
| `minio.auth.rootUser`              | MinIO&reg; root username                                                                                                          | `admin`                                                |
| `minio.auth.rootPassword`          | Password for MinIO&reg; root user                                                                                                 | `""`                                                   |
| `minio.auth.existingSecret`        | Name of an existing secret containing the MinIO&reg; credentials                                                                  | `""`                                                   |
| `minio.defaultBuckets`             | Comma, semi-colon or space separated list of MinIO&reg; buckets to create                                                         | `s3storage`                                            |
| `minio.provisioning.enabled`       | Enable/disable MinIO&reg; provisioning job                                                                                        | `true`                                                 |
| `minio.provisioning.extraCommands` | Extra commands to run on MinIO&reg; provisioning job                                                                              | `["mc anonymous set download provisioning/s3storage"]` |
| `minio.tls.enabled`                | Enable/disable MinIO&reg; TLS support                                                                                             | `false`                                                |
| `minio.service.type`               | MinIO&reg; service type                                                                                                           | `ClusterIP`                                            |
| `minio.service.loadBalancerIP`     | MinIO&reg; service LoadBalancer IP                                                                                                | `""`                                                   |
| `minio.service.ports.api`          | MinIO&reg; service port                                                                                                           | `80`                                                   |

### Elasticsearch chart configuration

| Name                                        | Description                                                                 | Value   |
| ------------------------------------------- | --------------------------------------------------------------------------- | ------- |
| `elasticsearch.enabled`                     | Whether to deploy a elasticsearch server to use as Mastodon's search engine | `true`  |
| `elasticsearch.sysctlImage.enabled`         | Enable kernel settings modifier image for Elasticsearch                     | `true`  |
| `elasticsearch.security.enabled`            | Enable security settings for Elasticsearch                                  | `false` |
| `elasticsearch.security.existingSecret`     | Name of an existing secret containing the elasticsearch credentials         | `""`    |
| `elasticsearch.security.tls.restEncryption` | Enable TLS encryption for REST API                                          | `false` |
| `elasticsearch.master.replicaCount`         | Desired number of Elasticsearch master-eligible nodes                       | `1`     |
| `elasticsearch.coordinating.replicaCount`   | Desired number of Elasticsearch coordinating-only nodes                     | `1`     |
| `elasticsearch.data.replicaCount`           | Desired number of Elasticsearch data nodes                                  | `1`     |
| `elasticsearch.ingest.replicaCount`         | Desired number of Elasticsearch ingest nodes                                | `1`     |
| `elasticsearch.service.ports.restAPI`       | Elasticsearch REST API port                                                 | `9200`  |

### Apache chart configuration

| Name                            | Description                                                     | Value                      |
| ------------------------------- | --------------------------------------------------------------- | -------------------------- |
| `apache.enabled`                | Enable Apache chart                                             | `true`                     |
| `apache.containerPorts.http`    | Apache container port                                           | `8080`                     |
| `apache.service.type`           | Apache service type                                             | `LoadBalancer`             |
| `apache.service.loadBalancerIP` | Apache service LoadBalancer IP                                  | `""`                       |
| `apache.service.ports.http`     | Apache service port                                             | `80`                       |
| `apache.vhostsConfigMap`        | Name of the ConfigMap containing the Apache vhost configuration | `""`                       |
| `apache.livenessProbe.path`     | Apache liveness probe path                                      | `/api/v1/streaming/health` |
| `apache.readinessProbe.path`    | Apache readiness probe path                                     | `/api/v1/streaming/health` |
| `apache.startupProbe.path`      | Apache startup probe path                                       | `/api/v1/streaming/health` |
| `apache.ingress.enabled`        | Enable ingress                                                  | `false`                    |
| `apache.ingress.hostname`       | Ingress hostname                                                | `mastodon.local`           |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
  --set adminUsername=admin \
  --set adminPassword=password \
    oci://registry-1.docker.io/bitnamicharts/mastodon
```

The above command sets the mastodon administrator account username and password to `admin` and `password` respectively.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml oci://registry-1.docker.io/bitnamicharts/mastodon
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### External database support

You may want to have Mastodon connect to an external database rather than installing one inside your cluster. Typical reasons for this are to use a managed database service, or to share a common database server for all your applications. To achieve this, the chart allows you to specify credentials for an external database with the [`externalDatabase` parameter](#parameters). You should also disable the MongoDB installation with the `postgresql.enabled` option. Here is an example:

```console
postgresql.enabled=false
externalDatabase.host=myexternalhost
externalDatabase.user=myuser
externalDatabase.password=mypassword
externalDatabase.database=mydatabase
externalDatabase.port=5432
```

### External redis support

You may want to have mastodon connect to an external redis rather than installing one inside your cluster. Typical reasons for this are to use a managed redis service, or to share a common redis server for all your applications. To achieve this, the chart allows you to specify credentials for an external redis with the [`externalRedis` parameter](#parameters). You should also disable the Redis installation with the `redis.enabled` option. Here is an example:

```console
redis.enabled=false
externalRedis.host=myexternalhost
externalRedis.password=mypassword
externalRedis.port=6379
```

### External elasticsearch support

You may want to have mastodon connect to an external elasticsearch rather than installing one inside your cluster. Typical reasons for this are to use a managed elasticsearch service, or to share a common elasticsearch server for all your applications. To achieve this, the chart allows you to specify credentials for an external elasticsearch with the [`externalElasticsearch` parameter](#parameters). You should also disable the Redis installation with the `elasticsearch.enabled` option. Here is an example:

```console
elasticsearch.enabled=false
externalElasticsearch.host=myexternalhost
externalElasticsearch.password=mypassword
externalElasticsearch.port=9200
```

### External S3 support

You may want to have mastodon connect to an external storage streaming rather than installing MiniIO(TM) inside your cluster. To achieve this, the chart allows you to specify credentials for an external storage streaming with the [`externalS3` parameter](#parameters). You should also disable the MinIO(TM) installation with the `minio.enabled` option. Here is an example:

```console
minio.enabled=false
externalS3.host=myexternalhost
exterernalS3.accessKeyID=accesskey
externalS3.accessKeySecret=secret
```

### Ingress

This chart provides support for Ingress resources. If you have an ingress controller installed on your cluster, such as [nginx-ingress-controller](https://github.com/bitnami/charts/tree/main/bitnami/nginx-ingress-controller) or [contour](https://github.com/bitnami/charts/tree/main/bitnami/contour) you can utilize the ingress controller to serve your application.

To enable Ingress integration, set `apache.ingress.enabled` to `true`. The `apache.ingress.hostname` property can be used to set the host name. The `apache.ingress.tls` parameter can be used to add the TLS configuration for this host. It is also possible to have more than one host, with a separate TLS configuration for each host. [Learn more about configuring and using Ingress](https://docs.bitnami.com/kubernetes/apps/mastodon/configuration/configure-ingress/).

### TLS secrets

The chart also facilitates the creation of TLS secrets for use with the Ingress controller, with different options for certificate management. [Learn more about TLS secrets](https://docs.bitnami.com/kubernetes/apps/mastodon/administration/enable-tls-ingress/).

## Persistence

The [Bitnami mastodon](https://github.com/bitnami/containers/tree/main/bitnami/mastodon) image stores the mastodon data and configurations at the `/bitnami` path of the container. Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.

### Additional environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `extraEnvVars` property inside the `web`, `streaming` and `sidekiq` sections.

```yaml
streaming:
  extraEnvVars:
    - name: LOG_LEVEL
      value: error
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values inside the `web`, `streaming` and `sidekiq` sections.

### Sidecars

If additional containers are needed in the same pod as mastodon (such as additional metrics or logging exporters), they can be defined using the `sidecars` parameter inside the `web`, `streaming` and `sidekiq` sections. If these sidecars export extra posidekiq, extra port definitions can be added using the `service.extraPosidekiq` parameter. [Learn more about configuring and using sidecar containers](https://docs.bitnami.com/kubernetes/apps/mastodon/administration/configure-use-sidecars/).

### Pod affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, use one of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters inside the `web`, `streaming` and `sidekiq` sections.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 3.0.0

This major updates the PostgreSQL subchart to its newest major, 13.0.0. [Here](https://github.com/bitnami/charts/tree/master/bitnami/postgresql#to-1300) you can find more information about the changes introduced in that version.

### 2.0.0

This major updates the Redis&reg; subchart to its newest major, 18.0.0. This subchart's major doesn't include any changes affecting its use as a subchart for Mastodon, so no major issues are expected during the upgrade.

NOTE: Due to an error in our release process, Redis&reg;' chart versions higher or equal than 17.15.4 already use Redis&reg; 7.2 by default.

### 1.0.0

This major updates the MinIO&reg; subchart to its newest major, 12.0.0. This subchart's major doesn't include any changes affecting its use as a subchart for Mastodon, so no major issues are expected during the upgrade.

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