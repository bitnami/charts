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
- Helm 3.1.0

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

The following tables lists the configurable parameters of the NGINX chart and their default values per section/component:

### Global parameters

| Parameter                 | Description                                     | Default                                                 |
|---------------------------|-------------------------------------------------|---------------------------------------------------------|
| `global.imageRegistry`    | Global Docker image registry                    | `nil`                                                   |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]` (does not add image pull secrets to deployed pods) |

### Common parameters

| Parameter            | Description                                                          | Default                        |
|----------------------|----------------------------------------------------------------------|--------------------------------|
| `nameOverride`       | String to partially override nginx.fullname                          | `nil`                          |
| `fullnameOverride`   | String to fully override nginx.fullname                              | `nil`                          |
| `clusterDomain`      | Default Kubernetes cluster domain                                    | `cluster.local`                |
| `commonLabels`       | Labels to add to all deployed objects                                | `{}`                           |
| `commonAnnotations`  | Annotations to add to all deployed objects                           | `{}`                           |
| `extraDeploy`        | Array of extra objects to deploy with the release                    | `[]` (evaluated as a template) |
| `pdb.create`         | Created a PodDisruptionBudget                                        | `false`                        |
| `pdb.minAvailable`   | Set PDB minAvailable value                                           | `1`                            |
| `pdb.maxUnavailable` | Set PDB maxUnavailable value                                         | `nil`                          |
| `kubeVersion`        | Force target Kubernetes version (using Helm capabilities if not set) | `nil`                          |

### NGINX parameters

| Parameter            | Description                                                          | Default                                                 |
|----------------------|----------------------------------------------------------------------|---------------------------------------------------------|
| `image.registry`     | NGINX image registry                                                 | `docker.io`                                             |
| `image.repository`   | NGINX image name                                                     | `bitnami/nginx`                                         |
| `image.tag`          | NGINX image tag                                                      | `{TAG_NAME}`                                            |
| `image.pullPolicy`   | NGINX image pull policy                                              | `IfNotPresent`                                          |
| `image.pullSecrets`  | Specify docker-registry secret names as an array                     | `[]` (does not add image pull secrets to deployed pods) |
| `image.debug`        | Set to true if you would like to see extra information on logs       | `false`                                                 |
| `hostAliases`        | Add deployment host aliases                                          | `[]`                                                    |
| `command`            | Override default container command (useful when using custom images) | `nil`                                                   |
| `args`               | Override default container args (useful when using custom images)    | `nil`                                                   |
| `extraEnvVars`       | Extra environment variables to be set on NGINX containers            | `[]`                                                    |
| `extraEnvVarsCM`     | Name of existing ConfigMap containing extra env vars                 | `nil`                                                   |
| `extraEnvVarsSecret` | Name of existing Secret containing extra env vars                    | `nil`                                                   |

### NGINX deployment parameters

| Parameter                    | Description                                                                                    | Default                                              |
|------------------------------|------------------------------------------------------------------------------------------------|------------------------------------------------------|
| `replicaCount`               | Number of NGINX replicas to deploy                                                             | `1`                                                  |
| `strategyType`               | Deployment Strategy Type                                                                       | `RollingUpdate`                                      |
| `podAffinityPreset`          | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`            | `""`                                                 |
| `podAntiAffinityPreset`      | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`       | `soft`                                               |
| `nodeAffinityPreset.type`    | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`      | `""`                                                 |
| `nodeAffinityPreset.key`     | Node label key to match Ignored if `affinity` is set.                                          | `""`                                                 |
| `nodeAffinityPreset.values`  | Node label values to match. Ignored if `affinity` is set.                                      | `[]`                                                 |
| `affinity`                   | Affinity for pod assignment                                                                    | `{}` (evaluated as a template)                       |
| `nodeSelector`               | Node labels for pod assignment                                                                 | `{}` (evaluated as a template)                       |
| `tolerations`                | Tolerations for pod assignment                                                                 | `[]` (evaluated as a template)                       |
| `podLabels`                  | Additional labels for NGINX pods                                                               | `{}` (evaluated as a template)                       |
| `podAnnotations`             | Annotations for NGINX pods                                                                     | `{}` (evaluated as a template)                       |
| `podSecurityContext`         | NGINX pods' Security Context                                                                   | Check `values.yaml` file                             |
| `containerSecurityContext`   | NGINX containers' Security Context                                                             | Check `values.yaml` file                             |
| `containerPorts.http`        | Sets http port inside NGINX container                                                          | `8080`                                               |
| `containerPorts.https`       | Sets https port inside NGINX container                                                         | `nil`                                                |
| `resources.limits`           | The resources limits for the NGINX container                                                   | `{}`                                                 |
| `resources.requests`         | The requested resources for the NGINX container                                                | `{}`                                                 |
| `livenessProbe`              | Liveness probe configuration for NGINX                                                         | Check `values.yaml` file                             |
| `readinessProbe`             | Readiness probe configuration for NGINX                                                        | Check `values.yaml` file                             |
| `customLivenessProbe`        | Override default liveness probe                                                                | `nil`                                                |
| `customReadinessProbe`       | Override default readiness probe                                                               | `nil`                                                |
| `autoscaling.enabled`        | Enable autoscaling for NGINX deployment                                                        | `false`                                              |
| `autoscaling.minReplicas`    | Minimum number of replicas to scale back                                                       | `nil`                                                |
| `autoscaling.maxReplicas`    | Maximum number of replicas to scale out                                                        | `nil`                                                |
| `autoscaling.targetCPU`      | Target CPU utilization percentage                                                              | `nil`                                                |
| `autoscaling.targetMemory`   | Target Memory utilization percentage                                                           | `nil`                                                |
| `extraVolumes`               | Array to add extra volumes                                                                     | `[]` (evaluated as a template)                       |
| `extraVolumeMounts`          | Array to add extra mount                                                                       | `[]` (evaluated as a template)                       |
| `sidecars`                   | Attach additional containers to nginx pods                                                     | `nil`                                                |
| `initContainers`             | Additional init containers (this value is evaluated as a template)                             | `[]`                                                 |
| `serviceAccount.create`      | Enable creation of ServiceAccount for nginx pod                                                | `false`                                              |
| `serviceAccount.name`        | The name of the service account to use. If not set and `create` is `true`, a name is generated | Generated using the `common.names.fullname` template |
| `serviceAccount.annotations` | Annotations for service account.                                                               | `{}`                                                 |

### Custom NGINX application parameters

| Parameter                                  | Description                                                 | Default                                                 |
|--------------------------------------------|-------------------------------------------------------------|---------------------------------------------------------|
| `cloneStaticSiteFromGit.enabled`           | Get the server static content from a GIT repository         | `false`                                                 |
| `cloneStaticSiteFromGit.image.registry`    | GIT image registry                                          | `docker.io`                                             |
| `cloneStaticSiteFromGit.image.repository`  | GIT image name                                              | `bitnami/git`                                           |
| `cloneStaticSiteFromGit.image.tag`         | GIT image tag                                               | `{TAG_NAME}`                                            |
| `cloneStaticSiteFromGit.image.pullPolicy`  | GIT image pull policy                                       | `Always`                                                |
| `cloneStaticSiteFromGit.image.pullSecrets` | Specify docker-registry secret names as an array            | `[]` (does not add image pull secrets to deployed pods) |
| `cloneStaticSiteFromGit.repository`        | GIT Repository to clone                                     | `nil`                                                   |
| `cloneStaticSiteFromGit.branch`            | GIT revision to checkout                                    | `nil`                                                   |
| `cloneStaticSiteFromGit.interval`          | Interval for sidecar container pull from the GIT repository | `60`                                                    |
| `serverBlock`                              | Custom NGINX server block                                   | `nil`                                                   |
| `existingServerBlockConfigmap`             | Name of existing PVC with custom NGINX server block         | `nil`                                                   |
| `staticSiteConfigmap`                      | Name of existing ConfigMap with the server static content   | `nil`                                                   |
| `staticSitePVC`                            | Name of existing PVC with the server static content         | `nil`                                                   |

### LDAP parameters

| Parameter                                   | Description                                                                              | Default                          |
|---------------------------------------------|------------------------------------------------------------------------------------------|----------------------------------|
| `ldapDaemon.enabled`                        | Enable LDAP Auth Daemon proxy                                                            | `false`                          |
| `ldapDaemon.image.registry`                 | LDAP AUth Daemon Image registry                                                          | `docker.io`                      |
| `ldapDaemon.image.repository`               | LDAP Auth Daemon Image name                                                              | `bitnami/nginx-ldap-auth-daemon` |
| `ldapDaemon.image.tag`                      | LDAP Auth Daemon Image tag                                                               | `{TAG_NAME}`                     |
| `ldapDaemon.image.pullPolicy`               | LDAP Auth Daemon Image pull policy                                                       | `IfNotPresent`                   |
| `ldapDaemon.port`                           | LDAP Auth Daemon port                                                                    | `8888`                           |
| `ldapDaemon.ldapConfig.uri`                 | LDAP Server URI, `ldap[s]:/<hostname>:<port>`                                            | `""`                             |
| `ldapDaemon.ldapConfig.baseDN`              | LDAP root DN to begin the search for the user                                            | `""`                             |
| `ldapDaemon.ldapConfig.bindDN`              | DN of user to bind to LDAP                                                               | `""`                             |
| `ldapDaemon.ldapConfig.bindPassword`        | Password for the user to bind to LDAP                                                    | `""`                             |
| `ldapDaemon.ldapConfig.filter`              | LDAP search filter for search+bind authentication                                        | `""`                             |
| `ldapDaemon.ldapConfig.httpRealm`           | LDAP HTTP auth realm                                                                     | `""`                             |
| `ldapDaemon.ldapConfig.httpCookieName`      | HTTP cookie name to be used in LDAP Auth                                                 | `""`                             |
| `ldapDaemon.nginxServerBlock`               | NGINX server block that configures LDAP communication. Overrides `ldapDaemon.ldapConfig` | See `values.yaml`                |
| `ldapDaemon.existingNginxServerBlockSecret` | Name of existing Secret with a NGINX server block to use for LDAP communication          | `nil`                            |
| `ldapDaemon.livenessProbe`                  | LDAP Auth Daemon Liveness Probe                                                          | See `values.yaml`                |
| `ldapDaemon.readinessProbe`                 | LDAP Auth Daemon Readiness Probe                                                         | See `values.yaml`                |

### Exposure parameters

| Parameter                        | Description                                                                             | Default                        |
|----------------------------------|-----------------------------------------------------------------------------------------|--------------------------------|
| `service.type`                   | Kubernetes Service type                                                                 | `LoadBalancer`                 |
| `service.port`                   | Service HTTP port                                                                       | `80`                           |
| `service.httpsPort`              | Service HTTPS port                                                                      | `443`                          |
| `service.nodePorts.http`         | Kubernetes http node port                                                               | `""`                           |
| `service.nodePorts.https`        | Kubernetes https node port                                                              | `""`                           |
| `service.targetPort.http`        | Kubernetes http targetPort                                                              | `http`                         |
| `service.targetPort.https`       | Kubernetes https targetPort                                                             | `https`                        |
| `service.externalTrafficPolicy`  | Enable client source IP preservation                                                    | `Cluster`                      |
| `service.loadBalancerIP`         | LoadBalancer service IP address                                                         | `""`                           |
| `service.annotations`            | Service annotations                                                                     | `{}`                           |
| `ingress.enabled`                | Enable ingress controller resource                                                      | `false`                        |
| `ingress.certManager`            | Add annotations for cert-manager                                                        | `false`                        |
| `ingress.hostname`               | Default host for the ingress resource                                                   | `nginx.local`                  |
| `ingress.apiVersion`             | Force Ingress API version (automatically detected if not set)                           | ``                             |
| `ingress.path`                   | Ingress path                                                                            | `/`                            |
| `ingress.pathType`               | Ingress path type                                                                       | `ImplementationSpecific`       |
| `ingress.tls`                    | Create TLS Secret                                                                       | `false`                        |
| `ingress.annotations`            | Ingress annotations                                                                     | `[]` (evaluated as a template) |
| `ingress.extraHosts[0].name`     | Additional hostnames to be covered                                                      | `nil`                          |
| `ingress.extraHosts[0].path`     | Additional hostnames to be covered                                                      | `nil`                          |
| `ingress.extraPaths`             | Additional arbitrary path/backend objects                                               | `nil`                          |
| `ingress.extraTls[0].hosts[0]`   | TLS configuration for additional hostnames to be covered                                | `nil`                          |
| `ingress.extraTls[0].secretName` | TLS configuration for additional hostnames to be covered                                | `nil`                          |
| `ingress.secrets[0].name`        | TLS Secret Name                                                                         | `nil`                          |
| `ingress.secrets[0].certificate` | TLS Secret Certificate                                                                  | `nil`                          |
| `ingress.secrets[0].key`         | TLS Secret Key                                                                          | `nil`                          |
| `healthIngress.enabled`          | Enable healthIngress controller resource                                                | `false`                        |
| `healthIngress.certManager`      | Add annotations for cert-manager                                                        | `false`                        |
| `healthIngress.hostname`         | Default host for the healthIngress resource                                             | `example.local`                |
| `healthIngress.path`             | Ingress path                                                                            | `/`                            |
| `healthIngress.pathType`         | Ingress path type                                                                       | `ImplementationSpecific`       |
| `healthIngress.tls`              | Enable TLS configuration for the hostname defined at `healthIngress.hostname` parameter | `false`                        |
| `healthIngress.annotations`      | Ingress annotations                                                                     | `[]`                           |
| `healthIngress.extraHosts`       | Additional hostnames to be covered                                                      | `[]`                           |
| `healthIngress.extraTls`         | TLS configuration for additional hostnames to be covered                                | `[]`                           |
| `healthIngress.secrets`          | TLS Secret configuration                                                                | `[]`                           |

### Metrics parameters

| Parameter                              | Description                                                                                 | Default                                                      |
|----------------------------------------|---------------------------------------------------------------------------------------------|--------------------------------------------------------------|
| `metrics.enabled`                      | Start a Prometheus exporter sidecar container                                               | `false`                                                      |
| `metrics.image.registry`               | NGINX Prometheus exporter image registry                                                    | `docker.io`                                                  |
| `metrics.image.repository`             | NGINX Prometheus exporter image name                                                        | `bitnami/nginx-exporter`                                     |
| `metrics.image.tag`                    | NGINX Prometheus exporter image tag                                                         | `{TAG_NAME}`                                                 |
| `metrics.image.pullPolicy`             | NGINX Prometheus exporter image pull policy                                                 | `IfNotPresent`                                               |
| `metrics.image.pullSecrets`            | Specify docker-registry secret names as an array                                            | `[]` (does not add image pull secrets to deployed pods)      |
| `metrics.podAnnotations`               | Additional annotations for NGINX Prometheus exporter pod(s)                                 | `{}`                                                         |
| `metrics.resources.limits`             | The resources limits for the NGINX Prometheus exporter container                            | `{}`                                                         |
| `metrics.resources.requests`           | The requested resources for the NGINX Prometheus exporter container                         | `{}`                                                         |
| `metrics.service.port`                 | NGINX Prometheus exporter service port                                                      | `9113`                                                       |
| `metrics.service.annotations`          | Annotations for Jenkins Prometheus exporter service                                         | `{prometheus.io/scrape: "true", prometheus.io/port: "9113"}` |
| `metrics.serviceMonitor.enabled`       | Creates a Prometheus Operator ServiceMonitor (also requires `metrics.enabled` to be `true`) | `false`                                                      |
| `metrics.serviceMonitor.namespace`     | Namespace in which Prometheus is running                                                    | `nil`                                                        |
| `metrics.serviceMonitor.interval`      | Interval at which metrics should be scraped.                                                | `nil` (Prometheus Operator default value)                    |
| `metrics.serviceMonitor.scrapeTimeout` | Timeout after which the scrape is ended                                                     | `nil` (Prometheus Operator default value)                    |
| `metrics.serviceMonitor.selector`      | Prometheus instance selector labels                                                         | `nil`                                                        |

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

```
                ┌────────────────┐           ┌────────────────┐           ┌────────────────┐
                │     NGINX      │  ----->   │     NGINX      │  ----->   │      LDAP      │
                │     server     │  <-----   |  ldap daemon   │  <-----   |     server     │
                └────────────────┘           └────────────────┘           └────────────────┘

```

In order to enable LDAP authentication you can set the `ldapDaemon.enabled` property and follow these steps:

1. NGINX server needs to be configured to be self-aware of the proxy. In order to do so, use the `ldapDaemon.nginxServerBlock` property to provide with an additional server block, that will instruct NGINX to use it (see `values.yaml`). Alternatively, you can specify this server block configuration using an external Secret using the property `ldapDaemon.existingNginxServerBlockSecret`.

2. Supply your LDAP Server connection details either in the aforementioned server block (setting request headers) or specifying them in `ldapDaemon.ldapConfig`. e.g. The following two approaches are equivalent:

_Approach A) Specify connection details using the `ldapDaemon.ldapConfig` property_

```yaml
ldapDaemon:
  enabled: true
  ldapConfig:
    uri: "ldap://YOUR_LDAP_SERVER_IP:YOUR_LDAP_SERVER_PORT"
    baseDN: "dc=example,dc=org"
    bindDN: "cn=admin,dc=example,dc=org"
    bindPassword: "adminpassword"

  nginxServerBlock: |-
    server {
    listen 0.0.0.0:{{ .Values.containerPorts.http }};

    # You can provide a special subPath or the root
    location = / {
        auth_request /auth-proxy;
    }

    location = /auth-proxy {
        internal;

        proxy_pass http://127.0.0.1:{{ .Values.ldapDaemon.port }};
    }
    }
```

_Approach B) Specify connection details directly in the server block_

```yaml
ldapDaemon:
  enabled: true
  nginxServerBlock: |-
    server {
    listen 0.0.0.0:{{ .Values.containerPorts.http }};

    # You can provide a special subPath or the root
    location = / {
        auth_request /auth-proxy;
    }

    location = /auth-proxy {
        internal;

        proxy_pass http://127.0.0.1:{{ .Values.ldapDaemon.port }};

        ###############################################################
        # YOU SHOULD CHANGE THE FOLLOWING TO YOUR LDAP CONFIGURATION  #
        ###############################################################

        # URL and port for connecting to the LDAP server
        proxy_set_header X-Ldap-URL "ldap://YOUR_LDAP_SERVER_IP:YOUR_LDAP_SERVER_PORT";

        # Base DN
        proxy_set_header X-Ldap-BaseDN "dc=example,dc=org";

        # Bind DN
        proxy_set_header X-Ldap-BindDN "cn=admin,dc=example,dc=org";

        # Bind password
        proxy_set_header X-Ldap-BindPass "adminpassword";
    }
    }
```

### Adding extra environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `extraEnvVars` property.

```yaml
extraEnvVars:
  - name: LOG_LEVEL
    value: error
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values.

### Setting Pod's affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinity) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

### Deploying extra resources

There are cases where you may want to deploy extra objects, such a ConfigMap containing your app's configuration or some extra deployment with a micro service used by your app. For covering this case, the chart allows adding the full specification of other objects using the `extraDeploy` parameter.

### Ingress

This chart provides support for ingress resources. If you have an ingress controller installed on your cluster, such as [nginx-ingress-controller](https://github.com/bitnami/charts/tree/master/bitnami/nginx-ingress-controller) or [contour](https://github.com/bitnami/charts/tree/master/bitnami/contour) you can utilize the ingress controller to serve your application.

To enable ingress integration, please set `ingress.enabled` to `true`.

#### Hosts

Most likely you will only want to have one hostname that maps to this NGINX installation. If that's your case, the property `ingress.hostname` will set it. However, it is possible to have more than one host. To facilitate this, the `ingress.extraHosts` object can be specified as an array. You can also use `ingress.extraTLS` to add the TLS configuration for extra hosts.

For each host indicated at `ingress.extraHosts`, please indicate a `name`, `path`, and any `annotations` that you may want the ingress controller to know about.

For annotations, please see [this document](https://github.com/kubernetes/ingress-nginx/blob/master/docs/user-guide/nginx-configuration/annotations.md). Not all annotations are supported by all ingress controllers, but this document does a good job of indicating which annotation is supported by many popular ingress controllers.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami’s Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 8.0.0

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

### To 7.0.0

- This version also introduces `bitnami/common`, a [library chart](https://helm.sh/docs/topics/library_charts/#helm) as a dependency. More documentation about this new utility could be found [here](https://github.com/bitnami/charts/tree/master/bitnami/common#bitnami-common-library-chart). Please, make sure that you have updated the chart dependencies before executing any upgrade.
- Ingress configuration was also adapted to follow the Helm charts best practices.

> Note: There is no backwards compatibility due to the above mentioned changes. It's necessary to install a new release of the chart, and migrate your existing application to the new NGINX instances.

### To 5.6.0

Added support for the use of LDAP.

### To 5.0.0

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

## Bitnami Kubernetes Documentation

Bitnami Kubernetes documentation is available at [https://docs.bitnami.com/](https://docs.bitnami.com/). You can find there the following resources:

- [Documentation for NGINX Helm chart](https://docs.bitnami.com/kubernetes/infrastructure/nginx/)
- [Get Started with Kubernetes guides](https://docs.bitnami.com/kubernetes/)
- [Bitnami Helm charts documentation](https://docs.bitnami.com/kubernetes/apps/)
- [Kubernetes FAQs](https://docs.bitnami.com/kubernetes/faq/)
- [Kubernetes Developer guides](https://docs.bitnami.com/tutorials/)
