# strongDM Client packaged by Bitnami

strongDM is tool that allows people first access.

[Overview of strongDM](https://strongdm.com)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install my-release bitnami/sdm-client
```

## Introduction

This repo provides an implementation of a strongDM Client Container inside Kubernetes using Helm.

[Learn more about deploying strongDM's cliet container inside Kubernetes on our docs site.](https://www.strongdm.com/docs/automation/containers/client-container)

## Prerequisites

* Kubernetes v1.16+

* Helm 3.0+

* If you are going to use [Nginx Ingress Controller](https://kubernetes.github.io/ingress-nginx/), then you will need to manually patch your [services to allow TCP and UDP traffic](https://kubernetes.github.io/ingress-nginx/user-guide/exposing-tcp-udp-services/)

* [A strongDM Service Token](https://www.strongdm.com/docs/admin-ui-guide/access/service-accounts)

## Installing the Chart

```console
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install [RELEASE_NAME] bitnami/sdm-client -f values.yaml
helm status [RELEASE_NAME]
```

_See [configuration](#configuration) below._

_See [helm install](https://helm.sh/docs/helm/helm_install/) for command documentation._

## Upgrading the Chart

```console
helm upgrade [RELEASE_NAME] bitnami/sdm-client --install
```

_See [helm upgrade](https://helm.sh/docs/helm/helm_upgrade/) for command documentation._

## Uninstalling the Chart

```console
helm uninstall [RELEASE_NAME]
```

The command removes all the Kubernetes components associated with the release and deletes the release.

_See [helm uninstall](https://helm.sh/docs/helm/helm_uninstall/) for command documentation._

## Parameters

The following table lists the configurable parameters of the strongDM relay/gateway chart and their default values.

| Parameter | Description | Default | Required |
| --- | --- | --- | --- |
| .global.service.type | The kind of service you'd like to run for the gateway. E.G. `ClusterIP` or `Loadbalancer` | `ClusterIP` | &#9744; |
| .global.secret.token | The `base64` encoded value of the relay or gateway token generated in the Admin UI. | None | &#9745; |
| .global.deployment.replicas | The number of container replicas you'd like to run for the deployment. | 1 | &#9744; |
| .global.deployment.repository | The image you'd like to use for the strongDM client. | quay.io/sdmrepo/client | &#9745; |
| .global.deployment.tag | The tag for the image you'd like to use for the strongDM client. | latest | &#9745; |
| .global.deployment.imagePullPolicy | The policy for pulling a new image from the repo. | Always | &#9745; |
| .global.deployment.ports | A list of ports you'd like to have the service listening on. The ports will coincide with the SDM port you are exposing from SDM. | None | &#9744; |
| .configmap.SDM_DOCKERIZED | Setting this will automatically send logs to STDOUT overriding settings in AdminUI. | true | &#9744; |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install [RELEASE_NAME] \
  --set global.secret.token=[base64 encoded token] \
  --set configmap.SDM_DOCKERIZED=true \
    bitnami/sdm-client
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install [RELEASE_NAME] bitnami/sdm-client -f values.yaml
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

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
