[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/bitnami)](https://artifacthub.io/packages/search?repo=bitnami)
[![CD Pipeline](https://github.com/bitnami/charts/actions/workflows/cd-pipeline.yml/badge.svg)](https://github.com/bitnami/charts/actions/workflows/cd-pipeline.yml)

# The Bitnami Library for Kubernetes

Popular applications, provided by [Bitnami](https://bitnami.com), ready to launch on Kubernetes using [Kubernetes Helm](https://github.com/helm/helm).

## TL;DR

```bash
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm search repo bitnami
$ helm install my-release bitnami/<chart>
```

![Installing a chart](demo.gif)

## Vulnerabilities scanner

Each Helm chart contains one or more containers. Those containers use images provided by Bitnami through its test & release pipeline and whose source code can be found at [bitnami/containers](https://github.com/bitnami/containers).

As part of the container releases, the images are scanned for vulnerabilities, [here](https://github.com/bitnami/containers#vulnerability-scan-in-bitnami-container-images) you can find more info about this topic.

Since the container image is an immutable artifact that is already analyzed, as part of the Helm chart release process we are not looking for vulnerabilities in the containers but running different verification to ensure the Helm charts work as expected, see the testing strategy defined at [_TESTING.md_](https://github.com/bitnami/charts/blob/master/TESTING.md).

## Before you begin

### Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+

### Setup a Kubernetes Cluster

The quickest way to setup a Kubernetes cluster to install Bitnami Charts is following the "Bitnami Get Started" guides for the different services:

- [Get Started with Bitnami Charts using VMware Tanzu Kubernetes Grid](https://docs.bitnami.com/kubernetes/get-started-tkg/)
- [Get Started with Bitnami Charts using VMware Tanzu Mission Control](https://docs.bitnami.com/tutorials/tanzu-mission-control-get-started/)
- [Get Started with Bitnami Charts using the Azure Kubernetes Service (AKS)](https://docs.bitnami.com/kubernetes/get-started-aks/)
- [Get Started with Bitnami Charts using the Amazon Elastic Container Service for Kubernetes (EKS)](https://docs.bitnami.com/kubernetes/get-started-eks/)
- [Get Started with Bitnami Charts using the Google Kubernetes Engine (GKE)](https://docs.bitnami.com/kubernetes/get-started-gke/)
- [Get Started with Bitnami Charts using the IBM Cloud Kubernetes Service (IKS)](https://docs.bitnami.com/kubernetes/get-started-charts-iks/)

For setting up Kubernetes on other cloud platforms or bare-metal servers refer to the Kubernetes [getting started guide](https://kubernetes.io/docs/getting-started-guides/).

### Install Helm

Helm is a tool for managing Kubernetes charts. Charts are packages of pre-configured Kubernetes resources.

To install Helm, refer to the [Helm install guide](https://github.com/helm/helm#install) and ensure that the `helm` binary is in the `PATH` of your shell.

### Add Repo

The following command allows you to download and install all the charts from this repository:

```bash
$ helm repo add bitnami https://charts.bitnami.com/bitnami
```

> **_NOTE:_** It is important to note that the above mentioned repo is truncated so it only contains entries for the releases produced in the last 6 months. In case you need a full index, you can use it from the [archive-full-index branch](https://raw.githubusercontent.com/bitnami/charts/archive-full-index/bitnami/index.yaml) in the bitnami/charts Github repository.
>
> This full index is updated every time the [truncated index file](https://raw.githubusercontent.com/bitnami/charts/index/bitnami/index.yaml) is updated. Take into account that this full index is under the [Github's rate limits](https://docs.github.com/en/developers/apps/building-github-apps/rate-limits-for-github-apps).
>
> You can find more information in the [Bitnami index FAQ](https://github.com/bitnami/charts/issues/10833) pinned issue.

### Using Helm

Once you have installed the Helm client, you can deploy a Bitnami Helm Chart into a Kubernetes cluster.

Please refer to the [Quick Start guide](https://helm.sh/docs/intro/quickstart/) if you wish to get running in just a few commands, otherwise the [Using Helm Guide](https://helm.sh/docs/intro/using_helm/) provides detailed instructions on how to use the Helm client to manage packages on your Kubernetes cluster.

Useful Helm Client Commands:
* View available charts: `helm search repo`
* Install a chart: `helm install my-release bitnami/<package-name>`
* Upgrade your application: `helm upgrade`

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
