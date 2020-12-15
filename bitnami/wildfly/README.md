# WildFly

[Wildfly](http://wildfly.org/) formerly known as JBoss AS, or simply JBoss, is an application server authored by JBoss, now developed by Red Hat. WildFly is written in Java, and implements the Java Platform, Enterprise Edition (Java EE) specification.

## TL;DR

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/wildfly
```

## Introduction

This chart bootstraps a [WildFly](https://github.com/bitnami/bitnami-docker-wildfly) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This Helm chart has been tested on top of [Bitnami Kubernetes Production Runtime](https://kubeprod.io/) (BKPR). Deploy BKPR to get automated TLS certificates, logging and monitoring for your applications.

## Prerequisites

- Kubernetes 1.12+
- Helm 3.0-beta3+
- PV provisioner support in the underlying infrastructure
- ReadWriteMany volumes for deployment scaling

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/wildfly
```

These commands deploy WildFly on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

The following tables lists the configurable parameters of the WildFly chart and their default values.

| Parameter                            | Description                                                                                                                                               | Default                                                 |
|--------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------|
| `global.imageRegistry`               | Global Docker image registry                                                                                                                              | `nil`                                                   |
| `global.imagePullSecrets`            | Global Docker registry secret names as an array                                                                                                           | `[]` (does not add image pull secrets to deployed pods) |
| `global.storageClass`                | Global storage class for dynamic provisioning                                                                                                             | `nil`                                                   |
| `image.registry`                     | WildFly image registry                                                                                                                                    | `docker.io`                                             |
| `image.repository`                   | WildFly Image name                                                                                                                                        | `bitnami/wildfly`                                       |
| `image.tag`                          | WildFly Image tag                                                                                                                                         | `{TAG_NAME}`                                            |
| `image.pullPolicy`                   | WildFly image pull policy                                                                                                                                 | `IfNotPresent`                                          |
| `image.pullSecrets`                  | Specify docker-registry secret names as an array                                                                                                          | `[]` (does not add image pull secrets to deployed pods) |
| `volumePermissions.enabled`          | Enable init container that changes volume permissions in the data directory (for cases where the default k8s `runAsUser` and `fsUser` values do not work) | `false`                                                 |
| `volumePermissions.image.registry`   | Init container volume-permissions image registry                                                                                                          | `docker.io`                                             |
| `volumePermissions.image.repository` | Init container volume-permissions image name                                                                                                              | `bitnami/minideb`                                       |
| `volumePermissions.image.tag`        | Init container volume-permissions image tag                                                                                                               | `buster`                                                |
| `volumePermissions.image.pullPolicy` | Init container volume-permissions image pull policy                                                                                                       | `Always`                                                |
| `volumePermissions.resources`        | Init container resource requests/limit                                                                                                                    | `{}`                                                    |
| `nameOverride`                       | String to partially override wildfly.fullname template with a string (will prepend the release name)                                                      | `nil`                                                   |
| `fullnameOverride`                   | String to fully override wildfly.fullname template with a string                                                                                          | `nil`                                                   |
| `updateStrategy`                     | Set to Recreate if you use persistent volume that cannot be mounted by more than one pods                                                                 | `RollingUpdate`                                         |
| `wildflyUsername`                    | WildFly admin user                                                                                                                                        | `user`                                                  |
| `wildflyPassword`                    | WildFly admin password                                                                                                                                    | _random 10 character alphanumeric string_               |
| `podAnnotations`                     | Pod annotations                                                                                                                                           | `{}`                                                    |
| `affinity`                           | Map of node/pod affinities                                                                                                                                | `{}` (The value is evaluated as a template)             |
| `nodeSelector`                       | Node labels for pod assignment                                                                                                                            | `{}` (The value is evaluated as a template)             |
| `tolerations`                        | Tolerations for pod assignment                                                                                                                            | `[]` (The value is evaluated as a template)             |
| `securityContext.enabled`            | Enable security context                                                                                                                                   | `true`                                                  |
| `securityContext.fsGroup`            | Group ID for the container                                                                                                                                | `1001`                                                  |
| `securityContext.runAsUser`          | User ID for the container                                                                                                                                 | `1001`                                                  |
| `resources`                          | CPU/Memory resource requests/limits                                                                                                                       | `{"requests": {"Memory": "512Mi", CPU: "300m"}}`        |
| `persistence.enabled`                | Enable persistence using PVC                                                                                                                              | `true`                                                  |
| `persistence.storageClass`           | PVC Storage Class for WildFly volume                                                                                                                      | `nil` (uses alpha storage class annotation)             |
| `persistence.accessMode`             | PVC Access Mode for WildFly volume                                                                                                                        | `ReadWriteOnce`                                         |
| `persistence.size`                   | PVC Storage Request for WildFly volume                                                                                                                    | `8Gi`                                                   |
| `service.type`                       | Kubernetes Service type                                                                                                                                   | `LoadBalancer`                                          |
| `service.port`                       | Service HTTP port                                                                                                                                         | `80`                                                    |
| `service.mgmtPort`                   | Service Management port                                                                                                                                   | `9990`                                                  |
| `service.nodePorts.http`             | Kubernetes http node port                                                                                                                                 | `""`                                                    |
| `service.nodePorts.mgmt`             | Kubernetes management node port                                                                                                                           | `""`                                                    |
| `service.externalTrafficPolicy`      | Enable client source IP preservation                                                                                                                      | `Cluster`                                               |
| `service.loadBalancerIP`             | LoadBalancer service IP address                                                                                                                           | `""`                                                    |
| `service.annotations`                | Service annotations                                                                                                                                       | `{}`                                                    |
| `extraVolumes`                       | Extra Volumes                                                                                                                                             | `[]`                                                    |
| `extraVolumeMounts`                  | Extra Volume Mounts (normally used with extraVolumes)                                                                                                     | `[]`                                                    |
| `extraEnvVars`                       | Extra Environment Variables                                                                                                                               | `nil`                                                   |
| `extraEnvVarsCM`                     | Extra Environment Variables ConfigMap                                                                                                                     | `nil`                                                   |
| `extraEnvVarsSecret`                 | Extra Environment Variables Secret                                                                                                                        | `nil`                                                   |
| `sidecars`                           | Sidecar images to add to the pod. Evaluated as a template.                                                                                                | `[]`                                                    |
| `livenessProbe`                      | The Kubernetes livenssProbe. Evaluated as a template.                                                                                                     | `{"httpGet": {"path": "/", "port": "http"}, "initialDelaySeconds": 120, "timeoutSeconds": 5, "failureThreshold": 6}` |        
| `readinessProbe`                     | The Kubernetes readinessProbe. Evaluated as a template.                                                                                                   | `{"httpGet": {"path": "/", "port": "http"}, "initialDelaySeconds": 30, "timeoutSeconds": 3, "periodSeconds": 5}`     |

The above parameters map to the env variables defined in [bitnami/wildfly](http://github.com/bitnami/bitnami-docker-wildfly). For more information please refer to the [bitnami/wildfly](http://github.com/bitnami/bitnami-docker-wildfly) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install my-release \
  --set wildflyUser=manager,wildflyPassword=password \
    bitnami/wildfly
```

The above command sets the WildFly management username and password to `manager` and `password` respectively.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
$ helm install my-release -f values.yaml bitnami/wildfly
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Sidecars
If you have a need for additional containers to run within the same pod as  Wildfly (e.g. an additional metrics or logging exporter), you can do so via the sidecars config parameter. Simply define your container according to the Kubernetes container spec.

```
sidecars:
  - name: your-image-name
    image: your-image
    imagePullPolicy: Always
    ports:
      - name: portname
      containerPort: 1234
```

## Persistence

The [Bitnami WildFly](https://github.com/bitnami/bitnami-docker-wildfly) image stores the WildFly data and configurations at the `/bitnami/wildfly` path of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Parameters](#parameters) section to configure the PVC or to disable persistence.

### Adjust permissions of persistent volume mountpoint

As the image run as non-root by default, it is necessary to adjust the ownership of the persistent volume so that the container can write data into it.

By default, the chart is configured to use Kubernetes Security Context to automatically change the ownership of the volume. However, this feature does not work in all Kubernetes distributions.
As an alternative, this chart supports using an initContainer to change the ownership of the volume before mounting it in the final destination.

You can enable this initContainer by setting `volumePermissions.enabled` to `true`.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami’s Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 6.0.0

[On November 13, 2020, Helm v2 support was formally finished](https://github.com/helm/charts#status-of-the-project), this major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

**What changes were introduced in this major version?**

- Previous versions of this Helm Chart use `apiVersion: v1` (installable by both Helm 2 and 3), this Helm Chart was updated to `apiVersion: v2` (installable by Helm 3 only). [Here](https://helm.sh/docs/topics/charts/#the-apiversion-field) you can find more information about the `apiVersion` field.
- The different fields present in the *Chart.yaml* file has been ordered alphabetically in a homogeneous way for all the Bitnami Helm Charts

**Considerations when upgrading to this version**

- If you want to upgrade to this version from a previous one installed with Helm v3, you shouldn't face any issues
- If you want to upgrade to this version using Helm v2, this scenario is not supported as this version doesn't support Helm v2 anymore
- If you installed the previous version with Helm v2 and wants to upgrade to this version with Helm v3, please refer to the [official Helm documentation](https://helm.sh/docs/topics/v2_v3_migration/#migration-use-cases) about migrating from Helm v2 to v3

**Useful links**

- https://docs.bitnami.com/tutorials/resolve-helm2-helm3-post-migration-issues/
- https://helm.sh/docs/topics/v2_v3_migration/
- https://helm.sh/blog/migrate-from-helm-v2-to-helm-v3/

### To 2.1.0

WildFly container was moved to a non-root approach. There shouldn't be any issue when upgrading since the corresponding `securityContext` is enabled by default. Both the container image and the chart can be upgraded by running the command below:

```
$ helm upgrade my-release bitnami/wildfly
```

If you use a previous container image (previous to **14.0.1-r75**) disable the `securityContext` by running the command below:

```
$ helm upgrade my-release bitnami/wildfly --set securityContext.enabled=fase,image.tag=XXX
```

### To 1.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 1.0.0. The following example assumes that the release name is wildfly:

```console
$ kubectl patch deployment wildfly --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
```
