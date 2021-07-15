# Concourse

[Concourse](https://concourse-ci.org/) is an automation system written in Go. It is most commonly used for CI/CD, and is built to scale to any kind of automation pipeline, from simple to complex.

## TL;DR

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/concourse
```

## Introduction

This chart bootstraps a [Concourse](https://concourse-ci.org/) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages [Bitnami Postgresql](https://github.com/bitnami/charts/tree/master/bitnami/postgresql)

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.12+
- Helm 3.1.0
- PV provisioner support in the underlying infrastructure
- ReadWriteMany volumes for deployment scaling

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release bitnami/concourse
```

The command deploys concourse on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

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
| `global.imageRegistry`    | Global Docker image registry                    | `nil` |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]`  |
| `global.storageClass`     | Global StorageClass for Persistent Volume(s)    | `nil` |


### Common parameters

| Name                | Description                                        | Value |
| ------------------- | -------------------------------------------------- | ----- |
| `kubeVersion`       | Override Kubernetes version                        | `nil` |
| `nameOverride`      | String to partially override common.names.fullname | `nil` |
| `fullnameOverride`  | String to fully override common.names.fullname     | `nil` |
| `commonLabels`      | Labels to add to all deployed objects              | `{}`  |
| `commonAnnotations` | Annotations to add to all deployed objects         | `{}`  |
| `extraDeploy`       | Array of extra objects to deploy with the release  | `[]`  |


### Traffic Exposure Parameters

| Name | Description | Value |
| ---- | ----------- | ----- |


### consourse Parameters

| Name                                     | Description                                                                                       | Value                   |
| ---------------------------------------- | ------------------------------------------------------------------------------------------------- | ----------------------- |
| `concourse.image.registry`               | image registry                                                                                    | `docker.io`             |
| `concourse.image.repository`             | image repository                                                                                  | `bitnami/concourse`     |
| `concourse.image.tag`                    | image tag (immutable tags are recommended)                                                        | `7.3.2-debian-10-r7`    |
| `concourse.image.pullPolicy`             | image pull policy                                                                                 | `IfNotPresent`          |
| `concourse.image.pullSecrets`            | image pull secrets                                                                                | `[]`                    |
| `web.enabled`                            | Enable web                                                                                        | `true`                  |
| `web.replicaCount`                       | Number of web replicas to deploy                                                                  | `1`                     |
| `web.args`                               | Args of the startup command for the web component.                                                | `[]`                    |
| `web.baseUrl`                            | url                                                                                               | `/`                     |
| `web.logLevel`                           | Minimum level of logs to see. Possible options: debug, info, error.                               | `debug`                 |
| `web.clusterName`                        | A name for this Concourse cluster, to be displayed on the dashboard page.                         | `nil`                   |
| `web.listenIp`                           | IP address on which to listen for HTTP traffic (web UI and API).                                  | `0.0.0.0`               |
| `web.containerPort`                      | Port on which to listen for HTTP traffic (web UI and API).                                        | `8080`                  |
| `web.nameOverride`                       | provide a name to substitute for the full names of resources                                      | `nil`                   |
| `web.peerAddress`                        | Network address of this web node, reachable by other web nodes.                                   | `nil`                   |
| `web.externalUrl`                        | URL used to reach any ATC from the outside world.                                                 | `nil`                   |
| `web.enableAcrossStep`                   | Enable the experimental across step to be used in jobs. The API is subject to change.             | `false`                 |
| `web.enablePipelineInstances`            | Enable the creation of instanced pipelines.                                                       | `false`                 |
| `web.enableCacheStreamedVolumes`         | Enable caching streamed resource volumes on the destination worker.                               | `false`                 |
| `web.livenessProbe.enabled`              | Enable livenessProbe on web nodes                                                                 | `true`                  |
| `web.livenessProbe.initialDelaySeconds`  | Initial delay seconds for livenessProbe                                                           | `30`                    |
| `web.livenessProbe.periodSeconds`        | Period seconds for livenessProbe                                                                  | `15`                    |
| `web.livenessProbe.timeoutSeconds`       | Timeout seconds for livenessProbe                                                                 | `3`                     |
| `web.livenessProbe.failureThreshold`     | Failure threshold for livenessProbe                                                               | `1`                     |
| `web.livenessProbe.successThreshold`     | Success threshold for livenessProbe                                                               | `1`                     |
| `web.readinessProbe.enabled`             | Enable readinessProbe on web nodes                                                                | `true`                  |
| `web.readinessProbe.initialDelaySeconds` | Initial delay seconds for readinessProbe                                                          | `30`                    |
| `web.readinessProbe.periodSeconds`       | Period seconds for readinessProbe                                                                 | `15`                    |
| `web.readinessProbe.timeoutSeconds`      | Timeout seconds for readinessProbe                                                                | `3`                     |
| `web.readinessProbe.failureThreshold`    | Failure threshold for readinessProbe                                                              | `1`                     |
| `web.readinessProbe.successThreshold`    | Success threshold for readinessProbe                                                              | `1`                     |
| `web.customLivenessProbe`                | Custom livenessProbe that overrides the default one                                               | `{}`                    |
| `web.customReadinessProbe`               | Custom readinessProbe that overrides the default one                                              | `{}`                    |
| `web.resources.limits`                   | The resources limits for the web containers                                                       | `{}`                    |
| `web.resources.requests`                 | The requested for the web containers                                                              | `{}`                    |
| `web.tls.enabled`                        | enable serving HTTPS traffic directly through the web component.                                  | `false`                 |
| `web.tls.containerPort`                  | on which to listen for HTTPS traffic.                                                             | `443`                   |
| `web.existingConfigmap`                  | The name of an existing ConfigMap with your custom configuration for web                          | `nil`                   |
| `web.command`                            | Override default container command (useful when using custom images)                              | `[]`                    |
| `web.hostAliases`                        | Deployment pod host aliases                                                                       | `[]`                    |
| `web.podLabels`                          | Extra labels for web pods                                                                         | `{}`                    |
| `web.keySecretsPath`                     |                                                                                                   | `/concourse-keys`       |
| `web.teamSecretsPath`                    |                                                                                                   | `/team-authorized-keys` |
| `web.podSecurityContext.enabled`         | Enabled web pods' Security Context                                                                | `true`                  |
| `web.podSecurityContext.fsGroup`         | Set web pod's Security Context fsGroup                                                            | `1001`                  |
| `web.containerSecurityContext.enabled`   | Enabled web containers' Security Context                                                          | `true`                  |
| `web.containerSecurityContext.runAsUser` | Set web containers' Security Context runAsUser                                                    | `1001`                  |
| `web.psp.create`                         | Specifies whether a PodSecurityPolicy should be created (set `psp.create` to `true` to enable it) | `false`                 |
| `web.tsa.logLevel`                       | Minimum level of logs to see. Possible values: debug, info, error.                                | `debug`                 |
| `web.tsa.listenIp`                       | IP address on which to listen for SSH.                                                            | `0.0.0.0`               |
| `web.tsa.containerPort`                  | Port on which to listen for SSH.                                                                  | `2222`                  |
| `web.tsa.debugListenIp`                  | IP address on which to listen for the pprof debugger endpoints (default: 127.0.0.1)               | `127.0.0.1`             |
| `web.tsa.debugContainerPort`             | Port on which to listen for TSA pprof server.                                                     | `2221`                  |
| `web.tsa.hostKey`                        | Path to private key to use for the SSH server.                                                    | `nil`                   |
| `web.tsa.atcUrl`                         | ATC API endpoints to which workers will be registered.                                            | `nil`                   |
| `web.tsa.heartbeatInterval`              | Interval on which to heartbeat workers to the ATC.                                                | `30s`                   |
| `web.tsa.gardenRequestTimeout`           | How long to wait for requests to Garden to complete. 0 means no timeout.                          | `nil`                   |
| `web.auth.cookieSecure`                  | use cookie secure true or flase                                                                   | `false`                 |
| `web.auth.duration`                      | Length of time for which tokens are valid. Afterwards, users will have to log back in.            | `24h`                   |
| `web.auth.passwordConnector`             | The connector to use for password authentication for `fly login -u ... -p ...`.                   | `nil`                   |
| `web.auth.mainTeam.config`               | Configuration file for specifying the main teams params.                                          | `""`                    |
| `web.auth.mainTeam.localUser`            | Comma-separated list of local Concourse users to be included as members of the `main` team.       | `test`                  |
| `web.auth.userIDFieldPerConnector`       | Define how to display user ID for each authentication connector.                                  | `""`                    |


### web.ingress

| Name                            | Description                                                                                   | Value                    |
| ------------------------------- | --------------------------------------------------------------------------------------------- | ------------------------ |
| `web.ingress.enabled`           | Ingress configuration enabled                                                                 | `false`                  |
| `web.ingress.certManager`       | Add annotations for cert-manager                                                              | `false`                  |
| `web.ingress.annotations`       | Annotations to be added to the web ingress.                                                   | `{}`                     |
| `web.ingress.hostname`          |                                                                                               | `concourse.local`        |
| `web.ingress.path`              | The Path to Concourse                                                                         | `/`                      |
| `web.ingress.rulesOverride`     | Ingress rules override                                                                        | `nil`                    |
| `web.ingress.tls`               | TLS configuration.                                                                            | `false`                  |
| `web.ingress.pathType`          | Ingress Path type                                                                             | `ImplementationSpecific` |
| `web.ingress.extraHosts`        | The list of additional hostnames to be covered with this ingress record.                      | `[]`                     |
| `web.ingress.extraTls`          | The tls configuration for additional hostnames to be covered with this ingress record.        | `[]`                     |
| `web.ingress.secrets`           | If you're providing your own certificates, please use this to add the certificates as secrets | `[]`                     |
| `web.podAnnotations`            | Annotations for web pods                                                                      | `{}`                     |
| `web.podAffinityPreset`         | Pod affinity preset. Ignored if `web.affinity` is set. Allowed values: `soft` or `hard`       | `""`                     |
| `web.podAntiAffinityPreset`     | Pod anti-affinity preset. Ignored if `web.affinity` is set. Allowed values: `soft` or `hard`  | `soft`                   |
| `web.nodeAffinityPreset.type`   | Node affinity preset type. Ignored if `web.affinity` is set. Allowed values: `soft` or `hard` | `""`                     |
| `web.nodeAffinityPreset.key`    | Node label key to match. Ignored if `web.affinity` is set                                     | `""`                     |
| `web.nodeAffinityPreset.values` | Node label values to match. Ignored if `web.affinity` is set                                  | `[]`                     |
| `web.affinity`                  | Affinity for web pods assignment                                                              | `{}`                     |
| `web.nodeSelector`              | Node labels for web pods assignment                                                           | `{}`                     |
| `web.tolerations`               | Tolerations for web pods assignment                                                           | `[]`                     |
| `web.updateStrategy.type`       | web statefulset strategy type                                                                 | `RollingUpdate`          |
| `web.priorityClassName`         | web pods' priorityClassName                                                                   | `""`                     |
| `web.lifecycleHooks`            | for the web container(s) to automate configuration before or after startup                    | `{}`                     |
| `web.extraEnvVars`              | Array with extra environment variables to add to web nodes                                    | `[]`                     |
| `web.baseResourceTypeDefaults`  | Configuration file for specifying defaults for base resource types                            | `""`                     |
| `web.extraEnvVarsCM`            | Name of existing ConfigMap containing extra env vars for web nodes                            | `nil`                    |
| `web.extraEnvVarsSecret`        | Name of existing Secret containing extra env vars for web nodes                               | `nil`                    |
| `web.extraVolumes`              | Optionally specify extra list of additional volumes for the web pod(s)                        | `[]`                     |
| `web.extraVolumeMounts`         | Optionally specify extra list of additional volumeMounts for the web container(s)             | `[]`                     |
| `web.sidecars`                  | Add additional sidecar containers to the web pod(s)                                           | `{}`                     |
| `web.initContainers`            | Add additional init containers to the web pod(s)                                              | `{}`                     |
| `web.existingSecret`            |                                                                                               | `nil`                    |


### Worker 

| Name                                         | Description                                                                                       | Value                    |
| -------------------------------------------- | ------------------------------------------------------------------------------------------------- | ------------------------ |
| `worker.enabled`                             |                                                                                                   | `true`                   |
| `worker.replicaCount`                        |                                                                                                   | `2`                      |
| `worker.mode`                                | Selects kind of Deployment. Valid Options are: statefulSet | deployment                           | `statefulSet`            |
| `worker.workDir`                             | Directory in which to place container data.                                                       | `/opt/bitnami/concourse` |
| `worker.nameOverride`                        | provide a name to substitute for the full names of resources                                      | `nil`                    |
| `worker.logLevel`                            | Minimum level of logs to see. Possible options: debug, info, error                                | `debug`                  |
| `worker.keySecretsPath`                      | For managing where secrets should be mounted for worker agents                                    | `/concourse-keys`        |
| `worker.args`                                |                                                                                                   | `[]`                     |
| `worker.listenIp`                            | IP address on which to listen for the Garden server.                                              | `127.0.0.1`              |
| `worker.containerPort`                       | Port on which to listen for the Garden server.                                                    | `7777`                   |
| `worker.autoscaling.enabled`                 |                                                                                                   | `false`                  |
| `worker.autoscaling.maxReplicas`             |                                                                                                   | `nil`                    |
| `worker.autoscaling.minReplicas`             |                                                                                                   | `nil`                    |
| `worker.autoscaling.builtInMetrics`          |                                                                                                   | `[]`                     |
| `worker.autoscaling.customMetrics`           |                                                                                                   | `[]`                     |
| `worker.pdb.create`                          |                                                                                                   | `true`                   |
| `worker.pdb.minAvailable`                    | Minimum number of workers available after an eviction                                             | `2`                      |
| `worker.livenessProbe.enabled`               | Enable livenessProbe on worker nodes                                                              | `true`                   |
| `worker.livenessProbe.initialDelaySeconds`   | Initial delay seconds for livenessProbe                                                           | `10`                     |
| `worker.livenessProbe.periodSeconds`         | Period seconds for livenessProbe                                                                  | `15`                     |
| `worker.livenessProbe.timeoutSeconds`        | Timeout seconds for livenessProbe                                                                 | `3`                      |
| `worker.livenessProbe.failureThreshold`      | Failure threshold for livenessProbe                                                               | `5`                      |
| `worker.livenessProbe.successThreshold`      | Failure threshold for livenessProbe                                                               | `1`                      |
| `worker.readinessProbe`                      | Configures the readiness probes.                                                                  | `{}`                     |
| `worker.customLivenessProbe`                 | Custom livenessProbe that overrides the default one                                               | `{}`                     |
| `worker.customReadinessProbe`                | Custom readinessProbe that overrides the default one                                              | `{}`                     |
| `worker.resources.limits`                    | Configure resource limits.                                                                        | `{}`                     |
| `worker.resources.requests`                  | Configure resource request                                                                        | `{}`                     |
| `worker.podSecurityContext.enabled`          | Enabled web pods' Security Context                                                                | `true`                   |
| `worker.podSecurityContext.fsGroup`          | Set web pod's Security Context fsGroup                                                            | `1001`                   |
| `worker.containerSecurityContext.enabled`    | Enabled web containers' Security Context                                                          | `true`                   |
| `worker.containerSecurityContext.privileged` | Set web containers' Security Context with privileged or not                                       | `true`                   |
| `worker.psp.create`                          | Specifies whether a PodSecurityPolicy should be created (set `psp.create` to `true` to enable it) | `false`                  |
| `worker.podLabels`                           |                                                                                                   | `{}`                     |
| `worker.podAnnotations`                      | Annotations for web pods                                                                          | `{}`                     |
| `worker.podAffinityPreset`                   | Pod affinity preset. Ignored if `web.affinity` is set. Allowed values: `soft` or `hard`           | `""`                     |
| `worker.podAntiAffinityPreset`               | Pod anti-affinity preset                                                                          | `soft`                   |
| `worker.hostAliases`                         | Deployment pod host aliases                                                                       | `[]`                     |
| `worker.nodeAffinityPreset.type`             | Node affinity type                                                                                | `""`                     |
| `worker.nodeAffinityPreset.key`              | Node label key to match                                                                           | `""`                     |
| `worker.nodeAffinityPreset.values`           | Node label values to match                                                                        | `[]`                     |
| `worker.nodeAffinityPreset.affinity`         | Affinity for pod assignment                                                                       | `{}`                     |
| `worker.nodeSelector`                        | Node labels for pod assignment                                                                    | `{}`                     |
| `worker.tolerations`                         | Tolerations for worker pod assignment                                                             | `[]`                     |
| `worker.updateStrategy.type`                 | web statefulset strategy type                                                                     | `RollingUpdate`          |
| `worker.priorityClassName`                   | web pods' priorityClassName                                                                       | `""`                     |
| `worker.lifecycleHooks`                      | for the web container(s) to automate configuration before or after startup                        | `{}`                     |
| `worker.extraEnvVars`                        | Array with extra environment variables to add to web nodes                                        | `[]`                     |
| `worker.extraEnvVarsCM`                      | Name of existing ConfigMap containing extra env vars for web nodes                                | `nil`                    |
| `worker.extraEnvVarsSecret`                  | Name of existing Secret containing extra env vars for web nodes                                   | `nil`                    |
| `worker.extraVolumes`                        | Optionally specify extra list of additional volumes for the web pod(s)                            | `[]`                     |
| `worker.extraVolumeMounts`                   | Optionally specify extra list of additional volumeMounts for the web container(s)                 | `[]`                     |
| `worker.sidecars`                            | Add additional sidecar containers to the web pod(s)                                               | `{}`                     |
| `worker.initContainers`                      | Add additional init containers to the web pod(s)                                                  | `{}`                     |
| `worker.existingSecret`                      | name of an existing secret resource containing the keys and the pub                               | `nil`                    |
| `worker.baggageclaim.logLevel`               | Minimum level of logs to see. Possible values: debug, info, error                                 | `info`                   |
| `worker.baggageclaim.listenIp`               | IP address on which to listen for API traffic.                                                    | `127.0.0.1`              |
| `worker.baggageclaim.containerPort`          | Port on which to listen for API traffic.                                                          | `7788`                   |
| `worker.baggageclaim.debugListenIp`          | IP address on which to listen for the pprof debugger endpoints.                                   | `127.0.0.1`              |
| `worker.baggageclaim.debugContainerPort`     | Port on which to listen for baggageclaim pprof server.                                            | `7787`                   |
| `worker.baggageclaim.disableUserNamespaces`  | Disable remapping of user/group IDs in unprivileged volumes.                                      | `nil`                    |
| `worker.baggageclaim.volumes`                | Directory in which to place volume data.                                                          | `nil`                    |
| `worker.baggageclaim.driver`                 | Driver to use for managing volumes.                                                               | `nil`                    |
| `worker.baggageclaim.btrfsBin`               | Path to btrfs binary                                                                              | `btrfs`                  |
| `worker.baggageclaim.mkfsBin`                | Path to mkfs.btrfs binary                                                                         | `mkfs.btrfs`             |
| `worker.baggageclaim.overlaysDir`            | Path to directory in which to store overlay data                                                  | `nil`                    |
| `worker.additionalCertificates`              |                                                                                                   | `false`                  |
| `worker.affinity`                            | Affinity for worker pod assignment                                                                | `[]`                     |
| `worker.persistence.enabled`                 | Enable persistence using Persistent Volume Claims                                                 | `true`                   |
| `worker.persistence.storageClass`            | Persistent Volume storage class                                                                   | `nil`                    |
| `worker.persistence.annotations`             | Persistent Volume Claim annotations                                                               | `{}`                     |
| `worker.persistence.accessModes`             | Persistent Volume access modes                                                                    | `[]`                     |
| `worker.persistence.size`                    | Persistent Volume size                                                                            | `8Gi`                    |
| `worker.persistence.selector`                | Additional labels to match for the PVC                                                            | `{}`                     |
| `worker.persistence.existingClaim`           | A manually managed Persistent Volume Claim                                                        | `nil`                    |


### Service

| Name                                             | Description                                                                                                   | Value       |
| ------------------------------------------------ | ------------------------------------------------------------------------------------------------------------- | ----------- |
| `service.web.type`                               | For minikube, set this to ClusterIP, elsewhere use LoadBalancer or NodePort                                   | `ClusterIP` |
| `service.web.port`                               | Service HTTP port                                                                                             | `8080`      |
| `service.web.clusterIP`                          | When using `service.web.type: ClusterIP`, sets the user-specified cluster IP.                                 | `nil`       |
| `service.web.loadBalancerIP`                     | When using `service.web.type: LoadBalancer`, sets the user-specified load balancer IP.                        | `nil`       |
| `service.web.labels`                             | Additional Labels to be added to the web api service.                                                         | `nil`       |
| `service.web.annotations`                        | Annotations to be added to the web api service.                                                               | `{}`        |
| `service.web.loadBalancerSourceRanges`           | When using `service.web.type: LoadBalancer`, restrict access to the load balancer to particular IPs           | `nil`       |
| `service.web.nodePort`                           | When using `service.web.type: NodePort`, sets the nodePort for api                                            | `nil`       |
| `service.web.tlsNodePort`                        | When using `service.web.type: NodePort`, sets the nodePort for api tls                                        | `nil`       |
| `service.workerGateway.type`                     | For minikube, set this to ClusterIP, elsewhere use LoadBalancer or NodePort                                   | `ClusterIP` |
| `service.workerGateway.clusterIP`                | When using `service.workerGateway.type: ClusterIP`, sets the user-specified cluster IP.                       | `nil`       |
| `service.workerGateway.port`                     | Service HTTP port                                                                                             | `2222`      |
| `service.workerGateway.loadBalancerIP`           | When using `service.workerGateway.type: LoadBalancer`, sets the user-specified load balancer IP.              | `nil`       |
| `service.workerGateway.labels`                   | Additional Labels to be added to the web workerGateway service.                                               | `nil`       |
| `service.workerGateway.annotations`              | Annotations to be added to the web workerGateway service.                                                     | `{}`        |
| `service.workerGateway.loadBalancerSourceRanges` | When using `service.workerGateway.type: LoadBalancer`, restrict access to the load balancer to particular IPs | `nil`       |
| `service.workerGateway.nodePort`                 | When using `service.workerGateway.type: NodePort`, sets the nodePort for tsa                                  | `nil`       |


### Init Container Parameters

| Name                                                   | Description                                                                                     | Value                   |
| ------------------------------------------------------ | ----------------------------------------------------------------------------------------------- | ----------------------- |
| `volumePermissions.enabled`                            | Enable init container that changes the owner/group of the PV mount point to `runAsUser:fsGroup` | `false`                 |
| `volumePermissions.image.registry`                     | Bitnami Shell image registry                                                                    | `docker.io`             |
| `volumePermissions.image.repository`                   | Bitnami Shell image repository                                                                  | `bitnami/bitnami-shell` |
| `volumePermissions.image.tag`                          | Bitnami Shell image tag (immutable tags are recommended)                                        | `10`                    |
| `volumePermissions.image.pullPolicy`                   | Bitnami Shell image pull policy                                                                 | `Always`                |
| `volumePermissions.image.pullSecrets`                  | Bitnami Shell image pull secrets                                                                | `[]`                    |
| `volumePermissions.resources.limits`                   | The resources limits for the init container                                                     | `{}`                    |
| `volumePermissions.resources.requests`                 | The requested resources for the init container                                                  | `{}`                    |
| `volumePermissions.containerSecurityContext.runAsUser` | Set init container's Security Context runAsUser                                                 | `0`                     |


### Other Parameters

| Name                                         | Description                                                                                                  | Value               |
| -------------------------------------------- | ------------------------------------------------------------------------------------------------------------ | ------------------- |
| `rbac.create`                                | Specifies whether RBAC resources should be created                                                           | `true`              |
| `secrets.create`                             | Create the secret resource from the following values. Set this to                                            | `true`              |
| `secrets.localAuth.enabled`                  | the use of local authentication (basic auth).                                                                | `true`              |
| `secrets.annotations`                        | Annotations to be added to the secrets.                                                                      | `{}`                |
| `secrets.teamAuthorizedKeys`                 | Array of team names and public keys for team external workers. A single                                      | `[]`                |
| `secrets.localUsers`                         | List of `username:password` or `username:bcrypted_password` combinations for all your local concourse users. | `test:test`         |
| `secrets.hostKey`                            | Concourse Host Keys.                                                                                         | `nil`               |
| `secrets.hostKeyPub`                         | Concourse Host Keys.                                                                                         | `nil`               |
| `secrets.sessionSigningKey`                  | Concourse Session Signing Keys.                                                                              | `nil`               |
| `secrets.workerKey`                          | Concourse Worker Keys.                                                                                       | `nil`               |
| `secrets.workerKeyPub`                       | Concourse Worker Keys.                                                                                       | `nil`               |
| `postgresql.enabled`                         | Switch to enable or disable the PostgreSQL helm chart                                                        | `true`              |
| `postgresql.postgresqlUsername`              | Airflow Postgresql username                                                                                  | `bn_concourse`      |
| `postgresql.postgresqlDatabase`              | Airflow Postgresql database                                                                                  | `bitnami_concourse` |
| `postgresql.existingSecret`                  | Name of an existing secret containing the PostgreSQL password ('postgresql-password' key)                    | `nil`               |
| `externalDatabase.host`                      | Database host                                                                                                | `localhost`         |
| `externalDatabase.user`                      | non-root Username for Airflow Database                                                                       | `bn_concourse`      |
| `externalDatabase.password`                  | Database password                                                                                            | `nil`               |
| `externalDatabase.existingSecret`            | Name of an existing secret resource containing the DB password                                               | `nil`               |
| `externalDatabase.existingSecretPasswordKey` | Name of an existing secret key containing the DB password                                                    | `nil`               |
| `externalDatabase.database`                  | Database name                                                                                                | `bitnami_concourse` |
| `externalDatabase.port`                      | Database port number                                                                                         | `5432`              |


See https://github.com/bitnami-labs/readme-generator-for-helm to create the table

The above parameters map to the env variables defined in [bitnami/concourse](http://github.com/bitnami/bitnami-docker-concourse). For more information please refer to the [bitnami/concourse](http://github.com/bitnami/bitnami-docker-concourse) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
  --set concourseUsername=admin \
  --set concoursePassword=password \
  --set mariadb.auth.rootPassword=secretpassword \
    bitnami/concourse
```

The above command sets the concourse administrator account username and password to `admin` and `password` respectively. Additionally, it sets the MariaDB `root` user password to `secretpassword`.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml bitnami/concourse
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### External database support

You may want to have concourse connect to an external database rather than installing one inside your cluster. Typical reasons for this are to use a managed database service, or to share a common database server for all your applications. To achieve this, the chart allows you to specify credentials for an external database with the [`externalDatabase` parameter](#parameters). You should also disable the MariaDB installation with the `mariadb.enabled` option. Here is an example:

```console
mariadb.enabled=false
externalDatabase.host=myexternalhost
externalDatabase.user=myuser
externalDatabase.password=mypassword
externalDatabase.database=mydatabase
externalDatabase.port=3306
```

### Ingress


This chart provides support for Ingress resources. If an Ingress controller, such as [nginx-ingress](https://kubeapps.com/charts/stable/nginx-ingress) or [traefik](https://kubeapps.com/charts/stable/traefik), that Ingress controller can be used to serve concourse.

To enable Ingress integration, set `ingress.enabled` to `true`. The `ingress.hostname` property can be used to set the host name. The `ingress.tls` parameter can be used to add the TLS configuration for this host. It is also possible to have more than one host, with a separate TLS configuration for each host. [Learn more about configuring and using Ingress](https://docs.bitnami.com/kubernetes/apps/concourse/configuration/configure-use-ingress/).

### TLS secrets

The chart also facilitates the creation of TLS secrets for use with the Ingress controller, with different options for certificate management. [Learn more about TLS secrets](https://docs.bitnami.com/kubernetes/apps/concourse/administration/enable-tls/).


## Persistence

The [Bitnami Concourse](https://github.com/bitnami/bitnami-docker-concourse) image stores the concourse data and configurations at the `/bitnami` path of the container. Persistent Volume Claims are used to keep the data across deployments. [Learn more about persistence in the chart documentation](https://docs.bitnami.com/kubernetes/apps/concourse/configuration/chart-persistence/).

### Additional environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `extraEnvVars` property.

```yaml
concourse:
  extraEnvVars:
    - name: LOG_LEVEL
      value: error
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values.

### Sidecars

If additional containers are needed in the same pod as concourse (such as additional metrics or logging exporters), they can be defined using the `sidecars` parameter. If these sidecars export extra ports, extra port definitions can be added using the `service.extraPorts` parameter. [Learn more about configuring and using sidecar containers](https://docs.bitnami.com/kubernetes/apps/concourse/administration/configure-use-sidecars/).

### Pod affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, use one of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).
