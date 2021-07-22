# MariaDB Galera

[MariaDB Galera](https://mariadb.com/kb/en/library/what-is-mariadb-galera-cluster/) is a multi-master database cluster solution for synchronous replication and high availability.

## TL;DR

```bash
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/mariadb-galera
```

## Introduction

This chart bootstraps a [MariaDB Galera](https://github.com/bitnami/bitnami-docker-mariadb-galera) cluster on [Kubernetes](http://kubernetes.io) using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This chart has been tested to work with fluentd and Prometheus on top of [BKPR](https://kubeprod.io/).

## Prerequisites

- Kubernetes 1.10+
- Helm 3.1.0
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

### Global parameters

| Name                      | Description                                     | Value |
| ------------------------- | ----------------------------------------------- | ----- |
| `global.imageRegistry`    | Global Docker image registry                    | `nil` |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]`  |
| `global.storageClass`     | Global StorageClass for Persistent Volume(s)    | `nil` |


### Common parameters

| Name                     | Description                                                                                               | Value           |
| ------------------------ | --------------------------------------------------------------------------------------------------------- | --------------- |
| `nameOverride`           | String to partially override common.names.fullname template with a string (will prepend the release name) | `nil`           |
| `fullnameOverride`       | String to fully override common.names.fullname template with a string                                     | `nil`           |
| `schedulerName`          | Name of the Kubernetes scheduler (other than default)                                                     | `nil`           |
| `clusterDomain`          | Kubernetes DNS Domain name to use                                                                         | `cluster.local` |
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden)                   | `false`         |
| `diagnosticMode.command` | Command to override all containers in the deployment                                                      | `[]`            |
| `diagnosticMode.args`    | Args to override all containers in the deployment                                                         | `[]`            |


### MariaDB Galera parameters

| Name                                       | Description                                                                                                                                                                                   | Value                     |
| ------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------- |
| `image.registry`                           | MariaDB Galera image registry                                                                                                                                                                 | `docker.io`               |
| `image.repository`                         | MariaDB Galera image repository                                                                                                                                                               | `bitnami/mariadb-galera`  |
| `image.tag`                                | MariaDB Galera image tag (immutable tags are recommended)                                                                                                                                     | `10.5.11-debian-10-r0`    |
| `image.pullPolicy`                         | MariaDB Galera image pull policy                                                                                                                                                              | `IfNotPresent`            |
| `image.pullSecrets`                        | Specify docker-registry secret names as an array                                                                                                                                              | `[]`                      |
| `image.debug`                              | Specify if debug logs should be enabled                                                                                                                                                       | `false`                   |
| `podManagementPolicy`                      | StatefulSet controller supports relax its ordering guarantees while preserving its uniqueness and identity guarantees. There are two valid pod management policies: OrderedReady and Parallel | `OrderedReady`            |
| `hostAliases`                              | Add deployment host aliases                                                                                                                                                                   | `[]`                      |
| `service.type`                             | Kubernetes service type                                                                                                                                                                       | `ClusterIP`               |
| `service.port`                             | MariaDB service port                                                                                                                                                                          | `3306`                    |
| `service.clusterIP`                        | Specific cluster IP when service type is cluster IP. Use `None` for headless service                                                                                                          | `nil`                     |
| `service.nodePort`                         | Specify the nodePort value for the LoadBalancer and NodePort service types.                                                                                                                   | `nil`                     |
| `service.externalIPs`                      | External IP list to use with ClusterIP service type                                                                                                                                           | `[]`                      |
| `service.loadBalancerIP`                   | `loadBalancerIP` if service type is `LoadBalancer`                                                                                                                                            | `nil`                     |
| `service.loadBalancerSourceRanges`         | Addresses that are allowed when svc is `LoadBalancer`                                                                                                                                         | `[]`                      |
| `service.annotations`                      | Additional annotations for MariaDB Galera service                                                                                                                                             | `{}`                      |
| `service.headless.annotations`             | Annotations for the headless service. May be useful for setting `service.alpha.kubernetes.io/tolerate-unready-endpoints="true"` when using peer-finder.                                       | `{}`                      |
| `serviceAccount.create`                    | Specify whether a ServiceAccount should be created                                                                                                                                            | `false`                   |
| `serviceAccount.name`                      | The name of the ServiceAccount to create                                                                                                                                                      | `""`                      |
| `extraEnvVars`                             | Array containing extra env vars to configure MariaDB Galera replicas                                                                                                                          | `nil`                     |
| `extraEnvVarsCM`                           | ConfigMap containing extra env vars to configure MariaDB Galera replicas                                                                                                                      | `nil`                     |
| `extraEnvVarsSecret`                       | Secret containing extra env vars to configure MariaDB Galera replicas                                                                                                                         | `nil`                     |
| `rbac.create`                              | Specify whether RBAC resources should be created and used                                                                                                                                     | `false`                   |
| `securityContext.enabled`                  | Enable security context                                                                                                                                                                       | `true`                    |
| `securityContext.fsGroup`                  | Group ID for the container filesystem                                                                                                                                                         | `1001`                    |
| `securityContext.runAsUser`                | User ID for the container                                                                                                                                                                     | `1001`                    |
| `rootUser.user`                            | Username for the admin user.                                                                                                                                                                  | `root`                    |
| `rootUser.password`                        | Password for the admin user. Ignored if existing secret is provided.                                                                                                                          | `""`                      |
| `rootUser.forcePassword`                   | Option to force users to specify a password. That is required for 'helm upgrade' to work properly.                                                                                            | `false`                   |
| `existingSecret`                           | Use existing secret for password details (`rootUser.password`, `db.password`, `galera.mariabackup.password` will be ignored and picked up from this secret)                                   | `nil`                     |
| `usePasswordFiles`                         | Mount credentials as a files instead of using an environment variable.                                                                                                                        | `false`                   |
| `customPasswordFiles`                      | Use custom password files when `usePasswordFiles` is set to `true`. Define path for keys `root`, `user`, and `mariabackup`.                                                                   | `{}`                      |
| `db.user`                                  | Username of new user to create                                                                                                                                                                | `""`                      |
| `db.password`                              | Password for the new user. Ignored if existing secret is provided.                                                                                                                            | `""`                      |
| `db.name`                                  | Name for new database to create                                                                                                                                                               | `my_database`             |
| `db.forcePassword`                         | Option to force users to specify a password. That is required for 'helm upgrade' to work properly.                                                                                            | `false`                   |
| `galera.name`                              | Galera cluster name                                                                                                                                                                           | `galera`                  |
| `galera.bootstrap.bootstrapFromNode`       | Node to bootstrap from, you will need to change this parameter in case you want to bootstrap from other node                                                                                  | `nil`                     |
| `galera.bootstrap.forceSafeToBootstrap`    | Force `safe_to_bootstrap: 1` in `grastate.date` file                                                                                                                                          | `false`                   |
| `galera.mariabackup.user`                  | MariaBackup username                                                                                                                                                                          | `mariabackup`             |
| `galera.mariabackup.password`              | MariaBackup password. Password is ignored if existingSecret is specified.                                                                                                                     | `""`                      |
| `galera.mariabackup.forcePassword`         | Option to force users to specify a password. That is required for 'helm upgrade' to work properly.                                                                                            | `false`                   |
| `ldap.enabled`                             | Enable LDAP support                                                                                                                                                                           | `false`                   |
| `ldap.uri`                                 | LDAP URL beginning in the form `ldap                                                                                                                                                          | `""`                      |
| `ldap.base`                                | LDAP base DN                                                                                                                                                                                  | `""`                      |
| `ldap.binddn`                              | LDAP bind DN                                                                                                                                                                                  | `""`                      |
| `ldap.bindpw`                              | LDAP bind password                                                                                                                                                                            | `""`                      |
| `ldap.bslookup`                            | LDAP base lookup                                                                                                                                                                              | `nil`                     |
| `ldap.filter`                              | LDAP custom filter                                                                                                                                                                            | `nil`                     |
| `ldap.map`                                 | LDAP custom map                                                                                                                                                                               | `nil`                     |
| `ldap.nss_initgroups_ignoreusers`          | LDAP ignored users                                                                                                                                                                            | `root,nslcd`              |
| `ldap.scope`                               | LDAP search scope                                                                                                                                                                             | `nil`                     |
| `ldap.tls_reqcert`                         | LDAP TLS check on server certificates                                                                                                                                                         | `nil`                     |
| `tls.enabled`                              | Enable TLS support for replication traffic                                                                                                                                                    | `false`                   |
| `tls.autoGenerated`                        | Generate automatically self-signed TLS certificates                                                                                                                                           | `false`                   |
| `tls.certificatesSecret`                   | Name of the secret that contains the certificates                                                                                                                                             | `nil`                     |
| `tls.certFilename`                         | Certificate filename                                                                                                                                                                          | `nil`                     |
| `tls.certKeyFilename`                      | Certificate key filename                                                                                                                                                                      | `nil`                     |
| `tls.certCAFilename`                       | CA Certificate filename                                                                                                                                                                       | `nil`                     |
| `mariadbConfiguration`                     | Configuration for the MariaDB server                                                                                                                                                          | `""`                      |
| `configurationConfigMap`                   | ConfigMap with the MariaDB configuration files (Note: Overrides `mariadbConfiguration`). The value is evaluated as a template.                                                                | `nil`                     |
| `initdbScripts`                            | Specify dictionary of scripts to be run at first boot                                                                                                                                         | `nil`                     |
| `initdbScriptsConfigMap`                   | ConfigMap with the initdb scripts (Note: Overrides `initdbScripts`)                                                                                                                           | `nil`                     |
| `extraFlags`                               | MariaDB additional command line flags                                                                                                                                                         | `nil`                     |
| `replicaCount`                             | Desired number of cluster nodes                                                                                                                                                               | `3`                       |
| `updateStrategy.type`                      | updateStrategy for MariaDB Master StatefulSet                                                                                                                                                 | `RollingUpdate`           |
| `podLabels`                                | Extra labels for MariaDB Galera pods                                                                                                                                                          | `{}`                      |
| `podAnnotations`                           | Annotations for MariaDB Galera  pods                                                                                                                                                          | `{}`                      |
| `podAffinityPreset`                        | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                           | `""`                      |
| `podAntiAffinityPreset`                    | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                      | `soft`                    |
| `nodeAffinityPreset.type`                  | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                     | `""`                      |
| `nodeAffinityPreset.key`                   | Node label key to match. Ignored if `affinity` is set.                                                                                                                                        | `""`                      |
| `nodeAffinityPreset.values`                | Node label values to match. Ignored if `affinity` is set.                                                                                                                                     | `[]`                      |
| `affinity`                                 | Affinity for pod assignment                                                                                                                                                                   | `{}`                      |
| `nodeSelector`                             | Node labels for pod assignment                                                                                                                                                                | `{}`                      |
| `tolerations`                              | Tolerations for pod assignment                                                                                                                                                                | `[]`                      |
| `persistence.enabled`                      | Enable persistence using PVC                                                                                                                                                                  | `true`                    |
| `persistence.existingClaim`                | Provide an existing `PersistentVolumeClaim`                                                                                                                                                   | `nil`                     |
| `persistence.subPath`                      | Subdirectory of the volume to mount                                                                                                                                                           | `nil`                     |
| `persistence.mountPath`                    | Path to mount the volume at                                                                                                                                                                   | `/bitnami/mariadb`        |
| `persistence.selector`                     | Selector to match an existing Persistent Volume (this value is evaluated as a template)                                                                                                       | `{}`                      |
| `persistence.storageClass`                 | Persistent Volume Storage Class                                                                                                                                                               | `nil`                     |
| `persistence.annotations`                  | Persistent Volume Claim annotations                                                                                                                                                           | `nil`                     |
| `persistence.accessModes`                  | Persistent Volume Access Modes                                                                                                                                                                | `[]`                      |
| `persistence.size`                         | Persistent Volume Size                                                                                                                                                                        | `8Gi`                     |
| `priorityClassName`                        | Priority Class Name for Statefulset                                                                                                                                                           | `nil`                     |
| `extraInitContainers`                      | Additional init containers (this value is evaluated as a template)                                                                                                                            | `[]`                      |
| `extraContainers`                          | Additional containers (this value is evaluated as a template)                                                                                                                                 | `[]`                      |
| `extraVolumes`                             | Extra volumes                                                                                                                                                                                 | `[]`                      |
| `extraVolumeMounts`                        | Mount extra volume(s)                                                                                                                                                                         | `[]`                      |
| `resources.limits`                         | The resources limits for the container                                                                                                                                                        | `{}`                      |
| `resources.requests`                       | The requested resources for the container                                                                                                                                                     | `{}`                      |
| `livenessProbe.enabled`                    | Turn on and off liveness probe                                                                                                                                                                | `true`                    |
| `livenessProbe.initialDelaySeconds`        | Delay before liveness probe is initiated                                                                                                                                                      | `120`                     |
| `livenessProbe.periodSeconds`              | How often to perform the probe                                                                                                                                                                | `10`                      |
| `livenessProbe.timeoutSeconds`             | When the probe times out                                                                                                                                                                      | `1`                       |
| `livenessProbe.failureThreshold`           | Minimum consecutive failures for the probe                                                                                                                                                    | `3`                       |
| `livenessProbe.successThreshold`           | Minimum consecutive successes for the probe                                                                                                                                                   | `1`                       |
| `readinessProbe.enabled`                   | Turn on and off readiness probe                                                                                                                                                               | `true`                    |
| `readinessProbe.initialDelaySeconds`       | Delay before readiness probe is initiated                                                                                                                                                     | `30`                      |
| `readinessProbe.periodSeconds`             | How often to perform the probe                                                                                                                                                                | `10`                      |
| `readinessProbe.timeoutSeconds`            | When the probe times out                                                                                                                                                                      | `1`                       |
| `readinessProbe.failureThreshold`          | Minimum consecutive failures for the probe                                                                                                                                                    | `3`                       |
| `readinessProbe.successThreshold`          | Minimum consecutive successes for the probe                                                                                                                                                   | `1`                       |
| `startupProbe.enabled`                     | Turn on and off startup probe                                                                                                                                                                 | `false`                   |
| `startupProbe.initialDelaySeconds`         | Delay before startup probe is initiated                                                                                                                                                       | `120`                     |
| `startupProbe.periodSeconds`               | How often to perform the probe                                                                                                                                                                | `10`                      |
| `startupProbe.timeoutSeconds`              | When the probe times out                                                                                                                                                                      | `1`                       |
| `startupProbe.failureThreshold`            | Minimum consecutive failures for the probe                                                                                                                                                    | `48`                      |
| `startupProbe.successThreshold`            | Minimum consecutive successes for the probe                                                                                                                                                   | `1`                       |
| `podDisruptionBudget.create`               | Specifies whether a Pod disruption budget should be created                                                                                                                                   | `false`                   |
| `podDisruptionBudget.minAvailable`         | Minimum number / percentage of pods that should remain scheduled                                                                                                                              | `1`                       |
| `podDisruptionBudget.maxUnavailable`       | Maximum number / percentage of pods that may be made unavailable                                                                                                                              | `nil`                     |
| `metrics.enabled`                          | Start a side-car prometheus exporter                                                                                                                                                          | `false`                   |
| `metrics.image.registry`                   | MariaDB Prometheus exporter image registry                                                                                                                                                    | `docker.io`               |
| `metrics.image.repository`                 | MariaDB Prometheus exporter image repository                                                                                                                                                  | `bitnami/mysqld-exporter` |
| `metrics.image.tag`                        | MariaDB Prometheus exporter image tag (immutable tags are recommended)                                                                                                                        | `0.13.0-debian-10-r19`    |
| `metrics.image.pullPolicy`                 | MariaDB Prometheus exporter image pull policy                                                                                                                                                 | `IfNotPresent`            |
| `metrics.image.pullSecrets`                | MariaDB Prometheus exporter image pull secrets                                                                                                                                                | `[]`                      |
| `metrics.extraFlags`                       | MariaDB Prometheus exporter additional command line flags                                                                                                                                     | `[]`                      |
| `metrics.resources.limits`                 | The resources limits for the container                                                                                                                                                        | `{}`                      |
| `metrics.resources.requests`               | The requested resources for the container                                                                                                                                                     | `{}`                      |
| `metrics.service.type`                     | Prometheus exporter service type                                                                                                                                                              | `ClusterIP`               |
| `metrics.service.port`                     | Prometheus exporter service port                                                                                                                                                              | `9104`                    |
| `metrics.service.annotations`              | Prometheus exporter service annotations                                                                                                                                                       | `{}`                      |
| `metrics.serviceMonitor.enabled`           | if `true`, creates a Prometheus Operator ServiceMonitor (also requires `metrics.enabled` to be `true`)                                                                                        | `false`                   |
| `metrics.serviceMonitor.namespace`         | Optional namespace which Prometheus is running in                                                                                                                                             | `nil`                     |
| `metrics.serviceMonitor.interval`          | How frequently to scrape metrics (use by default, falling back to Prometheus' default)                                                                                                        | `nil`                     |
| `metrics.serviceMonitor.scrapeTimeout`     | Timeout after which the scrape is ended                                                                                                                                                       | `nil`                     |
| `metrics.serviceMonitor.selector`          | ServiceMonitor selector labels                                                                                                                                                                | `{}`                      |
| `metrics.serviceMonitor.relabelings`       | RelabelConfigs to apply to samples before scraping                                                                                                                                            | `[]`                      |
| `metrics.serviceMonitor.metricRelabelings` | MetricRelabelConfigs to apply to samples before ingestion                                                                                                                                     | `[]`                      |
| `metrics.prometheusRules.enabled`          | if `true`, creates a Prometheus Operator PrometheusRule (also requires `metrics.enabled` to be `true`, and makes little sense without ServiceMonitor)                                         | `false`                   |
| `metrics.prometheusRules.selector`         | Additional labels to add to the PrometheusRule so it is picked up by the operator                                                                                                             | `{}`                      |
| `metrics.prometheusRules.rules`            | PrometheusRule rules to configure                                                                                                                                                             | `{}`                      |


The above parameters map to the env variables defined in [bitnami/mariadb-galera](http://github.com/bitnami/bitnami-docker-mariadb-galera). For more information please refer to the [bitnami/mariadb-galera](http://github.com/bitnami/bitnami-docker-mariadb-galera) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install my-release \
  --set rootUser.password=secretpassword,
  --set db.user=app_database \
    bitnami/mariadb-galera
```

The above command sets the MariaDB `root` account password to `secretpassword`. Additionally it creates a database named `my_database`.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

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

### Change MariaDB version

To modify the MariaDB version used in this chart you can specify a [valid image tag](https://hub.docker.com/r/bitnami/mariadb-galera/tags/) using the `image.tag` parameter. For example, `image.tag=X.Y.Z`. This approach is also applicable to other images like exporters.

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
- `ldap.filter`: LDAP custom search filter. No defaults.
- `ldap.map`: LDAP custom map to use. No defaults.
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
ldap.filter="AccountName"
ldap.map="number"
ldap.tls_reqcert="demand"
```

Next, login to the MariaDB server using the `mysql` client and add the PAM authenticated LDAP users.

For example,

```mysql
CREATE USER 'bitnami'@'localhost' IDENTIFIED VIA pam USING 'mariadb';
```

With the above example, when the `bitnami` user attempts to login to the MariaDB server, he/she will be authenticated against the LDAP server.

### Securing traffic using TLS

TLS support can be enabled in the chart by specifying the `tls.` parameters while creating a release. The following parameters should be configured to properly enable the TLS support in the chart:

- `tls.enabled`: Enable TLS support. Defaults to `false`
- `tls.certificatesSecret`: Name of the secret that contains the certificates. No defaults.
- `tls.certFilename`: Certificate filename. No defaults.
- `tls.certKeyFilename`: Certificate key filename. No defaults.
- `tls.certCAFilename`: CA Certificate filename. No defaults.

For example:

First, create the secret with the cetificates files:

```console
kubectl create secret generic certificates-tls-secret --from-file=./cert.pem --from-file=./cert.key --from-file=./ca.pem
```

Then, use the following parameters:

```console
tls.enabled="true"
tls.certificatesSecret="certificates-tls-secret"
tls.certFilename="cert.pem"
tls.certKeyFilename="cert.key"
tls.certCAFilename="ca.pem"
```

### Initialize a fresh instance

The [Bitnami MariaDB Galera](https://github.com/bitnami/bitnami-docker-mariadb-galera) image allows you to use your custom scripts to initialize a fresh instance. In order to execute the scripts, they must be located inside the chart folder `files/docker-entrypoint-initdb.d` so they can be consumed as a ConfigMap.

Alternatively, you can specify custom scripts using the `initdbScripts` parameter as dict.

In addition to these options, you can also set an external ConfigMap with all the initialization scripts. This is done by setting the `initdbScriptsConfigMap` parameter. Note that this will override the two previous options.

The allowed extensions are `.sh`, `.sql` and `.sql.gz`.

Take into account those scripts are treated differently depending on the extension. While the `.sh` scripts are executed in all the nodes; the `.sql` and `.sql.gz` scripts are only executed in the bootstrap node. The reason behind this differentiation is that the `.sh` scripts allow adding conditions to determine what is the node running the script, while these conditions can't be set using `.sql` nor `sql.gz` files. This way it is possible to cover different use cases depending on their needs.

If using a `.sh` script you want to do a "one-time" action like creating a database, you need to add a condition in your `.sh` script to be executed only in one of the nodes, such as

```yaml
initdbScripts:
  my_init_script.sh: |
     #!/bin/sh
     if [[ $(hostname) == *-0  ]]; then
       echo "First node"
       mysql -P 3306 -uroot -prandompassword -e "create database new_database";
     else
       echo "No first node"
     fi
```

## Extra Init Containers

The feature allows for specifying a template string for a initContainer in the pod. Usecases include situations when you need some pre-run setup. For example, in IKS (IBM Cloud Kubernetes Service), non-root users do not have write permission on the volume mount path for NFS-powered file storage. So, you could use a initcontainer to `chown` the mount. See a example below, where we add an initContainer on the pod that reports to an external resource that the db is going to starting.
`values.yaml`
```yaml
extraInitContainers:
- name: initcontainer
  image: bitnami/minideb
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
    value: '{{ template "common.names.fullname" . }}'
  - name: EUREKA_APP_NAME
    value: '{{ template "common.names.name" . }}'
  - name: MARIADB_USER
    value: '{{ .Values.db.user }}'
  - name: MARIADB_PASSWORD
    valueFrom:
      secretKeyRef:
        name: '{{ template "common.names.fullname" . }}'
        key: mariadb-password
  resources:
    limits:
      cpu: 100m
      memory: 20Mi
    requests:
      cpu: 50m
      memory: 10Mi
```

### Bootstraping a node other than 0

> Note: Some of these procedures can lead to data loss, always make a backup beforehand.

To restart the cluster you need to check the state in which it is after being stopped, also you will need the previous password for the `rootUser` and `mariabackup`, and the deployment name. The value of `safe_to_bootstrap` in `/bitnami/mariadb/data/grastate.dat`, will indicate if it is safe to bootstrap form that node. In the case it is other than node 0, it is needed to choose one and force the bootstraping from it. You will notice that in these cases it is needed to start the nodes in `Parallel` by setting `podManagementPolicy`.

#### Checking `safe_to_boostrap`

First you need to get the name of the persistent volume claims (pvc), for example:

```bash
$ kubectl get pvc
NAME                              STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
data-my-galera-mariadb-galera-0   Bound    pvc-a496aded-f604-4a2d-b934-174907c4d235   8Gi        RWO            gp2            25h
data-my-galera-mariadb-galera-1   Bound    pvc-00ba6121-9042-4760-af14-3b8a40de936c   8Gi        RWO            gp2            25h
data-my-galera-mariadb-galera-2   Bound    pvc-61644bc9-2d7d-4e84-bf32-35e59d909b05   8Gi        RWO            gp2            25h
```

The following command will print the content of `grastate.dat` for the persistent volume claim `data-my-galera-mariadb-galera-2`. This needs to be run for each of the pvc. You will need to change this name accordingly with yours for each PVC.

```bash
kubectl run --generator=run-pod/v1 -i --rm --tty volpod --overrides='
{
    "apiVersion": "v1",
    "kind": "Pod",
    "metadata": {
        "name": "volpod"
    },
    "spec": {
        "containers": [{
            "command": [
                "cat",
                "/mnt/data/grastate.dat"
            ],
            "image": "bitnami/minideb",
            "name": "mycontainer",
            "volumeMounts": [{
                "mountPath": "/mnt",
                "name": "galeradata"
            }]
        }],
        "restartPolicy": "Never",
        "volumes": [{
            "name": "galeradata",
            "persistentVolumeClaim": {
                "claimName": "data-my-galera-mariadb-galera-2"
            }
        }]
    }
}' --image="bitnami/minideb"
```

The output should be similar to this:

```
# GALERA saved state
version: 2.1
uuid:    6f2cbfcd-951b-11ea-a116-5f407049e57d
seqno:   25
safe_to_bootstrap: 1
```

There are two possible scenarios:

#### Only one node with `safe_to_bootstrap: 1`

In this case you will need the node number `N` and run:

```bash
helm install my-release bitnami/mariadb-galera \
--set rootUser.password=XXXX \
--set galera.mariabackup.password=YYYY \
--set galera.bootstrap.bootstrapFromNode=N \
--set podManagementPolicy=Parallel
```

#### All the nodes with `safe_to_bootstrap: 0`

In this case the cluster was not stopped cleanly and you need to pick one to force the bootstrap from. The one to be chosen in the one with the highest `seqno` in `/bitnami/mariadb/data/grastate.dat`. The following example shows how to force bootstrap from node 3.

```bash
helm install my-release bitnami/mariadb-galera \
--set rootUser.password=XXXX \
--set galera.mariabackup.password=YYYY
--set galera.bootstrap.bootstrapFromNode=3 \
--set galera.bootstrap.forceSafeToBootstrap=true \
--set podManagementPolicy=Parallel
```

## Persistence

The [Bitnami MariaDB Galera](https://github.com/bitnami/bitnami-docker-mariadb-galera) image stores the MariaDB data and configurations at the `/bitnami/mariadb` path of the container.

The chart mounts a [Persistent Volume](kubernetes.io/docs/user-guide/persistent-volumes/) volume at this location. The volume is created using dynamic volume provisioning, by default. An existing PersistentVolumeClaim can be defined.

### Setting Pod's affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami’s Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

It's necessary to specify the existing passwords while performing a upgrade to ensure the secrets are not updated with invalid randomly generated passwords. Remember to specify the existing values of the `rootUser.password`, `db.password` and `galera.mariabackup.password` parameters when upgrading the chart:

```bash
$ helm upgrade my-release bitnami/mariadb-galera \
    --set rootUser.password=[ROOT_PASSWORD] \
    --set db.password=[MARIADB_PASSWORD] \
    --set galera.mariabackup.password=[GALERA_MARIABACKUP_PASSWORD]
```

| Note: you need to substitute the placeholders _[ROOT_PASSWORD]_, _[MARIADB_PASSWORD]_ and _[MARIABACKUP_PASSWORD]_ with the values obtained from instructions in the installation notes.

### To 5.2.0

This version introduces `bitnami/common`, a [library chart](https://helm.sh/docs/topics/library_charts/#helm) as a dependency. More documentation about this new utility could be found [here](https://github.com/bitnami/charts/tree/master/bitnami/common#bitnami-common-library-chart). Please, make sure that you have updated the chart dependencies before executing any upgrade.

### To 5.0.0

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

### To 2.0.0

In this version the bootstraping was improved. Now it is possible to indicate a node where to bootstrap from, and force the parameter `safe_to_bootstrap`. This allows to handle situations where the cluster was not cleanly stopped. It should be safe to upgrade from v1 of the chart, but it is wise to create always a backup before performing operations where there is a risk of data loss.

### To 1.0.0

The [Bitnami MariaDB Galera](https://github.com/bitnami/bitnami-docker-mariadb-galera) image was migrated to a "non-root" user approach. Previously the container ran as the `root` user and the MySQL daemon was started as the `mysql` user. From now on, both the container and the MySQL daemon run as user `1001`. You can revert this behavior by setting the parameters `securityContext.runAsUser`, and `securityContext.fsGroup` to `0`.

Consequences:

- Backwards compatibility is not guaranteed.
- Environment variables related to LDAP configuration were renamed removing the `MARIADB_` prefix. For instance, to indicate the LDAP URI to use, you must set `LDAP_URI` instead of `MARIADB_LDAP_URI`

To upgrade to `1.0.0`, install a new release of the MariaDB Galera chart, and migrate your data by creating a backup of the database, and restoring it on the new release. In the link below you can find a guide that explain the whole process:

- [Create And Restore MySQL/MariaDB Backups](https://docs.bitnami.com/general/infrastructure/mariadb/administration/backup-restore-mysql-mariadb/)

## Bitnami Kubernetes Documentation

Bitnami Kubernetes documentation is available at [https://docs.bitnami.com/](https://docs.bitnami.com/). You can find there the following resources:

- [Documentation for MariaDB Galera Helm chart](https://docs.bitnami.com/kubernetes/infrastructure/mariadb-galera/)
- [Get Started with Kubernetes guides](https://docs.bitnami.com/kubernetes/)
- [Bitnami Helm charts documentation](https://docs.bitnami.com/kubernetes/apps/)
- [Kubernetes FAQs](https://docs.bitnami.com/kubernetes/faq/)
- [Kubernetes Developer guides](https://docs.bitnami.com/tutorials/)
