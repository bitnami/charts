<!--- app-name: Keycloak -->

# Bitnami package for Keycloak

Keycloak is a high performance Java-based identity and access management solution. It lets developers add an authentication layer to their applications with minimum effort.

[Overview of Keycloak](https://www.keycloak.org/)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/keycloak
```

Looking to use Keycloak in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the commercial edition of the Bitnami catalog.

## Introduction

Bitnami charts for Helm are carefully engineered, actively maintained and are the quickest and easiest way to deploy containers on a Kubernetes cluster that are ready to handle production workloads.

This chart bootstraps a [Keycloak](https://github.com/bitnami/containers/tree/main/bitnami/keycloak) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/keycloak
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

These commands deploy a Keycloak application on the Kubernetes cluster in the default configuration.

> **Tip**: List all releases using `helm list`

## Configuration and installation details

### Resource requests and limits

Bitnami charts allow setting resource requests and limits for all containers inside the chart deployment. These are inside the `resources` value (check parameter table). Setting requests is essential for production workloads and these should be adapted to your specific use case.

To make this process easier, the chart contains the `resourcesPreset` values, which automatically sets the `resources` section according to different presets. Check these presets in [the bitnami/common chart](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15). However, in production workloads using `resourcePreset` is discouraged as it may not fully adapt to your specific needs. Find more information on container resource management in the [official Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).

### [Rolling vs Immutable tags](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Use an external database

Sometimes, you may want to have Keycloak connect to an external PostgreSQL database rather than a database within your cluster - for example, when using a managed database service, or when running a single database server for all your applications. To do this, set the `postgresql.enabled` parameter to `false` and specify the credentials for the external database using the `externalDatabase.*` parameters. Here is an example:

```text
postgresql.enabled=false
externalDatabase.host=myexternalhost
externalDatabase.user=myuser
externalDatabase.password=mypassword
externalDatabase.database=mydatabase
externalDatabase.port=5432
```

> NOTE: Only PostgreSQL database server is supported as external database

It is not supported but possible to run Keycloak with an external MSSQL database with the following settings:

```yaml
externalDatabase:
  host: "mssql.example.com"
  port: 1433
  user: keycloak
  database: keycloak
  existingSecret: passwords
extraEnvVars:
  - name: KC_DB # override values from the conf file
    value: 'mssql'
  - name: KC_DB_URL
    value: 'jdbc:sqlserver://mssql.example.com:1433;databaseName=keycloak;'
```

### Importing and exporting a realm

#### Importing a realm

You can import a realm by setting the `KEYCLOAK_EXTRA_ARGS` to contain the `--import-realm` argument.

This will import all `*.json` under `/opt/bitnami/keycloak/data/import` files as a realm into keycloak as per the
official documentation [here](https://www.keycloak.org/server/importExport#_importing_a_realm_from_a_directory). You
can supply the files by mounting a volume e.g. with docker compose as follows:

```yaml
keycloak:
  image: bitnami/keycloak:latest
  volumes:
    - /local/path/to/realms/folder:/opt/bitnami/keycloak/data/import
```

#### Exporting a realm

You can export a realm through the GUI but it will not export users even the option is set, this is a known keycloak
[bug](https://github.com/keycloak/keycloak/issues/23970).

By using the `kc.sh` script you can export a realm with users. Be sure to mount the export folder to a local folder:

```yaml
keycloak:
  image: bitnami/keycloak:latest
  volumes:
    - /local/path/to/export/folder:/export
```

Then open a terminal in the running keycloak container and run:

```bash
kc.sh export --dir /export/ --users realm_file
````

This will export the all the realms with users to the `/export` folder.

### Configure Ingress

This chart provides support for Ingress resources. If you have an ingress controller installed on your cluster, such as [nginx-ingress-controller](https://github.com/bitnami/charts/tree/main/bitnami/nginx-ingress-controller) or [contour](https://github.com/bitnami/charts/tree/main/bitnami/contour) you can utilize the ingress controller to serve your application.To enable Ingress integration, set `ingress.enabled` to `true`.

The most common scenario is to have one host name mapped to the deployment. In this case, the `ingress.hostname` property can be used to set the host name. The `ingress.tls` parameter can be used to add the TLS configuration for this host.

However, it is also possible to have more than one host. To facilitate this, the `ingress.extraHosts` parameter (if available) can be set with the host names specified as an array. The `ingress.extraTLS` parameter (if available) can also be used to add the TLS configuration for extra hosts.

> NOTE: For each host specified in the `ingress.extraHosts` parameter, it is necessary to set a name, path, and any annotations that the Ingress controller should know about. Not all annotations are supported by all Ingress controllers, but [this annotation reference document](https://github.com/kubernetes/ingress-nginx/blob/master/docs/user-guide/nginx-configuration/annotations.md) lists the annotations supported by many popular Ingress controllers.

Adding the TLS parameter (where available) will cause the chart to generate HTTPS URLs, and the  application will be available on port 443. The actual TLS secrets do not have to be generated by this chart. However, if TLS is enabled, the Ingress record will not work until the TLS secret exists.

[Learn more about Ingress controllers](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/).

### Configure admin Ingress

In addition to the Ingress resource described above, this chart also provides the ability to define an Ingress for the admin area of Keycloak, for example the `master` realm.

For this scenario, you can use the Keycloak Config CLI integration with the following values, where `keycloak-admin.example.com` is to be replaced by the actual hostname:

```yaml
adminIngress:
  enabled: true
  hostname: keycloak-admin.example.com
keycloakConfigCli:
  enabled: true
  configuration:
    master.json: |
      {
        "realm" : "master",
        "attributes": {
          "frontendUrl": "https://keycloak-admin.example.com"
        }
      }
```

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

### Use with ingress offloading SSL

If your ingress controller has the SSL Termination, you should set `proxy` to `edge`.

### Manage secrets and passwords

This chart provides several ways to manage passwords:

- Values passed to the chart: In this scenario, a new secret including all the passwords will be created during the chart installation. When upgrading, it is necessary to provide the secrets to the chart as shown below. Replace the KEYCLOAK_ADMIN_PASSWORD, POSTGRESQL_PASSWORD and POSTGRESQL_PVC placeholders with the correct passwords and PVC name.

```console
helm upgrade keycloak bitnami/keycloak \
  --set auth.adminPassword=KEYCLOAK_ADMIN_PASSWORD \
  --set postgresql.postgresqlPassword=POSTGRESQL_PASSWORD \
  --set postgresql.persistence.existingClaim=POSTGRESQL_PVC
```

- An existing secret with all the passwords via the `existingSecret` parameter.

### Add extra environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `extraEnvVars` property.

```yaml
extraEnvVars:
  - name: KEYCLOAK_LOG_LEVEL
    value: DEBUG
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values.

### Use Sidecars and Init Containers

If additional containers are needed in the same pod (such as additional metrics or logging exporters), they can be defined using the `sidecars` config parameter.

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

### Initialize a fresh instance

The [Bitnami Keycloak](https://github.com/bitnami/containers/tree/main/bitnami/keycloak) image allows you to use your custom scripts to initialize a fresh instance. In order to execute the scripts, you can specify custom scripts using the `initdbScripts` parameter as dict.

In addition to this option, you can also set an external ConfigMap with all the initialization scripts. This is done by setting the `initdbScriptsConfigMap` parameter. Note that this will override the previous option.

The allowed extensions is `.sh`.

### Deploy extra resources

There are cases where you may want to deploy extra objects, such a ConfigMap containing your app's configuration or some extra deployment with a micro service used by your app. For covering this case, the chart allows adding the full specification of other objects using the `extraDeploy` parameter.

### Set Pod affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

## Parameters

### Global parameters

| Name                                                  | Description                                                                                                                                                                                                                                                                                                                                                         | Value  |
| ----------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------ |
| `global.imageRegistry`                                | Global Docker image registry                                                                                                                                                                                                                                                                                                                                        | `""`   |
| `global.imagePullSecrets`                             | Global Docker registry secret names as an array                                                                                                                                                                                                                                                                                                                     | `[]`   |
| `global.defaultStorageClass`                          | Global default StorageClass for Persistent Volume(s)                                                                                                                                                                                                                                                                                                                | `""`   |
| `global.storageClass`                                 | DEPRECATED: use global.defaultStorageClass instead                                                                                                                                                                                                                                                                                                                  | `""`   |
| `global.compatibility.openshift.adaptSecurityContext` | Adapt the securityContext sections of the deployment to make them compatible with Openshift restricted-v2 SCC: remove runAsUser, runAsGroup and fsGroup and let the platform use their allowed default IDs. Possible values: auto (apply if the detected running cluster is Openshift), force (perform the adaptation always), disabled (do not perform adaptation) | `auto` |

### Common parameters

| Name                     | Description                                                                             | Value           |
| ------------------------ | --------------------------------------------------------------------------------------- | --------------- |
| `kubeVersion`            | Force target Kubernetes version (using Helm capabilities if not set)                    | `""`            |
| `nameOverride`           | String to partially override common.names.fullname                                      | `""`            |
| `fullnameOverride`       | String to fully override common.names.fullname                                          | `""`            |
| `namespaceOverride`      | String to fully override common.names.namespace                                         | `""`            |
| `commonLabels`           | Labels to add to all deployed objects                                                   | `{}`            |
| `enableServiceLinks`     | If set to false, disable Kubernetes service links in the pod spec                       | `true`          |
| `commonAnnotations`      | Annotations to add to all deployed objects                                              | `{}`            |
| `dnsPolicy`              | DNS Policy for pod                                                                      | `""`            |
| `dnsConfig`              | DNS Configuration pod                                                                   | `{}`            |
| `clusterDomain`          | Default Kubernetes cluster domain                                                       | `cluster.local` |
| `extraDeploy`            | Array of extra objects to deploy with the release                                       | `[]`            |
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden) | `false`         |
| `diagnosticMode.command` | Command to override all containers in the the statefulset                               | `["sleep"]`     |
| `diagnosticMode.args`    | Args to override all containers in the the statefulset                                  | `["infinity"]`  |

### Keycloak parameters

| Name                             | Description                                                                                                                                            | Value                         |
| -------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------ | ----------------------------- |
| `image.registry`                 | Keycloak image registry                                                                                                                                | `REGISTRY_NAME`               |
| `image.repository`               | Keycloak image repository                                                                                                                              | `REPOSITORY_NAME/keycloak`    |
| `image.digest`                   | Keycloak image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                               | `""`                          |
| `image.pullPolicy`               | Keycloak image pull policy                                                                                                                             | `IfNotPresent`                |
| `image.pullSecrets`              | Specify docker-registry secret names as an array                                                                                                       | `[]`                          |
| `image.debug`                    | Specify if debug logs should be enabled                                                                                                                | `false`                       |
| `auth.adminUser`                 | Keycloak administrator user                                                                                                                            | `user`                        |
| `auth.adminPassword`             | Keycloak administrator password for the new user                                                                                                       | `""`                          |
| `auth.existingSecret`            | Existing secret containing Keycloak admin password                                                                                                     | `""`                          |
| `auth.passwordSecretKey`         | Key where the Keycloak admin password is being stored inside the existing secret.                                                                      | `""`                          |
| `auth.annotations`               | Additional custom annotations for Keycloak auth secret object                                                                                          | `{}`                          |
| `customCaExistingSecret`         | Name of the secret containing the Keycloak custom CA certificates. The secret will be mounted as a directory and configured using KC_TRUSTSTORE_PATHS. | `""`                          |
| `tls.enabled`                    | Enable TLS encryption. Required for HTTPs traffic.                                                                                                     | `false`                       |
| `tls.autoGenerated`              | Generate automatically self-signed TLS certificates. Currently only supports PEM certificates                                                          | `false`                       |
| `tls.existingSecret`             | Existing secret containing the TLS certificates per Keycloak replica                                                                                   | `""`                          |
| `tls.usePem`                     | Use PEM certificates as input instead of PKS12/JKS stores                                                                                              | `false`                       |
| `tls.truststoreFilename`         | Truststore filename inside the existing secret                                                                                                         | `keycloak.truststore.jks`     |
| `tls.keystoreFilename`           | Keystore filename inside the existing secret                                                                                                           | `keycloak.keystore.jks`       |
| `tls.keystorePassword`           | Password to access the keystore when it's password-protected                                                                                           | `""`                          |
| `tls.truststorePassword`         | Password to access the truststore when it's password-protected                                                                                         | `""`                          |
| `tls.passwordsSecret`            | Secret containing the Keystore and Truststore passwords.                                                                                               | `""`                          |
| `spi.existingSecret`             | Existing secret containing the Keycloak truststore for SPI connection over HTTPS/TLS                                                                   | `""`                          |
| `spi.truststorePassword`         | Password to access the truststore when it's password-protected                                                                                         | `""`                          |
| `spi.truststoreFilename`         | Truststore filename inside the existing secret                                                                                                         | `keycloak-spi.truststore.jks` |
| `spi.passwordsSecret`            | Secret containing the SPI Truststore passwords.                                                                                                        | `""`                          |
| `spi.hostnameVerificationPolicy` | Verify the hostname of the server's certificate. Allowed values: "ANY", "WILDCARD", "STRICT".                                                          | `""`                          |
| `adminRealm`                     | Name of the admin realm                                                                                                                                | `master`                      |
| `production`                     | Run Keycloak in production mode. TLS configuration is required except when using proxy=edge.                                                           | `false`                       |
| `proxyHeaders`                   | Set Keycloak proxy headers                                                                                                                             | `""`                          |
| `proxy`                          | reverse Proxy mode edge, reencrypt, passthrough or none                                                                                                | `""`                          |
| `httpRelativePath`               | Set the path relative to '/' for serving resources. Useful if you are migrating from older version which were using '/auth/'                           | `/`                           |
| `configuration`                  | Keycloak Configuration. Auto-generated based on other parameters when not specified                                                                    | `""`                          |
| `existingConfigmap`              | Name of existing ConfigMap with Keycloak configuration                                                                                                 | `""`                          |
| `extraStartupArgs`               | Extra default startup args                                                                                                                             | `""`                          |
| `enableDefaultInitContainers`    | Deploy default init containers                                                                                                                         | `true`                        |
| `initdbScripts`                  | Dictionary of initdb scripts                                                                                                                           | `{}`                          |
| `initdbScriptsConfigMap`         | ConfigMap with the initdb scripts (Note: Overrides `initdbScripts`)                                                                                    | `""`                          |
| `command`                        | Override default container command (useful when using custom images)                                                                                   | `[]`                          |
| `args`                           | Override default container args (useful when using custom images)                                                                                      | `[]`                          |
| `extraEnvVars`                   | Extra environment variables to be set on Keycloak container                                                                                            | `[]`                          |
| `extraEnvVarsCM`                 | Name of existing ConfigMap containing extra env vars                                                                                                   | `""`                          |
| `extraEnvVarsSecret`             | Name of existing Secret containing extra env vars                                                                                                      | `""`                          |

### Keycloak statefulset parameters

| Name                                                | Description                                                                                                                                                                                                       | Value            |
| --------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| `replicaCount`                                      | Number of Keycloak replicas to deploy                                                                                                                                                                             | `1`              |
| `revisionHistoryLimitCount`                         | Number of controller revisions to keep                                                                                                                                                                            | `10`             |
| `containerPorts.http`                               | Keycloak HTTP container port                                                                                                                                                                                      | `8080`           |
| `containerPorts.https`                              | Keycloak HTTPS container port                                                                                                                                                                                     | `8443`           |
| `containerPorts.metrics`                            | Keycloak metrics container port                                                                                                                                                                                   | `9000`           |
| `extraContainerPorts`                               | Optionally specify extra list of additional port-mappings for Keycloak container                                                                                                                                  | `[]`             |
| `statefulsetAnnotations`                            | Optionally add extra annotations on the statefulset resource                                                                                                                                                      | `{}`             |
| `podSecurityContext.enabled`                        | Enabled Keycloak pods' Security Context                                                                                                                                                                           | `true`           |
| `podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                | `Always`         |
| `podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                    | `[]`             |
| `podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                       | `[]`             |
| `podSecurityContext.fsGroup`                        | Set Keycloak pod's Security Context fsGroup                                                                                                                                                                       | `1001`           |
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
| `resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if resources is set (resources is recommended for production). | `small`          |
| `resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                 | `{}`             |
| `livenessProbe.enabled`                             | Enable livenessProbe on Keycloak containers                                                                                                                                                                       | `true`           |
| `livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                           | `300`            |
| `livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                  | `1`              |
| `livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                 | `5`              |
| `livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                               | `3`              |
| `livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                               | `1`              |
| `readinessProbe.enabled`                            | Enable readinessProbe on Keycloak containers                                                                                                                                                                      | `true`           |
| `readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                          | `30`             |
| `readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                 | `10`             |
| `readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                | `1`              |
| `readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                              | `3`              |
| `readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                              | `1`              |
| `startupProbe.enabled`                              | Enable startupProbe on Keycloak containers                                                                                                                                                                        | `false`          |
| `startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                            | `30`             |
| `startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                   | `5`              |
| `startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                  | `1`              |
| `startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                | `60`             |
| `startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                | `1`              |
| `customLivenessProbe`                               | Custom Liveness probes for Keycloak                                                                                                                                                                               | `{}`             |
| `customReadinessProbe`                              | Custom Rediness probes Keycloak                                                                                                                                                                                   | `{}`             |
| `customStartupProbe`                                | Custom Startup probes for Keycloak                                                                                                                                                                                | `{}`             |
| `lifecycleHooks`                                    | LifecycleHooks to set additional configuration at startup                                                                                                                                                         | `{}`             |
| `automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                | `true`           |
| `hostAliases`                                       | Deployment pod host aliases                                                                                                                                                                                       | `[]`             |
| `podLabels`                                         | Extra labels for Keycloak pods                                                                                                                                                                                    | `{}`             |
| `podAnnotations`                                    | Annotations for Keycloak pods                                                                                                                                                                                     | `{}`             |
| `podAffinityPreset`                                 | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                               | `""`             |
| `podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                          | `soft`           |
| `nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                         | `""`             |
| `nodeAffinityPreset.key`                            | Node label key to match. Ignored if `affinity` is set.                                                                                                                                                            | `""`             |
| `nodeAffinityPreset.values`                         | Node label values to match. Ignored if `affinity` is set.                                                                                                                                                         | `[]`             |
| `affinity`                                          | Affinity for pod assignment                                                                                                                                                                                       | `{}`             |
| `nodeSelector`                                      | Node labels for pod assignment                                                                                                                                                                                    | `{}`             |
| `tolerations`                                       | Tolerations for pod assignment                                                                                                                                                                                    | `[]`             |
| `topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template                                                                                          | `[]`             |
| `podManagementPolicy`                               | Pod management policy for the Keycloak statefulset                                                                                                                                                                | `Parallel`       |
| `priorityClassName`                                 | Keycloak pods' Priority Class Name                                                                                                                                                                                | `""`             |
| `schedulerName`                                     | Use an alternate scheduler, e.g. "stork".                                                                                                                                                                         | `""`             |
| `terminationGracePeriodSeconds`                     | Seconds Keycloak pod needs to terminate gracefully                                                                                                                                                                | `""`             |
| `updateStrategy.type`                               | Keycloak statefulset strategy type                                                                                                                                                                                | `RollingUpdate`  |
| `updateStrategy.rollingUpdate`                      | Keycloak statefulset rolling update configuration parameters                                                                                                                                                      | `{}`             |
| `minReadySeconds`                                   | How many seconds a pod needs to be ready before killing the next, during update                                                                                                                                   | `0`              |
| `extraVolumes`                                      | Optionally specify extra list of additional volumes for Keycloak pods                                                                                                                                             | `[]`             |
| `extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for Keycloak container(s)                                                                                                                                | `[]`             |
| `initContainers`                                    | Add additional init containers to the Keycloak pods                                                                                                                                                               | `[]`             |
| `sidecars`                                          | Add additional sidecar containers to the Keycloak pods                                                                                                                                                            | `[]`             |

### Exposure parameters

| Name                                    | Description                                                                                                                      | Value                    |
| --------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `service.type`                          | Kubernetes service type                                                                                                          | `ClusterIP`              |
| `service.http.enabled`                  | Enable http port on service                                                                                                      | `true`                   |
| `service.ports.http`                    | Keycloak service HTTP port                                                                                                       | `80`                     |
| `service.ports.https`                   | Keycloak service HTTPS port                                                                                                      | `443`                    |
| `service.nodePorts`                     | Specify the nodePort values for the LoadBalancer and NodePort service types.                                                     | `{}`                     |
| `service.sessionAffinity`               | Control where client requests go, to the same pod or round-robin                                                                 | `None`                   |
| `service.sessionAffinityConfig`         | Additional settings for the sessionAffinity                                                                                      | `{}`                     |
| `service.clusterIP`                     | Keycloak service clusterIP IP                                                                                                    | `""`                     |
| `service.loadBalancerIP`                | loadBalancerIP for the SuiteCRM Service (optional, cloud specific)                                                               | `""`                     |
| `service.loadBalancerSourceRanges`      | Address that are allowed when service is LoadBalancer                                                                            | `[]`                     |
| `service.externalTrafficPolicy`         | Enable client source IP preservation                                                                                             | `Cluster`                |
| `service.annotations`                   | Additional custom annotations for Keycloak service                                                                               | `{}`                     |
| `service.extraPorts`                    | Extra port to expose on Keycloak service                                                                                         | `[]`                     |
| `service.extraHeadlessPorts`            | Extra ports to expose on Keycloak headless service                                                                               | `[]`                     |
| `service.headless.annotations`          | Annotations for the headless service.                                                                                            | `{}`                     |
| `service.headless.extraPorts`           | Extra ports to expose on Keycloak headless service                                                                               | `[]`                     |
| `ingress.enabled`                       | Enable ingress record generation for Keycloak                                                                                    | `false`                  |
| `ingress.ingressClassName`              | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                    | `""`                     |
| `ingress.pathType`                      | Ingress path type                                                                                                                | `ImplementationSpecific` |
| `ingress.apiVersion`                    | Force Ingress API version (automatically detected if not set)                                                                    | `""`                     |
| `ingress.controller`                    | The ingress controller type. Currently supports `default` and `gce`                                                              | `default`                |
| `ingress.hostname`                      | Default host for the ingress record (evaluated as template)                                                                      | `keycloak.local`         |
| `ingress.hostnameStrict`                | Disables dynamically resolving the hostname from request headers.                                                                | `false`                  |
| `ingress.path`                          | Default path for the ingress record (evaluated as template)                                                                      | `""`                     |
| `ingress.servicePort`                   | Backend service port to use                                                                                                      | `http`                   |
| `ingress.annotations`                   | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                     |
| `ingress.labels`                        | Additional labels for the Ingress resource.                                                                                      | `{}`                     |
| `ingress.tls`                           | Enable TLS configuration for the host defined at `ingress.hostname` parameter                                                    | `false`                  |
| `ingress.selfSigned`                    | Create a TLS secret for this ingress record using self-signed certificates generated by Helm                                     | `false`                  |
| `ingress.extraHosts`                    | An array with additional hostname(s) to be covered with the ingress record                                                       | `[]`                     |
| `ingress.extraPaths`                    | Any additional arbitrary paths that may need to be added to the ingress under the main host.                                     | `[]`                     |
| `ingress.extraTls`                      | The tls configuration for additional hostnames to be covered with this ingress record.                                           | `[]`                     |
| `ingress.secrets`                       | If you're providing your own certificates, please use this to add the certificates as secrets                                    | `[]`                     |
| `ingress.extraRules`                    | Additional rules to be covered with this ingress record                                                                          | `[]`                     |
| `adminIngress.enabled`                  | Enable admin ingress record generation for Keycloak                                                                              | `false`                  |
| `adminIngress.ingressClassName`         | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                    | `""`                     |
| `adminIngress.pathType`                 | Ingress path type                                                                                                                | `ImplementationSpecific` |
| `adminIngress.apiVersion`               | Force Ingress API version (automatically detected if not set)                                                                    | `""`                     |
| `adminIngress.controller`               | The ingress controller type. Currently supports `default` and `gce`                                                              | `default`                |
| `adminIngress.hostname`                 | Default host for the admin ingress record (evaluated as template)                                                                | `keycloak.local`         |
| `adminIngress.path`                     | Default path for the admin ingress record (evaluated as template)                                                                | `""`                     |
| `adminIngress.servicePort`              | Backend service port to use                                                                                                      | `http`                   |
| `adminIngress.annotations`              | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                     |
| `adminIngress.labels`                   | Additional labels for the Ingress resource.                                                                                      | `{}`                     |
| `adminIngress.tls`                      | Enable TLS configuration for the host defined at `adminIngress.hostname` parameter                                               | `false`                  |
| `adminIngress.selfSigned`               | Create a TLS secret for this ingress record using self-signed certificates generated by Helm                                     | `false`                  |
| `adminIngress.extraHosts`               | An array with additional hostname(s) to be covered with the admin ingress record                                                 | `[]`                     |
| `adminIngress.extraPaths`               | Any additional arbitrary paths that may need to be added to the admin ingress under the main host.                               | `[]`                     |
| `adminIngress.extraTls`                 | The tls configuration for additional hostnames to be covered with this ingress record.                                           | `[]`                     |
| `adminIngress.secrets`                  | If you're providing your own certificates, please use this to add the certificates as secrets                                    | `[]`                     |
| `adminIngress.extraRules`               | Additional rules to be covered with this ingress record                                                                          | `[]`                     |
| `networkPolicy.enabled`                 | Specifies whether a NetworkPolicy should be created                                                                              | `true`                   |
| `networkPolicy.allowExternal`           | Don't require server label for connections                                                                                       | `true`                   |
| `networkPolicy.allowExternalEgress`     | Allow the pod to access any range of port and all destinations.                                                                  | `true`                   |
| `networkPolicy.kubeAPIServerPorts`      | List of possible endpoints to kube-apiserver (limit to your cluster settings to increase security)                               | `[]`                     |
| `networkPolicy.extraIngress`            | Add extra ingress rules to the NetworkPolicy                                                                                     | `[]`                     |
| `networkPolicy.extraEgress`             | Add extra ingress rules to the NetworkPolicy                                                                                     | `[]`                     |
| `networkPolicy.ingressNSMatchLabels`    | Labels to match to allow traffic from other namespaces                                                                           | `{}`                     |
| `networkPolicy.ingressNSPodMatchLabels` | Pod labels to match to allow traffic from other namespaces                                                                       | `{}`                     |

### RBAC parameter

| Name                                          | Description                                               | Value   |
| --------------------------------------------- | --------------------------------------------------------- | ------- |
| `serviceAccount.create`                       | Enable the creation of a ServiceAccount for Keycloak pods | `true`  |
| `serviceAccount.name`                         | Name of the created ServiceAccount                        | `""`    |
| `serviceAccount.automountServiceAccountToken` | Auto-mount the service account token in the pod           | `false` |
| `serviceAccount.annotations`                  | Additional custom annotations for the ServiceAccount      | `{}`    |
| `serviceAccount.extraLabels`                  | Additional labels for the ServiceAccount                  | `{}`    |
| `rbac.create`                                 | Whether to create and use RBAC resources or not           | `false` |
| `rbac.rules`                                  | Custom RBAC rules                                         | `[]`    |

### Other parameters

| Name                                                        | Description                                                                                  | Value   |
| ----------------------------------------------------------- | -------------------------------------------------------------------------------------------- | ------- |
| `pdb.create`                                                | Enable/disable a Pod Disruption Budget creation                                              | `true`  |
| `pdb.minAvailable`                                          | Minimum number/percentage of pods that should remain scheduled                               | `""`    |
| `pdb.maxUnavailable`                                        | Maximum number/percentage of pods that may be made unavailable                               | `""`    |
| `autoscaling.enabled`                                       | Enable autoscaling for Keycloak                                                              | `false` |
| `autoscaling.minReplicas`                                   | Minimum number of Keycloak replicas                                                          | `1`     |
| `autoscaling.maxReplicas`                                   | Maximum number of Keycloak replicas                                                          | `11`    |
| `autoscaling.targetCPU`                                     | Target CPU utilization percentage                                                            | `""`    |
| `autoscaling.targetMemory`                                  | Target Memory utilization percentage                                                         | `""`    |
| `autoscaling.behavior.scaleUp.stabilizationWindowSeconds`   | The number of seconds for which past recommendations should be considered while scaling up   | `120`   |
| `autoscaling.behavior.scaleUp.selectPolicy`                 | The priority of policies that the autoscaler will apply when scaling up                      | `Max`   |
| `autoscaling.behavior.scaleUp.policies`                     | HPA scaling policies when scaling up                                                         | `[]`    |
| `autoscaling.behavior.scaleDown.stabilizationWindowSeconds` | The number of seconds for which past recommendations should be considered while scaling down | `300`   |
| `autoscaling.behavior.scaleDown.selectPolicy`               | The priority of policies that the autoscaler will apply when scaling down                    | `Max`   |
| `autoscaling.behavior.scaleDown.policies`                   | HPA scaling policies when scaling down                                                       | `[]`    |

### Metrics parameters

| Name                                       | Description                                                                                                                                        | Value     |
| ------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------- | --------- |
| `metrics.enabled`                          | Enable exposing Keycloak statistics                                                                                                                | `false`   |
| `metrics.service.ports.http`               | Metrics service HTTP port                                                                                                                          | `8080`    |
| `metrics.service.ports.https`              | Metrics service HTTPS port                                                                                                                         | `8443`    |
| `metrics.service.ports.metrics`            | Metrics service Metrics port                                                                                                                       | `9000`    |
| `metrics.service.annotations`              | Annotations for enabling prometheus to access the metrics endpoints                                                                                | `{}`      |
| `metrics.service.extraPorts`               | Add additional ports to the keycloak metrics service (i.e. admin port 9000)                                                                        | `[]`      |
| `metrics.serviceMonitor.enabled`           | Create ServiceMonitor Resource for scraping metrics using PrometheusOperator                                                                       | `false`   |
| `metrics.serviceMonitor.port`              | Metrics service HTTP port                                                                                                                          | `metrics` |
| `metrics.serviceMonitor.scheme`            | Metrics service scheme                                                                                                                             | `http`    |
| `metrics.serviceMonitor.tlsConfig`         | Metrics service TLS configuration                                                                                                                  | `{}`      |
| `metrics.serviceMonitor.endpoints`         | The endpoint configuration of the ServiceMonitor. Path is mandatory. Port, scheme, tlsConfig, interval, timeout and labellings can be overwritten. | `[]`      |
| `metrics.serviceMonitor.path`              | Metrics service HTTP path. Deprecated: Use @param metrics.serviceMonitor.endpoints instead                                                         | `""`      |
| `metrics.serviceMonitor.namespace`         | Namespace which Prometheus is running in                                                                                                           | `""`      |
| `metrics.serviceMonitor.interval`          | Interval at which metrics should be scraped                                                                                                        | `30s`     |
| `metrics.serviceMonitor.scrapeTimeout`     | Specify the timeout after which the scrape is ended                                                                                                | `""`      |
| `metrics.serviceMonitor.labels`            | Additional labels that can be used so ServiceMonitor will be discovered by Prometheus                                                              | `{}`      |
| `metrics.serviceMonitor.selector`          | Prometheus instance selector labels                                                                                                                | `{}`      |
| `metrics.serviceMonitor.relabelings`       | RelabelConfigs to apply to samples before scraping                                                                                                 | `[]`      |
| `metrics.serviceMonitor.metricRelabelings` | MetricRelabelConfigs to apply to samples before ingestion                                                                                          | `[]`      |
| `metrics.serviceMonitor.honorLabels`       | honorLabels chooses the metric's labels on collisions with target labels                                                                           | `false`   |
| `metrics.serviceMonitor.jobLabel`          | The name of the label on the target service to use as the job name in prometheus.                                                                  | `""`      |
| `metrics.prometheusRule.enabled`           | Create PrometheusRule Resource for scraping metrics using PrometheusOperator                                                                       | `false`   |
| `metrics.prometheusRule.namespace`         | Namespace which Prometheus is running in                                                                                                           | `""`      |
| `metrics.prometheusRule.labels`            | Additional labels that can be used so PrometheusRule will be discovered by Prometheus                                                              | `{}`      |
| `metrics.prometheusRule.groups`            | Groups, containing the alert rules.                                                                                                                | `[]`      |

### keycloak-config-cli parameters

| Name                                                                  | Description                                                                                                                                                                                                                                           | Value                                 |
| --------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------- |
| `keycloakConfigCli.enabled`                                           | Whether to enable keycloak-config-cli job                                                                                                                                                                                                             | `false`                               |
| `keycloakConfigCli.image.registry`                                    | keycloak-config-cli container image registry                                                                                                                                                                                                          | `REGISTRY_NAME`                       |
| `keycloakConfigCli.image.repository`                                  | keycloak-config-cli container image repository                                                                                                                                                                                                        | `REPOSITORY_NAME/keycloak-config-cli` |
| `keycloakConfigCli.image.digest`                                      | keycloak-config-cli container image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                         | `""`                                  |
| `keycloakConfigCli.image.pullPolicy`                                  | keycloak-config-cli container image pull policy                                                                                                                                                                                                       | `IfNotPresent`                        |
| `keycloakConfigCli.image.pullSecrets`                                 | keycloak-config-cli container image pull secrets                                                                                                                                                                                                      | `[]`                                  |
| `keycloakConfigCli.annotations`                                       | Annotations for keycloak-config-cli job                                                                                                                                                                                                               | `{}`                                  |
| `keycloakConfigCli.command`                                           | Command for running the container (set to default if not set). Use array form                                                                                                                                                                         | `[]`                                  |
| `keycloakConfigCli.args`                                              | Args for running the container (set to default if not set). Use array form                                                                                                                                                                            | `[]`                                  |
| `keycloakConfigCli.automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                                                    | `true`                                |
| `keycloakConfigCli.hostAliases`                                       | Job pod host aliases                                                                                                                                                                                                                                  | `[]`                                  |
| `keycloakConfigCli.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if keycloakConfigCli.resources is set (keycloakConfigCli.resources is recommended for production). | `small`                               |
| `keycloakConfigCli.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                                     | `{}`                                  |
| `keycloakConfigCli.containerSecurityContext.enabled`                  | Enabled keycloak-config-cli Security Context                                                                                                                                                                                                          | `true`                                |
| `keycloakConfigCli.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                                                      | `{}`                                  |
| `keycloakConfigCli.containerSecurityContext.runAsUser`                | Set keycloak-config-cli Security Context runAsUser                                                                                                                                                                                                    | `1001`                                |
| `keycloakConfigCli.containerSecurityContext.runAsGroup`               | Set keycloak-config-cli Security Context runAsGroup                                                                                                                                                                                                   | `1001`                                |
| `keycloakConfigCli.containerSecurityContext.runAsNonRoot`             | Set keycloak-config-cli Security Context runAsNonRoot                                                                                                                                                                                                 | `true`                                |
| `keycloakConfigCli.containerSecurityContext.privileged`               | Set keycloak-config-cli Security Context privileged                                                                                                                                                                                                   | `false`                               |
| `keycloakConfigCli.containerSecurityContext.readOnlyRootFilesystem`   | Set keycloak-config-cli Security Context readOnlyRootFilesystem                                                                                                                                                                                       | `true`                                |
| `keycloakConfigCli.containerSecurityContext.allowPrivilegeEscalation` | Set keycloak-config-cli Security Context allowPrivilegeEscalation                                                                                                                                                                                     | `false`                               |
| `keycloakConfigCli.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                                                    | `["ALL"]`                             |
| `keycloakConfigCli.containerSecurityContext.seccompProfile.type`      | Set keycloak-config-cli Security Context seccomp profile                                                                                                                                                                                              | `RuntimeDefault`                      |
| `keycloakConfigCli.podSecurityContext.enabled`                        | Enabled keycloak-config-cli pods' Security Context                                                                                                                                                                                                    | `true`                                |
| `keycloakConfigCli.podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                                                    | `Always`                              |
| `keycloakConfigCli.podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                                                        | `[]`                                  |
| `keycloakConfigCli.podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                                                           | `[]`                                  |
| `keycloakConfigCli.podSecurityContext.fsGroup`                        | Set keycloak-config-cli pod's Security Context fsGroup                                                                                                                                                                                                | `1001`                                |
| `keycloakConfigCli.backoffLimit`                                      | Number of retries before considering a Job as failed                                                                                                                                                                                                  | `1`                                   |
| `keycloakConfigCli.podLabels`                                         | Pod extra labels                                                                                                                                                                                                                                      | `{}`                                  |
| `keycloakConfigCli.podAnnotations`                                    | Annotations for job pod                                                                                                                                                                                                                               | `{}`                                  |
| `keycloakConfigCli.extraEnvVars`                                      | Additional environment variables to set                                                                                                                                                                                                               | `[]`                                  |
| `keycloakConfigCli.nodeSelector`                                      | Node labels for pod assignment                                                                                                                                                                                                                        | `{}`                                  |
| `keycloakConfigCli.podTolerations`                                    | Tolerations for job pod assignment                                                                                                                                                                                                                    | `[]`                                  |
| `keycloakConfigCli.extraEnvVarsCM`                                    | ConfigMap with extra environment variables                                                                                                                                                                                                            | `""`                                  |
| `keycloakConfigCli.extraEnvVarsSecret`                                | Secret with extra environment variables                                                                                                                                                                                                               | `""`                                  |
| `keycloakConfigCli.extraVolumes`                                      | Extra volumes to add to the job                                                                                                                                                                                                                       | `[]`                                  |
| `keycloakConfigCli.extraVolumeMounts`                                 | Extra volume mounts to add to the container                                                                                                                                                                                                           | `[]`                                  |
| `keycloakConfigCli.initContainers`                                    | Add additional init containers to the Keycloak config cli pod                                                                                                                                                                                         | `[]`                                  |
| `keycloakConfigCli.sidecars`                                          | Add additional sidecar containers to the Keycloak config cli pod                                                                                                                                                                                      | `[]`                                  |
| `keycloakConfigCli.configuration`                                     | keycloak-config-cli realms configuration                                                                                                                                                                                                              | `{}`                                  |
| `keycloakConfigCli.existingConfigmap`                                 | ConfigMap with keycloak-config-cli configuration                                                                                                                                                                                                      | `""`                                  |
| `keycloakConfigCli.cleanupAfterFinished.enabled`                      | Enables Cleanup for Finished Jobs                                                                                                                                                                                                                     | `false`                               |
| `keycloakConfigCli.cleanupAfterFinished.seconds`                      | Sets the value of ttlSecondsAfterFinished                                                                                                                                                                                                             | `600`                                 |

### Database parameters

| Name                                         | Description                                                                                                       | Value              |
| -------------------------------------------- | ----------------------------------------------------------------------------------------------------------------- | ------------------ |
| `postgresql.enabled`                         | Switch to enable or disable the PostgreSQL helm chart                                                             | `true`             |
| `postgresql.auth.postgresPassword`           | Password for the "postgres" admin user. Ignored if `auth.existingSecret` with key `postgres-password` is provided | `""`               |
| `postgresql.auth.username`                   | Name for a custom user to create                                                                                  | `bn_keycloak`      |
| `postgresql.auth.password`                   | Password for the custom user to create                                                                            | `""`               |
| `postgresql.auth.database`                   | Name for a custom database to create                                                                              | `bitnami_keycloak` |
| `postgresql.auth.existingSecret`             | Name of existing secret to use for PostgreSQL credentials                                                         | `""`               |
| `postgresql.auth.secretKeys.userPasswordKey` | Name of key in existing secret to use for PostgreSQL credentials. Only used when `auth.existingSecret` is set.    | `password`         |
| `postgresql.architecture`                    | PostgreSQL architecture (`standalone` or `replication`)                                                           | `standalone`       |
| `externalDatabase.host`                      | Database host                                                                                                     | `""`               |
| `externalDatabase.port`                      | Database port number                                                                                              | `5432`             |
| `externalDatabase.user`                      | Non-root username for Keycloak                                                                                    | `bn_keycloak`      |
| `externalDatabase.password`                  | Password for the non-root username for Keycloak                                                                   | `""`               |
| `externalDatabase.database`                  | Keycloak database name                                                                                            | `bitnami_keycloak` |
| `externalDatabase.existingSecret`            | Name of an existing secret resource containing the database credentials                                           | `""`               |
| `externalDatabase.existingSecretHostKey`     | Name of an existing secret key containing the database host name                                                  | `""`               |
| `externalDatabase.existingSecretPortKey`     | Name of an existing secret key containing the database port                                                       | `""`               |
| `externalDatabase.existingSecretUserKey`     | Name of an existing secret key containing the database user                                                       | `""`               |
| `externalDatabase.existingSecretDatabaseKey` | Name of an existing secret key containing the database name                                                       | `""`               |
| `externalDatabase.existingSecretPasswordKey` | Name of an existing secret key containing the database credentials                                                | `""`               |
| `externalDatabase.annotations`               | Additional custom annotations for external database secret object                                                 | `{}`               |

### Keycloak Cache parameters

| Name              | Description                                                                | Value        |
| ----------------- | -------------------------------------------------------------------------- | ------------ |
| `cache.enabled`   | Switch to enable or disable the keycloak distributed cache for kubernetes. | `true`       |
| `cache.stackName` | Set infinispan cache stack to use                                          | `kubernetes` |
| `cache.stackFile` | Set infinispan cache stack filename to use                                 | `""`         |

### Keycloak Logging parameters

| Name             | Description                                                                    | Value     |
| ---------------- | ------------------------------------------------------------------------------ | --------- |
| `logging.output` | Alternates between the default log output format or json format                | `default` |
| `logging.level`  | Allowed values as documented: FATAL, ERROR, WARN, INFO, DEBUG, TRACE, ALL, OFF | `INFO`    |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release --set auth.adminPassword=secretpassword oci://REGISTRY_NAME/REPOSITORY_NAME/keycloak
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The above command sets the Keycloak administrator password to `secretpassword`.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml oci://REGISTRY_NAME/REPOSITORY_NAME/keycloak
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.
> **Tip**: You can use the default [values.yaml](https://github.com/bitnami/charts/tree/main/bitnami/keycloak/values.yaml)

Keycloak realms, users and clients can be created from the Keycloak administration panel.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 24.1.0

With this update the metrics service listening port is switched to 9000, the same as the keycloak management endpoint is using.
This can be changed by setting `metrics.service.ports.http` to a different value, e.g. 8080 like before this change.

### To 23.0.0

This major updates the PostgreSQL subchart to its newest major, 16.0.0, which uses PostgreSQL 17.x.  Follow the [official instructions](https://www.postgresql.org/docs/17/upgrading.html) to upgrade to 17.x.

### To 21.0.0

This major release updates the keycloak branch to its newest major, 24.x.x. Follow the [upstream documentation](https://www.keycloak.org/docs/latest/upgrading/index.html#migrating-to-24-0-0) for upgrade instructions.

### To 20.0.0

This major bump changes the following security defaults:

- `runAsGroup` is changed from `0` to `1001`
- `readOnlyRootFilesystem` is set to `true`
- `resourcesPreset` is changed from `none` to the minimum size working in our test suites (NOTE: `resourcesPreset` is not meant for production usage, but `resources` adapted to your use case).
- `global.compatibility.openshift.adaptSecurityContext` is changed from `disabled` to `auto`.

This could potentially break any customization or init scripts used in your deployment. If this is the case, change the default values to the previous ones.

### To 19.0.0

This major release bumps the PostgreSQL chart version to [14.x.x](https://github.com/bitnami/charts/pull/22750); no major issues are expected during the upgrade.

### To 17.0.0

This major updates the PostgreSQL subchart to its newest major, 13.0.0. [Here](https://github.com/bitnami/charts/tree/master/bitnami/postgresql#to-1300) you can find more information about the changes introduced in that version.

### To 15.0.0

This major updates the default serviceType from `LoadBalancer` to `ClusterIP` to avoid inadvertently exposing Keycloak directly to the internet without an Ingress.

### To 12.0.0

This major updates the PostgreSQL subchart to its newest major, 12.0.0. [Here](https://github.com/bitnami/charts/tree/master/bitnami/postgresql#to-1200) you can find more information about the changes introduced in that version.

### To 10.0.0

This major release updates Keycloak to its major version `19`. Please, refer to the official [Keycloak migration documentation](https://www.keycloak.org/docs/latest/upgrading/index.html#migrating-to-19-0-0) for a complete list of changes and further information.

### To 9.0.0

This major release updates Keycloak to its major version `18`. Please, refer to the official [Keycloak migration documentation](https://www.keycloak.org/docs/latest/upgrading/index.html#migrating-to-18-0-0) for a complete list of changes and further information.

### To 8.0.0

This major release updates Keycloak to its major version `17`. Among other features, this new version has deprecated WildFly in favor of Quarkus, which introduces breaking changes like:

- Removal of `/auth` from the default context path.
- Changes in the configuration and deployment of custom providers.
- Significant changes in configuring Keycloak.

Please, refer to the official [Keycloak migration documentation](https://www.keycloak.org/docs/latest/upgrading/index.html#migrating-to-17-0-0) and [Migrating to Quarkus distribution document](https://www.keycloak.org/migration/migrating-to-quarkus) for a complete list of changes and further information.

### To 7.0.0

This major release updates the PostgreSQL subchart to its newest major *11.x.x*, which contain several changes in the supported values (check the [upgrade notes](https://github.com/bitnami/charts/tree/master/bitnami/postgresql#to-1100) to obtain more information).

#### Upgrading Instructions

To upgrade to *7.0.0* from *6.x*, it should be done reusing the PVC(s) used to hold the data on your previous release. To do so, follow the instructions below (the following example assumes that the release name is *keycloak* and the release namespace *default*):

1. Obtain the credentials and the names of the PVCs used to hold the data on your current release:

```console
export KEYCLOAK_PASSWORD=$(kubectl get secret --namespace default keycloak -o jsonpath="{.data.admin-password}" | base64 --decode)
export POSTGRESQL_PASSWORD=$(kubectl get secret --namespace default keycloak-postgresql -o jsonpath="{.data.postgresql-password}" | base64 --decode)
export POSTGRESQL_PVC=$(kubectl get pvc -l app.kubernetes.io/instance=keycloak,app.kubernetes.io/name=postgresql,role=primary -o jsonpath="{.items[0].metadata.name}")
```

1. Delete the PostgreSQL statefulset (notice the option *--cascade=false*) and secret:

```console
kubectl delete statefulsets.apps --cascade=false keycloak-postgresql
kubectl delete secret keycloak-postgresql --namespace default
```

1. Upgrade your release using the same PostgreSQL version:

```console
CURRENT_PG_VERSION=$(kubectl exec keycloak-postgresql-0 -- bash -c 'echo $BITNAMI_IMAGE_VERSION')
helm upgrade keycloak bitnami/keycloak \
  --set auth.adminPassword=$KEYCLOAK_PASSWORD \
  --set postgresql.image.tag=$CURRENT_PG_VERSION \
  --set postgresql.auth.password=$POSTGRESQL_PASSWORD \
  --set postgresql.persistence.existingClaim=$POSTGRESQL_PVC
```

1. Delete the existing PostgreSQL pods and the new statefulset will create a new one:

```console
kubectl delete pod keycloak-postgresql-0
```

### To 1.0.0

[On November 13, 2020, Helm v2 support was formally finished](https://github.com/helm/charts#status-of-the-project), this major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

#### What changes were introduced in this major version?

- Previous versions of this Helm Chart use `apiVersion: v1` (installable by both Helm 2 and 3), this Helm Chart was updated to `apiVersion: v2` (installable by Helm 3 only). [Here](https://helm.sh/docs/topics/charts/#the-apiversion-field) you can find more information about the `apiVersion` field.
- Move dependency information from the *requirements.yaml* to the *Chart.yaml*
- After running *helm dependency update*, a *Chart.lock* file is generated containing the same structure used in the previous *requirements.lock*
- The different fields present in the *Chart.yaml* file has been ordered alphabetically in a homogeneous way for all the Bitnami Helm Chart.

#### Considerations when upgrading to this version

- If you want to upgrade to this version using Helm v2, this scenario is not supported as this version does not support Helm v2 anymore.
- If you installed the previous version with Helm v2 and wants to upgrade to this version with Helm v3, please refer to the [official Helm documentation](https://helm.sh/docs/topics/v2_v3_migration/#migration-use-cases) about migrating from Helm v2 to v3.

#### Useful links

- [Bitnami Tutorial](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-resolve-helm2-helm3-post-migration-issues-index.html)
- [Helm docs](https://helm.sh/docs/topics/v2_v3_migration)
- [Helm Blog](https://helm.sh/blog/migrate-from-helm-v2-to-helm-v3)

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