# Jenkins

[Jenkins](https://jenkins.io) is widely recognized as the most feature-rich CI available with easy configuration, continuous delivery and continuous integration support, easily test, build and stage your app, and more. It supports multiple SCM tools including CVS, Subversion and Git. It can execute Apache Ant and Apache Maven-based projects as well as arbitrary scripts.

## TL;DR

```console
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install my-release bitnami/jenkins
```

## Introduction

This chart bootstraps a [Jenkins](https://github.com/bitnami/bitnami-docker-jenkins) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This Helm chart has been tested on top of [Bitnami Kubernetes Production Runtime](https://kubeprod.io/) (BKPR). Deploy BKPR to get automated TLS certificates, logging and monitoring for your applications.

## Prerequisites

- Kubernetes 1.12+
- Helm 3.1.0
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

The following tables lists the configurable parameters of the Jenkins chart and their default values per section/component:

### Global parameters

| Parameter                 | Description                                     | Default                                                 |
|---------------------------|-------------------------------------------------|---------------------------------------------------------|
| `global.imageRegistry`    | Global Docker image registry                    | `nil`                                                   |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]` (does not add image pull secrets to deployed pods) |
| `global.storageClass`     | Global storage class for dynamic provisioning   | `nil`                                                   |

### Common parameters

| Parameter           | Description                                                                                               | Default                        |
|---------------------|-----------------------------------------------------------------------------------------------------------|--------------------------------|
| `nameOverride`      | String to partially override common.names.fullname template with a string (will prepend the release name) | `nil`                          |
| `fullnameOverride`  | String to fully override common.names.fullname template with a string                                     | `nil`                          |
| `clusterDomain`     | Default Kubernetes cluster domain                                                                         | `cluster.local`                |
| `commonLabels`      | Labels to add to all deployed objects                                                                     | `{}`                           |
| `commonAnnotations` | Annotations to add to all deployed objects                                                                | `{}`                           |
| `extraDeploy`       | Array of extra objects to deploy with the release                                                         | `[]` (evaluated as a template) |
| `kubeVersion`       | Force target Kubernetes version (using Helm capabilities if not set)                                      | `nil`                          |

### Jenkins parameters

| Parameter               | Description                                                          | Default                                                 |
|-------------------------|----------------------------------------------------------------------|---------------------------------------------------------|
| `image.registry`        | Jenkins image registry                                               | `docker.io`                                             |
| `image.repository`      | Jenkins Image name                                                   | `bitnami/jenkins`                                       |
| `image.tag`             | Jenkins Image tag                                                    | `{TAG_NAME}`                                            |
| `image.pullPolicy`      | Jenkins image pull policy                                            | `IfNotPresent`                                          |
| `image.pullSecrets`     | Specify docker-registry secret names as an array                     | `[]` (does not add image pull secrets to deployed pods) |
| `jenkinsUser`           | User of the application                                              | `user`                                                  |
| `jenkinsPassword`       | Application password                                                 | _random 10 character alphanumeric string_               |
| `jenkinsHome`           | Jenkins home directory                                               | `/opt/bitnami/jenkins/jenkins_home`                     |
| `disableInitialization` | Allows to disable the initial Bitnami configuration for Jenkins      | `no`                                                    |
| `javaOpts`              | Customize JVM parameters                                             | `nil`                                                   |
| `command`               | Override default container command (useful when using custom images) | `nil`                                                   |
| `args`                  | Override default container args (useful when using custom images)    | `nil`                                                   |
| `extraEnvVars`          | Extra environment variables to be set on Jenkins container           | `{}`                                                    |
| `extraEnvVarsCM`        | Name of existing ConfigMap containing extra env vars                 | `nil`                                                   |
| `extraEnvVarsSecret`    | Name of existing Secret containing extra env vars                    | `nil`                                                   |

### Jenkins deployment parameters

| Parameter                   | Description                                                                               | Default                                     |
|-----------------------------|-------------------------------------------------------------------------------------------|---------------------------------------------|
| `podSecurityContext`        | Jenkins pods' Security Context                                                            | Check `values.yaml` file                    |
| `containerSecurityContext`  | Jenkins containers' Security Context                                                      | Check `values.yaml` file                    |
| `hostAliases`               | Add deployment host aliases                                                               | `[]`                                        |
| `resources.limits`          | The resources limits for the Jenkins container                                            | `{}`                                        |
| `resources.requests`        | The requested resources for the Jenkins container                                         | `{ cpu: "300m", memory: "512Mi" }`          |
| `livenessProbe`             | Liveness probe configuration for Jenkins                                                  | Check `values.yaml` file                    |
| `readinessProbe`            | Readiness probe configuration for Jenkins                                                 | Check `values.yaml` file                    |
| `customLivenessProbe`       | Override default liveness probe                                                           | `nil`                                       |
| `customReadinessProbe`      | Override default readiness probe                                                          | `nil`                                       |
| `updateStrategy`            | Strategy to use to update Pods                                                            | Check `values.yaml` file                    |
| `podAffinityPreset`         | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`       | `""`                                        |
| `podAntiAffinityPreset`     | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`  | `soft`                                      |
| `nodeAffinityPreset.type`   | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard` | `""`                                        |
| `nodeAffinityPreset.key`    | Node label key to match. Ignored if `affinity` is set.                                    | `""`                                        |
| `nodeAffinityPreset.values` | Node label values to match. Ignored if `affinity` is set.                                 | `[]`                                        |
| `affinity`                  | Affinity for pod assignment                                                               | `{}` (evaluated as a template)              |
| `nodeSelector`              | Node labels for pod assignment                                                            | `{}` (evaluated as a template)              |
| `tolerations`               | Tolerations for pod assignment                                                            | `[]` (evaluated as a template)              |
| `podLabels`                 | Extra labels for Jenkins pods                                                             | `{}` (evaluated as a template)              |
| `podAnnotations`            | Annotations for Jenkins pods                                                              | `{}` (evaluated as a template)              |
| `extraVolumeMounts`         | Optionally specify extra list of additional volumeMounts for Jenkins container(s)         | `[]`                                        |
| `extraVolumes`              | Optionally specify extra list of additional volumes for Jenkins pods                      | `[]`                                        |
| `initContainers`            | Add additional init containers to the Jenkins pods                                        | `{}` (evaluated as a template)              |
| `sidecars`                  | Add additional sidecar containers to the Jenkins pods                                     | `{}` (evaluated as a template)              |
| `persistence.enabled`       | Enable persistence using PVC                                                              | `true`                                      |
| `persistence.storageClass`  | PVC Storage Class for Jenkins volume                                                      | `nil` (uses alpha storage class annotation) |
| `persistence.accessMode`    | PVC Access Mode for Jenkins volume                                                        | `ReadWriteOnce`                             |
| `persistence.size`          | PVC Storage Request for Jenkins volume                                                    | `8Gi`                                       |
| `persistence.annotations`   | Persistence annotations                                                                   | `{}`                                        |

### Exposure parameters

| Parameter                        | Description                                                   | Default                        |
|----------------------------------|---------------------------------------------------------------|--------------------------------|
| `service.type`                   | Kubernetes Service type                                       | `LoadBalancer`                 |
| `service.port`                   | Service HTTP port                                             | `80`                           |
| `service.httpsPort`              | Service HTTPS port                                            | `443`                          |
| `service.nodePorts.http`         | Kubernetes http node port                                     | `""`                           |
| `service.nodePorts.https`        | Kubernetes https node port                                    | `""`                           |
| `service.externalTrafficPolicy`  | Enable client source IP preservation                          | `Cluster`                      |
| `service.loadBalancerIP`         | LoadBalancer service IP address                               | `""`                           |
| `service.annotations`            | Service annotations                                           | `{}`                           |
| `ingress.enabled`                | Enable ingress controller resource                            | `false`                        |
| `ingress.certManager`            | Add annotations for cert-manager                              | `false`                        |
| `ingress.hostname`               | Default host for the ingress resource                         | `jenkins.local`                |
| `ingress.path`                   | Default path for the ingress resource                         | `/`                            |
| `ingress.apiVersion`             | Force Ingress API version (automatically detected if not set) | ``                             |
| `ingress.pathType`               | Ingress path type                                             | `ImplementationSpecific`       |
| `ingress.tls`                    | Create TLS Secret                                             | `false`                        |
| `ingress.annotations`            | Ingress annotations                                           | `[]` (evaluated as a template) |
| `ingress.extraHosts[0].name`     | Additional hostnames to be covered                            | `nil`                          |
| `ingress.extraHosts[0].path`     | Additional hostnames to be covered                            | `nil`                          |
| `ingress.extraPaths`             | Additional arbitrary path/backend objects                     | `nil`                          |
| `ingress.extraTls[0].hosts[0]`   | TLS configuration for additional hostnames to be covered      | `nil`                          |
| `ingress.extraTls[0].secretName` | TLS configuration for additional hostnames to be covered      | `nil`                          |
| `ingress.secrets[0].name`        | TLS Secret Name                                               | `nil`                          |
| `ingress.secrets[0].certificate` | TLS Secret Certificate                                        | `nil`                          |
| `ingress.secrets[0].key`         | TLS Secret Key                                                | `nil`                          |

### Volume Permissions parameters

| Parameter                              | Description                                                                                                          | Default                                                 |
|----------------------------------------|----------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------|
| `volumePermissions.enabled`            | Enable init container that changes the owner and group of the persistent volume(s) mountpoint to `runAsUser:fsGroup` | `false`                                                 |
| `volumePermissions.image.registry`     | Init container volume-permissions image registry                                                                     | `docker.io`                                             |
| `volumePermissions.image.repository`   | Init container volume-permissions image name                                                                         | `bitnami/bitnami-shell`                                 |
| `volumePermissions.image.tag`          | Init container volume-permissions image tag                                                                          | `"10"`                                                  |
| `volumePermissions.image.pullPolicy`   | Init container volume-permissions image pull policy                                                                  | `Always`                                                |
| `volumePermissions.image.pullSecrets`  | Specify docker-registry secret names as an array                                                                     | `[]` (does not add image pull secrets to deployed pods) |
| `volumePermissions.resources.limits`   | Init container volume-permissions resource  limits                                                                   | `{}`                                                    |
| `volumePermissions.resources.requests` | Init container volume-permissions resource  requests                                                                 | `{}`                                                    |

### Metrics parameters

| Parameter                              | Description                                                                                            | Default                                                      |
|----------------------------------------|--------------------------------------------------------------------------------------------------------|--------------------------------------------------------------|
| `metrics.enabled`                      | Start a side-car Jenkins Prometheus exporter                                                           | `false`                                                      |
| `metrics.image.registry`               | Jenkins Prometheus exporter image registry                                                             | `docker.io`                                                  |
| `metrics.image.repository`             | Jenkins Prometheus exporter image name                                                                 | `bitnami/jenkins-exporter`                                   |
| `metrics.image.tag`                    | Jenkins Prometheus exporter image tag                                                                  | `{TAG_NAME}`                                                 |
| `metrics.image.pullPolicy`             | Image pull policy                                                                                      | `IfNotPresent`                                               |
| `metrics.image.pullSecrets`            | Specify docker-registry secret names as an array                                                       | `[]` (does not add image pull secrets to deployed pods)      |
| `metrics.podAnnotations`               | Additional annotations for Metrics exporter pod                                                        | `{}`                                                         |
| `metrics.resources.limits`             | Jenkins Prometheus exporter resource limits                                                            | `{}`                                                         |
| `metrics.resources.requests`           | Jenkins Prometheus exporter resource requests                                                          | `{}`                                                         |
| `metrics.service.type`                 | Kubernetes service type (`ClusterIP`, `NodePort` or `LoadBalancer`)                                    | `ClusterIP`                                                  |
| `metrics.service.port`                 | Jenkins Prometheus exporter service port                                                               | `9122`                                                       |
| `metrics.service.nodePort`             | Kubernetes node port                                                                                   | `""`                                                         |
| `metrics.service.annotations`          | Annotations for Jenkins Prometheus exporter service                                                    | `{prometheus.io/scrape: "true", prometheus.io/port: "9118"}` |
| `metrics.service.loadBalancerIP`       | loadBalancerIP if service type is `LoadBalancer`                                                       | `nil`                                                        |
| `metrics.serviceMonitor.enabled`       | if `true`, creates a Prometheus Operator ServiceMonitor (also requires `metrics.enabled` to be `true`) | `false`                                                      |
| `metrics.serviceMonitor.namespace`     | Namespace in which Prometheus is running                                                               | `nil`                                                        |
| `metrics.serviceMonitor.interval`      | Interval at which metrics should be scraped.                                                           | `nil` (Prometheus Operator default value)                    |
| `metrics.serviceMonitor.scrapeTimeout` | Timeout after which the scrape is ended                                                                | `nil` (Prometheus Operator default value)                    |
| `metrics.serviceMonitor.selector`      | Prometheus instance selector labels                                                                    | `{}`                                                         |

The above parameters map to the env variables defined in [bitnami/jenkins](http://github.com/bitnami/bitnami-docker-jenkins). For more information please refer to the [bitnami/jenkins](http://github.com/bitnami/bitnami-docker-jenkins) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install my-release \
  --set jenkinsUser=admin,jenkinsPassword=password \
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

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Ingress

This chart provides support for ingress resources. If you have an ingress controller installed on your cluster, such as [nginx-ingress-controller](https://github.com/bitnami/charts/tree/master/bitnami/nginx-ingress-controller) or [contour](https://github.com/bitnami/charts/tree/master/bitnami/contour) you can utilize the ingress controller to serve your application.

To enable ingress integration, please set `ingress.enabled` to `true`.

#### Hosts

Most likely you will only want to have one hostname that maps to this Jenkins installation. If that's your case, the property `ingress.hostname` will set it. However, it is possible to have more than one host. To facilitate this, the `ingress.extraHosts` object can be specified as an array. You can also use `ingress.extraTLS` to add the TLS configuration for extra hosts.

For each host indicated at `ingress.extraHosts`, please indicate a `name`, `path`, and any `annotations` that you may want the ingress controller to know about.

For annotations, please see [this document](https://github.com/kubernetes/ingress-nginx/blob/master/docs/user-guide/nginx-configuration/annotations.md). Not all annotations are supported by all ingress controllers, but this document does a good job of indicating which annotation is supported by many popular ingress controllers.

### TLS Secrets

This chart will facilitate the creation of TLS secrets for use with the ingress controller, however, this is not required. There are three common use cases:

- Helm generates/manages certificate secrets.
- User generates/manages certificates separately.
- An additional tool (like [cert-manager](https://github.com/jetstack/cert-manager/)) manages the secrets for the application.

In the first two cases, it's needed a certificate and a key. We would expect them to look like this:

- certificate files should look like (and there can be more than one certificate if there is a certificate chain)

    ```console
    -----BEGIN CERTIFICATE-----
    MIID6TCCAtGgAwIBAgIJAIaCwivkeB5EMA0GCSqGSIb3DQEBCwUAMFYxCzAJBgNV
    ...
    jScrvkiBO65F46KioCL9h5tDvomdU1aqpI/CBzhvZn1c0ZTf87tGQR8NK7v7
    -----END CERTIFICATE-----
    ```

- keys should look like:

    ```console
    -----BEGIN RSA PRIVATE KEY-----
    MIIEogIBAAKCAQEAvLYcyu8f3skuRyUgeeNpeDvYBCDcgq+LsWap6zbX5f8oLqp4
    ...
    wrj2wDbCDCFmfqnSJ+dKI3vFLlEz44sAV8jX/kd4Y6ZTQhlLbYc=
    -----END RSA PRIVATE KEY-----
    ```

If you are going to use Helm to manage the certificates, please copy these values into the `certificate` and `key` values for a given `ingress.secrets` entry.

If you are going to manage TLS secrets outside of Helm, please know that you can create a TLS secret (named `jenkins.local-tls` for example).

### Adding extra environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `extraEnvVars` property.

```yaml
extraEnvVars:
  - name: LOG_LEVEL
    value: DEBUG
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values.

### Sidecars and Init Containers

If you have a need for additional containers to run within the same pod as the Jenkins app (e.g. an additional metrics or logging exporter), you can do so via the `sidecars` config parameter. Simply define your container according to the Kubernetes container spec.

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
        containerPort: 1234
```

### Deploying extra resources

There are cases where you may want to deploy extra objects, such a ConfigMap containing your app's configuration or some extra deployment with a micro service used by your app. For covering this case, the chart allows adding the full specification of other objects using the `extraDeploy` parameter.

### Setting Pod's affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

## Persistence

The [Bitnami Jenkins](https://github.com/bitnami/bitnami-docker-jenkins) image stores the Jenkins data and configurations at the `/bitnami/jenkins` path of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Parameters](#parameters) section to configure the PVC or to disable persistence.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami’s Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 7.0.0

Chart labels were adapted to follow the [Helm charts standard labels](https://helm.sh/docs/chart_best_practices/labels/#standard-labels).

Consequences:

- Backwards compatibility is not guaranteed. However, you can easily workaround this issue by removing Jenkins deployment before upgrading (the following example assumes that the release name is `jenkins`):

```console
$ export JENKINS_PASSWORD=$(kubectl get secret --namespace default jenkins -o jsonpath="{.data.jenkins-password}" | base64 --decode)
$ kubectl delete deployments.apps jenkins
$ helm upgrade jenkins bitnami/jenkins --set jenkinsPassword=$JENKINS_PASSWORD
```

### To 6.1.0

This version also introduces `bitnami/common`, a [library chart](https://helm.sh/docs/topics/library_charts/#helm) as a dependency. More documentation about this new utility could be found [here](https://github.com/bitnami/charts/tree/master/bitnami/common#bitnami-common-library-chart). Please, make sure that you have updated the chart dependencies before executing any upgrade.

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

### To 5.0.0

The [Bitnami Jenkins](https://github.com/bitnami/bitnami-docker-jenkins) image was migrated to a "non-root" user approach. Previously the container ran as the `root` user and the Jenkins service was started as the `jenkins` user. From now on, both the container and the Jenkins service run as user `jenkins` (`uid=1001`). You can revert this behavior by setting the parameters `securityContext.runAsUser`, and `securityContext.fsGroup` to `root`.
Ingress configuration was also adapted to follow the Helm charts best practices.

Consequences:

- No "privileged" actions are allowed anymore.
- Backwards compatibility is not guaranteed when persistence is enabled.

To upgrade to `5.0.0`, install a new Jenkins chart, and migrate your Jenkins data ensuring the `jenkins` user has the appropriate permissions.

### 4.0.0

Helm performs a lookup for the object based on its group (apps), version (v1), and kind (Deployment). Also known as its GroupVersionKind, or GVK. Changing the GVK is considered a compatibility breaker from Kubernetes' point of view, so you cannot "upgrade" those objects to the new GVK in-place. Earlier versions of Helm 3 did not perform the lookup correctly which has since been fixed to match the spec.

In 4dfac075aacf74405e31ae5b27df4369e84eb0b0 the `apiVersion` of the deployment resources was updated to `apps/v1` in tune with the api's deprecated, resulting in compatibility breakage.

This major version signifies this change.

### 1.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 1.0.0. The following example assumes that the release name is jenkins:

```console
kubectl patch deployment jenkins --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
```
