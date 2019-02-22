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

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install --name kubeapps --namespace kubeapps bitnami/kubeapps
```

## Introduction

This chart bootstraps a [Kubeapps](https://kubeapps.com) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages the [Bitnami MongoDB chart](https://github.com/helm/charts/tree/master/stable/mongodb) which is required for bootstrapping a MongoDB deployment for the database requirements of the Kubeapps application.

## Prerequisites

- Kubernetes 1.8+ (tested with Azure Kubernetes Service, Google Kubernetes Engine, minikube and Docker for Desktop Kubernetes)
- Helm 2.10.0+
- Administrative access to the cluster to create and update RBAC ClusterRoles

## Installing the Chart

To install the chart with the release name `kubeapps`:

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install --name kubeapps --namespace kubeapps bitnami/kubeapps
```

> **IMPORTANT** This assumes an insecure Helm installation, which is not recommended in production. See [the documentation to learn how to secure Helm and Kubeapps in production](https://github.com/kubeapps/kubeapps/blob/master/docs/user/securing-kubeapps.md).

The command deploys Kubeapps on the Kubernetes cluster in the `kubeapps` namespace. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Caveat**: Only one Kubeapps installation is supported per namespace

> **Tip**: List all releases using `helm list`

Once you have installed Kubeapps follow the [Getting Started Guide](https://github.com/kubeapps/kubeapps/blob/master/docs/user/getting-started.md) for additional information on how to access and use Kubeapps.

## Upgrading Kubeapps

You can upgrade Kubeapps from the Kubeapps web interface. Select the namespace in which Kubeapps is installed (`kubeapps` if you followed the instructions in this guide) and click on the "Upgrade" button. Select the new version and confirm.

> NOTE: If the chart values were modified when deploying Kubeapps the first time, those values need to be set again when upgrading.

You can also use the Helm CLI to upgrade Kubeapps, first ensure you have updated your local chart repository cache:

```console
$ helm repo update
```

Now upgrade Kubeapps:

```console
$ export RELEASE_NAME=kubeapps
$ helm upgrade $RELEASE_NAME bitnami/kubeapps
```

If you find issues upgrading Kubeapps, check the [troubleshooting](#error-while-upgrading-the-chart) section.

## Uninstalling Kubeapps

To uninstall/delete the `kubeapps` deployment:

```console
$ helm delete --purge kubeapps
$ # Optional: Only if there are no more instances of Kubeapps
$ kubectl delete crd apprepositories.kubeapps.com
```

The first command removes most of the Kubernetes components associated with the chart and deletes the release. After that, if there are no more instances of Kubeapps in the cluster you can manually delete the `apprepositories.kubeapps.com` CRD used by Kubeapps that is shared for the entire cluster.

> **NOTE**: If you delete the CRD for `apprepositories.kubeapps.com` it will delete the repositories for **all** the installed instances of `kubeapps`. This will break existing installations of `kubeapps` if they exist.

If you have dedicated a namespace only for Kubeapps you can completely clean remaining completed/failed jobs or any stale resources by deleting the namespace

```console
$ kubectl delete namespace kubeapps
```

## Configuration

For a full list of configuration parameters of the Kubeapps chart, see the [values.yaml](values.yaml) file.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name kubeapps --namespace kubeapps \
  --set chartsvc.service.port=9090 \
    bitnami/kubeapps
```

The above command sets the port for the chartsvc Service to 9090.

Alternatively, a YAML file that specifies the values for parameters can be provided while installing the chart. For example,

```console
$ helm install --name kubeapps --namespace kubeapps -f custom-values.yaml bitnami/kubeapps
```

### Configuring Initial Repositories

By default, Kubeapps will track the [community Helm charts](https://github.com/helm/charts) and the [Kubernetes Service Catalog charts](https://github.com/kubernetes-incubator/service-catalog). To change these defaults, override the `apprepository.initialRepos` object:

```console
$ cat > custom-values.yaml <<EOF
apprepository:
  initialRepos:
  - name: example
    url: https://charts.example.com
EOF
$ helm install --name kubeapps --namespace kubeapps bitnami/kubeapps -f custom-values.yaml
```

### Configuring connection to a custom namespace Tiller instance

By default, Kubeapps connects to the Tiller Service in the `kube-system` namespace, the default install location for Helm.

If your instance of Tiller is running in a different namespace or you want to have different instances of Kubeapps connected to different Tiller instances, you can achieve it by setting `tillerProxy.host`:

```console
helm install \
  --set tillerProxy.host=tiller-deploy.my-custom-namespace:44134 \
  bitnami/kubeapps
```

### Configuring connection to a secure Tiller instance

In production, we strongly recommend setting up a [secure installation of Tiller](https://docs.helm.sh/using_helm/#using-ssl-between-helm-and-tiller), the Helm server side component.

In this case, set the following values to configure TLS:

```console
helm install \
  --tls --tls-ca-cert ca.cert.pem --tls-cert helm.cert.pem --tls-key helm.key.pem \
  --set tillerProxy.tls.verify=true \
  --set tillerProxy.tls.ca="$(cat ca.cert.pem)" \
  --set tillerProxy.tls.key="$(cat helm.key.pem)" \
  --set tillerProxy.tls.cert="$(cat helm.cert.pem)" \
  bitnami/kubeapps
```

Learn more about how to secure your Kubeapps installation [here](https://github.com/kubeapps/kubeapps/blob/master/docs/user/securing-kubeapps.md).

### Exposing Externally

#### LoadBalancer Service

The simplest way to expose the Kubeapps Dashboard is to assign a LoadBalancer type to the Kubeapps frontend Service. For example:

```console
$ helm install --name kubeapps --namespace kubeapps bitnami/kubeapps --set frontend.service.type=LoadBalancer
```

Wait for your cluster to assign a LoadBalancer IP or Hostname to the `kubeapps` Service and access it on that address:

```console
$ kubectl get services --namespace kubeapps --watch
```

#### Ingress

This chart provides support for ingress resources. If you have an ingress controller installed on your cluster, such as [nginx-ingress](https://hub.kubeapps.com/charts/stable/nginx-ingress) or [traefik](https://hub.kubeapps.com/charts/stable/traefik) you can utilize the ingress controller to expose Kubeapps.

To enable ingress integration, please set `ingress.enabled` to `true`

##### Hosts

Most likely you will only want to have one hostname that maps to this Kubeapps installation, however, it is possible to have more than one host. To facilitate this, the `ingress.hosts` object is an array.

##### Annotations

For annotations, please see [this document](https://github.com/kubernetes/ingress-nginx/blob/master/docs/annotations.md). Not all annotations are supported by all ingress controllers, but this document does a good job of indicating which annotation is supported by many popular ingress controllers. Annotations can be set using `ingress.annotations`.

##### TLS

TLS can be configured using setting the `ingress.hosts[].tls` boolean of the corresponding hostname to true, then you can choose the TLS secret name setting `ingress.hosts[].tlsSecret`. Please see [this example](https://github.com/kubernetes/contrib/tree/master/ingress/controllers/nginx/examples/tls) for more information.

You can provide your own certificates using the `ingress.secrets` object. If your cluster has a [cert-manager](https://github.com/jetstack/cert-manager) add-on to automate the management and issuance of TLS certificates, set `ingress.hosts[].certManager` boolean to true to enable the corresponding annotations for cert-manager as shown in the example below:

```console
helm install --name kubeapps --namespace kubeapps bitnami/kubeapps \
  --set ingress.enabled=true \
  --set ingress.certManager=true \
  --set ingress.hosts[0].name=kubeapps.custom.domain \
  --set ingress.hosts[0].tls=true \
  --set ingress.hosts[0].tlsSecret=kubeapps-tls
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

This usually is an indication that Tiller was not installed with enough permissions to create the resources by Kubeapps. In order to install Kubeapps, you will need to install Tiller with elevated permissions (e.g. as a cluster-admin). For example:

```
kubectl -n kube-system create sa tiller
kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller
helm init --service-account tiller
```

It is also possible, though less common, that your cluster does not have Role Based Access Control (RBAC) enabled. To check if your cluster has RBAC you can execute:

```console
$ kubectl api-versions
```

If the above command does not include entries for `rbac.authorization.k8s.io` you should perform the chart installation by setting `rbac.create=false`:

```console
$ helm install --name kubeapps --namespace kubeapps bitnami/kubeapps --set rbac.create=false
```

### Error while upgrading the Chart

It is possible that when upgrading Kubeapps an error appears. That can be caused by a breaking change in the new chart or because the current chart installation is in an inconsistent state. If you find issues upgrading Kubeapps you can follow these steps:

> Note: This steps assume that you have installed Kubeapps in the namespace `kubeapps` using the name `kubeapps`. If that is not the case replace the command with your namespace and/or name.

1.  (Optional) Backup your personal repositories (if you have any):

```console
kubectl get apprepository --namespace kubeapps -o yaml <repo name> > <repo name>.yaml
```

2.  Delete Kubeapps:

```console
helm del --purge kubeapps
```

3.  (Optional) Delete the App Repositories CRD:

> **Warning**: Don't execute this step if you have more than one Kubeapps installation in your cluster.

```console
kubectl delete crd apprepositories.kubeapps.com
```

4.  (Optional) Clean the Kubeapps namespace:

> **Warning**: Don't execute this step if you have workloads other than Kubeapps in the `kubeapps` namespace.

```console
kubectl delete namespace kubeapps
```

5.  Install the latest version of Kubeapps (using any custom modifications you need):

```console
helm repo update
helm install --name kubeapps --namespace kubeapps bitnami/kubeapps
```

6.  (Optional) Restore any repositories you backed up in the first step:

```console
kubectl apply -f <repo name>.yaml
```

After that you should be able to access the new version of Kubeapps. If the above doesn't work for you or you run into any other issues please open an [issue](https://github.com/kubeapps/kubeapps/issues/new).
