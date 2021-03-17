# Spring Cloud Data Flow

[Spring Cloud Data Flow](https://dataflow.spring.io/) is a microservices-based Streaming and Batch data processing pipeline in Cloud Foundry and Kubernetes.

## TL;DR

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install my-release bitnami/spring-cloud-dataflow
```

## Introduction

This chart bootstraps a [Spring Cloud Data Flow](https://github.com/bitnami/bitnami-docker-spring-cloud-dataflow) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.12+
- Helm 3.1.0
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

| Parameter                 | Description                                     | Default                                                 |
|---------------------------|-------------------------------------------------|---------------------------------------------------------|
| `global.imageRegistry`    | Global Docker image registry                    | `nil`                                                   |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]` (does not add image pull secrets to deployed pods) |
| `global.storageClass`     | Global storage class for dynamic provisioning   | `nil`                                                   |

### Common parameters

| Parameter           | Description                                                          | Default                        |
|---------------------|----------------------------------------------------------------------|--------------------------------|
| `nameOverride`      | String to partially override common.names.fullname                   | `nil`                          |
| `fullnameOverride`  | String to fully override common.names.fullname                       | `nil`                          |
| `clusterDomain`     | Default Kubernetes cluster domain                                    | `cluster.local`                |
| `commonLabels`      | Labels to add to all deployed objects                                | `{}`                           |
| `commonAnnotations` | Annotations to add to all deployed objects                           | `{}`                           |
| `extraDeploy`       | Array of extra objects to deploy with the release                    | `[]` (evaluated as a template) |
| `kubeVersion`       | Force target Kubernetes version (using Helm capabilities if not set) | `nil`                          |

### Dataflow Server parameters

| Parameter                                     | Description                                                                                                      | Default                                                 |
|-----------------------------------------------|------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------|
| `server.image.registry`                       | Spring Cloud Dataflow image registry                                                                             | `docker.io`                                             |
| `server.image.repository`                     | Spring Cloud Dataflow image name                                                                                 | `bitnami/spring-cloud-dataflow`                         |
| `server.image.tag`                            | Spring Cloud Dataflow image tag                                                                                  | `{TAG_NAME}`                                            |
| `server.image.pullPolicy`                     | Spring Cloud Dataflow image pull policy                                                                          | `IfNotPresent`                                          |
| `server.image.pullSecrets`                    | Specify docker-registry secret names as an array                                                                 | `[]` (does not add image pull secrets to deployed pods) |
| `server.composedTaskRunner.image.registry`    | Spring Cloud Dataflow Composed Task Runner image registry                                                        | `docker.io`                                             |
| `server.composedTaskRunner.image.repository`  | Spring Cloud Dataflow Composed Task Runner image name                                                            | `bitnami/spring-cloud-dataflow-composed-task-runner`    |
| `server.composedTaskRunner.image.tag`         | Spring Cloud Dataflow Composed Task Runner image tag                                                             | `{TAG_NAME}`                                            |
| `server.composedTaskRunner.image.pullPolicy`  | Spring Cloud Dataflow Composed Task Runner image pull policy                                                     | `IfNotPresent`                                          |
| `server.composedTaskRunner.image.pullSecrets` | Spring Cloud Dataflow Composed Task Runner image pull secrets                                                    | `[]`                                                    |
| `server.command`                              | Override sever command                                                                                           | `nil`                                                   |
| `server.args`                                 | Override server args                                                                                             | `nil`                                                   |
| `server.configuration.streamingEnabled`       | Enables or disables streaming data processing                                                                    | `true`                                                  |
| `server.configuration.batchEnabled`           | Enables or disables bath data (tasks and schedules) processing                                                   | `true`                                                  |
| `server.configuration.accountName`            | The name of the account to configure for the Kubernetes platform                                                 | `default`                                               |
| `server.configuration.trustK8sCerts`          | Trust K8s certificates when querying the Kubernetes API                                                          | `false`                                                 |
| `server.configuration.containerRegistries`    | Container registries configuration                                                                               | `{}` (check `values.yaml` for more information)         |
| `server.configuration.metricsDashboard`       | Endpoint to the metricsDashboard instance                                                                        | `nil`                                                   |
| `server.existingConfigmap`                    | Name of existing ConfigMap with Dataflow server configuration                                                    | `nil`                                                   |
| `server.extraEnvVars`                         | Extra environment variables to be set on Dataflow server container                                               | `{}`                                                    |
| `server.extraEnvVarsCM`                       | Name of existing ConfigMap containing extra env vars                                                             | `nil`                                                   |
| `server.extraEnvVarsSecret`                   | Name of existing Secret containing extra env vars                                                                | `nil`                                                   |
| `server.replicaCount`                         | Number of Dataflow server replicas to deploy                                                                     | `1`                                                     |
| `server.hostAliases`                          | Add deployment host aliases                                                                                      | `[]`                                                    |
| `server.strategyType`                         | Deployment Strategy Type                                                                                         | `RollingUpdate`                                         |
| `server.podAffinityPreset`                    | Dataflow server pod affinity preset. Ignored if `server.affinity` is set. Allowed values: `soft` or `hard`       | `""`                                                    |
| `server.podAntiAffinityPreset`                | Dataflow server pod anti-affinity preset. Ignored if `server.affinity` is set. Allowed values: `soft` or `hard`  | `soft`                                                  |
| `server.nodeAffinityPreset.type`              | Dataflow server node affinity preset type. Ignored if `server.affinity` is set. Allowed values: `soft` or `hard` | `""`                                                    |
| `server.nodeAffinityPreset.key`               | Dataflow server node label key to match Ignored if `server.affinity` is set.                                     | `""`                                                    |
| `server.nodeAffinityPreset.values`            | Dataflow server node label values to match. Ignored if `server.affinity` is set.                                 | `[]`                                                    |
| `server.affinity`                             | Dataflow server affinity for pod assignment                                                                      | `{}` (evaluated as a template)                          |
| `server.nodeSelector`                         | Dataflow server node labels for pod assignment                                                                   | `{}` (evaluated as a template)                          |
| `server.tolerations`                          | Dataflow server tolerations for pod assignment                                                                   | `[]` (evaluated as a template)                          |
| `server.priorityClassName`                    | Controller priorityClassName                                                                                     | `nil`                                                   |
| `server.podSecurityContext`                   | Dataflow server pods' Security Context                                                                           | `{ fsGroup: "1001" }`                                   |
| `server.containerSecurityContext`             | Dataflow server containers' Security Context                                                                     | `{ runAsUser: "1001" }`                                 |
| `server.resources.limits`                     | The resources limits for the Dataflow server container                                                           | `{}`                                                    |
| `server.resources.requests`                   | The requested resources for the Dataflow server container                                                        | `{}`                                                    |
| `server.podAnnotations`                       | Annotations for Dataflow server pods                                                                             | `{}`                                                    |
| `server.livenessProbe`                        | Liveness probe configuration for Dataflow server                                                                 | Check `values.yaml` file                                |
| `server.readinessProbe`                       | Readiness probe configuration for Dataflow server                                                                | Check `values.yaml` file                                |
| `server.customLivenessProbe`                  | Override default liveness probe                                                                                  | `nil`                                                   |
| `server.customReadinessProbe`                 | Override default readiness probe                                                                                 | `nil`                                                   |
| `server.service.type`                         | Kubernetes service type                                                                                          | `ClusterIP`                                             |
| `server.service.port`                         | Service HTTP port                                                                                                | `8080`                                                  |
| `server.service.nodePort`                     | Service HTTP node port                                                                                           | `nil`                                                   |
| `server.service.clusterIP`                    | Dataflow server service clusterIP IP                                                                             | `None`                                                  |
| `server.service.externalTrafficPolicy`        | Enable client source IP preservation                                                                             | `Cluster`                                               |
| `server.service.loadBalancerIP`               | loadBalancerIP if service type is `LoadBalancer`                                                                 | `nil`                                                   |
| `server.service.loadBalancerSourceRanges`     | Address that are allowed when service is LoadBalancer                                                            | `[]`                                                    |
| `server.service.annotations`                  | Annotations for Dataflow server service                                                                          | `{}`                                                    |
| `server.containerPort`                        | Dataflow server port                                                                                             | `8080                                                   |
| `server.ingress.enabled`                      | Enable ingress controller resource                                                                               | `false`                                                 |
| `server.ingress.pathType`                     | Ingress path type                                                                                                | `ImplementationSpecific`                                |
| `server.ingress.path`                         | Ingress path                                                                                                     | `/`                                                     |
| `server.ingress.certManager`                  | Add annotations for cert-manager                                                                                 | `false`                                                 |
| `server.ingress.hostname`                     | Default host for the ingress resource                                                                            | `dataflow.local`                                        |
| `server.ingress.annotations`                  | Ingress annotations                                                                                              | `[]`                                                    |
| `server.ingress.extraHosts[0].name`           | Additional hostnames to be covered                                                                               | `nil`                                                   |
| `server.ingress.extraHosts[0].path`           | Additional hostnames to be covered                                                                               | `nil`                                                   |
| `server.ingress.extraTls[0].hosts[0]`         | TLS configuration for additional hostnames to be covered                                                         | `nil`                                                   |
| `server.ingress.extraTls[0].secretName`       | TLS configuration for additional hostnames to be covered                                                         | `nil`                                                   |
| `server.ingress.tls`                          | Enables TLS configuration for the Ingress component                                                              | `false`                                                 |
| `server.ingress.secrets[0].name`              | TLS Secret Name                                                                                                  | `nil`                                                   |
| `server.ingress.secrets[0].certificate`       | TLS Secret Certificate                                                                                           | `nil`                                                   |
| `server.ingress.secrets[0].key`               | TLS Secret Key                                                                                                   | `nil`                                                   |
| `server.initContainers`                       | Add additional init containers to the Dataflow server pods                                                       | `{}` (evaluated as a template)                          |
| `server.sidecars`                             | Add additional sidecar containers to the Dataflow server pods                                                    | `{}` (evaluated as a template)                          |
| `server.pdb.create`                           | Enable/disable a Pod Disruption Budget creation                                                                  | `false`                                                 |
| `server.pdb.minAvailable`                     | Minimum number/percentage of pods that should remain scheduled                                                   | `1`                                                     |
| `server.pdb.maxUnavailable`                   | Maximum number/percentage of pods that may be made unavailable                                                   | `nil`                                                   |
| `server.autoscaling.enabled`                  | Enable autoscaling for Dataflow server                                                                           | `false`                                                 |
| `server.autoscaling.minReplicas`              | Minimum number of Dataflow server replicas                                                                       | `nil`                                                   |
| `server.autoscaling.maxReplicas`              | Maximum number of Dataflow server replicas                                                                       | `nil`                                                   |
| `server.autoscaling.targetCPU`                | Target CPU utilization percentage                                                                                | `nil`                                                   |
| `server.autoscaling.targetMemory`             | Target Memory utilization percentage                                                                             | `nil`                                                   |
| `server.jdwp.enabled`                         | Enable Java Debug Wire Protocol (JDWP)                                                                           | `false`                                                 |
| `server.jdwp.port`                            | JDWP TCP port                                                                                                    | `5005`                                                  |
| `server.extraVolumes`                         | Extra Volumes to be set on the Dataflow Server Pod                                                               | `nil`                                                   |
| `server.extraVolumeMounts`                    | Extra VolumeMounts to be set on the Dataflow Container                                                           | `nil`                                                   |
| `server.proxy.host`                           | Proxy host                                                                                                       | `nil`                                                   |
| `server.proxy.port`                           | Proxy port                                                                                                       | `nil`                                                   |
| `server.proxy.user`                           | Proxy username (if authentication is required)                                                                   | `nil`                                                   |
| `server.proxy.password`                       | Proxy password (if authentication is required)                                                                   | `nil`                                                   |

### Dataflow Skipper parameters

| Parameter                                  | Description                                                                                               | Default                                                 |
|--------------------------------------------|-----------------------------------------------------------------------------------------------------------|---------------------------------------------------------|
| `skipper.enabled`                          | Enable Spring Cloud Skipper component                                                                     | `true`                                                  |
| `skipper.image.registry`                   | Spring Cloud Skipper image registry                                                                       | `docker.io`                                             |
| `skipper.image.repository`                 | Spring Cloud Skipper image name                                                                           | `bitnami/spring-cloud-dataflow`                         |
| `skipper.image.tag`                        | Spring Cloud Skipper image tag                                                                            | `{TAG_NAME}`                                            |
| `skipper.image.pullPolicy`                 | Spring Cloud Skipper image pull policy                                                                    | `IfNotPresent`                                          |
| `skipper.image.pullSecrets`                | Specify docker-registry secret names as an array                                                          | `[]` (does not add image pull secrets to deployed pods) |
| `skipper.configuration.accountName`        | The name of the account to configure for the Kubernetes platform                                          | `default`                                               |
| `skipper.configuration.trustK8sCerts`      | Trust K8s certificates when querying the Kubernetes API                                                   | `false`                                                 |
| `skipper.existingConfigmap`                | Name of existing ConfigMap with Skipper server configuration                                              | `nil`                                                   |
| `skipper.extraEnvVars`                     | Extra environment variables to be set on Skipper server container                                         | `{}`                                                    |
| `skipper.extraEnvVarsCM`                   | Name of existing ConfigMap containing extra env vars                                                      | `nil`                                                   |
| `skipper.extraEnvVarsSecret`               | Name of existing Secret containing extra env vars                                                         | `nil`                                                   |
| `skipper.replicaCount`                     | Number of Skipper server replicas to deploy                                                               | `1`                                                     |
| `skipper.strategyType`                     | Deployment Strategy Type                                                                                  | `RollingUpdate`                                         |
| `skipper.podAffinityPreset`                | Skipper pod affinity preset. Ignored if `skipper.affinity` is set. Allowed values: `soft` or `hard`       | `""`                                                    |
| `skipper.podAntiAffinityPreset`            | Skipper pod anti-affinity preset. Ignored if `skipper.affinity` is set. Allowed values: `soft` or `hard`  | `soft`                                                  |
| `skipper.nodeAffinityPreset.type`          | Skipper node affinity preset type. Ignored if `skipper.affinity` is set. Allowed values: `soft` or `hard` | `""`                                                    |
| `skipper.nodeAffinityPreset.key`           | Skipper node label key to match Ignored if `skipper.affinity` is set.                                     | `""`                                                    |
| `skipper.nodeAffinityPreset.values`        | Skipper node label values to match. Ignored if `skipper.affinity` is set.                                 | `[]`                                                    |
| `skipper.hostAliases`                      | Add deployment host aliases                                                                               | `[]`                                                    |
| `skipper.affinity`                         | Skipper affinity for pod assignment                                                                       | `{}` (evaluated as a template)                          |
| `skipper.nodeSelector`                     | Skipper node labels for pod assignment                                                                    | `{}` (evaluated as a template)                          |
| `skipper.tolerations`                      | Skipper tolerations for pod assignment                                                                    | `[]` (evaluated as a template)                          |
| `skipper.priorityClassName`                | Controller priorityClassName                                                                              | `nil`                                                   |
| `skipper.podSecurityContext`               | Skipper server pods' Security Context                                                                     | `{ fsGroup: "1001" }`                                   |
| `skipper.containerSecurityContext`         | Skipper server containers' Security Context                                                               | `{ runAsUser: "1001" }`                                 |
| `skipper.resources.limits`                 | The resources limits for the Skipper server container                                                     | `{}`                                                    |
| `skipper.resources.requests`               | The requested resources for the Skipper server container                                                  | `{}`                                                    |
| `skipper.podAnnotations`                   | Annotations for Skipper server pods                                                                       | `{}`                                                    |
| `skipper.livenessProbe`                    | Liveness probe configuration for Skipper server                                                           | Check `values.yaml` file                                |
| `skipper.readinessProbe`                   | Readiness probe configuration for Skipper server                                                          | Check `values.yaml` file                                |
| `skipper.customLivenessProbe`              | Override default liveness probe                                                                           | `nil`                                                   |
| `skipper.customReadinessProbe`             | Override default readiness probe                                                                          | `nil`                                                   |
| `skipper.service.type`                     | Kubernetes service type                                                                                   | `ClusterIP`                                             |
| `skipper.service.port`                     | Service HTTP port                                                                                         | `8080`                                                  |
| `skipper.service.nodePort`                 | Service HTTP node port                                                                                    | `nil`                                                   |
| `skipper.service.clusterIP`                | Skipper server service clusterIP IP                                                                       | `None`                                                  |
| `skipper.service.externalTrafficPolicy`    | Enable client source IP preservation                                                                      | `Cluster`                                               |
| `skipper.service.loadBalancerIP`           | loadBalancerIP if service type is `LoadBalancer`                                                          | `nil`                                                   |
| `skipper.service.loadBalancerSourceRanges` | Address that are allowed when service is LoadBalancer                                                     | `[]`                                                    |
| `skipper.service.annotations`              | Annotations for Skipper server service                                                                    | `{}`                                                    |
| `skipper.initContainers`                   | Add additional init containers to the Skipper pods                                                        | `{}` (evaluated as a template)                          |
| `skipper.sidecars`                         | Add additional sidecar containers to the Skipper pods                                                     | `{}` (evaluated as a template)                          |
| `skipper.pdb.create`                       | Enable/disable a Pod Disruption Budget creation                                                           | `false`                                                 |
| `skipper.pdb.minAvailable`                 | Minimum number/percentage of pods that should remain scheduled                                            | `1`                                                     |
| `skipper.pdb.maxUnavailable`               | Maximum number/percentage of pods that may be made unavailable                                            | `nil`                                                   |
| `skipper.autoscaling.enabled`              | Enable autoscaling for Skipper server                                                                     | `false`                                                 |
| `skipper.autoscaling.minReplicas`          | Minimum number of Skipper server replicas                                                                 | `nil`                                                   |
| `skipper.autoscaling.maxReplicas`          | Maximum number of Skipper server replicas                                                                 | `nil`                                                   |
| `skipper.autoscaling.targetCPU`            | Target CPU utilization percentage                                                                         | `nil`                                                   |
| `skipper.autoscaling.targetMemory`         | Target Memory utilization percentage                                                                      | `nil`                                                   |
| `skipper.jdwp.enabled`                     | Enable Java Debug Wire Protocol (JDWP)                                                                    | `false`                                                 |
| `skipper.jdwp.port`                        | JDWP TCP port                                                                                             | `5005`                                                  |
| `skipper.extraVolumes`                     | Extra Volumes to be set on the Skipper Pod                                                                | `nil`                                                   |
| `skipper.extraVolumeMounts`                | Extra VolumeMounts to be set on the Skipper Container                                                     | `nil`                                                   |
| `externalSkipper.host`                     | Host of a external Skipper Server                                                                         | `localhost`                                             |
| `externalSkipper.port`                     | External Skipper Server port number                                                                       | `7577`                                                  |

### Deployer parameters

| Parameter                           | Description                                      | Default                             |
|-------------------------------------|--------------------------------------------------|-------------------------------------|
| `deployer.resources.limits`         | Streaming applications resource limits           | `{ cpu: "500m", memory: "1024Mi" }` |
| `deployer.resources.requests`       | Streaming applications resource requests         | `{}`                                |
| `deployer.resources.readinessProbe` | Streaming applications readiness probes requests | Check `values.yaml` file            |
| `deployer.resources.livenessProbe`  | Streaming applications liveness probes  requests | Check `values.yaml` file            |
| `deployer.nodeSelector`             | Streaming applications nodeSelector              | `""`                                |
| `deployer.tolerations`              | Streaming applications tolerations               | `{}`                                |
| `deployer.volumeMounts`             | Streaming applications extra volume mounts       | `{}`                                |
| `deployer.volumes`                  | Streaming applications extra volumes             | `{}`                                |
| `deployer.environmentVariables`     | Streaming applications environment variables     | `""`                                |
| `deployer.podSecurityContext`       | Streaming applications Security Context.         | `{runAsUser: 1001}`                 |

### RBAC parameters

| Parameter               | Description                                                                         | Default                                              |
|-------------------------|-------------------------------------------------------------------------------------|------------------------------------------------------|
| `serviceAccount.create` | Enable the creation of a ServiceAccount for Dataflow server and Skipper server pods | `true`                                               |
| `serviceAccount.name`   | Name of the created serviceAccount                                                  | Generated using the `common.names.fullname` template |
| `rbac.create`           | Weather to create & use RBAC resources or not                                       | `true`                                               |

### Metrics parameters

| Parameter                              | Description                                                                                            | Default                                                 |
|----------------------------------------|--------------------------------------------------------------------------------------------------------|---------------------------------------------------------|
| `metrics.metrics`                      | Enable the export of Prometheus metrics                                                                | `false`                                                 |
| `metrics.image.registry`               | Prometheus Rsocket Proxy image registry                                                                | `docker.io`                                             |
| `metrics.image.repository`             | Prometheus Rsocket Proxy image name                                                                    | `bitnami/prometheus-rsocket-proxy`                      |
| `metrics.image.tag`                    | Prometheus Rsocket Proxy image tag                                                                     | `{TAG_NAME}`                                            |
| `metrics.image.pullPolicy`             | Prometheus Rsocket Proxy image pull policy                                                             | `IfNotPresent`                                          |
| `metrics.image.pullSecrets`            | Specify docker-registry secret names as an array                                                       | `[]` (does not add image pull secrets to deployed pods) |
| `metrics.replicaCount`                 | Number of Prometheus Rsocket Proxy replicas to deploy                                                  | `1`                                                     |
| `metrics.resources.limits`             | The resources limits for the Prometheus Rsocket Proxy container                                        | `{}`                                                    |
| `metrics.resources.requests`           | The requested resources for the Prometheus Rsocket Proxy container                                     | `{}`                                                    |
| `metrics.kafka.service.httpPort`       | Prometheus Rsocket Proxy HTTP port                                                                     | `8080`                                                  |
| `metrics.kafka.service.rsocketPort`    | Prometheus Rsocket Proxy Rsocket port                                                                  | `8080`                                                  |
| `metrics.kafka.service.annotations`    | Annotations for Prometheus Rsocket Proxy service                                                       | `Check values.yaml file`                                |
| `metrics.serviceMonitor.enabled`       | if `true`, creates a Prometheus Operator ServiceMonitor (also requires `metrics.enabled` to be `true`) | `false`                                                 |
| `metrics.serviceMonitor.namespace`     | Namespace in which ServiceMonitor is created if different from release                                 | `nil`                                                   |
| `metrics.serviceMonitor.extraLabels`   | Labels to add to ServiceMonitor                                                                        | `{}`                                                    |
| `metrics.serviceMonitor.interval`      | Interval at which metrics should be scraped.                                                           | `nil` (Prometheus Operator default value)               |
| `metrics.serviceMonitor.scrapeTimeout` | Timeout after which the scrape is ended                                                                | `nil` (Prometheus Operator default value)               |
| `metrics.pdb.create`                   | Enable/disable a Pod Disruption Budget creation                                                        | `false`                                                 |
| `metrics.pdb.minAvailable`             | Minimum number/percentage of pods that should remain scheduled                                         | `1`                                                     |
| `metrics.pdb.maxUnavailable`           | Maximum number/percentage of pods that may be made unavailable                                         | `nil`                                                   |
| `metrics.autoscaling.enabled`          | Enable autoscaling for Prometheus Rsocket Proxy                                                        | `false`                                                 |
| `metrics.autoscaling.minReplicas`      | Minimum number of Prometheus Rsocket Proxy replicas                                                    | `nil`                                                   |
| `metrics.autoscaling.maxReplicas`      | Maximum number of Prometheus Rsocket Proxy replicas                                                    | `nil`                                                   |
| `metrics.autoscaling.targetCPU`        | Target CPU utilization percentage                                                                      | `nil`                                                   |
| `metrics.autoscaling.targetMemory`     | Target Memory utilization percentage                                                                   | `nil`                                                   |


### Init Container parameters

| Parameter                            | Description                                                                                       | Default                                                 |
|--------------------------------------|---------------------------------------------------------------------------------------------------|---------------------------------------------------------|
| `waitForBackends.enabled`            | Wait for the database and other services (such as Kafka or RabbitMQ) used when enabling streaming | `true`                                                  |
| `waitForBackends.image.registry`     | Init container wait-for-backend image registry                                                    | `docker.io`                                             |
| `waitForBackends.image.repository`   | Init container wait-for-backend image name                                                        | `bitnami/kubectl`                                       |
| `waitForBackends.image.tag`          | Init container wait-for-backend image tag                                                         | `{TAG_NAME}`                                            |
| `waitForBackends.image.pullPolicy`   | Init container wait-for-backend image pull policy                                                 | `IfNotPresent`                                          |
| `waitForBackends.image.pullSecrets`  | Specify docker-registry secret names as an array                                                  | `[]` (does not add image pull secrets to deployed pods) |
| `waitForBackends.resources.limits`   | Init container wait-for-backend resource  limits                                                  | `{}`                                                    |
| `waitForBackends.resources.requests` | Init container wait-for-backend resource  requests                                                | `{}`                                                    |

### Database parameters

| Parameter                                 | Description                                                                                         | Default                                   |
|-------------------------------------------|-----------------------------------------------------------------------------------------------------|-------------------------------------------|
| `mariadb.enabled`                         | Enable/disable MariaDB chart installation                                                           | `true`                                    |
| `mariadb.architecture`                    | MariaDB architecture (`standalone` or `replication`)                                                | `standalone`                              |
| `mariadb.auth.database`                   | Database name to create                                                                             | `dataflow`                                |
| `mariadb.auth.username`                   | Username of new user to create                                                                      | `dataflow`                                |
| `mariadb.auth.password`                   | Password for the new user                                                                           | `change-me`                               |
| `mariadb.auth.rootPassword`               | Password for the MariaDB `root` user                                                                | _random 10 character alphanumeric string_ |
| `mariadb.initdbScripts`                   | Dictionary of initdb scripts                                                                        | Check `values.yaml` file                  |
| `externalDatabase.driver`                 | The fully qualified name of the JDBC Driver class                                                   | `""`                                      |
| `externalDatabase.scheme`                 | The scheme is a vendor-specific or shared protocol string that follows the "jdbc:" of the URL       | `""`                                      |
| `externalDatabase.host`                   | Host of the external database                                                                       | `localhost`                               |
| `externalDatabase.port`                   | External database port number                                                                       | `3306`                                    |
| `externalDatabase.password`               | Password for the above username                                                                     | `""`                                      |
| `externalDatabase.existingPasswordSecret` | Existing secret with database password                                                              | `""`                                      |
| `externalDatabase.existingPasswordKey`    | Key of the existing secret with database password                                                   | `datasource-password`                     |
| `externalDatabase.dataflow.url`           | JDBC URL for dataflow server. Overrides external scheme, host, port, database, and jdbc parameters. | `""`                                      |
| `externalDatabase.dataflow.username`      | Existing username in the external db to be used by Dataflow server                                  | `dataflow`                                |
| `externalDatabase.dataflow.database`      | Name of the existing database to be used by Dataflow server                                         | `dataflow`                                |
| `externalDatabase.skipper.url`            | JDBC URL for skipper. Overrides external scheme, host, port, database, and jdbc parameters.         | `""`                                      |
| `externalDatabase.skipper.username`       | Existing username in the external db to be used by Skipper server                                   | `skipper`                                 |
| `externalDatabase.skipper.database`       | Name of the existing database to be used by Skipper server                                          | `skipper`                                 |
| `externalDatabase.hibernateDialect`       | Hibernate Dialect used by Dataflow/Skipper servers                                                  | `""`                                      |

### RabbitMQ chart parameters

| Parameter                                 | Description                                | Default                                   |
|-------------------------------------------|--------------------------------------------|-------------------------------------------|
| `rabbitmq.enabled`                        | Enable/disable RabbitMQ chart installation | `true`                                    |
| `rabbitmq.auth.username`                  | RabbitMQ username                          | `user`                                    |
| `rabbitmq.auth.password`                  | RabbitMQ password                          | _random 40 character alphanumeric string_ |
| `externalRabbitmq.enabled`                | Enable/disable external RabbitMQ           | `false`                                   |
| `externalRabbitmq.host`                   | Host of the external RabbitMQ              | `localhost`                               |
| `externalRabbitmq.port`                   | External RabbitMQ port number              | `5672`                                    |
| `externalRabbitmq.username`               | External RabbitMQ username                 | `guest`                                   |
| `externalRabbitmq.password`               | External RabbitMQ password                 | `guest`                                   |
| `externalRabbitmq.vhost`                  | External RabbitMQ virtual host             | `/`                                       |
| `externalRabbitmq.existingPasswordSecret` | Existing secret with RabbitMQ password     | `""`                                      |

### Kafka chart parameters

| Parameter                             | Description                                 | Default          |
|---------------------------------------|---------------------------------------------|------------------|
| `kafka.enabled`                       | Enable/disable Kafka chart installation     | `false`          |
| `kafka.replicaCount`                  | Number of Kafka brokers                     | `1`              |
| `kafka.offsetsTopicReplicationFactor` | Kafka Secret Key                            | `1`              |
| `kafka.zookeeper.enabled`             | Enable/disable Zookeeper chart installation | `nil`            |
| `kafka.zookeeper.replicaCount`        | Number of Zookeeper replicas                | `1`              |
| `externalKafka.enabled`               | Enable/disable external Kafka               | `false`          |
| `externalKafka.brokers`               | External Kafka brokers                      | `localhost:9092` |
| `externalKafka.zkNodes`               | External Zookeeper nodes                    | `localhost:2181` |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
helm install my-release --set server.replicaCount=2 bitnami/spring-cloud-dataflow
```

The above command install Spring Cloud Data Flow chart with 2 Dataflow server replicas.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
helm install my-release -f values.yaml bitnami/spring-cloud-dataflow
```

> **Tip**: You can use the default [values.yaml](https://github.com/bitnami/charts/blob/master/bitnami/spring-cloud-dataflow/values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

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
externalDatabase.scheme=mariadb
externalDatabase.host=myexternalhost
externalDatabase.port=3306
externalDatabase.password=mypassword
externalDatabase.dataflow.user=mydataflowuser
externalDatabase.dataflow.database=mydataflowdatabase
externalDatabase.dataflow.user=myskipperuser
externalDatabase.dataflow.database=myskipperdatabase
```

NOTE: When using the indidual properties (scheme, host, port, database, an optional jdbcParameters) this chart will format the JDBC URL as `jdbc:{scheme}://{host}:{port}/{database}{jdbcParameters}`. The URL format follows that of the MariaDB database drive but may not work for other database vendors.

To use an alternate database vendor (other than MariaDB) you can use the `externalDatabase.dataflow.url` and `externalDatabase.skipper.url` properties to provide the JDBC URLs for the dataflow server and skipper respectively. If these properties are defined, they will take precedence over the individual attributes. As an example of configuring an external MS SQL Server database:

```console
mariadb.enabled=false
externalDatabase.password=mypassword
externalDatabase.dataflow.url=jdbc:sqlserver://mssql-server:1433
externalDatabase.dataflow.user=mydataflowuser
externalDatabase.skipper.url=jdbc:sqlserver://mssql-server:1433
externalDatabase.skipper.user=myskipperuser
externalDatabase.hibernateDialect=org.hibernate.dialect.SQLServer2012Dialect
```

NOTE: If you disable MariaDB per above you MUST supply values for the `externalDatabase` connection.

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

#### TLS

This chart will facilitate the creation of TLS secrets for use with the ingress controller, however, this is not required. There are four common use cases:

- Helm generates/manages certificate secrets based on the parameters.
- User generates/manages certificates separately.
- Helm creates self-signed certificates and generates/manages certificate secrets.
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
- If you are going to use Helm to manage the certificates based on the parameters, please copy these values into the `certificate` and `key` values for a given `server.ingress.secrets` entry.
- In case you are going to manage TLS secrets separately, please know that you must create a TLS secret with name *INGRESS_HOSTNAME-tls* (where *INGRESS_HOSTNAME* is a placeholder to be replaced with the hostname you set using the `server.ingress.hostname` parameter).
- To use self-signed certificates created by Helm, set `server.ingress.tls` to `true` and `server.ingress.certManager` to `false`.
- If your cluster has a [cert-manager](https://github.com/jetstack/cert-manager) add-on to automate the management and issuance of TLS certificates, set `server.ingress.certManager` boolean to true to enable the corresponding annotations for cert-manager.

### Setting Pod's affinity

This chart allows you to set your custom affinity using the `XXX.affinity` parameter(s). Find more information about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `XXX.podAffinityPreset`, `XXX.podAntiAffinityPreset`, or `XXX.nodeAffinityPreset` parameters.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

If you enabled RabbitMQ chart to be used as the messaging solution for Skipper to manage streaming content, then it's necessary to set the `rabbitmq.auth.password` and `rabbitmq.auth.erlangCookie` parameters when upgrading for readiness/liveness probes to work properly. Inspect the RabbitMQ secret to obtain the password and the Erlang cookie, then you can upgrade your chart using the command below:

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

### v0.x.x

```bash
helm upgrade my-release bitnami/spring-cloud-dataflow --set mariadb.rootUser.password=[MARIADB_ROOT_PASSWORD] --set rabbitmq.auth.password=[RABBITMQ_PASSWORD] --set rabbitmq.auth.erlangCookie=[RABBITMQ_ERLANG_COOKIE]
```

### v1.x.x

```bash
helm upgrade my-release bitnami/spring-cloud-dataflow --set mariadb.auth.rootPassword=[MARIADB_ROOT_PASSWORD] --set rabbitmq.auth.password=[RABBITMQ_PASSWORD] --set rabbitmq.auth.erlangCookie=[RABBITMQ_ERLANG_COOKIE]
```

## Notable changes

### v1.0.0

MariaDB dependency version was bumped to a new major version that introduces several incompatilibites. Therefore, backwards compatibility is not guaranteed unless an external database is used. Check [MariaDB Upgrading Notes](https://github.com/bitnami/charts/tree/master/bitnami/mariadb#to-800) for more information.

To upgrade to `1.0.0`, you will need to reuse the PVC used to hold the MariaDB data on your previous release. To do so, follow the instructions below (the following example assumes that the release name is `dataflow`):

> NOTE: Please, create a backup of your database before running any of those actions.

Obtain the credentials and the name of the PVC used to hold the MariaDB data on your current release:

```console
export MARIADB_ROOT_PASSWORD=$(kubectl get secret --namespace default dataflow-mariadb -o jsonpath="{.data.mariadb-root-password}" | base64 --decode)
export MARIADB_PASSWORD=$(kubectl get secret --namespace default dataflow-mariadb -o jsonpath="{.data.mariadb-password}" | base64 --decode)
export MARIADB_PVC=$(kubectl get pvc -l app=mariadb,component=master,release=dataflow -o jsonpath="{.items[0].metadata.name}")
export RABBITMQ_PASSWORD=$(kubectl get secret --namespace default dataflow-rabbitmq -o jsonpath="{.data.rabbitmq-password}" | base64 --decode)
export RABBITMQ_ERLANG_COOKIE=$(kubectl get secret --namespace default dataflow-rabbitmq -o jsonpath="{.data.rabbitmq-erlang-cookie}" | base64 --decode)
```

Upgrade your release (maintaining the version) disabling MariaDB and scaling Data Flow replicas to 0:

```console
$ helm upgrade dataflow bitnami/spring-cloud-dataflow --version 0.7.4 \
  --set server.replicaCount=0 \
  --set skipper.replicaCount=0 \
  --set mariadb.enabled=false \
  --set rabbitmq.auth.password=$RABBITMQ_PASSWORD \
  --set rabbitmq.auth.erlangCookie=$RABBITMQ_ERLANG_COOKIE
```

Finally, upgrade you release to 1.0.0 reusing the existing PVC, and enabling back MariaDB:

```console
$ helm upgrade dataflow bitnami/spring-cloud-dataflow \
  --set mariadb.primary.persistence.existingClaim=$MARIADB_PVC \
  --set mariadb.auth.rootPassword=$MARIADB_ROOT_PASSWORD \
  --set mariadb.auth.password=$MARIADB_PASSWORD \
  --set rabbitmq.auth.password=$RABBITMQ_PASSWORD \
  --set rabbitmq.auth.erlangCookie=$RABBITMQ_ERLANG_COOKIE
```

You should see the lines below in MariaDB container logs:

```console
$ kubectl logs $(kubectl get pods -l app.kubernetes.io/instance=dataflow,app.kubernetes.io/name=mariadb,app.kubernetes.io/component=primary -o jsonpath="{.items[0].metadata.name}")
...
mariadb 12:13:24.98 INFO  ==> Using persisted data
mariadb 12:13:25.01 INFO  ==> Running mysql_upgrade
...
```
