<!--- app-name: MariaDB -->

# Bitnami package for MariaDB

MariaDB is an open source, community-developed SQL database server that is widely in use around the world due to its enterprise features, flexibility, and collaboration with leading tech firms.

[Overview of MariaDB](https://mariadb.org/)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/mariadb
```

Looking to use MariaDB in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the commercial edition of the Bitnami catalog.

## Introduction

This chart bootstraps a [MariaDB](https://github.com/bitnami/containers/tree/main/bitnami/mariadb) replication cluster deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

MariaDB is developed as open source software and as a relational database it provides an SQL interface for accessing data. The latest versions of MariaDB also include GIS and JSON features.

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/mariadb
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The command deploys MariaDB on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

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

### Change MariaDB version

To modify the MariaDB version used in this chart you can specify a [valid image tag](https://hub.docker.com/r/bitnami/mariadb/tags/) using the `image.tag` parameter. For example, `image.tag=X.Y.Z`. This approach is also applicable to other images like exporters.

### Update credentials

Bitnami charts, with its default settings, configure credentials at first boot. Any further change in the secrets or credentials can be done using one of the following methods:

### Manual update of the passwords and secrets

- Update the user password following [the upstream documentation](https://milvus.io/docs/authenticate.md#Update-user-password)
- Update the password secret with the new values (replace the SECRET_NAME, PASSWORD and ROOT_PASSWORD placeholders)

```shell
kubectl create secret generic SECRET_NAME --from-literal=password=PASSWORD --from-literal=root-password=ROOT_PASSWORD --dry-run -o yaml | kubectl apply -f -
```

### Automated update using a password update job

The Bitnami MariaDB provides a password update job that will automatically change the MariaDB passwords when running helm upgrade. To enable the job set `passwordUpdateJob.enabled=true`. This job requires:

- The new passwords: this is configured using either `auth.rootPassword`, `auth.password` and `auth.replicationPassword` (if applicable) or setting `auth.existingSecret`.
- The previous passwords: This value is taken automatically from already deployed secret object. If you are using `auth.existingSecret` or `helm template` instead of `helm upgrade`, then set either `passwordUpdate.job.previousPasswords.rootPassword`, `passwordUpdate.job.previousPasswords.password`, `passwordUpdate.job.previousPasswords.replicationPassword` (when applicable), setting `auth.existingSecret`.

In the following example we update the password via values.yaml in a mariadb installation with replication

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

### Initialize a fresh instance

The [Bitnami MariaDB](https://github.com/bitnami/containers/tree/main/bitnami/mariadb) image allows you to use your custom scripts to initialize a fresh instance. Custom scripts may be specified using the `initdbScripts` parameter. Alternatively, an external ConfigMap may be created with all the initialization scripts and the ConfigMap passed to the chart via the `initdbScriptsConfigMap` parameter. Note that this will override the `initdbScripts` parameter.

The allowed extensions are `.sh`, `.sql` and `.sql.gz`.

These scripts are treated differently depending on their extension. While `.sh` scripts are executed on all the nodes, `.sql` and `.sql.gz` scripts are only executed on the primary nodes. This is because `.sh` scripts support conditional tests to identify the type of node they are running on, while such tests are not supported in `.sql` or `.sql.gz` files.

When using a `.sh` script, you may wish to perform a "one-time" action like creating a database. This can be achieved by adding a condition in the script to ensure that it is executed only on one node, as shown in the example below:

```yaml
initdbScripts:
  my_init_script.sh: |
    #!/bin/sh
    if [[ $(hostname) == *primary* ]]; then
      echo "Primary node"
      mysql -P 3306 -uroot -prandompassword -e "create database new_database";
    else
      echo "No primary node"
    fi
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

### Securing data at rest using Transparent Data Encryption

This chart supports encrypting data at rest using Transparent Data Encryption (TDE). To enable this feature, set the `tde.enabled`.

The chart supports two different ways to enable TDE:

- Using Kubernetes secret to store the encryption keys. Enable this feature by setting `tde.enabled` to `true` and `tde.existingSecret` to the name of the secret containing the random key and the encrypted TDE key.
- Using the Secrets Store CSI Driver to store the encryption keys. Enable this feature by setting `tde.enabled` to `true` and `tde.secretsStoreProvider.enabled` to `true`. Currently only the `vault` provider is supported and requires further parameters to be set for secret keys and paths to the encryption keys.

To simplify the configuration the chart defaults most configuration values for TDE and [file key management encryption plugin](https://mariadb.com/kb/en/file-key-management-encryption-plugin/). For more information, on creating the required keys to enable TDE please refer to the mariaDB blog post [here](https://mariadb.com/resources/blog/mariadb-encryption-tde-using-mariadbs-file-key-management-encryption-plugin/).  

> NOTE: The `tde.enabled` parameter impacts recoverability of the MariaDB data. If you enable TDE, the MariaDB data cannot be recovered if your encryption keys are lost. Always backup your encryption keys and store in a secure location outside of the cluster.

#### Using Kubernetes secret to store the encryption keys

To enable TDE using Kubernetes secret, create a secret containing the random key and the encrypted TDE key.

```console
kubectl create secret generic mariadb-tde-secret --namespace=mariadb \
  --from-file=./mariadb/encryption/keyfile.key \
  --from-file=./mariadb/encryption/keyfile.enc
```

#### Using the Secrets Store CSI Driver to store the encryption keys in Hashicorp Vault

To enable TDE using the Secrets Store CSI Driver, create a secret containing the random key and the encrypted TDE key.  When using the Secrets Store CSI Driver, the `tde.secretsStoreProvider.vault` parameters should be configured. Secrets in Hashicorp Vault are used to store the random key and the encrypted TDE key. The key files must be stored as base64 encoded values.

```console
export KEYFILE_KEY=$(cat ./mariadb/encryption/keyfile.key|base64)
export KEYFILE_ENC=$(cat ./mariadb/encryption/keyfile.enc|base64)

vault kv put secrets-kv/keyfile key="$KEYFILE_KEY" enc="$KEYFILE_ENC"
```

The `SecretProviderClass` for `vault` at minimum requires the `tde.secretsStoreProvider.vault.roleName`, `tde.secretsStoreProvider.vault.*KeySecretPath` and `tde.secretsStoreProvider.vault.*SecretKey` parameters to be set for the secret values to properly be mounted.

>NOTE: This guide does not include configuration for the Secrets Store CSI Driver or Hashicorp Vault provider which are prerequisites for enabling TDE with the Secrets Store CSI Driver.  

### Sidecars and Init Containers

If additional containers are needed in the same pod as MariaDB (such as additional metrics or logging exporters), they can be defined using the `sidecars` parameter.

```yaml
sidecars:
- name: your-image-name
  image: your-image
  imagePullPolicy: Always
  ports:
  - name: portname
    containerPort: 1234
```

If these sidecars export extra ports, extra port definitions can be added using the `service.extraPorts` parameter (where available), as shown in the example below:

```yaml
service:
  extraPorts:
  - name: extraPort
    port: 11311
    targetPort: 11311
```

> NOTE: This Helm chart already includes sidecar containers for the Prometheus exporters (where applicable). These can be activated by adding the `--enable-metrics=true` parameter at deployment time. The `sidecars` parameter should therefore only be used for any extra sidecar containers.

If additional init containers are needed in the same pod, they can be defined using the `initContainers` parameter. Here is an example:

```yaml
initContainers:
  - name: your-image-name
    image: your-image
    imagePullPolicy: Always
    ports:
      - name: portname
        containerPort: 1234
```

Learn more about [sidecar containers](https://kubernetes.io/docs/concepts/workloads/pods/) and [init containers](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/).

### Backup and restore

To back up and restore Helm chart deployments on Kubernetes, you need to back up the persistent volumes from the source deployment and attach them to a new deployment using [Velero](https://velero.io/), a Kubernetes backup/restore tool. Find the instructions for using Velero in [this guide](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-backup-restore-deployments-velero-index.html).

## Persistence

The [Bitnami MariaDB](https://github.com/bitnami/containers/tree/main/bitnami/mariadb) image stores the MariaDB data and configurations at the `/bitnami/mariadb` path of the container.

The chart mounts a [Persistent Volume](https://kubernetes.io/docs/concepts/storage/persistent-volumes/) volume at this location. The volume is created using dynamic volume provisioning, by default. An existing PersistentVolumeClaim can also be defined.

If you encounter errors when working with persistent volumes, refer to our [troubleshooting guide for persistent volumes](https://docs.bitnami.com/kubernetes/faq/troubleshooting/troubleshooting-persistence-volumes/).

### Adjust permissions of persistent volume mountpoint

As the image run as non-root by default, it is necessary to adjust the ownership of the persistent volume so that the container can write data into it.

By default, the chart is configured to use Kubernetes Security Context to automatically change the ownership of the volume. However, this feature does not work in all Kubernetes distributions.

As an alternative, this chart supports using an initContainer to change the ownership of the volume before mounting it in the final destination. You can enable this initContainer by setting `volumePermissions.enabled` to `true`.

## Parameters

### Global parameters

| Name                                                  | Description                                                                                                                                                                                                                                                                                                                                                         | Value   |
| ----------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `global.imageRegistry`                                | Global Docker Image registry                                                                                                                                                                                                                                                                                                                                        | `""`    |
| `global.imagePullSecrets`                             | Global Docker registry secret names as an array                                                                                                                                                                                                                                                                                                                     | `[]`    |
| `global.defaultStorageClass`                          | Global default StorageClass for Persistent Volume(s)                                                                                                                                                                                                                                                                                                                | `""`    |
| `global.security.allowInsecureImages`                 | Allows skipping image verification                                                                                                                                                                                                                                                                                                                                  | `false` |
| `global.compatibility.openshift.adaptSecurityContext` | Adapt the securityContext sections of the deployment to make them compatible with Openshift restricted-v2 SCC: remove runAsUser, runAsGroup and fsGroup and let the platform use their allowed default IDs. Possible values: auto (apply if the detected running cluster is Openshift), force (perform the adaptation always), disabled (do not perform adaptation) | `auto`  |

### Common parameters

| Name                      | Description                                                                             | Value           |
| ------------------------- | --------------------------------------------------------------------------------------- | --------------- |
| `kubeVersion`             | Force target Kubernetes version (using Helm capabilities if not set)                    | `""`            |
| `nameOverride`            | String to partially override mariadb.fullname                                           | `""`            |
| `fullnameOverride`        | String to fully override mariadb.fullname                                               | `""`            |
| `clusterDomain`           | Default Kubernetes cluster domain                                                       | `cluster.local` |
| `commonAnnotations`       | Common annotations to add to all MariaDB resources (sub-charts are not considered)      | `{}`            |
| `commonLabels`            | Common labels to add to all MariaDB resources (sub-charts are not considered)           | `{}`            |
| `schedulerName`           | Name of the scheduler (other than default) to dispatch pods                             | `""`            |
| `runtimeClassName`        | Name of the Runtime Class for all MariaDB pods                                          | `""`            |
| `extraDeploy`             | Array of extra objects to deploy with the release (evaluated as a template)             | `[]`            |
| `diagnosticMode.enabled`  | Enable diagnostic mode (all probes will be disabled and the command will be overridden) | `false`         |
| `diagnosticMode.command`  | Command to override all containers in the deployment                                    | `["sleep"]`     |
| `diagnosticMode.args`     | Args to override all containers in the deployment                                       | `["infinity"]`  |
| `serviceBindings.enabled` | Create secret for service binding (Experimental)                                        | `false`         |

### MariaDB common parameters

| Name                       | Description                                                                                                                                                                                                                                                                   | Value                     |
| -------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------- |
| `image.registry`           | MariaDB image registry                                                                                                                                                                                                                                                        | `REGISTRY_NAME`           |
| `image.repository`         | MariaDB image repository                                                                                                                                                                                                                                                      | `REPOSITORY_NAME/mariadb` |
| `image.digest`             | MariaDB image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                                                                       | `""`                      |
| `image.pullPolicy`         | MariaDB image pull policy                                                                                                                                                                                                                                                     | `IfNotPresent`            |
| `image.pullSecrets`        | Specify docker-registry secret names as an array                                                                                                                                                                                                                              | `[]`                      |
| `image.debug`              | Specify if debug logs should be enabled                                                                                                                                                                                                                                       | `false`                   |
| `architecture`             | MariaDB architecture (`standalone` or `replication`)                                                                                                                                                                                                                          | `standalone`              |
| `auth.rootPassword`        | Password for the `root` user. Ignored if existing secret is provided.                                                                                                                                                                                                         | `""`                      |
| `auth.database`            | Name for a custom database to create                                                                                                                                                                                                                                          | `my_database`             |
| `auth.username`            | Name for a custom user to create                                                                                                                                                                                                                                              | `""`                      |
| `auth.password`            | Password for the new user. Ignored if existing secret is provided                                                                                                                                                                                                             | `""`                      |
| `auth.replicationUser`     | MariaDB replication user                                                                                                                                                                                                                                                      | `replicator`              |
| `auth.replicationPassword` | MariaDB replication user password. Ignored if existing secret is provided                                                                                                                                                                                                     | `""`                      |
| `auth.existingSecret`      | Use existing secret for password details (`auth.rootPassword`, `auth.password`, `auth.replicationPassword` will be ignored and picked up from this secret). The secret has to contain the keys `mariadb-root-password`, `mariadb-replication-password` and `mariadb-password` | `""`                      |
| `auth.forcePassword`       | Force users to specify required passwords                                                                                                                                                                                                                                     | `false`                   |
| `auth.usePasswordFiles`    | Mount credentials as files instead of using environment variables                                                                                                                                                                                                             | `true`                    |
| `auth.customPasswordFiles` | Use custom password files when `auth.usePasswordFiles` is set to `true`. Define path for keys `root` and `user`, also define `replicator` if `architecture` is set to `replication`                                                                                           | `{}`                      |
| `initdbScripts`            | Dictionary of initdb scripts                                                                                                                                                                                                                                                  | `{}`                      |
| `initdbScriptsConfigMap`   | ConfigMap with the initdb scripts (Note: Overrides `initdbScripts`)                                                                                                                                                                                                           | `""`                      |

### TLS/SSL parameters

| Name                                               | Description                                                                                            | Value     |
| -------------------------------------------------- | ------------------------------------------------------------------------------------------------------ | --------- |
| `tls.enabled`                                      | Enable TLS in MariaDB                                                                                  | `false`   |
| `tls.existingSecret`                               | Existing secret that contains TLS certificates                                                         | `""`      |
| `tls.certFilename`                                 | The secret key from the existingSecret if 'cert' key different from the default (tls.crt)              | `tls.crt` |
| `tls.certKeyFilename`                              | The secret key from the existingSecret if 'key' key different from the default (tls.key)               | `tls.key` |
| `tls.certCAFilename`                               | The secret key from the existingSecret if 'ca' key different from the default (tls.crt)                | `""`      |
| `tls.ca`                                           | CA certificate for TLS. Ignored if `tls.existingSecret` is set                                         | `""`      |
| `tls.cert`                                         | TLS certificate. Ignored if `tls.master.existingSecret` is set                                         | `""`      |
| `tls.key`                                          | TLS key. Ignored if `tls.master.existingSecret` is set                                                 | `""`      |
| `tls.autoGenerated.enabled`                        | Enable automatic generation of certificates for TLS                                                    | `true`    |
| `tls.autoGenerated.engine`                         | Mechanism to generate the certificates (allowed values: helm, cert-manager)                            | `helm`    |
| `tls.autoGenerated.certManager.existingIssuer`     | The name of an existing Issuer to use for generating the certificates (only for `cert-manager` engine) | `""`      |
| `tls.autoGenerated.certManager.existingIssuerKind` | Existing Issuer kind, defaults to Issuer (only for `cert-manager` engine)                              | `""`      |
| `tls.autoGenerated.certManager.keyAlgorithm`       | Key algorithm for the certificates (only for `cert-manager` engine)                                    | `RSA`     |
| `tls.autoGenerated.certManager.keySize`            | Key size for the certificates (only for `cert-manager` engine)                                         | `2048`    |
| `tls.autoGenerated.certManager.duration`           | Duration for the certificates (only for `cert-manager` engine)                                         | `2160h`   |
| `tls.autoGenerated.certManager.renewBefore`        | Renewal period for the certificates (only for `cert-manager` engine)                                   | `360h`    |

### Transparent Data Encryption parameters

| Name                                                    | Description                                                                                                                                                          | Value         |
| ------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------- |
| `tde.enabled`                                           | Enable Transparent Data Encryption using the File Key Management Encryption Plugin for MariaDB                                                                       | `false`       |
| `tde.existingSecret`                                    | Existing secret that contains Transparent Data Encryption key files used when secretsStoreProvider is not enabled                                                    | `""`          |
| `tde.randomKeyFilename`                                 | File name of the 'random keyfile' when it is different from the default (keyfile.key), is also used for key name in the existingSecret                               | `keyfile.key` |
| `tde.encryptedKeyFilename`                              | File name of the 'encrypted keyfile' when it is different from the default (keyfile.enc), is also used for key name in the existingSecret                            | `keyfile.enc` |
| `tde.fileKeyManagementEncryptionAlgorithm`              | Encryption algorithm used for encrypting data (allowed values: AES_CTR, AES_CBC | default: AES_CTR)                                                                  | `AES_CTR`     |
| `tde.innodbEncryptTables`                               | Enables automatic encryption of all InnoDB tablespaces (allowed values: FORCE, ON, OFF | default: FORCE)                                                             | `FORCE`       |
| `tde.innodbEncryptLog`                                  | Enables encryption of the InnoDB redo log (allowed values: ON, OFF | default: ON)                                                                                    | `ON`          |
| `tde.innodbEncryptTemporaryTables`                      | Enables automatic encryption of the InnoDB temporary tablespace (allowed values: ON, OFF | default: ON)                                                              | `ON`          |
| `tde.innodbEncryptionThreads`                           | Number of threads to use for encryption (default: 4)                                                                                                                 | `4`           |
| `tde.encryptTmpDiskTables`                              | Enables automatic encryption of all internal on-disk temporary tables that are created during query execution (allowed values: ON, OFF | default: ON)                | `ON`          |
| `tde.encryptTmpTiles`                                   | Enables automatic encryption of temporary files, such as those created for filesort operations, binary log file caches, etc. (allowed values: ON, OFF | default: ON) | `ON`          |
| `tde.encryptBINLOG`                                     | Enables encrypting binary logs including relay logs (allowed values: ON, OFF | default: ON)                                                                          | `ON`          |
| `tde.ariaEncryptTables`                                 | Enables automatic encryption of all Aria tablespaces (allowed values: ON, OFF | default: ON)                                                                         | `ON`          |
| `tde.secretsStoreProvider.enabled`                      | Enable use of secrets store provider for Transparent Data Encryption key files                                                                                       | `false`       |
| `tde.secretsStoreProvider.provider`                     | Type of provider used in secrets store provider class (allowed values: vault)                                                                                        | `vault`       |
| `tde.secretsStoreProvider.vault.roleName`               | The name of the HashiCorp Vault role used for accessing the key files (only for `vault` provider)                                                                    | `""`          |
| `tde.secretsStoreProvider.vault.address`                | The URL of the HashiCorp Vault server (only for `vault` provider)                                                                                                    | `""`          |
| `tde.secretsStoreProvider.vault.authMountPath`          | The HashiCorp Vault auth mount path (only for `vault` provider)                                                                                                      | `""`          |
| `tde.secretsStoreProvider.vault.randomKeySecretPath`    | The HashiCorp Vault secret path for the 'random keyfile' (only for `vault` provider)                                                                                 | `""`          |
| `tde.secretsStoreProvider.vault.randomKeySecretKey`     | The HashiCorp Vault secret key for the 'random keyfile' (only for `vault` provider)                                                                                  | `""`          |
| `tde.secretsStoreProvider.vault.encryptedKeySecretPath` | The HashiCorp Vault secret path for the 'encrypted keyfile' (only for `vault` provider)                                                                              | `""`          |
| `tde.secretsStoreProvider.vault.encryptedKeySecretKey`  | The HashiCorp Vault secret key for the 'encrypted keyfile' (only for `vault` provider)                                                                               | `""`          |

### MariaDB Primary parameters

| Name                                                        | Description                                                                                                                                                                                                                       | Value               |
| ----------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------- |
| `primary.name`                                              | Name of the primary database (eg primary, master, leader, ...)                                                                                                                                                                    | `primary`           |
| `primary.command`                                           | Override default container command on MariaDB Primary container(s) (useful when using custom images)                                                                                                                              | `[]`                |
| `primary.args`                                              | Override default container args on MariaDB Primary container(s) (useful when using custom images)                                                                                                                                 | `[]`                |
| `primary.lifecycleHooks`                                    | for the MariaDB Primary container(s) to automate configuration before or after startup                                                                                                                                            | `{}`                |
| `primary.automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                                | `false`             |
| `primary.hostAliases`                                       | Add deployment host aliases                                                                                                                                                                                                       | `[]`                |
| `primary.containerPorts.mysql`                              | Container port for mysql                                                                                                                                                                                                          | `3306`              |
| `primary.configuration`                                     | MariaDB Primary configuration to be injected as ConfigMap                                                                                                                                                                         | `""`                |
| `primary.existingConfigmap`                                 | Name of existing ConfigMap with MariaDB Primary configuration.                                                                                                                                                                    | `""`                |
| `primary.updateStrategy.type`                               | MariaDB primary statefulset strategy type                                                                                                                                                                                         | `RollingUpdate`     |
| `primary.rollingUpdatePartition`                            | Partition update strategy for Mariadb Primary statefulset                                                                                                                                                                         | `""`                |
| `primary.podAnnotations`                                    | Additional pod annotations for MariaDB primary pods                                                                                                                                                                               | `{}`                |
| `primary.podLabels`                                         | Extra labels for MariaDB primary pods                                                                                                                                                                                             | `{}`                |
| `primary.podAffinityPreset`                                 | MariaDB primary pod affinity preset. Ignored if `primary.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                       | `""`                |
| `primary.podAntiAffinityPreset`                             | MariaDB primary pod anti-affinity preset. Ignored if `primary.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                  | `soft`              |
| `primary.nodeAffinityPreset.type`                           | MariaDB primary node affinity preset type. Ignored if `primary.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                 | `""`                |
| `primary.nodeAffinityPreset.key`                            | MariaDB primary node label key to match Ignored if `primary.affinity` is set.                                                                                                                                                     | `""`                |
| `primary.nodeAffinityPreset.values`                         | MariaDB primary node label values to match. Ignored if `primary.affinity` is set.                                                                                                                                                 | `[]`                |
| `primary.affinity`                                          | Affinity for MariaDB primary pods assignment                                                                                                                                                                                      | `{}`                |
| `primary.nodeSelector`                                      | Node labels for MariaDB primary pods assignment                                                                                                                                                                                   | `{}`                |
| `primary.tolerations`                                       | Tolerations for MariaDB primary pods assignment                                                                                                                                                                                   | `[]`                |
| `primary.schedulerName`                                     | Name of the k8s scheduler (other than default)                                                                                                                                                                                    | `""`                |
| `primary.terminationGracePeriodSeconds`                     | In seconds, time the given to the MySQL primary pod needs to terminate gracefully                                                                                                                                                 | `""`                |
| `primary.podManagementPolicy`                               | podManagementPolicy to manage scaling operation of MariaDB primary pods                                                                                                                                                           | `""`                |
| `primary.topologySpreadConstraints`                         | Topology Spread Constraints for MariaDB primary pods assignment                                                                                                                                                                   | `[]`                |
| `primary.priorityClassName`                                 | Priority class for MariaDB primary pods assignment                                                                                                                                                                                | `""`                |
| `primary.runtimeClassName`                                  | Runtime Class for MariaDB primary pods                                                                                                                                                                                            | `""`                |
| `primary.podSecurityContext.enabled`                        | Enable security context for MariaDB primary pods                                                                                                                                                                                  | `true`              |
| `primary.podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                                | `Always`            |
| `primary.podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                                    | `[]`                |
| `primary.podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                                       | `[]`                |
| `primary.podSecurityContext.fsGroup`                        | Group ID for the mounted volumes' filesystem                                                                                                                                                                                      | `1001`              |
| `primary.containerSecurityContext.enabled`                  | MariaDB primary container securityContext                                                                                                                                                                                         | `true`              |
| `primary.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                                  | `{}`                |
| `primary.containerSecurityContext.runAsUser`                | User ID for the MariaDB primary container                                                                                                                                                                                         | `1001`              |
| `primary.containerSecurityContext.runAsGroup`               | Group ID for the MariaDB primary container                                                                                                                                                                                        | `1001`              |
| `primary.containerSecurityContext.runAsNonRoot`             | Set primary container's Security Context runAsNonRoot                                                                                                                                                                             | `true`              |
| `primary.containerSecurityContext.privileged`               | Set primary container's Security Context privileged                                                                                                                                                                               | `false`             |
| `primary.containerSecurityContext.allowPrivilegeEscalation` | Set primary container's Security Context allowPrivilegeEscalation                                                                                                                                                                 | `false`             |
| `primary.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                                           | `true`              |
| `primary.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                                | `["ALL"]`           |
| `primary.containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                                  | `RuntimeDefault`    |
| `primary.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if primary.resources is set (primary.resources is recommended for production). | `small`             |
| `primary.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                 | `{}`                |
| `primary.startupProbe.enabled`                              | Enable startupProbe                                                                                                                                                                                                               | `false`             |
| `primary.startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                                            | `120`               |
| `primary.startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                                   | `15`                |
| `primary.startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                                  | `5`                 |
| `primary.startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                                | `10`                |
| `primary.startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                                | `1`                 |
| `primary.livenessProbe.enabled`                             | Enable livenessProbe                                                                                                                                                                                                              | `true`              |
| `primary.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                                           | `120`               |
| `primary.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                                  | `10`                |
| `primary.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                                 | `1`                 |
| `primary.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                                               | `3`                 |
| `primary.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                                               | `1`                 |
| `primary.readinessProbe.enabled`                            | Enable readinessProbe                                                                                                                                                                                                             | `true`              |
| `primary.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                                          | `30`                |
| `primary.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                                 | `10`                |
| `primary.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                                | `1`                 |
| `primary.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                                              | `3`                 |
| `primary.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                                              | `1`                 |
| `primary.customStartupProbe`                                | Override default startup probe for MariaDB primary containers                                                                                                                                                                     | `{}`                |
| `primary.customLivenessProbe`                               | Override default liveness probe for MariaDB primary containers                                                                                                                                                                    | `{}`                |
| `primary.customReadinessProbe`                              | Override default readiness probe for MariaDB primary containers                                                                                                                                                                   | `{}`                |
| `primary.startupWaitOptions`                                | Override default builtin startup wait check options for MariaDB primary containers                                                                                                                                                | `{}`                |
| `primary.extraFlags`                                        | MariaDB primary additional command line flags                                                                                                                                                                                     | `""`                |
| `primary.extraEnvVars`                                      | Extra environment variables to be set on MariaDB primary containers                                                                                                                                                               | `[]`                |
| `primary.extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for MariaDB primary containers                                                                                                                                               | `""`                |
| `primary.extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for MariaDB primary containers                                                                                                                                                  | `""`                |
| `primary.persistence.enabled`                               | Enable persistence on MariaDB primary replicas using a `PersistentVolumeClaim`. If false, use emptyDir                                                                                                                            | `true`              |
| `primary.persistence.existingClaim`                         | Name of an existing `PersistentVolumeClaim` for MariaDB primary replicas                                                                                                                                                          | `""`                |
| `primary.persistence.subPath`                               | Subdirectory of the volume to mount at                                                                                                                                                                                            | `""`                |
| `primary.persistence.storageClass`                          | MariaDB primary persistent volume storage Class                                                                                                                                                                                   | `""`                |
| `primary.persistence.labels`                                | Labels for the PVC                                                                                                                                                                                                                | `{}`                |
| `primary.persistence.annotations`                           | MariaDB primary persistent volume claim annotations                                                                                                                                                                               | `{}`                |
| `primary.persistence.accessModes`                           | MariaDB primary persistent volume access Modes                                                                                                                                                                                    | `["ReadWriteOnce"]` |
| `primary.persistence.size`                                  | MariaDB primary persistent volume size                                                                                                                                                                                            | `8Gi`               |
| `primary.persistence.selector`                              | Selector to match an existing Persistent Volume                                                                                                                                                                                   | `{}`                |
| `primary.extraVolumes`                                      | Optionally specify extra list of additional volumes to the MariaDB Primary pod(s)                                                                                                                                                 | `[]`                |
| `primary.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the MariaDB Primary container(s)                                                                                                                                     | `[]`                |
| `primary.initContainers`                                    | Add additional init containers for the MariaDB Primary pod(s)                                                                                                                                                                     | `[]`                |
| `primary.sidecars`                                          | Add additional sidecar containers for the MariaDB Primary pod(s)                                                                                                                                                                  | `[]`                |
| `primary.service.type`                                      | MariaDB Primary Kubernetes service type                                                                                                                                                                                           | `ClusterIP`         |
| `primary.service.ports.mysql`                               | MariaDB Primary Kubernetes service port for MariaDB                                                                                                                                                                               | `3306`              |
| `primary.service.ports.metrics`                             | MariaDB Primary Kubernetes service port for metrics                                                                                                                                                                               | `9104`              |
| `primary.service.nodePorts.mysql`                           | MariaDB Primary Kubernetes service node port                                                                                                                                                                                      | `""`                |
| `primary.service.clusterIP`                                 | MariaDB Primary Kubernetes service clusterIP IP                                                                                                                                                                                   | `""`                |
| `primary.service.loadBalancerIP`                            | MariaDB Primary loadBalancerIP if service type is `LoadBalancer`                                                                                                                                                                  | `""`                |
| `primary.service.externalTrafficPolicy`                     | Enable client source IP preservation                                                                                                                                                                                              | `Cluster`           |
| `primary.service.loadBalancerSourceRanges`                  | Address that are allowed when MariaDB Primary service is LoadBalancer                                                                                                                                                             | `[]`                |
| `primary.service.extraPorts`                                | Extra ports to expose (normally used with the `sidecar` value)                                                                                                                                                                    | `[]`                |
| `primary.service.annotations`                               | Provide any additional annotations which may be required                                                                                                                                                                          | `{}`                |
| `primary.service.sessionAffinity`                           | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                                                                                                                                                              | `None`              |
| `primary.service.sessionAffinityConfig`                     | Additional settings for the sessionAffinity                                                                                                                                                                                       | `{}`                |
| `primary.service.headless.annotations`                      | Annotations of the headless service                                                                                                                                                                                               | `{}`                |
| `primary.pdb.create`                                        | Enable/disable a Pod Disruption Budget creation for MariaDB primary pods                                                                                                                                                          | `true`              |
| `primary.pdb.minAvailable`                                  | Minimum number/percentage of MariaDB primary pods that must still be available after the eviction                                                                                                                                 | `""`                |
| `primary.pdb.maxUnavailable`                                | Maximum number/percentage of MariaDB primary pods that can be unavailable after the eviction. Defaults to `1` if both `primary.pdb.minAvailable` and `primary.pdb.maxUnavailable` are empty.                                      | `""`                |
| `primary.revisionHistoryLimit`                              | Maximum number of revisions that will be maintained in the StatefulSet                                                                                                                                                            | `10`                |

### MariaDB Secondary parameters

| Name                                                          | Description                                                                                                                                                                                                                           | Value               |
| ------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------- |
| `secondary.name`                                              | Name of the secondary database (eg secondary, slave, ...)                                                                                                                                                                             | `secondary`         |
| `secondary.replicaCount`                                      | Number of MariaDB secondary replicas                                                                                                                                                                                                  | `1`                 |
| `secondary.command`                                           | Override default container command on MariaDB Secondary container(s) (useful when using custom images)                                                                                                                                | `[]`                |
| `secondary.args`                                              | Override default container args on MariaDB Secondary container(s) (useful when using custom images)                                                                                                                                   | `[]`                |
| `secondary.lifecycleHooks`                                    | for the MariaDB Secondary container(s) to automate configuration before or after startup                                                                                                                                              | `{}`                |
| `secondary.automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                                    | `false`             |
| `secondary.hostAliases`                                       | Add deployment host aliases                                                                                                                                                                                                           | `[]`                |
| `secondary.containerPorts.mysql`                              | Container port for mysql                                                                                                                                                                                                              | `3306`              |
| `secondary.configuration`                                     | MariaDB Secondary configuration to be injected as ConfigMap                                                                                                                                                                           | `""`                |
| `secondary.existingConfigmap`                                 | Name of existing ConfigMap with MariaDB Secondary configuration.                                                                                                                                                                      | `""`                |
| `secondary.updateStrategy.type`                               | MariaDB secondary statefulset strategy type                                                                                                                                                                                           | `RollingUpdate`     |
| `secondary.rollingUpdatePartition`                            | Partition update strategy for Mariadb Secondary statefulset                                                                                                                                                                           | `""`                |
| `secondary.podAnnotations`                                    | Additional pod annotations for MariaDB secondary pods                                                                                                                                                                                 | `{}`                |
| `secondary.podLabels`                                         | Extra labels for MariaDB secondary pods                                                                                                                                                                                               | `{}`                |
| `secondary.podAffinityPreset`                                 | MariaDB secondary pod affinity preset. Ignored if `secondary.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                       | `""`                |
| `secondary.podAntiAffinityPreset`                             | MariaDB secondary pod anti-affinity preset. Ignored if `secondary.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                  | `soft`              |
| `secondary.nodeAffinityPreset.type`                           | MariaDB secondary node affinity preset type. Ignored if `secondary.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                 | `""`                |
| `secondary.nodeAffinityPreset.key`                            | MariaDB secondary node label key to match Ignored if `secondary.affinity` is set.                                                                                                                                                     | `""`                |
| `secondary.nodeAffinityPreset.values`                         | MariaDB secondary node label values to match. Ignored if `secondary.affinity` is set.                                                                                                                                                 | `[]`                |
| `secondary.affinity`                                          | Affinity for MariaDB secondary pods assignment                                                                                                                                                                                        | `{}`                |
| `secondary.nodeSelector`                                      | Node labels for MariaDB secondary pods assignment                                                                                                                                                                                     | `{}`                |
| `secondary.tolerations`                                       | Tolerations for MariaDB secondary pods assignment                                                                                                                                                                                     | `[]`                |
| `secondary.topologySpreadConstraints`                         | Topology Spread Constraints for MariaDB secondary pods assignment                                                                                                                                                                     | `[]`                |
| `secondary.priorityClassName`                                 | Priority class for MariaDB secondary pods assignment                                                                                                                                                                                  | `""`                |
| `secondary.runtimeClassName`                                  | Runtime Class for MariaDB secondary pods                                                                                                                                                                                              | `""`                |
| `secondary.schedulerName`                                     | Name of the k8s scheduler (other than default)                                                                                                                                                                                        | `""`                |
| `secondary.terminationGracePeriodSeconds`                     | In seconds, time the given to the MySQL secondary pod needs to terminate gracefully                                                                                                                                                   | `""`                |
| `secondary.podManagementPolicy`                               | podManagementPolicy to manage scaling operation of MariaDB secondary pods                                                                                                                                                             | `""`                |
| `secondary.podSecurityContext.enabled`                        | Enable security context for MariaDB secondary pods                                                                                                                                                                                    | `true`              |
| `secondary.podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                                    | `Always`            |
| `secondary.podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                                        | `[]`                |
| `secondary.podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                                           | `[]`                |
| `secondary.podSecurityContext.fsGroup`                        | Group ID for the mounted volumes' filesystem                                                                                                                                                                                          | `1001`              |
| `secondary.containerSecurityContext.enabled`                  | MariaDB secondary container securityContext                                                                                                                                                                                           | `true`              |
| `secondary.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                                      | `{}`                |
| `secondary.containerSecurityContext.runAsUser`                | User ID for the MariaDB secondary container                                                                                                                                                                                           | `1001`              |
| `secondary.containerSecurityContext.runAsGroup`               | Group ID for the MariaDB secondary container                                                                                                                                                                                          | `1001`              |
| `secondary.containerSecurityContext.runAsNonRoot`             | Set secondary container's Security Context runAsNonRoot                                                                                                                                                                               | `true`              |
| `secondary.containerSecurityContext.privileged`               | Set secondary container's Security Context privileged                                                                                                                                                                                 | `false`             |
| `secondary.containerSecurityContext.allowPrivilegeEscalation` | Set secondary container's Security Context allowPrivilegeEscalation                                                                                                                                                                   | `false`             |
| `secondary.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                                               | `true`              |
| `secondary.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                                    | `["ALL"]`           |
| `secondary.containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                                      | `RuntimeDefault`    |
| `secondary.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if secondary.resources is set (secondary.resources is recommended for production). | `small`             |
| `secondary.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                     | `{}`                |
| `secondary.startupProbe.enabled`                              | Enable startupProbe                                                                                                                                                                                                                   | `false`             |
| `secondary.startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                                                | `120`               |
| `secondary.startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                                       | `15`                |
| `secondary.startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                                      | `5`                 |
| `secondary.startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                                    | `10`                |
| `secondary.startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                                    | `1`                 |
| `secondary.livenessProbe.enabled`                             | Enable livenessProbe                                                                                                                                                                                                                  | `true`              |
| `secondary.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                                               | `120`               |
| `secondary.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                                      | `10`                |
| `secondary.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                                     | `1`                 |
| `secondary.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                                                   | `3`                 |
| `secondary.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                                                   | `1`                 |
| `secondary.readinessProbe.enabled`                            | Enable readinessProbe                                                                                                                                                                                                                 | `true`              |
| `secondary.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                                              | `30`                |
| `secondary.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                                     | `10`                |
| `secondary.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                                    | `1`                 |
| `secondary.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                                                  | `3`                 |
| `secondary.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                                                  | `1`                 |
| `secondary.customStartupProbe`                                | Override default startup probe for MariaDB secondary containers                                                                                                                                                                       | `{}`                |
| `secondary.customLivenessProbe`                               | Override default liveness probe for MariaDB secondary containers                                                                                                                                                                      | `{}`                |
| `secondary.customReadinessProbe`                              | Override default readiness probe for MariaDB secondary containers                                                                                                                                                                     | `{}`                |
| `secondary.startupWaitOptions`                                | Override default builtin startup wait check options for MariaDB secondary containers                                                                                                                                                  | `{}`                |
| `secondary.extraFlags`                                        | MariaDB secondary additional command line flags                                                                                                                                                                                       | `""`                |
| `secondary.extraEnvVars`                                      | Extra environment variables to be set on MariaDB secondary containers                                                                                                                                                                 | `[]`                |
| `secondary.extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for MariaDB secondary containers                                                                                                                                                 | `""`                |
| `secondary.extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for MariaDB secondary containers                                                                                                                                                    | `""`                |
| `secondary.persistence.enabled`                               | Enable persistence on MariaDB secondary replicas using a `PersistentVolumeClaim`                                                                                                                                                      | `true`              |
| `secondary.persistence.subPath`                               | Subdirectory of the volume to mount at                                                                                                                                                                                                | `""`                |
| `secondary.persistence.storageClass`                          | MariaDB secondary persistent volume storage Class                                                                                                                                                                                     | `""`                |
| `secondary.persistence.labels`                                | Labels for the PVC                                                                                                                                                                                                                    | `{}`                |
| `secondary.persistence.annotations`                           | MariaDB secondary persistent volume claim annotations                                                                                                                                                                                 | `{}`                |
| `secondary.persistence.accessModes`                           | MariaDB secondary persistent volume access Modes                                                                                                                                                                                      | `["ReadWriteOnce"]` |
| `secondary.persistence.size`                                  | MariaDB secondary persistent volume size                                                                                                                                                                                              | `8Gi`               |
| `secondary.persistence.selector`                              | Selector to match an existing Persistent Volume                                                                                                                                                                                       | `{}`                |
| `secondary.extraVolumes`                                      | Optionally specify extra list of additional volumes to the MariaDB secondary pod(s)                                                                                                                                                   | `[]`                |
| `secondary.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the MariaDB secondary container(s)                                                                                                                                       | `[]`                |
| `secondary.initContainers`                                    | Add additional init containers for the MariaDB secondary pod(s)                                                                                                                                                                       | `[]`                |
| `secondary.sidecars`                                          | Add additional sidecar containers for the MariaDB secondary pod(s)                                                                                                                                                                    | `[]`                |
| `secondary.service.type`                                      | MariaDB secondary Kubernetes service type                                                                                                                                                                                             | `ClusterIP`         |
| `secondary.service.ports.mysql`                               | MariaDB secondary Kubernetes service port for MariaDB                                                                                                                                                                                 | `3306`              |
| `secondary.service.ports.metrics`                             | MariaDB secondary Kubernetes service port for metrics                                                                                                                                                                                 | `9104`              |
| `secondary.service.nodePorts.mysql`                           | MariaDB secondary Kubernetes service node port                                                                                                                                                                                        | `""`                |
| `secondary.service.clusterIP`                                 | MariaDB secondary Kubernetes service clusterIP IP                                                                                                                                                                                     | `""`                |
| `secondary.service.loadBalancerIP`                            | MariaDB secondary loadBalancerIP if service type is `LoadBalancer`                                                                                                                                                                    | `""`                |
| `secondary.service.externalTrafficPolicy`                     | Enable client source IP preservation                                                                                                                                                                                                  | `Cluster`           |
| `secondary.service.loadBalancerSourceRanges`                  | Address that are allowed when MariaDB secondary service is LoadBalancer                                                                                                                                                               | `[]`                |
| `secondary.service.extraPorts`                                | Extra ports to expose (normally used with the `sidecar` value)                                                                                                                                                                        | `[]`                |
| `secondary.service.annotations`                               | Provide any additional annotations which may be required                                                                                                                                                                              | `{}`                |
| `secondary.service.sessionAffinity`                           | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                                                                                                                                                                  | `None`              |
| `secondary.service.sessionAffinityConfig`                     | Additional settings for the sessionAffinity                                                                                                                                                                                           | `{}`                |
| `secondary.pdb.create`                                        | Enable/disable a Pod Disruption Budget creation for MariaDB secondary pods                                                                                                                                                            | `true`              |
| `secondary.pdb.minAvailable`                                  | Minimum number/percentage of MariaDB secondary pods that should remain scheduled                                                                                                                                                      | `""`                |
| `secondary.pdb.maxUnavailable`                                | Maximum number/percentage of MariaDB secondary pods that may be made unavailable. Defaults to `1` if both `secondary.pdb.minAvailable` and `secondary.pdb.maxUnavailable` are empty.                                                  | `""`                |
| `secondary.revisionHistoryLimit`                              | Maximum number of revisions that will be maintained in the StatefulSet                                                                                                                                                                | `10`                |

### RBAC parameters

| Name                                          | Description                                                    | Value   |
| --------------------------------------------- | -------------------------------------------------------------- | ------- |
| `serviceAccount.create`                       | Enable the creation of a ServiceAccount for MariaDB pods       | `true`  |
| `serviceAccount.name`                         | Name of the created ServiceAccount                             | `""`    |
| `serviceAccount.annotations`                  | Annotations for MariaDB Service Account                        | `{}`    |
| `serviceAccount.automountServiceAccountToken` | Automount service account token for the server service account | `false` |
| `rbac.create`                                 | Whether to create and use RBAC resources or not                | `false` |

### Password update job

| Name                                                                  | Description                                                                                                                                                                                                                                           | Value            |
| --------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| `passwordUpdateJob.enabled`                                           | Enable password update job                                                                                                                                                                                                                            | `false`          |
| `passwordUpdateJob.backoffLimit`                                      | set backoff limit of the job                                                                                                                                                                                                                          | `10`             |
| `passwordUpdateJob.command`                                           | Override default container command on MariaDB Primary container(s) (useful when using custom images)                                                                                                                                                  | `[]`             |
| `passwordUpdateJob.args`                                              | Override default container args on MariaDB Primary container(s) (useful when using custom images)                                                                                                                                                     | `[]`             |
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
| `passwordUpdateJob.initContainers`                                    | Add additional init containers for the MariaDB Primary pod(s)                                                                                                                                                                                         | `[]`             |
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
| `metrics.annotations`                                       | Annotations for the Exporter pod                                                                                                                                                                                                  | `{}`                              |
| `metrics.extraArgs`                                         | Extra args to be passed to mysqld_exporter                                                                                                                                                                                        | `{}`                              |
| `metrics.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the MariaDB metrics container(s)                                                                                                                                     | `{}`                              |
| `metrics.containerPorts.http`                               | Container port for http                                                                                                                                                                                                           | `9104`                            |
| `metrics.containerSecurityContext.enabled`                  | Enable security context for MariaDB metrics container                                                                                                                                                                             | `false`                           |
| `metrics.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                                  | `{}`                              |
| `metrics.containerSecurityContext.runAsUser`                | User ID for the MariaDB metrics container                                                                                                                                                                                         | `1001`                            |
| `metrics.containerSecurityContext.runAsGroup`               | Group ID for the MariaDB metrics container                                                                                                                                                                                        | `1001`                            |
| `metrics.containerSecurityContext.runAsNonRoot`             | Set metrics container's Security Context runAsNonRoot                                                                                                                                                                             | `true`                            |
| `metrics.containerSecurityContext.privileged`               | Set metrics container's Security Context privileged                                                                                                                                                                               | `false`                           |
| `metrics.containerSecurityContext.allowPrivilegeEscalation` | Set metrics container's Security Context allowPrivilegeEscalation                                                                                                                                                                 | `false`                           |
| `metrics.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                                           | `true`                            |
| `metrics.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                                | `["ALL"]`                         |
| `metrics.containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                                  | `RuntimeDefault`                  |
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
| `metrics.serviceMonitor.namespace`                          | Namespace which Prometheus is running in                                                                                                                                                                                          | `""`                              |
| `metrics.serviceMonitor.jobLabel`                           | The name of the label on the target service to use as the job name in prometheus.                                                                                                                                                 | `""`                              |
| `metrics.serviceMonitor.interval`                           | Interval at which metrics should be scraped                                                                                                                                                                                       | `30s`                             |
| `metrics.serviceMonitor.scrapeTimeout`                      | Specify the timeout after which the scrape is ended                                                                                                                                                                               | `""`                              |
| `metrics.serviceMonitor.relabelings`                        | RelabelConfigs to apply to samples before scraping                                                                                                                                                                                | `[]`                              |
| `metrics.serviceMonitor.metricRelabelings`                  | MetricRelabelConfigs to apply to samples before ingestion                                                                                                                                                                         | `[]`                              |
| `metrics.serviceMonitor.honorLabels`                        | honorLabels chooses the metric's labels on collisions with target labels                                                                                                                                                          | `false`                           |
| `metrics.serviceMonitor.selector`                           | ServiceMonitor selector labels                                                                                                                                                                                                    | `{}`                              |
| `metrics.serviceMonitor.labels`                             | Extra labels for the ServiceMonitor                                                                                                                                                                                               | `{}`                              |
| `metrics.prometheusRule.enabled`                            | if `true`, creates a Prometheus Operator PrometheusRule (also requires `metrics.enabled` to be `true` and `metrics.prometheusRule.rules`)                                                                                         | `false`                           |
| `metrics.prometheusRule.namespace`                          | Namespace for the PrometheusRule Resource (defaults to the Release Namespace)                                                                                                                                                     | `""`                              |
| `metrics.prometheusRule.additionalLabels`                   | Additional labels that can be used so PrometheusRule will be discovered by Prometheus                                                                                                                                             | `{}`                              |
| `metrics.prometheusRule.rules`                              | Prometheus Rule definitions                                                                                                                                                                                                       | `[]`                              |

### NetworkPolicy parameters

| Name                                    | Description                                                     | Value  |
| --------------------------------------- | --------------------------------------------------------------- | ------ |
| `networkPolicy.enabled`                 | Enable creation of NetworkPolicy resources                      | `true` |
| `networkPolicy.allowExternal`           | The Policy model to apply                                       | `true` |
| `networkPolicy.allowExternalEgress`     | Allow the pod to access any range of port and all destinations. | `true` |
| `networkPolicy.extraIngress`            | Add extra ingress rules to the NetworkPolicy                    | `[]`   |
| `networkPolicy.extraEgress`             | Add extra ingress rules to the NetworkPolicy                    | `[]`   |
| `networkPolicy.ingressNSMatchLabels`    | Labels to match to allow traffic from other namespaces          | `{}`   |
| `networkPolicy.ingressNSPodMatchLabels` | Pod labels to match to allow traffic from other namespaces      | `{}`   |

The above parameters map to the env variables defined in [bitnami/mariadb](https://github.com/bitnami/containers/tree/main/bitnami/mariadb). For more information please refer to the [bitnami/mariadb](https://github.com/bitnami/containers/tree/main/bitnami/mariadb) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
  --set auth.rootPassword=secretpassword,auth.database=app_database \
    oci://REGISTRY_NAME/REPOSITORY_NAME/mariadb
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The above command sets the MariaDB `root` account password to `secretpassword`. Additionally it creates a database named `my_database`.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml oci://REGISTRY_NAME/REPOSITORY_NAME/mariadb
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.
> **Tip**: You can use the default [values.yaml](https://github.com/bitnami/charts/tree/main/bitnami/mariadb/values.yaml)

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 20.2.0

This version introduces image verification for security purposes. To disable it, set `global.security.allowInsecureImages` to `true`. More details at [GitHub issue](https://github.com/bitnami/charts/issues/30850).

It's necessary to set the `auth.rootPassword` parameter when upgrading for readiness/liveness probes to work properly. When you install this chart for the first time, some notes will be displayed providing the credentials you must use under the 'Administrator credentials' section. Please note down the password and run the command below to upgrade your chart:

```console
helm upgrade my-release oci://REGISTRY_NAME/REPOSITORY_NAME/mariadb --set auth.rootPassword=[ROOT_PASSWORD]
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

| Note: you need to substitute the placeholder _[ROOT_PASSWORD]_ with the value obtained in the installation notes.

### To 20.0.0

This major bump updates the StatefulSet objects `serviceName` to use a headless service, as the current non-headless service attached to it was not providing DNS entries. This will cause an upgrade issue because it changes "immutable fields". To workaround it, delete the StatefulSet objects as follows (replace the RELEASE_NAME placeholder):

```shell

# If architecture = "standalone"
kubectl delete sts RELEASE_NAME --cascade=false

# If architecture = "replication"
kubectl delete sts RELEASE_NAME-primary --cascade=false
kubectl delete sts RELEASE_NAME-secondary --cascade=false
```

Then execute `helm upgrade` as usual.

Additionally, this new major provides a new, optional, password update job for automating this second-day operation in the chart. See the [Update credential](#password-update-job) for detailed instructions.

### To 19.0.0

This major release bumps the MariaDB version to 11.4. Follow the [upstream instructions](https://mariadb.com/kb/en/upgrading-between-minor-versions-on-linux/) for upgrading from MariaDB 11.3 to 11.4. No major issues are expected during the upgrade.

### To 18.0.0

This major release bumps the MariaDB version to 11.3. Follow the [upstream instructions](https://mariadb.com/kb/en/upgrading-between-minor-versions-on-linux/) for upgrading from MariaDB 11.2 to 11.3. No major issues are expected during the upgrade.

### To 17.0.0

This major bump changes the following security defaults:

- `runAsGroup` is changed from `0` to `1001`
- `readOnlyRootFilesystem` is set to `true`
- `resourcesPreset` is changed from `none` to the minimum size working in our test suites (NOTE: `resourcesPreset` is not meant for production usage, but `resources` adapted to your use case).
- `global.compatibility.openshift.adaptSecurityContext` is changed from `disabled` to `auto`.

This could potentially break any customization or init scripts used in your deployment. If this is the case, change the default values to the previous ones.

### To 16.0.0

This section enables NetworkPolicies by default to increase security of the application. It also adapts the values in the `networkPolicy` section to the current Bitnami standards. The removed sections are `networkPolicy.metrics.*`, `networkPolicy.ingressRules.*` and `networkPolicy.egressRules.*`. Check the Parameters table for the new structure.

### To 14.0.0

This major release bumps the MariaDB version to 11.1. Follow the [upstream instructions](https://mariadb.com/kb/en/upgrading-between-minor-versions-on-linux/) for upgrading from MariaDB 11.0 to 11.1. No major issues are expected during the upgrade.

### To 13.0.0

This major release bumps the MariaDB version to 11.0. Follow the [upstream instructions](https://mariadb.com/kb/en/upgrading-from-mariadb-10-11-to-mariadb-11-0/) for upgrading from MariaDB 10.11 to 11.0. No major issues are expected during the upgrade.

### To 11.0.0

This major release bumps default MariaDB branch to 10.6. Follow the [official instructions](https://mariadb.com/kb/en/upgrading-from-mariadb-105-to-mariadb-106/) from upgrading between 10.5 and 10.6.

No major issues are expected during the upgrade.

### To 10.0.0

This major release renames several values in this chart and adds missing features, in order to be inline with the rest of assets in the Bitnami charts repository.

Affected values:

- `primary.service.port` was deprecated, we recommend using `primary.service.ports.mysql` instead.
- `primary.service.nodePort` was deprecated, we recommend using `primary.service.nodePorts.mysql` instead.
- `secondary.service.port` was deprecated, we recommend using `secondary.service.ports.mysql` instead.
- `secondary.service.nodePort` was deprecated, we recommend using `secondary.service.nodePorts.mysql` instead.
- `metrics.serviceMonitor.additionalLabels` was deprecated, we recommend using `metrics.serviceMonitor.selector` instead.
- `primary.pdb.enabled` renamed as `primary.pdb.create`.
- `secondary.pdb.enabled` renamed as `secondary.pdb.create`.
- `primary.updateStrategy` changed from String type (previously default to 'rollingUpdate') to Object type, allowing users to configure other updateStrategy parameters, similar to other charts.
- Removed value `primary.rollingUpdatePartition`, now configured using `primary.updateStrategy` setting `primary.updateStrategy.rollingUpdate.partition`.
- `secondary.updateStrategy` changed from String type (previously default to 'rollingUpdate') to Object type, allowing users to configure other updateStrategy parameters, similar to other charts.
- Removed value `secondary.rollingUpdatePartition`, now configured using `secondary.updateStrategy` setting `secondary.updateStrategy.rollingUpdate.partition`.
- `metrics.serviceMonitor.relabellings`, previously used to configure ServiceMonitor metricRelabelings, has been replaced with the value `metrics.serviceMonitor.metricRelabelings`, and new value `metrics.serviceMonitor.relabelings` can be used to set ServiceMonitor relabelings parameter

### To 9.0.0

[On November 13, 2020, Helm v2 support was formally finished](https://github.com/helm/charts#status-of-the-project), this major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

### To 8.0.0

- Several parameters were renamed or disappeared in favor of new ones on this major version:
  - The terms _master_ and _slave_ have been replaced by the terms _primary_ and _secondary_. Therefore, parameters prefixed with `master` or `slave` are now prefixed with `primary` or `secondary`, respectively.
  - `securityContext.*` is deprecated in favor of `primary.podSecurityContext`, `primary.containerSecurityContext`, `secondary.podSecurityContext`, and `secondary.containerSecurityContext`.
  - Credentials parameter are reorganized under the `auth` parameter.
  - `replication.enabled` parameter is deprecated in favor of `architecture` parameter that accepts two values: `standalone` and `replication`.
- The default MariaDB version was updated from 10.3 to 10.5. According to the official documentation, upgrading from 10.3 should be painless. However, there are some things that have changed which could affect an upgrade:
  - [Incompatible changes upgrading from MariaDB 10.3 to MariaDB 10.4](https://mariadb.com/kb/en/upgrading-from-mariadb-103-to-mariadb-104/#incompatible-changes-between-103-and-104).
  - [Incompatible changes upgrading from MariaDB 10.4 to MariaDB 10.5](https://mariadb.com/kb/en/upgrading-from-mariadb-104-to-mariadb-105/#incompatible-changes-between-104-and-105).
- Chart labels were adapted to follow the [Helm charts standard labels](https://helm.sh/docs/chart_best_practices/labels/#standard-labels).
- This version also introduces `bitnami/common`, a [library chart](https://helm.sh/docs/topics/library_charts/#helm) as a dependency. More documentation about this new utility could be found [here](https://github.com/bitnami/charts/tree/main/bitnami/common#bitnami-common-library-chart). Please, make sure that you have updated the chart dependencies before executing any upgrade.

Consequences:

Backwards compatibility is not guaranteed. To upgrade to `8.0.0`, install a new release of the MariaDB chart, and migrate the data from your previous release. You have 2 alternatives to do so:

- Create a backup of the database, and restore it on the new release using tools such as [mysqldump](https://mariadb.com/kb/en/mysqldump/).
- Reuse the PVC used to hold the master data on your previous release. To do so, use the `primary.persistence.existingClaim` parameter. The following example assumes that the release name is `mariadb`:

```console
helm install mariadb oci://REGISTRY_NAME/REPOSITORY_NAME/mariadb --set auth.rootPassword=[ROOT_PASSWORD] --set primary.persistence.existingClaim=[EXISTING_PVC]
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

| Note: you need to substitute the placeholder _[EXISTING_PVC]_ with the name of the PVC used on your previous release, and _[ROOT_PASSWORD]_ with the root password used in your previous release.

### To 7.0.0

Helm performs a lookup for the object based on its group (apps), version (v1), and kind (Deployment). Also known as its GroupVersionKind, or GVK. Changing the GVK is considered a compatibility breaker from Kubernetes' point of view, so you cannot "upgrade" those objects to the new GVK in-place. Earlier versions of Helm 3 did not perform the lookup correctly which has since been fixed to match the spec.

In <https://github.com/helm/charts/pull/17308> the `apiVersion` of the statefulset resources was updated to `apps/v1` in tune with the api's deprecated, resulting in compatibility breakage.

This major version bump signifies this change.

### To 6.0.0

MariaDB version was updated from 10.1 to 10.3, there are no changes in the chart itself. According to the official documentation, upgrading from 10.1 should be painless. However, there are some things that have changed which could affect an upgrade:

- [Incompatible changes upgrading from MariaDB 10.1 to MariaDB 10.2](https://mariadb.com/kb/en/library/upgrading-from-mariadb-101-to-mariadb-102//#incompatible-changes-between-101-and-102)
- [Incompatible changes upgrading from MariaDB 10.2 to MariaDB 10.3](https://mariadb.com/kb/en/library/upgrading-from-mariadb-102-to-mariadb-103/#incompatible-changes-between-102-and-103)

### To 5.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 5.0.0. The following example assumes that the release name is mariadb:

```console
kubectl delete statefulset opencart-mariadb --cascade=false
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
