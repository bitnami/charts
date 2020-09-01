# NGINX

[NGINX](https://nginx.org) (pronounced "engine-x") is an open source reverse proxy server for HTTP, HTTPS, SMTP, POP3, and IMAP protocols, as well as a load balancer, HTTP cache, and a web server (origin server).

## TL;DR

```bash
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/nginx
```

## Introduction

Bitnami charts for Helm are carefully engineered, actively maintained and are the quickest and easiest way to deploy containers on a Kubernetes cluster that are ready to handle production workloads.

This chart bootstraps a [NGINX Open Source](https://github.com/bitnami/bitnami-docker-nginx) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This Helm chart has been tested on top of [Bitnami Kubernetes Production Runtime](https://kubeprod.io/) (BKPR). Deploy BKPR to get automated TLS certificates, logging and monitoring for your applications.

## Prerequisites

- Kubernetes 1.12+
- Helm 2.12+ or Helm 3.0-beta3+

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/nginx
```

These commands deploy NGINX Open Source on the Kubernetes cluster in the default configuration.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

The following tables lists the configurable parameters of the NGINX Open Source chart and their default values.

| Parameter                                  | Description                                                                                  | Default                                                      |
|--------------------------------------------|----------------------------------------------------------------------------------------------|--------------------------------------------------------------|
| `global.imageRegistry`                     | Global Docker image registry                                                                 | `nil`                                                        |
| `global.imagePullSecrets`                  | Global Docker registry secret names as an array                                              | `[]` (does not add image pull secrets to deployed pods)      |
| `image.registry`                           | NGINX image registry                                                                         | `docker.io`                                                  |
| `image.repository`                         | NGINX Image name                                                                             | `bitnami/nginx`                                              |
| `image.tag`                                | NGINX Image tag                                                                              | `{TAG_NAME}`                                                 |
| `image.pullPolicy`                         | NGINX image pull policy                                                                      | `IfNotPresent`                                               |
| `image.pullSecrets`                        | Specify docker-registry secret names as an array                                             | `[]` (does not add image pull secrets to deployed pods)      |
| `nameOverride`                             | String to partially override nginx.fullname template                                         | `nil`                                                        |
| `fullnameOverride`                         | String to fully override nginx.fullname template                                             | `nil`                                                        |
| `staticSiteConfigmap`                      | Name of existing ConfigMap with the server static content                                    | `nil`                                                        |
| `staticSitePVC`                            | Name of existing PVC with the server static content                                          | `nil`                                                        |
| `cloneStaticSiteFromGit.enabled`           | Get the server static content from a git repository                                          | `false`                                                      |
| `cloneStaticSiteFromGit.image.registry`    | Git image registry                                                                           | `docker.io`                                                  |
| `cloneStaticSiteFromGit.image.repository`  | Git image name                                                                               | `bitnami/git`                                                |
| `cloneStaticSiteFromGit.image.tag`         | Git image tag                                                                                | `{TAG_NAME}`                                                 |
| `cloneStaticSiteFromGit.image.pullPolicy`  | Git image pull policy                                                                        | `Always`                                                     |
| `cloneStaticSiteFromGit.image.pullSecrets` | Specify docker-registry secret names as an array                                             | `[]` (does not add image pull secrets to deployed pods)      |
| `cloneStaticSiteFromGit.repository`        | Repository to clone static content from                                                      | `nil`                                                        |
| `cloneStaticSiteFromGit.branch`            | Branch inside the git repository                                                             | `nil`                                                        |
| `cloneStaticSiteFromGit.interval`          | Interval for sidecar container pull from the repository                                      | `60`                                                         |
| `serverBlock`                              | Custom NGINX server block                                                                    | `nil`                                                        |
| `existingServerBlockConfigmap`             | Name of existing PVC with custom NGINX server block                                          | `nil`                                                        |
| `replicaCount`                             | Number of replicas to deploy                                                                 | `1`                                                          |
| `containerPort`                            | Deployment Container Port                                                                    | `8080`                                                       |
| `containerTlsPort`                         | Deployment Container Tls Port                                                                | `nil`                                                        |
| `podAnnotations`                           | Pod annotations                                                                              | `{}`                                                         |
| `affinity`                                 | Map of node/pod affinities                                                                   | `{}` (The value is evaluated as a template)                  |
| `nodeSelector`                             | Node labels for pod assignment                                                               | `{}` (The value is evaluated as a template)                  |
| `tolerations`                              | Tolerations for pod assignment                                                               | `[]` (The value is evaluated as a template)                  |
| `resources`                                | Resource requests/limit                                                                      | `{}`                                                         |
| `livenessProbe`                            | Deployment Liveness Probe                                                                    | See `values.yaml`                                            |
| `readinessProbe`                           | Deployment Readiness Probe                                                                   | See `values.yaml`                                            |
| `service.type`                             | Kubernetes Service type                                                                      | `LoadBalancer`                                               |
| `service.port`                             | Service HTTP port                                                                            | `80`                                                         |
| `service.httpsPort`                        | Service HTTPS port                                                                           | `443`                                                        |
| `service.nodePorts.http`                   | Kubernetes http node port                                                                    | `""`                                                         |
| `service.nodePorts.https`                  | Kubernetes https node port
| `service.targetPort.http`                  | Kubernetes http targetPort                                                                   | `http`                   |
| `service.targetPort.https`                 | Kubernetes https targetPort                                                                  | `https`                  |
| `service.externalTrafficPolicy`            | Enable client source IP preservation                                                         | `Cluster`                                                    |
| `service.loadBalancerIP`                   | LoadBalancer service IP address                                                              | `""`                                                         |
| `service.annotations`                      | Service annotations                                                                          | `{}`                                                         |
| `ldapDaemon.enabled`                       | Enable LDAP Auth Daemon proxy                                                                | `false`                                                      |
| `ldapDaemon.image.registry`                | LDAP AUth Daemon Image registry                                                              | `docker.io`                                                  |
| `ldapDaemon.image.repository`              | LDAP Auth Daemon Image name                                                                  | `bitnami/nginx-ldap-auth-daemon`                             |
| `ldapDaemon.image.tag`                     | LDAP Auth Daemon Image tag                                                                   | `{TAG_NAME}`                                                 |
| `ldapDaemon.image.pullPolicy`              | LDAP Auth Daemon Image pull policy                                                           | `IfNotPresent`                                               |
| `ldapDaemon.port`                          | LDAP Auth Daemon port                                                                        | `8888`                                                       |
| `ldapDaemon.ldapConfig.uri`                | LDAP Server URI, `ldap[s]:/<hostname>:<port>`                                                | `""`                                                         |
| `ldapDaemon.ldapConfig.baseDN`             | LDAP root DN to begin the search for the user                                                | `""`                                                         |
| `ldapDaemon.ldapConfig.bindDN`             | DN of user to bind to LDAP                                                                   | `""`                                                         |
| `ldapDaemon.ldapConfig.bindPassword`       | Password for the user to bind to LDAP                                                        | `""`                                                         |
| `ldapDaemon.ldapConfig.filter`             | LDAP search filter for search+bind authentication                                            | `""`                                                         |
| `ldapDaemon.ldapConfig.httpRealm`          | LDAP HTTP auth realm                                                                         | `""`                                                         |
| `ldapDaemon.ldapConfig.httpCookieName`     | HTTP cookie name to be used in LDAP Auth                                                     | `""`                                                         |
| `ldapDaemon.nginxServerBlock`              | NGINX server block that configures LDAP communication. Overrides `ldapDaemon.ldapConfig`     | See `values.yaml`                                            |
| `ldapDaemon.existingNginxServerBlockSecret`| Name of existing Secret with a NGINX server block to use for LDAP communication              | `nil`                                                        |
| `ldapDaemon.livenessProbe`                 | LDAP Auth Daemon Liveness Probe                                                              | See `values.yaml`                                            |
| `ldapDaemon.readinessProbe`                | LDAP Auth Daemon Readiness Probe                                                             | See `values.yaml`                                            |
| `ingress.enabled`                          | Enable ingress controller resource                                                           | `false`                                                      |
| `ingress.certManager`                      | Add annotations for cert-manager                                                             | `false`                                                      |
| `ingress.selectors`                        | Ingress selectors for labelSelector option                                                   | `[]`                                                         |
| `ingress.annotations`                      | Ingress annotations                                                                          | `[]`                                                         |
| `ingress.hosts[0].name`                    | Hostname to your NGINX installation                                                          | `nginx.local`                                                |
| `ingress.hosts[0].path`                    | Path within the url structure                                                                | `/`                                                          |
| `ingress.hosts[0].extraPaths`              | Ingress extra paths to prepend to every host configuration. Useful when configuring [custom actions with AWS ALB Ingress Controller](https://kubernetes-sigs.github.io/aws-alb-ingress-controller/guide/ingress/annotation/#actions). | `[]`                |
| `ingress.tls[0].hosts[0]`                  | TLS hosts                                                                                    | `nginx.local`                                                |
| `ingress.tls[0].secretName`                | TLS Secret (certificates)                                                                    | `nginx.local-tls`                                            |
| `ingress.secrets[0].name`                  | TLS Secret Name                                                                              | `nil`                                                        |
| `ingress.secrets[0].certificate`           | TLS Secret Certificate                                                                       | `nil`                                                        |
| `ingress.secrets[0].key`                   | TLS Secret Key                                                                               | `nil`                                                        |
| `healthIngress.enabled`                    | Enable health ingress controller resource                                                    | `false`                                                      |
| `healthIngress.certManager`                | Add annotations for cert-manager                                                             | `false`                                                      |
| `healthIngress.selectors`                  | Health Ingress selectors for labelSelector option                                            | `[]`                                                         |
| `healthIngress.annotations`                | Health Ingress annotations                                                                   | `[]`                                                         |
| `healthIngress.hosts[0].name`              | Hostname to your NGINX installation                                                          | `nginx.local`                                                |
| `healthIngress.hosts[0].path`              | Path within the url structure                                                                | `/`                                                          |
| `healthIngress.tls[0].hosts[0]`            | TLS hosts                                                                                    | `nginx.local`                                                |
| `healthIngress.tls[0].secretName`          | TLS Secret (certificates)                                                                    | `nginx.local-tls`                                            |
| `healthIngress.secrets[0].name`            | TLS Secret Name                                                                              | `nil`                                                        |
| `healthIngress.secrets[0].certificate`     | TLS Secret Certificate                                                                       | `nil`                                                        |
| `healthIngress.secrets[0].key`             | TLS Secret Key                                                                               | `nil`                                                        |
| `metrics.enabled`                          | Start a side-car prometheus exporter                                                         | `false`                                                      |
| `metrics.image.registry`                   | NGINX Prometheus exporter image registry                                                     | `docker.io`                                                  |
| `metrics.image.repository`                 | NGINX Prometheus exporter image name                                                         | `bitnami/nginx-exporter`                                     |
| `metrics.image.tag`                        | NGINX Prometheus exporter image tag                                                          | `{TAG_NAME}`                                                 |
| `metrics.image.pullPolicy`                 | NGINX Prometheus exporter image pull policy                                                  | `IfNotPresent`                                               |
| `metrics.image.pullSecrets`                | Specify docker-registry secret names as an array                                             | `[]` (does not add image pull secrets to deployed pods)      |
| `metrics.podAnnotations`                   | Additional annotations for NGINX Prometheus exporter pod(s)                                  | `{prometheus.io/scrape: "true", prometheus.io/port: "9113"}` |
| `metrics.resources`                        | NGINX Prometheus exporter resource requests/limit                                            | `{}`                                                         |
| `metrics.serviceMonitor.enabled`           | Creates a Prometheus Operator ServiceMonitor (also requires `metrics.enabled` to be `true`)  | `false`                                                      |
| `metrics.serviceMonitor.namespace`         | Namespace in which Prometheus is running                                                     | `nil`                                                        |
| `metrics.serviceMonitor.interval`          | Interval at which metrics should be scraped.                                                 | `nil` (Prometheus Operator default value)                    |
| `metrics.serviceMonitor.scrapeTimeout`     | Timeout after which the scrape is ended                                                      | `nil` (Prometheus Operator default value)                    |
| `metrics.serviceMonitor.selector`          | Prometheus instance selector labels                                                          | `nil`                                                        |
| `autoscaling.enabled`                      | Enable autoscaling for NGINX deployment                                                      | `false`                                                      |
| `autoscaling.minReplicas`                  | Minimum number of replicas to scale back                                                     | `nil`                                                        |
| `autoscaling.maxReplicas`                  | Maximum number of replicas to scale out                                                      | `nil`                                                        |
| `autoscaling.targetCPU`                    | Target CPU utilization percentage                                                            | `nil`                                                        |
| `autoscaling.targetMemory`                 | Target Memory utilization percentage                                                         | `nil`                                                        |
| `extraVolumes`                             | Array to add extra volumes (evaluated as a template)                                         | `[]`                                                         |
| `extraVolumeMounts`                        | Array to add extra mounts (normally used with extraVolumes, evaluated as a template)         | `[]`                                                         |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install my-release \
  --set imagePullPolicy=Always \
    bitnami/nginx
```

The above command sets the `imagePullPolicy` to `Always`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install my-release -f values.yaml bitnami/nginx
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Change NGINX version

To modify the NGINX version used in this chart you can specify a [valid image tag](https://hub.docker.com/r/bitnami/nginx/tags/) using the `image.tag` parameter. For example, `image.tag=X.Y.Z`. This approach is also applicable to other images like exporters.

### Deploying your custom web application

The NGINX chart allows you to deploy a custom web application using one of the following methods:

- Cloning from a git repository: Set `cloneStaticSiteFromGit.enabled` to `true` and set the repository and branch using the `cloneStaticSiteFromGit.repository` and  `cloneStaticSiteFromGit.branch` parameters. A sidecar will also pull the latest changes in an interval set by `cloneStaticSitesFromGit.interval`.
- Providing a ConfigMap: Set the `staticSiteConfigMap` value to mount a ConfigMap in the NGINX html folder.
- Using an existing PVC: Set the `staticSitePVC` value to mount an PersistentVolumeClaim with the static site content.

You can deploy a example web application using git deploying the chart with the following parameters:

```console
cloneStaticSiteFromGit.enabled=true
cloneStaticSiteFromGit.repository=https://github.com/mdn/beginner-html-site-styled.git
cloneStaticSiteFromGit.branch=master
```

### Providing a custom server block

This helm chart supports using custom custom server block for NGINX to use.

You can use the `serverBlock` value to provide a custom server block for NGINX to use. To do this, create a values files with your server block and install the chart using it:

```yaml
serverBlock: |-
  server {
    listen 0.0.0.0:8080;
    location / {
      return 200 "hello!";
    }
  }
```

> Warning: The above example is not compatible with enabling Prometheus metrics since it affects the `/status` endpoint.

In addition, you can also set an external ConfigMap with the configuration file. This is done by setting the `existingServerBlockConfigmap` parameter. Note that this will override the previous option.

### Enabling LDAP

In some scenarios, you may require users to authenticate in order to gain access to protected resources. By enabling LDAP, NGINX will make use of an Authorization Daemon to proxy those identification requests against a given LDAP Server.

In order to enable LDAP authentication you can set the `ldapDaemon.enabled` property and follow these steps:

1. Use the `ldapDaemon.nginxServerBlock` property to provide with an additional server block that will make NGINX such a proxy (see `values.yaml`). Alternatively, you can provide this configuration using an external Secret and the property `ldapDaemon.existingNginxServerBlockSecret`.

2. Complete the aforementioned server block by specifying your LDAP Server connection details (see `values.yaml`). Alternatively, you can declare them using the property `ldapDaemon.ldapConfig`.

## Upgrading

### 5.6.0
Added support for the use of LDAP.

### 5.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 5.0.0. The following example assumes that the release name is nginx:

```console
$ kubectl delete deployment nginx --cascade=false
$ helm upgrade nginx bitnami/nginx
```

### To 1.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 1.0.0. The following example assumes that the release name is nginx:

```console
$ kubectl patch deployment nginx --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
```
