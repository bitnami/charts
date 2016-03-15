# Bitnami Charts Repository

This repository contains Charts for [Helm](http://helm.sh/) and use Docker containers developed and maintained by [Bitnami](https://bitnami.com/)

To learn more about Bitnami-provided Docker containers, please visit http://bitnami.com/docker.

## Before you begin

### Setup a Kubernetes Cluster

The quickest way to setup a Kubernetes cluster is with [Google Container Engine](https://cloud.google.com/container-engine/) (GKE) using [these instructions](https://cloud.google.com/container-engine/docs/before-you-begin).

Finish up by creating a cluster:

```bash
$ gcloud container clusters create my-cluster
```

The above command creates a new cluster named `my-cluster`. You can name the cluster according to your preferences.

> For setting up Kubernetes on other cloud platforms or bare-metal servers refer to the Kubernetes [getting started guide](http://kubernetes.io/docs/getting-started-guides/).

### Install Helm

Dubbed as the Kubernetes Package Manager, Helm bootstraps your Kubernetes cluster with Charts that provide ready-to-use workloads.

To install Helm, refer to the [Helm install guide](https://github.com/helm/helm#installing-helm) and ensure that the `helm` binary is in the `PATH` of your shell.

### Bitnami Charts Repo

To use the awesome Charts from this repo, you should add the repo to Helm using:

```bash
$ helm repo add bitnami https://github.com/bitnami/charts.git
```

Remember to periodically update your Charts to get the latest and greatest Helm Charts from Bitnami.

```bash
$ helm update
```

### Next Steps

 - [Deploy MariaDB](https://github.com/bitnami/charts/tree/master/mariadb)
 - [Deploy Redmine](https://github.com/bitnami/charts/tree/master/redmine)
