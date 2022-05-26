<!--- app-name: Redmine -->

# Redmine packaged by Bitnami

Redmine is an open source management application. It includes a tracking issue system, Gantt charts for a visual view of projects and deadlines, and supports SCM integration for version control.

[Overview of Redmine](http://www.redmine.org/)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.
                           
## TL;DR

```bash
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/redmine
```

## Introduction

This chart bootstraps a [Redmine](https://github.com/bitnami/bitnami-docker-redmine) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages the [Bitnami MariaDB chart](https://github.com/bitnami/charts/tree/master/bitnami/mariadb) and the [PostgreSQL chart](https://github.com/bitnami/charts/tree/master/bitnami/postgresql) which are required for bootstrapping a MariaDB/PostgreSQL deployment for the database requirements of the Redmine application.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This chart has been tested to work with NGINX Ingress, cert-manager, fluentd and Prometheus on top of the [BKPR](https://kubeprod.io/).

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
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

| Name                     | Description                                                                             | Value           |
| ------------------------ | --------------------------------------------------------------------------------------- | --------------- |
| `kubeVersion`            | Override Kubernetes version                                                             | `""`            |
| `nameOverride`           | String to partially override common.names.fullname                                      | `""`            |
| `fullnameOverride`       | String to fully override common.names.fullname                                          | `""`            |
| `commonLabels`           | Labels to add to all deployed objects                                                   | `{}`            |
| `commonAnnotations`      | Annotations to add to all deployed objects                                              | `{}`            |
| `clusterDomain`          | Default Kubernetes cluster domain                                                       | `cluster.local` |
| `extraDeploy`            | Array of extra objects to deploy with the release                                       | `[]`            |
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden) | `false`         |
| `diagnosticMode.command` | Command to override all containers in the the deployment                                | `["sleep"]`     |
| `diagnosticMode.args`    | Args to override all containers in the the deployment                                   | `["infinity"]`  |


### Redmine Configuration parameters

| Name                    | Description                                                            | Value                |
| ----------------------- | ---------------------------------------------------------------------- | -------------------- |
| `image.registry`        | Redmine image registry                                                 | `docker.io`          |
| `image.repository`      | Redmine image repository                                               | `bitnami/redmine`    |
| `image.tag`             | Redmine image tag (immutable tags are recommended)                     | `5.0.1-debian-10-r7` |
| `image.pullPolicy`      | Redmine image pull policy                                              | `IfNotPresent`       |
| `image.pullSecrets`     | Redmine image pull secrets                                             | `[]`                 |
| `image.debug`           | Enable image debug mode                                                | `false`              |
| `redmineUsername`       | Redmine username                                                       | `user`               |
| `redminePassword`       | Redmine user password                                                  | `""`                 |
| `redmineEmail`          | Redmine user email                                                     | `user@example.com`   |
| `redmineLanguage`       | Redmine default data language                                          | `en`                 |
| `allowEmptyPassword`    | Allow the container to be started with blank passwords                 | `false`              |
| `smtpHost`              | SMTP server host                                                       | `""`                 |
| `smtpPort`              | SMTP server port                                                       | `""`                 |
| `smtpUser`              | SMTP username                                                          | `""`                 |
| `smtpPassword`          | SMTP user password                                                     | `""`                 |
| `smtpProtocol`          | SMTP protocol                                                          | `""`                 |
| `existingSecret`        | Name of existing secret containing Redmine credentials                 | `""`                 |
| `smtpExistingSecret`    | The name of an existing secret with SMTP credentials                   | `""`                 |
| `customPostInitScripts` | Custom post-init.d user scripts                                        | `{}`                 |
| `command`               | Override default container command (useful when using custom images)   | `[]`                 |
| `args`                  | Override default container args (useful when using custom images)      | `[]`                 |
| `extraEnvVars`          | Array with extra environment variables to add to the Redmine container | `[]`                 |
| `extraEnvVarsCM`        | Name of existing ConfigMap containing extra env vars                   | `""`                 |
| `extraEnvVarsSecret`    | Name of existing Secret containing extra env vars                      | `""`                 |


### Redmine deployment parameters

| Name                                 | Description                                                                                                              | Value           |
| ------------------------------------ | ------------------------------------------------------------------------------------------------------------------------ | --------------- |
| `replicaCount`                       | Number of Redmine replicas to deploy                                                                                     | `1`             |
| `containerPorts.http`                | Redmine HTTP container port                                                                                              | `3000`          |
| `resources.limits`                   | The resources limits for the Redmine container                                                                           | `{}`            |
| `resources.requests`                 | The requested resources for the Redmine container                                                                        | `{}`            |
| `podSecurityContext.enabled`         | Enabled Redmine pods' Security Context                                                                                   | `false`         |
| `podSecurityContext.fsGroup`         | Set Redmine pod's Security Context fsGroup                                                                               | `1001`          |
| `containerSecurityContext.enabled`   | Enabled Redmine containers' Security Context                                                                             | `false`         |
| `containerSecurityContext.runAsUser` | Set Redmine container's Security Context runAsUser                                                                       | `1001`          |
| `livenessProbe.enabled`              | Enable livenessProbe on Redmine containers                                                                               | `true`          |
| `livenessProbe.path`                 | Path for to check for livenessProbe                                                                                      | `/`             |
| `livenessProbe.initialDelaySeconds`  | Initial delay seconds for livenessProbe                                                                                  | `300`           |
| `livenessProbe.periodSeconds`        | Period seconds for livenessProbe                                                                                         | `10`            |
| `livenessProbe.timeoutSeconds`       | Timeout seconds for livenessProbe                                                                                        | `5`             |
| `livenessProbe.failureThreshold`     | Failure threshold for livenessProbe                                                                                      | `6`             |
| `livenessProbe.successThreshold`     | Success threshold for livenessProbe                                                                                      | `1`             |
| `readinessProbe.enabled`             | Enable readinessProbe on Redmine containers                                                                              | `true`          |
| `readinessProbe.path`                | Path to check for readinessProbe                                                                                         | `/`             |
| `readinessProbe.initialDelaySeconds` | Initial delay seconds for readinessProbe                                                                                 | `5`             |
| `readinessProbe.periodSeconds`       | Period seconds for readinessProbe                                                                                        | `10`            |
| `readinessProbe.timeoutSeconds`      | Timeout seconds for readinessProbe                                                                                       | `5`             |
| `readinessProbe.failureThreshold`    | Failure threshold for readinessProbe                                                                                     | `6`             |
| `readinessProbe.successThreshold`    | Success threshold for readinessProbe                                                                                     | `1`             |
| `startupProbe.enabled`               | Enable startupProbe on Redmine containers                                                                                | `false`         |
| `startupProbe.path`                  | Path to check for startupProbe                                                                                           | `/`             |
| `startupProbe.initialDelaySeconds`   | Initial delay seconds for startupProbe                                                                                   | `300`           |
| `startupProbe.periodSeconds`         | Period seconds for startupProbe                                                                                          | `10`            |
| `startupProbe.timeoutSeconds`        | Timeout seconds for startupProbe                                                                                         | `5`             |
| `startupProbe.failureThreshold`      | Failure threshold for startupProbe                                                                                       | `6`             |
| `startupProbe.successThreshold`      | Success threshold for startupProbe                                                                                       | `1`             |
| `customLivenessProbe`                | Custom livenessProbe that overrides the default one                                                                      | `{}`            |
| `customReadinessProbe`               | Custom readinessProbe that overrides the default one                                                                     | `{}`            |
| `customStartupProbe`                 | Custom startupProbe that overrides the default one                                                                       | `{}`            |
| `lifecycleHooks`                     | LifecycleHooks to set additional configuration at startup                                                                | `{}`            |
| `hostAliases`                        | Redmine pod host aliases                                                                                                 | `[]`            |
| `podLabels`                          | Extra labels for Redmine pods                                                                                            | `{}`            |
| `podAnnotations`                     | Annotations for Redmine pods                                                                                             | `{}`            |
| `podAffinityPreset`                  | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                      | `""`            |
| `podAntiAffinityPreset`              | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                 | `soft`          |
| `nodeAffinityPreset.type`            | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                | `""`            |
| `nodeAffinityPreset.key`             | Node label key to match. Ignored if `affinity` is set                                                                    | `""`            |
| `nodeAffinityPreset.values`          | Node label values to match. Ignored if `affinity` is set                                                                 | `[]`            |
| `affinity`                           | Affinity for pod assignment                                                                                              | `{}`            |
| `nodeSelector`                       | Node labels for pod assignment                                                                                           | `{}`            |
| `tolerations`                        | Tolerations for pod assignment                                                                                           | `[]`            |
| `priorityClassName`                  | Redmine pods' Priority Class Name                                                                                        | `""`            |
| `schedulerName`                      | Alternate scheduler                                                                                                      | `""`            |
| `terminationGracePeriodSeconds`      | Seconds Redmine pod needs to terminate gracefully                                                                        | `""`            |
| `topologySpreadConstraints`          | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template | `{}`            |
| `updateStrategy.type`                | Redmine statefulset strategy type                                                                                        | `RollingUpdate` |
| `updateStrategy.rollingUpdate`       | Redmine statefulset rolling update configuration parameters                                                              | `{}`            |
| `extraVolumes`                       | Optionally specify extra list of additional volumes for Redmine pods                                                     | `[]`            |
| `extraVolumeMounts`                  | Optionally specify extra list of additional volumeMounts for Redmine container(s)                                        | `[]`            |
| `initContainers`                     | Add additional init containers to the Redmine pods                                                                       | `[]`            |
| `sidecars`                           | Add additional sidecar containers to the Redmine pod                                                                     | `[]`            |


### Traffic Exposure Parameters

| Name                               | Description                                                                                                                      | Value                    |
| ---------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `service.type`                     | Redmine service type                                                                                                             | `LoadBalancer`           |
| `service.ports.http`               | Redmine service HTTP port                                                                                                        | `80`                     |
| `service.nodePorts.http`           | NodePort for the Redmine HTTP endpoint                                                                                           | `""`                     |
| `service.sessionAffinity`          | Control where client requests go, to the same pod or round-robin                                                                 | `None`                   |
| `service.sessionAffinityConfig`    | Additional settings for the sessionAffinity                                                                                      | `{}`                     |
| `service.clusterIP`                | Redmine service Cluster IP                                                                                                       | `""`                     |
| `service.loadBalancerIP`           | Redmine service Load Balancer IP                                                                                                 | `""`                     |
| `service.loadBalancerSourceRanges` | Redmine service Load Balancer sources                                                                                            | `[]`                     |
| `service.externalTrafficPolicy`    | Redmine service external traffic policy                                                                                          | `Cluster`                |
| `service.annotations`              | Additional custom annotations for Redmine service                                                                                | `{}`                     |
| `service.extraPorts`               | Extra port to expose on Redmine service                                                                                          | `[]`                     |
| `ingress.enabled`                  | Enable ingress record generation for Redmine                                                                                     | `false`                  |
| `ingress.ingressClassName`         | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                    | `""`                     |
| `ingress.pathType`                 | Ingress path type                                                                                                                | `ImplementationSpecific` |
| `ingress.apiVersion`               | Force Ingress API version (automatically detected if not set)                                                                    | `""`                     |
| `ingress.hostname`                 | Default host for the ingress record                                                                                              | `redmine.local`          |
| `ingress.path`                     | Default path for the ingress record                                                                                              | `/`                      |
| `ingress.annotations`              | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                     |
| `ingress.tls`                      | Enable TLS configuration for the host defined at `ingress.hostname` parameter                                                    | `false`                  |
| `ingress.selfSigned`               | Create a TLS secret for this ingress record using self-signed certificates generated by Helm                                     | `false`                  |
| `ingress.extraHosts`               | An array with additional hostname(s) to be covered with the ingress record                                                       | `[]`                     |
| `ingress.extraPaths`               | An array with additional arbitrary paths that may need to be added to the ingress under the main host                            | `[]`                     |
| `ingress.extraTls`                 | The tls configuration for additional hostnames to be covered with this ingress record.                                           | `[]`                     |
| `ingress.secrets`                  | If you're providing your own certificates, please use this to add the certificates as secrets                                    | `[]`                     |
| `ingress.extraRules`               | Additional rules to be covered with this ingress record                                                                          | `[]`                     |


### Persistence Parameters

| Name                                                   | Description                                                                                     | Value   |
| ------------------------------------------------------ | ----------------------------------------------------------------------------------------------- | ------- |
| `persistence.enabled`                                  | Enable persistence using Persistent Volume Claims                                               | `true`  |
| `persistence.storageClass`                             | Persistent Volume storage class                                                                 | `""`    |
| `persistence.accessModes`                              | Persistent Volume access modes                                                                  | `[]`    |
| `persistence.size`                                     | Persistent Volume size                                                                          | `8Gi`   |
| `persistence.dataSource`                               | Custom PVC data source                                                                          | `{}`    |
| `persistence.annotations`                              | Annotations for the PVC                                                                         | `{}`    |
| `persistence.selector`                                 | Selector to match an existing Persistent Volume (this value is evaluated as a template)         | `{}`    |
| `persistence.existingClaim`                            | The name of an existing PVC to use for persistence                                              | `""`    |
| `volumePermissions.enabled`                            | Enable init container that changes the owner/group of the PV mount point to `runAsUser:fsGroup` | `false` |
| `volumePermissions.resources.limits`                   | The resources limits for the init container                                                     | `{}`    |
| `volumePermissions.resources.requests`                 | The requested resources for the init container                                                  | `{}`    |
| `volumePermissions.containerSecurityContext.enabled`   | Enable init container's Security Context                                                        | `true`  |
| `volumePermissions.containerSecurityContext.runAsUser` | Set init container's Security Context runAsUser                                                 | `0`     |


### RBAC Parameters

| Name                                          | Description                                                                                              | Value   |
| --------------------------------------------- | -------------------------------------------------------------------------------------------------------- | ------- |
| `serviceAccount.create`                       | Specifies whether a ServiceAccount should be created                                                     | `true`  |
| `serviceAccount.name`                         | The name of the ServiceAccount to create (name generated using common.names.fullname template otherwise) | `""`    |
| `serviceAccount.automountServiceAccountToken` | Auto-mount the service account token in the pod                                                          | `false` |
| `serviceAccount.annotations`                  | Additional custom annotations for the ServiceAccount                                                     | `{}`    |


### Other Parameters

| Name                       | Description                                                    | Value   |
| -------------------------- | -------------------------------------------------------------- | ------- |
| `pdb.create`               | Enable a Pod Disruption Budget creation                        | `false` |
| `pdb.minAvailable`         | Minimum number/percentage of pods that should remain scheduled | `""`    |
| `pdb.maxUnavailable`       | Maximum number/percentage of pods that may be made unavailable | `""`    |
| `autoscaling.enabled`      | Enable Horizontal POD autoscaling for Redmine                  | `false` |
| `autoscaling.minReplicas`  | Minimum number of Redmine replicas                             | `1`     |
| `autoscaling.maxReplicas`  | Maximum number of Redmine replicas                             | `11`    |
| `autoscaling.targetCPU`    | Target CPU utilization percentage                              | `50`    |
| `autoscaling.targetMemory` | Target Memory utilization percentage                           | `50`    |


### Database Parameters

| Name                                         | Description                                                             | Value             |
| -------------------------------------------- | ----------------------------------------------------------------------- | ----------------- |
| `databaseType`                               | Redmine database type. Allowed values: `mariadb` and `postgresql`       | `mariadb`         |
| `mariadb.enabled`                            | Switch to enable or disable the MariaDB helm chart                      | `true`            |
| `mariadb.auth.rootPassword`                  | MariaDB root password                                                   | `""`              |
| `mariadb.auth.username`                      | MariaDB username                                                        | `bn_redmine`      |
| `mariadb.auth.password`                      | MariaDB password                                                        | `""`              |
| `mariadb.auth.existingSecret`                | Name of existing secret to use for MariaDB credentials                  | `""`              |
| `mariadb.architecture`                       | MariaDB architecture. Allowed values: `standalone` or `replication`     | `standalone`      |
| `postgresql.enabled`                         | Switch to enable or disable the PostgreSQL helm chart                   | `true`            |
| `postgresql.auth.username`                   | Name for a custom user to create                                        | `bn_redmine`      |
| `postgresql.auth.password`                   | Password for the custom user to create                                  | `""`              |
| `postgresql.auth.database`                   | Name for a custom database to create                                    | `bitnami_redmine` |
| `postgresql.auth.existingSecret`             | Name of existing secret to use for PostgreSQL credentials               | `""`              |
| `postgresql.architecture`                    | PostgreSQL architecture (`standalone` or `replication`)                 | `standalone`      |
| `externalDatabase.host`                      | Database host                                                           | `""`              |
| `externalDatabase.port`                      | Database port number                                                    | `5432`            |
| `externalDatabase.user`                      | Non-root username for Redmine                                           | `bn_redmine`      |
| `externalDatabase.password`                  | Password for the non-root username for Redmine                          | `""`              |
| `externalDatabase.database`                  | Redmine database name                                                   | `bitnami_redmine` |
| `externalDatabase.existingSecret`            | Name of an existing secret resource containing the database credentials | `""`              |
| `externalDatabase.existingSecretPasswordKey` | Name of an existing secret key containing the database credentials      | `""`              |


### Mail Receiver/Cron Job Parameters

| Name                                                 | Description                                                                                                                                   | Value         |
| ---------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------- | ------------- |
| `mailReceiver.enabled`                               | Whether to enable scheduled mail-to-task CronJob                                                                                              | `false`       |
| `mailReceiver.schedule`                              | Kubernetes CronJob schedule                                                                                                                   | `*/5 * * * *` |
| `mailReceiver.suspend`                               | Whether to create suspended CronJob                                                                                                           | `true`        |
| `mailReceiver.mailProtocol`                          | Mail protocol to use for reading emails. Allowed values: `IMAP` and `POP3`                                                                    | `IMAP`        |
| `mailReceiver.host`                                  | Server to receive emails from                                                                                                                 | `""`          |
| `mailReceiver.port`                                  | TCP port on the `host`                                                                                                                        | `993`         |
| `mailReceiver.username`                              | Login to authenticate on the `host`                                                                                                           | `""`          |
| `mailReceiver.password`                              | Password to authenticate on the `host`                                                                                                        | `""`          |
| `mailReceiver.ssl`                                   | Whether use SSL/TLS to connect to the `host`                                                                                                  | `true`        |
| `mailReceiver.startTLS`                              | Whether use StartTLS to connect to the `host`                                                                                                 | `false`       |
| `mailReceiver.imapFolder`                            | IMAP only. Folder to read emails from                                                                                                         | `INBOX`       |
| `mailReceiver.moveOnSuccess`                         | IMAP only. Folder to move processed emails to                                                                                                 | `""`          |
| `mailReceiver.moveOnFailure`                         | IMAP only. Folder to move emails with processing errors to                                                                                    | `""`          |
| `mailReceiver.unknownUserAction`                     | Action to perform is an email received from unregistered user                                                                                 | `ignore`      |
| `mailReceiver.noPermissionCheck`                     | Whether skip permission check during creating a new task                                                                                      | `0`           |
| `mailReceiver.noAccountNotice`                       | Whether send an email to an unregistered user created during a new task creation                                                              | `1`           |
| `mailReceiver.defaultGroup`                          | Defines a group list to add created user to                                                                                                   | `""`          |
| `mailReceiver.project`                               | Defines identifier of the target project for a new task                                                                                       | `""`          |
| `mailReceiver.projectFromSubaddress`                 | Defines email address to select project from subaddress                                                                                       | `""`          |
| `mailReceiver.status`                                | Defines a new task status                                                                                                                     | `""`          |
| `mailReceiver.tracker`                               | Defines a new task tracker                                                                                                                    | `""`          |
| `mailReceiver.category`                              | Defines a new task category                                                                                                                   | `""`          |
| `mailReceiver.priority`                              | Defines a new task priority                                                                                                                   | `""`          |
| `mailReceiver.assignedTo`                            | Defines a new task assignee                                                                                                                   | `""`          |
| `mailReceiver.allowOverride`                         | Defines if email content is allowed to set attributes values. Values is a comma separated list of attributes or `all` to allow all attributes | `""`          |
| `mailReceiver.command`                               | Override default container command (useful when using custom images)                                                                          | `[]`          |
| `mailReceiver.args`                                  | Override default container args (useful when using custom images)                                                                             | `[]`          |
| `mailReceiver.extraEnvVars`                          | Extra environment variables to be set on mailReceiver container                                                                               | `[]`          |
| `mailReceiver.extraEnvVarsCM`                        | Name of existing ConfigMap containing extra env vars                                                                                          | `""`          |
| `mailReceiver.extraEnvVarsSecret`                    | Name of existing Secret containing extra env vars                                                                                             | `""`          |
| `mailReceiver.podSecurityContext.enabled`            | Enabled Redmine pods' Security Context                                                                                                        | `true`        |
| `mailReceiver.podSecurityContext.fsGroup`            | Set Redmine pod's Security Context fsGroup                                                                                                    | `1001`        |
| `mailReceiver.containerSecurityContext.enabled`      | mailReceiver Container securityContext                                                                                                        | `false`       |
| `mailReceiver.containerSecurityContext.runAsUser`    | User ID for the mailReceiver container                                                                                                        | `1001`        |
| `mailReceiver.containerSecurityContext.runAsNonRoot` | Whether to run the mailReceiver container as a non-root user                                                                                  | `true`        |
| `mailReceiver.podAnnotations`                        | Additional pod annotations                                                                                                                    | `{}`          |
| `mailReceiver.podLabels`                             | Additional pod labels                                                                                                                         | `{}`          |
| `mailReceiver.podAffinityPreset`                     | Pod affinity preset. Ignored if `mailReceiver.affinity` is set. Allowed values: `soft` or `hard`                                              | `""`          |
| `mailReceiver.podAntiAffinityPreset`                 | Pod anti-affinity preset. Ignored if `mailReceiver.affinity` is set. Allowed values: `soft` or `hard`                                         | `soft`        |
| `mailReceiver.nodeAffinityPreset.type`               | Node affinity preset. Ignored if `mailReceiver.affinity` is set. Allowed values: `soft` or `hard`                                             | `""`          |
| `mailReceiver.nodeAffinityPreset.key`                | Node label key to match. Ignored if `mailReceiver.affinity` is set.                                                                           | `""`          |
| `mailReceiver.nodeAffinityPreset.values`             | Node label values to match. Ignored if `mailReceiver.affinity` is set.                                                                        | `[]`          |
| `mailReceiver.affinity`                              | Affinity for pod assignment                                                                                                                   | `{}`          |
| `mailReceiver.nodeSelector`                          | Node labels for pod assignment                                                                                                                | `{}`          |
| `mailReceiver.tolerations`                           | Tolerations for pod assignment                                                                                                                | `[]`          |
| `mailReceiver.priorityClassName`                     | Redmine pods' priority.                                                                                                                       | `""`          |
| `mailReceiver.initContainers`                        | Add additional init containers to the mailReceiver pods                                                                                       | `[]`          |
| `mailReceiver.sidecars`                              | Add additional sidecar containers to the mailReceiver pods                                                                                    | `[]`          |
| `mailReceiver.extraVolumes`                          | Optionally specify extra list of additional volumes for mailReceiver container                                                                | `[]`          |
| `mailReceiver.extraVolumeMounts`                     | Optionally specify extra list of additional volumeMounts for mailReceiver container                                                           | `[]`          |


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
| `certificates.image.tag`                             | Redmine image tag (immutable tags are recommended)                 | `10-debian-10-r434`                      |
| `certificates.image.pullPolicy`                      | Redmine image pull policy                                          | `IfNotPresent`                           |
| `certificates.image.pullSecrets`                     | Redmine image pull secrets                                         | `[]`                                     |
| `certificates.extraEnvVars`                          | Container sidecar extra environment variables (e.g. proxy)         | `[]`                                     |


### NetworkPolicy parameters

| Name                                                          | Description                                                                                                                 | Value   |
| ------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------- | ------- |
| `networkPolicy.enabled`                                       | Enable network policies                                                                                                     | `false` |
| `networkPolicy.ingress.enabled`                               | Enable network policy for Ingress Proxies                                                                                   | `false` |
| `networkPolicy.ingress.namespaceSelector`                     | Ingress Proxy namespace selector labels. These labels will be used to identify the Ingress Proxy's namespace.               | `{}`    |
| `networkPolicy.ingress.podSelector`                           | Ingress Proxy pods selector labels. These labels will be used to identify the Ingress Proxy pods.                           | `{}`    |
| `networkPolicy.ingressRules.backendOnlyAccessibleByFrontend`  | Enable ingress rule that makes the backend (mariadb) only accessible by Redmine's pods.                                     | `false` |
| `networkPolicy.ingressRules.customBackendSelector`            | Backend selector labels. These labels will be used to identify the backend pods.                                            | `{}`    |
| `networkPolicy.ingressRules.accessOnlyFrom.enabled`           | Enable ingress rule that makes Redmine only accessible from a particular origin                                             | `false` |
| `networkPolicy.ingressRules.accessOnlyFrom.namespaceSelector` | Namespace selector label that is allowed to access Redmine. This label will be used to identified the allowed namespace(s). | `{}`    |
| `networkPolicy.ingressRules.accessOnlyFrom.podSelector`       | Pods selector label that is allowed to access Redmine. This label will be used to identified the allowed pod(s).            | `{}`    |
| `networkPolicy.ingressRules.customRules`                      | Custom network policy ingress rule                                                                                          | `{}`    |
| `networkPolicy.egressRules.denyConnectionsToExternal`         | Enable egress rule that denies outgoing traffic outside the cluster, except for DNS (port 53).                              | `false` |
| `networkPolicy.egressRules.customRules`                       | Custom network policy rule                                                                                                  | `{}`    |


The above parameters map to the env variables defined in [bitnami/redmine](https://github.com/bitnami/bitnami-docker-redmine). For more information please refer to the [bitnami/redmine](https://github.com/bitnami/bitnami-docker-redmine) image documentation.

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
>
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
---
readinessProbe:
  enabled: true
  path: /redmine/
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

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

Refer to the [chart documentation for more information about how to upgrade from previous releases](https://docs.bitnami.com/kubernetes/apps/redmine/administration/upgrade/).

## Community supported solution

Please, note this Helm chart is a community-supported solution. This means that the Bitnami team is not actively working on new features/improvements nor providing support through GitHub Issues for this Helm chart. Any new issue will stay open for 20 days to allow the community to contribute, after 15 days without activity the issue will be marked as stale being closed after 5 days.

The Bitnami team will review any PR that is created, feel free to create a PR if you find any issue or want to implement a new feature.

New versions are not going to be affected. Once a new version is released in the upstream project, the Bitnami container image will be updated to use the latest version.

## License

Copyright &copy; 2022 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.