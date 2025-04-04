<!--- app-name: MySQL -->

# Bitnami package for MySQL

MySQL is a fast, reliable, scalable, and easy to use open source relational database system. Designed to handle mission-critical, heavy-load production applications.

[Overview of MySQL](http://www.mysql.com)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/mysql
```

Looking to use MySQL in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the commercial edition of the Bitnami catalog.

## Introduction

This chart bootstraps a [MySQL](https://github.com/bitnami/containers/tree/main/bitnami/mysql) replication cluster deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/mysql
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

These commands deploy MySQL on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Configuration and installation details

### Resource requests and limits

Bitnami charts allow setting resource requests and limits for all containers inside the chart deployment. These are inside the `resources` value (check parameter table). Setting requests is essential for production workloads and these should be adapted to your specific use case.

To make this process easier, the chart contains the `resourcesPreset` values, which automatically sets the `resources` section according to different presets. Check these presets in [the bitnami/common chart](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15). However, in production workloads using `resourcesPreset` is discouraged as it may not fully adapt to your specific needs. Find more information on container resource management in the [official Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).

### Prometheus metrics

This chart can be integrated with Prometheus by setting `metrics.enabled` to `true`. This will deploy a sidecar container with [mysqld_exporter](https://github.com/prometheus/mysqld_exporter) in all pods and will expose it via the MariaDB service. This service will have the necessary annotations to be automatically scraped by Prometheus.

#### Prometheus requirements

It is necessary to have a working installation of Prometheus or Prometheus Operator for the integration to work. Install the [Bitnami Prometheus helm chart](https://github.com/bitnami/charts/tree/main/bitnami/prometheus) or the [Bitnami Kube Prometheus helm chart](https://github.com/bitnami/charts/tree/main/bitnami/kube-prometheus) to easily have a working Prometheus in your cluster.

#### Integration with Prometheus Operator

The chart can deploy `ServiceMonitor` objects for integration with Prometheus Operator installations. To do so, set the value `metrics.serviceMonitor.enabled=true`. Ensure that the Prometheus Operator `CustomResourceDefinitions` are installed in the cluster or it will fail with the following error:

```text
no matches for kind "ServiceMonitor" in version "monitoring.coreos.com/v1"
```

Install the [Bitnami Kube Prometheus helm chart](https://github.com/bitnami/charts/tree/main/bitnami/kube-prometheus) for having the necessary CRDs and the Prometheus Operator.

### [Rolling VS Immutable tags](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Use a different MySQL version

To modify the application version used in this chart, specify a different version of the image using the `image.tag` parameter and/or a different repository using the `image.repository` parameter.

### Customize a new MySQL instance

The [Bitnami MySQL](https://github.com/bitnami/containers/tree/main/bitnami/mysql) image allows you to use your custom scripts to initialize a fresh instance. Custom scripts may be specified using the `initdbScripts` parameter. Alternatively, an external ConfigMap may be created with all the initialization scripts and the ConfigMap passed to the chart via the `initdbScriptsConfigMap` parameter. Note that this will override the `initdbScripts` parameter.

The allowed extensions are `.sh`, `.sql` and `.sql.gz`.

These scripts are treated differently depending on their extension. While `.sh` scripts are executed on all the nodes, `.sql` and `.sql.gz` scripts are only executed on the primary nodes. This is because `.sh` scripts support conditional tests to identify the type of node they are running on, while such tests are not supported in `.sql` or `sql.gz` files.

When using a `.sh` script, you may wish to perform a "one-time" action like creating a database. This can be achieved by adding a condition in the script to ensure that it is executed only on one node, as shown in the example below:

```yaml
initdbScripts:
  my_init_script.sh: |
    #!/bin/bash
    if [[ $(hostname) == *primary* ]]; then
      echo "Primary node"
      password_aux="${MYSQL_ROOT_PASSWORD:-}"
      if [[ -f "${MYSQL_ROOT_PASSWORD_FILE:-}" ]]; then
          password_aux=$(cat "$MYSQL_ROOT_PASSWORD_FILE")
      fi
      mysql -P 3306 -uroot -p"$password_aux" -e "create database new_database";
    else
      echo "Secondary node"
    fi
```

### Sidecars and Init Containers

If you have a need for additional containers to run within the same pod as MySQL, you can do so via the `sidecars` config parameter. Simply define your container according to the Kubernetes container spec.

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

### Securing traffic using TLS

This chart supports encrypting communications using TLS. To enable this feature, set the `tls.enabled`.

It is necessary to create a secret containing the TLS certificates and pass it to the chart via the `tls.existingSecret` parameter. Every secret should contain a `tls.crt` and `tls.key` keys including the certificate and key files respectively and, optionally, a `ca.crt` key including the CA certificate. For example: create the secret with the certificates files:

```console
kubectl create secret generic tls-secret --from-file=./tls.crt --from-file=./tls.key --from-file=./ca.crt
```

You can manually create the required TLS certificates or relying on the chart auto-generation capabilities. The chart supports two different ways to auto-generate the required certificates:

- Using Helm capabilities. Enable this feature by setting `tls.autoGenerated.enabled` to `true` and `tls.autoGenerated.engine` to `helm`.
- Relying on CertManager (please note it's required to have CertManager installed in your K8s cluster). Enable this feature by setting `tls.autoGenerated.enabled` to `true` and `tls.autoGenerated.engine` to `cert-manager`. Please note it's supported to use an existing Issuer/ClusterIssuer for issuing the TLS certificates by setting the `tls.autoGenerated.certManager.existingIssuer` and `tls.autoGenerated.certManager.existingIssuerKind` parameters.

### Update credentials

Bitnami charts, with its default settings, configure credentials at first boot. Any further change in the secrets or credentials can be done using one of the following methods:

#### Manual update of the passwords and secrets

- Update the user password following [the upstream documentation](https://dev.mysql.com/doc/refman/8.4/en/set-password.html)
- Update the password secret with the new values (replace the SECRET_NAME, PASSWORD and ROOT_PASSWORD placeholders)

```shell
kubectl create secret generic SECRET_NAME --from-literal=password=PASSWORD --from-literal=root-password=ROOT_PASSWORD --dry-run -o yaml | kubectl apply -f -
```

#### Automated update using a password update job

The Bitnami MySQL provides a password update job that will automatically change the MySQL passwords when running helm upgrade. To enable the job set `passwordUpdateJob.enabled=true`. This job requires:

- The new passwords: this is configured using either `auth.rootPassword`, `auth.password` and `auth.replicationPassword` (if applicable) or setting `auth.existingSecret`.
- The previous passwords: This value is taken automatically from already deployed secret object. If you are using `auth.existingSecret` or `helm template` instead of `helm upgrade`, then set either `passwordUpdate.job.previousPasswords.rootPassword`, `passwordUpdate.job.previousPasswords.password`, `passwordUpdate.job.previousPasswords.replicationPassword` (when applicable), setting `auth.existingSecret`.

In the following example we update the password via values.yaml in a mysql installation with replication

```yaml
architecture: "replication"

auth:
  user: "user"
  rootPassword: "newRootPassword123"
  password: "newUserPassword123"
  replicationPassword: "newReplicationPassword123"

passwordUpdateJob:
  enabled: true
```

In this example we use two existing secrets (`new-password-secret` and `previous-password-secret`) to update the passwords:

```yaml
auth:
  existingSecret: new-password-secret

passwordUpdateJob:
  enabled: true
  previousPasswords:
    existingSecret: previous-password-secret
```

You can add extra update commands using the `passwordUpdateJob.extraCommands` value.

### Network Policy config

To enable network policy for MySQL, install [a networking plugin that implements the Kubernetes NetworkPolicy spec](https://kubernetes.io/docs/tasks/administer-cluster/declare-network-policy#before-you-begin), and set `networkPolicy.enabled` to `true`.

For Kubernetes v1.5 & v1.6, you must also turn on NetworkPolicy by setting the DefaultDeny namespace annotation. Note: this will enforce policy for _all_ pods in the namespace:

```console
kubectl annotate namespace default "net.beta.kubernetes.io/network-policy={\"ingress\":{\"isolation\":\"DefaultDeny\"}}"
```

With NetworkPolicy enabled, traffic will be limited to just port 3306.

For more precise policy, set `networkPolicy.allowExternal=false`. This will only allow pods with the generated client label to connect to MySQL.
This label will be displayed in the output of a successful install.

### Pod affinity

This chart allows you to set your custom affinity using the `XXX.affinity` parameter(s). Find more information about Pod affinity in the [Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities) chart. To do so, set the `XXX.podAffinityPreset`, `XXX.podAntiAffinityPreset`, or `XXX.nodeAffinityPreset` parameters.

### Backup and restore

To back up and restore Helm chart deployments on Kubernetes, you need to back up the persistent volumes from the source deployment and attach them to a new deployment using [Velero](https://velero.io/), a Kubernetes backup/restore tool. Find the instructions for using Velero in [this guide](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-backup-restore-deployments-velero-index.html).

## Persistence

The [Bitnami MySQL](https://github.com/bitnami/containers/tree/main/bitnami/mysql) image stores the MySQL data and configurations at the `/bitnami/mysql` path of the container.

The chart mounts a [Persistent Volume](https://kubernetes.io/docs/concepts/storage/persistent-volumes/) volume at this location. The volume is created using dynamic volume provisioning by default. An existing PersistentVolumeClaim can also be defined for this purpose.

If you encounter errors when working with persistent volumes, refer to our [troubleshooting guide for persistent volumes](https://docs.bitnami.com/kubernetes/faq/troubleshooting/troubleshooting-persistence-volumes/).

## Parameters

### Global parameters

| Name                                                  | Description                                                                                                                                                                                                                                                                                                                                                         | Value   |
| ----------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `global.imageRegistry`                                | Global Docker image registry                                                                                                                                                                                                                                                                                                                                        | `""`    |
| `global.imagePullSecrets`                             | Global Docker registry secret names as an array                                                                                                                                                                                                                                                                                                                     | `[]`    |
| `global.defaultStorageClass`                          | Global default StorageClass for Persistent Volume(s)                                                                                                                                                                                                                                                                                                                | `""`    |
| `global.storageClass`                                 | DEPRECATED: use global.defaultStorageClass instead                                                                                                                                                                                                                                                                                                                  | `""`    |
| `global.security.allowInsecureImages`                 | Allows skipping image verification                                                                                                                                                                                                                                                                                                                                  | `false` |
| `global.compatibility.openshift.adaptSecurityContext` | Adapt the securityContext sections of the deployment to make them compatible with Openshift restricted-v2 SCC: remove runAsUser, runAsGroup and fsGroup and let the platform use their allowed default IDs. Possible values: auto (apply if the detected running cluster is Openshift), force (perform the adaptation always), disabled (do not perform adaptation) | `auto`  |

### Common parameters

| Name                      | Description                                                                                               | Value           |
| ------------------------- | --------------------------------------------------------------------------------------------------------- | --------------- |
| `kubeVersion`             | Force target Kubernetes version (using Helm capabilities if not set)                                      | `""`            |
| `nameOverride`            | String to partially override common.names.fullname template (will maintain the release name)              | `""`            |
| `fullnameOverride`        | String to fully override common.names.fullname template                                                   | `""`            |
| `namespaceOverride`       | String to fully override common.names.namespace                                                           | `""`            |
| `clusterDomain`           | Cluster domain                                                                                            | `cluster.local` |
| `commonAnnotations`       | Common annotations to add to all MySQL resources (sub-charts are not considered). Evaluated as a template | `{}`            |
| `commonLabels`            | Common labels to add to all MySQL resources (sub-charts are not considered). Evaluated as a template      | `{}`            |
| `extraDeploy`             | Array with extra yaml to deploy with the chart. Evaluated as a template                                   | `[]`            |
| `serviceBindings.enabled` | Create secret for service binding (Experimental)                                                          | `false`         |
| `diagnosticMode.enabled`  | Enable diagnostic mode (all probes will be disabled and the command will be overridden)                   | `false`         |
| `diagnosticMode.command`  | Command to override all containers in the deployment                                                      | `["sleep"]`     |
| `diagnosticMode.args`     | Args to override all containers in the deployment                                                         | `["infinity"]`  |

### MySQL common parameters

| Name                        | Description                                                                                                                                                                         | Value                   |
| --------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------- |
| `image.registry`            | MySQL image registry                                                                                                                                                                | `REGISTRY_NAME`         |
| `image.repository`          | MySQL image repository                                                                                                                                                              | `REPOSITORY_NAME/mysql` |
| `image.digest`              | MySQL image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                               | `""`                    |
| `image.pullPolicy`          | MySQL image pull policy                                                                                                                                                             | `IfNotPresent`          |
| `image.pullSecrets`         | Specify docker-registry secret names as an array                                                                                                                                    | `[]`                    |
| `image.debug`               | Specify if debug logs should be enabled                                                                                                                                             | `false`                 |
| `architecture`              | MySQL architecture (`standalone` or `replication`)                                                                                                                                  | `standalone`            |
| `auth.rootPassword`         | Password for the `root` user. Ignored if existing secret is provided                                                                                                                | `""`                    |
| `auth.createDatabase`       | Whether to create the .Values.auth.database or not                                                                                                                                  | `true`                  |
| `auth.database`             | Name for a custom database to create                                                                                                                                                | `my_database`           |
| `auth.username`             | Name for a custom user to create                                                                                                                                                    | `""`                    |
| `auth.password`             | Password for the new user. Ignored if existing secret is provided                                                                                                                   | `""`                    |
| `auth.replicationUser`      | MySQL replication user                                                                                                                                                              | `replicator`            |
| `auth.replicationPassword`  | MySQL replication user password. Ignored if existing secret is provided                                                                                                             | `""`                    |
| `auth.existingSecret`       | Use existing secret for password details. The secret has to contain the keys `mysql-root-password`, `mysql-replication-password` and `mysql-password`                               | `""`                    |
| `auth.usePasswordFiles`     | Mount credentials as files instead of using an environment variable                                                                                                                 | `true`                  |
| `auth.customPasswordFiles`  | Use custom password files when `auth.usePasswordFiles` is set to `true`. Define path for keys `root` and `user`, also define `replicator` if `architecture` is set to `replication` | `{}`                    |
| `auth.authenticationPolicy` | Sets the authentication policy, by default it will use `* ,,`                                                                                                                       | `""`                    |
| `initdbScripts`             | Dictionary of initdb scripts                                                                                                                                                        | `{}`                    |
| `initdbScriptsConfigMap`    | ConfigMap with the initdb scripts (Note: Overrides `initdbScripts`)                                                                                                                 | `""`                    |
| `startdbScripts`            | Dictionary of startdb scripts                                                                                                                                                       | `{}`                    |
| `startdbScriptsConfigMap`   | ConfigMap with the startdb scripts (Note: Overrides `startdbScripts`)                                                                                                               | `""`                    |

### TLS/SSL parameters

| Name                                               | Description                                                                                            | Value     |
| -------------------------------------------------- | ------------------------------------------------------------------------------------------------------ | --------- |
| `tls.enabled`                                      | Enable TLS in MySQL                                                                                    | `false`   |
| `tls.existingSecret`                               | Existing secret that contains TLS certificates                                                         | `""`      |
| `tls.certFilename`                                 | The secret key from the existingSecret if 'cert' key different from the default (tls.crt)              | `tls.crt` |
| `tls.certKeyFilename`                              | The secret key from the existingSecret if 'key' key different from the default (tls.key)               | `tls.key` |
| `tls.certCAFilename`                               | The secret key from the existingSecret if 'ca' key different from the default (tls.crt)                | `""`      |
| `tls.ca`                                           | CA certificate for TLS. Ignored if `tls.existingSecret` is set                                         | `""`      |
| `tls.cert`                                         | TLS certificate for MySQL. Ignored if `tls.existingSecret` is set                                      | `""`      |
| `tls.key`                                          | TLS key for MySQL. Ignored if `tls.existingSecret` is set                                              | `""`      |
| `tls.autoGenerated.enabled`                        | Enable automatic generation of certificates for TLS                                                    | `true`    |
| `tls.autoGenerated.engine`                         | Mechanism to generate the certificates (allowed values: helm, cert-manager)                            | `helm`    |
| `tls.autoGenerated.certManager.existingIssuer`     | The name of an existing Issuer to use for generating the certificates (only for `cert-manager` engine) | `""`      |
| `tls.autoGenerated.certManager.existingIssuerKind` | Existing Issuer kind, defaults to Issuer (only for `cert-manager` engine)                              | `""`      |
| `tls.autoGenerated.certManager.keyAlgorithm`       | Key algorithm for the certificates (only for `cert-manager` engine)                                    | `RSA`     |
| `tls.autoGenerated.certManager.keySize`            | Key size for the certificates (only for `cert-manager` engine)                                         | `2048`    |
| `tls.autoGenerated.certManager.duration`           | Duration for the certificates (only for `cert-manager` engine)                                         | `2160h`   |
| `tls.autoGenerated.certManager.renewBefore`        | Renewal period for the certificates (only for `cert-manager` engine)                                   | `360h`    |

### MySQL Primary parameters

| Name                                                        | Description                                                                                                                                                                                                                       | Value               |
| ----------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------- |
| `primary.name`                                              | Name of the primary database (eg primary, master, leader, ...)                                                                                                                                                                    | `primary`           |
| `primary.command`                                           | Override default container command on MySQL Primary container(s) (useful when using custom images)                                                                                                                                | `[]`                |
| `primary.args`                                              | Override default container args on MySQL Primary container(s) (useful when using custom images)                                                                                                                                   | `[]`                |
| `primary.lifecycleHooks`                                    | for the MySQL Primary container(s) to automate configuration before or after startup                                                                                                                                              | `{}`                |
| `primary.automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                                | `false`             |
| `primary.hostAliases`                                       | Deployment pod host aliases                                                                                                                                                                                                       | `[]`                |
| `primary.enableMySQLX`                                      | Enable mysqlx port                                                                                                                                                                                                                | `false`             |
| `primary.configuration`                                     | Configure MySQL Primary with a custom my.cnf file                                                                                                                                                                                 | `""`                |
| `primary.existingConfigmap`                                 | Name of existing ConfigMap with MySQL Primary configuration.                                                                                                                                                                      | `""`                |
| `primary.containerPorts.mysql`                              | Container port for mysql                                                                                                                                                                                                          | `3306`              |
| `primary.containerPorts.mysqlx`                             | Container port for mysqlx                                                                                                                                                                                                         | `33060`             |
| `primary.updateStrategy.type`                               | Update strategy type for the MySQL primary statefulset                                                                                                                                                                            | `RollingUpdate`     |
| `primary.podAnnotations`                                    | Additional pod annotations for MySQL primary pods                                                                                                                                                                                 | `{}`                |
| `primary.podAffinityPreset`                                 | MySQL primary pod affinity preset. Ignored if `primary.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                         | `""`                |
| `primary.podAntiAffinityPreset`                             | MySQL primary pod anti-affinity preset. Ignored if `primary.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                    | `soft`              |
| `primary.nodeAffinityPreset.type`                           | MySQL primary node affinity preset type. Ignored if `primary.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                   | `""`                |
| `primary.nodeAffinityPreset.key`                            | MySQL primary node label key to match Ignored if `primary.affinity` is set.                                                                                                                                                       | `""`                |
| `primary.nodeAffinityPreset.values`                         | MySQL primary node label values to match. Ignored if `primary.affinity` is set.                                                                                                                                                   | `[]`                |
| `primary.affinity`                                          | Affinity for MySQL primary pods assignment                                                                                                                                                                                        | `{}`                |
| `primary.nodeSelector`                                      | Node labels for MySQL primary pods assignment                                                                                                                                                                                     | `{}`                |
| `primary.tolerations`                                       | Tolerations for MySQL primary pods assignment                                                                                                                                                                                     | `[]`                |
| `primary.priorityClassName`                                 | MySQL primary pods' priorityClassName                                                                                                                                                                                             | `""`                |
| `primary.runtimeClassName`                                  | MySQL primary pods' runtimeClassName                                                                                                                                                                                              | `""`                |
| `primary.schedulerName`                                     | Name of the k8s scheduler (other than default)                                                                                                                                                                                    | `""`                |
| `primary.terminationGracePeriodSeconds`                     | In seconds, time the given to the MySQL primary pod needs to terminate gracefully                                                                                                                                                 | `""`                |
| `primary.topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment                                                                                                                                                                                    | `[]`                |
| `primary.podManagementPolicy`                               | podManagementPolicy to manage scaling operation of MySQL primary pods                                                                                                                                                             | `""`                |
| `primary.podSecurityContext.enabled`                        | Enable security context for MySQL primary pods                                                                                                                                                                                    | `true`              |
| `primary.podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                                | `Always`            |
| `primary.podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                                    | `[]`                |
| `primary.podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                                       | `[]`                |
| `primary.podSecurityContext.fsGroup`                        | Group ID for the mounted volumes' filesystem                                                                                                                                                                                      | `1001`              |
| `primary.containerSecurityContext.enabled`                  | MySQL primary container securityContext                                                                                                                                                                                           | `true`              |
| `primary.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                                  | `{}`                |
| `primary.containerSecurityContext.runAsUser`                | User ID for the MySQL primary container                                                                                                                                                                                           | `1001`              |
| `primary.containerSecurityContext.runAsGroup`               | Group ID for the MySQL primary container                                                                                                                                                                                          | `1001`              |
| `primary.containerSecurityContext.runAsNonRoot`             | Set MySQL primary container's Security Context runAsNonRoot                                                                                                                                                                       | `true`              |
| `primary.containerSecurityContext.allowPrivilegeEscalation` | Set container's privilege escalation                                                                                                                                                                                              | `false`             |
| `primary.containerSecurityContext.capabilities.drop`        | Set container's Security Context runAsNonRoot                                                                                                                                                                                     | `["ALL"]`           |
| `primary.containerSecurityContext.seccompProfile.type`      | Set Client container's Security Context seccomp profile                                                                                                                                                                           | `RuntimeDefault`    |
| `primary.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context read-only root filesystem                                                                                                                                                                        | `true`              |
| `primary.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if primary.resources is set (primary.resources is recommended for production). | `small`             |
| `primary.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                 | `{}`                |
| `primary.livenessProbe.enabled`                             | Enable livenessProbe                                                                                                                                                                                                              | `true`              |
| `primary.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                                           | `5`                 |
| `primary.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                                  | `10`                |
| `primary.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                                 | `1`                 |
| `primary.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                                               | `3`                 |
| `primary.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                                               | `1`                 |
| `primary.readinessProbe.enabled`                            | Enable readinessProbe                                                                                                                                                                                                             | `true`              |
| `primary.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                                          | `5`                 |
| `primary.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                                 | `10`                |
| `primary.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                                | `1`                 |
| `primary.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                                              | `3`                 |
| `primary.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                                              | `1`                 |
| `primary.startupProbe.enabled`                              | Enable startupProbe                                                                                                                                                                                                               | `true`              |
| `primary.startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                                            | `15`                |
| `primary.startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                                   | `10`                |
| `primary.startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                                  | `1`                 |
| `primary.startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                                | `10`                |
| `primary.startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                                | `1`                 |
| `primary.customLivenessProbe`                               | Override default liveness probe for MySQL primary containers                                                                                                                                                                      | `{}`                |
| `primary.customReadinessProbe`                              | Override default readiness probe for MySQL primary containers                                                                                                                                                                     | `{}`                |
| `primary.customStartupProbe`                                | Override default startup probe for MySQL primary containers                                                                                                                                                                       | `{}`                |
| `primary.extraFlags`                                        | MySQL primary additional command line flags                                                                                                                                                                                       | `""`                |
| `primary.extraEnvVars`                                      | Extra environment variables to be set on MySQL primary containers                                                                                                                                                                 | `[]`                |
| `primary.extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for MySQL primary containers                                                                                                                                                 | `""`                |
| `primary.extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for MySQL primary containers                                                                                                                                                    | `""`                |
| `primary.extraPodSpec`                                      | Optionally specify extra PodSpec for the MySQL Primary pod(s)                                                                                                                                                                     | `{}`                |
| `primary.extraPorts`                                        | Extra ports to expose                                                                                                                                                                                                             | `[]`                |
| `primary.persistence.enabled`                               | Enable persistence on MySQL primary replicas using a `PersistentVolumeClaim`. If false, use emptyDir                                                                                                                              | `true`              |
| `primary.persistence.existingClaim`                         | Name of an existing `PersistentVolumeClaim` for MySQL primary replicas                                                                                                                                                            | `""`                |
| `primary.persistence.subPath`                               | The name of a volume's sub path to mount for persistence                                                                                                                                                                          | `""`                |
| `primary.persistence.storageClass`                          | MySQL primary persistent volume storage Class                                                                                                                                                                                     | `""`                |
| `primary.persistence.annotations`                           | MySQL primary persistent volume claim annotations                                                                                                                                                                                 | `{}`                |
| `primary.persistence.accessModes`                           | MySQL primary persistent volume access Modes                                                                                                                                                                                      | `["ReadWriteOnce"]` |
| `primary.persistence.size`                                  | MySQL primary persistent volume size                                                                                                                                                                                              | `8Gi`               |
| `primary.persistence.selector`                              | Selector to match an existing Persistent Volume                                                                                                                                                                                   | `{}`                |
| `primary.persistentVolumeClaimRetentionPolicy.enabled`      | Enable Persistent volume retention policy for Primary StatefulSet                                                                                                                                                                 | `false`             |
| `primary.persistentVolumeClaimRetentionPolicy.whenScaled`   | Volume retention behavior when the replica count of the StatefulSet is reduced                                                                                                                                                    | `Retain`            |
| `primary.persistentVolumeClaimRetentionPolicy.whenDeleted`  | Volume retention behavior that applies when the StatefulSet is deleted                                                                                                                                                            | `Retain`            |
| `primary.extraVolumes`                                      | Optionally specify extra list of additional volumes to the MySQL Primary pod(s)                                                                                                                                                   | `[]`                |
| `primary.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the MySQL Primary container(s)                                                                                                                                       | `[]`                |
| `primary.initContainers`                                    | Add additional init containers for the MySQL Primary pod(s)                                                                                                                                                                       | `[]`                |
| `primary.sidecars`                                          | Add additional sidecar containers for the MySQL Primary pod(s)                                                                                                                                                                    | `[]`                |
| `primary.service.type`                                      | MySQL Primary K8s service type                                                                                                                                                                                                    | `ClusterIP`         |
| `primary.service.ports.mysql`                               | MySQL Primary K8s service port                                                                                                                                                                                                    | `3306`              |
| `primary.service.ports.mysqlx`                              | MySQL Primary K8s service mysqlx port                                                                                                                                                                                             | `33060`             |
| `primary.service.nodePorts.mysql`                           | MySQL Primary K8s service node port                                                                                                                                                                                               | `""`                |
| `primary.service.nodePorts.mysqlx`                          | MySQL Primary K8s service node port mysqlx                                                                                                                                                                                        | `""`                |
| `primary.service.clusterIP`                                 | MySQL Primary K8s service clusterIP IP                                                                                                                                                                                            | `""`                |
| `primary.service.loadBalancerIP`                            | MySQL Primary loadBalancerIP if service type is `LoadBalancer`                                                                                                                                                                    | `""`                |
| `primary.service.externalTrafficPolicy`                     | Enable client source IP preservation                                                                                                                                                                                              | `Cluster`           |
| `primary.service.loadBalancerSourceRanges`                  | Addresses that are allowed when MySQL Primary service is LoadBalancer                                                                                                                                                             | `[]`                |
| `primary.service.extraPorts`                                | Extra ports to expose (normally used with the `sidecar` value)                                                                                                                                                                    | `[]`                |
| `primary.service.annotations`                               | Additional custom annotations for MySQL primary service                                                                                                                                                                           | `{}`                |
| `primary.service.sessionAffinity`                           | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                                                                                                                                                              | `None`              |
| `primary.service.sessionAffinityConfig`                     | Additional settings for the sessionAffinity                                                                                                                                                                                       | `{}`                |
| `primary.service.headless.annotations`                      | Additional custom annotations for headless MySQL primary service.                                                                                                                                                                 | `{}`                |
| `primary.pdb.create`                                        | Enable/disable a Pod Disruption Budget creation for MySQL primary pods                                                                                                                                                            | `true`              |
| `primary.pdb.minAvailable`                                  | Minimum number/percentage of MySQL primary pods that should remain scheduled                                                                                                                                                      | `""`                |
| `primary.pdb.maxUnavailable`                                | Maximum number/percentage of MySQL primary pods that may be made unavailable. Defaults to `1` if both `primary.pdb.minAvailable` and `primary.pdb.maxUnavailable` are empty.                                                      | `""`                |
| `primary.podLabels`                                         | MySQL Primary pod label. If labels are same as commonLabels , this will take precedence                                                                                                                                           | `{}`                |

### MySQL Secondary parameters

| Name                                                          | Description                                                                                                                                                                                                                           | Value               |
| ------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------- |
| `secondary.name`                                              | Name of the secondary database (eg secondary, slave, ...)                                                                                                                                                                             | `secondary`         |
| `secondary.replicaCount`                                      | Number of MySQL secondary replicas                                                                                                                                                                                                    | `1`                 |
| `secondary.automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                                    | `false`             |
| `secondary.hostAliases`                                       | Deployment pod host aliases                                                                                                                                                                                                           | `[]`                |
| `secondary.command`                                           | Override default container command on MySQL Secondary container(s) (useful when using custom images)                                                                                                                                  | `[]`                |
| `secondary.args`                                              | Override default container args on MySQL Secondary container(s) (useful when using custom images)                                                                                                                                     | `[]`                |
| `secondary.lifecycleHooks`                                    | for the MySQL Secondary container(s) to automate configuration before or after startup                                                                                                                                                | `{}`                |
| `secondary.enableMySQLX`                                      | Enable mysqlx port                                                                                                                                                                                                                    | `false`             |
| `secondary.configuration`                                     | Configure MySQL Secondary with a custom my.cnf file                                                                                                                                                                                   | `""`                |
| `secondary.existingConfigmap`                                 | Name of existing ConfigMap with MySQL Secondary configuration.                                                                                                                                                                        | `""`                |
| `secondary.containerPorts.mysql`                              | Container port for mysql                                                                                                                                                                                                              | `3306`              |
| `secondary.containerPorts.mysqlx`                             | Container port for mysqlx                                                                                                                                                                                                             | `33060`             |
| `secondary.updateStrategy.type`                               | Update strategy type for the MySQL secondary statefulset                                                                                                                                                                              | `RollingUpdate`     |
| `secondary.podAnnotations`                                    | Additional pod annotations for MySQL secondary pods                                                                                                                                                                                   | `{}`                |
| `secondary.podAffinityPreset`                                 | MySQL secondary pod affinity preset. Ignored if `secondary.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                         | `""`                |
| `secondary.podAntiAffinityPreset`                             | MySQL secondary pod anti-affinity preset. Ignored if `secondary.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                    | `soft`              |
| `secondary.nodeAffinityPreset.type`                           | MySQL secondary node affinity preset type. Ignored if `secondary.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                   | `""`                |
| `secondary.nodeAffinityPreset.key`                            | MySQL secondary node label key to match Ignored if `secondary.affinity` is set.                                                                                                                                                       | `""`                |
| `secondary.nodeAffinityPreset.values`                         | MySQL secondary node label values to match. Ignored if `secondary.affinity` is set.                                                                                                                                                   | `[]`                |
| `secondary.affinity`                                          | Affinity for MySQL secondary pods assignment                                                                                                                                                                                          | `{}`                |
| `secondary.nodeSelector`                                      | Node labels for MySQL secondary pods assignment                                                                                                                                                                                       | `{}`                |
| `secondary.tolerations`                                       | Tolerations for MySQL secondary pods assignment                                                                                                                                                                                       | `[]`                |
| `secondary.priorityClassName`                                 | MySQL secondary pods' priorityClassName                                                                                                                                                                                               | `""`                |
| `secondary.runtimeClassName`                                  | MySQL secondary pods' runtimeClassName                                                                                                                                                                                                | `""`                |
| `secondary.schedulerName`                                     | Name of the k8s scheduler (other than default)                                                                                                                                                                                        | `""`                |
| `secondary.terminationGracePeriodSeconds`                     | In seconds, time the given to the MySQL secondary pod needs to terminate gracefully                                                                                                                                                   | `""`                |
| `secondary.topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment                                                                                                                                                                                        | `[]`                |
| `secondary.podManagementPolicy`                               | podManagementPolicy to manage scaling operation of MySQL secondary pods                                                                                                                                                               | `""`                |
| `secondary.podSecurityContext.enabled`                        | Enable security context for MySQL secondary pods                                                                                                                                                                                      | `true`              |
| `secondary.podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                                    | `Always`            |
| `secondary.podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                                        | `[]`                |
| `secondary.podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                                           | `[]`                |
| `secondary.podSecurityContext.fsGroup`                        | Group ID for the mounted volumes' filesystem                                                                                                                                                                                          | `1001`              |
| `secondary.containerSecurityContext.enabled`                  | MySQL secondary container securityContext                                                                                                                                                                                             | `true`              |
| `secondary.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                                      | `{}`                |
| `secondary.containerSecurityContext.runAsUser`                | User ID for the MySQL secondary container                                                                                                                                                                                             | `1001`              |
| `secondary.containerSecurityContext.runAsGroup`               | Group ID for the MySQL secondary container                                                                                                                                                                                            | `1001`              |
| `secondary.containerSecurityContext.runAsNonRoot`             | Set MySQL secondary container's Security Context runAsNonRoot                                                                                                                                                                         | `true`              |
| `secondary.containerSecurityContext.allowPrivilegeEscalation` | Set container's privilege escalation                                                                                                                                                                                                  | `false`             |
| `secondary.containerSecurityContext.capabilities.drop`        | Set container's Security Context runAsNonRoot                                                                                                                                                                                         | `["ALL"]`           |
| `secondary.containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                                      | `RuntimeDefault`    |
| `secondary.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context read-only root filesystem                                                                                                                                                                            | `true`              |
| `secondary.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if secondary.resources is set (secondary.resources is recommended for production). | `small`             |
| `secondary.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                     | `{}`                |
| `secondary.livenessProbe.enabled`                             | Enable livenessProbe                                                                                                                                                                                                                  | `true`              |
| `secondary.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                                               | `5`                 |
| `secondary.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                                      | `10`                |
| `secondary.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                                     | `1`                 |
| `secondary.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                                                   | `3`                 |
| `secondary.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                                                   | `1`                 |
| `secondary.readinessProbe.enabled`                            | Enable readinessProbe                                                                                                                                                                                                                 | `true`              |
| `secondary.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                                              | `5`                 |
| `secondary.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                                     | `10`                |
| `secondary.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                                    | `1`                 |
| `secondary.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                                                  | `3`                 |
| `secondary.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                                                  | `1`                 |
| `secondary.startupProbe.enabled`                              | Enable startupProbe                                                                                                                                                                                                                   | `true`              |
| `secondary.startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                                                | `15`                |
| `secondary.startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                                       | `10`                |
| `secondary.startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                                      | `1`                 |
| `secondary.startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                                    | `15`                |
| `secondary.startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                                    | `1`                 |
| `secondary.customLivenessProbe`                               | Override default liveness probe for MySQL secondary containers                                                                                                                                                                        | `{}`                |
| `secondary.customReadinessProbe`                              | Override default readiness probe for MySQL secondary containers                                                                                                                                                                       | `{}`                |
| `secondary.customStartupProbe`                                | Override default startup probe for MySQL secondary containers                                                                                                                                                                         | `{}`                |
| `secondary.extraFlags`                                        | MySQL secondary additional command line flags                                                                                                                                                                                         | `""`                |
| `secondary.extraEnvVars`                                      | An array to add extra environment variables on MySQL secondary containers                                                                                                                                                             | `[]`                |
| `secondary.extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for MySQL secondary containers                                                                                                                                                   | `""`                |
| `secondary.extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for MySQL secondary containers                                                                                                                                                      | `""`                |
| `secondary.extraPodSpec`                                      | Optionally specify extra PodSpec for the MySQL Secondary pod(s)                                                                                                                                                                       | `{}`                |
| `secondary.extraPorts`                                        | Extra ports to expose                                                                                                                                                                                                                 | `[]`                |
| `secondary.persistence.enabled`                               | Enable persistence on MySQL secondary replicas using a `PersistentVolumeClaim`                                                                                                                                                        | `true`              |
| `secondary.persistence.existingClaim`                         | Name of an existing `PersistentVolumeClaim` for MySQL secondary replicas                                                                                                                                                              | `""`                |
| `secondary.persistence.subPath`                               | The name of a volume's sub path to mount for persistence                                                                                                                                                                              | `""`                |
| `secondary.persistence.storageClass`                          | MySQL secondary persistent volume storage Class                                                                                                                                                                                       | `""`                |
| `secondary.persistence.annotations`                           | MySQL secondary persistent volume claim annotations                                                                                                                                                                                   | `{}`                |
| `secondary.persistence.accessModes`                           | MySQL secondary persistent volume access Modes                                                                                                                                                                                        | `["ReadWriteOnce"]` |
| `secondary.persistence.size`                                  | MySQL secondary persistent volume size                                                                                                                                                                                                | `8Gi`               |
| `secondary.persistence.selector`                              | Selector to match an existing Persistent Volume                                                                                                                                                                                       | `{}`                |
| `secondary.persistentVolumeClaimRetentionPolicy.enabled`      | Enable Persistent volume retention policy for read only StatefulSet                                                                                                                                                                   | `false`             |
| `secondary.persistentVolumeClaimRetentionPolicy.whenScaled`   | Volume retention behavior when the replica count of the StatefulSet is reduced                                                                                                                                                        | `Retain`            |
| `secondary.persistentVolumeClaimRetentionPolicy.whenDeleted`  | Volume retention behavior that applies when the StatefulSet is deleted                                                                                                                                                                | `Retain`            |
| `secondary.extraVolumes`                                      | Optionally specify extra list of additional volumes to the MySQL secondary pod(s)                                                                                                                                                     | `[]`                |
| `secondary.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the MySQL secondary container(s)                                                                                                                                         | `[]`                |
| `secondary.initContainers`                                    | Add additional init containers for the MySQL secondary pod(s)                                                                                                                                                                         | `[]`                |
| `secondary.sidecars`                                          | Add additional sidecar containers for the MySQL secondary pod(s)                                                                                                                                                                      | `[]`                |
| `secondary.service.type`                                      | MySQL secondary Kubernetes service type                                                                                                                                                                                               | `ClusterIP`         |
| `secondary.service.ports.mysql`                               | MySQL secondary Kubernetes service port                                                                                                                                                                                               | `3306`              |
| `secondary.service.ports.mysqlx`                              | MySQL secondary Kubernetes service port mysqlx                                                                                                                                                                                        | `33060`             |
| `secondary.service.nodePorts.mysql`                           | MySQL secondary Kubernetes service node port                                                                                                                                                                                          | `""`                |
| `secondary.service.nodePorts.mysqlx`                          | MySQL secondary Kubernetes service node port mysqlx                                                                                                                                                                                   | `""`                |
| `secondary.service.clusterIP`                                 | MySQL secondary Kubernetes service clusterIP IP                                                                                                                                                                                       | `""`                |
| `secondary.service.loadBalancerIP`                            | MySQL secondary loadBalancerIP if service type is `LoadBalancer`                                                                                                                                                                      | `""`                |
| `secondary.service.externalTrafficPolicy`                     | Enable client source IP preservation                                                                                                                                                                                                  | `Cluster`           |
| `secondary.service.loadBalancerSourceRanges`                  | Addresses that are allowed when MySQL secondary service is LoadBalancer                                                                                                                                                               | `[]`                |
| `secondary.service.extraPorts`                                | Extra ports to expose (normally used with the `sidecar` value)                                                                                                                                                                        | `[]`                |
| `secondary.service.annotations`                               | Additional custom annotations for MySQL secondary service                                                                                                                                                                             | `{}`                |
| `secondary.service.sessionAffinity`                           | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                                                                                                                                                                  | `None`              |
| `secondary.service.sessionAffinityConfig`                     | Additional settings for the sessionAffinity                                                                                                                                                                                           | `{}`                |
| `secondary.service.headless.annotations`                      | Additional custom annotations for headless MySQL secondary service.                                                                                                                                                                   | `{}`                |
| `secondary.pdb.create`                                        | Enable/disable a Pod Disruption Budget creation for MySQL secondary pods                                                                                                                                                              | `true`              |
| `secondary.pdb.minAvailable`                                  | Minimum number/percentage of MySQL secondary pods that should remain scheduled                                                                                                                                                        | `""`                |
| `secondary.pdb.maxUnavailable`                                | Maximum number/percentage of MySQL secondary pods that may be made unavailable. Defaults to `1` if both `secondary.pdb.minAvailable` and `secondary.pdb.maxUnavailable` are empty.                                                    | `""`                |
| `secondary.podLabels`                                         | Additional pod labels for MySQL secondary pods                                                                                                                                                                                        | `{}`                |

### RBAC parameters

| Name                                          | Description                                                    | Value   |
| --------------------------------------------- | -------------------------------------------------------------- | ------- |
| `serviceAccount.create`                       | Enable the creation of a ServiceAccount for MySQL pods         | `true`  |
| `serviceAccount.name`                         | Name of the created ServiceAccount                             | `""`    |
| `serviceAccount.annotations`                  | Annotations for MySQL Service Account                          | `{}`    |
| `serviceAccount.automountServiceAccountToken` | Automount service account token for the server service account | `false` |
| `rbac.create`                                 | Whether to create & use RBAC resources or not                  | `false` |
| `rbac.rules`                                  | Custom RBAC rules to set                                       | `[]`    |

### Network Policy

| Name                                    | Description                                                     | Value  |
| --------------------------------------- | --------------------------------------------------------------- | ------ |
| `networkPolicy.enabled`                 | Enable creation of NetworkPolicy resources                      | `true` |
| `networkPolicy.allowExternal`           | The Policy model to apply                                       | `true` |
| `networkPolicy.allowExternalEgress`     | Allow the pod to access any range of port and all destinations. | `true` |
| `networkPolicy.extraIngress`            | Add extra ingress rules to the NetworkPolicy                    | `[]`   |
| `networkPolicy.extraEgress`             | Add extra ingress rules to the NetworkPolicy                    | `[]`   |
| `networkPolicy.ingressNSMatchLabels`    | Labels to match to allow traffic from other namespaces          | `{}`   |
| `networkPolicy.ingressNSPodMatchLabels` | Pod labels to match to allow traffic from other namespaces      | `{}`   |

### Password update job

| Name                                                                  | Description                                                                                                                                                                                                                                           | Value            |
| --------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| `passwordUpdateJob.enabled`                                           | Enable password update job                                                                                                                                                                                                                            | `false`          |
| `passwordUpdateJob.backoffLimit`                                      | set backoff limit of the job                                                                                                                                                                                                                          | `10`             |
| `passwordUpdateJob.command`                                           | Override default container command on mysql Primary container(s) (useful when using custom images)                                                                                                                                                    | `[]`             |
| `passwordUpdateJob.args`                                              | Override default container args on mysql Primary container(s) (useful when using custom images)                                                                                                                                                       | `[]`             |
| `passwordUpdateJob.extraCommands`                                     | Extra commands to pass to the generation job                                                                                                                                                                                                          | `""`             |
| `passwordUpdateJob.previousPasswords.rootPassword`                    | Previous root password (set if the password secret was already changed)                                                                                                                                                                               | `""`             |
| `passwordUpdateJob.previousPasswords.password`                        | Previous password (set if the password secret was already changed)                                                                                                                                                                                    | `""`             |
| `passwordUpdateJob.previousPasswords.replicationPassword`             | Previous replication password (set if the password secret was already changed)                                                                                                                                                                        | `""`             |
| `passwordUpdateJob.previousPasswords.existingSecret`                  | Name of a secret containing the previous passwords (set if the password secret was already changed)                                                                                                                                                   | `""`             |
| `passwordUpdateJob.containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                                                                                                                                                                  | `true`           |
| `passwordUpdateJob.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                                                      | `{}`             |
| `passwordUpdateJob.containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                                                                                                                                            | `1001`           |
| `passwordUpdateJob.containerSecurityContext.runAsGroup`               | Set containers' Security Context runAsGroup                                                                                                                                                                                                           | `1001`           |
| `passwordUpdateJob.containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                                                                                                                                                         | `true`           |
| `passwordUpdateJob.containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                                                                                                                                                           | `false`          |
| `passwordUpdateJob.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                                                               | `true`           |
| `passwordUpdateJob.containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                                                                                                                                             | `false`          |
| `passwordUpdateJob.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                                                    | `["ALL"]`        |
| `passwordUpdateJob.containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                                                      | `RuntimeDefault` |
| `passwordUpdateJob.podSecurityContext.enabled`                        | Enabled credential init job pods' Security Context                                                                                                                                                                                                    | `true`           |
| `passwordUpdateJob.podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                                                    | `Always`         |
| `passwordUpdateJob.podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                                                        | `[]`             |
| `passwordUpdateJob.podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                                                           | `[]`             |
| `passwordUpdateJob.podSecurityContext.fsGroup`                        | Set credential init job pod's Security Context fsGroup                                                                                                                                                                                                | `1001`           |
| `passwordUpdateJob.extraEnvVars`                                      | Array containing extra env vars to configure the credential init job                                                                                                                                                                                  | `[]`             |
| `passwordUpdateJob.extraEnvVarsCM`                                    | ConfigMap containing extra env vars to configure the credential init job                                                                                                                                                                              | `""`             |
| `passwordUpdateJob.extraEnvVarsSecret`                                | Secret containing extra env vars to configure the credential init job (in case of sensitive data)                                                                                                                                                     | `""`             |
| `passwordUpdateJob.extraVolumes`                                      | Optionally specify extra list of additional volumes for the credential init job                                                                                                                                                                       | `[]`             |
| `passwordUpdateJob.extraVolumeMounts`                                 | Array of extra volume mounts to be added to the jwt Container (evaluated as template). Normally used with `extraVolumes`.                                                                                                                             | `[]`             |
| `passwordUpdateJob.initContainers`                                    | Add additional init containers for the mysql Primary pod(s)                                                                                                                                                                                           | `[]`             |
| `passwordUpdateJob.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if passwordUpdateJob.resources is set (passwordUpdateJob.resources is recommended for production). | `micro`          |
| `passwordUpdateJob.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                                     | `{}`             |
| `passwordUpdateJob.customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                                                                                                                                                   | `{}`             |
| `passwordUpdateJob.customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                                                                                                                                                                  | `{}`             |
| `passwordUpdateJob.customStartupProbe`                                | Custom startupProbe that overrides the default one                                                                                                                                                                                                    | `{}`             |
| `passwordUpdateJob.automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                                                    | `false`          |
| `passwordUpdateJob.hostAliases`                                       | Add deployment host aliases                                                                                                                                                                                                                           | `[]`             |
| `passwordUpdateJob.annotations`                                       | Add annotations to the job                                                                                                                                                                                                                            | `{}`             |
| `passwordUpdateJob.podLabels`                                         | Additional pod labels                                                                                                                                                                                                                                 | `{}`             |
| `passwordUpdateJob.podAnnotations`                                    | Additional pod annotations                                                                                                                                                                                                                            | `{}`             |

### Volume Permissions parameters

| Name                                  | Description                                                                                                                                                                                                                                           | Value                      |
| ------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------- |
| `volumePermissions.enabled`           | Enable init container that changes the owner and group of the persistent volume(s) mountpoint to `runAsUser:fsGroup`                                                                                                                                  | `false`                    |
| `volumePermissions.image.registry`    | Init container volume-permissions image registry                                                                                                                                                                                                      | `REGISTRY_NAME`            |
| `volumePermissions.image.repository`  | Init container volume-permissions image repository                                                                                                                                                                                                    | `REPOSITORY_NAME/os-shell` |
| `volumePermissions.image.digest`      | Init container volume-permissions image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                     | `""`                       |
| `volumePermissions.image.pullPolicy`  | Init container volume-permissions image pull policy                                                                                                                                                                                                   | `IfNotPresent`             |
| `volumePermissions.image.pullSecrets` | Specify docker-registry secret names as an array                                                                                                                                                                                                      | `[]`                       |
| `volumePermissions.resourcesPreset`   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if volumePermissions.resources is set (volumePermissions.resources is recommended for production). | `nano`                     |
| `volumePermissions.resources`         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                                     | `{}`                       |

### Metrics parameters

| Name                                                        | Description                                                                                                                                                                                                                       | Value                             |
| ----------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------- |
| `metrics.enabled`                                           | Start a side-car prometheus exporter                                                                                                                                                                                              | `false`                           |
| `metrics.image.registry`                                    | Exporter image registry                                                                                                                                                                                                           | `REGISTRY_NAME`                   |
| `metrics.image.repository`                                  | Exporter image repository                                                                                                                                                                                                         | `REPOSITORY_NAME/mysqld-exporter` |
| `metrics.image.digest`                                      | Exporter image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                          | `""`                              |
| `metrics.image.pullPolicy`                                  | Exporter image pull policy                                                                                                                                                                                                        | `IfNotPresent`                    |
| `metrics.image.pullSecrets`                                 | Specify docker-registry secret names as an array                                                                                                                                                                                  | `[]`                              |
| `metrics.containerSecurityContext.enabled`                  | MySQL metrics container securityContext                                                                                                                                                                                           | `true`                            |
| `metrics.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                                  | `{}`                              |
| `metrics.containerSecurityContext.runAsUser`                | User ID for the MySQL metrics container                                                                                                                                                                                           | `1001`                            |
| `metrics.containerSecurityContext.runAsGroup`               | Group ID for the MySQL metrics container                                                                                                                                                                                          | `1001`                            |
| `metrics.containerSecurityContext.runAsNonRoot`             | Set MySQL metrics container's Security Context runAsNonRoot                                                                                                                                                                       | `true`                            |
| `metrics.containerSecurityContext.allowPrivilegeEscalation` | Set container's privilege escalation                                                                                                                                                                                              | `false`                           |
| `metrics.containerSecurityContext.capabilities.drop`        | Set container's Security Context runAsNonRoot                                                                                                                                                                                     | `["ALL"]`                         |
| `metrics.containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                                  | `RuntimeDefault`                  |
| `metrics.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context read-only root filesystem                                                                                                                                                                        | `true`                            |
| `metrics.containerPorts.http`                               | Container port for http                                                                                                                                                                                                           | `9104`                            |
| `metrics.service.type`                                      | Kubernetes service type for MySQL Prometheus Exporter                                                                                                                                                                             | `ClusterIP`                       |
| `metrics.service.clusterIP`                                 | Kubernetes service clusterIP for MySQL Prometheus Exporter                                                                                                                                                                        | `""`                              |
| `metrics.service.port`                                      | MySQL Prometheus Exporter service port                                                                                                                                                                                            | `9104`                            |
| `metrics.service.annotations`                               | Prometheus exporter service annotations                                                                                                                                                                                           | `{}`                              |
| `metrics.extraArgs.primary`                                 | Extra args to be passed to mysqld_exporter on Primary pods                                                                                                                                                                        | `[]`                              |
| `metrics.extraArgs.secondary`                               | Extra args to be passed to mysqld_exporter on Secondary pods                                                                                                                                                                      | `[]`                              |
| `metrics.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if metrics.resources is set (metrics.resources is recommended for production). | `nano`                            |
| `metrics.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                 | `{}`                              |
| `metrics.livenessProbe.enabled`                             | Enable livenessProbe                                                                                                                                                                                                              | `true`                            |
| `metrics.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                                           | `120`                             |
| `metrics.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                                  | `10`                              |
| `metrics.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                                 | `1`                               |
| `metrics.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                                               | `3`                               |
| `metrics.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                                               | `1`                               |
| `metrics.readinessProbe.enabled`                            | Enable readinessProbe                                                                                                                                                                                                             | `true`                            |
| `metrics.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                                          | `30`                              |
| `metrics.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                                 | `10`                              |
| `metrics.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                                | `1`                               |
| `metrics.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                                              | `3`                               |
| `metrics.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                                              | `1`                               |
| `metrics.serviceMonitor.enabled`                            | Create ServiceMonitor Resource for scraping metrics using PrometheusOperator                                                                                                                                                      | `false`                           |
| `metrics.serviceMonitor.namespace`                          | Specify the namespace in which the serviceMonitor resource will be created                                                                                                                                                        | `""`                              |
| `metrics.serviceMonitor.jobLabel`                           | The name of the label on the target service to use as the job name in prometheus.                                                                                                                                                 | `""`                              |
| `metrics.serviceMonitor.interval`                           | Specify the interval at which metrics should be scraped                                                                                                                                                                           | `30s`                             |
| `metrics.serviceMonitor.scrapeTimeout`                      | Specify the timeout after which the scrape is ended                                                                                                                                                                               | `""`                              |
| `metrics.serviceMonitor.relabelings`                        | RelabelConfigs to apply to samples before scraping                                                                                                                                                                                | `[]`                              |
| `metrics.serviceMonitor.metricRelabelings`                  | MetricRelabelConfigs to apply to samples before ingestion                                                                                                                                                                         | `[]`                              |
| `metrics.serviceMonitor.selector`                           | ServiceMonitor selector labels                                                                                                                                                                                                    | `{}`                              |
| `metrics.serviceMonitor.honorLabels`                        | Specify honorLabels parameter to add the scrape endpoint                                                                                                                                                                          | `false`                           |
| `metrics.serviceMonitor.labels`                             | Used to pass Labels that are used by the Prometheus installed in your cluster to select Service Monitors to work with                                                                                                             | `{}`                              |
| `metrics.serviceMonitor.annotations`                        | ServiceMonitor annotations                                                                                                                                                                                                        | `{}`                              |
| `metrics.prometheusRule.enabled`                            | Creates a Prometheus Operator prometheusRule (also requires `metrics.enabled` to be `true` and `metrics.prometheusRule.rules`)                                                                                                    | `false`                           |
| `metrics.prometheusRule.namespace`                          | Namespace for the prometheusRule Resource (defaults to the Release Namespace)                                                                                                                                                     | `""`                              |
| `metrics.prometheusRule.additionalLabels`                   | Additional labels that can be used so prometheusRule will be discovered by Prometheus                                                                                                                                             | `{}`                              |
| `metrics.prometheusRule.rules`                              | Prometheus Rule definitions                                                                                                                                                                                                       | `[]`                              |

The above parameters map to the env variables defined in [bitnami/mysql](https://github.com/bitnami/containers/tree/main/bitnami/mysql). For more information please refer to the [bitnami/mysql](https://github.com/bitnami/containers/tree/main/bitnami/mysql) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
  --set auth.rootPassword=secretpassword,auth.database=app_database \
    oci://REGISTRY_NAME/REPOSITORY_NAME/mysql
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The above command sets the MySQL `root` account password to `secretpassword`. Additionally it creates a database named `app_database`.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml oci://REGISTRY_NAME/REPOSITORY_NAME/mysql
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.
> **Tip**: You can use the default [values.yaml](https://github.com/bitnami/charts/tree/main/bitnami/mysql/values.yaml)

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 12.2.0

This version introduces image verification for security purposes. To disable it, set `global.security.allowInsecureImages` to `true`. More details at [GitHub issue](https://github.com/bitnami/charts/issues/30850).

It's necessary to set the `auth.rootPassword` parameter when upgrading for readiness/liveness probes to work properly. When you install this chart for the first time, some notes will be displayed providing the credentials you must use under the 'Administrator credentials' section. Please note down the password and run the command below to upgrade your chart:

```console
helm upgrade my-release oci://REGISTRY_NAME/REPOSITORY_NAME/mysql --set auth.rootPassword=[ROOT_PASSWORD]
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

| Note: you need to substitute the placeholder _[ROOT_PASSWORD]_ with the value obtained in the installation notes.

### To 12.0.0

This major bump updates the StatefulSet objects `serviceName` to use a headless service, as the current non-headless service attached to it was not providing DNS entries. This will cause an upgrade issue because it changes "immutable fields". To workaround it, delete the StatefulSet objects as follows (replace the RELEASE_NAME placeholder):

```shell

# If architecture = "standalone"
kubectl delete sts RELEASE_NAME --cascade=false

# If architecture = "replication"
kubectl delete sts RELEASE_NAME-primary --cascade=false
kubectl delete sts RELEASE_NAME-secondary --cascade=false
```

Then execute `helm upgrade` as usual.

Additionally, this new major provides a new, optional, password update job for automating this second-day operation in the chart. See the [Update credential](#automated-update-using-a-password-update-job) for detailed instructions.

### To 11.0.0

This major bump uses mysql `8.4` image, that includes several [removal of deprecated](https://dev.mysql.com/doc/relnotes/mysql/8.4/en/news-8-4-0.html#mysqld-8-4-0-deprecation-removal) configuration settings, for example the parameter `auth.defaultAuthenticationPlugin` has been removed in favor of `auth.authenticationPolicy`. This could potentially break your deployment and you would need to adjust the config settings accordingly.

### To 10.0.0

This major bump changes the following security defaults:

- `runAsGroup` is changed from `0` to `1001`
- `readOnlyRootFilesystem` is set to `true`
- `resourcesPreset` is changed from `none` to the minimum size working in our test suites (NOTE: `resourcesPreset` is not meant for production usage, but `resources` adapted to your use case).
- `global.compatibility.openshift.adaptSecurityContext` is changed from `disabled` to `auto`.

This could potentially break any customization or init scripts used in your deployment. If this is the case, change the default values to the previous ones.

### To 9.0.0

This major release renames several values in this chart and adds missing features, in order to be aligned with the rest of the assets in the Bitnami charts repository.

Affected values:

- `schedulerName` was renamed as `primary.schedulerName` and `secondary.schedulerName`.
- The way how passwords are handled has been refactored and value `auth.forcePassword` has been removed. Now, the password configuration will have the following priority:
  1. Search for an already existing 'Secret' resource and reuse previous password.
  2. Password provided via the values.yaml
  3. If no secret existed, and no password was provided, the bitnami/mysql chart will set a randomly generated password.
- `primary.service.port` was renamed as `primary.service.ports.mysql`.
- `secondary.service.port` was renamed as `secondary.service.ports.mysql`.
- `primary.service.nodePort` was renamed as `primary.service.nodePorts.mysql`.
- `secondary.service.nodePort` was renamed as `secondary.service.nodePorts.mysql`.
- `primary.updateStrategy` and `secondary.updateStrategy` are now interpreted as an object and not a string.
- Values `primary.rollingUpdatePartition` and `secondary.rollingUpdatePartition` have been removed. In cases were they are needed, they can be set inside `.*updateStrategy`.
- `primary.pdb.enabled` was renamed as `primary.pdb.create`.
- `secondary.pdb.enabled` was renamed as `secondary.pdb.create`.
- `metrics.serviceMonitor.additionalLabels` was renamed as `metrics.serviceMonitor.labels`
- `metrics.serviceMonitor.relabellings` was removed, previously used to configured `metricRelabelings` field. We introduced two new values: `metrics.serviceMonitor.relabelings` and `metrics.serviceMonitor.metricRelabelings` that can be used to configured the serviceMonitor homonimous field.

### To 8.0.0

- Several parameters were renamed or disappeared in favor of new ones on this major version:
  - The terms _master_ and _slave_ have been replaced by the terms _primary_ and _secondary_. Therefore, parameters prefixed with `master` or `slave` are now prefixed with `primary` or `secondary`, respectively.
  - Credentials parameters are reorganized under the `auth` parameter.
  - `replication.enabled` parameter is deprecated in favor of `architecture` parameter that accepts two values: `standalone` and `replication`.
- Chart labels were adapted to follow the [Helm charts standard labels](https://helm.sh/docs/chart_best_practices/labels/#standard-labels).
- This version also introduces `bitnami/common`, a [library chart](https://helm.sh/docs/topics/library_charts/#helm) as a dependency. More documentation about this new utility could be found [here](https://github.com/bitnami/charts/tree/main/bitnami/common#bitnami-common-library-chart). Please, make sure that you have updated the chart dependencies before executing any upgrade.

Consequences:

- Backwards compatibility is not guaranteed. To upgrade to `8.0.0`, install a new release of the MySQL chart, and migrate the data from your previous release. You have 2 alternatives to do so:
  - Create a backup of the database, and restore it on the new release using tools such as [mysqldump](https://dev.mysql.com/doc/refman/8.0/en/mysqldump.html).
  - Reuse the PVC used to hold the master data on your previous release. To do so, use the `primary.persistence.existingClaim` parameter. The following example assumes that the release name is `mysql`:

```console
helm install mysql oci://REGISTRY_NAME/REPOSITORY_NAME/mysql --set auth.rootPassword=[ROOT_PASSWORD] --set primary.persistence.existingClaim=[EXISTING_PVC]
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

| Note: you need to substitute the placeholder _[EXISTING_PVC]_ with the name of the PVC used on your previous release, and _[ROOT_PASSWORD]_ with the root password used in your previous release.

### To 7.0.0

[On November 13, 2020, Helm v2 support formally ended](https://github.com/helm/charts#status-of-the-project). This major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

### To 3.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 3.0.0. The following example assumes that the release name is mysql:

```console
kubectl delete statefulset mysql-master --cascade=false
kubectl delete statefulset mysql-slave --cascade=false
```

## License

Copyright &copy; 2025 Broadcom. The term "Broadcom" refers to Broadcom Inc. and/or its subsidiaries.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

<http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.