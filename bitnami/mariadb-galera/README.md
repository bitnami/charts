# MariaDB Galera

[MariaDB Galera](https://mariadb.com/kb/en/library/what-is-mariadb-galera-cluster/) is a multi-master database cluster solution for synchronous replication and high availability.

## TL;DR;

```bash
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/mariadb-galera
```

## Introduction

This chart bootstraps a [MariaDB Galera](https://github.com/bitnami/bitnami-docker-mariadb-galera) cluster on [Kubernetes](http://kubernetes.io) using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This chart has been tested to work with fluentd and Prometheus on top of [BKPR](https://kubeprod.io/).

## Prerequisites

- Kubernetes 1.10+
- PV provisioner support in the underlying infrastructure

## Installing the Chart

Add the `bitnami` charts repo to Helm:

```bash
$ helm repo add bitnami https://charts.bitnami.com/bitnami
```

To install the chart with the release name `my-release`:

```bash
$ helm install my-release bitnami/mariadb-galera
```

The command deploys MariaDB Galera on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

For a graceful termination, set the replica count of the Pods in the `mariadb-galera` StatefulSet to `0`:

```bash
$ kubectl scale sts my-release-mariadb-galera --replicas=0
```

To uninstall/delete the `my-release` release:

```bash
$ helm delete --purge my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

The following table lists the configurable parameters of the MariaDB Galera chart and their default values.

|              Parameter               |                                                                         Description                                                                         |                              Default                              |
|--------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------|
| `global.imageRegistry`               | Global Docker image registry                                                                                                                                | `nil`                                                             |
| `global.imagePullSecrets`            | Global Docker registry secret names as an array                                                                                                             | `[]` (does not add image pull secrets to deployed pods)           |
| `global.storageClass`                | Global storage class for dynamic provisioning                                                                                                               | `nil`                                                             |
| `image.registry`                     | MariaDB Galera image registry                                                                                                                               | `docker.io`                                                       |
| `image.repository`                   | MariaDB Galera Image name                                                                                                                                   | `bitnami/mariadb-galera`                                          |
| `image.tag`                          | MariaDB Galera Image tag                                                                                                                                    | `{TAG_NAME}`                                                      |
| `image.pullPolicy`                   | MariaDB Galera image pull policy                                                                                                                            | `IfNotPresent`                                                    |
| `image.pullSecrets`                  | Specify docker-registry secret names as an array                                                                                                            | `[]` (does not add image pull secrets to deployed pods)           |
| `image.debug`                        | Specify if debug logs should be enabled                                                                                                                     | `false`                                                           |
| `nameOverride`                       | String to partially override mariadb-galera.fullname template with a string (will prepend the release name)                                                 | `nil`                                                             |
| `fullnameOverride`                   | String to fully override mariadb-galera.fullname template with a string                                                                                     | `nil`                                                             |
| `schedulerName`                      | Name of the k8s scheduler (other than default)                                                                                                              | `nil`                                                             |
| `service.type`                       | Kubernetes service type                                                                                                                                     | `ClusterIP`                                                       |
| `service.port`                       | MariaDB service port                                                                                                                                        | `3306`                                                            |
| `service.clusterIP`                  | Specific cluster IP when service type is cluster IP. Use `None` for headless service                                                                        | `nil`                                                             |
| `service.nodePort`                   | Kubernetes Service nodePort                                                                                                                                 | `nil`                                                             |
| `service.loadBalancerIP`             | `loadBalancerIP` if service type is `LoadBalancer`                                                                                                          | `nil`                                                             |
| `service.loadBalancerSourceRanges`   | Address that are allowed when svc is `LoadBalancer`                                                                                                         | `[]`                                                              |
| `service.annotations`                | Additional annotations for MariaDB Galera service                                                                                                           | `{}`                                                              |
| `clusterDomain`                      | Kubernetes DNS Domain name to use                                                                                                                           | `cluster.local`                                                   |
| `serviceAccount.create`              | Specify whether a ServiceAccount should be created                                                                                                          | `false`                                                           |
| `serviceAccount.name`                | The name of the ServiceAccount to create                                                                                                                    | Generated using the mariadb-galera.fullname template              |
| `rbac.create`                        | Specify whether RBAC resources should be created and used                                                                                                   | `false`                                                           |
| `securityContext.enabled`            | Enable security context                                                                                                                                     | `true`                                                            |
| `securityContext.fsGroup`            | Group ID for the container filesystem                                                                                                                       | `1001`                                                            |
| `securityContext.runAsUser`          | User ID for the container                                                                                                                                   | `1001`                                                            |
| `existingSecret`                     | Use existing secret for password details (`rootUser.password`, `db.password`, `galera.mariabackup.password` will be ignored and picked up from this secret) | `nil`                                                             |
| `rootUser.password`                  | Password for the `root` user. Ignored if existing secret is provided.                                                                                       | _random 10 character alphanumeric string_                         |
| `rootUser.forcePassword`             | Force users to specify a password                                                                                                                           | `false`                                                           |
| `db.user`                            | Username of new user to create                                                                                                                              | `nil`                                                             |
| `db.password`                        | Password for the new user. Ignored if existing secret is provided.                                                                                          | _random 10 character alphanumeric string if `db.user` is defined_ |
| `db.name`                            | Name for new database to create                                                                                                                             | `my_database`                                                     |
| `db.forcePassword`                   | Force users to specify a password                                                                                                                           | `false`                                                           |
| `galera.name`                        | Galera cluster name                                                                                                                                         | `galera`                                                          |
| `galera.mariabackup.user`            | Galera mariabackup user                                                                                                                                     | `mariabackup`                                                     |
| `galera.mariabackup.password`        | Galera mariabackup password                                                                                                                                 | _random 10 character alphanumeric string_                         |
| `galera.mariabackup.forcePassword`   | Force users to specify a password                                                                                                                           | `false`                                                           |
| `ldap.enabled`                       | Enable LDAP support                                                                                                                                         | `false`                                                           |
| `ldap.uri`                           | LDAP URL beginning in the form `ldap[s]://<hostname>:<port>`                                                                                                | `nil`                                                             |
| `ldap.base`                          | LDAP base DN                                                                                                                                                | `nil`                                                             |
| `ldap.binddn`                        | LDAP bind DN                                                                                                                                                | `nil`                                                             |
| `ldap.bindpw`                        | LDAP bind password                                                                                                                                          | `nil`                                                             |
| `ldap.bslookup`                      | LDAP base lookup                                                                                                                                            | `nil`                                                             |
| `ldap.nss_initgroups_ignoreusers`    | LDAP ignored users                                                                                                                                          | `root,nslcd`                                                      |
| `ldap.scope`                         | LDAP search scope                                                                                                                                           | `nil`                                                             |
| `ldap.tls_reqcert`                   | LDAP TLS check on server certificates                                                                                                                       | `nil`                                                             |
| `mariadbConfiguration`               | Configuration for the MariaDB server                                                                                                                        | `_default values in the values.yaml file_`                        |
| `configurationConfigMap`             | ConfigMap with the MariaDB configuration files (Note: Overrides `mariadbConfiguration`). The value is evaluated as a template.                              | `nil`                                                             |
| `initdbScripts`                      | Dictionary of initdb scripts                                                                                                                                | `nil`                                                             |
| `initdbScriptsConfigMap`             | ConfigMap with the initdb scripts (Note: Overrides `initdbScripts`)                                                                                         | `nil`                                                             |
| `extraFlags`                         | MariaDB additional command line flags                                                                                                                       | `nil`                                                             |
| `annotations[].key`                  | key for the the annotation list item                                                                                                                        | `nil`                                                             |
| `annotations[].value`                | value for the the annotation list item                                                                                                                      | `nil`                                                             |
| `replicaCount`                       | Desired number of cluster nodes                                                                                                                             | `3`                                                               |
| `updateStrategy`                     | Statefulset update strategy policy                                                                                                                          | `RollingUpdate`                                                   |
| `affinity`                           | Map of node/pod affinities                                                                                                                                  | `{}` (The value is evaluated as a template)                       |
| `nodeSelector`                       | Node labels for pod assignment (this value is evaluated as a template)                                                                                      | `{}`                                                              |
| `tolerations`                        | List of node taints to tolerate (this value is evaluated as a template)                                                                                     | `[]`                                                              |
| `persistence.enabled`                | Enable persistence using PVC                                                                                                                                | `true`                                                            |
| `persistence.existingClaim`          | Provide an existing `PersistentVolumeClaim`                                                                                                                 | `nil`                                                             |
| `persistence.subPath`                | Subdirectory of the volume to mount                                                                                                                         | `nil`                                                             |
| `persistence.mountPath`              | Path to mount the volume at                                                                                                                                 | `/bitnami/mariadb`                                                |
| `persistence.annotations`            | Persistent Volume Claim annotations                                                                                                                         | `{}`                                                              |
| `persistence.storageClass`           | Persistent Volume Storage Class                                                                                                                             | `nil`                                                             |
| `persistence.accessModes`            | Persistent Volume Access Modes                                                                                                                              | `[ReadWriteOnce]`                                                 |
| `persistence.size`                   | Persistent Volume Size                                                                                                                                      | `8Gi`                                                             |
| `podLabels`                          | Additional pod labels                                                                                                                                       | `{}`                                                              |
| `priorityClassName`                  | Priority Class Name for Statefulset                                                                                                                         | ``                                                                |
| `extraInitContainers`                | Additional init containers (this value is evaluated as a template)                                                                                          | `[]`                                                              |
| `extraContainers`                    | Additional containers (this value is evaluated as a template)                                                                                               | `[]`                                                              |
| `extraVolumes`                       | Extra volumes                                                                                                                                               | `nil`                                                             |
| `extraVolumeMounts`                  | Mount extra volume(s)                                                                                                                                       | `nil`                                                             |
| `resources`                          | CPU/Memory resource requests/limits for node                                                                                                                | `{}`                                                              |
| `livenessProbe.enabled`              | Turn on and off liveness probe                                                                                                                              | `true`                                                            |
| `livenessProbe.initialDelaySeconds`  | Delay before liveness probe is initiated                                                                                                                    | `120`                                                             |
| `livenessProbe.periodSeconds`        | How often to perform the probe                                                                                                                              | `10`                                                              |
| `livenessProbe.timeoutSeconds`       | When the probe times out                                                                                                                                    | `1`                                                               |
| `livenessProbe.successThreshold`     | Minimum consecutive successes for the probe                                                                                                                 | `1`                                                               |
| `livenessProbe.failureThreshold`     | Minimum consecutive failures for the probe                                                                                                                  | `3`                                                               |
| `readinessProbe.enabled`             | Turn on and off readiness probe                                                                                                                             | `true`                                                            |
| `readinessProbe.initialDelaySeconds` | Delay before readiness probe is initiated                                                                                                                   | `30`                                                              |
| `readinessProbe.periodSeconds`       | How often to perform the probe                                                                                                                              | `10`                                                              |
| `readinessProbe.timeoutSeconds`      | When the probe times out                                                                                                                                    | `1`                                                               |
| `readinessProbe.successThreshold`    | Minimum consecutive successes for the probe                                                                                                                 | `1`                                                               |
| `readinessProbe.failureThreshold`    | Minimum consecutive failures for the probe                                                                                                                  | `3`                                                               |
| `podDisruptionBudget.create`         | If true, create a pod disruption budget for pods.                                                                                                           | `false`                                                           |
| `podDisruptionBudget.minAvailable`   | Minimum number / percentage of pods that should remain scheduled                                                                                            | `1`                                                               |
| `podDisruptionBudget.maxUnavailable` | Maximum number / percentage of pods that may be made unavailable                                                                                            | `nil`                                                             |
| `metrics.enabled`                    | Start a side-car prometheus exporter                                                                                                                        | `false`                                                           |
| `metrics.image.registry`             | MariaDB Prometheus exporter image registry                                                                                                                  | `docker.io`                                                       |
| `metrics.image.repository`           | MariaDB Prometheus exporter image name                                                                                                                      | `bitnami/mysqld-exporter`                                         |
| `metrics.image.tag`                  | MariaDB Prometheus exporter image tag                                                                                                                       | `{TAG_NAME}`                                                      |
| `metrics.image.pullPolicy`           | MariaDB Prometheus exporter image pull policy                                                                                                               | `IfNotPresent`                                                    |
| `metrics.resources`                  | Prometheus exporter resource requests/limits                                                                                                                | `{}`                                                              |
| `metrics.service.annotations`        | Prometheus exporter svc annotations                                                                                                                         | `{prometheus.io/scrape: "true", prometheus.io/port: "9104"}`      |
| `metrics.serviceMonitor.enabled`     | if `true`, creates a Prometheus Operator ServiceMonitor (also requires `metrics.enabled` to be `true`)                                                      | `false`                                                           |
| `metrics.serviceMonitor.namespace`   | Optional namespace which Prometheus is running in                                                                                                           | `nil`                                                             |
| `metrics.serviceMonitor.interval`    | How frequently to scrape metrics (use by default, falling back to Prometheus' default)                                                                      | `nil`                                                             |
| `metrics.serviceMonitor.selector`    | Default to kube-prometheus install (CoreOS recommended), but should be set according to Prometheus install                                                  | `{prometheus: "kube-prometheus"}`                                 |

The above parameters map to the env variables defined in [bitnami/mariadb-galera](http://github.com/bitnami/bitnami-docker-mariadb-galera). For more information please refer to the [bitnami/mariadb-galera](http://github.com/bitnami/bitnami-docker-mariadb-galera) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install my-release \
  --set rootUser.password=secretpassword,
  --set db.user=app_database \
    bitnami/mariadb-galera
```

The above command sets the MariaDB `root` account password to `secretpassword`. Additionally it creates a database named `my_database`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install my-release -f values.yaml bitnami/mariadb-galera
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Passing extra command-line flags to mysqld startup

While the chart allows you to specify the server configuration using the `.mariadbConfiguration` chart parameter, some options for the MariaDB server can only be specified via command line flags. For such cases, the chart exposes the `.extraFlags` parameter.

For example, if you want to enable the PAM cleartext plugin, specify the command line parameter while deploying the chart like so:

```bash
$ helm install my-release \
  --set extraFlags="--pam-use-cleartext-plugin=ON" \
  bitnami/mariadb-galera
```

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Production configuration

This chart includes a `values-production.yaml` file where you can find some parameters oriented to production configuration in comparison to the regular `values.yaml`. You can use this file instead of the default one.

- Force users to specify a password:

```diff
- rootUser.forcePassword: false
+ rootUser.forcePassword: true
- db.forcePassword: false
+ db.forcePassword: true
- galera.mariabackup.forcePassword: false
+ galera.mariabackup..forcePassword: true
```

- Start a side-car prometheus exporter:

```diff
- metrics.enabled: false
+ metrics.enabled: true
```

### LDAP

LDAP support can be enabled in the chart by specifying the `ldap.` parameters while creating a release. The following parameters should be configured to properly enable the LDAP support in the chart.

- `ldap.enabled`: Enable LDAP support. Defaults to `false`.
- `ldap.uri`: LDAP URL beginning in the form `ldap[s]://<hostname>:<port>`. No defaults.
- `ldap.base`: LDAP base DN. No defaults.
- `ldap.binddn`: LDAP bind DN. No defaults.
- `ldap.bindpw`: LDAP bind password. No defaults.
- `ldap.bslookup`: LDAP base lookup. No defaults.
- `ldap.nss_initgroups_ignoreusers`: LDAP ignored users. `root,nslcd`.
- `ldap.scope`: LDAP search scope. No defaults.
- `ldap.tls_reqcert`: LDAP TLS check on server certificates. No defaults.

For example:

```console
ldap.enabled="true"
ldap.uri="ldap://my_ldap_server"
ldap.base="dc=example,dc=org"
ldap.binddn="cn=admin,dc=example,dc=org"
ldap.bindpw="admin"
ldap.bslookup="ou=group-ok,dc=example,dc=org"
ldap.nss_initgroups_ignoreusers="root,nslcd"
ldap.scope="sub"
ldap.tls_reqcert="demand"
```

Next, login to the MariaDB server using the `mysql` client and add the PAM authenticated LDAP users.

For example,

```mysql
CREATE USER 'bitnami'@'localhost' IDENTIFIED VIA pam USING 'mariadb';
```

With the above example, when the `bitnami` user attempts to login to the MariaDB server, he/she will be authenticated against the LDAP server.

### Initialize a fresh instance

The [Bitnami MariaDB Galera](https://github.com/bitnami/bitnami-docker-mariadb-galera) image allows you to use your custom scripts to initialize a fresh instance. In order to execute the scripts, they must be located inside the chart folder `files/docker-entrypoint-initdb.d` so they can be consumed as a ConfigMap.

Alternatively, you can specify custom scripts using the `initdbScripts` parameter as dict.

In addition to these options, you can also set an external ConfigMap with all the initialization scripts. This is done by setting the `initdbScriptsConfigMap` parameter. Note that this will override the two previous options.

The allowed extensions are `.sh`, `.sql` and `.sql.gz`.

## Extra Init Containers

The feature allows for specifying a template string for a initContainer in the pod. Usecases include situations when you need some pre-run setup. For example, in IKS (IBM Cloud Kubernetes Service), non-root users do not have write permission on the volume mount path for NFS-powered file storage. So, you could use a initcontainer to `chown` the mount. See a example below, where we add an initContainer on the pod that reports to an external resource that the db is going to starting.
`values.yaml`
```yaml
extraInitContainers:
- name: initcontainer
  image: bitnami/minideb:buster
  command: ["/bin/sh", "-c"]
  args:
    - install_packages curl && curl http://api-service.local/db/starting;
```

## Extra Containers

The feature allows for specifying additional containers in the pod. Usecases include situations when you need to run some sidecar containers. For example, you can observe if mysql in pod is running and report to some service discovery software like eureka. Example:
`values.yaml`
```yaml
extraContainers:
- name: '{{ .Chart.Name }}-eureka-sidecar'
  image: 'image:tag'
  env:
  - name: SERVICE_NAME
    value: '{{ template "mariadb-galera.fullname" . }}'
  - name: EUREKA_APP_NAME
    value: '{{ template "mariadb-galera.name" . }}'
  - name: MARIADB_USER
    value: '{{ .Values.db.user }}'
  - name: MARIADB_PASSWORD
    valueFrom:
      secretKeyRef:
        name: '{{ template "mariadb-galera.fullname" . }}'
        key: mariadb-password
  resources:
    limits:
      cpu: 100m
      memory: 20Mi
    requests:
      cpu: 50m
      memory: 10Mi
```

## Persistence

The [Bitnami MariaDB Galera](https://github.com/bitnami/bitnami-docker-mariadb-galera) image stores the MariaDB data and configurations at the `/bitnami/mariadb` path of the container.

The chart mounts a [Persistent Volume](kubernetes.io/docs/user-guide/persistent-volumes/) volume at this location. The volume is created using dynamic volume provisioning, by default. An existing PersistentVolumeClaim can be defined.

## Upgrading

It's necessary to specify the existing passwords while performing a upgrade to ensure the secrets are not updated with invalid randomly generated passwords. Remember to specify the existing values of the `rootUser.password`, `db.password` and `galera.mariabackup.password` parameters when upgrading the chart:

```bash
$ helm upgrade my-release bitnami/mariadb-galera \
    --set rootUser.password=[ROOT_PASSWORD] \
    --set db.password=[MARIADB_PASSWORD] \
    --set galera.mariabackup.password=[GALERA_MARIABACKUP_PASSWORD]
```

| Note: you need to substitute the placeholders _[ROOT_PASSWORD]_, _[MARIADB_PASSWORD]_ and _[MARIABACKUP_PASSWORD]_ with the values obtained from instructions in the installation notes.

### To 1.0.0

The [Bitnami MariaDB Galera](https://github.com/bitnami/bitnami-docker-mariadb-galera) image was migrated to a "non-root" user approach. Previously the container ran as the `root` user and the MySQL daemon was started as the `mysql` user. From now on, both the container and the MySQL daemon run as user `1001`. You can revert this behavior by setting the parameters `securityContext.runAsUser`, and `securityContext.fsGroup` to `0`.

Consequences:

- Backwards compatibility is not guaranteed.
- Environment variables related to LDAP configuration were renamed removing the `MARIADB_` prefix. For instance, to indicate the LDAP URI to use, you must set `LDAP_URI` instead of `MARIADB_LDAP_URI`

To upgrade to `1.0.0`, install a new release of the MariaDB Galera chart, and migrate your data by creating a backup of the database, and restoring it on the new release. In the link below you can find a guide that explain the whole process:

- [Create And Restore MySQL/MariaDB Backups](https://docs.bitnami.com/general/infrastructure/mariadb/administration/backup-restore-mysql-mariadb/)
