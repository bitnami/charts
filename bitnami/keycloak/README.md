# Keycloak

[Keycloak](https://www.keycloak.org) is a high performance Java-based identity and access management solution. It lets developers add an authentication layer to their applications with minimum effort.

## TL;DR

```console
  helm repo add bitnami https://charts.bitnami.com/bitnami
  helm install my-release bitnami/keycloak
```

## Introduction

Bitnami charts for Helm are carefully engineered, actively maintained and are the quickest and easiest way to deploy containers on a Kubernetes cluster that are ready to handle production workloads.

This chart bootstraps a [Keycloak](https://github.com/bitnami/bitnami-docker-keycloak) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This Helm chart has been tested on top of [Bitnami Kubernetes Production Runtime](https://kubeprod.io/) (BKPR). Deploy BKPR to get automated TLS certificates, logging and monitoring for your applications.

## Prerequisites

- Kubernetes 1.12+
- Helm 3.1.0

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/keycloak
```

These commands deploy a Keycloak application on the Kubernetes cluster in the default configuration.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

The following tables lists the configurable parameters of the Keycloak chart and their default values per section/component:

### Global parameters

| Parameter                 | Description                                     | Default                                                 |
|---------------------------|-------------------------------------------------|---------------------------------------------------------|
| `global.imageRegistry`    | Global Docker image registry                    | `nil`                                                   |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]` (does not add image pull secrets to deployed pods) |
| `global.storageClass`     | Global storage class for dynamic provisioning   | `nil`                                                   |

### Common parameters

| Parameter           | Description                                                          | Default                        |
|---------------------|----------------------------------------------------------------------|--------------------------------|
| `nameOverride`      | String to partially override keycloak.fullname                       | `nil`                          |
| `fullnameOverride`  | String to fully override keycloak.fullname                           | `nil`                          |
| `commonLabels`      | Labels to add to all deployed objects                                | `{}`                           |
| `commonAnnotations` | Annotations to add to all deployed objects                           | `{}`                           |
| `clusterDomain`     | Default Kubernetes cluster domain                                    | `cluster.local`                |
| `extraDeploy`       | Array of extra objects to deploy with the release                    | `[]` (evaluated as a template) |
| `kubeVersion`       | Force target Kubernetes version (using Helm capabilities if not set) | `nil`                          |

### Keycloak parameters

| Parameter                         | Description                                                                                                                                                   | Default                                                 |
|-----------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------|
| `image.registry`                  | Keycloak image registry                                                                                                                                       | `docker.io`                                             |
| `image.repository`                | Keycloak image name                                                                                                                                           | `bitnami/keycloak`                                      |
| `image.tag`                       | Keycloak image tag                                                                                                                                            | `{TAG_NAME}`                                            |
| `image.pullPolicy`                | Keycloak image pull policy                                                                                                                                    | `IfNotPresent`                                          |
| `image.pullSecrets`               | Specify docker-registry secret names as an array                                                                                                              | `[]` (does not add image pull secrets to deployed pods) |
| `image.debug`                     | Specify if debug logs should be enabled                                                                                                                       | `false`                                                 |
| `auth.createAdminUser`            | Create administrator user on boot                                                                                                                             | `true`                                                  |
| `auth.adminUser`                  | Keycloak administrator name                                                                                                                                   | `user`                                                  |
| `auth.adminPassword`              | Keycloak administrator password for the new user                                                                                                              | _random 10 character long alphanumeric string_          |
| `auth.managementUser`             | Wildfly management user                                                                                                                                       | `manager`                                               |
| `auth.managementPassword`         | Wildfly management password                                                                                                                                   | _random 10 character long alphanumeric string_          |
| `auth.tls.enabled`                | Enable TLS encryption                                                                                                                                         | `false`                                                 |
| `auth.tls.jksSecret`              | Existing secret containing the truststore and one keystore per Keycloak replica                                                                               | `nil`                                                   |
| `auth.tls.keystorePassword`       | Password to access the keystore when it's password-protected                                                                                                  | `nil`                                                   |
| `auth.tls.truststorePassword`     | Password to access the truststore when it's password-protected                                                                                                | `nil`                                                   |
| `auth.tls.image.registry`         | TLS init container image registry                                                                                                                             | `docker.io`                                             |
| `auth.tls.image.repository`       | TLS init container image repository                                                                                                                           | `bitnami/bitnami-shell`                                 |
| `auth.tls.image.tag`              | TLS init container image tag                                                                                                                                  | `"10"`                                                  |
| `auth.tls.image.pullPolicy`       | TLS init container image pull policy                                                                                                                          | `Always`                                                |
| `auth.tls.image.pullSecrets`      | TLS init container image pull secrets                                                                                                                         | `[]` (does not add image pull secrets to deployed pods) |
| `auth.tls.resources.limits`       | The resources limits for the TLS init container                                                                                                               | `{}`                                                    |
| `auth.tls.resources.requests`     | The requested resources for the TLS init container                                                                                                            | `{}`                                                    |
| `auth.existingSecret.name`        | Name for an existing secret containing passwords                                                                                                              | `nil`                                                   |
| `auth.existingSecret.keyMapping`  | Key mapping between the expected keys and the existing secret's keys. [See more](https://github.com/bitnami/charts/tree/master/bitnami/common#existingsecret) | `nil`                                                   |
| `auth.existingSecretPerPassword.adminPassword.name`  | Name of the secret which contains the Keycloak admin password. Overrides `existingSecret` and `adminPassword` and  | `nil`                                                   |
| `auth.existingSecretPerPassword.managementPassword.name`  | Name of the secret which contains the Widlfly admin password. Overrides `existingSecret` and `managementPassword` and  | `nil`                                                   |
| `auth.existingSecretPerPassword.databasePassword.name`  | Name of the secret which contains the database password. Overrides `existingSecret` and `databaseEncryptedPassword` and  | `nil`                                                   |
| `auth.existingSecretPerPassword.tlsKeystorePassword.name`  | Name of the secret which contains the JKS keystore password. Overrides `existingSecret` and `keystorePassword` and  | `nil`                                                   |
| `auth.existingSecretPerPassword.tlsTruststorePassword.name`  | Name of the secret which contains the JKS truststore password. Overrides `existingSecret` and `truststorePassword` and  | `nil`                                                   |
| `auth.existingSecretPerPassword.keyMapping`  | Key mapping between the expected keys and the existing secrets' keys. [See more](https://github.com/bitnami/charts/tree/master/bitnami/common#existingsecret) | `nil`
| `proxyAddressForwarding`          | Enable Proxy Address Forwarding                                                                                                                               | `false`                                                 |
| `serviceDiscovery.enabled`        | Enable Service Discovery for Keycloak (required if `replicaCount` > `1`)                                                                                      | `false`                                                 |
| `serviceDiscovery.protocol`       | Sets the protocol that Keycloak nodes would use to discover new peers                                                                                         | `kubernetes.KUBE_PING`                                  |
| `serviceDiscovery.properties`     | Properties for the discovery protocol set in `serviceDiscovery.protocol` parameter                                                                            | `[]`                                                    |
| `serviceDiscovery.transportStack` | Transport stack for the discovery protocol set in `serviceDiscovery.protocol` parameter                                                                       | `tcp`                                                   |
| `cache.ownersCount`               | Number of nodes that will replicate cached data                                                                                                               | `1`                                                     |
| `cache.authOwnersCount`           | Number of nodes that will replicate cached authentication data                                                                                                | `1`                                                     |
| `configuration`                   | Keycloak Configuration. Auto-generated based on other parameters when not specified                                                                           | `nil`                                                   |
| `existingConfigmap`               | Name of existing ConfigMap with Keycloak configuration                                                                                                        | `nil`                                                   |
| `hostAliases`                     | Add deployment host aliases                                                                                                                                   | `[]`                                                    |
| `initdbScripts`                   | Dictionary of initdb scripts                                                                                                                                  | `{}` (evaluated as a template)                          |
| `initdbScriptsConfigMap`          | ConfigMap with the initdb scripts (Note: Overrides `initdbScripts`)                                                                                           | `nil`                                                   |
| `command`                         | Override default container command (useful when using custom images)                                                                                          | `nil`                                                   |
| `args`                            | Override default container args (useful when using custom images)                                                                                             | `nil`                                                   |
| `extraStartupArgs`                | Extra default startup args                                                                                                                                    | `nil`                                                   |
| `extraEnvVars`                    | Extra environment variables to be set on Keycloak container                                                                                                   | `{}`                                                    |
| `extraEnvVarsCM`                  | Name of existing ConfigMap containing extra env vars                                                                                                          | `nil`                                                   |
| `extraEnvVarsSecret`              | Name of existing Secret containing extra env vars                                                                                                             | `nil`                                                   |

### keycloak-config-cli parameters

| Parameter                                    | Description                                                                                     | Default                                                 |
| -------------------------------------------- | ----------------------------------------------------------------------------------------------- | ------------------------------------------------------- |
| `keycloakConfigCli.enabled`                  | Whether to enable keycloak-config-cli                                                           | `false`                                                 |
| `keycloakConfigCli.image.registry`           | keycloak-config-cli container image registry                                                    | `docker.io`                                             |
| `keycloakConfigCli.image.repository`         | keycloak-config-cli container image repository                                                  | `bitnami/keycloak-config-cli`                           |
| `keycloakConfigCli.image.tag`                | keycloak-config-cli container image tag                                                         | `{TAG_NAME}`                                            |
| `keycloakConfigCli.image.pullPolicy`         | keycloak-config-cli container image pull policy                                                 | `IfNotPresent`                                          |
| `keycloakConfigCli.image.pullSecrets`        | keycloak-config-cli container image pull secrets                                                | `[]` (does not add image pull secrets to deployed pods) |
| `keycloakConfigCli.annotations`              | Annotations for keycloak-config-cli job                                                         | Check `values.yaml` file                                |
| `keycloakConfigCli.command`                  | Command for running the container (set to default if not set). Use array form                   | `[]`                                                    |
| `keycloakConfigCli.args`                     | Args for running the container (set to default if not set). Use array form                      | `[]`                                                    |
| `keycloakConfigCli.hostAliases`              | Job pod host aliases                                                                            | `[]`                                                    |
| `keycloakConfigCli.resources.limits`         | The resources limits for the keycloak-config-cli container                                      | `{}`                                                    |
| `keycloakConfigCli.resources.requests`       | The requested resources for the keycloak-config-cli container                                   | `{}`                                                    |
| `keycloakConfigCli.containerSecurityContext` | keycloak-config-cli containers' Security Context                                                | Check `values.yaml` file                                |
| `keycloakConfigCli.podSecurityContext`       | keycloak-config-cli pods' Security Context                                                      | Check `values.yaml` file                                |
| `keycloakConfigCli.backoffLimit`             | Number of retries before considering a Job as failed                                            | `1`                                                     |
| `keycloakConfigCli.podLabels`                | Pod extra labels                                                                                | `{}`                                                    |
| `keycloakConfigCli.podAnnotations`           | Annotations for job pod                                                                         | `{}`                                                    |
| `keycloakConfigCli.extraEnvVars`             | Additional environment variables to set                                                         | `[]`                                                    |
| `keycloakConfigCli.extraEnvVarsCM`           | ConfigMap with extra environment variables                                                      | `nil`                                                   |
| `keycloakConfigCli.extraEnvVarsSecret`       | Secret with extra environment variables                                                         | `nil`                                                   |
| `keycloakConfigCli.extraVolumes`             | Extra volumes to add to the job                                                                 | `[]`                                                    |
| `keycloakConfigCli.extraVolumeMounts`        | Extra volume mounts to add to the container                                                     | `[]`                                                    |
| `keycloakConfigCli.configuration`            | keycloak-config-cli realms configuration                                                        | `{}`                                                    |
| `keycloakConfigCli.existingConfigmap`        | ConfigMap with keycloak-config-cli configuration. This will override `keycloakConfigCli.config` | `nil`                                                   |

### Keycloak deployment/statefulset parameters

| Parameter                   | Description                                                                               | Default                        |
|-----------------------------|-------------------------------------------------------------------------------------------|--------------------------------|
| `replicaCount`              | Number of Keycloak replicas to deploy                                                     | `1`                            |
| `containerPorts.http`       | HTTP port to expose at container level                                                    | `8080`                         |
| `containerPorts.https`      | HTTPS port to expose at container level                                                   | `8443`                         |
| `podSecurityContext`        | Keycloak pods' Security Context                                                           | Check `values.yaml` file       |
| `containerSecurityContext`  | Keycloak containers' Security Context                                                     | Check `values.yaml` file       |
| `resources.limits`          | The resources limits for the Keycloak container                                           | `{}`                           |
| `resources.requests`        | The requested resources for the Keycloak container                                        | `{}`                           |
| `lifecycleHooks`            | LifecycleHooks to set additional configuration at startup.                                | `{}` (evaluated as a template) |
| `livenessProbe`             | Liveness probe configuration for Keycloak                                                 | Check `values.yaml` file       |
| `readinessProbe`            | Readiness probe configuration for Keycloak                                                | Check `values.yaml` file       |
| `customLivenessProbe`       | Override default liveness probe                                                           | `nil`                          |
| `customReadinessProbe`      | Override default readiness probe                                                          | `nil`                          |
| `updateStrategy`            | Strategy to use to update Pods                                                            | Check `values.yaml` file       |
| `podAffinityPreset`         | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`       | `""`                           |
| `podAntiAffinityPreset`     | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`  | `soft`                         |
| `nodeAffinityPreset.type`   | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard` | `""`                           |
| `nodeAffinityPreset.key`    | Node label key to match. Ignored if `affinity` is set.                                    | `""`                           |
| `nodeAffinityPreset.values` | Node label values to match. Ignored if `affinity` is set.                                 | `[]`                           |
| `affinity`                  | Affinity for pod assignment                                                               | `{}` (evaluated as a template) |
| `nodeSelector`              | Node labels for pod assignment                                                            | `{}` (evaluated as a template) |
| `tolerations`               | Tolerations for pod assignment                                                            | `[]` (evaluated as a template) |
| `podLabels`                 | Extra labels for Keycloak pods                                                            | `{}`                           |
| `podAnnotations`            | Annotations for Keycloak pods                                                             | `{}`                           |
| `priorityClassName`         | Controller priorityClassName                                                              | `nil`                          |
| `lifecycleHooks`            | LifecycleHooks to set additional configuration at startup.                                | `{}` (evaluated as a template) |
| `extraVolumeMounts`         | Optionally specify extra list of additional volumeMounts for Keycloak container(s)        | `[]`                           |
| `extraVolumes`              | Optionally specify extra list of additional volumes for Keycloak pods                     | `[]`                           |
| `initContainers`            | Add additional init containers to the Keycloak pods                                       | `{}` (evaluated as a template) |
| `sidecars`                  | Add additional sidecar containers to the Keycloak pods                                    | `{}` (evaluated as a template) |

### Exposure parameters

| Parameter                          | Description                                                                       | Default                        |
|------------------------------------|-----------------------------------------------------------------------------------|--------------------------------|
| `service.type`                     | Kubernetes service type                                                           | `LoadBalancer`                 |
| `service.port`                     | Service HTTP port                                                                 | `80`                           |
| `service.nodePort`                 | Service HTTPS port                                                                | `443`                          |
| `service.nodePorts.http`           | Kubernetes HTTP node port                                                         | `""`                           |
| `service.nodePorts.https`          | Kubernetes HTTPS node port                                                        | `""`                           |
| `service.clusterIP`                | Keycloak service clusterIP IP                                                     | `None`                         |
| `service.externalTrafficPolicy`    | Enable client source IP preservation                                              | `Cluster`                      |
| `service.loadBalancerIP`           | loadBalancerIP if service type is `LoadBalancer`                                  | `nil`                          |
| `service.loadBalancerSourceRanges` | Address that are allowed when service is LoadBalancer                             | `[]`                           |
| `service.annotations`              | Annotations for Keycloak service                                                  | `{}` (evaluated as a template) |
| `ingress.enabled`                  | Enable ingress controller resource                                                | `false`                        |
| `ingress.apiVersion`               | Force Ingress API version (automatically detected if not set)                     | ``                             |
| `ingress.path`                     | Ingress path                                                                      | `/`                            |
| `ingress.pathType`                 | Ingress path type                                                                 | `ImplementationSpecific`       |
| `ingress.certManager`              | Add annotations for cert-manager                                                  | `false`                        |
| `ingress.hostname`                 | Default host for the ingress resource                                             | `keycloak.local`               |
| `ingress.tls`                      | Enable TLS configuration for the hostname defined at `ingress.hostname` parameter | `false`                        |
| `ingress.annotations`              | Ingress annotations                                                               | `{}` (evaluated as a template) |
| `ingress.extraHosts[0].name`       | Additional hostnames to be covered                                                | `nil`                          |
| `ingress.extraHosts[0].path`       | Additional hostnames to be covered                                                | `nil`                          |
| `ingress.extraTls[0].hosts[0]`     | TLS configuration for additional hostnames to be covered                          | `nil`                          |
| `ingress.extraTls[0].secretName`   | TLS configuration for additional hostnames to be covered                          | `nil`                          |
| `ingress.secrets[0].name`          | TLS Secret Name                                                                   | `nil`                          |
| `ingress.secrets[0].certificate`   | TLS Secret Certificate                                                            | `nil`                          |
| `ingress.secrets[0].key`           | TLS Secret Key                                                                    | `nil`                          |
| `ingress.servicePort`              | Service port to be used                                                           | `http`                          |
| `networkPolicy.enabled`            | Enable the default NetworkPolicy policy                                           | `false`                        |
| `networkPolicy.allowExternal`      | Don't require client label for connections                                        | `true`                         |
| `networkPolicy.additionalRules`    | Additional NetworkPolicy rules                                                    | `{}` (evaluated as a template) |

### RBAC parameters

| Parameter               | Description                                               | Default                                          |
|-------------------------|-----------------------------------------------------------|--------------------------------------------------|
| `serviceAccount.create` | Enable the creation of a ServiceAccount for Keycloak pods | `true`                                           |
| `serviceAccount.name`   | Name of the created ServiceAccount                        | Generated using the `keycloak.fullname` template |
| `rbac.create`           | Weather to create & use RBAC resources or not             | `false`                                          |
| `rbac.rules`            | Specifies whether RBAC resources should be created        | `[]`                                             |

### Other parameters

| Parameter                  | Description                                                    | Default |
|----------------------------|----------------------------------------------------------------|---------|
| `pdb.create`               | Enable/disable a Pod Disruption Budget creation                | `false` |
| `pdb.minAvailable`         | Minimum number/percentage of pods that should remain scheduled | `1`     |
| `pdb.maxUnavailable`       | Maximum number/percentage of pods that may be made unavailable | `nil`   |
| `autoscaling.enabled`      | Enable autoscaling for Keycloak                                | `false` |
| `autoscaling.minReplicas`  | Minimum number of Keycloak replicas                            | `1`     |
| `autoscaling.maxReplicas`  | Maximum number of Keycloak replicas                            | `11`    |
| `autoscaling.targetCPU`    | Target CPU utilization percentage                              | `nil`   |
| `autoscaling.targetMemory` | Target Memory utilization percentage                           | `nil`   |

### Metrics parameters

| Parameter                                 | Description                                                                         | Default                                                      |
|-------------------------------------------|-------------------------------------------------------------------------------------|--------------------------------------------------------------|
| `metrics.enabled`                         | Enable exposing Keycloak statistics                                                 | `false`                                                      |
| `metrics.service.port`                    | Service HTTP management port                                                        | `9990`                                                       |
| `metrics.service.annotations`             | Annotations for enabling prometheus to access the metrics endpoints                 | `{prometheus.io/scrape: "true", prometheus.io/port: "9990"}` |
| `metrics.serviceMonitor.enabled`          | Create ServiceMonitor Resource for scraping metrics using PrometheusOperator        | `false`                                                      |
| `metrics.serviceMonitor.namespace`        | Namespace which Prometheus is running in                                            | `nil`                                                        |
| `metrics.serviceMonitor.interval`         | Interval at which metrics should be scraped                                         | `30s`                                                        |
| `metrics.serviceMonitor.scrapeTimeout`    | Specify the timeout after which the scrape is ended                                 | `nil`                                                        |
| `metrics.serviceMonitor.relabellings`     | Specify Metric Relabellings to add to the scrape endpoint                           | `nil`                                                        |
| `metrics.serviceMonitor.honorLabels`      | honorLabels chooses the metric's labels on collisions with target labels.           | `false`                                                      |
| `metrics.serviceMonitor.additionalLabels` | Used to pass Labels that are required by the Installed Prometheus Operator          | `{}`                                                         |
| `metrics.serviceMonitor.release`          | Used to pass Labels release that sometimes should be custom for Prometheus Operator | `nil`                                                        |

### Database parameters

| Parameter                        | Description                                                                  | Default            |
|----------------------------------|------------------------------------------------------------------------------|--------------------|
| `postgresql.enabled`             | Deploy a PostgreSQL server to satisfy the applications database requirements | `true`             |
| `postgresql.postgresqlUsername`  | Keycloak PostgreSQL user to create (used by Keycloak)                        | `bn_keycloak`      |
| `postgresql.postgresqlPassword`  | Keycloak PostgreSQL password - ignored if existingSecret is provided         | `some-password`    |
| `postgresql.existingSecret`      | Use an existing secret file with the PostgreSQL password                     | `nil`              |
| `postgresql.postgresqlDatabase`  | Name of the database to create                                               | `bitnami_keycloak` |
| `postgresql.persistence.enabled` | Enable database persistence using PVC                                        | `true`             |
| `externalDatabase.host`          | Host of the external database                                                | `""`               |
| `externalDatabase.port`          | Database port number (when using an external db)                             | `5432`             |
| `externalDatabase.user`          | PostgreSQL username (when using an external db)                              | `bn_keycloak`      |
| `externalDatabase.password`      | Password for the above username (when using an external db)                  | `""`               |
| `externalDatabase.database`      | Name of the existing database (when using an external db)                    | `bitnami_keycloak` |
| `externalDatabase.existingSecret`| Use an existing secret file with the external PostgreSQL credentials         | `nil`              |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
helm install my-release --set auth.adminPassword=secretpassword bitnami/keycloak
```

The above command sets the Keycloak administrator password to `secretpassword`.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install my-release -f values.yaml bitnami/keycloak
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Using an external database

Sometimes you may want to have Keycloak connect to an external database rather than installing one inside your cluster, e.g. to use a managed database service, or use run a single database server for all your applications. To do this, the chart allows you to specify credentials for an external database under the [`externalDatabase` parameter](#database-parameters). You should also disable the PostgreSQL installation with the `postgresql.enabled` option. For example with the following parameters:

```console
postgresql.enabled=false
externalDatabase.host=myexternalhost
externalDatabase.port=5432
externalDatabase.user=myuser
externalDatabase.password=mypassword
externalDatabase.database=mydatabase
```

Note also that if you disable PostgreSQL per above you MUST supply values for the `externalDatabase` connection.

### Adding extra environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `extraEnvVars` property.

```yaml
extraEnvVars:
  - name: KEYCLOAK_LOG_LEVEL
    value: DEBUG
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values.

### Sidecars and Init Containers

If you have a need for additional containers to run within the same pod as the Keycloak app (e.g. an additional metrics or logging exporter), you can do so via the `sidecars` config parameter. Simply define your container according to the Kubernetes container spec.

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

### Initialize a fresh instance

The [Bitnami Keycloak](https://github.com/bitnami/bitnami-docker-keycloak) image allows you to use your custom scripts to initialize a fresh instance. In order to execute the scripts, you can specify custom scripts using the `initdbScripts` parameter as dict.

In addition to this option, you can also set an external ConfigMap with all the initialization scripts. This is done by setting the `initdbScriptsConfigMap` parameter. Note that this will override the previous option.

The allowed extensions is `.sh`.

### Deploying extra resources

There are cases where you may want to deploy extra objects, such a ConfigMap containing your app's configuration or some extra deployment with a micro service used by your app. For covering this case, the chart allows adding the full specification of other objects using the `extraDeploy` parameter.

### Setting Pod's affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

### Ingress

This chart provides support for ingress resources. If you have an ingress controller installed on your cluster, such as [nginx-ingress-controller](https://github.com/bitnami/charts/tree/master/bitnami/nginx-ingress-controller) or [contour](https://github.com/bitnami/charts/tree/master/bitnami/contour) you can utilize the ingress controller to serve your application.

To enable ingress integration, please set `ingress.enabled` to `true`.

#### Hosts

Most likely you will only want to have one hostname that maps to this Keycloak installation. If that's your case, the property `ingress.hostname` will set it. However, it is possible to have more than one host. To facilitate this, the `ingress.extraHosts` object can be specified as an array. You can also use `ingress.extraTLS` to add the TLS configuration for extra hosts.

For each host indicated at `ingress.extraHosts`, please indicate a `name`, `path`, and any `annotations` that you may want the ingress controller to know about.

For annotations, please see [this document](https://github.com/kubernetes/ingress-nginx/blob/master/docs/user-guide/nginx-configuration/annotations.md). Not all annotations are supported by all ingress controllers, but this document does a good job of indicating which annotation is supported by many popular ingress controllers.

### TLS Secrets

This chart will facilitate the creation of TLS secrets for use with the ingress controller, however, this is not required. There are three common use cases:

- Helm generates/manages certificate secrets.
- User generates/manages certificates separately.
- An additional tool (like [cert-manager](https://github.com/jetstack/cert-manager/)) manages the secrets for the application.

In the first two cases, it's needed a certificate and a key. We would expect them to look like this:

- certificate files should look like (and there can be more than one certificate if there is a certificate chain)

  ```console
  -----BEGIN CERTIFICATE-----
  MIID6TCCAtGgAwIBAgIJAIaCwivkeB5EMA0GCSqGSIb3DQEBCwUAMFYxCzAJBgNV
  ...
  jScrvkiBO65F46KioCL9h5tDvomdU1aqpI/CBzhvZn1c0ZTf87tGQR8NK7v7
  -----END CERTIFICATE-----
  ```

- keys should look like:

  ```console
  -----BEGIN RSA PRIVATE KEY-----
  MIIEogIBAAKCAQEAvLYcyu8f3skuRyUgeeNpeDvYBCDcgq+LsWap6zbX5f8oLqp4
  ...
  wrj2wDbCDCFmfqnSJ+dKI3vFLlEz44sAV8jX/kd4Y6ZTQhlLbYc=
  -----END RSA PRIVATE KEY-----
  ```

If you are going to use Helm to manage the certificates, please copy these values into the `certificate` and `key` values for a given `ingress.secrets` entry.

If you are going to manage TLS secrets outside of Helm, please know that you can create a TLS secret (named `keycloak.local-tls` for example).

### Secrets and passwords

This chart provides several ways to manage passwords:
- Values passed to the chart
- An existing secret with all the passwords
- Passwords present among several secrets

In the first case, a new Secret including all the passwords will be created during the chart installation. When upgrading it is necessary to provide the secrets using the `--set` option as shown below:
For example:
\```console
  $ helm upgrade keycloak bitnami/keycloak \
      --set auth.adminPassword=$KEYCLOAK_ADMIN_PASSWORD \
      --set auth.managementPassword=$KEYCLOAK_MANAGEMENT_PASSWORD \
      --set postgresql.postgresqlPassword=$POSTGRESQL_PASSWORD \
      --set postgresql.persistence.existingClaim=$POSTGRESQL_PVC
\```

When installing using an existing secret, passwords can be stored in single secret or separeted into differect secrets.

To use a single existing secret `existingSecret` can be configured at values.yaml:

\```yaml
    existingSecret:
      name: mySecret
      keyMapping:
        admin-password: myPasswordKey
        management-password: myManagementPasswordKey
        database-password: myDatabasePasswordKey
        tls-keystore-password: myTlsKeystorePasswordKey
        tls-truestore-password: myTlsTruestorePasswordKey
\```

The keyMapping links the passwords in the chart with the passwords stored in the existing Secret.

Configuring multiple existing secrets can be done by using `auth.existingSecretPerPassword` instead:

\```yaml
      existingSecretPerPassword:
        keyMapping:
          adminPassword: KEYCLOAK_ADMIN_PASSWORD
          managementPassword: KEYCLOAK_MANAGEMENT_PASSWORD
          databasePassword: password
          tlsKeystorePassword: JKS_KEYSTORE_TRUSTSTORE_PASSWORD
          tlsTruststorePassword: JKS_KEYSTORE_TRUSTSTORE_PASSWORD
        adminPassword:
          name: mySecret
        managementPassword:
          name: mySecret
        databasePassword:
          name: myOtherSecret
        tlsKeystorePassword:
          name: mySecret
        tlsTruststorePassword:
          name: mySecret
\```

Additionally to the key mapping, a different Secret name can be configured per password.

> NOTE: 'auth.existingSecretPerPassword' will overwrite the configuration at 'auth.existingSecret'
## Troubleshooting

Find more information about how to deal with common errors related to Bitnami’s Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 1.0.0

[On November 13, 2020, Helm v2 support was formally finished](https://github.com/helm/charts#status-of-the-project), this major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

**What changes were introduced in this major version?**

- Previous versions of this Helm Chart use `apiVersion: v1` (installable by both Helm 2 and 3), this Helm Chart was updated to `apiVersion: v2` (installable by Helm 3 only). [Here](https://helm.sh/docs/topics/charts/#the-apiversion-field) you can find more information about the `apiVersion` field.
- Move dependency information from the _requirements.yaml_ to the _Chart.yaml_
- After running `helm dependency update`, a _Chart.lock_ file is generated containing the same structure used in the previous _requirements.lock_
- The different fields present in the _Chart.yaml_ file has been ordered alphabetically in a homogeneous way for all the Bitnami Helm Charts
- This chart depends on the **PostgreSQL 10** instead of **PostgreSQL 9**. Apart from the same changes that are described in this section, there are also other major changes due to the master/slave nomenclature was replaced by primary/readReplica. [Here](https://github.com/bitnami/charts/pull/4385) you can find more information about the changes introduced.

**Considerations when upgrading to this version**

- If you want to upgrade to this version using Helm v2, this scenario is not supported as this version doesn't support Helm v2 anymore
- If you installed the previous version with Helm v2 and wants to upgrade to this version with Helm v3, please refer to the [official Helm documentation](https://helm.sh/docs/topics/v2_v3_migration/#migration-use-cases) about migrating from Helm v2 to v3
- If you want to upgrade to this version from a previous one installed with Helm v3, it should be done reusing the PVC used to hold the PostgreSQL data on your previous release. To do so, follow the instructions below (the following example assumes that the release name is `keycloak`):

> NOTE: Please, create a backup of your database before running any of those actions.

##### Export secrets and required values to update

```console
$ export KEYCLOAK_ADMIN_PASSWORD=$(kubectl get secret --namespace default keycloak-env-vars -o jsonpath="{.data.KEYCLOAK_ADMIN_PASSWORD}" | base64 --decode)
$ export KEYCLOAK_MANAGEMENT_PASSWORD=$(kubectl get secret --namespace default keycloak-env-vars -o jsonpath="{.data.KEYCLOAK_MANAGEMENT_PASSWORD}" | base64 --decode)
$ export POSTGRESQL_PASSWORD=$(kubectl get secret --namespace default keycloak-postgresql -o jsonpath="{.data.postgresql-password}" | base64 --decode)
$ export POSTGRESQL_PVC=$(kubectl get pvc -l app.kubernetes.io/instance=keycloak,app.kubernetes.io/name=postgresql,role=master -o jsonpath="{.items[0].metadata.name}")
```

##### Delete statefulsets

Delete PostgreSQL statefulset. Notice the option `--cascade=false`:

```
$ kubectl delete statefulsets.apps keycloak-postgresql --cascade=false
```

##### Upgrade the chart release

```console
$ helm upgrade keycloak bitnami/keycloak \
    --set auth.adminPassword=$KEYCLOAK_ADMIN_PASSWORD \
    --set auth.managementPassword=$KEYCLOAK_MANAGEMENT_PASSWORD \
    --set postgresql.postgresqlPassword=$POSTGRESQL_PASSWORD \
    --set postgresql.persistence.existingClaim=$POSTGRESQL_PVC
```

##### Force new statefulset to create a new pod for postgresql

```console
$ kubectl delete pod keycloak-postgresql-0
```

Finally, you should see the lines below in MariaDB container logs:

```console
$ kubectl logs $(kubectl get pods -l app.kubernetes.io/instance=postgresql,app.kubernetes.io/name=postgresql,role=primary -o jsonpath="{.items[0].metadata.name}")
...
postgresql 08:05:12.59 INFO  ==> Deploying PostgreSQL with persisted data...
...
```

**Useful links**

- https://docs.bitnami.com/tutorials/resolve-helm2-helm3-post-migration-issues/
- https://helm.sh/docs/topics/v2_v3_migration/
- https://helm.sh/blog/migrate-from-helm-v2-to-helm-v3/
