# Bitnami Charts Repository

This repository contains Charts for [Helm](https://github.com/kubernetes/helm) that use Docker containers developed and maintained by [Bitnami](https://bitnami.com/)

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

Helm is a tool for managing Kubernetes charts. Charts are packages of pre-configured Kubernetes resources.

To install Helm, refer to the [Helm install guide](https://github.com/kubernetes/helm#install) and ensure that the `helm` binary is in the `PATH` of your shell.

