# MongoDB

[MongoDB](https://www.mongodb.com/) is a cross-platform document-oriented database. Classified as a NoSQL database, MongoDB eschews the traditional table-based relational database structure in favor of JSON-like documents with dynamic schemas, making the integration of data in certain types of applications easier and faster.

## TL;DR;

```bash
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/mongodb
```

## Introduction

This chart bootstraps a [MongoDB](https://github.com/bitnami/bitnami-docker-mongodb) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This chart has been tested to work with NGINX Ingress, cert-manager, fluentd and Prometheus on top of the [BKPR](https://kubeprod.io/).

## Prerequisites

- Kubernetes 1.12+
- Helm 2.12+ or Helm 3.0-beta3+
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install my-release bitnami/mongodb
```

The command deploys MongoDB on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Architecture

This charts allows you install MongoDB using two different architecture setups: "standalone" or "replicaset". You can use the `architecture` parameter to choose the one to use:

```console
architecture="standalone"
architecture="replicaset"
```

The standalone architecture installs a deployment (or statefulset) with one MongoDB server (it cannot be scaled):

```
                ┌────────────────┐
                │    MongoDB     │
                |      svc       │
                └───────┬────────┘
                        │
                        ▼
                  ┌──────────┐
                  │  MongoDB │
                  │  Server  │
                  │   Pod    │
                  └──────────┘
```

The replicaset architecture install two statefulsets: a statefulset with N MongoDB servers (organised with one primary and N-1 secondary nodes), and a statefulset with one MongoDB arbiter node (it cannot be scaled). There are no services load balancing requests between MongoDB nodes, instead each node has an associated service to access them individually:

```
    ┌────────────────┐ ┌────────────────┐ ┌────────────────┐    ┌─────────────┐
    │   MongoDB 0    │ │   MongoDB 1    │ │   MongoDB N    │    │   Arbiter   │
    |  external svc  │ |  external svc  │ |  external svc  │    |     svc     │
    └───────┬────────┘ └───────┬────────┘ └───────┬────────┘    └──────┬──────┘
            │                  │                  │                    │
            ▼                  ▼                  ▼                    ▼
      ┌───────────┐      ┌───────────┐      ┌───────────┐        ┌───────────┐
      │ MongoDB 0 │      │ MongoDB 1 │      │ MongoDB N │        │  MongoDB  │
      │  Server   │      │  Server   │ .... │  Server   │        │  Arbiter  │
      │   Pod     │      │   Pod     │      │   Pod     │        │   Pod     │
      └───────────┘      └───────────┘      └───────────┘        └───────────┘
         primary           secondary          secondary
```

> Note: although the 1st replica is initially assigned the "primary" role, any of the "secondary" nodes can become the "primary" if it is down, or during upgrades. Do not make any assumption about what replica has the "primary" role, instead configure your Mongo client with the list of MongoDB hostnames so it can dynamically choose the node to send requests.

## Parameters

The following tables lists the configurable parameters of the MongoDB chart and their default values per section/component:

### Global parameters

| Parameter                                 | Description                                                                                                | Default                                                      |
|-------------------------------------------|------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------|
| `global.imageRegistry`                    | Global Docker image registry                                                                               | `nil`                                                        |
| `global.imagePullSecrets`                 | Global Docker registry secret names as an array                                                            | `[]` (does not add image pull secrets to deployed pods)      |
| `global.storageClass`                     | Global storage class for dynamic provisioning                                                              | `nil`                                                        |
| `global.namespaceOverride`                | Global string to override the release namespace                                                            | `nil`                                                        |

### Common parameters

| Parameter                                 | Description                                                                                                | Default                                                      |
|-------------------------------------------|------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------|
| `nameOverride`                            | String to partially override mongodb.fullname                                                              | `nil`                                                        |
| `fullnameOverride`                        | String to fully override mongodb.fullname                                                                  | `nil`                                                        |
| `clusterDomain`                           | Default Kubernetes cluster domain                                                                          | `cluster.local`                                              |
| `schedulerName`                           | Name of the scheduler (other than default) to dispatch pods                                                | `nil`                                                        |
| `image.registry`                          | MongoDB image registry                                                                                     | `docker.io`                                                  |
| `image.repository`                        | MongoDB image name                                                                                         | `bitnami/mongodb`                                            |
| `image.tag`                               | MongoDB image tag                                                                                          | `{TAG_NAME}`                                                 |
| `image.pullPolicy`                        | MongoDB image pull policy                                                                                  | `IfNotPresent`                                               |
| `image.pullSecrets`                       | Specify docker-registry secret names as an array                                                           | `[]` (does not add image pull secrets to deployed pods)      |
| `image.debug`                             | Set to true if you would like to see extra information on logs                                             | `false`                                                      |

### MongoDB parameters

| Parameter                                 | Description                                                                                                | Default                                                 |
|-------------------------------------------|------------------------------------------------------------------------------------------------------------|---------------------------------------------------------|
| `architecture`                            | MongoDB architecture (`standalone` or `replicaset`)                                                        | `standalone`                                            |
| `useStatefulSet`                          | Set to true to use a StatefulSet instead of a Deployment (only when `architecture=standalone`)             | `false`                                                 |
| `auth.enabled`                            | Enable authentication                                                                                      | `true`                                                  |
| `auth.rootPassword`                       | MongoDB admin password                                                                                     | _random 10 character long alphanumeric string_          |
| `auth.username`                           | MongoDB custom user (mandatory if `auth.database` is set)                                                  | `nil`                                                   |
| `auth.password`                           | MongoDB custom user password                                                                               | _random 10 character long alphanumeric string_          |
| `auth.database`                           | MongoDB custom database                                                                                    | `nil`                                                   |
| `auth.replicaSetKey`                      | Key used for authentication in the replicaset (only when `architecture=replicaset`)                        | _random 10 character long alphanumeric string_          |
| `auth.existingSecret`                     | Existing secret with MongoDB credentials                                                                   | `nil`                                                   |
| `replicaSetName`                          | Name of the replica set (only when `architecture=replicaset`)                                              | `rs0`                                                   |
| `replicaSetHostnames`                     | Enable DNS hostnames in the replicaset config (only when `architecture=replicaset`)                        | `true`                                                  |
| `enableIPv6`                              | Switch to enable/disable IPv6 on MongoDB                                                                   | `false`                                                 |
| `directoryPerDB`                          | Switch to enable/disable DirectoryPerDB on MongoDB                                                         | `false`                                                 |
| `systemLogVerbosity`                      | MongoDB system log verbosity level                                                                         | `0`                                                     |
| `disableSystemLog`                        | Switch to enable/disable MongoDB system log                                                                | `false`                                                 |
| `configuration`                           | MongoDB configuration file to be used                                                                      | `{}`                                                    |
| `existingConfigmap`                       | Name of existing ConfigMap with MongoDB configuration                                                      | `nil`                                                   |
| `initdbScripts`                           | Dictionary of initdb scripts                                                                               | `nil`                                                   |
| `initdbScriptsConfigMap`                  | ConfigMap with the initdb scripts                                                                          | `nil`                                                   |
| `command`                                 | Override default container command (useful when using custom images)                                       | `nil`                                                   |
| `args`                                    | Override default container args (useful when using custom images)                                          | `nil`                                                   |
| `extraFlags`                              | MongoDB additional command line flags                                                                      | `[]`                                                    |
| `extraEnvVars`                            | Extra environment variables to add to MongoDB pods                                                         | `[]`                                                    |
| `extraEnvVarsCM`                          | Name of existing ConfigMap containing extra env vars                                                       | `nil`                                                   |
| `extraEnvVarsSecret`                      | Name of existing Secret containing extra env vars (in case of sensitive data)                              | `nil`                                                   |

### MongoDB statefulset parameters

| Parameter                                 | Description                                                                                                | Default                                                 |
|-------------------------------------------|------------------------------------------------------------------------------------------------------------|---------------------------------------------------------|
| `replicaCount`                            | Number of MongoDB nodes (only when `architecture=replicaset`)                                              | `2`                                                     |
| `labels`                                  | Annotations to be added to the MongoDB statefulset                                                         | `{}` (evaluated as a template)                          |
| `annotations`                             | Additional labels to be added to the MongoDB statefulset                                                   | `{}` (evaluated as a template)                          |
| `podManagementPolicy`                     | Pod management policy for MongoDB                                                                          | `OrderedReady`                                          |
| `strategyType`                            | StrategyType for MongoDB statefulset                                                                       | `RollingUpdate`                                         |
| `podLabels`                               | MongoDB pod labels                                                                                         | `{}` (evaluated as a template)                          |
| `podAnnotations`                          | MongoDB Pod annotations                                                                                    | `{}` (evaluated as a template)                          |
| `priorityClassName`                       | Name of the existing priority class to be used by MongoDB pod(s)                                           | `""`                                                    |
| `affinity`                                | Affinity for MongoDB pod(s) assignment                                                                     | `{}` (evaluated as a template)                          |
| `nodeSelector`                            | Node labels for MongoDB pod(s) assignment                                                                  | `{}` (evaluated as a template)                          |
| `tolerations`                             | Tolerations for MongoDB pod(s) assignment                                                                  | `[]` (evaluated as a template)                          |
| `podSecurityContext`                      | MongoDB pod(s)' Security Context                                                                           | Check `values.yaml` file                                |
| `containerSecurityContext`                | MongoDB containers' Security Context                                                                       | Check `values.yaml` file                                |
| `resources.limits`                        | The resources limits for MongoDB containers                                                                | `{}`                                                    |
| `resources.requests`                      | The requested resources for MongoDB containers                                                             | `{}`                                                    |
| `livenessProbe`                           | Liveness probe configuration for MongoDB                                                                   | Check `values.yaml` file                                |
| `readinessProbe`                          | Readiness probe configuration for MongoDB                                                                  | Check `values.yaml` file                                |
| `customLivenessProbe`                     | Override default liveness probe for MongoDB containers                                                     | `nil`                                                   |
| `customReadinessProbe`                    | Override default readiness probe for MongoDB containers                                                    | `nil`                                                   |
| `pdb.create`                              | Enable/disable a Pod Disruption Budget creation for MongoDB pod(s)                                         | `false`                                                 |
| `pdb.minAvailable`                        | Minimum number/percentage of MongoDB pods that should remain scheduled                                     | `nil`                                                   |
| `pdb.maxUnavailable`                      | Maximum number/percentage of MongoDB pods that may be made unavailable                                     | `1`                                                     |
| `initContainers`                          | Add additional init containers for the MongoDB pod(s)                                                      | `{}` (evaluated as a template)                          |
| `sidecars`                                | Add additional sidecar containers for the MongoDB pod(s)                                                   | `{}` (evaluated as a template)                          |
| `extraVolumeMounts`                       | Optionally specify extra list of additional volumeMounts for the MongoDB container(s)                      | `{}`                                                    |
| `extraVolumes`                            | Optionally specify extra list of additional volumes to the MongoDB statefulset                             | `{}`                                                    |

### Exposure parameters

| Parameter                                         | Description                                                                                        | Default                                                 |
|---------------------------------------------------|----------------------------------------------------------------------------------------------------|---------------------------------------------------------|
| `service.type`                                    | Kubernetes Service type                                                                            | `ClusterIP`                                             |
| `service.port`                                    | MongoDB service port                                                                               | `27017`                                                 |
| `service.portName`                                | MongoDB service port name                                                                          | `mongodb`                                               |
| `service.nodePort`                                | Port to bind to for NodePort and LoadBalancer service types                                        | `""`                                                    |
| `service.clusterIP`                               | MongoDB service cluster IP                                                                         | `nil`                                                   |
| `service.loadBalancerIP`                          | loadBalancerIP for MongoDB Service                                                                 | `nil`                                                   |
| `service.loadBalancerSourceRanges`                | Address(es) that are allowed when service is LoadBalancer                                          | `[]`                                                    |
| `service.annotations`                             | Service annotations                                                                                | `{}` (evaluated as a template)                          |
| `externalAccess.enabled`                          | Enable Kubernetes external cluster access to MongoDB nodes                                         | `false`                                                 |
| `externalAccess.autoDiscovery.enabled`            | Enable using an init container to auto-detect external IPs by querying the K8s API                 | `false`                                                 |
| `externalAccess.autoDiscovery.image.registry`     | Init container auto-discovery image registry (kubectl)                                             | `docker.io`                                             |
| `externalAccess.autoDiscovery.image.repository`   | Init container auto-discovery image name (kubectl)                                                 | `bitnami/kubectl`                                       |
| `externalAccess.autoDiscovery.image.tag`          | Init container auto-discovery image tag (kubectl)                                                  | `{TAG_NAME}`                                            |
| `externalAccess.autoDiscovery.image.pullPolicy`   | Init container auto-discovery image pull policy (kubectl)                                          | `Always`                                                |
| `externalAccess.autoDiscovery.resources.limits`   | Init container auto-discovery resource limits                                                      | `{}`                                                    |
| `externalAccess.autoDiscovery.resources.requests` | Init container auto-discovery resource requests                                                    | `{}`                                                    |
| `externalAccess.service.type`                     | Kubernetes Servive type for external access. It can be NodePort or LoadBalancer                    | `LoadBalancer`                                          |
| `externalAccess.service.port`                     | MongoDB port used for external access when service type is LoadBalancer                            | `27017`                                                 |
| `externalAccess.service.loadBalancerIPs`          | Array of load balancer IPs for MongoDB nodes                                                       | `[]`                                                    |
| `externalAccess.service.loadBalancerSourceRanges` | Address(es) that are allowed when service is LoadBalancer                                          | `[]`                                                    |
| `externalAccess.service.domain`                   | Domain or external IP used to configure MongoDB advertised hostname when service type is NodePort  | `nil`                                                   |
| `externalAccess.service.nodePorts`                | Array of node ports used to configure MongoDB advertised hostname when service type is NodePort    | `[]`                                                    |
| `externalAccess.service.annotations`              | Service annotations for external access                                                            | `{}`(evaluated as a template)                           |

### Persistence parameters

| Parameter                                 | Description                                                                                                | Default                                                 |
|-------------------------------------------|------------------------------------------------------------------------------------------------------------|---------------------------------------------------------|
| `persistence.enabled`                     | Enable MongoDB data persistence using PVC                                                                  | `true`                                                  |
| `persistence.existingClaim`               | Provide an existing `PersistentVolumeClaim` (only when `architecture=standalone`)                          | `nil` (evaluated as a template)                         |
| `persistence.storageClass`                | PVC Storage Class for MongoDB data volume                                                                  | `nil`                                                   |
| `persistence.accessMode`                  | PVC Access Mode for MongoDB data volume                                                                    | `ReadWriteOnce`                                         |
| `persistence.size`                        | PVC Storage Request for MongoDB data volume                                                                | `8Gi`                                                   |
| `persistence.mountPath`                   | Path to mount the volume at                                                                                | `/bitnami/mongodb`                                      |
| `persistence.subPath`                     | Subdirectory of the volume to mount at                                                                     | `""`                                                    |

### RBAC parameters

| Parameter                                 | Description                                                                                                | Default                                                 |
|-------------------------------------------|------------------------------------------------------------------------------------------------------------|---------------------------------------------------------|
| `serviceAccount.create`                   | Enable creation of ServiceAccount for MongoDB pods                                                         | `true`                                                  |
| `serviceAccount.name`                     | Name of the created serviceAccount                                                                         | Generated using the `mongodb.fullname` template         |
| `rbac.create`                             | Weather to create & use RBAC resources or not                                                              | `false`                                                 |

### Volume Permissions parameters

| Parameter                                 | Description                                                                                                          | Default                                                      |
|-------------------------------------------|----------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------|
| `volumePermissions.enabled`               | Enable init container that changes the owner and group of the persistent volume(s) mountpoint to `runAsUser:fsGroup` | `false`                                                      |
| `volumePermissions.image.registry`        | Init container volume-permissions image registry                                                                     | `docker.io`                                                  |
| `volumePermissions.image.repository`      | Init container volume-permissions image name                                                                         | `bitnami/minideb`                                            |
| `volumePermissions.image.tag`             | Init container volume-permissions image tag                                                                          | `buster`                                                     |
| `volumePermissions.image.pullPolicy`      | Init container volume-permissions image pull policy                                                                  | `Always`                                                     |
| `volumePermissions.image.pullSecrets`     | Specify docker-registry secret names as an array                                                                     | `[]` (does not add image pull secrets to deployed pods)      |
| `volumePermissions.resources.limits`      | Init container volume-permissions resource  limits                                                                   | `{}`                                                         |
| `volumePermissions.resources.requests`    | Init container volume-permissions resource  requests                                                                 | `{}`                                                         |

### Arbiter parameters

| Parameter                                 | Description                                                                                                | Default                                                      |
|-------------------------------------------|------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------|
| `arbiter.configuration`                   | Arbiter configuration file to be used                                                                      | `{}`                                                         |
| `arbiter.existingConfigmap`               | Name of existing ConfigMap with Arbiter configuration                                                      | `nil`                                                        |
| `arbiter.command`                         | Override default container command (useful when using custom images)                                       | `nil`                                                        |
| `arbiter.args`                            | Override default container args (useful when using custom images)                                          | `nil`                                                        |
| `arbiter.extraFlags`                      | Arbiter additional command line flags                                                                      | `[]`                                                         |
| `arbiter.extraEnvVars`                    | Extra environment variables to add to Arbiter pods                                                         | `[]`                                                         |
| `arbiter.extraEnvVarsCM`                  | Name of existing ConfigMap containing extra env vars                                                       | `nil`                                                        |
| `arbiter.extraEnvVarsSecret`              | Name of existing Secret containing extra env vars (in case of sensitive data)                              | `nil`                                                        |
| `arbiter.labels`                          | Annotations to be added to the Arbiter statefulset                                                         | `{}` (evaluated as a template)                               |
| `arbiter.annotations`                     | Additional labels to be added to the Arbiter statefulset                                                   | `{}` (evaluated as a template)                               |
| `arbiter.podLabels`                       | Arbiter pod labels                                                                                         | `{}` (evaluated as a template)                               |
| `arbiter.podAnnotations`                  | Arbiter Pod annotations                                                                                    | `{}` (evaluated as a template)                               |
| `arbiter.priorityClassName`               | Name of the existing priority class to be used by Arbiter pod(s)                                           | `""`                                                         |
| `arbiter.affinity`                        | Affinity for Arbiter pod(s) assignment                                                                     | `{}` (evaluated as a template)                               |
| `arbiter.nodeSelector`                    | Node labels for Arbiter pod(s) assignment                                                                  | `{}` (evaluated as a template)                               |
| `arbiter.tolerations`                     | Tolerations for Arbiter pod(s) assignment                                                                  | `[]` (evaluated as a template)                               |
| `arbiter.podSecurityContext`              | Arbiter pod(s)' Security Context                                                                           | Check `values.yaml` file                                     |
| `arbiter.containerSecurityContext`        | Arbiter containers' Security Context                                                                       | Check `values.yaml` file                                     |
| `arbiter.resources.limits`                | The resources limits for Arbiter containers                                                                | `{}`                                                         |
| `arbiter.resources.requests`              | The requested resources for Arbiter containers                                                             | `{}`                                                         |
| `arbiter.livenessProbe`                   | Liveness probe configuration for Arbiter                                                                   | Check `values.yaml` file                                     |
| `arbiter.readinessProbe`                  | Readiness probe configuration for Arbiter                                                                  | Check `values.yaml` file                                     |
| `arbiter.customLivenessProbe`             | Override default liveness probe for Arbiter containers                                                     | `nil`                                                        |
| `arbiter.customReadinessProbe`            | Override default readiness probe for Arbiter containers                                                    | `nil`                                                        |
| `arbiter.pdb.create`                      | Enable/disable a Pod Disruption Budget creation for Arbiter pod(s)                                         | `false`                                                      |
| `arbiter.pdb.minAvailable`                | Minimum number/percentage of Arbiter pods that should remain scheduled                                     | `nil`                                                        |
| `arbiter.pdb.maxUnavailable`              | Maximum number/percentage of Arbiter pods that may be made unavailable                                     | `1`                                                          |
| `arbiter.initContainers`                  | Add additional init containers for the Arbiter pod(s)                                                      | `{}` (evaluated as a template)                               |
| `arbiter.sidecars`                        | Add additional sidecar containers for the Arbiter pod(s)                                                   | `{}` (evaluated as a template)                               |
| `arbiter.extraVolumeMounts`               | Optionally specify extra list of additional volumeMounts for the Arbiter container(s)                      | `{}`                                                         |
| `arbiter.extraVolumes`                    | Optionally specify extra list of additional volumes to the Arbiter statefulset                             | `{}`                                                         |

### Metrics parameters

| Parameter                                 | Description                                                                                                | Default                                                      |
|-------------------------------------------|------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------|
| `metrics.enabled`                         | Enable using a sidecar Prometheus exporter                                                                 | `false`                                                      |
| `metrics.image.registry`                  | MongoDB Prometheus exporter image registry                                                                 | `docker.io`                                                  |
| `metrics.image.repository`                | MongoDB Prometheus exporter image name                                                                     | `bitnami/mongodb-exporter`                                   |
| `metrics.image.tag`                       | MongoDB Prometheus exporter image tag                                                                      | `{TAG_NAME}`                                                 |
| `metrics.image.pullPolicy`                | MongoDB Prometheus exporter image pull policy                                                              | `Always`                                                     |
| `metrics.image.pullSecrets`               | Specify docker-registry secret names as an array                                                           | `[]` (does not add image pull secrets to deployed pods)      |
| `metrics.extraFlags`                      | Arbiter additional command line flags                                                                      | `""`                                                         |
| `metrics.service.type`                    | Type of the Prometheus metrics service                                                                     | `ClusterIP file`                                             |
| `metrics.service.port`                    | Port of the Prometheus metrics service                                                                     | `9216`                                                       |
| `metrics.service.annotations`             | Annotations for Prometheus metrics service                                                                 | Check `values.yaml` file                                     |
| `metrics.resources.limits`                | The resources limits for Prometheus exporter  containers                                                   | `{}`                                                         |
| `metrics.resources.requests`              | The requested resources for Prometheus exporter  containers                                                | `{}`                                                         |
| `metrics.livenessProbe`                   | Liveness probe configuration for Prometheus exporter                                                       | Check `values.yaml` file                                     |
| `metrics.readinessProbe`                  | Readiness probe configuration for Prometheus exporter                                                      | Check `values.yaml` file                                     |
| `metrics.serviceMonitor.enabled`          | Create ServiceMonitor Resource for scraping metrics using Prometheus Operator                              | `false`                                                      |
| `metrics.serviceMonitor.namespace`        | Namespace which Prometheus is running in                                                                   | `monitoring`                                                 |
| `metrics.serviceMonitor.interval`         | Interval at which metrics should be scraped                                                                | `30s`                                                        |
| `metrics.serviceMonitor.scrapeTimeout`    | Specify the timeout after which the scrape is ended                                                        | `nil`                                                        |
| `metrics.serviceMonitor.additionalLabels` | Used to pass Labels that are required by the Installed Prometheus Operator                                 | `{}`                                                         |
| `metrics.prometheusRule.enabled`          | Set this to true to create prometheusRules for Prometheus operator                                         | `false`                                                      |
| `metrics.prometheusRule.namespace`        | namespace where prometheusRules resource should be created                                                 | `monitoring`                                                 |
| `metrics.prometheusRule.rules`            | Rules to be created, check values for an example.                                                          | `[]`                                                         |
| `metrics.prometheusRule.additionalLabels` | Additional labels that can be used so prometheusRules will be discovered by Prometheus                     | `{}`                                                         |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install my-release \
    --set auth.rootPassword=secretpassword,auth.username=my-user,auth.password=my-password,auth.database=my-database \
    bitnami/mongodb
```

The above command sets the MongoDB `root` account password to `secretpassword`. Additionally, it creates a standard database user named `my-user`, with the password `my-password`, who has access to a database named `my-database`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install my-release -f values.yaml bitnami/mongodb
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Production configuration and horizontal scaling

This chart includes a `values-production.yaml` file where you can find some parameters oriented to production configuration in comparison to the regular `values.yaml`. You can use this file instead of the default one.

- Switch to enable/disable replica set configuration:

```diff
- architecture: standalone
+ architecture: replicaset
```

- Increase the number of MongoDB nodes:

```diff
- replicaCount: 2
+ replicaCount: 4
```

- Enable Pod Disruption Budget:

```diff
- pdb.create: false
+ pdb.create: true
```

- Enable using a sidecar Prometheus exporter:

```diff
- metrics.enabled: false
+ metrics.enabled: true
```

To horizontally scale this chart, you can use the `--replicaCount` flag to modify the number of secondary nodes in your MongoDB replica set.

### Initialize a fresh instance

The [Bitnami MongoDB](https://github.com/bitnami/bitnami-docker-mongodb) image allows you to use your custom scripts to initialize a fresh instance. In order to execute the scripts, you can specify them using the `initdbScripts` parameter as dict.

You can also set an external ConfigMap with all the initialization scripts. This is done by setting the `initdbScriptsConfigMap` parameter. Note that this will override the previous option.

The allowed extensions are `.sh`, and `.js`.

### Replicaset: Accessing MongoDB nodes from outside the cluster

In order to access MongoDB nodes from outside the cluster when using a replicaset architecture, a specific service per MongoDB pod will be created. There are two ways of configuring external access:

- Using LoadBalancer services
- Using NodePort services.

#### Using LoadBalancer services

You have two alternatives to use LoadBalancer services:

- Option A) Use random load balancer IPs using an **initContainer** that waits for the IPs to be ready and discover them automatically.

```console
architecture=replicaset
replicaCount=2
externalAccess.enabled=true
externalAccess.service.type=LoadBalancer
externalAccess.service.port=27017
externalAccess.autoDiscovery.enabled=true
serviceAccount.create=true
rbac.create=true
```

> Note: This option requires creating RBAC rules on clusters where RBAC policies are enabled.

- Option B) Manually specify the load balancer IPs:

```console
architecture=replicaset
replicaCount=2
externalAccess.enabled=true
externalAccess.service.type=LoadBalancer
externalAccess.service.port=27017
externalAccess.service.loadBalancerIPs[0]='external-ip-1'
externalAccess.service.loadBalancerIPs[1]='external-ip-2'}
```

> Note: You need to know in advance the load balancer IPs so each MongoDB node advertised hostname is configured with it.

#### Using NodePort services

Manually specify the node ports to use:

```console
architecture=replicaset
replicaCount=2
externalAccess.enabled=true
externalAccess.service.type=NodePort
externalAccess.serivce.nodePorts[0]='node-port-1'
externalAccess.serivce.nodePorts[1]='node-port-2'
```

> Note: You need to know in advance the node ports that will be exposed so each MongoDB node advertised hostname is configured with it.

The pod will try to get the external ip of the node using `curl -s https://ipinfo.io/ip` unless `externalAccess.service.domain` is provided.

### Adding extra environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `extraEnvVars` property.

```yaml
extraEnvVars:
  - name: LOG_LEVEL
    value: error
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` properties.

### Sidecars and Init Containers

If you have a need for additional containers to run within the same pod as MongoDB (e.g. an additional metrics or logging exporter), you can do so via the `sidecars` config parameter. Simply define your container according to the Kubernetes container spec.

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

## Persistence

The [Bitnami MongoDB](https://github.com/bitnami/bitnami-docker-mongodb) image stores the MongoDB data and configurations at the `/bitnami/mongodb` path of the container.

The chart mounts a [Persistent Volume](http://kubernetes.io/docs/user-guide/persistent-volumes/) at this location. The volume is created using dynamic volume provisioning.

### Adjust permissions of persistent volume mountpoint

As the image run as non-root by default, it is necessary to adjust the ownership of the persistent volume so that the container can write data into it. By default, the chart is configured to use Kubernetes Security Context to automatically change the ownership of the volume. However, this feature does not work in all Kubernetes distributions.

As an alternative, this chart supports using an initContainer to change the ownership of the volume before mounting it in the final destination. You can enable this initContainer by setting `volumePermissions.enabled` to `true`.

## Upgrading

If authentication is enabled, it's necessary to set the `auth.rootPassword` (also `auth.replicaSetKey` when using a replicaset architecture) when upgrading for readiness/liveness probes to work properly. When you install this chart for the first time, some notes will be displayed providing the credentials you must use under the 'Credentials' section. Please note down the password, and run the command below to upgrade your chart:

```bash
$ helm upgrade my-release bitnami/mongodb --set auth.rootPassword=[PASSWORD] (--set auth.replicaSetKey=[REPLICASETKEY])
```

> Note: you need to substitute the placeholders [PASSWORD] and [REPLICASETKEY] with the values obtained in the installation notes.

### To 8.0.0

- Architecture used to configure MongoDB as a replicaset was completely refactored. Now, both primary and secondary nodes are part of the same statefulset.
- Chart labels were adapted to follow the Helm charts best practices.
- This version introduces `bitnami/common`, a [library chart](https://helm.sh/docs/topics/library_charts/#helm) as a dependency. More documentation about this new utility could be found [here](https://github.com/bitnami/charts/tree/master/bitnami/common#bitnami-common-library-chart). Please, make sure that you have updated the chart dependencies before executing any upgrade.
- Several parameters were renamed or dissapeared in favor of new ones on this major version. These are the most important ones:
  - `replicas` is renamed to `replicaCount`.
  - Authentication parameters are reorganized under the `auth.*` parameter:
    - `usePassword` is renamed to `auth.enabled`.
    - `mongodbRootPassword`, `mongodbUsername`, `mongodbPassword`, `mongodbDatabase`, and `replicaSet.key` are now `auth.rootPassword`, `auth.username`, `auth.password`, `auth.database`, and `auth.replicaSetKey` respectively.
  - `securityContext.*` is deprecated in favor of `podSecurityContext` and `containerSecurityContext`.
  - Parameters prefixed with `mongodb` are renamed removing the prefix. E.g. `mongodbEnableIPv6` is renamed to `enableIPv6`.
  - Parameters affecting Arbiter nodes are reorganized under the `arbiter.*` parameter.

Consequences:

- Backwards compatibility is not guaranteed. To upgrade to `8.0.0`, install a new release of the MongoDB chart, and migrate your data by creating a backup of the database, and restoring it on the new release.

### To 7.0.0

From this version, the way of setting the ingress rules has changed. Instead of using `ingress.paths` and `ingress.hosts` as separate objects, you should now define the rules as objects inside the `ingress.hosts` value, for example:

```yaml
ingress:
  hosts:
  - name: mongodb.local
    path: /
```

### To 6.0.0

From this version, `mongodbEnableIPv6` is set to `false` by default in order to work properly in most k8s clusters, if you want to use IPv6 support, you need to set this variable to `true` by adding `--set mongodbEnableIPv6=true` to your `helm` command.
You can find more information in the [`bitnami/mongodb` image README](https://github.com/bitnami/bitnami-docker-mongodb/blob/master/README.md).

### To 5.0.0

When enabling replicaset configuration, backwards compatibility is not guaranteed unless you modify the labels used on the chart's statefulsets.
Use the workaround below to upgrade from versions previous to 5.0.0. The following example assumes that the release name is `my-release`:

```console
$ kubectl delete statefulset my-release-mongodb-arbiter my-release-mongodb-primary my-release-mongodb-secondary --cascade=false
```
