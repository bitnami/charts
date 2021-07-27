# Apache

The [Apache HTTP Server Project](https://httpd.apache.org/) is an effort to develop and maintain an open-source HTTP server for modern operating systems including UNIX and Windows NT. The goal of this project is to provide a secure, efficient and extensible server that provides HTTP services in sync with the current HTTP standards.

The Apache HTTP Server ("httpd") was launched in 1995 and it has been the most popular web server on the Internet since April 1996. It has celebrated its 20th birthday as a project in February 2015.

## TL;DR

```bash
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/apache
```

## Introduction

Bitnami charts for Helm are carefully engineered, actively maintained and are the quickest and easiest way to deploy containers on a Kubernetes cluster that are ready to handle production workloads.

This chart bootstraps a [Apache](https://github.com/bitnami/bitnami-docker-apache) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This Helm chart has been tested on top of [Bitnami Kubernetes Production Runtime](https://kubeprod.io/) (BKPR). Deploy BKPR to get automated TLS certificates, logging and monitoring for your applications.

## Prerequisites

- Kubernetes 1.12+
- Helm 3.1.0

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/apache
```

These commands deploy Apache on the Kubernetes cluster in the default configuration.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

### Global parameters

| Name                      | Description                                     | Value |
| ------------------------- | ----------------------------------------------- | ----- |
| `global.imageRegistry`    | Global Docker image registry                    | `""`  |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]`  |


### Common parameters

| Name                | Description                                        | Value |
| ------------------- | -------------------------------------------------- | ----- |
| `kubeVersion`       | Override Kubernetes version                        | `""`  |
| `nameOverride`      | String to partially override common.names.fullname | `""`  |
| `fullnameOverride`  | String to fully override common.names.fullname     | `""`  |
| `commonLabels`      | Labels to add to all deployed objects              | `{}`  |
| `commonAnnotations` | Annotations to add to all deployed objects         | `{}`  |
| `extraDeploy`       | Array of extra objects to deploy with the release  | `[]`  |


### Apache parameters

| Name                                   | Description                                                                               | Value                  |
| -------------------------------------- | ----------------------------------------------------------------------------------------- | ---------------------- |
| `image.registry`                       | Apache image registry                                                                     | `docker.io`            |
| `image.repository`                     | Apache image repository                                                                   | `bitnami/apache`       |
| `image.tag`                            | Apache image tag (immutable tags are recommended)                                         | `2.4.48-debian-10-r28` |
| `image.pullPolicy`                     | Apache image pull policy                                                                  | `IfNotPresent`         |
| `image.pullSecrets`                    | Apache image pull secrets                                                                 | `[]`                   |
| `image.debug`                          | Enable image debug mode                                                                   | `false`                |
| `git.registry`                         | Git image registry                                                                        | `docker.io`            |
| `git.repository`                       | Git image name                                                                            | `bitnami/git`          |
| `git.tag`                              | Git image tag                                                                             | `2.32.0-debian-10-r26` |
| `git.pullPolicy`                       | Git image pull policy                                                                     | `IfNotPresent`         |
| `git.pullSecrets`                      | Specify docker-registry secret names as an array                                          | `[]`                   |
| `replicaCount`                         | Number of replicas of the Apache deployment                                               | `1`                    |
| `podAffinityPreset`                    | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`       | `""`                   |
| `podAntiAffinityPreset`                | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`  | `soft`                 |
| `nodeAffinityPreset.type`              | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard` | `""`                   |
| `nodeAffinityPreset.key`               | Node label key to match. Ignored if `affinity` is set                                     | `""`                   |
| `nodeAffinityPreset.values`            | Node label values to match. Ignored if `affinity` is set                                  | `[]`                   |
| `affinity`                             | Affinity for pod assignment                                                               | `{}`                   |
| `nodeSelector`                         | Node labels for pod assignment                                                            | `{}`                   |
| `tolerations`                          | Tolerations for pod assignment                                                            | `[]`                   |
| `cloneHtdocsFromGit.enabled`           | Get the server static content from a git repository                                       | `false`                |
| `cloneHtdocsFromGit.repository`        | Repository to clone static content from                                                   | `""`                   |
| `cloneHtdocsFromGit.branch`            | Branch inside the git repository                                                          | `""`                   |
| `cloneHtdocsFromGit.interval`          | Interval for sidecar container pull from the repository                                   | `60`                   |
| `cloneHtdocsFromGit.resources`         | Init container git resource requests                                                      | `{}`                   |
| `cloneHtdocsFromGit.extraVolumeMounts` | Add extra volume mounts for the GIT containers                                            | `[]`                   |
| `htdocsConfigMap`                      | Name of a config map with the server static content                                       | `""`                   |
| `htdocsPVC`                            | Name of a PVC with the server static content                                              | `""`                   |
| `vhostsConfigMap`                      | Name of a config map with the virtual hosts content                                       | `""`                   |
| `httpdConfConfigMap`                   | Name of a config map with the httpd.conf file contents                                    | `""`                   |
| `podLabels`                            | Extra labels for Apache pods                                                              | `{}`                   |
| `podAnnotations`                       | Pod annotations                                                                           | `{}`                   |
| `hostAliases`                          | Add deployment host aliases                                                               | `[]`                   |
| `resources.limits`                     | The resources limits for the container                                                    | `{}`                   |
| `resources.requests`                   | The requested resources for the container                                                 | `{}`                   |
| `livenessProbe.enabled`                | Enable liveness probe                                                                     | `true`                 |
| `livenessProbe.path`                   | Path to access on the HTTP server                                                         | `/`                    |
| `livenessProbe.port`                   | Port for livenessProbe                                                                    | `http`                 |
| `livenessProbe.initialDelaySeconds`    | Initial delay seconds for livenessProbe                                                   | `180`                  |
| `livenessProbe.periodSeconds`          | Period seconds for livenessProbe                                                          | `20`                   |
| `livenessProbe.timeoutSeconds`         | Timeout seconds for livenessProbe                                                         | `5`                    |
| `livenessProbe.failureThreshold`       | Failure threshold for livenessProbe                                                       | `6`                    |
| `livenessProbe.successThreshold`       | Success threshold for livenessProbe                                                       | `1`                    |
| `readinessProbe.enabled`               | Enable readiness probe                                                                    | `true`                 |
| `readinessProbe.path`                  | Path to access on the HTTP server                                                         | `/`                    |
| `readinessProbe.port`                  | Port for readinessProbe                                                                   | `http`                 |
| `readinessProbe.initialDelaySeconds`   | Initial delay seconds for readinessProbe                                                  | `30`                   |
| `readinessProbe.periodSeconds`         | Period seconds for readinessProbe                                                         | `10`                   |
| `readinessProbe.timeoutSeconds`        | Timeout seconds for readinessProbe                                                        | `5`                    |
| `readinessProbe.failureThreshold`      | Failure threshold for readinessProbe                                                      | `6`                    |
| `readinessProbe.successThreshold`      | Success threshold for readinessProbe                                                      | `1`                    |
| `extraVolumes`                         | Array to add extra volumes (evaluated as a template)                                      | `[]`                   |
| `extraVolumeMounts`                    | Array to add extra mounts (normally used with extraVolumes, evaluated as a template)      | `[]`                   |
| `extraEnvVars`                         | Array to add extra environment variables                                                  | `[]`                   |
| `initContainers`                       | Add additional init containers to the Apache pods                                         | `[]`                   |
| `sidecars`                             | Add additional sidecar containers to the Apache pods                                      | `[]`                   |


### Traffic Exposure Parameters

| Name                            | Description                                                                | Value                    |
| ------------------------------- | -------------------------------------------------------------------------- | ------------------------ |
| `service.type`                  | Apache Service type                                                        | `LoadBalancer`           |
| `service.port`                  | Apache service HTTP port                                                   | `80`                     |
| `service.httpsPort`             | Apache service HTTPS port                                                  | `443`                    |
| `service.nodePorts.http`        | Node port for HTTP                                                         | `""`                     |
| `service.nodePorts.https`       | Node port for HTTPS                                                        | `""`                     |
| `service.loadBalancerIP`        | Apache service Load Balancer IP                                            | `""`                     |
| `service.annotations`           | Additional custom annotations for Apache service                           | `{}`                     |
| `service.externalTrafficPolicy` | Apache service external traffic policy                                     | `Cluster`                |
| `ingress.enabled`               | Enable ingress record generation for Apache                                | `false`                  |
| `ingress.pathType`              | Ingress path type                                                          | `ImplementationSpecific` |
| `ingress.apiVersion`            | Force Ingress API version (automatically detected if not set)              | `""`                     |
| `ingress.hostname`              | Default host for the ingress record                                        | `example.local`          |
| `ingress.path`                  | Default path for the ingress record                                        | `ImplementationSpecific` |
| `ingress.annotations`           | Additional custom annotations for the ingress record                       | `{}`                     |
| `ingress.tls`                   | Enable TLS configuration for the hosts defined                             | `[]`                     |
| `ingress.certManager`           | Add the corresponding annotations for cert-manager integration             | `false`                  |
| `ingress.hosts`                 | An array with additional hostname(s) to be covered with the ingress record | `[]`                     |
| `ingress.secrets`               | Custom TLS certificates as secrets                                         | `[]`                     |


### Metrics Parameters

| Name                         | Description                                                  | Value                     |
| ---------------------------- | ------------------------------------------------------------ | ------------------------- |
| `metrics.enabled`            | Start a sidecar prometheus exporter to expose Apache metrics | `false`                   |
| `metrics.image.registry`     | Apache Exporter image registry                               | `docker.io`               |
| `metrics.image.repository`   | Apache Exporter image repository                             | `bitnami/apache-exporter` |
| `metrics.image.tag`          | Apache Exporter image tag (immutable tags are recommended)   | `0.9.0-debian-10-r25`     |
| `metrics.image.pullPolicy`   | Apache Exporter image pull policy                            | `IfNotPresent`            |
| `metrics.image.pullSecrets`  | Apache Exporter image pull secrets                           | `[]`                      |
| `metrics.podAnnotations`     | Additional custom annotations for Apache exporter service    | `{}`                      |
| `metrics.resources.limits`   | The resources limits for the container                       | `{}`                      |
| `metrics.resources.requests` | The requested resources for the container                    | `{}`                      |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install my-release \
  --set imagePullPolicy=Always \
    bitnami/apache
```

The above command sets the `imagePullPolicy` to `Always`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install my-release -f values.yaml bitnami/apache
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Deploying a custom web application

The Apache chart allows you to deploy a custom web application using one of the following methods:

- Cloning from a git repository: Set `cloneHtdocsFromGit.enabled` to `true` and set the repository and branch using the `cloneHtdocsFromGit.repository` and  `cloneHtdocsFromGit.branch` parameters. A sidecar will also pull the latest changes in an interval set by `cloneHtdocsFromGit.interval`.
- Providing a ConfigMap: Set the `htdocsConfigMap` value to mount a ConfigMap in the Apache htdocs folder.
- Using an existing PVC: Set the `htdocsPVC` value to mount an PersistentVolumeClaim with the web application content.

Refer to the [chart documentation](https://docs.bitnami.com/kubernetes/infrastructure/apache/get-started/deploy-custom-application/) for more information.

### Setting Pod's affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod affinity in the [Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use  the preset configurations for pod affinity, pod anti-affinity, and node affinity available in the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami’s Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Notable changes

### 7.4.0

This version also introduces `bitnami/common`, a [library chart](https://helm.sh/docs/topics/library_charts/#helm) as a dependency. More documentation about this new utility could be found [here](https://github.com/bitnami/charts/tree/master/bitnami/common#bitnami-common-library-chart). Please, make sure that you have updated the chart dependencies before executing any upgrade.

### 7.0.0

This release updates the Bitnami Apache container to `2.4.41-debian-9-r40`, which is based on Bash instead of Node.js.

### 6.0.0

This release allows you to use your custom static application. In order to do so, check [this section](#deploying-your-custom-web-application).

## Upgrading

### To 8.0.0

[On November 13, 2020, Helm v2 support formally ended](https://github.com/helm/charts#status-of-the-project). This major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

[Learn more about this change and related upgrade considerations](https://docs.bitnami.com/kubernetes/infrastructure/apache/administration/upgrade-helm3/).

### To 2.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 2.0.0. The following example assumes that the release name is apache:

```console
$ kubectl patch deployment apache --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
```
