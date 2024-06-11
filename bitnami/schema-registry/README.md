<!--- app-name: Confluent Schema Registry -->

# Bitnami package for Confluent Schema Registry

Confluent Schema Registry provides a RESTful interface by adding a serving layer for your metadata on top of Kafka. It expands Kafka enabling support for Apache Avro, JSON, and Protobuf schemas.

[Overview of Confluent Schema Registry](https://www.confluent.io)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/schema-registry
```

Looking to use Confluent Schema Registry in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the enterprise edition of Bitnami Application Catalog.

## Introduction

This chart bootstraps a [Schema Registry](https://github.com/bitnami/containers/tree/main/bitnami/schema-registry) statefulset on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/schema-registry
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

These commands deploy Schema Registry on the Kubernetes cluster with the default configuration. The [parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Configuration and installation details

### Resource requests and limits

Bitnami charts allow setting resource requests and limits for all containers inside the chart deployment. These are inside the `resources` value (check parameter table). Setting requests is essential for production workloads and these should be adapted to your specific use case.

To make this process easier, the chart contains the `resourcesPreset` values, which automatically sets the `resources` section according to different presets. Check these presets in [the bitnami/common chart](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15). However, in production workloads using `resourcePreset` is discouraged as it may not fully adapt to your specific needs. Find more information on container resource management in the [official Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).

### [Rolling VS Immutable tags](https://docs.vmware.com/en/VMware-Tanzu-Application-Catalog/services/tutorials/GUID-understand-rolling-tags-containers-index.html)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Enable authentication for Kafka

You can configure different authentication protocols for each listener you configure in Kafka. For instance, you can use `sasl_tls` authentication for client communications, while using `tls` for inter-broker communications. This table shows the available protocols and the security they provide:

| Method    | Authentication               | Encryption via TLS |
|-----------|------------------------------|--------------------|
| plaintext | None                         | No                 |
| tls       | None                         | Yes                |
| mtls      | Yes (two-way authentication) | Yes                |
| sasl      | Yes (via SASL)               | No                 |
| sasl_tls  | Yes (via SASL)               | Yes                |

Configure the authentication protocols for client and inter-broker communications by setting the *auth.clientProtocol* and *auth.interBrokerProtocol* parameters to the desired ones, respectively.

If you enabled SASL authentication on any listener, you can set the SASL credentials using the parameters below:

- `kafka.auth.sasl.jaas.clientUsers`/`kafka.auth.sasl.jaas.clientPasswords`: when enabling SASL authentication for communications with clients.
- `kafka.auth.sasl.jaas.interBrokerUser`/`kafka.auth.sasl.jaas.interBrokerPassword`:  when enabling SASL authentication for inter-broker communications.
- `kafka.auth.jaas.zookeeperUser`/`kafka.auth.jaas.zookeeperPassword`: In the case that the Zookeeper chart is deployed with SASL authentication enabled.

For instance, you can deploy the chart with the following parameters:

```console
kafka.auth.clientProtocol=sasl
kafka.auth.jaas.clientUsers[0]=clientUser
kafka.auth.jaas.clientPasswords[0]=clientPassword
```

In order to configure TLS authentication/encryption, you **can** create a secret per Kafka broker you have in the cluster containing the Java Key Stores (JKS) files: the truststore (`kafka.truststore.jks`) and the keystore (`kafka.keystore.jks`). Then, you need pass the secret names with the `kafka.auth.tls.existingSecrets` parameter when deploying the chart.

> **Note**: If the JKS files are password protected (recommended), you will need to provide the password to get access to the keystores. To do so, use the `kafka.auth.tls.password` parameter to provide your password.

For instance, to configure TLS authentication on a cluster with 2 Kafka brokers, and 1 Schema Registry replica use the commands below to create the secrets:

```console
kubectl create secret generic schema-registry-jks --from-file=/schema-registry.truststore.jks --from-file=./schema-registry-0.keystore.jks
kubectl create secret generic kafka-jks-0 --from-file=kafka.truststore.jks=./kafka.truststore.jks --from-file=kafka.keystore.jks=./kafka-0.keystore.jks
kubectl create secret generic kafka-jks-1 --from-file=kafka.truststore.jks=./kafka.truststore.jks --from-file=kafka.keystore.jks=./kafka-1.keystore.jks
```

> **Note**: the command above assumes you already created the truststore and keystores files. This [script](https://raw.githubusercontent.com/confluentinc/confluent-platform-security-tools/master/kafka-generate-ssl.sh) can help you with the JKS files generation.

Then, deploy the chart with the following parameters:

```console
auth.kafka.jksSecret=schema-registry-jks
auth.kafka.keystorePassword=some-password
auth.kafka.truststorePassword=some-password
kafka.replicaCount=2
kafka.auth.clientProtocol=tls
kafka.auth.tls.existingSecrets[0]=kafka-jks-0
kafka.auth.tls.existingSecrets[1]=kafka-jks-1
kafka.auth.tls.password=jksPassword
```

In case you want to ignore hostname verification on Kafka certificates, set the parameter `auth.kafka.tls.endpointIdentificationAlgorithm` with an empty string `""`. In this case, you can reuse the same truststore and keystore for every Kafka broker and Schema Registry replica. For instance, to configure TLS authentication on a cluster with 2 Kafka brokers, and 1 Schema Registry replica use the commands below to create the secrets:

```console
kubectl create secret generic schema-registry-jks --from-file=schema-registry.truststore.jks=common.truststore.jks --from-file=schema-registry-0.keystore.jks=common.keystore.jks
kubectl create secret generic kafka-jks --from-file=kafka.truststore.jks=common.truststore.jks --from-file=kafka.keystore.jks=common.keystore.jks
```

### Adding extra flags

In case you want to add extra environment variables to Schema Registry, you can use `extraEnvs` parameter. For instance:

```yaml
extraEnvs:
  - name: FOO
    value: BAR
```

### Using custom configuration

This helm chart supports using custom configuration for Schema Registry.

You can specify the configuration for Schema Registry using the `configuration` paramater. In addition, you can also set an external configmap with the configuration file. This is done by setting the `existingConfigmap` parameter.

### Sidecars and Init Containers

If you have a need for additional containers to run within the same pod as Schema Registry (e.g. an additional metrics or logging exporter), you can do so via the `sidecars` config parameter. Simply define your container according to the Kubernetes container spec.

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
        containerPort: 1234
```

### Using an external Kafka

Sometimes you may want to have Schema Registry connect to an external Kafka cluster rather than installing one as dependency. To do this, the chart allows you to specify credentials for an existing Kafka cluster under the [`externalKafka` parameter](#kafka-chart-parameters). You should also disable the Kafka installation with the `kafka.enabled` option.

For example, use the parameters below to connect Schema Registry with an existing Kafka installation using SASL authentication:

```console
kafka.enabled=false
externalKafka.brokers=SASL_PLAINTEXT://kafka-0.kafka-headless.default.svc.cluster.local:9092
externalKafka.auth.protocol=sasl
externalKafka.auth.jaas.user=myuser
externalKafka.auth.jaas.password=mypassword
```

Alternatively, you can use an existing secret with a key "client-passwords":

```console
kafka.enabled=false
externalKafka.brokers=SASL_PLAINTEXT://kafka-0.kafka-headless.default.svc.cluster.local:9092
externalKafka.auth.protocol=sasl
externalKafka.auth.jaas.user=myuser
externalKafka.auth.jaas.existingSecret=my-secret
```

### Ingress

This chart provides support for Ingress resources. If you have an ingress controller installed on your cluster, such as [nginx-ingress-controller](https://github.com/bitnami/charts/tree/main/bitnami/nginx-ingress-controller) or [contour](https://github.com/bitnami/charts/tree/main/bitnami/contour) you can utilize the ingress controller to serve your application.
To enable Ingress integration, set `ingress.enabled` to `true`. The `ingress.hostname` property can be used to set the host name.

#### Hosts

Most likely you will only want to have one hostname that maps to this Schema Registry installation. If that's your case, the property `ingress.hostname` will set it. However, it is possible to have more than one host. To facilitate this, the `ingress.extraHosts` object is can be specified as an array. You can also use `ingress.extraTLS` to add the TLS configuration for extra hosts.

For each host indicated at `ingress.extraHosts`, please indicate a `name`, `path`, and any `annotations` that you may want the ingress controller to know about.

For annotations, please see [this document](https://github.com/kubernetes/ingress-nginx/blob/main/docs/user-guide/nginx-configuration/annotations.md). Not all annotations are supported by all ingress controllers, but this document does a good job of indicating which annotation is supported by many popular ingress controllers.

## Parameters

### Global parameters

| Name                                                  | Description                                                                                                                                                                                                                                                                                                                                                         | Value  |
| ----------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------ |
| `global.imageRegistry`                                | Global Docker image registry                                                                                                                                                                                                                                                                                                                                        | `""`   |
| `global.imagePullSecrets`                             | Global Docker registry secret names as an array                                                                                                                                                                                                                                                                                                                     | `[]`   |
| `global.compatibility.openshift.adaptSecurityContext` | Adapt the securityContext sections of the deployment to make them compatible with Openshift restricted-v2 SCC: remove runAsUser, runAsGroup and fsGroup and let the platform use their allowed default IDs. Possible values: auto (apply if the detected running cluster is Openshift), force (perform the adaptation always), disabled (do not perform adaptation) | `auto` |
| `kubeVersion`                                         | Override Kubernetes version                                                                                                                                                                                                                                                                                                                                         | `""`   |

### Common parameters

| Name                     | Description                                                                                          | Value           |
| ------------------------ | ---------------------------------------------------------------------------------------------------- | --------------- |
| `nameOverride`           | String to partially override airflow.fullname template with a string (will prepend the release name) | `""`            |
| `fullnameOverride`       | String to fully override airflow.fullname template with a string                                     | `""`            |
| `namespaceOverride`      | String to fully override common.names.namespace                                                      | `""`            |
| `commonLabels`           | Labels to add to all deployed objects                                                                | `{}`            |
| `commonAnnotations`      | Annotations to add to all deployed objects                                                           | `{}`            |
| `clusterDomain`          | Kubernetes cluster domain name                                                                       | `cluster.local` |
| `extraDeploy`            | Array of extra objects to deploy with the release                                                    | `[]`            |
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden)              | `false`         |
| `diagnosticMode.command` | Command to override all containers in the deployment                                                 | `["sleep"]`     |
| `diagnosticMode.args`    | Args to override all containers in the deployment                                                    | `["infinity"]`  |

### Schema Registry parameters

| Name                                            | Description                                                                                                     | Value                             |
| ----------------------------------------------- | --------------------------------------------------------------------------------------------------------------- | --------------------------------- |
| `image.registry`                                | Schema Registry image registry                                                                                  | `REGISTRY_NAME`                   |
| `image.repository`                              | Schema Registry image repository                                                                                | `REPOSITORY_NAME/schema-registry` |
| `image.digest`                                  | Schema Registry image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag | `""`                              |
| `image.pullPolicy`                              | Schema Registry image pull policy                                                                               | `IfNotPresent`                    |
| `image.pullSecrets`                             | Schema Registry image pull secrets                                                                              | `[]`                              |
| `image.debug`                                   | Enable image debug mode                                                                                         | `false`                           |
| `command`                                       | Override default container command (useful when using custom images)                                            | `[]`                              |
| `args`                                          | Override default container args (useful when using custom images)                                               | `[]`                              |
| `automountServiceAccountToken`                  | Mount Service Account token in pod                                                                              | `false`                           |
| `hostAliases`                                   | Schema Registry pods host aliases                                                                               | `[]`                              |
| `podLabels`                                     | Extra labels for Schema Registry pods                                                                           | `{}`                              |
| `configuration`                                 | Specify content for schema-registry.properties. Auto-generated based on other parameters when not specified     | `{}`                              |
| `existingConfigmap`                             | Name of existing ConfigMap with Schema Registry configuration                                                   | `""`                              |
| `log4j`                                         | Schema Registry Log4J Configuration (optional)                                                                  | `{}`                              |
| `existingLog4jConfigMap`                        | Name of existing ConfigMap containing a custom log4j.properties file.                                           | `""`                              |
| `auth.tls.enabled`                              | Enable TLS configuration to provide to be used when a listener uses HTTPS                                       | `false`                           |
| `auth.tls.jksSecret`                            | Existing secret containing the truststore and one keystore per Schema Registry replica                          | `""`                              |
| `auth.tls.keystorePassword`                     | Password to access the keystore when it's password-protected                                                    | `""`                              |
| `auth.tls.truststorePassword`                   | Password to access the truststore when it's password-protected                                                  | `""`                              |
| `auth.tls.clientAuthentication`                 | Client authentication configuration.                                                                            | `NONE`                            |
| `auth.kafka.jksSecret`                          | Existing secret containing the truststore and one keystore per Schema Registry replica                          | `""`                              |
| `auth.kafka.tlsEndpointIdentificationAlgorithm` | The endpoint identification algorithm used validate brokers hostnames                                           | `https`                           |
| `auth.kafka.keystorePassword`                   | Password to access the keystore when it's password-protected                                                    | `""`                              |
| `auth.kafka.truststorePassword`                 | Password to access the truststore when it's password-protected                                                  | `""`                              |
| `auth.kafka.saslMechanism`                      | Mechanism that schema registry will use to connect to kafka. Allowed: PLAIN, SCRAM-SHA-256, SCRAM-SHA-512       | `PLAIN`                           |
| `listeners`                                     | Comma-separated list of listeners that listen for API requests over either HTTP or HTTPS                        | `http://0.0.0.0:8081`             |
| `avroCompatibilityLevel`                        | Avro compatibility type                                                                                         | `backward`                        |
| `extraEnvVars`                                  | Extra environment variables to be set on Schema Registry container                                              | `[]`                              |
| `extraEnvVarsCM`                                | Name of existing ConfigMap containing extra env vars                                                            | `""`                              |
| `extraEnvVarsSecret`                            | Name of existing Secret containing extra env vars                                                               | `""`                              |

### Schema Registry statefulset parameters

| Name                                                | Description                                                                                                                                                                                                       | Value            |
| --------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| `replicaCount`                                      | Number of Schema Registry replicas to deploy.                                                                                                                                                                     | `1`              |
| `updateStrategy.type`                               | Schema Registry statefulset strategy type                                                                                                                                                                         | `RollingUpdate`  |
| `nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                         | `""`             |
| `nodeAffinityPreset.key`                            | Node label key to match. Ignored if `affinity` is set                                                                                                                                                             | `""`             |
| `nodeAffinityPreset.values`                         | Node label values to match. Ignored if `affinity` is set                                                                                                                                                          | `[]`             |
| `affinity`                                          | Affinity for pod assignment                                                                                                                                                                                       | `{}`             |
| `nodeSelector`                                      | Node labels for pod assignment                                                                                                                                                                                    | `{}`             |
| `tolerations`                                       | Tolerations for pod assignment                                                                                                                                                                                    | `[]`             |
| `podManagementPolicy`                               | Statefulset Pod management policy, it needs to be Parallel to be able to complete the cluster join                                                                                                                | `OrderedReady`   |
| `podAnnotations`                                    | Annotations for Schema Registry pods                                                                                                                                                                              | `{}`             |
| `podAffinityPreset`                                 | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                               | `""`             |
| `podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                          | `soft`           |
| `priorityClassName`                                 | Schema Registry pod priority class name                                                                                                                                                                           | `""`             |
| `topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template                                                                                          | `{}`             |
| `schedulerName`                                     | Name of the k8s scheduler (other than default) for Schema Registry pods                                                                                                                                           | `""`             |
| `terminationGracePeriodSeconds`                     | Seconds Redmine pod needs to terminate gracefully                                                                                                                                                                 | `""`             |
| `lifecycleHooks`                                    | for the Schema Registry container(s) to automate configuration before or after startup                                                                                                                            | `{}`             |
| `podSecurityContext.enabled`                        | Enabled Controller pods' Security Context                                                                                                                                                                         | `true`           |
| `podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                | `Always`         |
| `podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                       | `[]`             |
| `podSecurityContext.fsGroup`                        | Set Controller pod's Security Context fsGroup                                                                                                                                                                     | `1001`           |
| `podSecurityContext.sysctls`                        | sysctl settings of the Schema Registry pods                                                                                                                                                                       | `[]`             |
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
| `livenessProbe.enabled`                             | Enable livenessProbe                                                                                                                                                                                              | `true`           |
| `livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                           | `10`             |
| `livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                  | `20`             |
| `livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                 | `1`              |
| `livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                               | `6`              |
| `livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                               | `1`              |
| `readinessProbe.enabled`                            | Enable readinessProbe                                                                                                                                                                                             | `true`           |
| `readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                          | `10`             |
| `readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                 | `20`             |
| `readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                | `1`              |
| `readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                              | `6`              |
| `readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                              | `1`              |
| `startupProbe.enabled`                              | Enable startupProbe                                                                                                                                                                                               | `false`          |
| `startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                            | `10`             |
| `startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                   | `5`              |
| `startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                  | `1`              |
| `startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                | `20`             |
| `startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                | `1`              |
| `customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                                                                                                               | `{}`             |
| `customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                                                                                                                              | `{}`             |
| `customStartupProbe`                                | Custom startupProbe that overrides the default one                                                                                                                                                                | `{}`             |
| `extraVolumes`                                      | Optionally specify extra list of additional volumes for schema-registry pods                                                                                                                                      | `[]`             |
| `extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for schema-registry container(s)                                                                                                                         | `[]`             |
| `initContainers`                                    | Add additional init containers to the Schema Registry pods.                                                                                                                                                       | `[]`             |
| `sidecars`                                          | Add additional sidecar containers to the Schema Registry pods.                                                                                                                                                    | `[]`             |
| `pdb.create`                                        | Enable/disable a Pod Disruption Budget creation                                                                                                                                                                   | `true`           |
| `pdb.minAvailable`                                  | Minimum number/percentage of pods that must still be available after the eviction                                                                                                                                 | `""`             |
| `pdb.maxUnavailable`                                | Maximum number/percentage of pods that may be made unavailable after the eviction. Defaults to `1` if both `pdb.minAvailable` and `pdb.maxUnavailable` are empty.                                                 | `""`             |
| `autoscaling.enabled`                               | Enable autoscaling for replicas                                                                                                                                                                                   | `false`          |
| `autoscaling.minReplicas`                           | Minimum number of replicas                                                                                                                                                                                        | `1`              |
| `autoscaling.maxReplicas`                           | Maximum number of replicas                                                                                                                                                                                        | `11`             |
| `autoscaling.targetCPU`                             | Target CPU utilization percentage                                                                                                                                                                                 | `""`             |
| `autoscaling.targetMemory`                          | Target Memory utilization percentage                                                                                                                                                                              | `""`             |
| `autoscaling.customPodMetrics`                      | allows you to set a list of custom metrics to trigger the scaling.                                                                                                                                                | `[]`             |

### Exposure Parameters

| Name                                    | Description                                                                                           | Value                    |
| --------------------------------------- | ----------------------------------------------------------------------------------------------------- | ------------------------ |
| `service.type`                          | Kubernetes service type                                                                               | `ClusterIP`              |
| `service.ports.http`                    | Service HTTP port                                                                                     | `8081`                   |
| `service.nodePorts.http`                | Service HTTP node port                                                                                | `""`                     |
| `service.clusterIP`                     | Schema Registry service clusterIP IP                                                                  | `""`                     |
| `service.externalTrafficPolicy`         | Enable client source IP preservation                                                                  | `Cluster`                |
| `service.loadBalancerIP`                | loadBalancerIP if service type is LoadBalancer                                                        | `""`                     |
| `service.loadBalancerSourceRanges`      | Address that are allowed when service is LoadBalancer                                                 | `[]`                     |
| `service.annotations`                   | Annotations for Schema Registry service                                                               | `{}`                     |
| `service.extraPorts`                    | Extra ports to expose in Schema Registry service (normally used with the `sidecars` value)            | `[]`                     |
| `service.sessionAffinity`               | Control where client requests go, to the same pod or round-robin                                      | `None`                   |
| `service.sessionAffinityConfig`         | Additional settings for the sessionAffinity                                                           | `{}`                     |
| `service.headless.annotations`          | Annotations for the headless service.                                                                 | `{}`                     |
| `networkPolicy.enabled`                 | Specifies whether a NetworkPolicy should be created                                                   | `true`                   |
| `networkPolicy.allowExternal`           | Don't require client label for connections                                                            | `true`                   |
| `networkPolicy.allowExternalEgress`     | Allow the pod to access any range of port and all destinations.                                       | `true`                   |
| `networkPolicy.extraIngress`            | Add extra ingress rules to the NetworkPolicy                                                          | `[]`                     |
| `networkPolicy.extraEgress`             | Add extra ingress rules to the NetworkPolicy                                                          | `[]`                     |
| `networkPolicy.ingressNSMatchLabels`    | Labels to match to allow traffic from other namespaces                                                | `{}`                     |
| `networkPolicy.ingressNSPodMatchLabels` | Pod labels to match to allow traffic from other namespaces                                            | `{}`                     |
| `ingress.enabled`                       | Enable ingress controller resource                                                                    | `false`                  |
| `ingress.hostname`                      | Default host for the ingress resource                                                                 | `schema-registry.local`  |
| `ingress.annotations`                   | Ingress annotations                                                                                   | `{}`                     |
| `ingress.extraHosts`                    | An array with additional hostname(s) to be covered with the ingress record                            | `[]`                     |
| `ingress.extraTls`                      | TLS configuration for additional hostname(s) to be covered with this ingress record                   | `[]`                     |
| `ingress.secrets`                       | Custom TLS certificates as secrets                                                                    | `[]`                     |
| `ingress.enabled`                       | Enable ingress record generation for Schema Registry                                                  | `false`                  |
| `ingress.pathType`                      | Ingress path type                                                                                     | `ImplementationSpecific` |
| `ingress.apiVersion`                    | Force Ingress API version (automatically detected if not set)                                         | `""`                     |
| `ingress.hostname`                      | Default host for the ingress record                                                                   | `schema-registry.local`  |
| `ingress.ingressClassName`              | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                         | `""`                     |
| `ingress.path`                          | Default path for the ingress record                                                                   | `/`                      |
| `ingress.annotations`                   | Additional custom annotations for the ingress record                                                  | `{}`                     |
| `ingress.tls`                           | Enable TLS configuration for the host defined at `ingress.hostname` parameter                         | `false`                  |
| `ingress.selfSigned`                    | Create a TLS secret for this ingress record using self-signed certificates generated by Helm          | `false`                  |
| `ingress.extraHosts`                    | An array with additional hostname(s) to be covered with the ingress record                            | `[]`                     |
| `ingress.extraPaths`                    | An array with additional arbitrary paths that may need to be added to the ingress under the main host | `[]`                     |
| `ingress.extraTls`                      | TLS configuration for additional hostname(s) to be covered with this ingress record                   | `[]`                     |
| `ingress.secrets`                       | Custom TLS certificates as secrets                                                                    | `[]`                     |
| `ingress.extraRules`                    | Additional rules to be covered with this ingress record                                               | `[]`                     |

### RBAC parameters

| Name                                          | Description                                                      | Value   |
| --------------------------------------------- | ---------------------------------------------------------------- | ------- |
| `serviceAccount.create`                       | Enable the creation of a ServiceAccount for Schema Registry pods | `true`  |
| `serviceAccount.name`                         | Name of the created ServiceAccount to use                        | `""`    |
| `serviceAccount.annotations`                  | Additional Service Account annotations (evaluated as a template) | `{}`    |
| `serviceAccount.automountServiceAccountToken` | Automount service account token for the server service account   | `false` |

### Kafka chart parameters

| Name                                | Description                                                                                                                  | Value                                |
| ----------------------------------- | ---------------------------------------------------------------------------------------------------------------------------- | ------------------------------------ |
| `kafka.enabled`                     | Enable/disable Kafka chart installation                                                                                      | `true`                               |
| `kafka.controller.replicaCount`     | Number of Kafka controller-eligible (controller+broker) nodes                                                                | `1`                                  |
| `kafka.listeners.client.protocol`   | Authentication protocol for communications with clients. Allowed protocols: `PLAINTEXT`, `SASL_PLAINTEXT`, `SASL_SSL`, `SSL` | `PLAINTEXT`                          |
| `kafka.service.ports.client`        | Kafka svc port for client connections                                                                                        | `9092`                               |
| `kafka.extraConfig`                 | Additional configuration to be appended at the end of the generated Kafka configuration file.                                | `offsets.topic.replication.factor=1` |
| `kafka.sasl.client.users`           | Comma-separated list of usernames for Kafka client listener when SASL is enabled                                             | `["user"]`                           |
| `kafka.sasl.client.passwords`       | Comma-separated list of passwords for client listener when SASL is enabled, must match the number of client.users            | `""`                                 |
| `externalKafka.brokers`             | Array of Kafka brokers to connect to. Format: protocol://broker_hostname:port                                                | `["PLAINTEXT://localhost:9092"]`     |
| `externalKafka.listener.protocol`   | Kafka listener protocol. Allowed protocols: PLAINTEXT, SASL_PLAINTEXT, SASL_SSL and SSL                                      | `PLAINTEXT`                          |
| `externalKafka.sasl.user`           | User for SASL authentication                                                                                                 | `user`                               |
| `externalKafka.sasl.password`       | Password for SASL authentication                                                                                             | `""`                                 |
| `externalKafka.sasl.existingSecret` | Name of the existing secret containing a password for SASL authentication (under the key named "client-passwords")           | `""`                                 |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
  --set replicaCount=2 \
    oci://REGISTRY_NAME/REPOSITORY_NAME/schema-registry
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The above command installs Schema Registry chart with 2 replicas.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml oci://REGISTRY_NAME/REPOSITORY_NAME/schema-registry
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.
> **Tip**: You can use the default [values.yaml](https://github.com/bitnami/charts/tree/main/bitnami/schema-registry/values.yaml)

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 19.0.0

This major updates the Kafka subchart to its newest major, 29.0.0. For more information on this subchart's major, please refer to [Kafka upgrade notes](https://github.com/bitnami/charts/tree/main/bitnami/kafka#to-2900).

### To 18.0.0

This major bump changes the following security defaults:

- `runAsGroup` is changed from `0` to `1001`
- `readOnlyRootFilesystem` is set to `true`
- `resourcesPreset` is changed from `none` to the minimum size working in our test suites (NOTE: `resourcesPreset` is not meant for production usage, but `resources` adapted to your use case).
- `global.compatibility.openshift.adaptSecurityContext` is changed from `disabled` to `auto`.

This could potentially break any customization or init scripts used in your deployment. If this is the case, change the default values to the previous ones.

### To 16.0.0

This major updates the Kafka subchart to its newest major, 26.0.0. For more information on this subchart's major, please refer to [Kafka upgrade notes](https://github.com/bitnami/charts/tree/main/bitnami/kafka#to-2600).

### To 14.0.0

This major updates the Kafka subchart to its newest major, 25.0.0. For more information on this subchart's major, please refer to [Kafka upgrade notes](https://github.com/bitnami/charts/tree/main/bitnami/kafka#to-2500).

### To 13.0.0

This major updates the Kafka subchart to its newest major, 24.0.0. This new version refactors the Kafka chart architecture and requires manual actions during the upgrade. For more information on this subchart's major, please refer to [Kafka upgrade notes](https://github.com/bitnami/charts/tree/main/bitnami/kafka#to-2400).

Additionally, `externalKafka` parameters have been renamed to match the new kafka format:

- `externalKafka.auth.protocol` has been renamed as `externalKafka.listener.protocol`.
- `externalKafka.auth.jaas.user` has been renamed as `externalKafka.sasl.user`.
- `externalKafka.auth.jaas.password` has been renamed as `externalKafka.sasl.password`.
- `externalKafka.auth.jaas.existingSecret` has been renamed as `externalKafka.sasl.existingSecret`.

### To 10.0.0

This major updates the Kafka subchart to its newest major, 22.0.0. This new version of Kafka uses Kraft by default. For more information on this subchart's major, please refer to [Kafka upgrade notes](https://github.com/bitnami/charts/tree/main/bitnami/kafka#to-2200).

### To 9.0.0

This major updates the Kafka subchart to its newest major, 21.0.0. For more information on this subchart's major, please refer to [Kafka upgrade notes](https://github.com/bitnami/charts/tree/main/bitnami/kafka#to-2100).

### To 8.0.0

This major updates the Kafka subchart to its newest major, 20.0.0. For more information on this subchart's major, please refer to [Kafka upgrade notes](https://github.com/bitnami/charts/tree/main/bitnami/kafka#to-2000).

### To 6.0.0

This major updates the Kafka subchart to its newest major, 19.0.0. For more information on this subchart's major, please refer to [Kafka upgrade notes](https://github.com/bitnami/charts/tree/main/bitnami/kafka#to-1900).

### To 4.0.0

This version bump the version of charts used as dependency in a major. Kafka from 12.X.X to 18.X.X ([here](https://github.com/bitnami/charts/tree/main/bitnami/kafka#to-1800) you can see the changes introduced in this version).

### To 3.0.0

This major release renames several values and adds new features, in order to be inline with the rest of assets in the Bitnami charts repository.

Affected values:

- `strategyType` is replaced by `updateStrategy`
- `service.port` is renamed to `service.ports.http`
- `service.nodePort` is renamed to `service.nodePorts.http`
- `ingress.certManager` is removed, please use `ingress.annotations`to add any third party feature

### To 2.0.0

This version bump the version of charts used as dependency in a major. Kafka from 11.X.X to 12.X.X ([here](https://github.com/bitnami/charts/tree/main/bitnami/kafka#to-1220) you can see the changes introduced in this version) and common from 0.X.X to 1.X.X ([here](https://github.com/bitnami/charts/tree/main/bitnami/common#to-100) you can find the changes introduced in this version). Mainly the changes in both subcharts are related to the Helm v2 EOL.

### To 1.0.0

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