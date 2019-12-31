# Apache Spark

[Apache Spark](https://spark.apache.org/) is a high-performance engine for large-scale computing tasks, such as data processing, machine learning and real-time data streaming. It includes APIs for Java, Python, Scala and R.

## TL;DR;

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install bitnami/spark
```

## Introduction

This chart bootstraps a [spark](https://github.com/bitnami/bitnami-docker-spark) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This Helm chart has been tested on top of [Bitnami Kubernetes Production Runtime](https://kubeprod.io/) (BKPR). Deploy BKPR to get automated TLS certificates, logging and monitoring for your applications.

## Prerequisites

- Kubernetes 1.12+
- Helm 2.11+ or Helm 3.0-beta3+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install --name my-release bitnami/spark
```

These commands deploy Spark on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` statefulset:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release. Use the option `--purge` to delete all persistent volumes too.

## Parameters

The following tables lists the configurable parameters of the spark chart and their default values.

|                  Parameter                  |                                                                Description                                                                 |                         Default                         |
|---------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------|
| `global.imageRegistry`                      | Global Docker image registry                                                                                                               | `nil`                                                   |
| `global.imagePullSecrets`                   | Global Docker registry secret names as an array                                                                                            | `[]` (does not add image pull secrets to deployed pods) |
| `image.registry`                            | spark image registry                                                                                                                       | `docker.io`                                             |
| `image.repository`                          | spark Image name                                                                                                                           | `bitnami/spark`                                         |
| `image.tag`                                 | spark Image tag                                                                                                                            | `{TAG_NAME}`                                            |
| `image.pullPolicy`                          | spark image pull policy                                                                                                                    | `IfNotPresent`                                          |
| `image.pullSecrets`                         | Specify docker-registry secret names as an array                                                                                           | `[]` (does not add image pull secrets to deployed pods) |
| `nameOverride`                              | String to partially override spark.fullname template with a string (will prepend the release name)                                         | `nil`                                                   |
| `fullnameOverride`                          | String to fully override spark.fullname template with a string                                                                             | `nil`                                                   |
| `master.debug`                              | Specify if debug values should be set on the master                                                                                        | `false`                                                 |
| `master.webPort`                            | Specify the port where the web interface will listen on the master                                                                         | `8080`                                                  |
| `master.clusterPort`                        | Specify the port where the master listens to communicate with workers                                                                      | `7077`                                                  |
| `master.daemonMemoryLimit`                  | Set the memory limit for the master daemon                                                                                                 | No default                                              |
| `master.configOptions`                      | Optional configuration if the form `-Dx=y`                                                                                                 | No default                                              |
| `master.securityContext.enabled`            | Enable security context                                                                                                                    | `true`                                                  |
| `master.securityContext.fsGroup`            | Group ID for the container                                                                                                                 | `1001`                                                  |
| `master.securityContext.runAsUser`          | User ID for the container                                                                                                                  | `1001`                                                  |
| `master.nodeSelector`                       | Node affinity policy                                                                                                                       | `{}` (The value is evaluated as a template)             |
| `master.tolerations`                        | Tolerations for pod assignment                                                                                                             | `[]` (The value is evaluated as a template)             |
| `master.affinity`                           | Affinity for pod assignment                                                                                                                | `{}` (The value is evaluated as a template)             |
| `master.resources`                          | CPU/Memory resource requests/limits                                                                                                        | `{}`                                                    |
| `master.extraEnvVars`                       | Extra environment variables to pass to the master container                                                                                | `{}`                                                    |
| `master.extraVolumes`                       | Array of extra volumes to be added to the Spark master deployment (evaluated as template). Requires setting `master.extraVolumeMounts`     | `nil`                                                   |
| `master.extraVolumeMounts`                  | Array of extra volume mounts to be added to the Spark master deployment (evaluated as template). Normally used with `master.extraVolumes`. | `nil`                                                   |
| `master.livenessProbe.enabled`              | Turn on and off liveness probe                                                                                                             | `true`                                                  |
| `master.livenessProbe.initialDelaySeconds`  | Delay before liveness probe is initiated                                                                                                   | 10                                                      |
| `master.livenessProbe.periodSeconds`        | How often to perform the probe                                                                                                             | 10                                                      |
| `master.livenessProbe.timeoutSeconds`       | When the probe times out                                                                                                                   | 5                                                       |
| `master.livenessProbe.failureThreshold`     | Minimum consecutive failures for the probe to be considered failed after having succeeded.                                                 | 2                                                       |
| `master.livenessProbe.successThreshold`     | Minimum consecutive successes for the probe to be considered successful after having failed                                                | 1                                                       |
| `master.readinessProbe.enabled`             | Turn on and off readiness probe                                                                                                            | `true`                                                  |
| `master.readinessProbe.initialDelaySeconds` | Delay before liveness probe is initiated                                                                                                   | 5                                                       |
| `master.readinessProbe.periodSeconds`       | How often to perform the probe                                                                                                             | 10                                                      |
| `master.readinessProbe.timeoutSeconds`      | When the probe times out                                                                                                                   | 5                                                       |
| `master.readinessProbe.failureThreshold`    | Minimum consecutive failures for the probe to be considered failed after having succeeded.                                                 | 6                                                       |
| `master.readinessProbe.successThreshold`    | Minimum consecutive successes for the probe to be considered successful after having failed                                                | 1                                                       |
| `worker.debug`                              | Specify if debug values should be set on workers                                                                                           | `false`                                                 |
| `worker.webPort`                            | Specify the port where the web interface will listen on the worker                                                                         | `8080`                                                  |
| `worker.clusterPort`                        | Specify the port where the worker listens to communicate with the master                                                                   | `7077`                                                  |
| `worker.daemonMemoryLimit`                  | Set the memory limit for the worker daemon                                                                                                 | No default                                              |
| `worker.memoryLimit`                        | Set the maximum memory the worker is allowed to use                                                                                        | No default                                              |
| `worker.coreLimit`                          | Se the maximum number of cores that the worker can use                                                                                     | No default                                              |
| `worker.dir`                                | Set a custom working directory for the application                                                                                         | No default                                              |
| `worker.javaOptions`                        | Set options for the JVM in the form `-Dx=y`                                                                                                | No default                                              |
| `worker.configOptions`                      | Set extra options to configure the worker in the form `-Dx=y`                                                                              | No default                                              |
| `worker.replicaCount`                       | Set the number of workers                                                                                                                  | `2`                                                     |
| `worker.autoscaling.enabled`                | Enable autoscaling depending on CPU                                                                                                        | `false`                                                 |
| `worker.autoscaling.CpuTargetPercentage`    | k8s hpa cpu targetPercentage                                                                                                               | `50`                                                    |
| `worker.autoscaling.replicasMax`            | Maximum number of workers when using autoscaling                                                                                           | `5`                                                     |
| `worker.securityContext.enabled`            | Enable security context                                                                                                                    | `true`                                                  |
| `worker.securityContext.fsGroup`            | Group ID for the container                                                                                                                 | `1001`                                                  |
| `worker.securityContext.runAsUser`          | User ID for the container                                                                                                                  | `1001`                                                  |
| `worker.nodeSelector`                       | Node labels for pod assignment. Used as a template from the values.                                                                        | `{}`                                                    |
| `worker.tolerations`                        | Toleration labels for pod assignment                                                                                                       | `[]`                                                    |
| `worker.affinity`                           | Affinity and AntiAffinity rules for pod assignment                                                                                         | `{}`                                                    |
| `worker.resources`                          | CPU/Memory resource requests/limits                                                                                                        | Memory: `256Mi`, CPU: `250m`                            |
| `worker.livenessProbe.enabled`              | Turn on and off liveness probe                                                                                                             | `true`                                                  |
| `worker.livenessProbe.initialDelaySeconds`  | Delay before liveness probe is initiated                                                                                                   | 10                                                      |
| `worker.livenessProbe.periodSeconds`        | How often to perform the probe                                                                                                             | 10                                                      |
| `worker.livenessProbe.timeoutSeconds`       | When the probe times out                                                                                                                   | 5                                                       |
| `worker.livenessProbe.failureThreshold`     | Minimum consecutive failures for the probe to be considered failed after having succeeded.                                                 | 2                                                       |
| `worker.livenessProbe.successThreshold`     | Minimum consecutive successes for the probe to be considered successful after having failed                                                | 1                                                       |
| `worker.readinessProbe.enabled`             | Turn on and off readiness probe                                                                                                            | `true`                                                  |
| `worker.readinessProbe.initialDelaySeconds` | Delay before liveness probe is initiated                                                                                                   | 5                                                       |
| `worker.readinessProbe.periodSeconds`       | How often to perform the probe                                                                                                             | 10                                                      |
| `worker.readinessProbe.timeoutSeconds`      | When the probe times out                                                                                                                   | 5                                                       |
| `worker.readinessProbe.failureThreshold`    | Minimum consecutive failures for the probe to be considered failed after having succeeded.                                                 | 6                                                       |
| `worker.readinessProbe.successThreshold`    | Minimum consecutive successes for the probe to be considered successful after having failed                                                | 1                                                       |
| `master.extraEnvVars`                       | Extra environment variables to pass to the worker container                                                                                | `{}`                                                    |
| `worker.extraVolumes`                       | Array of extra volumes to be added to the Spark worker deployment (evaluated as template). Requires setting `worker.extraVolumeMounts`     | `nil`                                                   |
| `worker.extraVolumeMounts`                  | Array of extra volume mounts to be added to the Spark worker deployment (evaluated as template). Normally used with `worker.extraVolumes`. | `nil`                                                   |
| `security.passwordsSecretName`              | Secret to use when using security configuration to set custom passwords                                                                    | No default                                              |
| `security.rpc.authenticationEnabled`        | Enable the RPC authentication                                                                                                              | `false`                                                 |
| `security.rpc.encryptionEnabled`            | Enable the encryption for RPC                                                                                                              | `false`                                                 |
| `security.storageEncryptionEnabled`         | Enable the encryption of the storage                                                                                                       | `false`                                                 |
| `security.ssl.enabled`                      | Enable the SSL configuration                                                                                                               | `false`                                                 |
| `security.ssl.needClientAuth`               | Enable the client authentication                                                                                                           | `false`                                                 |
| `security.ssl.protocol`                     | Set the SSL protocol                                                                                                                       | `TLSv1.2`                                               |
| `security.certificatesSecretName`           | Set the name of the secret that contains the certificates                                                                                  | No default                                              |
| `service.type`                              | Kubernetes Service type                                                                                                                    | `ClusterIP`                                             |
| `service.webPort`                           | Spark client port                                                                                                                          | `80`                                                    |
| `service.clusterPort`                       | Spark cluster port                                                                                                                         | `7077`                                                  |
| `service.nodePort`                          | Port to bind to for NodePort service type (client port)                                                                                    | `nil`                                                   |
| `service.nodePorts.cluster`                 | Kubernetes cluster node port                                                                                                               | `""`                                                    |
| `service.nodePorts.web`                     | Kubernetes web node port                                                                                                                   | `""`                                                    |
| `service.annotations`                       | Annotations for spark service                                                                                                              | {}                                                      |
| `service.loadBalancerIP`                    | loadBalancerIP if spark service type is `LoadBalancer`                                                                                     | `nil`                                                   |
| `ingress.enabled`                           | Enable the use of the ingress controller to access the web UI                                                                              | `false`                                                 |
| `ingress.certManager`                       | Add annotations for cert-manager                                                                                                           | `false`                                                 |
| `ingress.annotations`                       | Ingress annotations                                                                                                                        | `{}`                                                    |
| `ingress.hosts[0].name`                     | Hostname to your Spark installation                                                                                                        | `spark.local`                                           |
| `ingress.hosts[0].path`                     | Path within the url structure                                                                                                              | `/`                                                     |
| `ingress.hosts[0].tls`                      | Utilize TLS backend in ingress                                                                                                             | `false`                                                 |
| `ingress.hosts[0].tlsHosts`                 | Array of TLS hosts for ingress record (defaults to `ingress.hosts[0].name` if `nil`)                                                       | `nil`                                                   |
| `ingress.hosts[0].tlsSecret`                | TLS Secret (certificates)                                                                                                                  | `spark.local-tls`                                       |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set master.webPort=8081 bitnami/spark
```

The above command sets the spark master web port to `8081`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml bitnami/spark
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Production configuration

This chart includes a `values-production.yaml` file where you can find some parameters oriented to production configuration in comparison to the regular `values.yaml`. You can use this file instead of the default one.

- Enable ingress controller
```diff
- ingress.enabled: false
+ ingress.enabled: true
```

- Enable RPC authentication and encryption:
```diff
- security.rpc.authenticationEnabled: false
- security.rpc.encryptionEnabled: false
+ security.rpc.authenticationEnabled: true
+ security.rpc.encryptionEnabled: true
```

- Enable storage encryption:
```diff
- security.storageEncryptionEnabled: false
+ security.storageEncryptionEnabled: true
```

- Configure SSL parameters:
```diff
- security.ssl.enabled: false
- security.ssl.needClientAuth: false
+ security.ssl.enabled: true
+ security.ssl.needClientAuth: true
```

- Set a secret name for passwords:
```diff
+ security.passwordsSecretName: my-passwords-secret
```

- Set a secret name for certificates:
```diff
+ security.certificatesSecretName: my-certificates-secret
```

- Enable autoscaling depending on CPU:
```diff
- worker.autoscaling.enabled: false
- worker.autoscaling.replicasMax: 5
+ worker.autoscaling.enabled: true
+ worker.autoscaling.replicasMax: 10
```

### Using custom configuration

To use a custom configuration a ConfigMap should be created with the `spark-env.sh` file inside the ConfigMap. The ConfigMap name must be provided at deployment time, to set the configuration on the master use: ` master.configurationConfigMap=configMapName`

To set the configuration on the worker use: `worker.configurationConfigMap=configMapName`

It can be set both at the same time with the same ConfigMap or using two ConfigMaps.
Also, you can provide in the ConfigMap a `spark-defaults.conf` file.
You can use both files without the other.

### Submit an application

To submit an application to the cluster use the `spark-submit` script. You can obtain the script [here](https://github.com/apache/spark/tree/master/bin). For example, to deploy one of the example applications:
```bash
$ ./bin/spark-submit   --class org.apache.spark.examples.SparkPi   --master spark://<master-IP>:<master-cluster-port>   --deploy-mode cluster  ./examples/jars/spark-examples_2.11-2.4.3.jar   1000
```

Where the master IP and port must be changed by you master IP address and port.
> Be aware that currently is not possible to submit an application to a standalone cluster if RPC authentication is configured. More info about the issue [here](https://issues.apache.org/jira/browse/SPARK-25078).

### Enable security for spark

#### Configure ssl communication

In order to enable secure transport between workers and master deploy the helm chart with this options: `ssl.enabled=true`

#### How to create the certificates secret

It is needed to create two secrets to set the passwords and certificates. The name of the two secrets should be configured on `security.passwordsSecretName` and `security.certificatesSecretName`. To generate certificates for testing purpose you can use [this script](https://raw.githubusercontent.com/confluentinc/confluent-platform-security-tools/master/kafka-generate-ssl.sh).
Into the certificates secret, the keys must be `spark-keystore.jks` and `spark-truststore.jks`, and the content must be text on JKS format.
To generate the certificates secret, first it is needed to generate the two certificates and rename them as `spark-keystore.jks` and `spark-truststore.jks`.
Once the certificates are created, you can create the secret having the file names as keys.

The second secret, the secret for passwords should have four keys: `rpc-authentication-secret`, `ssl-key-password`, `ssl-keystore-password` and `ssl-truststore-password`.

Now that the two secrets are created, deploy the chart enabling security configuration and setting the name for the certificates secret (`my-secret` in this case) at the `security.certificatesSecretName` and setting the name for the passwords secret (`my-passwords-secret` in this case) at `security.passwordsSecretName`.

To deploy chart, use the following parameters:
```bash
security.certificatesSecretName=my-secret
security.passwordsSecretName=my-passwords-secret
security.rpc.authenticationEnabled=true
security.rpc.encryptionEnabled=true
security.storageEncrytionEnabled=true
security.ssl.enabled=true
security.ssl.needClientAuth=true
```

> Be aware that currently is not possible to submit an application to a standalone cluster if RPC authentication is configured. More info about the issue [here](https://issues.apache.org/jira/browse/SPARK-25078).
