# Phabricator

[Phabricator](https://www.phacility.com) is a collection of open source web applications that help software companies build better software. Phabricator is built by developers for developers. Every feature is optimized around developer efficiency for however you like to work. Code Quality starts with an effective collaboration between team members.

## TL;DR

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/phabricator
```

## Introduction

This chart bootstraps a [Phabricator](https://github.com/bitnami/bitnami-docker-phabricator) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages the [Bitnami MariaDB chart](https://github.com/kubernetes/charts/tree/master/bitnami/mariadb) which is required for bootstrapping a MariaDB deployment for the database requirements of the Phabricator application.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This chart has been tested to work with NGINX Ingress, cert-manager, fluentd and Prometheus on top of the [BKPR](https://kubeprod.io/).

## Prerequisites

- Kubernetes 1.12+
- Helm 3.1.0
- PV provisioner support in the underlying infrastructure
- ReadWriteMany volumes for deployment scaling

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install my-release bitnami/phabricator
```

The command deploys Phabricator on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

The following tables list the configurable parameters of the Phabricator chart and their default values per section/component:

### Global parameters

| Parameter                        | Description                                                                                              | Default                                                      |
|----------------------------------|----------------------------------------------------------------------------------------------------------|--------------------------------------------------------------|
| `global.imageRegistry`           | Global Docker image registry                                                                             | `nil`                                                        |
| `global.imagePullSecrets`        | Global Docker registry secret names as an array                                                          | `[]` (does not add image pull secrets to deployed pods)      |
| `global.storageClass`            | Global storage class for dynamic provisioning                                                            | `nil`                                                        |

### Common parameters

| Parameter                        | Description                                                                                              | Default                                                      |
|----------------------------------|----------------------------------------------------------------------------------------------------------|--------------------------------------------------------------|
| `nameOverride`                   | String to partially override common.names.fullname template with a string (will prepend the release name)| `nil`                                                        |
| `fullnameOverride`               | String to fully override common.names.fullname template with a string                                    | `nil`                                                        |
| `commonLabels`                   | Labels to add to all deployed objects                                                                    | `{}`                                                         |
| `commonAnnotations`              | Annotations to add to all deployed objects                                                               | `{}`                                                         |
| `kubeVersion`                    | Force target Kubernetes version (using Helm capabilities if not set)                                     | `nil`                                                        |
| `clusterDomain`                  | Default Kubernetes cluster domain                                                                        | `cluster.local`                                              |
| `extraDeploy`                    | Array of extra objects to deploy with the release                                                        | `[]` (evaluated as a template)                               |

### Phabricator parameters

| Parameter                        | Description                                                                                              | Default                                                      |
|----------------------------------|----------------------------------------------------------------------------------------------------------|--------------------------------------------------------------|
| `image.registry`                 | Phabricator image registry                                                                               | `docker.io`                                                  |
| `image.repository`               | Phabricator image name                                                                                   | `bitnami/phabricator`                                        |
| `image.tag`                      | Phabricator image tag                                                                                    | `{TAG_NAME}`                                                 |
| `image.pullPolicy`               | Image pull policy                                                                                        | `IfNotPresent`                                               |
| `image.pullSecrets`              | Specify docker-registry secret names as an array                                                         | `[]` (does not add image pull secrets to deployed pods)      |
| `image.debug`                    | Specify if debug logs should be enabled                                                                  | `false`                                                      |
| `phabricatorUsername`            | User of the application                                                                                  | `user`                                                       |
| `phabricatorPassword`            | Application password                                                                                     | _random 10 character long alphanumeric string_               |
| `phabricatorEmail`               | Admin email                                                                                              | `user@example.com`                                           |
| `phabricatorFirstName`           | First name                                                                                               | `First Name`                                                 |
| `phabricatorLastName`            | Last name                                                                                                | `Last Name`                                                  |
| `phabricatorHost`                | Phabricator host to create application URLs                                                              | `nil`                                                        |
| `phabricatorAlternateFileDomain` | Phabricator alternate domain to upload files                                                             | `nil`                                                        |
| `phabricatorEnableHttps`         | Configure Phabricator to build application URLs using https                                              | `true`                                                       |
| `phabricatorUseLFS`              | Configure Phabricator to use GIT Large File Storage (LFS)                                                | `false`                                                      |
| `phabricatorGitSSH`              | Configure a self-hosted GIT repository with SSH authentication                                           | `false`                                                      |
| `phabricatorEnablePygments`      | Enable syntax highlighting using Pygments                                                                | `true`                                                       |
| `phabricatorSkipInstall`         | Skip the initial bootstrapping for the application                                                       | `false`                                                      |
| `smtpHost`                       | SMTP mail delivery host                                                                                  | `nil`                                                        |
| `smtpPort`                       | SMTP mail delivery port                                                                                  | `nil`                                                        |
| `smtpUser`                       | SMTP mail delivery user                                                                                  | `nil`                                                        |
| `smtpPassword`                   | SMTP mail delivery password                                                                              | `nil`                                                        |
| `smtpProtocol`                   | SMTP mail delivery protocol [`ssl`, `tls`]                                                               | `nil`                                                        |
| `command`                        | Override default container command (useful when using custom images)                                     | `nil`                                                        |
| `args`                           | Override default container args (useful when using custom images)                                        | `nil`                                                        |
| `extraEnvVars`                   | Extra environment variables to be set on Phabricator container                                           | `{}`                                                         |
| `extraEnvVarsCM`                 | Name of existing ConfigMap containing extra env vars                                                     | `nil`                                                        |
| `extraEnvVarsSecret`             | Name of existing Secret containing extra env vars                                                        | `nil`                                                        |

### Phabricator deployment parameters

| Parameter                        | Description                                                                                              | Default                                                 |
|----------------------------------|----------------------------------------------------------------------------------------------------------|---------------------------------------------------------|
| `containerPorts.http`            | HTTP port to expose at container level                                                                   | `8080`                                                  |
| `containerPorts.https`           | HTTPS port to expose at container level                                                                  | `8443`                                                  |
| `containerPorts.ssh`             | SSH port to expose at container level                                                                    | `2222`                                                  |
| `podSecurityContext`             | Phabricator pods' Security Context                                                                       | Check `values.yaml` file                                |
| `containerSecurityContext`       | Phabricator containers' Security Context                                                                 | Check `values.yaml` file                                |
| `resources.limits`               | The resources limits for the Phabricator container                                                       | `{}`                                                    |
| `resources.requests`             | The requested resources for the Phabricator container                                                    | `{"memory": "512Mi", "cpu": "300m"}`                    |
| `livenessProbe`                  | Liveness probe configuration for Phabricator                                                             | Check `values.yaml` file                                |
| `readinessProbe`                 | Readiness probe configuration for Phabricator                                                            | Check `values.yaml` file                                |
| `customLivenessProbe`            | Override default liveness probe                                                                          | `nil`                                                   |
| `customReadinessProbe`           | Override default readiness probe                                                                         | `nil`                                                   |
| `updateStrategy`                 | Strategy to use to update Pods                                                                           | Check `values.yaml` file                                |
| `podAffinityPreset`              | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                      | `""`                                                    |
| `podAntiAffinityPreset`          | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                 | `soft`                                                  |
| `nodeAffinityPreset.type`        | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                | `""`                                                    |
| `nodeAffinityPreset.key`         | Node label key to match. Ignored if `affinity` is set.                                                   | `""`                                                    |
| `nodeAffinityPreset.values`      | Node label values to match. Ignored if `affinity` is set.                                                | `[]`                                                    |
| `affinity`                       | Affinity for pod assignment                                                                              | `{}` (evaluated as a template)                          |
| `nodeSelector`                   | Node labels for pod assignment                                                                           | `{}` (evaluated as a template)                          |
| `tolerations`                    | Tolerations for pod assignment                                                                           | `[]` (evaluated as a template)                          |
| `podLabels`                      | Extra labels for Phabricator pods                                                                        | `{}` (evaluated as a template)                          |
| `podAnnotations`                 | Annotations for Phabricator pods                                                                         | `{}` (evaluated as a template)                          |
| `extraVolumeMounts`              | Optionally specify extra list of additional volumeMounts for Phabricator container(s)                    | `[]`                                                    |
| `extraVolumes`                   | Optionally specify extra list of additional volumes for Phabricator pods                                 | `[]`                                                    |
| `initContainers`                 | Add additional init containers to the Phabricator pods                                                   | `{}` (evaluated as a template)                          |
| `sidecars`                       | Add additional sidecar containers to the Phabricator pods                                                | `{}` (evaluated as a template)                          |
| `persistence.enabled`            | Enable persistence using PVC                                                                             | `true`                                                  |
| `persistence.storageClass`       | PVC Storage Class for Phabricator volume                                                                 | `nil` (uses alpha storage class annotation)             |
| `persistence.accessMode`         | PVC Access Mode for Phabricator volume                                                                   | `ReadWriteOnce`                                         |
| `persistence.size`               | PVC Storage Request for Phabricator volume                                                               | `8Gi`                                                   |
| `persistence.existingClaim`      | An Existing PVC name for Phabricator volume                                                              | `nil` (uses alpha storage class annotation)             |
| `persistence.hostPath`           | Host mount path for Phabricator volume                                                                   | `nil` (will not mount to a host path)                   |

### Traffic Exposure Parameters

| Parameter                        | Description                                                                                              | Default                                                 |
|----------------------------------|----------------------------------------------------------------------------------------------------------|---------------------------------------------------------|
| `service.type`                   | Kubernetes Service type                                                                                  | `LoadBalancer`                                          |
| `service.port`                   | Service HTTP port                                                                                        | `80`                                                    |
| `service.httpsPort`              | Service HTTP port                                                                                        | `443`                                                   |
| `service.sshPort`                | Service SSH port                                                                                         | `22`                                                    |
| `service.loadBalancerIP`         | `loadBalancerIP` for the Phabricator Service                                                             | `nil`                                                   |
| `service.externalTrafficPolicy`  | Enable client source IP preservation                                                                     | `Cluster`                                               |
| `service.nodePorts.http`         | Kubernetes http node port                                                                                | `""`                                                    |
| `service.nodePorts.https`        | Kubernetes https node port                                                                               | `""`                                                    |
| `service.nodePorts.ssh`          | Kubernetes ssh node port                                                                                 | `""`                                                    |
| `service.annotations`            | Service annotations                                                                                      | `[]`                                                    |
| `ingress.enabled`                | Enable ingress controller resource                                                                       | `false`                                                 |
| `ingress.certManager`            | Add annotations for cert-manager                                                                         | `false`                                                 |
| `ingress.hostname`               | Default host for the ingress resource                                                                    | `phabricator.local`                                     |
| `ingress.apiVersion`             | Force Ingress API version (automatically detected if not set)                                            | `nil`                                                   |
| `ingress.path`                   | Ingress path                                                                                             | `/`                                                     |
| `ingress.pathType`               | Ingress path type                                                                                        | `ImplementationSpecific`                                |
| `ingress.tls`                    | Create TLS Secret                                                                                        | `false`                                                 |
| `ingress.annotations`            | Ingress annotations                                                                                      | `[]` (evaluated as a template)                          |
| `ingress.extraHosts[0].name`     | Additional hostnames to be covered                                                                       | `nil`                                                   |
| `ingress.extraHosts[0].path`     | Additional hostnames to be covered                                                                       | `nil`                                                   |
| `ingress.extraPaths`             | Additional arbitrary path/backend objects                                                                | `nil`                                                   |
| `ingress.extraTls[0].hosts[0]`   | TLS configuration for additional hostnames to be covered                                                 | `nil`                                                   |
| `ingress.extraTls[0].secretName` | TLS configuration for additional hostnames to be covered                                                 | `nil`                                                   |
| `ingress.secrets[0].name`        | TLS Secret Name                                                                                          | `nil`                                                   |
| `ingress.secrets[0].certificate` | TLS Secret Certificate                                                                                   | `nil`                                                   |
| `ingress.secrets[0].key`         | TLS Secret Key                                                                                           | `nil`                                                   |

### Database parameters

| Parameter                                  | Description                                                                                    | Default                                                 |
|--------------------------------------------|------------------------------------------------------------------------------------------------|---------------------------------------------------------|
| `mariadb.enabled`                          | Whether to use the MariaDB chart                                                               | `true`                                                  |
| `mariadb.architecture`                     | MariaDB architecture (`standalone` or `replication`)                                           | `standalone`                                            |
| `mariadb.auth.rootPassword`                | Password for the MariaDB `root` user                                                           | _random 10 character alphanumeric string_               |
| `mariadb.primary.configuration`            | MariaDB Primary configuration to be injected as ConfigMap                                      | Check `values.yaml` file                                |
| `mariadb.primary.extraFlags`               | Additional command line flags                                                                  | Check `values.yaml` file                                |
| `mariadb.primary.persistence.enabled`      | Enable database persistence using PVC                                                          | `true`                                                  |
| `mariadb.primary.persistence.accessMode`   | Database Persistent Volume Access Modes                                                        | `ReadWriteOnce`                                         |
| `mariadb.primary.persistence.size`         | Database Persistent Volume Size                                                                | `8Gi`                                                   |
| `mariadb.primary.persistence.existingClaim`| Enable persistence using an existing PVC                                                       | `nil`                                                   |
| `mariadb.primary.persistence.storageClass` | PVC Storage Class                                                                              | `nil` (uses alpha storage class annotation)             |
| `mariadb.primary.persistence.hostPath`     | Host mount path for MariaDB volume                                                             | `nil` (will not mount to a host path)                   |
| `externalDatabase.host`                    | Host of the existing database                                                                  | `nil`                                                   |
| `externalDatabase.port`                    | Port of the existing database                                                                  | `3306`                                                  |
| `externalDatabase.rootUser`                | Username in the external db with root privileges                                               | `root`                                                  |
| `externalDatabase.rootPassword`            | Password for the above username                                                                | `nil`                                                   |
| `externalDatabase.existingSecret`          | Name of the database existing Secret Object                                                    | `nil`                                                   |

### Volume Permissions parameters

| Parameter                                  | Description                                                                                    | Default                                                 |
|--------------------------------------------|------------------------------------------------------------------------------------------------|---------------------------------------------------------|
| `volumePermissions.enabled`                | Enable init container that changes volume permissions in the data directory (                  | `false`                                                 |
| `volumePermissions.image.registry`         | Init container volume-permissions image registry                                               | `docker.io`                                             |
| `volumePermissions.image.repository`       | Init container volume-permissions image name                                                   | `bitnami/bitnami-shell`                                 |
| `volumePermissions.image.tag`              | Init container volume-permissions image tag                                                    | `"10"`                                                  |
| `volumePermissions.image.pullSecrets`      | Specify docker-registry secret names as an array                                               | `[]` (does not add image pull secrets to deployed pods) |
| `volumePermissions.image.pullPolicy`       | Init container volume-permissions image pull policy                                            | `Always`                                                |
| `volumePermissions.resources`              | Init container resource requests/limit                                                         | `nil`                                                   |

### Metrics parameters

| Parameter                        | Description                                                                                              | Default                                                      |
|----------------------------------|----------------------------------------------------------------------------------------------------------|--------------------------------------------------------------|
| `metrics.enabled`                | Start a side-car prometheus exporter                                                                     | `false`                                                      |
| `metrics.image.registry`         | Apache exporter image registry                                                                           | `docker.io`                                                  |
| `metrics.image.repository`       | Apache exporter image name                                                                               | `bitnami/apache-exporter`                                    |
| `metrics.image.tag`              | Apache exporter image tag                                                                                | `{TAG_NAME}`                                                 |
| `metrics.image.pullPolicy`       | Image pull policy                                                                                        | `IfNotPresent`                                               |
| `metrics.image.pullSecrets`      | Specify docker-registry secret names as an array                                                         | `[]` (does not add image pull secrets to deployed pods)      |
| `metrics.podAnnotations`         | Additional annotations for Metrics exporter pod                                                          | `{prometheus.io/scrape: "true", prometheus.io/port: "9117"}` |
| `metrics.resources`              | Exporter resource requests/limit                                                                         | `{}`                                                         |

The above parameters map to the env variables defined in [bitnami/phabricator](http://github.com/bitnami/bitnami-docker-phabricator). For more information please refer to the [bitnami/phabricator](http://github.com/bitnami/bitnami-docker-phabricator) image documentation.

> **Note**:
>
> For Phabricator to function correctly, you should specify the `phabricatorHost` parameter to specify the FQDN (recommended) or the public IP address of the Phabricator service.
>
> Optionally, you can specify the `phabricatorLoadBalancerIP` parameter to assign a reserved IP address to the Phabricator service of the chart. However please note that this feature is only available on a few cloud providers (f.e. GKE).
>
> To reserve a public IP address on GKE:
>
> ```bash
> $ gcloud compute addresses create phabricator-public-ip
> ```
>
> The reserved IP address can be associated to the Phabricator service by specifying it as the value of the `phabricatorLoadBalancerIP` parameter while installing the chart.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install my-release \
  --set phabricatorUsername=admin,phabricatorPassword=password,mariadb.auth.rootPassword=secretpassword \
  bitnami/phabricator
```

The above command sets the Phabricator administrator account username and password to `admin` and `password` respectively. Additionally, it sets the MariaDB `root` user password to `secretpassword`.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install my-release -f values.yaml bitnami/phabricator
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Using an external database

Sometimes you may want to have Phabricator connect to an external database rather than installing one inside your cluster, e.g. to use a managed database service, or use run a single database server for all your applications. To do this, the chart allows you to specify credentials for an external database under the [`externalDatabase` parameter](#parameters). You should also disable the MariaDB installation with the `mariadb.enabled` option. For example with the following parameters:

```console
mariadb.enabled=false
externalDatabase.host=myexternalhost
externalDatabase.port=3306
externalDatabase.rootUser=myuser
externalDatabase.rootPassword=mypassword
```

Note also if you disable MariaDB per above you MUST supply values for the `externalDatabase` connection.

### Ingress

This chart provides support for ingress resources. If you have an ingress controller installed on your cluster, such as [nginx-ingress-controller](https://github.com/bitnami/charts/tree/master/bitnami/nginx-ingress-controller) or [contour](https://github.com/bitnami/charts/tree/master/bitnami/contour) you can utilize the ingress controller to serve your application.

To enable ingress integration, please set `ingress.enabled` to `true`.

#### Hosts

Most likely you will only want to have one hostname that maps to this Phabricator installation. If that's your case, the property `ingress.hostname` will set it. However, it is possible to have more than one host. To facilitate this, the `ingress.extraHosts` object can be specified as an array. You can also use `ingress.extraTLS` to add the TLS configuration for extra hosts.

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

If you are going to manage TLS secrets outside of Helm, please know that you can create a TLS secret (named `phabricator.local-tls` for example).

### Adding extra environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `extraEnvVars` property.

```yaml
extraEnvVars:
  - name: LOG_LEVEL
    value: DEBUG
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values.

### Sidecars and Init Containers

If you have a need for additional containers to run within the same pod as the Phabricator app (e.g. an additional metrics or logging exporter), you can do so via the `sidecars` config parameter. Simply define your container according to the Kubernetes container spec.

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

This chart allows you to set your custom affinity using the `affinity` paremeter. Find more infomation about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

## Persistence

The [Bitnami Phabricator](https://github.com/bitnami/bitnami-docker-phabricator) image stores the Phabricator data and configurations at the `/bitnami/phabricator` path of the container.

Persistent Volume Claims are used to keep the data across deployments. There is a [known issue](https://github.com/kubernetes/kubernetes/issues/39178) in Kubernetes Clusters with EBS in different availability zones. Ensure your cluster is configured properly to create Volumes in the same availability zone where the nodes are running. Kuberentes 1.12 solved this issue with the [Volume Binding Mode](https://kubernetes.io/docs/concepts/storage/storage-classes/#volume-binding-mode).

See the [Parameters](#parameters) section to configure the PVC or to disable persistence.

### Existing PersistentVolumeClaim

1. Create the PersistentVolume
1. Create the PersistentVolumeClaim
1. Install the chart

    ```bash
    $ helm install my-release --set persistence.existingClaim=PVC_NAME bitnami/phabricator
    ```

### Host path

#### System compatibility

- The local filesystem accessibility to a container in a pod with `hostPath` has been tested on OSX/MacOS with xhyve, and Linux with VirtualBox.
- Windows has not been tested with the supported VM drivers. Minikube does however officially support [Mounting Host Folders](https://github.com/kubernetes/minikube/blob/master/docs/host_folder_mount.md) per pod. Or you may manually sync your container whenever host files are changed with tools like [docker-sync](https://github.com/EugenMayer/docker-sync) or [docker-bg-sync](https://github.com/cweagans/docker-bg-sync).

#### Mounting steps

1. The specified `hostPath` directory must already exist (create one if it does not).
1. Install the chart

    ```bash
    $ helm install my-release --set persistence.hostPath=/PATH/TO/HOST/MOUNT bitnami/phabricator
    ```

    This will mount the `phabricator-data` volume into the `hostPath` directory. The site data will be persisted if the mount path contains valid data, else the site data will be initialized at first launch.
1. Because the container cannot control the host machine's directory permissions, you must set the Phabricator file directory permissions yourself.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami’s Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 11.0.0

In this major there were two main changes introduced:

- Parameter standarizations
- Migration to non-root

To upgrade to `11.0.0`, backup Phabricator data and the previous MariaDB databases, install a new Phabricator chart and import the backups and data, ensuring the `1001` user has the appropriate permissions on the migrated volume.

**1. Chart standarizations**

This upgrade adapts the chart to the latest Bitnami good practices. Check the Parameters section for more information. In summary:

- New parameters were added.
- Some parameters were renamed or disappeared in favor of new ones in this major version.
- This version also introduces `bitnami/common`, a [library chart](https://helm.sh/docs/topics/library_charts/#helm) as a dependency. More documentation about this new utility could be found [here](https://github.com/bitnami/charts/tree/master/bitnami/common#bitnami-common-library-chart). Please, make sure that you have updated the chart dependencies before executing any upgrade.

**2. Migration of the Phabricator image to non-root**

The [Bitnami Phabricator](https://github.com/bitnami/bitnami-docker-phabricator) image was migrated to a "non-root" user approach. Previously the container ran as the `root` user and the Apache daemon was started as the `daemon` while the Phabricator daemons were started as the `phabricator` user. From now on, both the container and the different daemons run as user `1001`.. Consequences:

- The HTTP/HTTPS ports exposed by the container are now `8080/8443` instead of `80/443`.
- Backwards compatibility is not guaranteed. Uninstall & install the chart again to obtain the latest version.

You can revert this behavior by setting the parameters `containerSecurityContext.runAsUser` to `root`.

### To 10.0.0

In this major there were two main changes introduced:

1. Adaptation to Helm v2 EOL
2. Updated MariaDB dependency version

Please read the update notes carefully.

**1. Adaptation to Helm v2 EOL**

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

**2. Updated MariaDB dependency version**

In this major the MariaDB dependency version was also bumped to a new major version that introduces several incompatilibites. Therefore, backwards compatibility is not guaranteed unless an external database is used. Check [MariaDB Upgrading Notes](https://github.com/bitnami/charts/tree/master/bitnami/mariadb#to-800) for more information.

To upgrade to `10.0.0`, it should be done reusing the PVCs used to hold both the MariaDB and Phabricator data on your previous release. To do so, follow the instructions below (the following example assumes that the release name is `phabricator` and that a `rootUser.password` was defined for MariaDB in `values.yaml` when the chart was first installed):

> NOTE: Please, create a backup of your database before running any of those actions. The steps below would be only valid if your application (e.g. any plugins or custom code) is compatible with MariaDB 10.5.x

Obtain the credentials and the names of the PVCs used to hold both the MariaDB and Phabricator data on your current release:

```console
export PHABRICATOR_HOST=$(kubectl get svc --namespace default phabricator --template "{{ range (index .status.loadBalancer.ingress 0) }}{{ . }}{{ end }}")
export PHABRICATOR_PASSWORD=$(kubectl get secret --namespace default phabricator -o jsonpath="{.data.phabricator-password}" | base64 --decode)
export MARIADB_ROOT_PASSWORD=$(kubectl get secret --namespace default phabricator-mariadb -o jsonpath="{.data.mariadb-root-password}" | base64 --decode)
export MARIADB_PVC=$(kubectl get pvc -l app=mariadb,component=master,release=phabricator -o jsonpath="{.items[0].metadata.name}")
```

Delete the Phabricator deployment and delete the MariaDB statefulset. Notice the option `--cascade=false` in the latter.

```console
  $ kubectl delete deployments.apps phabricator

  $ kubectl delete statefulsets.apps phabricator-mariadb --cascade=false
```

Now the upgrade works:

```console
$ helm upgrade phabricator bitnami/phabricator --set mariadb.primary.persistence.existingClaim=$MARIADB_PVC --set mariadb.auth.rootPassword=$MARIADB_ROOT_PASSWORD --set phabricatorPassword=$PHABRICATOR_PASSWORD --set phabricatorHost=$PHABRICATOR_HOST
```

You will have to delete the existing MariaDB pod and the new statefulset is going to create a new one

  ```console
  $ kubectl delete pod phabricator-mariadb-0
  ```

Finally, you should see the lines below in MariaDB container logs:

```console
$ kubectl logs $(kubectl get pods -l app.kubernetes.io/instance=phabricator,app.kubernetes.io/name=mariadb,app.kubernetes.io/component=primary -o jsonpath="{.items[0].metadata.name}")
...
mariadb 12:13:24.98 INFO  ==> Using persisted data
mariadb 12:13:25.01 INFO  ==> Running mysql_upgrade
...
```

### To 9.0.0

Helm performs a lookup for the object based on its group (apps), version (v1), and kind (Deployment). Also known as its GroupVersionKind, or GVK. Changing the GVK is considered a compatibility breaker from Kubernetes' point of view, so you cannot "upgrade" those objects to the new GVK in-place. Earlier versions of Helm 3 did not perform the lookup correctly which has since been fixed to match the spec.

In https://github.com/helm/charts/pulls/17305 the `apiVersion` of the deployment resources was updated to `apps/v1` in tune with the api's deprecated, resulting in compatibility breakage.

This major version signifies this change.

### To 7.0.0

Backwards compatibility is not guaranteed. The following notables changes were included:

- Labels are adapted to follow the Helm charts best practices.
- The parameters `persistence.phabricator.storageClass`, `persistence.phabricator.accessMode`, and `persistence.phabricator.size` switch to `persistence.storageClass`, `persistence.accessMode`, and `persistence.size`.
- The way of setting the ingress rules has changed. Instead of using `ingress.paths` and `ingress.hosts` as separate objects, you should now define the rules as objects inside the `ingress.hosts` value, for example:

```yaml
ingress:
  hosts:
  - name: phabricator.local
    path: /
```

### To 3.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 3.0.0. The following example assumes that the release name is opencart:

```console
$ kubectl patch deployment opencart-opencart --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/app"}]'
$ kubectl delete statefulset opencart-mariadb --cascade=false
```
