# etcd

[etcd](https://www.etcd.org/) is an object-relational database management system (ORDBMS) with an emphasis on extensibility and on standards-compliance.

## TL;DR;

```console
$ helm install bitnami/etcd
```

## Introduction

This chart bootstraps a [etcd](https://github.com/bitnami/bitnami-docker-etcd) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This Helm chart has been tested on top of [Bitnami Kubernetes Production Runtime](https://kubeprod.io/) (BKPR). Deploy BKPR to get automated TLS certificates, logging and monitoring for your applications.

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release bitnami/etcd
```

The command deploys etcd on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the etcd chart and their default values.

|          Parameter                    |                                                  Description                                             |                                     Default                        |
|---------------------------------------|----------------------------------------------------------------------------------------------------------|------------------------------------------------------------------- |
| `global.imageRegistry`                | Global Docker image registry                                                                             | `nil`                                                              |
| `global.imagePullSecrets`             | Global Docker registry secret names as an array                                                          | `[]` (does not add image pull secrets to deployed pods)            |
| `image.registry`                      | etcd image registry                                                                                      | `docker.io`                                                        |
| `image.repository`                    | etcd Image name                                                                                          | `bitnami/etcd`                                                     |
| `image.tag`                           | etcd Image tag                                                                                           | `{TAG_NAME}`                                                       |
| `image.pullPolicy`                    | etcd image pull policy                                                                                   | `IfNotPresent`                                                     |
| `image.pullSecrets`                   | Specify docker-registry secret names as an array                                                         | `[]` (does not add image pull secrets to deployed pods)            |
| `image.debug`                         | Specify if debug values should be set                                                                    | `false`                                                            |
| `statefulset.updateStrategy`          | Update strategy for the stateful set                                                                     | `RollingUpdate`                                                    |
| `statefulset.rollingUpdatePartition`  | Partition for Rolling Update strategy                                                                    | `nil`                                                              |
| `statefulset.podManagementPolicy`     | Pod management policy for the stateful set                                                               | `OrderedReady`                                                     |
| `statefulset.replicaCount`            | Number of etcd nodes                                                                                     | `1`                                                                |
| `configFileConfigMap`                 | ConfigMap that contains a etcd.conf.yaml to be mounted                                                   | `nil`                                                              |
| `envVarsConfigMap`                    | ConfigMap that contains environment variables to be set in the container                                 | `nil`                                                              |
| `allowNoneAuthentication`             | Allow to use etcd without configuring RBAC authentication                                                | `true`                                                             |
| `maxProcs`                            | Set GOMAXPROCS environment variable to limit the number of CPUs                                          | `nil`                                                              |
| `auth.rbac.enabled`                   | Switch to enable the etcd authentication.                                                                | `true`                                                             |
| `auth.rbac.rootPassword`              | Password for the root user                                                                               | `nil`                                                              |
| `auth.rbac.existingSecret`            | Name of the existing secret containing the root password                                                 | `nil`                                                              |
| `auth.client.secureTransport`         | Switch to encrypt client communication using TLS certificates                                            | `false`                                                            |
| `auth.client.useAutoTLS`              | Switch to automatically create the TLS certificates                                                      | `false`                                                            |
| `auth.client.enableAuthentication`    | Switch to enable host authentication using TLS certificates. Requires existing secret.                   | `secret`                                                           |
| `auth.client.existingSecret`          | Name of the existing secret containing cert files for client communication.                              | `nil`                                                              |
| `auth.peer.secureTransport`           | Switch to encrypt peer communication using TLS certificates                                              | `false`                                                            |
| `auth.peer.useAutoTLS`                | Switch to automatically create the TLS certificates                                                      | `false`                                                            |
| `auth.peer.enableAuthentication`      | Switch to enable host authentication using TLS certificates. Requires existing secret.                   | `false`                                                            |
| `auth.peer.existingSecret`            | Name of the existing secret containing cert files for peer communication.                                | `nil`                                                              |
| `securityContext.enabled`             | Enable security context                                                                                  | `true`                                                             |
| `securityContext.fsGroup`             | Group ID for the container                                                                               | `1001`                                                             |
| `securityContext.runAsUser`           | User ID for the container                                                                                | `1001`                                                             |
| `service.dnsBase`                     | Kubernetes service cluster dns base name                                                                 | svc.cluster.local                                                  |
| `service.type`                        | Kubernetes Service type                                                                                  | `ClusterIP`                                                        |
| `service.port`                        | etcd client port                                                                                         | `2379`                                                             |
| `service.nodePort`                    | Port to bind to for NodePort service type (client port)                                                  | `nil`                                                              |
| `service.peerPort`                    | etcd peer port                                                                                           | `2380`                                                             |
| `service.peerNodePort`                | Port to bind to for NodePort service type (peer port)                                                    | `nil`                                                              |
| `service.annotations`                 | Annotations for etcd service                                                                             | {}                                                                 |
| `service.loadBalancerIP`              | loadBalancerIP if etcd service type is `LoadBalancer`                                                    | `nil`                                                              |
| `persistence.enabled`                 | Enable persistence using PVC                                                                             | `true`                                                             |
| `persistence.storageClass`            | PVC Storage Class for etcd volume                                                                        | `nil`                                                              |
| `persistence.accessMode`              | PVC Access Mode for etcd volume                                                                          | `ReadWriteOnce`                                                    |
| `persistence.size`                    | PVC Storage Request for etcd volume                                                                      | `8Gi`                                                              |
| `persistence.annotations`             | Annotations for the PVC                                                                                  | `{}`                                                               |
| `affinity`                            | Affinity and AntiAffinity rules for pod assignment                                                       | `{}`                                                               |
| `nodeSelector`                        | Node labels for pod assignment                                                                           | `{}`                                                               |
| `tolerations`                         | Toleration labels for pod assignment                                                                     | `[]`                                                               |
| `resources`                           | CPU/Memory resource requests/limits                                                                      | Memory: `256Mi`, CPU: `250m`                                       |
| `livenessProbe.enabled`               | Turn on and off liveness probe                                                                           |  `true`                                                            |
| `livenessProbe.initialDelaySeconds`   | Delay before liveness probe is initiated                                                                 |  10                                                                |
| `livenessProbe.periodSeconds`         | How often to perform the probe                                                                           |  10                                                                |
| `livenessProbe.timeoutSeconds`        | When the probe times out                                                                                 |  5                                                                 |
| `livenessProbe.failureThreshold`      | Minimum consecutive failures for the probe to be considered failed after having succeeded.               |  2                                                                 |
| `livenessProbe.successThreshold`      | Minimum consecutive successes for the probe to be considered successful after having failed              |  1                                                                 |
| `readinessProbe.enabled`              | Turn on and off readiness probe                                                                          |  `true`                                                            |
| `readinessProbe.initialDelaySeconds`  | Delay before liveness probe is initiated                                                                 |  5                                                                 |
| `readinessProbe.periodSeconds`        | How often to perform the probe                                                                           |  10                                                                |
| `readinessProbe.timeoutSeconds`       | When the probe times out                                                                                 |  5                                                                 |
| `readinessProbe.failureThreshold`     | Minimum consecutive failures for the probe to be considered failed after having succeeded.               |  6                                                                 |
| `readinessProbe.successThreshold`     | Minimum consecutive successes for the probe to be considered successful after having failed              |  1                                                                 |
| `podAnnotations`                      | Annotations to be added to pods                                                                          | {}                                                                 |
| `metrics.enabled`                     | Enable prometheus to access etcd metrics endpoint                                                        | `false`                                                            |
| `metrics.podAnnotations`              | Annotations for enabling prometheus to access the metrics endpoint                                       | {`prometheus.io/scrape: "true",prometheus.io/port: "2379"`}        |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set auth.rootPassword=secretpassword bitnami/etcd
```

The above command sets the etcd `etcd` account password to `secretpassword`. Additionally it creates a database named `my-database`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml bitnami/etcd
```

> **Tip**: You can use the default [values.yaml](values.yaml)

### Production configuration and horizontal scaling

This chart includes a `values-production.yaml` file where you can find some parameters oriented to production configuration in comparison to the regular `values.yaml`.

```console
$ helm install --name my-release -f ./values-production.yaml bitnami/etcd
```

- Number of etcd nodes:
```diff
- statefulset.replicaCount: 1
+ statefulset.replicaCount: 3
```

- Switch to encrypt client communication using TLS certificates:
```diff
- auth.client.secureTransport: false
+ auth.client.secureTransport: true
```

- Switch to enable host authentication using TLS certificates:
```diff
- auth.client.enableAuthentication: false
+ auth.client.enableAuthentication: true
```

- Switch to encrypt peer communication using TLS certificates:
```diff
- auth.peer.secureTransport: false
+ auth.peer.secureTransport: true
```

- Switch to automatically create the TLS certificates:
```diff
- auth.peer.useAutoTLS: false
+ auth.peer.useAutoTLS: true
```

- Enable prometheus to access etcd metrics endpoint:
```diff
- metrics.enabled: false
+ metrics.enabled: true
```

To horizontally scale this chart once it has been deployed:

```console
$ kubectl scale statefulset my-etcd --replicas=5
```

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Using custom configuration

In order to use custom configuration parameters, two options are available:

  - Using environment variables: etcd allows setting environment variables that map to configuration settings. In order to set extra environment variables, use the `envVarsConfigMap` value to point to a ConfigMap that contains them. Example:

```console
$ cat << EOF > /tmp/configurationEnvVars.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: etcd-env-vars
  namespace: default
data:
  ETCD_AUTO_COMPACTION_RETENTION: "0"
  ETCD_HEARTBEAT_INTERVAL: "150"
EOF

$ kubectl create -f /tmp/configurationEnvVars.yaml

$ helm install bitnami/etcd --set envVarsConfigMap=etcd-env-vars
```

  - Using a custom etcd.conf.yml: The etcd chart allows mounting a custom etcd.conf.yml file using the `configFileConfigMap` value. Example:

```console
$ kubectl create configmap etcd-conf --from-file=etcd.conf.yml

$ helm install bitnami/etcd --set configFileConfigMap=etcd-conf
```

## Enable security for etcd

### Configure RBAC

In order to enable [Role-based access control for etcd](https://coreos.com/etcd/docs/latest/op-guide/authentication.html) you can run the following command:

```console
$ helm install --name my-release --set auth.rbac.enabled --set auth.rbac.rootPassword=YOUR-PASSWORD bitnami/etcd

```

The previous command will deploy etcd creating a `root` user with its associate `root` role with access to everything.
The rest of users will use the `guest` role and won't have permissions to do anything.

### Configure certificated for peer communication

In order to enable secure transport between peer nodes deploy the helm chart with these options:

```console
$ helm install --name my-release --set auth.peer.secureTransport=true --set auth.peer.useAutoTLS=true bitnami/etcd

```

### Configure certificates for client comminication

In order to enable secure transport between client and server you have to create a secret containing the cert and key files and the CA used to sign those client certificates.

You can create that secret with this command:

```console
$ kubectl create secret generic etcd-client-certs --from-file=ca.crt=path/to/ca.crt --from-file=cert.pem=path/to/cert.pem --from-file=key.pem=path/to/key.pem
```

Once the secret is created, you can deploy the helm chart with these options:

```console
$ helm install --name my-release --set auth.client.secureTransport=true --set auth.client.enableAuthentication=true --set auth.client.existingSecret=etcd-client-certs bitnami/etcd

```

> Ref: [etcd security model](https://coreos.com/etcd/docs/latest/op-guide/security.html)
>
> Ref: [Generate self-signed certificagtes for etcd](https://coreos.com/os/docs/latest/generate-self-signed-certificates.html)

## Persistence

The [Bitnami etcd](https://github.com/bitnami/bitnami-docker-etcd) image stores the etcd data at the `/bitnami/etcd` path of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Configuration](#configuration) section to configure the PVC or to disable persistence.

## Upgrading

### To 1.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 1.0.0. The following example assumes that the release name is etcd:

```console
$ kubectl delete statefulset etcd --cascade=false
```