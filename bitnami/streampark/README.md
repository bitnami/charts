# Bitnami package for StreamPark
Apache StreamPark™ is a user-friendly streaming application development framework and one-stop cloud-native real-time computing platform.

[Learn more about StreamPark](https://streampark.apache.org/)

## Introduction
This chart bootstrap a StreamPark deployment on a Kubernetes cluster using the Helm package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Prerequisites
- Kubernetes 1.23+
- Helm 3.8.0+

## Installing the Chart
To install the chart with the release name `my-release`:

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/streampark
```

It will deploy a StreamPark and a PostgreSQL instance on the Kubernetes cluster.

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

## Configuration and installation details

### Resource requests and limits
Bitnami charts allow setting resource requests and limits for all containers inside the chart deployment. These are inside the `resources` value (check parameter table). Setting requests is essential for production workloads and these should be adapted to your specific use case.

To make this process easier, the chart contains the `resourcesPreset` values, which automatically sets the `resources` section according to different presets. Check these presets in [the bitnami/common chart](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15). However, in production workloads using `resourcesPreset` is discouraged as it may not fully adapt to your specific needs. Find more information on container resource management in the [official Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).

### [Rolling vs Immutable tags](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html)
It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Use an external database
To make StreamPark connect to an external database (e.g., a managed database service or a centralized database server), disable the internal database options by setting `postgresql.enabled` and `mysql.enabled` to `false`. Then, provide the connection details for your external database using the `externalDatabase.*` parameters. Here is an example:

> WARNING: Please make sure there is already a database named `streampark` in the external database instance.

```yaml
postgresql:
  enabled: false
mysql:
  enabled: false
externalDatabase:
  enabled: true
  type: pgsql
  host: myexternalhost
  port: 5432
  user: myuser
  password: CHANGEME
  ## Following image is used for determining external database is ready or not
  image:
    registry: docker.io
    repository: postgres
    tag: 17.4
    pullPolicy: IfNotPresent
```

To initialize the required schema and data in the external database, you have two options: 

  * Enable `externalDatabase.initDatabase` to use our provided initialization job
  * Perform the initialization manually using the SQL scripts located at [SQL scripts](https://github.com/apache/streampark/tree/v2.1.5/streampark-console/streampark-console-service/src/main/assembly/script)

The initialization job is created and executed only during the initial installation. If the initialization fails for any reason, you will need to either reinstall the chart again or redeploy the initialization job only. Please follow these steps to redeploy initialization job:

1. Retrieve the Job YAML
    ```bash
    kubectl get job -n [NAMESPACE] [JOB NAME] -o yaml > job.yaml
    ```
2. Delete failed Job
    ```bash
    kubectl delete job -n [NAMESPACE] [JOB NAME]
    ```
3. Re-deploy a new Job with previous YAML
    ```bash
    kubectl apply -f job.yaml
    ```

### Docker engine
When a user submits a job, StreamPark automatically builds a container image for the job using a Docker engine. This image encapsulates the job's code and dependencies. The resulting image is then pushed to an external artifact registry, such as Docker Hub or a private registry. Flink subsequently pulls this image from the registry and uses it to launch a Flink Session, providing a consistent and reproducible execution environment.

Therefore, we should specify the Docker engine in following 2 ways:

  * Enabling `dockerInDocker.create` to create a DinD (Docker in Docker) Pod with privileged mode
  * Provision additional Docker engine with following values
    ```yaml
    dockerInDocker:
      create: false
      externalHost: "your-docker-engine.local"
      externalPort: 2375
    ```

The Docker engine will be directly specified as environment variable `DOCKER_HOST` in `templates/deployment.yaml`.

> NOTICE: For security reasons, Docker in Docker (DinD) is typically disabled on Kubernetes clusters in most public cloud environments. This is because DinD can introduce potential security vulnerabilities. To work around this limitation, you can create a dedicated `dind` service on a separate cloud instance and configure StreamPark to use this service for building container images.

### Configure TLS Secrets for use with Ingress
This chart facilitates the creation of TLS secrets for use with the Ingress controller (although this is not mandatory). There are several common use cases :

  * Use the `ingress.tlsSecretName` parameter to point the TLS secret you already have
    ```yaml
    ingress:
      tls: true
      # The TLS secret must contain keys named tls.crt and tls.key that contain the certificate and private key to use for TLS.
      tlsSecretName: "your-secret-name"
    ```
  * Use the `ingress.secrets` parameter to create this TLS secret, and it will be attached on ingress automatically
    ```yaml
    ingress:
      tls: true
      secrets:
      - name: streampark.local-tls # specify to your hostname instead of 'streampark.local'
        certificate: |-
          -----BEGIN CERTIFICATE-----
          ...
          -----END CERTIFICATE-----
        key: |-
          -----BEGIN RSA PRIVATE KEY-----
          ...
          -----END RSA PRIVATE KEY-----
    ```
  * Rely on cert-manager to create it by setting the [corresponding annotations](https://cert-manager.io/docs/usage/ingress/#supported-annotations)
    ```yaml
    ingress:
      tls: true
      annotations:
        cert-manager.io/cluster-issuer: letsencrypt
    ```
  * Rely on Helm to create self-signed certificates by setting `ingress.selfSigned=true`
    ```yaml
    ingress:
      tls: true
      selfSigned: true
    ```

### Upgrade
If you need to upgrade database to meet [system requirement](https://streampark.apache.org/docs/get-started/installation), here is how you can do steps by steps :

1. Stop Streampark service
    ```bash
    kubectl scale deployment [Deployment Name] -n [Namespace] --replica 0
    ```

2. According to how you install database, upgrade database version by your own.

3. Download [Streampark release](https://streampark.apache.org/download/) to get SQL scripts and upgrade database in sequences :
    * If the current version is `2.1.2`, you need to execute the scripts in the following order: `2.1.3.sql` → `2.1.4.sql` → `2.1.5.sql`.
    * If the current version is `2.1.3`, you need to execute `2.1.4.sql` → `2.1.5.sql`.
    * If the current version is `2.1.4`, you only need to execute `2.1.5.sql`.

4. Restart or upgrade Streampark service
    ```bash
    kubectl scale deployment [Deployment Name] -n [Namespace] --replica 1
    ```

## Parameters

### Global parameters

| Name                                  | Description                                          | Value   |
| ------------------------------------- | ---------------------------------------------------- | ------- |
| `global.imageRegistry`                | Global Docker image registry                         | `""`    |
| `global.imagePullSecrets`             | Global Docker registry secret names as an array      | `[]`    |
| `global.defaultStorageClass`          | Global default StorageClass for Persistent Volume(s) | `""`    |
| `global.security.allowInsecureImages` | Allows skipping image verification                   | `false` |
| `extraDeploy`                         | Array of extra objects to deploy with the release    | `[]`    |

### StreamPark parameters

| Name                                     | Description                                                                                                                                                                                                       | Value                        |
| ---------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------- |
| `image.registry`                         | StreamPark image registry                                                                                                                                                                                         | `REGISTRY_NAME`              |
| `image.repository`                       | StreamPark image repository                                                                                                                                                                                       | `REPOSITORY_NAME/streampark` |
| `image.digest`                           | StreamPark image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                        | `""`                         |
| `image.pullPolicy`                       | StreamPark image pull policy                                                                                                                                                                                      | `IfNotPresent`               |
| `image.pullSecrets`                      | Specify docker-registry secret names as an array                                                                                                                                                                  | `[]`                         |
| `image.debug`                            | Specify if debug logs should be enabled                                                                                                                                                                           | `false`                      |
| `commonLabels`                           | Labels to add to all deployed objects                                                                                                                                                                             | `{}`                         |
| `commonAnnotations`                      | Annotations to add to all deployed objects                                                                                                                                                                        | `{}`                         |
| `deploymentAnnotations`                  | Annotations to deployment only                                                                                                                                                                                    | `{}`                         |
| `jobAnnotations`                         | Annotations to job only                                                                                                                                                                                           | `{}`                         |
| `automountServiceAccountToken`           | Mount Service Account token in pod                                                                                                                                                                                | `true`                       |
| `extraEnvVars`                           | Extra environment variables to be set on StreamPark container                                                                                                                                                     | `[]`                         |
| `extraEnvVarsCM`                         | Name of existing ConfigMap containing extra env vars                                                                                                                                                              | `""`                         |
| `extraEnvVarsSecret`                     | Name of existing Secret containing extra env vars                                                                                                                                                                 | `""`                         |
| `replicaCount`                           | Number of StreamPark replicas to deploy                                                                                                                                                                           | `1`                          |
| `podAffinityPreset`                      | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                               | `""`                         |
| `podAntiAffinityPreset`                  | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                          | `soft`                       |
| `nodeAffinityPreset.type`                | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                         | `""`                         |
| `nodeAffinityPreset.key`                 | Node label key to match. Ignored if `affinity` is set.                                                                                                                                                            | `""`                         |
| `nodeAffinityPreset.values`              | Node label values to match. Ignored if `affinity` is set.                                                                                                                                                         | `[]`                         |
| `affinity`                               | Affinity for pod assignment                                                                                                                                                                                       | `{}`                         |
| `nodeSelector`                           | Node labels for pod assignment                                                                                                                                                                                    | `{}`                         |
| `tolerations`                            | Tolerations for pod assignment                                                                                                                                                                                    | `[]`                         |
| `podSecurityContext.enabled`             | Enabled Security Context in StreamPark pod                                                                                                                                                                        | `false`                      |
| `podSecurityContext.fsGroupChangePolicy` | Set filesystem group change policy                                                                                                                                                                                | `Always`                     |
| `podSecurityContext.sysctls`             | Set kernel settings using the sysctl interface                                                                                                                                                                    | `[]`                         |
| `podSecurityContext.supplementalGroups`  | Set filesystem extra groups                                                                                                                                                                                       | `[]`                         |
| `podSecurityContext.fsGroup`             | Set Security Context fsGroup in StreamPark pod                                                                                                                                                                    | `1001`                       |
| `resourcesPreset`                        | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if resources is set (resources is recommended for production). | `micro`                      |
| `resources`                              | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                 | `{}`                         |
| `extraVolumes`                           | Optionally specify extra list of additional volumes for StreamPark pods                                                                                                                                           | `[]`                         |
| `extraVolumeMounts`                      | Optionally specify extra list of additional volumeMounts for StreamPark container(s)                                                                                                                              | `[]`                         |
| `existingConfigmap`                      | Name of existing ConfigMap for StreamPark configuration                                                                                                                                                           | `""`                         |

### Exposure parameters

| Name                               | Description                                                                                                                      | Value                    |
| ---------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `service.type`                     | Kubernetes service type                                                                                                          | `ClusterIP`              |
| `service.nodePorts`                | Specify the nodePort values for the LoadBalancer and NodePort service types.                                                     | `""`                     |
| `service.sessionAffinity`          | Control where client requests go, to the same pod or round-robin                                                                 | `None`                   |
| `service.sessionAffinityConfig`    | Additional settings for the sessionAffinity                                                                                      | `{}`                     |
| `service.clusterIP`                | StreamPark service clusterIP IP                                                                                                  | `""`                     |
| `service.loadBalancerIP`           | loadBalancerIP for the service on cloud (optional)                                                                               | `""`                     |
| `service.loadBalancerSourceRanges` | Address that are allowed when service is LoadBalancer                                                                            | `[]`                     |
| `service.externalTrafficPolicy`    | Enable client source IP preservation                                                                                             | `Cluster`                |
| `service.annotations`              | Additional custom annotations for StreamPark service                                                                             | `{}`                     |
| `service.extraPorts`               | Extra port to expose on StreamPark service                                                                                       | `[]`                     |
| `ingress.enabled`                  | Enable ingress record generation for StreamPark                                                                                  | `false`                  |
| `ingress.ingressClassName`         | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                    | `""`                     |
| `ingress.hostname`                 | Ingress hostname                                                                                                                 | `streampark.local`       |
| `ingress.path`                     | Default path for the ingress record                                                                                              | `/`                      |
| `ingress.pathType`                 | Ingress path type                                                                                                                | `ImplementationSpecific` |
| `ingress.servicePort`              | Backend service port to use                                                                                                      | `http`                   |
| `ingress.apiVersion`               | Force Ingress API version (automatically detected if not set)                                                                    | `""`                     |
| `ingress.annotations`              | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                     |
| `ingress.labels`                   | Additional labels for the Ingress resource.                                                                                      | `{}`                     |
| `ingress.tls`                      | Enable TLS configuration for the host defined at `ingress.hostname` parameter                                                    | `true`                   |
| `ingress.tlsSecretName`            | Existing secret name for TLS certificate                                                                                         | `""`                     |
| `ingress.secrets`                  | You can use this block to create a new secret with your own cert and key pair.                                                   | `[]`                     |
| `ingress.selfSigned`               | Create a TLS secret for this ingress record using self-signed certificates generated by Helm                                     | `false`                  |
| `ingress.extraHosts`               | An array with additional hostname(s) to be covered with the ingress record                                                       | `[]`                     |
| `ingress.extraPaths`               | Any additional arbitrary paths that may need to be added to the ingress under the main host.                                     | `[]`                     |
| `ingress.extraTls`                 | The tls configuration for additional hostnames to be covered with this ingress record.                                           | `[]`                     |
| `ingress.extraRules`               | Additional rules to be covered with this ingress record                                                                          | `[]`                     |

### RBAC parameters

| Name                                          | Description                                            | Value        |
| --------------------------------------------- | ------------------------------------------------------ | ------------ |
| `serviceAccount.create`                       | Create ServiceAccount or not                           | `true`       |
| `serviceAccount.name`                         | Name of the ServiceAccount you create or wante to be.  | `streampark` |
| `serviceAccount.automountServiceAccountToken` | Auto-mount the service account token in the pod        | `false`      |
| `serviceAccount.annotations`                  | Additional custom annotations for the ServiceAccount   | `{}`         |
| `serviceAccount.extraLabels`                  | Additional labels for the ServiceAccount               | `{}`         |
| `rbac.create`                                 | Whether to create required Role and RoleBinding or not | `true`       |

### StreamPark configuration

| Name                                       | Description                                                                                                                                                   | Value         |
| ------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------- |
| `streamParkConfiguration.timezone`         | Timezone in StreamPark container                                                                                                                              | `Asia/Taipei` |
| `streamParkConfiguration.streampark`       | Configuration for `streampark` filed in the `/streampark/conf/config.yaml`                                                                                    | `{}`          |
| `streamParkConfiguration.ldap`             | Configuration for StreamPark authentication via LDAP                                                                                                          | `{}`          |
| `streamParkConfiguration.sso`              | Configuration for StreamPark authentication via SSO                                                                                                           | `{}`          |
| `streamParkConfiguration.securityKerberos` | Flink on yarn or spark on yarn, when the hadoop cluster enable kerberos authentication, it is necessary to set up Kerberos authentication related parameters. | `{}`          |
| `streamParkConfiguration.logbackSpring`    | Override the default `logback-spring.xml` configuration                                                                                                       | `""`          |

### Docker server parameters

| Name                                      | Description                                        | Value                    |
| ----------------------------------------- | -------------------------------------------------- | ------------------------ |
| `dockerInDocker.create`                   | Create dind deployment or not                      | `true`                   |
| `dockerInDocker.image.registry`           | Image registry                                     | `REGISTRY_NAME`          |
| `dockerInDocker.image.repository`         | Image repository                                   | `REPOSITORY_NAME/docker` |
| `dockerInDocker.image.tag`                | Image tag (immutable tags are recommended)         | `dind`                   |
| `dockerInDocker.image.pullPolicy`         | Image pull policy                                  | `IfNotPresent`           |
| `dockerInDocker.image.pullSecrets`        | Specify docker-registry secret names as an array   | `[]`                     |
| `dockerInDocker.extraEnvVars`             | Extra environment variables for dind container     | `[]`                     |
| `dockerInDocker.persistence.accessModes`  | Access mode for persistent volume                  | `ReadWriteOnce`          |
| `dockerInDocker.persistence.storageClass` | StorageClass for persistent volume                 | `""`                     |
| `dockerInDocker.persistence.volumeMode`   | Volume mode for persistent volume                  | `Filesystem`             |
| `dockerInDocker.persistence.size`         | Storage size for persistent volume                 | `10Gi`                   |
| `dockerInDocker.externalHost`             | Host name or IP address for external Docker server | `""`                     |
| `dockerInDocker.externalPort`             | Port number for external Docker server             | `2375`                   |

### Busybox parameters

| Name                       | Description      | Value                     |
| -------------------------- | ---------------- | ------------------------- |
| `busybox.image.registry`   | Image registry   | `REGISTRY_NAME`           |
| `busybox.image.repository` | Image repository | `REPOSITORY_NAME/busybox` |
| `busybox.image.tag`        | Image tag        | `latest`                  |
| `busybox.image.pullPolicy` | Image pullPolicy | `IfNotPresent`            |

### External database parameters

| Name                                         | Description                                        | Value                      |
| -------------------------------------------- | -------------------------------------------------- | -------------------------- |
| `externalDatabase.enabled`                   | Using external database                            | `false`                    |
| `externalDatabase.type`                      | Specify database either `pgsql` or `mysql`         | `pgsql`                    |
| `externalDatabase.host`                      | Hostname or IP address for external database       | `psql.host`                |
| `externalDatabase.port`                      | Port number for accessing database                 | `5432`                     |
| `externalDatabase.user`                      | User name used by StreamPark accessing database    | `streampark`               |
| `externalDatabase.password`                  | Password for previous user                         | `CHANGEME`                 |
| `externalDatabase.existingSecret`            | Secret name which stores the password              | `""`                       |
| `externalDatabase.existingSecretPasswordKey` | Key in the Secret which stores the password values | `""`                       |
| `externalDatabase.initDatabase`              | Initialize external database with our job          | `true`                     |
| `externalDatabase.image.registry`            | Image registry                                     | `REGISTRY_NAME`            |
| `externalDatabase.image.repository`          | Image repository                                   | `REPOSITORY_NAME/postgres` |
| `externalDatabase.image.tag`                 | Image tag                                          | `17.4`                     |
| `externalDatabase.image.pullPolicy`          | Image pullPolicy                                   | `IfNotPresent`             |

## Know Issues

### SSO configuration
**Description** : According to the [config.yaml](https://github.com/apache/streampark/blob/v2.1.5/helm/streampark/conf/config.yaml), there is no any corresponding field for SSO configuration like the original [application-sso.yml](https://streampark.apache.org/docs/platform/sso#how-to-enable-sso-login). Since `application-*.yml` is deprecated in v2.1.5, we still not know how to inject SSO related parameters in `config.yaml`.

**Follow Up** : [Issues on GitHub](https://github.com/apache/streampark/issues/4237)