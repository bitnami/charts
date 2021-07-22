# EJBCA

[EJBCA](https://www.ejbca.org/) is a free software public key infrastructure certificate authority software package.

## TL;DR

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/ejbca
```

## Introduction

This chart bootstraps a [EJBCA](https://www.ejbca.org/) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages [Bitnami MariaDB](https://github.com/bitnami/charts/tree/master/bitnami/mariadb) as the required databases for the EJBCA application.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.12+
- Helm 3.1.0
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install my-release bitnami/ejbca
```

The command deploys EJBCA on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

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

| Name                     | Description                                                                             | Value   |
| ------------------------ | --------------------------------------------------------------------------------------- | ------- |
| `kubeVersion`            | Force target Kubernetes version (using Helm capabilities if not set)                    | `""`    |
| `nameOverride`           | String to partially override ebjca.fullname template (will maintain the release name)   | `""`    |
| `fullnameOverride`       | String to fully override ebjca.fullname template                                        | `""`    |
| `commonLabels`           | Add labels to all the deployed resources                                                | `{}`    |
| `commonAnnotations`      | Annotations to be added to all deployed resources                                       | `{}`    |
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden) | `false` |
| `diagnosticMode.command` | Command to override all containers in the deployment                                    | `[]`    |
| `diagnosticMode.args`    | Args to override all containers in the deployment                                       | `[]`    |


### EJBCA parameters

| Name                                 | Description                                                                               | Value                     |
| ------------------------------------ | ----------------------------------------------------------------------------------------- | ------------------------- |
| `image.registry`                     | EJBCA image registry                                                                      | `docker.io`               |
| `image.repository`                   | EJBCA image name                                                                          | `bitnami/ejbca`           |
| `image.tag`                          | EJBCA image tag                                                                           | `6.15.2-6-debian-10-r294` |
| `image.pullPolicy`                   | EJBCA image pull policy                                                                   | `IfNotPresent`            |
| `image.pullSecrets`                  | Specify docker-registry secret names as an array                                          | `[]`                      |
| `image.debug`                        | Enable image debug mode                                                                   | `false`                   |
| `replicaCount`                       | Number of EJBCA replicas to deploy                                                        | `1`                       |
| `extraVolumeMounts`                  | Additional volume mounts (used along with `extraVolumes`)                                 | `[]`                      |
| `extraVolumes`                       | Array of extra volumes to be added deployment. Requires setting `extraVolumeMounts`       | `[]`                      |
| `podAnnotations`                     | Additional pod annotations                                                                | `{}`                      |
| `podLabels`                          | Additional pod labels                                                                     | `{}`                      |
| `podSecurityContext.enabled`         | Enable security context for EJBCA container                                               | `true`                    |
| `podSecurityContext.fsGroup`         | Group ID for the volumes of the pod                                                       | `1001`                    |
| `podAffinityPreset`                  | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`       | `""`                      |
| `podAntiAffinityPreset`              | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`  | `soft`                    |
| `nodeAffinityPreset.type`            | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard` | `""`                      |
| `nodeAffinityPreset.key`             | Node label key to match Ignored if `affinity` is set.                                     | `""`                      |
| `nodeAffinityPreset.values`          | Node label values to match. Ignored if `affinity` is set.                                 | `[]`                      |
| `affinity`                           | Affinity for pod assignment                                                               | `{}`                      |
| `nodeSelector`                       | Node labels for pod assignment                                                            | `{}`                      |
| `tolerations`                        | Tolerations for pod assignment                                                            | `[]`                      |
| `persistence.enabled`                | Whether to enable persistence based on Persistent Volume Claims                           | `true`                    |
| `persistence.accessMode`             | PVC Access Mode (RWO, ROX, RWX)                                                           | `ReadWriteOnce`           |
| `persistence.size`                   | Size of the PVC to request                                                                | `2Gi`                     |
| `persistence.storageClass`           | PVC Storage Class                                                                         | `""`                      |
| `persistence.existingClaim`          | Name of an existing PVC to reuse                                                          | `""`                      |
| `sidecars`                           | Attach additional sidecar containers to the pod                                           | `[]`                      |
| `initContainers`                     | Additional init containers to add to the pods                                             | `[]`                      |
| `hostAliases`                        | Add deployment host aliases                                                               | `[]`                      |
| `ejbcaAdminUsername`                 | EJBCA administrator username                                                              | `bitnami`                 |
| `ejbcaAdminPassword`                 | Password for the administrator account                                                    | `""`                      |
| `existingSecret`                     | Alternatively, you can provide the name of an existing secret containing                  | `""`                      |
| `ejbcaJavaOpts`                      | Options used to launch the WildFly server                                                 | `""`                      |
| `ejbcaCA.name`                       | Name of the CA EJBCA will instantiate by default                                          | `ManagementCA`            |
| `ejbcaCA.baseDN`                     | Base DomainName of the CA EJBCA will instantiate by default                               | `""`                      |
| `ejbcaKeystoreExistingSecret`        | Name of an existing Secret containing a Keystore object                                   | `""`                      |
| `extraEnv`                           | Additional container environment variables                                                | `[]`                      |
| `command`                            | Custom command to override image cmd                                                      | `[]`                      |
| `args`                               | Custom args for the custom command                                                        | `[]`                      |
| `resources.limits`                   | The resources limits for the container                                                    | `{}`                      |
| `resources.requests`                 | The requested resources for the container                                                 | `{}`                      |
| `containerSecurityContext.enabled`   | Enabled EJBCA containers' Security Context                                                | `true`                    |
| `containerSecurityContext.runAsUser` | Set EJBCA containers' Security Context runAsUser                                          | `1001`                    |
| `livenessProbe.enabled`              | Enable/disable livenessProbe                                                              | `true`                    |
| `livenessProbe.initialDelaySeconds`  | Delay before liveness probe is initiated                                                  | `500`                     |
| `livenessProbe.periodSeconds`        | How often to perform the probe                                                            | `10`                      |
| `livenessProbe.timeoutSeconds`       | When the probe times out                                                                  | `5`                       |
| `livenessProbe.failureThreshold`     | Minimum consecutive failures for the probe                                                | `6`                       |
| `livenessProbe.successThreshold`     | Minimum consecutive successes for the probe                                               | `1`                       |
| `readinessProbe.enabled`             | Enable/disable readinessProbe                                                             | `true`                    |
| `readinessProbe.initialDelaySeconds` | Delay before readiness probe is initiated                                                 | `500`                     |
| `readinessProbe.periodSeconds`       | How often to perform the probe                                                            | `10`                      |
| `readinessProbe.timeoutSeconds`      | When the probe times out                                                                  | `5`                       |
| `readinessProbe.failureThreshold`    | Minimum consecutive failures for the probe                                                | `6`                       |
| `readinessProbe.successThreshold`    | Minimum consecutive successes for the probe                                               | `1`                       |
| `customLivenessProbe`                | Custom liveness probe to execute (when the main one is disabled)                          | `{}`                      |
| `customReadinessProbe`               | Custom readiness probe to execute (when the main one is disabled)                         | `{}`                      |
| `containerPorts`                     | EJBCA Container ports to open                                                             | `{}`                      |


### Service parameters

| Name                               | Description                                                                   | Value          |
| ---------------------------------- | ----------------------------------------------------------------------------- | -------------- |
| `service.type`                     | Kubernetes Service type                                                       | `LoadBalancer` |
| `service.port`                     | Service HTTP port                                                             | `8080`         |
| `service.httpsPort`                | Service HTTPS port                                                            | `8443`         |
| `service.advertisedHttpsPort`      | Port used for the administration                                              | `443`          |
| `service.httpsTargetPort`          | Service Target HTTPS port                                                     | `https`        |
| `service.nodePorts`                | Node Ports to expose                                                          | `{}`           |
| `service.externalTrafficPolicy`    | Enable client source IP preservation                                          | `Cluster`      |
| `service.annotations`              | Service annotations                                                           | `{}`           |
| `service.loadBalancerSourceRanges` | Limits which cidr blocks can connect to service's load balancer               | `[]`           |
| `service.extraPorts`               | Extra ports to expose in the service (normally used with the `sidecar` value) | `[]`           |


### Ingress parameters

| Name                  | Description                                                                                   | Value                    |
| --------------------- | --------------------------------------------------------------------------------------------- | ------------------------ |
| `ingress.enabled`     | Enable ingress controller resource                                                            | `false`                  |
| `ingress.certManager` | Add annotations for cert-manager                                                              | `false`                  |
| `ingress.pathType`    | Ingress Path type                                                                             | `ImplementationSpecific` |
| `ingress.apiVersion`  | Override API Version (automatically detected if not set)                                      | `""`                     |
| `ingress.hostname`    | Default host for the ingress resource                                                         | `ejbca.local`            |
| `ingress.path`        | The Path to EJBCA. You may need to set this to '/*' in order to use this                      | `ImplementationSpecific` |
| `ingress.annotations` | Ingress annotations done as key:value pairs                                                   | `{}`                     |
| `ingress.tls`         | Enable TLS configuration for the hostname defined at ingress.hostname parameter               | `false`                  |
| `ingress.extraHosts`  | The list of additional hostnames to be covered with this ingress record.                      | `[]`                     |
| `ingress.extraPaths`  | Any additional arbitrary paths that may need to be added to the ingress under the main host.  | `[]`                     |
| `ingress.extraTls`    | The tls configuration for additional hostnames to be covered with this ingress record.        | `[]`                     |
| `ingress.secrets`     | If you're providing your own certificates, please use this to add the certificates as secrets | `[]`                     |


### Database parameters

| Name                                        | Description                                                                                | Value           |
| ------------------------------------------- | ------------------------------------------------------------------------------------------ | --------------- |
| `mariadb.enabled`                           | Whether to deploy a mariadb server to satisfy the applications database requirements.      | `true`          |
| `mariadb.architecture`                      | MariaDB architecture (`standalone` or `replication`)                                       | `standalone`    |
| `mariadb.auth.rootPassword`                 | Password for the MariaDB `root` user                                                       | `""`            |
| `mariadb.auth.database`                     | Database name to create                                                                    | `bitnami_ejbca` |
| `mariadb.auth.username`                     | Database user to create                                                                    | `bn_ejbca`      |
| `mariadb.auth.password`                     | Password for the database                                                                  | `""`            |
| `mariadb.primary.persistence.enabled`       | Enable database persistence using PVC                                                      | `true`          |
| `mariadb.primary.persistence.storageClass`  | MariaDB primary persistent volume storage Class                                            | `""`            |
| `mariadb.primary.persistence.accessMode`    | Persistent Volume access mode                                                              | `ReadWriteOnce` |
| `mariadb.primary.persistence.size`          | Database Persistent Volume Size                                                            | `8Gi`           |
| `mariadb.primary.persistence.hostPath`      | Set path in case you want to use local host path volumes (not recommended in production)   | `""`            |
| `mariadb.primary.persistence.existingClaim` | Name of an existing `PersistentVolumeClaim` for MariaDB primary replicas                   | `""`            |
| `externalDatabase.host`                     | Host of the external database                                                              | `localhost`     |
| `externalDatabase.user`                     | non-root Username for EJBCA Database                                                       | `bn_ejbca`      |
| `externalDatabase.password`                 | Password for the above username                                                            | `""`            |
| `externalDatabase.existingSecret`           | Name of an existing secret resource containing the DB password in a 'mariadb-password' key | `""`            |
| `externalDatabase.database`                 | Name of the existing database                                                              | `bitnami_ejbca` |
| `externalDatabase.port`                     | Database port number                                                                       | `3306`          |


The above parameters map to the env variables defined in [bitnami/ejbca](http://github.com/bitnami/bitnami-docker-ejbca). For more information please refer to the [bitnami/ejbca](http://github.com/bitnami/bitnami-docker-ejbca) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install my-release \
  --set ejbcaAdminUsername=admin,ejbcaAdminPassword=password,mariadb.auth.password=secretpassword \
    bitnami/discourse
```

The above command sets the EJBCA administrator account username and password to `admin` and `password` respectively. Additionally, it sets the MariaDB `bn_ejbca` user password to `secretpassword`.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install my-release -f values.yaml bitnami/ejbca
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Setting up replication

By default, this Chart only deploys a single pod running EJBCA. Should you want to increase the number of replicas, you may follow these simple steps to ensure everything works smoothly:

1. Create a conventional release with only one replica, that will be scaled later.
2. Wait for the release to complete and EJBCA to be running successfully. You may verify you have access to the main page in order to do this.
3. Perform an upgrade specifying the number of replicas and the credentials that were previously used. Set the parameters `replicaCount`, `ejbcaAdminPassword` and `mariadb.auth.password` accordingly.

For example, for a release using `secretPassword` and `dbPassword` to scale up to a total of `2` replicas, the aforementioned parameters should hold these values `replicaCount=2`, `ejbcaAdminPassword=secretPassword`, `mariadb.auth.password=dbPassword`.

> **Tip**: You can modify the file [values.yaml](values.yaml)

### Sidecars

If you have a need for additional containers to run within the same pod as EJBCA (e.g. metrics or logging exporter), you can do so via the `sidecars` config parameter. Simply define your container according to the Kubernetes container spec.

```yaml
sidecars:
- name: your-image-name
  image: your-image
  imagePullPolicy: Always
  ports:
  - name: portname
   containerPort: 1234
```

If these sidecars export extra ports, you can add extra port definitions using the `service.extraPorts` value:

```yaml
service:
...
  extraPorts:
  - name: extraPort
    port: 11311
    targetPort: 11311
```

### Using an external database

Sometimes you may want to have EJBCA connect to an external database rather than installing one inside your cluster, e.g. to use a managed database service, or use run a single database server for all your applications. To do this, the chart allows you to specify credentials for an external database under the [`externalDatabase` parameter](#parameters). You should also disable the MariaDB installation with the `mariadb.enabled` option. For example with the following parameters:

```console
mariadb.enabled=false
externalDatabase.host=myexternalhost
externalDatabase.user=myuser
externalDatabase.password=mypassword
externalDatabase.database=mydatabase
externalDatabase.port=3306
```

Note also that if you disable MariaDB per above you MUST supply values for the `externalDatabase` connection.

### Setting Pod's affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

## Persistence

The [Bitnami EJBCA](https://github.com/bitnami/bitnami-docker-discourse) image stores the EJBCA data and configurations at the `/bitnami` path of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Parameters](#parameters) section to configure the PVC or to disable persistence.

### Image

The `image` parameter allows specifying which image will be pulled for the chart.

#### Private registry

If you configure the `image` value to one in a private registry, you will need to [specify an image pull secret](https://kubernetes.io/docs/concepts/containers/images/#specifying-imagepullsecrets-on-a-pod).

1. Manually create image pull secret(s) in the namespace. See [this YAML example reference](https://kubernetes.io/docs/concepts/containers/images/#creating-a-secret-with-a-docker-config). Consult your image registry's documentation about getting the appropriate secret.
2. Note that the `imagePullSecrets` configuration value cannot currently be passed to helm using the `--set` parameter, so you must supply these using a `values.yaml` file, such as:

```yaml
imagePullSecrets:
  - name: SECRET_NAME
```

3. Install the chart

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami’s Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 2.0.0

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

### To 1.0.0

MariaDB dependency version was bumped to a new major version that introduces several incompatilibites. Therefore, backwards compatibility is not guaranteed unless an external database is used. Check [MariaDB Upgrading Notes](https://github.com/bitnami/charts/tree/master/bitnami/mariadb#to-800) for more information.

To upgrade to `1.0.0`, you have two alternatives:

- Install a new EJBCA chart, and migrate your EJBCA following [the official documentation](https://doc.primekey.com/ejbca/ejbca-operations/ejbca-operations-guide/ca-operations-guide/ejbca-maintenance/backup-and-restore).
- Reuse the PVC used to hold the MariaDB data on your previous release. To do so, follow the instructions below (the following example assumes that the release name is `ejbca`):

> NOTE: Please, create a backup of your database before running any of those actions. The steps below would be only valid if your application (e.g. any plugins or custom code) is compatible with MariaDB 10.5.x

Obtain the credentials and the name of the PVC used to hold the MariaDB data on your current release:

```console
export EJBCA_ADMIN_PASSWORD=$(kubectl get secret --namespace default ejbca -o jsonpath="{.data.ejbca-admin-password}" | base64 --decode)
export MARIADB_ROOT_PASSWORD=$(kubectl get secret --namespace default ejbca-mariadb -o jsonpath="{.data.mariadb-root-password}" | base64 --decode)
export MARIADB_PASSWORD=$(kubectl get secret --namespace default ejbca-mariadb -o jsonpath="{.data.mariadb-password}" | base64 --decode)
export MARIADB_PVC=$(kubectl get pvc -l app=mariadb,component=master,release=ejbca -o jsonpath="{.items[0].metadata.name}")
```

Upgrade your release (maintaining the version) disabling MariaDB and scaling EJBCA replicas to 0:

```console
$ helm upgrade ejbca bitnami/ejbca --set ejbcaAdminPassword=$EJBCA_ADMIN_PASSWORD --set replicaCount=0 --set mariadb.enabled=false --version 0.4.0
```

Finally, upgrade you release to 1.0.0 reusing the existing PVC, and enabling back MariaDB:

```console
$ helm upgrade ejbca bitnami/ejbca --set mariadb.primary.persistence.existingClaim=$MARIADB_PVC --set mariadb.auth.rootPassword=$MARIADB_ROOT_PASSWORD --set mariadb.auth.password=$MARIADB_PASSWORD --set ejbcaAdminPassword=$EJBCA_ADMIN_PASSWORD
```

You should see the lines below in MariaDB container logs:

```console
$ kubectl logs $(kubectl get pods -l app.kubernetes.io/instance=ejbca,app.kubernetes.io/name=mariadb,app.kubernetes.io/component=primary -o jsonpath="{.items[0].metadata.name}")
...
mariadb 12:13:24.98 INFO  ==> Using persisted data
mariadb 12:13:25.01 INFO  ==> Running mysql_upgrade
...
```
