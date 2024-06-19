<!--- app-name: Concourse -->

# Bitnami package for Concourse

Concourse is an automation system written in Go. It is most commonly used for CI/CD, and is built to scale to any kind of automation pipeline, from simple to complex.

[Overview of Concourse](https://concourse-ci.org/)

## TL;DR

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/concourse
```

Looking to use Concourse in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the enterprise edition of Bitnami Application Catalog.

## Introduction

This chart bootstraps a [Concourse](https://concourse-ci.org/) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages [Bitnami Postgresql](https://github.com/bitnami/charts/tree/main/bitnami/postgresql)

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+
- PV provisioner support in the underlying infrastructure
- ReadWriteMany volumes for deployment scaling

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/concourse
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The command deploys concourse on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Configuration and installation details

### Resource requests and limits

Bitnami charts allow setting resource requests and limits for all containers inside the chart deployment. These are inside the `resources` value (check parameter table). Setting requests is essential for production workloads and these should be adapted to your specific use case.

To make this process easier, the chart contains the `resourcesPreset` values, which automatically sets the `resources` section according to different presets. Check these presets in [the bitnami/common chart](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15). However, in production workloads using `resourcePreset` is discouraged as it may not fully adapt to your specific needs. Find more information on container resource management in the [official Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).

### [Rolling vs Immutable tags](https://docs.vmware.com/en/VMware-Tanzu-Application-Catalog/services/tutorials/GUID-understand-rolling-tags-containers-index.html)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Use an external database

Sometimes, you may want to have Concourse connect to an external database rather than a database within your cluster - for example, when using a managed database service, or when running a single database server for all your applications. To do this, set the `postgresql.enabled` parameter to `false` and specify the credentials for the external database using the `externalDatabase.*` parameters. Here is an example:

```text
postgresql.enabled=false
externalDatabase.host=myexternalhost
externalDatabase.user=myuser
externalDatabase.password=mypassword
externalDatabase.database=mydatabase
externalDatabase.port=5432
```

### Configure Ingress

This chart provides support for Ingress resources. If you have an ingress controller installed on your cluster, such as [nginx-ingress-controller](https://github.com/bitnami/charts/tree/main/bitnami/nginx-ingress-controller) or [contour](https://github.com/bitnami/charts/tree/main/bitnami/contour) you can utilize the ingress controller to serve your application.To enable Ingress integration, set `ingress.enabled` to `true`.

The most common scenario is to have one host name mapped to the deployment. In this case, the `ingress.hostname` property can be used to set the host name. The `ingress.tls` parameter can be used to add the TLS configuration for this host.

However, it is also possible to have more than one host. To facilitate this, the `ingress.extraHosts` parameter (if available) can be set with the host names specified as an array. The `ingress.extraTLS` parameter (if available) can also be used to add the TLS configuration for extra hosts.

> NOTE: For each host specified in the `ingress.extraHosts` parameter, it is necessary to set a name, path, and any annotations that the Ingress controller should know about. Not all annotations are supported by all Ingress controllers, but [this annotation reference document](https://github.com/kubernetes/ingress-nginx/blob/master/docs/user-guide/nginx-configuration/annotations.md) lists the annotations supported by many popular Ingress controllers.

Adding the TLS parameter (where available) will cause the chart to generate HTTPS URLs, and the  application will be available on port 443. The actual TLS secrets do not have to be generated by this chart. However, if TLS is enabled, the Ingress record will not work until the TLS secret exists.

[Learn more about Ingress controllers](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/).

### Configure TLS Secrets for use with Ingress

This chart facilitates the creation of TLS secrets for use with the Ingress controller (although this is not mandatory). There are several common use cases:

- Generate certificate secrets based on chart parameters.
- Enable externally generated certificates.
- Manage application certificates via an external service (like [cert-manager](https://github.com/jetstack/cert-manager/)).
- Create self-signed certificates within the chart (if supported).

In the first two cases, a certificate and a key are needed. Files are expected in `.pem` format.

Here is an example of a certificate file:

> NOTE: There may be more than one certificate if there is a certificate chain.

```text
-----BEGIN CERTIFICATE-----
MIID6TCCAtGgAwIBAgIJAIaCwivkeB5EMA0GCSqGSIb3DQEBCwUAMFYxCzAJBgNV
...
jScrvkiBO65F46KioCL9h5tDvomdU1aqpI/CBzhvZn1c0ZTf87tGQR8NK7v7
-----END CERTIFICATE-----
```

Here is an example of a certificate key:

```text
-----BEGIN RSA PRIVATE KEY-----
MIIEogIBAAKCAQEAvLYcyu8f3skuRyUgeeNpeDvYBCDcgq+LsWap6zbX5f8oLqp4
...
wrj2wDbCDCFmfqnSJ+dKI3vFLlEz44sAV8jX/kd4Y6ZTQhlLbYc=
-----END RSA PRIVATE KEY-----
```

- If using Helm to manage the certificates based on the parameters, copy these values into the `certificate` and `key` values for a given `*.ingress.secrets` entry.
- If managing TLS secrets separately, it is necessary to create a TLS secret with name `INGRESS_HOSTNAME-tls` (where INGRESS_HOSTNAME is a placeholder to be replaced with the hostname you set using the `*.ingress.hostname` parameter).
- If your cluster has a [cert-manager](https://github.com/jetstack/cert-manager) add-on to automate the management and issuance of TLS certificates, add to `*.ingress.annotations` the [corresponding ones](https://cert-manager.io/docs/usage/ingress/#supported-annotations) for cert-manager.
- If using self-signed certificates created by Helm, set both `*.ingress.tls` and `*.ingress.selfSigned` to `true`.

### Configure extra environment variables

To add extra environment variables (useful for advanced operations like custom init scripts), use the `extraEnvVars` property.

```yaml
extraEnvVars:
  - name: LOG_LEVEL
    value: DEBUG
```

Alternatively, use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values.

### Configure Sidecars and Init Containers

If additional containers are needed in the same pod as Concourse (such as additional metrics or logging exporters), they can be defined using the `sidecars` parameter.

```yaml
sidecars:
- name: your-image-name
  image: your-image
  imagePullPolicy: Always
  ports:
  - name: portname
    containerPort: 1234
```

If these sidecars export extra ports, extra port definitions can be added using the `service.extraPorts` parameter (where available), as shown in the example below:

```yaml
service:
  extraPorts:
  - name: extraPort
    port: 11311
    targetPort: 11311
```

> NOTE: This Helm chart already includes sidecar containers for the Prometheus exporters (where applicable). These can be activated by adding the `--enable-metrics=true` parameter at deployment time. The `sidecars` parameter should therefore only be used for any extra sidecar containers.

If additional init containers are needed in the same pod, they can be defined using the `initContainers` parameter. Here is an example:

```yaml
initContainers:
  - name: your-image-name
    image: your-image
    imagePullPolicy: Always
    ports:
      - name: portname
        containerPort: 1234
```

Learn more about [sidecar containers](https://kubernetes.io/docs/concepts/workloads/pods/) and [init containers](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/).

### Set Pod affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod affinity in the [Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, use one of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

## Persistence

The [Bitnami Concourse](https://github.com/bitnami/containers/tree/main/bitnami/concourse) image stores the concourse data and configurations at the `/bitnami` path of the container. Persistent Volume Claims are used to keep the data across deployments.

## Parameters

### Global parameters

| Name                                                  | Description                                                                                                                                                                                                                                                                                                                                                         | Value      |
| ----------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------- |
| `global.imageRegistry`                                | Global Docker image registry                                                                                                                                                                                                                                                                                                                                        | `""`       |
| `global.imagePullSecrets`                             | Global Docker registry secret names as an array                                                                                                                                                                                                                                                                                                                     | `[]`       |
| `global.storageClass`                                 | Global StorageClass for Persistent Volume(s)                                                                                                                                                                                                                                                                                                                        | `""`       |
| `global.compatibility.openshift.adaptSecurityContext` | Adapt the securityContext sections of the deployment to make them compatible with Openshift restricted-v2 SCC: remove runAsUser, runAsGroup and fsGroup and let the platform use their allowed default IDs. Possible values: auto (apply if the detected running cluster is Openshift), force (perform the adaptation always), disabled (do not perform adaptation) | `disabled` |

### Common parameters

| Name                     | Description                                                                             | Value           |
| ------------------------ | --------------------------------------------------------------------------------------- | --------------- |
| `kubeVersion`            | Override Kubernetes version                                                             | `""`            |
| `nameOverride`           | String to partially override common.names.fullname                                      | `""`            |
| `fullnameOverride`       | String to fully override common.names.fullname                                          | `""`            |
| `clusterDomain`          | Kubernetes Cluster Domain                                                               | `cluster.local` |
| `commonLabels`           | Labels to add to all deployed objects                                                   | `{}`            |
| `commonAnnotations`      | Annotations to add to all deployed objects                                              | `{}`            |
| `extraDeploy`            | Array of extra objects to deploy with the release                                       | `[]`            |
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden) | `false`         |
| `diagnosticMode.command` | Command to override all containers in the deployment(s)/statefulset(s)                  | `["sleep"]`     |
| `diagnosticMode.args`    | Args to override all containers in the deployment(s)/statefulset(s)                     | `["infinity"]`  |

### Common Concourse Parameters

| Name                            | Description                                                                                                                            | Value                       |
| ------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------- | --------------------------- |
| `image.registry`                | image registry                                                                                                                         | `REGISTRY_NAME`             |
| `image.repository`              | image repository                                                                                                                       | `REPOSITORY_NAME/concourse` |
| `image.digest`                  | image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                        | `""`                        |
| `image.pullPolicy`              | image pull policy                                                                                                                      | `IfNotPresent`              |
| `image.pullSecrets`             | image pull secrets                                                                                                                     | `[]`                        |
| `secrets.localAuth.enabled`     | the use of local authentication (basic auth).                                                                                          | `true`                      |
| `secrets.localUsers`            | List of `username:password` or `username:bcrypted_password` combinations for all your local concourse users. Auto-generated if not set | `""`                        |
| `secrets.teamAuthorizedKeys`    | Array of team names and public keys for team external workers                                                                          | `[]`                        |
| `secrets.conjurAccount`         | Account for Conjur auth provider.                                                                                                      | `""`                        |
| `secrets.conjurAuthnLogin`      | Host username for Conjur auth provider.                                                                                                | `""`                        |
| `secrets.conjurAuthnApiKey`     | API key for host used for Conjur auth provider. Either API key or token file can be used, but not both.                                | `""`                        |
| `secrets.conjurAuthnTokenFile`  | Token file used for Conjur auth provider if running in Kubernetes or IAM. Either token file or API key can be used, but not both.      | `""`                        |
| `secrets.conjurCACert`          | CA Certificate to specify if conjur instance is deployed with a self-signed cert                                                       | `""`                        |
| `secrets.hostKey`               | Concourse Host Keys.                                                                                                                   | `""`                        |
| `secrets.hostKeyPub`            | Concourse Host Keys.                                                                                                                   | `""`                        |
| `secrets.sessionSigningKey`     | Concourse Session Signing Keys.                                                                                                        | `""`                        |
| `secrets.workerKey`             | Concourse Worker Keys.                                                                                                                 | `""`                        |
| `secrets.workerKeyPub`          | Concourse Worker Keys.                                                                                                                 | `""`                        |
| `secrets.workerAdditionalCerts` | Additional certificates to add to the worker nodes                                                                                     | `""`                        |

### Concourse Web parameters

| Name                                                    | Description                                                                                                                                                                                                               | Value                                           |
| ------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------- |
| `web.enabled`                                           | Enable Concourse web component                                                                                                                                                                                            | `true`                                          |
| `web.baseUrl`                                           | url                                                                                                                                                                                                                       | `/`                                             |
| `web.logLevel`                                          | Minimum level of logs to see. Possible options: debug, info, error.                                                                                                                                                       | `debug`                                         |
| `web.clusterName`                                       | A name for this Concourse cluster, to be displayed on the dashboard page.                                                                                                                                                 | `""`                                            |
| `web.bindIp`                                            | IP address on which to listen for HTTP traffic (web UI and API).                                                                                                                                                          | `0.0.0.0`                                       |
| `web.peerAddress`                                       | Network address of this web node, reachable by other web nodes.                                                                                                                                                           | `""`                                            |
| `web.externalUrl`                                       | URL used to reach any ATC from the outside world.                                                                                                                                                                         | `""`                                            |
| `web.auth.cookieSecure`                                 | use cookie secure true or false                                                                                                                                                                                           | `false`                                         |
| `web.auth.duration`                                     | Length of time for which tokens are valid. Afterwards, users will have to log back in.                                                                                                                                    | `24h`                                           |
| `web.auth.passwordConnector`                            | The connector to use for password authentication for `fly login -u ... -p ...`.                                                                                                                                           | `""`                                            |
| `web.auth.mainTeam.config`                              | Configuration file for specifying the main teams params.                                                                                                                                                                  | `""`                                            |
| `web.auth.mainTeam.localUser`                           | Comma-separated list of local Concourse users to be included as members of the `main` team.                                                                                                                               | `user`                                          |
| `web.existingSecret`                                    | Use an existing secret for the Web service credentials                                                                                                                                                                    | `""`                                            |
| `web.enableAcrossStep`                                  | Enable the experimental across step to be used in jobs. The API is subject to change.                                                                                                                                     | `false`                                         |
| `web.enablePipelineInstances`                           | Enable the creation of instanced pipelines.                                                                                                                                                                               | `false`                                         |
| `web.enableCacheStreamedVolumes`                        | Enable caching streamed resource volumes on the destination worker.                                                                                                                                                       | `false`                                         |
| `web.baseResourceTypeDefaults`                          | Configuration file for specifying defaults for base resource types                                                                                                                                                        | `""`                                            |
| `web.tsa.logLevel`                                      | Minimum level of logs to see. Possible values: debug, info, error                                                                                                                                                         | `debug`                                         |
| `web.tsa.bindIp`                                        | IP address on which to listen for SSH                                                                                                                                                                                     | `0.0.0.0`                                       |
| `web.tsa.debugBindIp`                                   | IP address on which to listen for the pprof debugger endpoints (default: 127.0.0.1)                                                                                                                                       | `127.0.0.1`                                     |
| `web.tsa.heartbeatInterval`                             | Interval on which to heartbeat workers to the ATC                                                                                                                                                                         | `30s`                                           |
| `web.tsa.gardenRequestTimeout`                          | How long to wait for requests to Garden to complete. 0 means no timeout                                                                                                                                                   | `""`                                            |
| `web.tls.enabled`                                       | enable serving HTTPS traffic directly through the web component.                                                                                                                                                          | `false`                                         |
| `web.configRBAC`                                        | Set RBAC configuration                                                                                                                                                                                                    | `""`                                            |
| `web.conjur.enabled`                                    | Enable the use of Conjur as a credential manager                                                                                                                                                                          | `false`                                         |
| `web.conjur.applianceUrl`                               | URL of the Conjur instance.                                                                                                                                                                                               | `""`                                            |
| `web.conjur.pipelineSecretTemplate`                     | Path used to locate pipeline-level secret                                                                                                                                                                                 | `concourse/{{.Team}}/{{.Pipeline}}/{{.Secret}}` |
| `web.conjur.teamSecretTemplate`                         | Path used to locate team-level secret                                                                                                                                                                                     | `concourse/{{.Team}}/{{.Secret}}`               |
| `web.conjur.secretTemplate`                             | Path used to locate a vault or safe-level secret                                                                                                                                                                          | `concourse/{{.Secret}}`                         |
| `web.existingConfigmap`                                 | The name of an existing ConfigMap with your custom configuration for web                                                                                                                                                  | `""`                                            |
| `web.command`                                           | Override default container command (useful when using custom images)                                                                                                                                                      | `[]`                                            |
| `web.args`                                              | Override default container args (useful when using custom images)                                                                                                                                                         | `[]`                                            |
| `web.extraEnvVars`                                      | Array with extra environment variables to add to Concourse web nodes                                                                                                                                                      | `[]`                                            |
| `web.extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for Concourse web nodes                                                                                                                                              | `""`                                            |
| `web.extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for Concourse web nodes                                                                                                                                                 | `""`                                            |
| `web.replicaCount`                                      | Number of Concourse web replicas to deploy                                                                                                                                                                                | `1`                                             |
| `web.containerPorts.http`                               | Concourse web UI and API HTTP container port                                                                                                                                                                              | `8080`                                          |
| `web.containerPorts.https`                              | Concourse web UI and API HTTPS container port                                                                                                                                                                             | `8443`                                          |
| `web.containerPorts.tsa`                                | Concourse web TSA SSH container port                                                                                                                                                                                      | `2222`                                          |
| `web.containerPorts.pprof`                              | Concourse web TSA pprof server container port                                                                                                                                                                             | `2221`                                          |
| `web.networkPolicy.enabled`                             | Specifies whether a NetworkPolicy should be created                                                                                                                                                                       | `true`                                          |
| `web.networkPolicy.allowExternal`                       | Don't require server label for connections                                                                                                                                                                                | `true`                                          |
| `web.networkPolicy.allowExternalEgress`                 | Allow the pod to access any range of port and all destinations.                                                                                                                                                           | `true`                                          |
| `web.networkPolicy.kubeAPIServerPorts`                  | List of possible endpoints to kube-apiserver (limit to your cluster settings to increase security)                                                                                                                        | `[]`                                            |
| `web.networkPolicy.extraIngress`                        | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                              | `[]`                                            |
| `web.networkPolicy.extraEgress`                         | Add extra ingress rules to the NetworkPolicy (ignored if allowExternalEgress=true)                                                                                                                                        | `[]`                                            |
| `web.networkPolicy.ingressNSMatchLabels`                | Labels to match to allow traffic from other namespaces                                                                                                                                                                    | `{}`                                            |
| `web.networkPolicy.ingressNSPodMatchLabels`             | Pod labels to match to allow traffic from other namespaces                                                                                                                                                                | `{}`                                            |
| `web.livenessProbe.enabled`                             | Enable livenessProbe on Concourse web containers                                                                                                                                                                          | `true`                                          |
| `web.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                                   | `10`                                            |
| `web.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                          | `15`                                            |
| `web.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                         | `3`                                             |
| `web.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                                       | `1`                                             |
| `web.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                                       | `1`                                             |
| `web.readinessProbe.enabled`                            | Enable readinessProbe on Concourse web containers                                                                                                                                                                         | `true`                                          |
| `web.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                                  | `10`                                            |
| `web.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                         | `15`                                            |
| `web.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                        | `3`                                             |
| `web.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                                      | `1`                                             |
| `web.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                                      | `1`                                             |
| `web.startupProbe.enabled`                              | Enable startupProbe on Concourse web containers                                                                                                                                                                           | `false`                                         |
| `web.startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                                    | `5`                                             |
| `web.startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                           | `10`                                            |
| `web.startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                          | `1`                                             |
| `web.startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                        | `15`                                            |
| `web.startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                        | `1`                                             |
| `web.customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                                                                                                                       | `{}`                                            |
| `web.customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                                                                                                                                      | `{}`                                            |
| `web.customStartupProbe`                                | Custom startupProbe that overrides the default one                                                                                                                                                                        | `{}`                                            |
| `web.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if web.resources is set (web.resources is recommended for production). | `nano`                                          |
| `web.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                         | `{}`                                            |
| `web.podSecurityContext.enabled`                        | Enabled web pods' Security Context                                                                                                                                                                                        | `true`                                          |
| `web.podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                        | `Always`                                        |
| `web.podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                            | `[]`                                            |
| `web.podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                               | `[]`                                            |
| `web.podSecurityContext.fsGroup`                        | Set web pod's Security Context fsGroup                                                                                                                                                                                    | `1001`                                          |
| `web.containerSecurityContext.enabled`                  | web container securityContext                                                                                                                                                                                             | `true`                                          |
| `web.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                          | `nil`                                           |
| `web.containerSecurityContext.runAsUser`                | User ID for the web container                                                                                                                                                                                             | `1001`                                          |
| `web.containerSecurityContext.runAsGroup`               | Group ID for the web container                                                                                                                                                                                            | `1001`                                          |
| `web.containerSecurityContext.runAsNonRoot`             | Set web container's Security Context runAsNonRoot                                                                                                                                                                         | `true`                                          |
| `web.containerSecurityContext.privileged`               | Set web container's Security Context privileged                                                                                                                                                                           | `false`                                         |
| `web.containerSecurityContext.allowPrivilegeEscalation` | Set web container's Security Context allowPrivilegeEscalation                                                                                                                                                             | `false`                                         |
| `web.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                                   | `true`                                          |
| `web.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                        | `["ALL"]`                                       |
| `web.containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                          | `RuntimeDefault`                                |
| `web.automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                        | `true`                                          |
| `web.hostAliases`                                       | Concourse web pod host aliases                                                                                                                                                                                            | `[]`                                            |
| `web.podLabels`                                         | Extra labels for Concourse web pods                                                                                                                                                                                       | `{}`                                            |
| `web.podAnnotations`                                    | Annotations for Concourse web pods                                                                                                                                                                                        | `{}`                                            |
| `web.podAffinityPreset`                                 | Pod affinity preset. Ignored if `web.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                   | `""`                                            |
| `web.podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `web.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                              | `soft`                                          |
| `web.nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `web.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                             | `""`                                            |
| `web.nodeAffinityPreset.key`                            | Node label key to match. Ignored if `web.affinity` is set                                                                                                                                                                 | `""`                                            |
| `web.nodeAffinityPreset.values`                         | Node label values to match. Ignored if `web.affinity` is set                                                                                                                                                              | `[]`                                            |
| `web.affinity`                                          | Affinity for web pods assignment                                                                                                                                                                                          | `{}`                                            |
| `web.nodeSelector`                                      | Node labels for web pods assignment                                                                                                                                                                                       | `{}`                                            |
| `web.tolerations`                                       | Tolerations for web pods assignment                                                                                                                                                                                       | `[]`                                            |
| `web.topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template                                                                                                  | `[]`                                            |
| `web.priorityClassName`                                 | Priority Class to use for each pod (Concourse web)                                                                                                                                                                        | `""`                                            |
| `web.schedulerName`                                     | Use an alternate scheduler, e.g. "stork".                                                                                                                                                                                 | `""`                                            |
| `web.terminationGracePeriodSeconds`                     | Seconds Concourse web pod needs to terminate gracefully                                                                                                                                                                   | `""`                                            |
| `web.updateStrategy.rollingUpdate`                      | Concourse web statefulset rolling update configuration parameters                                                                                                                                                         | `{}`                                            |
| `web.updateStrategy.type`                               | Concourse web statefulset strategy type                                                                                                                                                                                   | `RollingUpdate`                                 |
| `web.lifecycleHooks`                                    | lifecycleHooks for the Concourse web container(s)                                                                                                                                                                         | `{}`                                            |
| `web.extraVolumes`                                      | Optionally specify extra list of additional volumeMounts for the Concourse web container(s)                                                                                                                               | `[]`                                            |
| `web.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the Concourse web container(s)                                                                                                                               | `[]`                                            |
| `web.sidecars`                                          | Add additional sidecar containers to the Concourse web pod(s)                                                                                                                                                             | `[]`                                            |
| `web.initContainers`                                    | Add additional init containers to the Concourse web pod(s)                                                                                                                                                                | `[]`                                            |
| `web.pdb.create`                                        | Create Pod disruption budget object for Concourse worker nodes                                                                                                                                                            | `true`                                          |
| `web.pdb.minAvailable`                                  | Minimum number / percentage of Concourse worker pods that should remain scheduled                                                                                                                                         | `""`                                            |
| `web.pdb.maxUnavailable`                                | Maximum number/percentage of Concourse worker pods that may be made unavailable                                                                                                                                           | `""`                                            |
| `web.psp.create`                                        | Whether to create a PodSecurityPolicy. WARNING: PodSecurityPolicy is deprecated in Kubernetes v1.21 or later, unavailable in v1.25 or later                                                                               | `false`                                         |
| `web.rbac.create`                                       | Specifies whether RBAC resources should be created                                                                                                                                                                        | `true`                                          |
| `web.rbac.rules`                                        | Custom RBAC rules to set                                                                                                                                                                                                  | `[]`                                            |
| `web.serviceAccount.create`                             | Specifies whether a ServiceAccount should be created                                                                                                                                                                      | `true`                                          |
| `web.serviceAccount.name`                               | Override Web service account name                                                                                                                                                                                         | `""`                                            |
| `web.serviceAccount.automountServiceAccountToken`       | Allows auto mount of ServiceAccountToken on the serviceAccount created                                                                                                                                                    | `false`                                         |
| `web.serviceAccount.annotations`                        | Additional custom annotations for the ServiceAccount                                                                                                                                                                      | `{}`                                            |

### Concourse Worker parameters

| Name                                                       | Description                                                                                                                                                                                                                     | Value               |
| ---------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------- |
| `worker.enabled`                                           | Enable Concourse worker nodes                                                                                                                                                                                                   | `true`              |
| `worker.runtime`                                           | Set CONCURSE_RUNTIME in worker nodes. Please note the default runtime (guardian) only supports cgroupsv1.                                                                                                                       | `containerd`        |
| `worker.logLevel`                                          | Minimum level of logs to see. Possible options: debug, info, error                                                                                                                                                              | `debug`             |
| `worker.bindIp`                                            | IP address on which to listen for the Garden server.                                                                                                                                                                            | `127.0.0.1`         |
| `worker.tsa.hosts`                                         | TSA host(s) to forward the worker through                                                                                                                                                                                       | `[]`                |
| `worker.existingSecret`                                    | name of an existing secret resource containing the keys and the pub                                                                                                                                                             | `""`                |
| `worker.baggageclaim.logLevel`                             | Minimum level of logs to see. Allowed values: `debug`, `info`, and `error`                                                                                                                                                      | `info`              |
| `worker.baggageclaim.bindIp`                               | IP address on which to listen for API traffic                                                                                                                                                                                   | `127.0.0.1`         |
| `worker.baggageclaim.debugBindIp`                          | IP address on which to listen for the pprof debugger endpoints                                                                                                                                                                  | `127.0.0.1`         |
| `worker.baggageclaim.disableUserNamespaces`                | Disable remapping of user/group IDs in unprivileged volumes                                                                                                                                                                     | `""`                |
| `worker.baggageclaim.volumes`                              | Directory in which to place volume data                                                                                                                                                                                         | `""`                |
| `worker.baggageclaim.driver`                               | Driver to use for managing volumes. Allowed values: `detect`, `naive`, `btrfs`, and `overlay`                                                                                                                                   | `""`                |
| `worker.baggageclaim.btrfsBin`                             | Path to btrfs binary                                                                                                                                                                                                            | `btrfs`             |
| `worker.baggageclaim.mkfsBin`                              | Path to mkfs.btrfs binary                                                                                                                                                                                                       | `mkfs.btrfs`        |
| `worker.baggageclaim.overlaysDir`                          | Path to directory in which to store overlay data                                                                                                                                                                                | `""`                |
| `worker.command`                                           | Override default container command (useful when using custom images)                                                                                                                                                            | `[]`                |
| `worker.args`                                              | Override worker default args                                                                                                                                                                                                    | `[]`                |
| `worker.replicaCount`                                      | Number of worker replicas                                                                                                                                                                                                       | `2`                 |
| `worker.mode`                                              | Selects kind of Deployment. Allowed values: `deployment` or `statefulset`                                                                                                                                                       | `deployment`        |
| `worker.containerPorts.garden`                             | Concourse worker Garden server container port                                                                                                                                                                                   | `7777`              |
| `worker.containerPorts.health`                             | Concourse worker health-check container port                                                                                                                                                                                    | `8888`              |
| `worker.containerPorts.baggageclaim`                       | Concourse worker baggageclaim API container port                                                                                                                                                                                | `7788`              |
| `worker.containerPorts.pprof`                              | Concourse worker baggageclaim pprof server container port                                                                                                                                                                       | `7787`              |
| `worker.networkPolicy.enabled`                             | Specifies whether a NetworkPolicy should be created                                                                                                                                                                             | `true`              |
| `worker.networkPolicy.allowExternal`                       | Don't require server label for connections                                                                                                                                                                                      | `true`              |
| `worker.networkPolicy.allowExternalEgress`                 | Allow the pod to access any range of port and all destinations.                                                                                                                                                                 | `true`              |
| `worker.networkPolicy.kubeAPIServerPorts`                  | List of possible endpoints to kube-apiserver (limit to your cluster settings to increase security)                                                                                                                              | `[]`                |
| `worker.networkPolicy.extraIngress`                        | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                                    | `[]`                |
| `worker.networkPolicy.extraEgress`                         | Add extra ingress rules to the NetworkPolicy (ignored if allowExternalEgress=true)                                                                                                                                              | `[]`                |
| `worker.networkPolicy.ingressNSMatchLabels`                | Labels to match to allow traffic from other namespaces                                                                                                                                                                          | `{}`                |
| `worker.networkPolicy.ingressNSPodMatchLabels`             | Pod labels to match to allow traffic from other namespaces                                                                                                                                                                      | `{}`                |
| `worker.livenessProbe.enabled`                             | Enable livenessProbe on Concourse worker containers                                                                                                                                                                             | `true`              |
| `worker.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                                         | `10`                |
| `worker.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                                | `15`                |
| `worker.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                               | `3`                 |
| `worker.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                                             | `1`                 |
| `worker.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                                             | `1`                 |
| `worker.readinessProbe.enabled`                            | Enable readinessProbe on Concourse worker containers                                                                                                                                                                            | `true`              |
| `worker.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                                        | `10`                |
| `worker.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                               | `15`                |
| `worker.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                              | `3`                 |
| `worker.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                                            | `1`                 |
| `worker.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                                            | `1`                 |
| `worker.startupProbe.enabled`                              | Enable startupProbe on Concourse worker containers                                                                                                                                                                              | `false`             |
| `worker.startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                                          | `5`                 |
| `worker.startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                                 | `10`                |
| `worker.startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                                | `1`                 |
| `worker.startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                              | `15`                |
| `worker.startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                              | `1`                 |
| `worker.customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                                                                                                                             | `{}`                |
| `worker.customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                                                                                                                                            | `{}`                |
| `worker.customStartupProbe`                                | Custom startupProbe that overrides the default one                                                                                                                                                                              | `{}`                |
| `worker.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if worker.resources is set (worker.resources is recommended for production). | `nano`              |
| `worker.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                               | `{}`                |
| `worker.podSecurityContext.enabled`                        | Enabled worker pods' Security Context                                                                                                                                                                                           | `true`              |
| `worker.podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                              | `Always`            |
| `worker.podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                                  | `[]`                |
| `worker.podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                                     | `[]`                |
| `worker.podSecurityContext.fsGroup`                        | Set worker pod's Security Context fsGroup                                                                                                                                                                                       | `1001`              |
| `worker.containerSecurityContext.enabled`                  | worker container securityContext                                                                                                                                                                                                | `true`              |
| `worker.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                                | `nil`               |
| `worker.containerSecurityContext.runAsUser`                | User ID for the worker container                                                                                                                                                                                                | `0`                 |
| `worker.containerSecurityContext.runAsGroup`               | Group ID for the worker container                                                                                                                                                                                               | `0`                 |
| `worker.containerSecurityContext.runAsNonRoot`             | Set worker container's Security Context runAsNonRoot                                                                                                                                                                            | `false`             |
| `worker.containerSecurityContext.privileged`               | Set worker container's Security Context privileged                                                                                                                                                                              | `true`              |
| `worker.containerSecurityContext.allowPrivilegeEscalation` | Set worker container's Security Context allowPrivilegeEscalation                                                                                                                                                                | `true`              |
| `worker.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                                         | `false`             |
| `worker.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                              | `["ALL"]`           |
| `worker.containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                                | `RuntimeDefault`    |
| `worker.automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                              | `true`              |
| `worker.hostAliases`                                       | Concourse worker pod host aliases                                                                                                                                                                                               | `[]`                |
| `worker.podLabels`                                         | Custom labels for Concourse worker pods                                                                                                                                                                                         | `{}`                |
| `worker.podAnnotations`                                    | Annotations for Concourse worker pods                                                                                                                                                                                           | `{}`                |
| `worker.podAffinityPreset`                                 | Pod affinity preset. Ignored if `worker.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                      | `""`                |
| `worker.podAntiAffinityPreset`                             | Pod anti-affinity preset                                                                                                                                                                                                        | `soft`              |
| `worker.nodeAffinityPreset.type`                           | Node affinity type                                                                                                                                                                                                              | `""`                |
| `worker.nodeAffinityPreset.key`                            | Node label key to match                                                                                                                                                                                                         | `""`                |
| `worker.nodeAffinityPreset.values`                         | Node label values to match                                                                                                                                                                                                      | `[]`                |
| `worker.affinity`                                          | Affinity for pod assignment                                                                                                                                                                                                     | `{}`                |
| `worker.nodeSelector`                                      | Node labels for pod assignment                                                                                                                                                                                                  | `{}`                |
| `worker.tolerations`                                       | Tolerations for worker pod assignment                                                                                                                                                                                           | `[]`                |
| `worker.topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template                                                                                                        | `[]`                |
| `worker.priorityClassName`                                 | Priority Class to use for each pod (Concourse worker)                                                                                                                                                                           | `""`                |
| `worker.schedulerName`                                     | Use an alternate scheduler, e.g. "stork".                                                                                                                                                                                       | `""`                |
| `worker.terminationGracePeriodSeconds`                     | Seconds Concourse worker pod needs to terminate gracefully                                                                                                                                                                      | `""`                |
| `worker.podManagementPolicy`                               | Statefulset Pod Management Policy Type. Allowed values: `OrderedReady` or `Parallel`                                                                                                                                            | `OrderedReady`      |
| `worker.updateStrategy.rollingUpdate`                      | Concourse worker statefulset rolling update configuration parameters                                                                                                                                                            | `{}`                |
| `worker.updateStrategy.type`                               | Concourse worker statefulset strategy type                                                                                                                                                                                      | `RollingUpdate`     |
| `worker.lifecycleHooks`                                    | for the Concourse worker container(s) to automate configuration before or after startup                                                                                                                                         | `{}`                |
| `worker.extraEnvVars`                                      | Array with extra environment variables to add to Concourse worker nodes                                                                                                                                                         | `[]`                |
| `worker.extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for Concourse worker nodes                                                                                                                                                 | `""`                |
| `worker.extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for Concourse worker nodes                                                                                                                                                    | `""`                |
| `worker.extraVolumes`                                      | Optionally specify extra list of additional volumes for the Concourse worker pod(s)                                                                                                                                             | `[]`                |
| `worker.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the Concourse worker container(s)                                                                                                                                  | `[]`                |
| `worker.sidecars`                                          | Add additional sidecar containers to the Concourse worker pod(s)                                                                                                                                                                | `[]`                |
| `worker.initContainers`                                    | Add additional init containers to the Concourse worker pod(s)                                                                                                                                                                   | `[]`                |
| `worker.autoscaling.enabled`                               | Enable autoscaling for the Concourse worker nodes                                                                                                                                                                               | `false`             |
| `worker.autoscaling.maxReplicas`                           | Set maximum number of replicas to the Concourse worker nodes                                                                                                                                                                    | `""`                |
| `worker.autoscaling.minReplicas`                           | Set minimum number of replicas to the Concourse worker nodes                                                                                                                                                                    | `""`                |
| `worker.autoscaling.builtInMetrics`                        | Array with built-in metrics                                                                                                                                                                                                     | `[]`                |
| `worker.autoscaling.customMetrics`                         | Array with custom metrics                                                                                                                                                                                                       | `[]`                |
| `worker.pdb.create`                                        | Create Pod disruption budget object for Concourse worker nodes                                                                                                                                                                  | `true`              |
| `worker.pdb.minAvailable`                                  | Minimum number / percentage of Concourse worker pods that should remain scheduled                                                                                                                                               | `2`                 |
| `worker.pdb.maxUnavailable`                                | Maximum number/percentage of Concourse worker pods that may be made unavailable                                                                                                                                                 | `""`                |
| `worker.psp.create`                                        | Whether to create a PodSecurityPolicy. WARNING: PodSecurityPolicy is deprecated in Kubernetes v1.21 or later, unavailable in v1.25 or later                                                                                     | `false`             |
| `worker.persistence.enabled`                               | Enable Concourse worker data persistence using PVC                                                                                                                                                                              | `true`              |
| `worker.persistence.existingClaim`                         | Name of an existing PVC to use                                                                                                                                                                                                  | `""`                |
| `worker.persistence.storageClass`                          | PVC Storage Class for Concourse worker data volume                                                                                                                                                                              | `""`                |
| `worker.persistence.accessModes`                           | PVC Access Mode for Concourse worker volume                                                                                                                                                                                     | `["ReadWriteOnce"]` |
| `worker.persistence.size`                                  | PVC Storage Request for Concourse worker volume                                                                                                                                                                                 | `8Gi`               |
| `worker.persistence.annotations`                           | Annotations for the PVC                                                                                                                                                                                                         | `{}`                |
| `worker.persistence.selector`                              | Selector to match an existing Persistent Volume (this value is evaluated as a template)                                                                                                                                         | `{}`                |
| `worker.rbac.create`                                       | Specifies whether RBAC resources should be created                                                                                                                                                                              | `true`              |
| `worker.rbac.rules`                                        | Custom RBAC rules to set                                                                                                                                                                                                        | `[]`                |
| `worker.serviceAccount.create`                             | Specifies whether a ServiceAccount should be created                                                                                                                                                                            | `true`              |
| `worker.serviceAccount.name`                               | Override worker service account name                                                                                                                                                                                            | `""`                |
| `worker.serviceAccount.automountServiceAccountToken`       | Allows auto mount of ServiceAccountToken on the serviceAccount created                                                                                                                                                          | `false`             |
| `worker.serviceAccount.annotations`                        | Additional custom annotations for the ServiceAccount                                                                                                                                                                            | `{}`                |

### Traffic exposure parameters

| Name                                             | Description                                                                                                                      | Value                    |
| ------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `service.web.type`                               | Concourse web service type                                                                                                       | `LoadBalancer`           |
| `service.web.ports.http`                         | Concourse web service HTTP port                                                                                                  | `80`                     |
| `service.web.ports.https`                        | Concourse web service HTTPS port                                                                                                 | `443`                    |
| `service.web.nodePorts.http`                     | Node port for HTTP                                                                                                               | `""`                     |
| `service.web.nodePorts.https`                    | Node port for HTTPS                                                                                                              | `""`                     |
| `service.web.sessionAffinity`                    | Control where client requests go, to the same pod or round-robin                                                                 | `None`                   |
| `service.web.sessionAffinityConfig`              | Additional settings for the sessionAffinity                                                                                      | `{}`                     |
| `service.web.clusterIP`                          | Concourse web service Cluster IP                                                                                                 | `""`                     |
| `service.web.loadBalancerIP`                     | Concourse web service Load Balancer IP                                                                                           | `""`                     |
| `service.web.loadBalancerSourceRanges`           | Concourse web service Load Balancer sources                                                                                      | `[]`                     |
| `service.web.externalTrafficPolicy`              | Concourse web service external traffic policy                                                                                    | `Cluster`                |
| `service.web.annotations`                        | Additional custom annotations for Concourse web service                                                                          | `{}`                     |
| `service.web.extraPorts`                         | Extra port to expose on Concourse web service                                                                                    | `[]`                     |
| `service.workerGateway.type`                     | Concourse worker gateway service type                                                                                            | `ClusterIP`              |
| `service.workerGateway.ports.tsa`                | Concourse worker gateway service port                                                                                            | `2222`                   |
| `service.workerGateway.nodePorts.tsa`            | Node port for worker gateway service                                                                                             | `""`                     |
| `service.workerGateway.sessionAffinity`          | Control where client requests go, to the same pod or round-robin                                                                 | `None`                   |
| `service.workerGateway.sessionAffinityConfig`    | Additional settings for the sessionAffinity                                                                                      | `{}`                     |
| `service.workerGateway.clusterIP`                | Concourse worker gateway service Cluster IP                                                                                      | `""`                     |
| `service.workerGateway.loadBalancerIP`           | Concourse worker gateway service Load Balancer IP                                                                                | `""`                     |
| `service.workerGateway.loadBalancerSourceRanges` | Concourse worker gateway service Load Balancer sources                                                                           | `[]`                     |
| `service.workerGateway.externalTrafficPolicy`    | Concourse worker gateway service external traffic policy                                                                         | `Cluster`                |
| `service.workerGateway.annotations`              | Additional custom annotations for Concourse worker gateway service                                                               | `{}`                     |
| `service.workerGateway.extraPorts`               | Extra port to expose on Concourse worker gateway service                                                                         | `[]`                     |
| `ingress.enabled`                                | Enable ingress record generation for Concourse                                                                                   | `false`                  |
| `ingress.ingressClassName`                       | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                    | `""`                     |
| `ingress.pathType`                               | Ingress path type                                                                                                                | `ImplementationSpecific` |
| `ingress.apiVersion`                             | Force Ingress API version (automatically detected if not set)                                                                    | `""`                     |
| `ingress.hostname`                               | Default host for the ingress record                                                                                              | `concourse.local`        |
| `ingress.path`                                   | Default path for the ingress record                                                                                              | `/`                      |
| `ingress.annotations`                            | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                     |
| `ingress.tls`                                    | Enable TLS configuration for the host defined at `ingress.hostname` parameter                                                    | `false`                  |
| `ingress.selfSigned`                             | Create a TLS secret for this ingress record using self-signed certificates generated by Helm                                     | `false`                  |
| `ingress.extraHosts`                             | An array with additional hostname(s) to be covered with the ingress record                                                       | `[]`                     |
| `ingress.extraPaths`                             | An array with additional arbitrary paths that may need to be added to the ingress under the main host                            | `[]`                     |
| `ingress.extraTls`                               | TLS configuration for additional hostname(s) to be covered with this ingress record                                              | `[]`                     |
| `ingress.secrets`                                | Custom TLS certificates as secrets                                                                                               | `[]`                     |
| `ingress.extraRules`                             | Additional rules to be covered with this ingress record                                                                          | `[]`                     |

### Init Container Parameters

| Name                                                             | Description                                                                                                                                                                                                                                           | Value                      |
| ---------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------- |
| `volumePermissions.enabled`                                      | Enable init container that changes the owner and group of the persistent volume                                                                                                                                                                       | `false`                    |
| `volumePermissions.image.registry`                               | Init container volume-permissions image registry                                                                                                                                                                                                      | `REGISTRY_NAME`            |
| `volumePermissions.image.repository`                             | Init container volume-permissions image repository                                                                                                                                                                                                    | `REPOSITORY_NAME/os-shell` |
| `volumePermissions.image.digest`                                 | Init container volume-permissions image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                     | `""`                       |
| `volumePermissions.image.pullPolicy`                             | Init container volume-permissions image pull policy                                                                                                                                                                                                   | `IfNotPresent`             |
| `volumePermissions.image.pullSecrets`                            | Init container volume-permissions image pull secrets                                                                                                                                                                                                  | `[]`                       |
| `volumePermissions.resourcesPreset`                              | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if volumePermissions.resources is set (volumePermissions.resources is recommended for production). | `nano`                     |
| `volumePermissions.resources`                                    | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                                     | `{}`                       |
| `volumePermissions.containerSecurityContext.enabled`             | Enabled init container Security Context                                                                                                                                                                                                               | `true`                     |
| `volumePermissions.containerSecurityContext.seLinuxOptions`      | Set SELinux options in container                                                                                                                                                                                                                      | `nil`                      |
| `volumePermissions.containerSecurityContext.runAsUser`           | User ID for the init container                                                                                                                                                                                                                        | `0`                        |
| `volumePermissions.containerSecurityContext.seccompProfile.type` | Set container's Security Context seccomp profile                                                                                                                                                                                                      | `RuntimeDefault`           |

### Concourse database parameters

| Name                                 | Description                                                                                                                                                                                                                | Value               |
| ------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------- |
| `postgresql.enabled`                 | Switch to enable or disable the PostgreSQL helm chart                                                                                                                                                                      | `true`              |
| `postgresql.auth.enablePostgresUser` | Assign a password to the "postgres" admin user. Otherwise, remote access will be blocked for this user                                                                                                                     | `false`             |
| `postgresql.auth.username`           | Name for a custom user to create                                                                                                                                                                                           | `bn_concourse`      |
| `postgresql.auth.password`           | Password for the custom user to create                                                                                                                                                                                     | `""`                |
| `postgresql.auth.database`           | Name for a custom database to create                                                                                                                                                                                       | `bitnami_concourse` |
| `postgresql.auth.existingSecret`     | Name of existing secret to use for PostgreSQL credentials                                                                                                                                                                  | `""`                |
| `postgresql.architecture`            | PostgreSQL architecture (`standalone` or `replication`)                                                                                                                                                                    | `standalone`        |
| `postgresql.primary.resourcesPreset` | Set container resources according to one common preset (allowed values: none, nano, small, medium, large, xlarge, 2xlarge). This is ignored if primary.resources is set (primary.resources is recommended for production). | `nano`              |
| `postgresql.primary.resources`       | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                          | `{}`                |

### External PostgreSQL configuration

| Name                                         | Description                                                             | Value               |
| -------------------------------------------- | ----------------------------------------------------------------------- | ------------------- |
| `externalDatabase.host`                      | Database host                                                           | `localhost`         |
| `externalDatabase.port`                      | Database port number                                                    | `5432`              |
| `externalDatabase.user`                      | Non-root username for Concourse                                         | `bn_concourse`      |
| `externalDatabase.password`                  | Password for the non-root username for Concourse                        | `""`                |
| `externalDatabase.database`                  | Concourse database name                                                 | `bitnami_concourse` |
| `externalDatabase.existingSecret`            | Name of an existing secret resource containing the database credentials | `""`                |
| `externalDatabase.existingSecretPasswordKey` | Name of an existing secret key containing the database credentials      | `""`                |

See <https://github.com/bitnami/readme-generator-for-helm> to create the table.

The above parameters map to the env variables defined in [bitnami/concourse](https://github.com/bitnami/containers/tree/main/bitnami/concourse). For more information please refer to the [bitnami/concourse](https://github.com/bitnami/containers/tree/main/bitnami/concourse) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
  --set secrets.localUsers=admin:password \
    oci://REGISTRY_NAME/REPOSITORY_NAME/concourse
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The above command sets the Concourse account username and password to `admin` and `password` respectively.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml oci://REGISTRY_NAME/REPOSITORY_NAME/concourse
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.
> **Tip**: You can use the default [values.yaml](https://github.com/bitnami/charts/tree/main/bitnami/concourse/values.yaml)

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 4.0.0

This major bump changes the following security defaults:

- `runAsGroup` is changed from `0` to `1001` in `web` node.
- `readOnlyRootFilesystem` is set to `true`
- `resourcesPreset` is changed from `none` to the minimum size working in our test suites (NOTE: `resourcesPreset` is not meant for production usage, but `resources` adapted to your use case).
- `global.compatibility.openshift.adaptSecurityContext` is changed from `disabled` to `auto`.

This could potentially break any customization or init scripts used in your deployment. If this is the case, change the default values to the previous ones.

### To 3.0.0

This major updates the PostgreSQL subchart to its newest major, 13.0.0. [Here](https://github.com/bitnami/charts/tree/master/bitnami/postgresql#to-1300) you can find more information about the changes introduced in that version.

### To 2.0.0

This major updates the PostgreSQL subchart to its newest major, 12.0.0. [Here](https://github.com/bitnami/charts/tree/master/bitnami/postgresql#to-1200) you can find more information about the changes introduced in that version.

### To 1.0.0

This major release renames several values in this chart and adds missing features, in order to be inline with the rest of assets in the Bitnami charts repository. Additionally updates the PostgreSQL subchart to its newest major 11.x.x which contains similar changes.

#### What changes were introduced in this major version?

- *web.containerPort*, *web.tsa.containerPort*, *web.tsa.debugContainerPort* and *web.tls.containerPort* have been regrouped under the *web.containerPorts*.
- *worker.containerPort*, *worker.healthCheckContainerPort*, *worker.baggageclaim.containerPort* and *worker.baggageclaim.debugContainerPort* have been regrouped under the *worker.containerPorts*.
- *service.web.port* and *service.web.tlsPort* have been regrouped under the *web.service.ports* map.
- *service.workerGateway.port* has been regrouped under the *service.workerGateway.port* map.

#### Upgrading Instructions

1. Obtain the credentials and the names of the PVCs used to hold the data on your current release:

```console
export CONCOURSE_LOCAL_USERS=$(kubectl get secret --namespace default concourse-web -o jsonpath="{.data.local-users}" | base64 --decode)
export POSTGRESQL_PASSWORD=$(kubectl get secret --namespace default concourse-postgresql -o jsonpath="{.data.postgresql-password}" | base64 --decode)
export POSTGRESQL_PVC=$(kubectl get pvc -l app.kubernetes.io/instance=concourse,app.kubernetes.io/name=postgresql,role=primary -o jsonpath="{.items[0].metadata.name}")
```

1. Delete the PostgreSQL statefulset (notice the option *--cascade=false*) and secret:

```console
kubectl delete statefulsets.apps --cascade=false concourse-postgresql
kubectl delete secret postgresql --namespace default
```

1. Upgrade your release using the same PostgreSQL version:

```console
CURRENT_PG_VERSION=$(kubectl exec concourse-postgresql-0 -- bash -c 'echo $BITNAMI_IMAGE_VERSION')
helm upgrade concourse bitnami/concourse \
  --set loadExamples=true \
  --set secrets.localUsers=$CONCOURSE_LOCAL_USERS \
  --set postgresql.image.tag=$CURRENT_VERSION \
  --set postgresql.auth.password=$POSTGRESQL_PASSWORD \
  --set postgresql.persistence.existingClaim=$POSTGRESQL_PVC
```

1. Delete the existing PostgreSQL pod and the new statefulset will create a new one:

```console
kubectl delete pod concourse-postgresql-0
```

## License

Copyright &copy; 2024 Broadcom. The term "Broadcom" refers to Broadcom Inc. and/or its subsidiaries.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

<http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.