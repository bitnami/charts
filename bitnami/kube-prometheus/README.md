<!--- app-name: Prometheus Operator -->

# Prometheus Operator packaged by Bitnami

Prometheus Operator provides easy monitoring definitions for Kubernetes services and deployment and management of Prometheus instances.

[Overview of Prometheus Operator](https://github.com/coreos/prometheus-operator)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```bash
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/kube-prometheus
```

## Introduction

This chart bootstraps [Prometheus Operator](https://github.com/bitnami/bitnami-docker-prometheus-operator) on [Kubernetes](https://kubernetes.io) using the [Helm](https://helm.sh) package manager.

In the default configuration the chart deploys the following components on the Kubernetes cluster:

- [Prometheus Operator](https://github.com/prometheus-operator/prometheus-operator)
- [Prometheus](https://github.com/prometheus/prometheus/)
- [Alertmanager](https://github.com/prometheus/alertmanager)

**IMPORTANT**

Only one instance of the Prometheus Operator component should be running in the cluster. If you wish to deploy this chart to **manage multiple instances** of Prometheus in your Kubernetes cluster, you **have to disable** the installation of the Prometheus Operator component using the `operator.enabled=false` chart installation argument.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.16+
- Helm 3.2.0+

## Installing the Chart

Add the `bitnami` charts repo to Helm:

```bash
$ helm repo add bitnami https://charts.bitnami.com/bitnami
```

To install the chart with the release name `my-release`:

```bash
$ helm install my-release bitnami/kube-prometheus
```

The command deploys kube-prometheus on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` release:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release. Use the flag `--purge` to delete all history too.

## Parameters

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install my-release \
  --set operator.logLevel=debug \
  --set prometheus.replicaCount=5 \
    bitnami/kube-prometheus
```

The above command sets the Prometheus Operator `logLevel` to `debug`. Additionally it sets the `prometheus.replicaCount` to `5`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install my-release -f values.yaml bitnami/kube-prometheus
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling vs Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Additional scrape configurations

The following values have been deprecated. See [Upgrading](#upgrading) below.

```console
prometheus.additionalScrapeConfigsExternal.enabled
prometheus.additionalScrapeConfigsExternal.name
prometheus.additionalScrapeConfigsExternal.key
```

It is possible to inject externally managed scrape configurations via a Secret by setting `prometheus.additionalScrapeConfigs.enabled` to `true` and `prometheus.additionalScrapeConfigs.type` to `external`. The secret must exist in the same namespace as the chart deployment. Set the secret name using the parameter `prometheus.additionalScrapeConfigs.external.name`, and the key containing the additional scrape configuration using the `prometheus.additionalScrapeConfigs.external.key`.

It is also possible to define scrape configuratios to be managed by the Helm chart by setting `prometheus.additionalScrapeConfigs.enabled` to `true` and `prometheus.additionalScrapeConfigs.type` to `internal`. You can then use `prometheus.additionalScrapeConfigs.internal.jobList` to define a list of additional scrape jobs for Prometheus.

Refer to the [chart documentation on customizing scrape configurations](https://docs.bitnami.com/kubernetes/apps/prometheus-operator/configuration/customize-scrape-configurations) for an example.

### Additional alert relabel configurations

It is possible to inject externally managed Prometheus alert relabel configurations via a Secret by setting `prometheus.additionalAlertRelabelConfigsExternal.enabled` to `true`. The secret must exist in the same namespace as the chart deployment. Set the secret name using the parameter `prometheus.additionalAlertRelabelConfigsExternal.name`, and the key containing the additional alert relabel configuration using the `prometheus.additionalAlertRelabelConfigsExternal.key`.

Refer to the [chart documentation on customizing alert configurations](https://docs.bitnami.com/kubernetes/apps/prometheus-operator/configuration/customize-alert-configurations) for an example.

### Set Pod affinity

This chart allows setting custom Pod affinity using the `XXX.affinity` parameter(s). Find more information about Pod's affinity in the [Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, use one of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `XXX.podAffinityPreset`, `XXX.podAntiAffinityPreset`, or `XXX.nodeAffinityPreset` parameters.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

```bash
$ helm upgrade my-release bitnami/kube-prometheus
```

### To 6.0.0

This major update changes the `securityContext` interface in the `values.yaml` file.

Please note if you have changes in the `securityContext` fields those need to be migrated to `podSecurityContext`.

```diff
# ...
- securityContext:
+ podSecurityContext:
# ...
```

Other than that a new `securityContext` interface for containers got introduced `containerSecurityContext`. It's default is enabled so if you do not need it you need to opt out of it.

If you use [Strategic Merge Patch](https://github.com/prometheus-operator/prometheus-operator/blob/master/Documentation/user-guides/strategic-merge-patch.md) for any of the
`Alertmanager` or `Prometheus` kinds you need to actively disable all of those things below. For the resource you want to use Strategic Merge Patch for.

```yaml
<resource>:
  containerSecurityContext:
    enabled: false
  livenessProbe:
    enabled: false
  readinessProbe:
    enabled: false
```

### To 5.0.0

This major updates the kube-state-metrics subchart to it newest major, 2.0.0, which contains name changes to a few of its values. For more information on this subchart's major, please refer to [kube-state-metrics upgrade notes](https://github.com/bitnami/charts/tree/master/bitnami/kube-state-metrics#to-200).

### To 4.4.0

This version replaced the old `configReloaderCpu` and `configReloaderMemory` variables in favor of the new `configReloaderResources` map to define the requests and limits for the config-reloader sidecards. Users who made use of the old variables will need to migrate to the new ones.

### To 4.0.0

This version standardizes the way of defining Ingress rules.
When configuring a single hostname for the Prometheus Ingress rule, set the `prometheus.ingress.hostname` value. When defining more than one, set the `prometheus.ingress.extraHosts` array.
When configuring a single hostname for the Alertmanager Ingress rule, set the `alertmanager.ingress.hostname` value. When defining more than one, set the `alertmanager.ingress.extraHosts` array.

Apart from this case, no issues are expected to appear when upgrading.

### To 3.4.0

Some parameters disappeared in favor of new ones:

- `prometheus.additionalScrapeConfigsExternal.enabled` -> deprecated in favor of `prometheus.additionalScrapeConfigs.enabled` and `prometheus.additionalScrapeConfigs.type`.
- `prometheus.additionalScrapeConfigsExternal.name` -> deprecated in favor of `prometheus.additionalScrapeConfigs.external.name`.
- `prometheus.additionalScrapeConfigsExternal.key` -> deprecated in favor of `prometheus.additionalScrapeConfigs.external.key`.

Adapt you parameters accordingly if you are external scrape configs.

### To 3.1.0

Some parameters disappeared in favor of new ones:

- `*.podAffinity` -> deprecated in favor of `*.podAffinityPreset`.
- `*.podAntiAffinity` -> deprecated in favor of `*.podAntiAffinityPreset`.
- `*.nodeAffinity` -> deprecated in favor of `*.nodeAffinityPreset.type`, `*.nodeAffinityPreset.key` and `*.nodeAffinityPreset.values`.

Adapt parameters accordingly if you are setting custom affinity.

### To 3.0.0

[On November 13, 2020, Helm v2 support formally ended](https://github.com/helm/charts#status-of-the-project). This major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

[Learn more about this change and related upgrade considerations](https://docs.bitnami.com/kubernetes/apps/prometheus-operator/administration/upgrade-helm3/).

### To 2.1.0

> Note: ignore these instructions if you did not enabled the Thanos sidecar on Prometheus pods.

The Thanos sidecar svc is transformed into a headless service by default so Thanos can discover every available sidecar. You can undo this change by setting the `prometheus.thanos.service.clusterIP` parameter to an empty string `""`.

To upgrade from version 2.0.0, previously remove the Thanos sidecar svc to avoid issues with immutable fields:

```bash
$ kubectl delete svc my-relase-kube-prometheus-prometheus-thanos
$ helm upgrade my-release --set prometheus.thanos.create=true bitnami/kube-prometheus
```

### To 2.0.0

- CRDs were updated to the latest prometheus-operator v0.4.1 release artifacts
  - The apiVersion of CRDs was updated from `apiextensions.k8s.io/v1beta1` to `apiextensions.k8s.io/v1`
  - Kubernetes 1.16 is required

### To 1.0.0

- The chart was renamed to `kube-prometheus` to be more accurate with the actual capabilities of the chart: it does not just deploy the Prometheus operator, it deploys an entire cluster monitoring stack, that includes other components (e.g. NodeExporter or Kube State metrics). Find more information about the reasons behind this decision at [#3490](https://github.com/bitnami/charts/issues/3490).
- New CRDs were added and some existing ones were updated.
- This version also introduces `bitnami/common`, a [library chart](https://helm.sh/docs/topics/library_charts/#helm) as a dependency. More documentation about this new utility could be found [here](https://github.com/bitnami/charts/tree/master/bitnami/common#bitnami-common-library-chart). Please, make sure that you have updated the chart dependencies before executing any upgrade.

> Note: There is no backwards compatibility due to the above mentioned changes. It's necessary to install a new release of the chart, and migrate the existing TSDB data to the new Prometheus instances.

## License

Copyright &copy; 2022 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
