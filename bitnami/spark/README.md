# Apache Spark

[Apache Spark](https://spark.apache.org/) is a high-performance engine for large-scale computing tasks, such as data processing, machine learning and real-time data streaming. It includes APIs for Java, Python, Scala and R.

## TL;DR

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/spark
```

## Introduction

This chart bootstraps an [Apache Spark](https://github.com/bitnami/bitnami-docker-spark) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This Helm chart has been tested on top of [Bitnami Kubernetes Production Runtime](https://kubeprod.io/) (BKPR). Deploy BKPR to get automated TLS certificates, logging and monitoring for your applications.

## Prerequisites

- Kubernetes 1.12+
- Helm 3.1.0

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/spark
```

These commands deploy Apache Spark on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` statefulset:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release. Use the option `--purge` to delete all persistent volumes too.

## Parameters

The following tables lists the configurable parameters of the Apache Spark chart and their default values.

### Global parameters

| Parameter                 | Description                                     | Default                                                 |
|---------------------------|-------------------------------------------------|---------------------------------------------------------|
| `global.imageRegistry`    | Global Docker image registry                    | `nil`                                                   |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]` (does not add image pull secrets to deployed pods) |

### Common parameters

| Parameter           | Description                                                                                               | Default                        |
|---------------------|-----------------------------------------------------------------------------------------------------------|--------------------------------|
| `nameOverride`      | String to partially override common.names.fullname template with a string (will prepend the release name) | `nil`                          |
| `fullnameOverride`  | String to fully override common.names.fullname template with a string                                     | `nil`                          |
| `commonLabels`      | Labels to add to all deployed objects                                                                     | `{}`                           |
| `commonAnnotations` | Annotations to add to all deployed objects                                                                | `{}`                           |
| `kubeVersion`       | Force target Kubernetes version (using Helm capabilities if not set)                                      | `nil`                          |
| `extraDeploy`       | Array of extra objects to deploy with the release                                                         | `[]` (evaluated as a template) |

### Spark parameters

| Parameter           | Description                                                                             | Default                                                 |
|---------------------|-----------------------------------------------------------------------------------------|---------------------------------------------------------|
| `image.registry`    | spark image registry                                                                    | `docker.io`                                             |
| `image.repository`  | spark Image name                                                                        | `bitnami/spark`                                         |
| `image.tag`         | spark Image tag                                                                         | `{TAG_NAME}`                                            |
| `image.pullPolicy`  | spark image pull policy                                                                 | `IfNotPresent`                                          |
| `image.pullSecrets` | Specify docker-registry secret names as an array                                        | `[]` (does not add image pull secrets to deployed pods) |
| `hostNetwork`       | Use Host-Network for the PODs (if true, also dnsPolicy: ClusterFirstWithHostNet is set) | `false`                                                 |

### Spark master parameters

| Parameter                                   | Description                                                                                                                                | Default                                     |
|---------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------|
| `master.debug`                              | Specify if debug values should be set on the master                                                                                        | `false`                                     |
| `master.webPort`                            | Specify the port where the web interface will listen on the master                                                                         | `8080`                                      |
| `master.clusterPort`                        | Specify the port where the master listens to communicate with workers                                                                      | `7077`                                      |
| `master.hostAliases`                        | Add deployment host aliases                                                                                                                | `[]`                                        |
| `master.daemonMemoryLimit`                  | Set the memory limit for the master daemon                                                                                                 | No default                                  |
| `master.configOptions`                      | Optional configuration if the form `-Dx=y`                                                                                                 | No default                                  |
| `master.securityContext.enabled`            | Enable security context                                                                                                                    | `true`                                      |
| `master.securityContext.fsGroup`            | Group ID for the container                                                                                                                 | `1001`                                      |
| `master.securityContext.runAsUser`          | User ID for the container                                                                                                                  | `1001`                                      |
| `master.securityContext.seLinuxOptions`     | SELinux options for the container                                                                                                          | `{}`                                        |
| `master.podAnnotations`                     | Annotations for pods in StatefulSet                                                                                                        | `{}` (The value is evaluated as a template) |
| `master.extraPodLabels`                     | Extra labels for pods in StatefulSet                                                                                                       | `{}` (The value is evaluated as a template) |
| `master.podAffinityPreset`                  | Spark master pod affinity preset. Ignored if `master.affinity` is set. Allowed values: `soft` or `hard`                                    | `""`                                        |
| `master.podAntiAffinityPreset`              | Spark master pod anti-affinity preset. Ignored if `master.affinity` is set. Allowed values: `soft` or `hard`                               | `soft`                                      |
| `master.nodeAffinityPreset.type`            | Spark master node affinity preset type. Ignored if `master.affinity` is set. Allowed values: `soft` or `hard`                              | `""`                                        |
| `master.nodeAffinityPreset.key`             | Spark master node label key to match Ignored if `master.affinity` is set.                                                                  | `""`                                        |
| `master.nodeAffinityPreset.values`          | Spark master node label values to match. Ignored if `master.affinity` is set.                                                              | `[]`                                        |
| `master.affinity`                           | Spark master affinity for pod assignment                                                                                                   | `{}` (evaluated as a template)              |
| `master.nodeSelector`                       | Spark master node labels for pod assignment                                                                                                | `{}` (evaluated as a template)              |
| `master.tolerations`                        | Spark master tolerations for pod assignment                                                                                                | `[]` (evaluated as a template)              |
| `master.resources`                          | CPU/Memory resource requests/limits                                                                                                        | `{}`                                        |
| `master.extraEnvVars`                       | Extra environment variables to pass to the master container                                                                                | `{}`                                        |
| `master.extraVolumes`                       | Array of extra volumes to be added to the Spark master deployment (evaluated as template). Requires setting `master.extraVolumeMounts`     | `nil`                                       |
| `master.extraVolumeMounts`                  | Array of extra volume mounts to be added to the Spark master deployment (evaluated as template). Normally used with `master.extraVolumes`. | `nil`                                       |
| `master.livenessProbe.enabled`              | Turn on and off liveness probe                                                                                                             | `true`                                      |
| `master.livenessProbe.initialDelaySeconds`  | Delay before liveness probe is initiated                                                                                                   | 10                                          |
| `master.livenessProbe.periodSeconds`        | How often to perform the probe                                                                                                             | 10                                          |
| `master.livenessProbe.timeoutSeconds`       | When the probe times out                                                                                                                   | 5                                           |
| `master.livenessProbe.failureThreshold`     | Minimum consecutive failures for the probe to be considered failed after having succeeded.                                                 | 2                                           |
| `master.livenessProbe.successThreshold`     | Minimum consecutive successes for the probe to be considered successful after having failed                                                | 1                                           |
| `master.readinessProbe.enabled`             | Turn on and off readiness probe                                                                                                            | `true`                                      |
| `master.readinessProbe.initialDelaySeconds` | Delay before liveness probe is initiated                                                                                                   | 5                                           |
| `master.readinessProbe.periodSeconds`       | How often to perform the probe                                                                                                             | 10                                          |
| `master.readinessProbe.timeoutSeconds`      | When the probe times out                                                                                                                   | 5                                           |
| `master.readinessProbe.failureThreshold`    | Minimum consecutive failures for the probe to be considered failed after having succeeded.                                                 | 6                                           |
| `master.readinessProbe.successThreshold`    | Minimum consecutive successes for the probe to be considered successful after having failed                                                | 1                                           |

### Spark worker parameters

| Parameter                                   | Description                                                                                                                                                                          | Default                                     |
|---------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------|
| `worker.debug`                              | Specify if debug values should be set on workers                                                                                                                                     | `false`                                     |
| `worker.webPort`                            | Specify the port where the web interface will listen on the worker                                                                                                                   | `8080`                                      |
| `worker.clusterPort`                        | Specify the port where the worker listens to communicate with the master                                                                                                             | `7077`                                      |
| `worker.extraPorts`                         | Specify the port where the running jobs inside the workers listens, [ContainerPort spec](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.20/#containerport-v1-core) | `[]`                                        |
| `worker.daemonMemoryLimit`                  | Set the memory limit for the worker daemon                                                                                                                                           | No default                                  |
| `worker.memoryLimit`                        | Set the maximum memory the worker is allowed to use                                                                                                                                  | No default                                  |
| `worker.coreLimit`                          | Se the maximum number of cores that the worker can use                                                                                                                               | No default                                  |
| `worker.dir`                                | Set a custom working directory for the application                                                                                                                                   | No default                                  |
| `worker.hostAliases`                        | Add deployment host aliases                                                                                                                                                          | `[]`                                        |
| `worker.javaOptions`                        | Set options for the JVM in the form `-Dx=y`                                                                                                                                          | No default                                  |
| `worker.configOptions`                      | Set extra options to configure the worker in the form `-Dx=y`                                                                                                                        | No default                                  |
| `worker.replicaCount`                       | Set the number of workers                                                                                                                                                            | `2`                                         |
| `worker.podManagementPolicy`                | Statefulset Pod Management Policy Type                                                                                                                                               | `OrderedReady`                              |
| `worker.autoscaling.enabled`                | Enable autoscaling depending on CPU                                                                                                                                                  | `false`                                     |
| `worker.autoscaling.CpuTargetPercentage`    | k8s hpa cpu targetPercentage                                                                                                                                                         | `50`                                        |
| `worker.autoscaling.replicasMax`            | Maximum number of workers when using autoscaling                                                                                                                                     | `5`                                         |
| `worker.securityContext.enabled`            | Enable security context                                                                                                                                                              | `true`                                      |
| `worker.securityContext.fsGroup`            | Group ID for the container                                                                                                                                                           | `1001`                                      |
| `worker.securityContext.runAsUser`          | User ID for the container                                                                                                                                                            | `1001`                                      |
| `worker.securityContext.seLinuxOptions`     | SELinux options for the container                                                                                                                                                    | `{}`                                        |
| `worker.podAnnotations`                     | Annotations for pods in StatefulSet                                                                                                                                                  | `{}`                                        |
| `worker.extraPodLabels`                     | Extra labels for pods in StatefulSet                                                                                                                                                 | `{}` (The value is evaluated as a template) |
| `worker.podAffinityPreset`                  | Spark worker pod affinity preset. Ignored if `worker.affinity` is set. Allowed values: `soft` or `hard`                                                                              | `""`                                        |
| `worker.podAntiAffinityPreset`              | Spark worker pod anti-affinity preset. Ignored if `worker.affinity` is set. Allowed values: `soft` or `hard`                                                                         | `soft`                                      |
| `worker.nodeAffinityPreset.type`            | Spark worker node affinity preset type. Ignored if `worker.affinity` is set. Allowed values: `soft` or `hard`                                                                        | `""`                                        |
| `worker.nodeAffinityPreset.key`             | Spark worker node label key to match Ignored if `worker.affinity` is set.                                                                                                            | `""`                                        |
| `worker.nodeAffinityPreset.values`          | Spark worker node label values to match. Ignored if `worker.affinity` is set.                                                                                                        | `[]`                                        |
| `worker.affinity`                           | Spark worker affinity for pod assignment                                                                                                                                             | `{}` (evaluated as a template)              |
| `worker.nodeSelector`                       | Spark worker node labels for pod assignment                                                                                                                                          | `{}` (evaluated as a template)              |
| `worker.tolerations`                        | Spark worker tolerations for pod assignment                                                                                                                                          | `[]` (evaluated as a template)              |
| `worker.resources`                          | CPU/Memory resource requests/limits                                                                                                                                                  | Memory: `256Mi`, CPU: `250m`                |
| `worker.livenessProbe.enabled`              | Turn on and off liveness probe                                                                                                                                                       | `true`                                      |
| `worker.livenessProbe.initialDelaySeconds`  | Delay before liveness probe is initiated                                                                                                                                             | 10                                          |
| `worker.livenessProbe.periodSeconds`        | How often to perform the probe                                                                                                                                                       | 10                                          |
| `worker.livenessProbe.timeoutSeconds`       | When the probe times out                                                                                                                                                             | 5                                           |
| `worker.livenessProbe.failureThreshold`     | Minimum consecutive failures for the probe to be considered failed after having succeeded.                                                                                           | 2                                           |
| `worker.livenessProbe.successThreshold`     | Minimum consecutive successes for the probe to be considered successful after having failed                                                                                          | 1                                           |
| `worker.readinessProbe.enabled`             | Turn on and off readiness probe                                                                                                                                                      | `true`                                      |
| `worker.readinessProbe.initialDelaySeconds` | Delay before liveness probe is initiated                                                                                                                                             | 5                                           |
| `worker.readinessProbe.periodSeconds`       | How often to perform the probe                                                                                                                                                       | 10                                          |
| `worker.readinessProbe.timeoutSeconds`      | When the probe times out                                                                                                                                                             | 5                                           |
| `worker.readinessProbe.failureThreshold`    | Minimum consecutive failures for the probe to be considered failed after having succeeded.                                                                                           | 6                                           |
| `worker.readinessProbe.successThreshold`    | Minimum consecutive successes for the probe to be considered successful after having failed                                                                                          | 1                                           |
| `master.extraEnvVars`                       | Extra environment variables to pass to the worker container                                                                                                                          | `{}`                                        |
| `worker.extraVolumes`                       | Array of extra volumes to be added to the Spark worker deployment (evaluated as template). Requires setting `worker.extraVolumeMounts`                                               | `nil`                                       |
| `worker.extraVolumeMounts`                  | Array of extra volume mounts to be added to the Spark worker deployment (evaluated as template). Normally used with `worker.extraVolumes`.                                           | `nil`                                       |

### Security parameters

| Parameter                            | Description                                                             | Default    |
|--------------------------------------|-------------------------------------------------------------------------|------------|
| `security.passwordsSecretName`       | Secret to use when using security configuration to set custom passwords | No default |
| `security.rpc.authenticationEnabled` | Enable the RPC authentication                                           | `false`    |
| `security.rpc.encryptionEnabled`     | Enable the encryption for RPC                                           | `false`    |
| `security.storageEncryptionEnabled`  | Enable the encryption of the storage                                    | `false`    |
| `security.ssl.enabled`               | Enable the SSL configuration                                            | `false`    |
| `security.ssl.needClientAuth`        | Enable the client authentication                                        | `false`    |
| `security.ssl.protocol`              | Set the SSL protocol                                                    | `TLSv1.2`  |
| `security.ssl.existingSecret`        | Set the name of the secret that contains the certificates               | No default |
| `security.ssl.keystorePassword`      | Set the password of the JKS Keystore                                    | No default |
| `security.ssl.existingSecret`        | Set the password of the JKS Truststore                                  | No default |
| `security.ssl.autoGenerated`         | Generate automatically self-signed TLS certificates                     | `false`    |
| `security.ssl.resources.limits`      | The resources limits for the TLS                                        | `{}`       |
| `security.ssl.resources.requests`    | The requested resources for the TLS init                                | `{}`       |

### Exposure parameters

| Parameter                        | Description                                                   | Default                        |
|----------------------------------|---------------------------------------------------------------|--------------------------------|
| `service.type`                   | Kubernetes Service type                                       | `ClusterIP`                    |
| `service.webPort`                | Spark client port                                             | `80`                           |
| `service.clusterPort`            | Spark cluster port                                            | `7077`                         |
| `service.nodePort`               | Port to bind to for NodePort service type (client port)       | `nil`                          |
| `service.nodePorts.cluster`      | Kubernetes cluster node port                                  | `""`                           |
| `service.nodePorts.web`          | Kubernetes web node port                                      | `""`                           |
| `service.annotations`            | Annotations for spark service                                 | {}                             |
| `service.loadBalancerIP`         | loadBalancerIP if spark service type is `LoadBalancer`        | `nil`                          |
| `ingress.enabled`                | Enable ingress controller resource                            | `false`                        |
| `ingress.certManager`            | Add annotations for cert-manager                              | `false`                        |
| `ingress.hostname`               | Default host for the ingress resource                         | `spark.local`                  |
| `ingress.path`                   | Default path for the ingress resource                         | `/`                            |
| `ingress.tls`                    | Create TLS Secret                                             | `false`                        |
| `ingress.annotations`            | Ingress annotations                                           | `[]` (evaluated as a template) |
| `ingress.extraHosts[0].name`     | Additional hostnames to be covered                            | `nil`                          |
| `ingress.extraHosts[0].path`     | Additional hostnames to be covered                            | `nil`                          |
| `ingress.extraPaths`             | Additional arbitrary path/backend objects                     | `nil`                          |
| `ingress.extraTls[0].hosts[0]`   | TLS configuration for additional hostnames to be covered      | `nil`                          |
| `ingress.extraTls[0].secretName` | TLS configuration for additional hostnames to be covered      | `nil`                          |
| `ingress.secrets[0].name`        | TLS Secret Name                                               | `nil`                          |
| `ingress.secrets[0].certificate` | TLS Secret Certificate                                        | `nil`                          |
| `ingress.secrets[0].key`         | TLS Secret Key                                                | `nil`                          |
| `ingress.apiVersion`             | Force Ingress API version (automatically detected if not set) | ``                             |
| `ingress.path`                   | Ingress path                                                  | `/`                            |
| `ingress.pathType`               | Ingress path type                                             | `ImplementationSpecific`       |

### Metrics parameters

| Parameter                                  | Description                                                                                                                                                                                                  | Default                                                                                       |
|--------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------|
| `metrics.enabled`                          | Start a side-car prometheus exporter                                                                                                                                                                         | `false`                                                                                       |
| `metrics.masterAnnotations`                | Annotations for enabling prometheus to access the metrics endpoint of the master nodes                                                                                                                       | `{prometheus.io/scrape: "true", prometheus.io/path: "/metrics/", prometheus.io/port: "8080"}` |
| `metrics.workerAnnotations`                | Annotations for enabling prometheus to access the metrics endpoint of the worker nodes                                                                                                                       | `{prometheus.io/scrape: "true", prometheus.io/path: "/metrics/", prometheus.io/port: "8081"}` |
| `metrics.resources.limits`                 | The resources limits for the metrics exporter container                                                                                                                                                      | `{}`                                                                                          |
| `metrics.resources.requests`               | The requested resources for the metrics exporter container                                                                                                                                                   | `{}`                                                                                          |
| `metrics.podMonitor.enabled`               | Create PodMonitor Resource for scraping metrics using PrometheusOperator                                                                                                                                     | `false`                                                                                       |
| `metrics.podMonitor.extraMetricsEndpoints` | Add metrics endpoints for monitoring the jobs running in the worker nodes, [MetricsEndpoint](https://github.com/prometheus-operator/prometheus-operator/blob/master/Documentation/api.md#podmetricsendpoint) | `[]`                                                                                          |
| `metrics.podMonitor.namespace`             | Namespace where podmonitor resource should be created                                                                                                                                                        | `nil`                                                                                         |
| `metrics.podMonitor.interval`              | Specify the interval at which metrics should be scraped                                                                                                                                                      | `30s`                                                                                         |
| `metrics.podMonitor.scrapeTimeout`         | Specify the timeout after which the scrape is ended                                                                                                                                                          | `nil`                                                                                         |
| `metrics.podMonitor.additionalLabels`      | Additional labels that can be used so PodMonitors will be discovered by Prometheus                                                                                                                           | `{}`                                                                                          |
| `metrics.prometheusRule.enabled`           | Set this to true to create prometheusRules for Prometheus                                                                                                                                                    | `false`                                                                                       |
| `metrics.prometheusRule.additionalLabels`  | Additional labels that can be used so prometheusRules will be discovered by Prometheus                                                                                                                       | `{}`                                                                                          |
| `metrics.prometheusRule.namespace`         | namespace where prometheusRules resource should be created                                                                                                                                                   | the same namespace as spark                                                                   |
| `metrics.prometheusRule.rules`             | [rules](https://prometheus.io/docs/prometheus/latest/configuration/alerting_rules/) to be created, check values for an example.                                                                              | `[]`                                                                                          |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install my-release \
  --set master.webPort=8081 bitnami/spark
```

The above command sets the spark master web port to `8081`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
$ helm install my-release -f values.yaml bitnami/spark
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling vs Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Define custom configuration

To use a custom configuration, a ConfigMap should be created with the `spark-env.sh` file inside the ConfigMap. The ConfigMap name must be provided at deployment time.

To set the configuration on the master use `master.configurationConfigMap=configMapName`. To set the configuration on the worker, use `worker.configurationConfigMap=configMapName`.

These values can be set at the same time in a single ConfigMap or using two ConfigMaps. An additional `spark-defaults.conf` file can be provided in the ConfigMap. You can use both files or one without the other.

### Submit an application

To submit an application to the Apache Spark cluster, use the `spark-submit` script, which is available at [https://github.com/apache/spark/tree/master/bin](https://github.com/apache/spark/tree/master/bin).

The command below illustrates the process of deploying one of the sample applications included with Apache Spark. Replace the MASTER-IP-ADDRESS and MASTER-PORT placeholders with the correct master IP address and port for your deployment.

```bash
$ ./bin/spark-submit --class org.apache.spark.examples.SparkPi --master spark://MASTER-IP-ADDRESS:MASTER-PORT  --deploy-mode cluster  ./examples/jars/spark-examples_2.11-2.4.3.jar 1000
```

For a complete walkthrough of the process using a custom application, refer to the [detailed Apache Spark tutorial](https://docs.bitnami.com/tutorials/process-data-spark-kubernetes/).

> Be aware that it is currently not possible to submit an application to a standalone cluster if RPC authentication is configured. [Learn more about the issue](https://issues.apache.org/jira/browse/SPARK-25078).

### Configure security for Apache Spark

### Configure SSL communication

In order to enable secure transport between workers and master, deploy the Helm chart with the `ssl.enabled=true` chart parameter.

### Create certificate and password secrets

It is necessary to create two secrets for the passwords and certificates. The names of the two secrets should be configured using the `security.passwordsSecretName` and `security.ssl.existingSecret` chart parameters.

The keys for the certificate secret must be named `spark-keystore.jks` and `spark-truststore.jks`, and the content must be text in JKS format. Use [this script to generate certificates](https://raw.githubusercontent.com/confluentinc/confluent-platform-security-tools/master/kafka-generate-ssl.sh) for test purposes if required.

The secret for passwords should have three keys: `rpc-authentication-secret`, `ssl-keystore-password` and `ssl-truststore-password`.

Refer to the [chart documentation for more details on configuring security and an example](https://docs.bitnami.com/kubernetes/infrastructure/spark/administration/configure-security/).

> It is currently not possible to submit an application to a standalone cluster if RPC authentication is configured. [Learn more about this issue](https://issues.apache.org/jira/browse/SPARK-25078).

### Set Pod affinity

This chart allows you to set your custom affinity using the `XXX.affinity` parameter(s). Find more information about Pod affinity in the [Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `XXX.podAffinityPreset`, `XXX.podAntiAffinityPreset`, or `XXX.nodeAffinityPreset` parameters.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami’s Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 5.0.0

This version standardizes the way of defining Ingress rules. When configuring a single hostname for the Ingress rule, set the `ingress.hostname` value. When defining more than one, set the `ingress.extraHosts` array. Apart from this case, no issues are expected to appear when upgrading.

### To 4.0.0

[On November 13, 2020, Helm v2 support formally ended](https://github.com/helm/charts#status-of-the-project). This major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

[Learn more about this change and related upgrade considerations](https://docs.bitnami.com/kubernetes/infrastructure/spark/administration/upgrade-helm3/).

### To 3.0.0

- This version introduces `bitnami/common`, a [library chart](https://helm.sh/docs/topics/library_charts/#helm) as a dependency. More documentation about this new utility could be found [here](https://github.com/bitnami/charts/tree/master/bitnami/common#bitnami-common-library-chart). Please, make sure that you have updated the chart dependencies before executing any upgrade.

- Spark container images are updated to use Hadoop `3.2.x`: [Notable Changes: 3.0.0-debian-10-r44](https://github.com/bitnami/bitnami-docker-spark#300-debian-10-r44)

> Note: Backwards compatibility is not guaranteed due to the above mentioned changes. Please make sure your workloads are compatible with the new version of Hadoop before upgrading. Backups are always recommended before any upgrade operation.
