<!--- app-name: Cortex -->

# Bitnami Secure Images Helm chart for Cortex

Cortex is an open source, horizontally scalable, highly available, multi-tenant, long-term storage for Prometheus metrics that is compatible with the Prometheus remote write API.

[Overview of Cortex](https://cortexmetrics.io/)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/cortex
```

## Why use Bitnami Secure Images?

Those are hardened, minimal CVE images built and maintained by Bitnami. Bitnami Secure Images are based on the cloud-optimized, security-hardened enterprise [OS Photon Linux](https://vmware.github.io/photon/). Why choose BSI images?

- Hardened secure images of popular open source software with Near-Zero Vulnerabilities
- Vulnerability Triage & Prioritization with VEX Statements, KEV and EPSS Scores
- Compliance focus with FIPS, STIG, and air-gap options, including secure bill of materials (SBOM)
- Software supply chain provenance attestation through in-toto
- First class support for the internet's favorite Helm charts

Each image comes with valuable security metadata. You can view the metadata in [our public catalog here](https://app-catalog.vmware.com/bitnami/apps). Note: Some data is only available with [commercial subscriptions to BSI](https://bitnami.com/).

![Alt text](https://github.com/bitnami/containers/blob/main/BSI%20UI%201.png?raw=true "Application details")
![Alt text](https://github.com/bitnami/containers/blob/main/BSI%20UI%202.png?raw=true "Packaging report")

If you are looking for our previous generation of images based on Debian Linux, please see the [Bitnami Legacy registry](https://hub.docker.com/u/bitnamilegacy).

## Introduction

Bitnami charts for Helm are carefully engineered, actively maintained and are the quickest and easiest way to deploy containers on a Kubernetes cluster that are ready to handle production workloads.

This chart bootstraps a [Cortex](https://github.com/cortexproject/cortex) deployment in a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/cortex
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The command deploys Cortex on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Configuration and installation details

### Resource requests and limits

Bitnami charts allow setting resource requests and limits for all containers inside the chart deployment. These are inside the `resources` value (check parameter table). Setting requests is essential for production workloads and these should be adapted to your specific use case.

To make this process easier, the chart contains the `resourcesPreset` values, which automatically sets the `resources` section according to different presets. Check these presets in [the bitnami/common chart](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15). However, in production workloads using `resourcesPreset` is discouraged as it may not fully adapt to your specific needs. Find more information on container resource management in the [official Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).

### [Rolling VS Immutable tags](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Prometheus metrics

This chart can be integrated with Prometheus by setting `metrics.enabled` to true. This will expose the Cortex native Prometheus metrics port in both the containers and services. The services will also have the necessary annotations to be automatically scraped by Prometheus.

#### Prometheus requirements

It is necessary to have a working installation of Prometheus or Prometheus Operator for the integration to work. Install the [Bitnami Prometheus helm chart](https://github.com/bitnami/charts/tree/main/bitnami/prometheus) or the [Bitnami Kube Prometheus helm chart](https://github.com/bitnami/charts/tree/main/bitnami/kube-prometheus) to easily have a working Prometheus in your cluster.

#### Integration with Prometheus Operator

The chart can deploy `ServiceMonitor` objects for integration with Prometheus Operator installations. To do so, set the value `metrics.serviceMonitor.enabled=true`. Ensure that the Prometheus Operator `CustomResourceDefinitions` are installed in the cluster or it will fail with the following error:

```text
no matches for kind "ServiceMonitor" in version "monitoring.coreos.com/v1"
```

Install the [Bitnami Kube Prometheus helm chart](https://github.com/bitnami/charts/tree/main/bitnami/kube-prometheus) for having the necessary CRDs and the Prometheus Operator.

### Cortex configuration

The Cortex configuration file `cortex.yaml` is shared across the different components: `alertmanager`, `compactor`, `distributor`, `ingester`, `querier`, `query-frontend`, `query-scheduler`, `ruler`, `store-gateway`, `overrides-exporter`, and the Nginx gateway. This is set in the `cortex.configuration` value. That value is templated, so you can use other chart values or templates in your configuration. Check the official [Cortex configuration documentation](https://cortexmetrics.io/docs/configuration/configuration-file/) for the list of possible configurations.

### Block storage

By default, the chart deploys an embedded [SeaweedFS](https://github.com/seaweedfs/seaweedfs) instance as S3-compatible object storage for block storage, ruler rules, and alertmanager state. For production workloads, it is recommended to use an external S3-compatible storage backend.

To use an external S3 backend, disable SeaweedFS and configure the block storage:

```yaml
seaweedfs:
  enabled: false
cortex:
  blockStorage:
    backend: s3
    s3:
      endpoint: s3.us-east-1.amazonaws.com
      accessKeyId: my-access-key
      secretAccessKey: my-secret-key
      bucketName: my-cortex-bucket
```

### Data

The [Bitnami Cortex](https://github.com/bitnami/containers/tree/main/bitnami/cortex) image stores the data at the `/bitnami/cortex` path of the container. Persistent Volume Claims are used to keep the data across deployments for stateful components (alertmanager, compactor, ingester, store-gateway).

### Backup and restore

To back up and restore Helm chart deployments on Kubernetes, you need to back up the persistent volumes from the source deployment and attach them to a new deployment using [Velero](https://velero.io/), a Kubernetes backup/restore tool. Find the instructions for using Velero in [this guide](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-backup-restore-deployments-velero-index.html).

### Additional environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `extraEnvVars` property inside each of the subsections: `alertmanager`, `compactor`, `distributor`, `ingester`, `querier`, `queryFrontend`, `queryScheduler`, `ruler`, `storeGateway`, and `overridesExporter`.

```yaml
cortex:
  blockStorage:
    backend: s3
    s3:
      endpoint: "${S3_ENDPOINT}"
      accessKeyId: "${S3_ACCESS_KEY_ID}"
      secretAccessKey: "${S3_SECRET_ACCESS_KEY}"
      bucketName: cortex
ingester:
  extraEnvVars:
    - name: S3_ACCESS_KEY_ID
      valueFrom:
        secretKeyRef:
          name: s3-credentials-secret
          key: access-key-id
    - name: S3_SECRET_ACCESS_KEY
      valueFrom:
        secretKeyRef:
          name: s3-credentials-secret
          key: secret-access-key
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values.

### Pod affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, use one of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters inside each of the subsections: `alertmanager`, `compactor`, `distributor`, `ingester`, `querier`, `queryFrontend`, `queryScheduler`, `ruler`, `storeGateway`, and `overridesExporter`.

### External cache support

You may want to have Cortex connect to an external Memcached rather than installing one inside your cluster. Typical reasons for this are to use a managed cache service, or to share a common cache server for all your applications. To achieve this, the chart allows you to specify credentials for an external Memcached with the `externalMemcached*` parameters. You should also disable the Memcached installation with the `enabled` option. Here is an example:

```console
memcachedchunks.enabled=false
externalMemcachedChunks.host=myexternalhost
externalMemcachedChunks.port=11211
```

## Parameters

### Global parameters

| Name                                                  | Description                                                                                                                                                                                                                                                                                                                                                         | Value       |
| ----------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| `global.imageRegistry`                                | Global Docker image registry                                                                                                                                                                                                                                                                                                                                        | `""`        |
| `global.imagePullSecrets`                             | Global Docker registry secret names as an array                                                                                                                                                                                                                                                                                                                     | `[]`        |
| `global.defaultStorageClass`                          | Global default StorageClass for Persistent Volume(s)                                                                                                                                                                                                                                                                                                                | `""`        |
| `global.security.allowInsecureImages`                 | Allows skipping image verification                                                                                                                                                                                                                                                                                                                                  | `false`     |
| `global.compatibility.openshift.adaptSecurityContext` | Adapt the securityContext sections of the deployment to make them compatible with Openshift restricted-v2 SCC: remove runAsUser, runAsGroup and fsGroup and let the platform use their allowed default IDs. Possible values: auto (apply if the detected running cluster is Openshift), force (perform the adaptation always), disabled (do not perform adaptation) | `auto`      |

### Common parameters

| Name                     | Description                                                                             | Value           |
| ------------------------ | --------------------------------------------------------------------------------------- | --------------- |
| `kubeVersion`            | Override Kubernetes version                                                             | `""`            |
| `nameOverride`           | String to partially override common.names.name                                          | `""`            |
| `fullnameOverride`       | String to fully override common.names.fullname                                          | `""`            |
| `namespaceOverride`      | String to fully override common.names.namespace                                         | `""`            |
| `commonLabels`           | Labels to add to all deployed objects                                                   | `{}`            |
| `commonAnnotations`      | Annotations to add to all deployed objects                                              | `{}`            |
| `clusterDomain`          | Kubernetes cluster domain name                                                          | `cluster.local` |
| `extraDeploy`            | Array of extra objects to deploy with the release                                       | `[]`            |
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden) | `false`         |
| `diagnosticMode.command` | Command to override all containers in the chart                                         | `["sleep"]`     |
| `diagnosticMode.args`    | Args to override all containers in the chart                                            | `["infinity"]`  |

### Common Cortex parameters

| Name                                    | Description                                                                                                                              | Value                        |
| --------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------- |
| `cortex.image.registry`                 | Cortex image registry                                                                                                                    | `REGISTRY_NAME`              |
| `cortex.image.repository`               | Cortex image repository                                                                                                                  | `REPOSITORY_NAME/cortex`     |
| `cortex.image.digest`                   | Cortex image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag image tag (immutable tags are recommended) | `""`                   |
| `cortex.image.pullPolicy`               | Cortex image pull policy                                                                                                                 | `IfNotPresent`               |
| `cortex.image.pullSecrets`              | Cortex image pull secrets                                                                                                                | `[]`                         |
| `cortex.dataDir`                        | Path to the Cortex data directory                                                                                                        | `/bitnami/cortex`            |
| `cortex.configuration`                  | Cortex components configuration (cortex.yaml)                                                                                           | `""`                         |
| `cortex.overrideConfiguration`          | Cortex components configuration override. Values defined here take precedence over cortex.configuration                                  | `{}`                         |
| `cortex.existingConfigmap`              | Name of a ConfigMap with the Cortex configuration                                                                                        | `""`                         |
| `cortex.containerPorts.http`            | Cortex HTTP container port (shared for all components)                                                                                   | `80`                         |
| `cortex.containerPorts.grpc`            | Cortex gRPC container port (shared for all components)                                                                                   | `9095`                       |
| `cortex.containerPorts.gossip`          | Cortex memberlist/gossip container port (shared for all components)                                                                      | `7946`                       |
| `cortex.gossipRing.service.ports.http`  | Gossip Ring HTTP headless service port                                                                                                   | `7946`                       |
| `cortex.gossipRing.service.annotations` | Additional custom annotations for Gossip Ring headless service                                                                           | `{}`                         |
| `cortex.blockStorage.backend`           | Backend storage to use. NOTE: if seaweedfs.enabled == true, this configuration will be ignored                                           | `s3`                         |
| `cortex.blockStorage.s3.endpoint`       | External S3 endpoint (used when seaweedfs.enabled == false)                                                                              | `""`                         |
| `cortex.blockStorage.s3.accessKeyId`    | External S3 access key ID                                                                                                                | `""`                         |
| `cortex.blockStorage.s3.secretAccessKey`| External S3 secret access key                                                                                                            | `""`                         |
| `cortex.blockStorage.s3.bucketName`     | External S3 bucket name for blocks storage                                                                                               | `""`                         |
| `cortex.blockStorage.s3.region`         | External S3 region                                                                                                                       | `""`                         |
| `cortex.blockStorage.s3.insecure`       | Disable TLS for external S3 connections                                                                                                  | `false`                      |

### Distributor parameters

| Name                                            | Description                                                  | Value        |
| ----------------------------------------------- | ------------------------------------------------------------ | ------------ |
| `distributor.replicaCount`                      | Number of Distributor replicas to deploy                     | `1`          |
| `distributor.resources`                         | Set container requests and limits for different resources like CPU or memory | `{}`  |
| `distributor.resourcesPreset`                   | Set container resources according to one common preset       | `small`      |
| `distributor.podAnnotations`                    | Annotations for Distributor pods                             | `{}`         |
| `distributor.podLabels`                         | Extra labels for Distributor pods                            | `{}`         |
| `distributor.extraEnvVars`                      | Array with extra environment variables to add to Distributor containers | `[]` |
| `distributor.extraEnvVarsCM`                    | Name of existing ConfigMap containing extra env vars         | `""`         |
| `distributor.extraEnvVarsSecret`                | Name of existing Secret containing extra env vars            | `""`         |
| `distributor.podSecurityContext.enabled`        | Enabled pods' Security Context                               | `true`       |
| `distributor.containerSecurityContext.enabled`  | Enabled containers' Security Context                         | `true`       |
| `distributor.service.type`                      | Distributor service type                                     | `ClusterIP`  |
| `distributor.service.ports.http`                | Distributor service HTTP port                                | `80`         |
| `distributor.service.ports.grpc`                | Distributor service gRPC port                                | `9095`       |
| `distributor.pdb.create`                        | Enable/disable a Pod Disruption Budget creation              | `true`       |
| `distributor.autoscaling.enabled`               | Enable autoscaling for the Distributor                       | `false`      |

### Ingester parameters

| Name                                          | Description                                                  | Value        |
| --------------------------------------------- | ------------------------------------------------------------ | ------------ |
| `ingester.replicaCount`                       | Number of Ingester replicas to deploy                        | `1`          |
| `ingester.resources`                          | Set container requests and limits for different resources like CPU or memory | `{}`  |
| `ingester.resourcesPreset`                    | Set container resources according to one common preset       | `small`      |
| `ingester.podAnnotations`                     | Annotations for Ingester pods                                | `{}`         |
| `ingester.persistence.enabled`                | Enable Ingester persistence using PVC                        | `true`       |
| `ingester.persistence.size`                   | Ingester PVC size                                            | `10Gi`       |
| `ingester.persistence.storageClass`           | StorageClass for Ingester PVC                                | `""`         |
| `ingester.service.type`                       | Ingester service type                                        | `ClusterIP`  |
| `ingester.pdb.create`                         | Enable/disable a Pod Disruption Budget creation              | `true`       |
| `ingester.autoscaling.enabled`                | Enable autoscaling for the Ingester                          | `false`      |

### Querier parameters

| Name                                         | Description                                                  | Value        |
| -------------------------------------------- | ------------------------------------------------------------ | ------------ |
| `querier.replicaCount`                       | Number of Querier replicas to deploy                         | `1`          |
| `querier.resources`                          | Set container requests and limits for different resources like CPU or memory | `{}`  |
| `querier.resourcesPreset`                    | Set container resources according to one common preset       | `small`      |
| `querier.service.type`                       | Querier service type                                         | `ClusterIP`  |
| `querier.pdb.create`                         | Enable/disable a Pod Disruption Budget creation              | `true`       |
| `querier.autoscaling.enabled`                | Enable autoscaling for the Querier                           | `false`      |

### Query Frontend parameters

| Name                                              | Description                                                  | Value        |
| ------------------------------------------------- | ------------------------------------------------------------ | ------------ |
| `queryFrontend.replicaCount`                      | Number of Query Frontend replicas to deploy                  | `1`          |
| `queryFrontend.resources`                         | Set container requests and limits for different resources like CPU or memory | `{}`  |
| `queryFrontend.resourcesPreset`                   | Set container resources according to one common preset       | `small`      |
| `queryFrontend.service.type`                      | Query Frontend service type                                  | `ClusterIP`  |
| `queryFrontend.pdb.create`                        | Enable/disable a Pod Disruption Budget creation              | `true`       |
| `queryFrontend.autoscaling.enabled`               | Enable autoscaling for the Query Frontend                    | `false`      |

### Query Scheduler parameters

| Name                                               | Description                                                  | Value        |
| -------------------------------------------------- | ------------------------------------------------------------ | ------------ |
| `queryScheduler.enabled`                           | Enable Query Scheduler deployment                            | `false`      |
| `queryScheduler.replicaCount`                      | Number of Query Scheduler replicas to deploy                 | `2`          |
| `queryScheduler.resources`                         | Set container requests and limits for different resources like CPU or memory | `{}`  |
| `queryScheduler.resourcesPreset`                   | Set container resources according to one common preset       | `small`      |
| `queryScheduler.service.type`                      | Query Scheduler service type                                 | `ClusterIP`  |

### Store Gateway parameters

| Name                                               | Description                                                  | Value        |
| -------------------------------------------------- | ------------------------------------------------------------ | ------------ |
| `storeGateway.replicaCount`                        | Number of Store Gateway replicas to deploy                   | `1`          |
| `storeGateway.resources`                           | Set container requests and limits for different resources like CPU or memory | `{}`  |
| `storeGateway.resourcesPreset`                     | Set container resources according to one common preset       | `small`      |
| `storeGateway.persistence.enabled`                 | Enable Store Gateway persistence using PVC                   | `true`       |
| `storeGateway.persistence.size`                    | Store Gateway PVC size                                       | `10Gi`       |
| `storeGateway.service.type`                        | Store Gateway service type                                   | `ClusterIP`  |
| `storeGateway.pdb.create`                          | Enable/disable a Pod Disruption Budget creation              | `true`       |

### Compactor parameters

| Name                                           | Description                                                  | Value        |
| ---------------------------------------------- | ------------------------------------------------------------ | ------------ |
| `compactor.replicaCount`                       | Number of Compactor replicas to deploy                       | `1`          |
| `compactor.resources`                          | Set container requests and limits for different resources like CPU or memory | `{}`  |
| `compactor.resourcesPreset`                    | Set container resources according to one common preset       | `small`      |
| `compactor.persistence.enabled`                | Enable Compactor persistence using PVC                       | `true`       |
| `compactor.persistence.size`                   | Compactor PVC size                                           | `10Gi`       |
| `compactor.service.type`                       | Compactor service type                                       | `ClusterIP`  |
| `compactor.pdb.create`                         | Enable/disable a Pod Disruption Budget creation              | `true`       |

### Ruler parameters

| Name                                        | Description                                                  | Value        |
| ------------------------------------------- | ------------------------------------------------------------ | ------------ |
| `ruler.replicaCount`                        | Number of Ruler replicas to deploy                           | `1`          |
| `ruler.resources`                           | Set container requests and limits for different resources like CPU or memory | `{}`  |
| `ruler.resourcesPreset`                     | Set container resources according to one common preset       | `small`      |
| `ruler.service.type`                        | Ruler service type                                           | `ClusterIP`  |
| `ruler.pdb.create`                          | Enable/disable a Pod Disruption Budget creation              | `true`       |

### Alertmanager parameters

| Name                                              | Description                                                  | Value        |
| ------------------------------------------------- | ------------------------------------------------------------ | ------------ |
| `alertmanager.replicaCount`                       | Number of Alertmanager replicas to deploy                    | `1`          |
| `alertmanager.resources`                          | Set container requests and limits for different resources like CPU or memory | `{}`  |
| `alertmanager.resourcesPreset`                    | Set container resources according to one common preset       | `small`      |
| `alertmanager.persistence.enabled`                | Enable Alertmanager persistence using PVC                    | `true`       |
| `alertmanager.persistence.size`                   | Alertmanager PVC size                                        | `10Gi`       |
| `alertmanager.service.type`                       | Alertmanager service type                                    | `ClusterIP`  |
| `alertmanager.pdb.create`                         | Enable/disable a Pod Disruption Budget creation              | `true`       |

### Overrides Exporter parameters

| Name                                                  | Description                                                  | Value        |
| ----------------------------------------------------- | ------------------------------------------------------------ | ------------ |
| `overridesExporter.replicaCount`                      | Number of Overrides Exporter replicas to deploy              | `1`          |
| `overridesExporter.resources`                         | Set container requests and limits for different resources like CPU or memory | `{}`  |
| `overridesExporter.resourcesPreset`                   | Set container resources according to one common preset       | `small`      |
| `overridesExporter.service.type`                      | Overrides Exporter service type                              | `ClusterIP`  |

### Nginx gateway parameters

| Name                                        | Description                                                  | Value        |
| ------------------------------------------- | ------------------------------------------------------------ | ------------ |
| `nginx.enabled`                             | Enable Nginx gateway deployment                              | `true`       |
| `nginx.replicaCount`                        | Number of Nginx gateway replicas to deploy                   | `1`          |
| `nginx.image.registry`                      | Nginx image registry                                         | `REGISTRY_NAME` |
| `nginx.image.repository`                    | Nginx image repository                                       | `REPOSITORY_NAME/nginx` |
| `nginx.service.type`                        | Nginx service type                                           | `LoadBalancer` |
| `nginx.service.ports.http`                  | Nginx service HTTP port                                      | `80`         |
| `nginx.pdb.create`                          | Enable/disable a Pod Disruption Budget creation              | `true`       |
| `nginx.autoscaling.enabled`                 | Enable autoscaling for Nginx gateway                         | `false`      |

### SeaweedFS (embedded S3 storage) parameters

| Name                               | Description                                                            | Value   |
| ---------------------------------- | ---------------------------------------------------------------------- | ------- |
| `seaweedfs.enabled`                | Enable SeaweedFS for S3-compatible object storage                      | `true`  |
| `seaweedfs.s3.enabled`             | Enable the SeaweedFS S3 API                                            | `true`  |
| `seaweedfs.s3.auth.enabled`        | Enable S3 authentication                                               | `true`  |
| `seaweedfs.s3.auth.existingSecret` | Name of an existing Secret with S3 credentials                         | `""`    |

### Memcached (chunks cache) parameters

| Name                               | Description                                                            | Value   |
| ---------------------------------- | ---------------------------------------------------------------------- | ------- |
| `memcachedchunks.enabled`          | Enable Memcached for chunks cache                                      | `false` |

### Memcached (frontend cache) parameters

| Name                                | Description                                                           | Value   |
| ----------------------------------- | --------------------------------------------------------------------- | ------- |
| `memcachedfrontend.enabled`         | Enable Memcached for query frontend results cache                     | `false` |

### Memcached (index cache) parameters

| Name                               | Description                                                            | Value   |
| ---------------------------------- | ---------------------------------------------------------------------- | ------- |
| `memcachedindex.enabled`           | Enable Memcached for index cache                                       | `false` |

### Memcached (metadata cache) parameters

| Name                                | Description                                                           | Value   |
| ----------------------------------- | --------------------------------------------------------------------- | ------- |
| `memcachedmetadata.enabled`         | Enable Memcached for metadata cache                                   | `false` |

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## License

Copyright &copy; 2026 Broadcom. The term "Broadcom" refers to Broadcom Inc. and/or its subsidiaries.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at <http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and limitations under the License.
