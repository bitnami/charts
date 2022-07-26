<!--- app-name: Jenkins -->

# Jenkins packaged by Bitnami

Jenkins is an open source Continuous Integration and Continuous Delivery (CI/CD) server designed to automate the building, testing, and deploying of any software project.

[Overview of Jenkins](http://jenkins-ci.org/)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install my-release bitnami/jenkins
```

## Introduction

This chart bootstraps a [Jenkins](https://github.com/bitnami/containers/tree/main/bitnami/jenkins) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- PV provisioner support in the underlying infrastructure
- ReadWriteMany volumes for deployment scaling

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install my-release bitnami/jenkins
```

These commands deploy Jenkins on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

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


### Jenkins Image parameters

| Name                | Description                                        | Value                  |
| ------------------- | -------------------------------------------------- | ---------------------- |
| `image.registry`    | Jenkins image registry                             | `docker.io`            |
| `image.repository`  | Jenkins image repository                           | `bitnami/jenkins`      |
| `image.tag`         | Jenkins image tag (immutable tags are recommended) | `2.346.2-debian-11-r4` |
| `image.pullPolicy`  | Jenkins image pull policy                          | `IfNotPresent`         |
| `image.pullSecrets` | Jenkins image pull secrets                         | `[]`                   |
| `image.debug`       | Enable image debug mode                            | `false`                |


### Jenkins Configuration parameters

| Name                    | Description                                                            | Value                   |
| ----------------------- | ---------------------------------------------------------------------- | ----------------------- |
| `jenkinsUser`           | Jenkins username                                                       | `user`                  |
| `jenkinsPassword`       | Jenkins user password                                                  | `""`                    |
| `jenkinsHost`           | Jenkins host to create application URLs                                | `""`                    |
| `jenkinsHome`           | Jenkins home directory                                                 | `/bitnami/jenkins/home` |
| `javaOpts`              | Custom JVM parameters                                                  | `[]`                    |
| `disableInitialization` | Skip performing the initial bootstrapping for Jenkins                  | `no`                    |
| `command`               | Override default container command (useful when using custom images)   | `[]`                    |
| `args`                  | Override default container args (useful when using custom images)      | `[]`                    |
| `extraEnvVars`          | Array with extra environment variables to add to the Jenkins container | `[]`                    |
| `extraEnvVarsCM`        | Name of existing ConfigMap containing extra env vars                   | `""`                    |
| `extraEnvVarsSecret`    | Name of existing Secret containing extra env vars                      | `""`                    |


### Jenkins deployment parameters

| Name                                    | Description                                                                               | Value           |
| --------------------------------------- | ----------------------------------------------------------------------------------------- | --------------- |
| `updateStrategy.type`                   | Jenkins deployment strategy type                                                          | `RollingUpdate` |
| `serviceAccountName`                    | Jenkins pod service account name                                                          | `default`       |
| `priorityClassName`                     | Jenkins pod priority class name                                                           | `""`            |
| `schedulerName`                         | Name of the k8s scheduler (other than default)                                            | `""`            |
| `topologySpreadConstraints`             | Topology Spread Constraints for pod assignment                                            | `[]`            |
| `hostAliases`                           | Jenkins pod host aliases                                                                  | `[]`            |
| `extraVolumes`                          | Optionally specify extra list of additional volumes for Jenkins pods                      | `[]`            |
| `extraVolumeMounts`                     | Optionally specify extra list of additional volumeMounts for Jenkins container(s)         | `[]`            |
| `sidecars`                              | Add additional sidecar containers to the Jenkins pod                                      | `[]`            |
| `initContainers`                        | Add additional init containers to the Jenkins pods                                        | `[]`            |
| `lifecycleHooks`                        | Add lifecycle hooks to the Jenkins deployment                                             | `{}`            |
| `podLabels`                             | Extra labels for Jenkins pods                                                             | `{}`            |
| `podAnnotations`                        | Annotations for Jenkins pods                                                              | `{}`            |
| `podAffinityPreset`                     | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`       | `""`            |
| `podAntiAffinityPreset`                 | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`  | `soft`          |
| `nodeAffinityPreset.type`               | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard` | `""`            |
| `nodeAffinityPreset.key`                | Node label key to match. Ignored if `affinity` is set                                     | `""`            |
| `nodeAffinityPreset.values`             | Node label values to match. Ignored if `affinity` is set                                  | `[]`            |
| `affinity`                              | Affinity for pod assignment                                                               | `{}`            |
| `nodeSelector`                          | Node labels for pod assignment                                                            | `{}`            |
| `tolerations`                           | Tolerations for pod assignment                                                            | `[]`            |
| `resources.limits`                      | The resources limits for the Jenkins container                                            | `{}`            |
| `resources.requests`                    | The requested resources for the Jenkins container                                         | `{}`            |
| `containerPorts.http`                   | Jenkins HTTP container port                                                               | `8080`          |
| `containerPorts.https`                  | Jenkins HTTPS container port                                                              | `8443`          |
| `podSecurityContext.enabled`            | Enabled Jenkins pods' Security Context                                                    | `true`          |
| `podSecurityContext.fsGroup`            | Set Jenkins pod's Security Context fsGroup                                                | `1001`          |
| `containerSecurityContext.enabled`      | Enabled Jenkins containers' Security Context                                              | `true`          |
| `containerSecurityContext.runAsUser`    | Set Jenkins container's Security Context runAsUser                                        | `1001`          |
| `containerSecurityContext.runAsNonRoot` | Set Jenkins container's Security Context runAsNonRoot                                     | `true`          |
| `startupProbe.enabled`                  | Enable startupProbe                                                                       | `false`         |
| `startupProbe.initialDelaySeconds`      | Initial delay seconds for startupProbe                                                    | `180`           |
| `startupProbe.periodSeconds`            | Period seconds for startupProbe                                                           | `10`            |
| `startupProbe.timeoutSeconds`           | Timeout seconds for startupProbe                                                          | `5`             |
| `startupProbe.failureThreshold`         | Failure threshold for startupProbe                                                        | `6`             |
| `startupProbe.successThreshold`         | Success threshold for startupProbe                                                        | `1`             |
| `livenessProbe.enabled`                 | Enable livenessProbe                                                                      | `true`          |
| `livenessProbe.initialDelaySeconds`     | Initial delay seconds for livenessProbe                                                   | `180`           |
| `livenessProbe.periodSeconds`           | Period seconds for livenessProbe                                                          | `10`            |
| `livenessProbe.timeoutSeconds`          | Timeout seconds for livenessProbe                                                         | `5`             |
| `livenessProbe.failureThreshold`        | Failure threshold for livenessProbe                                                       | `6`             |
| `livenessProbe.successThreshold`        | Success threshold for livenessProbe                                                       | `1`             |
| `readinessProbe.enabled`                | Enable readinessProbe                                                                     | `true`          |
| `readinessProbe.initialDelaySeconds`    | Initial delay seconds for readinessProbe                                                  | `30`            |
| `readinessProbe.periodSeconds`          | Period seconds for readinessProbe                                                         | `5`             |
| `readinessProbe.timeoutSeconds`         | Timeout seconds for readinessProbe                                                        | `3`             |
| `readinessProbe.failureThreshold`       | Failure threshold for readinessProbe                                                      | `3`             |
| `readinessProbe.successThreshold`       | Success threshold for readinessProbe                                                      | `1`             |
| `customStartupProbe`                    | Custom startupProbe that overrides the default one                                        | `{}`            |
| `customLivenessProbe`                   | Custom livenessProbe that overrides the default one                                       | `{}`            |
| `customReadinessProbe`                  | Custom readinessProbe that overrides the default one                                      | `{}`            |


### Traffic Exposure Parameters

| Name                               | Description                                                                                                                      | Value                    |
| ---------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `service.type`                     | Jenkins service type                                                                                                             | `LoadBalancer`           |
| `service.ports.http`               | Jenkins service HTTP port                                                                                                        | `80`                     |
| `service.ports.https`              | Jenkins service HTTPS port                                                                                                       | `443`                    |
| `service.nodePorts.http`           | Node port for HTTP                                                                                                               | `""`                     |
| `service.nodePorts.https`          | Node port for HTTPS                                                                                                              | `""`                     |
| `service.clusterIP`                | Jenkins service Cluster IP                                                                                                       | `""`                     |
| `service.loadBalancerIP`           | Jenkins service Load Balancer IP                                                                                                 | `""`                     |
| `service.loadBalancerSourceRanges` | Jenkins service Load Balancer sources                                                                                            | `[]`                     |
| `service.externalTrafficPolicy`    | Jenkins service external traffic policy                                                                                          | `Cluster`                |
| `service.annotations`              | Additional custom annotations for Jenkins service                                                                                | `{}`                     |
| `service.extraPorts`               | Extra ports to expose (normally used with the `sidecar` value)                                                                   | `[]`                     |
| `service.sessionAffinity`          | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                                                             | `None`                   |
| `service.sessionAffinityConfig`    | Additional settings for the sessionAffinity                                                                                      | `{}`                     |
| `ingress.enabled`                  | Enable ingress record generation for Jenkins                                                                                     | `false`                  |
| `ingress.pathType`                 | Ingress path type                                                                                                                | `ImplementationSpecific` |
| `ingress.apiVersion`               | Force Ingress API version (automatically detected if not set)                                                                    | `""`                     |
| `ingress.hostname`                 | Default host for the ingress record                                                                                              | `jenkins.local`          |
| `ingress.path`                     | Default path for the ingress record                                                                                              | `/`                      |
| `ingress.annotations`              | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                     |
| `ingress.tls`                      | Enable TLS configuration for the host defined at `ingress.hostname` parameter                                                    | `false`                  |
| `ingress.selfSigned`               | Create a TLS secret for this ingress record using self-signed certificates generated by Helm                                     | `false`                  |
| `ingress.extraHosts`               | An array with additional hostname(s) to be covered with the ingress record                                                       | `[]`                     |
| `ingress.extraPaths`               | An array with additional arbitrary paths that may need to be added to the ingress under the main host                            | `[]`                     |
| `ingress.extraTls`                 | TLS configuration for additional hostname(s) to be covered with this ingress record                                              | `[]`                     |
| `ingress.secrets`                  | Custom TLS certificates as secrets                                                                                               | `[]`                     |
| `ingress.ingressClassName`         | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                    | `""`                     |
| `ingress.extraRules`               | Additional rules to be covered with this ingress record                                                                          | `[]`                     |


### Persistence Parameters

| Name                                          | Description                                                                                     | Value                   |
| --------------------------------------------- | ----------------------------------------------------------------------------------------------- | ----------------------- |
| `persistence.enabled`                         | Enable persistence using Persistent Volume Claims                                               | `true`                  |
| `persistence.storageClass`                    | Persistent Volume storage class                                                                 | `""`                    |
| `persistence.existingClaim`                   | Use a existing PVC which must be created manually before bound                                  | `""`                    |
| `persistence.annotations`                     | Additional custom annotations for the PVC                                                       | `{}`                    |
| `persistence.accessModes`                     | Persistent Volume access modes                                                                  | `[]`                    |
| `persistence.size`                            | Persistent Volume size                                                                          | `8Gi`                   |
| `persistence.selector`                        | Selector to match an existing Persistent Volume for Ingester's data PVC                         | `{}`                    |
| `volumePermissions.enabled`                   | Enable init container that changes the owner/group of the PV mount point to `runAsUser:fsGroup` | `false`                 |
| `volumePermissions.image.registry`            | Bitnami Shell image registry                                                                    | `docker.io`             |
| `volumePermissions.image.repository`          | Bitnami Shell image repository                                                                  | `bitnami/bitnami-shell` |
| `volumePermissions.image.tag`                 | Bitnami Shell image tag (immutable tags are recommended)                                        | `11-debian-11-r17`      |
| `volumePermissions.image.pullPolicy`          | Bitnami Shell image pull policy                                                                 | `IfNotPresent`          |
| `volumePermissions.image.pullSecrets`         | Bitnami Shell image pull secrets                                                                | `[]`                    |
| `volumePermissions.resources.limits`          | The resources limits for the init container                                                     | `{}`                    |
| `volumePermissions.resources.requests`        | The requested resources for the init container                                                  | `{}`                    |
| `volumePermissions.securityContext.runAsUser` | Set init container's Security Context runAsUser                                                 | `0`                     |


The above parameters map to the env variables defined in [bitnami/jenkins](https://github.com/bitnami/containers/tree/main/bitnami/jenkins). For more information please refer to the [bitnami/jenkins](https://github.com/bitnami/containers/tree/main/bitnami/jenkins) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install my-release \
  --set jenkinsUser=admin \
  --set jenkinsPassword=password \
  bitnami/jenkins
```

The above command sets the Jenkins administrator account username and password to `admin` and `password` respectively.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml bitnami/jenkins
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling vs Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Configure Ingress

This chart provides support for Ingress resources. If you have an ingress controller installed on your cluster, such as [nginx-ingress-controller](https://github.com/bitnami/charts/tree/master/bitnami/nginx-ingress-controller) or [contour](https://github.com/bitnami/charts/tree/master/bitnami/contour) you can utilize the ingress controller to serve your application.

To enable Ingress integration, set `ingress.enabled` to `true`. The `ingress.hostname` property can be used to set the host name. The `ingress.tls` parameter can be used to add the TLS configuration for this host. It is also possible to have more than one host, with a separate TLS configuration for each host. [Learn more about configuring and using Ingress](https://docs.bitnami.com/kubernetes/apps/jenkins/configuration/configure-ingress/).

### Configure TLS Secrets for use with Ingress

The chart also facilitates the creation of TLS secrets for use with the Ingress controller, with different options for certificate management. [Learn more about TLS secrets](https://docs.bitnami.com/kubernetes/apps/jenkins/administration/enable-tls-ingress/).

### Configure extra environment variables

To add extra environment variables (useful for advanced operations like custom init scripts), use the `extraEnvVars` property.

```yaml
extraEnvVars:
  - name: LOG_LEVEL
    value: DEBUG
```

Alternatively, use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values.

### Configure Sidecars and Init Containers

If additional containers are needed in the same pod as Jenkins (such as additional metrics or logging exporters), they can be defined using the `sidecars` parameter. Similarly, you can add extra init containers using the `initContainers` parameter.

[Learn more about configuring and using sidecar and init containers](https://docs.bitnami.com/kubernetes/apps/jenkins/configuration/configure-sidecar-init-containers/).

### Deploy extra resources

There are cases where you may want to deploy extra objects, such a ConfigMap containing your app's configuration or some extra deployment with a micro service used by your app. For covering this case, the chart allows adding the full specification of other objects using the `extraDeploy` parameter.

### Set Pod affinity

This chart allows you to set custom Pod affinity using the `XXX.affinity` parameter(s). Find more information about Pod affinity in the [Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `XXX.podAffinityPreset`, `XXX.podAntiAffinityPreset`, or `XXX.nodeAffinityPreset` parameters.

## Persistence

The [Bitnami Jenkins](https://github.com/bitnami/containers/tree/main/bitnami/jenkins) image stores the Jenkins data and configurations at the `/bitnami/jenkins` path of the container. Persistent Volume Claims (PVCs) are used to keep the data across deployments.

If you encounter errors when working with persistent volumes, refer to our [troubleshooting guide for persistent volumes](https://docs.bitnami.com/kubernetes/faq/troubleshooting/troubleshooting-persistence-volumes/).

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 10.0.0

This major release is no longer contains the metrics section because the container `bitnami/enkins-exporter` has been deprecated due to the upstream project is not maintained.

### To 9.0.0

This major release renames several values in this chart and adds missing features, in order to be inline with the rest of assets in the Bitnami charts repository.

Affected values:
- `service.port` renamed as `service.ports.http`.
- `service.httpsPort` renamed as `service.ports.https`.
- `serviceMonitor.additionalLabels` renamed as `serviceMonitor.labels`.

### To 8.0.0

Due to recent changes in the container image (see [Notable changes](https://github.com/bitnami/containers/tree/main/bitnami/jenkins#notable-changes)), the major version of the chart has been bumped preemptively.

Upgrading from version `7.x.x` should be possible following the workaround below (the following example assumes that the release name is `jenkins`):

- Create a backup of your Jenkins data (e.g. using Velero to backup your PV)
- Remove Jenkins deployment:

```console
$ export JENKINS_PASSWORD=$(kubectl get secret --namespace default jenkins -o jsonpath="{.data.jenkins-password}" | base64 -d)
$ kubectl delete deployments.apps jenkins
```

- Upgrade your release and delete data that should not be persisted anymore:

```console
$ helm upgrade jenkins bitnami/jenkins --set jenkinsPassword=$JENKINS_PASSWORD --set jenkinsHome=/bitnami/jenkins/jenkins_home
$ kubectl exec -it $(kubectl get pod -l app.kubernetes.io/instance=jenkins,app.kubernetes.io/name=jenkins -o jsonpath="{.items[0].metadata.name}") -- find /bitnami/jenkins -mindepth 1 -maxdepth 1 -not -name jenkins_home -exec rm -rf {} \;
```

### To 7.0.0

Chart labels were adapted to follow the [Helm charts standard labels](https://helm.sh/docs/chart_best_practices/labels/#standard-labels).

Consequences:

- Backwards compatibility is not guaranteed. However, you can easily workaround this issue by removing Jenkins deployment before upgrading (the following example assumes that the release name is `jenkins`):

```console
$ export JENKINS_PASSWORD=$(kubectl get secret --namespace default jenkins -o jsonpath="{.data.jenkins-password}" | base64 -d)
$ kubectl delete deployments.apps jenkins
$ helm upgrade jenkins bitnami/jenkins --set jenkinsPassword=$JENKINS_PASSWORD
```

### To 6.1.0

This version also introduces `bitnami/common`, a [library chart](https://helm.sh/docs/topics/library_charts/#helm) as a dependency. More documentation about this new utility could be found [here](https://github.com/bitnami/charts/tree/master/bitnami/common#bitnami-common-library-chart). Please, make sure that you have updated the chart dependencies before executing any upgrade.

### To 6.0.0

[On November 13, 2020, Helm v2 support formally ended](https://github.com/helm/charts#status-of-the-project). This major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

[Learn more about this change and related upgrade considerations](https://docs.bitnami.com/kubernetes/apps/jenkins/administration/upgrade-helm3/).

### To 5.0.0

The [Bitnami Jenkins](https://github.com/bitnami/containers/tree/main/bitnami/jenkins) image was migrated to a "non-root" user approach. Previously the container ran as the `root` user and the Jenkins service was started as the `jenkins` user. From now on, both the container and the Jenkins service run as user `jenkins` (`uid=1001`). You can revert this behavior by setting the parameters `securityContext.runAsUser`, and `securityContext.fsGroup` to `root`.
Ingress configuration was also adapted to follow the Helm charts best practices.

Consequences:

- No "privileged" actions are allowed anymore.
- Backwards compatibility is not guaranteed when persistence is enabled.

To upgrade to `5.0.0`, install a new Jenkins chart, and migrate your Jenkins data ensuring the `jenkins` user has the appropriate permissions.

### To 4.0.0

Helm performs a lookup for the object based on its group (apps), version (v1), and kind (Deployment). Also known as its GroupVersionKind, or GVK. Changing the GVK is considered a compatibility breaker from Kubernetes' point of view, so you cannot "upgrade" those objects to the new GVK in-place. Earlier versions of Helm 3 did not perform the lookup correctly which has since been fixed to match the spec.

In 4dfac075aacf74405e31ae5b27df4369e84eb0b0 the `apiVersion` of the deployment resources was updated to `apps/v1` in tune with the api's deprecated, resulting in compatibility breakage.

This major version signifies this change.

### To 1.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 1.0.0. The following example assumes that the release name is jenkins:

```console
kubectl patch deployment jenkins --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
```

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
