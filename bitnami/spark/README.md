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

### Global parameters

| Name                      | Description                                     | Value |
| ------------------------- | ----------------------------------------------- | ----- |
| `global.imageRegistry`    | Global Docker image registry                    | `""`  |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]`  |


### Common parameters

| Name               | Description                                                                                  | Value |
| ------------------ | -------------------------------------------------------------------------------------------- | ----- |
| `kubeVersion`      | Force target Kubernetes version (using Helm capabilities if not set)                         | `""`  |
| `nameOverride`     | String to partially override common.names.fullname template (will maintain the release name) | `""`  |
| `fullnameOverride` | String to fully override common.names.fullname template                                      | `""`  |
| `extraDeploy`      | Array of extra objects to deploy with the release                                            | `[]`  |


### Spark parameters

| Name                | Description                                      | Value                 |
| ------------------- | ------------------------------------------------ | --------------------- |
| `image.registry`    | Spark image registry                             | `docker.io`           |
| `image.repository`  | Spark image repository                           | `bitnami/spark`       |
| `image.tag`         | Spark image tag (immutable tags are recommended) | `3.1.2-debian-10-r18` |
| `image.pullPolicy`  | Spark image pull policy                          | `IfNotPresent`        |
| `image.pullSecrets` | Specify docker-registry secret names as an array | `[]`                  |
| `image.debug`       | Enable image debug mode                          | `false`               |
| `hostNetwork`       | Enable HOST Network                              | `false`               |


### Spark master parameters

| Name                                        | Description                                                                                                   | Value  |
| ------------------------------------------- | ------------------------------------------------------------------------------------------------------------- | ------ |
| `master.configurationConfigMap`             | Set a custom configuration by using an existing configMap with the configuration file.                        | `""`   |
| `master.webPort`                            | Specify the port where the web interface will listen on the master                                            | `8080` |
| `master.clusterPort`                        | Specify the port where the master listens to communicate with workers                                         | `7077` |
| `master.hostAliases`                        | Deployment pod host aliases                                                                                   | `[]`   |
| `master.daemonMemoryLimit`                  | Set the memory limit for the master daemon                                                                    | `""`   |
| `master.configOptions`                      | Use a string to set the config options for in the form "-Dx=y"                                                | `""`   |
| `master.extraEnvVars`                       | Extra environment variables to pass to the master container                                                   | `[]`   |
| `master.securityContext.enabled`            | Enable security context                                                                                       | `true` |
| `master.securityContext.fsGroup`            | Group ID for the container                                                                                    | `1001` |
| `master.securityContext.runAsUser`          | User ID for the container                                                                                     | `1001` |
| `master.securityContext.runAsGroup`         | Group ID for the container                                                                                    | `0`    |
| `master.securityContext.seLinuxOptions`     | SELinux options for the container                                                                             | `{}`   |
| `master.podAnnotations`                     | Annotations for pods in StatefulSet                                                                           | `{}`   |
| `master.extraPodLabels`                     | Extra labels for pods in StatefulSet                                                                          | `{}`   |
| `master.podAffinityPreset`                  | Spark master pod affinity preset. Ignored if `master.affinity` is set. Allowed values: `soft` or `hard`       | `""`   |
| `master.podAntiAffinityPreset`              | Spark master pod anti-affinity preset. Ignored if `master.affinity` is set. Allowed values: `soft` or `hard`  | `soft` |
| `master.nodeAffinityPreset.type`            | Spark master node affinity preset type. Ignored if `master.affinity` is set. Allowed values: `soft` or `hard` | `""`   |
| `master.nodeAffinityPreset.key`             | Spark master node label key to match Ignored if `master.affinity` is set.                                     | `""`   |
| `master.nodeAffinityPreset.values`          | Spark master node label values to match. Ignored if `master.affinity` is set.                                 | `[]`   |
| `master.affinity`                           | Spark master affinity for pod assignment                                                                      | `{}`   |
| `master.nodeSelector`                       | Spark master node labels for pod assignment                                                                   | `{}`   |
| `master.tolerations`                        | Spark master tolerations for pod assignment                                                                   | `[]`   |
| `master.resources.limits`                   | The resources limits for the container                                                                        | `{}`   |
| `master.resources.requests`                 | The requested resources for the container                                                                     | `{}`   |
| `master.livenessProbe.enabled`              | Enable livenessProbe                                                                                          | `true` |
| `master.livenessProbe.initialDelaySeconds`  | Initial delay seconds for livenessProbe                                                                       | `180`  |
| `master.livenessProbe.periodSeconds`        | Period seconds for livenessProbe                                                                              | `20`   |
| `master.livenessProbe.timeoutSeconds`       | Timeout seconds for livenessProbe                                                                             | `5`    |
| `master.livenessProbe.failureThreshold`     | Failure threshold for livenessProbe                                                                           | `6`    |
| `master.livenessProbe.successThreshold`     | Success threshold for livenessProbe                                                                           | `1`    |
| `master.readinessProbe.enabled`             | Enable readinessProbe                                                                                         | `true` |
| `master.readinessProbe.initialDelaySeconds` | Initial delay seconds for readinessProbe                                                                      | `30`   |
| `master.readinessProbe.periodSeconds`       | Period seconds for readinessProbe                                                                             | `10`   |
| `master.readinessProbe.timeoutSeconds`      | Timeout seconds for readinessProbe                                                                            | `5`    |
| `master.readinessProbe.failureThreshold`    | Failure threshold for readinessProbe                                                                          | `6`    |
| `master.readinessProbe.successThreshold`    | Success threshold for readinessProbe                                                                          | `1`    |
| `master.initContainers`                     | Add initContainers to the master pods.                                                                        | `[]`   |


### Spark worker parameters

| Name                                        | Description                                                                                                   | Value          |
| ------------------------------------------- | ------------------------------------------------------------------------------------------------------------- | -------------- |
| `worker.configurationConfigMap`             | Set a custom configuration by using an existing configMap with the configuration file.                        | `""`           |
| `worker.webPort`                            | Specify the port where the web interface will listen on the worker                                            | `8081`         |
| `worker.clusterPort`                        | Specify the port where the worker listens to communicate with the master                                      | `""`           |
| `worker.hostAliases`                        | Add deployment host aliases                                                                                   | `[]`           |
| `worker.extraPorts`                         | Specify the port where the running jobs inside the workers listens                                            | `[]`           |
| `worker.daemonMemoryLimit`                  | Set the memory limit for the worker daemon                                                                    | `""`           |
| `worker.memoryLimit`                        | Set the maximum memory the worker is allowed to use                                                           | `""`           |
| `worker.coreLimit`                          | Se the maximum number of cores that the worker can use                                                        | `""`           |
| `worker.dir`                                | Set a custom working directory for the application                                                            | `""`           |
| `worker.javaOptions`                        | Set options for the JVM in the form `-Dx=y`                                                                   | `""`           |
| `worker.configOptions`                      | Set extra options to configure the worker in the form `-Dx=y`                                                 | `""`           |
| `worker.extraEnvVars`                       | An array to add extra env vars                                                                                | `[]`           |
| `worker.replicaCount`                       | Number of spark workers (will be the minimum number when autoscaling is enabled)                              | `2`            |
| `worker.podManagementPolicy`                | Statefulset Pod Management Policy Type                                                                        | `OrderedReady` |
| `worker.securityContext.enabled`            | Enable security context                                                                                       | `true`         |
| `worker.securityContext.fsGroup`            | Group ID for the container                                                                                    | `1001`         |
| `worker.securityContext.runAsUser`          | User ID for the container                                                                                     | `1001`         |
| `worker.securityContext.runAsGroup`         | Group ID for the container                                                                                    | `0`            |
| `worker.securityContext.seLinuxOptions`     | SELinux options for the container                                                                             | `{}`           |
| `worker.podAnnotations`                     | Annotations for pods in StatefulSet                                                                           | `{}`           |
| `worker.extraPodLabels`                     | Extra labels for pods in StatefulSet                                                                          | `{}`           |
| `worker.podAffinityPreset`                  | Spark worker pod affinity preset. Ignored if `worker.affinity` is set. Allowed values: `soft` or `hard`       | `""`           |
| `worker.podAntiAffinityPreset`              | Spark worker pod anti-affinity preset. Ignored if `worker.affinity` is set. Allowed values: `soft` or `hard`  | `soft`         |
| `worker.nodeAffinityPreset.type`            | Spark worker node affinity preset type. Ignored if `worker.affinity` is set. Allowed values: `soft` or `hard` | `""`           |
| `worker.nodeAffinityPreset.key`             | Spark worker node label key to match Ignored if `worker.affinity` is set.                                     | `""`           |
| `worker.nodeAffinityPreset.values`          | Spark worker node label values to match. Ignored if `worker.affinity` is set.                                 | `[]`           |
| `worker.affinity`                           | Spark worker affinity for pod assignment                                                                      | `{}`           |
| `worker.nodeSelector`                       | Spark worker node labels for pod assignment                                                                   | `{}`           |
| `worker.tolerations`                        | Spark worker tolerations for pod assignment                                                                   | `[]`           |
| `worker.resources.limits`                   | The resources limits for the container                                                                        | `{}`           |
| `worker.resources.requests`                 | The requested resources for the container                                                                     | `{}`           |
| `worker.livenessProbe.enabled`              | Enable livenessProbe                                                                                          | `true`         |
| `worker.livenessProbe.initialDelaySeconds`  | Initial delay seconds for livenessProbe                                                                       | `180`          |
| `worker.livenessProbe.periodSeconds`        | Period seconds for livenessProbe                                                                              | `20`           |
| `worker.livenessProbe.timeoutSeconds`       | Timeout seconds for livenessProbe                                                                             | `5`            |
| `worker.livenessProbe.failureThreshold`     | Failure threshold for livenessProbe                                                                           | `6`            |
| `worker.livenessProbe.successThreshold`     | Success threshold for livenessProbe                                                                           | `1`            |
| `worker.readinessProbe.enabled`             | Enable readinessProbe                                                                                         | `true`         |
| `worker.readinessProbe.initialDelaySeconds` | Initial delay seconds for readinessProbe                                                                      | `30`           |
| `worker.readinessProbe.periodSeconds`       | Period seconds for readinessProbe                                                                             | `10`           |
| `worker.readinessProbe.timeoutSeconds`      | Timeout seconds for readinessProbe                                                                            | `5`            |
| `worker.readinessProbe.failureThreshold`    | Failure threshold for readinessProbe                                                                          | `6`            |
| `worker.readinessProbe.successThreshold`    | Success threshold for readinessProbe                                                                          | `1`            |
| `worker.initContainers`                     | Add initContainers to the master pods.                                                                        | `[]`           |
| `worker.autoscaling.enabled`                | Enable replica autoscaling depending on CPU                                                                   | `false`        |
| `worker.autoscaling.CpuTargetPercentage`    | Kubernetes HPA CPU target percentage                                                                          | `50`           |
| `worker.autoscaling.replicasMax`            | Maximum number of workers when using autoscaling                                                              | `5`            |


### Security parameters

| Name                                 | Description                                                                   | Value     |
| ------------------------------------ | ----------------------------------------------------------------------------- | --------- |
| `security.passwordsSecretName`       | Name of the secret that contains all the passwords                            | `""`      |
| `security.rpc.authenticationEnabled` | Enable the RPC authentication                                                 | `false`   |
| `security.rpc.encryptionEnabled`     | Enable the encryption for RPC                                                 | `false`   |
| `security.storageEncryptionEnabled`  | Enables local storage encryption                                              | `false`   |
| `security.certificatesSecretName`    | Name of the secret that contains the certificates.                            | `""`      |
| `security.ssl.enabled`               | Enable the SSL configuration                                                  | `false`   |
| `security.ssl.needClientAuth`        | Enable the client authentication                                              | `false`   |
| `security.ssl.protocol`              | Set the SSL protocol                                                          | `TLSv1.2` |
| `security.ssl.existingSecret`        | Name of the existing secret containing the TLS certificates                   | `""`      |
| `security.ssl.autoGenerated`         | Create self-signed TLS certificates. Currently only supports PEM certificates | `false`   |
| `security.ssl.keystorePassword`      | Set the password of the JKS Keystore                                          | `""`      |
| `security.ssl.truststorePassword`    | Truststore password.                                                          | `""`      |
| `security.ssl.resources.limits`      | The resources limits for the container                                        | `{}`      |
| `security.ssl.resources.requests`    | The requested resources for the container                                     | `{}`      |


### Traffic Exposure parameters

| Name                        | Description                                                                                            | Value                    |
| --------------------------- | ------------------------------------------------------------------------------------------------------ | ------------------------ |
| `service.type`              | Kubernetes Service type                                                                                | `ClusterIP`              |
| `service.clusterPort`       | Spark cluster port                                                                                     | `7077`                   |
| `service.webPort`           | Spark client port                                                                                      | `80`                     |
| `service.nodePorts.cluster` | Kubernetes cluster node port                                                                           | `""`                     |
| `service.nodePorts.web`     | Kubernetes web node port                                                                               | `""`                     |
| `service.loadBalancerIP`    | Load balancer IP if spark service type is `LoadBalancer`                                               | `""`                     |
| `service.annotations`       | Annotations for spark service                                                                          | `{}`                     |
| `ingress.enabled`           | Enable ingress controller resource                                                                     | `false`                  |
| `ingress.certManager`       | Set this to true in order to add the corresponding annotations for cert-manager                        | `false`                  |
| `ingress.pathType`          | Ingress path type                                                                                      | `ImplementationSpecific` |
| `ingress.apiVersion`        | Force Ingress API version (automatically detected if not set)                                          | `""`                     |
| `ingress.hostname`          | Default host for the ingress resource                                                                  | `spark.local`            |
| `ingress.path`              | The Path to Spark. You may need to set this to '/*' in order to use this with ALB ingress controllers. | `ImplementationSpecific` |
| `ingress.annotations`       | Ingress annotations                                                                                    | `{}`                     |
| `ingress.tls`               | Enable TLS configuration for the hostname defined at ingress.hostname parameter                        | `false`                  |
| `ingress.extraHosts`        | The list of additional hostnames to be covered with this ingress record.                               | `[]`                     |
| `ingress.extraPaths`        | Any additional arbitrary paths that may need to be added to the ingress under the main host.           | `[]`                     |
| `ingress.extraTls`          | The tls configuration for additional hostnames to be covered with this ingress record.                 | `[]`                     |
| `ingress.secrets`           | If you're providing your own certificates, please use this to add the certificates as secrets          | `[]`                     |


### Metrics parameters

| Name                                       | Description                                                                                                                             | Value   |
| ------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `metrics.enabled`                          | Start a side-car prometheus exporter                                                                                                    | `false` |
| `metrics.masterAnnotations`                | Annotations for the Prometheus metrics on master nodes                                                                                  | `{}`    |
| `metrics.workerAnnotations`                | Annotations for the Prometheus metrics on worker nodes                                                                                  | `{}`    |
| `metrics.podMonitor.enabled`               | If the operator is installed in your cluster, set to true to create a PodMonitor Resource for scraping metrics using PrometheusOperator | `false` |
| `metrics.podMonitor.extraMetricsEndpoints` | Add metrics endpoints for monitoring the jobs running in the worker nodes                                                               | `[]`    |
| `metrics.podMonitor.namespace`             | Specify the namespace in which the podMonitor resource will be created                                                                  | `""`    |
| `metrics.podMonitor.interval`              | Specify the interval at which metrics should be scraped                                                                                 | `30s`   |
| `metrics.podMonitor.scrapeTimeout`         | Specify the timeout after which the scrape is ended                                                                                     | `""`    |
| `metrics.podMonitor.additionalLabels`      | Additional labels that can be used so PodMonitors will be discovered by Prometheus                                                      | `{}`    |
| `metrics.prometheusRule.enabled`           | Set this to true to create prometheusRules for Prometheus                                                                               | `false` |
| `metrics.prometheusRule.namespace`         | Namespace where the prometheusRules resource should be created                                                                          | `""`    |
| `metrics.prometheusRule.additionalLabels`  | Additional labels that can be used so prometheusRules will be discovered by Prometheus                                                  | `{}`    |
| `metrics.prometheusRule.rules`             | Custom Prometheus [rules](https://prometheus.io/docs/prometheus/latest/configuration/alerting_rules/)                                   | `[]`    |


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
