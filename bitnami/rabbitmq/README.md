# RabbitMQ

[RabbitMQ](https://www.rabbitmq.com/) is an open source message broker software that implements the Advanced Message Queuing Protocol (AMQP).

## TL;DR

```bash
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/rabbitmq
```

## Introduction

This chart bootstraps a [RabbitMQ](https://github.com/bitnami/bitnami-docker-rabbitmq) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This chart has been tested to work with NGINX Ingress, cert-manager, fluentd and Prometheus on top of the [BKPR](https://kubeprod.io/).

## Prerequisites

- Kubernetes 1.12+
- Helm 2.12+ or Helm 3.0-beta3+
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install my-release bitnami/rabbitmq
```

The command deploys RabbitMQ on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

The following table lists the configurable parameters of the RabbitMQ chart and their default values.

| Parameter                                 | Description                                                                                                          | Default                                                      |
|-------------------------------------------|----------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------|
| `global.imageRegistry`                    | Global Docker image registry                                                                                         | `nil`                                                        |
| `global.imagePullSecrets`                 | Global Docker registry secret names as an array                                                                      | `[]` (does not add image pull secrets to deployed pods)      |
| `global.storageClass`                     | Global storage class for dynamic provisioning                                                                        | `nil`                                                        |

### Common parameters

| Parameter                                 | Description                                                                                                          | Default                                                      |
|-------------------------------------------|----------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------|
| `nameOverride`                            | String to partially override rabbitmq.fullname                                                                       | `nil`                                                        |
| `fullnameOverride`                        | String to fully override rabbitmq.fullname                                                                           | `nil`                                                        |
| `clusterDomain`                           | Default Kubernetes cluster domain                                                                                    | `cluster.local`                                              |

### RabbitMQ parameters

| Parameter                                 | Description                                                                                                          | Default                                                      |
|-------------------------------------------|----------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------|
| `image.registry`                          | RabbitMQ image registry                                                                                              | `docker.io`                                                  |
| `image.repository`                        | RabbitMQ image name                                                                                                  | `bitnami/rabbitmq`                                           |
| `image.tag`                               | RabbitMQ image tag                                                                                                   | `{TAG_NAME}`                                                 |
| `image.pullPolicy`                        | RabbitMQ image pull policy                                                                                           | `IfNotPresent`                                               |
| `image.pullSecrets`                       | Specify docker-registry secret names as an array                                                                     | `[]` (does not add image pull secrets to deployed pods)      |
| `image.debug`                             | Set to true if you would like to see extra information on logs                                                       | `false`                                                      |
| `auth.username`                           | RabbitMQ application username                                                                                        | `user`                                                       |
| `auth.password`                           | RabbitMQ application password                                                                                        | _random 10 character long alphanumeric string_               |
| `auth.existingPasswordSecret`             | Existing secret with RabbitMQ credentials                                                                            | `nil` (evaluated as a template)                              |
| `auth.erlangCookie`                       | Erlang cookie                                                                                                        | _random 32 character long alphanumeric string_               |
| `auth.existingErlangSecret`               | Existing secret with RabbitMQ Erlang cookie                                                                          | `nil`                                                        |
| `auth.tls.enabled`                        | Enable TLS support on RabbitMQ                                                                                       | `false`                                                      |
| `auth.tls.failIfNoPeerCert`               | When set to true, TLS connection will be rejected if client fails to provide a certificate                           | `true`                                                       |
| `auth.tls.sslOptionsVerify`               | Should [peer verification](https://www.rabbitmq.com/ssl.html#peer-verification) be enabled?                          | `verify_peer`                                                |
| `auth.tls.caCertificate`                  | Certificate Authority (CA) bundle content                                                                            | `nil`                                                        |
| `auth.tls.serverCertificate`              | Server certificate content                                                                                           | `nil`                                                        |
| `auth.tls.serverKey`                      | Server private key content                                                                                           | `nil`                                                        |
| `auth.tls.existingSecret`                 | Existing secret with certificate content to RabbitMQ credentials                                                     | `nil`                                                        |
| `logs`                                    | Path of the RabbitMQ server's Erlang log file                                                                        | `-`                                                          |
| `ulimitNofiles`                           | Max File Descriptor limit                                                                                            | `65536`                                                      |
| `maxAvailableSchedulers`                  | RabbitMQ maximum available scheduler threads                                                                         | `2`                                                          |
| `onlineSchedulers`                        | RabbitMQ online scheduler threads                                                                                    | `1`                                                          |
| `memoryHighWatermark.enabled`             | Enable configuring Memory high watermark on RabbitMQ                                                                 | `false`                                                      |
| `memoryHighWatermark.type`                | Memory high watermark type. Either `absolute` or `relative`                                                          | `relative`                                                   |
| `memoryHighWatermark.value`               | Memory high watermark value                                                                                          | `0.4`                                                        |
| `plugins`                                 | List of plugins to enable                                                                                            | `rabbitmq_management rabbitmq_peer_discovery_k8s`            |
| `communityPlugins`                        | List of custom plugins (URLs) to be downloaded during container initialization                                       | `nil`                                                        |
| `extraPlugins`                            | Extra plugins to enable                                                                                              | `nil`                                                        |
| `clustering.addressType`                  | Switch clustering mode. Either `ip` or `hostname`                                                                    | `hostname`                                                   |
| `clustering.rebalance`                    | Rebalance master for queues in cluster when new replica is created                                                   | `false`                                                      |
| `clustering.forceBoot`                    | Rebalance master for queues in cluster when new replica is created                                                   | `false`                                                      |
| `loadDefinition.enabled`                  | Enable loading a RabbitMQ definitions file to configure RabbitMQ                                                     | `false`                                                      |
| `loadDefinition.existingSecret`           | Existing secret with the load definitions file                                                                       | `nil`                                                        |
| `command`                                 | Override default container command (useful when using custom images)                                                 | `nil`                                                        |
| `args`                                    | Override default container args (useful when using custom images)                                                    | `nil`                                                        |
| `extraEnvVars`                            | Extra environment variables to add to RabbitMQ pods                                                                  | `[]`                                                         |
| `extraEnvVarsCM`                          | Name of existing ConfigMap containing extra env vars                                                                 | `nil`                                                        |
| `extraEnvVarsSecret`                      | Name of existing Secret containing extra env vars (in case of sensitive data)                                        | `nil`                                                        |
| `extraContainerPorts`                     | Extra ports to be included in container spec, primarily informational                                                | `[]`                                                         |
| `configuration`                           | RabbitMQ configuration                                                                                               | Check `values.yaml` file                                     |
| `extraConfiguration`                      | Extra configuration to be appended to RabbitMQ configuration                                                         | Check `values.yaml` file                                     |
| `advancedConfiguration`                   | Extra configuration (in classic format)                                                                              | Check `values.yaml` file                                     |
| `ldap.enabled`                            | Enable LDAP support                                                                                                  | `false`                                                      |
| `ldap.servers`                            | List of LDAP servers hostnames                                                                                       | `[]`                                                         |
| `ldap.port`                               | LDAP servers port                                                                                                    | `389`                                                        |
| `ldap.user_dn_pattern`                    | Pattern used to translate the provided username into a value to be used for the LDAP bind                            | `cn=${username},dc=example,dc=org`                           |
| `ldap.tls.enabled`                        | Enable TLS for LDAP connections (check advancedConfiguration parameter in values.yml)                                | `false`                                                      |

### Statefulset parameters

| Parameter                                 | Description                                                                                                          | Default                                                      |
|-------------------------------------------|----------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------|
| `replicaCount`                            | Number of RabbitMQ nodes                                                                                             | `1`                                                          |
| `schedulerName`                           | Name of the k8s service (other than default)                                                                         | `nil`                                                        |
| `podManagementPolicy`                     | Pod management policy                                                                                                | `OrderedReady`                                               |
| `updateStrategyType`                      | Update strategy type for the statefulset                                                                             | `RollingUpdate`                                              |
| `rollingUpdatePartition`                  | Partition update strategy                                                                                            | `nil`                                                        |
| `podLabels`                               | RabbitMQ pod labels                                                                                                  | `{}` (evaluated as a template)                               |
| `podAnnotations`                          | RabbitMQ Pod annotations                                                                                             | `{}` (evaluated as a template)                               |
| `affinity`                                | Affinity for pod assignment                                                                                          | `{}` (evaluated as a template)                               |
| `priorityClassName`                       | Name of the existing priority class to be used by kafka pods                                                         | `""`                                                         |
| `nodeSelector`                            | Node labels for pod assignment                                                                                       | `{}` (evaluated as a template)                               |
| `tolerations`                             | Tolerations for pod assignment                                                                                       | `[]` (evaluated as a template)                               |
| `podSecurityContext`                      | RabbitMQ pods' Security Context                                                                                      | `{}`                                                         |
| `containerSecurityContext`                | RabbitMQ containers' Security Context                                                                                | `{}`                                                         |
| `resources.limits`                        | The resources limits for RabbitMQ containers                                                                         | `{}`                                                         |
| `resources.requests`                      | The requested resources for RabbitMQ containers                                                                      | `{}`                                                         |
| `livenessProbe`                           | Liveness probe configuration for RabbitMQ                                                                            | Check `values.yaml` file                                     |
| `readinessProbe`                          | Readiness probe configuration for RabbitMQ                                                                           | Check `values.yaml` file                                     |
| `customLivenessProbe`                     | Override default liveness probe                                                                                      | `nil`                                                        |
| `customReadinessProbe`                    | Override default readiness probe                                                                                     | `nil`                                                        |
| `pdb.create`                              | Enable/disable a Pod Disruption Budget creation                                                                      | `false`                                                      |
| `pdb.minAvailable`                        | Minimum number/percentage of pods that should remain scheduled                                                       | `nil`                                                        |
| `pdb.maxUnavailable`                      | Maximum number/percentage of pods that may be made unavailable                                                       | `1`                                                          |
| `initContainers`                          | Add additional init containers to the RabbitMQ pod                                                                   | `{}` (evaluated as a template)                               |
| `sidecars`                                | Add additional sidecar containers to the RabbitMQ pod                                                                | `{}` (evaluated as a template)                               |
| `extraVolumeMounts`                       | Optionally specify extra list of additional volumeMounts .                                                           | `{}`                                                         |
| `extraVolumes`                            | Optionally specify extra list of additional volumes .                                                                | `{}`                                                         |
| `extraSecrets`                            | Optionally specify extra secrets to be created by the chart.                                                         | `{}`                                                         |

### Exposure parameters

| Parameter                                 | Description                                                                                                          | Default                                                      |
|-------------------------------------------|----------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------|
| `service.type`                            | Kubernetes Service type                                                                                              | `ClusterIP`                                                  |
| `service.port`                            | Amqp port                                                                                                            | `5672`                                                       |
| `service.tlsPort`                         | Amqp TLS port                                                                                                        | `5671`                                                       |
| `service.nodePort`                        | Node port override for `amqp` port, if serviceType NodePort or LoadBalancer                                          | `nil`                                                        |
| `service.tlsNodePort`                     | Node port override for `amqp-ssl` port, if serviceType NodePort or LoadBalancer                                      | `nil`                                                        |
| `service.distPort`                        | Erlang distribution server port                                                                                      | `25672`                                                      |
| `service.distNodePort`                    | Node port override for `dist` port, if serviceType NodePort                                                          | `nil`                                                        |
| `service.managerPort`                     | RabbitMQ Manager port                                                                                                | `15672`                                                      |
| `service.managerNodePort`                 | Node port override for `http-stats` port, if serviceType NodePort                                                    | `nil`                                                        |
| `service.metricsPort`                     | RabbitMQ Prometheues metrics port                                                                                    | `9419`                                                       |
| `service.metricsNodePort`                 | Node port override for `metrics` port, if serviceType NodePort                                                       | `nil`                                                        |
| `service.epmdNodePort`                    | Node port override for `epmd` port, if serviceType NodePort                                                          | `nil`                                                        |
| `service.extraPorts`                      | Extra ports to expose in the service                                                                                 | `[]`                                                         |
| `service.loadBalancerSourceRanges`        | Address(es) that are allowed when service is LoadBalancer                                                            | `[]`                                                         |
| `service.loadBalancerIP`                  | LoadBalancerIP for the service                                                                                       | `nil`                                                        |
| `service.externalIP`                      | ExternalIP for the service                                                                                           | `nil`                                                        |
| `service.labels`                          | Service labels                                                                                                       | `{}` (evaluated as a template)                               |
| `service.annotations`                     | Service annotations                                                                                                  | `{}` (evaluated as a template)                               |
| `ingress.enabled`                         | Enable ingress resource for Management console                                                                       | `false`                                                      |
| `ingress.path`                            | Path for the default host                                                                                            | `/`                                                          |
| `ingress.certManager`                     | Add annotations for cert-manager                                                                                     | `false`                                                      |
| `ingress.hostname`                        | Default host for the ingress resource                                                                                | `rabbitmq.local`                                             |
| `ingress.annotations`                     | Ingress annotations                                                                                                  | `[]`                                                         |
| `ingress.tls`                             | Enable TLS configuration for the hostname defined at `ingress.hostname` parameter                                    | `false`                                                      |
| `ingress.existingSecret`                  | Existing secret for the Ingress TLS certificate                                                                      | `nil`                                                        |
| `ingress.extraHosts[0].name`              | Additional hostnames to be covered                                                                                   | `nil`                                                        |
| `ingress.extraHosts[0].path`              | Additional hostnames to be covered                                                                                   | `nil`                                                        |
| `ingress.extraTls[0].hosts[0]`            | TLS configuration for additional hostnames to be covered                                                             | `nil`                                                        |
| `ingress.extraTls[0].secretName`          | TLS configuration for additional hostnames to be covered                                                             | `nil`                                                        |
| `ingress.secrets[0].name`                 | TLS Secret Name                                                                                                      | `nil`                                                        |
| `ingress.secrets[0].certificate`          | TLS Secret Certificate                                                                                               | `nil`                                                        |
| `ingress.secrets[0].key`                  | TLS Secret Key                                                                                                       | `nil`                                                        |
| `networkPolicy.enabled`                   | Enable NetworkPolicy                                                                                                 | `false`                                                      |
| `networkPolicy.allowExternal`             | Don't require client label for connections                                                                           | `true`                                                       |
| `networkPolicy.additionalRules`           | Additional NetworkPolicy rules                                                                                       | `nil`                                                        |

### Persistence parameters

| Parameter                                 | Description                                                                                                          | Default                                                      |
|-------------------------------------------|----------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------|
| `persistence.enabled`                     | Enable RabbitMQ data persistence using PVC                                                                           | `true`                                                       |
| `persistence.existingClaim`               | Provide an existing `PersistentVolumeClaim`, the value is evaluated as a template                                    | `nil`                                                        |
| `persistence.storageClass`                | PVC Storage Class for RabbitMQ data volume                                                                           | `nil`                                                        |
| `persistence.accessMode`                  | PVC Access Mode for RabbitMQ data volume                                                                             | `ReadWriteOnce`                                              |
| `persistence.size`                        | PVC Storage Request for RabbitMQ data volume                                                                         | `8Gi`                                                        |
| `persistence.selector`                    | Selector to match an existing Persistent Volume                                                                      | `{}`(evaluated as a template)                                |
| `persistence.volumes`                     | Additional volumes without creating PVC                                                                             | `{}`(evaluated as a template)                                |

### RBAC parameters

| Parameter                                 | Description                                                                                                          | Default                                                      |
|-------------------------------------------|----------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------|
| `serviceAccount.create`                   | Enable creation of ServiceAccount for RabbitMQ pods                                                                  | `true`                                                       |
| `serviceAccount.name`                     | Name of the created serviceAccount                                                                                   | Generated using the `rabbitmq.fullname` template             |
| `rbac.create`                             | Weather to create & use RBAC resources or not                                                                        | `false`                                                      |

### Volume Permissions parameters

| Parameter                                 | Description                                                                                                          | Default                                                      |
|-------------------------------------------|----------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------|
| `volumePermissions.enabled`               | Enable init container that changes the owner and group of the persistent volume(s) mountpoint to `runAsUser:fsGroup` | `false`                                                      |
| `volumePermissions.image.registry`        | Init container volume-permissions image registry                                                                     | `docker.io`                                                  |
| `volumePermissions.image.repository`      | Init container volume-permissions image name                                                                         | `bitnami/minideb`                                            |
| `volumePermissions.image.tag`             | Init container volume-permissions image tag                                                                          | `buster`                                                     |
| `volumePermissions.image.pullPolicy`      | Init container volume-permissions image pull policy                                                                  | `Always`                                                     |
| `volumePermissions.image.pullSecrets`     | Specify docker-registry secret names as an array                                                                     | `[]` (does not add image pull secrets to deployed pods)      |
| `volumePermissions.resources.limits`      | Init container volume-permissions resource  limits                                                                   | `{}`                                                         |
| `volumePermissions.resources.requests`    | Init container volume-permissions resource  requests                                                                 | `{}`                                                         |

### Metrics parameters

| Parameter                                 | Description                                                                                                          | Default                                                      |
|-------------------------------------------|----------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------|
| `metrics.enabled`                         | Enable exposing RabbitMQ metrics to be gathered by Prometheus                                                        | `false`                                                      |
| `metrics.plugins`                         | Plugins to enable Prometheus metrics in RabbitMQ                                                                     | `rabbitmq_prometheus`                                        |
| `metrics.podAnnotations`                  | Annotations for enabling prometheus to access the metrics endpoint                                                   | `{prometheus.io/scrape: "true", prometheus.io/port: "9419"}` |
| `metrics.serviceMonitor.enabled`          | Create ServiceMonitor Resource for scraping metrics using PrometheusOperator                                         | `false`                                                      |
| `metrics.serviceMonitor.namespace`        | Namespace which Prometheus is running in                                                                             | `monitoring`                                                 |
| `metrics.serviceMonitor.interval`         | Interval at which metrics should be scraped                                                                          | `30s`                                                        |
| `metrics.serviceMonitor.scrapeTimeout`    | Specify the timeout after which the scrape is ended                                                                  | `nil`                                                        |
| `metrics.serviceMonitor.relabellings`     | Specify Metric Relabellings to add to the scrape endpoint                                                            | `nil`                                                        |
| `metrics.serviceMonitor.honorLabels`      | honorLabels chooses the metric's labels on collisions with target labels.                                            | `false`                                                      |
| `metrics.serviceMonitor.additionalLabels` | Used to pass Labels that are required by the Installed Prometheus Operator                                           | `{}`                                                         |
| `metrics.serviceMonitor.release`          | Used to pass Labels release that sometimes should be custom for Prometheus Operator                                  | `nil`                                                        |
| `metrics.prometheusRule.enabled`          | Set this to true to create prometheusRules for Prometheus operator                                                   | `false`                                                      |
| `metrics.prometheusRule.additionalLabels` | Additional labels that can be used so prometheusRules will be discovered by Prometheus                               | `{}`                                                         |
| `metrics.prometheusRule.namespace`        | namespace where prometheusRules resource should be created                                                           | `monitoring`                                                 |
| `metrics.prometheusRule.rules`            | Rules to be created, check values for an example.                                                                    | `[]`                                                         |

The above parameters map to the env variables defined in [bitnami/rabbitmq](http://github.com/bitnami/bitnami-docker-rabbitmq). For more information please refer to the [bitnami/rabbitmq](http://github.com/bitnami/bitnami-docker-rabbitmq) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install my-release \
  --set auth.username=admin,auth.password=secretpassword,auth.erlangCookie=secretcookie \
    bitnami/rabbitmq
```

The above command sets the RabbitMQ admin username and password to `admin` and `secretpassword` respectively. Additionally the secure erlang cookie is set to `secretcookie`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install my-release -f values.yaml bitnami/rabbitmq
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Production configuration and horizontal scaling

This chart includes a `values-production.yaml` file where you can find some parameters oriented to production configuration in comparison to the regular `values.yaml`. You can use this file instead of the default one. In case you want to spread the deployment accross nodes you should configure the affinity parameters.

- Increase the number of replicas:

```diff
- replicaCount: 1
+ replicaCount: 3
```

- Resource needs and limits to apply to the pod:

```diff
resources:
- requests: {}
+ requests:
+   memory: 2Gi
+   cpu: 1000m
- limits: {}
+ limits:
+   memory: 2Gi
+   cpu: 1000m
```

- Enable Memory high watermark relative limit:

```diff
- memoryHighWatermark.enabled: false
+ memoryHighWatermark.enabled: true
```

- Enable NetworkPolicy:

```diff
- networkPolicy.enabled: false
+ networkPolicy.enabled: true
- networkPolicy.allowExternal: true
+ networkPolicy.allowExternal: false
```

- Enable Pod Disruption Budget:

```diff
- pdb.create: false
+ pdb.create: true
```

- Enable Prometheus metrics:

```diff
- metrics.enabled: false
+ metrics.enabled: true
```

To horizontally scale this chart once it has been deployed you have two options:

- Use `kubectl scale` command.
- Upgrading the chart with the following parameters:

```console
replicaCount=3
auth.password="$RABBITMQ_PASSWORD"
auth.erlangCookie="$RABBITMQ_ERLANG_COOKIE"
```

> Note: please note it's mandatory to indicate the password and erlangCookie that was set the first time the chart was installed to upgrade the chart. Otherwise, new pods won't be able to join the cluster.

When scaling down the solution unnecessary RabbitMQ nodes are automatically stopped, but they are not removed from the cluster. You need to manually remove them running the `rabbitmqctl forget_cluster_node` command. For instance, if you initially installed RabbitMQ with 3 replicas and then you scaled it down to 2 replicas, run the commands below (assuming that the release name is `rabbitmq` and you're using `hostname` as clustering type):

```console
$ kubectl exec rabbitmq-0 --container rabbitmq -- rabbitmqctl forget_cluster_node rabbit@rabbitmq-2.rabbitmq-headless.default.svc.cluster.local
$ kubectl delete pvc data-rabbitmq-2
```

### Enabling TLS support

To enable TLS support you must generate the certificates using RabbitMQ [documentation](https://www.rabbitmq.com/ssl.html#automated-certificate-generation). Once you have your certificate, you have two alternatives:

A) Create a secret including the certificates:

```bash
$ kubectl create secret generic rabbitmq-certificates --from-file=./ca.crt --from-file=./tls.crt --from-file=./tls.key
```

Then, install the RabbitMQ chart setting the parameters below:

```console
tls.enabled=true
tls.existingSecret=rabbitmq-certificates
```

B) Include the certificates in your values.yaml:

```yaml
auth:
  enabled: true
  caCertificate: |-
    -----BEGIN CERTIFICATE-----
    MIIDRTCCAi2gAwIBAgIJAJPh+paO6a3cMA0GCSqGSIb3DQEBCwUAMDExIDAeBgNV
    ...
    -----END CERTIFICATE-----
  serverCertificate: |-
    -----BEGIN CERTIFICATE-----
    MIIDqjCCApKgAwIBAgIBATANBgkqhkiG9w0BAQsFADAxMSAwHgYDVQQDDBdUTFNH
    ...
    -----END CERTIFICATE-----
  serverKey: |-
    -----BEGIN RSA PRIVATE KEY-----
    MIIEpAIBAAKCAQEA2iX3M4d3LHrRAoVUbeFZN3EaGzKhyBsz7GWwTgETiNj+AL7p
    ....
    -----END RSA PRIVATE KEY-----
```

- Setting [auth.tls.failIfNoPeerCert](https://www.rabbitmq.com/ssl.html#peer-verification-configuration) to `false` allows a TLS connection if client fails to provide a certificate.
- When setting [auth.tls.sslOptionsVerify](https://www.rabbitmq.com/ssl.html#peer-verification-configuration) to `verify_peer`, the node must perform peer verification. When set to `verify_none`, peer verification will be disabled and certificate exchange won't be performed.

### Load Definitions

It is possible to [load a RabbitMQ definitions file to configure RabbitMQ](http://www.rabbitmq.com/management.html#load-definitions). Because definitions may contain RabbitMQ credentials, [store the JSON as a Kubernetes secret](https://kubernetes.io/docs/concepts/configuration/secret/#using-secrets-as-files-from-a-pod). Within the secret's data, choose a key name that corresponds with the desired load definitions filename (i.e. `load_definition.json`) and use the JSON object as the value. For example:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: rabbitmq-load-definition
type: Opaque
stringData:
  load_definition.json: |-
    {
      "vhosts": [
        {
          "name": "/"
        }
      ]
    }
```

Then, specify the `load_definitions` property as an `extraConfiguration` pointing to the load definition file path within the container (i.e. `/app/load_definition.json`) and set `loadDefinition.enable` to `true`. Any load definitions specified will be available within in the container at `/app`.

> Loading a definition will take precedence over any configuration done through [Helm values](#parameters).

If needed, you can use `extraSecrets` to let the chart create the secret for you. This way, you don't need to manually create it before deploying a release. For example :

```yaml
extraSecrets:
  load-definition:
    load_definition.json: |
      {
        "vhosts": [
          {
            "name": "/"
          }
        ]
      }
loadDefinition:
  enabled: true
  existingSecret: load-definition
extraConfiguration: |
  load_definitions = /app/load_definition.json
```

### LDAP

LDAP support can be enabled in the chart by specifying the `ldap.` parameters while creating a release. The following parameters should be configured to properly enable the LDAP support in the chart.

- `ldap.enabled`: Enable LDAP support. Defaults to `false`.
- `ldap.servers`: List of LDAP servers hostnames. No defaults.
- `ldap.port`: LDAP servers port. `389`.
- `ldap.user_dn_pattern`: Pattern used to translate the provided username into a value to be used for the LDAP bind. Defaults to `cn=${username},dc=example,dc=org`.
- `ldap.tls.enabled`: Enable TLS for LDAP connections. Defaults to `false`.

For example:

```console
ldap.enabled=true
ldap.serverss[0]="my-ldap-server"
ldap.port="389"
ldap.user_dn_pattern="cn=${username},dc=example,dc=org"
```

If `ldap.tls.enabled` is set to true, consider using `ldap.port=636` and checking the settings in the advancedConfiguration.

### Memory high watermark

It is possible to configure Memory high watermark on RabbitMQ to define [memory thresholds](https://www.rabbitmq.com/memory.html#threshold) using the `memoryHighWatermark.*` parameters. To do so, you have two alternatives:

A) Set an absolute limit of RAM to be used on each RabbitMQ node:

```console
memoryHighWatermark.enabled="true"
memoryHighWatermark.type="absolute"
memoryHighWatermark.value="512MB"
```

B) Set a relative limit of RAM to be used on each RabbitMQ node. To enable this feature, you must define the memory limits at POD level too:

```console
memoryHighWatermark.enabled="true"
memoryHighWatermark.type="relative"
memoryHighWatermark.value="0.4"
resources.limits.memory="2Gi"
```

### Adding extra environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `extraEnvVars` property.

```yaml
extraEnvVars:
  - name: LOG_LEVEL
    value: error
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `.extraEnvVarsCM` or the `extraEnvVarsSecret` properties.

### Plugins

The Bitnami Docker RabbitMQ image ships a set of plugins by default. You can use the command below to obtain the whole list.

```bash
$ docker run --rm -it bitnami/rabbitmq -- ls /opt/bitnami/rabbitmq/plugins/
```

By default, this chart enables `rabbitmq_management` and `rabbitmq_peer_discovery_k8s` since they are required for RabbitMQ to work on K8s. To enable extra plugins, set the `extraPlugins` parameter with the list of plugins you want to enable.

In addition to this, you can also use the `communityPlugins` parameter to indicate a list of URLs separated by spaces where to download you custom plugins for RabbitMQ. For instance, use the parameters below to download a custom plugin during the container initialization and enable it:

```console
communityPlugins="http://some-public-url/my-custom-plugin-X.Y.Z.ez"
extraPlugins="my-custom-plugin"
```

### Known issues

- Changing the password through RabbitMQ's UI can make the pod fail due to the default liveness probes. If you do so, remember to make the chart aware of the new password. Updating the default secret with the password you set through RabbitMQ's UI will automatically recreate the pods. If you are using your own secret, you may have to manually recreate the pods.

## Persistence

The [Bitnami RabbitMQ](https://github.com/bitnami/bitnami-docker-rabbitmq) image stores the RabbitMQ data and configurations at the `/opt/bitnami/rabbitmq/var/lib/rabbitmq/` path of the container.

The chart mounts a [Persistent Volume](http://kubernetes.io/docs/user-guide/persistent-volumes/) at this location. By default, the volume is created using dynamic volume provisioning. An existing PersistentVolumeClaim can also be defined.

### Existing PersistentVolumeClaims

1. Create the PersistentVolume
1. Create the PersistentVolumeClaim
1. Install the chart

```bash
$ helm install my-release --set persistence.existingClaim=PVC_NAME bitnami/rabbitmq
```

### Adjust permissions of the persistence volume mountpoint

As the image runs as non-root by default, it is necessary to adjust the ownership of the persistent volume so that the container can write data into it.

By default, the chart is configured to use Kubernetes Security Context to automatically change the ownership of the volume. However, this feature does not work in all Kubernetes distributions.
As an alternative, this chart supports using an `initContainer` to change the ownership of the volume before mounting it in the final destination.

You can enable this `initContainer` by setting `volumePermissions.enabled` to `true`.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami’s Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

It's necessary to set the `auth.password` and `auth.erlangCookie` parameters when upgrading for readiness/liveness probes to work properly. When you install this chart for the first time, some notes will be displayed providing the credentials you must use under the 'Credentials' section. Please note down the password and the cookie, and run the command below to upgrade your chart:

```bash
$ helm upgrade my-release bitnami/rabbitmq --set auth.password=[PASSWORD] --set auth.erlangCookie=[RABBITMQ_ERLANG_COOKIE]
```

| Note: you need to substitute the placeholders [PASSWORD] and [RABBITMQ_ERLANG_COOKIE] with the values obtained in the installation notes.

### To 7.0.0

- Several parameters were renamed or dissapeared in favor of new ones on this major version:
  - `replicas` is renamed to `replicaCount`.
  - `securityContext.*` is deprecated in favor of `podSecurityContext` and `containerSecurityContext`.
  - Authentication parameters were reorganized under the `auth.*` parameter:
    - `rabbitmq.username`, `rabbitmq.password`, and `rabbitmq.erlangCookie` are now `auth.username`, `auth.password`, and `auth.erlangCookie` respectively.
    - `rabbitmq.tls.*` parameters are now under `auth.tls.*`.
  - Parameters prefixed with `rabbitmq.` were renamed removing the prefix. E.g. `rabbitmq.configuration` -> renamed to `configuration`.
  - `rabbitmq.rabbitmqClusterNodeName` is deprecated.
  - `rabbitmq.setUlimitNofiles` is deprecated.
  - `forceBoot.enabled` is renamed to `clustering.forceBoot`.
  - `loadDefinition.secretName` is renamed to `loadDefinition.existingSecret`.
  - `metics.port` is remamed to `service.metricsPort`.
  - `service.extraContainerPorts` is renamed to `extraContainerPorts`.
  - `service.nodeTlsPort` is renamed to `service.tlsNodePort`.
  - `podDisruptionBudget` is deprecated in favor of `pdb.create`, `pdb.minAvailable`, and `pdb.maxUnavailable`.
  - `rbacEnabled` -> deprecated in favor of `rbac.create`.
  - New parameters: `serviceAccount.create`, and `serviceAccount.name`.
  - New parameters: `memoryHighWatermark.enabled`, `memoryHighWatermark.type`, and `memoryHighWatermark.value`.
- Chart labels and Ingress configuration were adapted to follow the Helm charts best practices.
- Initialization logic now relies on the container.
- This version introduces `bitnami/common`, a [library chart](https://helm.sh/docs/topics/library_charts/#helm) as a dependency. More documentation about this new utility could be found [here](https://github.com/bitnami/charts/tree/master/bitnami/common#bitnami-common-library-chart). Please, make sure that you have updated the chart dependencies before executing any upgrade.

Consequences:

- Backwards compatibility is not guaranteed.
- Compatibility with non Bitnami images is not guaranteed anymore.

### To 6.0.0

This new version updates the RabbitMQ image to a [new version based on bash instead of node.js](https://github.com/bitnami/bitnami-docker-rabbitmq#3715-r18-3715-ol-7-r19). However, since this Chart overwrites the container's command, the changes to the container shouldn't affect the Chart. To upgrade, it may be needed to enable the `fastBoot` option, as it is already the case from upgrading from 5.X to 5.Y.

### To 5.0.0

This major release changes the clustering method from `ip` to `hostname`.
This change is needed to fix the persistence. The data dir will now depend on the hostname which is stable instead of the pod IP that might change.

> IMPORTANT: Note that if you upgrade from a previous version you will lose your data.

### To 3.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 3.0.0. The following example assumes that the release name is rabbitmq:

```console
$ kubectl delete statefulset rabbitmq --cascade=false
```

## Bitnami Kubernetes Documentation

Bitnami Kubernetes documentation is available at [https://docs.bitnami.com/](https://docs.bitnami.com/). You can find there the following resources:

- [Documentation for RabbitMQ Helm chart](https://docs.bitnami.com/kubernetes/infrastructure/rabbitmq/)
- [Get Started with Kubernetes guides](https://docs.bitnami.com/kubernetes/)
- [Bitnami Helm charts documentation](https://docs.bitnami.com/kubernetes/apps/)
- [Kubernetes FAQs](https://docs.bitnami.com/kubernetes/faq/)
- [Kubernetes Developer guides](https://docs.bitnami.com/tutorials/)
