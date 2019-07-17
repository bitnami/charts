# Nginx Ingress Controller

[nginx-ingress](https://github.com/kubernetes/ingress-nginx) is an Ingress controller that uses NGINX to manage external access to HTTP services in a Kubernetes cluster.

## TL;DR;

```bash
$ helm install bitnami/nginx-ingress-controller
```

## Introduction

Bitnami charts for Helm are carefully engineered, actively maintained and are the quickest and easiest way to deploy containers on a Kubernetes cluster that are ready to handle production workloads.

This chart bootstraps a [nginx-ingress](https://github.com/kubernetes/ingress-nginx) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This Helm chart has been tested on top of [Bitnami Kubernetes Production Runtime](https://kubeprod.io/) (BKPR). Deploy BKPR to get automated TLS certificates, logging and monitoring for your applications.

## Prerequisites

- Kubernetes 1.6+

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release bitnami/nginx-ingress-controller
```

The command deploys nginx-ingress-controller on the Kubernetes cluster in the default configuration.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the nginx-ingress-controller chart and their default values.

Parameter | Description | Default
--- | --- | ---
`global.imageRegistry` | Global Docker image registry | `nil`
`global.imagePullSecrets` | Global Docker registry secret names as an array | `[]` (does not add image pull secrets to deployed pods)
`name` | Name of the controller component | `controller`
`image.registry` | Name of the container image registry | `docker.io`
`image.repository` | Controller container image repository | `bitnami/nginx-ingress-controller`
`image.tag` | Controller container image tag | `{TAG_NAME}`
`image.pullPolicy` | Controller container image pull policy | `IfNotPresent`
`config` | Nginx ConfigMap entries | `use-geoip: "false", use-geoip2: "true"`
`hostNetwork` | If the nginx deployment / daemonset should run on the host's network namespace. Do not set this when `service.externalIPs` is set and `kube-proxy` is used as there will be a port-conflict for port `80` | false
`defaultBackendService` | Default 404 backend service; required only if `defaultBackend.enabled = false` | `""`
`electionID` | Election ID to use for the status update | `ingress-controller-leader`
`extraEnvs` | Any additional environment variables to set in the pods | `{}`
`extraContainers` | Sidecar containers to add to the controller pod. See [LemonLDAP::NG controller](https://github.com/lemonldap-ng-controller/lemonldap-ng-controller) as example | `{}`
`extraVolumeMounts` | Additional volumeMounts to the controller main container | `{}`
`extraVolumes` | Additional volumes to the controller pod | `{}`
`extraInitContainers` | Containers, which are run before the app containers are started | `[]`
`ingressClass` | Name of the ingress class to route through this controller | `nginx`
`scope.enabled` | Limit the scope of the ingress controller | `false` (watch all namespaces)
`scope.namespace` | Namespace to watch for ingress | `""` (use the release namespace)
`extraArgs` | Additional controller container arguments | `{}`
`kind` | Install as Deployment or DaemonSet | `Deployment`
`daemonset.useHostPort` | If `kind` is `DaemonSet`, this will enable `hostPort` for TCP/80 and TCP/443 | false
`daemonset.hostPorts.http` | If `daemonset.useHostPort` is `true` and this is non-empty, it sets the hostPort | `"80"`
`daemonset.hostPorts.https` | If `daemonset.useHostPort` is `true` and this is non-empty, it sets the hostPort | `"443"`
`tolerations` | Node taints to tolerate (requires Kubernetes >=1.6) | `[]`
`affinity` | Node/pod affinities (requires Kubernetes >=1.6) | `{}`
`minReadySeconds` | How many seconds a pod needs to be ready before killing the next, during update | `0`
`nodeSelector` | Node labels for pod assignment | `{}`
`podAnnotations` | Annotations to be added to pods | `{}`
`podLabels` | Labels to add to the pod container metadata | `{}`
`replicaCount` | Desired number of controller pods | `1`
`minAvailable` | Minimum number of available controller pods for PodDisruptionBudget | `1`
`resources` | Controller pod resource requests & limits | `{}`
`priorityClassName` | Controller priorityClassName | `nil`
`lifecycle` | Controller pod lifecycle hooks | `{}`
`service.annotations` | Annotations for controller service | `{}`
`service.labels` | Labels for controller service | `{}`
`publishService.enabled` | If true, the controller will set the endpoint records on the ingress objects to reflect those on the service | `false`
`publishService.pathOverride` | Override of the default publish-service name | `""`
`service.clusterIP` | Internal controller cluster service IP | `""`
`service.externalIPs` | Controller service external IP addresses. Do not set this when `hostNetwork` is set to `true` and `kube-proxy` is used as there will be a port-conflict for port `80` | `[]`
`service.externalTrafficPolicy` | If `service.type` is `NodePort` or `LoadBalancer`, set this to `Local` to enable [source IP preservation](https://kubernetes.io/docs/tutorials/services/source-ip/#source-ip-for-services-with-typenodeport) | `"Cluster"`
`service.healthCheckNodePort` | If `service.type` is `NodePort` or `LoadBalancer` and `service.externalTrafficPolicy` is set to `Local`, set this to [the managed health-check port the kube-proxy will expose](https://kubernetes.io/docs/tutorials/services/source-ip/#source-ip-for-services-with-typenodeport). If blank, a random port in the `NodePort` range will be assigned | `""`
`service.loadBalancerIP` | IP address to assign to load balancer (if supported) | `""`
`service.loadBalancerSourceRanges` | List of IP CIDRs allowed access to load balancer (if supported) | `[]`
`service.enableHttp` | If port 80 should be opened for service | `true`
`service.enableHttps` | If port 443 should be opened for service | `true`
`service.targetPorts.http` | Sets the targetPort that maps to the Ingress' port 80 | `80`
`service.targetPorts.https` | Sets the targetPort that maps to the Ingress' port 443 | `443`
`service.type` | Type of controller service to create | `LoadBalancer`
`service.nodePorts.http` | If `service.type` is `NodePort` and this is non-empty, it sets the nodePort that maps to the Ingress' port 80 | `""`
`service.nodePorts.https` | If `service.type` is `NodePort` and this is non-empty, it sets the nodePort that maps to the Ingress' port 443 | `""`
`livenessProbe.initialDelaySeconds` | Delay before liveness probe is initiated | 10
`livenessProbe.periodSeconds` | How often to perform the probe | 10
`livenessProbe.timeoutSeconds` | When the probe times out | 5
`livenessProbe.successThreshold` | Minimum consecutive successes for the probe to be considered successful after having failed. | 1
`livenessProbe.failureThreshold` | Minimum consecutive failures for the probe to be considered failed after having succeeded. | 3
`livenessProbe.port` | The port number that the liveness probe will listen on. | 10254
`readinessProbe.initialDelaySeconds` | Delay before readiness probe is initiated | 10
`readinessProbe.periodSeconds` | How often to perform the probe | 10
`readinessProbe.timeoutSeconds` | When the probe times out | 1
`readinessProbe.successThreshold` | Minimum consecutive successes for the probe to be considered successful after having failed. | 1
`readinessProbe.failureThreshold` | Minimum consecutive failures for the probe to be considered failed after having succeeded. | 3
`readinessProbe.port` | The port number that the readiness probe will listen on. | 10254
`stats.enabled` | If `true`, enable "vts-status" page | `false`
`stats.service.annotations` | Annotations for controller stats service | `{}`
`stats.service.clusterIP` | Internal controller stats cluster service IP | `""`
`stats.service.externalIPs` | Controller service stats external IP addresses | `[]`
`stats.service.loadBalancerIP` | IP address to assign to load balancer (if supported) | `""`
`stats.service.loadBalancerSourceRanges` | List of IP CIDRs allowed access to load balancer (if supported) | `[]`
`stats.service.type` | Type of controller stats service to create | `ClusterIP`
`metrics.enabled` | If `true`, enable Prometheus metrics (`stats.enabled` must be `true` as well) | `false`
`metrics.service.annotations` | Annotations for Prometheus metrics service | `{}`
`metrics.service.clusterIP` | Cluster IP address to assign to service | `""`
`metrics.service.externalIPs` | Prometheus metrics service external IP addresses | `[]`
`metrics.service.loadBalancerIP` | IP address to assign to load balancer (if supported) | `""`
`metrics.service.loadBalancerSourceRanges` | List of IP CIDRs allowed access to load balancer (if supported) | `[]`
`metrics.service.port` | Prometheus metrics service port | `9913`
`metrics.service.type` | Type of Prometheus metrics service to create | `ClusterIP`
`customTemplate.configMapName` | ConfigMap containing a custom nginx template | `""`
`customTemplate.configMapKey` | ConfigMap key containing the nginx template | `""`
`headers` | ConfigMap key:value pairs containing the [custom headers](https://github.com/kubernetes/ingress-nginx/tree/master/docs/examples/customization/custom-headers) for Nginx | `{}`
`updateStrategy` | Allows setting of RollingUpdate strategy | `{}`
`defaultBackend.enabled` | If false, defaultBackendService must be provided | `true`
`defaultBackend.name` | Name of the default backend component | `default-backend`
`defaultBackend.image.repository` | Default backend container image repository | `k8s.gcr.io/defaultbackend`
`defaultBackend.image.tag` | Default backend container image tag | `1.4`
`defaultBackend.image.pullPolicy` | Default backend container image pull policy | `IfNotPresent`
`defaultBackend.extraArgs` | Additional default backend container arguments | `{}`
`defaultBackend.port` | Http port number | `8080`
`defaultBackend.tolerations` | Node taints to tolerate (requires Kubernetes >=1.6) | `[]`
`defaultBackend.affinity` | Node/pod affinities (requires Kubernetes >=1.6) | `{}`
`defaultBackend.nodeSelector` | Node labels for pod assignment | `{}`
`defaultBackend.podAnnotations` | Annotations to be added to pods | `{}`
`defaultBackend.podLabels` | Labels to add to the pod container metadata | `{}`
`defaultBackend.replicaCount` | Desired number of default backend pods | `1`
`defaultBackend.minAvailable` | Minimum number of available default backend pods for PodDisruptionBudget | `1`
`defaultBackend.resources` | Default backend pod resource requests & limits | `{}`
`defaultBackend.priorityClassName` | Default backend  priorityClassName | `nil`
`defaultBackend.service.annotations` | Annotations for default backend service | `{}`
`defaultBackend.service.clusterIP` | Internal default backend cluster service IP | `""`
`defaultBackend.service.externalIPs` | Default backend service external IP addresses | `[]`
`defaultBackend.service.loadBalancerIP` | IP address to assign to load balancer (if supported) | `""`
`defaultBackend.service.loadBalancerSourceRanges` | List of IP CIDRs allowed access to load balancer (if supported) | `[]`
`defaultBackend.service.type` | Type of default backend service to create | `ClusterIP`
`imagePullSecrets` | Name of Secret resource containing private registry credentials | `nil`
`rbac.create` | If `true`, create & use RBAC resources | `true`
`securityContext.fsGroup` |	Group ID for the container	| `1001`
`securityContext.runAsUser` | User ID for the container	| `1001`
`podSecurityPolicy.enabled` | If `true`, create & use Pod Security Policy resources | `false`
`serviceAccount.create` | If `true`, create a service account | ``
`serviceAccount.name` | The name of the service account to use. If not set and `create` is `true`, a name is generated using the fullname template. | ``
`revisionHistoryLimit` | The number of old history to retain to allow rollback. | `10`
`tcp` | TCP service key:value pairs | `{}`
`udp` | UDP service key:value pairs | `{}`                                                 |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
    --set image.pullPolicy=Always \
    bitnami/nginx-ingress-controller
```

The above command sets the `image.pullPolicy` to `Always`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml bitnami/nginx-ingress-controller
```

> **Tip**: You can use the default [values.yaml](values.yaml)

### Production configuration

This chart includes a `values-production.yaml` file where you can find some parameters oriented to production configuration in comparison to the regular `values.yaml`.

```console
$ helm install --name my-release -f ./values-production.yaml bitnami/nginx-ingress-controller
```

- Enable "vts-status" page:
```diff
- stats.enabled: false
+ stats.enabled: true
```

- Enable Prometheus metrics
```diff
- metrics.enabled: false
+ metrics.enabled: true
```

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

## Upgrading

### To 1.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 1.0.0. The following example assumes that the release name is nginx-ingress-controller:

```console
$ kubectl patch deployment nginx-ingress-controller-default-backend --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
# If using deployments
$ kubectl patch deployment nginx-ingress-controller --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
# If using daemonsets
$ kubectl patch daemonset nginx-ingress-controller --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
```
