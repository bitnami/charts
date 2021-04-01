# Parse

[Parse](https://parse.com/) is an open source version of the Parse backend that can be deployed to any infrastructure that can run Node.js.

## TL;DR

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/parse
```

## Introduction

This chart bootstraps a [Parse](https://github.com/bitnami/bitnami-docker-parse) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This chart has been tested to work with NGINX Ingress, cert-manager, fluentd and Prometheus on top of the [BKPR](https://kubeprod.io/).

## Prerequisites

- Kubernetes 1.12+
- Helm 3.1.0
- PV provisioner support in the underlying infrastructure
- ReadWriteMany volumes for deployment scaling

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install my-release bitnami/parse
```

The command deploys Parse on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

The following table lists the configurable parameters of the Parse chart and their default values.

### Global Parameters

| Parameter                 | Description                                     | Default                                                 |
|---------------------------|-------------------------------------------------|---------------------------------------------------------|
| `global.imageRegistry`    | Global Docker image registry                    | `nil`                                                   |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]` (does not add image pull secrets to deployed pods) |
| `global.storageClass`     | Global storage class for dynamic provisioning   | `nil`                                                   |

### Common Parameters

| Parameter           | Description                                                                                               | Default                        |
|---------------------|-----------------------------------------------------------------------------------------------------------|--------------------------------|
| `nameOverride`      | String to partially override common.names.fullname template with a string (will prepend the release name) | `nil`                          |
| `fullnameOverride`  | String to fully override common.names.fullname template with a string                                     | `nil`                          |
| `commonLabels`      | Labels to add to all deployed objects                                                                     | `{}`                           |
| `commonAnnotations` | Annotations to add to all deployed objects                                                                | `{}`                           |
| `extraDeploy`       | Array of extra objects to deploy with the release                                                         | `[]` (evaluated as a template) |

### Parse server parameters

| Parameter                           | Description                                                                                                              | Default                                                 |
|-------------------------------------|--------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------|
| `server.image.registry`             | Parse image registry                                                                                                     | `docker.io`                                             |
| `server.image.repository`           | Parse image name                                                                                                         | `bitnami/parse`                                         |
| `server.image.tag`                  | Parse image tag                                                                                                          | `{TAG_NAME}`                                            |
| `server.image.pullPolicy`           | Image pull policy                                                                                                        | `IfNotPresent`                                          |
| `server.image.pullSecrets`          | Specify docker-registry secret names as an array                                                                         | `[]` (does not add image pull secrets to deployed pods) |
| `server.securityContext.enabled`    | Enable security context for Parse Server                                                                                 | `true`                                                  |
| `server.securityContext.fsGroup`    | Group ID for Parse Server container                                                                                      | `1001`                                                  |
| `server.securityContext.runAsUser`  | User ID for Parse Server container                                                                                       | `1001`                                                  |
| `server.host`                       | Hostname to use to access Parse server (when `ingress.enabled=true` is set to `ingress.server.hosts[0].name` by default) | `nil`                                                   |
| `server.port`                       | Parse server port                                                                                                        | `1337`                                                  |
| `server.hostAliases`                | Add deployment host aliases                                                                                              | `[]`                                                    |
| `server.mountPath`                  | Parse server API mount path                                                                                              | `/parse`                                                |
| `server.appId`                      | Parse server App Id                                                                                                      | `myappID`                                               |
| `server.masterKey`                  | Parse server Master Key                                                                                                  | `random 10 character alphanumeric string`               |
| `server.enableCloudCode`            | Enable Parse Cloud Clode                                                                                                 | `false`                                                 |
| `server.cloudCodeScripts`           | Dictionary of Cloud Code scripts                                                                                         | `nil`                                                   |
| `server.existingCloudCodeScriptsCM` | ConfigMap with Cloud Code scripts (Note: Overrides `cloudCodeScripts`).                                                  | `nil`                                                   |
| `server.resources`                  | The [resources] to allocate for container                                                                                | `{}`                                                    |
| `server.livenessProbe`              | Liveness probe configuration for Server                                                                                  | `Check values.yaml file`                                |
| `server.readinessProbe`             | Readiness probe configuration for Server                                                                                 | `Check values.yaml file`                                |
| `server.podAffinityPreset`          | Parse server pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                         | `""`                                                    |
| `server.podAntiAffinityPreset`      | Parse server pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                    | `soft`                                                  |
| `server.nodeAffinityPreset.type`    | Parse server node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                   | `""`                                                    |
| `server.nodeAffinityPreset.key`     | Parse server node label key to match Ignored if `affinity` is set.                                                       | `""`                                                    |
| `server.nodeAffinityPreset.values`  | Parse server node label values to match. Ignored if `affinity` is set.                                                   | `[]`                                                    |
| `server.affinity`                   | Parse server affinity for pod assignment                                                                                 | `{}` (evaluated as a template)                          |
| `server.nodeSelector`               | Parse server node labels for pod assignment                                                                              | `{}` (evaluated as a template)                          |
| `server.tolerations`                | Parse server tolerations for pod assignment                                                                              | `[]` (evaluated as a template)                          |
| `server.extraEnvVars`               | Array containing extra env vars (evaluated as a template)                                                                | `nil`                                                   |
| `server.extraEnvVarsCM`             | ConfigMap containing extra env vars (evaluated as a template)                                                            | `nil`                                                   |
| `server.extraEnvVarsSecret`         | Secret containing extra env vars  (evaluated as a template)                                                              | `nil`                                                   |

### Traffic Exposure Parameters

| Parameter                        | Description                            | Default                  |
|----------------------------------|----------------------------------------|--------------------------|
| `service.type`                   | Kubernetes Service type                | `LoadBalancer`           |
| `service.port`                   | Service HTTP port (Dashboard)          | `80`                     |
| `service.loadBalancerIP`         | `loadBalancerIP` for the Parse Service | `nil`                    |
| `service.externalTrafficPolicy`  | Enable client source IP preservation   | `Cluster`                |
| `service.nodePorts.http`         | Kubernetes http node port              | `""`                     |
| `ingress.enabled`                | Enable ingress controller resource     | `false`                  |
| `ingress.annotations`            | Ingress annotations                    | `[]`                     |
| `ingress.certManager`            | Add annotations for cert-manager       | `false`                  |
| `ingress.dashboard.hostname`     | Default host for the ingress resource  | `parse-dashboard.local`  |
| `ingress.dashboard.extraHosts`   | Extra hosts for the ingress resource   | `[]`                     |
| `ingress.dashboard.path`         | Default path for the ingress resource  | `/`                      |
| `ingress.dashboard.pathType`     | Ingress path type                      | `ImplementationSpecific` |
| `ingress.server.hostname`        | Default host for the ingress resource  | `parse-server.local`     |
| `ingress.server.path`            | Default path for the ingress resource  | `/`                      |
| `ingress.server.pathType`        | Ingress path type                      | `ImplementationSpecific` |
| `ingress.server.extraHosts`      | Extra hosts for the ingress resource   | `[]`                     |
| `ingress.secrets[0].name`        | TLS Secret Name                        | `nil`                    |
| `ingress.secrets[0].certificate` | TLS Secret Certificate                 | `nil`                    |
| `ingress.secrets[0].key`         | TLS Secret Key                         | `nil`                    |

### Persistence Parameters

| Parameter                  | Description                          | Default                                     |
|----------------------------|--------------------------------------|---------------------------------------------|
| `persistence.enabled`      | Enable Parse persistence using PVC   | `true`                                      |
| `persistence.storageClass` | PVC Storage Class for Parse volume   | `nil` (uses alpha storage class annotation) |
| `persistence.accessMode`   | PVC Access Mode for Parse volume     | `ReadWriteOnce`                             |
| `persistence.size`         | PVC Storage Request for Parse volume | `8Gi`                                       |

### Dashboard Parameters

| Parameter                             | Description                                                                                               | Default                                                 |
|---------------------------------------|-----------------------------------------------------------------------------------------------------------|---------------------------------------------------------|
| `dashboard.enabled`                   | Enable parse dashboard                                                                                    | `true`                                                  |
| `dashboard.image.registry`            | Dashboard image registry                                                                                  | `docker.io`                                             |
| `dashboard.image.repository`          | Dashboard image name                                                                                      | `bitnami/parse-dashboard`                               |
| `dashboard.image.tag`                 | Dashboard image tag                                                                                       | `{TAG_NAME}`                                            |
| `dashboard.image.pullPolicy`          | Image pull policy                                                                                         | `IfNotPresent`                                          |
| `dashboard.securityContext.enabled`   | Enable security context for Dashboard                                                                     | `true`                                                  |
| `dashboard.securityContext.fsGroup`   | Group ID for Dashboard container                                                                          | `1001`                                                  |
| `dashboard.securityContext.runAsUser` | User ID for Dashboard container                                                                           | `1001`                                                  |
| `dashboard.image.pullSecrets`         | Specify docker-registry secret names as an array                                                          | `[]` (does not add image pull secrets to deployed pods) |
| `dashboard.hostAliases`               | Add deployment host aliases                                                                               | `[]`                                                    |
| `dashboard.username`                  | Dashboard username                                                                                        | `user`                                                  |
| `dashboard.password`                  | Dashboard user password                                                                                   | `random 10 character alphanumeric string`               |
| `dashboard.appName`                   | Dashboard application name                                                                                | `MyDashboard`                                           |
| `dashboard.parseServerUrlProtocol`    | Protocol used by Parse Dashboard to form the URLs to Parse Server.                                        | `http`                                                  |
| `dashboard.resources`                 | The [resources] to allocate for container                                                                 | `{}`                                                    |
| `dashboard.livenessProbe`             | Liveness probe configuration for Dashboard                                                                | `Check values.yaml file`                                |
| `dashboard.readinessProbe`            | Readiness probe configuration for Dashboard                                                               | `Check values.yaml file`                                |
| `dashboard.podAffinityPreset`         | Parse dashboard pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`       | `""`                                                    |
| `dashboard.podAntiAffinityPreset`     | Parse dashboard pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`  | `soft`                                                  |
| `dashboard.nodeAffinityPreset.type`   | Parse dashboard node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard` | `""`                                                    |
| `dashboard.nodeAffinityPreset.key`    | Parse dashboard node label key to match Ignored if `affinity` is set.                                     | `""`                                                    |
| `dashboard.nodeAffinityPreset.values` | Parse dashboard node label values to match. Ignored if `affinity` is set.                                 | `[]`                                                    |
| `dashboard.affinity`                  | Parse dashboard affinity for pod assignment                                                               | `{}` (evaluated as a template)                          |
| `dashboard.nodeSelector`              | Parse dashboard node labels for pod assignment                                                            | `{}` (evaluated as a template)                          |
| `dashboard.tolerations`               | Parse dashboard tolerations for pod assignment                                                            | `[]` (evaluated as a template)                          |
| `dashboard.extraEnvVars`              | Array containing extra env vars (evaluated as a template)                                                 | `nil`                                                   |
| `dashboard.extraEnvVarsCM`            | ConfigMap containing extra env vars (evaluated as a template)                                             | `nil`                                                   |
| `dashboard.extraEnvVarsSecret`        | Secret containing extra env vars  (evaluated as a template)                                               | `nil`                                                   |

### Volume Permissions parameters

| Parameter                            | Description                                                                                                                                               | Default                 |
|--------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------|
| `volumePermissions.enabled`          | Enable init container that changes volume permissions in the data directory (for cases where the default k8s `runAsUser` and `fsUser` values do not work) | `false`                 |
| `volumePermissions.image.registry`   | Init container volume-permissions image registry                                                                                                          | `docker.io`             |
| `volumePermissions.image.repository` | Init container volume-permissions image name                                                                                                              | `bitnami/bitnami-shell` |
| `volumePermissions.image.tag`        | Init container volume-permissions image tag                                                                                                               | `"10"`                  |
| `volumePermissions.image.pullPolicy` | Init container volume-permissions image pull policy                                                                                                       | `Always`                |
| `volumePermissions.resources`        | Init container resource requests/limit                                                                                                                    | `nil`                   |

### MongoDB&reg; Parameters

| Parameter                          | Description                                 | Default                                     |
|------------------------------------|---------------------------------------------|---------------------------------------------|
| `mongodb.auth.enabled`             | Enable MongoDB&reg; password authentication | `true`                                      |
| `mongodb.auth.rootPassword`        | MongoDB&reg; admin password                 | `nil`                                       |
| `mongodb.persistence.enabled`      | Enable MongoDB&reg; persistence using PVC   | `true`                                      |
| `mongodb.persistence.storageClass` | PVC Storage Class for MongoDB&reg; volume   | `nil` (uses alpha storage class annotation) |
| `mongodb.persistence.accessMode`   | PVC Access Mode for MongoDB&reg; volume     | `ReadWriteOnce`                             |
| `mongodb.persistence.size`         | PVC Storage Request for MongoDB&reg; volume | `8Gi`                                       |

The above parameters map to the env variables defined in [bitnami/parse](http://github.com/bitnami/bitnami-docker-parse). For more information please refer to the [bitnami/parse](http://github.com/bitnami/bitnami-docker-parse) image documentation.

> **Note**:
>
> For the Parse application function correctly, you should specify the `parseHost` parameter to specify the FQDN (recommended) or the public IP address of the Parse service.
>
> Optionally, you can specify the `loadBalancerIP` parameter to assign a reserved IP address to the Parse service of the chart. However please note that this feature is only available on a few cloud providers (f.e. GKE).
>
> To reserve a public IP address on GKE:
>
> ```bash
> $ gcloud compute addresses create parse-public-ip
> ```
>
> The reserved IP address can be associated to the Parse service by specifying it as the value of the `loadBalancerIP` parameter while installing the chart.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install my-release \
  --set dashboard.username=admin,dashboard.password=password \
    bitnami/parse
```

The above command sets the Parse administrator account username and password to `admin` and `password` respectively.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install my-release -f values.yaml bitnami/parse
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Deploy your Cloud functions with Parse Cloud Code

The [Bitnami Parse](https://github.com/bitnami/bitnami-docker-parse) image allows you to deploy your Cloud functions with Parse Cloud Code (a feature which allows running a piece of code in your Parse Server instead of the user's mobile devices). In order to add your custom scripts, they must be located inside the chart folder `files/cloud` so they can be consumed as a ConfigMap.

Alternatively, you can specify custom scripts using the `cloudCodeScripts` parameter as dict.

In addition to these options, you can also set an external ConfigMap with all the Cloud Code scripts. This is done by setting the `existingCloudCodeScriptsCM` parameter. Note that this will override the two previous options.

## Persistence

The [Bitnami Parse](https://github.com/bitnami/bitnami-docker-parse) image stores the Parse data and configurations at the `/bitnami/parse` path of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Parameters](#parameters) section to configure the PVC or to disable persistence.

### Adjust permissions of persistent volume mountpoint

As the image run as non-root by default, it is necessary to adjust the ownership of the persistent volume so that the container can write data into it.

By default, the chart is configured to use Kubernetes Security Context to automatically change the ownership of the volume. However, this feature does not work in all Kubernetes distributions.
As an alternative, this chart supports using an initContainer to change the ownership of the volume before mounting it in the final destination.

You can enable this initContainer by setting `volumePermissions.enabled` to `true`.

### Adding extra environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `extraEnvVars` (available in the `server` and `dashboard` sections) property.

```yaml
extraEnvVars:
  - name: PARSE_SERVER_ALLOW_CLIENT_CLASS_CREATION
    value: true
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values.

### Deploying extra resources

There are cases where you may want to deploy extra objects, such as KongPlugins, KongConsumers, amongst others. For covering this case, the chart allows adding the full specification of other objects using the `extraDeploy` parameter. The following example would activate a plugin at deployment time.

```yaml
## Extra objects to deploy (value evaluated as a template)
##
extraDeploy: |-
  - apiVersion: rbac.authorization.k8s.io/v1
    kind: RoleBinding
    metadata:
      name: {{ include "common.names.fullname" . }}-privileged
      namespace: {{ .Release.Namespace }}
      labels: {{- include "common.labels.standard" . | nindent 6 }}
    roleRef:
      apiGroup: rbac.authorization.k8s.io
      kind: ClusterRole
      name: cluster-admin
    subjects:
      - kind: ServiceAccount
        name: default
        namespace: {{ .Release.Namespace }}
```

### Setting Pod's affinity

This chart allows you to set your custom affinity using the `XXX.affinity` paremeter(s). Find more infomation about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `XXX.podAffinityPreset`, `XXX.podAntiAffinityPreset`, or `XXX.nodeAffinityPreset` parameters.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami’s Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 14.0.0

This version standardizes the way of defining Ingress rules. When configuring a single hostname for the Ingress rule, set the `ingress.dashboard.hostname` and `ingress.server.hostname` values. When defining more than one, set the `ingress.dashboard.extraHosts` and `ingress.server.extraHosts` arrays. Apart from this case, no issues are expected to appear when upgrading.

### To 13.0.0

[On November 13, 2020, Helm v2 support was formally finished](https://github.com/helm/charts#status-of-the-project), this major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

**What changes were introduced in this major version?**

- Previous versions of this Helm Chart use `apiVersion: v1` (installable by both Helm 2 and 3), this Helm Chart was updated to `apiVersion: v2` (installable by Helm 3 only). [Here](https://helm.sh/docs/topics/charts/#the-apiversion-field) you can find more information about the `apiVersion` field.
- Move dependency information from the *requirements.yaml* to the *Chart.yaml*
- After running `helm dependency update`, a *Chart.lock* file is generated containing the same structure used in the previous *requirements.lock*
- The different fields present in the *Chart.yaml* file has been ordered alphabetically in a homogeneous way for all the Bitnami Helm Charts

**Considerations when upgrading to this version**

- If you want to upgrade to this version from a previous one installed with Helm v3, you shouldn't face any issues
- If you want to upgrade to this version using Helm v2, this scenario is not supported as this version doesn't support Helm v2 anymore
- If you installed the previous version with Helm v2 and wants to upgrade to this version with Helm v3, please refer to the [official Helm documentation](https://helm.sh/docs/topics/v2_v3_migration/#migration-use-cases) about migrating from Helm v2 to v3

**Useful links**

- https://docs.bitnami.com/tutorials/resolve-helm2-helm3-post-migration-issues/
- https://helm.sh/docs/topics/v2_v3_migration/
- https://helm.sh/blog/migrate-from-helm-v2-to-helm-v3/

### To 12.0.0

MongoDB&reg; subchart container images were updated to 4.4.x and it can affect compatibility with older versions of MongoDB&reg;.

- https://github.com/bitnami/charts/tree/master/bitnami/mongodb#to-900

### To 11.0.0

Backwards compatibility is not guaranteed since breaking changes were included in MongoDB&reg; subchart. More information in the link below:

- https://github.com/bitnami/charts/tree/master/bitnami/mongodb#to-800

### To 10.0.0

Backwards compatibility is not guaranteed. The following notables changes were included:

- **parse-dashboard** is bumped to the branch 2 (major version)
- Labels are adapted to follow the Helm charts best practices.

### To 5.1.0

Parse & Parse Dashboard containers were moved to a non-root approach. There shouldn't be any issue when upgrading since the corresponding `securityContext` is enabled by default. Both container images and chart can be upgraded by running the command below:

```
$ helm upgrade my-release bitnami/parse
```

If you use a previous container image (previous to **3.1.2-r14** for Parse or **1.2.0-r69** for Parse Dashboard), disable the `securityContext` by running the command below:

```
$ helm upgrade my-release bitnami/parse --set server.securityContext.enabled=false,dashboard.securityContext.enabled=false,server.image.tag=XXX,dashboard.image.tag=YYY
```

### To 3.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 3.0.0. The following example assumes that the release name is parse:

```console
$ kubectl patch deployment parse-parse-dashboard --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
$ kubectl patch deployment parse-parse-server --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
$ kubectl patch deployment parse-mongodb --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
```
