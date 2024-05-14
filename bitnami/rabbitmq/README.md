<!--- app-name: RabbitMQ -->

# Bitnami package for RabbitMQ

RabbitMQ is an open source general-purpose message broker that is designed for consistent, highly-available messaging scenarios (both synchronous and asynchronous).

[Overview of RabbitMQ](https://www.rabbitmq.com)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/rabbitmq
```

Looking to use RabbitMQ in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the enterprise edition of Bitnami Application Catalog.

## Introduction

This chart bootstraps a [RabbitMQ](https://github.com/bitnami/containers/tree/main/bitnami/rabbitmq) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/rabbitmq
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The command deploys RabbitMQ on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Configuration and installation details

### Resource requests and limits

Bitnami charts allow setting resource requests and limits for all containers inside the chart deployment. These are inside the `resources` value (check parameter table). Setting requests is essential for production workloads and these should be adapted to your specific use case.

To make this process easier, the chart contains the `resourcesPreset` values, which automatically sets the `resources` section according to different presets. Check these presets in [the bitnami/common chart](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15). However, in production workloads using `resourcePreset` is discouraged as it may not fully adapt to your specific needs. Find more information on container resource management in the [official Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).

### [Rolling vs Immutable tags](https://docs.vmware.com/en/VMware-Tanzu-Application-Catalog/services/tutorials/GUID-understand-rolling-tags-containers-index.html)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Set pod affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

### Scale horizontally

To horizontally scale this chart once it has been deployed, two options are available:

- Use the `kubectl scale` command.
- Upgrade the chart modifying the `replicaCount` parameter.

```text
    replicaCount=3
    auth.password="$RABBITMQ_PASSWORD"
    auth.erlangCookie="$RABBITMQ_ERLANG_COOKIE"
```

> NOTE: It is mandatory to specify the password and Erlang cookie that was set the first time the chart was installed when upgrading the chart. Otherwise, new pods won't be able to join the cluster.

When scaling down the solution, unnecessary RabbitMQ nodes are automatically stopped, but they are not removed from the cluster. These nodes must be manually removed via the `rabbitmqctl forget_cluster_node` command.

For instance, if RabbitMQ was initially installed with three replicas and then scaled down to two replicas, run the commands below (assuming that the release name is `rabbitmq` and the clustering type is `hostname`):

```console
    kubectl exec rabbitmq-0 --container rabbitmq -- rabbitmqctl forget_cluster_node rabbit@rabbitmq-2.rabbitmq-headless.default.svc.cluster.local
    kubectl delete pvc data-rabbitmq-2
```

> NOTE: It is mandatory to specify the password and Erlang cookie that was set the first time the chart was installed when upgrading the chart.

### Enable TLS support

To enable TLS support, first generate the certificates as described in the [RabbitMQ documentation for SSL certificate generation](https://www.rabbitmq.com/ssl.html#automated-certificate-generation).

Once the certificates are generated, you have two alternatives:

- Create a secret with the certificates and associate the secret when deploying the chart
- Include the certificates in the *values.yaml* file when deploying the chart

Set the *auth.tls.failIfNoPeerCert* parameter to *false* to allow a TLS connection if the client fails to provide a certificate.

Set the *auth.tls.sslOptionsVerify* to *verify_peer* to force a node to perform peer verification. When set to *verify_none*, peer verification will be disabled and certificate exchange won't be performed.

This chart also facilitates the creation of TLS secrets for use with the Ingress controller (although this is not mandatory). There are several common use cases:

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

### Load custom definitions

It is possible to [load a RabbitMQ definitions file to configure RabbitMQ](https://www.rabbitmq.com/management.html#load-definitions). Follow the steps below:

Because definitions may contain RabbitMQ credentials, [store the JSON as a Kubernetes secret](https://kubernetes.io/docs/concepts/configuration/secret/#using-secrets-as-files-from-a-pod). Within the secret's data, choose a key name that corresponds with the desired load definitions filename (i.e. `load_definition.json`) and use the JSON object as the value.

Next, specify the `load_definitions` property as an `extraConfiguration` pointing to the load definition file path within the container (i.e. `/app/load_definition.json`) and set `loadDefinition.enable` to `true`. Any load definitions specified will be available within in the container at `/app`.

> NOTE: Loading a definition will take precedence over any configuration done through [Helm values](#parameters).

If needed, you can use `extraSecrets` to let the chart create the secret for you. This way, you don't need to manually create it before deploying a release. These secrets can also be templated to use supplied chart values. Here is an example:

```yaml
auth:
  password: CHANGEME
extraSecrets:
  load-definition:
    load_definition.json: |
      {
        "users": [
          {
            "name": "{{ .Values.auth.username }}",
            "password": "{{ .Values.auth.password }}",
            "tags": "administrator"
          }
        ],
        "vhosts": [
          {
            "name": "/"
          }
        ]
      }
loadDefinition:
  enabled: true
  existingSecret: load-definition
extraConfiguration: |
  load_definitions = /app/load_definition.json
```

### Configure LDAP support

LDAP support can be enabled in the chart by specifying the `ldap.*` parameters while creating a release. For example:

```text
ldap.enabled="true"
ldap.server="my-ldap-server"
ldap.port="389"
ldap.user_dn_pattern="cn=${username},dc=example,dc=org"
```

If `ldap.tls.enabled` is set to true, consider using `ldap.port=636` and checking the settings in the `advancedConfiguration` chart parameters.

### Configure memory high watermark

It is possible to configure a memory high watermark on RabbitMQ to define [memory thresholds](https://www.rabbitmq.com/memory.html#threshold) using the `memoryHighWatermark.*` parameters. To do so, you have two alternatives:

- Set an absolute limit of RAM to be used on each RabbitMQ node, as shown in the configuration example below:

```text
memoryHighWatermark.enabled="true"
memoryHighWatermark.type="absolute"
memoryHighWatermark.value="512Mi"
```

- Set a relative limit of RAM to be used on each RabbitMQ node. To enable this feature,  define the memory limits at pod level too. An example configuration is shown below:

```text
memoryHighWatermark.enabled="true"
memoryHighWatermark.type="relative"
memoryHighWatermark.value="0.4"
resources.limits.memory="2Gi"
```

### Add extra environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `extraEnvVars` property.

```yaml
extraEnvVars:
  - name: LOG_LEVEL
    value: error
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `.extraEnvVarsCM` or the `extraEnvVarsSecret` properties.

### Configure the default user/vhost

If you want to create default user/vhost and set the default permission. you can use `extraConfiguration`:

```yaml
auth:
  username: default-user
extraConfiguration: |-
  default_vhost = default-vhost
  default_permissions.configure = .*
  default_permissions.read = .*
  default_permissions.write = .*
```

### Use plugins

The Bitnami Docker RabbitMQ image ships a set of plugins by default. By default, this chart enables `rabbitmq_management` and `rabbitmq_peer_discovery_k8s` since they are required for RabbitMQ to work on K8s.

To enable extra plugins, set the `extraPlugins` parameter with the list of plugins you want to enable. In addition to this, the `communityPlugins` parameter can be used to specify a list of URLs (separated by spaces) for custom plugins for RabbitMQ.

```text
communityPlugins="http://URL-TO-PLUGIN/"
extraPlugins="my-custom-plugin"
```

### Advanced logging

In case you want to configure RabbitMQ logging set `logs` value to false and set the log config in extraConfiguration following the [official documentation](https://www.rabbitmq.com/logging.html#log-file-location).

An example:

```yaml
logs: false # custom logging
extraConfiguration: |
  log.default.level = warning
  log.file = false
  log.console = true
  log.console.level = warning
  log.console.formatter = json
```

### How to Avoid Deadlocked Deployments After a Cluster-Wide Restart

RabbitMQ nodes assume their peers come back online within five minutes (by default). When the `OrderedReady` pod management policy is used with a readiness probe that implicitly requires a fully booted node, the deployment can deadlock:

- Kubernetes will expect the first node to pass a readiness probe
- The readiness probe may require a fully booted node
- The node will fully boot after it detects that its peers have come online
- Kubernetes will not start any more pods until the first one boots

The following combination of deployment settings avoids the problem:

- Use `podManagementPolicy: "Parallel"` to boot multiple cluster nodes in parallel
- Use `rabbitmq-diagnostics ping` for readiness probe

To learn more, please consult RabbitMQ documentation guides:

- [RabbitMQ Clustering guide: Node Restarts](https://www.rabbitmq.com/docs/clustering#restarting)
- [RabbitMQ Clustering guide: Restarts and Readiness Probes](https://www.rabbitmq.com/docs/clustering#restarting-readiness-probes)
- [Recommendations](https://www.rabbitmq.com/docs/cluster-formation#peer-discovery-k8s) for Operator-less (DIY) deployments to Kubernetes

#### Do Not Force Boot Nodes on a Regular Basis

Note that forcing nodes to boot is **not a solution** and doing so **can be dangerous**.
Forced booting is a last resort mechanism in RabbitMQ that helps make remaining cluster
nodes recover and rejoin each other after a permanent loss of some of their former peers. In other words, forced booting a node is an emergency event recovery procedure.

### Known issues

- Changing the password through RabbitMQ's UI can make the pod fail due to the default liveness probes. If you do so, remember to make the chart aware of the new password. Updating the default secret with the password you set through RabbitMQ's UI will automatically recreate the pods. If you are using your own secret, you may have to manually recreate the pods.

## Persistence

The [Bitnami RabbitMQ](https://github.com/bitnami/containers/tree/main/bitnami/rabbitmq) image stores the RabbitMQ data and configurations at the `/opt/bitnami/rabbitmq/var/lib/rabbitmq/` path of the container.

The chart mounts a [Persistent Volume](https://kubernetes.io/docs/concepts/storage/persistent-volumes/) at this location. By default, the volume is created using dynamic volume provisioning. An existing PersistentVolumeClaim can also be defined.

### Use existing PersistentVolumeClaims

1. Create the PersistentVolume
2. Create the PersistentVolumeClaim
3. Install the chart

```console
helm install my-release --set persistence.existingClaim=PVC_NAME oci://REGISTRY_NAME/REPOSITORY_NAME/rabbitmq
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

### Adjust permissions of the persistence volume mountpoint

As the image runs as non-root by default, it is necessary to adjust the ownership of the persistent volume so that the container can write data into it.

By default, the chart is configured to use Kubernetes Security Context to automatically change the ownership of the volume. However, this feature does not work in all Kubernetes distributions.
As an alternative, this chart supports using an `initContainer` to change the ownership of the volume before mounting it in the final destination.

You can enable this `initContainer` by setting `volumePermissions.enabled` to `true`.

## Parameters

### Global parameters

| Name                                                  | Description                                                                                                                                                                                                                                                                                                                                                         | Value  |
| ----------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------ |
| `global.imageRegistry`                                | Global Docker image registry                                                                                                                                                                                                                                                                                                                                        | `""`   |
| `global.imagePullSecrets`                             | Global Docker registry secret names as an array                                                                                                                                                                                                                                                                                                                     | `[]`   |
| `global.storageClass`                                 | Global StorageClass for Persistent Volume(s)                                                                                                                                                                                                                                                                                                                        | `""`   |
| `global.compatibility.openshift.adaptSecurityContext` | Adapt the securityContext sections of the deployment to make them compatible with Openshift restricted-v2 SCC: remove runAsUser, runAsGroup and fsGroup and let the platform use their allowed default IDs. Possible values: auto (apply if the detected running cluster is Openshift), force (perform the adaptation always), disabled (do not perform adaptation) | `auto` |

### RabbitMQ Image parameters

| Name                | Description                                                                                              | Value                      |
| ------------------- | -------------------------------------------------------------------------------------------------------- | -------------------------- |
| `image.registry`    | RabbitMQ image registry                                                                                  | `REGISTRY_NAME`            |
| `image.repository`  | RabbitMQ image repository                                                                                | `REPOSITORY_NAME/rabbitmq` |
| `image.digest`      | RabbitMQ image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag | `""`                       |
| `image.pullPolicy`  | RabbitMQ image pull policy                                                                               | `IfNotPresent`             |
| `image.pullSecrets` | Specify docker-registry secret names as an array                                                         | `[]`                       |
| `image.debug`       | Set to true if you would like to see extra information on logs                                           | `false`                    |

### Common parameters

| Name                                         | Description                                                                                                                                                             | Value                                             |
| -------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------- |
| `nameOverride`                               | String to partially override rabbitmq.fullname template (will maintain the release name)                                                                                | `""`                                              |
| `fullnameOverride`                           | String to fully override rabbitmq.fullname template                                                                                                                     | `""`                                              |
| `namespaceOverride`                          | String to fully override common.names.namespace                                                                                                                         | `""`                                              |
| `kubeVersion`                                | Force target Kubernetes version (using Helm capabilities if not set)                                                                                                    | `""`                                              |
| `clusterDomain`                              | Kubernetes Cluster Domain                                                                                                                                               | `cluster.local`                                   |
| `extraDeploy`                                | Array of extra objects to deploy with the release                                                                                                                       | `[]`                                              |
| `commonAnnotations`                          | Annotations to add to all deployed objects                                                                                                                              | `{}`                                              |
| `servicenameOverride`                        | String to partially override headless service name                                                                                                                      | `""`                                              |
| `commonLabels`                               | Labels to add to all deployed objects                                                                                                                                   | `{}`                                              |
| `serviceBindings.enabled`                    | Create secret for service binding (Experimental)                                                                                                                        | `false`                                           |
| `enableServiceLinks`                         | Whether information about services should be injected into pod's environment variable                                                                                   | `true`                                            |
| `diagnosticMode.enabled`                     | Enable diagnostic mode (all probes will be disabled and the command will be overridden)                                                                                 | `false`                                           |
| `diagnosticMode.command`                     | Command to override all containers in the deployment                                                                                                                    | `["sleep"]`                                       |
| `diagnosticMode.args`                        | Args to override all containers in the deployment                                                                                                                       | `["infinity"]`                                    |
| `automountServiceAccountToken`               | Mount Service Account token in pod                                                                                                                                      | `true`                                            |
| `hostAliases`                                | Deployment pod host aliases                                                                                                                                             | `[]`                                              |
| `dnsPolicy`                                  | DNS Policy for pod                                                                                                                                                      | `""`                                              |
| `dnsConfig`                                  | DNS Configuration pod                                                                                                                                                   | `{}`                                              |
| `auth.username`                              | RabbitMQ application username                                                                                                                                           | `user`                                            |
| `auth.password`                              | RabbitMQ application password                                                                                                                                           | `""`                                              |
| `auth.securePassword`                        | Whether to set the RabbitMQ password securely. This is incompatible with loading external RabbitMQ definitions and 'true' when not setting the auth.password parameter. | `true`                                            |
| `auth.existingPasswordSecret`                | Existing secret with RabbitMQ credentials (existing secret must contain a value for `rabbitmq-password` key or override with setting auth.existingSecretPasswordKey)    | `""`                                              |
| `auth.existingSecretPasswordKey`             | Password key to be retrieved from existing secret                                                                                                                       | `rabbitmq-password`                               |
| `auth.enableLoopbackUser`                    | If enabled, the user `auth.username` can only connect from localhost                                                                                                    | `false`                                           |
| `auth.erlangCookie`                          | Erlang cookie to determine whether different nodes are allowed to communicate with each other                                                                           | `""`                                              |
| `auth.existingErlangSecret`                  | Existing secret with RabbitMQ Erlang cookie (must contain a value for `rabbitmq-erlang-cookie` key or override with auth.existingSecretErlangKey)                       | `""`                                              |
| `auth.existingSecretErlangKey`               | Erlang cookie key to be retrieved from existing secret                                                                                                                  | `rabbitmq-erlang-cookie`                          |
| `auth.tls.enabled`                           | Enable TLS support on RabbitMQ                                                                                                                                          | `false`                                           |
| `auth.tls.autoGenerated`                     | Generate automatically self-signed TLS certificates                                                                                                                     | `false`                                           |
| `auth.tls.failIfNoPeerCert`                  | When set to true, TLS connection will be rejected if client fails to provide a certificate                                                                              | `true`                                            |
| `auth.tls.sslOptionsVerify`                  | Should [peer verification](https://www.rabbitmq.com/ssl.html#peer-verification) be enabled?                                                                             | `verify_peer`                                     |
| `auth.tls.sslOptionsPassword.enabled`        | Enable usage of password for private Key                                                                                                                                | `false`                                           |
| `auth.tls.sslOptionsPassword.existingSecret` | Name of existing Secret containing the sslOptionsPassword                                                                                                               | `""`                                              |
| `auth.tls.sslOptionsPassword.key`            | Enable Key referring to sslOptionsPassword in Secret specified in auth.tls.sslOptionsPassword.existingSecret                                                            | `""`                                              |
| `auth.tls.sslOptionsPassword.password`       | Use this string as Password. If set, auth.tls.sslOptionsPassword.existingSecret and auth.tls.sslOptionsPassword.key are ignored                                         | `""`                                              |
| `auth.tls.caCertificate`                     | Certificate Authority (CA) bundle content                                                                                                                               | `""`                                              |
| `auth.tls.serverCertificate`                 | Server certificate content                                                                                                                                              | `""`                                              |
| `auth.tls.serverKey`                         | Server private key content                                                                                                                                              | `""`                                              |
| `auth.tls.existingSecret`                    | Existing secret with certificate content to RabbitMQ credentials                                                                                                        | `""`                                              |
| `auth.tls.existingSecretFullChain`           | Whether or not the existing secret contains the full chain in the certificate (`tls.crt`). Will be used in place of `ca.cert` if `true`.                                | `false`                                           |
| `auth.tls.overrideCaCertificate`             | Existing secret with certificate content be mounted instead of the `ca.crt` coming from caCertificate or existingSecret/existingSecretFullChain.                        | `""`                                              |
| `logs`                                       | Path of the RabbitMQ server's Erlang log file. Value for the `RABBITMQ_LOGS` environment variable                                                                       | `-`                                               |
| `ulimitNofiles`                              | RabbitMQ Max File Descriptors                                                                                                                                           | `65536`                                           |
| `maxAvailableSchedulers`                     | RabbitMQ maximum available scheduler threads                                                                                                                            | `""`                                              |
| `onlineSchedulers`                           | RabbitMQ online scheduler threads                                                                                                                                       | `""`                                              |
| `memoryHighWatermark.enabled`                | Enable configuring Memory high watermark on RabbitMQ                                                                                                                    | `false`                                           |
| `memoryHighWatermark.type`                   | Memory high watermark type. Either `absolute` or `relative`                                                                                                             | `relative`                                        |
| `memoryHighWatermark.value`                  | Memory high watermark value                                                                                                                                             | `0.4`                                             |
| `plugins`                                    | List of default plugins to enable (should only be altered to remove defaults; for additional plugins use `extraPlugins`)                                                | `rabbitmq_management rabbitmq_peer_discovery_k8s` |
| `communityPlugins`                           | List of Community plugins (URLs) to be downloaded during container initialization                                                                                       | `""`                                              |
| `extraPlugins`                               | Extra plugins to enable (single string containing a space-separated list)                                                                                               | `rabbitmq_auth_backend_ldap`                      |
| `clustering.enabled`                         | Enable RabbitMQ clustering                                                                                                                                              | `true`                                            |
| `clustering.name`                            | RabbitMQ cluster name                                                                                                                                                   | `""`                                              |
| `clustering.addressType`                     | Switch clustering mode. Either `ip` or `hostname`                                                                                                                       | `hostname`                                        |
| `clustering.rebalance`                       | Rebalance master for queues in cluster when new replica is created                                                                                                      | `false`                                           |
| `clustering.forceBoot`                       | Force boot of an unexpectedly shut down cluster (in an unexpected order).                                                                                               | `false`                                           |
| `clustering.partitionHandling`               | Switch Partition Handling Strategy. Either `autoheal` or `pause_minority` or `pause_if_all_down` or `ignore`                                                            | `autoheal`                                        |
| `loadDefinition.enabled`                     | Enable loading a RabbitMQ definitions file to configure RabbitMQ                                                                                                        | `false`                                           |
| `loadDefinition.file`                        | Name of the definitions file                                                                                                                                            | `/app/load_definition.json`                       |
| `loadDefinition.existingSecret`              | Existing secret with the load definitions file                                                                                                                          | `""`                                              |
| `command`                                    | Override default container command (useful when using custom images)                                                                                                    | `[]`                                              |
| `args`                                       | Override default container args (useful when using custom images)                                                                                                       | `[]`                                              |
| `lifecycleHooks`                             | Overwrite livecycle for the RabbitMQ container(s) to automate configuration before or after startup                                                                     | `{}`                                              |
| `terminationGracePeriodSeconds`              | Default duration in seconds k8s waits for container to exit before sending kill signal.                                                                                 | `120`                                             |
| `extraEnvVars`                               | Extra environment variables to add to RabbitMQ pods                                                                                                                     | `[]`                                              |
| `extraEnvVarsCM`                             | Name of existing ConfigMap containing extra environment variables                                                                                                       | `""`                                              |
| `extraEnvVarsSecret`                         | Name of existing Secret containing extra environment variables (in case of sensitive data)                                                                              | `""`                                              |
| `containerPorts.amqp`                        |                                                                                                                                                                         | `5672`                                            |
| `containerPorts.amqpTls`                     |                                                                                                                                                                         | `5671`                                            |
| `containerPorts.dist`                        |                                                                                                                                                                         | `25672`                                           |
| `containerPorts.manager`                     |                                                                                                                                                                         | `15672`                                           |
| `containerPorts.epmd`                        |                                                                                                                                                                         | `4369`                                            |
| `containerPorts.metrics`                     |                                                                                                                                                                         | `9419`                                            |
| `initScripts`                                | Dictionary of init scripts. Evaluated as a template.                                                                                                                    | `{}`                                              |
| `initScriptsCM`                              | ConfigMap with the init scripts. Evaluated as a template.                                                                                                               | `""`                                              |
| `initScriptsSecret`                          | Secret containing `/docker-entrypoint-initdb.d` scripts to be executed at initialization time that contain sensitive data. Evaluated as a template.                     | `""`                                              |
| `extraContainerPorts`                        | Extra ports to be included in container spec, primarily informational                                                                                                   | `[]`                                              |
| `configuration`                              | RabbitMQ Configuration file content: required cluster configuration                                                                                                     | `""`                                              |
| `tcpListenOptions.backlog`                   | Maximum size of the unaccepted TCP connections queue                                                                                                                    | `128`                                             |
| `tcpListenOptions.nodelay`                   | When set to true, deactivates Nagle's algorithm. Default is true. Highly recommended for most users.                                                                    | `true`                                            |
| `tcpListenOptions.linger.lingerOn`           | Enable Server socket lingering                                                                                                                                          | `true`                                            |
| `tcpListenOptions.linger.timeout`            | Server Socket lingering timeout                                                                                                                                         | `0`                                               |
| `tcpListenOptions.keepalive`                 | When set to true, enables TCP keepalives                                                                                                                                | `false`                                           |
| `configurationExistingSecret`                | Existing secret with the configuration to use as rabbitmq.conf.                                                                                                         | `""`                                              |
| `extraConfiguration`                         | Configuration file content: extra configuration to be appended to RabbitMQ configuration                                                                                | `""`                                              |
| `extraConfigurationExistingSecret`           | Existing secret with the extra configuration to append to `configuration`.                                                                                              | `""`                                              |
| `advancedConfiguration`                      | Configuration file content: advanced configuration                                                                                                                      | `""`                                              |
| `advancedConfigurationExistingSecret`        | Existing secret with the advanced configuration file (must contain a key `advanced.config`).                                                                            | `""`                                              |
| `featureFlags`                               | that controls what features are considered to be enabled or available on all cluster nodes.                                                                             | `""`                                              |
| `ldap.enabled`                               | Enable LDAP support                                                                                                                                                     | `false`                                           |
| `ldap.uri`                                   | LDAP connection string.                                                                                                                                                 | `""`                                              |
| `ldap.servers`                               | List of LDAP servers hostnames. This is valid only if ldap.uri is not set                                                                                               | `[]`                                              |
| `ldap.port`                                  | LDAP servers port. This is valid only if ldap.uri is not set                                                                                                            | `""`                                              |
| `ldap.userDnPattern`                         | Pattern used to translate the provided username into a value to be used for the LDAP bind.                                                                              | `""`                                              |
| `ldap.binddn`                                | DN of the account used to search in the LDAP server.                                                                                                                    | `""`                                              |
| `ldap.bindpw`                                | Password for binddn account.                                                                                                                                            | `""`                                              |
| `ldap.basedn`                                | Base DN path where binddn account will search for the users.                                                                                                            | `""`                                              |
| `ldap.uidField`                              | Field used to match with the user name (uid, samAccountName, cn, etc). It matches with 'dn_lookup_attribute' in RabbitMQ configuration                                  | `""`                                              |
| `ldap.uidField`                              | Field used to match with the user name (uid, samAccountName, cn, etc). It matches with 'dn_lookup_attribute' in RabbitMQ configuration                                  | `""`                                              |
| `ldap.authorisationEnabled`                  | Enable LDAP authorisation. Please set 'advancedConfiguration' with tag, topic, resources and vhost mappings                                                             | `false`                                           |
| `ldap.tls.enabled`                           | Enabled TLS configuration.                                                                                                                                              | `false`                                           |
| `ldap.tls.startTls`                          | Use STARTTLS instead of LDAPS.                                                                                                                                          | `false`                                           |
| `ldap.tls.skipVerify`                        | Skip any SSL verification (hostanames or certificates)                                                                                                                  | `false`                                           |
| `ldap.tls.verify`                            | Verify connection. Valid values are 'verify_peer' or 'verify_none'                                                                                                      | `verify_peer`                                     |
| `ldap.tls.certificatesMountPath`             | Where LDAP certifcates are mounted.                                                                                                                                     | `/opt/bitnami/rabbitmq/ldap/certs`                |
| `ldap.tls.certificatesSecret`                | Secret with LDAP certificates.                                                                                                                                          | `""`                                              |
| `ldap.tls.CAFilename`                        | CA certificate filename. Should match with the CA entry key in the ldap.tls.certificatesSecret.                                                                         | `""`                                              |
| `ldap.tls.certFilename`                      | Client certificate filename to authenticate against the LDAP server. Should match with certificate the entry key in the ldap.tls.certificatesSecret.                    | `""`                                              |
| `ldap.tls.certKeyFilename`                   | Client Key filename to authenticate against the LDAP server. Should match with certificate the entry key in the ldap.tls.certificatesSecret.                            | `""`                                              |
| `extraVolumeMounts`                          | Optionally specify extra list of additional volumeMounts                                                                                                                | `[]`                                              |
| `extraVolumes`                               | Optionally specify extra list of additional volumes .                                                                                                                   | `[]`                                              |
| `extraSecrets`                               | Optionally specify extra secrets to be created by the chart.                                                                                                            | `{}`                                              |
| `extraSecretsPrependReleaseName`             | Set this flag to true if extraSecrets should be created with <release-name> prepended.                                                                                  | `false`                                           |

### Statefulset parameters

| Name                                                | Description                                                                                                                                                                                                       | Value            |
| --------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| `replicaCount`                                      | Number of RabbitMQ replicas to deploy                                                                                                                                                                             | `1`              |
| `schedulerName`                                     | Use an alternate scheduler, e.g. "stork".                                                                                                                                                                         | `""`             |
| `podManagementPolicy`                               | Pod management policy                                                                                                                                                                                             | `OrderedReady`   |
| `podLabels`                                         | RabbitMQ Pod labels. Evaluated as a template                                                                                                                                                                      | `{}`             |
| `podAnnotations`                                    | RabbitMQ Pod annotations. Evaluated as a template                                                                                                                                                                 | `{}`             |
| `updateStrategy.type`                               | Update strategy type for RabbitMQ statefulset                                                                                                                                                                     | `RollingUpdate`  |
| `statefulsetLabels`                                 | RabbitMQ statefulset labels. Evaluated as a template                                                                                                                                                              | `{}`             |
| `statefulsetAnnotations`                            | RabbitMQ statefulset annotations. Evaluated as a template                                                                                                                                                         | `{}`             |
| `priorityClassName`                                 | Name of the priority class to be used by RabbitMQ pods, priority class needs to be created beforehand                                                                                                             | `""`             |
| `podAffinityPreset`                                 | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                               | `""`             |
| `podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                          | `soft`           |
| `nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                         | `""`             |
| `nodeAffinityPreset.key`                            | Node label key to match Ignored if `affinity` is set.                                                                                                                                                             | `""`             |
| `nodeAffinityPreset.values`                         | Node label values to match. Ignored if `affinity` is set.                                                                                                                                                         | `[]`             |
| `affinity`                                          | Affinity for pod assignment. Evaluated as a template                                                                                                                                                              | `{}`             |
| `nodeSelector`                                      | Node labels for pod assignment. Evaluated as a template                                                                                                                                                           | `{}`             |
| `tolerations`                                       | Tolerations for pod assignment. Evaluated as a template                                                                                                                                                           | `[]`             |
| `topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template                                                                                          | `[]`             |
| `podSecurityContext.enabled`                        | Enable RabbitMQ pods' Security Context                                                                                                                                                                            | `true`           |
| `podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                | `Always`         |
| `podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                    | `[]`             |
| `podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                       | `[]`             |
| `podSecurityContext.fsGroup`                        | Set RabbitMQ pod's Security Context fsGroup                                                                                                                                                                       | `1001`           |
| `containerSecurityContext.enabled`                  | Enabled RabbitMQ containers' Security Context                                                                                                                                                                     | `true`           |
| `containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                  | `nil`            |
| `containerSecurityContext.runAsUser`                | Set RabbitMQ containers' Security Context runAsUser                                                                                                                                                               | `1001`           |
| `containerSecurityContext.runAsGroup`               | Set RabbitMQ containers' Security Context runAsGroup                                                                                                                                                              | `1001`           |
| `containerSecurityContext.runAsNonRoot`             | Set RabbitMQ container's Security Context runAsNonRoot                                                                                                                                                            | `true`           |
| `containerSecurityContext.allowPrivilegeEscalation` | Set container's privilege escalation                                                                                                                                                                              | `false`          |
| `containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                           | `true`           |
| `containerSecurityContext.capabilities.drop`        | Set container's Security Context runAsNonRoot                                                                                                                                                                     | `["ALL"]`        |
| `containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                  | `RuntimeDefault` |
| `resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if resources is set (resources is recommended for production). | `micro`          |
| `resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                 | `{}`             |
| `livenessProbe.enabled`                             | Enable livenessProbe                                                                                                                                                                                              | `true`           |
| `livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                           | `120`            |
| `livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                  | `30`             |
| `livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                 | `20`             |
| `livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                               | `6`              |
| `livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                               | `1`              |
| `readinessProbe.enabled`                            | Enable readinessProbe                                                                                                                                                                                             | `true`           |
| `readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                          | `10`             |
| `readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                 | `30`             |
| `readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                | `20`             |
| `readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                              | `3`              |
| `readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                              | `1`              |
| `startupProbe.enabled`                              | Enable startupProbe                                                                                                                                                                                               | `false`          |
| `startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                            | `10`             |
| `startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                   | `30`             |
| `startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                  | `20`             |
| `startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                | `3`              |
| `startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                | `1`              |
| `customLivenessProbe`                               | Override default liveness probe                                                                                                                                                                                   | `{}`             |
| `customReadinessProbe`                              | Override default readiness probe                                                                                                                                                                                  | `{}`             |
| `customStartupProbe`                                | Define a custom startup probe                                                                                                                                                                                     | `{}`             |
| `initContainers`                                    | Add init containers to the RabbitMQ pod                                                                                                                                                                           | `[]`             |
| `sidecars`                                          | Add sidecar containers to the RabbitMQ pod                                                                                                                                                                        | `[]`             |
| `pdb.create`                                        | Enable/disable a Pod Disruption Budget creation                                                                                                                                                                   | `false`          |
| `pdb.minAvailable`                                  | Minimum number/percentage of pods that should remain scheduled                                                                                                                                                    | `1`              |
| `pdb.maxUnavailable`                                | Maximum number/percentage of pods that may be made unavailable                                                                                                                                                    | `""`             |

### RBAC parameters

| Name                                          | Description                                                                                | Value   |
| --------------------------------------------- | ------------------------------------------------------------------------------------------ | ------- |
| `serviceAccount.create`                       | Enable creation of ServiceAccount for RabbitMQ pods                                        | `true`  |
| `serviceAccount.name`                         | Name of the created serviceAccount                                                         | `""`    |
| `serviceAccount.automountServiceAccountToken` | Auto-mount the service account token in the pod                                            | `false` |
| `serviceAccount.annotations`                  | Annotations for service account. Evaluated as a template. Only used if `create` is `true`. | `{}`    |
| `rbac.create`                                 | Whether RBAC rules should be created                                                       | `true`  |
| `rbac.rules`                                  | Custom RBAC rules                                                                          | `[]`    |

### Persistence parameters

| Name                                               | Description                                                                    | Value                                    |
| -------------------------------------------------- | ------------------------------------------------------------------------------ | ---------------------------------------- |
| `persistence.enabled`                              | Enable RabbitMQ data persistence using PVC                                     | `true`                                   |
| `persistence.storageClass`                         | PVC Storage Class for RabbitMQ data volume                                     | `""`                                     |
| `persistence.selector`                             | Selector to match an existing Persistent Volume                                | `{}`                                     |
| `persistence.accessModes`                          | PVC Access Modes for RabbitMQ data volume                                      | `["ReadWriteOnce"]`                      |
| `persistence.existingClaim`                        | Provide an existing PersistentVolumeClaims                                     | `""`                                     |
| `persistence.mountPath`                            | The path the volume will be mounted at                                         | `/opt/bitnami/rabbitmq/.rabbitmq/mnesia` |
| `persistence.subPath`                              | The subdirectory of the volume to mount to                                     | `""`                                     |
| `persistence.size`                                 | PVC Storage Request for RabbitMQ data volume                                   | `8Gi`                                    |
| `persistence.annotations`                          | Persistence annotations. Evaluated as a template                               | `{}`                                     |
| `persistence.labels`                               | Persistence labels. Evaluated as a template                                    | `{}`                                     |
| `persistentVolumeClaimRetentionPolicy.enabled`     | Enable Persistent volume retention policy for rabbitmq Statefulset             | `false`                                  |
| `persistentVolumeClaimRetentionPolicy.whenScaled`  | Volume retention behavior when the replica count of the StatefulSet is reduced | `Retain`                                 |
| `persistentVolumeClaimRetentionPolicy.whenDeleted` | Volume retention behavior that applies when the StatefulSet is deleted         | `Retain`                                 |

### Exposure parameters

| Name                                    | Description                                                                                                                      | Value                    |
| --------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `service.type`                          | Kubernetes Service type                                                                                                          | `ClusterIP`              |
| `service.portEnabled`                   | Amqp port. Cannot be disabled when `auth.tls.enabled` is `false`. Listener can be disabled with `listeners.tcp = none`.          | `true`                   |
| `service.distPortEnabled`               | Erlang distribution server port                                                                                                  | `true`                   |
| `service.managerPortEnabled`            | RabbitMQ Manager port                                                                                                            | `true`                   |
| `service.epmdPortEnabled`               | RabbitMQ EPMD Discovery service port                                                                                             | `true`                   |
| `service.ports.amqp`                    | Amqp service port                                                                                                                | `5672`                   |
| `service.ports.amqpTls`                 | Amqp TLS service port                                                                                                            | `5671`                   |
| `service.ports.dist`                    | Erlang distribution service port                                                                                                 | `25672`                  |
| `service.ports.manager`                 | RabbitMQ Manager service port                                                                                                    | `15672`                  |
| `service.ports.metrics`                 | RabbitMQ Prometheues metrics service port                                                                                        | `9419`                   |
| `service.ports.epmd`                    | EPMD Discovery service port                                                                                                      | `4369`                   |
| `service.portNames.amqp`                | Amqp service port name                                                                                                           | `amqp`                   |
| `service.portNames.amqpTls`             | Amqp TLS service port name                                                                                                       | `amqp-tls`               |
| `service.portNames.dist`                | Erlang distribution service port name                                                                                            | `dist`                   |
| `service.portNames.manager`             | RabbitMQ Manager service port name                                                                                               | `http-stats`             |
| `service.portNames.metrics`             | RabbitMQ Prometheues metrics service port name                                                                                   | `metrics`                |
| `service.portNames.epmd`                | EPMD Discovery service port name                                                                                                 | `epmd`                   |
| `service.nodePorts.amqp`                | Node port for Ampq                                                                                                               | `""`                     |
| `service.nodePorts.amqpTls`             | Node port for Ampq TLS                                                                                                           | `""`                     |
| `service.nodePorts.dist`                | Node port for Erlang distribution                                                                                                | `""`                     |
| `service.nodePorts.manager`             | Node port for RabbitMQ Manager                                                                                                   | `""`                     |
| `service.nodePorts.epmd`                | Node port for EPMD Discovery                                                                                                     | `""`                     |
| `service.nodePorts.metrics`             | Node port for RabbitMQ Prometheues metrics                                                                                       | `""`                     |
| `service.extraPorts`                    | Extra ports to expose in the service                                                                                             | `[]`                     |
| `service.loadBalancerSourceRanges`      | Address(es) that are allowed when service is `LoadBalancer`                                                                      | `[]`                     |
| `service.allocateLoadBalancerNodePorts` | Whether to allocate node ports when service type is LoadBalancer                                                                 | `true`                   |
| `service.externalIPs`                   | Set the ExternalIPs                                                                                                              | `[]`                     |
| `service.externalTrafficPolicy`         | Enable client source IP preservation                                                                                             | `Cluster`                |
| `service.loadBalancerClass`             | Set the LoadBalancerClass                                                                                                        | `""`                     |
| `service.loadBalancerIP`                | Set the LoadBalancerIP                                                                                                           | `""`                     |
| `service.clusterIP`                     | Kubernetes service Cluster IP                                                                                                    | `""`                     |
| `service.labels`                        | Service labels. Evaluated as a template                                                                                          | `{}`                     |
| `service.annotations`                   | Service annotations. Evaluated as a template                                                                                     | `{}`                     |
| `service.annotationsHeadless`           | Headless Service annotations. Evaluated as a template                                                                            | `{}`                     |
| `service.headless.annotations`          | Annotations for the headless service.                                                                                            | `{}`                     |
| `service.sessionAffinity`               | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                                                             | `None`                   |
| `service.sessionAffinityConfig`         | Additional settings for the sessionAffinity                                                                                      | `{}`                     |
| `ingress.enabled`                       | Enable ingress resource for Management console                                                                                   | `false`                  |
| `ingress.path`                          | Path for the default host. You may need to set this to '/*' in order to use this with ALB ingress controllers.                   | `/`                      |
| `ingress.pathType`                      | Ingress path type                                                                                                                | `ImplementationSpecific` |
| `ingress.hostname`                      | Default host for the ingress resource                                                                                            | `rabbitmq.local`         |
| `ingress.annotations`                   | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                     |
| `ingress.tls`                           | Enable TLS configuration for the hostname defined at `ingress.hostname` parameter                                                | `false`                  |
| `ingress.selfSigned`                    | Set this to true in order to create a TLS secret for this ingress record                                                         | `false`                  |
| `ingress.extraHosts`                    | The list of additional hostnames to be covered with this ingress record.                                                         | `[]`                     |
| `ingress.extraPaths`                    | An array with additional arbitrary paths that may need to be added to the ingress under the main host                            | `[]`                     |
| `ingress.extraRules`                    | The list of additional rules to be added to this ingress record. Evaluated as a template                                         | `[]`                     |
| `ingress.extraTls`                      | The tls configuration for additional hostnames to be covered with this ingress record.                                           | `[]`                     |
| `ingress.secrets`                       | Custom TLS certificates as secrets                                                                                               | `[]`                     |
| `ingress.ingressClassName`              | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                    | `""`                     |
| `ingress.existingSecret`                | It is you own the certificate as secret.                                                                                         | `""`                     |
| `networkPolicy.enabled`                 | Specifies whether a NetworkPolicy should be created                                                                              | `true`                   |
| `networkPolicy.kubeAPIServerPorts`      | List of possible endpoints to kube-apiserver (limit to your cluster settings to increase security)                               | `[]`                     |
| `networkPolicy.allowExternal`           | Don't require server label for connections                                                                                       | `true`                   |
| `networkPolicy.allowExternalEgress`     | Allow the pod to access any range of port and all destinations.                                                                  | `true`                   |
| `networkPolicy.extraIngress`            | Add extra ingress rules to the NetworkPolicy                                                                                     | `[]`                     |
| `networkPolicy.extraEgress`             | Add extra ingress rules to the NetworkPolicy                                                                                     | `[]`                     |
| `networkPolicy.ingressNSMatchLabels`    | Labels to match to allow traffic from other namespaces                                                                           | `{}`                     |
| `networkPolicy.ingressNSPodMatchLabels` | Pod labels to match to allow traffic from other namespaces                                                                       | `{}`                     |

### Metrics Parameters

| Name                                       | Description                                                                            | Value                 |
| ------------------------------------------ | -------------------------------------------------------------------------------------- | --------------------- |
| `metrics.enabled`                          | Enable exposing RabbitMQ metrics to be gathered by Prometheus                          | `false`               |
| `metrics.plugins`                          | Plugins to enable Prometheus metrics in RabbitMQ                                       | `rabbitmq_prometheus` |
| `metrics.podAnnotations`                   | Annotations for enabling prometheus to access the metrics endpoint                     | `{}`                  |
| `metrics.serviceMonitor.enabled`           | Create ServiceMonitor Resource for scraping metrics using PrometheusOperator           | `false`               |
| `metrics.serviceMonitor.namespace`         | Specify the namespace in which the serviceMonitor resource will be created             | `""`                  |
| `metrics.serviceMonitor.interval`          | Specify the interval at which metrics should be scraped                                | `30s`                 |
| `metrics.serviceMonitor.scrapeTimeout`     | Specify the timeout after which the scrape is ended                                    | `""`                  |
| `metrics.serviceMonitor.jobLabel`          | The name of the label on the target service to use as the job name in prometheus.      | `""`                  |
| `metrics.serviceMonitor.relabelings`       | RelabelConfigs to apply to samples before scraping.                                    | `[]`                  |
| `metrics.serviceMonitor.metricRelabelings` | MetricsRelabelConfigs to apply to samples before ingestion.                            | `[]`                  |
| `metrics.serviceMonitor.honorLabels`       | honorLabels chooses the metric's labels on collisions with target labels               | `false`               |
| `metrics.serviceMonitor.targetLabels`      | Used to keep given service's labels in target                                          | `{}`                  |
| `metrics.serviceMonitor.podTargetLabels`   | Used to keep given pod's labels in target                                              | `{}`                  |
| `metrics.serviceMonitor.path`              | Define the path used by ServiceMonitor to scrap metrics                                | `""`                  |
| `metrics.serviceMonitor.params`            | Define the HTTP URL parameters used by ServiceMonitor                                  | `{}`                  |
| `metrics.serviceMonitor.selector`          | ServiceMonitor selector labels                                                         | `{}`                  |
| `metrics.serviceMonitor.labels`            | Extra labels for the ServiceMonitor                                                    | `{}`                  |
| `metrics.serviceMonitor.annotations`       | Extra annotations for the ServiceMonitor                                               | `{}`                  |
| `metrics.prometheusRule.enabled`           | Set this to true to create prometheusRules for Prometheus operator                     | `false`               |
| `metrics.prometheusRule.additionalLabels`  | Additional labels that can be used so prometheusRules will be discovered by Prometheus | `{}`                  |
| `metrics.prometheusRule.namespace`         | namespace where prometheusRules resource should be created                             | `""`                  |
| `metrics.prometheusRule.rules`             | List of rules, used as template by Helm.                                               | `[]`                  |

### Init Container Parameters

| Name                                                        | Description                                                                                                                                                                                                                                           | Value                      |
| ----------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------- |
| `volumePermissions.enabled`                                 | Enable init container that changes the owner and group of the persistent volume(s) mountpoint to `runAsUser:fsGroup`                                                                                                                                  | `false`                    |
| `volumePermissions.image.registry`                          | Init container volume-permissions image registry                                                                                                                                                                                                      | `REGISTRY_NAME`            |
| `volumePermissions.image.repository`                        | Init container volume-permissions image repository                                                                                                                                                                                                    | `REPOSITORY_NAME/os-shell` |
| `volumePermissions.image.digest`                            | Init container volume-permissions image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                     | `""`                       |
| `volumePermissions.image.pullPolicy`                        | Init container volume-permissions image pull policy                                                                                                                                                                                                   | `IfNotPresent`             |
| `volumePermissions.image.pullSecrets`                       | Specify docker-registry secret names as an array                                                                                                                                                                                                      | `[]`                       |
| `volumePermissions.resourcesPreset`                         | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if volumePermissions.resources is set (volumePermissions.resources is recommended for production). | `nano`                     |
| `volumePermissions.resources`                               | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                                     | `{}`                       |
| `volumePermissions.containerSecurityContext.seLinuxOptions` | Set SELinux options in container                                                                                                                                                                                                                      | `nil`                      |
| `volumePermissions.containerSecurityContext.runAsUser`      | User ID for the init container                                                                                                                                                                                                                        | `0`                        |

The above parameters map to the env variables defined in [bitnami/rabbitmq](https://github.com/bitnami/containers/tree/main/bitnami/rabbitmq). For more information please refer to the [bitnami/rabbitmq](https://github.com/bitnami/containers/tree/main/bitnami/rabbitmq) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
  --set auth.username=admin,auth.password=secretpassword,auth.erlangCookie=secretcookie \
    oci://REGISTRY_NAME/REPOSITORY_NAME/rabbitmq
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The above command sets the RabbitMQ admin username and password to `admin` and `secretpassword` respectively. Additionally the secure erlang cookie is set to `secretcookie`.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml oci://REGISTRY_NAME/REPOSITORY_NAME/rabbitmq
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.
> **Tip**: You can use the default [values.yaml](https://github.com/bitnami/charts/tree/main/bitnami/rabbitmq/values.yaml)

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

It's necessary to set the `auth.password` and `auth.erlangCookie` parameters when upgrading for readiness/liveness probes to work properly. When you install this chart for the first time, some notes will be displayed providing the credentials you must use under the 'Credentials' section. Please note down the password and the cookie, and run the command below to upgrade your chart:

```console
helm upgrade my-release oci://REGISTRY_NAME/REPOSITORY_NAME/rabbitmq --set auth.password=[PASSWORD] --set auth.erlangCookie=[RABBITMQ_ERLANG_COOKIE]
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

| Note: you need to substitute the placeholders [PASSWORD] and [RABBITMQ_ERLANG_COOKIE] with the values obtained in the installation notes.

### To 14.0.0

This major version changes the default RabbitMQ image from 3.12.x to 3.13.x. Follow the [official instructions](https://www.rabbitmq.com/upgrade.html) to upgrade from 3.12 to 3.13.

### To 13.0.0

This major bump changes the following security defaults:

- `runAsGroup` is changed from `0` to `1001`
- `readOnlyRootFilesystem` is set to `true`
- `resourcesPreset` is changed from `none` to the minimum size working in our test suites (NOTE: `resourcesPreset` is not meant for production usage, but `resources` adapted to your use case).
- `global.compatibility.openshift.adaptSecurityContext` is changed from `disabled` to `auto`.

This could potentially break any customization or init scripts used in your deployment. If this is the case, change the default values to the previous ones.

### To 12.10.0

This version adds NetworkPolicy objects by default. Its default configuration is setting open `egress` (this can be changed by setting `networkPolicy.allowExternalEgress=false`) and limited `ingress` to the default container ports. If you have any extra port exposed you may need to set the `networkPolicy.extraIngress` value. In the example below an extra port is exposed using `extraContainerPorts` and access is allowed using `networkPolicy.extraIngress`:

```yaml
  extraContainerPorts:
    - name: "mqtts"
      protocol: "TCP"
      containerPort: 8883
  networkPolicy:
    extraIngress:
      - ports:
          - protocol: "TCP"
            containerPort: 8883
            port: 8883
```

You can revert this behavior by setting `networkPolicy.enabled=false`.

### To 11.0.0

This major version changes the default RabbitMQ image from 3.10.x to 3.11.x. Follow the [official instructions](https://www.rabbitmq.com/upgrade.html) to upgrade from 3.10 to 3.11.

### To 10.0.0

This major version changes the default RabbitMQ image from 3.9.x to 3.10.x. Follow the [official instructions](https://www.rabbitmq.com/upgrade.html) to upgrade from 3.9 to 3.10.

### To 9.0.0

This major release renames several values in this chart and adds missing features, in order to be aligned with the rest of the assets in the Bitnami charts repository.

  .dist
  .manager
  .metrics
  .epmd

- `service.port` has been renamed as `service.ports.amqp`.
- `service.portName` has been renamed as `service.portNames.amqp`.
- `service.nodePort`has been renamed as `service.nodePorts.amqp`.
- `service.tlsPort` has been renamed as `service.ports.amqpTls`.
- `service.tlsPortName` has been renamed as `service.portNames.amqpTls`.
- `service.tlsNodePort` has been renamed as `service.nodePorts.amqpTls`.
- `service.epmdPortName` has been renamed as `service.portNames.epmd`.
- `service.epmdNodePort` has been renamed as `service.nodePorts.epmd`.
- `service.distPort` has been renamed as `service.ports.dist`.
- `service.distPortName` has been renamed as `service.portNames.dist`.
- `service.distNodePort` has been renamed as `service.nodePorts.dist`.
- `service.managerPort` has been renamed as `service.ports.manager`.
- `service.managerPortName` has been renamed as `service.portNames.manager`.
- `service.managerNodePort` has been renamed as `service.nodePorts.manager`.
- `service.metricsPort` has been renamed as `service.ports.metrics`.
- `service.metricsPortName` has been renamed as `service.portNames.metrics`.
- `service.metricsNodePort` has been renamed as `service.nodePorts.metrics`.
- `persistence.volumes` has been removed, as it duplicates the parameter `extraVolumes`.
- `ingress.certManager` has been removed.
- `metrics.serviceMonitor.relabellings` has been replaced with `metrics.serviceMonitor.relabelings`, and it sets the field `relabelings` instead of `metricRelabelings`.
- `metrics.serviceMonitor.additionalLabels` has been renamed as `metrics.serviceMonitor.labels`
- `updateStrategyType` has been removed, use the field `updateStrategy` instead, which is interpreted as a template.
- The content of `podSecurityContext` and `containerSecurityContext` have been modified.
- The behavior of VolumePermissions has been modified to not change ownership of '.snapshot' and 'lost+found'
- Introduced the values `ContainerPorts.*`, separating the service and container ports configuration.

### To 8.21.0

This new version of the chart bumps the RabbitMQ version to `3.9.1`. It is considered a minor release, and no breaking changes are expected. Additionally, RabbitMQ `3.9.X` nodes can run alongside `3.8.X` nodes.

See the [Upgrading guide](https://www.rabbitmq.com/upgrade.html) and the [RabbitMQ change log](https://www.rabbitmq.com/changelog.html) for further documentation.

### To 8.0.0

[On November 13, 2020, Helm v2 support was formally finished](https://github.com/helm/charts#status-of-the-project), this major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

### To 7.0.0

- Several parameters were renamed or disappeared in favor of new ones on this major version:
  - `replicas` is renamed to `replicaCount`.
  - `securityContext.*` is deprecated in favor of `podSecurityContext` and `containerSecurityContext`.
  - Authentication parameters were reorganized under the `auth.*` parameter:
    - `rabbitmq.username`, `rabbitmq.password`, and `rabbitmq.erlangCookie` are now `auth.username`, `auth.password`, and `auth.erlangCookie` respectively.
    - `rabbitmq.tls.*` parameters are now under `auth.tls.*`.
  - Parameters prefixed with `rabbitmq.` were renamed removing the prefix. E.g. `rabbitmq.configuration` -> renamed to `configuration`.
  - `rabbitmq.rabbitmqClusterNodeName` is deprecated.
  - `rabbitmq.setUlimitNofiles` is deprecated.
  - `forceBoot.enabled` is renamed to `clustering.forceBoot`.
  - `loadDefinition.secretName` is renamed to `loadDefinition.existingSecret`.
  - `metics.port` is remamed to `service.metricsPort`.
  - `service.extraContainerPorts` is renamed to `extraContainerPorts`.
  - `service.nodeTlsPort` is renamed to `service.tlsNodePort`.
  - `podDisruptionBudget` is deprecated in favor of `pdb.create`, `pdb.minAvailable`, and `pdb.maxUnavailable`.
  - `rbacEnabled` -> deprecated in favor of `rbac.create`.
  - New parameters: `serviceAccount.create`, and `serviceAccount.name`.
  - New parameters: `memoryHighWatermark.enabled`, `memoryHighWatermark.type`, and `memoryHighWatermark.value`.
- Chart labels and Ingress configuration were adapted to follow the Helm charts best practices.
- Initialization logic now relies on the container.
- This version introduces `bitnami/common`, a [library chart](https://helm.sh/docs/topics/library_charts/#helm) as a dependency. More documentation about this new utility could be found [here](https://github.com/bitnami/charts/tree/main/bitnami/common#bitnami-common-library-chart). Please, make sure that you have updated the chart dependencies before executing any upgrade.
- The layout of the persistent volumes has changed (if using persistence). Action is required if preserving data through the upgrade is desired:
  - The data has moved from `mnesia/` within the persistent volume to the root of the persistent volume
  - The `config/` and `schema/` directories within the persistent volume are no longer used
  - An init container can be used to move and clean up the peristent volumes. An example can be found [here](https://github.com/bitnami/charts/issues/10913#issuecomment-1169619513).
  - Alternately the value `persistence.subPath` can be overridden to be `mnesia` so that the directory layout is consistent with what it was previously.
    - Note however that this will leave the unused `config/` and `schema/` directories within the peristent volume forever.

Consequences:

- Backwards compatibility is not guaranteed.
- Compatibility with non Bitnami images is not guaranteed anymore.

### To 6.0.0

This new version updates the RabbitMQ image to a [new version based on bash instead of node.js](https://github.com/bitnami/containers/tree/main/bitnami/rabbitmq#3715-r18-3715-ol-7-r19). However, since this Chart overwrites the container's command, the changes to the container shouldn't affect the Chart. To upgrade, it may be needed to enable the `fastBoot` option, as it is already the case from upgrading from 5.X to 5.Y.

### To 5.0.0

This major release changes the clustering method from `ip` to `hostname`.
This change is needed to fix the persistence. The data dir will now depend on the hostname which is stable instead of the pod IP that might change.

> IMPORTANT: Note that if you upgrade from a previous version you will lose your data.

### To 3.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 3.0.0. The following example assumes that the release name is rabbitmq:

```console
kubectl delete statefulset rabbitmq --cascade=false
```

## Bitnami Kubernetes Documentation

Bitnami Kubernetes documentation is available at [https://docs.bitnami.com/](https://docs.bitnami.com/). You can find there the following resources:

- [Documentation for RabbitMQ Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/rabbitmq)
- [Get Started with Kubernetes guides](https://docs.bitnami.com/kubernetes/)
- [Kubernetes FAQs](https://docs.bitnami.com/kubernetes/faq/)
- [Kubernetes Developer guides](https://docs.vmware.com/en/VMware-Tanzu-Application-Catalog/services/tutorials/GUID-index.html)

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
