# Spring Cloud Data Flow

[Spring Cloud Data Flow](https://dataflow.spring.io/) is a microservices-based Streaming and Batch data processing pipeline in Cloud Foundry and Kubernetes.

## TL;DR;

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install my-release bitnami/spring-cloud-dataflow
```

## Introduction

This chart bootstraps a [Spring Cloud Data Flow](https://github.com/bitnami/bitnami-docker-spring-cloud-dataflow) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.12+
- Helm 2.12+ or Helm 3.0-beta3+
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install my-release bitnami/spring-cloud-dataflow
```

These commands deploy Spring Cloud Data Flow on the Kubernetes cluster with the default configuration. The [parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` chart:

```bash
helm uninstall my-release
```

## Parameters

The following tables lists the configurable parameters of the Spring Cloud Data Flow chart and their default values per section/component:

### Global parameters

| Parameter                                       | Description                                                | Default                                                 |
|-------------------------------------------------|------------------------------------------------------------|---------------------------------------------------------|
| `global.imageRegistry`                          | Global Docker image registry                               | `nil`                                                   |
| `global.imagePullSecrets`                       | Global Docker registry secret names as an array            | `[]` (does not add image pull secrets to deployed pods) |
| `global.storageClass`                           | Global storage class for dynamic provisioning              | `nil`                                                   |

### Common parameters

| Parameter                                       | Description                                                | Default                                                 |
|-------------------------------------------------|------------------------------------------------------------|---------------------------------------------------------|
| `nameOverride`                                  | String to partially override scdf.fullname                 | `nil`                                                   |
| `fullnameOverride`                              | String to fully override scdf.fullname                     | `nil`                                                   |
| `clusterDomain`                                 | Default Kubernetes cluster domain                          | `cluster.local`                                         |
| `deployer.resources.limits`                     | Streaming applications resource limits                     | `{ cpu: "500m", memory: "1024Mi" }`                     |
| `deployer.resources.requests`                   | Streaming applications resource requests                   | `{}`                                                    |
| `deployer.resources.readinessProbe`             | Streaming applications readiness probes requests           | Check `values.yaml` file                                |
| `deployer.resources.livenessProbe`              | Streaming applications liveness probes  requests           | Check `values.yaml` file                                |
| `deployer.nodeSelector`                         | Streaming applications nodeSelector                        | `""`                                                    |
| `deployer.tolerations`                          | Streaming applications tolerations                         | `{}`                                                    |
| `deployer.volumeMounts`                         | Streaming applications extra volume mounts                 | `{}`                                                    |
| `deployer.volumes`                              | Streaming applications extra volumes                       | `{}`                                                    |
| `deployer.environmentVariables`                 | Streaming applications environment variables               | `""`                                                    |

### Dataflow Server parameters

| Parameter                                      | Description                                                         | Default                                                 |
|------------------------------------------------|---------------------------------------------------------------------|---------------------------------------------------------|
| `server.image.registry`                        | Spring Cloud Dataflow image registry                                | `docker.io`                                             |
| `server.image.repository`                      | Spring Cloud Dataflow image name                                    | `bitnami/spring-cloud-dataflow`                         |
| `server.image.tag`                             | Spring Cloud Dataflow image tag                                     | `{TAG_NAME}`                                            |
| `server.image.pullPolicy`                      | Spring Cloud Dataflow image pull policy                             | `IfNotPresent`                                          |
| `server.image.pullSecrets`                     | Specify docker-registry secret names as an array                    | `[]` (does not add image pull secrets to deployed pods) |
| `server.configuration.streamingEnabled`        | Enables or disables streaming data processing                       | `true`                                                  |
| `server.configuration.batchEnabled`            | Enables or disables bath data (tasks and schedules) processing      | `true`                                                  |
| `server.configuration.accountName`             | The name of the account to configure for the Kubernetes platform    | `default`                                               |
| `server.configuration.trustK8sCerts`           | Trust K8s certificates when querying the Kubernetes API             | `false`                                                 |
| `server.configuration.containerRegistries`     | Container registries configuration                                  | `{}` (check `values.yaml` for more information)         |
| `server.existingConfigmap`                     | Name of existing ConfigMap with Dataflow server configuration       | `nil`                                                   |
| `server.extraEnvVars`                          | Extra environment variables to be set on Dataflow server container  | `{}`                                                    |
| `server.extraEnvVarsCM`                        | Name of existing ConfigMap containing extra env vars                | `nil`                                                   |
| `server.extraEnvVarsSecret`                    | Name of existing Secret containing extra env vars                   | `nil`                                                   |
| `server.replicaCount`                          | Number of Dataflow server replicas to deploy                        | `1`                                                     |
| `server.strategyType`                          | Deployment Strategy Type                                            | `RollingUpdate`                                         |
| `server.affinity`                              | Affinity for pod assignment                                         | `{}` (evaluated as a template)                          |
| `server.nodeSelector`                          | Node labels for pod assignment                                      | `{}` (evaluated as a template)                          |
| `server.tolerations`                           | Tolerations for pod assignment                                      | `[]` (evaluated as a template)                          |
| `server.priorityClassName`                     | Controller priorityClassName                                        | `nil`                                                   |
| `server.podSecurityContext`                    | Dataflow server pods' Security Context                              | `{ fsGroup: "1001" }`                                   |
| `server.containerSecurityContext`              | Dataflow server containers' Security Context                        | `{ runAsUser: "1001" }`                                 |
| `server.resources.limits`                      | The resources limits for the Dataflow server container              | `{}`                                                    |
| `server.resources.requests`                    | The requested resources for the Dataflow server container           | `{}`                                                    |
| `server.podAnnotations`                        | Annotations for Dataflow server pods                                | `{}`                                                    |
| `server.livenessProbe`                         | Liveness probe configuration for Dataflow server                    | Check `values.yaml` file                                |
| `server.readinessProbe`                        | Readiness probe configuration for Dataflow server                   | Check `values.yaml` file                                |
| `server.customLivenessProbe`                   | Override default liveness probe                                     | `nil`                                                   |
| `server.customReadinessProbe`                  | Override default readiness probe                                    | `nil`                                                   |
| `server.service.type`                          | Kubernetes service type                                             | `ClusterIP`                                             |
| `server.service.port`                          | Service HTTP port                                                   | `8080`                                                  |
| `server.service.nodePort`                      | Service HTTP node port                                              | `nil`                                                   |
| `server.service.clusterIP`                     | Dataflow server service clusterIP IP                                | `None`                                                  |
| `server.service.externalTrafficPolicy`         | Enable client source IP preservation                                | `Cluster`                                               |
| `server.service.loadBalancerIP`                | loadBalancerIP if service type is `LoadBalancer`                    | `nil`                                                   |
| `server.service.loadBalancerSourceRanges`      | Address that are allowed when service is LoadBalancer               | `[]`                                                    |
| `server.service.annotations`                   | Annotations for Dataflow server service                             | `{}`                                                    |
| `server.ingress.enabled`                       | Enable ingress controller resource                                  | `false`                                                 |
| `server.ingress.certManager`                   | Add annotations for cert-manager                                    | `false`                                                 |
| `server.ingress.hostname`                      | Default host for the ingress resource                               | `dataflow.local`                                        |
| `server.ingress.annotations`                   | Ingress annotations                                                 | `[]`                                                    |
| `server.ingress.extraHosts[0].name`            | Additional hostnames to be covered                                  | `nil`                                                   |
| `server.ingress.extraHosts[0].path`            | Additional hostnames to be covered                                  | `nil`                                                   |
| `server.ingress.extraTls[0].hosts[0]`          | TLS configuration for additional hostnames to be covered            | `nil`                                                   |
| `server.ingress.extraTls[0].secretName`        | TLS configuration for additional hostnames to be covered            | `nil`                                                   |
| `server.ingress.secrets[0].name`               | TLS Secret Name                                                     | `nil`                                                   |
| `server.ingress.secrets[0].certificate`        | TLS Secret Certificate                                              | `nil`                                                   |
| `server.ingress.secrets[0].key`                | TLS Secret Key                                                      | `nil`                                                   |
| `server.initContainers`                        | Add additional init containers to the Dataflow server pods          | `{}` (evaluated as a template)                          |
| `server.sidecars`                              | Add additional sidecar containers to the Dataflow server pods       | `{}` (evaluated as a template)                          |
| `server.pdb.create`                            | Enable/disable a Pod Disruption Budget creation                     | `false`                                                 |
| `server.pdb.minAvailable`                      | Minimum number/percentage of pods that should remain scheduled      | `1`                                                     |
| `server.pdb.maxUnavailable`                    | Maximum number/percentage of pods that may be made unavailable      | `nil`                                                   |
| `server.autoscaling.enabled`                   | Enable autoscaling for Dataflow server                              | `false`                                                 |
| `server.autoscaling.minReplicas`               | Minimum number of Dataflow server replicas                          | `nil`                                                   |
| `server.autoscaling.maxReplicas`               | Maximum number of Dataflow server replicas                          | `nil`                                                   |
| `server.autoscaling.targetCPU`                 | Target CPU utilization percentage                                   | `nil`                                                   |
| `server.autoscaling.targetMemory`              | Target Memory utilization percentage                                | `nil`                                                   |
| `server.jdwp.enabled`                          | Enable Java Debug Wire Protocol (JDWP)                              | `false`                                                 |
| `server.jdwp.port`                             | JDWP TCP port                                                       | `5005`                                                  |

### Dataflow Skipper parameters

| Parameter                                  | Description                                                         | Default                                                 |
|--------------------------------------------|---------------------------------------------------------------------|---------------------------------------------------------|
| `skipper.enabled`                          | Enable Spring Cloud Skipper component                               | `true`                                                  |
| `skipper.image.registry`                   | Spring Cloud Skipper image registry                                 | `docker.io`                                             |
| `skipper.image.repository`                 | Spring Cloud Skipper image name                                     | `bitnami/spring-cloud-dataflow`                         |
| `skipper.image.tag`                        | Spring Cloud Skipper image tag                                      | `{TAG_NAME}`                                            |
| `skipper.image.pullPolicy`                 | Spring Cloud Skipper image pull policy                              | `IfNotPresent`                                          |
| `skipper.image.pullSecrets`                | Specify docker-registry secret names as an array                    | `[]` (does not add image pull secrets to deployed pods) |
| `skipper.configuration.accountName`        | The name of the account to configure for the Kubernetes platform    | `default`                                               |
| `skipper.configuration.trustK8sCerts`      | Trust K8s certificates when querying the Kubernetes API             | `false`                                                 |
| `skipper.existingConfigmap`                | Name of existing ConfigMap with Skipper server configuration        | `nil`                                                   |
| `skipper.extraEnvVars`                     | Extra environment variables to be set on Skipper server container   | `{}`                                                    |
| `skipper.extraEnvVarsCM`                   | Name of existing ConfigMap containing extra env vars                | `nil`                                                   |
| `skipper.extraEnvVarsSecret`               | Name of existing Secret containing extra env vars                   | `nil`                                                   |
| `skipper.replicaCount`                     | Number of Skipper server replicas to deploy                         | `1`                                                     |
| `skipper.strategyType`                     | Deployment Strategy Type                                            | `RollingUpdate`                                         |
| `skipper.affinity`                         | Affinity for pod assignment                                         | `{}` (evaluated as a template)                          |
| `skipper.nodeSelector`                     | Node labels for pod assignment                                      | `{}` (evaluated as a template)                          |
| `skipper.tolerations`                      | Tolerations for pod assignment                                      | `[]` (evaluated as a template)                          |
| `skipper.priorityClassName`                | Controller priorityClassName                                        | `nil`                                                   |
| `skipper.podSecurityContext`               | Skipper server pods' Security Context                               | `{ fsGroup: "1001" }`                                   |
| `skipper.containerSecurityContext`         | Skipper server containers' Security Context                         | `{ runAsUser: "1001" }`                                 |
| `skipper.resources.limits`                 | The resources limits for the Skipper server container               | `{}`                                                    |
| `skipper.resources.requests`               | The requested resources for the Skipper server container            | `{}`                                                    |
| `skipper.podAnnotations`                   | Annotations for Skipper server pods                                 | `{}`                                                    |
| `skipper.livenessProbe`                    | Liveness probe configuration for Skipper server                     | Check `values.yaml` file                                |
| `skipper.readinessProbe`                   | Readiness probe configuration for Skipper server                    | Check `values.yaml` file                                |
| `skipper.customLivenessProbe`              | Override default liveness probe                                     | `nil`                                                   |
| `skipper.customReadinessProbe`             | Override default readiness probe                                    | `nil`                                                   |
| `skipper.service.type`                     | Kubernetes service type                                             | `ClusterIP`                                             |
| `skipper.service.port`                     | Service HTTP port                                                   | `8080`                                                  |
| `skipper.service.nodePort`                 | Service HTTP node port                                              | `nil`                                                   |
| `skipper.service.clusterIP`                | Skipper server service clusterIP IP                                 | `None`                                                  |
| `skipper.service.externalTrafficPolicy`    | Enable client source IP preservation                                | `Cluster`                                               |
| `skipper.service.loadBalancerIP`           | loadBalancerIP if service type is `LoadBalancer`                    | `nil`                                                   |
| `skipper.service.loadBalancerSourceRanges` | Address that are allowed when service is LoadBalancer               | `[]`                                                    |
| `skipper.service.annotations`              | Annotations for Skipper server service                              | `{}`                                                    |
| `skipper.initContainers`                   | Add additional init containers to the Skipper pods                  | `{}` (evaluated as a template)                          |
| `skipper.sidecars`                         | Add additional sidecar containers to the Skipper pods               | `{}` (evaluated as a template)                          |
| `skipper.pdb.create`                       | Enable/disable a Pod Disruption Budget creation                     | `false`                                                 |
| `skipper.pdb.minAvailable`                 | Minimum number/percentage of pods that should remain scheduled      | `1`                                                     |
| `skipper.pdb.maxUnavailable`               | Maximum number/percentage of pods that may be made unavailable      | `nil`                                                   |
| `skipper.autoscaling.enabled`              | Enable autoscaling for Skipper server                               | `false`                                                 |
| `skipper.autoscaling.minReplicas`          | Minimum number of Skipper server replicas                           | `nil`                                                   |
| `skipper.autoscaling.maxReplicas`          | Maximum number of Skipper server replicas                           | `nil`                                                   |
| `skipper.autoscaling.targetCPU`            | Target CPU utilization percentage                                   | `nil`                                                   |
| `skipper.autoscaling.targetMemory`         | Target Memory utilization percentage                                | `nil`                                                   |
| `skipper.jdwp.enabled`                     | Enable Java Debug Wire Protocol (JDWP)                              | `false`                                                 |
| `skipper.jdwp.port`                        | JDWP TCP port                                                       | `5005`                                                  |
| `externalSkipper.host`                     | Host of a external Skipper Server                                   | `localhost`                                             |
| `externalSkipper.port`                     | External Skipper Server port number                                 | `7577`                                                  |

### RBAC parameters

| Parameter                | Description                                                                          | Default                                       |
|------------------------- |--------------------------------------------------------------------------------------|---------------------------------------------- |
| `serviceAccount.create`  | Enable the creation of a ServiceAccount for Dataflow server and Skipper server pods  | `true`                                        |
| `serviceAccount.name`    | Name of the created serviceAccount                                                   | Generated using the `scdf.fullname` template  |
| `rbac.create`            | Weather to create & use RBAC resources or not                                        | `true`                                        |

### Metrics parameters

| Parameter                                       | Description                                                                                            | Default                                                 |
|-------------------------------------------------|--------------------------------------------------------------------------------------------------------|---------------------------------------------------------|
| `metrics.metrics`                               | Enable the export of Prometheus metrics                                                                | `false`                                                 |
| `metrics.image.registry`                        | Prometheus Rsocket Proxy image registry                                                                | `docker.io`                                             |
| `metrics.image.repository`                      | Prometheus Rsocket Proxy image name                                                                    | `bitnami/prometheus-rsocket-proxy`                      |
| `metrics.image.tag`                             | Prometheus Rsocket Proxy image tag                                                                     | `{TAG_NAME}`                                            |
| `metrics.image.pullPolicy`                      | Prometheus Rsocket Proxy image pull policy                                                             | `IfNotPresent`                                          |
| `metrics.image.pullSecrets`                     | Specify docker-registry secret names as an array                                                       | `[]` (does not add image pull secrets to deployed pods) |
| `metrics.kafka.service.httpPort`                | Prometheus Rsocket Proxy HTTP port                                                                     | `8080`                                                  |
| `metrics.kafka.service.rsocketPort`             | Prometheus Rsocket Proxy Rsocket port                                                                  | `8080`                                                  |
| `metrics.kafka.service.annotations`             | Annotations for Prometheus Rsocket Proxy service                                                       | `Check values.yaml file`                                |
| `metrics.serviceMonitor.enabled`                | if `true`, creates a Prometheus Operator ServiceMonitor (also requires `metrics.enabled` to be `true`) | `false`                                                 |
| `metrics.serviceMonitor.namespace`              | Namespace in which Prometheus is running                                                               | `nil`                                                   |
| `metrics.serviceMonitor.interval`               | Interval at which metrics should be scraped.                                                           | `nil` (Prometheus Operator default value)               |
| `metrics.serviceMonitor.scrapeTimeout`          | Timeout after which the scrape is ended                                                                | `nil` (Prometheus Operator default value)               |

### Init Container parameters

| Parameter                                       | Description                                                                                            | Default                                                 |
|-------------------------------------------------|--------------------------------------------------------------------------------------------------------|---------------------------------------------------------|
| `waitForBackends.enabled`                       | Wait for the database and other services (such as Kafka or RabbitMQ) used when enabling streaming      | `true`                                                  |
| `waitForBackends.image.registry`                | Init container wait-for-backend image registry                                                         | `docker.io`                                             |
| `waitForBackends.image.repository`              | Init container wait-for-backend image name                                                             | `bitnami/kubectl`                                       |
| `waitForBackends.image.tag`                     | Init container wait-for-backend image tag                                                              | `{TAG_NAME}`                                            |
| `waitForBackends.image.pullPolicy`              | Init container wait-for-backend image pull policy                                                      | `IfNotPresent`                                          |
| `waitForBackends.image.pullSecrets`             | Specify docker-registry secret names as an array                                                       | `[]` (does not add image pull secrets to deployed pods) |
| `waitForBackends.resources.limits`              | Init container wait-for-backend resource  limits                                                       | `{}`                                                    |
| `waitForBackends.resources.requests`            | Init container wait-for-backend resource  requests                                                     | `{}`                                                    |

### Database parameters

| Parameter                                       | Description                                                             | Default                             |
|-------------------------------------------------|-------------------------------------------------------------------------|-------------------------------------|
| `mariadb.enabled`                               | Enable/disable MariaDB chart installation                               | `true`                              |
| `mariadb.replication.enabled`                   | MariaDB replication enabled                                             | `false`                             |
| `mariadb.db.name`                               | Name for new database to create                                         | `dataflow`                          |
| `mariadb.db.user`                               | Username of new user to create                                          | `dataflow`                          |
| `mariadb.db.password`                           | Password for the new user                                               | `change-me`_                        |
| `mariadb.initdbScripts`                         | Dictionary of initdb scripts                                            | Check `values.yaml` file            |
| `externalDatabase.host`                         | Host of the external database                                           | `localhost`                         |
| `externalDatabase.port`                         | External database port number                                           | `3306`                              |
| `externalDatabase.password`                     | Password for the above username                                         | `""`                                |
| `externalDatabase.existingPasswordSecret`       | Existing secret with database password                                  | `""`                                |
| `externalDatabase.dataflow.user`                | Existing username in the external db to be used by Dataflow server      | `dataflow`                          |
| `externalDatabase.dataflow.database`            | Name of the existing database to be used by Dataflow server             | `dataflow`                          |
| `externalDatabase.skipper.user`                 | Existing username in the external db to be used by Skipper server       | `skipper`                           |
| `externalDatabase.skipper.database`             | Name of the existing database to be used by Skipper server              | `skipper`                           |
| `externalDatabase.hibernateDialect`             | Hibernate Dialect used by Dataflow/Skipper servers                      | `""`                                |

### RabbitMQ chart parameters

| Parameter                                       | Description                                                             | Default                                                 |
|-------------------------------------------------|-------------------------------------------------------------------------|---------------------------------------------------------|
| `rabbitmq.enabled`                              | Enable/disable RabbitMQ chart installation                              | `true`                                                  |
| `rabbitmq.auth.username`                        | RabbitMQ username                                                       | `user`                                                  |
| `rabbitmq.auth.password`                        | RabbitMQ password                                                       | _random 40 character alphanumeric string_               |
| `externalRabbitmq.enabled`                      | Enable/disable external RabbitMQ                                        | `false`                                                 |
| `externalRabbitmq.host`                         | Host of the external RabbitMQ                                           | `localhost`                                             |
| `externalRabbitmq.port`                         | External RabbitMQ port number                                           | `5672`                                                  |
| `externalRabbitmq.username`                     | External RabbitMQ username                                              | `guest`                                                 |
| `externalRabbitmq.password`                     | External RabbitMQ password                                              | `guest`                                                 |
| `externalRabbitmq.vhost`                        | External RabbitMQ virtual host                                          | `/`                                                     |
| `externalRabbitmq.existingPasswordSecret`       | Existing secret with RabbitMQ password                                  | `""`                                                    |

### Kafka chart parameters

| Parameter                                       | Description                                                             | Default                                                 |
|-------------------------------------------------|-------------------------------------------------------------------------|---------------------------------------------------------|
| `kafka.enabled`                                 | Enable/disable Kafka chart installation                                 | `false`                                                 |
| `kafka.replicaCount`                            | Number of Kafka brokers                                                 | `1`                                                     |
| `kafka.offsetsTopicReplicationFactor`           | Kafka Secret Key                                                        | `1`                                                     |
| `kafka.zookeeper.enabled`                       | Enable/disable Zookeeper chart installation                             | `nil`                                                   |
| `kafka.zookeeper.replicaCount`                  | Number of Zookeeper replicas                                            | `1`                                                     |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
helm install my-release --set server.replicaCount=2 bitnami/spring-cloud-dataflow
```

The above command install Spring Cloud Data Flow chart with 2 Dataflow server replicas.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
helm install my-release -f values.yaml bitnami/spring-cloud-dataflow
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Production configuration

This chart includes a `values-production.yaml` file where you can find some parameters oriented to production configuration in comparison to the regular `values.yaml`. You can use this file instead of the default one.

- Enable Pod Disruption Budget for Server and Skipper:

```diff
- server.pdb.create: false
+ server.pdb.create: true
- skipper.pdb.create: false
+ skipper.pdb.create: true
```

- Enable exposing Prometheus Metrics via Prometheus Rsocket Proxy:

```diff
- metrics.enabled: false
+ metrics.enabled: true
```

- Force users to specify a password and mount secrets as volumes instead of using environment variables on MariaDB:

```diff
- mariadb.rootUser.forcePassword: false
- mariadb.rootUser.injectSecretsAsVolume: false
+ mariadb.rootUser.forcePassword: true
+ mariadb.rootUser.injectSecretsAsVolume: true
- mariadb.db.forcePassword: false
- mariadb.db.injectSecretsAsVolume: false
+ mariadb.db.forcePassword: true
+ mariadb.db.injectSecretsAsVolume: true
```

### Features

If you only need to deploy tasks and schedules, streaming and Skipper can be disabled:

```console
server.configuration.batchEnabled=true
server.configuration.streamingEnabled=false
skipper.enabled=false
rabbitmq.enabled=false
```

If you only need to deploy streams, tasks and schedules can be disabled:

```console
server.configuration.batchEnabled=false
server.configuration.streamingEnabled=true
skipper.enabled=true
rabbitmq.enabled=true
```

NOTE: Both `server.configuration.batchEnabled` and `server.configuration.streamingEnabled` should not be set to `false` at the same time.

### Messaging solutions

There are two supported messaging solutions in this chart:

- RabbitMQ (default)
- Kafka

To change the messaging layer to Kafka, use the the following parameters:

```console
rabbitmq.enabled=false
kafka.enabled=true
```

Only one messaging layer can be used at a given time.

### Using an external database

Sometimes you may want to have Spring Cloud components connect to an external database rather than installing one inside your cluster, e.g. to use a managed database service, or use run a single database server for all your applications. To do this, the chart allows you to specify credentials for an external database under the [`externalDatabase` parameter](#database-parameters). You should also disable the MariaDB installation with the `mariadb.enabled` option. For example with the following parameters:

```console
mariadb.enabled=false
externalDatabase.host=myexternalhost
externalDatabase.port=3306
externalDatabase.password=mypassword
externalDatabase.dataflow.user=mydataflowuser
externalDatabase.dataflow.database=mydataflowdatabase
externalDatabase.dataflow.user=myskipperuser
externalDatabase.dataflow.database=myskipperdatabase
```

Note also if you disable MariaDB per above you MUST supply values for the `externalDatabase` connection.

### Adding extra flags

In case you want to add extra environment variables to any Spring Cloud component, you can use `XXX.extraEnvs` parameter(s), where XXX is placeholder you need to replace with the actual component(s). For instance, to add extra flags to Spring Cloud Data Flow, use:

```yaml
server:
  extraEnvs:
    - name: FOO
      value: BAR
```

### Using custom Dataflow configuration

This helm chart supports using custom configuration for Dataflow server.

You can specify the configuration for Dataflow server setting the `server.existingConfigmap` parameter to an external ConfigMap with the configuration file.

### Using custom Skipper configuration

This helm chart supports using custom configuration for Skipper server.

You can specify the configuration for Skipper server setting the `skipper.existingConfigmap` parameter to an external ConfigMap with the configuration file.

### Sidecars and Init Containers

If you have a need for additional containers to run within the same pod as Dataflow or Skipper components (e.g. an additional metrics or logging exporter), you can do so via the `XXX.sidecars` parameter(s), where XXX is placeholder you need to replace with the actual component(s). Simply define your container according to the Kubernetes container spec.

```yaml
server:
  sidecars:
    - name: your-image-name
      image: your-image
      imagePullPolicy: Always
      ports:
        - name: portname
          containerPort: 1234
```

Similarly, you can add extra init containers using the `XXX.initContainers` parameter(s).

```yaml
server:
  initContainers:
    - name: your-image-name
      image: your-image
      imagePullPolicy: Always
      ports:
        - name: portname
          containerPort: 1234
```

### Ingress

This chart provides support for ingress resources. If you have an ingress controller installed on your cluster, such as [nginx-ingress](https://kubeapps.com/charts/stable/nginx-ingress) or [traefik](https://kubeapps.com/charts/stable/traefik) you can utilize the ingress controller to serve your Spring Cloud Data Flow server.

To enable ingress integration, please set `server.ingress.enabled` to `true`

#### Hosts

Most likely you will only want to have one hostname that maps to this Spring Cloud Data Flow installation. If that's your case, the property `server.ingress.hostname` will set it. However, it is possible to have more than one host. To facilitate this, the `server.ingress.extraHosts` object is can be specified as an array. You can also use `server.ingress.extraTLS` to add the TLS configuration for extra hosts.

For each host indicated at `server.ingress.extraHosts`, please indicate a `name`, `path`, and any `annotations` that you may want the ingress controller to know about.

For annotations, please see [this document](https://github.com/kubernetes/ingress-nginx/blob/master/docs/user-guide/nginx-configuration/annotations.md). Not all annotations are supported by all ingress controllers, but this document does a good job of indicating which annotation is supported by many popular ingress controllers.

## Upgrading

It's necessary to set the `mariadb.rootUser.password` parameter when upgrading for readiness/liveness probes to work properly. When you install this chart for the first time, unless you indicate set this parameter, a random value will be generated. Inspect the MariaDB secret to obtain the root password, then you can upgrade your chart using the command below:

```bash
helm upgrade my-release bitnami/spring-cloud-dataflow --set mariadb.rootUser.password=[MARIADB_ROOT_PASSWORD]
```

If you enabled RabbitMQ chart to be used as the messaging solution for Skipper to manage streaming content, then it's necessary to set the `rabbitmq.auth.password` and `rabbitmq.auth.erlangCookie` parameters when upgrading for readiness/liveness probes to work properly. Inspect the RabbitMQ secret to obtain the password and the Erlang cookie, then you can upgrade your chart using the command below:

```bash
helm upgrade my-release bitnami/spring-cloud-dataflow --set mariadb.rootUser.password=[MARIADB_ROOT_PASSWORD] --set rabbitmq.auth.password=[RABBITMQ_PASSWORD] --set rabbitmq.auth.erlangCookie=[RABBITMQ_ERLANG_COOKIE]
```
