<!--- app-name: Confluent Schema Registry -->

# Bitnami Confluent Schema Registry Stack

Confluent Schema Registry provides a RESTful interface by adding a serving layer for your metadata on top of Kafka. It expands Kafka enabling support for Apache Avro, JSON, and Protobuf schemas.

[Overview of Confluent Schema Registry](https://www.confluent.io)


                           
## TL;DR

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install my-release bitnami/schema-registry
```

## Introduction

This chart bootstraps a [Schema Registry](https://github.com/bitnami/bitnami-docker-schema-registry) statefulset on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- PV provisioner support in the underlying infrastructure
- ReadWriteMany volumes for deployment scaling

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install my-release bitnami/schema-registry
```

These commands deploy Schema Registry on the Kubernetes cluster with the default configuration. The [parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` chart:

```bash
helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

### Global parameters

| Name                      | Description                                     | Value |
| ------------------------- | ----------------------------------------------- | ----- |
| `global.imageRegistry`    | Global Docker image registry                    | `""`  |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]`  |
| `global.storageClass`     | Global StorageClass for Persistent Volume(s)    | `""`  |
| `kubeVersion`             | Override Kubernetes version                     | `""`  |


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

| Name                                            | Description                                                                                                     | Value                     |
| ----------------------------------------------- | --------------------------------------------------------------------------------------------------------------- | ------------------------- |
| `image.registry`                                | Schema Registry image registry                                                                                  | `docker.io`               |
| `image.repository`                              | Schema Registry image repository                                                                                | `bitnami/schema-registry` |
| `image.tag`                                     | Schema Registry image tag (immutable tags are recommended)                                                      | `7.2.1-debian-11-r0`      |
| `image.digest`                                  | Schema Registry image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag | `""`                      |
| `image.pullPolicy`                              | Schema Registry image pull policy                                                                               | `IfNotPresent`            |
| `image.pullSecrets`                             | Schema Registry image pull secrets                                                                              | `[]`                      |
| `image.debug`                                   | Enable image debug mode                                                                                         | `false`                   |
| `command`                                       | Override default container command (useful when using custom images)                                            | `[]`                      |
| `args`                                          | Override default container args (useful when using custom images)                                               | `[]`                      |
| `hostAliases`                                   | Schema Registry pods host aliases                                                                               | `[]`                      |
| `podLabels`                                     | Extra labels for Schema Registry pods                                                                           | `{}`                      |
| `configuration`                                 | Specify content for schema-registry.properties. Auto-generated based on other parameters when not specified     | `{}`                      |
| `existingConfigmap`                             | Name of existing ConfigMap with Schema Registry configuration                                                   | `""`                      |
| `log4j`                                         | Schema Registry Log4J Configuration (optional)                                                                  | `{}`                      |
| `existingLog4jConfigMap`                        | Name of existing ConfigMap containing a custom log4j.properties file.                                           | `""`                      |
| `auth.tls.enabled`                              | Enable TLS configuration to provide to be used when a listener uses HTTPS                                       | `false`                   |
| `auth.tls.jksSecret`                            | Existing secret containing the truststore and one keystore per Schema Registry replica                          | `""`                      |
| `auth.tls.keystorePassword`                     | Password to access the keystore when it's password-protected                                                    | `""`                      |
| `auth.tls.truststorePassword`                   | Password to access the truststore when it's password-protected                                                  | `""`                      |
| `auth.tls.clientAuthentication`                 | Client authentication configuration.                                                                            | `NONE`                    |
| `auth.kafka.jksSecret`                          | Existing secret containing the truststore and one keystore per Schema Registry replica                          | `""`                      |
| `auth.kafka.tlsEndpointIdentificationAlgorithm` | The endpoint identification algorithm used validate brokers hostnames                                           | `https`                   |
| `auth.kafka.keystorePassword`                   | Password to access the keystore when it's password-protected                                                    | `""`                      |
| `auth.kafka.truststorePassword`                 | Password to access the truststore when it's password-protected                                                  | `""`                      |
| `auth.kafka.saslMechanism`                      | Mechanism that schema registry will use to connect to kafka. Allowed: PLAIN, SCRAM-SHA-256, SCRAM-SHA-512       | `PLAIN`                   |
| `listeners`                                     | Comma-separated list of listeners that listen for API requests over either HTTP or HTTPS                        | `http://0.0.0.0:8081`     |
| `avroCompatibilityLevel`                        | Avro compatibility type                                                                                         | `backward`                |
| `extraEnvVars`                                  | Extra environment variables to be set on Schema Registry container                                              | `[]`                      |
| `extraEnvVarsCM`                                | Name of existing ConfigMap containing extra env vars                                                            | `""`                      |
| `extraEnvVarsSecret`                            | Name of existing Secret containing extra env vars                                                               | `""`                      |


### Schema Registry statefulset parameters

| Name                                 | Description                                                                                                              | Value           |
| ------------------------------------ | ------------------------------------------------------------------------------------------------------------------------ | --------------- |
| `replicaCount`                       | Number of Schema Registry replicas to deploy.                                                                            | `1`             |
| `updateStrategy.type`                | Schema Registry statefulset strategy type                                                                                | `RollingUpdate` |
| `nodeAffinityPreset.type`            | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                | `""`            |
| `nodeAffinityPreset.key`             | Node label key to match. Ignored if `affinity` is set                                                                    | `""`            |
| `nodeAffinityPreset.values`          | Node label values to match. Ignored if `affinity` is set                                                                 | `[]`            |
| `affinity`                           | Affinity for pod assignment                                                                                              | `{}`            |
| `nodeSelector`                       | Node labels for pod assignment                                                                                           | `{}`            |
| `tolerations`                        | Tolerations for pod assignment                                                                                           | `[]`            |
| `podManagementPolicy`                | Statefulset Pod management policy, it needs to be Parallel to be able to complete the cluster join                       | `OrderedReady`  |
| `podAnnotations`                     | Annotations for Schema Registry pods                                                                                     | `{}`            |
| `podAffinityPreset`                  | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                      | `""`            |
| `podAntiAffinityPreset`              | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                 | `soft`          |
| `priorityClassName`                  | Schema Registry pod priority class name                                                                                  | `""`            |
| `topologySpreadConstraints`          | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template | `{}`            |
| `schedulerName`                      | Name of the k8s scheduler (other than default) for Schema Registry pods                                                  | `""`            |
| `terminationGracePeriodSeconds`      | Seconds Redmine pod needs to terminate gracefully                                                                        | `""`            |
| `lifecycleHooks`                     | for the Schema Registry container(s) to automate configuration before or after startup                                   | `{}`            |
| `podSecurityContext.enabled`         | Enabled Controller pods' Security Context                                                                                | `true`          |
| `podSecurityContext.fsGroup`         | Set Controller pod's Security Context fsGroup                                                                            | `1001`          |
| `podSecurityContext.sysctls`         | sysctl settings of the Schema Registry pods                                                                              | `[]`            |
| `containerSecurityContext.enabled`   | Enable container security context                                                                                        | `true`          |
| `containerSecurityContext.runAsUser` | User ID for the container                                                                                                | `1001`          |
| `resources.limits`                   | The resources limits for the container                                                                                   | `{}`            |
| `resources.requests`                 | The requested resources for the container                                                                                | `{}`            |
| `livenessProbe.enabled`              | Enable livenessProbe                                                                                                     | `true`          |
| `livenessProbe.initialDelaySeconds`  | Initial delay seconds for livenessProbe                                                                                  | `10`            |
| `livenessProbe.periodSeconds`        | Period seconds for livenessProbe                                                                                         | `20`            |
| `livenessProbe.timeoutSeconds`       | Timeout seconds for livenessProbe                                                                                        | `1`             |
| `livenessProbe.failureThreshold`     | Failure threshold for livenessProbe                                                                                      | `6`             |
| `livenessProbe.successThreshold`     | Success threshold for livenessProbe                                                                                      | `1`             |
| `readinessProbe.enabled`             | Enable readinessProbe                                                                                                    | `true`          |
| `readinessProbe.initialDelaySeconds` | Initial delay seconds for readinessProbe                                                                                 | `10`            |
| `readinessProbe.periodSeconds`       | Period seconds for readinessProbe                                                                                        | `20`            |
| `readinessProbe.timeoutSeconds`      | Timeout seconds for readinessProbe                                                                                       | `1`             |
| `readinessProbe.failureThreshold`    | Failure threshold for readinessProbe                                                                                     | `6`             |
| `readinessProbe.successThreshold`    | Success threshold for readinessProbe                                                                                     | `1`             |
| `startupProbe.enabled`               | Enable startupProbe                                                                                                      | `false`         |
| `startupProbe.initialDelaySeconds`   | Initial delay seconds for startupProbe                                                                                   | `10`            |
| `startupProbe.periodSeconds`         | Period seconds for startupProbe                                                                                          | `5`             |
| `startupProbe.timeoutSeconds`        | Timeout seconds for startupProbe                                                                                         | `1`             |
| `startupProbe.failureThreshold`      | Failure threshold for startupProbe                                                                                       | `20`            |
| `startupProbe.successThreshold`      | Success threshold for startupProbe                                                                                       | `1`             |
| `customLivenessProbe`                | Custom livenessProbe that overrides the default one                                                                      | `{}`            |
| `customReadinessProbe`               | Custom readinessProbe that overrides the default one                                                                     | `{}`            |
| `customStartupProbe`                 | Custom startupProbe that overrides the default one                                                                       | `{}`            |
| `extraVolumes`                       | Optionally specify extra list of additional volumes for MinIO&reg; pods                                                  | `[]`            |
| `extraVolumeMounts`                  | Optionally specify extra list of additional volumeMounts for MinIO&reg; container(s)                                     | `[]`            |
| `initContainers`                     | Add additional init containers to the Schema Registry pods.                                                              | `[]`            |
| `sidecars`                           | Add additional sidecar containers to the Schema Registry pods.                                                           | `[]`            |
| `pdb.create`                         | Enable/disable a Pod Disruption Budget creation                                                                          | `false`         |
| `pdb.minAvailable`                   | Minimum number/percentage of pods that must still be available after the eviction                                        | `1`             |
| `pdb.maxUnavailable`                 | Maximum number/percentage of pods that may be made unavailable after the eviction                                        | `""`            |
| `autoscaling.enabled`                | Enable autoscaling for replicas                                                                                          | `false`         |
| `autoscaling.minReplicas`            | Minimum number of replicas                                                                                               | `1`             |
| `autoscaling.maxReplicas`            | Maximum number of replicas                                                                                               | `11`            |
| `autoscaling.targetCPU`              | Target CPU utilization percentage                                                                                        | `""`            |
| `autoscaling.targetMemory`           | Target Memory utilization percentage                                                                                     | `""`            |


### Exposure Parameters

| Name                               | Description                                                                                           | Value                    |
| ---------------------------------- | ----------------------------------------------------------------------------------------------------- | ------------------------ |
| `service.type`                     | Kubernetes service type                                                                               | `ClusterIP`              |
| `service.ports.http`               | Service HTTP port                                                                                     | `8081`                   |
| `service.nodePorts.http`           | Service HTTP node port                                                                                | `""`                     |
| `service.clusterIP`                | Schema Registry service clusterIP IP                                                                  | `""`                     |
| `service.externalTrafficPolicy`    | Enable client source IP preservation                                                                  | `Cluster`                |
| `service.loadBalancerIP`           | loadBalancerIP if service type is LoadBalancer                                                        | `""`                     |
| `service.loadBalancerSourceRanges` | Address that are allowed when service is LoadBalancer                                                 | `[]`                     |
| `service.annotations`              | Annotations for Schema Registry service                                                               | `{}`                     |
| `service.extraPorts`               | Extra ports to expose in Schema Registry service (normally used with the `sidecars` value)            | `[]`                     |
| `service.sessionAffinity`          | Control where client requests go, to the same pod or round-robin                                      | `None`                   |
| `service.sessionAffinityConfig`    | Additional settings for the sessionAffinity                                                           | `{}`                     |
| `ingress.enabled`                  | Enable ingress controller resource                                                                    | `false`                  |
| `ingress.hostname`                 | Default host for the ingress resource                                                                 | `schema-registry.local`  |
| `ingress.annotations`              | Ingress annotations                                                                                   | `{}`                     |
| `ingress.extraHosts`               | An array with additional hostname(s) to be covered with the ingress record                            | `[]`                     |
| `ingress.extraTls`                 | TLS configuration for additional hostname(s) to be covered with this ingress record                   | `[]`                     |
| `ingress.secrets`                  | Custom TLS certificates as secrets                                                                    | `[]`                     |
| `ingress.enabled`                  | Enable ingress record generation for Schema Registry                                                  | `false`                  |
| `ingress.pathType`                 | Ingress path type                                                                                     | `ImplementationSpecific` |
| `ingress.apiVersion`               | Force Ingress API version (automatically detected if not set)                                         | `""`                     |
| `ingress.hostname`                 | Default host for the ingress record                                                                   | `schema-registry.local`  |
| `ingress.ingressClassName`         | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                         | `""`                     |
| `ingress.path`                     | Default path for the ingress record                                                                   | `/`                      |
| `ingress.annotations`              | Additional custom annotations for the ingress record                                                  | `{}`                     |
| `ingress.tls`                      | Enable TLS configuration for the host defined at `ingress.hostname` parameter                         | `false`                  |
| `ingress.selfSigned`               | Create a TLS secret for this ingress record using self-signed certificates generated by Helm          | `false`                  |
| `ingress.extraHosts`               | An array with additional hostname(s) to be covered with the ingress record                            | `[]`                     |
| `ingress.extraPaths`               | An array with additional arbitrary paths that may need to be added to the ingress under the main host | `[]`                     |
| `ingress.extraTls`                 | TLS configuration for additional hostname(s) to be covered with this ingress record                   | `[]`                     |
| `ingress.secrets`                  | Custom TLS certificates as secrets                                                                    | `[]`                     |
| `ingress.extraRules`               | Additional rules to be covered with this ingress record                                               | `[]`                     |


### RBAC parameters

| Name                                          | Description                                                      | Value  |
| --------------------------------------------- | ---------------------------------------------------------------- | ------ |
| `serviceAccount.create`                       | Enable the creation of a ServiceAccount for Schema Registry pods | `true` |
| `serviceAccount.name`                         | Name of the created ServiceAccount to use                        | `""`   |
| `serviceAccount.annotations`                  | Additional Service Account annotations (evaluated as a template) | `{}`   |
| `serviceAccount.automountServiceAccountToken` | Automount service account token for the server service account   | `true` |


### Kafka chart parameters

| Name                                             | Description                                                                                                         | Value                            |
| ------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------- | -------------------------------- |
| `kafka.enabled`                                  | Enable/disable Kafka chart installation                                                                             | `true`                           |
| `kafka.replicaCount`                             | Number of Kafka brokers                                                                                             | `1`                              |
| `kafka.auth.clientProtocol`                      | Authentication protocol for communications with clients. Allowed protocols: plaintext, tls, mtls, sasl and sasl_tls | `plaintext`                      |
| `kafka.auth.interBrokerProtocol`                 | Authentication protocol for inter-broker communications. Allowed protocols: plaintext, tls, mtls, sasl and sasl_tls | `plaintext`                      |
| `kafka.auth.tls.existingSecrets`                 | Array existing secrets containing the TLS certificates for the Kafka brokers                                        | `[]`                             |
| `kafka.auth.tls.password`                        | Password to access the JKS files or PEM key when they are password-protected.                                       | `""`                             |
| `kafka.auth.tls.endpointIdentificationAlgorithm` | The endpoint identification algorithm to validate server hostname using server certificate                          | `https`                          |
| `kafka.auth.sasl.jaas.clientUsers`               | Kafka client users for SASL authentication                                                                          | `[]`                             |
| `kafka.auth.sasl.jaas.clientPasswords`           | Kafka client passwords for SASL authentication                                                                      | `[]`                             |
| `kafka.auth.sasl.jaas.interBrokerUser`           | Kafka inter broker communication user for SASL authentication                                                       | `admin`                          |
| `kafka.auth.sasl.jaas.interBrokerPassword`       | Kafka inter broker communication password for SASL authentication                                                   | `""`                             |
| `kafka.auth.sasl.jaas.zookeeperUser`             | Kafka Zookeeper user for SASL authentication                                                                        | `""`                             |
| `kafka.auth.sasl.jaas.zookeeperPassword`         | Kafka Zookeeper password for SASL authentication                                                                    | `""`                             |
| `kafka.auth.sasl.jaas.existingSecret`            | Name of the existing secret containing credentials for brokerUser, interBrokerUser and zookeeperUser                | `""`                             |
| `kafka.service.ports.client`                     | Kafka service port for client connections                                                                           | `9092`                           |
| `kafka.zookeeper.enabled`                        | Enable/disable Zookeeper chart installation                                                                         | `true`                           |
| `kafka.zookeeper.replicaCount`                   | Number of Zookeeper replicas                                                                                        | `1`                              |
| `kafka.zookeeper.auth`                           | Zookeeper auth settings                                                                                             | `{}`                             |
| `externalKafka.brokers`                          | Array of Kafka brokers to connect to. Format: protocol://broker_hostname:port                                       | `["PLAINTEXT://localhost:9092"]` |
| `externalKafka.auth.protocol`                    | Authentication protocol. Allowed protocols: plaintext, tls, sasl and sasl_tls                                       | `plaintext`                      |
| `externalKafka.auth.jaas.user`                   | User for SASL authentication                                                                                        | `user`                           |
| `externalKafka.auth.jaas.password`               | Password for SASL authentication                                                                                    | `""`                             |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
helm install my-release \
  --set replicaCount=2 \
    bitnami/schema-registry
```

The above command installs Schema Registry chart with 2 replicas.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
helm install my-release -f values.yaml bitnami/schema-registry
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

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

Learn more about how to configure Kafka to use the different authentication protocols in the [chart documentation](https://docs.bitnami.com/kubernetes/infrastructure/kafka/administration/enable-security/).

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

### Ingress

This chart provides support for Ingress resources. If you have an ingress controller installed on your cluster, such as [nginx-ingress-controller](https://github.com/bitnami/charts/tree/master/bitnami/nginx-ingress-controller) or [contour](https://github.com/bitnami/charts/tree/master/bitnami/contour) you can utilize the ingress controller to serve your Schema Registry.

To enable Ingress integration, set `ingress.enabled` to `true`. The `ingress.hostname` property can be used to set the host name.

#### Hosts

Most likely you will only want to have one hostname that maps to this Schema Registry installation. If that's your case, the property `ingress.hostname` will set it. However, it is possible to have more than one host. To facilitate this, the `ingress.extraHosts` object is can be specified as an array. You can also use `ingress.extraTLS` to add the TLS configuration for extra hosts.

For each host indicated at `ingress.extraHosts`, please indicate a `name`, `path`, and any `annotations` that you may want the ingress controller to know about.

For annotations, please see [this document](https://github.com/kubernetes/ingress-nginx/blob/master/docs/user-guide/nginx-configuration/annotations.md). Not all annotations are supported by all ingress controllers, but this document does a good job of indicating which annotation is supported by many popular ingress controllers.

## Upgrading

### To 4.0.0

This version bump the version of charts used as dependency in a major. Kafka from 12.X.X to 18.X.X ([here](https://github.com/bitnami/charts/tree/master/bitnami/kafka#to-1800) you can see the changes introduced in this version).

### To 3.0.0

This major release renames several values and adds new features, in order to be inline with the rest of assets in the Bitnami charts repository.

Affected values:

- `strategyType` is replaced by `updateStrategy`
- `service.port` is renamed to `service.ports.http`
- `service.nodePort` is renamed to `service.nodePorts.http`
- `ingress.certManager` is removed, please use `ingress.annotations`to add any third party feature

### To 2.0.0

This version bump the version of charts used as dependency in a major. Kafka from 11.X.X to 12.X.X ([here](https://github.com/bitnami/charts/tree/master/bitnami/kafka#to-1220) you can see the changes introduced in this version) and common from 0.X.X to 1.X.X ([here](https://github.com/bitnami/charts/tree/master/bitnami/common#to-100) you can find the changes introduced in this version). Mainly the changes in both subcharts are related to the Helm v2 EOL.

### To 1.0.0

[On November 13, 2020, Helm v2 support was formally finished](https://github.com/helm/charts#status-of-the-project), this major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

**What changes were introduced in this major version?**

- Previous versions of this Helm Chart use `apiVersion: v1` (installable by both Helm 2 and 3), this Helm Chart was updated to `apiVersion: v2` (installable by Helm 3 only). [Here](https://helm.sh/docs/topics/charts/#the-apiversion-field) you can find more information about the `apiVersion` field.
- Move dependency information from the *requirements.yaml* to the *Chart.yaml*
- After running `helm dependency update`, a *Chart.lock* file is generated containing the same structure used in the previous *requirements.lock*
- The different fields present in the *Chart.yaml* file has been ordered alphabetically in a homogeneous way for all the Bitnami Helm Charts

**Considerations when upgrading to this version**

- If you want to upgrade to this version from a previous one installed with Helm v3, you shouldn't face any issues
- If you want to upgrade to this version using Helm v2, this scenario is not supported as this version doesn't support Helm v2 anymore
- If you installed the previous version with Helm v2 and wants to upgrade to this version with Helm v3, please refer to the [official Helm documentation](https://helm.sh/docs/topics/v2_v3_migration/#migration-use-cases) about migrating from Helm v2 to v3

**Useful links**

- https://docs.bitnami.com/tutorials/resolve-helm2-helm3-post-migration-issues/
- https://helm.sh/docs/topics/v2_v3_migration/
- https://helm.sh/blog/migrate-from-helm-v2-to-helm-v3/

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## License

Copyright &copy; 2022 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.