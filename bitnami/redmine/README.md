# Redmine

[Redmine](http://www.redmine.org) is a free and open source, web-based project management and issue tracking tool.

## TL;DR

```bash
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/redmine
```

## Introduction

This chart bootstraps a [Redmine](https://github.com/bitnami/bitnami-docker-redmine) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages the [Bitnami MariaDB chart](https://github.com/kubernetes/charts/tree/master/bitnami/mariadb) and the [PostgreSQL chart](https://github.com/kubernetes/charts/tree/master/bitnami/postgresql) which are required for bootstrapping a MariaDB/PostgreSQL deployment for the database requirements of the Redmine application.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This chart has been tested to work with NGINX Ingress, cert-manager, fluentd and Prometheus on top of the [BKPR](https://kubeprod.io/).

## Prerequisites

- Kubernetes 1.12+
- Helm 3.1.0
- PV provisioner support in the underlying infrastructure
- ReadWriteMany volumes for deployment scaling

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install my-release bitnami/redmine
```

The command deploys Redmine on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Using PostgreSQL instead of MariaDB

This chart includes the option to use a PostgreSQL database for Redmine instead of MariaDB. To use this, set the `databaseType` parameter to `postgresql`:

```
helm install my-release bitnami/redmine --set databaseType=postgresql
```

## Parameters

### Global parameters

| Name                      | Description                                     | Value |
| ------------------------- | ----------------------------------------------- | ----- |
| `global.imageRegistry`    | Global Docker image registry                    | `""`  |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]`  |
| `global.storageClass`     | Global StorageClass for Persistent Volume(s)    | `""`  |


### Common parameters

| Name                | Description                                        | Value                 |
| ------------------- | -------------------------------------------------- | --------------------- |
| `kubeVersion`       | Override Kubernetes version                        | `""`                  |
| `nameOverride`      | String to partially override common.names.fullname | `""`                  |
| `fullnameOverride`  | String to fully override common.names.fullname     | `""`                  |
| `commonLabels`      | Labels to add to all deployed objects              | `{}`                  |
| `commonAnnotations` | Annotations to add to all deployed objects         | `{}`                  |
| `extraDeploy`       | Array of extra objects to deploy with the release  | `[]`                  |
| `image.registry`    | Redmine image registry                             | `docker.io`           |
| `image.repository`  | Redmine image repository                           | `bitnami/redmine`     |
| `image.tag`         | Redmine image tag (immutable tags are recommended) | `4.2.1-debian-10-r71` |
| `image.pullPolicy`  | Redmine image pull policy                          | `IfNotPresent`        |
| `image.pullSecrets` | Redmine image pull secrets                         | `[]`                  |
| `image.debug`       | Enable image debug mode                            | `false`               |


### Redmine Configuration parameters

| Name                    | Description                                                            | Value              |
| ----------------------- | ---------------------------------------------------------------------- | ------------------ |
| `redmineUsername`       | Redmine username                                                       | `user`             |
| `redminePassword`       | Redmine user password                                                  | `""`               |
| `redmineEmail`          | Redmine user email                                                     | `user@example.com` |
| `redmineLanguage`       | Redmine default data language                                          | `en`               |
| `customPostInitScripts` | Custom post-init.d user scripts                                        | `{}`               |
| `smtpHost`              | SMTP server host                                                       | `""`               |
| `smtpPort`              | SMTP server port                                                       | `""`               |
| `smtpUser`              | SMTP username                                                          | `""`               |
| `smtpPassword`          | SMTP user password                                                     | `""`               |
| `smtpProtocol`          | SMTP protocol                                                          | `""`               |
| `existingSecret`        | Name of existing secret containing Redmine credentials                 | `""`               |
| `smtpExistingSecret`    | The name of an existing secret with SMTP credentials                   | `""`               |
| `allowEmptyPassword`    | Allow the container to be started with blank passwords                 | `false`            |
| `command`               | Override default container command (useful when using custom images)   | `[]`               |
| `args`                  | Override default container args (useful when using custom images)      | `[]`               |
| `extraEnvVars`          | Array with extra environment variables to add to the Redmine container | `[]`               |
| `extraEnvVarsCM`        | Name of existing ConfigMap containing extra env vars                   | `""`               |
| `extraEnvVarsSecret`    | Name of existing Secret containing extra env vars                      | `""`               |


### Redmine deployment parameters

| Name                                 | Description                                                                               | Value           |
| ------------------------------------ | ----------------------------------------------------------------------------------------- | --------------- |
| `replicaCount`                       | Number of Redmine replicas to deploy                                                      | `1`             |
| `updateStrategy.type`                | Redmine deployment strategy type                                                          | `RollingUpdate` |
| `updateStrategy.rollingUpdate`       | Redmine deployment rolling update configuration parameters                                | `{}`            |
| `schedulerName`                      | Alternate scheduler                                                                       | `""`            |
| `serviceAccount.create`              | Specifies whether a ServiceAccount should be created                                      | `false`         |
| `serviceAccount.name`                | The name of the ServiceAccount to create. Defaults to the `redmine.fullname` macro        | `""`            |
| `hostAliases`                        | Redmine pod host aliases                                                                  | `[]`            |
| `extraVolumes`                       | Optionally specify extra list of additional volumes for Redmine pods                      | `[]`            |
| `extraVolumeMounts`                  | Optionally specify extra list of additional volumeMounts for Redmine container(s)         | `[]`            |
| `sidecars`                           | Add additional sidecar containers to the Redmine pod                                      | `[]`            |
| `initContainers`                     | Add additional init containers to the Redmine pods                                        | `[]`            |
| `podLabels`                          | Extra labels for Redmine pods                                                             | `{}`            |
| `podAnnotations`                     | Annotations for Redmine pods                                                              | `{}`            |
| `podAffinityPreset`                  | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`       | `""`            |
| `podAntiAffinityPreset`              | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`  | `soft`          |
| `nodeAffinityPreset.type`            | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard` | `""`            |
| `nodeAffinityPreset.key`             | Node label key to match. Ignored if `affinity` is set                                     | `""`            |
| `nodeAffinityPreset.values`          | Node label values to match. Ignored if `affinity` is set                                  | `[]`            |
| `affinity`                           | Affinity for pod assignment                                                               | `{}`            |
| `nodeSelector`                       | Node labels for pod assignment                                                            | `{}`            |
| `tolerations`                        | Tolerations for pod assignment                                                            | `[]`            |
| `resources.limits`                   | The resources limits for the Redmine container                                            | `{}`            |
| `resources.requests`                 | The requested resources for the Redmine container                                         | `{}`            |
| `containerPort`                      | Redmine HTTP container port                                                               | `3000`          |
| `podSecurityContext.enabled`         | Enabled Redmine pods' Security Context                                                    | `false`         |
| `podSecurityContext.fsGroup`         | Set Redmine pod's Security Context fsGroup                                                | `1001`          |
| `containerSecurityContext.enabled`   | Enabled Redmine containers' Security Context                                              | `false`         |
| `containerSecurityContext.runAsUser` | Set Redmine container's Security Context runAsUser                                        | `1001`          |
| `livenessProbe.enabled`              | Enable livenessProbe                                                                      | `true`          |
| `livenessProbe.path`                 | Path for to check for livenessProbe                                                       | `/`             |
| `livenessProbe.initialDelaySeconds`  | Initial delay seconds for livenessProbe                                                   | `300`           |
| `livenessProbe.periodSeconds`        | Period seconds for livenessProbe                                                          | `10`            |
| `livenessProbe.timeoutSeconds`       | Timeout seconds for livenessProbe                                                         | `5`             |
| `livenessProbe.failureThreshold`     | Failure threshold for livenessProbe                                                       | `6`             |
| `livenessProbe.successThreshold`     | Success threshold for livenessProbe                                                       | `1`             |
| `readinessProbe.enabled`             | Enable readinessProbe                                                                     | `true`          |
| `readinessProbe.path`                | Path to check for readinessProbe                                                          | `/`             |
| `readinessProbe.initialDelaySeconds` | Initial delay seconds for readinessProbe                                                  | `5`             |
| `readinessProbe.periodSeconds`       | Period seconds for readinessProbe                                                         | `10`            |
| `readinessProbe.timeoutSeconds`      | Timeout seconds for readinessProbe                                                        | `5`             |
| `readinessProbe.failureThreshold`    | Failure threshold for readinessProbe                                                      | `6`             |
| `readinessProbe.successThreshold`    | Success threshold for readinessProbe                                                      | `1`             |
| `startupProbe.enabled`               | Enable startupProbe                                                                       | `false`         |
| `startupProbe.path`                  | Path to check for startupProbe                                                            | `/`             |
| `startupProbe.initialDelaySeconds`   | Initial delay seconds for startupProbe                                                    | `300`           |
| `startupProbe.periodSeconds`         | Period seconds for startupProbe                                                           | `10`            |
| `startupProbe.timeoutSeconds`        | Timeout seconds for startupProbe                                                          | `5`             |
| `startupProbe.failureThreshold`      | Failure threshold for startupProbe                                                        | `6`             |
| `startupProbe.successThreshold`      | Success threshold for startupProbe                                                        | `1`             |
| `customLivenessProbe`                | Custom livenessProbe that overrides the default one                                       | `{}`            |
| `customReadinessProbe`               | Custom readinessProbe that overrides the default one                                      | `{}`            |
| `customStartupProbe`                 | Custom startupProbe that overrides the default one                                        | `{}`            |


### Traffic Exposure Parameters

| Name                               | Description                                                                                           | Value                    |
| ---------------------------------- | ----------------------------------------------------------------------------------------------------- | ------------------------ |
| `service.type`                     | Redmine service type                                                                                  | `LoadBalancer`           |
| `service.port`                     | Redmine service HTTP port                                                                             | `80`                     |
| `service.nodePort`                 | Node port for HTTP                                                                                    | `""`                     |
| `service.clusterIP`                | Redmine service Cluster IP                                                                            | `""`                     |
| `service.loadBalancerIP`           | Redmine service Load Balancer IP                                                                      | `""`                     |
| `service.loadBalancerSourceRanges` | Redmine service Load Balancer sources                                                                 | `[]`                     |
| `service.externalTrafficPolicy`    | Redmine service external traffic policy                                                               | `Cluster`                |
| `service.annotations`              | Additional custom annotations for Redmine service                                                     | `{}`                     |
| `service.extraPorts`               | Extra port to expose on Redmine service                                                               | `[]`                     |
| `ingress.enabled`                  | Enable ingress record generation for Redmine                                                          | `false`                  |
| `ingress.certManager`              | Add the corresponding annotations for cert-manager integration                                        | `false`                  |
| `ingress.selfSigned`               | Create a TLS secret for this ingress record using self-signed certificates generated by Helm          | `false`                  |
| `ingress.pathType`                 | Ingress path type                                                                                     | `ImplementationSpecific` |
| `ingress.apiVersion`               | Force Ingress API version (automatically detected if not set)                                         | `""`                     |
| `ingress.hostname`                 | Default host for the ingress record                                                                   | `redmine.local`          |
| `ingress.path`                     | Default path for the ingress record                                                                   | `ImplementationSpecific` |
| `ingress.annotations`              | Additional custom annotations for the ingress record                                                  | `{}`                     |
| `ingress.tls`                      | Enable TLS configuration for the host defined at `ingress.hostname` parameter                         | `false`                  |
| `ingress.extraHosts`               | An array with additional hostname(s) to be covered with the ingress record                            | `[]`                     |
| `ingress.extraPaths`               | An array with additional arbitrary paths that may need to be added to the ingress under the main host | `[]`                     |
| `ingress.extraTls`                 | TLS configuration for additional hostname(s) to be covered with this ingress record                   | `[]`                     |
| `ingress.secrets`                  | Custom TLS certificates as secrets                                                                    | `[]`                     |


### Persistence Parameters

| Name                                          | Description                                                                                     | Value   |
| --------------------------------------------- | ----------------------------------------------------------------------------------------------- | ------- |
| `persistence.enabled`                         | Enable persistence using Persistent Volume Claims                                               | `true`  |
| `persistence.storageClass`                    | Persistent Volume storage class                                                                 | `""`    |
| `persistence.accessModes`                     | Persistent Volume access modes                                                                  | `[]`    |
| `persistence.size`                            | Persistent Volume size                                                                          | `8Gi`   |
| `persistence.dataSource`                      | Custom PVC data source                                                                          | `{}`    |
| `persistence.existingClaim`                   | The name of an existing PVC to use for persistence                                              | `""`    |
| `volumePermissions.enabled`                   | Enable init container that changes the owner/group of the PV mount point to `runAsUser:fsGroup` | `false` |
| `volumePermissions.resources.limits`          | The resources limits for the init container                                                     | `{}`    |
| `volumePermissions.resources.requests`        | The requested resources for the init container                                                  | `{}`    |
| `volumePermissions.securityContext.runAsUser` | Set init container's Security Context runAsUser                                                 | `0`     |


### Other Parameters

| Name                                 | Description                                                    | Value   |
| ------------------------------------ | -------------------------------------------------------------- | ------- |
| `podDisruptionBudget.create`         | Enable a Pod Disruption Budget creation                        | `false` |
| `podDisruptionBudget.minAvailable`   | Minimum number/percentage of pods that should remain scheduled | `""`    |
| `podDisruptionBudget.maxUnavailable` | Maximum number/percentage of pods that may be made unavailable | `""`    |
| `autoscaling.enabled`                | Enable Horizontal POD autoscaling for Redmine                  | `false` |
| `autoscaling.minReplicas`            | Minimum number of Redmine replicas                             | `1`     |
| `autoscaling.maxReplicas`            | Maximum number of Redmine replicas                             | `11`    |
| `autoscaling.targetCPU`              | Target CPU utilization percentage                              | `50`    |
| `autoscaling.targetMemory`           | Target Memory utilization percentage                           | `50`    |


### Database Parameters

| Name                                        | Description                                                                                                                              | Value             |
| ------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- | ----------------- |
| `databaseType`                              | Redmine database type. Allowed values: `mariadb` and `postgresql`                                                                        | `mariadb`         |
| `mariadb.enabled`                           | Whether to deploy a MariaDB server to satisfy the database requirements                                                                  | `true`            |
| `mariadb.architecture`                      | MariaDB architecture. Allowed values: `standalone` or `replication`                                                                      | `standalone`      |
| `mariadb.auth.rootPassword`                 | MariaDB root password                                                                                                                    | `""`              |
| `mariadb.auth.username`                     | MariaDB username                                                                                                                         | `bn_redmine`      |
| `mariadb.auth.password`                     | MariaDB password                                                                                                                         | `""`              |
| `mariadb.auth.existingSecret`               | Name of existing secret object                                                                                                           | `""`              |
| `mariadb.primary.persistence.enabled`       | Enable MariaDB persistence using PVC                                                                                                     | `true`            |
| `mariadb.primary.persistence.existingClaim` | Provide an existing `PersistentVolumeClaim`, the value is evaluated as a template                                                        | `""`              |
| `mariadb.primary.persistence.storageClass`  | PVC Storage Class for MariaDB volume                                                                                                     | `""`              |
| `mariadb.primary.persistence.accessModes`   | PVC Access Mode for MariaDB volume                                                                                                       | `[]`              |
| `mariadb.primary.persistence.size`          | PVC Storage Request for MariaDB volume                                                                                                   | `8Gi`             |
| `mariadb.primary.persistence.hostPath`      | Set path in case you want to use local host path volumes (not recommended in production)                                                 | `""`              |
| `postgresql.enabled`                        | Whether to deploy a PostgreSQL server to satisfy the database requirements                                                               | `true`            |
| `postgresql.postgresqlUsername`             | PostgreSQL username                                                                                                                      | `bn_redmine`      |
| `postgresql.postgresqlPassword`             | PostgreSQL password                                                                                                                      | `""`              |
| `postgresql.postgresqlDatabase`             | PostgreSQL database                                                                                                                      | `bitnami_redmine` |
| `postgresql.existingSecret`                 | Name of existing secret object                                                                                                           | `""`              |
| `postgresql.persistence.enabled`            | Enable PostgreSQL persistence using PVC                                                                                                  | `true`            |
| `postgresql.persistence.existingClaim`      | Provide an existing `PersistentVolumeClaim`, the value is evaluated as a template                                                        | `""`              |
| `postgresql.persistence.storageClass`       | PVC Storage Class for PostgreSQL volume                                                                                                  | `""`              |
| `postgresql.persistence.accessMode`         | PVC Access Mode for PostgreSQL volume                                                                                                    | `ReadWriteOnce`   |
| `postgresql.persistence.size`               | PVC Storage Request for PostgreSQL volume                                                                                                | `8Gi`             |
| `externalDatabase.host`                     | External Database server host                                                                                                            | `""`              |
| `externalDatabase.port`                     | External Database server port                                                                                                            | `5432`            |
| `externalDatabase.user`                     | External Database username                                                                                                               | `bn_redmine`      |
| `externalDatabase.password`                 | External Database user password                                                                                                          | `""`              |
| `externalDatabase.database`                 | External Database database name                                                                                                          | `bitnami_redmine` |
| `externalDatabase.existingSecret`           | Use an existing secret for external db password. Must contain the keys `redmine-password` or `mariadb-password` depending on the DB type | `""`              |


### Mail Receiver/Cron Job Parameters

| Name                                                 | Description                                                                                                                                   | Value                 |
| ---------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------- | --------------------- |
| `mailReceiver.enabled`                               | Whether to enable scheduled mail-to-task CronJob                                                                                              | `false`               |
| `mailReceiver.schedule`                              | Kubernetes CronJob schedule                                                                                                                   | `*/5 * * * *`         |
| `mailReceiver.suspend`                               | Whether to create suspended CronJob                                                                                                           | `true`                |
| `mailReceiver.image.registry`                        | Redmine MailReceiver image registry                                                                                                           | `docker.io`           |
| `mailReceiver.image.repository`                      | Redmine MailReceiver image repository                                                                                                         | `bitnami/redmine`     |
| `mailReceiver.image.tag`                             | Redmine MailReceiver image tag (immutable tags are recommended)                                                                               | `4.2.1-debian-10-r70` |
| `mailReceiver.image.pullPolicy`                      | Redmine MailReceiver image pull policy                                                                                                        | `IfNotPresent`        |
| `mailReceiver.image.pullSecrets`                     | Redmine MailReceiver image pull secrets                                                                                                       | `[]`                  |
| `mailReceiver.podAnnotations`                        | Additional pod annotations                                                                                                                    | `{}`                  |
| `mailReceiver.podLabels`                             | Additional pod labels                                                                                                                         | `{}`                  |
| `mailReceiver.priorityClassName`                     | Redmine pods' priority.                                                                                                                       | `""`                  |
| `mailReceiver.mailProtocol`                          | Mail protocol to use for reading emails. Allowed values: `IMAP` and `POP3`                                                                    | `IMAP`                |
| `mailReceiver.host`                                  | Server to receive emails from                                                                                                                 | `""`                  |
| `mailReceiver.port`                                  | TCP port on the `host`                                                                                                                        | `993`                 |
| `mailReceiver.username`                              | Login to authenticate on the `host`                                                                                                           | `""`                  |
| `mailReceiver.password`                              | Password to authenticate on the `host`                                                                                                        | `""`                  |
| `mailReceiver.ssl`                                   | Whether use SSL/TLS to connect to the `host`                                                                                                  | `true`                |
| `mailReceiver.startTLS`                              | Whether use StartTLS to connect to the `host`                                                                                                 | `false`               |
| `mailReceiver.imapFolder`                            | IMAP only. Folder to read emails from                                                                                                         | `INBOX`               |
| `mailReceiver.moveOnSuccess`                         | IMAP only. Folder to move processed emails to                                                                                                 | `""`                  |
| `mailReceiver.moveOnFailure`                         | IMAP only. Folder to move emails with processing errors to                                                                                    | `""`                  |
| `mailReceiver.unknownUserAction`                     | Action to perform is an email received from unregistered user                                                                                 | `ignore`              |
| `mailReceiver.noPermissionCheck`                     | Whether skip permission check during creating a new task                                                                                      | `0`                   |
| `mailReceiver.noAccountNotice`                       | Whether send an email to an unregistered user created during a new task creation                                                              | `1`                   |
| `mailReceiver.defaultGroup`                          | Defines a group list to add created user to                                                                                                   | `""`                  |
| `mailReceiver.project`                               | Defines identifier of the target project for a new task                                                                                       | `""`                  |
| `mailReceiver.projectFromSubaddress`                 | Defines email address to select project from subaddress                                                                                       | `""`                  |
| `mailReceiver.status`                                | Defines a new task status                                                                                                                     | `""`                  |
| `mailReceiver.tracker`                               | Defines a new task tracker                                                                                                                    | `""`                  |
| `mailReceiver.category`                              | Defines a new task category                                                                                                                   | `""`                  |
| `mailReceiver.priority`                              | Defines a new task priority                                                                                                                   | `""`                  |
| `mailReceiver.assignedTo`                            | Defines a new task assignee                                                                                                                   | `""`                  |
| `mailReceiver.allowOverride`                         | Defines if email content is allowed to set attributes values. Values is a comma separated list of attributes or `all` to allow all attributes | `""`                  |
| `mailReceiver.extraEnvVars`                          | Extra environment variables to be set on mailReceiver container                                                                               | `[]`                  |
| `mailReceiver.extraEnvVarsCM`                        | Name of existing ConfigMap containing extra env vars                                                                                          | `""`                  |
| `mailReceiver.extraEnvVarsSecret`                    | Name of existing Secret containing extra env vars                                                                                             | `""`                  |
| `mailReceiver.extraVolumes`                          | Optionally specify extra list of additional volumes for mailReceiver container                                                                | `[]`                  |
| `mailReceiver.extraVolumeMounts`                     | Optionally specify extra list of additional volumeMounts for mailReceiver container                                                           | `[]`                  |
| `mailReceiver.command`                               | Override default container command (useful when using custom images)                                                                          | `[]`                  |
| `mailReceiver.args`                                  | Override default container args (useful when using custom images)                                                                             | `[]`                  |
| `mailReceiver.podSecurityContext.enabled`            | Enabled Redmine pods' Security Context                                                                                                        | `true`                |
| `mailReceiver.podSecurityContext.fsGroup`            | Set Redmine pod's Security Context fsGroup                                                                                                    | `1001`                |
| `mailReceiver.containerSecurityContext.enabled`      | mailReceiver Container securityContext                                                                                                        | `false`               |
| `mailReceiver.containerSecurityContext.runAsUser`    | User ID for the mailReceiver container                                                                                                        | `1001`                |
| `mailReceiver.containerSecurityContext.runAsNonRoot` | Whether to run the mailReceiver container as a non-root user                                                                                  | `true`                |
| `mailReceiver.initContainers`                        | Add additional init containers to the mailReceiver pods                                                                                       | `[]`                  |
| `mailReceiver.sidecars`                              | Add additional sidecar containers to the mailReceiver pods                                                                                    | `[]`                  |
| `mailReceiver.podAffinityPreset`                     | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                           | `""`                  |
| `mailReceiver.podAntiAffinityPreset`                 | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                      | `soft`                |
| `mailReceiver.nodeAffinityPreset.type`               | Node affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                          | `""`                  |
| `mailReceiver.nodeAffinityPreset.key`                | Node label key to match. Ignored if `affinity` is set.                                                                                        | `""`                  |
| `mailReceiver.nodeAffinityPreset.values`             | Node label values to match. Ignored if `affinity` is set.                                                                                     | `[]`                  |
| `mailReceiver.affinity`                              | Affinity for pod assignment                                                                                                                   | `{}`                  |
| `mailReceiver.nodeSelector`                          | Node labels for pod assignment                                                                                                                | `{}`                  |
| `mailReceiver.tolerations`                           | Tolerations for pod assignment                                                                                                                | `[]`                  |


### Custom Certificates parameters

| Name                                                 | Description                                                        | Value                                    |
| ---------------------------------------------------- | ------------------------------------------------------------------ | ---------------------------------------- |
| `certificates.customCertificate.certificateSecret`   | Secret containing the certificate and key to add                   | `""`                                     |
| `certificates.customCertificate.certificateLocation` | Location in the container to store the certificate                 | `/etc/ssl/certs/ssl-cert-snakeoil.pem`   |
| `certificates.customCertificate.keyLocation`         | Location in the container to store the private key                 | `/etc/ssl/private/ssl-cert-snakeoil.key` |
| `certificates.customCertificate.chainLocation`       | Location in the container to store the certificate chain           | `/etc/ssl/certs/mychain.pem`             |
| `certificates.customCertificate.chainSecret.name`    | Name of the secret containing the certificate chain                | `""`                                     |
| `certificates.customCertificate.chainSecret.key`     | Key of the certificate chain file inside the secret                | `""`                                     |
| `certificates.customCA`                              | Defines a list of secrets to import into the container trust store | `[]`                                     |
| `certificates.image.registry`                        | Redmine image registry                                             | `docker.io`                              |
| `certificates.image.repository`                      | Redmine image repository                                           | `bitnami/bitnami-shell`                  |
| `certificates.image.tag`                             | Redmine image tag (immutable tags are recommended)                 | `10-debian-10-r133`                      |
| `certificates.image.pullPolicy`                      | Redmine image pull policy                                          | `IfNotPresent`                           |
| `certificates.image.pullSecrets`                     | Redmine image pull secrets                                         | `[]`                                     |
| `certificates.extraEnvVars`                          | Container sidecar extra environment variables (e.g. proxy)         | `[]`                                     |


The above parameters map to the env variables defined in [bitnami/redmine](http://github.com/bitnami/bitnami-docker-redmine). For more information please refer to the [bitnami/redmine](http://github.com/bitnami/bitnami-docker-redmine) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install my-release \
  --set redmineUsername=admin,redminePassword=password,mariadb.mariadb.auth.rootPassword=secretpassword \
    bitnami/redmine
```

The above command sets the Redmine administrator account username and password to `admin` and `password` respectively. Additionally, it sets the MariaDB `root` user password to `secretpassword`.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```bash
$ helm install my-release -f values.yaml bitnami/redmine
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Replicas

Redmine writes uploaded files to a persistent volume. By default that volume cannot be shared between pods (RWO). In such a configuration the `replicas` option must be set to `1`. If the persistent volume supports more than one writer (RWX), ie NFS, `replicas` can be greater than `1`.

> **Important**: When running more than one instance of Redmine they must share the same `secret_key_base` to have sessions working acreoss all instances.
> This can be achieved by setting
> ```
>   extraEnvVars:
>    - name: SECRET_KEY_BASE
>      value: someredminesecretkeybase
> ```

### Deploying to a sub-URI

(adapted from https://github.com/bitnami/bitnami-docker-redmine)

On certain occasions, you may need that Redmine is available under a specific sub-URI path rather than the root. A common scenario to this problem may arise if you plan to set up your Redmine container behind a reverse proxy. To deploy your Redmine container using a certain sub-URI you just need to follow these steps:

#### Create a configmap containing an altered version of post-init.sh

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: redmine-init-configmap
  namespace: <same-namespace-as-the-chart>
  labels:
  ...
data:

  post-init.sh: |-
    #!/bin/bash

    # REPLACE WITH YOUR OWN SUB-URI
    SUB_URI_PATH='/redmine'

    #Config files where to apply changes
    config1=/opt/bitnami/redmine/config.ru
    config2=/opt/bitnami/redmine/config/environment.rb

    sed -i '$ d' ${config1}
    echo 'map ActionController::Base.config.try(:relative_url_root) || "/" do' >> ${config1}
    echo 'run Rails.application' >> ${config1}
    echo 'end' >> ${config1}
    echo 'Redmine::Utils::relative_url_root = "'${SUB_URI_PATH}'"' >> ${config2}

    SUB_URI_PATH=$(echo ${SUB_URI_PATH} | sed -e 's|/|\\/|g')
    sed -i -e "s/\(relative_url_root\ \=\ \"\).*\(\"\)/\1${SUB_URI_PATH}\2/" ${config2}
```

#### Add this confimap as a volume/volume mount in the chart values

```yaml
## Extra volumes to add to the deployment
##
extraVolumes:
  - name: redmine-init-volume
    configMap:
      name: redmine-init-configmap

## Extra volume mounts to add to the container
##
extraVolumeMounts:
  - name: "redmine-init-volume"
    mountPath: "/post-init.sh"
    subPath: post-init.sh
```

#### Change the probes URI

```yaml
## Configure extra options for liveness and readiness probes
## ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/#configure-probes)
##
livenessProbe:
  enabled: true
  path: /redmine/
...

readinessProbe:
  enabled: true
  path: /redmine/
...
```

## Persistence

The [Bitnami Redmine](https://github.com/bitnami/bitnami-docker-redmine) image stores the Redmine data and configurations at the `/bitnami/redmine` path of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube. The volume is created using dynamic volume provisioning. Clusters configured with NFS mounts require manually managed volumes and claims.

See the [Parameters](#parameters) section to configure the PVC or to disable persistence.

### Existing PersistentVolumeClaims

The following example includes two PVCs, one for Redmine and another for MariaDB.

1. Create the PersistentVolume
1. Create the PersistentVolumeClaim
1. Create the directory, on a worker
1. Install the chart

```bash
$ helm install test --set persistence.existingClaim=PVC_REDMINE,mariadb.persistence.existingClaim=PVC_MARIADB bitnami/redmine
```

## Certificates

### CA Certificates

Custom CA certificates not included in the base docker image can be added with
the following configuration. The secret must exist in the same namespace as the
deployment. Will load all certificates files it finds in the secret.

```yaml
certificates:
  customCAs:
  - secret: my-ca-1
  - secret: my-ca-2
```

#### Secret

Secret can be created with:

```bash
kubectl create secret generic my-ca-1 --from-file my-ca-1.crt
```

### TLS Certificate

A web server TLS Certificate can be injected into the container with the
following configuration. The certificate will be stored at the location
specified in the certificateLocation value.

```yaml
certificates:
  customCertificate:
    certificateSecret: my-secret
    certificateLocation: /ssl/server.pem
    keyLocation: /ssl/key.pem
    chainSecret:
      name: my-cert-chain
      key: chain.pem
```

#### Secret

The certificate tls secret can be created with:

```bash
kubectl create secret tls my-secret --cert tls.crt --key tls.key
```

The certificate chain is created with:

```bash
kubectl create secret generic my-cert-chain --from-file chain.pem
```

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami’s Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### 16.0.0

The [Bitnami Redmine](https://github.com/bitnami/bitnami-docker-redmine) image was refactored and now the source code is published in GitHub in the [`rootfs`](https://github.com/bitnami/bitnami-docker-redmine/tree/master/4/debian-10/rootfs) folder of the container image repository.

Upgrades from previous versions require to specify `--set volumePermissions.enabled=true` in order for all features to work properly:

```console
$ helm upgrade example bitnami/redmine --set redminePassword=$REDMINE_PASSWORD --set mariadb.auth.rootPassword=$MARIADB_ROOT_PASSWORD --set mariadb.auth.password=$MARIADB_PASSWORD --set volumePermissions.enabled=true
```

In addition, the `replicas` parameter was renamed to `replicaCount`.

Full compatibility is not guaranteed due to the amount of involved changes, however no breaking changes are expected aside from the ones mentioned above.

### 15.0.0

[On November 13, 2020, Helm v2 support was formally finished](https://github.com/helm/charts#status-of-the-project), this major version includes all the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

#### What changes were introduced in this major version?

- Previous versions of this Helm Chart use `apiVersion: v1` (installable by both Helm 2 and 3), this Helm Chart was updated to `apiVersion: v2` (installable by Helm 3 only). [Here](https://helm.sh/docs/topics/charts/#the-apiversion-field) you can find more information about the `apiVersion` field.
- Move dependency information from the *requirements.yaml* to the *Chart.yaml*
- After running `helm dependency update`, a *Chart.lock* file is generated containing the same structure used in the previous *requirements.lock*
- The different fields present in the *Chart.yaml* file has been ordered alphabetically in a homogeneous way for all the Bitnami Helm Charts
- PostgreSQL dependency version was bumped to a new major version `10.X.X`, which includes changes that do no longer guarantee backwards compatibility. Check [PostgreSQL Upgrading Notes](https://github.com/bitnami/charts/tree/master/bitnami/postgresql#upgrading) for more information.
- MariaDB dependency version was bumped to a new major version `9.X.X`, which includes changes that do no longer guarantee backwards compatibility. Check [MariaDB Upgrading Notes](https://github.com/bitnami/charts/tree/master/bitnami/mariadb#upgrading) for more information.
- Inclusion of the`bitnami/common` library chart, standardizations and adaptation of labels to follow helm's standards.
- `securityContext.*` is deprecated in favor of `podSecurityContext`, `containerSecurityContext`, `mailReceiver.podSecurityContext`, and `mailReceiver.containerSecurityContext`.

#### Considerations when upgrading to this version

- If you want to upgrade to this version from a previous one installed with Helm v3, please follow the instructions below.
- If you want to upgrade to this version using Helm v2, this scenario is not supported as this version doesn't support Helm v2 anymore
- If you installed the previous version with Helm v2 and wants to upgrade to this version with Helm v3, please refer to the [official Helm documentation](https://helm.sh/docs/topics/v2_v3_migration/#migration-use-cases) about migrating from Helm v2 to v3.
- This chart depends on the **PostgreSQL 10** instead of **PostgreSQL 8**. Apart from the changes that are described in this section, there are also other major changes due to the `master/slave` nomenclature was replaced by `primary/readReplica` or the standardization of Helm labels. For further details regarding the changes introduced, refer to [version 10 changes](https://github.com/bitnami/charts/pull/4385) or [version 9 changes](https://github.com/bitnami/charts/pull/3021) respectively.

As a consequence, backwards compatibility from previous versions is not guaranteed during the upgrade. To upgrade to this new version `15.0.0` there are two alternatives:

* Install a new Redmine chart and follow the [official guide on how to backup/restore](https://www.redmine.org/projects/redmine/wiki/RedmineBackupRestore).

* Reuse the PVC used to hold the PostgreSQL/MariaDB data on your previous release. To do so, follow the instructions below.

**Upgrade instructions**

> NOTE: The instructions suppose your DatabaseType is MariaDB. The process is analogous for PostgreSQL instances.
> WARNING: Please, make sure to create or have a backup of your database before running any of those actions.

1. Old version is up and running

```console
$ kubectl get pods
NAME                              READY   STATUS    RESTARTS   AGE
example-mariadb-0                 1/1     Running   0          40s
example-redmine-9f8c7b54d-trns2   1/1     Running   0          72s
```

2. Export both MariaDB and Redmine credentials in order to provide them in the update

```console
$ export REDMINE_PASSWORD=$(kubectl get secret --namespace default example-redmine -o jsonpath="{.data.redmine-password}" | base64 --decode)

$ export MARIADB_ROOT_PASSWORD=$(kubectl get secret --namespace default example-mariadb -o jsonpath="{.data.mariadb-root-password}" | base64 --decode)

$ export MARIADB_PASSWORD=$(kubectl get secret --namespace default example-mariadb -o jsonpath="{.data.mariadb-password}" | base64 --decode)
```

3. Delete the Redmine deployment and delete the MariaDB statefulset. Notice the option `--cascade=false` in the latter.

```console
$ kubectl delete deployment.apps/example-redmine
deployment.apps "example-redmine" deleted

$ kubectl delete statefulset.apps/example-mariadb --cascade=false
statefulset.apps "example-mariadb" deleted
```

4. Now the upgrade works

```console
$ helm upgrade example bitnami/redmine --set redminePassword=$REDMINE_PASSWORD --set mariadb.auth.rootPassword=$MARIADB_ROOT_PASSWORD --set mariadb.auth.password=$MARIADB_PASSWORD

$ helm ls
NAME   	NAMESPACE	REVISION	UPDATED                             	STATUS  	CHART         	APP VERSION
example	default  	1       	2020-10-29 20:33:17.776769 +0100 CET	deployed	redmine-15.0.0	4.1.1
```

5. You should kill the existing MariaDB pod now and the new statefulset is going to create a new one

```console
$ kubectl delete pod example-mariadb-0
pod "example-mariadb-0" deleted

$ kubectl get pods
NAME                               READY   STATUS    RESTARTS   AGE
example-mariadb-0                  1/1     Running   0          19s
example-redmine-766c69d549-4zlgh   1/1     Running   2          2m26s
```

#### Useful links

- https://docs.bitnami.com/tutorials/resolve-helm2-helm3-post-migration-issues/
- https://helm.sh/docs/topics/v2_v3_migration/
- https://helm.sh/blog/migrate-from-helm-v2-to-helm-v3/

### To 14.0.0

- Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
- The `databaseType` parameters is no longer an object but a string. Allowed values are "mariadb" and "postgresql".
- Ingress configuration was standardized to simplify the way to configure the main host.
- Ports names were prefixed with the protocol to comply with Istio (see https://istio.io/docs/ops/deployment/requirements/).

### To 13.0.0

Helm performs a lookup for the object based on its group (apps), version (v1), and kind (Deployment). Also known as its GroupVersionKind, or GVK. Changing the GVK is considered a compatibility breaker from Kubernetes' point of view, so you cannot "upgrade" those objects to the new GVK in-place. Earlier versions of Helm 3 did not perform the lookup correctly which has since been fixed to match the spec.

In https://github.com/helm/charts/pull/17309 the `apiVersion` of the deployment resources was updated to `apps/v1` in tune with the api's deprecated, resulting in compatibility breakage.

This major version signifies this change.

### To 5.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 5.0.0. The following example assumes that the release name is redmine:

```console
$ kubectl patch deployment redmine-redmine --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
# If using postgresql as database
$ kubectl patch deployment redmine-postgresql --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
# If using mariadb as database
$ kubectl delete statefulset redmine-mariadb --cascade=false
```
