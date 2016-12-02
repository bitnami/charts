# The Bitnami Library for Kubernetes

Popular applications, provided by [Bitnami](https://bitnami.com), ready to launch on Kubernetes using [Kubernetes Helm](https://github.com/kubernetes/helm).

- [WordPress (stable)](https://github.com/kubernetes/charts/tree/master/stable/wordpress)
- [Joomla! (stable)](https://github.com/kubernetes/charts/tree/master/stable/joomla)
- [Redmine (stable)](https://github.com/kubernetes/charts/tree/master/stable/redmine)
- [Drupal (stable)](https://github.com/kubernetes/charts/tree/master/stable/drupal)
- [OpenCart (incubator)](https://github.com/bitnami/charts/tree/master/incubator/opencart)
- [Magento (incubator)](https://github.com/bitnami/charts/tree/master/incubator/magento)
- [RabbitMQ (stable)](https://github.com/kubernetes/charts/tree/master/stable/rabbitmq)
- [OwnCloud (stable)](https://github.com/kubernetes/charts/tree/master/stable/owncloud)
- [Jenkins (incubator)](https://github.com/bitnami/charts/tree/master/incubator/jenkins)
- [Memcached (incubator)](https://github.com/bitnami/charts/tree/master/incubator/memcached)
- [Phabricator (incubator)](https://github.com/bitnami/charts/tree/master/incubator/phabricator)
- [PrestaShop (incubator)](https://github.com/bitnami/charts/tree/master/incubator/prestashop)
- [PostgreSQL (incubator)](https://github.com/bitnami/charts/tree/master/incubator/postgresql)
- [MediaWiki (stable)](https://github.com/kubernetes/charts/tree/master/stable/mediawiki)
- [MongoDB (stable)](https://github.com/kubernetes/charts/tree/master/stable/mongodb)
- [Redis (stable)](https://github.com/kubernetes/charts/tree/master/stable/redis)
- [Odoo (incubator)](https://github.com/bitnami/charts/tree/master/incubator/odoo)
- [Osclass (incubator)](https://github.com/bitnami/charts/tree/master/incubator/osclass)
- [OrangeHRM (incubator)](https://github.com/bitnami/charts/tree/master/incubator/orangehrm)
- [nginx (incubator)](https://github.com/bitnami/charts/tree/master/incubator/nginx)
- [TestLink (stable)](https://github.com/kubernetes/charts/tree/master/stable/testlink)
- [WildFly (incubator)](https://github.com/bitnami/charts/tree/master/incubator/wildfly)
- [phpBB (stable)](https://github.com/kubernetes/charts/tree/master/stable/phpbb)
- [Ghost (stable)](https://github.com/kubernetes/charts/tree/master/stable/ghost)
- [Tomcat (incubator)](https://github.com/bitnami/charts/tree/master/incubator/tomcat)
- [Apache (incubator)](https://github.com/bitnami/charts/tree/master/incubator/apache)
- [MariaDB (stable)](https://github.com/kubernetes/charts/tree/master/stable/mariadb)
- [MariaDB Cluster (incubator)](https://github.com/bitnami/charts/tree/master/incubator/mariadb-cluster)
- [SuiteCRM (incubator)](https://github.com/bitnami/charts/tree/master/incubator/suitecrm)

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

### Using Helm

Once you have installed the Helm client and initialized the Tiller server, you can deploy a Bitnami Helm Chart into a Kubernetes cluster.

> Run `helm init` to initialize the Tiller server.

Please refer to the [Quick Start guide](https://github.com/kubernetes/helm/blob/master/docs/quickstart.md) if you wish to get running in just a few commands, otherwise the [Using Helm Guide](https://github.com/kubernetes/helm/blob/master/docs/using_helm.md) provides detailed instructions on how to use the Helm client to manage packages on your Kubernetes cluster.

Useful Helm Client Commands:
* View available charts: `helm search`
* Install a chart: `helm install stable/<package-name>`
* Upgrade your application: `helm upgrade`
