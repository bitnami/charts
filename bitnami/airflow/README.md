# Apache Airflow

[Apache Airflow]() is a platform to programmatically author, schedule and monitor workflows.

## TL;DR;

```console
$ helm install bitnami/airflow
```

## Introduction

This chart bootstraps an [Apache Airflow](https://github.com/bitnami/bitnami-docker-airflow) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This Helm chart has been tested on top of [Bitnami Kubernetes Production Runtime](https://kubeprod.io/) (BKPR). Deploy BKPR to get automated TLS certificates, logging and monitoring for your applications.

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release bitnami/airflow
```

The command deploys Airflow on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the Kafka chart and their default values.

| Parameter                                 | Description                                                                                 | Default                                                      |
| ----------------------------------------- | ------------------------------------------------------------------------------------------- | ------------------------------------------------------------ |
| `global.imageRegistry`                    | Global Docker image registry                                                                | `nil`                                                        |
| `global.imagePullSecrets`                 | Global Docker registry secret names as an array                                             | `[]` (does not add image pull secrets to deployed pods)      |
| `image.registry`                          | Airflow image registry                                                                      | `docker.io`                                                  |
| `image.repository`                        | Airflow image name                                                                          | `bitnami/airflow`                                            |
| `image.tag`                               | Airflow image tag                                                                           | `{TAG_NAME}`                                                 |
| `image.pullPolicy`                        | Airflow image pull policy                                                                   | `IfNotPresent`                                               |
| `image.pullSecrets`                       | Specify docker-registry secret names as an array                                            | `[]` (does not add image pull secrets to deployed pods)      |
| `image.debug`                             | Specify if debug values should be set                                                       | `false`                                                      |
| `schedulerImage.registry`                 | Airflow Scheduler image registry                                                            | `docker.io`                                                  |
| `schedulerImage.repository`               | Airflow Scheduler image name                                                                | `bitnami/airflow-shceduler`                                  |
| `schedulerImage.tag`                      | Airflow Scheduler image tag                                                                 | `{TAG_NAME}`                                                 |
| `schedulerImage.pullPolicy`               | Airflow Scheduler image pull policy                                                         | `IfNotPresent`                                               |
| `schedulerImage.pullSecrets`              | Specify docker-registry secret names as an array                                            | `[]` (does not add image pull secrets to deployed pods)      |
| `schedulerImage.debug`                    | Specify if debug values should be set                                                       | `false`                                                      |
| `workerImage.registry`                    | Airflow Worker image registry                                                               | `docker.io`                                                  |
| `workerImage.repository`                  | Airflow Worker image name                                                                   | `bitnami/airflow-worker`                                     |
| `workerImage.tag`                         | Airflow Worker image tag                                                                    | `{TAG_NAME}`                                                 |
| `workerImage.pullPolicy`                  | Airflow Worker image pull policy                                                            | `IfNotPresent`                                               |
| `workerImage.pullSecrets`                 | Specify docker-registry secret names as an array                                            | `[]` (does not add image pull secrets to deployed pods)      |
| `workerImage.debug`                       | Specify if debug values should be set                                                       | `false`                                                      |
| `git.registry`                            | Git image registry                                                                          | `docker.io`                                                  |
| `git.repository`                          | Git image name                                                                              | `bitnami/git`                                                |
| `git.tag`                                 | Git image tag                                                                               | `{TAG_NAME}`                                                 |
| `git.pullPolicy`                          | Git image pull policy                                                                       | `IfNotPresent`                                               |
| `git.pullSecrets`                         | Specify docker-registry secret names as an array                                            | `[]` (does not add image pull secrets to deployed pods)      |
| `updateStrategy`                          | Update strategy for the stateful set                                                        | `RollingUpdate`                                              |
| `rollingUpdatePartition`                  | Partition update strategy                                                                   | `nil`                                                        |
| `airflow.configurationConfigMap`          | Name of an existing config map containing the Airflow config file                           | `nil`                                                        |
| `airflow.dagsConfigMap`                   | Name of an existing config map containing all the DAGs files you want to load in Airflow.   | `nil`                                                        |
| `airflow.loadExamples`                    | Switch to load some Airflow examples                                                        | `true`                                                       |
| `airflow.cloneDagFilesFromGit.enabled`    | Enable in order to download DAG files from git repository.                                  | `false`                                                      |
| `airflow.cloneDagFilesFromGit.repository` | Repository where download DAG files from                                                    | `nil`                                                        |
| `airflow.cloneDagFilesFromGit.branch`     | Branch from repository to checkout                                                          | `nil`                                                        |
| `airflow.cloneDagFilesFromGit.interval`   | Interval to pull the repository on sidecar container                                        | `nil`                                                        |
| `airflow.baseUrl`                         | URL used to access to airflow web ui                                                        | `nil`                                                        |
| `airflow.worker.port`                     | Airflow Worker port                                                                         | `8793`                                                       |
| `airflow.worker.replicas`                 | Number of Airflow Worker replicas                                                           | `2`                                                          |
| `airflow.auth.forcePassword`              | Force users to specify a password                                                           | `false`                                                      |
| `airflow.auth.username`                   | Username to access web UI                                                                   | `user`                                                       |
| `airflow.auth.password`                   | Password to access web UI                                                                   | `nil`                                                        |
| `airflow.auth.fernetKey`                  | Fernet key to secure connections                                                            | `nil`                                                        |
| `airflow.auth.existingSecret`             | Name of an existing secret containing airflow password and fernet key                       | `nil`                                                        |
| `airflow.extraEnvVars`                    | Extra environment variables to add to airflow web, worker and scheduler pods                | `nil`                                                        |
| `securityContext.enabled`                 | Enable security context                                                                     | `true`                                                       |
| `securityContext.fsGroup`                 | Group ID for the container                                                                  | `1001`                                                       |
| `securityContext.runAsUser`               | User ID for the container                                                                   | `1001`                                                       |
| `service.type`                            | Kubernetes Service type                                                                     | `ClusterIP`                                                  |
| `service.port`                            | Airflow Web port                                                                            | `8080`                                                       |
| `service.nodePort`                        | Kubernetes Service nodePort                                                                 | `nil`                                                        |
| `service.loadBalancerIP`                  | loadBalancerIP for Kafka Service                                                            | `nil`                                                        |
| `service.annotations`                     | Service annotations                                                                         | ``                                                           |
| `ingress.enabled`                         | Enable ingress controller resource                                                          | `false`                                                      |
| `ingress.certManager`                     | Add annotations for cert-manager                                                            | `false`                                                      |
| `ingress.annotations`                     | Ingress annotations                                                                         | `[]`                                                         |
| `ingress.hosts[0].name`                   | Hostname to your Wordpress installation                                                     | `airflow.local`                                              |
| `ingress.hosts[0].path`                   | Path within the url structure                                                               | `/`                                                          |
| `ingress.tls[0].hosts[0]`                 | TLS hosts                                                                                   | `airflow.local`                                              |
| `ingress.tls[0].secretName`               | TLS Secret (certificates)                                                                   | `airflow.local-tls`                                          |
| `ingress.secrets[0].name`                 | TLS Secret Name                                                                             | `nil`                                                        |
| `ingress.secrets[0].certificate`          | TLS Secret Certificate                                                                      | `nil`                                                        |
| `ingress.secrets[0].key`                  | TLS Secret Key                                                                              | `nil`                                                        |
| `nodeSelector`                            | Node labels for pod assignment                                                              | `{}`                                                         |
| `tolerations`                             | Toleration labels for pod assignment                                                        | `[]`                                                         |
| `affinity`                                | Map of node/pod affinities                                                                  | `{}`                                                         |
| `resources`                               | CPU/Memory resource requests/limits                                                         | Memory: `256Mi`, CPU: `250m`                                 |
| `livenessProbe.enabled`                   | would you like a livessProbed to be enabled                                                 | `true`                                                       |
| `livenessProbe.initialDelaySeconds`       | Delay before liveness probe is initiated                                                    | 180                                                          |
| `livenessProbe.periodSeconds`             | How often to perform the probe                                                              | 20                                                           |
| `livenessProbe.timeoutSeconds`            | When the probe times out                                                                    | 5                                                            |
| `livenessProbe.failureThreshold`          | Minimum consecutive failures for the probe to be considered failed after having succeeded.  | 6                                                            |
| `livenessProbe.successThreshold`          | Minimum consecutive successes for the probe to be considered successful after having failed | 1                                                            |
| `readinessProbe.enabled`                  | would you like a readinessProbe to be enabled                                               | `true`                                                       |
| `readinessProbe.initialDelaySeconds`      | Delay before liveness probe is initiated                                                    | 30                                                           |
| `readinessProbe.periodSeconds`            | How often to perform the probe                                                              | 10                                                           |
| `readinessProbe.timeoutSeconds`           | When the probe times out                                                                    | 5                                                            |
| `readinessProbe.failureThreshold`         | Minimum consecutive failures for the probe to be considered failed after having succeeded.  | 6                                                            |
| `readinessProbe.successThreshold`         | Minimum consecutive successes for the probe to be considered successful after having failed | 1                                                            |
| `postgresql.enabled`                      | Switch to enable or disable the PostgreSQL helm chart                                       | `true`                                                       |
| `postgresql.postgresqlUsername`           | Airflow Postgresql username                                                                 | `bn_airflow`                                                 |
| `postgresql.postgresqlPassword`           | Airflow Postgresql password                                                                 | `nil`                                                        |
| `postgresql.postgresqlDatabase`           | Airflow Postgresql database                                                                 | `bitnami_airflow`                                            |
| `externalDatabase.host`                   | External PostgreSQL host                                                                    | `nil`                                                        |
| `externalDatabase.user`                   | External PostgreSQL user                                                                    | `nil`                                                        |
| `externalDatabase.password`               | External PostgreSQL password                                                                | `nil`                                                        |
| `externalDatabase.database`               | External PostgreSQL database name                                                           | `nil`                                                        |
| `externalDatabase.port`                   | External PostgreSQL port                                                                    | `nil`                                                        |
| `redis.enabled`                           | Switch to enable or disable the Redis helm chart                                            | `true`                                                       |
| `externalRedis.host`                      | External Redis host                                                                         | `nil`                                                        |
| `externalRedis.port`                      | External Redis port                                                                         | `nil`                                                        |
| `externalRedis.password`                  | External Redis password                                                                     | `nil`                                                        |
| `metrics.enabled`                         | Start a side-car prometheus exporter                                                        | `false`                                                      |
| `metrics.image.registry`                  | Airflow exporter image registry                                                             | `docker.io`                                                  |
| `metrics.image.repository`                | Airflow exporter image name                                                                 | `pbweb/airflow-prometheus-exporter`                          |
| `metrics.image.tag`                       | Airflow exporter image tag                                                                  | `latest`                                                     |
| `metrics.image.pullPolicy`                | Image pull policy                                                                           | `IfNotPresent`                                               |
| `metrics.image.pullSecrets`               | Specify docker-registry secret names as an array                                            | `[]` (does not add image pull secrets to deployed pods)      |
| `metrics.podAnnotations`                  | Additional annotations for Metrics exporter                                                 | `{prometheus.io/scrape: "true", prometheus.io/port: "9112"}` |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
               --set airflow.auth.username=my-user \
               --set airflow.auth.password=my-passsword \
               --set airflow.auth.fernetKey=my-fernet-key \
               bitnami/airflow
```

The above command sets the credentials to access the Airflow web UI.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml bitnami/airflow
```

> **Tip**: You can use the default [values.yaml](values.yaml)

### Production configuration

This chart includes a `values-production.yaml` file where you can find some parameters oriented to production configuration in comparison to the regular `values.yaml`.

```console
$ helm install --name my-release -f ./values-production.yaml bitnami/airflow
```

- URL used to access to airflow web ui:
```diff
- # airflow.baseUrl:
+ airflow.baseUrl: http://airflow.local
```

- Number of Airflow Worker replicas:
```diff
- airflow.worker.replicas: 1
+ airflow.worker.replicas: 3
```

- Force users to specify a password:
```diff
- airflow.auth.forcePassword: false
+ airflow.auth.forcePassword: true
```

- Enable ingress controller resource:
```diff
- ingress.enabled: false
+ ingress.enabled: true
```

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

## Persistence

The Bitnami Airflow chart relies on the PostgreSQL chart persistence. This means that Airflow does not persist anything.

## Generate a Fernet key

A Fernet key is required in order to encrypt password within connections. The Fernet key must be a base64-encoded 32-byte key.

Learn how to generate one [here](https://bcb.github.io/airflow/fernet-key)

## Load DAG files

There are three different ways to load your custom DAG files into the Airflow chart. All of them are compatible so you can use more than one at the same time.

### Option 1: Load locally from the `files` folder

If you plan to deploy the chart from your filesystem, you can copy your DAG files inside the `files/dags` directory. A config map will be created with those files and it will be mounted in all airflow nodes..

### Option 2: Specify an existing config map

You can manually create a config map containing all your DAG files and then pass the name when deploying Airflow chart. For that, you can pass the option `--set airflow.dagsConfigMap`.

### Option 3: Get your DAG files from a git repository

You can store all your DAG files on a GitHub repository and then clone to the Airflow pods with an initContainer. The repository will be periodically updated using a sidecar container. In order to do that, you can deploy airflow with the following options:

```console
helm install --name my-release bitnami/airflow \
             --set airflow.cloneDagFilesFromGit.enabled=true \
             --set airflow.cloneDagFilesFromGit.repository=https://github.com/USERNAME/REPOSITORY \
             --set airflow.cloneDagFilesFromGit.branch=master
             --set airflow.cloneDagFilesFromGit.interval=60
```
