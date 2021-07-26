# Tomcat

[Apache Tomcat](http://tomcat.apache.org/), often referred to as Tomcat, is an open-source web server and servlet container developed by the Apache Software Foundation. Tomcat implements several Java EE specifications including Java Servlet, JavaServer Pages, Java EL, and WebSocket, and provides a "pure Java" HTTP web server environment for Java code to run in.

## TL;DR

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/tomcat
```

## Introduction

This chart bootstraps a [Tomcat](https://github.com/bitnami/bitnami-docker-tomcat) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This Helm chart has been tested on top of [Bitnami Kubernetes Production Runtime](https://kubeprod.io/) (BKPR). Deploy BKPR to get automated TLS certificates, logging and monitoring for your applications.

## Prerequisites

- Kubernetes 1.12+
- Helm 3.1.0
- PV provisioner support in the underlying infrastructure
- ReadWriteMany volumes for deployment scaling

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/tomcat
```

These commands deploy Tomcat on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
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

| Name                | Description                                                                                  | Value           |
| ------------------- | -------------------------------------------------------------------------------------------- | --------------- |
| `kubeVersion`       | Force target Kubernetes version (using Helm capabilities if not set)                         | `""`            |
| `nameOverride`      | String to partially override common.names.fullname template (will maintain the release name) | `""`            |
| `fullnameOverride`  | String to fully override common.names.fullname template                                      | `""`            |
| `commonLabels`      | Add labels to all the deployed resources                                                     | `{}`            |
| `commonAnnotations` | Add annotations to all the deployed resources                                                | `{}`            |
| `clusterDomain`     | Kubernetes Cluster Domain                                                                    | `cluster.local` |
| `extraDeploy`       | Array of extra objects to deploy with the release                                            | `[]`            |


### Tomcat parameters

| Name                          | Description                                                          | Value                 |
| ----------------------------- | -------------------------------------------------------------------- | --------------------- |
| `image.registry`              | Tomcat image registry                                                | `docker.io`           |
| `image.repository`            | Tomcat image repository                                              | `bitnami/tomcat`      |
| `image.tag`                   | Tomcat image tag (immutable tags are recommended)                    | `10.0.8-debian-10-r1` |
| `image.pullPolicy`            | Tomcat image pull policy                                             | `IfNotPresent`        |
| `image.pullSecrets`           | Specify docker-registry secret names as an array                     | `[]`                  |
| `image.debug`                 | Specify if debug logs should be enabled                              | `false`               |
| `hostAliases`                 | Deployment pod host aliases                                          | `[]`                  |
| `tomcatUsername`              | Tomcat admin user                                                    | `user`                |
| `tomcatPassword`              | Tomcat admin password                                                | `""`                  |
| `tomcatAllowRemoteManagement` | Enable remote access to management interface                         | `0`                   |
| `command`                     | Override default container command (useful when using custom images) | `[]`                  |
| `args`                        | Override default container args (useful when using custom images)    | `[]`                  |
| `extraEnvVars`                | Extra environment variables to be set on Tomcat container            | `[]`                  |
| `extraEnvVarsCM`              | Name of existing ConfigMap containing extra environment variables    | `""`                  |
| `extraEnvVarsSecret`          | Name of existing Secret containing extra environment variables       | `""`                  |


### Tomcat deployment parameters

| Name                                 | Description                                                                                       | Value           |
| ------------------------------------ | ------------------------------------------------------------------------------------------------- | --------------- |
| `replicaCount`                       | Specify number of Tomcat replicas                                                                 | `1`             |
| `deployment.type`                    | Use Deployment or StatefulSet                                                                     | `deployment`    |
| `updateStrategy.type`                | StrategyType                                                                                      | `RollingUpdate` |
| `containerPort`                      | HTTP port to expose at container level                                                            | `8080`          |
| `containerExtraPorts`                | Extra ports to expose at container level                                                          | `{}`            |
| `podSecurityContext.enabled`         | Enable Tomcat pods' Security Context                                                              | `true`          |
| `podSecurityContext.fsGroup`         | Set Tomcat pod's Security Context fsGroup                                                         | `1001`          |
| `containerSecurityContext.enabled`   | Enable Tomcat containers' SecurityContext                                                         | `true`          |
| `containerSecurityContext.runAsUser` | User ID for the Tomcat container                                                                  | `1001`          |
| `resources.limits`                   | The resources limits for the Tomcat container                                                     | `{}`            |
| `resources.requests`                 | The requested resources for the Tomcat container                                                  | `{}`            |
| `livenessProbe.enabled`              | Enable livenessProbe                                                                              | `true`          |
| `livenessProbe.httpGet.path`         | Request path for livenessProbe                                                                    | `/`             |
| `livenessProbe.httpGet.port`         | Port for livenessProbe                                                                            | `http`          |
| `livenessProbe.initialDelaySeconds`  | Initial delay seconds for livenessProbe                                                           | `120`           |
| `livenessProbe.periodSeconds`        | Period seconds for livenessProbe                                                                  | `10`            |
| `livenessProbe.timeoutSeconds`       | Timeout seconds for livenessProbe                                                                 | `5`             |
| `livenessProbe.failureThreshold`     | Failure threshold for livenessProbe                                                               | `6`             |
| `livenessProbe.successThreshold`     | Success threshold for livenessProbe                                                               | `1`             |
| `readinessProbe.enabled`             | Enable readinessProbe                                                                             | `true`          |
| `readinessProbe.httpGet.path`        | Request path for readinessProbe                                                                   | `/`             |
| `readinessProbe.httpGet.port`        | Port for readinessProbe                                                                           | `http`          |
| `readinessProbe.initialDelaySeconds` | Initial delay seconds for readinessProbe                                                          | `30`            |
| `readinessProbe.periodSeconds`       | Period seconds for readinessProbe                                                                 | `5`             |
| `readinessProbe.timeoutSeconds`      | Timeout seconds for readinessProbe                                                                | `3`             |
| `readinessProbe.failureThreshold`    | Failure threshold for readinessProbe                                                              | `3`             |
| `readinessProbe.successThreshold`    | Success threshold for readinessProbe                                                              | `1`             |
| `customLivenessProbe`                | Override default liveness probe                                                                   | `{}`            |
| `customReadinessProbe`               | Override default readiness probe                                                                  | `{}`            |
| `podLabels`                          | Extra labels for Tomcat pods                                                                      | `{}`            |
| `podAnnotations`                     | Annotations for Tomcat pods                                                                       | `{}`            |
| `podAffinityPreset`                  | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`               | `""`            |
| `podAntiAffinityPreset`              | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`          | `soft`          |
| `nodeAffinityPreset.type`            | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`         | `""`            |
| `nodeAffinityPreset.key`             | Node label key to match. Ignored if `affinity` is set.                                            | `""`            |
| `nodeAffinityPreset.values`          | Node label values to match. Ignored if `affinity` is set.                                         | `[]`            |
| `affinity`                           | Affinity for pod assignment. Evaluated as a template.                                             | `{}`            |
| `nodeSelector`                       | Node labels for pod assignment. Evaluated as a template.                                          | `{}`            |
| `tolerations`                        | Tolerations for pod assignment. Evaluated as a template.                                          | `[]`            |
| `extraVolumes`                       | Optionally specify extra list of additional volumes for Tomcat pods in Deployment                 | `[]`            |
| `extraVolumeClaimTemplates`          | Optionally specify extra list of additional volume claim templates for Tomcat pods in StatefulSet | `[]`            |
| `extraVolumeMounts`                  | Optionally specify extra list of additional volumeMounts for Tomcat container(s)                  | `[]`            |
| `initContainers`                     | Add init containers to the Tomcat pods.                                                           | `[]`            |
| `sidecars`                           | Add sidecars to the Tomcat pods.                                                                  | `[]`            |
| `persistence.enabled`                | Enable persistence                                                                                | `true`          |
| `persistence.storageClass`           | PVC Storage Class for Tomcat volume                                                               | `""`            |
| `persistence.annotations`            | Persistent Volume Claim annotations                                                               | `{}`            |
| `persistence.accessModes`            | PVC Access Modes for Tomcat volume                                                                | `[]`            |
| `persistence.size`                   | PVC Storage Request for Tomcat volume                                                             | `8Gi`           |
| `persistence.existingClaim`          | An Existing PVC name for Tomcat volume                                                            | `""`            |
| `persistence.selectorLabels`         | Selector labels to use in volume claim template in statefulset                                    | `{}`            |


### Traffic Exposure parameters

| Name                            | Description                                                                                   | Value                    |
| ------------------------------- | --------------------------------------------------------------------------------------------- | ------------------------ |
| `service.type`                  | Kubernetes Service type                                                                       | `LoadBalancer`           |
| `service.port`                  | Service HTTP port                                                                             | `80`                     |
| `service.nodePort`              | Kubernetes http node port                                                                     | `""`                     |
| `service.loadBalancerIP`        | Port Use serviceLoadBalancerIP to request a specific static IP, otherwise leave blank         | `""`                     |
| `service.externalTrafficPolicy` | Enable client source IP preservation                                                          | `Cluster`                |
| `service.annotations`           | Annotations for Tomcat service                                                                | `{}`                     |
| `ingress.enabled`               | Enable ingress controller resource                                                            | `false`                  |
| `ingress.certManager`           | Set this to true in order to add the corresponding annotations for cert-manager               | `false`                  |
| `ingress.hostname`              | Default host for the ingress resource                                                         | `tomcat.local`           |
| `ingress.annotations`           | Ingress annotations                                                                           | `{}`                     |
| `ingress.tls`                   | Enable TLS configuration for the hostname defined at `ingress.hostname` parameter             | `false`                  |
| `ingress.extraHosts`            | The list of additional hostnames to be covered with this ingress record.                      | `[]`                     |
| `ingress.extraTls`              | The tls configuration for additional hostnames to be covered with this ingress record.        | `[]`                     |
| `ingress.secrets`               | If you're providing your own certificates, please use this to add the certificates as secrets | `[]`                     |
| `ingress.apiVersion`            | Force Ingress API version (automatically detected if not set)                                 | `""`                     |
| `ingress.path`                  | Ingress path                                                                                  | `/`                      |
| `ingress.pathType`              | Ingress path type                                                                             | `ImplementationSpecific` |


### Volume Permissions parameters

| Name                                   | Description                                                                 | Value                   |
| -------------------------------------- | --------------------------------------------------------------------------- | ----------------------- |
| `volumePermissions.enabled`            | Enable init container that changes volume permissions in the data directory | `false`                 |
| `volumePermissions.image.registry`     | Init container volume-permissions image registry                            | `docker.io`             |
| `volumePermissions.image.repository`   | Init container volume-permissions image repository                          | `bitnami/bitnami-shell` |
| `volumePermissions.image.tag`          | Init container volume-permissions image tag                                 | `10-debian-10-r126`     |
| `volumePermissions.image.pullPolicy`   | Init container volume-permissions image pull policy                         | `Always`                |
| `volumePermissions.image.pullSecrets`  | Specify docker-registry secret names as an array                            | `[]`                    |
| `volumePermissions.resources.limits`   | Init container volume-permissions resource  limits                          | `{}`                    |
| `volumePermissions.resources.requests` | Init container volume-permissions resource  requests                        | `{}`                    |


The above parameters map to the env variables defined in [bitnami/tomcat](http://github.com/bitnami/bitnami-docker-tomcat). For more information please refer to the [bitnami/tomcat](http://github.com/bitnami/bitnami-docker-tomcat) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install my-release \
  --set tomcatUser=manager,tomcatPassword=password bitnami/tomcat
```

The above command sets the Tomcat management username and password to `manager` and `password` respectively.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
$ helm install my-release -f values.yaml bitnami/tomcat
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling vs Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Change Tomcat version

To modify the Tomcat version used in this chart, specify a [valid image tag](https://hub.docker.com/r/bitnami/tomcat/tags/) using the `image.tag` parameter - for example, `image.tag=X.Y.Z`. This approach is also applicable to other images like exporters.

### Add extra environment variables

To add extra environment variables (useful for advanced operations like custom init scripts), use the `extraEnvVars` property.

```yaml
extraEnvVars:
  - name: LOG_LEVEL
    value: DEBUG
```

Alternatively, define a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values.

### Use Sidecars and Init Containers

If additional containers are needed in the same pod (such as additional metrics or logging exporters), they can be defined using the `sidecars` config parameter. Similarly, extra init containers can be added using the `initContainers` parameter.

Refer to the chart documentation for more information on, and examples of, configuring and using [sidecars and init containers](https://docs.bitnami.com/kubernetes/infrastructure/tomcat/configuration/configure-sidecar-init-containers/).

### Set Pod affinity

This chart allows you to set custom Pod affinity using the `affinity` parameter. Find more information about Pod's affinity in the [Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, use one of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

## Persistence

The [Bitnami Tomcat](https://github.com/bitnami/bitnami-docker-tomcat) image stores the Tomcat data and configurations at the `/bitnami/tomcat` path of the container.

Persistent Volume Claims (PVCs) are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.

See the [Parameters](#parameters) section to configure the PVC or to disable persistence.

### Adjust permissions of persistent volume mountpoint

As the image run as non-root by default, it is necessary to adjust the ownership of the persistent volume so that the container can write data into it.

By default, the chart is configured to use Kubernetes Security Context to automatically change the ownership of the volume. However, this feature does not work in all Kubernetes distributions.
As an alternative, this chart supports using an init container to change the ownership of the volume before mounting it in the final destination.

You can enable this init container by setting `volumePermissions.enabled` to `true`.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami’s Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 8.0.0

- Chart labels were adapted to follow the [Helm charts standard labels](https://helm.sh/docs/chart_best_practices/labels/#standard-labels).
- Ingress configuration was also adapted to follow the Helm charts best practices.
- This version also introduces `bitnami/common`, a [library chart](https://helm.sh/docs/topics/library_charts/#helm) as a dependency. More documentation about this new utility could be found [here](https://github.com/bitnami/charts/tree/master/bitnami/common#bitnami-common-library-chart). Please, make sure that you have updated the chart dependencies before executing any upgrade.

Consequences:

- Backwards compatibility is not guaranteed. However, you can easily workaround this issue by removing Tomcat deployment before upgrading (the following example assumes that the release name is `tomcat`):

```console
$ export TOMCAT_PASSWORD=$(kubectl get secret --namespace default tomcat -o jsonpath="{.data.tomcat-password}" | base64 --decode)
$ kubectl delete deployments.apps tomcat
$ helm upgrade tomcat bitnami/tomcat --set tomcatPassword=$TOMCAT_PASSWORD
```

### To 7.0.0

[On November 13, 2020, Helm v2 support formally ended](https://github.com/helm/charts#status-of-the-project). This major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

[Learn more about this change and related upgrade considerations](https://docs.bitnami.com/kubernetes/infrastructure/tomcat/administration/upgrade-helm3/).

### To 5.0.0

This release updates the Bitnami Tomcat container to `9.0.26-debian-9-r0`, which is based on Bash instead of Node.js.

### To 2.1.0

Tomcat container was moved to a non-root approach. There shouldn't be any issue when upgrading since the corresponding `securityContext` is enabled by default. Both the container image and the chart can be upgraded by running the command below:

```
$ helm upgrade my-release bitnami/tomcat
```

If you use a previous container image (previous to **8.5.35-r26**) disable the `securityContext` by running the command below:

```
$ helm upgrade my-release bitnami/tomcat --set securityContext.enabled=false,image.tag=XXX
```

### To 1.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 1.0.0. The following example assumes that the release name is tomcat:

```console
$ kubectl patch deployment tomcat --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
```
