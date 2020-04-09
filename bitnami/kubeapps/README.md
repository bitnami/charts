# Kubeapps

[![CircleCI](https://circleci.com/gh/kubeapps/kubeapps/tree/master.svg?style=svg)](https://circleci.com/gh/kubeapps/kubeapps/tree/master)

[Kubeapps](https://kubeapps.com) is a web-based UI for deploying and managing applications in Kubernetes clusters. Kubeapps allows you to:

- Browse and deploy [Helm](https://github.com/helm/helm) charts from chart repositories
- Inspect, upgrade and delete Helm-based applications installed in the cluster
- Add custom and private chart repositories (supports [ChartMuseum](https://github.com/helm/chartmuseum) and [JFrog Artifactory](https://www.jfrog.com/confluence/display/RTF/Helm+Chart+Repositories))
- Browse and provision external services from the [Service Catalog](https://github.com/kubernetes-incubator/service-catalog) and available Service Brokers
- Connect Helm-based applications to external services with Service Catalog Bindings
- Secure authentication and authorization based on Kubernetes [Role-Based Access Control](https://github.com/kubeapps/kubeapps/blob/master/docs/user/access-control.md)

## TL;DR;

For Helm 2:

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install --name kubeapps --namespace kubeapps bitnami/kubeapps
```

For Helm 3:

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
kubectl create namespace kubeapps
helm install kubeapps --namespace kubeapps bitnami/kubeapps --set useHelm3=true
```

## Introduction

This chart bootstraps a [Kubeapps](https://kubeapps.com) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages the [Bitnami MongoDB chart](https://github.com/bitnami/charts/tree/master/bitnami/mongodb) or the [Bitnami PostgreSQL chart](https://github.com/bitnami/charts/tree/master/bitnami/postgresql) which is required for bootstrapping a deployment for the database requirements of the Kubeapps application.

## Prerequisites

- Kubernetes 1.8+ (tested with Azure Kubernetes Service, Google Kubernetes Engine, minikube and Docker for Desktop Kubernetes)
- Helm 2.14.0+
- Administrative access to the cluster to create Custom Resource Definitions (CRDs)

## Installing the Chart

To install the chart with the release name `kubeapps`:

For Helm 2:

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install --name kubeapps --namespace kubeapps bitnami/kubeapps
```

> **IMPORTANT** This assumes an insecure Helm 2 installation, which is not recommended in production. See [the documentation to learn how to secure Helm 2 and Kubeapps in production](https://github.com/kubeapps/kubeapps/blob/master/docs/user/securing-kubeapps.md).

For Helm 3:

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
kubectl create namespace kubeapps
helm install kubeapps --namespace kubeapps bitnami/kubeapps --set useHelm3=true
```

The command deploys Kubeapps on the Kubernetes cluster in the `kubeapps` namespace. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Caveat**: Only one Kubeapps installation is supported per namespace

Once you have installed Kubeapps follow the [Getting Started Guide](https://github.com/kubeapps/kubeapps/blob/master/docs/user/getting-started.md) for additional information on how to access and use Kubeapps.

## Parameters

For a full list of configuration parameters of the Kubeapps chart, see the [values.yaml](values.yaml) file.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
helm install kubeapps --namespace kubeapps \
  --set assetsvc.service.port=9090 \
    bitnami/kubeapps
```

The above command sets the port for the assetsvc Service to 9090.

Alternatively, a YAML file that specifies the values for parameters can be provided while installing the chart. For example,

```bash
helm install kubeapps --namespace kubeapps -f custom-values.yaml bitnami/kubeapps
```

## Configuration and installation details

### Configuring Initial Repositories

By default, Kubeapps will track the [community Helm charts](https://github.com/helm/charts) and the [Kubernetes Service Catalog charts](https://github.com/kubernetes-incubator/service-catalog). To change these defaults, override with your desired parameters the `apprepository.initialRepos` object present in the [values.yaml](values.yaml) file.

### Configuring the database to use

Kubeapps supports two database types: MongoDB or PostgreSQL. By default MongoDB is installed. If you want to enable PostgreSQL instead set the following values when installing the application: `mongodb.enabled=false` and `postresql.enabled=true`.

> **Note**: Changing the database type when upgrading is not supported.

### Enabling Operators

Since v1.9.0, Kubeapps supports to deploy and manage Operators within its dashboard. To enable this feature, set the flag `featureFlags.operators=true`. More information about how to enable and use this feature can be found in [this guide](https://github.com/kubeapps/kubeapps/blob/master/docs/user/operators.md).

### [Only for Helm 2] Configuring connection to a custom namespace Tiller instance

By default, Kubeapps connects to the Tiller Service in the `kube-system` namespace, the default install location for Helm.

If your instance of Tiller is running in a different namespace or you want to have different instances of Kubeapps connected to different Tiller instances, you can achieve it by setting the `tillerProxy.host` parameter. For example, you can set `tillerProxy.host=tiller-deploy.my-custom-namespace:44134`

### [Only for Helm 2] Configuring connection to a secure Tiller instance

In production, we strongly recommend setting up a [secure installation of Tiller](https://docs.helm.sh/using_helm/#using-ssl-between-helm-and-tiller), the Helm server side component.

Learn more about how to secure your Kubeapps installation [here](https://github.com/kubeapps/kubeapps/blob/master/docs/user/securing-kubeapps.md).

### Exposing Externally

> **Note**: The Kubeapps frontend sets up a proxy to the Kubernetes API service, so when when exposing the Kubeapps service to a network external to the Kubernetes cluster (perhaps on an internal or public network), the Kubernetes API will also be exposed on that network. See [#1111](https://github.com/kubeapps/kubeapps/issues/1111) for more details.

#### LoadBalancer Service

The simplest way to expose the Kubeapps Dashboard is to assign a LoadBalancer type to the Kubeapps frontend Service. For example, you can use the following parameter: `frontend.service.type=LoadBalancer`

Wait for your cluster to assign a LoadBalancer IP or Hostname to the `kubeapps` Service and access it on that address:

```bash
kubectl get services --namespace kubeapps --watch
```

#### Ingress

This chart provides support for ingress resources. If you have an ingress controller installed on your cluster, such as [nginx-ingress](https://hub.kubeapps.com/charts/stable/nginx-ingress) or [traefik](https://hub.kubeapps.com/charts/stable/traefik) you can utilize the ingress controller to expose Kubeapps.

To enable ingress integration, please set `ingress.enabled` to `true`

##### Hosts

Most likely you will only want to have one hostname that maps to this Kubeapps installation (use the `ingress.hostname` parameter to set the hostname), however, it is possible to have more than one host. To facilitate this, the `ingress.extraHosts` object is an array.

##### Annotations

For annotations, please see [this document](https://github.com/kubernetes/ingress-nginx/blob/master/docs/user-guide/nginx-configuration/annotations.md). Not all annotations are supported by all ingress controllers, but this document does a good job of indicating which annotation is supported by many popular ingress controllers. Annotations can be set using `ingress.annotations`.

##### TLS

To enable TLS, please set `ingress.tls` to `true`. When enabling this parameter, the TLS certificates will be retrieved from a TLS secret with name *INGRESS_HOSTNAME-tls* (where *INGRESS_HOSTNAME* is a placeholder to be replaced with the hostname you set using the `ingress.hostname` parameter).

You can use the `ingress.extraTls` to provide the TLS configuration for the extra hosts you set using the `ingress.extraHosts` array. Please see [this example](https://kubernetes.github.io/ingress-nginx/examples/tls-termination/) for more information.

You can provide your own certificates using the `ingress.secrets` object. If your cluster has a [cert-manager](https://github.com/jetstack/cert-manager) add-on to automate the management and issuance of TLS certificates, set `ingress.certManager` boolean to true to enable the corresponding annotations for cert-manager. For a full list of configuration parameters related to configuring TLS can see the [values.yaml](values.yaml) file.

## Upgrading Kubeapps

You can upgrade Kubeapps from the Kubeapps web interface. Select the namespace in which Kubeapps is installed (`kubeapps` if you followed the instructions in this guide) and click on the "Upgrade" button. Select the new version and confirm.

You can also use the Helm CLI to upgrade Kubeapps, first ensure you have updated your local chart repository cache:

```bash
helm repo update
```

Now upgrade Kubeapps:

```bash
export RELEASE_NAME=kubeapps
helm upgrade $RELEASE_NAME bitnami/kubeapps
```

If you find issues upgrading Kubeapps, check the [troubleshooting](#error-while-upgrading-the-chart) section.

## Uninstalling the Chart

To uninstall/delete the `kubeapps` deployment:

```bash
# For Helm 2
helm delete --purge kubeapps

# For Helm 3
helm uninstall kubeapps

# Optional: Only if there are no more instances of Kubeapps
kubectl delete crd apprepositories.kubeapps.com
```

The first command removes most of the Kubernetes components associated with the chart and deletes the release. After that, if there are no more instances of Kubeapps in the cluster you can manually delete the `apprepositories.kubeapps.com` CRD used by Kubeapps that is shared for the entire cluster.

> **NOTE**: If you delete the CRD for `apprepositories.kubeapps.com` it will delete the repositories for **all** the installed instances of `kubeapps`. This will break existing installations of `kubeapps` if they exist.

If you have dedicated a namespace only for Kubeapps you can completely clean remaining completed/failed jobs or any stale resources by deleting the namespace

```bash
kubectl delete namespace kubeapps
```

## Troubleshooting

### Forbidden error while installing the Chart

If during installation you run into an error similar to:

```
Error: release kubeapps failed: clusterroles.rbac.authorization.k8s.io "kubeapps-apprepository-controller" is forbidden: attempt to grant extra privileges: [{[get] [batch] [cronjobs] [] []...
```

Or:

```
Error: namespaces "kubeapps" is forbidden: User "system:serviceaccount:kube-system:default" cannot get namespaces in the namespace "kubeapps"
```

This usually is an indication that Tiller was not installed with enough permissions to create the resources required by Kubeapps. In order to install Kubeapps, tiller will need to be able to install Custom Resource Definitions cluster-wide, as well as manage app repositories in your kubeapps namespace. The easiest way to enable this in a development environment is install Tiller with elevated permissions (e.g. as a cluster-admin). For example:

```bash
kubectl -n kube-system create sa tiller
kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller
helm init --service-account tiller
```

but for a production environment you can assign the specific permissions so that tiller can [manage CRDs on the cluster](https://github.com/kubeapps/kubeapps/blob/master/docs/user/manifests/openshift-tiller-with-crd-rbac.yaml) as well as [create app repositories in your Kubeapps namespace](https://github.com/kubeapps/kubeapps/blob/master/docs/user/manifests/openshift-tiller-with-apprepository-rbac.yaml) (examples are from our in development support for OpenShift).

It is also possible, though less common, that your cluster does not have Role Based Access Control (RBAC) enabled. To check if your cluster has RBAC you can execute:

```bash
kubectl api-versions
```

If the above command does not include entries for `rbac.authorization.k8s.io` you should perform the chart installation by setting `rbac.create=false`:

```bash
helm install --name kubeapps --namespace kubeapps bitnami/kubeapps --set rbac.create=false
```

### Error while upgrading the Chart

It is possible that when upgrading Kubeapps an error appears. That can be caused by a breaking change in the new chart or because the current chart installation is in an inconsistent state. If you find issues upgrading Kubeapps you can follow these steps:

> Note: This steps assume that you have installed Kubeapps in the namespace `kubeapps` using the name `kubeapps`. If that is not the case replace the command with your namespace and/or name.

1.  (Optional) Backup your personal repositories (if you have any):

```bash
kubectl get apprepository --namespace kubeapps -o yaml <repo name> > <repo name>.yaml
```

2.  Delete Kubeapps:

```bash
helm del --purge kubeapps
```

3.  (Optional) Delete the App Repositories CRD:

> **Warning**: Don't execute this step if you have more than one Kubeapps installation in your cluster.

```bash
kubectl delete crd apprepositories.kubeapps.com
```

4.  (Optional) Clean the Kubeapps namespace:

> **Warning**: Don't execute this step if you have workloads other than Kubeapps in the `kubeapps` namespace.

```bash
kubectl delete namespace kubeapps
```

5.  Install the latest version of Kubeapps (using any custom modifications you need):

```bash
helm repo update
helm install --name kubeapps --namespace kubeapps bitnami/kubeapps
```

6.  (Optional) Restore any repositories you backed up in the first step:

```bash
kubectl apply -f <repo name>.yaml
```

After that you should be able to access the new version of Kubeapps. If the above doesn't work for you or you run into any other issues please open an [issue](https://github.com/kubeapps/kubeapps/issues/new).
