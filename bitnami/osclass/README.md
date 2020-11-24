# Osclass

[Osclass](https://osclass.org/) is a PHP script that allows you to quickly create and manage your own free classifieds site. Using this script, you can provide free advertising for items for sale, real estate, jobs, cars... Hundreds of free classified advertising sites are using Osclass.

## TL;DR

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/osclass
```

## Introduction

This chart bootstraps an [Osclass](https://github.com/bitnami/bitnami-docker-osclass) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages the [Bitnami MariaDB chart](https://github.com/kubernetes/charts/tree/master/bitnami/mariadb) which is required for bootstrapping a MariaDB deployment for the database requirements of the Osclass application.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This chart has been tested to work with NGINX Ingress, cert-manager, fluentd and Prometheus on top of the [BKPR](https://kubeprod.io/).

## Prerequisites

- Kubernetes 1.12+
- Helm 3.0-beta3+
- PV provisioner support in the underlying infrastructure
- ReadWriteMany volumes for deployment scaling

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install my-release bitnami/osclass
```

The command deploys Osclass on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

The following table lists the configurable parameters of the Osclass chart and their default values.

| Parameter                          | Description                                                                                          | Default                                                      |
|------------------------------------|------------------------------------------------------------------------------------------------------|--------------------------------------------------------------|
| `global.imageRegistry`             | Global Docker image registry                                                                         | `nil`                                                        |
| `global.imagePullSecrets`          | Global Docker registry secret names as an array                                                      | `[]` (does not add image pull secrets to deployed pods)      |
| `global.storageClass`              | Global storage class for dynamic provisioning                                                        | `nil`                                                        |
| `image.registry`                   | Osclass image registry                                                                               | `docker.io`                                                  |
| `image.repository`                 | Osclass Image name                                                                                   | `bitnami/osclass`                                            |
| `image.tag`                        | Osclass Image tag                                                                                    | `{TAG_NAME}`                                                 |
| `image.pullPolicy`                 | Image pull policy                                                                                    | `IfNotPresent`                                               |
| `image.pullSecrets`                | Specify docker-registry secret names as an array                                                     | `[]` (does not add image pull secrets to deployed pods)      |
| `nameOverride`                     | String to partially override osclass.fullname template with a string (will prepend the release name) | `nil`                                                        |
| `fullnameOverride`                 | String to fully override osclass.fullname template with a string                                     | `nil`                                                        |
| `osclassHost`                      | Osclass host to create application URLs                                                              | `nil`                                                        |
| `osclassLoadBalancerIP`            | `loadBalancerIP` for the Osclass Service                                                             | `nil`                                                        |
| `osclassUsername`                  | User of the application                                                                              | `user`                                                       |
| `osclassPassword`                  | Application password                                                                                 | `bitnami`                                                    |
| `osclassEmail`                     | Admin email                                                                                          | `user@example.com`                                           |
| `osclassWebTitle`                  | Application tittle                                                                                   | `Sample Web Page`                                            |
| `osclassPingEngines`               | Allow site to appear in search engines                                                               | `1`                                                          |
| `osclassSaveStats`                 | Send statistics and reports to Osclass                                                               | `1`                                                          |
| `smtpHost`                         | SMTP host                                                                                            | `nil`                                                        |
| `smtpPort`                         | SMTP port                                                                                            | `nil`                                                        |
| `smtpUser`                         | SMTP user                                                                                            | `nil`                                                        |
| `smtpPassword`                     | SMTP password                                                                                        | `nil`                                                        |
| `smtpProtocol`                     | SMTP protocol [`ssl`, `tls`]                                                                         | `nil`                                                        |
| `serviceType`                      | Kubernetes Service type                                                                              | `LoadBalancer`                                               |
| `resources`                        | CPU/Memory resource requests/limits                                                                  | Memory: `512Mi`, CPU: `300m`                                 |
| `persistence.enabled`              | Enable persistence using PVC                                                                         | `true`                                                       |
| `persistence.moodle.storageClass`  | PVC Storage Class for OSClass volume                                                                 | `nil` (uses alpha storage class annotation)                  |
| `persistence.moodle.accessMode`    | PVC Access Mode for OSClass volume                                                                   | `ReadWriteOnce`                                              |
| `persistence.moodle.size`          | PVC Storage Request for OSClass volume                                                               | `8Gi`                                                        |
| `allowEmptyPassword`               | Allow DB blank passwords                                                                             | `yes`                                                        |
| `ingress.enabled`                  | Enable ingress controller resource                                                                   | `false`                                                      |
| `ingress.annotations`              | Ingress annotations                                                                                  | `[]`                                                         |
| `ingress.certManager`              | Add annotations for cert-manager                                                                     | `false`                                                      |
| `ingress.hosts[0].name`            | Hostname to your osclass installation                                                                | `osclass.local`                                              |
| `ingress.hosts[0].path`            | Path within the url structure                                                                        | `/`                                                          |
| `ingress.hosts[0].tls`             | Utilize TLS backend in ingress                                                                       | `false`                                                      |
| `ingress.hosts[0].tlsHosts`        | Array of TLS hosts for ingress record (defaults to `ingress.hosts[0].name` if `nil`)                 | `nil`                                                        |
| `ingress.hosts[0].tlsSecret`       | TLS Secret (certificates)                                                                            | `osclass.local-tls-secret`                                   |
| `ingress.secrets[0].name`          | TLS Secret Name                                                                                      | `nil`                                                        |
| `ingress.secrets[0].certificate`   | TLS Secret Certificate                                                                               | `nil`                                                        |
| `ingress.secrets[0].key`           | TLS Secret Key                                                                                       | `nil`                                                        |
| `podAnnotations`                   | Pod annotations                                                                                      | `{}`                                                         |
| `affinity`                         | Map of node/pod affinities                                                                           | `{}`                                                         |
| `metrics.enabled`                  | Start a side-car prometheus exporter                                                                 | `false`                                                      |
| `metrics.image.registry`           | Apache exporter image registry                                                                       | `docker.io`                                                  |
| `metrics.image.repository`         | Apache exporter image name                                                                           | `bitnami/apache-exporter`                                    |
| `metrics.image.tag`                | Apache exporter image tag                                                                            | `{TAG_NAME}`                                                 |
| `metrics.image.pullPolicy`         | Image pull policy                                                                                    | `IfNotPresent`                                               |
| `metrics.image.pullSecrets`        | Specify docker-registry secret names as an array                                                     | `[]` (does not add image pull secrets to deployed pods)      |
| `metrics.podAnnotations`           | Additional annotations for Metrics exporter pod                                                      | `{prometheus.io/scrape: "true", prometheus.io/port: "9117"}` |
| `metrics.resources`                | Exporter resource requests/limit                                                                     | {}                                                           |
### Database parameters

| Parameter                                  | Description                                           | Default                                        |
|--------------------------------------------|-------------------------------------------------------|------------------------------------------------|
| `mariadb.enabled`                          | Whether to use the MariaDB chart                      | `true`                                         |
| `mariadb.architecture`                     | MariaDB architecture (`standalone` or `replication`)  | `standalone`                                   |
| `mariadb.auth.rootPassword`                | Password for the MariaDB `root` user                  | _random 10 character alphanumeric string_      |
| `mariadb.auth.database`                    | Database name to create                               | `bitnami_osclass`                              |
| `mariadb.auth.username`                    | Database user to create                               | `bn_osclass`                                   |
| `mariadb.auth.password`                    | Password for the database                             | _random 10 character long alphanumeric string_ |
| `mariadb.primary.persistence.enabled`      | Enable database persistence using PVC                 | `true`                                         |
| `mariadb.primary.persistence.accessMode`   | Database Persistent Volume Access Modes               | `ReadWriteOnce`                                |
| `mariadb.primary.persistence.size`         | Database Persistent Volume Size                       | `8Gi`                                          |
| `mariadb.primary.persistence.existingClaim`| Enable persistence using an existing PVC              | `nil`                                          |
| `mariadb.primary.persistence.storageClass` | PVC Storage Class                                     | `nil` (uses alpha storage class annotation)    |
| `mariadb.primary.persistence.hostPath`     | Host mount path for MariaDB volume                    | `nil` (will not mount to a host path)          |
| `externalDatabase.user`                    | Existing username in the external db                  | `bn_osclass`                                   |
| `externalDatabase.password`                | Password for the above username                       | `nil`                                          |
| `externalDatabase.database`                | Name of the existing database                         | `bitnami_osclass`                              |
| `externalDatabase.host`                    | Host of the existing database                         | `nil`                                          |
| `externalDatabase.port`                    | Port of the existing database                         | `3306`                                         |
| `externalDatabase.existingSecret`          | Name of the database existing Secret Object           | `nil`                                          |

The above parameters map to the env variables defined in [bitnami/osclass](http://github.com/bitnami/bitnami-docker-osclass). For more information please refer to the [bitnami/osclass](http://github.com/bitnami/bitnami-docker-osclass) image documentation.

> **Note**:
>
> For Osclass to function correctly, you should specify the `osclassHost` parameter to specify the FQDN (recommended) or the public IP address of the Osclass service.
>
> Optionally, you can specify the `osclassLoadBalancerIP` parameter to assign a reserved IP address to the Osclass service of the chart. However please note that this feature is only available on a few cloud providers (f.e. GKE).
>
> To reserve a public IP address on GKE:
>
> ```bash
> $ gcloud compute addresses create osclass-public-ip
> ```
>
> The reserved IP address can be associated to the Osclass service by specifying it as the value of the `osclassLoadBalancerIP` parameter while installing the chart.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install my-release \
  --set osclassUsername=admin,osclassPassword=password,mariadb.mariadbRootPassword=secretpassword \
    bitnami/osclass
```

The above command sets the Osclass administrator account username and password to `admin` and `password` respectively. Additionally, it sets the MariaDB `root` user password to `secretpassword`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install my-release -f values.yaml bitnami/osclass
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

## Persistence

The [Bitnami Osclass](https://github.com/bitnami/bitnami-docker-osclass) image stores the Osclass data and configurations at the `/bitnami/osclass` path of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Parameters](#parameters) section to configure the PVC or to disable persistence.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami’s Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 8.0.0

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

To upgrade to `8.0.0`, it should be done reusing the PVCs used to hold both the MariaDB and Osclass data on your previous release. To do so, follow the instructions below (the following example assumes that the release name is `osclass` and that a `rootUser.password` was defined for MariaDB in `values.yaml` when the chart was first installed):

> NOTE: Please, create a backup of your database before running any of those actions. The steps below would be only valid if your application (e.g. any plugins or custom code) is compatible with MariaDB 10.5.x

Obtain the credentials and the names of the PVCs used to hold both the MariaDB and Osclass data on your current release:

```console
export OSCLASS_HOST=$(kubectl get svc --namespace default osclass --template "{{ range (index .status.loadBalancer.ingress 0) }}{{ . }}{{ end }}")
export OSCLASS_PASSWORD=$(kubectl get secret --namespace default osclass -o jsonpath="{.data.osclass-password}" | base64 --decode)
export MARIADB_ROOT_PASSWORD=$(kubectl get secret --namespace default osclass-mariadb -o jsonpath="{.data.mariadb-root-password}" | base64 --decode)
export MARIADB_PASSWORD=$(kubectl get secret --namespace default osclass-mariadb -o jsonpath="{.data.mariadb-password}" | base64 --decode)
export MARIADB_PVC=$(kubectl get pvc -l app=mariadb,component=master,release=osclass -o jsonpath="{.items[0].metadata.name}")
```

Delete the Osclass deployment and delete the MariaDB statefulset. Notice the option `--cascade=false` in the latter:

```console
  $ kubectl delete deployments.apps osclass

  $ kubectl delete statefulsets.apps osclass-mariadb --cascade=false
```

Now the upgrade works:

```console
$ helm upgrade osclass bitnami/osclass --set mariadb.primary.persistence.existingClaim=$MARIADB_PVC --set mariadb.auth.rootPassword=$MARIADB_ROOT_PASSWORD --set mariadb.auth.password=$MARIADB_PASSWORD --set osclassPassword=$OSCLASS_PASSWORD --set osclassHost=$OSCLASS_HOST
```

You will have to delete the existing MariaDB pod and the new statefulset is going to create a new one

  ```console
  $ kubectl delete pod osclass-mariadb-0
  ```

Finally, you should see the lines below in MariaDB container logs:

```console
$ kubectl logs $(kubectl get pods -l app.kubernetes.io/instance=osclass,app.kubernetes.io/name=mariadb,app.kubernetes.io/component=primary -o jsonpath="{.items[0].metadata.name}")
...
mariadb 12:13:24.98 INFO  ==> Using persisted data
mariadb 12:13:25.01 INFO  ==> Running mysql_upgrade
...
```

### To 7.0.0

Helm performs a lookup for the object based on its group (apps), version (v1), and kind (Deployment). Also known as its GroupVersionKind, or GVK. Changing the GVK is considered a compatibility breaker from Kubernetes' point of view, so you cannot "upgrade" those objects to the new GVK in-place. Earlier versions of Helm 3 did not perform the lookup correctly which has since been fixed to match the spec.

In https://github.com/helm/charts/pull/17303 the `apiVersion` of the deployment resources was updated to `apps/v1` in tune with the api's deprecated, resulting in compatibility breakage.

This major version signifies this change.

### To 3.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 3.0.0. The following example assumes that the release name is osclass:

```console
$ kubectl patch deployment osclass-osclass --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
$ kubectl delete statefulset osclass-mariadb --cascade=false
