# JasperReports

[JasperReports](http://community.jaspersoft.com/project/jasperreports-server) The JasperReports server can be used as a stand-alone or embedded reporting and BI server that offers web-based reporting, analytic tools and visualization, and a dashboard feature for compiling multiple custom views

## TL;DR

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/jasperreports
```

## Introduction

This chart bootstraps a [JasperReports](https://github.com/bitnami/bitnami-docker-jasperreports) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages the [Bitnami MariaDB chart](https://github.com/kubernetes/charts/tree/master/bitnami/mariadb) which bootstraps a MariaDB deployment required by the JasperReports application.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This chart has been tested to work with NGINX Ingress, cert-manager, fluentd and Prometheus on top of the [BKPR](https://kubeprod.io/).

## Prerequisites

- Kubernetes 1.12+
- Helm 3.0-beta3+
- PV provisioner support in the underlying infrastructure
- ReadWriteMany volumes for deployment scaling

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install my-release bitnami/jasperreports
```

The command deploys JasperReports on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

The following table lists the configurable parameters of the JasperReports chart and their default values.

| Parameter                        | Description                                                                                                | Default                                                 |
|----------------------------------|------------------------------------------------------------------------------------------------------------|---------------------------------------------------------|
| `global.imageRegistry`           | Global Docker image registry                                                                               | `nil`                                                   |
| `global.imagePullSecrets`        | Global Docker registry secret names as an array                                                            | `[]` (does not add image pull secrets to deployed pods) |
| `global.storageClass`            | Global storage class for dynamic provisioning                                                              | `nil`                                                   |
| `image.registry`                 | JasperReports image registry                                                                               | `docker.io`                                             |
| `image.repository`               | JasperReports Image name                                                                                   | `bitnami/jasperreports`                                 |
| `image.tag`                      | JasperReports Image tag                                                                                    | `{TAG_NAME}`                                            |
| `image.pullPolicy`               | Image pull policy                                                                                          | `IfNotPresent`                                          |
| `image.pullSecrets`              | Specify docker-registry secret names as an array                                                           | `[]` (does not add image pull secrets to deployed pods) |
| `nameOverride`                   | String to partially override jasperreports.fullname template with a string (will prepend the release name) | `nil`                                                   |
| `fullnameOverride`               | String to fully override jasperreports.fullname template with a string                                     | `nil`                                                   |
| `jasperreportsUsername`          | User of the application                                                                                    | `user`                                                  |
| `jasperreportsPassword`          | Application password                                                                                       | _random 10 character long alphanumeric string_          |
| `jasperreportsEmail`             | User email                                                                                                 | `user@example.com`                                      |
| `smtpHost`                       | SMTP host                                                                                                  | `nil`                                                   |
| `smtpPort`                       | SMTP port                                                                                                  | `nil`                                                   |
| `smtpEmail`                      | SMTP email                                                                                                 | `nil`                                                   |
| `smtpUser`                       | SMTP user                                                                                                  | `nil`                                                   |
| `smtpPassword`                   | SMTP password                                                                                              | `nil`                                                   |
| `smtpProtocol`                   | SMTP protocol [`ssl`, `none`]                                                                              | `nil`                                                   |
| `allowEmptyPassword`             | Allow DB blank passwords                                                                                   | `yes`                                                   |
| `ingress.enabled`                | Enable ingress controller resource                                                                         | `false`                                                 |
| `ingress.annotations`            | Ingress annotations                                                                                        | `[]`                                                    |
| `ingress.certManager`            | Add annotations for cert-manager                                                                           | `false`                                                 |
| `ingress.hosts[0].name`          | Hostname to your JasperReports installation                                                                | `jasperreports.local`                                   |
| `ingress.hosts[0].path`          | Path within the url structure                                                                              | `/`                                                     |
| `ingress.hosts[0].tls`           | Utilize TLS backend in ingress                                                                             | `false`                                                 |
| `ingress.hosts[0].tlsHosts`      | Array of TLS hosts for ingress record (defaults to `ingress.hosts[0].name` if `nil`)                       | `nil`                                                   |
| `ingress.hosts[0].tlsSecret`     | TLS Secret (certificates)                                                                                  | `jasperreports.local-tls-secret`                        |
| `ingress.secrets[0].name`        | TLS Secret Name                                                                                            | `nil`                                                   |
| `ingress.secrets[0].certificate` | TLS Secret Certificate                                                                                     | `nil`                                                   |
| `ingress.secrets[0].key`         | TLS Secret Key                                                                                             | `nil`                                                   |
| `service.type`                   | Kubernetes Service type                                                                                    | `LoadBalancer`                                          |
| `service.externalTrafficPolicy`  | Enable client source IP preservation                                                                       | `Cluster`                                               |
| `service.port`                   | Service HTTP port                                                                                          | `80`                                                    |
| `service.nodePorts.http`         | Kubernetes http node port                                                                                  | `""`                                                    |
| `service.annotations`            | Service annotations                                                                                        | `[]`                                                    |
| `persistence.enabled`            | Enable persistence using PVC                                                                               | `true`                                                  |
| `persistence.storageClass`       | PVC Storage Class for JasperReports volume                                                                 | `nil` (uses alpha storage annotation)                   |
| `persistence.accessMode`         | PVC Access Mode for JasperReports volume                                                                   | `ReadWriteOnce`                                         |
| `persistence.size`               | PVC Storage Request for JasperReports volume                                                               | `8Gi`                                                   |
| `resources`                      | CPU/Memory resource requests/limits                                                                        | `{Memory: 512Mi, CPU: 300m}`                            |
| `podAffinityPreset`              | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                        | `""`                                                    |
| `podAntiAffinityPreset`          | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                   | `soft`                                                  |
| `nodeAffinityPreset.type`        | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                  | `""`                                                    |
| `nodeAffinityPreset.key`         | Node label key to match Ignored if `affinity` is set.                                                      | `""`                                                    |
| `nodeAffinityPreset.values`      | Node label values to match. Ignored if `affinity` is set.                                                  | `[]`                                                    |
| `affinity`                       | Affinity for pod assignment                                                                                | `{}` (evaluated as a template)                          |
| `nodeSelector`                   | Node labels for pod assignment                                                                             | `{}` (evaluated as a template)                          |
| `tolerations`                    | Tolerations for pod assignment                                                                             | `[]` (evaluated as a template)                          |


### Database parameters

| Parameter                                  | Description                                           | Default                                        |
|--------------------------------------------|-------------------------------------------------------|------------------------------------------------|
| `mariadb.enabled`                          | Whether to use the MariaDB chart                      | `true`                                         |
| `mariadb.architecture`                     | MariaDB architecture (`standalone` or `replication`)  | `standalone`                                   |
| `mariadb.auth.rootPassword`                | Password for the MariaDB `root` user                  | _random 10 character alphanumeric string_      |
| `mariadb.auth.database`                    | Database name to create                               | `bitnami_jasperreports`                        |
| `mariadb.auth.username`                    | Database user to create                               | `bn_jasperreports`                             |
| `mariadb.auth.password`                    | Password for the database                             | _random 10 character long alphanumeric string_ |
| `mariadb.primary.persistence.enabled`      | Enable database persistence using PVC                 | `true`                                         |
| `mariadb.primary.persistence.accessMode`   | Database Persistent Volume Access Modes               | `ReadWriteOnce`                                |
| `mariadb.primary.persistence.size`         | Database Persistent Volume Size                       | `8Gi`                                          |
| `mariadb.primary.persistence.existingClaim`| Enable persistence using an existing PVC              | `nil`                                          |
| `mariadb.primary.persistence.storageClass` | PVC Storage Class                                     | `nil` (uses alpha storage class annotation)    |
| `mariadb.primary.persistence.hostPath`     | Host mount path for MariaDB volume                    | `nil` (will not mount to a host path)          |
| `externalDatabase.user`                    | Existing username in the external db                  | `bn_jasperreports`                             |
| `externalDatabase.password`                | Password for the above username                       | `nil`                                          |
| `externalDatabase.database`                | Name of the existing database                         | `bitnami_jasperreports`                        |
| `externalDatabase.host`                    | Host of the existing database                         | `nil`                                          |
| `externalDatabase.port`                    | Port of the existing database                         | `3306`                                         |
| `externalDatabase.existingSecret`          | Name of the database existing Secret Object           | `nil`                                          |

The above parameters map to the env variables defined in [bitnami/jasperreports](http://github.com/bitnami/bitnami-docker-jasperreports). For more information please refer to the [bitnami/jasperreports](http://github.com/bitnami/bitnami-docker-jasperreports) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install my-release \
  --set jasperreportsUsername=admin,jasperreportsPassword=password,mariadb.mariadbRootPassword=secretpassword \
    bitnami/jasperreports
```

The above command sets the JasperReports administrator account username and password to `admin` and `password` respectively. Additionally, it sets the MariaDB `root` user password to `secretpassword`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install my-release -f values.yaml bitnami/jasperreports
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Setting Pod's affinity

This chart allows you to set your custom affinity using the `affinity` paremeter. Find more infomation about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

## Persistence

The [Bitnami JasperReports](https://github.com/bitnami/bitnami-docker-jasperreports) image stores the JasperReports data and configurations at the `/bitnami/jasperreports` path of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Parameters](#parameters) section to configure the PVC or to disable persistence.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami’s Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

## Upgrading

### To 9.0.0

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

To upgrade to `9.0.0`, it should be done reusing the PVCs used to hold both the MariaDB and JasperReports data on your previous release. To do so, follow the instructions below (the following example assumes that the release name is `jasperreports` and that a `rootUser.password` was defined for MariaDB in `values.yaml` when the chart was first installed):

> NOTE: Please, create a backup of your database before running any of those actions. The steps below would be only valid if your application (e.g. any plugins or custom code) is compatible with MariaDB 10.5.x

Obtain the credentials and the names of the PVCs used to hold both the MariaDB and JasperReports data on your current release:

```console
export JASPERREPORTS_PASSWORD=$(kubectl get secret --namespace default jasperreports -o jsonpath="{.data.jasperreports-password}" | base64 --decode)
export MARIADB_ROOT_PASSWORD=$(kubectl get secret --namespace default jasperreports-mariadb -o jsonpath="{.data.mariadb-root-password}" | base64 --decode)
export MARIADB_PASSWORD=$(kubectl get secret --namespace default jasperreports-mariadb -o jsonpath="{.data.mariadb-password}" | base64 --decode)
export MARIADB_PVC=$(kubectl get pvc -l app=mariadb,component=master,release=jasperreports -o jsonpath="{.items[0].metadata.name}")
```

Delete the JasperReports deployment and delete the MariaDB statefulset. Notice the option `--cascade=false` in the latter:

```console
  $ kubectl delete deployments.apps jasperreports

  $ kubectl delete statefulsets.apps jasperreports-mariadb --cascade=false
```

Now the upgrade works:

```console
$ helm upgrade jasperreports bitnami/jasperreports --set mariadb.primary.persistence.existingClaim=$MARIADB_PVC --set mariadb.auth.rootPassword=$MARIADB_ROOT_PASSWORD --set mariadb.auth.password=$MARIADB_PASSWORD --set jasperreportsPassword=$JASPERREPORTS_PASSWORD --set allowEmptyPasswords=false
```

You will have to delete the existing MariaDB pod and the new statefulset is going to create a new one

  ```console
  $ kubectl delete pod jasperreports-mariadb-0
  ```

Finally, you should see the lines below in MariaDB container logs:

```console
$ kubectl logs $(kubectl get pods -l app.kubernetes.io/instance=jasperreports,app.kubernetes.io/name=mariadb,app.kubernetes.io/component=primary -o jsonpath="{.items[0].metadata.name}")
...
mariadb 12:13:24.98 INFO  ==> Using persisted data
mariadb 12:13:25.01 INFO  ==> Running mysql_upgrade
...
```

### to 8.0.0

JasperReports 7.5.0 includes some new configuration options that are required to be added if you upgrade from previous versions. Please check the [official community guide](https://community.jaspersoft.com/documentation/tibco-jasperreports-server-upgrade-guide/v750/upgrading-72-75) to upgrade your previous JasperReports installation.

### 7.0.0

Helm performs a lookup for the object based on its group (apps), version (v1), and kind (Deployment). Also known as its GroupVersionKind, or GVK. Changing the GVK is considered a compatibility breaker from Kubernetes' point of view, so you cannot "upgrade" those objects to the new GVK in-place. Earlier versions of Helm 3 did not perform the lookup correctly which has since been fixed to match the spec.

In https://github.com/helm/charts/pull/17298 the `apiVersion` of the deployment resources was updated to `apps/v1` in tune with the api's deprecated, resulting in compatibility breakage.

This major version signifies this change.

### 3.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 3.0.0. The following example assumes that the release name is jasperreports:

```console
$ kubectl patch deployment jasperreports-jasperreports --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
$ kubectl delete statefulset jasperreports-mariadb --cascade=false
