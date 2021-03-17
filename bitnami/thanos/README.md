# Thanos

[Thanos](https://thanos.io/) is a highly available metrics system that can be added on top of existing Prometheus deployments, providing a global query view across all Prometheus installations.

## TL;DR

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install my-release bitnami/thanos
```

## Introduction

This chart bootstraps a [Thanos](https://github.com/bitnami/bitnami-docker-thanos) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.12+
- Helm 3.1.0
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install my-release bitnami/thanos
```

These commands deploy Thanos on the Kubernetes cluster with the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` chart:

```bash
helm uninstall my-release
```

## Architecture

This charts allows you install several Thanos components, so you deploy an architecture as the one below:

```
                       ┌──────────────┐                  ┌──────────────┐      ┌──────────────┐
                       │ Thanos       │───────────┬────▶ │ Thanos Store │      │ Thanos       │
                       │ Query        │           │      │ Gateway      │      │ Compactor    │
                       └──────────────┘           │      └──────────────┘      └──────────────┘
                   push                           │             │                     │
┌──────────────┐   alerts   ┌──────────────┐      │             │ storages            │ Downsample &
│ Alertmanager │ ◀──────────│ Thanos       │ ◀────┤             │ query metrics       │ compact blocks
│ (*)          │            │ Ruler        │      │             │                     │
└──────────────┘            └──────────────┘      │             ▼                     │
      ▲                            │              │      ┌────────────────┐           │
      │ push alerts                └──────────────│────▶ │ MinIO&reg; (*) │ ◀─────────┘
      │                                           │      │                │
┌ ── ── ── ── ── ── ── ── ── ──┐                  │      └────────────────┘
│┌────────────┐  ┌────────────┐│                  │             ▲
││ Prometheus │─▶│ Thanos     ││ ◀────────────────┘             │
││ (*)        │◀─│ Sidecar (*)││    query                       │ inspect
│└────────────┘  └────────────┘│    metrics                     │ blocks
└ ── ── ── ── ── ── ── ── ── ──┘                                │
                                                         ┌──────────────┐
                                                         │ Thanos       │
                                                         │ Bucket Web   │
                                                         └──────────────┘
```

> Note: Components marked with (*) are provided by subchart(s) (such as the [Bitnami MinIO&reg; chart](https://github.com/bitnami/charts/tree/master/bitnami/minio)) or external charts (such as the [Bitnami kube-prometheus chart](https://github.com/bitnami/charts/tree/master/bitnami/kube-prometheus)).

Check the section [Integrate Thanos with Prometheus and Alertmanager](#integrate-thanos-with-prometheus-and-alertmanager) for detailed instructions to deploy this architecture.

## Parameters

The following tables lists the configurable parameters of the Thanos chart and their default values per section/component:

### Global parameters

| Parameter                 | Description                                     | Default                                                 |
| ------------------------- | ----------------------------------------------- | ------------------------------------------------------- |
| `global.imageRegistry`    | Global Docker image registry                    | `nil`                                                   |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]` (does not add image pull secrets to deployed pods) |
| `global.storageClass`     | Global storage class for dynamic provisioning   | `nil`                                                   |

### Common parameters

| Parameter                     | Description                                                                               | Default                                                 |
| ----------------------------- | ----------------------------------------------------------------------------------------- | ------------------------------------------------------- |
| `image.registry`              | Thanos image registry                                                                     | `docker.io`                                             |
| `image.repository`            | Thanos image name                                                                         | `bitnami/thanos`                                        |
| `image.tag`                   | Thanos image tag                                                                          | `{TAG_NAME}`                                            |
| `image.pullPolicy`            | Thanos image pull policy                                                                  | `IfNotPresent`                                          |
| `image.pullSecrets`           | Specify docker-registry secret names as an array                                          | `[]` (does not add image pull secrets to deployed pods) |
| `nameOverride`                | String to partially override common.names.fullname                                        | `nil`                                                   |
| `fullnameOverride`            | String to fully override common.names.fullname                                            | `nil`                                                   |
| `clusterDomain`               | Default Kubernetes cluster domain                                                         | `cluster.local`                                         |
| `objstoreConfig`              | [Objstore configuration](https://thanos.io/storage.md/#configuration)                     | `nil`                                                   |
| `indexCacheConfig`            | [Index cache configuration](https://thanos.io/components/store.md/#memcached-index-cache) | `nil`                                                   |
| `bucketCacheConfig`           | [Bucket cache configuration](https://thanos.io/components/store.md/#caching-bucket)       | `nil`                                                   |
| `existingObjstoreSecret`      | Name of existing secret with Objstore configuration                                       | `nil`                                                   |
| `existingObjstoreSecretItems` | List of Secret Keys and Paths                                                             | `[]`                                                    |
| `existingServiceAccount`      | Name for the existing service account to be shared between the components                 | `nil`                                                   |
| `kubeVersion`                 | Force target Kubernetes version (using Helm capabilities if not set)                      | `nil`                                                   |

### Thanos Query parameters

| Parameter                                        | Description                                                                                                                                                   | Default                         |
| ------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------- |
| `query.enabled`                                  | Enable/disable Thanos Query component                                                                                                                         | `true`                          |
| `query.logLevel`                                 | Thanos Query log level                                                                                                                                        | `info`                          |
| `query.logFormat`                                | Thanos Query log format                                                                                                                                       | `logfmt`                        |
| `query.replicaLabel`                             | Replica indicator(s) along which data is deduplicated                                                                                                         | `[replica]`                     |
| `query.hostAliases`                              | Add deployment host aliases                                                                                                                                   | `[]`                            |
| `query.dnsDiscovery.enabled`                     | Enable store APIs discovery via DNS                                                                                                                           | `true`                          |
| `query.dnsDiscovery.sidecarsService`             | Sidecars service name to discover them using DNS discovery                                                                                                    | `nil` (evaluated as a template) |
| `query.dnsDiscovery.sidecarsNamespace`           | Sidecars namespace to discover them using DNS discovery                                                                                                       | `nil` (evaluated as a template) |
| `query.stores`                                   | Store APIs to connect with Thanos Query                                                                                                                       | `[]`                            |
| `query.sdConfig`                                 | Service Discovery configuration                                                                                                                               | `nil`                           |
| `query.existingSDConfigmap`                      | Name of existing ConfigMap with Ruler configuration                                                                                                           | `nil`                           |
| `query.extraFlags`                               | Extra Flags to passed to Thanos Query                                                                                                                         | `[]`                            |
| `query.replicaCount`                             | Number of Thanos Query replicas to deploy                                                                                                                     | `1`                             |
| `query.strategyType`                             | Deployment Strategy Type                                                                                                                                      | `RollingUpdate`                 |
| `query.podAntiAffinityPreset`                    | Thanos Query pod anti-affinity preset. Ignored if `query.affinity` is set. Allowed values: `soft` or `hard`                                                   | `soft`                          |
| `query.nodeAffinityPreset.type`                  | Thanos Query node affinity preset type. Ignored if `query.affinity` is set. Allowed values: `soft` or `hard`                                                  | `""`                            |
| `query.nodeAffinityPreset.key`                   | Thanos Query node label key to match Ignored if `query.affinity` is set.                                                                                      | `""`                            |
| `query.nodeAffinityPreset.values`                | Thanos Query node label values to match. Ignored if `query.affinity` is set.                                                                                  | `[]`                            |
| `query.affinity`                                 | Thanos Query affinity for pod assignment                                                                                                                      | `{}` (evaluated as a template)  |
| `query.nodeSelector`                             | Thanos Query node labels for pod assignment                                                                                                                   | `{}` (evaluated as a template)  |
| `query.tolerations`                              | Thanos Query tolerations for pod assignment                                                                                                                   | `[]` (evaluated as a template)  |
| `query.podLabels`                                | Thanos Query pod labels                                                                                                                                       | `{}` (evaluated as a template)  |
| `query.priorityClassName`                        | Controller priorityClassName                                                                                                                                  | `nil`                           |
| `query.securityContext.enabled`                  | Enable security context for Thanos Query pods                                                                                                                 | `true`                          |
| `query.securityContext.fsGroup`                  | Group ID for the Thanos Query filesystem                                                                                                                      | `1001`                          |
| `query.securityContext.runAsUser`                | User ID for the Thanos Query container                                                                                                                        | `1001`                          |
| `query.resources.limits`                         | The resources limits for the Thanos Query container                                                                                                           | `{}`                            |
| `query.resources.requests`                       | The requested resources for the Thanos Query container                                                                                                        | `{}`                            |
| `query.podAnnotations`                           | Annotations for Thanos Query pods                                                                                                                             | `{}`                            |
| `query.livenessProbe`                            | Liveness probe configuration for Thanos Query                                                                                                                 | `Check values.yaml file`        |
| `query.readinessProbe`                           | Readiness probe configuration for Thanos Query                                                                                                                | `Check values.yaml file`        |
| `query.grpcTLS.server.secure`                    | Enable TLS for GRPC server                                                                                                                                    | `false`                         |
| `query.grpcTLS.server.cert`                      | TLS Certificate for gRPC server - ignored if existingSecret is provided                                                                                       | `nil`                           |
| `query.grpcTLS.server.key`                       | TLS Key for gRPC server - ignored if existingSecret is provided                                                                                               | `nil`                           |
| `query.grpcTLS.server.ca`                        | TLS client CA for gRPC server used for client verification purposes on the server - ignored if existingSecret is provided                                     | `nil`                           |
| `query.grpcTLS.server.existingSecret.name`       | Existing secret name containing your own TLS certificates for server                                                                                          | `nil`                           |
| `query.grpcTLS.server.existingSecret.keyMapping` | Key mapping between the expected keys and the existing secret's keys. [See more](https://github.com/bitnami/charts/tree/master/bitnami/common#existingsecret) | `nil`                           |
| `query.grpcTLS.client.secure`                    | Use TLS when talking to the gRPC server                                                                                                                       | `false`                         |
| `query.grpcTLS.client.cert`                      | TLS Certificates to use to identify this client to the server - ignored if existingSecret is provided                                                         | `nil`                           |
| `query.grpcTLS.client.key`                       | TLS Key for the client's certificate - ignored if existingSecret is provided                                                                                  | `nil`                           |
| `query.grpcTLS.client.ca`                        | TLS CA Certificates to use to verify gRPC servers - ignored if existingSecret is provided                                                                     | `nil`                           |
| `query.grpcTLS.client.servername`                | Server name to verify the hostname on the returned gRPC certificates.                                                                                         | `nil`                           |
| `query.grpcTLS.client.existingSecret.name`       | Existing secret name containing your own TLS certificates for client                                                                                          | `nil`                           |
| `query.grpcTLS.client.existingSecret.keyMapping` | Key mapping between the expected keys and the existing secret's keys. [See more](https://github.com/bitnami/charts/tree/master/bitnami/common#existingsecret) | `nil`                           |
| `query.service.type`                             | Kubernetes service type                                                                                                                                       | `ClusterIP`                     |
| `query.service.clusterIP`                        | Thanos Query service clusterIP IP                                                                                                                             | `None`                          |
| `query.service.http.port`                        | Service HTTP port                                                                                                                                             | `9090`                          |
| `query.service.http.nodePort`                    | Service HTTP node port                                                                                                                                        | `nil`                           |
| `query.service.grpc.port`                        | Service GRPC port                                                                                                                                             | `10901`                         |
| `query.service.grpc.nodePort`                    | Service GRPC node port                                                                                                                                        | `nil`                           |
| `query.service.loadBalancerIP`                   | loadBalancerIP if service type is `LoadBalancer`                                                                                                              | `nil`                           |
| `query.service.loadBalancerSourceRanges`         | Address that are allowed when service is LoadBalancer                                                                                                         | `[]`                            |
| `query.service.annotations`                      | Annotations for Thanos Query service                                                                                                                          | `{}`                            |
| `query.service.labelSelectorsOverride`           | Selector for Thanos query service                                                                                                                             | `{}`                            |
| `query.serviceAccount.annotations`               | Annotations for Thanos Query Service Account                                                                                                                  | `{}`                            |
| `query.rbac.create`                              | Create RBAC                                                                                                                                                   | `false`                         |
| `query.pspEnabled`                               | Create PodSecurityPolicy                                                                                                                                      | `false`                         |
| `query.autoscaling.enabled`                      | Enable autoscaling for Thanos Query                                                                                                                           | `false`                         |
| `query.autoscaling.minReplicas`                  | Minimum number of Thanos Query replicas                                                                                                                       | `nil`                           |
| `query.autoscaling.maxReplicas`                  | Maximum number of Thanos Query replicas                                                                                                                       | `nil`                           |
| `query.autoscaling.targetCPU`                    | Target CPU utilization percentage                                                                                                                             | `nil`                           |
| `query.autoscaling.targetMemory`                 | Target Memory utilization percentage                                                                                                                          | `nil`                           |
| `query.pdb.create`                               | Enable/disable a Pod Disruption Budget creation                                                                                                               | `false`                         |
| `query.pdb.minAvailable`                         | Minimum number/percentage of pods that should remain scheduled                                                                                                | `1`                             |
| `query.pdb.maxUnavailable`                       | Maximum number/percentage of pods that may be made unavailable                                                                                                | `nil`                           |
| `query.ingress.enabled`                          | Enable ingress controller resource                                                                                                                            | `false`                         |
| `query.ingress.apiVersion`                       | Force Ingress API version (automatically detected if not set)                                                                                                 | ``                              |
| `query.ingress.path`                             | Ingress path                                                                                                                                                  | `/`                             |
| `query.ingress.pathType`                         | Ingress path type                                                                                                                                             | `ImplementationSpecific`        |
| `query.ingress.certManager`                      | Add annotations for cert-manager                                                                                                                              | `false`                         |
| `query.ingress.hostname`                         | Default host for the ingress resource                                                                                                                         | `thanos.local`                  |
| `query.ingress.annotations`                      | Ingress annotations                                                                                                                                           | `[]`                            |
| `query.ingress.tls`                              | Create ingress TLS section                                                                                                                                    | `false`                         |
| `query.ingress.extraHosts[0].name`               | Additional hostnames to be covered                                                                                                                            | `nil`                           |
| `query.ingress.extraHosts[0].path`               | Additional hostnames to be covered                                                                                                                            | `nil`                           |
| `query.ingress.extraTls[0].hosts[0]`             | TLS configuration for additional hostnames to be covered                                                                                                      | `nil`                           |
| `query.ingress.extraTls[0].secretName`           | TLS configuration for additional hostnames to be covered                                                                                                      | `nil`                           |
| `query.ingress.secrets[0].name`                  | TLS Secret Name                                                                                                                                               | `nil`                           |
| `query.ingress.secrets[0].certificate`           | TLS Secret Certificate                                                                                                                                        | `nil`                           |
| `query.ingress.secrets[0].key`                   | TLS Secret Key                                                                                                                                                | `nil`                           |
| `query.ingress.grpc.enabled`                     | Enable ingress controller resource (GRPC)                                                                                                                     | `false`                         |
| `query.ingress.grpc.certManager`                 | Add annotations for cert-manager (GRPC)                                                                                                                       | `false`                         |
| `query.ingress.grpc.hostname`                    | Default host for the ingress resource (GRPC)                                                                                                                  | `thanos.local`                  |
| `query.ingress.grpc.annotations`                 | Ingress annotations (GRPC)                                                                                                                                    | `[]`                            |
| `query.ingress.grpc.extraHosts[0].name`          | Additional hostnames to be covered (GRPC)                                                                                                                     | `nil`                           |
| `query.ingress.grpc.extraHosts[0].path`          | Additional hostnames to be covered (GRPC)                                                                                                                     | `nil`                           |
| `query.ingress.grpc.extraTls[0].hosts[0]`        | TLS configuration for additional hostnames to be covered (GRPC)                                                                                               | `nil`                           |
| `query.ingress.grpc.extraTls[0].secretName`      | TLS configuration for additional hostnames to be covered (GRPC)                                                                                               | `nil`                           |
| `query.ingress.grpc.secrets[0].name`             | TLS Secret Name (GRPC)                                                                                                                                        | `nil`                           |
| `query.ingress.grpc.secrets[0].certificate`      | TLS Secret Certificate (GRPC)                                                                                                                                 | `nil`                           |
| `query.ingress.grpc.secrets[0].key`              | TLS Secret Key (GRPC)                                                                                                                                         | `nil`                           |

### Thanos Query Frontend parameters

| Parameter                                        | Description                                                                                                                   | Default                        |
| ------------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------- | ------------------------------ |
| `queryFrontend.enabled`                          | Enable/disable Thanos Query Frontend component                                                                                | `true`                         |
| `queryFrontend.logLevel`                         | Thanos Query Frontend log level                                                                                               | `info`                         |
| `queryFrontend.logFormat`                        | Thanos Query Frontend log format                                                                                              | `logfmt`                       |
| `queryFrontend.extraFlags`                       | Extra Flags to passed to Thanos Query Frontend                                                                                | `[]`                           |
| `queryFrontend.config`                           | Thanos Query Frontend cache configuration                                                                                     | `nil`                          |
| `queryFrontend.hostAliases`                      | Add deployment host aliases                                                                                                   | `[]`                           |
| `queryFrontend.existingConfigmap`                | Name of existing ConfigMap with Thanos Query Frontend cache configuration                                                     | `nil`                          |
| `queryFrontend.replicaCount`                     | Number of Thanos Query Frontend replicas to deploy                                                                            | `1`                            |
| `queryFrontend.strategyType`                     | Deployment Strategy Type                                                                                                      | `RollingUpdate`                |
| `queryFrontend.podAntiAffinityPreset`            | Thanos Query Frontend pod anti-affinity preset. Ignored if `queryFrontend.affinity` is set. Allowed values: `soft` or `hard`  | `soft`                         |
| `queryFrontend.nodeAffinityPreset.type`          | Thanos Query Frontend node affinity preset type. Ignored if `queryFrontend.affinity` is set. Allowed values: `soft` or `hard` | `""`                           |
| `queryFrontend.nodeAffinityPreset.key`           | Thanos Query Frontend node label key to match Ignored if `queryFrontend.affinity` is set.                                     | `""`                           |
| `queryFrontend.nodeAffinityPreset.values`        | Thanos Query Frontend node label values to match. Ignored if `queryFrontend.affinity` is set.                                 | `[]`                           |
| `queryFrontend.affinity`                         | Thanos Query Frontend affinity for pod assignment                                                                             | `{}` (evaluated as a template) |
| `queryFrontend.nodeSelector`                     | Thanos Query Frontend node labels for pod assignment                                                                          | `{}` (evaluated as a template) |
| `queryFrontend.tolerations`                      | Thanos Query Frontend tolerations for pod assignment                                                                          | `[]` (evaluated as a template) |
| `queryFrontend.podLabels`                        | Thanos Query Frontend pod labels                                                                                              | `{}` (evaluated as a template) |
| `queryFrontend.priorityClassName`                | Controller priorityClassName                                                                                                  | `nil`                          |
| `queryFrontend.securityContext.enabled`          | Enable security context for Thanos Query Frontend pods                                                                        | `true`                         |
| `queryFrontend.securityContext.fsGroup`          | Group ID for the Thanos Query Frontend filesystem                                                                             | `1001`                         |
| `queryFrontend.securityContext.runAsUser`        | User ID for the Thanos queryFrontend container                                                                                | `1001`                         |
| `queryFrontend.resources.limits`                 | The resources limits for the Thanos Query Frontend container                                                                  | `{}`                           |
| `queryFrontend.resources.requests`               | The requested resources for the Thanos Query Frontend container                                                               | `{}`                           |
| `queryFrontend.podAnnotations`                   | Annotations for Thanos Query Frontend pods                                                                                    | `{}`                           |
| `queryFrontend.livenessProbe`                    | Liveness probe configuration for Thanos Query Frontend                                                                        | `Check values.yaml file`       |
| `queryFrontend.readinessProbe`                   | Readiness probe configuration for Thanos Query Frontend                                                                       | `Check values.yaml file`       |
| `queryFrontend.service.type`                     | Kubernetes service type                                                                                                       | `ClusterIP`                    |
| `queryFrontend.service.clusterIP`                | Thanos Query Frontend  service clusterIP IP                                                                                   | `None`                         |
| `queryFrontend.service.http.port`                | Service HTTP port                                                                                                             | `9090`                         |
| `queryFrontend.service.http.nodePort`            | Service HTTP node port                                                                                                        | `nil`                          |
| `queryFrontend.service.loadBalancerIP`           | loadBalancerIP if service type is `LoadBalancer`                                                                              | `nil`                          |
| `queryFrontend.service.loadBalancerSourceRanges` | Address that are allowed when service is LoadBalancer                                                                         | `[]`                           |
| `queryFrontend.service.annotations`              | Annotations for Thanos Query Frontend service                                                                                 | `{}`                           |
| `queryFrontend.service.labelSelectorsOverride`   | Selector for Thanos query service                                                                                             | `{}`                           |
| `queryFrontend.serviceAccount.annotations`       | Annotations for Thanos Query Frontend Service Account                                                                         | `{}`                           |
| `queryFrontend.rbac.create`                      | Create RBAC                                                                                                                   | `false`                        |
| `queryFrontend.pspEnabled`                       | Create PodSecurityPolicy                                                                                                      | `false`                        |
| `queryFrontend.autoscaling.enabled`              | Enable autoscaling for Thanos Query Frontend                                                                                  | `false`                        |
| `queryFrontend.autoscaling.minReplicas`          | Minimum number of Thanos Query Frontend replicas                                                                              | `nil`                          |
| `queryFrontend.autoscaling.maxReplicas`          | Maximum number of Thanos Query Frontend replicas                                                                              | `nil`                          |
| `queryFrontend.autoscaling.targetCPU`            | Target CPU utilization percentage                                                                                             | `nil`                          |
| `queryFrontend.autoscaling.targetMemory`         | Target Memory utilization percentage                                                                                          | `nil`                          |
| `queryFrontend.pdb.create`                       | Enable/disable a Pod Disruption Budget creation                                                                               | `false`                        |
| `queryFrontend.pdb.minAvailable`                 | Minimum number/percentage of pods that should remain scheduled                                                                | `1`                            |
| `queryFrontend.pdb.maxUnavailable`               | Maximum number/percentage of pods that may be made unavailable                                                                | `nil`                          |
| `queryFrontend.ingress.enabled`                  | Enable ingress controller resource                                                                                            | `false`                        |
| `queryFrontend.ingress.apiVersion`               | Force Ingress API version (automatically detected if not set)                                                                 | ``                             |
| `queryFrontend.ingress.path`                     | Ingress path                                                                                                                  | `/`                            |
| `queryFrontend.ingress.pathType`                 | Ingress path type                                                                                                             | `ImplementationSpecific`       |
| `queryFrontend.ingress.certManager`              | Add annotations for cert-manager                                                                                              | `false`                        |
| `queryFrontend.ingress.hostname`                 | Default host for the ingress resource                                                                                         | `thanos.local`                 |
| `queryFrontend.ingress.annotations`              | Ingress annotations                                                                                                           | `[]`                           |
| `queryFrontend.ingress.extraHosts[0].name`       | Additional hostnames to be covered                                                                                            | `nil`                          |
| `queryFrontend.ingress.extraHosts[0].path`       | Additional hostnames to be covered                                                                                            | `nil`                          |
| `queryFrontend.ingress.extraTls[0].hosts[0]`     | TLS configuration for additional hostnames to be covered                                                                      | `nil`                          |
| `queryFrontend.ingress.extraTls[0].secretName`   | TLS configuration for additional hostnames to be covered                                                                      | `nil`                          |
| `queryFrontend.ingress.secrets[0].name`          | TLS Secret Name                                                                                                               | `nil`                          |
| `queryFrontend.ingress.secrets[0].certificate`   | TLS Secret Certificate                                                                                                        | `nil`                          |
| `queryFrontend.ingress.secrets[0].key`           | TLS Secret Key                                                                                                                | `nil`                          |

### Thanos Bucket Web parameters

| Parameter                                         | Description                                                                                                           | Default                        |
| ------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------- | ------------------------------ |
| `bucketweb.enabled`                               | Enable/disable Thanos Bucket Web component                                                                            | `false`                        |
| `bucketweb.logLevel`                              | Thanos Bucket Web log level                                                                                           | `info`                         |
| `bucketweb.logFormat`                             | Thanos Bucket Web log format                                                                                          | `logfmt`                       |
| `bucketweb.refresh`                               | Refresh interval to download metadata from remote storage                                                             | `30m`                          |
| `bucketweb.timeout`                               | Timeout to download metadata from remote storage                                                                      | `5m`                           |
| `bucketweb.extraFlags`                            | Extra Flags to passed to Thanos Bucket Web                                                                            | `[]`                           |
| `bucketweb.hostAliases`                           | Add deployment host aliases                                                                                           | `[]`                           |
| `bucketweb.replicaCount`                          | Number of Thanos Bucket Web replicas to deploy                                                                        | `1`                            |
| `bucketweb.strategyType`                          | Deployment Strategy Type                                                                                              | `RollingUpdate`                |
| `bucketweb.podAntiAffinityPreset`                 | Thanos Bucket Web pod anti-affinity preset. Ignored if `bucketweb.affinity` is set. Allowed values: `soft` or `hard`  | `soft`                         |
| `bucketweb.nodeAffinityPreset.type`               | Thanos Bucket Web node affinity preset type. Ignored if `bucketweb.affinity` is set. Allowed values: `soft` or `hard` | `""`                           |
| `bucketweb.nodeAffinityPreset.key`                | Thanos Bucket Web node label key to match Ignored if `bucketweb.affinity` is set.                                     | `""`                           |
| `bucketweb.nodeAffinityPreset.values`             | Thanos Bucket Web node label values to match. Ignored if `bucketweb.affinity` is set.                                 | `[]`                           |
| `bucketweb.affinity`                              | Thanos Bucket Web affinity for pod assignment                                                                         | `{}` (evaluated as a template) |
| `bucketweb.nodeSelector`                          | Thanos Bucket Web node labels for pod assignment                                                                      | `{}` (evaluated as a template) |
| `bucketweb.tolerations`                           | Thanos Bucket Web tolerations for pod assignment                                                                      | `[]` (evaluated as a template) |
| `bucketweb.podLabels`                             | Thanos Bucket Web pod labels                                                                                          | `{}` (evaluated as a template) |
| `bucketweb.priorityClassName`                     | Controller priorityClassName                                                                                          | `nil`                          |
| `bucketweb.securityContext.enabled`               | Enable security context for Thanos Bucket Web pods                                                                    | `true`                         |
| `bucketweb.securityContext.fsGroup`               | Group ID for the Thanos Bucket Web filesystem                                                                         | `1001`                         |
| `bucketweb.securityContext.runAsUser`             | User ID for the Thanos Bucket Web container                                                                           | `1001`                         |
| `bucketweb.resources.limits`                      | The resources limits for the Thanos Bucket Web container                                                              | `{}`                           |
| `bucketweb.resources.requests`                    | The requested resources for the Thanos Bucket Web container                                                           | `{}`                           |
| `bucketweb.podAnnotations`                        | Annotations for Thanos Bucket Web pods                                                                                | `{}`                           |
| `bucketweb.livenessProbe`                         | Liveness probe configuration for Thanos Compactor                                                                     | `Check values.yaml file`       |
| `bucketweb.readinessProbe`                        | Readiness probe configuration for Thanos Compactor                                                                    | `Check values.yaml file`       |
| `bucketweb.service.type`                          | Kubernetes service type                                                                                               | `ClusterIP`                    |
| `bucketweb.service.clusterIP`                     | Thanos Bucket Web service clusterIP IP                                                                                | `None`                         |
| `bucketweb.service.http.port`                     | Service HTTP port                                                                                                     | `8080`                         |
| `bucketweb.service.http.nodePort`                 | Service HTTP node port                                                                                                | `nil`                          |
| `bucketweb.service.loadBalancerIP`                | loadBalancerIP if service type is `LoadBalancer`                                                                      | `nil`                          |
| `bucketweb.service.loadBalancerSourceRanges`      | Address that are allowed when service is LoadBalancer                                                                 | `[]`                           |
| `bucketweb.service.annotations`                   | Annotations for Thanos Bucket Web service                                                                             | `{}`                           |
| `bucketweb.service.labelSelectorsOverride`        | Selector for Thanos query service                                                                                     | `{}`                           |
| `bucketweb.serviceAccount.annotations`            | Annotations for Thanos Bucket Web Service Account                                                                     | `{}`                           |
| `bucketweb.serviceAccount.existingServiceAccount` | Name for an existing Thanos Bucket Web Service Account                                                                | `nil`                          |
| `bucketweb.pdb.create`                            | Enable/disable a Pod Disruption Budget creation                                                                       | `false`                        |
| `bucketweb.pdb.minAvailable`                      | Minimum number/percentage of pods that should remain scheduled                                                        | `1`                            |
| `bucketweb.pdb.maxUnavailable`                    | Maximum number/percentage of pods that may be made unavailable                                                        | `nil`                          |
| `bucketweb.ingress.enabled`                       | Enable ingress controller resource                                                                                    | `false`                        |
| `bucketweb.ingress.apiVersion`                    | Force Ingress API version (automatically detected if not set)                                                         | ``                             |
| `bucketweb.ingress.path`                          | Ingress path                                                                                                          | `/`                            |
| `bucketweb.ingress.pathType`                      | Ingress path type                                                                                                     | `ImplementationSpecific`       |
| `bucketweb.ingress.certManager`                   | Add annotations for cert-manager                                                                                      | `false`                        |
| `bucketweb.ingress.hostname`                      | Default host for the ingress resource                                                                                 | `thanos-bucketweb.local`       |
| `bucketweb.ingress.annotations`                   | Ingress annotations                                                                                                   | `[]`                           |
| `bucketweb.ingress.tls`                           | Create ingress TLS section                                                                                            | `false`                        |
| `bucketweb.ingress.extraHosts[0].name`            | Additional hostnames to be covered                                                                                    | `nil`                          |
| `bucketweb.ingress.extraHosts[0].path`            | Additional hostnames to be covered                                                                                    | `nil`                          |
| `bucketweb.ingress.extraTls[0].hosts[0]`          | TLS configuration for additional hostnames to be covered                                                              | `nil`                          |
| `bucketweb.ingress.extraTls[0].secretName`        | TLS configuration for additional hostnames to be covered                                                              | `nil`                          |
| `bucketweb.ingress.secrets[0].name`               | TLS Secret Name                                                                                                       | `nil`                          |
| `bucketweb.ingress.secrets[0].certificate`        | TLS Secret Certificate                                                                                                | `nil`                          |
| `bucketweb.ingress.secrets[0].key`                | TLS Secret Key                                                                                                        | `nil`                          |

### Thanos Compactor parameters

| Parameter                                         | Description                                                                                                          | Default                        |
| ------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------- | ------------------------------ |
| `compactor.enabled`                               | Enable/disable Thanos Compactor component                                                                            | `false`                        |
| `compactor.logLevel`                              | Thanos Compactor log level                                                                                           | `info`                         |
| `compactor.logFormat`                             | Thanos Compactor log format                                                                                          | `logfmt`                       |
| `compactor.retentionResolutionRaw`                | Resolution and Retention flag                                                                                        | `30d`                          |
| `compactor.retentionResolution5m`                 | Resolution and Retention flag                                                                                        | `30d`                          |
| `compactor.retentionResolution1h`                 | Resolution and Retention flag                                                                                        | `10y`                          |
| `compactor.consistencyDelay`                      | Minimum age of fresh blocks before they are being processed                                                          | `30m`                          |
| `compactor.extraFlags`                            | Extra Flags to passed to Thanos Compactor                                                                            | `[]`                           |
| `compactor.hostAliases`                           | Add deployment host aliases                                                                                          | `[]`                           |
| `compactor.strategyType`                          | Deployment Strategy Type                                                                                             | `RollingUpdate`                |
| `compactor.podAntiAffinityPreset`                 | Thanos Compactor pod anti-affinity preset. Ignored if `compactor.affinity` is set. Allowed values: `soft` or `hard`  | `soft`                         |
| `compactor.nodeAffinityPreset.type`               | Thanos Compactor node affinity preset type. Ignored if `compactor.affinity` is set. Allowed values: `soft` or `hard` | `""`                           |
| `compactor.nodeAffinityPreset.key`                | Thanos Compactor node label key to match Ignored if `compactor.affinity` is set.                                     | `""`                           |
| `compactor.nodeAffinityPreset.values`             | Thanos Compactor node label values to match. Ignored if `compactor.affinity` is set.                                 | `[]`                           |
| `compactor.affinity`                              | Thanos Compactor affinity for pod assignment                                                                         | `{}` (evaluated as a template) |
| `compactor.nodeSelector`                          | Thanos Compactor node labels for pod assignment                                                                      | `{}` (evaluated as a template) |
| `compactor.tolerations`                           | Thanos Compactor tolerations for pod assignment                                                                      | `[]` (evaluated as a template) |
| `compactor.podLabels`                             | Thanos Compactor pod labels                                                                                          | `{}` (evaluated as a template) |
| `compactor.priorityClassName`                     | Controller priorityClassName                                                                                         | `nil`                          |
| `compactor.securityContext.enabled`               | Enable security context for Thanos Compactor pods                                                                    | `true`                         |
| `compactor.securityContext.fsGroup`               | Group ID for the Thanos Compactor filesystem                                                                         | `1001`                         |
| `compactor.securityContext.runAsUser`             | User ID for the Thanos Compactor container                                                                           | `1001`                         |
| `compactor.resources.limits`                      | The resources limits for the Thanos Compactor container                                                              | `{}`                           |
| `compactor.resources.requests`                    | The requested resources for the Thanos Compactor container                                                           | `{}`                           |
| `compactor.podAnnotations`                        | Annotations for Thanos Compactor pods                                                                                | `{}`                           |
| `compactor.livenessProbe`                         | Liveness probe configuration for Thanos Compactor                                                                    | `Check values.yaml file`       |
| `compactor.readinessProbe`                        | Readiness probe configuration for Thanos Compactor                                                                   | `Check values.yaml file`       |
| `compactor.service.type`                          | Kubernetes service type                                                                                              | `ClusterIP`                    |
| `compactor.service.clusterIP`                     | Thanos Compactor service clusterIP IP                                                                                | `None`                         |
| `compactor.service.http.port`                     | Service HTTP port                                                                                                    | `9090`                         |
| `compactor.service.http.nodePort`                 | Service HTTP node port                                                                                               | `nil`                          |
| `compactor.service.loadBalancerIP`                | loadBalancerIP if service type is `LoadBalancer`                                                                     | `nil`                          |
| `compactor.service.loadBalancerSourceRanges`      | Address that are allowed when service is LoadBalancer                                                                | `[]`                           |
| `compactor.service.annotations`                   | Annotations for Thanos Compactor service                                                                             | `{}`                           |
| `compactor.service.labelSelectorsOverride`        | Selector for Thanos query service                                                                                    | `{}`                           |
| `compactor.serviceAccount.annotations`            | Annotations for Thanos Compactor Service Account                                                                     | `{}`                           |
| `compactor.serviceAccount.existingServiceAccount` | Name for an existing Thanos Compactor Service Account                                                                | `nil`                          |
| `compactor.persistence.enabled`                   | Enable data persistence                                                                                              | `true`                         |
| `compactor.persistence.existingClaim`             | Use a existing PVC which must be created manually before bound                                                       | `nil`                          |
| `compactor.persistence.storageClass`              | Specify the `storageClass` used to provision the volume                                                              | `nil`                          |
| `compactor.persistence.accessModes`               | Access modes of data volume                                                                                          | `["ReadWriteOnce"]`            |
| `compactor.persistence.size`                      | Size of data volume                                                                                                  | `8Gi`                          |

### Thanos Store Gateway parameters

| Parameter                                            | Description                                                                                                                                                   | Default                        |
| ---------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------ |
| `storegateway.enabled`                               | Enable/disable Thanos Store Gateway component                                                                                                                 | `false`                        |
| `storegateway.logLevel`                              | Thanos Store Gateway log level                                                                                                                                | `info`                         |
| `storegateway.logFormat`                             | Thanos Store Gateway log format                                                                                                                               | `logfmt`                       |
| `storegateway.extraFlags`                            | Extra Flags to passed to Thanos Store Gateway                                                                                                                 | `[]`                           |
| `storegateway.grpc.tls.enabled`                      | Enable TLS for GRPC server                                                                                                                                    | `false`                        |
| `storegateway.grpc.tls.cert`                         | TLS Certificate for gRPC server - ignored if existingSecret is provided                                                                                       | `nil`                          |
| `storegateway.grpc.tls.key`                          | TLS Key for gRPC server - ignored if existingSecret is provided                                                                                               | `nil`                          |
| `storegateway.grpc.tls.ca`                           | TLS client CA for gRPC server used for client verification purposes on the server - ignored if existingSecret is provided                                     | `nil`                          |
| `storegateway.grpc.tls.existingSecret.name`          | Existing secret name containing your own TLS certificates for server                                                                                          | `nil`                          |
| `storegateway.grpc.tls.existingSecret.keyMapping`    | Key mapping between the expected keys and the existing secret's keys. [See more](https://github.com/bitnami/charts/tree/master/bitnami/common#existingsecret) | `nil`                          |
| `storegateway.hostAliases`                           | Add deployment host aliases                                                                                                                                   | `[]`                           |
| `storegateway.config`                                | Thanos Store Gateway cache configuration                                                                                                                      | `nil`                          |
| `storegateway.existingConfigmap`                     | Name of existing ConfigMap with Thanos Store Gateway cache configuration                                                                                      | `nil`                          |
| `storegateway.updateStrategyType`                    | Statefulset Update Strategy Type                                                                                                                              | `RollingUpdate`                |
| `storegateway.podManagementPolicy`                   | Statefulset Pod Management Policy Type                                                                                                                        | `OrderedReady`                 |
| `storegateway.replicaCount`                          | Number of Thanos Store Gateway replicas to deploy                                                                                                             | `1`                            |
| `storegateway.podAntiAffinityPreset`                 | Thanos Store Gateway pod anti-affinity preset. Ignored if `storegateway.affinity` is set. Allowed values: `soft` or `hard`                                    | `soft`                         |
| `storegateway.nodeAffinityPreset.type`               | Thanos Store Gateway node affinity preset type. Ignored if `storegateway.affinity` is set. Allowed values: `soft` or `hard`                                   | `""`                           |
| `storegateway.nodeAffinityPreset.key`                | Thanos Store Gateway node label key to match Ignored if `storegateway.affinity` is set.                                                                       | `""`                           |
| `storegateway.nodeAffinityPreset.values`             | Thanos Store Gateway node label values to match. Ignored if `storegateway.affinity` is set.                                                                   | `[]`                           |
| `storegateway.affinity`                              | Thanos Store Gateway affinity for pod assignment                                                                                                              | `{}` (evaluated as a template) |
| `storegateway.nodeSelector`                          | Thanos Store Gateway node labels for pod assignment                                                                                                           | `{}` (evaluated as a template) |
| `storegateway.tolerations`                           | Thanos Store Gateway tolerations for pod assignment                                                                                                           | `[]` (evaluated as a template) |
| `storegateway.podLabels`                             | Thanos Store Gateway pod labels                                                                                                                               | `{}` (evaluated as a template) |
| `storegateway.priorityClassName`                     | Controller priorityClassName                                                                                                                                  | `nil`                          |
| `storegateway.securityContext.enabled`               | Enable security context for Thanos Store Gateway pods                                                                                                         | `true`                         |
| `storegateway.securityContext.fsGroup`               | Group ID for the Thanos Store Gateway filesystem                                                                                                              | `1001`                         |
| `storegateway.securityContext.runAsUser`             | User ID for the Thanos Store Gateway container                                                                                                                | `1001`                         |
| `storegateway.resources.limits`                      | The resources limits for the Thanos Store Gateway container                                                                                                   | `{}`                           |
| `storegateway.resources.requests`                    | The requested resources for the Thanos Store Gateway container                                                                                                | `{}`                           |
| `storegateway.podAnnotations`                        | Annotations for Thanos Store Gateway pods                                                                                                                     | `{}`                           |
| `storegateway.livenessProbe`                         | Liveness probe configuration for Thanos Store Gateway                                                                                                         | `Check values.yaml file`       |
| `storegateway.readinessProbe`                        | Readiness probe configuration for Thanos Store Gateway                                                                                                        | `Check values.yaml file`       |
| `storegateway.service.type`                          | Kubernetes service type                                                                                                                                       | `ClusterIP`                    |
| `storegateway.service.clusterIP`                     | Thanos Store Gateway service clusterIP IP                                                                                                                     | `None`                         |
| `storegateway.service.http.port`                     | Service HTTP port                                                                                                                                             | `9090`                         |
| `storegateway.service.http.nodePort`                 | Service HTTP node port                                                                                                                                        | `nil`                          |
| `storegateway.service.grpc.port`                     | Service GRPC port                                                                                                                                             | `10901`                        |
| `storegateway.service.grpc.nodePort`                 | Service GRPC node port                                                                                                                                        | `nil`                          |
| `storegateway.service.loadBalancerIP`                | loadBalancerIP if service type is `LoadBalancer`                                                                                                              | `nil`                          |
| `storegateway.service.loadBalancerSourceRanges`      | Address that are allowed when service is LoadBalancer                                                                                                         | `[]`                           |
| `storegateway.service.annotations`                   | Annotations for Thanos Store Gateway service                                                                                                                  | `{}`                           |
| `storegateway.service.labelSelectorsOverride`        | Selector for Thanos query service                                                                                                                             | `{}`                           |
| `storegateway.service.additionalHeadless`            | Additional Headless service                                                                                                                                   | `false`                        |
| `storegateway.serviceAccount.annotations`            | Annotations for Thanos Store Gateway Service Account                                                                                                          | `{}`                           |
| `storegateway.serviceAccount.existingServiceAccount` | Name for an existing Thanos Store Gateway Service Account                                                                                                     | `nil`                          |
| `storegateway.persistence.enabled`                   | Enable data persistence                                                                                                                                       | `true`                         |
| `storegateway.persistence.existingClaim`             | Use a existing PVC which must be created manually before bound                                                                                                | `nil`                          |
| `storegateway.persistence.storageClass`              | Specify the `storageClass` used to provision the volume                                                                                                       | `nil`                          |
| `storegateway.persistence.accessModes`               | Access modes of data volume                                                                                                                                   | `["ReadWriteOnce"]`            |
| `storegateway.persistence.size`                      | Size of data volume                                                                                                                                           | `8Gi`                          |
| `storegateway.autoscaling.enabled`                   | Enable autoscaling for Thanos Store Gateway                                                                                                                   | `false`                        |
| `storegateway.autoscaling.minReplicas`               | Minimum number of Thanos Store Gateway replicas                                                                                                               | `nil`                          |
| `storegategay.autoscaling.maxReplicas`               | Maximum number of Thanos Store Gateway replicas                                                                                                               | `nil`                          |
| `storegateway.autoscaling.targetCPU`                 | Target CPU utilization percentage                                                                                                                             | `nil`                          |
| `storegateway.autoscaling.targetMemory`              | Target Memory utilization percentage                                                                                                                          | `nil`                          |
| `storegateway.pdb.create`                            | Enable/disable a Pod Disruption Budget creation                                                                                                               | `false`                        |
| `storegateway.pdb.minAvailable`                      | Minimum number/percentage of pods that should remain scheduled                                                                                                | `1`                            |
| `storegateway.pdb.maxUnavailable`                    | Maximum number/percentage of pods that may be made unavailable                                                                                                | `nil`                          |

### Thanos Ruler parameters

| Parameter                                     | Description                                                                                                  | Default                        |
| --------------------------------------------- | ------------------------------------------------------------------------------------------------------------ | ------------------------------ |
| `ruler.enabled`                               | Enable/disable Thanos Ruler component                                                                        | `false`                        |
| `ruler.logLevel`                              | Thanos Ruler log level                                                                                       | `info`                         |
| `ruler.logFormat`                             | Thanos Ruler log format                                                                                      | `logfmt`                       |
| `ruler.replicaLabel`                          | Label to treat as a replica indicator along which data is deduplicated                                       | `replica`                      |
| `ruler.dnsDiscovery.enabled`                  | Enable Query APIs discovery via DNS                                                                          | `true`                         |
| `ruler.alertmanagers`                         | Alermanager URLs array                                                                                       | `[]`                           |
| `ruler.hostAliases`                           | Add deployment host aliases                                                                                  | `[]`                           |
| `ruler.evalInterval`                          | The default evaluation interval to use                                                                       | `1m`                           |
| `ruler.clusterName`                           | Used to set the 'ruler_cluster' label                                                                        | `nil`                          |
| `ruler.extraFlags`                            | Extra Flags to passed to Thanos Ruler                                                                        | `[]`                           |
| `ruler.config`                                | Ruler configuration                                                                                          | `nil`                          |
| `ruler.existingConfigmap`                     | Name of existing ConfigMap with Ruler configuration                                                          | `nil`                          |
| `ruler.updateStrategyType`                    | Statefulset Update Strategy Type                                                                             | `RollingUpdate`                |
| `ruler.podManagementPolicy`                   | Statefulset Pod Management Policy Type                                                                       | `OrderedReady`                 |
| `ruler.replicaCount`                          | Number of Thanos Ruler replicas to deploy                                                                    | `1`                            |
| `ruler.podAntiAffinityPreset`                 | Thanos Ruler pod anti-affinity preset. Ignored if `ruler.affinity` is set. Allowed values: `soft` or `hard`  | `soft`                         |
| `ruler.nodeAffinityPreset.type`               | Thanos Ruler node affinity preset type. Ignored if `ruler.affinity` is set. Allowed values: `soft` or `hard` | `""`                           |
| `ruler.nodeAffinityPreset.key`                | Thanos Ruler node label key to match Ignored if `ruler.affinity` is set.                                     | `""`                           |
| `ruler.nodeAffinityPreset.values`             | Thanos Ruler node label values to match. Ignored if `ruler.affinity` is set.                                 | `[]`                           |
| `ruler.affinity`                              | Thanos Ruler affinity for pod assignment                                                                     | `{}` (evaluated as a template) |
| `ruler.nodeSelector`                          | Thanos Ruler node labels for pod assignment                                                                  | `{}` (evaluated as a template) |
| `ruler.tolerations`                           | Thanos Ruler tolerations for pod assignment                                                                  | `[]` (evaluated as a template) |
| `ruler.podLabels`                             | Thanos Ruler pod labels                                                                                      | `{}` (evaluated as a template) |
| `ruler.priorityClassName`                     | Controller priorityClassName                                                                                 | `nil`                          |
| `ruler.securityContext.enabled`               | Enable security context for Thanos Ruler pods                                                                | `true`                         |
| `ruler.securityContext.fsGroup`               | Group ID for the Thanos Ruler filesystem                                                                     | `1001`                         |
| `ruler.securityContext.runAsUser`             | User ID for the Thanos Ruler container                                                                       | `1001`                         |
| `ruler.resources.limits`                      | The resources limits for the Thanos Ruler container                                                          | `{}`                           |
| `ruler.resources.requests`                    | The requested resources for the Thanos Ruler container                                                       | `{}`                           |
| `ruler.podAnnotations`                        | Annotations for Thanos Ruler pods                                                                            | `{}`                           |
| `ruler.livenessProbe`                         | Liveness probe configuration for Thanos Ruler                                                                | `Check values.yaml file`       |
| `ruler.readinessProbe`                        | Readiness probe configuration for Thanos Ruler                                                               | `Check values.yaml file`       |
| `ruler.service.type`                          | Kubernetes service type                                                                                      | `ClusterIP`                    |
| `ruler.service.clusterIP`                     | Thanos Ruler service clusterIP IP                                                                            | `None`                         |
| `ruler.service.http.port`                     | Service HTTP port                                                                                            | `9090`                         |
| `ruler.service.http.nodePort`                 | Service HTTP node port                                                                                       | `nil`                          |
| `ruler.service.grpc.port`                     | Service GRPC port                                                                                            | `10901`                        |
| `ruler.service.grpc.nodePort`                 | Service GRPC node port                                                                                       | `nil`                          |
| `ruler.service.loadBalancerIP`                | loadBalancerIP if service type is `LoadBalancer`                                                             | `nil`                          |
| `ruler.service.loadBalancerSourceRanges`      | Address that are allowed when service is LoadBalancer                                                        | `[]`                           |
| `ruler.service.annotations`                   | Annotations for Thanos Ruler service                                                                         | `{}`                           |
| `ruler.service.labelSelectorsOverride`        | Selector for Thanos query service                                                                            | `{}`                           |
| `ruler.service.additionalHeadless`            | Additional Headless service                                                                                  | `false`                        |
| `ruler.serviceAccount.annotations`            | Annotations for Thanos Ruler Service Account                                                                 | `{}`                           |
| `ruler.serviceAccount.existingServiceAccount` | Name for an existing Thanos Ruler Service Account                                                            | `nil`                          |
| `ruler.persistence.enabled`                   | Enable data persistence                                                                                      | `true`                         |
| `ruler.persistence.existingClaim`             | Use a existing PVC which must be created manually before bound                                               | `nil`                          |
| `ruler.persistence.storageClass`              | Specify the `storageClass` used to provision the volume                                                      | `nil`                          |
| `ruler.persistence.accessModes`               | Access modes of data volume                                                                                  | `["ReadWriteOnce"]`            |
| `ruler.persistence.size`                      | Size of data volume                                                                                          | `8Gi`                          |
| `ruler.pdb.create`                            | Enable/disable a Pod Disruption Budget creation                                                              | `false`                        |
| `ruler.pdb.minAvailable`                      | Minimum number/percentage of pods that should remain scheduled                                               | `1`                            |
| `ruler.pdb.maxUnavailable`                    | Maximum number/percentage of pods that may be made unavailable                                               | `nil`                          |
| `ruler.ingress.enabled`                       | Enable ingress controller resource                                                                           | `false`                        |
| `ruler.ingress.apiVersion`                    | Force Ingress API version (automatically detected if not set)                                                | ``                             |
| `ruler.ingress.path`                          | Ingress path                                                                                                 | `/`                            |
| `ruler.ingress.pathType`                      | Ingress path type                                                                                            | `ImplementationSpecific`       |
| `ruler.ingress.certManager`                   | Add annotations for cert-manager                                                                             | `false`                        |
| `ruler.ingress.hostname`                      | Default host for the ingress resource                                                                        | `thanos-bucketweb.local`       |
| `ruler.ingress.annotations`                   | Ingress annotations                                                                                          | `[]`                           |
| `ruler.ingress.tls`                           | Create ingress TLS section                                                                                   | `false`                        |
| `ruler.ingress.extraHosts[0].name`            | Additional hostnames to be covered                                                                           | `nil`                          |
| `ruler.ingress.extraHosts[0].path`            | Additional hostnames to be covered                                                                           | `nil`                          |
| `ruler.ingress.extraTls[0].hosts[0]`          | TLS configuration for additional hostnames to be covered                                                     | `nil`                          |
| `ruler.ingress.extraTls[0].secretName`        | TLS configuration for additional hostnames to be covered                                                     | `nil`                          |
| `ruler.ingress.secrets[0].name`               | TLS Secret Name                                                                                              | `nil`                          |
| `ruler.ingress.secrets[0].certificate`        | TLS Secret Certificate                                                                                       | `nil`                          |
| `ruler.ingress.secrets[0].key`                | TLS Secret Key                                                                                               | `nil`                          |

### Thanos Receive parameters

| Parameter                                       | Description                                                                                                    | Default                                 |
| ----------------------------------------------- | -------------------------------------------------------------------------------------------------------------- | --------------------------------------- |
| `receive.enabled`                               | Enable/disable Thanos Receive component                                                                        | `false`                                 |
| `receive.logLevel`                              | Thanos Receive log level                                                                                       | `info`                                  |
| `receive.logFormat`                             | Thanos Receive log format                                                                                      | `logfmt`                                |
| `receive.logFormat`                             | Thanos Receive TSDB retention period                                                                           | `tsdbRetention`                         |
| `receive.replicationFactor`                     | Thanos Receive replication-factor                                                                              | `1`                                     |
| `receive.replicaLabel`                          | Label to treat as a replica indicator along which data is deduplicated                                         | `replica`                               |
| `receive.alertmanagers`                         | Alermanager URLs array                                                                                         | `[]`                                    |
| `receive.extraFlags`                            | Extra Flags to passed to Thanos Receive                                                                        | `[]`                                    |
| `receive.hostAliases`                           | Add deployment host aliases                                                                                    | `[]`                                    |
| `receive.config`                                | Receive Hashring configuration                                                                                 | `[{"endpoints": [ "127.0.0.1:10901"]}]` |
| `receive.updateStrategyType`                    | Statefulset Update Strategy Type                                                                               | `RollingUpdate`                         |
| `receive.podManagementPolicy`                   | Statefulset Pod Management Policy Type                                                                         | `OrderedReady`                          |
| `receive.replicaCount`                          | Number of Thanos Receive replicas to deploy                                                                    | `1`                                     |
| `receive.podAntiAffinityPreset`                 | Thanos Receive pod anti-affinity preset. Ignored if `ruler.affinity` is set. Allowed values: `soft` or `hard`  | `soft`                                  |
| `receive.nodeAffinityPreset.type`               | Thanos Receive node affinity preset type. Ignored if `ruler.affinity` is set. Allowed values: `soft` or `hard` | `""`                                    |
| `receive.nodeAffinityPreset.key`                | Thanos Receive node label key to match Ignored if `ruler.affinity` is set.                                     | `""`                                    |
| `receive.nodeAffinityPreset.values`             | Thanos Receive node label values to match. Ignored if `ruler.affinity` is set.                                 | `[]`                                    |
| `receive.affinity`                              | Thanos Receive affinity for pod assignment                                                                     | `{}` (evaluated as a template)          |
| `receive.nodeSelector`                          | Thanos Receive node labels for pod assignment                                                                  | `{}` (evaluated as a template)          |
| `receive.tolerations`                           | Thanos Receive tolerations for pod assignment                                                                  | `[]` (evaluated as a template)          |
| `receive.podLabels`                             | Thanos Receive pod labels                                                                                      | `{}` (evaluated as a template)          |
| `receive.priorityClassName`                     | Controller priorityClassName                                                                                   | `nil`                                   |
| `receive.securityContext.enabled`               | Enable security context for Thanos Receive pods                                                                | `true`                                  |
| `receive.securityContext.fsGroup`               | Group ID for the Thanos Receive filesystem                                                                     | `1001`                                  |
| `receive.securityContext.runAsUser`             | User ID for the Thanos Receive container                                                                       | `1001`                                  |
| `receive.resources.limits`                      | The resources limits for the Thanos Receive container                                                          | `{}`                                    |
| `receive.resources.requests`                    | The requested resources for the Thanos Receive container                                                       | `{}`                                    |
| `receive.podAnnotations`                        | Annotations for Thanos Ruler pods                                                                              | `{}`                                    |
| `receive.livenessProbe`                         | Liveness probe configuration for Thanos Receive                                                                | `Check values.yaml file`                |
| `receive.readinessProbe`                        | Readiness probe configuration for Thanos Ruler                                                                 | `Check values.yaml file`                |
| `receive.service.type`                          | Kubernetes service type                                                                                        | `ClusterIP`                             |
| `receive.service.clusterIP`                     | Thanos Ruler service clusterIP IP                                                                              | `None`                                  |
| `receive.service.http.port`                     | Service HTTP port                                                                                              | `9090`                                  |
| `receive.service.http.nodePort`                 | Service HTTP node port                                                                                         | `nil`                                   |
| `receive.service.grpc.port`                     | Service GRPC port                                                                                              | `10901`                                 |
| `receive.service.grpc.nodePort`                 | Service GRPC node port                                                                                         | `nil`                                   |
| `receive.service.remoteWrite.port`              | Service remote write port                                                                                      | `19291`                                 |
| `receive.service.remoteWrite.nodePort`          | Service remote write node port                                                                                 | `nil`                                   |
| `receive.service.loadBalancerIP`                | loadBalancerIP if service type is `LoadBalancer`                                                               | `nil`                                   |
| `receive.service.loadBalancerSourceRanges`      | Address that are allowed when service is LoadBalancer                                                          | `[]`                                    |
| `receive.service.annotations`                   | Annotations for Thanos Receive service                                                                         | `{}`                                    |
| `receive.service.labelSelectorsOverride`        | Selector for Thanos receive service                                                                            | `{}`                                    |
| `receive.service.additionalHeadless`            | Additional Headless service                                                                                    | `false`                                 |
| `receive.serviceAccount.annotations`            | Annotations for Thanos Receive Service Account                                                                 | `{}`                                    |
| `receive.serviceAccount.existingServiceAccount` | Name for an existing Thanos Receive Service Account                                                            | `nil`                                   |
| `receive.persistence.enabled`                   | Enable data persistence                                                                                        | `true`                                  |
| `receive.persistence.existingClaim`             | Use a existing PVC which must be created manually before bound                                                 | `nil`                                   |
| `receive.persistence.storageClass`              | Specify the `storageClass` used to provision the volume                                                        | `nil`                                   |
| `receive.persistence.accessModes`               | Access modes of data volume                                                                                    | `["ReadWriteOnce"]`                     |
| `receive.persistence.size`                      | Size of data volume                                                                                            | `8Gi`                                   |
| `receive.pdb.create`                            | Enable/disable a Pod Disruption Budget creation                                                                | `false`                                 |
| `receive.pdb.minAvailable`                      | Minimum number/percentage of pods that should remain scheduled                                                 | `1`                                     |
| `receive.pdb.maxUnavailable`                    | Maximum number/percentage of pods that may be made unavailable                                                 | `nil`                                   |

### Metrics parameters

| Parameter                              | Description                                                                                            | Default                                   |
| -------------------------------------- | ------------------------------------------------------------------------------------------------------ | ----------------------------------------- |
| `metrics.enabled`                      | Enable the export of Prometheus metrics                                                                | `false`                                   |
| `metrics.serviceMonitor.enabled`       | if `true`, creates a Prometheus Operator ServiceMonitor (also requires `metrics.enabled` to be `true`) | `false`                                   |
| `metrics.serviceMonitor.namespace`     | Namespace in which Prometheus is running                                                               | `nil`                                     |
| `metrics.serviceMonitor.labels`        | Additional labels for ServiceMonitor                                                                   | `{}`                                      |
| `metrics.serviceMonitor.interval`      | Interval at which metrics should be scraped.                                                           | `nil` (Prometheus Operator default value) |
| `metrics.serviceMonitor.scrapeTimeout` | Timeout after which the scrape is ended                                                                | `nil` (Prometheus Operator default value) |

### Volume Permissions parameters

| Parameter                             | Description                                                                                                          | Default                                                 |
| ------------------------------------- | -------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------- |
| `volumePermissions.enabled`           | Enable init container that changes the owner and group of the persistent volume(s) mountpoint to `runAsUser:fsGroup` | `false`                                                 |
| `volumePermissions.image.registry`    | Init container volume-permissions image registry                                                                     | `docker.io`                                             |
| `volumePermissions.image.repository`  | Init container volume-permissions image name                                                                         | `bitnami/bitnami-shell`                                 |
| `volumePermissions.image.tag`         | Init container volume-permissions image tag                                                                          | `"10"`                                                  |
| `volumePermissions.image.pullPolicy`  | Init container volume-permissions image pull policy                                                                  | `Always`                                                |
| `volumePermissions.image.pullSecrets` | Specify docker-registry secret names as an array                                                                     | `[]` (does not add image pull secrets to deployed pods) |

### MinIO&reg; chart parameters

| Parameter                  | Description                                                    | Default                                   |
| -------------------------- | -------------------------------------------------------------- | ----------------------------------------- |
| `minio.enabled`            | Enable/disable MinIO&reg; chart installation                   | `false`                                   |
| `minio.accessKey.password` | MinIO&reg; Access Key                                          | _random 10 character alphanumeric string_ |
| `minio.secretKey.password` | MinIO&reg; Secret Key                                          | _random 40 character alphanumeric string_ |
| `minio.defaultBuckets`     | Comma, semi-colon or space separated list of buckets to create | `nil`                                     |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
helm install my-release --set query.replicaCount=2 bitnami/thanos
```

The above command install Thanos chart with 2 Thanos Query replicas.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
helm install my-release -f values.yaml bitnami/thanos
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Adding extra flags

In case you want to add extra flags to any Thanos component, you can use `XXX.extraFlags` parameter(s), where XXX is placeholder you need to replace with the actual component(s). For instance, to add extra flags to Thanos Store Gateway, use:

```yaml
storegateway:
  extraFlags:
    - --sync-block-duration=3m
    - --chunk-pool-size=2GB
```

This also works for multi-line flags. This can be useful when you want to configure caching for a particular component without using a configMap. For example, to configure the [query-range response cache of the Thanos Query Frontend](https://thanos.io/tip/components/query-frontend.md/#memcached), use:

```yaml
queryFrontend:
  extraFlags:
    - |
      --query-range.response-cache-config=
      type: MEMCACHED
      config:
        addresses:
          - <MEMCACHED_SERVER>:11211
        timeout: 500ms
        max_idle_connections: 100
        max_async_concurrency: 10
        max_async_buffer_size: 10000
        max_get_multi_concurrency: 100
        max_get_multi_batch_size: 0
        dns_provider_update_interval: 10s
        expiration: 24h
```

### Using custom Objstore configuration

This helm chart supports using custom Objstore configuration.

You can specify the Objstore configuration using the `objstoreConfig` parameter.

In addition, you can also set an external Secret with the configuration file. This is done by setting the `existingObjstoreSecret` parameter. Note that this will override the previous option. If needed you can also provide a custom Secret Key with `existingObjstoreSecretItems`, please be aware that the Path of your Secret should be `objstore.yml`.

### Using custom Query Service Discovery configuration

This helm chart supports using custom Service Discovery configuration for Query.

You can specify the Service Discovery configuration using the `query.sdConfig` parameter.

In addition, you can also set an external ConfigMap with the Service Discovery configuration file. This is done by setting the `query.existingSDConfigmap` parameter. Note that this will override the previous option.

### Using custom Ruler configuration

This helm chart supports using custom Ruler configuration.

You can specify the Ruler configuration using the `ruler.config` parameter.

In addition, you can also set an external ConfigMap with the configuration file. This is done by setting the `ruler.existingConfigmap` parameter. Note that this will override the previous option.

### Integrate Thanos with Prometheus and Alertmanager

You can intregrate Thanos with Prometheus & Alertmanager using this chart and the [Bitnami kube-prometheus chart](https://github.com/bitnami/charts/tree/master/bitnami/kube-prometheus) following the steps below:

> Note: in this example we will use MinIO&reg; (subchart) as the Objstore. Every component will be deployed in the "monitoring" namespace.

- Create a **values.yaml** like the one below:

```yaml
objstoreConfig: |-
  type: s3
  config:
    bucket: thanos
    endpoint: {{ include "thanos.minio.fullname" . }}.monitoring.svc.cluster.local:9000
    access_key: minio
    secret_key: minio123
    insecure: true
query:
  dnsDiscovery:
    sidecarsService: kube-prometheus-prometheus-thanos
    sidecarsNamespace: monitoring
bucketweb:
  enabled: true
compactor:
  enabled: true
storegateway:
  enabled: true
ruler:
  enabled: true
  alertmanagers:
    - http://kube-prometheus-alertmanager.monitoring.svc.cluster.local:9093
  config: |-
    groups:
      - name: "metamonitoring"
        rules:
          - alert: "PrometheusDown"
            expr: absent(up{prometheus="monitoring/kube-prometheus"})
metrics:
  enabled: true
  serviceMonitor:
    enabled: true
minio:
  enabled: true
  accessKey:
    password: "minio"
  secretKey:
    password: "minio123"
  defaultBuckets: "thanos"
```

- Install Prometheus Operator and Thanos charts:

For Helm 3:

```bash
kubectl create namespace monitoring
helm install kube-prometheus \
    --set prometheus.thanos.create=true \
    --namespace monitoring \
    bitnami/kube-prometheus
helm install thanos \
    --values values.yaml \
    --namespace monitoring \
    bitnami/thanos
```

That's all! Now you have Thanos fully integrated with Prometheus and Alertmanager.

## Persistence

The data is persisted by default using PVC(s) on Thanos components. You can disable the persistence setting the `XXX.persistence.enabled` parameter(s) to `false`. A default `StorageClass` is needed in the Kubernetes cluster to dynamically provision the volumes. Specify another StorageClass in the `XXX.persistence.storageClass` parameter(s) or set `XXX.persistence.existingClaim` if you have already existing persistent volumes to use.

> Note: you need to substitute the XXX placeholders above with the actual component(s) you want to configure.

### Adjust permissions of persistent volume mountpoint

As the images run as non-root by default, it is necessary to adjust the ownership of the persistent volumes so that the containers can write data into it.

By default, the chart is configured to use Kubernetes Security Context to automatically change the ownership of the volumes. However, this feature does not work in all Kubernetes distributions.
As an alternative, this chart supports using an initContainer to change the ownership of the volumes before mounting it in the final destination.

You can enable this initContainer by setting `volumePermissions.enabled` to `true`.

### Setting Pod's affinity

This chart allows you to set your custom affinity using the `XXX.affinity` parameter(s). Find more information about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `XXX.podAffinityPreset`, `XXX.podAntiAffinityPreset`, or `XXX.nodeAffinityPreset` parameters.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami’s Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 3.3.0

This version introduces `bitnami/common`, a [library chart](https://helm.sh/docs/topics/library_charts/#helm) as a dependency. More documentation about this new utility could be found [here](https://github.com/bitnami/charts/tree/master/bitnami/common#bitnami-common-library-chart). Please, make sure that you have updated the chart dependencies before executing any upgrade.

### To 3.1.0

The querier component and its settings have been renamed to query. Configuration of the query component by using keys under `querier` in your `values.yaml` will continue to work. Support for keys under `querier` will be dropped in a future release.

```
querier.enabled                               -> query.enabled
querier.logLevel                              -> query.logLevel
querier.replicaLabel                          -> query.replicaLabel
querier.dnsDiscovery.enabled                  -> query.dnsDiscovery.enabled
querier.dnsDiscovery.sidecarsService          -> query.dnsDiscovery.sidecarsService
querier.dnsDiscovery.sidecarsNamespace        -> query.dnsDiscovery.sidecarsNamespace
querier.stores                                -> query.stores
querier.sdConfig                              -> query.sdConfig
querier.existingSDConfigmap                   -> query.existingSDConfigmap
querier.extraFlags                            -> query.extraFlags
querier.replicaCount                          -> query.replicaCount
querier.strategyType                          -> query.strategyType
querier.affinity                              -> query.affinity
querier.nodeSelector                          -> query.nodeSelector
querier.tolerations                           -> query.tolerations
querier.podLabels                             -> query.podLabels
querier.priorityClassName                     -> query.priorityClassName
querier.securityContext.enabled               -> query.securityContext.enabled
querier.securityContext.fsGroup               -> query.securityContext.fsGroup
querier.securityContext.runAsUser             -> query.securityContext.runAsUser
querier.resources.limits                      -> query.resources.limits
querier.resources.requests                    -> query.resources.requests
querier.podAnnotations                        -> query.podAnnotations
querier.livenessProbe                         -> query.livenessProbe
querier.readinessProbe                        -> query.readinessProbe
querier.grpcTLS.server.secure                 -> query.grpcTLS.server.secure
querier.grpcTLS.server.cert                   -> query.grpcTLS.server.cert
querier.grpcTLS.server.key                    -> query.grpcTLS.server.key
querier.grpcTLS.server.ca                     -> query.grpcTLS.server.ca
querier.grpcTLS.client.secure                 -> query.grpcTLS.client.secure
querier.grpcTLS.client.cert                   -> query.grpcTLS.client.cert
querier.grpcTLS.client.key                    -> query.grpcTLS.client.key
querier.grpcTLS.client.ca                     -> query.grpcTLS.client.ca
querier.grpcTLS.client.servername             -> query.grpcTLS.client.servername
querier.service.type                          -> query.service.type
querier.service.clusterIP                     -> query.service.clusterIP
querier.service.http.port                     -> query.service.http.port
querier.service.http.nodePort                 -> query.service.http.nodePort
querier.service.grpc.port                     -> query.service.grpc.port
querier.service.grpc.nodePort                 -> query.service.grpc.nodePort
querier.service.loadBalancerIP                -> query.service.loadBalancerIP
querier.service.loadBalancerSourceRanges      -> query.service.loadBalancerSourceRanges
querier.service.annotations                   -> query.service.annotations
querier.service.labelSelectorsOverride        -> query.service.labelSelectorsOverride
querier.serviceAccount.annotations            -> query.serviceAccount.annotations
querier.rbac.create                           -> query.rbac.create
querier.pspEnabled                            -> query.pspEnabled
querier.autoscaling.enabled                   -> query.autoscaling.enabled
querier.autoscaling.minReplicas               -> query.autoscaling.minReplicas
querier.autoscaling.maxReplicas               -> query.autoscaling.maxReplicas
querier.autoscaling.targetCPU                 -> query.autoscaling.targetCPU
querier.autoscaling.targetMemory              -> query.autoscaling.targetMemory
querier.pdb.create                            -> query.pdb.create
querier.pdb.minAvailable                      -> query.pdb.minAvailable
querier.pdb.maxUnavailable                    -> query.pdb.maxUnavailable
querier.ingress.enabled                       -> query.ingress.enabled
querier.ingress.certManager                   -> query.ingress.certManager
querier.ingress.hostname                      -> query.ingress.hostname
querier.ingress.annotations                   -> query.ingress.annotations
querier.ingress.tls                           -> query.ingress.tls
querier.ingress.extraHosts[0].name            -> query.ingress.extraHosts[0].name
querier.ingress.extraHosts[0].path            -> query.ingress.extraHosts[0].path
querier.ingress.extraTls[0].hosts[0]          -> query.ingress.extraTls[0].hosts[0]
querier.ingress.extraTls[0].secretName        -> query.ingress.extraTls[0].secretName
querier.ingress.secrets[0].name               -> query.ingress.secrets[0].name
querier.ingress.secrets[0].certificate        -> query.ingress.secrets[0].certificate
querier.ingress.secrets[0].key                -> query.ingress.secrets[0].key
querier.ingress.grpc.enabled                  -> query.ingress.grpc.enabled
querier.ingress.grpc.certManager              -> query.ingress.grpc.certManager
querier.ingress.grpc.hostname                 -> query.ingress.grpc.hostname
querier.ingress.grpc.annotations              -> query.ingress.grpc.annotations
querier.ingress.grpc.extraHosts[0].name       -> query.ingress.grpc.extraHosts[0].name
querier.ingress.grpc.extraHosts[0].path       -> query.ingress.grpc.extraHosts[0].path
querier.ingress.grpc.extraTls[0].hosts[0]     -> query.ingress.grpc.extraTls[0].hosts[0]
querier.ingress.grpc.extraTls[0].secretName   -> query.ingress.grpc.extraTls[0].secretName
querier.ingress.grpc.secrets[0].name          -> query.ingress.grpc.secrets[0].name
querier.ingress.grpc.secrets[0].certificate   -> query.ingress.grpc.secrets[0].certificate
querier.ingress.grpc.secrets[0].key           -> query.ingress.grpc.secrets[0].key
```

### To 3.0.0

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

### To 2.4.0

The Ingress API object name for Querier changes from:

```yaml
{{ include "common.names.fullname" . }}
```

> **NOTE**: Which in most cases (depending on any set values in `fullnameOverride` or `nameOverride`) resolves to the used Helm release name (`.Release.Name`).

To:

```yaml
{{ include "common.names.fullname" . }}-querier
```

### To 2.0.0

The format of the chart's `extraFlags` option has been updated to be an array (instead of an object), to support passing multiple flags with the same name to Thanos.

Now you need to specify the flags in the following way in your values file (where component is one of `querier/bucketweb/compactor/storegateway/ruler`):

```yaml
component:
  ...
  extraFlags
    - --sync-block-duration=3m
    - --chunk-pool-size=2GB
```

To specify the values via CLI::

```console
--set 'component.extraFlags[0]=--sync-block-duration=3m' --set 'ruler.extraFlags[1]=--chunk-pool-size=2GB'
```

### To 1.0.0

If you are upgrading from a `<1.0.0` release you need to move your Querier Ingress information to the new values settings:
```
ingress.enabled -> querier.ingress.enabled
ingress.certManager -> querier.ingress.certManager
ingress.hostname -> querier.ingress.hostname
ingress.annotations -> querier.ingress.annotations
ingress.extraHosts[0].name -> querier.ingress.extraHosts[0].name
ingress.extraHosts[0].path -> querier.ingress.extraHosts[0].path
ingress.extraHosts[0].hosts[0] -> querier.ingress.extraHosts[0].hosts[0]
ingress.extraHosts[0].secretName -> querier.ingress.extraHosts[0].secretName
ingress.secrets[0].name -> querier.ingress.secrets[0].name
ingress.secrets[0].certificate -> querier.ingress.secrets[0].certificate
ingress.secrets[0].key -> querier.ingress.secrets[0].key

```
