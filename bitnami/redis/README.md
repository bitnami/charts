<!--- app-name: Redis&reg; -->

# Bitnami package for Redis&reg;

Redis&reg; is an open source, advanced key-value store. It is often referred to as a data structure server since keys can contain strings, hashes, lists, sets and sorted sets.

[Overview of Redis&reg;](http://redis.io)

Disclaimer: Redis is a registered trademark of Redis Ltd. Any rights therein are reserved to Redis Ltd. Any use by Bitnami is for referential purposes only and does not indicate any sponsorship, endorsement, or affiliation between Redis Ltd.

## TL;DR

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/redis
```

Looking to use Redis&reg; in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the commercial edition of the Bitnami catalog.

## Introduction

This chart bootstraps a [Redis&reg;](https://github.com/bitnami/containers/tree/main/bitnami/redis) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

### Choose between Redis&reg; Helm Chart and Redis&reg; Cluster Helm Chart

You can choose any of the two Redis&reg; Helm charts for deploying a Redis&reg; cluster.

1. [Redis&reg; Helm Chart](https://github.com/bitnami/charts/tree/main/bitnami/redis) will deploy a master-replica cluster, with the [option](https://github.com/bitnami/charts/tree/main/bitnami/redis#redis-sentinel-configuration-parameters) of enabling using Redis&reg; Sentinel.
2. [Redis&reg; Cluster Helm Chart](https://github.com/bitnami/charts/tree/main/bitnami/redis-cluster) will deploy a Redis&reg; Cluster topology with sharding.

The main features of each chart are the following:

| Redis&reg;                                     | Redis&reg; Cluster                                             |
|--------------------------------------------------------|------------------------------------------------------------------------|
| Supports multiple databases                            | Supports only one database. Better if you have a big dataset           |
| Single write point (single master)                     | Multiple write points (multiple masters)                               |
| ![Redis&reg; Topology](img/redis-topology.png) | ![Redis&reg; Cluster Topology](img/redis-cluster-topology.png) |

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/redis
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The command deploys Redis&reg; on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Configuration and installation details

### Resource requests and limits

Bitnami charts allow setting resource requests and limits for all containers inside the chart deployment. These are inside the `resources` value (check parameter table). Setting requests is essential for production workloads and these should be adapted to your specific use case.

To make this process easier, the chart contains the `resourcesPreset` values, which automatically sets the `resources` section according to different presets. Check these presets in [the bitnami/common chart](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15). However, in production workloads using `resourcesPreset` is discouraged as it may not fully adapt to your specific needs. Find more information on container resource management in the [official Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).

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

### [Rolling VS Immutable tags](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Use a different Redis&reg; version

To modify the application version used in this chart, specify a different version of the image using the `image.tag` parameter and/or a different repository using the `image.repository` parameter.

### Bootstrapping with an External Cluster

This chart is equipped with the ability to bring online a set of Pods that connect to an existing Redis deployment that lies outside of Kubernetes.  This effectively creates a hybrid Redis Deployment where both Pods in Kubernetes and Instances such as Virtual Machines can partake in a single Redis Deployment. This is helpful in situations where one may be migrating Redis from Virtual Machines into Kubernetes, for example.  To take advantage of this, use the following as an example configuration:

```yaml
replica:
  externalMaster:
    enabled: true
    host: external-redis-0.internal
sentinel:
  externalMaster:
    enabled: true
    host: external-redis-0.internal
```

:warning: This is currently limited to clusters in which Sentinel and Redis run on the same node! :warning:

Please also note that the external sentinel must be listening on port `26379`, and this is currently not configurable.

Once the Kubernetes Redis Deployment is online and confirmed to be working with the existing cluster, the configuration can then be removed and the cluster will remain connected.

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

On a cluster where the name of the Helm release is `a`, the hostname of a Pod is generated as: `a-redis-node-0.a-redis.prod.example.org`. The IP of that FQDN will match that of the associated Pod. This modifies the following parameters of the Redis/Sentinel configuration using this new FQDN:

- `replica-announce-ip`
- `known-sentinel`
- `known-replica`
- `announce-ip`

:warning: This requires a working installation of `external-dns` to be fully functional. :warning:

See the [official ExternalDNS documentation](https://github.com/kubernetes-sigs/external-dns) for additional configuration options.

### Cluster topologies

#### Default: Master-Replicas

When installing the chart with `architecture=replication`, it will deploy a Redis&reg; master StatefulSet and a Redis&reg; replicas StatefulSet. The replicas will be read-replicas of the master. Two services will be exposed:

- Redis&reg; Master service: Points to the master, where read-write operations can be performed
- Redis&reg; Replicas service: Points to the replicas, where only read operations are allowed by default.

In case the master crashes, the replicas will wait until the master node is respawned again by the Kubernetes Controller Manager.

#### Standalone

When installing the chart with `architecture=standalone`, it will deploy a standalone Redis&reg; StatefulSet. A single service will be exposed:

- Redis&reg; Master service: Points to the master, where read-write operations can be performed

#### Master-Replicas with Sentinel

When installing the chart with `architecture=replication` and `sentinel.enabled=true`, it will deploy a Redis&reg; master StatefulSet (only one master allowed) and a Redis&reg; replicas StatefulSet. In this case, the pods will contain an extra container with Redis&reg; Sentinel. This container will form a cluster of Redis&reg; Sentinel nodes, which will promote a new master in case the actual one fails.

On graceful termination of the Redis&reg; master pod, a failover of the master is initiated to promote a new master. The Redis&reg; Sentinel container in this pod will wait for the failover to occur before terminating. If `sentinel.redisShutdownWaitFailover=true` is set (the default), the Redis&reg; container will wait for the failover as well before terminating. This increases availability for reads during failover, but may cause stale reads until all clients have switched to the new master.

In addition to this, only one service is exposed:

- Redis&reg; service: Exposes port 6379 for Redis&reg; read-only operations and port 26379 for accessing Redis&reg; Sentinel.

For read-only operations, access the service using port 6379. For write operations, it's necessary to access the Redis&reg; Sentinel cluster and query the current master using the command below (using redis-cli or similar):

```console
SENTINEL get-master-addr-by-name <name of your MasterSet. e.g: mymaster>
```

This command will return the address of the current master, which can be accessed from inside the cluster.

In case the current master crashes, the Sentinel containers will elect a new master node.

`master.count` greater than `1` is not designed for use when `sentinel.enabled=true`.

### Multiple masters (experimental)

When `master.count` is greater than `1`, special care must be taken to create a consistent setup.

An example of use case is the creation of a redundant set of standalone masters or master-replicas per Kubernetes node where you must ensure:

- No more than `1` master can be deployed per Kubernetes node
- Replicas and writers can only see the single master of their own Kubernetes node

One way of achieving this is by setting `master.service.internalTrafficPolicy=Local` in combination with a `master.affinity.podAntiAffinity` spec to never schedule more than one master per Kubernetes node.

It's recommended to only change `master.count` if you know what you are doing.
`master.count` greater than `1` is not designed for use when `sentinel.enabled=true`.

### Update credentials

The Bitnami Redis chart, when upgrading, reuses the secret previously rendered by the chart or the one specified in `auth.existingSecret`. To update credentials, use one of the following:

- Run `helm upgrade` specifying a new password in `auth.password`
- Run `helm upgrade` specifying a new secret in `auth.existingSecret`

### Using a password file

To use a password file for Redis&reg; you need to create a secret containing the password and then deploy the chart using that secret. Follow these instructions:

- Create the secret with the password. It is important that the file with the password must be called `redis-password`.

```console
kubectl create secret generic redis-password-secret --from-file=redis-password.yaml
```

- Deploy the Helm Chart using the secret name as parameter:

```text
usePassword=true
usePasswordFiles=true
existingSecret=redis-password-secret
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

If you have enabled TLS by specifying `tls.enabled=true` you also need to specify TLS option to the metrics exporter. You can do that via `metrics.extraArgs`. You can find the metrics exporter CLI flags for TLS [here](https://github.com/oliver006/redis_exporter#command-line-flags). For example:

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

Redis&reg; may require some changes in the kernel of the host machine to work as expected, in particular increasing the `somaxconn` value and disabling transparent huge pages. To do so, you can set up a privileged `initContainer` with the `sysctlImage` config values, for example:

```yaml
sysctlImage:
  enabled: true
  mountHostSys: true
  command:
    - /bin/sh
    - -c
    - |-
      install_packages procps
      sysctl -w net.core.somaxconn=10000
      echo never > /host-sys/kernel/mm/transparent_hugepage/enabled
```

Alternatively, for Kubernetes 1.12+ you can set `securityContext.sysctls` which will configure `sysctls` for master and slave pods. Example:

```yaml
securityContext:
  sysctls:
  - name: net.core.somaxconn
    value: "10000"
```

Note that this will not disable transparent huge tables.

### Backup and restore

To backup and restore Redis deployments on Kubernetes, you will need to create a snapshot of the data in the source cluster, and later restore it in a new cluster with the new parameters. Follow the instructions below:

#### Step 1: Backup the deployment

- Connect to one of the nodes and start the Redis CLI tool. Then, run the commands below:

    ```text
    $ kubectl exec -it my-release-master-0 bash
    $ redis-cli
    127.0.0.1:6379> auth your_current_redis_password
    OK
    127.0.0.1:6379> save
    OK
    ```

- Copy the dump file from the Redis node:

    ```console
    kubectl cp my-release-master-0:/data/dump.rdb dump.rdb -c redis
    ```

#### Step 2: Restore the data on the destination cluster

To restore the data in a new cluster, you will need to create a PVC and then upload the *dump.rdb* file to the new volume.

Follow the following steps:

- In the [*values.yaml*](https://github.com/bitnami/charts/blob/main/bitnami/redis/values.yaml) file set the *appendonly* parameter to *no*. You can skip this step if it is already configured as *no*

    ```yaml
    commonConfiguration: |-
       # Enable AOF https://redis.io/topics/persistence#append-only-file
       appendonly no
       # Disable RDB persistence, AOF persistence already enabled.
       save ""
    ```

    > *Note that the `Enable AOF` comment belongs to the original config file and what you're actually doing is disabling it. This change will only be neccessary for the temporal cluster you're creating to upload the dump.*

- Start the new cluster to create the PVCs. Use the command below as an example:

    ```console
    helm install new-redis  -f values.yaml .  --set cluster.enabled=true  --set cluster.slaveCount=3
    ```

- Now that the PVC were created, stop it and copy the *dump.rdp* file on the persisted data by using a helping pod.

    ```text
    $ helm delete new-redis

    $ kubectl run --generator=run-pod/v1 -i --rm --tty volpod --overrides='
    {
        "apiVersion": "v1",
        "kind": "Pod",
        "metadata": {
            "name": "redisvolpod"
        },
        "spec": {
            "containers": [{
               "command": [
                    "tail",
                    "-f",
                    "/dev/null"
               ],
               "image": "bitnami/minideb",
               "name": "mycontainer",
               "volumeMounts": [{
                   "mountPath": "/mnt",
                   "name": "redisdata"
                }]
            }],
            "restartPolicy": "Never",
            "volumes": [{
                "name": "redisdata",
                "persistentVolumeClaim": {
                    "claimName": "redis-data-new-redis-master-0"
                }
            }]
        }
    }' --image="bitnami/minideb"

    $ kubectl cp dump.rdb redisvolpod:/mnt/dump.rdb
    $ kubectl delete pod volpod
    ```

- Restart the cluster:

    > **INFO:** The *appendonly* parameter can be safely restored to your desired value.

    ```console
    helm install new-redis  -f values.yaml .  --set cluster.enabled=true  --set cluster.slaveCount=3
    ```

### NetworkPolicy

To enable network policy for Redis&reg;, install [a networking plugin that implements the Kubernetes NetworkPolicy spec](https://kubernetes.io/docs/tasks/administer-cluster/declare-network-policy#before-you-begin), and set `networkPolicy.enabled` to `true`.

With NetworkPolicy enabled, only pods with the generated client label will be able to connect to Redis. This label will be displayed in the output after a successful install.

With `networkPolicy.ingressNSMatchLabels` pods from other namespaces can connect to Redis. Set `networkPolicy.ingressNSPodMatchLabels` to match pod labels in matched namespace. For example, for a namespace labeled `redis=external` and pods in that namespace labeled `redis-client=true` the fields should be set:

```yaml
networkPolicy:
  enabled: true
  ingressNSMatchLabels:
    redis: external
  ingressNSPodMatchLabels:
    redis-client: true
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
helm install my-release --set master.persistence.existingClaim=PVC_NAME oci://REGISTRY_NAME/REPOSITORY_NAME/redis
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
| `global.redis.password`                               | Global Redis(R) password (overrides `auth.password`)                                                                                                                                                                                                                                                                                                                | `""`    |
| `global.security.allowInsecureImages`                 | Allows skipping image verification                                                                                                                                                                                                                                                                                                                                  | `false` |
| `global.compatibility.openshift.adaptSecurityContext` | Adapt the securityContext sections of the deployment to make them compatible with Openshift restricted-v2 SCC: remove runAsUser, runAsGroup and fsGroup and let the platform use their allowed default IDs. Possible values: auto (apply if the detected running cluster is Openshift), force (perform the adaptation always), disabled (do not perform adaptation) | `auto`  |

### Common parameters

| Name                           | Description                                                                                                    | Value           |
| ------------------------------ | -------------------------------------------------------------------------------------------------------------- | --------------- |
| `kubeVersion`                  | Override Kubernetes version                                                                                    | `""`            |
| `nameOverride`                 | String to partially override common.names.fullname                                                             | `""`            |
| `fullnameOverride`             | String to fully override common.names.fullname                                                                 | `""`            |
| `namespaceOverride`            | String to fully override common.names.namespace                                                                | `""`            |
| `commonLabels`                 | Labels to add to all deployed objects                                                                          | `{}`            |
| `commonAnnotations`            | Annotations to add to all deployed objects                                                                     | `{}`            |
| `configmapChecksumAnnotations` | Enable checksum annotations used to trigger rolling updates when ConfigMap(s) change                           | `true`          |
| `secretChecksumAnnotations`    | Enable checksum annotations used to trigger rolling updates when Secret(s) change                              | `true`          |
| `secretAnnotations`            | Annotations to add to secret                                                                                   | `{}`            |
| `clusterDomain`                | Kubernetes cluster domain name                                                                                 | `cluster.local` |
| `extraDeploy`                  | Array of extra objects to deploy with the release                                                              | `[]`            |
| `useHostnames`                 | Use hostnames internally when announcing replication. If false, the hostname will be resolved to an IP address | `true`          |
| `nameResolutionThreshold`      | Failure threshold for internal hostnames resolution                                                            | `5`             |
| `nameResolutionTimeout`        | Timeout seconds between probes for internal hostnames resolution                                               | `5`             |
| `diagnosticMode.enabled`       | Enable diagnostic mode (all probes will be disabled and the command will be overridden)                        | `false`         |
| `diagnosticMode.command`       | Command to override all containers in the deployment                                                           | `["sleep"]`     |
| `diagnosticMode.args`          | Args to override all containers in the deployment                                                              | `["infinity"]`  |

### Redis(R) Image parameters

| Name                | Description                                                                                              | Value                   |
| ------------------- | -------------------------------------------------------------------------------------------------------- | ----------------------- |
| `image.registry`    | Redis(R) image registry                                                                                  | `REGISTRY_NAME`         |
| `image.repository`  | Redis(R) image repository                                                                                | `REPOSITORY_NAME/redis` |
| `image.digest`      | Redis(R) image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag | `""`                    |
| `image.pullPolicy`  | Redis(R) image pull policy                                                                               | `IfNotPresent`          |
| `image.pullSecrets` | Redis(R) image pull secrets                                                                              | `[]`                    |
| `image.debug`       | Enable image debug mode                                                                                  | `false`                 |

### Redis(R) common configuration parameters

| Name                             | Description                                                                               | Value         |
| -------------------------------- | ----------------------------------------------------------------------------------------- | ------------- |
| `architecture`                   | Redis(R) architecture. Allowed values: `standalone` or `replication`                      | `replication` |
| `auth.enabled`                   | Enable password authentication                                                            | `true`        |
| `auth.sentinel`                  | Enable authentication on sentinels too                                                    | `true`        |
| `auth.password`                  | Redis(R) password                                                                         | `""`          |
| `auth.existingSecret`            | The name of an existing secret with Redis(R) credentials                                  | `""`          |
| `auth.existingSecretPasswordKey` | Password key to be retrieved from existing secret                                         | `""`          |
| `auth.usePasswordFiles`          | Mount credentials as files instead of using an environment variable                       | `true`        |
| `auth.usePasswordFileFromSecret` | Mount password file from secret                                                           | `true`        |
| `auth.acl.enabled`               | Enables the support of the Redis ACL system                                               | `false`       |
| `auth.acl.sentinel`              | Enables the support of the Redis ACL system for Sentinel Nodes                            | `false`       |
| `auth.acl.users`                 | A list of the configured users in the Redis ACL system                                    | `[]`          |
| `auth.acl.userSecret`            | Name of the Secret, containing user credentials for ACL users. Keys must match usernames. | `""`          |
| `commonConfiguration`            | Common configuration to be added into the ConfigMap                                       | `""`          |
| `existingConfigmap`              | The name of an existing ConfigMap with your custom configuration for Redis(R) nodes       | `""`          |

### Redis(R) master configuration parameters

| Name                                                       | Description                                                                                                                                                                                                                     | Value                    |
| ---------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `master.count`                                             | Number of Redis(R) master instances to deploy (experimental, requires additional configuration)                                                                                                                                 | `1`                      |
| `master.revisionHistoryLimit`                              | The number of old history to retain to allow rollback                                                                                                                                                                           | `10`                     |
| `master.configuration`                                     | Configuration for Redis(R) master nodes                                                                                                                                                                                         | `""`                     |
| `master.disableCommands`                                   | Array with Redis(R) commands to disable on master nodes                                                                                                                                                                         | `["FLUSHDB","FLUSHALL"]` |
| `master.command`                                           | Override default container command (useful when using custom images)                                                                                                                                                            | `[]`                     |
| `master.args`                                              | Override default container args (useful when using custom images)                                                                                                                                                               | `[]`                     |
| `master.enableServiceLinks`                                | Whether information about services should be injected into pod's environment variable                                                                                                                                           | `true`                   |
| `master.preExecCmds`                                       | Additional commands to run prior to starting Redis(R) master                                                                                                                                                                    | `[]`                     |
| `master.extraFlags`                                        | Array with additional command line flags for Redis(R) master                                                                                                                                                                    | `[]`                     |
| `master.extraEnvVars`                                      | Array with extra environment variables to add to Redis(R) master nodes                                                                                                                                                          | `[]`                     |
| `master.extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for Redis(R) master nodes                                                                                                                                                  | `""`                     |
| `master.extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for Redis(R) master nodes                                                                                                                                                     | `""`                     |
| `master.containerPorts.redis`                              | Container port to open on Redis(R) master nodes                                                                                                                                                                                 | `6379`                   |
| `master.startupProbe.enabled`                              | Enable startupProbe on Redis(R) master nodes                                                                                                                                                                                    | `false`                  |
| `master.startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                                          | `20`                     |
| `master.startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                                 | `5`                      |
| `master.startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                                | `5`                      |
| `master.startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                              | `5`                      |
| `master.startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                              | `1`                      |
| `master.livenessProbe.enabled`                             | Enable livenessProbe on Redis(R) master nodes                                                                                                                                                                                   | `true`                   |
| `master.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                                         | `20`                     |
| `master.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                                | `5`                      |
| `master.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                               | `5`                      |
| `master.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                                             | `5`                      |
| `master.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                                             | `1`                      |
| `master.readinessProbe.enabled`                            | Enable readinessProbe on Redis(R) master nodes                                                                                                                                                                                  | `true`                   |
| `master.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                                        | `20`                     |
| `master.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                               | `5`                      |
| `master.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                              | `1`                      |
| `master.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                                            | `5`                      |
| `master.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                                            | `1`                      |
| `master.customStartupProbe`                                | Custom startupProbe that overrides the default one                                                                                                                                                                              | `{}`                     |
| `master.customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                                                                                                                             | `{}`                     |
| `master.customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                                                                                                                                            | `{}`                     |
| `master.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if master.resources is set (master.resources is recommended for production). | `nano`                   |
| `master.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                               | `{}`                     |
| `master.podSecurityContext.enabled`                        | Enabled Redis(R) master pods' Security Context                                                                                                                                                                                  | `true`                   |
| `master.podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                              | `Always`                 |
| `master.podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                                  | `[]`                     |
| `master.podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                                     | `[]`                     |
| `master.podSecurityContext.fsGroup`                        | Set Redis(R) master pod's Security Context fsGroup                                                                                                                                                                              | `1001`                   |
| `master.containerSecurityContext.enabled`                  | Enabled Redis(R) master containers' Security Context                                                                                                                                                                            | `true`                   |
| `master.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                                | `{}`                     |
| `master.containerSecurityContext.runAsUser`                | Set Redis(R) master containers' Security Context runAsUser                                                                                                                                                                      | `1001`                   |
| `master.containerSecurityContext.runAsGroup`               | Set Redis(R) master containers' Security Context runAsGroup                                                                                                                                                                     | `1001`                   |
| `master.containerSecurityContext.runAsNonRoot`             | Set Redis(R) master containers' Security Context runAsNonRoot                                                                                                                                                                   | `true`                   |
| `master.containerSecurityContext.allowPrivilegeEscalation` | Is it possible to escalate Redis(R) pod(s) privileges                                                                                                                                                                           | `false`                  |
| `master.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context read-only root filesystem                                                                                                                                                                      | `true`                   |
| `master.containerSecurityContext.seccompProfile.type`      | Set Redis(R) master containers' Security Context seccompProfile                                                                                                                                                                 | `RuntimeDefault`         |
| `master.containerSecurityContext.capabilities.drop`        | Set Redis(R) master containers' Security Context capabilities to drop                                                                                                                                                           | `["ALL"]`                |
| `master.kind`                                              | Use either Deployment, StatefulSet (default) or DaemonSet                                                                                                                                                                       | `StatefulSet`            |
| `master.schedulerName`                                     | Alternate scheduler for Redis(R) master pods                                                                                                                                                                                    | `""`                     |
| `master.updateStrategy.type`                               | Redis(R) master statefulset strategy type                                                                                                                                                                                       | `RollingUpdate`          |
| `master.minReadySeconds`                                   | How many seconds a pod needs to be ready before killing the next, during update                                                                                                                                                 | `0`                      |
| `master.priorityClassName`                                 | Redis(R) master pods' priorityClassName                                                                                                                                                                                         | `""`                     |
| `master.automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                              | `false`                  |
| `master.hostAliases`                                       | Redis(R) master pods host aliases                                                                                                                                                                                               | `[]`                     |
| `master.podLabels`                                         | Extra labels for Redis(R) master pods                                                                                                                                                                                           | `{}`                     |
| `master.podAnnotations`                                    | Annotations for Redis(R) master pods                                                                                                                                                                                            | `{}`                     |
| `master.shareProcessNamespace`                             | Share a single process namespace between all of the containers in Redis(R) master pods                                                                                                                                          | `false`                  |
| `master.podAffinityPreset`                                 | Pod affinity preset. Ignored if `master.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                      | `""`                     |
| `master.podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `master.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                 | `soft`                   |
| `master.nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `master.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                | `""`                     |
| `master.nodeAffinityPreset.key`                            | Node label key to match. Ignored if `master.affinity` is set                                                                                                                                                                    | `""`                     |
| `master.nodeAffinityPreset.values`                         | Node label values to match. Ignored if `master.affinity` is set                                                                                                                                                                 | `[]`                     |
| `master.affinity`                                          | Affinity for Redis(R) master pods assignment                                                                                                                                                                                    | `{}`                     |
| `master.nodeSelector`                                      | Node labels for Redis(R) master pods assignment                                                                                                                                                                                 | `{}`                     |
| `master.tolerations`                                       | Tolerations for Redis(R) master pods assignment                                                                                                                                                                                 | `[]`                     |
| `master.topologySpreadConstraints`                         | Spread Constraints for Redis(R) master pod assignment                                                                                                                                                                           | `[]`                     |
| `master.dnsPolicy`                                         | DNS Policy for Redis(R) master pod                                                                                                                                                                                              | `""`                     |
| `master.dnsConfig`                                         | DNS Configuration for Redis(R) master pod                                                                                                                                                                                       | `{}`                     |
| `master.lifecycleHooks`                                    | for the Redis(R) master container(s) to automate configuration before or after startup                                                                                                                                          | `{}`                     |
| `master.extraVolumes`                                      | Optionally specify extra list of additional volumes for the Redis(R) master pod(s)                                                                                                                                              | `[]`                     |
| `master.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the Redis(R) master container(s)                                                                                                                                   | `[]`                     |
| `master.sidecars`                                          | Add additional sidecar containers to the Redis(R) master pod(s)                                                                                                                                                                 | `[]`                     |
| `master.initContainers`                                    | Add additional init containers to the Redis(R) master pod(s)                                                                                                                                                                    | `[]`                     |
| `master.persistence.enabled`                               | Enable persistence on Redis(R) master nodes using Persistent Volume Claims                                                                                                                                                      | `true`                   |
| `master.persistence.medium`                                | Provide a medium for `emptyDir` volumes.                                                                                                                                                                                        | `""`                     |
| `master.persistence.sizeLimit`                             | Set this to enable a size limit for `emptyDir` volumes.                                                                                                                                                                         | `""`                     |
| `master.persistence.path`                                  | The path the volume will be mounted at on Redis(R) master containers                                                                                                                                                            | `/data`                  |
| `master.persistence.subPath`                               | The subdirectory of the volume to mount on Redis(R) master containers                                                                                                                                                           | `""`                     |
| `master.persistence.subPathExpr`                           | Used to construct the subPath subdirectory of the volume to mount on Redis(R) master containers                                                                                                                                 | `""`                     |
| `master.persistence.storageClass`                          | Persistent Volume storage class                                                                                                                                                                                                 | `""`                     |
| `master.persistence.accessModes`                           | Persistent Volume access modes                                                                                                                                                                                                  | `["ReadWriteOnce"]`      |
| `master.persistence.size`                                  | Persistent Volume size                                                                                                                                                                                                          | `8Gi`                    |
| `master.persistence.annotations`                           | Additional custom annotations for the PVC                                                                                                                                                                                       | `{}`                     |
| `master.persistence.labels`                                | Additional custom labels for the PVC                                                                                                                                                                                            | `{}`                     |
| `master.persistence.selector`                              | Additional labels to match for the PVC                                                                                                                                                                                          | `{}`                     |
| `master.persistence.dataSource`                            | Custom PVC data source                                                                                                                                                                                                          | `{}`                     |
| `master.persistence.existingClaim`                         | Use a existing PVC which must be created manually before bound                                                                                                                                                                  | `""`                     |
| `master.persistentVolumeClaimRetentionPolicy.enabled`      | Controls if and how PVCs are deleted during the lifecycle of a StatefulSet                                                                                                                                                      | `false`                  |
| `master.persistentVolumeClaimRetentionPolicy.whenScaled`   | Volume retention behavior when the replica count of the StatefulSet is reduced                                                                                                                                                  | `Retain`                 |
| `master.persistentVolumeClaimRetentionPolicy.whenDeleted`  | Volume retention behavior that applies when the StatefulSet is deleted                                                                                                                                                          | `Retain`                 |
| `master.service.type`                                      | Redis(R) master service type                                                                                                                                                                                                    | `ClusterIP`              |
| `master.service.portNames.redis`                           | Redis(R) master service port name                                                                                                                                                                                               | `tcp-redis`              |
| `master.service.ports.redis`                               | Redis(R) master service port                                                                                                                                                                                                    | `6379`                   |
| `master.service.nodePorts.redis`                           | Node port for Redis(R) master                                                                                                                                                                                                   | `""`                     |
| `master.service.externalTrafficPolicy`                     | Redis(R) master service external traffic policy                                                                                                                                                                                 | `Cluster`                |
| `master.service.extraPorts`                                | Extra ports to expose (normally used with the `sidecar` value)                                                                                                                                                                  | `[]`                     |
| `master.service.internalTrafficPolicy`                     | Redis(R) master service internal traffic policy (requires Kubernetes v1.22 or greater to be usable)                                                                                                                             | `Cluster`                |
| `master.service.clusterIP`                                 | Redis(R) master service Cluster IP                                                                                                                                                                                              | `""`                     |
| `master.service.loadBalancerIP`                            | Redis(R) master service Load Balancer IP                                                                                                                                                                                        | `""`                     |
| `master.service.loadBalancerClass`                         | master service Load Balancer class if service type is `LoadBalancer` (optional, cloud specific)                                                                                                                                 | `""`                     |
| `master.service.loadBalancerSourceRanges`                  | Redis(R) master service Load Balancer sources                                                                                                                                                                                   | `[]`                     |
| `master.service.externalIPs`                               | Redis(R) master service External IPs                                                                                                                                                                                            | `[]`                     |
| `master.service.annotations`                               | Additional custom annotations for Redis(R) master service                                                                                                                                                                       | `{}`                     |
| `master.service.sessionAffinity`                           | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                                                                                                                                                            | `None`                   |
| `master.service.sessionAffinityConfig`                     | Additional settings for the sessionAffinity                                                                                                                                                                                     | `{}`                     |
| `master.terminationGracePeriodSeconds`                     | Integer setting the termination grace period for the redis-master pods                                                                                                                                                          | `30`                     |
| `master.serviceAccount.create`                             | Specifies whether a ServiceAccount should be created                                                                                                                                                                            | `true`                   |
| `master.serviceAccount.name`                               | The name of the ServiceAccount to use.                                                                                                                                                                                          | `""`                     |
| `master.serviceAccount.automountServiceAccountToken`       | Whether to auto mount the service account token                                                                                                                                                                                 | `false`                  |
| `master.serviceAccount.annotations`                        | Additional custom annotations for the ServiceAccount                                                                                                                                                                            | `{}`                     |
| `master.pdb.create`                                        | Enable/disable a Pod Disruption Budget creation                                                                                                                                                                                 | `true`                   |
| `master.pdb.minAvailable`                                  | Minimum number/percentage of pods that should remain scheduled                                                                                                                                                                  | `{}`                     |
| `master.pdb.maxUnavailable`                                | Maximum number/percentage of pods that may be made unavailable. Defaults to `1` if both `master.pdb.minAvailable` and `master.pdb.maxUnavailable` are empty.                                                                    | `{}`                     |
| `master.extraPodSpec`                                      | Optionally specify extra PodSpec for the Redis(R) master pod(s)                                                                                                                                                                 | `{}`                     |
| `master.annotations`                                       | Additional custom annotations for Redis(R) Master resource                                                                                                                                                                      | `{}`                     |

### Redis(R) replicas configuration parameters

| Name                                                        | Description                                                                                                                                                                                                                       | Value                    |
| ----------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `replica.kind`                                              | Use either DaemonSet or StatefulSet (default)                                                                                                                                                                                     | `StatefulSet`            |
| `replica.replicaCount`                                      | Number of Redis(R) replicas to deploy                                                                                                                                                                                             | `3`                      |
| `replica.revisionHistoryLimit`                              | The number of old history to retain to allow rollback                                                                                                                                                                             | `10`                     |
| `replica.configuration`                                     | Configuration for Redis(R) replicas nodes                                                                                                                                                                                         | `""`                     |
| `replica.disableCommands`                                   | Array with Redis(R) commands to disable on replicas nodes                                                                                                                                                                         | `["FLUSHDB","FLUSHALL"]` |
| `replica.command`                                           | Override default container command (useful when using custom images)                                                                                                                                                              | `[]`                     |
| `replica.args`                                              | Override default container args (useful when using custom images)                                                                                                                                                                 | `[]`                     |
| `replica.enableServiceLinks`                                | Whether information about services should be injected into pod's environment variable                                                                                                                                             | `true`                   |
| `replica.preExecCmds`                                       | Additional commands to run prior to starting Redis(R) replicas                                                                                                                                                                    | `[]`                     |
| `replica.extraFlags`                                        | Array with additional command line flags for Redis(R) replicas                                                                                                                                                                    | `[]`                     |
| `replica.extraEnvVars`                                      | Array with extra environment variables to add to Redis(R) replicas nodes                                                                                                                                                          | `[]`                     |
| `replica.extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for Redis(R) replicas nodes                                                                                                                                                  | `""`                     |
| `replica.extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for Redis(R) replicas nodes                                                                                                                                                     | `""`                     |
| `replica.externalMaster.enabled`                            | Use external master for bootstrapping                                                                                                                                                                                             | `false`                  |
| `replica.externalMaster.host`                               | External master host to bootstrap from                                                                                                                                                                                            | `""`                     |
| `replica.externalMaster.port`                               | Port for Redis service external master host                                                                                                                                                                                       | `6379`                   |
| `replica.containerPorts.redis`                              | Container port to open on Redis(R) replicas nodes                                                                                                                                                                                 | `6379`                   |
| `replica.startupProbe.enabled`                              | Enable startupProbe on Redis(R) replicas nodes                                                                                                                                                                                    | `true`                   |
| `replica.startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                                            | `10`                     |
| `replica.startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                                   | `10`                     |
| `replica.startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                                  | `5`                      |
| `replica.startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                                | `22`                     |
| `replica.startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                                | `1`                      |
| `replica.livenessProbe.enabled`                             | Enable livenessProbe on Redis(R) replicas nodes                                                                                                                                                                                   | `true`                   |
| `replica.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                                           | `20`                     |
| `replica.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                                  | `5`                      |
| `replica.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                                 | `5`                      |
| `replica.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                                               | `5`                      |
| `replica.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                                               | `1`                      |
| `replica.readinessProbe.enabled`                            | Enable readinessProbe on Redis(R) replicas nodes                                                                                                                                                                                  | `true`                   |
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
| `replica.podSecurityContext.enabled`                        | Enabled Redis(R) replicas pods' Security Context                                                                                                                                                                                  | `true`                   |
| `replica.podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                                | `Always`                 |
| `replica.podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                                    | `[]`                     |
| `replica.podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                                       | `[]`                     |
| `replica.podSecurityContext.fsGroup`                        | Set Redis(R) replicas pod's Security Context fsGroup                                                                                                                                                                              | `1001`                   |
| `replica.containerSecurityContext.enabled`                  | Enabled Redis(R) replicas containers' Security Context                                                                                                                                                                            | `true`                   |
| `replica.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                                  | `{}`                     |
| `replica.containerSecurityContext.runAsUser`                | Set Redis(R) replicas containers' Security Context runAsUser                                                                                                                                                                      | `1001`                   |
| `replica.containerSecurityContext.runAsGroup`               | Set Redis(R) replicas containers' Security Context runAsGroup                                                                                                                                                                     | `1001`                   |
| `replica.containerSecurityContext.runAsNonRoot`             | Set Redis(R) replicas containers' Security Context runAsNonRoot                                                                                                                                                                   | `true`                   |
| `replica.containerSecurityContext.allowPrivilegeEscalation` | Set Redis(R) replicas pod's Security Context allowPrivilegeEscalation                                                                                                                                                             | `false`                  |
| `replica.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context read-only root filesystem                                                                                                                                                                        | `true`                   |
| `replica.containerSecurityContext.seccompProfile.type`      | Set Redis(R) replicas containers' Security Context seccompProfile                                                                                                                                                                 | `RuntimeDefault`         |
| `replica.containerSecurityContext.capabilities.drop`        | Set Redis(R) replicas containers' Security Context capabilities to drop                                                                                                                                                           | `["ALL"]`                |
| `replica.schedulerName`                                     | Alternate scheduler for Redis(R) replicas pods                                                                                                                                                                                    | `""`                     |
| `replica.updateStrategy.type`                               | Redis(R) replicas statefulset strategy type                                                                                                                                                                                       | `RollingUpdate`          |
| `replica.minReadySeconds`                                   | How many seconds a pod needs to be ready before killing the next, during update                                                                                                                                                   | `0`                      |
| `replica.priorityClassName`                                 | Redis(R) replicas pods' priorityClassName                                                                                                                                                                                         | `""`                     |
| `replica.podManagementPolicy`                               | podManagementPolicy to manage scaling operation of %%MAIN_CONTAINER_NAME%% pods                                                                                                                                                   | `""`                     |
| `replica.automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                                | `false`                  |
| `replica.hostAliases`                                       | Redis(R) replicas pods host aliases                                                                                                                                                                                               | `[]`                     |
| `replica.podLabels`                                         | Extra labels for Redis(R) replicas pods                                                                                                                                                                                           | `{}`                     |
| `replica.podAnnotations`                                    | Annotations for Redis(R) replicas pods                                                                                                                                                                                            | `{}`                     |
| `replica.shareProcessNamespace`                             | Share a single process namespace between all of the containers in Redis(R) replicas pods                                                                                                                                          | `false`                  |
| `replica.podAffinityPreset`                                 | Pod affinity preset. Ignored if `replica.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                       | `""`                     |
| `replica.podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `replica.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                  | `soft`                   |
| `replica.nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `replica.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                 | `""`                     |
| `replica.nodeAffinityPreset.key`                            | Node label key to match. Ignored if `replica.affinity` is set                                                                                                                                                                     | `""`                     |
| `replica.nodeAffinityPreset.values`                         | Node label values to match. Ignored if `replica.affinity` is set                                                                                                                                                                  | `[]`                     |
| `replica.affinity`                                          | Affinity for Redis(R) replicas pods assignment                                                                                                                                                                                    | `{}`                     |
| `replica.nodeSelector`                                      | Node labels for Redis(R) replicas pods assignment                                                                                                                                                                                 | `{}`                     |
| `replica.tolerations`                                       | Tolerations for Redis(R) replicas pods assignment                                                                                                                                                                                 | `[]`                     |
| `replica.topologySpreadConstraints`                         | Spread Constraints for Redis(R) replicas pod assignment                                                                                                                                                                           | `[]`                     |
| `replica.dnsPolicy`                                         | DNS Policy for Redis(R) replica pods                                                                                                                                                                                              | `""`                     |
| `replica.dnsConfig`                                         | DNS Configuration for Redis(R) replica pods                                                                                                                                                                                       | `{}`                     |
| `replica.lifecycleHooks`                                    | for the Redis(R) replica container(s) to automate configuration before or after startup                                                                                                                                           | `{}`                     |
| `replica.extraVolumes`                                      | Optionally specify extra list of additional volumes for the Redis(R) replicas pod(s)                                                                                                                                              | `[]`                     |
| `replica.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the Redis(R) replicas container(s)                                                                                                                                   | `[]`                     |
| `replica.sidecars`                                          | Add additional sidecar containers to the Redis(R) replicas pod(s)                                                                                                                                                                 | `[]`                     |
| `replica.initContainers`                                    | Add additional init containers to the Redis(R) replicas pod(s)                                                                                                                                                                    | `[]`                     |
| `replica.persistence.enabled`                               | Enable persistence on Redis(R) replicas nodes using Persistent Volume Claims                                                                                                                                                      | `true`                   |
| `replica.persistence.medium`                                | Provide a medium for `emptyDir` volumes.                                                                                                                                                                                          | `""`                     |
| `replica.persistence.sizeLimit`                             | Set this to enable a size limit for `emptyDir` volumes.                                                                                                                                                                           | `""`                     |
| `replica.persistence.path`                                  | The path the volume will be mounted at on Redis(R) replicas containers                                                                                                                                                            | `/data`                  |
| `replica.persistence.subPath`                               | The subdirectory of the volume to mount on Redis(R) replicas containers                                                                                                                                                           | `""`                     |
| `replica.persistence.subPathExpr`                           | Used to construct the subPath subdirectory of the volume to mount on Redis(R) replicas containers                                                                                                                                 | `""`                     |
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
| `replica.service.type`                                      | Redis(R) replicas service type                                                                                                                                                                                                    | `ClusterIP`              |
| `replica.service.ports.redis`                               | Redis(R) replicas service port                                                                                                                                                                                                    | `6379`                   |
| `replica.service.nodePorts.redis`                           | Node port for Redis(R) replicas                                                                                                                                                                                                   | `""`                     |
| `replica.service.externalTrafficPolicy`                     | Redis(R) replicas service external traffic policy                                                                                                                                                                                 | `Cluster`                |
| `replica.service.internalTrafficPolicy`                     | Redis(R) replicas service internal traffic policy (requires Kubernetes v1.22 or greater to be usable)                                                                                                                             | `Cluster`                |
| `replica.service.extraPorts`                                | Extra ports to expose (normally used with the `sidecar` value)                                                                                                                                                                    | `[]`                     |
| `replica.service.clusterIP`                                 | Redis(R) replicas service Cluster IP                                                                                                                                                                                              | `""`                     |
| `replica.service.loadBalancerIP`                            | Redis(R) replicas service Load Balancer IP                                                                                                                                                                                        | `""`                     |
| `replica.service.loadBalancerClass`                         | replicas service Load Balancer class if service type is `LoadBalancer` (optional, cloud specific)                                                                                                                                 | `""`                     |
| `replica.service.loadBalancerSourceRanges`                  | Redis(R) replicas service Load Balancer sources                                                                                                                                                                                   | `[]`                     |
| `replica.service.annotations`                               | Additional custom annotations for Redis(R) replicas service                                                                                                                                                                       | `{}`                     |
| `replica.service.sessionAffinity`                           | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                                                                                                                                                              | `None`                   |
| `replica.service.sessionAffinityConfig`                     | Additional settings for the sessionAffinity                                                                                                                                                                                       | `{}`                     |
| `replica.terminationGracePeriodSeconds`                     | Integer setting the termination grace period for the redis-replicas pods                                                                                                                                                          | `30`                     |
| `replica.autoscaling.enabled`                               | Enable replica autoscaling settings                                                                                                                                                                                               | `false`                  |
| `replica.autoscaling.minReplicas`                           | Minimum replicas for the pod autoscaling                                                                                                                                                                                          | `1`                      |
| `replica.autoscaling.maxReplicas`                           | Maximum replicas for the pod autoscaling                                                                                                                                                                                          | `11`                     |
| `replica.autoscaling.targetCPU`                             | Percentage of CPU to consider when autoscaling                                                                                                                                                                                    | `""`                     |
| `replica.autoscaling.targetMemory`                          | Percentage of Memory to consider when autoscaling                                                                                                                                                                                 | `""`                     |
| `replica.serviceAccount.create`                             | Specifies whether a ServiceAccount should be created                                                                                                                                                                              | `true`                   |
| `replica.serviceAccount.name`                               | The name of the ServiceAccount to use.                                                                                                                                                                                            | `""`                     |
| `replica.serviceAccount.automountServiceAccountToken`       | Whether to auto mount the service account token                                                                                                                                                                                   | `false`                  |
| `replica.serviceAccount.annotations`                        | Additional custom annotations for the ServiceAccount                                                                                                                                                                              | `{}`                     |
| `replica.pdb.create`                                        | Enable/disable a Pod Disruption Budget creation                                                                                                                                                                                   | `true`                   |
| `replica.pdb.minAvailable`                                  | Minimum number/percentage of pods that should remain scheduled                                                                                                                                                                    | `{}`                     |
| `replica.pdb.maxUnavailable`                                | Maximum number/percentage of pods that may be made unavailable. Defaults to `1` if both `replica.pdb.minAvailable` and `replica.pdb.maxUnavailable` are empty.                                                                    | `{}`                     |
| `replica.extraPodSpec`                                      | Optionally specify extra PodSpec for the Redis(R) replicas pod(s)                                                                                                                                                                 | `{}`                     |
| `replica.annotations`                                       | Additional custom annotations for Redis(R) replicas resource                                                                                                                                                                      | `{}`                     |

### Redis(R) Sentinel configuration parameters

| Name                                                         | Description                                                                                                                                                                                                                         | Value                            |
| ------------------------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------- |
| `sentinel.enabled`                                           | Use Redis(R) Sentinel on Redis(R) pods.                                                                                                                                                                                             | `false`                          |
| `sentinel.image.registry`                                    | Redis(R) Sentinel image registry                                                                                                                                                                                                    | `REGISTRY_NAME`                  |
| `sentinel.image.repository`                                  | Redis(R) Sentinel image repository                                                                                                                                                                                                  | `REPOSITORY_NAME/redis-sentinel` |
| `sentinel.image.digest`                                      | Redis(R) Sentinel image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                   | `""`                             |
| `sentinel.image.pullPolicy`                                  | Redis(R) Sentinel image pull policy                                                                                                                                                                                                 | `IfNotPresent`                   |
| `sentinel.image.pullSecrets`                                 | Redis(R) Sentinel image pull secrets                                                                                                                                                                                                | `[]`                             |
| `sentinel.image.debug`                                       | Enable image debug mode                                                                                                                                                                                                             | `false`                          |
| `sentinel.annotations`                                       | Additional custom annotations for Redis(R) Sentinel resource                                                                                                                                                                        | `{}`                             |
| `sentinel.masterSet`                                         | Master set name                                                                                                                                                                                                                     | `mymaster`                       |
| `sentinel.quorum`                                            | Sentinel Quorum                                                                                                                                                                                                                     | `2`                              |
| `sentinel.getMasterTimeout`                                  | Amount of time to allow before get_sentinel_master_info() times out.                                                                                                                                                                | `90`                             |
| `sentinel.automateClusterRecovery`                           | Automate cluster recovery in cases where the last replica is not considered a good replica and Sentinel won't automatically failover to it.                                                                                         | `false`                          |
| `sentinel.redisShutdownWaitFailover`                         | Whether the Redis(R) master container waits for the failover at shutdown (in addition to the Redis(R) Sentinel container).                                                                                                          | `true`                           |
| `sentinel.downAfterMilliseconds`                             | Timeout for detecting a Redis(R) node is down                                                                                                                                                                                       | `60000`                          |
| `sentinel.failoverTimeout`                                   | Timeout for performing a election failover                                                                                                                                                                                          | `180000`                         |
| `sentinel.parallelSyncs`                                     | Number of replicas that can be reconfigured in parallel to use the new master after a failover                                                                                                                                      | `1`                              |
| `sentinel.configuration`                                     | Configuration for Redis(R) Sentinel nodes                                                                                                                                                                                           | `""`                             |
| `sentinel.command`                                           | Override default container command (useful when using custom images)                                                                                                                                                                | `[]`                             |
| `sentinel.args`                                              | Override default container args (useful when using custom images)                                                                                                                                                                   | `[]`                             |
| `sentinel.enableServiceLinks`                                | Whether information about services should be injected into pod's environment variable                                                                                                                                               | `true`                           |
| `sentinel.preExecCmds`                                       | Additional commands to run prior to starting Redis(R) Sentinel                                                                                                                                                                      | `[]`                             |
| `sentinel.extraEnvVars`                                      | Array with extra environment variables to add to Redis(R) Sentinel nodes                                                                                                                                                            | `[]`                             |
| `sentinel.extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for Redis(R) Sentinel nodes                                                                                                                                                    | `""`                             |
| `sentinel.extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for Redis(R) Sentinel nodes                                                                                                                                                       | `""`                             |
| `sentinel.externalMaster.enabled`                            | Use external master for bootstrapping                                                                                                                                                                                               | `false`                          |
| `sentinel.externalMaster.host`                               | External master host to bootstrap from                                                                                                                                                                                              | `""`                             |
| `sentinel.externalMaster.port`                               | Port for Redis service external master host                                                                                                                                                                                         | `6379`                           |
| `sentinel.containerPorts.sentinel`                           | Container port to open on Redis(R) Sentinel nodes                                                                                                                                                                                   | `26379`                          |
| `sentinel.startupProbe.enabled`                              | Enable startupProbe on Redis(R) Sentinel nodes                                                                                                                                                                                      | `true`                           |
| `sentinel.startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                                              | `10`                             |
| `sentinel.startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                                     | `10`                             |
| `sentinel.startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                                    | `5`                              |
| `sentinel.startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                                  | `22`                             |
| `sentinel.startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                                  | `1`                              |
| `sentinel.livenessProbe.enabled`                             | Enable livenessProbe on Redis(R) Sentinel nodes                                                                                                                                                                                     | `true`                           |
| `sentinel.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                                             | `20`                             |
| `sentinel.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                                    | `10`                             |
| `sentinel.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                                   | `5`                              |
| `sentinel.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                                                 | `6`                              |
| `sentinel.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                                                 | `1`                              |
| `sentinel.readinessProbe.enabled`                            | Enable readinessProbe on Redis(R) Sentinel nodes                                                                                                                                                                                    | `true`                           |
| `sentinel.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                                            | `20`                             |
| `sentinel.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                                   | `5`                              |
| `sentinel.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                                  | `1`                              |
| `sentinel.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                                                | `6`                              |
| `sentinel.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                                                | `1`                              |
| `sentinel.customStartupProbe`                                | Custom startupProbe that overrides the default one                                                                                                                                                                                  | `{}`                             |
| `sentinel.customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                                                                                                                                 | `{}`                             |
| `sentinel.customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                                                                                                                                                | `{}`                             |
| `sentinel.persistence.enabled`                               | Enable persistence on Redis(R) sentinel nodes using Persistent Volume Claims (Experimental)                                                                                                                                         | `false`                          |
| `sentinel.persistence.storageClass`                          | Persistent Volume storage class                                                                                                                                                                                                     | `""`                             |
| `sentinel.persistence.accessModes`                           | Persistent Volume access modes                                                                                                                                                                                                      | `["ReadWriteOnce"]`              |
| `sentinel.persistence.size`                                  | Persistent Volume size                                                                                                                                                                                                              | `100Mi`                          |
| `sentinel.persistence.annotations`                           | Additional custom annotations for the PVC                                                                                                                                                                                           | `{}`                             |
| `sentinel.persistence.labels`                                | Additional custom labels for the PVC                                                                                                                                                                                                | `{}`                             |
| `sentinel.persistence.selector`                              | Additional labels to match for the PVC                                                                                                                                                                                              | `{}`                             |
| `sentinel.persistence.dataSource`                            | Custom PVC data source                                                                                                                                                                                                              | `{}`                             |
| `sentinel.persistence.medium`                                | Provide a medium for `emptyDir` volumes.                                                                                                                                                                                            | `""`                             |
| `sentinel.persistence.sizeLimit`                             | Set this to enable a size limit for `emptyDir` volumes.                                                                                                                                                                             | `""`                             |
| `sentinel.persistentVolumeClaimRetentionPolicy.enabled`      | Controls if and how PVCs are deleted during the lifecycle of a StatefulSet                                                                                                                                                          | `false`                          |
| `sentinel.persistentVolumeClaimRetentionPolicy.whenScaled`   | Volume retention behavior when the replica count of the StatefulSet is reduced                                                                                                                                                      | `Retain`                         |
| `sentinel.persistentVolumeClaimRetentionPolicy.whenDeleted`  | Volume retention behavior that applies when the StatefulSet is deleted                                                                                                                                                              | `Retain`                         |
| `sentinel.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if sentinel.resources is set (sentinel.resources is recommended for production). | `nano`                           |
| `sentinel.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                   | `{}`                             |
| `sentinel.containerSecurityContext.enabled`                  | Enabled Redis(R) Sentinel containers' Security Context                                                                                                                                                                              | `true`                           |
| `sentinel.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                                    | `{}`                             |
| `sentinel.containerSecurityContext.runAsUser`                | Set Redis(R) Sentinel containers' Security Context runAsUser                                                                                                                                                                        | `1001`                           |
| `sentinel.containerSecurityContext.runAsGroup`               | Set Redis(R) Sentinel containers' Security Context runAsGroup                                                                                                                                                                       | `1001`                           |
| `sentinel.containerSecurityContext.runAsNonRoot`             | Set Redis(R) Sentinel containers' Security Context runAsNonRoot                                                                                                                                                                     | `true`                           |
| `sentinel.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context read-only root filesystem                                                                                                                                                                          | `true`                           |
| `sentinel.containerSecurityContext.allowPrivilegeEscalation` | Set Redis(R) Sentinel containers' Security Context allowPrivilegeEscalation                                                                                                                                                         | `false`                          |
| `sentinel.containerSecurityContext.seccompProfile.type`      | Set Redis(R) Sentinel containers' Security Context seccompProfile                                                                                                                                                                   | `RuntimeDefault`                 |
| `sentinel.containerSecurityContext.capabilities.drop`        | Set Redis(R) Sentinel containers' Security Context capabilities to drop                                                                                                                                                             | `["ALL"]`                        |
| `sentinel.lifecycleHooks`                                    | for the Redis(R) sentinel container(s) to automate configuration before or after startup                                                                                                                                            | `{}`                             |
| `sentinel.extraVolumes`                                      | Optionally specify extra list of additional volumes for the Redis(R) Sentinel                                                                                                                                                       | `[]`                             |
| `sentinel.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the Redis(R) Sentinel container(s)                                                                                                                                     | `[]`                             |
| `sentinel.service.type`                                      | Redis(R) Sentinel service type                                                                                                                                                                                                      | `ClusterIP`                      |
| `sentinel.service.ports.redis`                               | Redis(R) service port for Redis(R)                                                                                                                                                                                                  | `6379`                           |
| `sentinel.service.ports.sentinel`                            | Redis(R) service port for Redis(R) Sentinel                                                                                                                                                                                         | `26379`                          |
| `sentinel.service.nodePorts.redis`                           | Node port for Redis(R)                                                                                                                                                                                                              | `""`                             |
| `sentinel.service.nodePorts.sentinel`                        | Node port for Sentinel                                                                                                                                                                                                              | `""`                             |
| `sentinel.service.externalTrafficPolicy`                     | Redis(R) Sentinel service external traffic policy                                                                                                                                                                                   | `Cluster`                        |
| `sentinel.service.extraPorts`                                | Extra ports to expose (normally used with the `sidecar` value)                                                                                                                                                                      | `[]`                             |
| `sentinel.service.clusterIP`                                 | Redis(R) Sentinel service Cluster IP                                                                                                                                                                                                | `""`                             |
| `sentinel.service.createMaster`                              | Enable master service pointing to the current master (experimental)                                                                                                                                                                 | `false`                          |
| `sentinel.service.loadBalancerIP`                            | Redis(R) Sentinel service Load Balancer IP                                                                                                                                                                                          | `""`                             |
| `sentinel.service.loadBalancerClass`                         | sentinel service Load Balancer class if service type is `LoadBalancer` (optional, cloud specific)                                                                                                                                   | `""`                             |
| `sentinel.service.loadBalancerSourceRanges`                  | Redis(R) Sentinel service Load Balancer sources                                                                                                                                                                                     | `[]`                             |
| `sentinel.service.annotations`                               | Additional custom annotations for Redis(R) Sentinel service                                                                                                                                                                         | `{}`                             |
| `sentinel.service.sessionAffinity`                           | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                                                                                                                                                                | `None`                           |
| `sentinel.service.sessionAffinityConfig`                     | Additional settings for the sessionAffinity                                                                                                                                                                                         | `{}`                             |
| `sentinel.service.headless.annotations`                      | Annotations for the headless service.                                                                                                                                                                                               | `{}`                             |
| `sentinel.service.headless.extraPorts`                       | Optionally specify extra ports to expose for the headless service.                                                                                                                                                                  | `[]`                             |
| `sentinel.masterService.enabled`                             | Enable master service pointing to the current master (experimental)                                                                                                                                                                 | `false`                          |
| `sentinel.masterService.type`                                | Redis(R) Sentinel master service type                                                                                                                                                                                               | `ClusterIP`                      |
| `sentinel.masterService.ports.redis`                         | Redis(R) service port for Redis(R)                                                                                                                                                                                                  | `6379`                           |
| `sentinel.masterService.nodePorts.redis`                     | Node port for Redis(R)                                                                                                                                                                                                              | `""`                             |
| `sentinel.masterService.externalTrafficPolicy`               | Redis(R) master service external traffic policy                                                                                                                                                                                     | `""`                             |
| `sentinel.masterService.extraPorts`                          | Extra ports to expose (normally used with the `sidecar` value)                                                                                                                                                                      | `[]`                             |
| `sentinel.masterService.clusterIP`                           | Redis(R) master service Cluster IP                                                                                                                                                                                                  | `""`                             |
| `sentinel.masterService.loadBalancerIP`                      | Redis(R) master service Load Balancer IP                                                                                                                                                                                            | `""`                             |
| `sentinel.masterService.loadBalancerClass`                   | master service Load Balancer class if service type is `LoadBalancer` (optional, cloud specific)                                                                                                                                     | `""`                             |
| `sentinel.masterService.loadBalancerSourceRanges`            | Redis(R) master service Load Balancer sources                                                                                                                                                                                       | `[]`                             |
| `sentinel.masterService.annotations`                         | Additional custom annotations for Redis(R) master service                                                                                                                                                                           | `{}`                             |
| `sentinel.masterService.sessionAffinity`                     | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                                                                                                                                                                | `None`                           |
| `sentinel.masterService.sessionAffinityConfig`               | Additional settings for the sessionAffinity                                                                                                                                                                                         | `{}`                             |
| `sentinel.terminationGracePeriodSeconds`                     | Integer setting the termination grace period for the redis-node pods                                                                                                                                                                | `30`                             |
| `sentinel.extraPodSpec`                                      | Optionally specify extra PodSpec for the Redis(R) Sentinel pod(s)                                                                                                                                                                   | `{}`                             |
| `sentinel.externalAccess.enabled`                            | Enable external access to the Redis                                                                                                                                                                                                 | `false`                          |
| `sentinel.externalAccess.service.loadBalancerIPAnnotaion`    | Name of annotation to specify fixed IP for service in.                                                                                                                                                                              | `""`                             |
| `sentinel.externalAccess.service.type`                       | Type for the services used to expose every Pod                                                                                                                                                                                      | `LoadBalancer`                   |
| `sentinel.externalAccess.service.redisPort`                  | Port for the services used to expose redis-server                                                                                                                                                                                   | `6379`                           |
| `sentinel.externalAccess.service.sentinelPort`               | Port for the services used to expose redis-sentinel                                                                                                                                                                                 | `26379`                          |
| `sentinel.externalAccess.service.loadBalancerIP`             | Array of load balancer IPs for each Redis(R) node. Length must be the same as sentinel.replicaCount                                                                                                                                 | `[]`                             |
| `sentinel.externalAccess.service.loadBalancerClass`          | Load Balancer class if service type is `LoadBalancer` (optional, cloud specific)                                                                                                                                                    | `""`                             |
| `sentinel.externalAccess.service.loadBalancerSourceRanges`   | Service Load Balancer sources                                                                                                                                                                                                       | `[]`                             |
| `sentinel.externalAccess.service.annotations`                | Annotations to add to the services used to expose every Pod of the Redis(R) Cluster                                                                                                                                                 | `{}`                             |

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
| `pdb`                                           | DEPRECATED Please use `master.pdb` and `replica.pdb` values instead                                                                         | `{}`    |
| `tls.enabled`                                   | Enable TLS traffic                                                                                                                          | `false` |
| `tls.authClients`                               | Require clients to authenticate                                                                                                             | `true`  |
| `tls.autoGenerated`                             | Enable autogenerated certificates                                                                                                           | `false` |
| `tls.existingSecret`                            | The name of the existing secret that contains the TLS certificates                                                                          | `""`    |
| `tls.certificatesSecret`                        | DEPRECATED. Use existingSecret instead.                                                                                                     | `""`    |
| `tls.certFilename`                              | Certificate filename                                                                                                                        | `""`    |
| `tls.certKeyFilename`                           | Certificate Key filename                                                                                                                    | `""`    |
| `tls.certCAFilename`                            | CA Certificate filename                                                                                                                     | `""`    |
| `tls.dhParamsFilename`                          | File containing DH params (in order to support DH based ciphers)                                                                            | `""`    |

### Metrics Parameters

| Name                                                        | Description                                                                                                                                                                                                                       | Value                            |
| ----------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------- |
| `metrics.enabled`                                           | Start a sidecar prometheus exporter to expose Redis(R) metrics                                                                                                                                                                    | `false`                          |
| `metrics.image.registry`                                    | Redis(R) Exporter image registry                                                                                                                                                                                                  | `REGISTRY_NAME`                  |
| `metrics.image.repository`                                  | Redis(R) Exporter image repository                                                                                                                                                                                                | `REPOSITORY_NAME/redis-exporter` |
| `metrics.image.digest`                                      | Redis(R) Exporter image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                 | `""`                             |
| `metrics.image.pullPolicy`                                  | Redis(R) Exporter image pull policy                                                                                                                                                                                               | `IfNotPresent`                   |
| `metrics.image.pullSecrets`                                 | Redis(R) Exporter image pull secrets                                                                                                                                                                                              | `[]`                             |
| `metrics.containerPorts.http`                               | Metrics HTTP container port                                                                                                                                                                                                       | `9121`                           |
| `metrics.startupProbe.enabled`                              | Enable startupProbe on Redis(R) replicas nodes                                                                                                                                                                                    | `false`                          |
| `metrics.startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                                            | `10`                             |
| `metrics.startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                                   | `10`                             |
| `metrics.startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                                  | `5`                              |
| `metrics.startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                                | `5`                              |
| `metrics.startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                                | `1`                              |
| `metrics.livenessProbe.enabled`                             | Enable livenessProbe on Redis(R) replicas nodes                                                                                                                                                                                   | `true`                           |
| `metrics.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                                           | `10`                             |
| `metrics.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                                  | `10`                             |
| `metrics.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                                 | `5`                              |
| `metrics.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                                               | `5`                              |
| `metrics.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                                               | `1`                              |
| `metrics.readinessProbe.enabled`                            | Enable readinessProbe on Redis(R) replicas nodes                                                                                                                                                                                  | `true`                           |
| `metrics.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                                          | `5`                              |
| `metrics.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                                 | `10`                             |
| `metrics.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                                | `1`                              |
| `metrics.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                                              | `3`                              |
| `metrics.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                                              | `1`                              |
| `metrics.customStartupProbe`                                | Custom startupProbe that overrides the default one                                                                                                                                                                                | `{}`                             |
| `metrics.customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                                                                                                                               | `{}`                             |
| `metrics.customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                                                                                                                                              | `{}`                             |
| `metrics.command`                                           | Override default metrics container init command (useful when using custom images)                                                                                                                                                 | `[]`                             |
| `metrics.redisTargetHost`                                   | A way to specify an alternative Redis(R) hostname                                                                                                                                                                                 | `localhost`                      |
| `metrics.extraArgs`                                         | Extra arguments for Redis(R) exporter, for example:                                                                                                                                                                               | `{}`                             |
| `metrics.extraEnvVars`                                      | Array with extra environment variables to add to Redis(R) exporter                                                                                                                                                                | `[]`                             |
| `metrics.containerSecurityContext.enabled`                  | Enabled Redis(R) exporter containers' Security Context                                                                                                                                                                            | `true`                           |
| `metrics.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                                  | `{}`                             |
| `metrics.containerSecurityContext.runAsUser`                | Set Redis(R) exporter containers' Security Context runAsUser                                                                                                                                                                      | `1001`                           |
| `metrics.containerSecurityContext.runAsGroup`               | Set Redis(R) exporter containers' Security Context runAsGroup                                                                                                                                                                     | `1001`                           |
| `metrics.containerSecurityContext.runAsNonRoot`             | Set Redis(R) exporter containers' Security Context runAsNonRoot                                                                                                                                                                   | `true`                           |
| `metrics.containerSecurityContext.allowPrivilegeEscalation` | Set Redis(R) exporter containers' Security Context allowPrivilegeEscalation                                                                                                                                                       | `false`                          |
| `metrics.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context read-only root filesystem                                                                                                                                                                        | `true`                           |
| `metrics.containerSecurityContext.seccompProfile.type`      | Set Redis(R) exporter containers' Security Context seccompProfile                                                                                                                                                                 | `RuntimeDefault`                 |
| `metrics.containerSecurityContext.capabilities.drop`        | Set Redis(R) exporter containers' Security Context capabilities to drop                                                                                                                                                           | `["ALL"]`                        |
| `metrics.extraVolumes`                                      | Optionally specify extra list of additional volumes for the Redis(R) metrics sidecar                                                                                                                                              | `[]`                             |
| `metrics.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the Redis(R) metrics sidecar                                                                                                                                         | `[]`                             |
| `metrics.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if metrics.resources is set (metrics.resources is recommended for production). | `nano`                           |
| `metrics.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                 | `{}`                             |
| `metrics.podLabels`                                         | Extra labels for Redis(R) exporter pods                                                                                                                                                                                           | `{}`                             |
| `metrics.podAnnotations`                                    | Annotations for Redis(R) exporter pods                                                                                                                                                                                            | `{}`                             |
| `metrics.service.enabled`                                   | Create Service resource(s) for scraping metrics using PrometheusOperator ServiceMonitor, can be disabled when using a PodMonitor                                                                                                  | `true`                           |
| `metrics.service.type`                                      | Redis(R) exporter service type                                                                                                                                                                                                    | `ClusterIP`                      |
| `metrics.service.ports.http`                                | Redis(R) exporter service port                                                                                                                                                                                                    | `9121`                           |
| `metrics.service.externalTrafficPolicy`                     | Redis(R) exporter service external traffic policy                                                                                                                                                                                 | `Cluster`                        |
| `metrics.service.extraPorts`                                | Extra ports to expose (normally used with the `sidecar` value)                                                                                                                                                                    | `[]`                             |
| `metrics.service.loadBalancerIP`                            | Redis(R) exporter service Load Balancer IP                                                                                                                                                                                        | `""`                             |
| `metrics.service.loadBalancerClass`                         | exporter service Load Balancer class if service type is `LoadBalancer` (optional, cloud specific)                                                                                                                                 | `""`                             |
| `metrics.service.loadBalancerSourceRanges`                  | Redis(R) exporter service Load Balancer sources                                                                                                                                                                                   | `[]`                             |
| `metrics.service.annotations`                               | Additional custom annotations for Redis(R) exporter service                                                                                                                                                                       | `{}`                             |
| `metrics.service.clusterIP`                                 | Redis(R) exporter service Cluster IP                                                                                                                                                                                              | `""`                             |
| `metrics.serviceMonitor.port`                               | the service port to scrape metrics from                                                                                                                                                                                           | `http-metrics`                   |
| `metrics.serviceMonitor.enabled`                            | Create ServiceMonitor resource(s) for scraping metrics using PrometheusOperator                                                                                                                                                   | `false`                          |
| `metrics.serviceMonitor.namespace`                          | The namespace in which the ServiceMonitor will be created                                                                                                                                                                         | `""`                             |
| `metrics.serviceMonitor.interval`                           | The interval at which metrics should be scraped                                                                                                                                                                                   | `30s`                            |
| `metrics.serviceMonitor.scrapeTimeout`                      | The timeout after which the scrape is ended                                                                                                                                                                                       | `""`                             |
| `metrics.serviceMonitor.relabelings`                        | Metrics RelabelConfigs to apply to samples before scraping.                                                                                                                                                                       | `[]`                             |
| `metrics.serviceMonitor.metricRelabelings`                  | Metrics RelabelConfigs to apply to samples before ingestion.                                                                                                                                                                      | `[]`                             |
| `metrics.serviceMonitor.honorLabels`                        | Specify honorLabels parameter to add the scrape endpoint                                                                                                                                                                          | `false`                          |
| `metrics.serviceMonitor.additionalLabels`                   | Additional labels that can be used so ServiceMonitor resource(s) can be discovered by Prometheus                                                                                                                                  | `{}`                             |
| `metrics.serviceMonitor.podTargetLabels`                    | Labels from the Kubernetes pod to be transferred to the created metrics                                                                                                                                                           | `[]`                             |
| `metrics.serviceMonitor.sampleLimit`                        | Limit of how many samples should be scraped from every Pod                                                                                                                                                                        | `false`                          |
| `metrics.serviceMonitor.targetLimit`                        | Limit of how many targets should be scraped                                                                                                                                                                                       | `false`                          |
| `metrics.serviceMonitor.additionalEndpoints`                | Additional endpoints to scrape (e.g sentinel)                                                                                                                                                                                     | `[]`                             |
| `metrics.podMonitor.port`                                   | the pod port to scrape metrics from                                                                                                                                                                                               | `metrics`                        |
| `metrics.podMonitor.enabled`                                | Create PodMonitor resource(s) for scraping metrics using PrometheusOperator                                                                                                                                                       | `false`                          |
| `metrics.podMonitor.namespace`                              | The namespace in which the PodMonitor will be created                                                                                                                                                                             | `""`                             |
| `metrics.podMonitor.interval`                               | The interval at which metrics should be scraped                                                                                                                                                                                   | `30s`                            |
| `metrics.podMonitor.scrapeTimeout`                          | The timeout after which the scrape is ended                                                                                                                                                                                       | `""`                             |
| `metrics.podMonitor.relabelings`                            | Metrics RelabelConfigs to apply to samples before scraping.                                                                                                                                                                       | `[]`                             |
| `metrics.podMonitor.metricRelabelings`                      | Metrics RelabelConfigs to apply to samples before ingestion.                                                                                                                                                                      | `[]`                             |
| `metrics.podMonitor.honorLabels`                            | Specify honorLabels parameter to add the scrape endpoint                                                                                                                                                                          | `false`                          |
| `metrics.podMonitor.additionalLabels`                       | Additional labels that can be used so PodMonitor resource(s) can be discovered by Prometheus                                                                                                                                      | `{}`                             |
| `metrics.podMonitor.podTargetLabels`                        | Labels from the Kubernetes pod to be transferred to the created metrics                                                                                                                                                           | `[]`                             |
| `metrics.podMonitor.sampleLimit`                            | Limit of how many samples should be scraped from every Pod                                                                                                                                                                        | `false`                          |
| `metrics.podMonitor.targetLimit`                            | Limit of how many targets should be scraped                                                                                                                                                                                       | `false`                          |
| `metrics.podMonitor.additionalEndpoints`                    | Additional endpoints to scrape (e.g sentinel)                                                                                                                                                                                     | `[]`                             |
| `metrics.prometheusRule.enabled`                            | Create a custom prometheusRule Resource for scraping metrics using PrometheusOperator                                                                                                                                             | `false`                          |
| `metrics.prometheusRule.namespace`                          | The namespace in which the prometheusRule will be created                                                                                                                                                                         | `""`                             |
| `metrics.prometheusRule.additionalLabels`                   | Additional labels for the prometheusRule                                                                                                                                                                                          | `{}`                             |
| `metrics.prometheusRule.rules`                              | Custom Prometheus rules                                                                                                                                                                                                           | `[]`                             |

### Init Container Parameters

| Name                                                        | Description                                                                                                                                                                                                                                           | Value                                                             |
| ----------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------- |
| `volumePermissions.enabled`                                 | Enable init container that changes the owner/group of the PV mount point to `runAsUser:fsGroup`                                                                                                                                                       | `false`                                                           |
| `volumePermissions.image.registry`                          | OS Shell + Utility image registry                                                                                                                                                                                                                     | `REGISTRY_NAME`                                                   |
| `volumePermissions.image.repository`                        | OS Shell + Utility image repository                                                                                                                                                                                                                   | `REPOSITORY_NAME/os-shell`                                        |
| `volumePermissions.image.digest`                            | OS Shell + Utility image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                                    | `""`                                                              |
| `volumePermissions.image.pullPolicy`                        | OS Shell + Utility image pull policy                                                                                                                                                                                                                  | `IfNotPresent`                                                    |
| `volumePermissions.image.pullSecrets`                       | OS Shell + Utility image pull secrets                                                                                                                                                                                                                 | `[]`                                                              |
| `volumePermissions.resourcesPreset`                         | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if volumePermissions.resources is set (volumePermissions.resources is recommended for production). | `nano`                                                            |
| `volumePermissions.resources`                               | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                                     | `{}`                                                              |
| `volumePermissions.containerSecurityContext.seLinuxOptions` | Set SELinux options in container                                                                                                                                                                                                                      | `{}`                                                              |
| `volumePermissions.containerSecurityContext.runAsUser`      | Set init container's Security Context runAsUser                                                                                                                                                                                                       | `0`                                                               |
| `volumePermissions.extraEnvVars`                            | Array with extra environment variables to add to volume permissions init container.                                                                                                                                                                   | `[]`                                                              |
| `kubectl.image.registry`                                    | Kubectl image registry                                                                                                                                                                                                                                | `REGISTRY_NAME`                                                   |
| `kubectl.image.repository`                                  | Kubectl image repository                                                                                                                                                                                                                              | `REPOSITORY_NAME/kubectl`                                         |
| `kubectl.image.digest`                                      | Kubectl image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                                               | `""`                                                              |
| `kubectl.image.pullPolicy`                                  | Kubectl image pull policy                                                                                                                                                                                                                             | `IfNotPresent`                                                    |
| `kubectl.image.pullSecrets`                                 | Kubectl pull secrets                                                                                                                                                                                                                                  | `[]`                                                              |
| `kubectl.command`                                           | kubectl command to execute                                                                                                                                                                                                                            | `["/opt/bitnami/scripts/kubectl-scripts/update-master-label.sh"]` |
| `kubectl.containerSecurityContext.enabled`                  | Enabled kubectl containers' Security Context                                                                                                                                                                                                          | `true`                                                            |
| `kubectl.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                                                      | `{}`                                                              |
| `kubectl.containerSecurityContext.runAsUser`                | Set kubectl containers' Security Context runAsUser                                                                                                                                                                                                    | `1001`                                                            |
| `kubectl.containerSecurityContext.runAsGroup`               | Set kubectl containers' Security Context runAsGroup                                                                                                                                                                                                   | `1001`                                                            |
| `kubectl.containerSecurityContext.runAsNonRoot`             | Set kubectl containers' Security Context runAsNonRoot                                                                                                                                                                                                 | `true`                                                            |
| `kubectl.containerSecurityContext.allowPrivilegeEscalation` | Set kubectl containers' Security Context allowPrivilegeEscalation                                                                                                                                                                                     | `false`                                                           |
| `kubectl.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context read-only root filesystem                                                                                                                                                                                            | `true`                                                            |
| `kubectl.containerSecurityContext.seccompProfile.type`      | Set kubectl containers' Security Context seccompProfile                                                                                                                                                                                               | `RuntimeDefault`                                                  |
| `kubectl.containerSecurityContext.capabilities.drop`        | Set kubectl containers' Security Context capabilities to drop                                                                                                                                                                                         | `["ALL"]`                                                         |
| `kubectl.resources.limits`                                  | The resources limits for the kubectl containers                                                                                                                                                                                                       | `{}`                                                              |
| `kubectl.resources.requests`                                | The requested resources for the kubectl containers                                                                                                                                                                                                    | `{}`                                                              |
| `sysctl.enabled`                                            | Enable init container to modify Kernel settings                                                                                                                                                                                                       | `false`                                                           |
| `sysctl.image.registry`                                     | OS Shell + Utility image registry                                                                                                                                                                                                                     | `REGISTRY_NAME`                                                   |
| `sysctl.image.repository`                                   | OS Shell + Utility image repository                                                                                                                                                                                                                   | `REPOSITORY_NAME/os-shell`                                        |
| `sysctl.image.digest`                                       | OS Shell + Utility image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                                    | `""`                                                              |
| `sysctl.image.pullPolicy`                                   | OS Shell + Utility image pull policy                                                                                                                                                                                                                  | `IfNotPresent`                                                    |
| `sysctl.image.pullSecrets`                                  | OS Shell + Utility image pull secrets                                                                                                                                                                                                                 | `[]`                                                              |
| `sysctl.command`                                            | Override default init-sysctl container command (useful when using custom images)                                                                                                                                                                      | `[]`                                                              |
| `sysctl.mountHostSys`                                       | Mount the host `/sys` folder to `/host-sys`                                                                                                                                                                                                           | `false`                                                           |
| `sysctl.resourcesPreset`                                    | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if sysctl.resources is set (sysctl.resources is recommended for production).                       | `nano`                                                            |
| `sysctl.resources`                                          | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                                     | `{}`                                                              |

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
    oci://REGISTRY_NAME/REPOSITORY_NAME/redis
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The above command sets the Redis&reg; server password to `secretpassword`.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml oci://REGISTRY_NAME/REPOSITORY_NAME/redis
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.
> **Tip**: You can use the default [values.yaml](https://github.com/bitnami/charts/tree/main/bitnami/redis/values.yaml)

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 20.5.0

This version introduces image verification for security purposes. To disable it, set `global.security.allowInsecureImages` to `true`. More details at [GitHub issue](https://github.com/bitnami/charts/issues/30850).

A major chart version change (like v1.2.3 -> v2.0.0) indicates that there is an incompatible breaking change needing manual actions.

### RDB compatibility

It's common to have RDB format changes across Redis&reg; releases where we see backward compatibility but no forward compatibility. For example, v7.0 can load an RDB created by v6.2 , but the opposite is not true.
When that's the case, the rolling update can cause replicas to temporarily stop synchronizing while they are running a lower version than master.
For example, on a rolling update `master-0` and `replica-2` are updated first from version v6.2 to v7.0; `replica-0` and `replica-1` won't be able to start a full sync with `master-0` because they are still running v6.2 and can't support the RDB format from version 7.0 that master is now using.
This issue can be mitigated by splitting the upgrade into two stages: one for all replicas and another for any master.

- Stage 1 (replicas only, as there's no master with an ordinal higher than 99):
`helm upgrade oci://REGISTRY_NAME/REPOSITORY_NAME/redis --set master.updateStrategy.rollingUpdate.partition=99`
- Stage 2 (anything else that is not up to date, in this case only master):
`helm upgrade oci://REGISTRY_NAME/REPOSITORY_NAME/redis`

### To 20.0.0

This major version updates the Redis&reg; docker image version used from `7.2` to `7.4`, the new stable version. There are no major changes in the chart, but we recommend checking the [Redis&reg; 7.4 release notes](https://raw.githubusercontent.com/redis/redis/7.4/00-RELEASENOTES) before upgrading.

### To 19.0.0

This major bump changes the following security defaults:

- `runAsGroup` is changed from `0` to `1001`
- `readOnlyRootFilesystem` is set to `true`
- `resourcesPreset` is changed from `none` to the minimum size working in our test suites (NOTE: `resourcesPreset` is not meant for production usage, but `resources` adapted to your use case).
- `global.compatibility.openshift.adaptSecurityContext` is changed from `disabled` to `auto`.

This could potentially break any customization or init scripts used in your deployment. If this is the case, change the default values to the previous ones.

### To 18.0.0

This major version updates the Redis&reg; docker image version used from `7.0` to `7.2`, the new stable version. There are no major changes in the chart, but we recommend checking the [Redis&reg; 7.2 release notes](https://raw.githubusercontent.com/redis/redis/7.2/00-RELEASENOTES) before upgrading.

NOTE: Due to an error in our release process, versions higher or equal than 17.15.4 already use 7.2 by default.

### To 17.0.0

This major version updates the Redis&reg; docker image version used from `6.2` to `7.0`, the new stable version. There are no major changes in the chart, but we recommend checking the [Redis&reg; 7.0 release notes](https://raw.githubusercontent.com/redis/redis/7.0/00-RELEASENOTES) before upgrading.

### To 16.0.0

This major release renames several values in this chart and adds missing features, in order to be inline with the rest of assets in the Bitnami charts repository.

Affected values:

- `master.service.port` renamed as `master.service.ports.redis`.
- `master.service.nodePort` renamed as `master.service.nodePorts.redis`.
- `replica.service.port` renamed as `replica.service.ports.redis`.
- `replica.service.nodePort` renamed as `replica.service.nodePorts.redis`.
- `sentinel.service.port` renamed as `sentinel.service.ports.redis`.
- `sentinel.service.sentinelPort` renamed as `sentinel.service.ports.sentinel`.
- `master.containerPort` renamed as `master.containerPorts.redis`.
- `replica.containerPort` renamed as `replica.containerPorts.redis`.
- `sentinel.containerPort` renamed as `sentinel.containerPorts.sentinel`.
- `master.spreadConstraints` renamed as `master.topologySpreadConstraints`
- `replica.spreadConstraints` renamed as `replica.topologySpreadConstraints`

### To 15.0.0

The parameter to enable the usage of StaticIDs was removed. The behavior is to [always use StaticIDs](https://github.com/bitnami/charts/pull/7278).

### To 14.8.0

The Redis&reg; sentinel exporter was removed in this version because the upstream project was deprecated. The regular Redis&reg; exporter is included in the sentinel scenario as usual.

### To 14.0.0

- Several parameters were renamed or disappeared in favor of new ones on this major version:
  - The term *slave* has been replaced by the term *replica*. Therefore, parameters prefixed with `slave` are now prefixed with `replicas`.
  - Credentials parameter are reorganized under the `auth` parameter.
  - `cluster.enabled` parameter is deprecated in favor of `architecture` parameter that accepts two values: `standalone` and `replication`.
  - `securityContext.*` is deprecated in favor of `XXX.podSecurityContext` and `XXX.containerSecurityContext`.
  - `sentinel.metrics.*` parameters are deprecated in favor of `metrics.sentinel.*` ones.
- New parameters to add custom command, environment variables, sidecars, init containers, etc. were added.
- Chart labels were adapted to follow the [Helm charts standard labels](https://helm.sh/docs/chart_best_practices/labels/#standard-labels).
- values.yaml metadata was adapted to follow the format supported by [Readme Generator for Helm](https://github.com/bitnami/readme-generator-for-helm).

Consequences:

Backwards compatibility is not guaranteed. To upgrade to `14.0.0`, install a new release of the Redis&reg; chart, and migrate the data from your previous release. You have 2 alternatives to do so:

- Create a backup of the database, and restore it on the new release as explained in the [Backup and restore](#backup-and-restore) section.
- Reuse the PVC used to hold the master data on your previous release. To do so, use the `master.persistence.existingClaim` parameter. The following example assumes that the release name is `redis`:

```console
helm install redis oci://REGISTRY_NAME/REPOSITORY_NAME/redis --set auth.password=[PASSWORD] --set master.persistence.existingClaim=[EXISTING_PVC]
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

| Note: you need to substitute the placeholder *[EXISTING_PVC]* with the name of the PVC used on your previous release, and *[PASSWORD]* with the password used in your previous release.

### To 13.0.0

This major version updates the Redis&reg; docker image version used from `6.0` to `6.2`, the new stable version. There are no major changes in the chart and there shouldn't be any breaking changes in it as `6.2` is basically a stricter superset of `6.0`. For more information, please refer to [Redis&reg; 6.2 release notes](https://raw.githubusercontent.com/redis/redis/6.2/00-RELEASENOTES).

### To 12.3.0

This version also introduces `bitnami/common`, a [library chart](https://helm.sh/docs/topics/library_charts/#helm) as a dependency. More documentation about this new utility could be found [here](https://github.com/bitnami/charts/tree/main/bitnami/common#bitnami-common-library-chart). Please, make sure that you have updated the chart dependencies before executing any upgrade.

### To 12.0.0

[On November 13, 2020, Helm v2 support was formally finished](https://github.com/helm/charts#status-of-the-project), this major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

#### What changes were introduced in this major version?

- Previous versions of this Helm Chart use `apiVersion: v1` (installable by both Helm 2 and 3), this Helm Chart was updated to `apiVersion: v2` (installable by Helm 3 only). [Here](https://helm.sh/docs/topics/charts/#the-apiversion-field) you can find more information about the `apiVersion` field.
- The different fields present in the *Chart.yaml* file has been ordered alphabetically in a homogeneous way for all the Bitnami Helm Charts

#### Considerations when upgrading to this version

- If you want to upgrade to this version from a previous one installed with Helm v3, you shouldn't face any issues
- If you want to upgrade to this version using Helm v2, this scenario is not supported as this version doesn't support Helm v2 anymore
- If you installed the previous version with Helm v2 and wants to upgrade to this version with Helm v3, please refer to the [official Helm documentation](https://helm.sh/docs/topics/v2_v3_migration/#migration-use-cases) about migrating from Helm v2 to v3

#### Useful links

- <https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-resolve-helm2-helm3-post-migration-issues-index.html>
- <https://helm.sh/docs/topics/v2_v3_migration/>
- <https://helm.sh/blog/migrate-from-helm-v2-to-helm-v3/>

### To 11.0.0

When using sentinel, a new statefulset called `-node` was introduced. This will break upgrading from a previous version where the statefulsets are called master and slave. Hence the PVC will not match the new naming and won't be reused. If you want to keep your data, you will need to perform a backup and then a restore the data in this new version.

When deployed with sentinel enabled, only a group of nodes is deployed and the master/slave role is handled in the group. To avoid breaking the compatibility, the settings for this nodes are given through the `slave.xxxx` parameters in `values.yaml`

### To 10.0.0

For releases with `usePassword: true`, the value `sentinel.usePassword` controls whether the password authentication also applies to the sentinel port. This defaults to `true` for a secure configuration, however it is possible to disable to account for the following cases:

- Using a version of redis-sentinel prior to `5.0.1` where the authentication feature was introduced.
- Where redis clients need to be updated to support sentinel authentication.

If using a master/slave topology, or with `usePassword: false`, no action is required.

### To 9.0.0

The metrics exporter has been changed from a separate deployment to a sidecar container, due to the latest changes in the Redis&reg; exporter code. Check the [official page](https://github.com/oliver006/redis_exporter/) for more information. The metrics container image was changed from oliver006/redis_exporter to bitnami/redis-exporter (Bitnami's maintained package of oliver006/redis_exporter).

### To 8.0.18

For releases with `metrics.enabled: true` the default tag for the exporter image is now `v1.x.x`. This introduces many changes including metrics names. You'll want to use [this dashboard](https://github.com/oliver006/redis_exporter/blob/master/contrib/grafana_prometheus_redis_dashboard.json) now. Please see the [redis_exporter github page](https://github.com/oliver006/redis_exporter#upgrading-from-0x-to-1x) for more details.

### To 7.0.0

This version causes a change in the Redis&reg; Master StatefulSet definition, so the command helm upgrade would not work out of the box. As an alternative, one of the following could be done:

- Recommended: Create a clone of the Redis&reg; Master PVC (for example, using projects like [this one](https://github.com/edseymour/pvc-transfer)). Then launch a fresh release reusing this cloned PVC.

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/redis --set persistence.existingClaim=<NEW PVC>
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

- Alternative (not recommended, do at your own risk): `helm delete --purge` does not remove the PVC assigned to the Redis&reg; Master StatefulSet. As a consequence, the following commands can be done to upgrade the release

```console
helm delete --purge <RELEASE>
helm install <RELEASE> oci://REGISTRY_NAME/REPOSITORY_NAME/redis
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

Previous versions of the chart were not using persistence in the slaves, so this upgrade would add it to them. Another important change is that no values are inherited from master to slaves. For example, in 6.0.0 `slaves.readinessProbe.periodSeconds`, if empty, would be set to `master.readinessProbe.periodSeconds`. This approach lacked transparency and was difficult to maintain. From now on, all the slave parameters must be configured just as it is done with the masters.

Some values have changed as well:

- `master.port` and `slave.port` have been changed to `redisPort` (same value for both master and slaves)
- `master.securityContext` and `slave.securityContext` have been changed to `securityContext`(same values for both master and slaves)

By default, the upgrade will not change the cluster topology. In case you want to use Redis&reg; Sentinel, you must explicitly set `sentinel.enabled` to `true`.

### To 6.0.0

Previous versions of the chart were using an init-container to change the permissions of the volumes. This was done in case the `securityContext` directive in the template was not enough for that (for example, with cephFS). In this new version of the chart, this container is disabled by default (which should not affect most of the deployments). If your installation still requires that init container, execute `helm upgrade` with the `--set volumePermissions.enabled=true`.

### To 5.0.0

The default image in this release may be switched out for any image containing the `redis-server`
and `redis-cli` binaries. If `redis-server` is not the default image ENTRYPOINT, `master.command`
must be specified.

#### Breaking changes

- `master.args` and `slave.args` are removed. Use `master.command` or `slave.command` instead in order to override the image entrypoint, or `master.extraFlags` to pass additional flags to `redis-server`.
- `disableCommands` is now interpreted as an array of strings instead of a string of comma separated values.
- `master.persistence.path` now defaults to `/data`.

### To 4.0.0

This version removes the `chart` label from the `spec.selector.matchLabels`
which is immutable since `StatefulSet apps/v1beta2`. It has been inadvertently
added, causing any subsequent upgrade to fail. See <https://github.com/helm/charts/issues/7726>.

It also fixes <https://github.com/helm/charts/issues/7726> where a deployment `extensions/v1beta1` can not be upgraded if `spec.selector` is not explicitly set.

Finally, it fixes <https://github.com/helm/charts/issues/7803> by removing mutable labels in `spec.VolumeClaimTemplate.metadata.labels` so that it is upgradable.

In order to upgrade, delete the Redis&reg; StatefulSet before upgrading:

```console
kubectl delete statefulsets.apps --cascade=false my-release-redis-master
```

And edit the Redis&reg; slave (and metrics if enabled) deployment:

```console
kubectl patch deployments my-release-redis-slave --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
kubectl patch deployments my-release-redis-metrics --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
```

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