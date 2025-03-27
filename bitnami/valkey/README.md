<!--- app-name: Valkey -->

# Bitnami package for Valkey

Valkey is an open source (BSD) high-performance key/value datastore that supports a variety workloads such as caching, message queues, and can act as a primary database.

[Overview of Valkey](https://valkey.io/)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/valkey
```

Looking to use Valkey in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the commercial edition of the Bitnami catalog.

## Introduction

This chart bootstraps a [Valkey](https://github.com/bitnami/containers/tree/main/bitnami/valkey) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/valkey
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The command deploys Valkey on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Configuration and installation details

### Resource requests and limits

Bitnami charts allow setting resource requests and limits for all containers inside the chart deployment. These are inside the `resources` value (check parameter table). Setting requests is essential for production workloads and these should be adapted to your specific use case.

To make this process easier, the chart contains the `resourcesPreset` values, which automatically sets the `resources` section according to different presets. Check these presets in [the bitnami/common chart](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15). However, in production workloads using `resourcesPreset` is discouraged as it may not fully adapt to your specific needs. Find more information on container resource management in the [official Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).

### Update credentials

The Bitnami Valkey chart, when upgrading, reuses the secret previously rendered by the chart or the one specified in `auth.existingSecret`. To update credentials, use one of the following:

- Run `helm upgrade` specifying a new password in `auth.password`
- Run `helm upgrade` specifying a new secret in `auth.existingSecret`

### Prometheus metrics

This chart can be integrated with Prometheus by setting `metrics.enabled` to `true`. This will deploy a sidecar container with [redis_exporter](https://github.com/oliver006/redis_exporter) in all pods and a `metrics` service, which can be configured under the `metrics.service` section. This `metrics` service will have the necessary annotations to be automatically scraped by Prometheus.

#### Prometheus requirements

It is necessary to have a working installation of Prometheus or Prometheus Operator for the integration to work. Install the [Bitnami Prometheus helm chart](https://github.com/bitnami/charts/tree/main/bitnami/prometheus) or the [Bitnami Kube Prometheus helm chart](https://github.com/bitnami/charts/tree/main/bitnami/kube-prometheus) to easily have a working Prometheus in your cluster.

#### Integration with Prometheus Operator

The chart can deploy `ServiceMonitor` objects for integration with Prometheus Operator installations. To do so, set the value `metrics.serviceMonitor.enabled=true`. Ensure that the Prometheus Operator `CustomResourceDefinitions` are installed in the cluster or it will fail with the following error:

```text
no matches for kind "ServiceMonitor" in version "monitoring.coreos.com/v1"
```

Install the [Bitnami Kube Prometheus helm chart](https://github.com/bitnami/charts/tree/main/bitnami/kube-prometheus) for having the necessary CRDs and the Prometheus Operator.

### [Rolling VS Immutable tags](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Use a different Valkey version

To modify the application version used in this chart, specify a different version of the image using the `image.tag` parameter and/or a different repository using the `image.repository` parameter.

### Bootstrapping with an External Cluster

This chart is equipped with the ability to bring online a set of Pods that connect to an existing Valkey deployment that lies outside of Kubernetes.  This effectively creates a hybrid Valkey Deployment where both Pods in Kubernetes and Instances such as Virtual Machines can partake in a single Valkey Deployment. This is helpful in situations where one may be migrating Valkey from Virtual Machines into Kubernetes, for example.  To take advantage of this, use the following as an example configuration:

```yaml
replica:
  externalPrimary:
    enabled: true
    host: external-valkey-0.internal
sentinel:
  externalPrimary:
    enabled: true
    host: external-valkey-0.internal
```

:warning: This is currently limited to clusters in which Sentinel and Valkey run on the same node! :warning:

Please also note that the external sentinel must be listening on port `26379`, and this is currently not configurable.

Once the Kubernetes Valkey Deployment is online and confirmed to be working with the existing cluster, the configuration can then be removed and the cluster will remain connected.

### External DNS

This chart is equipped to allow leveraging the ExternalDNS project. Doing so will enable ExternalDNS to publish the FQDN for each instance, in the format of `<pod-name>.<release-name>.<dns-suffix>`.
Example, when using the following configuration:

```yaml
useExternalDNS:
  enabled: true
  suffix: prod.example.org
  additionalAnnotations:
    ttl: 10
```

On a cluster where the name of the Helm release is `a`, the hostname of a Pod is generated as: `a-valkey-node-0.a-valkey.prod.example.org`. The IP of that FQDN will match that of the associated Pod. This modifies the following parameters of the Valkey/Sentinel configuration using this new FQDN:

- `replica-announce-ip`
- `known-sentinel`
- `known-replica`
- `announce-ip`

:warning: This requires a working installation of `external-dns` to be fully functional. :warning:

See the [official ExternalDNS documentation](https://github.com/kubernetes-sigs/external-dns) for additional configuration options.

### Cluster topologies

#### Default: Primary-Replicas

When installing the chart with `architecture=replication`, it will deploy a Valkey primary StatefulSet and a Valkey replicas StatefulSet. The replicas will be read-replicas of the primary. Two services will be exposed:

- Valkey Primary service: Points to the primary, where read-write operations can be performed
- Valkey Replicas service: Points to the replicas, where only read operations are allowed by default.

In case the primary crashes, the replicas will wait until the primary node is respawned again by the Kubernetes Controller Manager.

#### Standalone

When installing the chart with `architecture=standalone`, it will deploy a standalone Valkey StatefulSet. A single service will be exposed:

- Valkey Primary service: Points to the primary, where read-write operations can be performed

#### Primary-Replicas with Sentinel

When installing the chart with `architecture=replication` and `sentinel.enabled=true`, it will deploy a Valkey primary StatefulSet (only one primary allowed) and a Valkey replicas StatefulSet. In this case, the pods will contain an extra container with Valkey Sentinel. This container will form a cluster of Valkey Sentinel nodes, which will promote a new primary in case the actual one fails.

On graceful termination of the Valkey primary pod, a failover of the primary is initiated to promote a new primary. The Valkey Sentinel container in this pod will wait for the failover to occur before terminating. If `sentinel.valkeyShutdownWaitFailover=true` is set (the default), the Valkey container will wait for the failover as well before terminating. This increases availability for reads during failover, but may cause stale reads until all clients have switched to the new primary.

In addition to this, only one service is exposed:

- Valkey service: Exposes port 6379 for Valkey read-only operations and port 26379 for accessing Valkey Sentinel.

For read-only operations, access the service using port 6379. For write operations, it's necessary to access the Valkey Sentinel cluster and query the current primary using the command below (using valkey-cli or similar):

```console
SENTINEL get-primary-addr-by-name <name of your PrimarySet. e.g: myprimary>
```

This command will return the address of the current primary, which can be accessed from inside the cluster.

In case the current primary crashes, the Sentinel containers will elect a new primary node.

`primary.replicaCount` greater than `1` is not designed for use when `sentinel.enabled=true`.

### Multiple primary nodes (experimental)

When `primary.replicaCount` is greater than `1`, special care must be taken to create a consistent setup.

An example of use case is the creation of a redundant set of standalone primary nodes or primary-replicas per Kubernetes node where you must ensure:

- No more than `1` primary can be deployed per Kubernetes node
- Replicas and writers can only see the single primary of their own Kubernetes node

One way of achieving this is by setting `primary.service.internalTrafficPolicy=Local` in combination with a `primary.affinity.podAntiAffinity` spec to never schedule more than one primary per Kubernetes node.

It's recommended to only change `primary.replicaCount` if you know what you are doing.
`primary.replicaCount` greater than `1` is not designed for use when `sentinel.enabled=true`.

### Using a password file

To use a password file for Valkey you need to create a secret containing the password and then deploy the chart using that secret. Follow these instructions:

- Create the secret with the password. It is important that the file with the password must be called `valkey-password`.

```console
kubectl create secret generic valkey-password-secret --from-file=valkey-password.yaml
```

- Deploy the Helm Chart using the secret name as parameter:

```text
usePassword=true
usePasswordFile=true
existingSecret=valkey-password-secret
sentinels.enabled=true
metrics.enabled=true
```

### Securing traffic using TLS

TLS support can be enabled in the chart by specifying the `tls.` parameters while creating a release. The following parameters should be configured to properly enable the TLS support in the cluster:

- `tls.enabled`: Enable TLS support. Defaults to `false`
- `tls.existingSecret`: Name of the secret that contains the certificates. No defaults.
- `tls.certFilename`: Certificate filename. No defaults.
- `tls.certKeyFilename`: Certificate key filename. No defaults.
- `tls.certCAFilename`: CA Certificate filename. No defaults.

For example:

First, create the secret with the certificates files:

```console
kubectl create secret generic certificates-tls-secret --from-file=./cert.pem --from-file=./cert.key --from-file=./ca.pem
```

Then, use the following parameters:

```console
tls.enabled="true"
tls.existingSecret="certificates-tls-secret"
tls.certFilename="cert.pem"
tls.certKeyFilename="cert.key"
tls.certCAFilename="ca.pem"
```

### Metrics

The chart optionally can start a metrics exporter for [prometheus](https://prometheus.io). The metrics endpoint (port 9121) is exposed in the service. Metrics can be scraped from within the cluster using something similar as the described in the [example Prometheus scrape configuration](https://github.com/prometheus/prometheus/blob/master/documentation/examples/prometheus-kubernetes.yml). If metrics are to be scraped from outside the cluster, the Kubernetes API proxy can be utilized to access the endpoint.

If you have enabled TLS by specifying `tls.enabled=true` you also need to specify TLS option to the metrics exporter. You can do that via `metrics.extraArgs`. You can find the metrics exporter CLI flags for TLS [here](https://github.com/oliver006/valkey_exporter#command-line-flags). For example:

You can either specify `metrics.extraArgs.skip-tls-verification=true` to skip TLS verification or providing the following values under `metrics.extraArgs` for TLS client authentication:

```console
tls-client-key-file
tls-client-cert-file
tls-ca-cert-file
```

### Deploy a custom metrics script in the sidecar

A custom Lua script can be added to the `redis-exporter` sidecar by way of the `metrics.extraArgs.script` parameter.  The pathname of the script must exist on the container, or the `redis_exporter` process (and therefore the whole pod) will refuse to start.  The script can be provided to the sidecar containers via the `metrics.extraVolumes` and `metrics.extraVolumeMounts` parameters:

```yaml
metrics:
  extraVolumeMounts:
    - name: '{{ printf "%s-metrics-script-file" (include "common.names.fullname" .) }}'
      mountPath: '{{ printf "/mnt/%s/" (include "common.names.name" .) }}'
      readOnly: true
  extraVolumes:
    - name: '{{ printf "%s-metrics-script-file" (include "common.names.fullname" .) }}'
      configMap:
        name: '{{ printf "%s-metrics-script" (include "common.names.fullname" .) }}'
  extraArgs:
    script: '{{ printf "/mnt/%s/my_custom_metrics.lua" (include "common.names.name" .) }}'
```

Then deploy the script into the correct location via `extraDeploy`:

```yaml
extraDeploy:
  - apiVersion: v1
    kind: ConfigMap
    metadata:
      name: '{{ printf "%s-metrics-script" (include "common.names.fullname" .) }}'
    data:
      my_custom_metrics.lua: |
        -- LUA SCRIPT CODE HERE, e.g.,
        return {'bitnami_makes_the_best_charts', '1'}
```

### Host Kernel Settings

Valkey may require some changes in the kernel of the host machine to work as expected, in particular increasing the `somaxconn` value and disabling transparent huge pages. To do so, you can set `securityContext.sysctls` which will configure `sysctls` for primary and replica pods. Example:

```yaml
securityContext:
  sysctls:
  - name: net.core.somaxconn
    value: "10000"
```

Note that this will not disable transparent huge tables.

### Backup and restore

To backup and restore Valkey deployments on Kubernetes, you will need to create a snapshot of the data in the source cluster, and later restore it in a new cluster with the new parameters. Follow the instructions below:

#### Step 1: Backup the deployment

- Connect to one of the nodes and start the Valkey CLI tool. Then, run the commands below:

    ```text
    $ kubectl exec -it my-release-primary-0 bash
    $ valkey-cli
    127.0.0.1:6379> auth your_current_valkey_password
    OK
    127.0.0.1:6379> save
    OK
    ```

- Copy the dump file from the Valkey node:

    ```console
    kubectl cp my-release-primary-0:/data/dump.rdb dump.rdb -c valkey
    ```

#### Step 2: Restore the data on the destination cluster

To restore the data in a new cluster, you will need to create a PVC and then upload the *dump.rdb* file to the new volume.

Follow the following steps:

- In the [*values.yaml*](https://github.com/bitnami/charts/blob/main/bitnami/valkey/values.yaml) file set the *appendonly* parameter to *no*. You can skip this step if it is already configured as *no*

    ```yaml
    commonConfiguration: |-
       # Enable AOF https://valkey.io/topics/persistence#append-only-file
       appendonly no
       # Disable RDB persistence, AOF persistence already enabled.
       save ""
    ```

    > *Note that the `Enable AOF` comment belongs to the original config file and what you're actually doing is disabling it. This change will only be neccessary for the temporal cluster you're creating to upload the dump.*

- Start the new cluster to create the PVCs. Use the command below as an example:

    ```console
    helm install new-valkey  -f values.yaml .  --set cluster.enabled=true  --set cluster.replicaCount=3
    ```

- Now that the PVC were created, stop it and copy the *dump.rdp* file on the persisted data by using a helping pod.

    ```text
    $ helm delete new-valkey

    $ kubectl run --generator=run-pod/v1 -i --rm --tty volpod --overrides='
    {
        "apiVersion": "v1",
        "kind": "Pod",
        "metadata": {
            "name": "valkeyvolpod"
        },
        "spec": {
            "containers": [{
               "command": [
                    "tail",
                    "-f",
                    "/dev/null"
               ],
               "image": "bitnami/os-shell",
               "name": "mycontainer",
               "volumeMounts": [{
                   "mountPath": "/mnt",
                   "name": "valkeydata"
                }]
            }],
            "restartPolicy": "Never",
            "volumes": [{
                "name": "valkeydata",
                "persistentVolumeClaim": {
                    "claimName": "valkey-data-new-valkey-primary-0"
                }
            }]
        }
    }' --image="bitnami/os-shell"

    $ kubectl cp dump.rdb valkeyvolpod:/mnt/dump.rdb
    $ kubectl delete pod volpod
    ```

- Restart the cluster:

    > **INFO:** The *appendonly* parameter can be safely restored to your desired value.

    ```console
    helm install new-valkey  -f values.yaml .  --set cluster.enabled=true  --set cluster.replicaCount=3
    ```

### NetworkPolicy

To enable network policy for Valkey, install [a networking plugin that implements the Kubernetes NetworkPolicy spec](https://kubernetes.io/docs/tasks/administer-cluster/declare-network-policy#before-you-begin), and set `networkPolicy.enabled` to `true`.

With NetworkPolicy enabled, only pods with the generated client label will be able to connect to Valkey. This label will be displayed in the output after a successful install.

With `networkPolicy.ingressNSMatchLabels` pods from other namespaces can connect to Valkey. Set `networkPolicy.ingressNSPodMatchLabels` to match pod labels in matched namespace. For example, for a namespace labeled `valkey=external` and pods in that namespace labeled `valkey-client=true` the fields should be set:

```yaml
networkPolicy:
  enabled: true
  ingressNSMatchLabels:
    valkey: external
  ingressNSPodMatchLabels:
    valkey-client: true
```

#### Setting Pod's affinity

This chart allows you to set your custom affinity using the `XXX.affinity` parameter(s). Find more information about Pod's affinity in the [Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities) chart. To do so, set the `XXX.podAffinityPreset`, `XXX.podAntiAffinityPreset`, or `XXX.nodeAffinityPreset` parameters.

## Persistence

By default, the chart mounts a [Persistent Volume](https://kubernetes.io/docs/concepts/storage/persistent-volumes/) at the `/data` path. The volume is created using dynamic volume provisioning. If a Persistent Volume Claim already exists, specify it during installation.

### Existing PersistentVolumeClaim

1. Create the PersistentVolume
2. Create the PersistentVolumeClaim
3. Install the chart

```console
helm install my-release --set primary.persistence.existingClaim=PVC_NAME oci://REGISTRY_NAME/REPOSITORY_NAME/valkey
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

## Parameters

### Global parameters

| Name                                                  | Description                                                                                                                                                                                                                                                                                                                                                         | Value   |
| ----------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `global.imageRegistry`                                | Global Docker image registry                                                                                                                                                                                                                                                                                                                                        | `""`    |
| `global.imagePullSecrets`                             | Global Docker registry secret names as an array                                                                                                                                                                                                                                                                                                                     | `[]`    |
| `global.defaultStorageClass`                          | Global default StorageClass for Persistent Volume(s)                                                                                                                                                                                                                                                                                                                | `""`    |
| `global.storageClass`                                 | DEPRECATED: use global.defaultStorageClass instead                                                                                                                                                                                                                                                                                                                  | `""`    |
| `global.valkey.password`                              | Global Valkey password (overrides `auth.password`)                                                                                                                                                                                                                                                                                                                  | `""`    |
| `global.security.allowInsecureImages`                 | Allows skipping image verification                                                                                                                                                                                                                                                                                                                                  | `false` |
| `global.compatibility.openshift.adaptSecurityContext` | Adapt the securityContext sections of the deployment to make them compatible with Openshift restricted-v2 SCC: remove runAsUser, runAsGroup and fsGroup and let the platform use their allowed default IDs. Possible values: auto (apply if the detected running cluster is Openshift), force (perform the adaptation always), disabled (do not perform adaptation) | `auto`  |

### Common parameters

| Name                      | Description                                                                                                    | Value           |
| ------------------------- | -------------------------------------------------------------------------------------------------------------- | --------------- |
| `kubeVersion`             | Override Kubernetes version                                                                                    | `""`            |
| `apiVersions`             | Override Kubernetes API versions reported by .Capabilities                                                     | `[]`            |
| `nameOverride`            | String to partially override common.names.fullname                                                             | `""`            |
| `fullnameOverride`        | String to fully override common.names.fullname                                                                 | `""`            |
| `namespaceOverride`       | String to fully override common.names.namespace                                                                | `""`            |
| `commonLabels`            | Labels to add to all deployed objects                                                                          | `{}`            |
| `commonAnnotations`       | Annotations to add to all deployed objects                                                                     | `{}`            |
| `secretAnnotations`       | Annotations to add to secret                                                                                   | `{}`            |
| `clusterDomain`           | Kubernetes cluster domain name                                                                                 | `cluster.local` |
| `extraDeploy`             | Array of extra objects to deploy with the release                                                              | `[]`            |
| `useHostnames`            | Use hostnames internally when announcing replication. If false, the hostname will be resolved to an IP address | `true`          |
| `nameResolutionThreshold` | Failure threshold for internal hostnames resolution                                                            | `5`             |
| `nameResolutionTimeout`   | Timeout seconds between probes for internal hostnames resolution                                               | `5`             |
| `diagnosticMode.enabled`  | Enable diagnostic mode (all probes will be disabled and the command will be overridden)                        | `false`         |
| `diagnosticMode.command`  | Command to override all containers in the deployment                                                           | `["sleep"]`     |
| `diagnosticMode.args`     | Args to override all containers in the deployment                                                              | `["infinity"]`  |

### Valkey Image parameters

| Name                | Description                                                                                            | Value                    |
| ------------------- | ------------------------------------------------------------------------------------------------------ | ------------------------ |
| `image.registry`    | Valkey image registry                                                                                  | `REGISTRY_NAME`          |
| `image.repository`  | Valkey image repository                                                                                | `REPOSITORY_NAME/valkey` |
| `image.digest`      | Valkey image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag | `""`                     |
| `image.pullPolicy`  | Valkey image pull policy                                                                               | `IfNotPresent`           |
| `image.pullSecrets` | Valkey image pull secrets                                                                              | `[]`                     |
| `image.debug`       | Enable image debug mode                                                                                | `false`                  |

### Valkey common configuration parameters

| Name                             | Description                                                                       | Value         |
| -------------------------------- | --------------------------------------------------------------------------------- | ------------- |
| `architecture`                   | Valkey architecture. Allowed values: `standalone` or `replication`                | `replication` |
| `auth.enabled`                   | Enable password authentication                                                    | `true`        |
| `auth.sentinel`                  | Enable password authentication on sentinels too                                   | `true`        |
| `auth.password`                  | Valkey password                                                                   | `""`          |
| `auth.existingSecret`            | The name of an existing secret with Valkey credentials                            | `""`          |
| `auth.existingSecretPasswordKey` | Password key to be retrieved from existing secret                                 | `""`          |
| `auth.usePasswordFiles`          | Mount credentials as files instead of using an environment variable               | `true`        |
| `auth.usePasswordFileFromSecret` | Mount password file from secret                                                   | `true`        |
| `commonConfiguration`            | Common configuration to be added into the ConfigMap                               | `""`          |
| `existingConfigmap`              | The name of an existing ConfigMap with your custom configuration for Valkey nodes | `""`          |

### Valkey primary configuration parameters

| Name                                                        | Description                                                                                                                                                                                                                       | Value                    |
| ----------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `primary.replicaCount`                                      | Number of Valkey primary instances to deploy (experimental, requires additional configuration)                                                                                                                                    | `1`                      |
| `primary.configuration`                                     | Configuration for Valkey primary nodes                                                                                                                                                                                            | `""`                     |
| `primary.disableCommands`                                   | Array with Valkey commands to disable on primary nodes                                                                                                                                                                            | `["FLUSHDB","FLUSHALL"]` |
| `primary.command`                                           | Override default container command (useful when using custom images)                                                                                                                                                              | `[]`                     |
| `primary.args`                                              | Override default container args (useful when using custom images)                                                                                                                                                                 | `[]`                     |
| `primary.enableServiceLinks`                                | Whether information about services should be injected into pod's environment variable                                                                                                                                             | `true`                   |
| `primary.preExecCmds`                                       | Additional commands to run prior to starting Valkey primary                                                                                                                                                                       | `[]`                     |
| `primary.extraFlags`                                        | Array with additional command line flags for Valkey primary                                                                                                                                                                       | `[]`                     |
| `primary.extraEnvVars`                                      | Array with extra environment variables to add to Valkey primary nodes                                                                                                                                                             | `[]`                     |
| `primary.extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for Valkey primary nodes                                                                                                                                                     | `""`                     |
| `primary.extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for Valkey primary nodes                                                                                                                                                        | `""`                     |
| `primary.containerPorts.valkey`                             | Container port to open on Valkey primary nodes                                                                                                                                                                                    | `6379`                   |
| `primary.startupProbe.enabled`                              | Enable startupProbe on Valkey primary nodes                                                                                                                                                                                       | `false`                  |
| `primary.startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                                            | `20`                     |
| `primary.startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                                   | `5`                      |
| `primary.startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                                  | `5`                      |
| `primary.startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                                | `5`                      |
| `primary.startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                                | `1`                      |
| `primary.livenessProbe.enabled`                             | Enable livenessProbe on Valkey primary nodes                                                                                                                                                                                      | `true`                   |
| `primary.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                                           | `20`                     |
| `primary.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                                  | `5`                      |
| `primary.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                                 | `5`                      |
| `primary.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                                               | `5`                      |
| `primary.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                                               | `1`                      |
| `primary.readinessProbe.enabled`                            | Enable readinessProbe on Valkey primary nodes                                                                                                                                                                                     | `true`                   |
| `primary.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                                          | `20`                     |
| `primary.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                                 | `5`                      |
| `primary.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                                | `1`                      |
| `primary.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                                              | `5`                      |
| `primary.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                                              | `1`                      |
| `primary.customStartupProbe`                                | Custom startupProbe that overrides the default one                                                                                                                                                                                | `{}`                     |
| `primary.customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                                                                                                                               | `{}`                     |
| `primary.customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                                                                                                                                              | `{}`                     |
| `primary.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if primary.resources is set (primary.resources is recommended for production). | `nano`                   |
| `primary.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                 | `{}`                     |
| `primary.podSecurityContext.enabled`                        | Enabled Valkey primary pods' Security Context                                                                                                                                                                                     | `true`                   |
| `primary.podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                                | `Always`                 |
| `primary.podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                                    | `[]`                     |
| `primary.podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                                       | `[]`                     |
| `primary.podSecurityContext.fsGroup`                        | Set Valkey primary pod's Security Context fsGroup                                                                                                                                                                                 | `1001`                   |
| `primary.containerSecurityContext.enabled`                  | Enabled Valkey primary containers' Security Context                                                                                                                                                                               | `true`                   |
| `primary.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                                  | `{}`                     |
| `primary.containerSecurityContext.runAsUser`                | Set Valkey primary containers' Security Context runAsUser                                                                                                                                                                         | `1001`                   |
| `primary.containerSecurityContext.runAsGroup`               | Set Valkey primary containers' Security Context runAsGroup                                                                                                                                                                        | `1001`                   |
| `primary.containerSecurityContext.runAsNonRoot`             | Set Valkey primary containers' Security Context runAsNonRoot                                                                                                                                                                      | `true`                   |
| `primary.containerSecurityContext.allowPrivilegeEscalation` | Is it possible to escalate Valkey pod(s) privileges                                                                                                                                                                               | `false`                  |
| `primary.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context read-only root filesystem                                                                                                                                                                        | `true`                   |
| `primary.containerSecurityContext.seccompProfile.type`      | Set Valkey primary containers' Security Context seccompProfile                                                                                                                                                                    | `RuntimeDefault`         |
| `primary.containerSecurityContext.capabilities.drop`        | Set Valkey primary containers' Security Context capabilities to drop                                                                                                                                                              | `["ALL"]`                |
| `primary.kind`                                              | Use either Deployment, StatefulSet (default) or DaemonSet                                                                                                                                                                         | `StatefulSet`            |
| `primary.schedulerName`                                     | Alternate scheduler for Valkey primary pods                                                                                                                                                                                       | `""`                     |
| `primary.updateStrategy.type`                               | Valkey primary statefulset strategy type                                                                                                                                                                                          | `RollingUpdate`          |
| `primary.minReadySeconds`                                   | How many seconds a pod needs to be ready before killing the next, during update                                                                                                                                                   | `0`                      |
| `primary.priorityClassName`                                 | Valkey primary pods' priorityClassName                                                                                                                                                                                            | `""`                     |
| `primary.automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                                | `false`                  |
| `primary.hostAliases`                                       | Valkey primary pods host aliases                                                                                                                                                                                                  | `[]`                     |
| `primary.podLabels`                                         | Extra labels for Valkey primary pods                                                                                                                                                                                              | `{}`                     |
| `primary.podAnnotations`                                    | Annotations for Valkey primary pods                                                                                                                                                                                               | `{}`                     |
| `primary.shareProcessNamespace`                             | Share a single process namespace between all of the containers in Valkey primary pods                                                                                                                                             | `false`                  |
| `primary.podAffinityPreset`                                 | Pod affinity preset. Ignored if `primary.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                       | `""`                     |
| `primary.podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `primary.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                  | `soft`                   |
| `primary.nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `primary.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                 | `""`                     |
| `primary.nodeAffinityPreset.key`                            | Node label key to match. Ignored if `primary.affinity` is set                                                                                                                                                                     | `""`                     |
| `primary.nodeAffinityPreset.values`                         | Node label values to match. Ignored if `primary.affinity` is set                                                                                                                                                                  | `[]`                     |
| `primary.affinity`                                          | Affinity for Valkey primary pods assignment                                                                                                                                                                                       | `{}`                     |
| `primary.nodeSelector`                                      | Node labels for Valkey primary pods assignment                                                                                                                                                                                    | `{}`                     |
| `primary.tolerations`                                       | Tolerations for Valkey primary pods assignment                                                                                                                                                                                    | `[]`                     |
| `primary.topologySpreadConstraints`                         | Spread Constraints for Valkey primary pod assignment                                                                                                                                                                              | `[]`                     |
| `primary.dnsPolicy`                                         | DNS Policy for Valkey primary pod                                                                                                                                                                                                 | `""`                     |
| `primary.dnsConfig`                                         | DNS Configuration for Valkey primary pod                                                                                                                                                                                          | `{}`                     |
| `primary.lifecycleHooks`                                    | for the Valkey primary container(s) to automate configuration before or after startup                                                                                                                                             | `{}`                     |
| `primary.extraVolumes`                                      | Optionally specify extra list of additional volumes for the Valkey primary pod(s)                                                                                                                                                 | `[]`                     |
| `primary.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the Valkey primary container(s)                                                                                                                                      | `[]`                     |
| `primary.sidecars`                                          | Add additional sidecar containers to the Valkey primary pod(s)                                                                                                                                                                    | `[]`                     |
| `primary.initContainers`                                    | Add additional init containers to the Valkey primary pod(s)                                                                                                                                                                       | `[]`                     |
| `primary.persistence.enabled`                               | Enable persistence on Valkey primary nodes using Persistent Volume Claims                                                                                                                                                         | `true`                   |
| `primary.persistence.medium`                                | Provide a medium for `emptyDir` volumes.                                                                                                                                                                                          | `""`                     |
| `primary.persistence.sizeLimit`                             | Set this to enable a size limit for `emptyDir` volumes.                                                                                                                                                                           | `""`                     |
| `primary.persistence.path`                                  | The path the volume will be mounted at on Valkey primary containers                                                                                                                                                               | `/data`                  |
| `primary.persistence.subPath`                               | The subdirectory of the volume to mount on Valkey primary containers                                                                                                                                                              | `""`                     |
| `primary.persistence.subPathExpr`                           | Used to construct the subPath subdirectory of the volume to mount on Valkey primary containers                                                                                                                                    | `""`                     |
| `primary.persistence.storageClass`                          | Persistent Volume storage class                                                                                                                                                                                                   | `""`                     |
| `primary.persistence.accessModes`                           | Persistent Volume access modes                                                                                                                                                                                                    | `["ReadWriteOnce"]`      |
| `primary.persistence.size`                                  | Persistent Volume size                                                                                                                                                                                                            | `8Gi`                    |
| `primary.persistence.annotations`                           | Additional custom annotations for the PVC                                                                                                                                                                                         | `{}`                     |
| `primary.persistence.labels`                                | Additional custom labels for the PVC                                                                                                                                                                                              | `{}`                     |
| `primary.persistence.selector`                              | Additional labels to match for the PVC                                                                                                                                                                                            | `{}`                     |
| `primary.persistence.dataSource`                            | Custom PVC data source                                                                                                                                                                                                            | `{}`                     |
| `primary.persistence.existingClaim`                         | Use a existing PVC which must be created manually before bound                                                                                                                                                                    | `""`                     |
| `primary.persistentVolumeClaimRetentionPolicy.enabled`      | Controls if and how PVCs are deleted during the lifecycle of a StatefulSet                                                                                                                                                        | `false`                  |
| `primary.persistentVolumeClaimRetentionPolicy.whenScaled`   | Volume retention behavior when the replica count of the StatefulSet is reduced                                                                                                                                                    | `Retain`                 |
| `primary.persistentVolumeClaimRetentionPolicy.whenDeleted`  | Volume retention behavior that applies when the StatefulSet is deleted                                                                                                                                                            | `Retain`                 |
| `primary.service.type`                                      | Valkey primary service type                                                                                                                                                                                                       | `ClusterIP`              |
| `primary.service.ports.valkey`                              | Valkey primary service port                                                                                                                                                                                                       | `6379`                   |
| `primary.service.nodePorts.valkey`                          | Node port for Valkey primary                                                                                                                                                                                                      | `""`                     |
| `primary.service.externalTrafficPolicy`                     | Valkey primary service external traffic policy                                                                                                                                                                                    | `Cluster`                |
| `primary.service.extraPorts`                                | Extra ports to expose (normally used with the `sidecar` value)                                                                                                                                                                    | `[]`                     |
| `primary.service.internalTrafficPolicy`                     | Valkey primary service internal traffic policy (requires Kubernetes v1.22 or greater to be usable)                                                                                                                                | `Cluster`                |
| `primary.service.clusterIP`                                 | Valkey primary service Cluster IP                                                                                                                                                                                                 | `""`                     |
| `primary.service.loadBalancerIP`                            | Valkey primary service Load Balancer IP                                                                                                                                                                                           | `""`                     |
| `primary.service.loadBalancerClass`                         | primary service Load Balancer class if service type is `LoadBalancer` (optional, cloud specific)                                                                                                                                  | `""`                     |
| `primary.service.loadBalancerSourceRanges`                  | Valkey primary service Load Balancer sources                                                                                                                                                                                      | `[]`                     |
| `primary.service.externalIPs`                               | Valkey primary service External IPs                                                                                                                                                                                               | `[]`                     |
| `primary.service.annotations`                               | Additional custom annotations for Valkey primary service                                                                                                                                                                          | `{}`                     |
| `primary.service.sessionAffinity`                           | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                                                                                                                                                              | `None`                   |
| `primary.service.sessionAffinityConfig`                     | Additional settings for the sessionAffinity                                                                                                                                                                                       | `{}`                     |
| `primary.terminationGracePeriodSeconds`                     | Integer setting the termination grace period for the valkey-primary pods                                                                                                                                                          | `30`                     |
| `primary.serviceAccount.create`                             | Specifies whether a ServiceAccount should be created                                                                                                                                                                              | `true`                   |
| `primary.serviceAccount.name`                               | The name of the ServiceAccount to use.                                                                                                                                                                                            | `""`                     |
| `primary.serviceAccount.automountServiceAccountToken`       | Whether to auto mount the service account token                                                                                                                                                                                   | `false`                  |
| `primary.serviceAccount.annotations`                        | Additional custom annotations for the ServiceAccount                                                                                                                                                                              | `{}`                     |
| `primary.pdb.create`                                        | Enable/disable a Pod Disruption Budget creation                                                                                                                                                                                   | `true`                   |
| `primary.pdb.minAvailable`                                  | Minimum number/percentage of pods that should remain scheduled                                                                                                                                                                    | `{}`                     |
| `primary.pdb.maxUnavailable`                                | Maximum number/percentage of pods that may be made unavailable. Defaults to `1` if both `primary.pdb.minAvailable` and `primary.pdb.maxUnavailable` are empty.                                                                    | `{}`                     |

### Valkey replicas configuration parameters

| Name                                                        | Description                                                                                                                                                                                                                       | Value                    |
| ----------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `replica.kind`                                              | Use either DaemonSet or StatefulSet (default)                                                                                                                                                                                     | `StatefulSet`            |
| `replica.replicaCount`                                      | Number of Valkey replicas to deploy                                                                                                                                                                                               | `3`                      |
| `replica.configuration`                                     | Configuration for Valkey replicas nodes                                                                                                                                                                                           | `""`                     |
| `replica.disableCommands`                                   | Array with Valkey commands to disable on replicas nodes                                                                                                                                                                           | `["FLUSHDB","FLUSHALL"]` |
| `replica.command`                                           | Override default container command (useful when using custom images)                                                                                                                                                              | `[]`                     |
| `replica.args`                                              | Override default container args (useful when using custom images)                                                                                                                                                                 | `[]`                     |
| `replica.enableServiceLinks`                                | Whether information about services should be injected into pod's environment variable                                                                                                                                             | `true`                   |
| `replica.preExecCmds`                                       | Additional commands to run prior to starting Valkey replicas                                                                                                                                                                      | `[]`                     |
| `replica.extraFlags`                                        | Array with additional command line flags for Valkey replicas                                                                                                                                                                      | `[]`                     |
| `replica.extraEnvVars`                                      | Array with extra environment variables to add to Valkey replicas nodes                                                                                                                                                            | `[]`                     |
| `replica.extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for Valkey replicas nodes                                                                                                                                                    | `""`                     |
| `replica.extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for Valkey replicas nodes                                                                                                                                                       | `""`                     |
| `replica.externalPrimary.enabled`                           | Use external primary for bootstrapping                                                                                                                                                                                            | `false`                  |
| `replica.externalPrimary.host`                              | External primary host to bootstrap from                                                                                                                                                                                           | `""`                     |
| `replica.externalPrimary.port`                              | Port for Valkey service external primary host                                                                                                                                                                                     | `6379`                   |
| `replica.containerPorts.valkey`                             | Container port to open on Valkey replicas nodes                                                                                                                                                                                   | `6379`                   |
| `replica.startupProbe.enabled`                              | Enable startupProbe on Valkey replicas nodes                                                                                                                                                                                      | `true`                   |
| `replica.startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                                            | `10`                     |
| `replica.startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                                   | `10`                     |
| `replica.startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                                  | `5`                      |
| `replica.startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                                | `22`                     |
| `replica.startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                                | `1`                      |
| `replica.livenessProbe.enabled`                             | Enable livenessProbe on Valkey replicas nodes                                                                                                                                                                                     | `true`                   |
| `replica.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                                           | `20`                     |
| `replica.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                                  | `5`                      |
| `replica.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                                 | `5`                      |
| `replica.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                                               | `5`                      |
| `replica.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                                               | `1`                      |
| `replica.readinessProbe.enabled`                            | Enable readinessProbe on Valkey replicas nodes                                                                                                                                                                                    | `true`                   |
| `replica.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                                          | `20`                     |
| `replica.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                                 | `5`                      |
| `replica.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                                | `1`                      |
| `replica.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                                              | `5`                      |
| `replica.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                                              | `1`                      |
| `replica.customStartupProbe`                                | Custom startupProbe that overrides the default one                                                                                                                                                                                | `{}`                     |
| `replica.customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                                                                                                                               | `{}`                     |
| `replica.customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                                                                                                                                              | `{}`                     |
| `replica.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if replica.resources is set (replica.resources is recommended for production). | `nano`                   |
| `replica.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                 | `{}`                     |
| `replica.podSecurityContext.enabled`                        | Enabled Valkey replicas pods' Security Context                                                                                                                                                                                    | `true`                   |
| `replica.podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                                | `Always`                 |
| `replica.podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                                    | `[]`                     |
| `replica.podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                                       | `[]`                     |
| `replica.podSecurityContext.fsGroup`                        | Set Valkey replicas pod's Security Context fsGroup                                                                                                                                                                                | `1001`                   |
| `replica.containerSecurityContext.enabled`                  | Enabled Valkey replicas containers' Security Context                                                                                                                                                                              | `true`                   |
| `replica.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                                  | `{}`                     |
| `replica.containerSecurityContext.runAsUser`                | Set Valkey replicas containers' Security Context runAsUser                                                                                                                                                                        | `1001`                   |
| `replica.containerSecurityContext.runAsGroup`               | Set Valkey replicas containers' Security Context runAsGroup                                                                                                                                                                       | `1001`                   |
| `replica.containerSecurityContext.runAsNonRoot`             | Set Valkey replicas containers' Security Context runAsNonRoot                                                                                                                                                                     | `true`                   |
| `replica.containerSecurityContext.allowPrivilegeEscalation` | Set Valkey replicas pod's Security Context allowPrivilegeEscalation                                                                                                                                                               | `false`                  |
| `replica.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context read-only root filesystem                                                                                                                                                                        | `true`                   |
| `replica.containerSecurityContext.seccompProfile.type`      | Set Valkey replicas containers' Security Context seccompProfile                                                                                                                                                                   | `RuntimeDefault`         |
| `replica.containerSecurityContext.capabilities.drop`        | Set Valkey replicas containers' Security Context capabilities to drop                                                                                                                                                             | `["ALL"]`                |
| `replica.schedulerName`                                     | Alternate scheduler for Valkey replicas pods                                                                                                                                                                                      | `""`                     |
| `replica.updateStrategy.type`                               | Valkey replicas statefulset strategy type                                                                                                                                                                                         | `RollingUpdate`          |
| `replica.minReadySeconds`                                   | How many seconds a pod needs to be ready before killing the next, during update                                                                                                                                                   | `0`                      |
| `replica.priorityClassName`                                 | Valkey replicas pods' priorityClassName                                                                                                                                                                                           | `""`                     |
| `replica.podManagementPolicy`                               | podManagementPolicy to manage scaling operation of %%MAIN_CONTAINER_NAME%% pods                                                                                                                                                   | `""`                     |
| `replica.automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                                | `false`                  |
| `replica.hostAliases`                                       | Valkey replicas pods host aliases                                                                                                                                                                                                 | `[]`                     |
| `replica.podLabels`                                         | Extra labels for Valkey replicas pods                                                                                                                                                                                             | `{}`                     |
| `replica.podAnnotations`                                    | Annotations for Valkey replicas pods                                                                                                                                                                                              | `{}`                     |
| `replica.shareProcessNamespace`                             | Share a single process namespace between all of the containers in Valkey replicas pods                                                                                                                                            | `false`                  |
| `replica.podAffinityPreset`                                 | Pod affinity preset. Ignored if `replica.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                       | `""`                     |
| `replica.podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `replica.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                  | `soft`                   |
| `replica.nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `replica.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                 | `""`                     |
| `replica.nodeAffinityPreset.key`                            | Node label key to match. Ignored if `replica.affinity` is set                                                                                                                                                                     | `""`                     |
| `replica.nodeAffinityPreset.values`                         | Node label values to match. Ignored if `replica.affinity` is set                                                                                                                                                                  | `[]`                     |
| `replica.affinity`                                          | Affinity for Valkey replicas pods assignment                                                                                                                                                                                      | `{}`                     |
| `replica.nodeSelector`                                      | Node labels for Valkey replicas pods assignment                                                                                                                                                                                   | `{}`                     |
| `replica.tolerations`                                       | Tolerations for Valkey replicas pods assignment                                                                                                                                                                                   | `[]`                     |
| `replica.topologySpreadConstraints`                         | Spread Constraints for Valkey replicas pod assignment                                                                                                                                                                             | `[]`                     |
| `replica.dnsPolicy`                                         | DNS Policy for Valkey replica pods                                                                                                                                                                                                | `""`                     |
| `replica.dnsConfig`                                         | DNS Configuration for Valkey replica pods                                                                                                                                                                                         | `{}`                     |
| `replica.lifecycleHooks`                                    | for the Valkey replica container(s) to automate configuration before or after startup                                                                                                                                             | `{}`                     |
| `replica.extraVolumes`                                      | Optionally specify extra list of additional volumes for the Valkey replicas pod(s)                                                                                                                                                | `[]`                     |
| `replica.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the Valkey replicas container(s)                                                                                                                                     | `[]`                     |
| `replica.sidecars`                                          | Add additional sidecar containers to the Valkey replicas pod(s)                                                                                                                                                                   | `[]`                     |
| `replica.initContainers`                                    | Add additional init containers to the Valkey replicas pod(s)                                                                                                                                                                      | `[]`                     |
| `replica.persistence.enabled`                               | Enable persistence on Valkey replicas nodes using Persistent Volume Claims                                                                                                                                                        | `true`                   |
| `replica.persistence.medium`                                | Provide a medium for `emptyDir` volumes.                                                                                                                                                                                          | `""`                     |
| `replica.persistence.sizeLimit`                             | Set this to enable a size limit for `emptyDir` volumes.                                                                                                                                                                           | `""`                     |
| `replica.persistence.path`                                  | The path the volume will be mounted at on Valkey replicas containers                                                                                                                                                              | `/data`                  |
| `replica.persistence.subPath`                               | The subdirectory of the volume to mount on Valkey replicas containers                                                                                                                                                             | `""`                     |
| `replica.persistence.subPathExpr`                           | Used to construct the subPath subdirectory of the volume to mount on Valkey replicas containers                                                                                                                                   | `""`                     |
| `replica.persistence.storageClass`                          | Persistent Volume storage class                                                                                                                                                                                                   | `""`                     |
| `replica.persistence.accessModes`                           | Persistent Volume access modes                                                                                                                                                                                                    | `["ReadWriteOnce"]`      |
| `replica.persistence.size`                                  | Persistent Volume size                                                                                                                                                                                                            | `8Gi`                    |
| `replica.persistence.annotations`                           | Additional custom annotations for the PVC                                                                                                                                                                                         | `{}`                     |
| `replica.persistence.labels`                                | Additional custom labels for the PVC                                                                                                                                                                                              | `{}`                     |
| `replica.persistence.selector`                              | Additional labels to match for the PVC                                                                                                                                                                                            | `{}`                     |
| `replica.persistence.dataSource`                            | Custom PVC data source                                                                                                                                                                                                            | `{}`                     |
| `replica.persistence.existingClaim`                         | Use a existing PVC which must be created manually before bound                                                                                                                                                                    | `""`                     |
| `replica.persistentVolumeClaimRetentionPolicy.enabled`      | Controls if and how PVCs are deleted during the lifecycle of a StatefulSet                                                                                                                                                        | `false`                  |
| `replica.persistentVolumeClaimRetentionPolicy.whenScaled`   | Volume retention behavior when the replica count of the StatefulSet is reduced                                                                                                                                                    | `Retain`                 |
| `replica.persistentVolumeClaimRetentionPolicy.whenDeleted`  | Volume retention behavior that applies when the StatefulSet is deleted                                                                                                                                                            | `Retain`                 |
| `replica.service.type`                                      | Valkey replicas service type                                                                                                                                                                                                      | `ClusterIP`              |
| `replica.service.ports.valkey`                              | Valkey replicas service port                                                                                                                                                                                                      | `6379`                   |
| `replica.service.nodePorts.valkey`                          | Node port for Valkey replicas                                                                                                                                                                                                     | `""`                     |
| `replica.service.externalTrafficPolicy`                     | Valkey replicas service external traffic policy                                                                                                                                                                                   | `Cluster`                |
| `replica.service.internalTrafficPolicy`                     | Valkey replicas service internal traffic policy (requires Kubernetes v1.22 or greater to be usable)                                                                                                                               | `Cluster`                |
| `replica.service.extraPorts`                                | Extra ports to expose (normally used with the `sidecar` value)                                                                                                                                                                    | `[]`                     |
| `replica.service.clusterIP`                                 | Valkey replicas service Cluster IP                                                                                                                                                                                                | `""`                     |
| `replica.service.loadBalancerIP`                            | Valkey replicas service Load Balancer IP                                                                                                                                                                                          | `""`                     |
| `replica.service.loadBalancerClass`                         | replicas service Load Balancer class if service type is `LoadBalancer` (optional, cloud specific)                                                                                                                                 | `""`                     |
| `replica.service.loadBalancerSourceRanges`                  | Valkey replicas service Load Balancer sources                                                                                                                                                                                     | `[]`                     |
| `replica.service.annotations`                               | Additional custom annotations for Valkey replicas service                                                                                                                                                                         | `{}`                     |
| `replica.service.sessionAffinity`                           | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                                                                                                                                                              | `None`                   |
| `replica.service.sessionAffinityConfig`                     | Additional settings for the sessionAffinity                                                                                                                                                                                       | `{}`                     |
| `replica.terminationGracePeriodSeconds`                     | Integer setting the termination grace period for the valkey-replicas pods                                                                                                                                                         | `30`                     |

### Autoscaling

| Name                                          | Description                                                                                    | Value   |
| --------------------------------------------- | ---------------------------------------------------------------------------------------------- | ------- |
| `replica.autoscaling.vpa.enabled`             | Enable VPA                                                                                     | `false` |
| `replica.autoscaling.vpa.annotations`         | Annotations for VPA resource                                                                   | `{}`    |
| `replica.autoscaling.vpa.controlledResources` | VPA List of resources that the vertical pod autoscaler can control. Defaults to cpu and memory | `[]`    |
| `replica.autoscaling.vpa.maxAllowed`          | VPA Max allowed resources for the pod                                                          | `{}`    |
| `replica.autoscaling.vpa.minAllowed`          | VPA Min allowed resources for the pod                                                          | `{}`    |

### VPA update policy

| Name                                                  | Description                                                                                                                                                            | Value   |
| ----------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `replica.autoscaling.vpa.updatePolicy.updateMode`     | Autoscaling update policy Specifies whether recommended updates are applied when a Pod is started and whether recommended updates are applied during the life of a Pod | `Auto`  |
| `replica.autoscaling.hpa.enabled`                     | Enable HPA                                                                                                                                                             | `false` |
| `replica.autoscaling.hpa.minReplicas`                 | Minimum number of replicas                                                                                                                                             | `""`    |
| `replica.autoscaling.hpa.maxReplicas`                 | Maximum number of replicas                                                                                                                                             | `""`    |
| `replica.autoscaling.hpa.targetCPU`                   | Target CPU utilization percentage                                                                                                                                      | `""`    |
| `replica.autoscaling.hpa.targetMemory`                | Target Memory utilization percentage                                                                                                                                   | `""`    |
| `replica.serviceAccount.create`                       | Specifies whether a ServiceAccount should be created                                                                                                                   | `true`  |
| `replica.serviceAccount.name`                         | The name of the ServiceAccount to use.                                                                                                                                 | `""`    |
| `replica.serviceAccount.automountServiceAccountToken` | Whether to auto mount the service account token                                                                                                                        | `false` |
| `replica.serviceAccount.annotations`                  | Additional custom annotations for the ServiceAccount                                                                                                                   | `{}`    |
| `replica.pdb.create`                                  | Enable/disable a Pod Disruption Budget creation                                                                                                                        | `true`  |
| `replica.pdb.minAvailable`                            | Minimum number/percentage of pods that should remain scheduled                                                                                                         | `{}`    |
| `replica.pdb.maxUnavailable`                          | Maximum number/percentage of pods that may be made unavailable. Defaults to `1` if both `replica.pdb.minAvailable` and `replica.pdb.maxUnavailable` are empty.         | `{}`    |

### Valkey Sentinel configuration parameters

| Name                                                         | Description                                                                                                                                                                                                                         | Value                             |
| ------------------------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------- |
| `sentinel.enabled`                                           | Use Valkey Sentinel on Valkey pods.                                                                                                                                                                                                 | `false`                           |
| `sentinel.image.registry`                                    | Valkey Sentinel image registry                                                                                                                                                                                                      | `REGISTRY_NAME`                   |
| `sentinel.image.repository`                                  | Valkey Sentinel image repository                                                                                                                                                                                                    | `REPOSITORY_NAME/valkey-sentinel` |
| `sentinel.image.digest`                                      | Valkey Sentinel image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                     | `""`                              |
| `sentinel.image.pullPolicy`                                  | Valkey Sentinel image pull policy                                                                                                                                                                                                   | `IfNotPresent`                    |
| `sentinel.image.pullSecrets`                                 | Valkey Sentinel image pull secrets                                                                                                                                                                                                  | `[]`                              |
| `sentinel.image.debug`                                       | Enable image debug mode                                                                                                                                                                                                             | `false`                           |
| `sentinel.annotations`                                       | Additional custom annotations for Valkey Sentinel resource                                                                                                                                                                          | `{}`                              |
| `sentinel.primarySet`                                        | Primary set name                                                                                                                                                                                                                    | `myprimary`                       |
| `sentinel.quorum`                                            | Sentinel Quorum                                                                                                                                                                                                                     | `2`                               |
| `sentinel.getPrimaryTimeout`                                 | Amount of time to allow before get_sentinel_primary_info() times out.                                                                                                                                                               | `90`                              |
| `sentinel.automateClusterRecovery`                           | Automate cluster recovery in cases where the last replica is not considered a good replica and Sentinel won't automatically failover to it.                                                                                         | `false`                           |
| `sentinel.valkeyShutdownWaitFailover`                        | Whether the Valkey primary container waits for the failover at shutdown (in addition to the Valkey Sentinel container).                                                                                                             | `true`                            |
| `sentinel.downAfterMilliseconds`                             | Timeout for detecting a Valkey node is down                                                                                                                                                                                         | `60000`                           |
| `sentinel.failoverTimeout`                                   | Timeout for performing a election failover                                                                                                                                                                                          | `180000`                          |
| `sentinel.parallelSyncs`                                     | Number of replicas that can be reconfigured in parallel to use the new primary after a failover                                                                                                                                     | `1`                               |
| `sentinel.configuration`                                     | Configuration for Valkey Sentinel nodes                                                                                                                                                                                             | `""`                              |
| `sentinel.command`                                           | Override default container command (useful when using custom images)                                                                                                                                                                | `[]`                              |
| `sentinel.args`                                              | Override default container args (useful when using custom images)                                                                                                                                                                   | `[]`                              |
| `sentinel.enableServiceLinks`                                | Whether information about services should be injected into pod's environment variable                                                                                                                                               | `true`                            |
| `sentinel.preExecCmds`                                       | Additional commands to run prior to starting Valkey Sentinel                                                                                                                                                                        | `[]`                              |
| `sentinel.extraEnvVars`                                      | Array with extra environment variables to add to Valkey Sentinel nodes                                                                                                                                                              | `[]`                              |
| `sentinel.extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for Valkey Sentinel nodes                                                                                                                                                      | `""`                              |
| `sentinel.extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for Valkey Sentinel nodes                                                                                                                                                         | `""`                              |
| `sentinel.externalPrimary.enabled`                           | Use external primary for bootstrapping                                                                                                                                                                                              | `false`                           |
| `sentinel.externalPrimary.host`                              | External primary host to bootstrap from                                                                                                                                                                                             | `""`                              |
| `sentinel.externalPrimary.port`                              | Port for Valkey service external primary host                                                                                                                                                                                       | `6379`                            |
| `sentinel.containerPorts.sentinel`                           | Container port to open on Valkey Sentinel nodes                                                                                                                                                                                     | `26379`                           |
| `sentinel.startupProbe.enabled`                              | Enable startupProbe on Valkey Sentinel nodes                                                                                                                                                                                        | `true`                            |
| `sentinel.startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                                              | `10`                              |
| `sentinel.startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                                     | `10`                              |
| `sentinel.startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                                    | `5`                               |
| `sentinel.startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                                  | `22`                              |
| `sentinel.startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                                  | `1`                               |
| `sentinel.livenessProbe.enabled`                             | Enable livenessProbe on Valkey Sentinel nodes                                                                                                                                                                                       | `true`                            |
| `sentinel.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                                             | `20`                              |
| `sentinel.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                                    | `10`                              |
| `sentinel.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                                   | `5`                               |
| `sentinel.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                                                 | `6`                               |
| `sentinel.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                                                 | `1`                               |
| `sentinel.readinessProbe.enabled`                            | Enable readinessProbe on Valkey Sentinel nodes                                                                                                                                                                                      | `true`                            |
| `sentinel.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                                            | `20`                              |
| `sentinel.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                                   | `5`                               |
| `sentinel.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                                  | `1`                               |
| `sentinel.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                                                | `6`                               |
| `sentinel.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                                                | `1`                               |
| `sentinel.customStartupProbe`                                | Custom startupProbe that overrides the default one                                                                                                                                                                                  | `{}`                              |
| `sentinel.customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                                                                                                                                 | `{}`                              |
| `sentinel.customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                                                                                                                                                | `{}`                              |
| `sentinel.persistence.enabled`                               | Enable persistence on Valkey sentinel nodes using Persistent Volume Claims (Experimental)                                                                                                                                           | `false`                           |
| `sentinel.persistence.storageClass`                          | Persistent Volume storage class                                                                                                                                                                                                     | `""`                              |
| `sentinel.persistence.accessModes`                           | Persistent Volume access modes                                                                                                                                                                                                      | `["ReadWriteOnce"]`               |
| `sentinel.persistence.size`                                  | Persistent Volume size                                                                                                                                                                                                              | `100Mi`                           |
| `sentinel.persistence.annotations`                           | Additional custom annotations for the PVC                                                                                                                                                                                           | `{}`                              |
| `sentinel.persistence.labels`                                | Additional custom labels for the PVC                                                                                                                                                                                                | `{}`                              |
| `sentinel.persistence.selector`                              | Additional labels to match for the PVC                                                                                                                                                                                              | `{}`                              |
| `sentinel.persistence.dataSource`                            | Custom PVC data source                                                                                                                                                                                                              | `{}`                              |
| `sentinel.persistence.medium`                                | Provide a medium for `emptyDir` volumes.                                                                                                                                                                                            | `""`                              |
| `sentinel.persistence.sizeLimit`                             | Set this to enable a size limit for `emptyDir` volumes.                                                                                                                                                                             | `""`                              |
| `sentinel.persistentVolumeClaimRetentionPolicy.enabled`      | Controls if and how PVCs are deleted during the lifecycle of a StatefulSet                                                                                                                                                          | `false`                           |
| `sentinel.persistentVolumeClaimRetentionPolicy.whenScaled`   | Volume retention behavior when the replica count of the StatefulSet is reduced                                                                                                                                                      | `Retain`                          |
| `sentinel.persistentVolumeClaimRetentionPolicy.whenDeleted`  | Volume retention behavior that applies when the StatefulSet is deleted                                                                                                                                                              | `Retain`                          |
| `sentinel.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if sentinel.resources is set (sentinel.resources is recommended for production). | `nano`                            |
| `sentinel.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                   | `{}`                              |
| `sentinel.containerSecurityContext.enabled`                  | Enabled Valkey Sentinel containers' Security Context                                                                                                                                                                                | `true`                            |
| `sentinel.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                                    | `{}`                              |
| `sentinel.containerSecurityContext.runAsUser`                | Set Valkey Sentinel containers' Security Context runAsUser                                                                                                                                                                          | `1001`                            |
| `sentinel.containerSecurityContext.runAsGroup`               | Set Valkey Sentinel containers' Security Context runAsGroup                                                                                                                                                                         | `1001`                            |
| `sentinel.containerSecurityContext.runAsNonRoot`             | Set Valkey Sentinel containers' Security Context runAsNonRoot                                                                                                                                                                       | `true`                            |
| `sentinel.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context read-only root filesystem                                                                                                                                                                          | `true`                            |
| `sentinel.containerSecurityContext.allowPrivilegeEscalation` | Set Valkey Sentinel containers' Security Context allowPrivilegeEscalation                                                                                                                                                           | `false`                           |
| `sentinel.containerSecurityContext.seccompProfile.type`      | Set Valkey Sentinel containers' Security Context seccompProfile                                                                                                                                                                     | `RuntimeDefault`                  |
| `sentinel.containerSecurityContext.capabilities.drop`        | Set Valkey Sentinel containers' Security Context capabilities to drop                                                                                                                                                               | `["ALL"]`                         |
| `sentinel.lifecycleHooks`                                    | for the Valkey sentinel container(s) to automate configuration before or after startup                                                                                                                                              | `{}`                              |
| `sentinel.extraVolumes`                                      | Optionally specify extra list of additional volumes for the Valkey Sentinel                                                                                                                                                         | `[]`                              |
| `sentinel.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the Valkey Sentinel container(s)                                                                                                                                       | `[]`                              |
| `sentinel.service.type`                                      | Valkey Sentinel service type                                                                                                                                                                                                        | `ClusterIP`                       |
| `sentinel.service.ports.valkey`                              | Valkey service port for Valkey                                                                                                                                                                                                      | `6379`                            |
| `sentinel.service.ports.sentinel`                            | Valkey service port for Valkey Sentinel                                                                                                                                                                                             | `26379`                           |
| `sentinel.service.nodePorts.valkey`                          | Node port for Valkey                                                                                                                                                                                                                | `""`                              |
| `sentinel.service.nodePorts.sentinel`                        | Node port for Sentinel                                                                                                                                                                                                              | `""`                              |
| `sentinel.service.externalTrafficPolicy`                     | Valkey Sentinel service external traffic policy                                                                                                                                                                                     | `Cluster`                         |
| `sentinel.service.extraPorts`                                | Extra ports to expose (normally used with the `sidecar` value)                                                                                                                                                                      | `[]`                              |
| `sentinel.service.clusterIP`                                 | Valkey Sentinel service Cluster IP                                                                                                                                                                                                  | `""`                              |
| `sentinel.service.createPrimary`                             | Enable primary service pointing to the current primary (experimental)                                                                                                                                                               | `false`                           |
| `sentinel.service.loadBalancerIP`                            | Valkey Sentinel service Load Balancer IP                                                                                                                                                                                            | `""`                              |
| `sentinel.service.loadBalancerClass`                         | sentinel service Load Balancer class if service type is `LoadBalancer` (optional, cloud specific)                                                                                                                                   | `""`                              |
| `sentinel.service.loadBalancerSourceRanges`                  | Valkey Sentinel service Load Balancer sources                                                                                                                                                                                       | `[]`                              |
| `sentinel.service.annotations`                               | Additional custom annotations for Valkey Sentinel service                                                                                                                                                                           | `{}`                              |
| `sentinel.service.sessionAffinity`                           | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                                                                                                                                                                | `None`                            |
| `sentinel.service.sessionAffinityConfig`                     | Additional settings for the sessionAffinity                                                                                                                                                                                         | `{}`                              |
| `sentinel.service.headless.annotations`                      | Annotations for the headless service.                                                                                                                                                                                               | `{}`                              |
| `sentinel.terminationGracePeriodSeconds`                     | Integer setting the termination grace period for the valkey-node pods                                                                                                                                                               | `30`                              |

### Other Parameters

| Name                                            | Description                                                                                                                                 | Value   |
| ----------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `serviceBindings.enabled`                       | Create secret for service binding (Experimental)                                                                                            | `false` |
| `networkPolicy.enabled`                         | Enable creation of NetworkPolicy resources                                                                                                  | `true`  |
| `networkPolicy.allowExternal`                   | Don't require client label for connections                                                                                                  | `true`  |
| `networkPolicy.allowExternalEgress`             | Allow the pod to access any range of port and all destinations.                                                                             | `true`  |
| `networkPolicy.extraIngress`                    | Add extra ingress rules to the NetworkPolicy                                                                                                | `[]`    |
| `networkPolicy.extraEgress`                     | Add extra egress rules to the NetworkPolicy                                                                                                 | `[]`    |
| `networkPolicy.ingressNSMatchLabels`            | Labels to match to allow traffic from other namespaces                                                                                      | `{}`    |
| `networkPolicy.ingressNSPodMatchLabels`         | Pod labels to match to allow traffic from other namespaces                                                                                  | `{}`    |
| `networkPolicy.metrics.allowExternal`           | Don't require client label for connections for metrics endpoint                                                                             | `true`  |
| `networkPolicy.metrics.ingressNSMatchLabels`    | Labels to match to allow traffic from other namespaces to metrics endpoint                                                                  | `{}`    |
| `networkPolicy.metrics.ingressNSPodMatchLabels` | Pod labels to match to allow traffic from other namespaces to metrics endpoint                                                              | `{}`    |
| `podSecurityPolicy.create`                      | Whether to create a PodSecurityPolicy. WARNING: PodSecurityPolicy is deprecated in Kubernetes v1.21 or later, unavailable in v1.25 or later | `false` |
| `podSecurityPolicy.enabled`                     | Enable PodSecurityPolicy's RBAC rules                                                                                                       | `false` |
| `rbac.create`                                   | Specifies whether RBAC resources should be created                                                                                          | `false` |
| `rbac.rules`                                    | Custom RBAC rules to set                                                                                                                    | `[]`    |
| `serviceAccount.create`                         | Specifies whether a ServiceAccount should be created                                                                                        | `true`  |
| `serviceAccount.name`                           | The name of the ServiceAccount to use.                                                                                                      | `""`    |
| `serviceAccount.automountServiceAccountToken`   | Whether to auto mount the service account token                                                                                             | `false` |
| `serviceAccount.annotations`                    | Additional custom annotations for the ServiceAccount                                                                                        | `{}`    |
| `pdb`                                           | DEPRECATED Please use `primary.pdb` and `replica.pdb` values instead                                                                        | `{}`    |
| `tls.enabled`                                   | Enable TLS traffic                                                                                                                          | `false` |
| `tls.authClients`                               | Require clients to authenticate                                                                                                             | `true`  |
| `tls.autoGenerated`                             | Enable autogenerated certificates                                                                                                           | `false` |
| `tls.existingSecret`                            | The name of the existing secret that contains the TLS certificates                                                                          | `""`    |
| `tls.certFilename`                              | Certificate filename                                                                                                                        | `""`    |
| `tls.certKeyFilename`                           | Certificate Key filename                                                                                                                    | `""`    |
| `tls.certCAFilename`                            | CA Certificate filename                                                                                                                     | `""`    |
| `tls.dhParamsFilename`                          | File containing DH params (in order to support DH based ciphers)                                                                            | `""`    |

### Metrics Parameters

| Name                                                        | Description                                                                                                                                                                                                                       | Value                             |
| ----------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------- |
| `metrics.enabled`                                           | Start a sidecar prometheus exporter to expose Valkey metrics                                                                                                                                                                      | `false`                           |
| `metrics.image.registry`                                    | Valkey Exporter image registry                                                                                                                                                                                                    | `REGISTRY_NAME`                   |
| `metrics.image.repository`                                  | Valkey Exporter image repository                                                                                                                                                                                                  | `REPOSITORY_NAME/valkey-exporter` |
| `metrics.image.digest`                                      | Valkey Exporter image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                   | `""`                              |
| `metrics.image.pullPolicy`                                  | Valkey Exporter image pull policy                                                                                                                                                                                                 | `IfNotPresent`                    |
| `metrics.image.pullSecrets`                                 | Valkey Exporter image pull secrets                                                                                                                                                                                                | `[]`                              |
| `metrics.containerPorts.http`                               | Metrics HTTP container port                                                                                                                                                                                                       | `9121`                            |
| `metrics.startupProbe.enabled`                              | Enable startupProbe on Valkey replicas nodes                                                                                                                                                                                      | `false`                           |
| `metrics.startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                                            | `10`                              |
| `metrics.startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                                   | `10`                              |
| `metrics.startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                                  | `5`                               |
| `metrics.startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                                | `5`                               |
| `metrics.startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                                | `1`                               |
| `metrics.livenessProbe.enabled`                             | Enable livenessProbe on Valkey replicas nodes                                                                                                                                                                                     | `true`                            |
| `metrics.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                                           | `10`                              |
| `metrics.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                                  | `10`                              |
| `metrics.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                                 | `5`                               |
| `metrics.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                                               | `5`                               |
| `metrics.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                                               | `1`                               |
| `metrics.readinessProbe.enabled`                            | Enable readinessProbe on Valkey replicas nodes                                                                                                                                                                                    | `true`                            |
| `metrics.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                                          | `5`                               |
| `metrics.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                                 | `10`                              |
| `metrics.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                                | `1`                               |
| `metrics.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                                              | `3`                               |
| `metrics.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                                              | `1`                               |
| `metrics.customStartupProbe`                                | Custom startupProbe that overrides the default one                                                                                                                                                                                | `{}`                              |
| `metrics.customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                                                                                                                               | `{}`                              |
| `metrics.customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                                                                                                                                              | `{}`                              |
| `metrics.command`                                           | Override default metrics container init command (useful when using custom images)                                                                                                                                                 | `[]`                              |
| `metrics.valkeyTargetHost`                                  | A way to specify an alternative Valkey hostname                                                                                                                                                                                   | `localhost`                       |
| `metrics.extraArgs`                                         | Extra arguments for Valkey exporter, for example:                                                                                                                                                                                 | `{}`                              |
| `metrics.extraEnvVars`                                      | Array with extra environment variables to add to Valkey exporter                                                                                                                                                                  | `[]`                              |
| `metrics.containerSecurityContext.enabled`                  | Enabled Valkey exporter containers' Security Context                                                                                                                                                                              | `true`                            |
| `metrics.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                                  | `{}`                              |
| `metrics.containerSecurityContext.runAsUser`                | Set Valkey exporter containers' Security Context runAsUser                                                                                                                                                                        | `1001`                            |
| `metrics.containerSecurityContext.runAsGroup`               | Set Valkey exporter containers' Security Context runAsGroup                                                                                                                                                                       | `1001`                            |
| `metrics.containerSecurityContext.runAsNonRoot`             | Set Valkey exporter containers' Security Context runAsNonRoot                                                                                                                                                                     | `true`                            |
| `metrics.containerSecurityContext.allowPrivilegeEscalation` | Set Valkey exporter containers' Security Context allowPrivilegeEscalation                                                                                                                                                         | `false`                           |
| `metrics.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context read-only root filesystem                                                                                                                                                                        | `true`                            |
| `metrics.containerSecurityContext.seccompProfile.type`      | Set Valkey exporter containers' Security Context seccompProfile                                                                                                                                                                   | `RuntimeDefault`                  |
| `metrics.containerSecurityContext.capabilities.drop`        | Set Valkey exporter containers' Security Context capabilities to drop                                                                                                                                                             | `["ALL"]`                         |
| `metrics.extraVolumes`                                      | Optionally specify extra list of additional volumes for the Valkey metrics sidecar                                                                                                                                                | `[]`                              |
| `metrics.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the Valkey metrics sidecar                                                                                                                                           | `[]`                              |
| `metrics.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if metrics.resources is set (metrics.resources is recommended for production). | `nano`                            |
| `metrics.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                 | `{}`                              |
| `metrics.podLabels`                                         | Extra labels for Valkey exporter pods                                                                                                                                                                                             | `{}`                              |
| `metrics.podAnnotations`                                    | Annotations for Valkey exporter pods                                                                                                                                                                                              | `{}`                              |
| `metrics.service.enabled`                                   | Create Service resource(s) for scraping metrics using PrometheusOperator ServiceMonitor, can be disabled when using a PodMonitor                                                                                                  | `true`                            |
| `metrics.service.type`                                      | Valkey exporter service type                                                                                                                                                                                                      | `ClusterIP`                       |
| `metrics.service.ports.http`                                | Valkey exporter service port                                                                                                                                                                                                      | `9121`                            |
| `metrics.service.externalTrafficPolicy`                     | Valkey exporter service external traffic policy                                                                                                                                                                                   | `Cluster`                         |
| `metrics.service.extraPorts`                                | Extra ports to expose (normally used with the `sidecar` value)                                                                                                                                                                    | `[]`                              |
| `metrics.service.loadBalancerIP`                            | Valkey exporter service Load Balancer IP                                                                                                                                                                                          | `""`                              |
| `metrics.service.loadBalancerClass`                         | exporter service Load Balancer class if service type is `LoadBalancer` (optional, cloud specific)                                                                                                                                 | `""`                              |
| `metrics.service.loadBalancerSourceRanges`                  | Valkey exporter service Load Balancer sources                                                                                                                                                                                     | `[]`                              |
| `metrics.service.annotations`                               | Additional custom annotations for Valkey exporter service                                                                                                                                                                         | `{}`                              |
| `metrics.service.clusterIP`                                 | Valkey exporter service Cluster IP                                                                                                                                                                                                | `""`                              |
| `metrics.serviceMonitor.port`                               | the service port to scrape metrics from                                                                                                                                                                                           | `http-metrics`                    |
| `metrics.serviceMonitor.enabled`                            | Create ServiceMonitor resource(s) for scraping metrics using PrometheusOperator                                                                                                                                                   | `false`                           |
| `metrics.serviceMonitor.namespace`                          | The namespace in which the ServiceMonitor will be created                                                                                                                                                                         | `""`                              |
| `metrics.serviceMonitor.interval`                           | The interval at which metrics should be scraped                                                                                                                                                                                   | `30s`                             |
| `metrics.serviceMonitor.scrapeTimeout`                      | The timeout after which the scrape is ended                                                                                                                                                                                       | `""`                              |
| `metrics.serviceMonitor.relabelings`                        | Metrics RelabelConfigs to apply to samples before scraping.                                                                                                                                                                       | `[]`                              |
| `metrics.serviceMonitor.metricRelabelings`                  | Metrics RelabelConfigs to apply to samples before ingestion.                                                                                                                                                                      | `[]`                              |
| `metrics.serviceMonitor.honorLabels`                        | Specify honorLabels parameter to add the scrape endpoint                                                                                                                                                                          | `false`                           |
| `metrics.serviceMonitor.additionalLabels`                   | Additional labels that can be used so ServiceMonitor resource(s) can be discovered by Prometheus                                                                                                                                  | `{}`                              |
| `metrics.serviceMonitor.podTargetLabels`                    | Labels from the Kubernetes pod to be transferred to the created metrics                                                                                                                                                           | `[]`                              |
| `metrics.serviceMonitor.sampleLimit`                        | Limit of how many samples should be scraped from every Pod                                                                                                                                                                        | `false`                           |
| `metrics.serviceMonitor.targetLimit`                        | Limit of how many targets should be scraped                                                                                                                                                                                       | `false`                           |
| `metrics.serviceMonitor.additionalEndpoints`                | Additional endpoints to scrape (e.g sentinel)                                                                                                                                                                                     | `[]`                              |
| `metrics.podMonitor.port`                                   | the pod port to scrape metrics from                                                                                                                                                                                               | `metrics`                         |
| `metrics.podMonitor.enabled`                                | Create PodMonitor resource(s) for scraping metrics using PrometheusOperator                                                                                                                                                       | `false`                           |
| `metrics.podMonitor.namespace`                              | The namespace in which the PodMonitor will be created                                                                                                                                                                             | `""`                              |
| `metrics.podMonitor.interval`                               | The interval at which metrics should be scraped                                                                                                                                                                                   | `30s`                             |
| `metrics.podMonitor.scrapeTimeout`                          | The timeout after which the scrape is ended                                                                                                                                                                                       | `""`                              |
| `metrics.podMonitor.relabelings`                            | Metrics RelabelConfigs to apply to samples before scraping.                                                                                                                                                                       | `[]`                              |
| `metrics.podMonitor.metricRelabelings`                      | Metrics RelabelConfigs to apply to samples before ingestion.                                                                                                                                                                      | `[]`                              |
| `metrics.podMonitor.honorLabels`                            | Specify honorLabels parameter to add the scrape endpoint                                                                                                                                                                          | `false`                           |
| `metrics.podMonitor.additionalLabels`                       | Additional labels that can be used so PodMonitor resource(s) can be discovered by Prometheus                                                                                                                                      | `{}`                              |
| `metrics.podMonitor.podTargetLabels`                        | Labels from the Kubernetes pod to be transferred to the created metrics                                                                                                                                                           | `[]`                              |
| `metrics.podMonitor.sampleLimit`                            | Limit of how many samples should be scraped from every Pod                                                                                                                                                                        | `false`                           |
| `metrics.podMonitor.targetLimit`                            | Limit of how many targets should be scraped                                                                                                                                                                                       | `false`                           |
| `metrics.podMonitor.additionalEndpoints`                    | Additional endpoints to scrape (e.g sentinel)                                                                                                                                                                                     | `[]`                              |
| `metrics.prometheusRule.enabled`                            | Create a custom prometheusRule Resource for scraping metrics using PrometheusOperator                                                                                                                                             | `false`                           |
| `metrics.prometheusRule.namespace`                          | The namespace in which the prometheusRule will be created                                                                                                                                                                         | `""`                              |
| `metrics.prometheusRule.additionalLabels`                   | Additional labels for the prometheusRule                                                                                                                                                                                          | `{}`                              |
| `metrics.prometheusRule.rules`                              | Custom Prometheus rules                                                                                                                                                                                                           | `[]`                              |

### Init Container Parameters

| Name                                                        | Description                                                                                                                                                                                                                                           | Value                                                              |
| ----------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------ |
| `volumePermissions.enabled`                                 | Enable init container that changes the owner/group of the PV mount point to `runAsUser:fsGroup`                                                                                                                                                       | `false`                                                            |
| `volumePermissions.image.registry`                          | OS Shell + Utility image registry                                                                                                                                                                                                                     | `REGISTRY_NAME`                                                    |
| `volumePermissions.image.repository`                        | OS Shell + Utility image repository                                                                                                                                                                                                                   | `REPOSITORY_NAME/os-shell`                                         |
| `volumePermissions.image.digest`                            | OS Shell + Utility image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                                    | `""`                                                               |
| `volumePermissions.image.pullPolicy`                        | OS Shell + Utility image pull policy                                                                                                                                                                                                                  | `IfNotPresent`                                                     |
| `volumePermissions.image.pullSecrets`                       | OS Shell + Utility image pull secrets                                                                                                                                                                                                                 | `[]`                                                               |
| `volumePermissions.resourcesPreset`                         | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if volumePermissions.resources is set (volumePermissions.resources is recommended for production). | `nano`                                                             |
| `volumePermissions.resources`                               | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                                     | `{}`                                                               |
| `volumePermissions.containerSecurityContext.seLinuxOptions` | Set SELinux options in container                                                                                                                                                                                                                      | `{}`                                                               |
| `volumePermissions.containerSecurityContext.runAsUser`      | Set init container's Security Context runAsUser                                                                                                                                                                                                       | `0`                                                                |
| `kubectl.image.registry`                                    | Kubectl image registry                                                                                                                                                                                                                                | `REGISTRY_NAME`                                                    |
| `kubectl.image.repository`                                  | Kubectl image repository                                                                                                                                                                                                                              | `REPOSITORY_NAME/kubectl`                                          |
| `kubectl.image.digest`                                      | Kubectl image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                                               | `""`                                                               |
| `kubectl.image.pullPolicy`                                  | Kubectl image pull policy                                                                                                                                                                                                                             | `IfNotPresent`                                                     |
| `kubectl.image.pullSecrets`                                 | Kubectl pull secrets                                                                                                                                                                                                                                  | `[]`                                                               |
| `kubectl.command`                                           | kubectl command to execute                                                                                                                                                                                                                            | `["/opt/bitnami/scripts/kubectl-scripts/update-primary-label.sh"]` |
| `kubectl.containerSecurityContext.enabled`                  | Enabled kubectl containers' Security Context                                                                                                                                                                                                          | `true`                                                             |
| `kubectl.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                                                      | `{}`                                                               |
| `kubectl.containerSecurityContext.runAsUser`                | Set kubectl containers' Security Context runAsUser                                                                                                                                                                                                    | `1001`                                                             |
| `kubectl.containerSecurityContext.runAsGroup`               | Set kubectl containers' Security Context runAsGroup                                                                                                                                                                                                   | `1001`                                                             |
| `kubectl.containerSecurityContext.runAsNonRoot`             | Set kubectl containers' Security Context runAsNonRoot                                                                                                                                                                                                 | `true`                                                             |
| `kubectl.containerSecurityContext.allowPrivilegeEscalation` | Set kubectl containers' Security Context allowPrivilegeEscalation                                                                                                                                                                                     | `false`                                                            |
| `kubectl.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context read-only root filesystem                                                                                                                                                                                            | `true`                                                             |
| `kubectl.containerSecurityContext.seccompProfile.type`      | Set kubectl containers' Security Context seccompProfile                                                                                                                                                                                               | `RuntimeDefault`                                                   |
| `kubectl.containerSecurityContext.capabilities.drop`        | Set kubectl containers' Security Context capabilities to drop                                                                                                                                                                                         | `["ALL"]`                                                          |
| `kubectl.resources.limits`                                  | The resources limits for the kubectl containers                                                                                                                                                                                                       | `{}`                                                               |
| `kubectl.resources.requests`                                | The requested resources for the kubectl containers                                                                                                                                                                                                    | `{}`                                                               |

### useExternalDNS Parameters

| Name                                   | Description                                                                                                                              | Value                               |
| -------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------- |
| `useExternalDNS.enabled`               | Enable various syntax that would enable external-dns to work.  Note this requires a working installation of `external-dns` to be usable. | `false`                             |
| `useExternalDNS.additionalAnnotations` | Extra annotations to be utilized when `external-dns` is enabled.                                                                         | `{}`                                |
| `useExternalDNS.annotationKey`         | The annotation key utilized when `external-dns` is enabled. Setting this to `false` will disable annotations.                            | `external-dns.alpha.kubernetes.io/` |
| `useExternalDNS.suffix`                | The DNS suffix utilized when `external-dns` is enabled.  Note that we prepend the suffix with the full name of the release.              | `""`                                |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
  --set auth.password=secretpassword \
    oci://REGISTRY_NAME/REPOSITORY_NAME/valkey
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The above command sets the Valkey server password to `secretpassword`.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml oci://REGISTRY_NAME/REPOSITORY_NAME/valkey
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.
> **Tip**: You can use the default [values.yaml](https://github.com/bitnami/charts/tree/main/bitnami/valkey/values.yaml)

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 2.2.0

This version introduces image verification for security purposes. To disable it, set `global.security.allowInsecureImages` to `true`. More details at [GitHub issue](https://github.com/bitnami/charts/issues/30850).

### To 2.0.0

This major updates all the references from `master/slave` to `primary/replica` to follow the upstream project strategy:

- The term *master* has been replaced by the term *primary*. Therefore, parameters prefixed with `master` are now prefixed with `primary`.
- Environment variables previously prefixed as `VALKEY_MASTER` or `VALKEY_SENTINEL_MASTER` use `VALKEY_PRIMARY` and `VALKEY_SENTINEL_PRIMARY` now.

Consequences:

Backwards compatibility is not guaranteed. To upgrade to `2.0.0`, install a new release of the Valkey chart, and migrate the data from your previous release. You have 2 alternatives to do so:

- Create a backup of the database, and restore it on the new release as explained in the [Backup and restore](#backup-and-restore) section.
- Reuse the PVC used to hold the master data on your previous release. To do so, use the `primary.persistence.existingClaim` parameter. The following example assumes that the release name is `valkey`:

```console
helm install valkey oci://REGISTRY_NAME/REPOSITORY_NAME/valkey --set auth.password=[PASSWORD] --set primary.persistence.existingClaim=[EXISTING_PVC]
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

| Note: you need to substitute the placeholder *[EXISTING_PVC]* with the name of the PVC used on your previous release, and *[PASSWORD]* with the password used in your previous release.

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