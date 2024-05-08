<!--- app-name: SonarQube&trade; -->

# Bitnami package for SonarQube(TM)

SonarQube(TM) is an open source quality management platform that analyzes and measures code's technical quality. It enables developers to detect code issues, vulnerabilities, and bugs in early stages.

[Overview of SonarQube&trade;](http://www.sonarqube.org)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement. SonarQube is a registered trademark of SonarSource SA.

## TL;DR

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/sonarqube
```

Looking to use SonarQube&trade; in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the enterprise edition of Bitnami Application Catalog.

## Introduction

This chart bootstraps an [SonarQube&trade;](https://github.com/bitnami/containers/tree/main/bitnami/sonarqube) cluster on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/sonarqube
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The command deploys SonarQube&trade; on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Configuration and installation details

### Resource requests and limits

Bitnami charts allow setting resource requests and limits for all containers inside the chart deployment. These are inside the `resources` value (check parameter table). Setting requests is essential for production workloads and these should be adapted to your specific use case.

To make this process easier, the chart contains the `resourcesPreset` values, which automatically sets the `resources` section according to different presets. Check these presets in [the bitnami/common chart](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15). However, in production workloads using `resourcePreset` is discouraged as it may not fully adapt to your specific needs. Find more information on container resource management in the [official Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).

### [Rolling VS Immutable tags](https://docs.vmware.com/en/VMware-Tanzu-Application-Catalog/services/tutorials/GUID-understand-rolling-tags-containers-index.html)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Default kernel settings

Currently, SonarQube&trade; requires some changes in the kernel of the host machine to work as expected. If those values are not set in the underlying operating system, the SonarQube&trade; containers fail to boot with ERROR messages. More information about these requirements can be found in the links below:

- [File Descriptor requirements](https://www.elastic.co/guide/en/elasticsearch/reference/current/file-descriptors.html)
- [Virtual memory requirements](https://www.elastic.co/guide/en/elasticsearch/reference/current/vm-max-map-count.html)

This chart uses a **privileged** initContainer to change those settings in the Kernel by running: `sysctl -w vm.max_map_count=262144 && sysctl -w fs.file-max=65536`. You can disable the initContainer using the `sysctl.enabled=false` parameter.

### External database support

You may want to have SonarQube&trade; connect to an external database rather than installing one inside your cluster. Typical reasons for this are to use a managed database service, or to share a common database server for all your applications. To achieve this, set the `postgresql.enabled` parameter to `false` and specify the credentials for the external database using the `externalDatabase.*` parameters. Here is an example:

```text
postgresql.enabled=false
externalDatabase.host=myexternalhost
externalDatabase.user=myuser
externalDatabase.password=mypassword
externalDatabase.database=mydatabase
externalDatabase.port=5432
```

### Ingress

This chart provides support for Ingress resources. If you have an ingress controller installed on your cluster, such as [nginx-ingress-controller](https://github.com/bitnami/charts/tree/main/bitnami/nginx-ingress-controller) or [contour](https://github.com/bitnami/charts/tree/main/bitnami/contour) you can utilize the ingress controller to serve your application.To enable Ingress integration, set `ingress.enabled` to `true`.

The most common scenario is to have one host name mapped to the deployment. In this case, the `ingress.hostname` property can be used to set the host name. The `ingress.tls` parameter can be used to add the TLS configuration for this host.

However, it is also possible to have more than one host. To facilitate this, the `ingress.extraHosts` parameter (if available) can be set with the host names specified as an array. The `ingress.extraTLS` parameter (if available) can also be used to add the TLS configuration for extra hosts.

> NOTE: For each host specified in the `ingress.extraHosts` parameter, it is necessary to set a name, path, and any annotations that the Ingress controller should know about. Not all annotations are supported by all Ingress controllers, but [this annotation reference document](https://github.com/kubernetes/ingress-nginx/blob/master/docs/user-guide/nginx-configuration/annotations.md) lists the annotations supported by many popular Ingress controllers.

Adding the TLS parameter (where available) will cause the chart to generate HTTPS URLs, and the  application will be available on port 443. The actual TLS secrets do not have to be generated by this chart. However, if TLS is enabled, the Ingress record will not work until the TLS secret exists.

[Learn more about Ingress controllers](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/).

### TLS secrets

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

### Additional environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `extraEnvVars` property.

```yaml
sonarqube:
  extraEnvVars:
    - name: LOG_LEVEL
      value: error
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values.

### Enable metrics

The chart can optionally start a sidecar exporter for [Prometheus](https://prometheus.io/) to expose JMX metrics. The metrics endpoint is exposed in a separate service.

To start the sidecar Prometheus exporter, set the *metrics.jmx.enabled* parameter to *true* when deploying the chart. Refer to the chart parameters for the default port number.

Metrics can be scraped from within the cluster using any of the following approaches:

- Adding the required annotations in the service for Prometheus to discover the metrics endpoints, as in the example below:

    ```yaml
    metrics:
      jmx:
        service:
          annotations:
            prometheus.io/scrape: "true"
            prometheus.io/port: "10443"
            prometheus.io/path: "/"
    ```

- Creating a ServiceMonitor (when the Prometheus Operator is available in the cluster). You can do this setting the *metrics.serviceMonitor.enabled* parameter to *true* when deploying the chart.
- Using something similar to the [example Prometheus scrape configuration](https://github.com/prometheus/prometheus/blob/master/documentation/examples/prometheus-kubernetes.yml).

If metrics are to be scraped from outside the cluster, the Kubernetes API proxy can be utilized to access the endpoint.

### Sidecars

If additional containers are needed in the same pod as SonarQube&trade; (such as additional metrics or logging exporters), they can be defined using the `sidecars` parameter.

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

### Pod affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, use one of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

## Persistence

The [Bitnami SonarQube&trade;](https://github.com/bitnami/containers/tree/main/bitnami/sonarqube) image stores the SonarQube&trade; data and configurations at the `/bitnami/sonarqube` path of the container. Persistent Volume Claims are used to keep the data across deployments.

### Adjust permissions of persistent volume mountpoint

As the image run as non-root by default, it is necessary to adjust the ownership of the persistent volume so that the container can write data into it.

By default, the chart is configured to use Kubernetes Security Context to automatically change the ownership of the volume. However, this feature does not work in all Kubernetes distributions.

As an alternative, this chart supports using an initContainer to change the ownership of the volume before mounting it in the final destination. You can enable this initContainer by setting `volumePermissions.enabled` to `true`.

## Parameters

### Global parameters

| Name                                                  | Description                                                                                                                                                                                                                                                                                                                                                         | Value  |
| ----------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------ |
| `global.imageRegistry`                                | Global Docker image registry                                                                                                                                                                                                                                                                                                                                        | `""`   |
| `global.imagePullSecrets`                             | Global Docker registry secret names as an array                                                                                                                                                                                                                                                                                                                     | `[]`   |
| `global.storageClass`                                 | Global StorageClass for Persistent Volume(s)                                                                                                                                                                                                                                                                                                                        | `""`   |
| `global.compatibility.openshift.adaptSecurityContext` | Adapt the securityContext sections of the deployment to make them compatible with Openshift restricted-v2 SCC: remove runAsUser, runAsGroup and fsGroup and let the platform use their allowed default IDs. Possible values: auto (apply if the detected running cluster is Openshift), force (perform the adaptation always), disabled (do not perform adaptation) | `auto` |

### Common parameters

| Name                     | Description                                                                             | Value           |
| ------------------------ | --------------------------------------------------------------------------------------- | --------------- |
| `kubeVersion`            | Override Kubernetes version                                                             | `""`            |
| `nameOverride`           | String to partially override common.names.fullname                                      | `""`            |
| `fullnameOverride`       | String to fully override common.names.fullname                                          | `""`            |
| `commonLabels`           | Labels to add to all deployed objects                                                   | `{}`            |
| `commonAnnotations`      | Annotations to add to all deployed objects                                              | `{}`            |
| `clusterDomain`          | Kubernetes cluster domain name                                                          | `cluster.local` |
| `extraDeploy`            | Array of extra objects to deploy with the release                                       | `[]`            |
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden) | `false`         |
| `diagnosticMode.command` | Command to override all containers in the deployment                                    | `["sleep"]`     |
| `diagnosticMode.args`    | Args to override all containers in the deployment                                       | `["infinity"]`  |

### SonarQube&trade; Image parameters

| Name                | Description                                                                                                      | Value                       |
| ------------------- | ---------------------------------------------------------------------------------------------------------------- | --------------------------- |
| `image.registry`    | SonarQube&trade; image registry                                                                                  | `REGISTRY_NAME`             |
| `image.repository`  | SonarQube&trade; image repository                                                                                | `REPOSITORY_NAME/sonarqube` |
| `image.digest`      | SonarQube&trade; image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag | `""`                        |
| `image.pullPolicy`  | SonarQube&trade; image pull policy                                                                               | `IfNotPresent`              |
| `image.pullSecrets` | SonarQube&trade; image pull secrets                                                                              | `[]`                        |
| `image.debug`       | Enable SonarQube&trade; image debug mode                                                                         | `false`                     |

### SonarQube&trade; Configuration parameters

| Name                          | Description                                                                                                                                                                 | Value                                                    |
| ----------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------- |
| `sonarqubeUsername`           | SonarQube&trade; username                                                                                                                                                   | `user`                                                   |
| `sonarqubePassword`           | SonarQube&trade; user password                                                                                                                                              | `""`                                                     |
| `provisioningFolder`          | Directory to use for provisioning content to Sonarqube                                                                                                                      | `/bitnami/sonarqube-provisioning`                        |
| `existingSecret`              | Name of existing secret containing SonarQube&trade; credentials                                                                                                             | `""`                                                     |
| `sonarqubeEmail`              | SonarQube&trade; user email                                                                                                                                                 | `user@example.com`                                       |
| `minHeapSize`                 | Minimum heap size for SonarQube&trade;                                                                                                                                      | `1024m`                                                  |
| `maxHeapSize`                 | Maximum heap size for SonarQube&trade;                                                                                                                                      | `2048m`                                                  |
| `jvmOpts`                     | Values to add to SONARQUBE_WEB_JAVA_ADD_OPTS                                                                                                                                | `""`                                                     |
| `jvmCeOpts`                   | Values to add to SONAR_CE_JAVAADDITIONALOPTS                                                                                                                                | `""`                                                     |
| `startTimeout`                | Timeout for the application to start in seconds                                                                                                                             | `150`                                                    |
| `extraProperties`             | List of extra properties to be set in the sonar.properties file (key=value format)                                                                                          | `[]`                                                     |
| `sonarqubeSkipInstall`        | Skip wizard installation                                                                                                                                                    | `false`                                                  |
| `sonarSecurityRealm`          | Set this to LDAP authenticate first against the external sytem. If the external system is not                                                                               | `""`                                                     |
| `sonarAuthenticatorDowncase`  | Set to true when connecting to a LDAP server using a case-insensitive setup.                                                                                                | `""`                                                     |
| `ldap.url`                    | URL of the LDAP server. If you are using ldaps, you should install the server certificate into the Java truststore                                                          | `""`                                                     |
| `ldap.bindDn`                 | The username of an LDAP user to connect (or bind) with. Leave this blank for anonymous access to the LDAP directory.                                                        | `""`                                                     |
| `ldap.bindPassword`           | The password of the user to connect with. Leave this blank for anonymous access to the LDAP directory.                                                                      | `""`                                                     |
| `ldap.authentication`         | Possible values: simple, CRAM-MD5, DIGEST-MD5, GSSAPI. See the tutorial on authentication mechanisms (<http://java.sun.com/products/jndi/tutorial/ldap/security/auth.html>) | `simple`                                                 |
| `ldap.realm`                  | See Digest-MD5 Authentication, CRAM-MD5 Authentication (<http://java.sun.com/products/jndi/tutorial/ldap/security/digest.html>)                                             | `""`                                                     |
| `ldap.contextFactoryClass`    | Context factory class.                                                                                                                                                      | `com.sun.jndi.ldap.LdapCtxFactory`                       |
| `ldap.StartTLS`               | Enable use of StartTLS                                                                                                                                                      | `false`                                                  |
| `ldap.followReferrals`        | Follow referrals or not                                                                                                                                                     | `true`                                                   |
| `ldap.user.baseDn`            | Distinguished Name (DN) of the root node in LDAP from which to search for users.                                                                                            | `""`                                                     |
| `ldap.user.request`           | LDAP user request.                                                                                                                                                          | `(&(objectClass=inetOrgPerson)(uid={login}))`            |
| `ldap.user.realNameAttribute` | in LDAP defining the user's real name.                                                                                                                                      | `cn`                                                     |
| `ldap.user.emailAttribute`    | Attribute in LDAP defining the user's email.                                                                                                                                | `mail`                                                   |
| `ldap.group.baseDn`           | Distinguished Name (DN) of the root node in LDAP from which to search for groups.                                                                                           | `""`                                                     |
| `ldap.group.request`          | LDAP group request.                                                                                                                                                         | `(&(objectClass=groupOfUniqueNames)(uniqueMember={dn}))` |
| `ldap.group.idAttribute`      | Attribute in LDAP defining the group's real name.                                                                                                                           | `cn`                                                     |
| `smtpHost`                    | SMTP server host                                                                                                                                                            | `""`                                                     |
| `smtpPort`                    | SMTP server port                                                                                                                                                            | `""`                                                     |
| `smtpUser`                    | SMTP username                                                                                                                                                               | `""`                                                     |
| `smtpPassword`                | SMTP user password                                                                                                                                                          | `""`                                                     |
| `smtpProtocol`                | SMTP protocol                                                                                                                                                               | `""`                                                     |
| `smtpExistingSecret`          | The name of an existing secret with SMTP credentials                                                                                                                        | `""`                                                     |
| `command`                     | Override default container command (useful when using custom images)                                                                                                        | `[]`                                                     |
| `args`                        | Override default container args (useful when using custom images)                                                                                                           | `[]`                                                     |
| `extraEnvVars`                | Array with extra environment variables to add to SonarQube&trade; nodes                                                                                                     | `[]`                                                     |
| `extraEnvVarsCM`              | Name of existing ConfigMap containing extra env vars for SonarQube&trade; nodes                                                                                             | `""`                                                     |
| `extraEnvVarsSecret`          | Name of existing Secret containing extra env vars for SonarQube&trade; nodes                                                                                                | `""`                                                     |

### SonarQube&trade; deployment parameters

| Name                                                | Description                                                                                                                                                                                                       | Value            |
| --------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| `replicaCount`                                      | Number of SonarQube&trade; replicas to deploy                                                                                                                                                                     | `1`              |
| `containerPorts.http`                               | SonarQube&trade; HTTP container port                                                                                                                                                                              | `9000`           |
| `containerPorts.elastic`                            | SonarQube&trade; Elasticsearch container port                                                                                                                                                                     | `9001`           |
| `livenessProbe.enabled`                             | Enable livenessProbe on SonarQube&trade; containers                                                                                                                                                               | `true`           |
| `livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                           | `100`            |
| `livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                  | `10`             |
| `livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                 | `5`              |
| `livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                               | `6`              |
| `livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                               | `1`              |
| `readinessProbe.enabled`                            | Enable readinessProbe on SonarQube&trade; containers                                                                                                                                                              | `true`           |
| `readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                          | `100`            |
| `readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                 | `10`             |
| `readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                | `5`              |
| `readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                              | `6`              |
| `readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                              | `1`              |
| `startupProbe.enabled`                              | Enable startupProbe on SonarQube&trade; containers                                                                                                                                                                | `false`          |
| `startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                            | `30`             |
| `startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                   | `10`             |
| `startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                  | `1`              |
| `startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                | `15`             |
| `startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                | `1`              |
| `customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                                                                                                               | `{}`             |
| `customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                                                                                                                              | `{}`             |
| `customStartupProbe`                                | Custom startupProbe that overrides the default one                                                                                                                                                                | `{}`             |
| `resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if resources is set (resources is recommended for production). | `xlarge`         |
| `resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                 | `{}`             |
| `podSecurityContext.enabled`                        | Enabled SonarQube&trade; pods' Security Context                                                                                                                                                                   | `true`           |
| `podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                | `Always`         |
| `podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                    | `[]`             |
| `podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                       | `[]`             |
| `podSecurityContext.fsGroup`                        | Set SonarQube&trade; pod's Security Context fsGroup                                                                                                                                                               | `1001`           |
| `containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                                                                                                                              | `true`           |
| `containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                  | `{}`             |
| `containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                                                                                                        | `1001`           |
| `containerSecurityContext.runAsGroup`               | Set containers' Security Context runAsGroup                                                                                                                                                                       | `1001`           |
| `containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                                                                                                                     | `true`           |
| `containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                                                                                                                       | `false`          |
| `containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                           | `true`           |
| `containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                                                                                                         | `false`          |
| `containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                | `["ALL"]`        |
| `containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                  | `RuntimeDefault` |
| `automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                | `false`          |
| `hostAliases`                                       | SonarQube&trade; pods host aliases                                                                                                                                                                                | `[]`             |
| `podLabels`                                         | Extra labels for SonarQube&trade; pods                                                                                                                                                                            | `{}`             |
| `podAnnotations`                                    | Annotations for SonarQube&trade; pods                                                                                                                                                                             | `{}`             |
| `podAffinityPreset`                                 | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                               | `""`             |
| `podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                          | `soft`           |
| `nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                         | `""`             |
| `nodeAffinityPreset.key`                            | Node label key to match. Ignored if `affinity` is set                                                                                                                                                             | `""`             |
| `nodeAffinityPreset.values`                         | Node label values to match. Ignored if `affinity` is set                                                                                                                                                          | `[]`             |
| `affinity`                                          | Affinity for SonarQube&trade; pods assignment                                                                                                                                                                     | `{}`             |
| `nodeSelector`                                      | Node labels for SonarQube&trade; pods assignment                                                                                                                                                                  | `{}`             |
| `tolerations`                                       | Tolerations for SonarQube&trade; pods assignment                                                                                                                                                                  | `[]`             |
| `updateStrategy.type`                               | SonarQube&trade; deployment strategy type                                                                                                                                                                         | `RollingUpdate`  |
| `priorityClassName`                                 | SonarQube&trade; pods' priorityClassName                                                                                                                                                                          | `""`             |
| `schedulerName`                                     | Name of the k8s scheduler (other than default) for SonarQube&trade; pods                                                                                                                                          | `""`             |
| `lifecycleHooks`                                    | for the SonarQube&trade; container(s) to automate configuration before or after startup                                                                                                                           | `{}`             |
| `extraVolumes`                                      | Optionally specify extra list of additional volumes for the SonarQube&trade; pod(s)                                                                                                                               | `[]`             |
| `extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the SonarQube&trade; container(s)                                                                                                                    | `[]`             |
| `sidecars`                                          | Add additional sidecar containers to the SonarQube&trade; pod(s)                                                                                                                                                  | `[]`             |
| `initContainers`                                    | Add additional init containers to the SonarQube&trade; pod(s)                                                                                                                                                     | `[]`             |

### Traffic Exposure Parameters

| Name                                    | Description                                                                                                                      | Value                    |
| --------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `service.type`                          | SonarQube&trade; service type                                                                                                    | `LoadBalancer`           |
| `service.ports.http`                    | SonarQube&trade; service HTTP port                                                                                               | `80`                     |
| `service.ports.elastic`                 | SonarQube&trade; service ElasticSearch port                                                                                      | `9001`                   |
| `service.nodePorts.http`                | Node port for HTTP                                                                                                               | `""`                     |
| `service.nodePorts.elastic`             | Node port for ElasticSearch                                                                                                      | `""`                     |
| `service.clusterIP`                     | SonarQube&trade; service Cluster IP                                                                                              | `""`                     |
| `service.loadBalancerIP`                | SonarQube&trade; service Load Balancer IP                                                                                        | `""`                     |
| `service.loadBalancerSourceRanges`      | SonarQube&trade; service Load Balancer sources                                                                                   | `[]`                     |
| `service.externalTrafficPolicy`         | SonarQube&trade; service external traffic policy                                                                                 | `Cluster`                |
| `service.annotations`                   | Additional custom annotations for SonarQube&trade; service                                                                       | `{}`                     |
| `service.extraPorts`                    | Extra ports to expose in SonarQube&trade; service (normally used with the `sidecars` value)                                      | `[]`                     |
| `service.sessionAffinity`               | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                                                             | `None`                   |
| `service.sessionAffinityConfig`         | Additional settings for the sessionAffinity                                                                                      | `{}`                     |
| `networkPolicy.enabled`                 | Specifies whether a NetworkPolicy should be created                                                                              | `true`                   |
| `networkPolicy.allowExternal`           | Don't require client label for connections                                                                                       | `true`                   |
| `networkPolicy.allowExternalEgress`     | Allow the pod to access any range of port and all destinations.                                                                  | `true`                   |
| `networkPolicy.extraIngress`            | Add extra ingress rules to the NetworkPolicy                                                                                     | `[]`                     |
| `networkPolicy.extraEgress`             | Add extra ingress rules to the NetworkPolicy                                                                                     | `[]`                     |
| `networkPolicy.ingressNSMatchLabels`    | Labels to match to allow traffic from other namespaces                                                                           | `{}`                     |
| `networkPolicy.ingressNSPodMatchLabels` | Pod labels to match to allow traffic from other namespaces                                                                       | `{}`                     |
| `ingress.enabled`                       | Enable ingress record generation for SonarQube&trade;                                                                            | `false`                  |
| `ingress.pathType`                      | Ingress path type                                                                                                                | `ImplementationSpecific` |
| `ingress.apiVersion`                    | Force Ingress API version (automatically detected if not set)                                                                    | `""`                     |
| `ingress.ingressClassName`              | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                    | `""`                     |
| `ingress.hostname`                      | Default host for the ingress record                                                                                              | `sonarqube.local`        |
| `ingress.path`                          | Default path for the ingress record                                                                                              | `/`                      |
| `ingress.annotations`                   | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                     |
| `ingress.labels`                        | Additional labels for the Ingress resource.                                                                                      | `{}`                     |
| `ingress.tls`                           | Enable TLS configuration for the host defined at `ingress.hostname` parameter                                                    | `false`                  |
| `ingress.selfSigned`                    | Create a TLS secret for this ingress record using self-signed certificates generated by Helm                                     | `false`                  |
| `ingress.extraHosts`                    | An array with additional hostname(s) to be covered with the ingress record                                                       | `[]`                     |
| `ingress.extraPaths`                    | An array with additional arbitrary paths that may need to be added to the ingress under the main host                            | `[]`                     |
| `ingress.extraTls`                      | TLS configuration for additional hostname(s) to be covered with this ingress record                                              | `[]`                     |
| `ingress.secrets`                       | Custom TLS certificates as secrets                                                                                               | `[]`                     |
| `ingress.extraRules`                    | Additional rules to be covered with this ingress record                                                                          | `[]`                     |

### SonarQube caCerts provisioning parameters

| Name                                                        | Description                                                                                                                                                                                                                       | Value                      |
| ----------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------- |
| `caCerts.enabled`                                           | Enable the use of caCerts                                                                                                                                                                                                         | `false`                    |
| `caCerts.image.registry`                                    | OS Shell + Utility image registry                                                                                                                                                                                                 | `REGISTRY_NAME`            |
| `caCerts.image.repository`                                  | OS Shell + Utility image repository                                                                                                                                                                                               | `REPOSITORY_NAME/os-shell` |
| `caCerts.image.digest`                                      | OS Shell + Utility image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                | `""`                       |
| `caCerts.image.pullPolicy`                                  | OS Shell + Utility image pull policy                                                                                                                                                                                              | `IfNotPresent`             |
| `caCerts.image.pullSecrets`                                 | OS Shell + Utility image pull secrets                                                                                                                                                                                             | `[]`                       |
| `caCerts.secret`                                            | Name of the secret containing the certificates                                                                                                                                                                                    | `ca-certs-secret`          |
| `caCerts.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if caCerts.resources is set (caCerts.resources is recommended for production). | `none`                     |
| `caCerts.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                 | `{}`                       |
| `caCerts.containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                                                                                                                                              | `true`                     |
| `caCerts.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                                  | `{}`                       |
| `caCerts.containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                                                                                                                        | `1001`                     |
| `caCerts.containerSecurityContext.runAsGroup`               | Set containers' Security Context runAsGroup                                                                                                                                                                                       | `1001`                     |
| `caCerts.containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                                                                                                                                     | `true`                     |
| `caCerts.containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                                                                                                                                       | `false`                    |
| `caCerts.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                                           | `true`                     |
| `caCerts.containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                                                                                                                         | `false`                    |
| `caCerts.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                                | `["ALL"]`                  |
| `caCerts.containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                                  | `RuntimeDefault`           |

### SonarQube plugin provisioning parameters

| Name                                                        | Description                                                                                                                                                                                                                       | Value                      |
| ----------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------- |
| `plugins.install`                                           | List of plugin URLS to download and install                                                                                                                                                                                       | `[]`                       |
| `plugins.netrcCreds`                                        | .netrc secret file with a key "netrc" to use basic auth while downloading plugins                                                                                                                                                 | `""`                       |
| `plugins.noCheckCertificate`                                | Set to true to not validate the server's certificate to download plugin                                                                                                                                                           | `true`                     |
| `plugins.image.registry`                                    | OS Shell + Utility image registry                                                                                                                                                                                                 | `REGISTRY_NAME`            |
| `plugins.image.repository`                                  | OS Shell + Utility image repository                                                                                                                                                                                               | `REPOSITORY_NAME/os-shell` |
| `plugins.image.digest`                                      | OS Shell + Utility image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                | `""`                       |
| `plugins.image.pullPolicy`                                  | OS Shell + Utility image pull policy                                                                                                                                                                                              | `IfNotPresent`             |
| `plugins.image.pullSecrets`                                 | OS Shell + Utility image pull secrets                                                                                                                                                                                             | `[]`                       |
| `plugins.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if plugins.resources is set (plugins.resources is recommended for production). | `none`                     |
| `plugins.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                 | `{}`                       |
| `plugins.containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                                                                                                                                              | `true`                     |
| `plugins.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                                  | `{}`                       |
| `plugins.containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                                                                                                                        | `1001`                     |
| `plugins.containerSecurityContext.runAsGroup`               | Set containers' Security Context runAsGroup                                                                                                                                                                                       | `1001`                     |
| `plugins.containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                                                                                                                                     | `true`                     |
| `plugins.containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                                                                                                                                       | `false`                    |
| `plugins.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                                           | `true`                     |
| `plugins.containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                                                                                                                         | `false`                    |
| `plugins.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                                | `["ALL"]`                  |
| `plugins.containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                                  | `RuntimeDefault`           |

### Persistence Parameters

| Name                                                        | Description                                                                                                                                                                                                                                           | Value                      |
| ----------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------- |
| `persistence.enabled`                                       | Enable persistence using Persistent Volume Claims                                                                                                                                                                                                     | `false`                    |
| `persistence.storageClass`                                  | Persistent Volume storage class                                                                                                                                                                                                                       | `""`                       |
| `persistence.accessModes`                                   | Persistent Volume access modes                                                                                                                                                                                                                        | `[]`                       |
| `persistence.size`                                          | Persistent Volume size                                                                                                                                                                                                                                | `10Gi`                     |
| `persistence.dataSource`                                    | Custom PVC data source                                                                                                                                                                                                                                | `{}`                       |
| `persistence.existingClaim`                                 | The name of an existing PVC to use for persistence                                                                                                                                                                                                    | `""`                       |
| `persistence.annotations`                                   | Persistent Volume Claim annotations                                                                                                                                                                                                                   | `{}`                       |
| `volumePermissions.enabled`                                 | Enable init container that changes the owner/group of the PV mount point to `runAsUser:fsGroup`                                                                                                                                                       | `false`                    |
| `volumePermissions.image.registry`                          | OS Shell + Utility image registry                                                                                                                                                                                                                     | `REGISTRY_NAME`            |
| `volumePermissions.image.repository`                        | OS Shell + Utility image repository                                                                                                                                                                                                                   | `REPOSITORY_NAME/os-shell` |
| `volumePermissions.image.digest`                            | OS Shell + Utility image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                                    | `""`                       |
| `volumePermissions.image.pullPolicy`                        | OS Shell + Utility image pull policy                                                                                                                                                                                                                  | `IfNotPresent`             |
| `volumePermissions.image.pullSecrets`                       | OS Shell + Utility image pull secrets                                                                                                                                                                                                                 | `[]`                       |
| `volumePermissions.resourcesPreset`                         | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if volumePermissions.resources is set (volumePermissions.resources is recommended for production). | `none`                     |
| `volumePermissions.resources`                               | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                                     | `{}`                       |
| `volumePermissions.containerSecurityContext.seLinuxOptions` | Set SELinux options in container                                                                                                                                                                                                                      | `{}`                       |
| `volumePermissions.containerSecurityContext.runAsUser`      | Set init container's Security Context runAsUser                                                                                                                                                                                                       | `0`                        |

### Sysctl Image parameters

| Name                                             | Description                                                                                                                                                                                                                     | Value                      |
| ------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------- |
| `sysctl.enabled`                                 | Enable kernel settings modifier image                                                                                                                                                                                           | `true`                     |
| `sysctl.image.registry`                          | OS Shell + Utility image registry                                                                                                                                                                                               | `REGISTRY_NAME`            |
| `sysctl.image.repository`                        | OS Shell + Utility image repository                                                                                                                                                                                             | `REPOSITORY_NAME/os-shell` |
| `sysctl.image.digest`                            | OS Shell + Utility image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                              | `""`                       |
| `sysctl.image.pullPolicy`                        | OS Shell + Utility image pull policy                                                                                                                                                                                            | `IfNotPresent`             |
| `sysctl.image.pullSecrets`                       | OS Shell + Utility image pull secrets                                                                                                                                                                                           | `[]`                       |
| `sysctl.resourcesPreset`                         | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if sysctl.resources is set (sysctl.resources is recommended for production). | `none`                     |
| `sysctl.resources`                               | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                               | `{}`                       |
| `sysctl.containerSecurityContext.enabled`        | Enable container security context                                                                                                                                                                                               | `true`                     |
| `sysctl.containerSecurityContext.seLinuxOptions` | Set SELinux options in container                                                                                                                                                                                                | `nil`                      |
| `sysctl.containerSecurityContext.runAsUser`      | Set init container's Security Context runAsUser                                                                                                                                                                                 | `0`                        |
| `sysctl.containerSecurityContext.privileged`     | Set init container's Security Context privileged                                                                                                                                                                                | `true`                     |

### Other Parameters

| Name                                          | Description                                                                                                         | Value   |
| --------------------------------------------- | ------------------------------------------------------------------------------------------------------------------- | ------- |
| `rbac.create`                                 | Specifies whether RBAC resources should be created                                                                  | `false` |
| `serviceAccount.create`                       | Specifies whether a ServiceAccount should be created                                                                | `true`  |
| `serviceAccount.name`                         | Name of the service account to use. If not set and create is true, a name is generated using the fullname template. | `""`    |
| `serviceAccount.automountServiceAccountToken` | Automount service account token for the server service account                                                      | `false` |
| `serviceAccount.annotations`                  | Annotations for service account. Evaluated as a template. Only used if `create` is `true`.                          | `{}`    |
| `autoscaling.enabled`                         | Enable Horizontal POD autoscaling for SonarQube&trade;                                                              | `false` |
| `autoscaling.minReplicas`                     | Minimum number of SonarQube&trade; replicas                                                                         | `1`     |
| `autoscaling.maxReplicas`                     | Maximum number of SonarQube&trade; replicas                                                                         | `11`    |
| `autoscaling.targetCPU`                       | Target CPU utilization percentage                                                                                   | `50`    |
| `autoscaling.targetMemory`                    | Target Memory utilization percentage                                                                                | `50`    |

### Metrics parameters

| Name                                                            | Description                                                                                                                                                                                                                               | Value                          |
| --------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------ |
| `metrics.jmx.enabled`                                           | Whether or not to expose JMX metrics to Prometheus                                                                                                                                                                                        | `false`                        |
| `metrics.jmx.image.registry`                                    | JMX exporter image registry                                                                                                                                                                                                               | `REGISTRY_NAME`                |
| `metrics.jmx.image.repository`                                  | JMX exporter image repository                                                                                                                                                                                                             | `REPOSITORY_NAME/jmx-exporter` |
| `metrics.jmx.image.digest`                                      | JMX exporter image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                              | `""`                           |
| `metrics.jmx.image.pullPolicy`                                  | JMX exporter image pull policy                                                                                                                                                                                                            | `IfNotPresent`                 |
| `metrics.jmx.image.pullSecrets`                                 | Specify docker-registry secret names as an array                                                                                                                                                                                          | `[]`                           |
| `metrics.jmx.containerPorts.metrics`                            | JMX Exporter metrics container port                                                                                                                                                                                                       | `10445`                        |
| `metrics.jmx.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if metrics.jmx.resources is set (metrics.jmx.resources is recommended for production). | `none`                         |
| `metrics.jmx.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                         | `{}`                           |
| `metrics.jmx.containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                                                                                                                                                      | `true`                         |
| `metrics.jmx.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                                          | `{}`                           |
| `metrics.jmx.containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                                                                                                                                | `1001`                         |
| `metrics.jmx.containerSecurityContext.runAsGroup`               | Set containers' Security Context runAsGroup                                                                                                                                                                                               | `1001`                         |
| `metrics.jmx.containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                                                                                                                                             | `true`                         |
| `metrics.jmx.containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                                                                                                                                               | `false`                        |
| `metrics.jmx.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                                                   | `true`                         |
| `metrics.jmx.containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                                                                                                                                 | `false`                        |
| `metrics.jmx.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                                        | `["ALL"]`                      |
| `metrics.jmx.containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                                          | `RuntimeDefault`               |
| `metrics.jmx.whitelistObjectNames`                              | Allows setting which JMX objects you want to expose to via JMX stats to JMX Exporter                                                                                                                                                      | `[]`                           |
| `metrics.jmx.configuration`                                     | Configuration file for JMX exporter                                                                                                                                                                                                       | `""`                           |
| `metrics.jmx.service.ports.metrics`                             | JMX Exporter Prometheus port                                                                                                                                                                                                              | `10443`                        |
| `metrics.jmx.service.annotations`                               | Annotations for the JMX Exporter Prometheus metrics service                                                                                                                                                                               | `{}`                           |
| `metrics.serviceMonitor.enabled`                                | if `true`, creates a Prometheus Operator ServiceMonitor (requires `metrics.jmx.enabled` to be `true`)                                                                                                                                     | `false`                        |
| `metrics.serviceMonitor.namespace`                              | Namespace in which Prometheus is running                                                                                                                                                                                                  | `""`                           |
| `metrics.serviceMonitor.labels`                                 | Extra labels for the ServiceMonitor                                                                                                                                                                                                       | `{}`                           |
| `metrics.serviceMonitor.jobLabel`                               | The name of the label on the target service to use as the job name in Prometheus                                                                                                                                                          | `""`                           |
| `metrics.serviceMonitor.interval`                               | How frequently to scrape metrics                                                                                                                                                                                                          | `""`                           |
| `metrics.serviceMonitor.scrapeTimeout`                          | Timeout after which the scrape is ended                                                                                                                                                                                                   | `""`                           |
| `metrics.serviceMonitor.metricRelabelings`                      | Specify additional relabeling of metrics                                                                                                                                                                                                  | `[]`                           |
| `metrics.serviceMonitor.relabelings`                            | Specify general relabeling                                                                                                                                                                                                                | `[]`                           |
| `metrics.serviceMonitor.selector`                               | Prometheus instance selector labels                                                                                                                                                                                                       | `{}`                           |

### PostgreSQL subchart settings

| Name                                           | Description                                                                        | Value               |
| ---------------------------------------------- | ---------------------------------------------------------------------------------- | ------------------- |
| `postgresql.enabled`                           | Deploy PostgreSQL subchart                                                         | `true`              |
| `postgresql.nameOverride`                      | Override name of the PostgreSQL chart                                              | `""`                |
| `postgresql.auth.existingSecret`               | Existing secret containing the password of the PostgreSQL chart                    | `""`                |
| `postgresql.auth.password`                     | Password for the postgres user of the PostgreSQL chart (auto-generated if not set) | `""`                |
| `postgresql.auth.username`                     | Username to create when deploying the PostgreSQL chart                             | `bn_sonarqube`      |
| `postgresql.auth.database`                     | Database to create when deploying the PostgreSQL chart                             | `bitnami_sonarqube` |
| `postgresql.primary.service.ports.postgresql`  | PostgreSQL service port                                                            | `5432`              |
| `postgresql.primary.persistence.enabled`       | Enable PostgreSQL Primary data persistence using PVC                               | `true`              |
| `postgresql.primary.persistence.existingClaim` | Name of an existing PVC to use                                                     | `""`                |
| `postgresql.primary.persistence.storageClass`  | PVC Storage Class for PostgreSQL Primary data volume                               | `""`                |
| `postgresql.primary.persistence.accessMode`    | PVC Access Mode for PostgreSQL volume                                              | `ReadWriteOnce`     |
| `postgresql.primary.persistence.size`          | PVC Storage Request for PostgreSQL volume                                          | `8Gi`               |

### External Database settings

| Name                              | Description                                                                                                     | Value       |
| --------------------------------- | --------------------------------------------------------------------------------------------------------------- | ----------- |
| `externalDatabase.host`           | Host of an external PostgreSQL instance to connect (only if postgresql.enabled=false)                           | `""`        |
| `externalDatabase.user`           | User of an external PostgreSQL instance to connect (only if postgresql.enabled=false)                           | `postgres`  |
| `externalDatabase.password`       | Password of an external PostgreSQL instance to connect (only if postgresql.enabled=false)                       | `""`        |
| `externalDatabase.existingSecret` | Secret containing the password of an external PostgreSQL instance to connect (only if postgresql.enabled=false) | `""`        |
| `externalDatabase.database`       | Database inside an external PostgreSQL to connect (only if postgresql.enabled=false)                            | `sonarqube` |
| `externalDatabase.port`           | Port of an external PostgreSQL to connect (only if postgresql.enabled=false)                                    | `5432`      |

The above parameters map to the env variables defined in [bitnami/sonarqube](https://github.com/bitnami/containers/tree/main/bitnami/sonarqube). For more information please refer to the [bitnami/sonarqube](https://github.com/bitnami/containers/tree/main/bitnami/sonarqube) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
  --set sonarqubeUsername=admin \
  --set sonarqubePassword=password \
  --set postgresql.auth.password=secretpassword \
    oci://REGISTRY_NAME/REPOSITORY_NAME/sonarqube
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The above command sets the sonarqube administrator account username and password to `admin` and `password` respectively. Additionally, it sets the PostgreSQL `postgres` user password to `secretpassword`.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml oci://REGISTRY_NAME/REPOSITORY_NAME/sonarqube
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.
> **Tip**: You can use the default [values.yaml](https://github.com/bitnami/charts/tree/main/bitnami/sonarqube/values.yaml)

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 5.0.0

This major bump changes the following security defaults:

- `runAsGroup` is changed from `0` to `1001`
- `readOnlyRootFilesystem` is set to `true`
- `resourcesPreset` is changed from `none` to the minimum size working in our test suites (NOTE: `resourcesPreset` is not meant for production usage, but `resources` adapted to your use case).
- `global.compatibility.openshift.adaptSecurityContext` is changed from `disabled` to `auto`.

This could potentially break any customization or init scripts used in your deployment. If this is the case, change the default values to the previous ones.

### To 4.0.0

This major updates the PostgreSQL subchart to its newest major, 13.0.0. [Here](https://github.com/bitnami/charts/tree/master/bitnami/postgresql#to-1300) you can find more information about the changes introduced in that version.

### To 2.0.0

This major updates the PostgreSQL subchart to its newest major, 12.0.0. [Here](https://github.com/bitnami/charts/tree/master/bitnami/postgresql#to-1200) you can find more information about the changes introduced in that version.

### To 1.0.0

This major release updates the PostgreSQL subchart to its newest major *11.x.x*, which contain several changes in the supported values (check the [upgrade notes](https://github.com/bitnami/charts/tree/master/bitnami/postgresql#to-1100) to obtain more information).

#### Upgrading Instructions

To upgrade to *1.0.0* from *0.x*, it should be done reusing the PVC(s) used to hold the data on your previous release. To do so, follow the instructions below (the following example assumes that the release name is *sonarqube* and the release namespace *default*):

1. Obtain the credentials and the names of the PVCs used to hold the data on your current release:

```console
export SONARQUBE_PASSWORD=$(kubectl get secret --namespace default sonarqube -o jsonpath="{.data.sonarqube-password}" | base64 --decode)
export POSTGRESQL_PASSWORD=$(kubectl get secret --namespace default sonarqube-postgresql -o jsonpath="{.data.postgresql-password}" | base64 --decode)
export POSTGRESQL_PVC=$(kubectl get pvc -l app.kubernetes.io/instance=sonarqube,app.kubernetes.io/name=postgresql,role=primary -o jsonpath="{.items[0].metadata.name}")
```

1. Delete the PostgreSQL statefulset (notice the option *--cascade=false*) and secret:

```console
kubectl delete statefulsets.apps --cascade=false sonarqube-postgresql
kubectl delete secret sonarqube-postgresql --namespace default
```

1. Upgrade your release using the same PostgreSQL version:

```console
CURRENT_PG_VERSION=$(kubectl exec sonarqube-postgresql-0 -- bash -c 'echo $BITNAMI_IMAGE_VERSION')
helm upgrade sonarqube bitnami/sonarqube \
  --set sonarqubePassword=$SONARQUBE_PASSWORD \
  --set postgresql.image.tag=$CURRENT_PG_VERSION \
  --set postgresql.auth.password=$POSTGRESQL_PASSWORD \
  --set postgresql.persistence.existingClaim=$POSTGRESQL_PVC
```

1. Delete the existing PostgreSQL pods and the new statefulset will create a new one:

```console
kubectl delete pod sonarqube-postgresql-0
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