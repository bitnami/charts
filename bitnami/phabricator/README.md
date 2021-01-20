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

### Phabricator parameters

| Parameter                        | Description                                                                                              | Default                                                      |
|----------------------------------|----------------------------------------------------------------------------------------------------------|--------------------------------------------------------------|
| `image.registry`                 | Phabricator image registry                                                                               | `docker.io`                                                  |
| `image.repository`               | Phabricator image name                                                                                   | `bitnami/phabricator`                                        |
| `image.tag`                      | Phabricator image tag                                                                                    | `{TAG_NAME}`                                                 |
| `image.pullPolicy`               | Image pull policy                                                                                        | `IfNotPresent`                                               |
| `image.pullSecrets`              | Specify docker-registry secret names as an array                                                         | `[]` (does not add image pull secrets to deployed pods)      |
| `phabricatorHost`                | Phabricator host to create application URLs                                                              | `nil`                                                        |
| `phabricatorAlternateFileDomain` | Phabricator alternate domain to upload files                                                             | `nil`                                                        |
| `phabricatorUsername`            | User of the application                                                                                  | `user`                                                       |
| `phabricatorPassword`            | Application password                                                                                     | _random 10 character long alphanumeric string_               |
| `phabricatorEmail`               | Admin email                                                                                              | `user@example.com`                                           |
| `phabricatorFirstName`           | First name                                                                                               | `First Name`                                                 |
| `phabricatorLastName`            | Last name                                                                                                | `Last Name`                                                  |
| `phabricatorGitSSH`              | Enabled SSH to access Git repositories                                                                   | `false`                                                      |
| `smtpHost`                       | SMTP host                                                                                                | `nil`                                                        |
| `smtpPort`                       | SMTP port                                                                                                | `nil`                                                        |
| `smtpUser`                       | SMTP user                                                                                                | `nil`                                                        |
| `smtpPassword`                   | SMTP password                                                                                            | `nil`                                                        |
| `smtpProtocol`                   | SMTP protocol [`ssl`, `tls`]                                                                             | `nil`                                                        |
| `podAffinityPreset`              | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                      | `""`                                                         |
| `podAntiAffinityPreset`          | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                 | `soft`                                                       |
| `nodeAffinityPreset.type`        | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                | `""`                                                         |
| `nodeAffinityPreset.key`         | Node label key to match. Ignored if `affinity` is set.                                                   | `""`                                                         |
| `nodeAffinityPreset.values`      | Node label values to match. Ignored if `affinity` is set.                                                | `[]`                                                         |
| `affinity`                       | Affinity for pod assignment                                                                              | `{}` (evaluated as a template)                               |
| `nodeSelector`                   | Node labels for pod assignment                                                                           | `{}` (evaluated as a template)                               |
| `tolerations`                    | Tolerations for pod assignment                                                                           | `[]` (evaluated as a template)                               |
| `podAnnotations`                 | Pod annotations                                                                                          | `{}`                                                         |
| `persistence.enabled`            | Enable persistence using PVC                                                                             | `true`                                                       |
| `persistence.storageClass`       | PVC Storage Class for Phabricator volume                                                                 | `nil` (uses alpha storage class annotation)                  |
| `persistence.accessMode`         | PVC Access Mode for Phabricator volume                                                                   | `ReadWriteOnce`                                              |
| `persistence.size`               | PVC Storage Request for Phabricator volume                                                               | `8Gi`                                                        |
| `resources`                      | CPU/Memory resource requests/limits                                                                      | Memory: `512Mi`, CPU: `300m`                                 |

The above parameters map to the env variables defined in [bitnami/phabricator](http://github.com/bitnami/bitnami-docker-phabricator). For more information please refer to the [bitnami/phabricator](http://github.com/bitnami/bitnami-docker-phabricator) image documentation.

### Database parameters

| Parameter                                  | Description                                           | Default                                        |
|--------------------------------------------|-------------------------------------------------------|------------------------------------------------|
| `mariadb.enabled`                          | Whether to use the MariaDB chart                      | `true`                                         |
| `mariadb.architecture`                     | MariaDB architecture (`standalone` or `replication`)  | `standalone`                                   |
| `mariadb.auth.rootPassword`                | Password for the MariaDB `root` user                  | _random 10 character alphanumeric string_      |
| `mariadb.primary.extraFlags`               | Additional command line flags                         | `true`                                         |
| `mariadb.primary.persistence.enabled`      | Enable database persistence using PVC                 | `true`                                         |
| `mariadb.primary.persistence.accessMode`   | Database Persistent Volume Access Modes               | `ReadWriteOnce`                                |
| `mariadb.primary.persistence.size`         | Database Persistent Volume Size                       | `8Gi`                                          |
| `mariadb.primary.persistence.existingClaim`| Enable persistence using an existing PVC              | `nil`                                          |
| `mariadb.primary.persistence.storageClass` | PVC Storage Class                                     | `nil` (uses alpha storage class annotation)    |
| `mariadb.primary.persistence.hostPath`     | Host mount path for MariaDB volume                    | `nil` (will not mount to a host path)          |
| `externalDatabase.user`                    | Existing username in the external db                  | `bn_phabricator`                               |
| `externalDatabase.password`                | Password for the above username                       | `nil`                                          |
| `externalDatabase.database`                | Name of the existing database                         | `bitnami_phabricator`                          |
| `externalDatabase.host`                    | Host of the existing database                         | `nil`                                          |
| `externalDatabase.port`                    | Port of the existing database                         | `3306`                                         |
| `externalDatabase.existingSecret`          | Name of the database existing Secret Object           | `nil`                                          |

### Traffic Exposure Parameters

| Parameter                        | Description                                                                                              | Default                                                      |
|----------------------------------|----------------------------------------------------------------------------------------------------------|--------------------------------------------------------------|
| `service.type`                   | Kubernetes Service type                                                                                  | `LoadBalancer`                                               |
| `service.port`                   | Service HTTP port                                                                                        | `80`                                                         |
| `service.httpsPort`              | Service HTTP port                                                                                        | `443`                                                        |
| `service.sshPort`                | Service SSH port                                                                                         | `22`                                                         |
| `service.loadBalancerIP`         | `loadBalancerIP` for the Phabricator Service                                                             | `nil`                                                        |
| `service.externalTrafficPolicy`  | Enable client source IP preservation                                                                     | `Cluster`                                                    |
| `service.nodePorts.http`         | Kubernetes http node port                                                                                | `""`                                                         |
| `service.nodePorts.https`        | Kubernetes https node port                                                                               | `""`                                                         |
| `service.nodePorts.ssh`          | Kubernetes ssh node port                                                                                 | `""`                                                         |
| `service.annotations`            | Service annotations                                                                                      | `[]`                                                         |
| `ingress.enabled`                | Enable ingress rules resource                                                                            | `false`                                                      |
| `ingress.certManager`            | Add annotations for cert-manager                                                                         | `false`                                                      |
| `ingress.annotations`            | Ingress annotations                                                                                      | `[]`                                                         |
| `ingress.hosts[0].name`          | Hostname to your Phabricator installation                                                                | `phabricator.local`                                          |
| `ingress.hosts[0].path`          | Path within the url structure                                                                            | `/`                                                          |
| `ingress.hosts[0].tls`           | Utilize TLS backend in ingress                                                                           | `false`                                                      |
| `ingress.hosts[0].tlsHosts`      | Array of TLS hosts for ingress record (defaults to `ingress.hosts[0].name` if `nil`)                     | `nil`                                                        |
| `ingress.hosts[0].tlsSecret`     | TLS Secret (certificates)                                                                                | `phabricator.local-tls-secret`                               |
| `ingress.secrets[0].name`        | TLS Secret Name                                                                                          | `nil`                                                        |
| `ingress.secrets[0].certificate` | TLS Secret Certificate                                                                                   | `nil`                                                        |
| `ingress.secrets[0].key`         | TLS Secret Key                                                                                           | `nil`                                                        |

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
| `metrics.resources`              | Exporter resource requests/limit                                                                         | {}                                                           |

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
  --set phabricatorUsername=admin,phabricatorPassword=password,mariadb.mariadbRootPassword=secretpassword \
  bitnami/phabricator
```

The above command sets the Phabricator administrator account username and password to `admin` and `password` respectively. Additionally, it sets the MariaDB `root` user password to `secretpassword`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install my-release -f values.yaml bitnami/phabricator
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Ingress with Reverse Proxy and cert-manager

You can define a custom ingress rule for Phabricator with TLS certificates auto-generated by cert-manager using the following parameters:

```console
ingress.enabled=true
ingress.certManager=true
ingress.hosts[0].name=phabricator.example.com
ingress.tls[0].hosts[0]=phabricator.example.com
phabricatorHost=example.com
```

Everything looks great but requests over https will cause asset requests to fail. Assuming you want to use HTTPS/TLS you will need to set the base-uri to an https schema.

### Using an external database

Sometimes you may want to have Phabricator connect to an external database rather than installing one inside your cluster, e.g. to use a managed database service, or use run a single database server for all your applications. To do this, the chart allows you to specify credentials for an external database under the [`externalDatabase` parameter](#parameters). You should also disable the MariaDB installation with the `mariadb.enabled` option. For example with the following parameters:

```console
mariadb.enabled=false
externalDatabase.host=myexternalhost
externalDatabase.rootUser=myuser
externalDatabase.rootPassword=mypassword
externalDatabase.database=mydatabase
externalDatabase.port=3306
```

Note also if you disable MariaDB per above you MUST supply values for the `externalDatabase` connection.

## Persistence

The [Bitnami Phabricator](https://github.com/bitnami/bitnami-docker-phabricator) image stores the Phabricator data and configurations at the `/bitnami/phabricator` path of the container.

Persistent Volume Claims are used to keep the data across deployments. There is a [known issue](https://github.com/kubernetes/kubernetes/issues/39178) in Kubernetes Clusters with EBS in different availability zones. Ensure your cluster is configured properly to create Volumes in the same availability zone where the nodes are running. Kuberentes 1.12 solved this issue with the [Volume Binding Mode](https://kubernetes.io/docs/concepts/storage/storage-classes/#volume-binding-mode).

See the [Parameters](#parameters) section to configure the PVC or to disable persistence.

### Setting Pod's affinity

This chart allows you to set your custom affinity using the `affinity` paremeter. Find more infomation about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami’s Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

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
