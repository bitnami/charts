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

## ⚠️ Important Notice: Upcoming changes to the Bitnami Catalog

Beginning August 28th, 2025, Bitnami will evolve its public catalog to offer a curated set of hardened, security-focused images under the new [Bitnami Secure Images initiative](https://news.broadcom.com/app-dev/broadcom-introduces-bitnami-secure-images-for-production-ready-containerized-applications). As part of this transition:

- Granting community users access for the first time to security-optimized versions of popular container images.
- Bitnami will begin deprecating support for non-hardened, Debian-based software images in its free tier and will gradually remove non-latest tags from the public catalog. As a result, community users will have access to a reduced number of hardened images. These images are published only under the “latest” tag and are intended for development purposes
- Starting August 28th, over two weeks, all existing container images, including older or versioned tags (e.g., 2.50.0, 10.6), will be migrated from the public catalog (docker.io/bitnami) to the “Bitnami Legacy” repository (docker.io/bitnamilegacy), where they will no longer receive updates.
- For production workloads and long-term support, users are encouraged to adopt Bitnami Secure Images, which include hardened containers, smaller attack surfaces, CVE transparency (via VEX/KEV), SBOMs, and enterprise support.

These changes aim to improve the security posture of all Bitnami users by promoting best practices for software supply chain integrity and up-to-date deployments. For more details, visit the [Bitnami Secure Images announcement](https://github.com/bitnami/containers/issues/83267).

## Introduction

Bitnami charts for Helm are carefully engineered, actively maintained and are the quickest and easiest way to deploy containers on a Kubernetes cluster that are ready to handle production workloads.

This chart bootstraps a [Keycloak](https://www.keycloak.org/) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

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

### Prometheus metrics

This chart can be integrated with Prometheus by setting `metrics.enabled` to `true`. This will expose Keycloak native Prometheus endpoint in a `metrics` service, which can be configured under the `metrics.service` section. It will have the necessary annotations to be automatically scraped by Prometheus.

#### Prometheus requirements

It is necessary to have a working installation of Prometheus or Prometheus Operator for the integration to work. Install the [Bitnami Prometheus helm chart](https://github.com/bitnami/charts/tree/main/bitnami/prometheus) or the [Bitnami Kube Prometheus helm chart](https://github.com/bitnami/charts/tree/main/bitnami/kube-prometheus) to easily have a working Prometheus in your cluster.

#### Integration with Prometheus Operator

The chart can deploy `ServiceMonitor` objects for integration with Prometheus Operator installations. To do so, set the value `metrics.serviceMonitor.enabled=true`. Ensure that the Prometheus Operator `CustomResourceDefinitions` are installed in the cluster or it will fail with the following error:

```text
no matches for kind "ServiceMonitor" in version "monitoring.coreos.com/v1"
```

Install the [Bitnami Kube Prometheus helm chart](https://github.com/bitnami/charts/tree/main/bitnami/kube-prometheus) for having the necessary CRDs and the Prometheus Operator.

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
externalDatabase.schema=public
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

This will import all `*.json` under `/opt/bitnami/keycloak/data/import` files as a realm into keycloak as per the official documentation [here](https://www.keycloak.org/server/importExport#_importing_a_realm_from_a_directory). You can supply the files by mounting a volume e.g. with docker compose as follows:

```yaml
keycloak:
  image: bitnami/keycloak:latest
  volumes:
    - /local/path/to/realms/folder:/opt/bitnami/keycloak/data/import
```

#### Exporting a realm

You can export a realm through the GUI but it will not export users even the option is set, this is a known keycloak [bug](https://github.com/keycloak/keycloak/issues/23970).

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
```

This will export the all the realms with users to the `/export` folder.

### Configure Ingress

This chart provides support for Ingress resources. If you have an ingress controller installed on your cluster, such as [nginx-ingress-controller](https://github.com/bitnami/charts/tree/main/bitnami/nginx-ingress-controller) or [contour](https://github.com/bitnami/charts/tree/main/bitnami/contour) you can utilize the ingress controller to serve your application. To enable Ingress integration, set `ingress.enabled` to `true`.

The most common scenario is to have one host name mapped to the deployment. In this case, the `ingress.hostname` property can be used to set the host name. The `ingress.tls` parameter can be used to add the TLS configuration for this host.

However, it is also possible to have more than one host. To facilitate this, the `ingress.extraHosts` parameter (if available) can be set with the host names specified as an array. The `ingress.extraTLS` parameter (if available) can also be used to add the TLS configuration for extra hosts.

> NOTE: For each host specified in the `ingress.extraHosts` parameter, it is necessary to set a name, path, and any annotations that the Ingress controller should know about. Not all annotations are supported by all Ingress controllers, but [this annotation reference document](https://github.com/kubernetes/ingress-nginx/blob/master/docs/user-guide/nginx-configuration/annotations.md) lists the annotations supported by many popular Ingress controllers.

Adding the TLS parameter (where available) will cause the chart to generate HTTPS URLs, and the application will be available on port 443. The actual TLS secrets do not have to be generated by this chart. However, if TLS is enabled, the Ingress record will not work until the TLS secret exists.

[Learn more about Ingress controllers](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/).

#### Configure TLS Secrets for use with Ingress

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

### Securing traffic using TLS

TLS support for the web interface can be enabled in the chart by specifying the `tls.enabled=true`. Two possible options are available:

- Provide your own secret with the PEM or JKS certificates
- Have the chart auto-generate the certificates.

#### Providing your own TLS secret

To provide your own secret set the `tls.existingSecret` value. It is possible to use PEM or JKS.

To use PEM Certs:

- `tls.usePemCerts=true`: Use PEM certificates instead of a JKS file.
- `tls.certFilename`: Certificate filename. Defaults to `tls.crt`.
- `tls.certKeyFilename`: Certificate key filename. Defaults to `tls.key`

To use JKS keystore:

- `tls.usePemCerts=false`: Use JKS file.
- `tls.keystoreFilename`: Certificate filename. Defaults to `keycloak.keystore.jks`.
- `tls.truststoreFilename`: Truststore filename. Defaults to `keycloak.truststore.jks`.

In the following example we will use PEM certificates. First, create the secret with the certificates files:

```console
kubectl create secret generic certificates-tls-secret --from-file=./cert.pem --from-file=./cert.key
```

Then, use the following parameters:

```console
tls.enabled=true
tls.autoGenerated.enabled=false
tls.usePemCerts=true
tls.existingSecret="certificates-tls-secret"
tls.certFilename="cert.pem"
tls.certKeyFilename="cert.key"
```

#### Auto-generation of TLS certificates

It is also possible to rely on the chart certificate auto-generation capabilities. The chart supports two different ways to auto-generate the required certificates:

- Using Helm capabilities. Enable this feature by setting `tls.autoGenerated.enabled` to `true` and `tls.autoGenerated.engine` to `helm`.
- Relying on CertManager (please note it's required to have CertManager installed in your K8s cluster). Enable this feature by setting `tls.autoGenerated.enabled` to `true` and `tls.autoGenerated.engine` to `cert-manager`. Please note it's supported to use an existing Issuer/ClusterIssuer for issuing the TLS certificates by setting the `tls.autoGenerated.certManager.existingIssuer` and `tls.autoGenerated.certManager.existingIssuerKind` parameters.

#### Use with ingress offloading SSL

If your ingress controller has the TLS/SSL Termination, you might need to properly configure the reverse proxy headers via the `proxyHeaders` parameter. Find more information in the [upstream documentation](https://www.keycloak.org/server/reverseproxy).

### Update credentials

Bitnami charts configure credentials at first boot. Any further change in the secrets or credentials require manual intervention. Follow these instructions:

- Update the user password following [the upstream documentation](https://www.keycloak.org/server/configuration)
- Update the password secret with the new values (replace the SECRET_NAME and PASSWORD placeholders)

```shell
kubectl create secret generic SECRET_NAME --from-literal=admin-password=PASSWORD --dry-run -o yaml | kubectl apply -f -
```

### Backup and restore

To back up and restore Helm chart deployments on Kubernetes, you need to back up the persistent volumes from the source deployment and attach them to a new deployment using [Velero](https://velero.io/), a Kubernetes backup/restore tool. Find the instructions for using Velero in [this guide](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-backup-restore-deployments-velero-index.html).

### Resource requests and limits

Bitnami charts allow setting resource requests and limits for all containers inside the chart deployment. These are inside the `resources` value (check parameter table). Setting requests is essential for production workloads and these should be adapted to your specific use case.

To make this process easier, the chart contains the `resourcesPreset` values, which automatically sets the `resources` section according to different presets. Check these presets in [the bitnami/common chart](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15). However, in production workloads using `resourcesPreset` is discouraged as it may not fully adapt to your specific needs. Find more information on container resource management in the [official Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).

### Set Pod affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

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

## Parameters

### Global parameters

| Name                                                  | Description                                                                                                                                                                                                                                                                                                                                                         | Value   |
| ----------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `global.imageRegistry`                                | Global Docker Image registry                                                                                                                                                                                                                                                                                                                                        | `""`    |
| `global.imagePullSecrets`                             | Global Docker registry secret names as an array                                                                                                                                                                                                                                                                                                                     | `[]`    |
| `global.defaultStorageClass`                          | Global default StorageClass for Persistent Volume(s)                                                                                                                                                                                                                                                                                                                | `""`    |
| `global.security.allowInsecureImages`                 | Allows skipping image verification                                                                                                                                                                                                                                                                                                                                  | `false` |
| `global.compatibility.openshift.adaptSecurityContext` | Adapt the securityContext sections of the deployment to make them compatible with Openshift restricted-v2 SCC: remove runAsUser, runAsGroup and fsGroup and let the platform use their allowed default IDs. Possible values: auto (apply if the detected running cluster is Openshift), force (perform the adaptation always), disabled (do not perform adaptation) | `auto`  |
| `global.compatibility.omitEmptySeLinuxOptions`        | If set to true, removes the seLinuxOptions from the securityContexts when it is set to an empty object                                                                                                                                                                                                                                                              | `false` |

### Common parameters

| Name                     | Description                                                                             | Value           |
| ------------------------ | --------------------------------------------------------------------------------------- | --------------- |
| `kubeVersion`            | Override Kubernetes version reported by .Capabilities                                   | `""`            |
| `apiVersions`            | Override Kubernetes API versions reported by .Capabilities                              | `[]`            |
| `nameOverride`           | String to partially override common.names.name                                          | `""`            |
| `fullnameOverride`       | String to fully override common.names.fullname                                          | `""`            |
| `namespaceOverride`      | String to fully override common.names.namespace                                         | `""`            |
| `commonLabels`           | Labels to add to all deployed objects                                                   | `{}`            |
| `commonAnnotations`      | Annotations to add to all deployed objects                                              | `{}`            |
| `clusterDomain`          | Default Kubernetes cluster domain                                                       | `cluster.local` |
| `extraDeploy`            | Array of extra objects to deploy with the release                                       | `[]`            |
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden) | `false`         |
| `diagnosticMode.command` | Command to override all containers in the chart release                                 | `["sleep"]`     |
| `diagnosticMode.args`    | Args to override all containers in the chart release                                    | `["infinity"]`  |
| `useHelmHooks`           | Enable use of Helm hooks if needed, e.g. on post-install jobs                           | `true`          |
| `usePasswordFiles`       | Mount credentials as files instead of using environment variables                       | `true`          |

### Keycloak parameters

| Name                                                | Description                                                                                                                                                                                                       | Value                      |
| --------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------- |
| `image.registry`                                    | Keycloak image registry                                                                                                                                                                                           | `REGISTRY_NAME`            |
| `image.repository`                                  | Keycloak image repository                                                                                                                                                                                         | `REPOSITORY_NAME/keycloak` |
| `image.digest`                                      | Keycloak image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                          | `""`                       |
| `image.pullPolicy`                                  | Keycloak image pull policy                                                                                                                                                                                        | `IfNotPresent`             |
| `image.pullSecrets`                                 | Keycloak image pull secrets                                                                                                                                                                                       | `[]`                       |
| `image.debug`                                       | Enable Keycloak image debug mode                                                                                                                                                                                  | `false`                    |
| `auth.adminUser`                                    | Keycloak administrator user                                                                                                                                                                                       | `user`                     |
| `auth.adminPassword`                                | Keycloak administrator password for the new user                                                                                                                                                                  | `""`                       |
| `auth.existingSecret`                               | Existing secret containing Keycloak admin password                                                                                                                                                                | `""`                       |
| `auth.passwordSecretKey`                            | Key where the Keycloak admin password is being stored inside the existing secret.                                                                                                                                 | `""`                       |
| `auth.annotations`                                  | Additional custom annotations for Keycloak auth secret object                                                                                                                                                     | `{}`                       |
| `production`                                        | Run Keycloak in production mode. TLS configuration is required except when using proxy headers                                                                                                                    | `false`                    |
| `tls.enabled`                                       | Enable TLS in Keycloak                                                                                                                                                                                            | `false`                    |
| `tls.usePemCerts`                                   | Use PEM certificates as input instead of PKS12/JKS stores                                                                                                                                                         | `false`                    |
| `tls.autoGenerated.enabled`                         | Enable automatic generation of TLS certificates                                                                                                                                                                   | `true`                     |
| `tls.autoGenerated.engine`                          | Mechanism to generate the certificates (allowed values: helm, cert-manager)                                                                                                                                       | `helm`                     |
| `tls.autoGenerated.certManager.existingIssuer`      | The name of an existing Issuer to use for generating the certificates (only for `cert-manager` engine)                                                                                                            | `""`                       |
| `tls.autoGenerated.certManager.existingIssuerKind`  | Existing Issuer kind, defaults to Issuer (only for `cert-manager` engine)                                                                                                                                         | `""`                       |
| `tls.autoGenerated.certManager.keyAlgorithm`        | Key algorithm for the certificates (only for `cert-manager` engine)                                                                                                                                               | `RSA`                      |
| `tls.autoGenerated.certManager.keySize`             | Key size for the certificates (only for `cert-manager` engine)                                                                                                                                                    | `2048`                     |
| `tls.autoGenerated.certManager.duration`            | Duration for the certificates (only for `cert-manager` engine)                                                                                                                                                    | `2160h`                    |
| `tls.autoGenerated.certManager.renewBefore`         | Renewal period for the certificates (only for `cert-manager` engine)                                                                                                                                              | `360h`                     |
| `tls.existingSecret`                                | The name of an existing Secret containing the TLS certificates for Keycloak replicas                                                                                                                              | `""`                       |
| `tls.certFilename`                                  | Certificate filename inside the existing secret (when tls.usePemCerts=true and tls.autoGenerated.enabled=false)                                                                                                   | `tls.crt`                  |
| `tls.certKeyFilename`                               | Certificate key filename inside the existing secret (when tls.usePemCerts=true and tls.autoGenerated.enabled=false)                                                                                               | `tls.key`                  |
| `tls.keystoreFilename`                              | Keystore filename inside the existing secret                                                                                                                                                                      | `keycloak.keystore.jks`    |
| `tls.truststoreFilename`                            | Truststore filename inside the existing secret                                                                                                                                                                    | `keycloak.truststore.jks`  |
| `tls.keystorePassword`                              | Password to access the keystore when it's password-protected                                                                                                                                                      | `""`                       |
| `tls.truststorePassword`                            | Password to access the truststore when it's password-protected                                                                                                                                                    | `""`                       |
| `tls.passwordsSecret`                               | The name of an existing Secret containing the keystore/truststore passwords (expected keys: `tls-keystore-password` and `tls-truststore-password`)                                                                | `""`                       |
| `trustedCertsExistingSecret`                        | Name of the existing Secret containing the trusted certificates to validate communications with external services                                                                                                 | `""`                       |
| `adminRealm`                                        | Name of the admin realm                                                                                                                                                                                           | `master`                   |
| `proxyHeaders`                                      | Set Keycloak proxy headers                                                                                                                                                                                        | `""`                       |
| `hostnameStrict`                                    | Disables dynamically resolving the hostname from request headers (ignored if ingress.enabled is false).                                                                                                           | `false`                    |
| `httpEnabled`                                       | Force enabling HTTP endpoint (by default is only enabled if TLS is disabled)                                                                                                                                      | `false`                    |
| `httpRelativePath`                                  | Set the path relative to '/' for serving resources                                                                                                                                                                | `/`                        |
| `cache.enabled`                                     | Switch to enable or disable the Keycloak distributed cache for kubernetes.                                                                                                                                        | `true`                     |
| `cache.stack`                                       | Cache stack to use                                                                                                                                                                                                | `jdbc-ping`                |
| `cache.configFile`                                  | Path to the file from which cache configuration should be loaded from                                                                                                                                             | `cache-ispn.xml`           |
| `cache.useHeadlessServiceWithAppVersion`            | Create a headless service used for ispn containing the app version                                                                                                                                                | `false`                    |
| `logging.output`                                    | Alternates between the default log output format or json format                                                                                                                                                   | `default`                  |
| `logging.level`                                     | Allowed values as documented: FATAL, ERROR, WARN, INFO, DEBUG, TRACE, ALL, OFF                                                                                                                                    | `INFO`                     |
| `configuration`                                     | Keycloak Configuration. Auto-generated based on other parameters when not specified                                                                                                                               | `""`                       |
| `existingConfigmap`                                 | Name of existing ConfigMap with Keycloak configuration                                                                                                                                                            | `""`                       |
| `extraStartupArgs`                                  | Extra default startup args                                                                                                                                                                                        | `""`                       |
| `initdbScripts`                                     | Dictionary of initdb scripts                                                                                                                                                                                      | `{}`                       |
| `initdbScriptsConfigMap`                            | ConfigMap with the initdb scripts (Note: Overrides `initdbScripts`)                                                                                                                                               | `""`                       |
| `command`                                           | Override default container command (useful when using custom images)                                                                                                                                              | `[]`                       |
| `args`                                              | Override default container args (useful when using custom images)                                                                                                                                                 | `[]`                       |
| `extraEnvVars`                                      | Extra environment variables to be set on Keycloak container                                                                                                                                                       | `[]`                       |
| `extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars                                                                                                                                                              | `""`                       |
| `extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars                                                                                                                                                                 | `""`                       |
| `containerPorts.http`                               | Keycloak HTTP container port                                                                                                                                                                                      | `8080`                     |
| `containerPorts.https`                              | Keycloak HTTPS container port                                                                                                                                                                                     | `8443`                     |
| `containerPorts.management`                         | Keycloak management container port                                                                                                                                                                                | `9000`                     |
| `extraContainerPorts`                               | Optionally specify extra list of additional ports for Keycloak container                                                                                                                                          | `[]`                       |
| `podSecurityContext.enabled`                        | Enabled Keycloak pods' Security Context                                                                                                                                                                           | `true`                     |
| `podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                | `Always`                   |
| `podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                    | `[]`                       |
| `podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                       | `[]`                       |
| `podSecurityContext.fsGroup`                        | Set Keycloak pod's Security Context fsGroup                                                                                                                                                                       | `1001`                     |
| `containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                                                                                                                              | `true`                     |
| `containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                  | `{}`                       |
| `containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                                                                                                        | `1001`                     |
| `containerSecurityContext.runAsGroup`               | Set containers' Security Context runAsGroup                                                                                                                                                                       | `1001`                     |
| `containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                                                                                                                     | `true`                     |
| `containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                                                                                                                       | `false`                    |
| `containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                           | `true`                     |
| `containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                                                                                                         | `false`                    |
| `containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                | `["ALL"]`                  |
| `containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                  | `RuntimeDefault`           |
| `resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if resources is set (resources is recommended for production). | `small`                    |
| `resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                 | `{}`                       |
| `livenessProbe.enabled`                             | Enable livenessProbe on Keycloak containers                                                                                                                                                                       | `true`                     |
| `livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                           | `120`                      |
| `livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                  | `1`                        |
| `livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                 | `5`                        |
| `livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                               | `3`                        |
| `livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                               | `1`                        |
| `readinessProbe.enabled`                            | Enable readinessProbe on Keycloak containers                                                                                                                                                                      | `true`                     |
| `readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                          | `30`                       |
| `readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                 | `10`                       |
| `readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                | `1`                        |
| `readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                              | `3`                        |
| `readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                              | `1`                        |
| `startupProbe.enabled`                              | Enable startupProbe on Keycloak containers                                                                                                                                                                        | `false`                    |
| `startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                            | `30`                       |
| `startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                   | `5`                        |
| `startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                  | `1`                        |
| `startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                | `10`                       |
| `startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                | `1`                        |
| `customLivenessProbe`                               | Custom Liveness probes for Keycloak                                                                                                                                                                               | `{}`                       |
| `customReadinessProbe`                              | Custom Readiness probes Keycloak                                                                                                                                                                                  | `{}`                       |
| `customStartupProbe`                                | Custom Startup probes for Keycloak                                                                                                                                                                                | `{}`                       |

### Keycloak StatefulSet parameters

| Name                            | Description                                                                                                              | Value           |
| ------------------------------- | ------------------------------------------------------------------------------------------------------------------------ | --------------- |
| `replicaCount`                  | Number of Keycloak replicas to deploy                                                                                    | `1`             |
| `updateStrategy.type`           | Keycloak StatefulSet type                                                                                                | `RollingUpdate` |
| `revisionHistoryLimitCount`     | Number of controller revisions to keep                                                                                   | `10`            |
| `minReadySeconds`               | How many seconds a pod needs to be ready before killing the next, during update                                          | `0`             |
| `statefulsetAnnotations`        | Optionally add extra annotations on the StatefulSet resource                                                             | `{}`            |
| `automountServiceAccountToken`  | Mount Service Account token in Keycloak pods                                                                             | `true`          |
| `hostAliases`                   | Deployment pod host aliases                                                                                              | `[]`            |
| `podLabels`                     | Extra labels for Keycloak pods                                                                                           | `{}`            |
| `podAnnotations`                | Annotations for Keycloak pods                                                                                            | `{}`            |
| `podAffinityPreset`             | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                      | `""`            |
| `podAntiAffinityPreset`         | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                 | `soft`          |
| `nodeAffinityPreset.type`       | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                | `""`            |
| `nodeAffinityPreset.key`        | Node label key to match. Ignored if `affinity` is set.                                                                   | `""`            |
| `nodeAffinityPreset.values`     | Node label values to match. Ignored if `affinity` is set.                                                                | `[]`            |
| `affinity`                      | Affinity for pod assignment                                                                                              | `{}`            |
| `nodeSelector`                  | Node labels for pod assignment                                                                                           | `{}`            |
| `tolerations`                   | Tolerations for pod assignment                                                                                           | `[]`            |
| `topologySpreadConstraints`     | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template | `[]`            |
| `podManagementPolicy`           | Pod management policy for the Keycloak StatefulSet                                                                       | `Parallel`      |
| `priorityClassName`             | Keycloak pods' Priority Class Name                                                                                       | `""`            |
| `schedulerName`                 | Use an alternate scheduler, e.g. "stork".                                                                                | `""`            |
| `terminationGracePeriodSeconds` | Seconds Keycloak pod needs to terminate gracefully                                                                       | `""`            |
| `lifecycleHooks`                | LifecycleHooks to set additional configuration at startup                                                                | `{}`            |
| `dnsPolicy`                     | DNS Policy for pod                                                                                                       | `""`            |
| `dnsConfig`                     | DNS Configuration pod                                                                                                    | `{}`            |
| `enableServiceLinks`            | If set to false, disable Kubernetes service links in the pod spec                                                        | `true`          |
| `extraVolumes`                  | Optionally specify extra list of additional volumes for Keycloak pods                                                    | `[]`            |
| `extraVolumeMounts`             | Optionally specify extra list of additional volumeMounts for Keycloak container(s)                                       | `[]`            |
| `initContainers`                | Add additional init containers to the Keycloak pods                                                                      | `[]`            |
| `sidecars`                      | Add additional sidecar containers to the Keycloak pods                                                                   | `[]`            |

### Traffic Exposure Parameters

| Name                                    | Description                                                                                                                      | Value                            |
| --------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | -------------------------------- |
| `service.type`                          | Kubernetes service type                                                                                                          | `ClusterIP`                      |
| `service.http.enabled`                  | Enable http port on service                                                                                                      | `true`                           |
| `service.ports.http`                    | Keycloak service HTTP port                                                                                                       | `80`                             |
| `service.ports.https`                   | Keycloak service HTTPS port                                                                                                      | `443`                            |
| `service.nodePorts.http`                | Node port for HTTP                                                                                                               | `""`                             |
| `service.nodePorts.https`               | Node port for HTTPS                                                                                                              | `""`                             |
| `service.extraPorts`                    | Extra port to expose on Keycloak service                                                                                         | `[]`                             |
| `service.sessionAffinity`               | Control where client requests go, to the same pod or round-robin                                                                 | `None`                           |
| `service.sessionAffinityConfig`         | Additional settings for the sessionAffinity                                                                                      | `{}`                             |
| `service.clusterIP`                     | Keycloak service clusterIP IP                                                                                                    | `""`                             |
| `service.loadBalancerIP`                | loadBalancerIP for the SuiteCRM Service (optional, cloud specific)                                                               | `""`                             |
| `service.loadBalancerSourceRanges`      | Address that are allowed when service is LoadBalancer                                                                            | `[]`                             |
| `service.externalTrafficPolicy`         | Enable client source IP preservation                                                                                             | `Cluster`                        |
| `service.annotations`                   | Additional custom annotations for Keycloak service                                                                               | `{}`                             |
| `service.headless.annotations`          | Annotations for the headless service.                                                                                            | `{}`                             |
| `service.headless.extraPorts`           | Extra ports to expose on Keycloak headless service                                                                               | `[]`                             |
| `ingress.enabled`                       | Enable ingress record generation for Keycloak                                                                                    | `false`                          |
| `ingress.pathType`                      | Ingress path type                                                                                                                | `ImplementationSpecific`         |
| `ingress.apiVersion`                    | Force Ingress API version (automatically detected if not set)                                                                    | `""`                             |
| `ingress.hostname`                      | Default host for the ingress record (evaluated as template)                                                                      | `keycloak.local`                 |
| `ingress.ingressClassName`              | IngressClass that will be be used to implement the Ingress (evaluated as template)                                               | `""`                             |
| `ingress.controller`                    | The ingress controller type. Currently supports `default` and `gce`                                                              | `default`                        |
| `ingress.path`                          | Default path for the ingress record                                                                                              | `{{ .Values.httpRelativePath }}` |
| `ingress.servicePort`                   | Backend service port to use                                                                                                      | `http`                           |
| `ingress.annotations`                   | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                             |
| `ingress.labels`                        | Additional labels for the Ingress resource.                                                                                      | `{}`                             |
| `ingress.tls`                           | Enable TLS configuration for the host defined at `ingress.hostname` parameter                                                    | `false`                          |
| `ingress.selfSigned`                    | Create a TLS secret for this ingress record using self-signed certificates generated by Helm                                     | `false`                          |
| `ingress.extraHosts`                    | An array with additional hostname(s) to be covered with the ingress record                                                       | `[]`                             |
| `ingress.extraPaths`                    | Any additional arbitrary paths that may need to be added to the ingress under the main host.                                     | `[]`                             |
| `ingress.extraTls`                      | The tls configuration for additional hostnames to be covered with this ingress record.                                           | `[]`                             |
| `ingress.secrets`                       | If you're providing your own certificates, please use this to add the certificates as secrets                                    | `[]`                             |
| `ingress.extraRules`                    | Additional rules to be covered with this ingress record                                                                          | `[]`                             |
| `networkPolicy.enabled`                 | Specifies whether a NetworkPolicy should be created                                                                              | `true`                           |
| `networkPolicy.allowExternal`           | Don't require server label for connections                                                                                       | `true`                           |
| `networkPolicy.allowExternalEgress`     | Allow the pod to access any range of port and all destinations.                                                                  | `true`                           |
| `networkPolicy.addExternalClientAccess` | Allow access from pods with client label set to "true". Ignored if `networkPolicy.allowExternal` is true.                        | `true`                           |
| `networkPolicy.kubeAPIServerPorts`      | List of possible endpoints to kube-apiserver (limit to your cluster settings to increase security)                               | `[]`                             |
| `networkPolicy.extraIngress`            | Add extra ingress rules to the NetworkPolicy                                                                                     | `[]`                             |
| `networkPolicy.extraEgress`             | Add extra ingress rules to the NetworkPolicy                                                                                     | `[]`                             |
| `networkPolicy.ingressPodMatchLabels`   | Labels to match to allow traffic from other pods. Ignored if `networkPolicy.allowExternal` is true.                              | `{}`                             |
| `networkPolicy.ingressNSMatchLabels`    | Labels to match to allow traffic from other namespaces                                                                           | `{}`                             |
| `networkPolicy.ingressNSPodMatchLabels` | Pod labels to match to allow traffic from other namespaces                                                                       | `{}`                             |

### Other parameters

| Name                                                            | Description                                                                                                                                    | Value   |
| --------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `serviceAccount.create`                                         | Specifies whether a ServiceAccount should be created                                                                                           | `true`  |
| `serviceAccount.name`                                           | The name of the ServiceAccount to use.                                                                                                         | `""`    |
| `serviceAccount.annotations`                                    | Additional Service Account annotations (evaluated as a template)                                                                               | `{}`    |
| `serviceAccount.automountServiceAccountToken`                   | Automount service account token for the server service account                                                                                 | `true`  |
| `serviceAccount.extraLabels`                                    | Additional Service Account labels (evaluated as a template)                                                                                    | `{}`    |
| `pdb.create`                                                    | Enable/disable a Pod Disruption Budget creation                                                                                                | `true`  |
| `pdb.minAvailable`                                              | Minimum number/percentage of pods that should remain scheduled                                                                                 | `""`    |
| `pdb.maxUnavailable`                                            | Maximum number/percentage of pods that may be made unavailable. Defaults to `1` if both `pdb.minAvailable` and `pdb.maxUnavailable` are empty. | `""`    |
| `autoscaling.vpa.enabled`                                       | Enable VPA for Keycloak pods                                                                                                                   | `false` |
| `autoscaling.vpa.annotations`                                   | Annotations for VPA resource                                                                                                                   | `{}`    |
| `autoscaling.vpa.controlledResources`                           | VPA List of resources that the vertical pod autoscaler can control. Defaults to cpu and memory                                                 | `[]`    |
| `autoscaling.vpa.maxAllowed`                                    | VPA Max allowed resources for the pod                                                                                                          | `{}`    |
| `autoscaling.vpa.minAllowed`                                    | VPA Min allowed resources for the pod                                                                                                          | `{}`    |
| `autoscaling.vpa.updatePolicy.updateMode`                       | Autoscaling update policy                                                                                                                      | `Auto`  |
| `autoscaling.hpa.enabled`                                       | Enable HPA for Keycloak pods                                                                                                                   | `false` |
| `autoscaling.hpa.minReplicas`                                   | Minimum number of Keycloak replicas                                                                                                            | `1`     |
| `autoscaling.hpa.maxReplicas`                                   | Maximum number of Keycloak replicas                                                                                                            | `11`    |
| `autoscaling.hpa.targetCPU`                                     | Target CPU utilization percentage                                                                                                              | `""`    |
| `autoscaling.hpa.targetMemory`                                  | Target Memory utilization percentage                                                                                                           | `""`    |
| `autoscaling.hpa.behavior.scaleUp.stabilizationWindowSeconds`   | The number of seconds for which past recommendations should be considered while scaling up                                                     | `120`   |
| `autoscaling.hpa.behavior.scaleUp.selectPolicy`                 | The priority of policies that the autoscaler will apply when scaling up                                                                        | `Max`   |
| `autoscaling.hpa.behavior.scaleUp.policies`                     | HPA scaling policies when scaling up                                                                                                           | `[]`    |
| `autoscaling.hpa.behavior.scaleDown.stabilizationWindowSeconds` | The number of seconds for which past recommendations should be considered while scaling down                                                   | `300`   |
| `autoscaling.hpa.behavior.scaleDown.selectPolicy`               | The priority of policies that the autoscaler will apply when scaling down                                                                      | `Max`   |
| `autoscaling.hpa.behavior.scaleDown.policies`                   | HPA scaling policies when scaling down                                                                                                         | `[]`    |

### Metrics parameters

| Name                                       | Description                                                                                            | Value   |
| ------------------------------------------ | ------------------------------------------------------------------------------------------------------ | ------- |
| `metrics.enabled`                          | Enable exposing Keycloak metrics                                                                       | `false` |
| `metrics.service.ports.metrics`            | Metrics service Metrics port                                                                           | `9000`  |
| `metrics.service.annotations`              | Annotations for enabling prometheus to access the metrics endpoints                                    | `{}`    |
| `metrics.service.extraPorts`               | Add additional ports to the keycloak metrics service                                                   | `[]`    |
| `metrics.serviceMonitor.enabled`           | if `true`, creates a Prometheus Operator ServiceMonitor (also requires `metrics.enabled` to be `true`) | `false` |
| `metrics.serviceMonitor.namespace`         | Namespace in which Prometheus is running                                                               | `""`    |
| `metrics.serviceMonitor.annotations`       | Additional custom annotations for the ServiceMonitor                                                   | `{}`    |
| `metrics.serviceMonitor.labels`            | Extra labels for the ServiceMonitor                                                                    | `{}`    |
| `metrics.serviceMonitor.jobLabel`          | The name of the label on the target service to use as the job name in Prometheus                       | `""`    |
| `metrics.serviceMonitor.honorLabels`       | honorLabels chooses the metric's labels on collisions with target labels                               | `false` |
| `metrics.serviceMonitor.tlsConfig`         | TLS configuration used for scrape endpoints used by Prometheus                                         | `{}`    |
| `metrics.serviceMonitor.interval`          | Interval at which metrics should be scraped.                                                           | `""`    |
| `metrics.serviceMonitor.scrapeTimeout`     | Timeout after which the scrape is ended                                                                | `""`    |
| `metrics.serviceMonitor.metricRelabelings` | Specify additional relabeling of metrics                                                               | `[]`    |
| `metrics.serviceMonitor.relabelings`       | Specify general relabeling                                                                             | `[]`    |
| `metrics.serviceMonitor.selector`          | Prometheus instance selector labels                                                                    | `{}`    |
| `metrics.prometheusRule.enabled`           | Create PrometheusRule Resource for scraping metrics using PrometheusOperator                           | `false` |
| `metrics.prometheusRule.namespace`         | Namespace which Prometheus is running in                                                               | `""`    |
| `metrics.prometheusRule.labels`            | Additional labels that can be used so PrometheusRule will be discovered by Prometheus                  | `{}`    |
| `metrics.prometheusRule.groups`            | Groups, containing the alert rules.                                                                    | `[]`    |

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
| `keycloakConfigCli.nodeSelector`                                      | Node labels for pod assignment                                                                                                                                                                                                                        | `{}`                                  |
| `keycloakConfigCli.tolerations`                                       | Tolerations for job pod assignment                                                                                                                                                                                                                    | `[]`                                  |
| `keycloakConfigCli.availabilityCheck.enabled`                         | Whether to wait until Keycloak is available                                                                                                                                                                                                           | `true`                                |
| `keycloakConfigCli.availabilityCheck.timeout`                         | Timeout for the availability check (Default is 120s)                                                                                                                                                                                                  | `""`                                  |
| `keycloakConfigCli.extraEnvVars`                                      | Additional environment variables to set                                                                                                                                                                                                               | `[]`                                  |
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

### Default init container parameters

| Name                                                                                       | Description                                                                                                                                                                                                                                                                                                                        | Value            |
| ------------------------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| `defaultInitContainers.prepareWriteDirs.enabled`                                           | Enable init container that copies writable directories to an empty dir                                                                                                                                                                                                                                                             | `true`           |
| `defaultInitContainers.prepareWriteDirs.containerSecurityContext.enabled`                  | Enabled "prepare-write-dirs" init-containers' Security Context                                                                                                                                                                                                                                                                     | `true`           |
| `defaultInitContainers.prepareWriteDirs.containerSecurityContext.seLinuxOptions`           | Set SELinux options in "prepare-write-dirs" init-containers                                                                                                                                                                                                                                                                        | `{}`             |
| `defaultInitContainers.prepareWriteDirs.containerSecurityContext.runAsUser`                | Set runAsUser in "prepare-write-dirs" init-containers' Security Context                                                                                                                                                                                                                                                            | `1001`           |
| `defaultInitContainers.prepareWriteDirs.containerSecurityContext.runAsGroup`               | Set runAsGroup in "prepare-write-dirs" init-containers' Security Context                                                                                                                                                                                                                                                           | `1001`           |
| `defaultInitContainers.prepareWriteDirs.containerSecurityContext.runAsNonRoot`             | Set runAsNonRoot in "prepare-write-dirs" init-containers' Security Context                                                                                                                                                                                                                                                         | `true`           |
| `defaultInitContainers.prepareWriteDirs.containerSecurityContext.privileged`               | Set privileged in "prepare-write-dirs" init-containers' Security Context                                                                                                                                                                                                                                                           | `false`          |
| `defaultInitContainers.prepareWriteDirs.containerSecurityContext.readOnlyRootFilesystem`   | Set readOnlyRootFilesystem in "prepare-write-dirs" init-containers' Security Context                                                                                                                                                                                                                                               | `true`           |
| `defaultInitContainers.prepareWriteDirs.containerSecurityContext.allowPrivilegeEscalation` | Set allowPrivilegeEscalation in "prepare-write-dirs" init-containers' Security Context                                                                                                                                                                                                                                             | `false`          |
| `defaultInitContainers.prepareWriteDirs.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped in "prepare-write-dirs" init-containers                                                                                                                                                                                                                                                         | `["ALL"]`        |
| `defaultInitContainers.prepareWriteDirs.containerSecurityContext.seccompProfile.type`      | Set seccomp profile in "prepare-write-dirs" init-containers                                                                                                                                                                                                                                                                        | `RuntimeDefault` |
| `defaultInitContainers.prepareWriteDirs.resourcesPreset`                                   | Set Keycloak "prepare-write-dirs" init container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if defaultInitContainers.prepareWriteDirs.resources is set (defaultInitContainers.prepareWriteDirs.resources is recommended for production). | `nano`           |
| `defaultInitContainers.prepareWriteDirs.resources`                                         | Set Keycloak "prepare-write-dirs" init container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                                                                               | `{}`             |

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
| `externalDatabase.schema`                    | Keycloak database schema                                                                                          | `public`           |
| `externalDatabase.existingSecret`            | Name of an existing secret resource containing the database credentials                                           | `""`               |
| `externalDatabase.existingSecretUserKey`     | Name of an existing secret key containing the database user                                                       | `""`               |
| `externalDatabase.existingSecretPasswordKey` | Name of an existing secret key containing the database credentials                                                | `""`               |
| `externalDatabase.annotations`               | Additional custom annotations for external database secret object                                                 | `{}`               |

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

### To 25.0.0

This version stops relying on the [Keycloak Metrics SPI](https://github.com/aerogear/keycloak-metrics-spi) to expose metrics and, relies on the native metrics exposed by Keycloak via [the management interface](https://www.keycloak.org/server/management-interface) and removes SPI Truststore related parameters given this functionality was deprecated on Keycloak as described in this [GitHub discussion](https://github.com/keycloak/keycloak/discussions/28007).
For security reasons, we also dropped support for exposing the management interface via Ingress.

This version includes some important refactoring to remove technical debt. As a consequence, some deprecated parameters were removed and it's likely some others were renamed to match the standards used in the Bitnami Charts catalog.

### To 24.3.0

This version introduces image verification for security purposes. To disable it, set `global.security.allowInsecureImages` to `true`. More details at [GitHub issue](https://github.com/bitnami/charts/issues/30850).

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

Copyright &copy; 2025 Broadcom. The term "Broadcom" refers to Broadcom Inc. and/or its subsidiaries.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

<http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
