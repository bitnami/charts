# The Bitnami Library for Kubernetes

Popular applications, provided by [Bitnami](https://bitnami.com), ready to launch on Kubernetes using [Kubernetes Helm](https://github.com/helm/helm).

## TL;DR

```bash
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm search repo bitnami
$ helm install my-release bitnami/<chart>
```

![Installing a chart](demo.gif)

## Before you begin

### Prerequisites
- Kubernetes 1.12+
- Helm 3.1.0

### Setup a Kubernetes Cluster

The quickest way to setup a Kubernetes cluster to install Bitnami Charts is following the "Bitnami Get Started" guides for the different services:

- [Get Started with Bitnami Charts using VMware Tanzu Kubernetes Grid](https://docs.bitnami.com/kubernetes/get-started-tkg/)
- [Get Started with Bitnami Charts using VMware Tanzu Mission Control](https://docs.bitnami.com/tutorials/tanzu-mission-control-get-started/)
- [Get Started with Bitnami Charts using the Azure Kubernetes Service (AKS)](https://docs.bitnami.com/kubernetes/get-started-aks/)
- [Get Started with Bitnami Charts using the Amazon Elastic Container Service for Kubernetes (EKS)](https://docs.bitnami.com/kubernetes/get-started-eks/)
- [Get Started with Bitnami Charts using the Google Kubernetes Engine (GKE)](https://docs.bitnami.com/kubernetes/get-started-gke/)
- [Get Started with Bitnami Charts using the IBM Cloud Kubernetes Service (IKS)](https://docs.bitnami.com/kubernetes/get-started-charts-iks/)

For setting up Kubernetes on other cloud platforms or bare-metal servers refer to the Kubernetes [getting started guide](http://kubernetes.io/docs/getting-started-guides/).

### Install Helm

Helm is a tool for managing Kubernetes charts. Charts are packages of pre-configured Kubernetes resources.

To install Helm, refer to the [Helm install guide](https://github.com/helm/helm#install) and ensure that the `helm` binary is in the `PATH` of your shell.

### Add Repo

The following command allows you to download and install all the charts from this repository:

```bash
$ helm repo add bitnami https://charts.bitnami.com/bitnami
```

### Using Helm

Once you have installed the Helm client, you can deploy a Bitnami Helm Chart into a Kubernetes cluster.

Please refer to the [Quick Start guide](https://helm.sh/docs/intro/quickstart/) if you wish to get running in just a few commands, otherwise the [Using Helm Guide](https://helm.sh/docs/intro/using_helm/) provides detailed instructions on how to use the Helm client to manage packages on your Kubernetes cluster.

Useful Helm Client Commands:
* View available charts: `helm search repo`
* Install a chart: `helm install my-release bitnami/<package-name>`
* Upgrade your application: `helm upgrade`

# License

Copyright (c) 2015-2021 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
