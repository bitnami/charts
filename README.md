<!-- markdownlint-disable MD001 MD041 -->
<p align="center">
    <img width="400px" height=auto src="https://bitnami.com/downloads/logos/bitnami-by-vmware.png" />
</p>

<p align="center">
    <a href="https://twitter.com/bitnami"><img src="https://badgen.net/badge/twitter/@bitnami/1DA1F2?icon&label" /></a>
    <a href="https://github.com/bitnami/charts"><img src="https://badgen.net/github/stars/bitnami/charts?icon=github" /></a>
    <a href="https://github.com/bitnami/charts"><img src="https://badgen.net/github/forks/bitnami/charts?icon=github" /></a>
    <a href="https://artifacthub.io/packages/search?repo=bitnami"><img src="https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/bitnami" /></a>
    <a href="https://github.com/bitnami/charts/actions/workflows/cd-pipeline.yml"><img src="https://github.com/bitnami/charts/actions/workflows/cd-pipeline.yml/badge.svg" /></a>
</p>

# The Bitnami Library for Kubernetes

Popular applications, provided by [Bitnami](https://bitnami.com), ready to launch on Kubernetes using [Kubernetes Helm](https://github.com/helm/helm).

Looking to use our applications in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the enterprise edition of Bitnami Application Catalog.

## TL;DR

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/<chart>
```

## Vulnerabilities scanner

Each Helm chart contains one or more containers. Those containers use images provided by Bitnami through its test & release pipeline and whose source code can be found at [bitnami/containers](https://github.com/bitnami/containers).

As part of the container releases, the images are scanned for vulnerabilities, [here](https://github.com/bitnami/containers#vulnerability-scan-in-bitnami-container-images) you can find more info about this topic.

Since the container image is an immutable artifact that is already analyzed, as part of the Helm chart release process we are not looking for vulnerabilities in the containers but running different verifications to ensure the Helm charts work as expected, see the testing strategy defined at [_TESTING.md_](https://github.com/bitnami/charts/blob/main/TESTING.md).

## Before you begin

### Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+

### Setup a Kubernetes Cluster

The quickest way to set up a Kubernetes cluster to install Bitnami Charts is by following the "Bitnami Get Started" guides for the different services:

- [Get Started with Bitnami Charts using VMware Tanzu Kubernetes Grid (TKG)](https://docs.bitnami.com/kubernetes/get-started-tkg/)
- [Get Started with Bitnami Charts using VMware Tanzu Mission Control (TMC)](https://docs.bitnami.com/kubernetes/get-started-tmc/)
- [Get Started With Bitnami Charts Using Azure Marketplace Kubernetes Applications](https://docs.bitnami.com/kubernetes/get-started-cnab/)
- [Get Started with Bitnami Charts using the Amazon Elastic Container Service for Kubernetes (EKS)](https://docs.bitnami.com/kubernetes/get-started-eks/)
- [Get Started with Bitnami Charts using the Google Kubernetes Engine (GKE)](https://docs.bitnami.com/kubernetes/get-started-gke/)

For setting up Kubernetes on other cloud platforms or bare-metal servers refer to the Kubernetes [getting started guide](https://kubernetes.io/docs/getting-started-guides/).

### Install Helm

Helm is a tool for managing Kubernetes charts. Charts are packages of pre-configured Kubernetes resources.

To install Helm, refer to the [Helm install guide](https://github.com/helm/helm#install) and ensure that the `helm` binary is in the `PATH` of your shell.

### Using Helm

Once you have installed the Helm client, you can deploy a Bitnami Helm Chart into a Kubernetes cluster.

Please refer to the [Quick Start guide](https://helm.sh/docs/intro/quickstart/) if you wish to get running in just a few commands, otherwise, the [Using Helm Guide](https://helm.sh/docs/intro/using_helm/) provides detailed instructions on how to use the Helm client to manage packages on your Kubernetes cluster.

Useful Helm Client Commands:

- Install a chart: `helm install my-release oci://registry-1.docker.io/bitnamicharts/<chart>`
- Upgrade your application: `helm upgrade my-release oci://registry-1.docker.io/bitnamicharts/<chart>`

## Creating a new chart

To make a chart that follows the same structure/patterns that the rest of the Bitnami charts, the basic scaffolding is provided in the [`template` directory](https://github.com/bitnami/charts/tree/main/template).
To make a new chart from the template, first run:

```console
make new_chart
```

This will create a copy in `/draft/<chart-name>` and a `/draft/<chart-name>/placeholder.yaml` file. Populate the `/draft/<chart-name>/placeholder.yaml` file with values for your chart, then run:

```console
make render_template
```

This will replace all the placeholders throughout the chart with your values. You will still likely need to modify the chart further to meet your needs.

The new chart can then be moved from `/draft/<chart-name>` to your own repo/location. If you wish to add the chart to this Bitnami repository, then refer to [Adding a new chart to the repository](./CONTRIBUTING.md#adding-a-new-chart-to-the-repository)

A chart in the `draft` directory can be recreated from the template by running:

```console
make recreate_chart
```

This will overwrite all existing files in the draft chart, except for the `/draft/<chart-name>/placeholder.yaml` file, which will be preserved.

## License

Copyright &copy; 2024 Broadcom. The term "Broadcom" refers to Broadcom Inc. and/or its subsidiaries.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

<http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
