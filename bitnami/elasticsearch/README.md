<!--- app-name: Elasticsearch -->

# Bitnami Elasticsearch Stack

Elasticsearch is a distributed search and analytics engine. It is used for web search, log monitoring, and real-time analytics. Ideal for Big Data applications.

[Overview of Elasticsearch](https://www.elastic.co/products/elasticsearch)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/elasticsearch
```

Looking to use Elasticsearch in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the enterprise edition of Bitnami Application Catalog.

## Introduction

This chart bootstraps a [Elasticsearch](https://github.com/bitnami/containers/tree/main/bitnami/elasticsearch) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/elasticsearch
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

These commands deploy Elasticsearch on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Configuration and installation details

### Resource requests and limits

Bitnami charts allow setting resource requests and limits for all containers inside the chart deployment. These are inside the `resources` value (check parameter table). Setting requests is essential for production workloads and these should be adapted to your specific use case.

To make this process easier, the chart contains the `resourcesPreset` values, which automatically sets the `resources` section according to different presets. Check these presets in [the bitnami/common chart](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15). However, in production workloads using `resourcePreset` is discouraged as it may not fully adapt to your specific needs. Find more information on container resource management in the [official Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).

### [Rolling VS Immutable tags](https://docs.vmware.com/en/VMware-Tanzu-Application-Catalog/services/tutorials/GUID-understand-rolling-tags-containers-index.html)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Change ElasticSearch version

To modify the ElasticSearch version used in this chart you can specify a [valid image tag](https://hub.docker.com/r/bitnami/elasticsearch/tags/) using the `image.tag` parameter. For example, `image.tag=X.Y.Z`. This approach is also applicable to other images like exporters.

### Default kernel settings

Currently, Elasticsearch requires some changes in the kernel of the host machine to work as expected. If those values are not set in the underlying operating system, the ES containers fail to boot with ERROR messages. More information about these requirements can be found in the links below:

- [File Descriptor requirements](https://www.elastic.co/guide/en/elasticsearch/reference/current/file-descriptors.html)
- [Virtual memory requirements](https://www.elastic.co/guide/en/elasticsearch/reference/current/vm-max-map-count.html)

This chart uses a **privileged** initContainer to change those settings in the Kernel by running: `sysctl -w vm.max_map_count=262144 && sysctl -w fs.file-max=65536`.
You can disable the initContainer using the `sysctlImage.enabled=false` parameter.

### Enable bundled Kibana

This Elasticsearch chart contains Kibana as subchart, you can enable it just setting the `global.kibanaEnabled=true` parameter.
To see the notes with some operational instructions from the Kibana chart, please use the `--render-subchart-notes` as part of your `helm install` command, in this way you can see the Kibana and ES notes in your terminal.

When enabling the bundled kibana subchart, there are a few gotchas that you should be aware of listed below.

#### Elasticsearch rest Encryption

When enabling elasticsearch' rest endpoint encryption you will also need to set `kibana.elasticsearch.security.tls.enabled` to the SAME value along with some additional values shown below for an "out of the box experience":

```yaml
security:
  enabled: true
  # PASSWORD must be the same value passed to elasticsearch to get an "out of the box" experience
  elasticPassword: "<PASSWORD>"
  tls:
    # AutoGenerate TLS certs for elastic
    autoGenerated: true

kibana:
  elasticsearch:
    security:
      auth:
        enabled: true
        # default in the elasticsearch chart is elastic
        kibanaUsername: "<USERNAME>"
        kibanaPassword: "<PASSWORD>"
      tls:
        # Instruct kibana to connect to elastic over https
        enabled: true
        # Bit of a catch 22, as you will need to know the name upfront of your release
        existingSecret: RELEASENAME-elasticsearch-coordinating-crt # or just 'elasticsearch-coordinating-crt' if the release name happens to be 'elasticsearch'
        # As the certs are auto-generated, they are pemCerts so set to true
        usePemCerts: true
```

At a bare-minimum, when working with kibana and elasticsearch together the following values MUST be the same, otherwise things will fail:

```yaml
security:
  tls:
    restEncryption: true

# assumes global.kibanaEnabled=true
kibana:
  elasticsearch:
    security:
      tls:
        enabled: true
```

### How to deploy a single node

This chart allows you to deploy Elasticsearch as a "single-node" cluster (one master node replica) that assumes all the roles. The following inputs should be provided:

```yaml
master:
  masterOnly: false
  replicaCount: 1
data:
  replicaCount: 0
coordinating:
  replicaCount: 0
ingest:
  replicaCount: 0
```

The "single-node" cluster will be configured with [single-node discovery](https://www.elastic.co/guide/en/elasticsearch/reference/current/bootstrap-checks.html#single-node-discovery).

If you want to scale up to more replicas, make sure you refresh the configuration of the existing StatefulSet. For example, scale down to 0 replicas first to avoid inconsistencies in the configuration:

```console
kubectl scale statefulset <DEPLOYMENT_NAME>-master --replicas=0
helm upgrade <DEPLOYMENT_NAME> oci://REGISTRY_NAME/REPOSITORY_NAME/elasticsearch --reset-values --set master.masterOnly=false
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

Please note that the master nodes should continue assuming all the roles (`master.masterOnly: false`) since there is shard data on the first replica.

### Adding extra environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `extraEnvVars` property.

```yaml
extraEnvVars:
  - name: ELASTICSEARCH_VERSION
    value: 7.0
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values.

### Using custom init scripts

For advanced operations, the Bitnami Elasticsearch charts allows using custom init scripts that will be mounted inside `/docker-entrypoint.init-db`. You can include the file directly in your `values.yaml` with `initScripts`, or use a ConfigMap or a Secret (in case of sensitive data) for mounting these extra scripts. In this case you use the `initScriptsCM` and `initScriptsSecret` values.

```console
initScriptsCM=special-scripts
initScriptsSecret=special-scripts-sensitive
```

### Snapshot and restore operations

As it's described in the [official documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-register-repository.html#snapshots-filesystem-repository), it's necessary to register a snapshot repository before you can perform snapshot and restore operations.

This chart allows you to configure Elasticsearch to use a shared file system to store snapshots. To do so, you need to mount a RWX volume on every Elasticsearch node, and set the parameter `snapshotRepoPath` with the path where the volume is mounted. In the example below, you can find the values to set when using a NFS Perstitent Volume:

```yaml
extraVolumes:
  - name: snapshot-repository
    nfs:
      server: nfs.example.com # Please change this to your NFS server
      path: /share1
extraVolumeMounts:
  - name: snapshot-repository
    mountPath: /snapshots
snapshotRepoPath: "/snapshots"
```

### Sidecars and Init Containers

If you have a need for additional containers to run within the same pod as Elasticsearch components (e.g. an additional metrics or logging exporter), you can do so via the `XXX.sidecars` parameter(s), where XXX is placeholder you need to replace with the actual component(s). Simply define your container according to the Kubernetes container spec.

```yaml
sidecars:
  - name: your-image-name
    image: your-image
    imagePullPolicy: Always
    ports:
      - name: portname
        containerPort: 1234
```

Similarly, you can add extra init containers using the `initContainers` parameter.

```yaml
initContainers:
  - name: your-image-name
    image: your-image
    imagePullPolicy: Always
    ports:
      - name: portname
```

### Setting Pod's affinity

This chart allows you to set your custom affinity using the `XXX.affinity` parameter(s). Find more information about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities) chart. To do so, set the `XXX.podAffinityPreset`, `XXX.podAntiAffinityPreset`, or `XXX.nodeAffinityPreset` parameters.

## Persistence

The [Bitnami Elasticsearch](https://github.com/bitnami/containers/tree/main/bitnami/elasticsearch) image stores the Elasticsearch data at the `/bitnami/elasticsearch/data` path of the container.

By default, the chart mounts a [Persistent Volume](https://kubernetes.io/docs/concepts/storage/persistent-volumes/) at this location. The volume is created using dynamic volume provisioning. See the [Parameters](#parameters) section to configure the PVC.

### Adjust permissions of persistent volume mountpoint

As the image run as non-root by default, it is necessary to adjust the ownership of the persistent volume so that the container can write data into it.

By default, the chart is configured to use Kubernetes Security Context to automatically change the ownership of the volume. However, this feature does not work in all Kubernetes distributions.
As an alternative, this chart supports using an initContainer to change the ownership of the volume before mounting it in the final destination.

You can enable this initContainer by setting `volumePermissions.enabled` to `true`.

## Parameters

### Global parameters

| Name                                                  | Description                                                                                                                                                                                                                                                                                                                                                         | Value           |
| ----------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------- |
| `global.imageRegistry`                                | Global Docker image registry                                                                                                                                                                                                                                                                                                                                        | `""`            |
| `global.imagePullSecrets`                             | Global Docker registry secret names as an array                                                                                                                                                                                                                                                                                                                     | `[]`            |
| `global.storageClass`                                 | Global StorageClass for Persistent Volume(s)                                                                                                                                                                                                                                                                                                                        | `""`            |
| `global.elasticsearch.service.name`                   | Elasticsearch service name to be used in the Kibana subchart (ignored if kibanaEnabled=false)                                                                                                                                                                                                                                                                       | `elasticsearch` |
| `global.elasticsearch.service.ports.restAPI`          | Elasticsearch service restAPI port to be used in the Kibana subchart (ignored if kibanaEnabled=false)                                                                                                                                                                                                                                                               | `9200`          |
| `global.kibanaEnabled`                                | Whether or not to enable Kibana                                                                                                                                                                                                                                                                                                                                     | `false`         |
| `global.compatibility.openshift.adaptSecurityContext` | Adapt the securityContext sections of the deployment to make them compatible with Openshift restricted-v2 SCC: remove runAsUser, runAsGroup and fsGroup and let the platform use their allowed default IDs. Possible values: auto (apply if the detected running cluster is Openshift), force (perform the adaptation always), disabled (do not perform adaptation) | `auto`          |

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
| `namespaceOverride`      | String to fully override common.names.namespace                                         | `""`            |
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden) | `false`         |
| `diagnosticMode.command` | Command to override all containers in the deployment                                    | `["sleep"]`     |
| `diagnosticMode.args`    | Args to override all containers in the deployment                                       | `["infinity"]`  |

### Elasticsearch cluster Parameters

| Name                                       | Description                                                                                                                                         | Value                           |
| ------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------- |
| `clusterName`                              | Elasticsearch cluster name                                                                                                                          | `elastic`                       |
| `containerPorts.restAPI`                   | Elasticsearch REST API port                                                                                                                         | `9200`                          |
| `containerPorts.transport`                 | Elasticsearch Transport port                                                                                                                        | `9300`                          |
| `plugins`                                  | Comma, semi-colon or space separated list of plugins to install at initialization                                                                   | `""`                            |
| `snapshotRepoPath`                         | File System snapshot repository path                                                                                                                | `""`                            |
| `config`                                   | Override elasticsearch configuration                                                                                                                | `{}`                            |
| `extraConfig`                              | Append extra configuration to the elasticsearch node configuration                                                                                  | `{}`                            |
| `extraHosts`                               | A list of external hosts which are part of this cluster                                                                                             | `[]`                            |
| `extraVolumes`                             | A list of volumes to be added to the pod                                                                                                            | `[]`                            |
| `extraVolumeMounts`                        | A list of volume mounts to be added to the pod                                                                                                      | `[]`                            |
| `initScripts`                              | Dictionary of init scripts. Evaluated as a template.                                                                                                | `{}`                            |
| `initScriptsCM`                            | ConfigMap with the init scripts. Evaluated as a template.                                                                                           | `""`                            |
| `initScriptsSecret`                        | Secret containing `/docker-entrypoint-initdb.d` scripts to be executed at initialization time that contain sensitive data. Evaluated as a template. | `""`                            |
| `extraEnvVars`                             | Array containing extra env vars to be added to all pods (evaluated as a template)                                                                   | `[]`                            |
| `extraEnvVarsCM`                           | ConfigMap containing extra env vars to be added to all pods (evaluated as a template)                                                               | `""`                            |
| `extraEnvVarsSecret`                       | Secret containing extra env vars to be added to all pods (evaluated as a template)                                                                  | `""`                            |
| `sidecars`                                 | Add additional sidecar containers to the all elasticsearch node pod(s)                                                                              | `[]`                            |
| `initContainers`                           | Add additional init containers to the all elasticsearch node pod(s)                                                                                 | `[]`                            |
| `useIstioLabels`                           | Use this variable to add Istio labels to all pods                                                                                                   | `true`                          |
| `image.registry`                           | Elasticsearch image registry                                                                                                                        | `REGISTRY_NAME`                 |
| `image.repository`                         | Elasticsearch image repository                                                                                                                      | `REPOSITORY_NAME/elasticsearch` |
| `image.digest`                             | Elasticsearch image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                       | `""`                            |
| `image.pullPolicy`                         | Elasticsearch image pull policy                                                                                                                     | `IfNotPresent`                  |
| `image.pullSecrets`                        | Elasticsearch image pull secrets                                                                                                                    | `[]`                            |
| `image.debug`                              | Enable Elasticsearch image debug mode                                                                                                               | `false`                         |
| `security.enabled`                         | Enable X-Pack Security settings                                                                                                                     | `false`                         |
| `security.elasticPassword`                 | Password for 'elastic' user                                                                                                                         | `""`                            |
| `security.existingSecret`                  | Name of the existing secret containing the Elasticsearch password (expected key: `elasticsearch-password`)                                          | `""`                            |
| `security.fipsMode`                        | Configure elasticsearch with FIPS 140 compliant mode                                                                                                | `false`                         |
| `security.tls.restEncryption`              | Enable SSL/TLS encryption for Elasticsearch REST API.                                                                                               | `true`                          |
| `security.tls.autoGenerated`               | Create self-signed TLS certificates.                                                                                                                | `false`                         |
| `security.tls.verificationMode`            | Verification mode for SSL communications.                                                                                                           | `full`                          |
| `security.tls.master.existingSecret`       | Existing secret containing the certificates for the master nodes                                                                                    | `""`                            |
| `security.tls.data.existingSecret`         | Existing secret containing the certificates for the data nodes                                                                                      | `""`                            |
| `security.tls.ingest.existingSecret`       | Existing secret containing the certificates for the ingest nodes                                                                                    | `""`                            |
| `security.tls.coordinating.existingSecret` | Existing secret containing the certificates for the coordinating nodes                                                                              | `""`                            |
| `security.tls.keystoreFilename`            | Name of the keystore file                                                                                                                           | `elasticsearch.keystore.jks`    |
| `security.tls.truststoreFilename`          | Name of the truststore                                                                                                                              | `elasticsearch.truststore.jks`  |
| `security.tls.usePemCerts`                 | Use this variable if your secrets contain PEM certificates instead of JKS/PKCS12                                                                    | `false`                         |
| `security.tls.passwordsSecret`             | Existing secret containing the Keystore and Truststore passwords, or key password if PEM certs are used                                             | `""`                            |
| `security.tls.keystorePassword`            | Password to access the JKS/PKCS12 keystore or PEM key when they are password-protected.                                                             | `""`                            |
| `security.tls.truststorePassword`          | Password to access the JKS/PKCS12 truststore when they are password-protected.                                                                      | `""`                            |
| `security.tls.keyPassword`                 | Password to access the PEM key when they are password-protected.                                                                                    | `""`                            |
| `security.tls.secretKeystoreKey`           | Name of the secret key containing the Keystore password                                                                                             | `""`                            |
| `security.tls.secretTruststoreKey`         | Name of the secret key containing the Truststore password                                                                                           | `""`                            |
| `security.tls.secretKey`                   | Name of the secret key containing the PEM key password                                                                                              | `""`                            |

### Traffic Exposure Parameters

| Name                               | Description                                                                                                                      | Value                    |
| ---------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `service.type`                     | Elasticsearch service type                                                                                                       | `ClusterIP`              |
| `service.ports.restAPI`            | Elasticsearch service REST API port                                                                                              | `9200`                   |
| `service.ports.transport`          | Elasticsearch service transport port                                                                                             | `9300`                   |
| `service.nodePorts.restAPI`        | Node port for REST API                                                                                                           | `""`                     |
| `service.nodePorts.transport`      | Node port for REST API                                                                                                           | `""`                     |
| `service.clusterIP`                | Elasticsearch service Cluster IP                                                                                                 | `""`                     |
| `service.loadBalancerIP`           | Elasticsearch service Load Balancer IP                                                                                           | `""`                     |
| `service.loadBalancerSourceRanges` | Elasticsearch service Load Balancer sources                                                                                      | `[]`                     |
| `service.externalTrafficPolicy`    | Elasticsearch service external traffic policy                                                                                    | `Cluster`                |
| `service.annotations`              | Additional custom annotations for Elasticsearch service                                                                          | `{}`                     |
| `service.extraPorts`               | Extra ports to expose in Elasticsearch service (normally used with the `sidecars` value)                                         | `[]`                     |
| `service.sessionAffinity`          | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                                                             | `None`                   |
| `service.sessionAffinityConfig`    | Additional settings for the sessionAffinity                                                                                      | `{}`                     |
| `ingress.enabled`                  | Enable ingress record generation for Elasticsearch                                                                               | `false`                  |
| `ingress.pathType`                 | Ingress path type                                                                                                                | `ImplementationSpecific` |
| `ingress.apiVersion`               | Force Ingress API version (automatically detected if not set)                                                                    | `""`                     |
| `ingress.hostname`                 | Default host for the ingress record                                                                                              | `elasticsearch.local`    |
| `ingress.path`                     | Default path for the ingress record                                                                                              | `/`                      |
| `ingress.annotations`              | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                     |
| `ingress.tls`                      | Enable TLS configuration for the host defined at `ingress.hostname` parameter                                                    | `false`                  |
| `ingress.selfSigned`               | Create a TLS secret for this ingress record using self-signed certificates generated by Helm                                     | `false`                  |
| `ingress.ingressClassName`         | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                    | `""`                     |
| `ingress.extraHosts`               | An array with additional hostname(s) to be covered with the ingress record                                                       | `[]`                     |
| `ingress.extraPaths`               | An array with additional arbitrary paths that may need to be added to the ingress under the main host                            | `[]`                     |
| `ingress.extraTls`                 | TLS configuration for additional hostname(s) to be covered with this ingress record                                              | `[]`                     |
| `ingress.secrets`                  | Custom TLS certificates as secrets                                                                                               | `[]`                     |
| `ingress.extraRules`               | Additional rules to be covered with this ingress record                                                                          | `[]`                     |

### Master-elegible nodes parameters

| Name                                                       | Description                                                                                                                                                                                                                     | Value               |
| ---------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------- |
| `master.masterOnly`                                        | Deploy the Elasticsearch master-elegible nodes as master-only nodes. Recommended for high-demand deployments.                                                                                                                   | `true`              |
| `master.replicaCount`                                      | Number of master-elegible replicas to deploy                                                                                                                                                                                    | `2`                 |
| `master.extraRoles`                                        | Append extra roles to the node role                                                                                                                                                                                             | `[]`                |
| `master.pdb.create`                                        | Enable/disable a Pod Disruption Budget creation                                                                                                                                                                                 | `true`              |
| `master.pdb.minAvailable`                                  | Minimum number/percentage of pods that should remain scheduled                                                                                                                                                                  | `""`                |
| `master.pdb.maxUnavailable`                                | Maximum number/percentage of pods that may be made unavailable                                                                                                                                                                  | `""`                |
| `master.nameOverride`                                      | String to partially override elasticsearch.master.fullname                                                                                                                                                                      | `""`                |
| `master.fullnameOverride`                                  | String to fully override elasticsearch.master.fullname                                                                                                                                                                          | `""`                |
| `master.servicenameOverride`                               | String to fully override elasticsearch.master.servicename                                                                                                                                                                       | `""`                |
| `master.annotations`                                       | Annotations for the master statefulset                                                                                                                                                                                          | `{}`                |
| `master.updateStrategy.type`                               | Master-elegible nodes statefulset stategy type                                                                                                                                                                                  | `RollingUpdate`     |
| `master.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if master.resources is set (master.resources is recommended for production). | `small`             |
| `master.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                               | `{}`                |
| `master.heapSize`                                          | Elasticsearch master-eligible node heap size.                                                                                                                                                                                   | `128m`              |
| `master.podSecurityContext.enabled`                        | Enabled master-elegible pods' Security Context                                                                                                                                                                                  | `true`              |
| `master.podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                              | `Always`            |
| `master.podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                                  | `[]`                |
| `master.podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                                     | `[]`                |
| `master.podSecurityContext.fsGroup`                        | Set master-elegible pod's Security Context fsGroup                                                                                                                                                                              | `1001`              |
| `master.containerSecurityContext.enabled`                  | Elasticseacrh master-eligible container securityContext                                                                                                                                                                         | `true`              |
| `master.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                                | `{}`                |
| `master.containerSecurityContext.runAsUser`                | User ID for the Elasticseacrh master-eligible container                                                                                                                                                                         | `1001`              |
| `master.containerSecurityContext.runAsGroup`               | Group ID for the Elasticseacrh master-eligible container                                                                                                                                                                        | `1001`              |
| `master.containerSecurityContext.runAsNonRoot`             | Set Elasticsearch master-eligible container's Security Context runAsNonRoot                                                                                                                                                     | `true`              |
| `master.containerSecurityContext.privileged`               | Set Elasticsearch master-eligible container's Security Context privileged                                                                                                                                                       | `false`             |
| `master.containerSecurityContext.allowPrivilegeEscalation` | Set Elasticsearch master-eligible container's Security Context allowPrivilegeEscalation                                                                                                                                         | `false`             |
| `master.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                                         | `true`              |
| `master.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                              | `["ALL"]`           |
| `master.containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                                | `RuntimeDefault`    |
| `master.networkPolicy.enabled`                             | Specifies whether a NetworkPolicy should be created                                                                                                                                                                             | `true`              |
| `master.networkPolicy.allowExternal`                       | Don't require server label for connections                                                                                                                                                                                      | `true`              |
| `master.networkPolicy.allowExternalEgress`                 | Allow the pod to access any range of port and all destinations.                                                                                                                                                                 | `true`              |
| `master.networkPolicy.extraIngress`                        | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                                    | `[]`                |
| `master.networkPolicy.extraEgress`                         | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                                    | `[]`                |
| `master.networkPolicy.ingressNSMatchLabels`                | Labels to match to allow traffic from other namespaces                                                                                                                                                                          | `{}`                |
| `master.networkPolicy.ingressNSPodMatchLabels`             | Pod labels to match to allow traffic from other namespaces                                                                                                                                                                      | `{}`                |
| `master.automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                              | `false`             |
| `master.hostAliases`                                       | master-elegible pods host aliases                                                                                                                                                                                               | `[]`                |
| `master.podLabels`                                         | Extra labels for master-elegible pods                                                                                                                                                                                           | `{}`                |
| `master.podAnnotations`                                    | Annotations for master-elegible pods                                                                                                                                                                                            | `{}`                |
| `master.podAffinityPreset`                                 | Pod affinity preset. Ignored if `master.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                      | `""`                |
| `master.podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `master.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                 | `""`                |
| `master.nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `master.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                | `""`                |
| `master.nodeAffinityPreset.key`                            | Node label key to match. Ignored if `master.affinity` is set                                                                                                                                                                    | `""`                |
| `master.nodeAffinityPreset.values`                         | Node label values to match. Ignored if `master.affinity` is set                                                                                                                                                                 | `[]`                |
| `master.affinity`                                          | Affinity for master-elegible pods assignment                                                                                                                                                                                    | `{}`                |
| `master.nodeSelector`                                      | Node labels for master-elegible pods assignment                                                                                                                                                                                 | `{}`                |
| `master.tolerations`                                       | Tolerations for master-elegible pods assignment                                                                                                                                                                                 | `[]`                |
| `master.priorityClassName`                                 | master-elegible pods' priorityClassName                                                                                                                                                                                         | `""`                |
| `master.schedulerName`                                     | Name of the k8s scheduler (other than default) for master-elegible pods                                                                                                                                                         | `""`                |
| `master.terminationGracePeriodSeconds`                     | In seconds, time the given to the Elasticsearch Master pod needs to terminate gracefully                                                                                                                                        | `""`                |
| `master.topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template                                                                                                        | `[]`                |
| `master.podManagementPolicy`                               | podManagementPolicy to manage scaling operation of Elasticsearch master pods                                                                                                                                                    | `Parallel`          |
| `master.startupProbe.enabled`                              | Enable/disable the startup probe (master nodes pod)                                                                                                                                                                             | `false`             |
| `master.startupProbe.initialDelaySeconds`                  | Delay before startup probe is initiated (master nodes pod)                                                                                                                                                                      | `90`                |
| `master.startupProbe.periodSeconds`                        | How often to perform the probe (master nodes pod)                                                                                                                                                                               | `10`                |
| `master.startupProbe.timeoutSeconds`                       | When the probe times out (master nodes pod)                                                                                                                                                                                     | `5`                 |
| `master.startupProbe.successThreshold`                     | Minimum consecutive successes for the probe to be considered successful after having failed (master nodes pod)                                                                                                                  | `1`                 |
| `master.startupProbe.failureThreshold`                     | Minimum consecutive failures for the probe to be considered failed after having succeeded                                                                                                                                       | `5`                 |
| `master.livenessProbe.enabled`                             | Enable/disable the liveness probe (master-eligible nodes pod)                                                                                                                                                                   | `true`              |
| `master.livenessProbe.initialDelaySeconds`                 | Delay before liveness probe is initiated (master-eligible nodes pod)                                                                                                                                                            | `180`               |
| `master.livenessProbe.periodSeconds`                       | How often to perform the probe (master-eligible nodes pod)                                                                                                                                                                      | `10`                |
| `master.livenessProbe.timeoutSeconds`                      | When the probe times out (master-eligible nodes pod)                                                                                                                                                                            | `5`                 |
| `master.livenessProbe.successThreshold`                    | Minimum consecutive successes for the probe to be considered successful after having failed (master-eligible nodes pod)                                                                                                         | `1`                 |
| `master.livenessProbe.failureThreshold`                    | Minimum consecutive failures for the probe to be considered failed after having succeeded                                                                                                                                       | `5`                 |
| `master.readinessProbe.enabled`                            | Enable/disable the readiness probe (master-eligible nodes pod)                                                                                                                                                                  | `true`              |
| `master.readinessProbe.initialDelaySeconds`                | Delay before readiness probe is initiated (master-eligible nodes pod)                                                                                                                                                           | `90`                |
| `master.readinessProbe.periodSeconds`                      | How often to perform the probe (master-eligible nodes pod)                                                                                                                                                                      | `10`                |
| `master.readinessProbe.timeoutSeconds`                     | When the probe times out (master-eligible nodes pod)                                                                                                                                                                            | `5`                 |
| `master.readinessProbe.successThreshold`                   | Minimum consecutive successes for the probe to be considered successful after having failed (master-eligible nodes pod)                                                                                                         | `1`                 |
| `master.readinessProbe.failureThreshold`                   | Minimum consecutive failures for the probe to be considered failed after having succeeded                                                                                                                                       | `5`                 |
| `master.customStartupProbe`                                | Override default startup probe                                                                                                                                                                                                  | `{}`                |
| `master.customLivenessProbe`                               | Override default liveness probe                                                                                                                                                                                                 | `{}`                |
| `master.customReadinessProbe`                              | Override default readiness probe                                                                                                                                                                                                | `{}`                |
| `master.command`                                           | Override default container command (useful when using custom images)                                                                                                                                                            | `[]`                |
| `master.args`                                              | Override default container args (useful when using custom images)                                                                                                                                                               | `[]`                |
| `master.lifecycleHooks`                                    | for the master-elegible container(s) to automate configuration before or after startup                                                                                                                                          | `{}`                |
| `master.extraEnvVars`                                      | Array with extra environment variables to add to master-elegible nodes                                                                                                                                                          | `[]`                |
| `master.extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for master-elegible nodes                                                                                                                                                  | `""`                |
| `master.extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for master-elegible nodes                                                                                                                                                     | `""`                |
| `master.extraVolumes`                                      | Optionally specify extra list of additional volumes for the master-elegible pod(s)                                                                                                                                              | `[]`                |
| `master.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the master-elegible container(s)                                                                                                                                   | `[]`                |
| `master.sidecars`                                          | Add additional sidecar containers to the master-elegible pod(s)                                                                                                                                                                 | `[]`                |
| `master.initContainers`                                    | Add additional init containers to the master-elegible pod(s)                                                                                                                                                                    | `[]`                |
| `master.persistence.enabled`                               | Enable persistence using a `PersistentVolumeClaim`                                                                                                                                                                              | `true`              |
| `master.persistence.storageClass`                          | Persistent Volume Storage Class                                                                                                                                                                                                 | `""`                |
| `master.persistence.existingClaim`                         | Existing Persistent Volume Claim                                                                                                                                                                                                | `""`                |
| `master.persistence.existingVolume`                        | Existing Persistent Volume for use as volume match label selector to the `volumeClaimTemplate`. Ignored when `master.persistence.selector` is set.                                                                              | `""`                |
| `master.persistence.selector`                              | Configure custom selector for existing Persistent Volume. Overwrites `master.persistence.existingVolume`                                                                                                                        | `{}`                |
| `master.persistence.annotations`                           | Persistent Volume Claim annotations                                                                                                                                                                                             | `{}`                |
| `master.persistence.accessModes`                           | Persistent Volume Access Modes                                                                                                                                                                                                  | `["ReadWriteOnce"]` |
| `master.persistence.size`                                  | Persistent Volume Size                                                                                                                                                                                                          | `8Gi`               |
| `master.serviceAccount.create`                             | Specifies whether a ServiceAccount should be created                                                                                                                                                                            | `true`              |
| `master.serviceAccount.name`                               | Name of the service account to use. If not set and create is true, a name is generated using the fullname template.                                                                                                             | `""`                |
| `master.serviceAccount.automountServiceAccountToken`       | Automount service account token for the server service account                                                                                                                                                                  | `false`             |
| `master.serviceAccount.annotations`                        | Annotations for service account. Evaluated as a template. Only used if `create` is `true`.                                                                                                                                      | `{}`                |
| `master.autoscaling.enabled`                               | Whether enable horizontal pod autoscale                                                                                                                                                                                         | `false`             |
| `master.autoscaling.minReplicas`                           | Configure a minimum amount of pods                                                                                                                                                                                              | `3`                 |
| `master.autoscaling.maxReplicas`                           | Configure a maximum amount of pods                                                                                                                                                                                              | `11`                |
| `master.autoscaling.targetCPU`                             | Define the CPU target to trigger the scaling actions (utilization percentage)                                                                                                                                                   | `""`                |
| `master.autoscaling.targetMemory`                          | Define the memory target to trigger the scaling actions (utilization percentage)                                                                                                                                                | `""`                |

### Data-only nodes parameters

| Name                                                     | Description                                                                                                                                                                                                                 | Value               |
| -------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------- |
| `data.replicaCount`                                      | Number of data-only replicas to deploy                                                                                                                                                                                      | `2`                 |
| `data.extraRoles`                                        | Append extra roles to the node role                                                                                                                                                                                         | `[]`                |
| `data.pdb.create`                                        | Enable/disable a Pod Disruption Budget creation                                                                                                                                                                             | `true`              |
| `data.pdb.minAvailable`                                  | Minimum number/percentage of pods that should remain scheduled                                                                                                                                                              | `""`                |
| `data.pdb.maxUnavailable`                                | Maximum number/percentage of pods that may be made unavailable                                                                                                                                                              | `""`                |
| `data.nameOverride`                                      | String to partially override elasticsearch.data.fullname                                                                                                                                                                    | `""`                |
| `data.fullnameOverride`                                  | String to fully override elasticsearch.data.fullname                                                                                                                                                                        | `""`                |
| `data.servicenameOverride`                               | String to fully override elasticsearch.data.servicename                                                                                                                                                                     | `""`                |
| `data.annotations`                                       | Annotations for the data statefulset                                                                                                                                                                                        | `{}`                |
| `data.updateStrategy.type`                               | Data-only nodes statefulset stategy type                                                                                                                                                                                    | `RollingUpdate`     |
| `data.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if data.resources is set (data.resources is recommended for production). | `medium`            |
| `data.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                           | `{}`                |
| `data.heapSize`                                          | Elasticsearch data node heap size.                                                                                                                                                                                          | `1024m`             |
| `data.podSecurityContext.enabled`                        | Enabled data pods' Security Context                                                                                                                                                                                         | `true`              |
| `data.podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                          | `Always`            |
| `data.podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                              | `[]`                |
| `data.podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                                 | `[]`                |
| `data.podSecurityContext.fsGroup`                        | Set data pod's Security Context fsGroup                                                                                                                                                                                     | `1001`              |
| `data.containerSecurityContext.enabled`                  | Elasticseacrh data container securityContext                                                                                                                                                                                | `true`              |
| `data.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                            | `{}`                |
| `data.containerSecurityContext.runAsUser`                | User ID for the Elasticseacrh data container                                                                                                                                                                                | `1001`              |
| `data.containerSecurityContext.runAsGroup`               | Group ID for the Elasticseacrh data container                                                                                                                                                                               | `1001`              |
| `data.containerSecurityContext.runAsNonRoot`             | Set Elasticsearch data container's Security Context runAsNonRoot                                                                                                                                                            | `true`              |
| `data.containerSecurityContext.privileged`               | Set Elasticsearch data container's Security Context privileged                                                                                                                                                              | `false`             |
| `data.containerSecurityContext.allowPrivilegeEscalation` | Set Elasticsearch data container's Security Context allowPrivilegeEscalation                                                                                                                                                | `false`             |
| `data.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                                     | `true`              |
| `data.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                          | `["ALL"]`           |
| `data.containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                            | `RuntimeDefault`    |
| `data.networkPolicy.enabled`                             | Specifies whether a NetworkPolicy should be created                                                                                                                                                                         | `true`              |
| `data.networkPolicy.allowExternal`                       | Don't require server label for connections                                                                                                                                                                                  | `true`              |
| `data.networkPolicy.allowExternalEgress`                 | Allow the pod to access any range of port and all destinations.                                                                                                                                                             | `true`              |
| `data.networkPolicy.extraIngress`                        | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                                | `[]`                |
| `data.networkPolicy.extraEgress`                         | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                                | `[]`                |
| `data.networkPolicy.ingressNSMatchLabels`                | Labels to match to allow traffic from other namespaces                                                                                                                                                                      | `{}`                |
| `data.networkPolicy.ingressNSPodMatchLabels`             | Pod labels to match to allow traffic from other namespaces                                                                                                                                                                  | `{}`                |
| `data.automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                          | `false`             |
| `data.hostAliases`                                       | data pods host aliases                                                                                                                                                                                                      | `[]`                |
| `data.podLabels`                                         | Extra labels for data pods                                                                                                                                                                                                  | `{}`                |
| `data.podAnnotations`                                    | Annotations for data pods                                                                                                                                                                                                   | `{}`                |
| `data.podAffinityPreset`                                 | Pod affinity preset. Ignored if `data.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                    | `""`                |
| `data.podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `data.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                               | `""`                |
| `data.nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `data.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                              | `""`                |
| `data.nodeAffinityPreset.key`                            | Node label key to match. Ignored if `data.affinity` is set                                                                                                                                                                  | `""`                |
| `data.nodeAffinityPreset.values`                         | Node label values to match. Ignored if `data.affinity` is set                                                                                                                                                               | `[]`                |
| `data.affinity`                                          | Affinity for data pods assignment                                                                                                                                                                                           | `{}`                |
| `data.nodeSelector`                                      | Node labels for data pods assignment                                                                                                                                                                                        | `{}`                |
| `data.tolerations`                                       | Tolerations for data pods assignment                                                                                                                                                                                        | `[]`                |
| `data.priorityClassName`                                 | data pods' priorityClassName                                                                                                                                                                                                | `""`                |
| `data.schedulerName`                                     | Name of the k8s scheduler (other than default) for data pods                                                                                                                                                                | `""`                |
| `data.terminationGracePeriodSeconds`                     | In seconds, time the given to the Elasticsearch data pod needs to terminate gracefully                                                                                                                                      | `""`                |
| `data.topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template                                                                                                    | `[]`                |
| `data.podManagementPolicy`                               | podManagementPolicy to manage scaling operation of Elasticsearch data pods                                                                                                                                                  | `Parallel`          |
| `data.startupProbe.enabled`                              | Enable/disable the startup probe (data nodes pod)                                                                                                                                                                           | `false`             |
| `data.startupProbe.initialDelaySeconds`                  | Delay before startup probe is initiated (data nodes pod)                                                                                                                                                                    | `90`                |
| `data.startupProbe.periodSeconds`                        | How often to perform the probe (data nodes pod)                                                                                                                                                                             | `10`                |
| `data.startupProbe.timeoutSeconds`                       | When the probe times out (data nodes pod)                                                                                                                                                                                   | `5`                 |
| `data.startupProbe.successThreshold`                     | Minimum consecutive successes for the probe to be considered successful after having failed (data nodes pod)                                                                                                                | `1`                 |
| `data.startupProbe.failureThreshold`                     | Minimum consecutive failures for the probe to be considered failed after having succeeded                                                                                                                                   | `5`                 |
| `data.livenessProbe.enabled`                             | Enable/disable the liveness probe (data nodes pod)                                                                                                                                                                          | `true`              |
| `data.livenessProbe.initialDelaySeconds`                 | Delay before liveness probe is initiated (data nodes pod)                                                                                                                                                                   | `180`               |
| `data.livenessProbe.periodSeconds`                       | How often to perform the probe (data nodes pod)                                                                                                                                                                             | `10`                |
| `data.livenessProbe.timeoutSeconds`                      | When the probe times out (data nodes pod)                                                                                                                                                                                   | `5`                 |
| `data.livenessProbe.successThreshold`                    | Minimum consecutive successes for the probe to be considered successful after having failed (data nodes pod)                                                                                                                | `1`                 |
| `data.livenessProbe.failureThreshold`                    | Minimum consecutive failures for the probe to be considered failed after having succeeded                                                                                                                                   | `5`                 |
| `data.readinessProbe.enabled`                            | Enable/disable the readiness probe (data nodes pod)                                                                                                                                                                         | `true`              |
| `data.readinessProbe.initialDelaySeconds`                | Delay before readiness probe is initiated (data nodes pod)                                                                                                                                                                  | `90`                |
| `data.readinessProbe.periodSeconds`                      | How often to perform the probe (data nodes pod)                                                                                                                                                                             | `10`                |
| `data.readinessProbe.timeoutSeconds`                     | When the probe times out (data nodes pod)                                                                                                                                                                                   | `5`                 |
| `data.readinessProbe.successThreshold`                   | Minimum consecutive successes for the probe to be considered successful after having failed (data nodes pod)                                                                                                                | `1`                 |
| `data.readinessProbe.failureThreshold`                   | Minimum consecutive failures for the probe to be considered failed after having succeeded                                                                                                                                   | `5`                 |
| `data.customStartupProbe`                                | Override default startup probe                                                                                                                                                                                              | `{}`                |
| `data.customLivenessProbe`                               | Override default liveness probe                                                                                                                                                                                             | `{}`                |
| `data.customReadinessProbe`                              | Override default readiness probe                                                                                                                                                                                            | `{}`                |
| `data.command`                                           | Override default container command (useful when using custom images)                                                                                                                                                        | `[]`                |
| `data.args`                                              | Override default container args (useful when using custom images)                                                                                                                                                           | `[]`                |
| `data.lifecycleHooks`                                    | for the data container(s) to automate configuration before or after startup                                                                                                                                                 | `{}`                |
| `data.extraEnvVars`                                      | Array with extra environment variables to add to data nodes                                                                                                                                                                 | `[]`                |
| `data.extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for data nodes                                                                                                                                                         | `""`                |
| `data.extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for data nodes                                                                                                                                                            | `""`                |
| `data.extraVolumes`                                      | Optionally specify extra list of additional volumes for the data pod(s)                                                                                                                                                     | `[]`                |
| `data.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the data container(s)                                                                                                                                          | `[]`                |
| `data.sidecars`                                          | Add additional sidecar containers to the data pod(s)                                                                                                                                                                        | `[]`                |
| `data.initContainers`                                    | Add additional init containers to the data pod(s)                                                                                                                                                                           | `[]`                |
| `data.persistence.enabled`                               | Enable persistence using a `PersistentVolumeClaim`                                                                                                                                                                          | `true`              |
| `data.persistence.storageClass`                          | Persistent Volume Storage Class                                                                                                                                                                                             | `""`                |
| `data.persistence.existingClaim`                         | Existing Persistent Volume Claim                                                                                                                                                                                            | `""`                |
| `data.persistence.existingVolume`                        | Existing Persistent Volume for use as volume match label selector to the `volumeClaimTemplate`. Ignored when `data.persistence.selector` is set.                                                                            | `""`                |
| `data.persistence.selector`                              | Configure custom selector for existing Persistent Volume. Overwrites `data.persistence.existingVolume`                                                                                                                      | `{}`                |
| `data.persistence.annotations`                           | Persistent Volume Claim annotations                                                                                                                                                                                         | `{}`                |
| `data.persistence.accessModes`                           | Persistent Volume Access Modes                                                                                                                                                                                              | `["ReadWriteOnce"]` |
| `data.persistence.size`                                  | Persistent Volume Size                                                                                                                                                                                                      | `8Gi`               |
| `data.serviceAccount.create`                             | Specifies whether a ServiceAccount should be created                                                                                                                                                                        | `true`              |
| `data.serviceAccount.name`                               | Name of the service account to use. If not set and create is true, a name is generated using the fullname template.                                                                                                         | `""`                |
| `data.serviceAccount.automountServiceAccountToken`       | Automount service account token for the server service account                                                                                                                                                              | `false`             |
| `data.serviceAccount.annotations`                        | Annotations for service account. Evaluated as a template. Only used if `create` is `true`.                                                                                                                                  | `{}`                |
| `data.autoscaling.enabled`                               | Whether enable horizontal pod autoscale                                                                                                                                                                                     | `false`             |
| `data.autoscaling.minReplicas`                           | Configure a minimum amount of pods                                                                                                                                                                                          | `3`                 |
| `data.autoscaling.maxReplicas`                           | Configure a maximum amount of pods                                                                                                                                                                                          | `11`                |
| `data.autoscaling.targetCPU`                             | Define the CPU target to trigger the scaling actions (utilization percentage)                                                                                                                                               | `""`                |
| `data.autoscaling.targetMemory`                          | Define the memory target to trigger the scaling actions (utilization percentage)                                                                                                                                            | `""`                |

### Coordinating-only nodes parameters

| Name                                                             | Description                                                                                                                                                                                                                                 | Value            |
| ---------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| `coordinating.replicaCount`                                      | Number of coordinating-only replicas to deploy                                                                                                                                                                                              | `2`              |
| `coordinating.extraRoles`                                        | Append extra roles to the node role                                                                                                                                                                                                         | `[]`             |
| `coordinating.pdb.create`                                        | Enable/disable a Pod Disruption Budget creation                                                                                                                                                                                             | `true`           |
| `coordinating.pdb.minAvailable`                                  | Minimum number/percentage of pods that should remain scheduled                                                                                                                                                                              | `""`             |
| `coordinating.pdb.maxUnavailable`                                | Maximum number/percentage of pods that may be made unavailable                                                                                                                                                                              | `""`             |
| `coordinating.nameOverride`                                      | String to partially override elasticsearch.coordinating.fullname                                                                                                                                                                            | `""`             |
| `coordinating.fullnameOverride`                                  | String to fully override elasticsearch.coordinating.fullname                                                                                                                                                                                | `""`             |
| `coordinating.servicenameOverride`                               | String to fully override elasticsearch.coordinating.servicename                                                                                                                                                                             | `""`             |
| `coordinating.annotations`                                       | Annotations for the coordinating-only statefulset                                                                                                                                                                                           | `{}`             |
| `coordinating.updateStrategy.type`                               | Coordinating-only nodes statefulset stategy type                                                                                                                                                                                            | `RollingUpdate`  |
| `coordinating.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if coordinating.resources is set (coordinating.resources is recommended for production). | `small`          |
| `coordinating.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                           | `{}`             |
| `coordinating.heapSize`                                          | Elasticsearch coordinating node heap size.                                                                                                                                                                                                  | `128m`           |
| `coordinating.podSecurityContext.enabled`                        | Enabled coordinating-only pods' Security Context                                                                                                                                                                                            | `true`           |
| `coordinating.podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                                          | `Always`         |
| `coordinating.podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                                              | `[]`             |
| `coordinating.podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                                                 | `[]`             |
| `coordinating.podSecurityContext.fsGroup`                        | Set coordinating-only pod's Security Context fsGroup                                                                                                                                                                                        | `1001`           |
| `coordinating.containerSecurityContext.enabled`                  | Elasticseacrh coordinating container securityContext                                                                                                                                                                                        | `true`           |
| `coordinating.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                                            | `{}`             |
| `coordinating.containerSecurityContext.runAsUser`                | User ID for the Elasticseacrh coordinating container                                                                                                                                                                                        | `1001`           |
| `coordinating.containerSecurityContext.runAsGroup`               | Group ID for the Elasticseacrh coordinating container                                                                                                                                                                                       | `1001`           |
| `coordinating.containerSecurityContext.runAsNonRoot`             | Set Elasticsearch coordinating container's Security Context runAsNonRoot                                                                                                                                                                    | `true`           |
| `coordinating.containerSecurityContext.privileged`               | Set Elasticsearch coordinating container's Security Context privileged                                                                                                                                                                      | `false`          |
| `coordinating.containerSecurityContext.allowPrivilegeEscalation` | Set Elasticsearch coordinating container's Security Context allowPrivilegeEscalation                                                                                                                                                        | `false`          |
| `coordinating.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                                                     | `true`           |
| `coordinating.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                                          | `["ALL"]`        |
| `coordinating.containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                                            | `RuntimeDefault` |
| `coordinating.networkPolicy.enabled`                             | Specifies whether a NetworkPolicy should be created                                                                                                                                                                                         | `true`           |
| `coordinating.networkPolicy.allowExternal`                       | Don't require server label for connections                                                                                                                                                                                                  | `true`           |
| `coordinating.networkPolicy.allowExternalEgress`                 | Allow the pod to access any range of port and all destinations.                                                                                                                                                                             | `true`           |
| `coordinating.networkPolicy.extraIngress`                        | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                                                | `[]`             |
| `coordinating.networkPolicy.extraEgress`                         | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                                                | `[]`             |
| `coordinating.networkPolicy.ingressNSMatchLabels`                | Labels to match to allow traffic from other namespaces                                                                                                                                                                                      | `{}`             |
| `coordinating.networkPolicy.ingressNSPodMatchLabels`             | Pod labels to match to allow traffic from other namespaces                                                                                                                                                                                  | `{}`             |
| `coordinating.automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                                          | `false`          |
| `coordinating.hostAliases`                                       | coordinating-only pods host aliases                                                                                                                                                                                                         | `[]`             |
| `coordinating.podLabels`                                         | Extra labels for coordinating-only pods                                                                                                                                                                                                     | `{}`             |
| `coordinating.podAnnotations`                                    | Annotations for coordinating-only pods                                                                                                                                                                                                      | `{}`             |
| `coordinating.podAffinityPreset`                                 | Pod affinity preset. Ignored if `coordinating.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                            | `""`             |
| `coordinating.podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `coordinating.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                       | `""`             |
| `coordinating.nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `coordinating.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                      | `""`             |
| `coordinating.nodeAffinityPreset.key`                            | Node label key to match. Ignored if `coordinating.affinity` is set                                                                                                                                                                          | `""`             |
| `coordinating.nodeAffinityPreset.values`                         | Node label values to match. Ignored if `coordinating.affinity` is set                                                                                                                                                                       | `[]`             |
| `coordinating.affinity`                                          | Affinity for coordinating-only pods assignment                                                                                                                                                                                              | `{}`             |
| `coordinating.nodeSelector`                                      | Node labels for coordinating-only pods assignment                                                                                                                                                                                           | `{}`             |
| `coordinating.tolerations`                                       | Tolerations for coordinating-only pods assignment                                                                                                                                                                                           | `[]`             |
| `coordinating.priorityClassName`                                 | coordinating-only pods' priorityClassName                                                                                                                                                                                                   | `""`             |
| `coordinating.schedulerName`                                     | Name of the k8s scheduler (other than default) for coordinating-only pods                                                                                                                                                                   | `""`             |
| `coordinating.terminationGracePeriodSeconds`                     | In seconds, time the given to the Elasticsearch coordinating pod needs to terminate gracefully                                                                                                                                              | `""`             |
| `coordinating.topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template                                                                                                                    | `[]`             |
| `coordinating.podManagementPolicy`                               | podManagementPolicy to manage scaling operation of Elasticsearch coordinating pods                                                                                                                                                          | `Parallel`       |
| `coordinating.startupProbe.enabled`                              | Enable/disable the startup probe (coordinating-only nodes pod)                                                                                                                                                                              | `false`          |
| `coordinating.startupProbe.initialDelaySeconds`                  | Delay before startup probe is initiated (coordinating-only nodes pod)                                                                                                                                                                       | `90`             |
| `coordinating.startupProbe.periodSeconds`                        | How often to perform the probe (coordinating-only nodes pod)                                                                                                                                                                                | `10`             |
| `coordinating.startupProbe.timeoutSeconds`                       | When the probe times out (coordinating-only nodes pod)                                                                                                                                                                                      | `5`              |
| `coordinating.startupProbe.successThreshold`                     | Minimum consecutive successes for the probe to be considered successful after having failed (coordinating-only nodes pod)                                                                                                                   | `1`              |
| `coordinating.startupProbe.failureThreshold`                     | Minimum consecutive failures for the probe to be considered failed after having succeeded                                                                                                                                                   | `5`              |
| `coordinating.livenessProbe.enabled`                             | Enable/disable the liveness probe (coordinating-only nodes pod)                                                                                                                                                                             | `true`           |
| `coordinating.livenessProbe.initialDelaySeconds`                 | Delay before liveness probe is initiated (coordinating-only nodes pod)                                                                                                                                                                      | `180`            |
| `coordinating.livenessProbe.periodSeconds`                       | How often to perform the probe (coordinating-only nodes pod)                                                                                                                                                                                | `10`             |
| `coordinating.livenessProbe.timeoutSeconds`                      | When the probe times out (coordinating-only nodes pod)                                                                                                                                                                                      | `5`              |
| `coordinating.livenessProbe.successThreshold`                    | Minimum consecutive successes for the probe to be considered successful after having failed (coordinating-only nodes pod)                                                                                                                   | `1`              |
| `coordinating.livenessProbe.failureThreshold`                    | Minimum consecutive failures for the probe to be considered failed after having succeeded                                                                                                                                                   | `5`              |
| `coordinating.readinessProbe.enabled`                            | Enable/disable the readiness probe (coordinating-only nodes pod)                                                                                                                                                                            | `true`           |
| `coordinating.readinessProbe.initialDelaySeconds`                | Delay before readiness probe is initiated (coordinating-only nodes pod)                                                                                                                                                                     | `90`             |
| `coordinating.readinessProbe.periodSeconds`                      | How often to perform the probe (coordinating-only nodes pod)                                                                                                                                                                                | `10`             |
| `coordinating.readinessProbe.timeoutSeconds`                     | When the probe times out (coordinating-only nodes pod)                                                                                                                                                                                      | `5`              |
| `coordinating.readinessProbe.successThreshold`                   | Minimum consecutive successes for the probe to be considered successful after having failed (coordinating-only nodes pod)                                                                                                                   | `1`              |
| `coordinating.readinessProbe.failureThreshold`                   | Minimum consecutive failures for the probe to be considered failed after having succeeded                                                                                                                                                   | `5`              |
| `coordinating.customStartupProbe`                                | Override default startup probe                                                                                                                                                                                                              | `{}`             |
| `coordinating.customLivenessProbe`                               | Override default liveness probe                                                                                                                                                                                                             | `{}`             |
| `coordinating.customReadinessProbe`                              | Override default readiness probe                                                                                                                                                                                                            | `{}`             |
| `coordinating.command`                                           | Override default container command (useful when using custom images)                                                                                                                                                                        | `[]`             |
| `coordinating.args`                                              | Override default container args (useful when using custom images)                                                                                                                                                                           | `[]`             |
| `coordinating.lifecycleHooks`                                    | for the coordinating-only container(s) to automate configuration before or after startup                                                                                                                                                    | `{}`             |
| `coordinating.extraEnvVars`                                      | Array with extra environment variables to add to coordinating-only nodes                                                                                                                                                                    | `[]`             |
| `coordinating.extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for coordinating-only nodes                                                                                                                                                            | `""`             |
| `coordinating.extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for coordinating-only nodes                                                                                                                                                               | `""`             |
| `coordinating.extraVolumes`                                      | Optionally specify extra list of additional volumes for the coordinating-only pod(s)                                                                                                                                                        | `[]`             |
| `coordinating.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the coordinating-only container(s)                                                                                                                                             | `[]`             |
| `coordinating.sidecars`                                          | Add additional sidecar containers to the coordinating-only pod(s)                                                                                                                                                                           | `[]`             |
| `coordinating.initContainers`                                    | Add additional init containers to the coordinating-only pod(s)                                                                                                                                                                              | `[]`             |
| `coordinating.serviceAccount.create`                             | Specifies whether a ServiceAccount should be created                                                                                                                                                                                        | `true`           |
| `coordinating.serviceAccount.name`                               | Name of the service account to use. If not set and create is true, a name is generated using the fullname template.                                                                                                                         | `""`             |
| `coordinating.serviceAccount.automountServiceAccountToken`       | Automount service account token for the server service account                                                                                                                                                                              | `false`          |
| `coordinating.serviceAccount.annotations`                        | Annotations for service account. Evaluated as a template. Only used if `create` is `true`.                                                                                                                                                  | `{}`             |
| `coordinating.autoscaling.enabled`                               | Whether enable horizontal pod autoscale                                                                                                                                                                                                     | `false`          |
| `coordinating.autoscaling.minReplicas`                           | Configure a minimum amount of pods                                                                                                                                                                                                          | `3`              |
| `coordinating.autoscaling.maxReplicas`                           | Configure a maximum amount of pods                                                                                                                                                                                                          | `11`             |
| `coordinating.autoscaling.targetCPU`                             | Define the CPU target to trigger the scaling actions (utilization percentage)                                                                                                                                                               | `""`             |
| `coordinating.autoscaling.targetMemory`                          | Define the memory target to trigger the scaling actions (utilization percentage)                                                                                                                                                            | `""`             |

### Ingest-only nodes parameters

| Name                                                       | Description                                                                                                                                                                                                                     | Value                        |
| ---------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------- |
| `ingest.enabled`                                           | Enable ingest nodes                                                                                                                                                                                                             | `true`                       |
| `ingest.replicaCount`                                      | Number of ingest-only replicas to deploy                                                                                                                                                                                        | `2`                          |
| `ingest.extraRoles`                                        | Append extra roles to the node role                                                                                                                                                                                             | `[]`                         |
| `ingest.pdb.create`                                        | Enable/disable a Pod Disruption Budget creation                                                                                                                                                                                 | `true`                       |
| `ingest.pdb.minAvailable`                                  | Minimum number/percentage of pods that should remain scheduled                                                                                                                                                                  | `""`                         |
| `ingest.pdb.maxUnavailable`                                | Maximum number/percentage of pods that may be made unavailable                                                                                                                                                                  | `""`                         |
| `ingest.nameOverride`                                      | String to partially override elasticsearch.ingest.fullname                                                                                                                                                                      | `""`                         |
| `ingest.fullnameOverride`                                  | String to fully override elasticsearch.ingest.fullname                                                                                                                                                                          | `""`                         |
| `ingest.servicenameOverride`                               | String to fully override ingest.master.servicename                                                                                                                                                                              | `""`                         |
| `ingest.annotations`                                       | Annotations for the ingest statefulset                                                                                                                                                                                          | `{}`                         |
| `ingest.containerPorts.restAPI`                            | Elasticsearch REST API port                                                                                                                                                                                                     | `9200`                       |
| `ingest.containerPorts.transport`                          | Elasticsearch Transport port                                                                                                                                                                                                    | `9300`                       |
| `ingest.updateStrategy.type`                               | Ingest-only nodes statefulset stategy type                                                                                                                                                                                      | `RollingUpdate`              |
| `ingest.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if ingest.resources is set (ingest.resources is recommended for production). | `small`                      |
| `ingest.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                               | `{}`                         |
| `ingest.heapSize`                                          | Elasticsearch ingest-only node heap size.                                                                                                                                                                                       | `128m`                       |
| `ingest.podSecurityContext.enabled`                        | Enabled ingest-only pods' Security Context                                                                                                                                                                                      | `true`                       |
| `ingest.podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                              | `Always`                     |
| `ingest.podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                                  | `[]`                         |
| `ingest.podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                                     | `[]`                         |
| `ingest.podSecurityContext.fsGroup`                        | Set ingest-only pod's Security Context fsGroup                                                                                                                                                                                  | `1001`                       |
| `ingest.containerSecurityContext.enabled`                  | Elasticseacrh ingest container securityContext                                                                                                                                                                                  | `true`                       |
| `ingest.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                                | `{}`                         |
| `ingest.containerSecurityContext.runAsUser`                | User ID for the Elasticseacrh ingest container                                                                                                                                                                                  | `1001`                       |
| `ingest.containerSecurityContext.runAsGroup`               | Group ID for the Elasticseacrh ingest container                                                                                                                                                                                 | `1001`                       |
| `ingest.containerSecurityContext.runAsNonRoot`             | Set Elasticsearch ingest container's Security Context runAsNonRoot                                                                                                                                                              | `true`                       |
| `ingest.containerSecurityContext.privileged`               | Set Elasticsearch ingest container's Security Context privileged                                                                                                                                                                | `false`                      |
| `ingest.containerSecurityContext.allowPrivilegeEscalation` | Set Elasticsearch ingest container's Security Context allowPrivilegeEscalation                                                                                                                                                  | `false`                      |
| `ingest.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                                         | `true`                       |
| `ingest.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                              | `["ALL"]`                    |
| `ingest.containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                                | `RuntimeDefault`             |
| `ingest.networkPolicy.enabled`                             | Specifies whether a NetworkPolicy should be created                                                                                                                                                                             | `true`                       |
| `ingest.networkPolicy.allowExternal`                       | Don't require server label for connections                                                                                                                                                                                      | `true`                       |
| `ingest.networkPolicy.allowExternalEgress`                 | Allow the pod to access any range of port and all destinations.                                                                                                                                                                 | `true`                       |
| `ingest.networkPolicy.extraIngress`                        | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                                    | `[]`                         |
| `ingest.networkPolicy.extraEgress`                         | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                                    | `[]`                         |
| `ingest.networkPolicy.ingressNSMatchLabels`                | Labels to match to allow traffic from other namespaces                                                                                                                                                                          | `{}`                         |
| `ingest.networkPolicy.ingressNSPodMatchLabels`             | Pod labels to match to allow traffic from other namespaces                                                                                                                                                                      | `{}`                         |
| `ingest.automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                              | `false`                      |
| `ingest.hostAliases`                                       | ingest-only pods host aliases                                                                                                                                                                                                   | `[]`                         |
| `ingest.podLabels`                                         | Extra labels for ingest-only pods                                                                                                                                                                                               | `{}`                         |
| `ingest.podAnnotations`                                    | Annotations for ingest-only pods                                                                                                                                                                                                | `{}`                         |
| `ingest.podAffinityPreset`                                 | Pod affinity preset. Ignored if `ingest.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                      | `""`                         |
| `ingest.podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `ingest.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                 | `""`                         |
| `ingest.nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `ingest.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                | `""`                         |
| `ingest.nodeAffinityPreset.key`                            | Node label key to match. Ignored if `ingest.affinity` is set                                                                                                                                                                    | `""`                         |
| `ingest.nodeAffinityPreset.values`                         | Node label values to match. Ignored if `ingest.affinity` is set                                                                                                                                                                 | `[]`                         |
| `ingest.affinity`                                          | Affinity for ingest-only pods assignment                                                                                                                                                                                        | `{}`                         |
| `ingest.nodeSelector`                                      | Node labels for ingest-only pods assignment                                                                                                                                                                                     | `{}`                         |
| `ingest.tolerations`                                       | Tolerations for ingest-only pods assignment                                                                                                                                                                                     | `[]`                         |
| `ingest.priorityClassName`                                 | ingest-only pods' priorityClassName                                                                                                                                                                                             | `""`                         |
| `ingest.schedulerName`                                     | Name of the k8s scheduler (other than default) for ingest-only pods                                                                                                                                                             | `""`                         |
| `ingest.terminationGracePeriodSeconds`                     | In seconds, time the given to the Elasticsearch ingest pod needs to terminate gracefully                                                                                                                                        | `""`                         |
| `ingest.topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template                                                                                                        | `[]`                         |
| `ingest.podManagementPolicy`                               | podManagementPolicy to manage scaling operation of Elasticsearch ingest pods                                                                                                                                                    | `Parallel`                   |
| `ingest.startupProbe.enabled`                              | Enable/disable the startup probe (ingest-only nodes pod)                                                                                                                                                                        | `false`                      |
| `ingest.startupProbe.initialDelaySeconds`                  | Delay before startup probe is initiated (ingest-only nodes pod)                                                                                                                                                                 | `90`                         |
| `ingest.startupProbe.periodSeconds`                        | How often to perform the probe (ingest-only nodes pod)                                                                                                                                                                          | `10`                         |
| `ingest.startupProbe.timeoutSeconds`                       | When the probe times out (ingest-only nodes pod)                                                                                                                                                                                | `5`                          |
| `ingest.startupProbe.successThreshold`                     | Minimum consecutive successes for the probe to be considered successful after having failed (ingest-only nodes pod)                                                                                                             | `1`                          |
| `ingest.startupProbe.failureThreshold`                     | Minimum consecutive failures for the probe to be considered failed after having succeeded                                                                                                                                       | `5`                          |
| `ingest.livenessProbe.enabled`                             | Enable/disable the liveness probe (ingest-only nodes pod)                                                                                                                                                                       | `true`                       |
| `ingest.livenessProbe.initialDelaySeconds`                 | Delay before liveness probe is initiated (ingest-only nodes pod)                                                                                                                                                                | `180`                        |
| `ingest.livenessProbe.periodSeconds`                       | How often to perform the probe (ingest-only nodes pod)                                                                                                                                                                          | `10`                         |
| `ingest.livenessProbe.timeoutSeconds`                      | When the probe times out (ingest-only nodes pod)                                                                                                                                                                                | `5`                          |
| `ingest.livenessProbe.successThreshold`                    | Minimum consecutive successes for the probe to be considered successful after having failed (ingest-only nodes pod)                                                                                                             | `1`                          |
| `ingest.livenessProbe.failureThreshold`                    | Minimum consecutive failures for the probe to be considered failed after having succeeded                                                                                                                                       | `5`                          |
| `ingest.readinessProbe.enabled`                            | Enable/disable the readiness probe (ingest-only nodes pod)                                                                                                                                                                      | `true`                       |
| `ingest.readinessProbe.initialDelaySeconds`                | Delay before readiness probe is initiated (ingest-only nodes pod)                                                                                                                                                               | `90`                         |
| `ingest.readinessProbe.periodSeconds`                      | How often to perform the probe (ingest-only nodes pod)                                                                                                                                                                          | `10`                         |
| `ingest.readinessProbe.timeoutSeconds`                     | When the probe times out (ingest-only nodes pod)                                                                                                                                                                                | `5`                          |
| `ingest.readinessProbe.successThreshold`                   | Minimum consecutive successes for the probe to be considered successful after having failed (ingest-only nodes pod)                                                                                                             | `1`                          |
| `ingest.readinessProbe.failureThreshold`                   | Minimum consecutive failures for the probe to be considered failed after having succeeded                                                                                                                                       | `5`                          |
| `ingest.customStartupProbe`                                | Override default startup probe                                                                                                                                                                                                  | `{}`                         |
| `ingest.customLivenessProbe`                               | Override default liveness probe                                                                                                                                                                                                 | `{}`                         |
| `ingest.customReadinessProbe`                              | Override default readiness probe                                                                                                                                                                                                | `{}`                         |
| `ingest.command`                                           | Override default container command (useful when using custom images)                                                                                                                                                            | `[]`                         |
| `ingest.args`                                              | Override default container args (useful when using custom images)                                                                                                                                                               | `[]`                         |
| `ingest.lifecycleHooks`                                    | for the ingest-only container(s) to automate configuration before or after startup                                                                                                                                              | `{}`                         |
| `ingest.extraEnvVars`                                      | Array with extra environment variables to add to ingest-only nodes                                                                                                                                                              | `[]`                         |
| `ingest.extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for ingest-only nodes                                                                                                                                                      | `""`                         |
| `ingest.extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for ingest-only nodes                                                                                                                                                         | `""`                         |
| `ingest.extraVolumes`                                      | Optionally specify extra list of additional volumes for the ingest-only pod(s)                                                                                                                                                  | `[]`                         |
| `ingest.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the ingest-only container(s)                                                                                                                                       | `[]`                         |
| `ingest.sidecars`                                          | Add additional sidecar containers to the ingest-only pod(s)                                                                                                                                                                     | `[]`                         |
| `ingest.initContainers`                                    | Add additional init containers to the ingest-only pod(s)                                                                                                                                                                        | `[]`                         |
| `ingest.serviceAccount.create`                             | Specifies whether a ServiceAccount should be created                                                                                                                                                                            | `true`                       |
| `ingest.serviceAccount.name`                               | Name of the service account to use. If not set and create is true, a name is generated using the fullname template.                                                                                                             | `""`                         |
| `ingest.serviceAccount.automountServiceAccountToken`       | Automount service account token for the server service account                                                                                                                                                                  | `false`                      |
| `ingest.serviceAccount.annotations`                        | Annotations for service account. Evaluated as a template. Only used if `create` is `true`.                                                                                                                                      | `{}`                         |
| `ingest.autoscaling.enabled`                               | Whether enable horizontal pod autoscale                                                                                                                                                                                         | `false`                      |
| `ingest.autoscaling.minReplicas`                           | Configure a minimum amount of pods                                                                                                                                                                                              | `3`                          |
| `ingest.autoscaling.maxReplicas`                           | Configure a maximum amount of pods                                                                                                                                                                                              | `11`                         |
| `ingest.autoscaling.targetCPU`                             | Define the CPU target to trigger the scaling actions (utilization percentage)                                                                                                                                                   | `""`                         |
| `ingest.autoscaling.targetMemory`                          | Define the memory target to trigger the scaling actions (utilization percentage)                                                                                                                                                | `""`                         |
| `ingest.service.enabled`                                   | Enable Ingest-only service                                                                                                                                                                                                      | `false`                      |
| `ingest.service.type`                                      | Elasticsearch ingest-only service type                                                                                                                                                                                          | `ClusterIP`                  |
| `ingest.service.ports.restAPI`                             | Elasticsearch service REST API port                                                                                                                                                                                             | `9200`                       |
| `ingest.service.ports.transport`                           | Elasticsearch service transport port                                                                                                                                                                                            | `9300`                       |
| `ingest.service.nodePorts.restAPI`                         | Node port for REST API                                                                                                                                                                                                          | `""`                         |
| `ingest.service.nodePorts.transport`                       | Node port for REST API                                                                                                                                                                                                          | `""`                         |
| `ingest.service.clusterIP`                                 | Elasticsearch ingest-only service Cluster IP                                                                                                                                                                                    | `""`                         |
| `ingest.service.loadBalancerIP`                            | Elasticsearch ingest-only service Load Balancer IP                                                                                                                                                                              | `""`                         |
| `ingest.service.loadBalancerSourceRanges`                  | Elasticsearch ingest-only service Load Balancer sources                                                                                                                                                                         | `[]`                         |
| `ingest.service.externalTrafficPolicy`                     | Elasticsearch ingest-only service external traffic policy                                                                                                                                                                       | `Cluster`                    |
| `ingest.service.extraPorts`                                | Extra ports to expose (normally used with the `sidecar` value)                                                                                                                                                                  | `[]`                         |
| `ingest.service.annotations`                               | Additional custom annotations for Elasticsearch ingest-only service                                                                                                                                                             | `{}`                         |
| `ingest.service.sessionAffinity`                           | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                                                                                                                                                            | `None`                       |
| `ingest.service.sessionAffinityConfig`                     | Additional settings for the sessionAffinity                                                                                                                                                                                     | `{}`                         |
| `ingest.ingress.enabled`                                   | Enable ingress record generation for Elasticsearch                                                                                                                                                                              | `false`                      |
| `ingest.ingress.pathType`                                  | Ingress path type                                                                                                                                                                                                               | `ImplementationSpecific`     |
| `ingest.ingress.apiVersion`                                | Force Ingress API version (automatically detected if not set)                                                                                                                                                                   | `""`                         |
| `ingest.ingress.hostname`                                  | Default host for the ingress record                                                                                                                                                                                             | `elasticsearch-ingest.local` |
| `ingest.ingress.path`                                      | Default path for the ingress record                                                                                                                                                                                             | `/`                          |
| `ingest.ingress.annotations`                               | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations.                                                                                                | `{}`                         |
| `ingest.ingress.tls`                                       | Enable TLS configuration for the host defined at `ingress.hostname` parameter                                                                                                                                                   | `false`                      |
| `ingest.ingress.selfSigned`                                | Create a TLS secret for this ingress record using self-signed certificates generated by Helm                                                                                                                                    | `false`                      |
| `ingest.ingress.ingressClassName`                          | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                                                                                                                   | `""`                         |
| `ingest.ingress.extraHosts`                                | An array with additional hostname(s) to be covered with the ingress record                                                                                                                                                      | `[]`                         |
| `ingest.ingress.extraPaths`                                | An array with additional arbitrary paths that may need to be added to the ingress under the main host                                                                                                                           | `[]`                         |
| `ingest.ingress.extraTls`                                  | TLS configuration for additional hostname(s) to be covered with this ingress record                                                                                                                                             | `[]`                         |
| `ingest.ingress.secrets`                                   | Custom TLS certificates as secrets                                                                                                                                                                                              | `[]`                         |
| `ingest.ingress.extraRules`                                | Additional rules to be covered with this ingress record                                                                                                                                                                         | `[]`                         |

### Metrics parameters

| Name                                                        | Description                                                                                                                                                                                                                       | Value                                    |
| ----------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------- |
| `metrics.enabled`                                           | Enable prometheus exporter                                                                                                                                                                                                        | `false`                                  |
| `metrics.nameOverride`                                      | Metrics pod name                                                                                                                                                                                                                  | `""`                                     |
| `metrics.fullnameOverride`                                  | String to fully override common.names.fullname                                                                                                                                                                                    | `""`                                     |
| `metrics.image.registry`                                    | Metrics exporter image registry                                                                                                                                                                                                   | `REGISTRY_NAME`                          |
| `metrics.image.repository`                                  | Metrics exporter image repository                                                                                                                                                                                                 | `REPOSITORY_NAME/elasticsearch-exporter` |
| `metrics.image.digest`                                      | Metrics exporter image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                  | `""`                                     |
| `metrics.image.pullPolicy`                                  | Metrics exporter image pull policy                                                                                                                                                                                                | `IfNotPresent`                           |
| `metrics.image.pullSecrets`                                 | Metrics exporter image pull secrets                                                                                                                                                                                               | `[]`                                     |
| `metrics.annotations`                                       | Annotations for metrics                                                                                                                                                                                                           | `{}`                                     |
| `metrics.extraArgs`                                         | Extra arguments to add to the default exporter command                                                                                                                                                                            | `[]`                                     |
| `metrics.automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                                | `false`                                  |
| `metrics.hostAliases`                                       | Add deployment host aliases                                                                                                                                                                                                       | `[]`                                     |
| `metrics.schedulerName`                                     | Name of the k8s scheduler (other than default)                                                                                                                                                                                    | `""`                                     |
| `metrics.priorityClassName`                                 | Elasticsearch metrics exporter pods' priorityClassName                                                                                                                                                                            | `""`                                     |
| `metrics.containerPorts.http`                               | Metrics HTTP port                                                                                                                                                                                                                 | `9114`                                   |
| `metrics.networkPolicy.enabled`                             | Specifies whether a NetworkPolicy should be created                                                                                                                                                                               | `true`                                   |
| `metrics.networkPolicy.allowExternal`                       | Don't require server label for connections                                                                                                                                                                                        | `true`                                   |
| `metrics.networkPolicy.allowExternalEgress`                 | Allow the pod to access any range of port and all destinations.                                                                                                                                                                   | `true`                                   |
| `metrics.networkPolicy.extraIngress`                        | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                                      | `[]`                                     |
| `metrics.networkPolicy.extraEgress`                         | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                                      | `[]`                                     |
| `metrics.networkPolicy.ingressNSMatchLabels`                | Labels to match to allow traffic from other namespaces                                                                                                                                                                            | `{}`                                     |
| `metrics.networkPolicy.ingressNSPodMatchLabels`             | Pod labels to match to allow traffic from other namespaces                                                                                                                                                                        | `{}`                                     |
| `metrics.service.type`                                      | Metrics exporter endpoint service type                                                                                                                                                                                            | `ClusterIP`                              |
| `metrics.service.port`                                      | Metrics exporter endpoint service port                                                                                                                                                                                            | `9114`                                   |
| `metrics.service.annotations`                               | Provide any additional annotations which may be required.                                                                                                                                                                         | `{}`                                     |
| `metrics.podAffinityPreset`                                 | Metrics Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                       | `""`                                     |
| `metrics.podAntiAffinityPreset`                             | Metrics Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                  | `""`                                     |
| `metrics.nodeAffinityPreset.type`                           | Metrics Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                 | `""`                                     |
| `metrics.nodeAffinityPreset.key`                            | Metrics Node label key to match Ignored if `affinity` is set.                                                                                                                                                                     | `""`                                     |
| `metrics.nodeAffinityPreset.values`                         | Metrics Node label values to match. Ignored if `affinity` is set.                                                                                                                                                                 | `[]`                                     |
| `metrics.affinity`                                          | Metrics Affinity for pod assignment                                                                                                                                                                                               | `{}`                                     |
| `metrics.nodeSelector`                                      | Metrics Node labels for pod assignment                                                                                                                                                                                            | `{}`                                     |
| `metrics.tolerations`                                       | Metrics Tolerations for pod assignment                                                                                                                                                                                            | `[]`                                     |
| `metrics.topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template                                                                                                          | `[]`                                     |
| `metrics.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if metrics.resources is set (metrics.resources is recommended for production). | `nano`                                   |
| `metrics.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                 | `{}`                                     |
| `metrics.livenessProbe.enabled`                             | Enable/disable the liveness probe (metrics pod)                                                                                                                                                                                   | `true`                                   |
| `metrics.livenessProbe.initialDelaySeconds`                 | Delay before liveness probe is initiated (metrics pod)                                                                                                                                                                            | `60`                                     |
| `metrics.livenessProbe.periodSeconds`                       | How often to perform the probe (metrics pod)                                                                                                                                                                                      | `10`                                     |
| `metrics.livenessProbe.timeoutSeconds`                      | When the probe times out (metrics pod)                                                                                                                                                                                            | `5`                                      |
| `metrics.livenessProbe.failureThreshold`                    | Minimum consecutive failures for the probe to be considered failed after having succeeded                                                                                                                                         | `5`                                      |
| `metrics.livenessProbe.successThreshold`                    | Minimum consecutive successes for the probe to be considered successful after having failed (metrics pod)                                                                                                                         | `1`                                      |
| `metrics.readinessProbe.enabled`                            | Enable/disable the readiness probe (metrics pod)                                                                                                                                                                                  | `true`                                   |
| `metrics.readinessProbe.initialDelaySeconds`                | Delay before readiness probe is initiated (metrics pod)                                                                                                                                                                           | `5`                                      |
| `metrics.readinessProbe.periodSeconds`                      | How often to perform the probe (metrics pod)                                                                                                                                                                                      | `10`                                     |
| `metrics.readinessProbe.timeoutSeconds`                     | When the probe times out (metrics pod)                                                                                                                                                                                            | `1`                                      |
| `metrics.readinessProbe.failureThreshold`                   | Minimum consecutive failures for the probe to be considered failed after having succeeded                                                                                                                                         | `5`                                      |
| `metrics.readinessProbe.successThreshold`                   | Minimum consecutive successes for the probe to be considered successful after having failed (metrics pod)                                                                                                                         | `1`                                      |
| `metrics.startupProbe.enabled`                              | Enable/disable the startup probe (metrics pod)                                                                                                                                                                                    | `false`                                  |
| `metrics.startupProbe.initialDelaySeconds`                  | Delay before startup probe is initiated (metrics pod)                                                                                                                                                                             | `5`                                      |
| `metrics.startupProbe.periodSeconds`                        | How often to perform the probe (metrics pod)                                                                                                                                                                                      | `10`                                     |
| `metrics.startupProbe.timeoutSeconds`                       | When the probe times out (metrics pod)                                                                                                                                                                                            | `1`                                      |
| `metrics.startupProbe.failureThreshold`                     | Minimum consecutive failures for the probe to be considered failed after having succeeded                                                                                                                                         | `5`                                      |
| `metrics.startupProbe.successThreshold`                     | Minimum consecutive successes for the probe to be considered successful after having failed (metrics pod)                                                                                                                         | `1`                                      |
| `metrics.customStartupProbe`                                | Custom liveness probe for the Web component                                                                                                                                                                                       | `{}`                                     |
| `metrics.customLivenessProbe`                               | Custom liveness probe for the Web component                                                                                                                                                                                       | `{}`                                     |
| `metrics.customReadinessProbe`                              | Custom readiness probe for the Web component                                                                                                                                                                                      | `{}`                                     |
| `metrics.podAnnotations`                                    | Metrics exporter pod Annotation and Labels                                                                                                                                                                                        | `{}`                                     |
| `metrics.podLabels`                                         | Extra labels to add to Pod                                                                                                                                                                                                        | `{}`                                     |
| `metrics.podSecurityContext.enabled`                        | Enabled Elasticsearch metrics exporter pods' Security Context                                                                                                                                                                     | `true`                                   |
| `metrics.podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                                | `Always`                                 |
| `metrics.podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                                    | `[]`                                     |
| `metrics.podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                                       | `[]`                                     |
| `metrics.podSecurityContext.fsGroup`                        | Set Elasticsearch metrics exporter pod's Security Context fsGroup                                                                                                                                                                 | `1001`                                   |
| `metrics.containerSecurityContext.enabled`                  | Elasticseacrh exporter container securityContext                                                                                                                                                                                  | `true`                                   |
| `metrics.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                                  | `{}`                                     |
| `metrics.containerSecurityContext.runAsUser`                | User ID for the Elasticseacrh exporter container                                                                                                                                                                                  | `1001`                                   |
| `metrics.containerSecurityContext.runAsGroup`               | Group ID for the Elasticseacrh exporter container                                                                                                                                                                                 | `1001`                                   |
| `metrics.containerSecurityContext.runAsNonRoot`             | Set Elasticsearch exporter container's Security Context runAsNonRoot                                                                                                                                                              | `true`                                   |
| `metrics.containerSecurityContext.privileged`               | Set Elasticsearch exporter container's Security Context privileged                                                                                                                                                                | `false`                                  |
| `metrics.containerSecurityContext.allowPrivilegeEscalation` | Set Elasticsearch exporter container's Security Context allowPrivilegeEscalation                                                                                                                                                  | `false`                                  |
| `metrics.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                                           | `true`                                   |
| `metrics.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                                | `["ALL"]`                                |
| `metrics.containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                                  | `RuntimeDefault`                         |
| `metrics.command`                                           | Override default container command (useful when using custom images)                                                                                                                                                              | `[]`                                     |
| `metrics.args`                                              | Override default container args (useful when using custom images)                                                                                                                                                                 | `[]`                                     |
| `metrics.extraEnvVars`                                      | Array with extra environment variables to add to Elasticsearch metrics exporter nodes                                                                                                                                             | `[]`                                     |
| `metrics.extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for Elasticsearch metrics exporter nodes                                                                                                                                     | `""`                                     |
| `metrics.extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for Elasticsearch metrics exporter nodes                                                                                                                                        | `""`                                     |
| `metrics.extraVolumes`                                      | Optionally specify extra list of additional volumes for the Elasticsearch metrics exporter pod(s)                                                                                                                                 | `[]`                                     |
| `metrics.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the Elasticsearch metrics exporter container(s)                                                                                                                      | `[]`                                     |
| `metrics.sidecars`                                          | Add additional sidecar containers to the Elasticsearch metrics exporter pod(s)                                                                                                                                                    | `[]`                                     |
| `metrics.initContainers`                                    | Add additional init containers to the Elasticsearch metrics exporter pod(s)                                                                                                                                                       | `[]`                                     |
| `metrics.serviceAccount.create`                             | Specifies whether a ServiceAccount should be created                                                                                                                                                                              | `true`                                   |
| `metrics.serviceAccount.name`                               | Name of the service account to use. If not set and create is true, a name is generated using the fullname template.                                                                                                               | `""`                                     |
| `metrics.serviceAccount.automountServiceAccountToken`       | Automount service account token for the server service account                                                                                                                                                                    | `false`                                  |
| `metrics.serviceAccount.annotations`                        | Annotations for service account. Evaluated as a template. Only used if `create` is `true`.                                                                                                                                        | `{}`                                     |
| `metrics.serviceMonitor.enabled`                            | Create ServiceMonitor Resource for scraping metrics using PrometheusOperator                                                                                                                                                      | `false`                                  |
| `metrics.serviceMonitor.namespace`                          | Namespace which Prometheus is running in                                                                                                                                                                                          | `""`                                     |
| `metrics.serviceMonitor.jobLabel`                           | The name of the label on the target service to use as the job name in prometheus.                                                                                                                                                 | `""`                                     |
| `metrics.serviceMonitor.interval`                           | Interval at which metrics should be scraped                                                                                                                                                                                       | `""`                                     |
| `metrics.serviceMonitor.scrapeTimeout`                      | Timeout after which the scrape is ended                                                                                                                                                                                           | `""`                                     |
| `metrics.serviceMonitor.relabelings`                        | RelabelConfigs to apply to samples before scraping                                                                                                                                                                                | `[]`                                     |
| `metrics.serviceMonitor.metricRelabelings`                  | MetricRelabelConfigs to apply to samples before ingestion                                                                                                                                                                         | `[]`                                     |
| `metrics.serviceMonitor.selector`                           | ServiceMonitor selector labels                                                                                                                                                                                                    | `{}`                                     |
| `metrics.serviceMonitor.labels`                             | Extra labels for the ServiceMonitor                                                                                                                                                                                               | `{}`                                     |
| `metrics.serviceMonitor.honorLabels`                        | honorLabels chooses the metric's labels on collisions with target labels                                                                                                                                                          | `false`                                  |
| `metrics.prometheusRule.enabled`                            | Creates a Prometheus Operator PrometheusRule (also requires `metrics.enabled` to be `true` and `metrics.prometheusRule.rules`)                                                                                                    | `false`                                  |
| `metrics.prometheusRule.namespace`                          | Namespace for the PrometheusRule Resource (defaults to the Release Namespace)                                                                                                                                                     | `""`                                     |
| `metrics.prometheusRule.additionalLabels`                   | Additional labels that can be used so PrometheusRule will be discovered by Prometheus                                                                                                                                             | `{}`                                     |
| `metrics.prometheusRule.rules`                              | Prometheus Rule definitions                                                                                                                                                                                                       | `[]`                                     |

### Init Container Parameters

| Name                                  | Description                                                                                                                                                                                                                                           | Value                      |
| ------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------- |
| `volumePermissions.enabled`           | Enable init container that changes volume permissions in the data directory (for cases where the default k8s `runAsUser` and `fsUser` values do not work)                                                                                             | `false`                    |
| `volumePermissions.image.registry`    | Init container volume-permissions image registry                                                                                                                                                                                                      | `REGISTRY_NAME`            |
| `volumePermissions.image.repository`  | Init container volume-permissions image name                                                                                                                                                                                                          | `REPOSITORY_NAME/os-shell` |
| `volumePermissions.image.digest`      | Init container volume-permissions image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                     | `""`                       |
| `volumePermissions.image.pullPolicy`  | Init container volume-permissions image pull policy                                                                                                                                                                                                   | `IfNotPresent`             |
| `volumePermissions.image.pullSecrets` | Init container volume-permissions image pull secrets                                                                                                                                                                                                  | `[]`                       |
| `volumePermissions.resourcesPreset`   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if volumePermissions.resources is set (volumePermissions.resources is recommended for production). | `nano`                     |
| `volumePermissions.resources`         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                                     | `{}`                       |
| `sysctlImage.enabled`                 | Enable kernel settings modifier image                                                                                                                                                                                                                 | `true`                     |
| `sysctlImage.registry`                | Kernel settings modifier image registry                                                                                                                                                                                                               | `REGISTRY_NAME`            |
| `sysctlImage.repository`              | Kernel settings modifier image repository                                                                                                                                                                                                             | `REPOSITORY_NAME/os-shell` |
| `sysctlImage.digest`                  | Kernel settings modifier image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                              | `""`                       |
| `sysctlImage.pullPolicy`              | Kernel settings modifier image pull policy                                                                                                                                                                                                            | `IfNotPresent`             |
| `sysctlImage.pullSecrets`             | Kernel settings modifier image pull secrets                                                                                                                                                                                                           | `[]`                       |
| `sysctlImage.resourcesPreset`         | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if sysctlImage.resources is set (sysctlImage.resources is recommended for production).             | `nano`                     |
| `sysctlImage.resources`               | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                                     | `{}`                       |

### Kibana Parameters

| Name                         | Description                                                               | Value                                                   |
| ---------------------------- | ------------------------------------------------------------------------- | ------------------------------------------------------- |
| `kibana.elasticsearch.hosts` | Array containing hostnames for the ES instances. Used to generate the URL | `[]`                                                    |
| `kibana.elasticsearch.port`  | Port to connect Kibana and ES instance. Used to generate the URL          | `{{ include "elasticsearch.service.ports.restAPI" . }}` |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
  --set name=my-elastic,client.service.port=8080 \
  oci://REGISTRY_NAME/REPOSITORY_NAME/elasticsearch
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The above command sets the Elasticsearch cluster name to `my-elastic` and REST port number to `8080`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml oci://REGISTRY_NAME/REPOSITORY_NAME/elasticsearch
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.
> **Tip**: You can use the default [values.yaml](https://github.com/bitnami/charts/tree/main/bitnami/elasticsearch/values.yaml).

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 21.0.0

This version bumps in a major the version of the Kibana Helm Chart bundled as dependecy, [here](https://github.com/bitnami/charts/tree/main/bitnami/kibana#to-1100) you can see the changes implemented in this Kibana major version.

### To 20.0.0

This major bump changes the following security defaults:

- `runAsGroup` is changed from `0` to `1001`
- `readOnlyRootFilesystem` is set to `true`
- `resourcesPreset` is changed from `none` to the minimum size working in our test suites (NOTE: `resourcesPreset` is not meant for production usage, but `resources` adapted to your use case).
- `global.compatibility.openshift.adaptSecurityContext` is changed from `disabled` to `auto`.

This could potentially break any customization or init scripts used in your deployment. If this is the case, change the default values to the previous ones.

### To 19.6.0

This version fixes the headless services creation. When upgrading you will need to manually delete the services first in order to get them created when upgrading.

### To 19.0.0

The new version of this chart no longer supports elasticsearch-curator, this repository has been deprecated.

### To 18.0.0

This major release refactors the bitnami/elasticsearch chart, adding some organization and functional changes.

- Each role has now the same structure: its Statefulset, a headless service (for FQDN, it gives each node an individual Advertised name, required for TLS verification), its own ServiceAccount (BWC), and HorizontalPodAutoscaling.
- Previously, the chart would alternate between a Coordinating service and an All-nodes service for traffic exposure. This logic has been replaced with a single Traffic exposure service, that will have coordinating-only nodes as backend pods, or master pods if no coordinating nodes are enabled.
- Master-eligible nodes can now be deployed as multi-role nodes using the setting masterOnly. This allows the creation of different topologies, smaller clusters with HA (3 multi-role master-eligible nodes), and single-node deployments.
- Renamed several values to be in line with the rest of the catalog.

This major release also upgrades Elasticsearch to its version 8.x.x and the updates Kibana subchart.

- Upgrade to Elasticsearch 8
- Upgrade Kibana subchart.

In addition, several modifications have been performed adding missing features and renaming values, in order to get aligned with the rest of the assets in the Bitnami charts repository.

The following values have been modified:

- `coordinating.service.*` have been renamed as `service.*`. This service will be backed by coordinating nodes if enabled, or master nodes if not.
- `master.service.*` has been removed.
- `data.service.*` has been removed.
- `master.ingress.*` has been renamed as `ingress.*`. This ingress will be backed by the coordinating/master service previously mentioned.
- In addition, an Ingest-only service and ingress have been added, for use cases where separated ingrestion and search channels are needed.
- `global.coordinating.name` have been renamed as `global.elasticsaerch.service.name`.
- `name` has been renamed as `clusterName`.
- `extraEnvVarsConfigMap` has been renamed as `extraEnvVarsCM`.
- `{master/data/ingest/coordinating}.replicas` has been renamed as `{master/data/ingest/coordinating}.replicaCount`.
- `{master/data/ingest/coordinating}.securityContext` has been separated in two different values: `podSecurityContext` and `containerSecurityContext`.
- `{master/data/ingest/coordinating}.updateStrategy` is now interpreted as an object. `rollingUpdatePartition` has been removed and has to be configured inside the updateStrategy object when needed.
- Default values for `kibana.elasticsearch.hosts` and `kibana.elasticsearch.port` have been modified to use the new helpers.
- `{master/data/ingest/coordinating/curator/metrics}.name` has been renamed as `{master/data/ingest/coordinating/curator}.nameOverride`.

### To 17.0.0

This version bumps in a major the version of the Kibana Helm Chart bundled as dependecy, [here](https://github.com/bitnami/charts/tree/main/bitnami/kibana#to-900) you can see the changes implemented in this Kibana major version.

### To 16.0.0

This version replaces the Ingest and Coordinating Deployments with Statefulsets. This change is required so Coordinating and Ingest nodes have their services associated, required for TLS hostname verification.

We haven't encountered any issues during our upgrade test, but we recommend creating volumes backups before upgrading this major version, especially for users with additional volumes and custom configurations.

Additionally, this version adds support for X-Pack Security features such as TLS/SSL encryption and basic authentication.

### To 15.0.0

From this version onwards, Elasticsearch container components are now licensed under the [Elastic License](https://www.elastic.co/licensing/elastic-license) that is not currently accepted as an Open Source license by the Open Source Initiative (OSI).

Also, from now on, the Helm Chart will include the X-Pack plugin installed by default.

Regular upgrade is compatible from previous versions.

### To 14.0.0

This version standardizes the way of defining Ingress rules in the Kibana subchart. When configuring a single hostname for the Ingress rule, set the `kibana.ingress.hostname` value. When defining more than one, set the `kibana.ingress.extraHosts` array. Apart from this case, no issues are expected to appear when upgrading.

### To 13.0.0

[On November 13, 2020, Helm v2 support was formally finished](https://github.com/helm/charts#status-of-the-project), this major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

#### What changes were introduced in this major version?

- Previous versions of this Helm Chart use `apiVersion: v1` (installable by both Helm 2 and 3), this Helm Chart was updated to `apiVersion: v2` (installable by Helm 3 only). [Here](https://helm.sh/docs/topics/charts/#the-apiversion-field) you can find more information about the `apiVersion` field.
- Move dependency information from the *requirements.yaml* to the *Chart.yaml*
- After running `helm dependency update`, a *Chart.lock* file is generated containing the same structure used in the previous *requirements.lock*
- The different fields present in the *Chart.yaml* file has been ordered alphabetically in a homogeneous way for all the Bitnami Helm Charts

#### Considerations when upgrading to this version

- If you want to upgrade to this version from a previous one installed with Helm v3, you shouldn't face any issues
- If you want to upgrade to this version using Helm v2, this scenario is not supported as this version doesn't support Helm v2 anymore
- If you installed the previous version with Helm v2 and wants to upgrade to this version with Helm v3, please refer to the [official Helm documentation](https://helm.sh/docs/topics/v2_v3_migration/#migration-use-cases) about migrating from Helm v2 to v3

#### Useful links

- <https://docs.vmware.com/en/VMware-Tanzu-Application-Catalog/services/tutorials/GUID-resolve-helm2-helm3-post-migration-issues-index.html>
- <https://helm.sh/docs/topics/v2_v3_migration/>
- <https://helm.sh/blog/migrate-from-helm-v2-to-helm-v3/>

### To 12.0.0

Several changes were introduced that breaks backwards compatibility:

- Ports names were prefixed with the protocol to comply with Istio (see <https://istio.io/docs/ops/deployment/requirements/>).
- Labels are adapted to follow the Helm charts best practices.
- Elasticsearch data pods are now deployed in parallel in order to bootstrap the cluster and be discovered.

### To 11.0.0

Elasticsearch master pods are now deployed in parallel in order to bootstrap the cluster and be discovered.

The field `podManagementPolicy` can't be updated in a StatefulSet, so you need to destroy it before you upgrade the chart to this version.

```console
kubectl delete statefulset elasticsearch-master
helm upgrade <DEPLOYMENT_NAME> oci://REGISTRY_NAME/REPOSITORY_NAME/elasticsearch
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

### TO 10.0.0

In this version, Kibana was added as dependent chart. More info about how to enable and work with this bundled Kibana in the ["Enable bundled Kibana"](#enable-bundled-kibana) section.

### To 9.0.0

Elasticsearch master nodes store the cluster status at `/bitnami/elasticsearch/data`. Among other things this includes the UUID of the elasticsearch cluster. Without a persistent data store for this data, the UUID of a cluster could change if k8s node(s) hosting the es master nodes go down and are scheduled on some other master node. In the event that this happens, the data nodes will no longer be able to join a cluster as the uuid changed resulting in a broken cluster.

To resolve such issues, PVC's are now attached for master node data persistence.

---

Helm performs a lookup for the object based on its group (apps), version (v1), and kind (Deployment). Also known as its GroupVersionKind, or GVK. Changing the GVK is considered a compatibility breaker from Kubernetes' point of view, so you cannot "upgrade" those objects to the new GVK in-place. Earlier versions of Helm 3 did not perform the lookup correctly which has since been fixed to match the spec.

In [4dfac075aacf74405e31ae5b27df4369e84eb0b0](https://github.com/bitnami/charts/commit/4dfac075aacf74405e31ae5b27df4369e84eb0b0) the `apiVersion` of the deployment resources was updated to `apps/v1` in tune with the api's deprecated, resulting in compatibility breakage.

### To 7.4.0

This version also introduces `bitnami/common`, a [library chart](https://helm.sh/docs/topics/library_charts/#helm) as a dependency. More documentation about this new utility could be found [here](https://github.com/bitnami/charts/tree/main/bitnami/common#bitnami-common-library-chart). Please, make sure that you have updated the chart dependencies before executing any upgrade.

### To 7.0.0

This version enabled by default the initContainer that modify some kernel settings to meet the Elasticsearch requirements. More info in the ["Default kernel settings"](#default-kernel-settings) section.
You can disable the initContainer using the `sysctlImage.enabled=false` parameter.

### To 3.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 3.0.0. The following example assumes that the release name is elasticsearch:

```console
kubectl patch deployment elasticsearch-coordinating --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
kubectl patch deployment elasticsearch-ingest --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
kubectl patch deployment elasticsearch-master --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
kubectl patch deployment elasticsearch-metrics --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
kubectl delete statefulset elasticsearch-data --cascade=false
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