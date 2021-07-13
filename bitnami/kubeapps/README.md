# Kubeapps

[![CircleCI](https://circleci.com/gh/kubeapps/kubeapps/tree/master.svg?style=svg)](https://circleci.com/gh/kubeapps/kubeapps/tree/master)

[Kubeapps](https://kubeapps.com) is an in-cluster web-based application that enables users with a one-time installation to deploy, manage, and upgrade applications on a Kubernetes cluster.

With Kubeapps you can:

- Customize deployments through an intuitive, form-based user interface
- Inspect, upgrade and delete applications installed in the cluster
- Browse and deploy [Helm](https://github.com/helm/helm) charts from public or private chart repositories (including [VMware Marketplace™](https://marketplace.cloud.vmware.com) and [Bitnami Application Catalog](https://bitnami.com/application-catalog))
- Browse and deploy [Kubernetes Operators](https://operatorhub.io/)
- Secure authentication to Kubeapps using a [standalone OAuth2/OIDC provider](./docs/user/using-an-OIDC-provider.md) or [using Pinniped](./docs/user/using-an-OIDC-provider-with-pinniped.md)
- Secure authorization based on Kubernetes [Role-Based Access Control](./docs/user/access-control.md)

**_Note:_** Kubeapps 2.0 and onwards supports Helm 3 only. While only the Helm 3 API is supported, in most cases, charts made for Helm 2 will still work.

## TL;DR

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
kubectl create namespace kubeapps
helm install kubeapps --namespace kubeapps bitnami/kubeapps
```

> Check out the [getting started](https://github.com/kubeapps/kubeapps/blob/master/docs/user/getting-started.md) to start deploying apps with Kubeapps.

## Introduction

This chart bootstraps a [Kubeapps](https://kubeapps.com) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages the [Bitnami PostgreSQL chart](https://github.com/bitnami/charts/tree/master/bitnami/postgresql) which is required for bootstrapping a deployment for the database requirements of the Kubeapps application.

## Prerequisites

- Kubernetes 1.16+ (tested with both bare-metal and managed clusters, including EKS, AKS, GKE and Tanzu Kubernetes Grid, as well as dev clusters, such as Kind, Minikube and Docker for Desktop Kubernetes)
- Helm 3.0.2+
- Administrative access to the cluster to create Custom Resource Definitions (CRDs)
- PV provisioner support in the underlying infrastructure (required for PostgreSQL database)

## Installing the Chart

To install the chart with the release name `kubeapps`:

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
kubectl create namespace kubeapps
helm install kubeapps --namespace kubeapps bitnami/kubeapps
```

The command deploys Kubeapps on the Kubernetes cluster in the `kubeapps` namespace. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Caveat**: Only one Kubeapps installation is supported per namespace

Once you have installed Kubeapps follow the [Getting Started Guide](https://github.com/kubeapps/kubeapps/blob/master/docs/user/getting-started.md) for additional information on how to access and use Kubeapps.

## Parameters

### Global parameters

| Name                      | Description                                     | Value |
| ------------------------- | ----------------------------------------------- | ----- |
| `global.imageRegistry`    | Global Docker image registry                    | `nil` |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]`  |
| `global.storageClass`     | Global StorageClass for Persistent Volume(s)    | `nil` |


### Common parameters

| Name                | Description                                        | Value   |
| ------------------- | -------------------------------------------------- | ------- |
| `kubeVersion`       | Override Kubernetes version                        | `nil`   |
| `nameOverride`      | String to partially override common.names.fullname | `nil`   |
| `fullnameOverride`  | String to fully override common.names.fullname     | `nil`   |
| `commonLabels`      | Labels to add to all deployed objects              | `{}`    |
| `commonAnnotations` | Annotations to add to all deployed objects         | `{}`    |
| `extraDeploy`       | Array of extra objects to deploy with the release  | `[]`    |
| `enableIPv6`        | Enable IPv6 configuration                          | `false` |


### Traffic Exposure Parameters

| Name                  | Description                                                                                           | Value                    |
| --------------------- | ----------------------------------------------------------------------------------------------------- | ------------------------ |
| `ingress.enabled`     | Enable ingress record generation for Kubeapps                                                         | `false`                  |
| `ingress.apiVersion`  | Force Ingress API version (automatically detected if not set)                                         | `nil`                    |
| `ingress.hostname`    | Default host for the ingress record                                                                   | `kubeapps.local`         |
| `ingress.path`        | Default path for the ingress record                                                                   | `/`                      |
| `ingress.pathType`    | Ingress path type                                                                                     | `ImplementationSpecific` |
| `ingress.annotations` | Additional custom annotations for the ingress record                                                  | `{}`                     |
| `ingress.tls`         | Enable TLS configuration for the host defined at `ingress.hostname` parameter                         | `false`                  |
| `ingress.certManager` | Add the corresponding annotations for cert-manager integration                                        | `false`                  |
| `ingress.selfSigned`  | Create a TLS secret for this ingress record using self-signed certificates generated by Helm          | `false`                  |
| `ingress.extraHosts`  | An array with additional hostname(s) to be covered with the ingress record                            | `[]`                     |
| `ingress.extraPaths`  | An array with additional arbitrary paths that may need to be added to the ingress under the main host | `[]`                     |
| `ingress.extraTls`    | TLS configuration for additional hostname(s) to be covered with this ingress record                   | `[]`                     |
| `ingress.secrets`     | Custom TLS certificates as secrets                                                                    | `[]`                     |


### Frontend parameters

| Name                                             | Description                                                                               | Value                 |
| ------------------------------------------------ | ----------------------------------------------------------------------------------------- | --------------------- |
| `frontend.image.registry`                        | NGINX image registry                                                                      | `docker.io`           |
| `frontend.image.repository`                      | NGINX image repository                                                                    | `bitnami/nginx`       |
| `frontend.image.tag`                             | NGINX image tag (immutable tags are recommended)                                          | `1.21.1-debian-10-r1` |
| `frontend.image.pullPolicy`                      | NGINX image pull policy                                                                   | `IfNotPresent`        |
| `frontend.image.pullSecrets`                     | NGINX image pull secrets                                                                  | `[]`                  |
| `frontend.image.debug`                           | Enable image debug mode                                                                   | `false`               |
| `frontend.proxypassAccessTokenAsBearer`          | Use access_token as the Bearer when talking to the k8s api server                         | `false`               |
| `frontend.proxypassExtraSetHeader`               | Set an additional proxy header for all requests proxied via NGINX                         | `nil`                 |
| `frontend.largeClientHeaderBuffers`              | Set large_client_header_buffers in NGINX config                                           | `4 32k`               |
| `frontend.replicaCount`                          | Number of frontend replicas to deploy                                                     | `2`                   |
| `frontend.resources.limits.cpu`                  | The CPU limits for the NGINX container                                                    | `250m`                |
| `frontend.resources.limits.memory`               | The memory limits for the NGINX container                                                 | `128Mi`               |
| `frontend.resources.requests.cpu`                | The requested CPU for the NGINX container                                                 | `25m`                 |
| `frontend.resources.requests.memory`             | The requested memory for the NGINX container                                              | `32Mi`                |
| `frontend.extraEnvVars`                          | Array with extra environment variables to add to the NGINX container                      | `[]`                  |
| `frontend.extraEnvVarsCM`                        | Name of existing ConfigMap containing extra env vars for the NGINX container              | `nil`                 |
| `frontend.extraEnvVarsSecret`                    | Name of existing Secret containing extra env vars for the NGINX container                 | `nil`                 |
| `frontend.containerPort`                         | NGINX HTTP container port                                                                 | `8080`                |
| `frontend.podSecurityContext.enabled`            | Enabled frontend pods' Security Context                                                   | `true`                |
| `frontend.podSecurityContext.fsGroup`            | Set frontend pod's Security Context fsGroup                                               | `1001`                |
| `frontend.containerSecurityContext.enabled`      | Enabled NGINX containers' Security Context                                                | `true`                |
| `frontend.containerSecurityContext.runAsUser`    | Set NGINX container's Security Context runAsUser                                          | `1001`                |
| `frontend.containerSecurityContext.runAsNonRoot` | Set NGINX container's Security Context runAsNonRoot                                       | `true`                |
| `frontend.livenessProbe.enabled`                 | Enable livenessProbe                                                                      | `true`                |
| `frontend.livenessProbe.initialDelaySeconds`     | Initial delay seconds for livenessProbe                                                   | `60`                  |
| `frontend.livenessProbe.periodSeconds`           | Period seconds for livenessProbe                                                          | `10`                  |
| `frontend.livenessProbe.timeoutSeconds`          | Timeout seconds for livenessProbe                                                         | `5`                   |
| `frontend.livenessProbe.failureThreshold`        | Failure threshold for livenessProbe                                                       | `6`                   |
| `frontend.livenessProbe.successThreshold`        | Success threshold for livenessProbe                                                       | `1`                   |
| `frontend.readinessProbe.enabled`                | Enable readinessProbe                                                                     | `true`                |
| `frontend.readinessProbe.initialDelaySeconds`    | Initial delay seconds for readinessProbe                                                  | `0`                   |
| `frontend.readinessProbe.periodSeconds`          | Period seconds for readinessProbe                                                         | `10`                  |
| `frontend.readinessProbe.timeoutSeconds`         | Timeout seconds for readinessProbe                                                        | `5`                   |
| `frontend.readinessProbe.failureThreshold`       | Failure threshold for readinessProbe                                                      | `6`                   |
| `frontend.readinessProbe.successThreshold`       | Success threshold for readinessProbe                                                      | `1`                   |
| `frontend.customLivenessProbe`                   | Custom livenessProbe that overrides the default one                                       | `{}`                  |
| `frontend.customReadinessProbe`                  | Custom readinessProbe that overrides the default one                                      | `{}`                  |
| `frontend.lifecycleHooks`                        | Custom lifecycle hooks for frontend containers                                            | `{}`                  |
| `frontend.podLabels`                             | Extra labels for frontend pods                                                            | `{}`                  |
| `frontend.podAnnotations`                        | Annotations for frontend pods                                                             | `{}`                  |
| `frontend.podAffinityPreset`                     | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`       | `""`                  |
| `frontend.podAntiAffinityPreset`                 | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`  | `soft`                |
| `frontend.nodeAffinityPreset.type`               | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard` | `""`                  |
| `frontend.nodeAffinityPreset.key`                | Node label key to match. Ignored if `affinity` is set                                     | `""`                  |
| `frontend.nodeAffinityPreset.values`             | Node label values to match. Ignored if `affinity` is set                                  | `[]`                  |
| `frontend.affinity`                              | Affinity for pod assignment                                                               | `{}`                  |
| `frontend.nodeSelector`                          | Node labels for pod assignment                                                            | `{}`                  |
| `frontend.tolerations`                           | Tolerations for pod assignment                                                            | `[]`                  |
| `frontend.priorityClassName`                     | Priority class name for frontend pods                                                     | `nil`                 |
| `frontend.hostAliases`                           | Custom host aliases for frontend pods                                                     | `[]`                  |
| `frontend.extraVolumes`                          | Optionally specify extra list of additional volumes for frontend pods                     | `[]`                  |
| `frontend.extraVolumeMounts`                     | Optionally specify extra list of additional volumeMounts for frontend container(s)        | `[]`                  |
| `frontend.sidecars`                              | Add additional sidecar containers to the frontend pod                                     | `{}`                  |
| `frontend.initContainers`                        | Add additional init containers to the frontend pods                                       | `{}`                  |
| `frontend.service.type`                          | Frontend service type                                                                     | `ClusterIP`           |
| `frontend.service.port`                          | Frontend service HTTP port                                                                | `80`                  |
| `frontend.service.nodePort`                      | Node port for HTTP                                                                        | `nil`                 |
| `frontend.service.clusterIP`                     | Frontend service Cluster IP                                                               | `nil`                 |
| `frontend.service.loadBalancerIP`                | Frontend service Load Balancer IP                                                         | `nil`                 |
| `frontend.service.loadBalancerSourceRanges`      | Frontend service Load Balancer sources                                                    | `[]`                  |
| `frontend.service.externalTrafficPolicy`         | Frontend service external traffic policy                                                  | `Cluster`             |
| `frontend.service.annotations`                   | Additional custom annotations for frontend service                                        | `{}`                  |


### Dashboard parameters

| Name                                              | Description                                                                               | Value                        |
| ------------------------------------------------- | ----------------------------------------------------------------------------------------- | ---------------------------- |
| `dashboard.image.registry`                        | Dashboard image registry                                                                  | `docker.io`                  |
| `dashboard.image.repository`                      | Dashboard image repository                                                                | `bitnami/kubeapps-dashboard` |
| `dashboard.image.tag`                             | Dashboard image tag (immutable tags are recommended)                                      | `2.3.3-debian-10-r0`         |
| `dashboard.image.pullPolicy`                      | Dashboard image pull policy                                                               | `IfNotPresent`               |
| `dashboard.image.pullSecrets`                     | Dashboard image pull secrets                                                              | `[]`                         |
| `dashboard.image.debug`                           | Enable image debug mode                                                                   | `false`                      |
| `dashboard.customStyle`                           | Custom CSS injected to the Dashboard to customize Kubeapps look and feel                  | `""`                         |
| `dashboard.customComponents`                      | Custom Form components injected into the BasicDeploymentForm                              | `""`                         |
| `dashboard.customLocale`                          | Custom translations injected to the Dashboard to customize the strings used in Kubeapps   | `""`                         |
| `dashboard.replicaCount`                          | Number of Dashboard replicas to deploy                                                    | `2`                          |
| `dashboard.extraEnvVars`                          | Array with extra environment variables to add to the Dashboard container                  | `[]`                         |
| `dashboard.extraEnvVarsCM`                        | Name of existing ConfigMap containing extra env vars for the Dashboard container          | `nil`                        |
| `dashboard.extraEnvVarsSecret`                    | Name of existing Secret containing extra env vars for the Dashboard container             | `nil`                        |
| `dashboard.containerPort`                         | Dashboard HTTP container port                                                             | `8080`                       |
| `dashboard.resources.limits.cpu`                  | The CPU limits for the Dashboard container                                                | `250m`                       |
| `dashboard.resources.limits.memory`               | The memory limits for the Dashboard container                                             | `128Mi`                      |
| `dashboard.resources.requests.cpu`                | The requested CPU for the Dashboard container                                             | `25m`                        |
| `dashboard.resources.requests.memory`             | The requested memory for the Dashboard container                                          | `32Mi`                       |
| `dashboard.podSecurityContext.enabled`            | Enabled Dashboard pods' Security Context                                                  | `true`                       |
| `dashboard.podSecurityContext.fsGroup`            | Set Dashboard pod's Security Context fsGroup                                              | `1001`                       |
| `dashboard.containerSecurityContext.enabled`      | Enabled Dashboard containers' Security Context                                            | `true`                       |
| `dashboard.containerSecurityContext.runAsUser`    | Set Dashboard container's Security Context runAsUser                                      | `1001`                       |
| `dashboard.containerSecurityContext.runAsNonRoot` | Set Dashboard container's Security Context runAsNonRoot                                   | `true`                       |
| `dashboard.livenessProbe.enabled`                 | Enable livenessProbe                                                                      | `true`                       |
| `dashboard.livenessProbe.initialDelaySeconds`     | Initial delay seconds for livenessProbe                                                   | `60`                         |
| `dashboard.livenessProbe.periodSeconds`           | Period seconds for livenessProbe                                                          | `10`                         |
| `dashboard.livenessProbe.timeoutSeconds`          | Timeout seconds for livenessProbe                                                         | `5`                          |
| `dashboard.livenessProbe.failureThreshold`        | Failure threshold for livenessProbe                                                       | `6`                          |
| `dashboard.livenessProbe.successThreshold`        | Success threshold for livenessProbe                                                       | `1`                          |
| `dashboard.readinessProbe.enabled`                | Enable readinessProbe                                                                     | `true`                       |
| `dashboard.readinessProbe.initialDelaySeconds`    | Initial delay seconds for readinessProbe                                                  | `0`                          |
| `dashboard.readinessProbe.periodSeconds`          | Period seconds for readinessProbe                                                         | `10`                         |
| `dashboard.readinessProbe.timeoutSeconds`         | Timeout seconds for readinessProbe                                                        | `5`                          |
| `dashboard.readinessProbe.failureThreshold`       | Failure threshold for readinessProbe                                                      | `6`                          |
| `dashboard.readinessProbe.successThreshold`       | Success threshold for readinessProbe                                                      | `1`                          |
| `dashboard.customLivenessProbe`                   | Custom livenessProbe that overrides the default one                                       | `{}`                         |
| `dashboard.customReadinessProbe`                  | Custom readinessProbe that overrides the default one                                      | `{}`                         |
| `dashboard.lifecycleHooks`                        | Custom lifecycle hooks for Dashboard containers                                           | `{}`                         |
| `dashboard.podLabels`                             | Extra labels for Dasbhoard pods                                                           | `{}`                         |
| `dashboard.podAnnotations`                        | Annotations for Dasbhoard pods                                                            | `{}`                         |
| `dashboard.podAffinityPreset`                     | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`       | `""`                         |
| `dashboard.podAntiAffinityPreset`                 | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`  | `soft`                       |
| `dashboard.nodeAffinityPreset.type`               | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard` | `""`                         |
| `dashboard.nodeAffinityPreset.key`                | Node label key to match. Ignored if `affinity` is set                                     | `""`                         |
| `dashboard.nodeAffinityPreset.values`             | Node label values to match. Ignored if `affinity` is set                                  | `[]`                         |
| `dashboard.affinity`                              | Affinity for pod assignment                                                               | `{}`                         |
| `dashboard.nodeSelector`                          | Node labels for pod assignment                                                            | `{}`                         |
| `dashboard.tolerations`                           | Tolerations for pod assignment                                                            | `[]`                         |
| `dashboard.priorityClassName`                     | Priority class name for Dashboard pods                                                    | `nil`                        |
| `dashboard.hostAliases`                           | Custom host aliases for Dashboard pods                                                    | `[]`                         |
| `dashboard.extraVolumes`                          | Optionally specify extra list of additional volumes for Dasbhoard pods                    | `[]`                         |
| `dashboard.extraVolumeMounts`                     | Optionally specify extra list of additional volumeMounts for Dasbhoard container(s)       | `[]`                         |
| `dashboard.sidecars`                              | Add additional sidecar containers to the Dasbhoard pod                                    | `{}`                         |
| `dashboard.initContainers`                        | Add additional init containers to the Dasbhoard pods                                      | `{}`                         |
| `dashboard.service.port`                          | Dasbhoard service HTTP port                                                               | `8080`                       |
| `dashboard.service.annotations`                   | Additional custom annotations for Dasbhoard service                                       | `{}`                         |


### AppRepository Controller parameters

| Name                                                  | Description                                                                               | Value                                       |
| ----------------------------------------------------- | ----------------------------------------------------------------------------------------- | ------------------------------------------- |
| `apprepository.image.registry`                        | Kubeapps AppRepository Controller image registry                                          | `docker.io`                                 |
| `apprepository.image.repository`                      | Kubeapps AppRepository Controller image repository                                        | `bitnami/kubeapps-apprepository-controller` |
| `apprepository.image.tag`                             | Kubeapps AppRepository Controller image tag (immutable tags are recommended)              | `2.3.3-scratch-r0`                          |
| `apprepository.image.pullPolicy`                      | Kubeapps AppRepository Controller image pull policy                                       | `IfNotPresent`                              |
| `apprepository.image.pullSecrets`                     | Kubeapps AppRepository Controller image pull secrets                                      | `[]`                                        |
| `apprepository.syncImage.registry`                    | Kubeapps Asset Syncer image registry                                                      | `docker.io`                                 |
| `apprepository.syncImage.repository`                  | Kubeapps Asset Syncer image repository                                                    | `bitnami/kubeapps-asset-syncer`             |
| `apprepository.syncImage.tag`                         | Kubeapps Asset Syncer image tag (immutable tags are recommended)                          | `2.3.3-scratch-r0`                          |
| `apprepository.syncImage.pullPolicy`                  | Kubeapps Asset Syncer image pull policy                                                   | `IfNotPresent`                              |
| `apprepository.syncImage.pullSecrets`                 | Kubeapps Asset Syncer image pull secrets                                                  | `[]`                                        |
| `apprepository.initialRepos`                          | Initial chart repositories to configure                                                   | `[]`                                        |
| `apprepository.initialReposProxy`                     | Proxy configuration to access chart repositories                                          | `{}`                                        |
| `apprepository.crontab`                               | Schedule for syncing App repositories (default to 10 minutes)                             | `nil`                                       |
| `apprepository.watchAllNamespaces`                    | Watch all namespaces to support separate AppRepositories per namespace                    | `true`                                      |
| `apprepository.replicaCount`                          | Number of AppRepository Controller replicas to deploy                                     | `1`                                         |
| `apprepository.resources.limits.cpu`                  | The CPU limits for the AppRepository Controller container                                 | `250m`                                      |
| `apprepository.resources.limits.memory`               | The memory limits for the AppRepository Controller container                              | `128Mi`                                     |
| `apprepository.resources.requests.cpu`                | The requested CPU for the AppRepository Controller container                              | `25m`                                       |
| `apprepository.resources.requests.memory`             | The requested memory for the AppRepository Controller container                           | `32Mi`                                      |
| `apprepository.podSecurityContext.enabled`            | Enabled AppRepository Controller pods' Security Context                                   | `true`                                      |
| `apprepository.podSecurityContext.fsGroup`            | Set AppRepository Controller pod's Security Context fsGroup                               | `1001`                                      |
| `apprepository.containerSecurityContext.enabled`      | Enabled AppRepository Controller containers' Security Context                             | `true`                                      |
| `apprepository.containerSecurityContext.runAsUser`    | Set AppRepository Controller container's Security Context runAsUser                       | `1001`                                      |
| `apprepository.containerSecurityContext.runAsNonRoot` | Set AppRepository Controller container's Security Context runAsNonRoot                    | `true`                                      |
| `apprepository.lifecycleHooks`                        | Custom lifecycle hooks for AppRepository Controller containers                            | `{}`                                        |
| `apprepository.podLabels`                             | Extra labels for AppRepository Controller pods                                            | `{}`                                        |
| `apprepository.podAnnotations`                        | Annotations for AppRepository Controller pods                                             | `{}`                                        |
| `apprepository.podAffinityPreset`                     | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`       | `""`                                        |
| `apprepository.podAntiAffinityPreset`                 | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`  | `soft`                                      |
| `apprepository.nodeAffinityPreset.type`               | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard` | `""`                                        |
| `apprepository.nodeAffinityPreset.key`                | Node label key to match. Ignored if `affinity` is set                                     | `""`                                        |
| `apprepository.nodeAffinityPreset.values`             | Node label values to match. Ignored if `affinity` is set                                  | `[]`                                        |
| `apprepository.affinity`                              | Affinity for pod assignment                                                               | `{}`                                        |
| `apprepository.nodeSelector`                          | Node labels for pod assignment                                                            | `{}`                                        |
| `apprepository.tolerations`                           | Tolerations for pod assignment                                                            | `[]`                                        |
| `apprepository.priorityClassName`                     | Priority class name for AppRepository Controller pods                                     | `nil`                                       |
| `apprepository.hostAliases`                           | Custom host aliases for AppRepository Controller pods                                     | `[]`                                        |


### Kubeops parameters

| Name                                            | Description                                                                               | Value                      |
| ----------------------------------------------- | ----------------------------------------------------------------------------------------- | -------------------------- |
| `kubeops.image.registry`                        | Kubeops image registry                                                                    | `docker.io`                |
| `kubeops.image.repository`                      | Kubeops image repository                                                                  | `bitnami/kubeapps-kubeops` |
| `kubeops.image.tag`                             | Kubeops image tag (immutable tags are recommended)                                        | `2.3.3-scratch-r0`         |
| `kubeops.image.pullPolicy`                      | Kubeops image pull policy                                                                 | `IfNotPresent`             |
| `kubeops.image.pullSecrets`                     | Kubeops image pull secrets                                                                | `[]`                       |
| `kubeops.namespaceHeaderName`                   | Additional header name for trusted namespaces                                             | `nil`                      |
| `kubeops.namespaceHeaderPattern`                | Additional header pattern for trusted namespaces                                          | `nil`                      |
| `kubeops.qps`                                   | Kubeops QPS (queries per second) rate                                                     | `nil`                      |
| `kubeops.burst`                                 | Kubeops burst rate                                                                        | `nil`                      |
| `kubeops.replicaCount`                          | Number of Kubeops replicas to deploy                                                      | `2`                        |
| `kubeops.terminationGracePeriodSeconds`         | The grace time period for sig term                                                        | `300`                      |
| `kubeops.extraEnvVars`                          | Array with extra environment variables to add to the Kubeops container                    | `[]`                       |
| `kubeops.extraEnvVarsCM`                        | Name of existing ConfigMap containing extra env vars for the Kubeops container            | `nil`                      |
| `kubeops.extraEnvVarsSecret`                    | Name of existing Secret containing extra env vars for the Kubeops container               | `nil`                      |
| `kubeops.containerPort`                         | Kubeops HTTP container port                                                               | `8080`                     |
| `kubeops.resources.limits.cpu`                  | The CPU limits for the Kubeops container                                                  | `250m`                     |
| `kubeops.resources.limits.memory`               | The memory limits for the Kubeops container                                               | `256Mi`                    |
| `kubeops.resources.requests.cpu`                | The requested CPU for the Kubeops container                                               | `25m`                      |
| `kubeops.resources.requests.memory`             | The requested memory for the Kubeops container                                            | `32Mi`                     |
| `kubeops.podSecurityContext.enabled`            | Enabled Kubeops pods' Security Context                                                    | `true`                     |
| `kubeops.podSecurityContext.fsGroup`            | Set Kubeops pod's Security Context fsGroup                                                | `1001`                     |
| `kubeops.containerSecurityContext.enabled`      | Enabled Kubeops containers' Security Context                                              | `true`                     |
| `kubeops.containerSecurityContext.runAsUser`    | Set Kubeops container's Security Context runAsUser                                        | `1001`                     |
| `kubeops.containerSecurityContext.runAsNonRoot` | Set Kubeops container's Security Context runAsNonRoot                                     | `true`                     |
| `kubeops.livenessProbe.enabled`                 | Enable livenessProbe                                                                      | `true`                     |
| `kubeops.livenessProbe.initialDelaySeconds`     | Initial delay seconds for livenessProbe                                                   | `60`                       |
| `kubeops.livenessProbe.periodSeconds`           | Period seconds for livenessProbe                                                          | `10`                       |
| `kubeops.livenessProbe.timeoutSeconds`          | Timeout seconds for livenessProbe                                                         | `5`                        |
| `kubeops.livenessProbe.failureThreshold`        | Failure threshold for livenessProbe                                                       | `6`                        |
| `kubeops.livenessProbe.successThreshold`        | Success threshold for livenessProbe                                                       | `1`                        |
| `kubeops.readinessProbe.enabled`                | Enable readinessProbe                                                                     | `true`                     |
| `kubeops.readinessProbe.initialDelaySeconds`    | Initial delay seconds for readinessProbe                                                  | `0`                        |
| `kubeops.readinessProbe.periodSeconds`          | Period seconds for readinessProbe                                                         | `10`                       |
| `kubeops.readinessProbe.timeoutSeconds`         | Timeout seconds for readinessProbe                                                        | `5`                        |
| `kubeops.readinessProbe.failureThreshold`       | Failure threshold for readinessProbe                                                      | `6`                        |
| `kubeops.readinessProbe.successThreshold`       | Success threshold for readinessProbe                                                      | `1`                        |
| `kubeops.customLivenessProbe`                   | Custom livenessProbe that overrides the default one                                       | `{}`                       |
| `kubeops.customReadinessProbe`                  | Custom readinessProbe that overrides the default one                                      | `{}`                       |
| `kubeops.lifecycleHooks`                        | Custom lifecycle hooks for Kubeops containers                                             | `{}`                       |
| `kubeops.podLabels`                             | Extra labels for Kubeops pods                                                             | `{}`                       |
| `kubeops.podAnnotations`                        | Annotations for Kubeops pods                                                              | `{}`                       |
| `kubeops.podAffinityPreset`                     | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`       | `""`                       |
| `kubeops.podAntiAffinityPreset`                 | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`  | `soft`                     |
| `kubeops.nodeAffinityPreset.type`               | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard` | `""`                       |
| `kubeops.nodeAffinityPreset.key`                | Node label key to match. Ignored if `affinity` is set                                     | `""`                       |
| `kubeops.nodeAffinityPreset.values`             | Node label values to match. Ignored if `affinity` is set                                  | `[]`                       |
| `kubeops.affinity`                              | Affinity for pod assignment                                                               | `{}`                       |
| `kubeops.nodeSelector`                          | Node labels for pod assignment                                                            | `{}`                       |
| `kubeops.tolerations`                           | Tolerations for pod assignment                                                            | `[]`                       |
| `kubeops.priorityClassName`                     | Priority class name for Kubeops pods                                                      | `nil`                      |
| `kubeops.hostAliases`                           | Custom host aliases for Kubeops pods                                                      | `[]`                       |
| `kubeops.service.port`                          | Kubeops service HTTP port                                                                 | `8080`                     |
| `kubeops.service.annotations`                   | Additional custom annotations for Kubeops service                                         | `{}`                       |


### Assetsvc parameters

| Name                                             | Description                                                                               | Value                       |
| ------------------------------------------------ | ----------------------------------------------------------------------------------------- | --------------------------- |
| `assetsvc.image.registry`                        | Kubeapps Assetsvc image registry                                                          | `docker.io`                 |
| `assetsvc.image.repository`                      | Kubeapps Assetsvc image repository                                                        | `bitnami/kubeapps-assetsvc` |
| `assetsvc.image.tag`                             | Kubeapps Assetsvc image tag (immutable tags are recommended)                              | `2.3.3-scratch-r0`          |
| `assetsvc.image.pullPolicy`                      | Kubeapps Assetsvc image pull policy                                                       | `IfNotPresent`              |
| `assetsvc.image.pullSecrets`                     | Kubeapps Assetsvc image pull secrets                                                      | `[]`                        |
| `assetsvc.replicaCount`                          | Number of Assetsvc replicas to deploy                                                     | `2`                         |
| `assetsvc.extraEnvVars`                          | Array with extra environment variables to add to the Assetsvc container                   | `[]`                        |
| `assetsvc.extraEnvVarsCM`                        | Name of existing ConfigMap containing extra env vars for the Assetsvc container           | `nil`                       |
| `assetsvc.extraEnvVarsSecret`                    | Name of existing Secret containing extra env vars for the Assetsvc container              | `nil`                       |
| `assetsvc.containerPort`                         | Assetsvc HTTP container port                                                              | `8080`                      |
| `assetsvc.resources.limits.cpu`                  | The CPU limits for the Assetsvc container                                                 | `250m`                      |
| `assetsvc.resources.limits.memory`               | The memory limits for the Assetsvc container                                              | `128Mi`                     |
| `assetsvc.resources.requests.cpu`                | The requested CPU for the Assetsvc container                                              | `25m`                       |
| `assetsvc.resources.requests.memory`             | The requested memory for the Assetsvc container                                           | `32Mi`                      |
| `assetsvc.podSecurityContext.enabled`            | Enabled Assetsvc pods' Security Context                                                   | `true`                      |
| `assetsvc.podSecurityContext.fsGroup`            | Set Assetsvc pod's Security Context fsGroup                                               | `1001`                      |
| `assetsvc.containerSecurityContext.enabled`      | Enabled Assetsvc containers' Security Context                                             | `true`                      |
| `assetsvc.containerSecurityContext.runAsUser`    | Set Assetsvc container's Security Context runAsUser                                       | `1001`                      |
| `assetsvc.containerSecurityContext.runAsNonRoot` | Set Assetsvc container's Security Context runAsNonRoot                                    | `true`                      |
| `assetsvc.livenessProbe.enabled`                 | Enable livenessProbe                                                                      | `true`                      |
| `assetsvc.livenessProbe.initialDelaySeconds`     | Initial delay seconds for livenessProbe                                                   | `60`                        |
| `assetsvc.livenessProbe.periodSeconds`           | Period seconds for livenessProbe                                                          | `10`                        |
| `assetsvc.livenessProbe.timeoutSeconds`          | Timeout seconds for livenessProbe                                                         | `5`                         |
| `assetsvc.livenessProbe.failureThreshold`        | Failure threshold for livenessProbe                                                       | `6`                         |
| `assetsvc.livenessProbe.successThreshold`        | Success threshold for livenessProbe                                                       | `1`                         |
| `assetsvc.readinessProbe.enabled`                | Enable readinessProbe                                                                     | `true`                      |
| `assetsvc.readinessProbe.initialDelaySeconds`    | Initial delay seconds for readinessProbe                                                  | `0`                         |
| `assetsvc.readinessProbe.periodSeconds`          | Period seconds for readinessProbe                                                         | `10`                        |
| `assetsvc.readinessProbe.timeoutSeconds`         | Timeout seconds for readinessProbe                                                        | `5`                         |
| `assetsvc.readinessProbe.failureThreshold`       | Failure threshold for readinessProbe                                                      | `6`                         |
| `assetsvc.readinessProbe.successThreshold`       | Success threshold for readinessProbe                                                      | `1`                         |
| `assetsvc.customLivenessProbe`                   | Custom livenessProbe that overrides the default one                                       | `{}`                        |
| `assetsvc.customReadinessProbe`                  | Custom readinessProbe that overrides the default one                                      | `{}`                        |
| `assetsvc.lifecycleHooks`                        | Custom lifecycle hooks for Assetsvc containers                                            | `{}`                        |
| `assetsvc.podLabels`                             | Extra labels for Assetsvc pods                                                            | `{}`                        |
| `assetsvc.podAnnotations`                        | Annotations for Assetsvc pods                                                             | `{}`                        |
| `assetsvc.podAffinityPreset`                     | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`       | `""`                        |
| `assetsvc.podAntiAffinityPreset`                 | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`  | `soft`                      |
| `assetsvc.nodeAffinityPreset.type`               | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard` | `""`                        |
| `assetsvc.nodeAffinityPreset.key`                | Node label key to match. Ignored if `affinity` is set                                     | `""`                        |
| `assetsvc.nodeAffinityPreset.values`             | Node label values to match. Ignored if `affinity` is set                                  | `[]`                        |
| `assetsvc.affinity`                              | Affinity for pod assignment                                                               | `{}`                        |
| `assetsvc.nodeSelector`                          | Node labels for pod assignment                                                            | `{}`                        |
| `assetsvc.tolerations`                           | Tolerations for pod assignment                                                            | `[]`                        |
| `assetsvc.priorityClassName`                     | Priority class name for Assetsvc pods                                                     | `nil`                       |
| `assetsvc.hostAliases`                           | Custom host aliases for Assetsvc pods                                                     | `[]`                        |
| `assetsvc.service.port`                          | Assetsvc service HTTP port                                                                | `8080`                      |
| `assetsvc.service.annotations`                   | Additional custom annotations for Assetsvc service                                        | `{}`                        |


### Auth Proxy parameters

| Name                                              | Description                                                                   | Value                  |
| ------------------------------------------------- | ----------------------------------------------------------------------------- | ---------------------- |
| `authProxy.enabled`                               | Specifies whether Kubeapps should configure OAuth login/logout                | `false`                |
| `authProxy.image.registry`                        | OAuth2 Proxy image registry                                                   | `docker.io`            |
| `authProxy.image.repository`                      | OAuth2 Proxy image repository                                                 | `bitnami/oauth2-proxy` |
| `authProxy.image.tag`                             | OAuth2 Proxy image tag (immutable tags are recommended)                       | `7.1.3-debian-10-r61`  |
| `authProxy.image.pullPolicy`                      | OAuth2 Proxy image pull policy                                                | `IfNotPresent`         |
| `authProxy.image.pullSecrets`                     | OAuth2 Proxy image pull secrets                                               | `[]`                   |
| `authProxy.external`                              | Use an external Auth Proxy instead of deploying its own one                   | `false`                |
| `authProxy.oauthLoginURI`                         | OAuth Login URI to which the Kubeapps frontend redirects for authn            | `/oauth2/start`        |
| `authProxy.oauthLogoutURI`                        | OAuth Logout URI to which the Kubeapps frontend redirects for authn           | `/oauth2/sign_out`     |
| `authProxy.skipKubeappsLoginPage`                 | Skip the Kubeapps login page when using OIDC and directly redirect to the IdP | `false`                |
| `authProxy.provider`                              | OAuth provider                                                                | `""`                   |
| `authProxy.clientID`                              | OAuth Client ID                                                               | `""`                   |
| `authProxy.clientSecret`                          | OAuth Client secret                                                           | `""`                   |
| `authProxy.cookieSecret`                          | Secret used by oauth2-proxy to encrypt any credentials                        | `""`                   |
| `authProxy.cookieRefresh`                         | Duration after which to refresh the cookie                                    | `2m`                   |
| `authProxy.scope`                                 | OAuth scope specification                                                     | `openid email groups`  |
| `authProxy.emailDomain`                           | Allowed email domains                                                         | `*`                    |
| `authProxy.additionalFlags`                       | Additional flags for oauth2-proxy                                             | `[]`                   |
| `authProxy.containerPort`                         | Auth Proxy HTTP container port                                                | `3000`                 |
| `authProxy.containerSecurityContext.enabled`      | Enabled Auth Proxy containers' Security Context                               | `true`                 |
| `authProxy.containerSecurityContext.runAsUser`    | Set Auth Proxy container's Security Context runAsUser                         | `1001`                 |
| `authProxy.containerSecurityContext.runAsNonRoot` | Set Auth Proxy container's Security Context runAsNonRoot                      | `true`                 |
| `authProxy.resources.limits.cpu`                  | The CPU limits for the OAuth2 Proxy container                                 | `250m`                 |
| `authProxy.resources.limits.memory`               | The memory limits for the OAuth2 Proxy container                              | `128Mi`                |
| `authProxy.resources.requests.cpu`                | The requested CPU for the OAuth2 Proxy container                              | `25m`                  |
| `authProxy.resources.requests.memory`             | The requested memory for the OAuth2 Proxy container                           | `32Mi`                 |


### Pinniped Proxy parameters

| Name                                                  | Description                                                              | Value                             |
| ----------------------------------------------------- | ------------------------------------------------------------------------ | --------------------------------- |
| `pinnipedProxy.enabled`                               | Specifies whether Kubeapps should configure Pinniped Proxy               | `false`                           |
| `pinnipedProxy.image.registry`                        | Pinniped Proxy image registry                                            | `docker.io`                       |
| `pinnipedProxy.image.repository`                      | Pinniped Proxy image repository                                          | `bitnami/kubeapps-pinniped-proxy` |
| `pinnipedProxy.image.tag`                             | Pinniped Proxy image tag (immutable tags are recommended)                | `2.3.3-debian-10-r0`              |
| `pinnipedProxy.image.pullPolicy`                      | Pinniped Proxy image pull policy                                         | `IfNotPresent`                    |
| `pinnipedProxy.image.pullSecrets`                     | Pinniped Proxy image pull secrets                                        | `[]`                              |
| `pinnipedProxy.defaultPinnipedNamespace`              | Specify the (default) namespace in which pinniped concierge is installed | `pinniped-concierge`              |
| `pinnipedProxy.defaultAuthenticatorType`              | Specify the (default) authenticator type                                 | `JWTAuthenticator`                |
| `pinnipedProxy.defaultAuthenticatorName`              | Specify the (default) authenticator name                                 | `jwt-authenticator`               |
| `pinnipedProxy.defaultPinnipedAPISuffix`              | Specify the (default) API suffix                                         | `pinniped.dev`                    |
| `pinnipedProxy.containerPort`                         | Kubeops HTTP container port                                              | `3333`                            |
| `pinnipedProxy.containerSecurityContext.enabled`      | Enabled Pinniped Proxy containers' Security Context                      | `true`                            |
| `pinnipedProxy.containerSecurityContext.runAsUser`    | Set Pinniped Proxy container's Security Context runAsUser                | `1001`                            |
| `pinnipedProxy.containerSecurityContext.runAsNonRoot` | Set Pinniped Proxy container's Security Context runAsNonRoot             | `true`                            |
| `pinnipedProxy.resources.limits.cpu`                  | The CPU limits for the Pinniped Proxy container                          | `250m`                            |
| `pinnipedProxy.resources.limits.memory`               | The memory limits for the Pinniped Proxy container                       | `128Mi`                           |
| `pinnipedProxy.resources.requests.cpu`                | The requested CPU for the Pinniped Proxy container                       | `25m`                             |
| `pinnipedProxy.resources.requests.memory`             | The requested memory for the Pinniped Proxy container                    | `32Mi`                            |


### Other Parameters

| Name                      | Description                                                                   | Value                 |
| ------------------------- | ----------------------------------------------------------------------------- | --------------------- |
| `allowNamespaceDiscovery` | Allow users to discover available namespaces (only the ones they have access) | `true`                |
| `clusters`                | List of clusters that Kubeapps can target for deployments                     | `[]`                  |
| `featureFlags`            | Feature flags (used to switch on development features)                        | `{}`                  |
| `rbac.create`             | Specifies whether RBAC resources should be created                            | `true`                |
| `testImage.registry`      | NGINX image registry                                                          | `docker.io`           |
| `testImage.repository`    | NGINX image repository                                                        | `bitnami/nginx`       |
| `testImage.tag`           | NGINX image tag (immutable tags are recommended)                              | `1.21.1-debian-10-r1` |
| `testImage.pullPolicy`    | NGINX image pull policy                                                       | `IfNotPresent`        |
| `testImage.pullSecrets`   | NGINX image pull secrets                                                      | `[]`                  |


### Database Parameters

| Name                                   | Description                                                                  | Value    |
| -------------------------------------- | ---------------------------------------------------------------------------- | -------- |
| `postgresql.enabled`                   | Deploy a PostgreSQL server to satisfy the applications database requirements | `true`   |
| `postgresql.replication.enabled`       | Enable replication for high availability                                     | `true`   |
| `postgresql.postgresqlDatabase`        | Database name for Kubeapps to be created on the first run                    | `assets` |
| `postgresql.postgresqlPassword`        | Password for 'postgres' user                                                 | `""`     |
| `postgresql.persistence.enabled`       | Enable persistence on PostgreSQL using PVC(s)                                | `false`  |
| `postgresql.persistence.size`          | Persistent Volume size                                                       | `8Gi`    |
| `postgresql.securityContext.enabled`   | Enabled PostgreSQL replicas pods' Security Context                           | `false`  |
| `postgresql.resources.limits`          | The resources limits for the PostreSQL container                             | `{}`     |
| `postgresql.resources.requests.cpu`    | The requested CPU for the PostreSQL container                                | `250m`   |
| `postgresql.resources.requests.memory` | The requested memory for the PostreSQL container                             | `256Mi`  |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
helm install kubeapps --namespace kubeapps \
  --set ingress.enabled=true \
    bitnami/kubeapps
```

The above command enables an Ingress Rule to expose Kubeapps.

Alternatively, a YAML file that specifies the values for parameters can be provided while installing the chart. For example,

```bash
helm install kubeapps --namespace kubeapps -f custom-values.yaml bitnami/kubeapps
```

## Configuration and installation details

### Configuring Initial Repositories

By default, Kubeapps will track the [community Helm charts](https://github.com/helm/charts) and the [Kubernetes Service Catalog charts](https://github.com/kubernetes-incubator/service-catalog). To change these defaults, override with your desired parameters the `apprepository.initialRepos` object present in the [values.yaml](values.yaml) file.

### Enabling Operators

Since v1.9.0 (and by default since v2.0), Kubeapps supports to deploy and manage Operators within its dashboard. More information about how to enable and use this feature can be found in [this guide](https://github.com/kubeapps/kubeapps/blob/master/docs/user/operators.md).

### Exposing Externally

> **Note**: The Kubeapps frontend sets up a proxy to the Kubernetes API service which means that when exposing the Kubeapps service to a network external to the Kubernetes cluster (perhaps on an internal or public network), the Kubernetes API will also be exposed for authenticated requests from that network. It is highly recommended that you [use an OAuth2/OIDC provider with Kubeapps](https://github.com/kubeapps/kubeapps/blob/master/docs/user/using-an-OIDC-provider.md) to ensure that your authentication proxy is exposed rather than the Kubeapps frontend. This ensures that only the configured users trusted by your Identity Provider will be able to reach the Kubeapps frontend and therefore the Kubernetes API. Kubernetes service token authentication should only be used for users for demonstration purposes only, not production environments.

#### LoadBalancer Service

The simplest way to expose the Kubeapps Dashboard is to assign a LoadBalancer type to the Kubeapps frontend Service. For example, you can use the following parameter: `frontend.service.type=LoadBalancer`

Wait for your cluster to assign a LoadBalancer IP or Hostname to the `kubeapps` Service and access it on that address:

```bash
kubectl get services --namespace kubeapps --watch
```

#### Ingress

This chart provides support for ingress resources. If you have an ingress controller installed on your cluster, such as [nginx-ingress](https://hub.kubeapps.com/charts/stable/nginx-ingress) or [traefik](https://hub.kubeapps.com/charts/stable/traefik) you can utilize the ingress controller to expose Kubeapps.

To enable ingress integration, please set `ingress.enabled` to `true`

##### Hosts

Most likely you will only want to have one hostname that maps to this Kubeapps installation (use the `ingress.hostname` parameter to set the hostname), however, it is possible to have more than one host. To facilitate this, the `ingress.extraHosts` object is an array.

##### Annotations

For annotations, please see [this document](https://github.com/kubeapps/kubeapps/blob/master/docs/user-guide/nginx-configuration/annotations.md). Not all annotations are supported by all ingress controllers, but this document does a good job of indicating which annotation is supported by many popular ingress controllers. Annotations can be set using `ingress.annotations`.

##### TLS

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

- If you are going to use Helm to manage the certificates based on the parameters, please copy these values into the `certificate` and `key` values for a given `ingress.secrets` entry.
- In case you are going to manage TLS secrets separately, please know that you must use a TLS secret with name *INGRESS_HOSTNAME-tls* (where *INGRESS_HOSTNAME* is a placeholder to be replaced with the hostname you set using the `ingress.hostname` parameter).
- To use self-signed certificates created by Helm, set both `ingress.tls` and `ingress.selfSigned` to `true`.
- If your cluster has a [cert-manager](https://github.com/jetstack/cert-manager) add-on to automate the management and issuance of TLS certificates, set `ingress.certManager` boolean to true to enable the corresponding annotations for cert-manager.

## Upgrading Kubeapps

You can upgrade Kubeapps from the Kubeapps web interface. Select the namespace in which Kubeapps is installed (`kubeapps` if you followed the instructions in this guide) and click on the "Upgrade" button. Select the new version and confirm.

You can also use the Helm CLI to upgrade Kubeapps, first ensure you have updated your local chart repository cache:

```bash
helm repo update
```

Now upgrade Kubeapps:

```bash
export RELEASE_NAME=kubeapps
helm upgrade $RELEASE_NAME bitnami/kubeapps
```

If you find issues upgrading Kubeapps, check the [troubleshooting](#error-while-upgrading-the-chart) section.

## Uninstalling the Chart

To uninstall/delete the `kubeapps` deployment:

```bash
helm uninstall -n kubeapps kubeapps

# Optional: Only if there are no more instances of Kubeapps
kubectl delete crd apprepositories.kubeapps.com
```

The first command removes most of the Kubernetes components associated with the chart and deletes the release. After that, if there are no more instances of Kubeapps in the cluster you can manually delete the `apprepositories.kubeapps.com` CRD used by Kubeapps that is shared for the entire cluster.

> **NOTE**: If you delete the CRD for `apprepositories.kubeapps.com` it will delete the repositories for **all** the installed instances of `kubeapps`. This will break existing installations of `kubeapps` if they exist.

If you have dedicated a namespace only for Kubeapps you can completely clean the remaining completed/failed jobs or any stale resources by deleting the namespace

```bash
kubectl delete namespace kubeapps
```

## FAQ

- [How to install Kubeapps for demo purposes?](#how-to-install-kubeapps-for-demo-purposes)
- [How to install Kubeapps in production scenarios?](#how-to-install-kubeapps-in-production-scenarios)
- [How to use Kubeapps?](#how-to-use-kubeapps)
- [How to configure Kubeapps with Ingress](#how-to-configure-kubeapps-with-ingress)
  - [Serving Kubeapps in a subpath](#serving-kubeapps-in-a-subpath)
- [Can Kubeapps install apps into more than one cluster?](#can-kubeapps-install-apps-into-more-than-one-cluster)
- [Can Kubeapps be installed without Internet connection?](#can-kubeapps-be-installed-without-internet-connection)
- [Does Kubeapps support private repositories?](#does-kubeapps-support-private-repositories)
- [Is there any API documentation?](#is-there-any-api-documentation)
- [Why can't I configure global private repositories?](#why-cant-i-configure-global-private-repositories)
- [Does Kubeapps support Operators?](#does-kubeapps-support-operators)
- [Slow response when listing namespaces?](#slow-response-when-listing-namespaces)
- [More questions?](#more-questions)

### How to install Kubeapps for demo purposes?

Install Kubeapps for exclusively **demo purposes** by simply following the [getting started](https://github.com/kubeapps/kubeapps/blob/master/docs/user/getting-started.md) docs.

### How to install Kubeapps in production scenarios?

For any user-facing installation, you should [configure an OAuth2/OIDC provider](https://github.com/kubeapps/kubeapps/blob/master/docs/user/using-an-OIDC-provider.md) to enable secure user authentication with Kubeapps and the cluster.
Please also refer to the [Access Control](https://github.com/kubeapps/kubeapps/blob/master/docs/user/access-control.md) documentation to configure fine-grained access control for users.

### How to use Kubeapps?

Have a look at the [dashboard documentation](https://github.com/kubeapps/kubeapps/blob/master/docs/user/dashboard.md) for knowing how to use the Kubeapps dashboard: deploying applications, listing and removing the applications running in your cluster and adding new repositories.

### How to configure Kubeapps with Ingress

The example below will match the URL `http://example.com` to the Kubeapps dashboard. For further configuration, please refer to your specific Ingress configuration docs (e.g., [NGINX](https://github.com/kubernetes/ingress-nginx) or [HAProxy](https://github.com/haproxytech/kubernetes-ingress)).

```bash
helm install kubeapps --namespace kubeapps \
  --set ingress.enabled=true \
  --set ingress.hostname=example.com \
    bitnami/kubeapps
```

#### Serving Kubeapps in a subpath

You may want to serve Kubeapps with a subpath, for instance `http://example.com/subpath`, you have to set the proper Ingress configuration. If you are using the ingress configuration provided by the Kubeapps chart, you will have to set the `ingress.extraHosts` parameter:

```bash
helm install kubeapps --namespace kubeapps \
    --set ingress.enabled=true
    --set ingress.hostname=""
    --set ingress.extraHosts[0].name="console.example.com"
    --set ingress.extraHosts[0].path="/catalog"
    bitnami/kubeapps
```

Besides, if you are using the OAuth2/OIDC login (more information at the [using an OIDC provider documentation](https://github.com/kubeapps/kubeapps/blob/master/docs/user/using-an-OIDC-provider.md)), you will need, also, to configure the different URLs:

```bash
helm install kubeapps bitnami/kubeapps \
  --namespace kubeapps \
  # ... other OIDC flags 
  --set authProxy.oauthLoginURI="/subpath/oauth2/login" \
  --set authProxy.oauthLogoutURI="/subpath/oauth2/logout" \
  --set authProxy.additionalFlags="{<other flags>,--proxy-prefix=/subpath/oauth2}"
```

### Can Kubeapps install apps into more than one cluster?

Yes! Kubeapps 2.0+ supports multicluster environments. Have a look at the [Kubeapps dashboard documentation](https://github.com/kubeapps/kubeapps/blob/master/docs/user/deploying-to-multiple-clusters.md) to know more.

### Can Kubeapps be installed without Internet connection?

Yes! Follow the [offline installation documentation](https://github.com/kubeapps/kubeapps/blob/master/docs/user/offline-installation.md) to discover how to perform an installation in an air-gapped scenario.

### Does Kubeapps support private repositories?

Of course! Have a look at the [private app repositories documentation](https://github.com/kubeapps/kubeapps/blob/master/docs/user/private-app-repository.md) to learn how to configure a private repository in Kubeapps.

### Is there any API documentation?

Yes! But it is not definitive and is still subject to change. Check out the [latest API online documentation](https://app.swaggerhub.com/apis/kubeapps/Kubeapps) or download the Kubeapps [OpenAPI Specification yaml file](./dashboard/public/openapi.yaml) from the repository.

### Why can't I configure global private repositories?

You can, but you will need to configure the `imagePullSecrets` manually.

Kubeapps does not allow you to add `imagePullSecrets` to an AppRepository that is available to the whole cluster because it would require that Kubeapps copies those secrets to the target namespace when a user deploys an app.

If you create a global AppRepository but the images are on a private registry requiring `imagePullSecrets`, the best way to configure that is to ensure your [Kubernetes nodes are configured with the required `imagePullSecrets`](https://kubernetes.io/docs/concepts/containers/images/#configuring-nodes-to-authenticate-to-a-private-registry) - this allows all users (of those nodes) to use those images in their deployments without ever requiring access to the secrets.

You could alternatively ensure that the `imagePullSecret` is available in all namespaces in which you want people to deploy, but this unnecessarily compromises the secret.

### Does Kubeapps support Operators?

Yes! You can get started by following the [operators documentation](https://github.com/kubeapps/kubeapps/blob/master/docs/user/operators.md).

### Slow response when listing namespaces

Kubeapps uses the currently logged-in user credential to retrieve the list of all namespaces. If the user doesn't have permission to list namespaces, the backend will try again with its own service account to list all namespaces and then iterate through each namespace to check if the user has permissions to get secrets for each namespace (to verify if they should be allowed to use that namespace or not and hence whether it is included in the selector). This can lead to a slow response if the number of namespaces on the cluster is large.

To reduce this time, you can increase the number of checks that Kubeapps will perform in parallel (per connection) setting the value: `kubeops.burst=<desired_number>` and `kubeops.QPS=<desired_number>`. The default value, if not set, is 15 burst requests and 10 QPS afterwards.

### More questions? 

Feel free to [open an issue](https://github.com/kubeapps/kubeapps/issues/new) if you have any questions! 

## Troubleshooting

### Nginx Ipv6 error

When starting the application with the `--set enableIPv6=true` option, the Nginx server present in the services `kubeapps` and `kubeapps-internal-dashboard` may fail with the following:

```console
nginx: [emerg] socket() [::]:8080 failed (97: Address family not supported by protocol)
```

This usually means that your cluster is not compatible with IPv6. To disable it, install kubeapps with the flag: `--set enableIPv6=false`.

### Forbidden error while installing the Chart

If during installation you run into an error similar to:

```console
Error: release kubeapps failed: clusterroles.rbac.authorization.k8s.io "kubeapps-apprepository-controller" is forbidden: attempt to grant extra privileges: [{[get] [batch] [cronjobs] [] []...
```

Or:

```console
Error: namespaces "kubeapps" is forbidden: User "system:serviceaccount:kube-system:default" cannot get namespaces in the namespace "kubeapps"
```

It is possible, though uncommon, that your cluster does not have Role-Based Access Control (RBAC) enabled. To check if your cluster has RBAC you can execute:

```bash
kubectl api-versions
```

If the above command does not include entries for `rbac.authorization.k8s.io` you should perform the chart installation by setting `rbac.create=false`:

```bash
helm install --name kubeapps --namespace kubeapps bitnami/kubeapps --set rbac.create=false
```

### Error while upgrading the Chart

It is possible that when upgrading Kubeapps an error appears. That can be caused by a breaking change in the new chart or because the current chart installation is in an inconsistent state. If you find issues upgrading Kubeapps you can follow these steps:

> Note: These steps assume that you have installed Kubeapps in the namespace `kubeapps` using the name `kubeapps`. If that is not the case replace the command with your namespace and/or name.
> Note: If you are upgrading from 2.3.1 see the [following section](#upgrading-to-2-3-1).
> Note: If you are upgrading from 2.3.1 see the [following section](#upgrading-to-2-3-1).
> Note: If you are upgrading from 1.X to 2.X see the [following section](#upgrading-to-2-0).

1. (Optional) Backup your personal repositories (if you have any):

```bash
kubectl get apprepository -A -o yaml > <repo name>.yaml
```

2. Delete Kubeapps:

```bash
helm del --purge kubeapps
```

3. (Optional) Delete the App Repositories CRD:

> **Warning**: Don't execute this step if you have more than one Kubeapps installation in your cluster.

```bash
kubectl delete crd apprepositories.kubeapps.com
```

4. (Optional) Clean the Kubeapps namespace:

> **Warning**: Don't execute this step if you have workloads other than Kubeapps in the `kubeapps` namespace.

```bash
kubectl delete namespace kubeapps
```

5. Install the latest version of Kubeapps (using any custom modifications you need):

```bash
helm repo update
helm install --name kubeapps --namespace kubeapps bitnami/kubeapps
```

6. (Optional) Restore any repositories you backed up in the first step:

```bash
kubectl apply -f <repo name>.yaml
```

After that you should be able to access the new version of Kubeapps. If the above doesn't work for you or you run into any other issues please open an [issue](https://github.com/kubeapps/kubeapps/issues/new).

### Upgrading to chart version 7.0.0

In this release, no breaking changes were included in Kubeapps (version 2.3.2). However, the chart adopted the standardizations included in the rest of the charts in the Bitnami catalog.

Most of these standardizations simply add new parameters that allow to add more customizations such as adding custom env. variables, volumes or sidecar containers. That said, some of them include breaking changes:

- Chart labels were adapted to follow the [Helm charts standard labels](https://helm.sh/docs/chart_best_practices/labels/#standard-labels).
- `securityContext.*` parameters are deprecated in favor of `XXX.podSecurityContext.*` and `XXX.containerSecurityContext.*`, where XXX is placeholder you need to replace with the actual component(s). For instance, to modify the container security context for "kubeops" use `kubeops.podSecurityContext` and `kubeops.containerSecurityContext` parameters.

### Upgrading to 2.3.1

Kubeapps 2.3.1 (Chart version 6.0.0) introduces some breaking changes. Helm specific functionality has been removed in order to support other installation methods (like using YAML manifests, [`kapp`](https://carvel.dev/kapp) or `kustomize`(https://kustomize.io/)). Because of that, there are some steps required before upgrading from a previous version:

1. Kubeapps will no longer create a database secret for you automatically but rather will rely on the default behavior of the PostgreSQL chart. If you try to upgrade Kubeapps and you installed it without setting a password, you will get the following error:

```console
Error: UPGRADE FAILED: template: kubeapps/templates/NOTES.txt:73:4: executing "kubeapps/templates/NOTES.txt" at <include "common.errors.upgrade.passwords.empty" (dict "validationErrors" $passwordValidationErrors "context" $)>: error calling include: template: kubeapps/charts/common/templates/_errors.tpl:18:48: executing "common.errors.upgrade.passwords.empty" at <fail>: error calling fail: 
PASSWORDS ERROR: you must provide your current passwords when upgrade the release
    'postgresql.postgresqlPassword' must not be empty, please add '--set postgresql.postgresqlPassword=$POSTGRESQL_PASSWORD' to the command. To get the current value:
```

The error gives you generic instructions for retrieving the PostgreSQL password, but if you have installed a Kubeapps version prior to 2.3.1, the name of the secret will differ. Execute:

```console
export POSTGRESQL_PASSWORD=$(kubectl get secret --namespace "kubeapps" kubeapps-db -o jsonpath="{.data.postgresql-password}" | base64 --decode)
```

> NOTE: Replace the namespace in the command with the namespace in which you have deployed Kubeapps.

Make sure that you have stored the password in the variable `$POSTGRESQL_PASSWORD` before continuing with the next issue.

2. The chart initialRepos are no longer installed using [Helm hooks](https://helm.sh/docs/topics/charts_hooks/) which caused these repos to not be handled by Helm after the first installation. Now they will be tracked for every update but if you don't delete the existing ones, it will fail to update with:

```console
Error: UPGRADE FAILED: rendered manifests contain a resource that already exists. Unable to continue with update: AppRepository "bitnami" in namespace "kubeapps" exists and cannot be imported into the current release: invalid ownership metadata; annotation validation error: missing key "meta.helm.sh/release-name": must be set to "kubeapps"; annotation validation error: missing key "meta.helm.sh/release-namespace": must be set to "kubeapps"
```

To bypass this issue, you will need to before delete all the initialRepos from the chart values (only the `bitnami` repo by default):

```console
$ kubectl delete apprepositories.kubeapps.com -n kubeapps bitnami
```

> NOTE: Replace the namespace in the command with the namespace in which you have deployed Kubeapps.

After that, you will be able to upgrade Kubeapps to 2.3.1 using the existing database secret:

> **WARNING**: Make sure that the variable `$POSTGRESQL_PASSWORD` is properly populated. Setting a wrong (or empty) password will corrupt the release.

```console
$ helm upgrade kubeapps bitnami/kubeapps -n kubeapps --set postgresql.postgresqlPassword=$POSTGRESQL_PASSWORD
```

### Upgrading to 2.0.1 (Chart 5.0.0)

[On November 13, 2020, Helm 2 support was formally finished](https://github.com/helm/charts#status-of-the-project), this major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm 3 and to be consistent with the Helm project itself regarding the Helm 2 EOL.

**What changes were introduced in this major version?**

- Previous versions of this Helm Chart use `apiVersion: v1` (installable by both Helm 2 and 3), this Helm Chart was updated to `apiVersion: v2` (installable by Helm 3 only). [Here](https://helm.sh/docs/topics/charts/#the-apiversion-field) you can find more information about the `apiVersion` field.
- Move dependency information from the *requirements.yaml* to the *Chart.yaml*
- After running `helm dependency update`, a *Chart.lock* file is generated containing the same structure used in the previous *requirements.lock*
- The different fields present in the *Chart.yaml* file has been ordered alphabetically in a homogeneous way for all the Bitnami Helm Charts
- In the case of PostgreSQL subchart, apart from the same changes that are described in this section, there are also other major changes due to the master/slave nomenclature was replaced by primary/readReplica. [Here](https://github.com/bitnami/charts/pull/4385) you can find more information about the changes introduced.

**Considerations when upgrading to this version**

- If you want to upgrade to this version using Helm 2, this scenario is not supported as this version doesn't support Helm 2 anymore
- If you installed the previous version with Helm 2 and wants to upgrade to this version with Helm 3, please refer to the [official Helm documentation](https://helm.sh/docs/topics/v2_v3_migration/#migration-use-cases) about migrating from Helm 2 to 3
- If you want to upgrade to this version from a previous one installed with Helm 3, you shouldn't face any issues related to the new `apiVersion`. Due to the PostgreSQL major version bump, it's necessary to remove the existing statefulsets:

> Note: The command below assumes that Kubeapps has been deployed in the kubeapps namespace using "kubeapps" as release name, if that's not the case, adapt the command accordingly.

```console
$ kubectl delete statefulset -n kubeapps kubeapps-postgresql-master kubeapps-postgresql-slave
```

**Useful links**

- https://docs.bitnami.com/tutorials/resolve-helm2-helm3-post-migration-issues/
- https://helm.sh/docs/topics/v2_v3_migration/
- https://helm.sh/blog/migrate-from-helm-v2-to-helm-v3/

### Upgrading to 2.0

Kubeapps 2.0 (Chart version 4.0.0) introduces some breaking changes:

- Helm 2 is no longer supported. If you are still using some Helm 2 charts, [migrate them with the available tools](https://helm.sh/docs/topics/v2_v3_migration/). Note that some charts (but not all of them) may require to be migrated to the [new Chart specification (v2)](https://helm.sh/docs/topics/charts/#the-apiversion-field). If you are facing any issue managing this migration and Kubeapps, please open a new issue!
- MongoDB&reg; is no longer supported. Since 2.0, the only database supported is PostgreSQL.
- PostgreSQL chart dependency has been upgraded to a new major version.

Due to the last point, it's necessary to run a command before upgrading to Kubeapps 2.0:

> Note: The command below assumes that Kubeapps has been deployed in the kubeapps namespace using "kubeapps" as release name, if that's not the case, adapt the command accordingly.

```bash
kubectl delete statefulset -n kubeapps kubeapps-postgresql-master kubeapps-postgresql-slave
```

After that you should be able to upgrade Kubeapps as always and the database will be repopulated.
