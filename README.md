<!-- markdownlint-disable-next-line -->
[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/bitnami)](https://artifacthub.io/packages/search?repo=bitnami) [![CD Pipeline](https://github.com/bitnami/charts/actions/workflows/cd-pipeline.yml/badge.svg)](https://github.com/bitnami/charts/actions/workflows/cd-pipeline.yml)

# The Bitnami Library for Kubernetes

Popular applications, provided by [Bitnami](https://bitnami.com), ready to launch on Kubernetes using [Kubernetes Helm](https://github.com/helm/helm).

Looking to use our applications in production? Try [VMware Application Catalog](https://bitnami.com/enterprise), the enterprise edition of Bitnami Application Catalog.

## TL;DR

```bash
helm install my-release oci://registry-1.docker.io/bitnamicharts/<chart>
```

## Vulnerabilities scanner

Each Helm chart contains one or more containers. Those containers use images provided by Bitnami through its test & release pipeline and whose source code can be found at [bitnami/containers](https://github.com/bitnami/containers).

As part of the container releases, the images are scanned for vulnerabilities, [here](https://github.com/bitnami/containers#vulnerability-scan-in-bitnami-container-images) you can find more info about this topic.

Since the container image is an immutable artifact that is already analyzed, as part of the Helm chart release process we are not looking for vulnerabilities in the containers but running different verification to ensure the Helm charts work as expected, see the testing strategy defined at [_TESTING.md_](https://github.com/bitnami/charts/blob/main/TESTING.md).

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

For setting up Kubernetes on other cloud platforms or bare-metal servers refer to the Kubernetes [getting started guide](https://kubernetes.io/docs/getting-started-guides/).

### Install Helm

Helm is a tool for managing Kubernetes charts. Charts are packages of pre-configured Kubernetes resources.

To install Helm, refer to the [Helm install guide](https://github.com/helm/helm#install) and ensure that the `helm` binary is in the `PATH` of your shell.

### Using Helm

Once you have installed the Helm client, you can deploy a Bitnami Helm Chart into a Kubernetes cluster.

Please refer to the [Quick Start guide](https://helm.sh/docs/intro/quickstart/) if you wish to get running in just a few commands, otherwise the [Using Helm Guide](https://helm.sh/docs/intro/using_helm/) provides detailed instructions on how to use the Helm client to manage packages on your Kubernetes cluster.

Useful Helm Client Commands:

- Install a chart: `helm install my-release oci://registry-1.docker.io/bitnamicharts/<chart>`
- Upgrade your application: `helm upgrade my-release oci://registry-1.docker.io/bitnamicharts/<chart>`

## License

Copyright &copy; 2023 VMware, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

<http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
