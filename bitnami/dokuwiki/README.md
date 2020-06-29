# DokuWiki

[DokuWiki](https://www.dokuwiki.org) is a standards-compliant, simple to use wiki optimized for creating documentation. It is targeted at developer teams, workgroups, and small companies. All data is stored in plain text files, so no database is required.

## TL;DR;

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/dokuwiki
```

## Introduction

This chart bootstraps a [DokuWiki](https://github.com/bitnami/bitnami-docker-dokuwiki) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This chart has been tested to work with NGINX Ingress, cert-manager, fluentd and Prometheus on top of the [BKPR](https://kubeprod.io/).

## Prerequisites

- Kubernetes 1.12+
- Helm 2.12+ or Helm 3.0-beta3+
- PV provisioner support in the underlying infrastructure
- ReadWriteMany volumes for deployment scaling

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install my-release bitnami/dokuwiki
```

The command deploys DokuWiki on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

The following table lists the configurable parameters of the DokuWiki chart and their default values.

| Parameter                            | Description                                                                                           | Default                                                      |
|--------------------------------------|-------------------------------------------------------------------------------------------------------|--------------------------------------------------------------|
| `global.imageRegistry`               | Global Docker image registry                                                                          | `nil`                                                        |
| `global.imagePullSecrets`            | Global Docker registry secret names as an array                                                       | `[]` (does not add image pull secrets to deployed pods)      |
| `global.storageClass`                | Global storage class for dynamic provisioning                                                         | `nil`                                                        |
| `image.registry`                     | DokuWiki image registry                                                                               | `docker.io`                                                  |
| `image.repository`                   | DokuWiki image name                                                                                   | `bitnami/dokuwiki`                                           |
| `image.tag`                          | DokuWiki image tag                                                                                    | `{TAG_NAME}`                                                 |
| `image.pullPolicy`                   | Image pull policy                                                                                     | `Always`                                                     |
| `image.pullSecrets`                  | Specify docker-registry secret names as an array                                                      | `[]` (does not add image pull secrets to deployed pods)      |
| `nameOverride`                       | String to partially override dokuwiki.fullname template with a string (will prepend the release name) | `nil`                                                        |
| `fullnameOverride`                   | String to fully override dokuwiki.fullname template with a string                                     | `nil`                                                        |
| `dokuwikiUsername`                   | User of the application                                                                               | `user`                                                       |
| `dokuwikiFullName`                   | User's full name                                                                                      | `User Name`                                                  |
| `dokuwikiPassword`                   | Application password                                                                                  | _random 10 character alphanumeric string_                    |
| `dokuwikiEmail`                      | User email                                                                                            | `user@example.com`                                           |
| `dokuwikiWikiName`                   | Wiki name                                                                                             | `My Wiki`                                                    |
| `service.type`                       | Kubernetes Service type                                                                               | `LoadBalancer`                                               |
| `service.port`                       | Service HTTP port                                                                                     | `80`                                                         |
| `service.httpsPort`                  | Service HTTPS port                                                                                    | `443`                                                        |
| `service.loadBalancerIP`             | Kubernetes LoadBalancerIP to request                                                                  | `nil`                                                        |
| `service.externalTrafficPolicy`      | Enable client source IP preservation                                                                  | `Cluster`                                                    |
| `service.nodePorts.http`             | Kubernetes http node port                                                                             | `""`                                                         |
| `service.nodePorts.https`            | Kubernetes https node port                                                                            | `""`                                                         |
| `ingress.enabled`                    | Enable ingress controller resource                                                                    | `false`                                                      |
| `ingress.hosts[0].name`              | Hostname to your DokuWiki installation                                                                | `dokuwiki.local`                                             |
| `ingress.hosts[0].path`              | Path within the url structure                                                                         | `/`                                                          |
| `ingress.hosts[0].tls`               | Utilize TLS backend in ingress                                                                        | `false`                                                      |
| `ingress.hosts[0].certManager`       | Add annotations for cert-manager                                                                      | `false`                                                      |
| `ingress.hosts[0].tlsSecret`         | TLS Secret (certificates)                                                                             | `dokuwiki.local-tls`                                         |
| `ingress.hosts[0].annotations`       | Annotations for this host's ingress record                                                            | `[]`                                                         |
| `ingress.secrets[0].name`            | TLS Secret Name                                                                                       | `nil`                                                        |
| `ingress.secrets[0].certificate`     | TLS Secret Certificate                                                                                | `nil`                                                        |
| `ingress.secrets[0].key`             | TLS Secret Key                                                                                        | `nil`                                                        |
| `persistence.enabled`                | Enable persistence using PVC                                                                          | `true`                                                       |
| `persistence.dokuwiki.storageClass`  | PVC Storage Class for DokuWiki volume                                                                 | `nil` (uses alpha storage class annotation)                  |
| `persistence.dokuwiki.accessMode`    | PVC Access Mode for DokuWiki volume                                                                   | `ReadWriteOnce`                                              |
| `persistence.dokuwiki.size`          | PVC Storage Request for DokuWiki volume                                                               | `8Gi`                                                        |
| `resources`                          | CPU/Memory resource requests/limits                                                                   | Memory: `512Mi`, CPU: `300m`                                 |
| `livenessProbe.enabled`              | Enable/disable the liveness probe                                                                     | `true`                                                       |
| `livenessProbe.initialDelaySeconds`  | Delay before liveness probe is initiated                                                              | 120                                                          |
| `livenessProbe.periodSeconds`        | How often to perform the probe                                                                        | 10                                                           |
| `livenessProbe.timeoutSeconds`       | When the probe times out                                                                              | 5                                                            |
| `livenessProbe.failureThreshold`     | Minimum consecutive failures to be considered failed                                                  | 6                                                            |
| `livenessProbe.successThreshold`     | Minimum consecutive successes to be considered successful                                             | 1                                                            |
| `readinessProbe.enabled`             | Enable/disable the readiness probe                                                                    | `true`                                                       |
| `readinessProbe.initialDelaySeconds` | Delay before readinessProbe is initiated                                                              | 30                                                           |
| `readinessProbe.periodSeconds   `    | How often to perform the probe                                                                        | 10                                                           |
| `readinessProbe.timeoutSeconds`      | When the probe times out                                                                              | 5                                                            |
| `readinessProbe.failureThreshold`    | Minimum consecutive failures to be considered failed                                                  | 6                                                            |
| `readinessProbe.successThreshold`    | Minimum consecutive successes to be considered successful                                             | 1                                                            |
| `nodeSelector`                       | Node labels for pod assignment                                                                        | `{}`                                                         |
| `affinity`                           | Affinity settings for pod assignment                                                                  | `{}`                                                         |
| `tolerations`                        | Toleration labels for pod assignment                                                                  | `[]`                                                         |
| `podAnnotations`                     | Pod annotations                                                                                       | `{}`                                                         |
| `metrics.enabled`                    | Start a side-car prometheus exporter                                                                  | `false`                                                      |
| `metrics.image.registry`             | Apache exporter image registry                                                                        | `docker.io`                                                  |
| `metrics.image.repository`           | Apache exporter image name                                                                            | `bitnami/apache-exporter`                                    |
| `metrics.image.tag`                  | Apache exporter image tag                                                                             | `{TAG_NAME}`                                                 |
| `metrics.image.pullPolicy`           | Image pull policy                                                                                     | `IfNotPresent`                                               |
| `metrics.image.pullSecrets`          | Specify docker-registry secret names as an array                                                      | `[]` (does not add image pull secrets to deployed pods)      |
| `metrics.podAnnotations`             | Additional annotations for Metrics exporter pod                                                       | `{prometheus.io/scrape: "true", prometheus.io/port: "9117"}` |
| `metrics.resources`                  | Exporter resource requests/limit                                                                      | {}                                                           |
| `certificates.customCertificate.certificateSecret`   | Secret containing the certificate and key to add                                      | `""`                                                         |
| `certificates.customCertificate.chainSecret.name`    | Name of the secret containing the certificate chain                                   | `""`                                                         |
| `certificates.customCertificate.chainSecret.key`     | Key of the certificate chain file inside the secret                                   | `""`                                                         |
| `certificates.customCertificate.certificateLocation` | Location in the container to store the certificate                                    | `/etc/ssl/certs/ssl-cert-snakeoil.pem`                       |
| `certificates.customCertificate.keyLocation`         | Location in the container to store the private key                                    | `/etc/ssl/private/ssl-cert-snakeoil.key`                     |
| `certificates.customCertificate.chainLocation`       | Location in the container to store the certificate chain                              | `/etc/ssl/certs/chain.pem`                                   |
| `certificates.customCA`              | Defines a list of secrets to import into the container trust store                                    | `[]`                                                         |
| `certificates.image.registry`        | Container sidecar registry                                                                            | `docker.io`                                                  |
| `certificates.image.repository`      | Container sidecar image                                                                               | `bitnami/minideb`                                            |
| `certificates.image.tag`             | Container sidecar image tag                                                                           | `buster`                                                     |
| `certificates.image.pullPolicy`      | Container sidecar image pull policy                                                                   | `IfNotPresent`                                               |
| `certificates.image.pullSecrets`     | Container sidecar image pull secrets                                                                  | `image.pullSecrets`                                          |
| `certificates.extraEnvVars`          | Container sidecar extra environment variables (eg proxy)                                              | `[]`                                                         |

The above parameters map to the env variables defined in [bitnami/dokuwiki](http://github.com/bitnami/bitnami-docker-dokuwiki). For more information please refer to the [bitnami/dokuwiki](http://github.com/bitnami/bitnami-docker-dokuwiki) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install my-release \
  --set dokuwikiUsername=admin,dokuwikiPassword=password \
    bitnami/dokuwiki
```

The above command sets the DokuWiki administrator account username and password to `admin` and `password` respectively.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install my-release -f values.yaml bitnami/dokuwiki
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

## Persistence

The [Bitnami DokuWiki](https://github.com/bitnami/bitnami-docker-dokuwiki) image stores the DokuWiki data and configurations at the `/bitnami/dokuwiki` path of the container.

Persistent Volume Claims are used to keep the data across deployments. There is a [known issue](https://github.com/kubernetes/kubernetes/issues/39178) in Kubernetes Clusters with EBS in different availability zones. Ensure your cluster is configured properly to create Volumes in the same availability zone where the nodes are running. Kuberentes 1.12 solved this issue with the [Volume Binding Mode](https://kubernetes.io/docs/concepts/storage/storage-classes/#volume-binding-mode).

See the [Parameters](#parameters) section to configure the PVC or to disable persistence.

## Certificates

### CA Certificates
Custom CA certificates not included in the base docker image can be added with
the following configuration. The secret must exist in the same namespace as the
deployment. Will load all certificates files it finds in the secret.

```yaml
certificates:
  customCAs:
  - secret: my-ca-1
  - secret: my-ca-2
```

#### Secret
Secret can be created with:

```bash
kubectl create secret generic my-ca-1 --from-file my-ca-1.crt
```

### TLS Certificate
A web server TLS Certificate can be injected into the container with the
following configuration. The certificate will be stored at the location
specified in the certificateLocation value.

```yaml
certificates:
  customCertificate:
    certificateSecret: my-secret
    certificateLocation: /ssl/server.pem
    keyLocation: /ssl/key.pem
    chainSecret:
      name: my-cert-chain-secret
      key: chain.pem
```

#### Secret
The certificate tls secret can be created with:

```bash
kubectl create secret tls my-secret --cert tls.crt --key tls.key
```

The certificate chain is created with:
```bash
kubectl create secret generic my-ca-1 --from-file my-ca-1.crt
```

## Upgrading

### To 6.0.0

Helm performs a lookup for the object based on its group (apps), version (v1), and kind (Deployment). Also known as its GroupVersionKind, or GVK. Changing the GVK is considered a compatibility breaker from Kubernetes' point of view, so you cannot "upgrade" those objects to the new GVK in-place. Earlier versions of Helm 3 did not perform the lookup correctly which has since been fixed to match the spec.

In https://github.com/helm/charts/pull/17294 the `apiVersion` of the deployment resources was updated to `apps/v1` in tune with the api's deprecated, resulting in compatibility breakage.

This major version signifies this change.

### To 3.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 3.0.0. The following example assumes that the release name is dokuwiki:

```console
$ kubectl patch deployment dokuwiki-dokuwiki --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
```
