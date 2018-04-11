# The Bitnami Library for Kubernetes

Popular applications, provided by [Bitnami](https://bitnami.com), ready to launch on Kubernetes using [Kubernetes Helm](https://github.com/kubernetes/helm).

## TL;DR

```bash
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm search bitnami
```

## Upstreamed charts (contributed to [kubernetes/charts](https://github.com/kubernetes/charts))

- [Dokuwiki](https://github.com/kubernetes/charts/tree/master/stable/dokuwiki)
- [Drupal](https://github.com/kubernetes/charts/tree/master/stable/drupal)
- [Ghost](https://github.com/kubernetes/charts/tree/master/stable/ghost)
- [JasperReports](https://github.com/kubernetes/charts/tree/master/stable/jasperreports)
- [Joomla!](https://github.com/kubernetes/charts/tree/master/stable/joomla)
- [Magento](https://github.com/kubernetes/charts/tree/master/stable/magento)
- [MariaDB](https://github.com/kubernetes/charts/tree/master/stable/mariadb)
- [MediaWiki](https://github.com/kubernetes/charts/tree/master/stable/mediawiki)
- [MongoDB](https://github.com/kubernetes/charts/tree/master/stable/mongodb)
- [Moodle](https://github.com/kubernetes/charts/tree/master/stable/moodle)
- [Odoo](https://github.com/kubernetes/charts/tree/master/stable/odoo)
- [OpenCart](https://github.com/kubernetes/charts/tree/master/stable/opencart)
- [OrangeHRM](https://github.com/kubernetes/charts/tree/master/stable/orangehrm)
- [Osclass](https://github.com/kubernetes/charts/tree/master/stable/osclass)
- [OwnCloud](https://github.com/kubernetes/charts/tree/master/stable/owncloud)
- [Parse](https://github.com/kubernetes/charts/tree/master/stable/parse)
- [Phabricator](https://github.com/kubernetes/charts/tree/master/stable/phabricator)
- [phpBB](https://github.com/kubernetes/charts/tree/master/stable/phpbb)
- [PrestaShop](https://github.com/kubernetes/charts/tree/master/stable/prestashop)
- [RabbitMQ](https://github.com/kubernetes/charts/tree/master/stable/rabbitmq)
- [Redis](https://github.com/kubernetes/charts/tree/master/stable/redis)
- [Redmine](https://github.com/kubernetes/charts/tree/master/stable/redmine)
- [SugarCRM](https://github.com/kubernetes/charts/tree/master/stable/sugarcrm)
- [SuiteCRM](https://github.com/kubernetes/charts/tree/master/stable/suitecrm)
- [TestLink](https://github.com/kubernetes/charts/tree/master/stable/testlink)
- [WordPress](https://github.com/kubernetes/charts/tree/master/stable/wordpress)

## Bitnami charts

- [Apache](https://github.com/bitnami/charts/tree/master/incubator/apache)
- [Elasticsearch](https://github.com/bitnami/charts/tree/master/incubator/elasticsearch)
- [Jenkins](https://github.com/bitnami/charts/tree/master/incubator/jenkins)
- [MariaDB Cluster](https://github.com/bitnami/charts/tree/master/incubator/mariadb-cluster)
- [Mean](https://github.com/bitnami/charts/tree/master/incubator/mean)
- [Memcached](https://github.com/bitnami/charts/tree/master/incubator/memcached)
- [MySQL](https://github.com/bitnami/charts/tree/master/incubator/mysql)
- [nginx](https://github.com/bitnami/charts/tree/master/incubator/nginx)
- [NodeJS](https://github.com/bitnami/charts/tree/master/incubator/node)
- [PostgreSQL](https://github.com/bitnami/charts/tree/master/incubator/postgresql)
- [TensorFlow Inception](https://github.com/bitnami/charts/tree/master/incubator/tensorflow-inception)
- [Tomcat](https://github.com/bitnami/charts/tree/master/incubator/tomcat)
- [WildFly](https://github.com/bitnami/charts/tree/master/incubator/wildfly)

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

### Add Repo

The stable charts are contributed to the upstream [kubernetes/charts](https://github.com/kubernetes/charts) repository. The following command allows you to download and install all the charts from this repository, the bitnami and the upstreamed ones.

```bash
$ helm repo add bitnami https://charts.bitnami.com/bitnami
```

### Using Helm

Once you have installed the Helm client and initialized the Tiller server, you can deploy a Bitnami Helm Chart into a Kubernetes cluster.

Please refer to the [Quick Start guide](https://github.com/kubernetes/helm/blob/master/docs/quickstart.md) if you wish to get running in just a few commands, otherwise the [Using Helm Guide](https://github.com/kubernetes/helm/blob/master/docs/using_helm.md) provides detailed instructions on how to use the Helm client to manage packages on your Kubernetes cluster.

Useful Helm Client Commands:
* View available charts: `helm search`
* Install a chart: `helm install stable/<package-name>`
* Upgrade your application: `helm upgrade`
