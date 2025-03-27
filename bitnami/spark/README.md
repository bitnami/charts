<!--- app-name: Apache Spark -->

# Bitnami package for Apache Spark

Apache Spark is a high-performance engine for large-scale computing tasks, such as data processing, machine learning and real-time data streaming. It includes APIs for Java, Python, Scala and R.

[Overview of Apache Spark](https://spark.apache.org/)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/spark
```

Looking to use Apache Spark in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the commercial edition of the Bitnami catalog.

## Introduction

This chart bootstraps an [Apache Spark](https://github.com/bitnami/containers/tree/main/bitnami/spark) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Apache Spark includes APIs for Java, Python, Scala and R.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/spark
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

These commands deploy Apache Spark on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Configuration and installation details

### Resource requests and limits

Bitnami charts allow setting resource requests and limits for all containers inside the chart deployment. These are inside the `resources` value (check parameter table). Setting requests is essential for production workloads and these should be adapted to your specific use case.

To make this process easier, the chart contains the `resourcesPreset` values, which automatically sets the `resources` section according to different presets. Check these presets in [the bitnami/common chart](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15). However, in production workloads using `resourcesPreset` is discouraged as it may not fully adapt to your specific needs. Find more information on container resource management in the [official Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).

### Prometheus metrics

This chart can be integrated with Prometheus by setting `metrics.enabled` to true. This will expose the Spark native Prometheus port in both the containers and services. The services will also have the necessary annotations to be automatically scraped by Prometheus.

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

### Backup and restore

To back up and restore Helm chart deployments on Kubernetes, you need to back up the persistent volumes from the source deployment and attach them to a new deployment using [Velero](https://velero.io/), a Kubernetes backup/restore tool. Find the instructions for using Velero in [this guide](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-backup-restore-deployments-velero-index.html).

### Define custom configuration

To use a custom configuration, a ConfigMap should be created with the `spark-env.sh` file inside the ConfigMap. The ConfigMap name must be provided at deployment time.

To set the configuration on the master use `master.configurationConfigMap=configMapName`. To set the configuration on the worker, use `worker.configurationConfigMap=configMapName`.

These values can be set at the same time in a single ConfigMap or using two ConfigMaps. An additional `spark-defaults.conf` file can be provided in the ConfigMap. You can use both files or one without the other.

### Submit an application

To submit an application to the Apache Spark cluster, use the `spark-submit` script, which is available at [https://github.com/apache/spark/tree/master/bin](https://github.com/apache/spark/tree/master/bin).

The command below illustrates the process of deploying one of the sample applications included with Apache Spark. Replace the `k8s-apiserver-host`, `k8s-apiserver-port`, `spark-master-svc`, and `spark-master-port` placeholders with the correct master host/IP address and port for your deployment.

```console
$ ./bin/spark-submit \
    --class org.apache.spark.examples.SparkPi \
    --conf spark.kubernetes.container.image=bitnami/spark:3 \
    --master k8s://https://k8s-apiserver-host:k8s-apiserver-port \
    --conf spark.kubernetes.driverEnv.SPARK_MASTER_URL=spark://spark-master-svc:spark-master-port \
    --deploy-mode cluster \
    ./examples/jars/spark-examples_2.12-3.2.0.jar 1000
```

This command example assumes that you have downloaded a Spark binary distribution, which can be found at [Download Apache Spark](https://spark.apache.org/downloads.html).

For a complete walkthrough of the process using a custom application, refer to Spark's guide to [Running Spark on Kubernetes](https://spark.apache.org/docs/latest/running-on-kubernetes.html).

> Be aware that it is currently not possible to submit an application to a standalone cluster if RPC authentication is configured. [Learn more about the issue](https://issues.apache.org/jira/browse/SPARK-25078).

### Configuring Spark Master as reverse proxy

Spark offers configuration to enable running Spark Master as reverse proxy for worker and application UIs. This can be useful as the Spark Master UI may otherwise use private IPv4 addresses for links to Spark workers and Spark apps.

Coupled with `ingress` configuration, you can set `master.configOptions` and `worker.configOptions` to tell Spark to reverse proxy the worker and application UIs to enable access without requiring direct access to their hosts:

```yaml
master:
  configOptions:
    -Dspark.ui.reverseProxy=true
    -Dspark.ui.reverseProxyUrl=https://spark.your-domain.com
worker:
  configOptions:
    -Dspark.ui.reverseProxy=true
    -Dspark.ui.reverseProxyUrl=https://spark.your-domain.com
ingress:
  enabled: true
  hostname: spark.your-domain.com
```

See the [Spark Configuration](https://spark.apache.org/docs/latest/configuration.html) docs for detail on the parameters.

### Configure security for Apache Spark

### Configure SSL communication

In order to enable secure transport between workers and master, deploy the Helm chart with the `ssl.enabled=true` chart parameter.

### Create certificate and password secrets

It is necessary to create two secrets for the passwords and certificates. The names of the two secrets should be configured using the `security.passwordsSecretName` and `security.ssl.existingSecret` chart parameters.

#### Create certificates and the certificate secret

To generate the certificates secret, first generate the two certificates and rename them to `spark-keystore.jks` and `spark-truststore.jks`. Use [this script to generate certificates](https://raw.githubusercontent.com/confluentinc/confluent-platform-security-tools/master/kafka-generate-ssl.sh) for test purposes if required.

Once the certificates are created, create a secret for them with the file names as keys. The keys must be named `spark-keystore.jks` and `spark-truststore.jks`, and the content must be text in JKS format.

#### Create the password secret

The secret for passwords should have three keys: `rpc-authentication-secret`, `ssl-keystore-password` and `ssl-truststore-password`.

#### Configure the chart

Once the secrets are created, configure the chart and set the various security-related parameters, including the `security.certificatesSecretName` and  `security.passwordsSecretName` parameters referencing the secrets created previously. Here is an example configuration for chart deployment:

```text
security.certificatesSecretName=my-secret
security.passwordsSecretName=my-passwords-secret
security.rpc.authenticationEnabled=true
security.rpc.encryptionEnabled=true
security.storageEncrytionEnabled=true
security.ssl.enabled=true
security.ssl.needClientAuth=true
```

> NOTE: It is currently not possible to submit an application to a standalone cluster if RPC authentication is configured. [Learn more about this issue](https://issues.apache.org/jira/browse/SPARK-25078).

### Set Pod affinity

This chart allows you to set your custom affinity using the `XXX.affinity` parameter(s). Find more information about Pod affinity in the [Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities) chart. To do so, set the `XXX.podAffinityPreset`, `XXX.podAntiAffinityPreset`, or `XXX.nodeAffinityPreset` parameters.

## Parameters

### Global parameters

| Name                                                  | Description                                                                                                                                                                                                                                                                                                                                                         | Value   |
| ----------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `global.imageRegistry`                                | Global Docker image registry                                                                                                                                                                                                                                                                                                                                        | `""`    |
| `global.imagePullSecrets`                             | Global Docker registry secret names as an array                                                                                                                                                                                                                                                                                                                     | `[]`    |
| `global.defaultStorageClass`                          | Global default StorageClass for Persistent Volume(s)                                                                                                                                                                                                                                                                                                                | `""`    |
| `global.storageClass`                                 | DEPRECATED: use global.defaultStorageClass instead                                                                                                                                                                                                                                                                                                                  | `""`    |
| `global.security.allowInsecureImages`                 | Allows skipping image verification                                                                                                                                                                                                                                                                                                                                  | `false` |
| `global.compatibility.openshift.adaptSecurityContext` | Adapt the securityContext sections of the deployment to make them compatible with Openshift restricted-v2 SCC: remove runAsUser, runAsGroup and fsGroup and let the platform use their allowed default IDs. Possible values: auto (apply if the detected running cluster is Openshift), force (perform the adaptation always), disabled (do not perform adaptation) | `auto`  |

### Common parameters

| Name                     | Description                                                                                                                                         | Value           |
| ------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------- | --------------- |
| `kubeVersion`            | Force target Kubernetes version (using Helm capabilities if not set)                                                                                | `""`            |
| `nameOverride`           | String to partially override common.names.fullname template (will maintain the release name)                                                        | `""`            |
| `fullnameOverride`       | String to fully override common.names.fullname template                                                                                             | `""`            |
| `namespaceOverride`      | String to fully override common.names.namespace                                                                                                     | `""`            |
| `commonLabels`           | Labels to add to all deployed objects                                                                                                               | `{}`            |
| `commonAnnotations`      | Annotations to add to all deployed objects                                                                                                          | `{}`            |
| `clusterDomain`          | Kubernetes cluster domain name                                                                                                                      | `cluster.local` |
| `extraDeploy`            | Array of extra objects to deploy with the release                                                                                                   | `[]`            |
| `initScripts`            | Dictionary of init scripts. Evaluated as a template.                                                                                                | `{}`            |
| `initScriptsCM`          | ConfigMap with the init scripts. Evaluated as a template.                                                                                           | `""`            |
| `initScriptsSecret`      | Secret containing `/docker-entrypoint-initdb.d` scripts to be executed at initialization time that contain sensitive data. Evaluated as a template. | `""`            |
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden)                                                             | `false`         |
| `diagnosticMode.command` | Command to override all containers in the deployment                                                                                                | `["sleep"]`     |
| `diagnosticMode.args`    | Args to override all containers in the deployment                                                                                                   | `["infinity"]`  |

### Spark parameters

| Name                | Description                                                                                           | Value                   |
| ------------------- | ----------------------------------------------------------------------------------------------------- | ----------------------- |
| `image.registry`    | Spark image registry                                                                                  | `REGISTRY_NAME`         |
| `image.repository`  | Spark image repository                                                                                | `REPOSITORY_NAME/spark` |
| `image.digest`      | Spark image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag | `""`                    |
| `image.pullPolicy`  | Spark image pull policy                                                                               | `IfNotPresent`          |
| `image.pullSecrets` | Specify docker-registry secret names as an array                                                      | `[]`                    |
| `image.debug`       | Enable image debug mode                                                                               | `false`                 |
| `hostNetwork`       | Enable HOST Network                                                                                   | `false`                 |

### Spark master parameters

| Name                                                       | Description                                                                                                                                                                                                                     | Value            |
| ---------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| `master.existingConfigmap`                                 | The name of an existing ConfigMap with your custom configuration for master                                                                                                                                                     | `""`             |
| `master.containerPorts.http`                               | Specify the port where the web interface will listen on the master over HTTP                                                                                                                                                    | `8080`           |
| `master.containerPorts.https`                              | Specify the port where the web interface will listen on the master over HTTPS                                                                                                                                                   | `8480`           |
| `master.containerPorts.cluster`                            | Specify the port where the master listens to communicate with workers                                                                                                                                                           | `7077`           |
| `master.automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                              | `false`          |
| `master.hostAliases`                                       | Deployment pod host aliases                                                                                                                                                                                                     | `[]`             |
| `master.extraContainerPorts`                               | Specify the port where the running jobs inside the masters listens                                                                                                                                                              | `[]`             |
| `master.daemonMemoryLimit`                                 | Set the memory limit for the master daemon                                                                                                                                                                                      | `""`             |
| `master.configOptions`                                     | Use a string to set the config options for in the form "-Dx=y"                                                                                                                                                                  | `""`             |
| `master.extraEnvVars`                                      | Extra environment variables to pass to the master container                                                                                                                                                                     | `[]`             |
| `master.extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for master nodes                                                                                                                                                           | `""`             |
| `master.extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for master nodes                                                                                                                                                              | `""`             |
| `master.podSecurityContext.enabled`                        | Enable security context                                                                                                                                                                                                         | `true`           |
| `master.podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                              | `Always`         |
| `master.podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                                  | `[]`             |
| `master.podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                                     | `[]`             |
| `master.podSecurityContext.fsGroup`                        | Set master pod's Security Context Group ID                                                                                                                                                                                      | `1001`           |
| `master.containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                                                                                                                                            | `true`           |
| `master.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                                | `{}`             |
| `master.containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                                                                                                                      | `1001`           |
| `master.containerSecurityContext.runAsGroup`               | Set containers' Security Context runAsGroup                                                                                                                                                                                     | `1001`           |
| `master.containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                                                                                                                                   | `true`           |
| `master.containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                                                                                                                                     | `false`          |
| `master.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                                         | `true`           |
| `master.containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                                                                                                                       | `false`          |
| `master.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                              | `["ALL"]`        |
| `master.containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                                | `RuntimeDefault` |
| `master.command`                                           | Override default container command (useful when using custom images)                                                                                                                                                            | `[]`             |
| `master.args`                                              | Override default container args (useful when using custom images)                                                                                                                                                               | `[]`             |
| `master.podAnnotations`                                    | Annotations for pods in StatefulSet                                                                                                                                                                                             | `{}`             |
| `master.podLabels`                                         | Extra labels for pods in StatefulSet                                                                                                                                                                                            | `{}`             |
| `master.podAffinityPreset`                                 | Spark master pod affinity preset. Ignored if `master.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                         | `""`             |
| `master.podAntiAffinityPreset`                             | Spark master pod anti-affinity preset. Ignored if `master.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                    | `soft`           |
| `master.nodeAffinityPreset.type`                           | Spark master node affinity preset type. Ignored if `master.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                   | `""`             |
| `master.nodeAffinityPreset.key`                            | Spark master node label key to match Ignored if `master.affinity` is set.                                                                                                                                                       | `""`             |
| `master.nodeAffinityPreset.values`                         | Spark master node label values to match. Ignored if `master.affinity` is set.                                                                                                                                                   | `[]`             |
| `master.affinity`                                          | Spark master affinity for pod assignment                                                                                                                                                                                        | `{}`             |
| `master.nodeSelector`                                      | Spark master node labels for pod assignment                                                                                                                                                                                     | `{}`             |
| `master.tolerations`                                       | Spark master tolerations for pod assignment                                                                                                                                                                                     | `[]`             |
| `master.updateStrategy.type`                               | Master statefulset strategy type.                                                                                                                                                                                               | `RollingUpdate`  |
| `master.priorityClassName`                                 | master pods' priorityClassName                                                                                                                                                                                                  | `""`             |
| `master.topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template                                                                                                        | `[]`             |
| `master.schedulerName`                                     | Name of the k8s scheduler (other than default) for master pods                                                                                                                                                                  | `""`             |
| `master.terminationGracePeriodSeconds`                     | Seconds Redmine pod needs to terminate gracefully                                                                                                                                                                               | `""`             |
| `master.lifecycleHooks`                                    | for the master container(s) to automate configuration before or after startup                                                                                                                                                   | `{}`             |
| `master.extraVolumes`                                      | Optionally specify extra list of additional volumes for the master pod(s)                                                                                                                                                       | `[]`             |
| `master.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the master container(s)                                                                                                                                            | `[]`             |
| `master.extraVolumeClaimTemplates`                         | Optionally specify extra list of volumesClaimTemplates for the master statefulset                                                                                                                                               | `[]`             |
| `master.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if master.resources is set (master.resources is recommended for production). | `small`          |
| `master.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                               | `{}`             |
| `master.livenessProbe.enabled`                             | Enable livenessProbe                                                                                                                                                                                                            | `true`           |
| `master.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                                         | `180`            |
| `master.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                                | `20`             |
| `master.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                               | `5`              |
| `master.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                                             | `6`              |
| `master.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                                             | `1`              |
| `master.readinessProbe.enabled`                            | Enable readinessProbe                                                                                                                                                                                                           | `true`           |
| `master.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                                        | `30`             |
| `master.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                               | `10`             |
| `master.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                              | `5`              |
| `master.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                                            | `6`              |
| `master.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                                            | `1`              |
| `master.startupProbe.enabled`                              | Enable startupProbe                                                                                                                                                                                                             | `false`          |
| `master.startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                                          | `30`             |
| `master.startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                                 | `10`             |
| `master.startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                                | `5`              |
| `master.startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                              | `6`              |
| `master.startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                              | `1`              |
| `master.customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                                                                                                                             | `{}`             |
| `master.customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                                                                                                                                            | `{}`             |
| `master.customStartupProbe`                                | Custom startupProbe that overrides the default one                                                                                                                                                                              | `{}`             |
| `master.networkPolicy.enabled`                             | Specifies whether a NetworkPolicy should be created                                                                                                                                                                             | `true`           |
| `master.networkPolicy.allowExternal`                       | Don't require client label for connections                                                                                                                                                                                      | `true`           |
| `master.networkPolicy.allowExternalEgress`                 | Allow the pod to access any range of port and all destinations.                                                                                                                                                                 | `true`           |
| `master.networkPolicy.extraIngress`                        | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                                    | `[]`             |
| `master.networkPolicy.extraEgress`                         | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                                    | `[]`             |
| `master.networkPolicy.ingressNSMatchLabels`                | Labels to match to allow traffic from other namespaces                                                                                                                                                                          | `{}`             |
| `master.networkPolicy.ingressNSPodMatchLabels`             | Pod labels to match to allow traffic from other namespaces                                                                                                                                                                      | `{}`             |
| `master.sidecars`                                          | Add additional sidecar containers to the master pod(s)                                                                                                                                                                          | `[]`             |
| `master.initContainers`                                    | Add initContainers to the master pods.                                                                                                                                                                                          | `[]`             |
| `master.pdb.create`                                        | Enable/disable a Pod Disruption Budget creation                                                                                                                                                                                 | `true`           |
| `master.pdb.minAvailable`                                  | Minimum number/percentage of pods that should remain scheduled                                                                                                                                                                  | `""`             |
| `master.pdb.maxUnavailable`                                | Maximum number/percentage of pods that may be made unavailable. Defaults to `1` if both `master.pdb.minAvailable` and `master.pdb.maxUnavailable` are empty.                                                                    | `""`             |

### Spark worker parameters

| Name                                                       | Description                                                                                                                                                                                                                     | Value            |
| ---------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| `worker.existingConfigmap`                                 | The name of an existing ConfigMap with your custom configuration for workers                                                                                                                                                    | `""`             |
| `worker.containerPorts.http`                               | Specify the port where the web interface will listen on the worker over HTTP                                                                                                                                                    | `8080`           |
| `worker.containerPorts.https`                              | Specify the port where the web interface will listen on the worker over HTTPS                                                                                                                                                   | `8480`           |
| `worker.containerPorts.cluster`                            | Specify the port where the worker listens to communicate with workers                                                                                                                                                           | `""`             |
| `worker.automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                              | `false`          |
| `worker.hostAliases`                                       | Add deployment host aliases                                                                                                                                                                                                     | `[]`             |
| `worker.extraContainerPorts`                               | Specify the port where the running jobs inside the workers listens                                                                                                                                                              | `[]`             |
| `worker.daemonMemoryLimit`                                 | Set the memory limit for the worker daemon                                                                                                                                                                                      | `""`             |
| `worker.memoryLimit`                                       | Set the maximum memory the worker is allowed to use                                                                                                                                                                             | `""`             |
| `worker.coreLimit`                                         | Se the maximum number of cores that the worker can use                                                                                                                                                                          | `""`             |
| `worker.dir`                                               | Set a custom working directory for the application                                                                                                                                                                              | `""`             |
| `worker.javaOptions`                                       | Set options for the JVM in the form `-Dx=y`                                                                                                                                                                                     | `""`             |
| `worker.configOptions`                                     | Set extra options to configure the worker in the form `-Dx=y`                                                                                                                                                                   | `""`             |
| `worker.extraEnvVars`                                      | An array to add extra env vars                                                                                                                                                                                                  | `[]`             |
| `worker.extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for worker nodes                                                                                                                                                           | `""`             |
| `worker.extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for worker nodes                                                                                                                                                              | `""`             |
| `worker.replicaCount`                                      | Number of spark workers (will be the minimum number when autoscaling is enabled)                                                                                                                                                | `2`              |
| `worker.podSecurityContext.enabled`                        | Enable security context                                                                                                                                                                                                         | `true`           |
| `worker.podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                              | `Always`         |
| `worker.podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                                  | `[]`             |
| `worker.podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                                     | `[]`             |
| `worker.podSecurityContext.fsGroup`                        | Group ID for the container                                                                                                                                                                                                      | `1001`           |
| `worker.podSecurityContext.seLinuxOptions`                 | SELinux options for the container                                                                                                                                                                                               | `{}`             |
| `worker.containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                                                                                                                                            | `true`           |
| `worker.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                                | `{}`             |
| `worker.containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                                                                                                                      | `1001`           |
| `worker.containerSecurityContext.runAsGroup`               | Set containers' Security Context runAsGroup                                                                                                                                                                                     | `1001`           |
| `worker.containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                                                                                                                                   | `true`           |
| `worker.containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                                                                                                                                     | `false`          |
| `worker.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                                         | `true`           |
| `worker.containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                                                                                                                       | `false`          |
| `worker.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                              | `["ALL"]`        |
| `worker.containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                                | `RuntimeDefault` |
| `worker.command`                                           | Override default container command (useful when using custom images)                                                                                                                                                            | `[]`             |
| `worker.args`                                              | Override default container args (useful when using custom images)                                                                                                                                                               | `[]`             |
| `worker.podAnnotations`                                    | Annotations for pods in StatefulSet                                                                                                                                                                                             | `{}`             |
| `worker.podLabels`                                         | Extra labels for pods in StatefulSet                                                                                                                                                                                            | `{}`             |
| `worker.podAffinityPreset`                                 | Spark worker pod affinity preset. Ignored if `worker.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                         | `""`             |
| `worker.podAntiAffinityPreset`                             | Spark worker pod anti-affinity preset. Ignored if `worker.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                    | `soft`           |
| `worker.nodeAffinityPreset.type`                           | Spark worker node affinity preset type. Ignored if `worker.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                   | `""`             |
| `worker.nodeAffinityPreset.key`                            | Spark worker node label key to match Ignored if `worker.affinity` is set.                                                                                                                                                       | `""`             |
| `worker.nodeAffinityPreset.values`                         | Spark worker node label values to match. Ignored if `worker.affinity` is set.                                                                                                                                                   | `[]`             |
| `worker.affinity`                                          | Spark worker affinity for pod assignment                                                                                                                                                                                        | `{}`             |
| `worker.nodeSelector`                                      | Spark worker node labels for pod assignment                                                                                                                                                                                     | `{}`             |
| `worker.tolerations`                                       | Spark worker tolerations for pod assignment                                                                                                                                                                                     | `[]`             |
| `worker.updateStrategy.type`                               | Worker statefulset strategy type.                                                                                                                                                                                               | `RollingUpdate`  |
| `worker.podManagementPolicy`                               | Statefulset Pod Management Policy Type                                                                                                                                                                                          | `OrderedReady`   |
| `worker.priorityClassName`                                 | worker pods' priorityClassName                                                                                                                                                                                                  | `""`             |
| `worker.topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template                                                                                                        | `[]`             |
| `worker.schedulerName`                                     | Name of the k8s scheduler (other than default) for worker pods                                                                                                                                                                  | `""`             |
| `worker.terminationGracePeriodSeconds`                     | Seconds Redmine pod needs to terminate gracefully                                                                                                                                                                               | `""`             |
| `worker.lifecycleHooks`                                    | for the worker container(s) to automate configuration before or after startup                                                                                                                                                   | `{}`             |
| `worker.extraVolumes`                                      | Optionally specify extra list of additional volumes for the worker pod(s)                                                                                                                                                       | `[]`             |
| `worker.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the master container(s)                                                                                                                                            | `[]`             |
| `worker.extraVolumeClaimTemplates`                         | Optionally specify extra list of volumesClaimTemplates for the worker statefulset                                                                                                                                               | `[]`             |
| `worker.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if worker.resources is set (worker.resources is recommended for production). | `small`          |
| `worker.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                               | `{}`             |
| `worker.livenessProbe.enabled`                             | Enable livenessProbe                                                                                                                                                                                                            | `true`           |
| `worker.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                                         | `180`            |
| `worker.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                                | `20`             |
| `worker.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                               | `5`              |
| `worker.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                                             | `6`              |
| `worker.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                                             | `1`              |
| `worker.readinessProbe.enabled`                            | Enable readinessProbe                                                                                                                                                                                                           | `true`           |
| `worker.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                                        | `30`             |
| `worker.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                               | `10`             |
| `worker.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                              | `5`              |
| `worker.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                                            | `6`              |
| `worker.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                                            | `1`              |
| `worker.startupProbe.enabled`                              | Enable startupProbe                                                                                                                                                                                                             | `true`           |
| `worker.startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                                          | `30`             |
| `worker.startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                                 | `10`             |
| `worker.startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                                | `5`              |
| `worker.startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                              | `6`              |
| `worker.startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                              | `1`              |
| `worker.customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                                                                                                                             | `{}`             |
| `worker.customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                                                                                                                                            | `{}`             |
| `worker.customStartupProbe`                                | Custom startupProbe that overrides the default one                                                                                                                                                                              | `{}`             |
| `worker.networkPolicy.enabled`                             | Specifies whether a NetworkPolicy should be created                                                                                                                                                                             | `true`           |
| `worker.networkPolicy.allowExternal`                       | Don't require client label for connections                                                                                                                                                                                      | `true`           |
| `worker.networkPolicy.allowExternalEgress`                 | Allow the pod to access any range of port and all destinations.                                                                                                                                                                 | `true`           |
| `worker.networkPolicy.extraIngress`                        | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                                    | `[]`             |
| `worker.networkPolicy.extraEgress`                         | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                                    | `[]`             |
| `worker.networkPolicy.ingressNSMatchLabels`                | Labels to match to allow traffic from other namespaces                                                                                                                                                                          | `{}`             |
| `worker.networkPolicy.ingressNSPodMatchLabels`             | Pod labels to match to allow traffic from other namespaces                                                                                                                                                                      | `{}`             |
| `worker.sidecars`                                          | Add additional sidecar containers to the worker pod(s)                                                                                                                                                                          | `[]`             |
| `worker.initContainers`                                    | Add initContainers to the worker pods.                                                                                                                                                                                          | `[]`             |
| `worker.pdb.create`                                        | Enable/disable a Pod Disruption Budget creation                                                                                                                                                                                 | `true`           |
| `worker.pdb.minAvailable`                                  | Minimum number/percentage of pods that should remain scheduled                                                                                                                                                                  | `""`             |
| `worker.pdb.maxUnavailable`                                | Maximum number/percentage of pods that may be made unavailable. Defaults to `1` if both `worker.pdb.minAvailable` and `worker.pdb.maxUnavailable` are empty.                                                                    | `""`             |
| `worker.autoscaling.enabled`                               | Enable replica autoscaling depending on CPU                                                                                                                                                                                     | `false`          |
| `worker.autoscaling.minReplicas`                           | Minimum number of worker replicas                                                                                                                                                                                               | `""`             |
| `worker.autoscaling.maxReplicas`                           | Maximum number of worker replicas                                                                                                                                                                                               | `5`              |
| `worker.autoscaling.targetCPU`                             | Target CPU utilization percentage                                                                                                                                                                                               | `50`             |
| `worker.autoscaling.targetMemory`                          | Target Memory utilization percentage                                                                                                                                                                                            | `""`             |

### Security parameters

| Name                                 | Description                                                                                                                                                                                                                                 | Value     |
| ------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------- |
| `security.passwordsSecretName`       | Name of the secret that contains all the passwords                                                                                                                                                                                          | `""`      |
| `security.rpc.authenticationEnabled` | Enable the RPC authentication                                                                                                                                                                                                               | `false`   |
| `security.rpc.encryptionEnabled`     | Enable the encryption for RPC                                                                                                                                                                                                               | `false`   |
| `security.storageEncryptionEnabled`  | Enables local storage encryption                                                                                                                                                                                                            | `false`   |
| `security.certificatesSecretName`    | Name of the secret that contains the certificates.                                                                                                                                                                                          | `""`      |
| `security.ssl.enabled`               | Enable the SSL configuration                                                                                                                                                                                                                | `false`   |
| `security.ssl.needClientAuth`        | Enable the client authentication                                                                                                                                                                                                            | `false`   |
| `security.ssl.protocol`              | Set the SSL protocol                                                                                                                                                                                                                        | `TLSv1.2` |
| `security.ssl.existingSecret`        | Name of the existing secret containing the TLS certificates                                                                                                                                                                                 | `""`      |
| `security.ssl.autoGenerated`         | Create self-signed TLS certificates. Currently only supports PEM certificates                                                                                                                                                               | `false`   |
| `security.ssl.keystorePassword`      | Set the password of the JKS Keystore                                                                                                                                                                                                        | `""`      |
| `security.ssl.truststorePassword`    | Truststore password.                                                                                                                                                                                                                        | `""`      |
| `security.ssl.resourcesPreset`       | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if security.ssl.resources is set (security.ssl.resources is recommended for production). | `small`   |
| `security.ssl.resources`             | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                           | `{}`      |

### Traffic Exposure parameters

| Name                               | Description                                                                                                                      | Value                    |
| ---------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `service.type`                     | Kubernetes Service type                                                                                                          | `ClusterIP`              |
| `service.ports.http`               | Spark client port for HTTP                                                                                                       | `80`                     |
| `service.ports.https`              | Spark client port for HTTPS                                                                                                      | `443`                    |
| `service.ports.cluster`            | Spark cluster port                                                                                                               | `7077`                   |
| `service.nodePorts.http`           | Kubernetes web node port for HTTP                                                                                                | `""`                     |
| `service.nodePorts.https`          | Kubernetes web node port for HTTPS                                                                                               | `""`                     |
| `service.nodePorts.cluster`        | Kubernetes cluster node port                                                                                                     | `""`                     |
| `service.clusterIP`                | Spark service Cluster IP                                                                                                         | `""`                     |
| `service.loadBalancerIP`           | Load balancer IP if spark service type is `LoadBalancer`                                                                         | `""`                     |
| `service.loadBalancerSourceRanges` | Spark service Load Balancer sources                                                                                              | `[]`                     |
| `service.externalTrafficPolicy`    | Spark service external traffic policy                                                                                            | `Cluster`                |
| `service.annotations`              | Additional custom annotations for Spark service                                                                                  | `{}`                     |
| `service.extraPorts`               | Extra ports to expose in Spark service (normally used with the `sidecars` value)                                                 | `[]`                     |
| `service.sessionAffinity`          | Control where client requests go, to the same pod or round-robin                                                                 | `None`                   |
| `service.sessionAffinityConfig`    | Additional settings for the sessionAffinity                                                                                      | `{}`                     |
| `service.headless.annotations`     | Annotations for the headless service.                                                                                            | `{}`                     |
| `ingress.enabled`                  | Enable ingress controller resource                                                                                               | `false`                  |
| `ingress.pathType`                 | Ingress path type                                                                                                                | `ImplementationSpecific` |
| `ingress.apiVersion`               | Force Ingress API version (automatically detected if not set)                                                                    | `""`                     |
| `ingress.hostname`                 | Default host for the ingress resource                                                                                            | `spark.local`            |
| `ingress.ingressClassName`         | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                    | `""`                     |
| `ingress.path`                     | The Path to Spark. You may need to set this to '/*' in order to use this with ALB ingress controllers.                           | `/`                      |
| `ingress.annotations`              | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                     |
| `ingress.tls`                      | Enable TLS configuration for the hostname defined at ingress.hostname parameter                                                  | `false`                  |
| `ingress.selfSigned`               | Create a TLS secret for this ingress record using self-signed certificates generated by Helm                                     | `false`                  |
| `ingress.extraHosts`               | The list of additional hostnames to be covered with this ingress record.                                                         | `[]`                     |
| `ingress.extraPaths`               | Any additional arbitrary paths that may need to be added to the ingress under the main host.                                     | `[]`                     |
| `ingress.extraTls`                 | The tls configuration for additional hostnames to be covered with this ingress record.                                           | `[]`                     |
| `ingress.secrets`                  | If you're providing your own certificates, please use this to add the certificates as secrets                                    | `[]`                     |
| `ingress.extraRules`               | Additional rules to be covered with this ingress record                                                                          | `[]`                     |

### Other parameters

| Name                                          | Description                                            | Value   |
| --------------------------------------------- | ------------------------------------------------------ | ------- |
| `serviceAccount.create`                       | Enable the creation of a ServiceAccount for Spark pods | `true`  |
| `serviceAccount.name`                         | The name of the ServiceAccount to use.                 | `""`    |
| `serviceAccount.annotations`                  | Annotations for Spark Service Account                  | `{}`    |
| `serviceAccount.automountServiceAccountToken` | Automount API credentials for a service account.       | `false` |

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
helm install my-release \
  --set master.webPort=8081 oci://REGISTRY_NAME/REPOSITORY_NAME/spark
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The above command sets the spark master web port to `8081`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml oci://REGISTRY_NAME/REPOSITORY_NAME/spark
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.
> **Tip**: You can use the default [values.yaml](https://github.com/bitnami/charts/tree/main/bitnami/spark/values.yaml)

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 9.3.0

This version introduces image verification for security purposes. To disable it, set `global.security.allowInsecureImages` to `true`. More details at [GitHub issue](https://github.com/bitnami/charts/issues/30850).

### To 9.0.0

This major bump changes the following security defaults:

- `runAsGroup` is changed from `0` to `1001`
- `readOnlyRootFilesystem` is set to `true`
- `resourcesPreset` is changed from `none` to the minimum size working in our test suites (NOTE: `resourcesPreset` is not meant for production usage, but `resources` adapted to your use case).
- `global.compatibility.openshift.adaptSecurityContext` is changed from `disabled` to `auto`.

This could potentially break any customization or init scripts used in your deployment. If this is the case, change the default values to the previous ones.

### To 6.0.0

This chart major version standarizes the chart templates and values, modifying some existing parameters names and adding several more. These parameter modifications can be sumarised in the following:

- `worker.autoscaling.CpuTargetPercentage/.replicasMax` parameters are now found by `worker.autoscaling.targetCPU/.maxReplicas`.
- `webport/webPortHttps/cluster` parameters are now found by `containerPorts.http/.https/.cluster`.
- `service.webport/webPortHttps/cluster` parameters are now found by `service.ports.http/.https/.cluster`.
- `service.nodePorts.web/webHttps/cluster` parameters are now found by `service.nodePorts.http/.https/.cluster`.
- `xxxxx.securityContext` parameters are now under `xxxxx.podSecurityContext`
- `xxxxx.configurationConfigMap` parameter has been renamed to `xxxxx.existingConfigmap`
- `extraPodLabels` parameter has been renamed to `podLabels`

Besides the changes detailed above, no issues are expected to appear when upgrading.

### To 5.0.0

This version standardizes the way of defining Ingress rules. When configuring a single hostname for the Ingress rule, set the `ingress.hostname` value. When defining more than one, set the `ingress.extraHosts` array. Apart from this case, no issues are expected to appear when upgrading.

### To 4.0.0

[On November 13, 2020, Helm v2 support formally ended](https://github.com/helm/charts#status-of-the-project). This major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

### To 3.0.0

- This version introduces `bitnami/common`, a [library chart](https://helm.sh/docs/topics/library_charts/#helm) as a dependency. More documentation about this new utility could be found [here](https://github.com/bitnami/charts/tree/main/bitnami/common#bitnami-common-library-chart). Please, make sure that you have updated the chart dependencies before executing any upgrade.

- Spark container images are updated to use Hadoop `3.2.x`: [Notable Changes: 3.0.0-debian-10-r44](https://github.com/bitnami/containers/tree/main/bitnami/spark#300-debian-10-r44)

> Note: Backwards compatibility is not guaranteed due to the above mentioned changes. Please make sure your workloads are compatible with the new version of Hadoop before upgrading. Backups are always recommended before any upgrade operation.

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