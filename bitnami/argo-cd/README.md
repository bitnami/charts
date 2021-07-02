# Argo CD

[Argo CD](https://argoproj.github.io/argo-cd/) is a declarative, GitOps continuous delivery tool for Kubernetes.

## TL;DR

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/argo-cd
```

## Introduction

This chart bootstraps an Argo CD deployment on a Kubernetes cluster using the Helm package manager.

Bitnami charts can be used with Kubeapps for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.12+
- Helm 3.1.0
- PV provisioner support in the underlying infrastructure
- ReadWriteMany volumes for deployment scaling

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release bitnami/argo-cd
```

The command deploys argo-cd on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

The above parameters map to the env variables defined in [bitnami/argo-cd](http://github.com/bitnami/bitnami-docker-argo-cd). For more information please refer to the [bitnami/argo-cd](http://github.com/bitnami/bitnami-docker-argo-cd) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
  --set controller.replicaCount=2 \
  --set server.metrics.enabled=true \
    bitnami/argo-cd
```

The above command sets the argo-cd controller replicas to 2, and enabled argo-cd server metrics.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml bitnami/argo-cd
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Ingress

This chart provides support for Ingress resources. If an Ingress controller, such as [nginx-ingress](https://kubeapps.com/charts/stable/nginx-ingress) or [traefik](https://kubeapps.com/charts/stable/traefik), that Ingress controller can be used to serve Argo CD.

To enable Ingress integration, set `server.ingress.enabled` to `true` for the http ingress or `server.grpcIngress.enabled` to `true` for the gRPC ingress. The `xxx.ingress.hostname` property can be used to set the host name. The `xxx.ingress.tls` parameter can be used to add the TLS configuration for this host. It is also possible to have more than one host, with a separate TLS configuration for each host. [Learn more about configuring and using Ingress](https://docs.bitnami.com/kubernetes/apps/argo-cd/configuration/configure-use-ingress/).

### TLS secrets

The chart also facilitates the creation of TLS secrets for use with the Ingress controller, with different options for certificate management. [Learn more about TLS secrets](https://docs.bitnami.com/kubernetes/apps/argo-cd/administration/enable-tls/).

Apart from the Ingress TLS certificates, Argo CD repo server will auto-generate a secret named `argocd-repo-server-tls`. This secret contains the TLS configuration for the Argo CD components. The secret will be created only if it does not exist, so if you want to add custom TLS configuration you can create a secret with that name before installing the chart.

### Default config maps and secrets

The chart has hardcoded names for some ConfigMaps and Secrets like `argocd-ssh-known-hosts-cm`, `argocd-repo-server-tls` or `argocd-ssh-known-hosts-cm`. Argo CD will search for those specific names when the chart installed, so installing the chart twice in the same namespaces is not possible due to this restriction.
For more information about each configmap or secret check the references at the corresponding YAML files.

### Using SSO

In order to use SSO you need to enable Dex by setting `dex.enabled=true`. You can follow [this guide](https://argoproj.github.io/argo-cd/operator-manual/user-management/#1-register-the-application-in-the-identity-provider) to configure your Argo CD deployment into your identity provider. After that, you need to configure Argo CD like described [here](https://argoproj.github.io/argo-cd/operator-manual/user-management/#2-configure-argo-cd-for-sso). You can set the Dex configuration at `server.config.dex\.config` that will populate the `argocd-cm` config map.

> NOTE: `dex.config` is the key of the object. IF you are using the Helm CLI to set the parameter you need to scape the `.` like `--set server.config.dex\.config`.

> IMPORTANT: if you enable Dex without configuring it you will get an error similar to `msg="dex is not configured"`, and the Dex pod will never reach the running state.

### Additional environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `extraEnvVars` property.

```yaml
argo-cd:
  extraEnvVars:
    - name: LOG_LEVEL
      value: error
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values.

### Sidecars

If additional containers are needed in the same pod as argo-cd (such as additional metrics or logging exporters), they can be defined using the `sidecars` parameter. If these sidecars export extra ports, extra port definitions can be added using the `service.extraPorts` parameter. [Learn more about configuring and using sidecar containers](https://docs.bitnami.com/kubernetes/apps/argo-cd/administration/configure-use-sidecars/).

### Pod affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, use one of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).
