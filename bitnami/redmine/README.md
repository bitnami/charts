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

The following table lists the configurable parameters of the Redmine chart and their default values.

| Parameter                 | Description                                     | Default                                                 |
|---------------------------|-------------------------------------------------|---------------------------------------------------------|
| `global.imageRegistry`    | Global Docker image registry                    | `nil`                                                   |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]` (does not add image pull secrets to deployed pods) |
| `global.storageClass`     | Global storage class for dynamic provisioning   | `nil`                                                   |

### Common parameters

| Parameter           | Description                                                                 | Default |
|---------------------|-----------------------------------------------------------------------------|---------|
| `nameOverride`      | String to partially override redmine.fullname template                      | `nil`   |
| `fullnameOverride`  | String to fully override redmine.fullname template                          | `nil`   |
| `commonLabels`      | Labels to add to all deployed objects                                       | `nil`   |
| `commonAnnotations` | Annotations to add to all deployed objects                                  | `[]`    |
| `extraDeploy`       | Array of extra objects to deploy with the release (evaluated as a template) | `nil`   |
| `kubeVersion`       | Force target Kubernetes version (using Helm capabilities if not set)        | `nil`   |

### Redmine parameters

| Parameter             | Description                                                                                                                                                   | Default                                                 |
|-----------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------|
| `image.registry`      | Redmine image registry                                                                                                                                        | `docker.io`                                             |
| `image.repository`    | Redmine image name                                                                                                                                            | `bitnami/redmine`                                       |
| `image.tag`           | Redmine image tag                                                                                                                                             | `{TAG_NAME}`                                            |
| `image.pullPolicy`    | Image pull policy                                                                                                                                             | `IfNotPresent`                                          |
| `image.pullSecrets`   | Specify docker-registry secret names as an array                                                                                                              | `[]` (does not add image pull secrets to deployed pods) |
| `hostAliases`         | Add deployment host aliases                                                                                                                                   | `[]`                                                    |
| `redmineUsername`     | User of the application                                                                                                                                       | `user`                                                  |
| `redminePassword`     | Application password                                                                                                                                          | _random 10 character long alphanumeric string_          |
| `redmineEmail`        | Admin email                                                                                                                                                   | `user@example.com`                                      |
| `redmineLanguage`     | Redmine default data language                                                                                                                                 | `en`                                                    |
| `smtpHost`            | SMTP host                                                                                                                                                     | `nil`                                                   |
| `smtpPort`            | SMTP port                                                                                                                                                     | `nil`                                                   |
| `smtpUser`            | SMTP user                                                                                                                                                     | `nil`                                                   |
| `smtpPassword`        | SMTP password                                                                                                                                                 | `nil`                                                   |
| `smtpTls`             | Use TLS encryption with SMTP                                                                                                                                  | `nil`                                                   |
| `command`             | Override default container command (useful when using custom images)                                                                                          | `[]`                                                    |
| `args`                | Override default container args (useful when using custom images)                                                                                             | `[]`                                                    |
| `containerPorts.http` | Redmine container HTTP port                                                                                                                                   | `3000`                                                  |
| `extraEnvVars`        | Extra environment variables to be set on redmine container                                                                                                    | `{}`                                                    |
| `extraEnvVarsCM`      | Name of existing ConfigMap containing extra env vars                                                                                                          | `nil`                                                   |
| `extraEnvVarsSecret`  | Name of existing Secret containing extra env vars                                                                                                             | `nil`                                                   |
| `existingSecret`      | Use existing secret for password details (`redminePassword` and `smtpPassword` will be ignored). Must contain the keys `redmine-password` and `smtp-password` | `nil`                                                   |

### Mailreceiver-CronJob parameters

| Parameter                                         | Description                                                                                                                                   | Default                                     |
|---------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------|
| `mailReceiver.enabled`                            | Whether to enable scheduled mail-to-task CronJob                                                                                              | `false`                                     |
| `mailReceiver.schedule`                           | Kubernetes CronJob schedule                                                                                                                   | `*/5 * * * *`                               |
| `mailReceiver.suspend`                            | Whether to create suspended CronJob                                                                                                           | `true`                                      |
| `mailReceiver.image.registry`                     | Mail to Task image registry                                                                                                                   | `docker.io`                                 |
| `mailReceiver.image.repository`                   | Mail to Task image repository                                                                                                                 | `bitnami/redmine`                           |
| `mailReceiver.image.tag`                          | Mail to Task image tag                                                                                                                        | `{TAG_NAME}`                                |
| `mailReceiver.image.pullPolicy`                   | Mail to Task image pull policy                                                                                                                | `IfNotPresent`                              |
| `mailReceiver.mailProtocol`                       | Mail protocol to use for reading emails: `IMAP` or `POP3`                                                                                     | `IMAP`                                      |
| `mailReceiver.host`                               | Server to receive emails from                                                                                                                 | `""`                                        |
| `mailReceiver.port`                               | TCP port on the `host`                                                                                                                        | `143`                                       |
| `mailReceiver.username`                           | Login to authenticate on the `host`                                                                                                           | `""`                                        |
| `mailReceiver.password`                           | Password to authenticate on the `host`                                                                                                        | `""`                                        |
| `mailReceiver.ssl`                                | Whether use SSL/TLS to connect to the `host`                                                                                                  | `true`                                      |
| `mailReceiver.startTLS`                           | Whether use StartTLS to connect to the `host`                                                                                                 | `false`                                     |
| `mailReceiver.imapFolder`                         | IMAP only. Folder to read emails from                                                                                                         | `INBOX`                                     |
| `mailReceiver.moveOnsuccess`                      | IMAP only. Folder to move processed emails to                                                                                                 | `""`                                        |
| `mailReceiver.moveOnFailure`                      | IMAP only. Folder to move emails with processing errors to                                                                                    | `""`                                        |
| `mailReceiver.unknownUserAction`                  | Action to perform is an email received from unregistered user                                                                                 | `ignore`                                    |
| `mailReceiver.noPermissionCheck`                  | Whether skip permission check during creating a new task                                                                                      | `0`                                         |
| `mailReceiver.noAccountNotice`                    | Whether send an email to an unregistered user created during a new task creation                                                              | `1`                                         |
| `mailReceiver.defaultGroup`                       | Defines a group list to add created user to                                                                                                   | `""`                                        |
| `mailReceiver.project`                            | Defines identifier of the target project for a new task                                                                                       | `""`                                        |
| `mailReceiver.projectFromSubaddress`              | Defines email address to select project from subaddress                                                                                       | `""`                                        |
| `mailReceiver.status`                             | Defines a new task status                                                                                                                     | `""`                                        |
| `mailReceiver.tracker`                            | Defines a new task tracker                                                                                                                    | `""`                                        |
| `mailReceiver.category`                           | Defines a new task category                                                                                                                   | `""`                                        |
| `mailReceiver.priority`                           | Defines a new task priority                                                                                                                   | `""`                                        |
| `mailReceiver.assignedTo`                         | Defines a new task priority                                                                                                                   | `""`                                        |
| `mailReceiver.allowOverride`                      | Defines if email content is allowed to set attributes values. Values is a comma separated list of attributes or `all` to allow all attributes | `""`                                        |
| `mailReceiver.podAnnotations`                     | Additional pod annotations                                                                                                                    | `{}`                                        |
| `mailReceiver.podLabels`                          | Additional pod labels                                                                                                                         | `{}`                                        |
| `mailReceiver.command`                            | Override default container command (useful when using custom images)                                                                          | `["bash"]`                                  |
| `mailReceiver.args`                               | Override default container args (useful when using custom images)                                                                             | `["-c", "/cj/receive.sh"]`                  |
| `mailReceiver.nodeSelector`                       | Node labels for pod assignment                                                                                                                | `{}` (The value is evaluated as a template) |
| `mailReceiver.tolerations`                        | List of node taints to tolerate                                                                                                               | `[]` (The value is evaluated as a template) |
| `mailReceiver.podSecurityContext.enabled`         | Enable security context for mailReceiver pods                                                                                                 | `true`                                      |
| `mailReceiver.podSecurityContext.fsGroup`         | Group ID for the volumes of the pod                                                                                                           | `1001`                                      |
| `mailReceiver.containerSecurityContext.enabled`   | mailReceiver Container securityContext                                                                                                        | `false`                                     |
| `mailReceiver.containerSecurityContext.runAsUser` | User ID for the mailReceiver container                                                                                                        | `1001`                                      |
| `mailReceiver.podAffinityPreset`                  | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                           | `""`                                        |
| `mailReceiver.podAntiAffinityPreset`              | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                      | `soft`                                      |
| `mailReceiver.nodeAffinityPreset.type`            | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                     | `""`                                        |
| `mailReceiver.nodeAffinityPreset.key`             | Node label key to match Ignored if `affinity` is set.                                                                                         | `""`                                        |
| `mailReceiver.nodeAffinityPreset.values`          | Node label values to match. Ignored if `affinity` is set.                                                                                     | `[]`                                        |
| `mailReceiver.affinity`                           | Affinity for pod assignment                                                                                                                   | `{}` (evaluated as a template)              |
| `mailReceiver.extraEnvVars`                       | Extra environment variables to be set on mailReceiver container                                                                               | `{}`                                        |
| `mailReceiver.extraEnvVarsCM`                     | Name of existing ConfigMap containing extra env vars                                                                                          | `nil`                                       |
| `mailReceiver.extraEnvVarsSecret`                 | Name of existing Secret containing extra env vars                                                                                             | `nil`                                       |
| `mailReceiver.extraVolumeMounts`                  | Optionally specify extra list of additional volumeMounts for mailReceiver container                                                           | `[]`                                        |
| `mailReceiver.extraVolumes`                       | Optionally specify extra list of additional volumes for mailReceiver container                                                                | `[]`                                        |
| `mailReceiver.initContainers`                     | Add additional init containers to the mailReceiver pods                                                                                       | `{}` (evaluated as a template)              |
| `mailReceiver.sidecars`                           | Add additional sidecar containers to the mailReceiver pods                                                                                    | `{}` (evaluated as a template)              |

### Volume Permissions parameters

| Parameter                             | Description                                                                                                                                               | Default                                                 |
|---------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------|
| `volumePermissions.enabled`           | Enable init container that changes volume permissions in the data directory (for cases where the default k8s `runAsUser` and `fsUser` values do not work) | `false`                                                 |
| `volumePermissions.image.registry`    | Init container volume-permissions image registry                                                                                                          | `docker.io`                                             |
| `volumePermissions.image.repository`  | Init container volume-permissions image name                                                                                                              | `bitnami/bitnami-shell`                                 |
| `volumePermissions.image.tag`         | Init container volume-permissions image tag                                                                                                               | `"10"`                                                  |
| `volumePermissions.image.pullSecrets` | Specify docker-registry secret names as an array                                                                                                          | `[]` (does not add image pull secrets to deployed pods) |
| `volumePermissions.image.pullPolicy`  | Init container volume-permissions image pull policy                                                                                                       | `Always`                                                |
| `volumePermissions.resources`         | Init container resource requests/limit                                                                                                                    | `nil`                                                   |

### Database parameters

| Parameter                         | Description                                                                                                                              | Default                                                |
|-----------------------------------|------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------|
| `databaseType`                    | Select database type                                                                                                                     | `mariadb` (allowed values: "mariadb" and "postgresql") |
| `mariadb.enabled`                 | Whether to deploy a MariaDB server to satisfy the database requirements                                                                  | `true`                                                 |
| `mariadb.existingSecret`          | Optional secret storing the MariaDB passwords                                                                                            | `nil`                                                  |
| `mariadb.auth.rootPassword`       | MariaDB admin password                                                                                                                   | `nil`                                                  |
| `postgresql.enabled`              | Whether to deploy a PostgreSQL server to satisfy the database requirements                                                               | `false`                                                |
| `postgresql.postgresqlDatabase`   | PostgreSQL database                                                                                                                      | `bitnami_redmine`                                      |
| `postgresql.postgresqlUsername`   | PostgreSQL user                                                                                                                          | `bn_redmine`                                           |
| `postgresql.postgresqlPassword`   | PostgreSQL password                                                                                                                      | `nil`                                                  |
| `externalDatabase.host`           | Host of the external database                                                                                                            | `""`                                                   |
| `externalDatabase.name`           | Name of the external database                                                                                                            | `bitnami_redmine`                                      |
| `externalDatabase.user`           | External db user                                                                                                                         | `bn_redmine`                                           |
| `externalDatabase.password`       | Password for the db user                                                                                                                 | `""`                                                   |
| `externalDatabase.port`           | Database port number                                                                                                                     | `3306`                                                 |
| `externalDatabase.existingSecret` | Use an existing secret for external db password. Must contain the keys `redmine-password` or `mariadb-password` depending on the DB type | `""`                                                   |

### Deployment parameters

| Parameter                            | Description                                                                               | Default                                     |
|--------------------------------------|-------------------------------------------------------------------------------------------|---------------------------------------------|
| `replicas`                           | The number of pod replicas                                                                | `1`                                         |
| `updateStrategy.type`                | Update strategy to use for the deployment                                                 | `RollingUpdate`                             |
| `priorityClassName`                  | Redmine priorityClassName                                                                 | `nil`                                       |
| `nodeSelector`                       | Node labels for pod assignment                                                            | `{}` (The value is evaluated as a template) |
| `tolerations`                        | List of node taints to tolerate                                                           | `[]` (The value is evaluated as a template) |
| `podAnnotations`                     | Additional pod annotations                                                                | `{}`                                        |
| `podLabels`                          | Additional pod labels                                                                     | `{}`                                        |
| `podAffinityPreset`                  | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`       | `""`                                        |
| `podAntiAffinityPreset`              | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`  | `soft`                                      |
| `nodeAffinityPreset.type`            | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard` | `""`                                        |
| `nodeAffinityPreset.key`             | Node label key to match Ignored if `affinity` is set.                                     | `""`                                        |
| `nodeAffinityPreset.values`          | Node label values to match. Ignored if `affinity` is set.                                 | `[]`                                        |
| `affinity`                           | Affinity for pod assignment                                                               | `{}` (evaluated as a template)              |
| `podAnnotations`                     | Pod annotations                                                                           | `{}`                                        |
| `podSecurityContext.enabled`         | Enable security context for Redmine pods                                                  | `false`                                     |
| `podSecurityContext.fsGroup`         | Group ID for the volumes of the pod                                                       | `0`                                         |
| `containerSecurityContext.enabled`   | Redmine Container securityContext                                                         | `false`                                     |
| `containerSecurityContext.runAsUser` | User ID for the Redmine container                                                         | `0`                                         |
| `livenessProbe.enabled`              | Whether to enable the livenessProbe or not                                                | `true`                                      |
| `livenessProbe.enabled`              | The path against which to perform the livenessProbe                                       | `/`                                         |
| `livenessProbe.initialDelaySeconds`  | Delay before liveness probe is initiated                                                  | 300                                         |
| `livenessProbe.periodSeconds`        | How often to perform the probe                                                            | 10                                          |
| `livenessProbe.timeoutSeconds`       | When the probe times out                                                                  | 5                                           |
| `livenessProbe.successThreshold`     | Minimum consecutive successes for the probe                                               | 1                                           |
| `livenessProbe.failureThreshold`     | Minimum consecutive failures for the probe                                                | 3                                           |
| `readinessProbe.enabled`             | Whether to enable the livenessProbe or not                                                | `true`                                      |
| `readinessProbe.enabled`             | The path against which to perform the readinessProbe                                      | `/`                                         |
| `readinessProbe.initialDelaySeconds` | Delay before readiness probe is initiated                                                 | 5                                           |
| `readinessProbe.periodSeconds`       | How often to perform the probe                                                            | 10                                          |
| `readinessProbe.timeoutSeconds`      | When the probe times out                                                                  | 1                                           |
| `readinessProbe.successThreshold`    | Minimum consecutive successes for the probe                                               | 1                                           |
| `readinessProbe.failureThreshold`    | Minimum consecutive failures for the probe                                                | 3                                           |
| `customLivenessProbe`                | Override default liveness probe                                                           | `nil`                                       |
| `customReadinessProbe`               | Override default readiness probe                                                          | `nil`                                       |
| `resources`                          | Resources allocation (Requests and Limits)                                                | `{}`                                        |
| `extraVolumeMounts`                  | Optionally specify extra list of additional volumeMounts for redmine container            | `[]`                                        |
| `extraVolumes`                       | Optionally specify extra list of additional volumes for redmine container                 | `[]`                                        |
| `initContainers`                     | Add additional init containers to the redmine pods                                        | `{}` (evaluated as a template)              |
| `sidecars`                           | Add additional sidecar containers to the redmine pods                                     | `{}` (evaluated as a template)              |

### Exposure parameters

| Parameter                          | Description                                                          | Default                                      |
|------------------------------------|----------------------------------------------------------------------|----------------------------------------------|
| `service.type`                     | Kubernetes Service type                                              | `LoadBalancer`                               |
| `service.port`                     | Service HTTP port                                                    | `80`                                         |
| `service.clusterIP`                | Redmine service clusterIP IP                                         | `None`                                       |
| `service.nodePorts.http`           | Kubernetes http node port                                            | `""`                                         |
| `service.externalTrafficPolicy`    | Enable client source IP preservation                                 | `Cluster`                                    |
| `service.loadBalancerIP`           | LoadBalancer service IP address                                      | `""`                                         |
| `service.loadBalancerSourceRanges` | An array of load balancer sources                                    | `0.0.0.0/0`                                  |
| `serviceAccount.create`            | Specifies whether a ServiceAccount should be created                 | `false`                                      |
| `serviceAccount.name`              | The name of the ServiceAccount to create                             | Generated using the `redmine.fullname` macro |
| `service.sessionAffinity`          | Session Affinity for Kubernetes service, can be "None" or "ClientIP" | `None`                                       |
| `ingress.enabled`                  | Enable ingress controller resource                                   | `false`                                      |
| `ingress.certManager`              | Add annotations for cert-manager                                     | `false`                                      |
| `ingress.path`                     | Ingress path                                                         | `/`                                          |
| `ingress.pathType`                 | Ingress path type                                                    | `ImplementationSpecific`                     |
| `ingress.hostname`                 | Default host for the ingress resource                                | `redmine.local`                              |
| `ingress.tls`                      | Enable TLS configuration                                             | `false`                                      |
| `ingress.annotations`              | Ingress annotations                                                  | `{}`                                         |
| `ingress.extraHosts[0].name`       | Extra hosts for your Redmine installation                            | `nil`                                        |
| `ingress.extraHosts[0].path`       | Path within the url structure                                        | `nil`                                        |
| `ingress.extraTls[0].hosts[0]`     | Extra TLS hosts                                                      | `nil`                                        |
| `ingress.extraTls[0].secretName`   | TLS Secret (certificates) for extra TLS hosts                        | `nil`                                        |
| `ingress.secrets[0].name`          | TLS Secret Name                                                      | `nil`                                        |
| `ingress.secrets[0].certificate`   | TLS Secret Certificate                                               | `nil`                                        |
| `ingress.secrets[0].key`           | TLS Secret Key                                                       | `nil`                                        |

### Persistence parameters

| Parameter                   | Description                  | Default                                     |
|-----------------------------|------------------------------|---------------------------------------------|
| `persistence.enabled`       | Enable persistence using PVC | `true`                                      |
| `persistence.existingClaim` | The name of an existing PVC  | `nil`                                       |
| `persistence.storageClass`  | PVC Storage Class            | `nil` (uses alpha storage class annotation) |
| `persistence.accessModes`   | PVC Access Modes             | `[ReadWriteOnce]`                           |
| `persistence.size`          | PVC Storage Request          | `8Gi`                                       |

### Pod Disruption parameters

| Parameter                            | Description                  | Default |
|--------------------------------------|------------------------------|---------|
| `podDisruptionBudget.enabled`        | Pod Disruption Budget toggle | `false` |
| `podDisruptionBudget.minAvailable`   | Minimum available pods       | `nil`   |
| `podDisruptionBudget.maxUnavailable` | Maximum unavailable pods     | `nil`   |

### Custom Certificates parameters
| Parameter                                            | Description                                                        | Default                                  |
|------------------------------------------------------|--------------------------------------------------------------------|------------------------------------------|
| `certificates.customCertificate.certificateSecret`   | Secret containing the certificate and key to add                   | `""`                                     |
| `certificates.customCertificate.chainSecret.name`    | Name of the secret containing the certificate chain                | `""`                                     |
| `certificates.customCertificate.chainSecret.key`     | Key of the certificate chain file inside the secret                | `""`                                     |
| `certificates.customCertificate.certificateLocation` | Location in the container to store the certificate                 | `/etc/ssl/certs/ssl-cert-snakeoil.pem`   |
| `certificates.customCertificate.keyLocation`         | Location in the container to store the private key                 | `/etc/ssl/private/ssl-cert-snakeoil.key` |
| `certificates.customCertificate.chainLocation`       | Location in the container to store the certificate chain           | `/etc/ssl/certs/chain.pem`               |
| `certificates.customCA`                              | Defines a list of secrets to import into the container trust store | `[]`                                     |
| `certificates.image.registry`                        | Container sidecar registry                                         | `docker.io`                              |
| `certificates.image.repository`                      | Container sidecar image                                            | `bitnami/bitnami-shell`                  |
| `certificates.image.tag`                             | Container sidecar image tag                                        | `"10"`                                   |
| `certificates.image.pullPolicy`                      | Container sidecar image pull policy                                | `IfNotPresent`                           |
| `certificates.image.pullSecrets`                     | Container sidecar image pull secrets                               | `image.pullSecrets`                      |
| `certificates.extraEnvVars`                          | Container sidecar extra environment variables (eg proxy)           | `[]`                                     |

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

### Deploying to a sub-URI

(adapted from https://github.com/bitnami/bitnami-docker-redmine)

On certain occasions, you may need that Redmine is available under a specific sub-URI path rather than the root. A common scenario to this problem may arise if you plan to set up your Redmine container behind a reverse proxy. To deploy your Redmine container using a certain sub-URI you just need to follow these steps:

#### Create a configmap containing an altered version of init.sh

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: redmine-init-configmap
  namespace: <same-namespace-as-the-chart>
  labels:
  ...
data:

  init.sh: |-

    #!/bin/bash

    # Set default values depending on database variation
    if [ -n "$REDMINE_DB_POSTGRES" ]; then
        export REDMINE_DB_PORT_NUMBER=${REDMINE_DB_PORT_NUMBER:-5432}
        export REDMINE_DB_USERNAME=${REDMINE_DB_USERNAME:-postgres}
    elif [ -n "$REDMINE_DB_MYSQL" ]; then
        export REDMINE_DB_PORT_NUMBER=${REDMINE_DB_PORT_NUMBER:-3306}
        export REDMINE_DB_USERNAME=${REDMINE_DB_USERNAME:-root}
    fi

    # REPLACE WITH YOUR OWN SUB-URI
    SUB_URI_PATH='/redmine'

    #Config files where to apply changes
    config1=/opt/bitnami/redmine/config.ru
    config2=/opt/bitnami/redmine/config/environment.rb

    if [[ ! -d /opt/bitnami/redmine/conf/ ]]; then
        sed -i '$ d' ${config1}
        echo 'map ActionController::Base.config.try(:relative_url_root) || "/" do' >> ${config1}
        echo 'run Rails.application' >> ${config1}
        echo 'end' >> ${config1}
        echo 'Redmine::Utils::relative_url_root = "'${SUB_URI_PATH}'"' >> ${config2}
    fi

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
    mountPath: "/init.sh"
    subPath: init.sh
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
