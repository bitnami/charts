# The Bitnami Library for Kubernetes

Popular applications, provided by [Bitnami](https://bitnami.com), ready to launch on Kubernetes using [Kubernetes Helm](https://github.com/kubernetes/helm).

- [Apache (incubator)](https://github.com/bitnami/charts/tree/master/incubator/apache)
- [Dokuwiki (incubator)](https://github.com/kubernetes/charts/tree/master/stable/dokuwiki)
- [Drupal (stable)](https://github.com/kubernetes/charts/tree/master/stable/drupal)
- [Ghost (stable)](https://github.com/kubernetes/charts/tree/master/stable/ghost)
- [JasperReports Server (incubator)](https://github.com/kubernetes/charts/tree/master/stable/jasperreports)
- [Jenkins (incubator)](https://github.com/bitnami/charts/tree/master/incubator/jenkins)
- [Joomla! (stable)](https://github.com/kubernetes/charts/tree/master/stable/joomla)
- [Magento (stable)](https://github.com/kubernetes/charts/tree/master/stable/magento)
- [MariaDB (stable)](https://github.com/kubernetes/charts/tree/master/stable/mariadb)
- [MariaDB Cluster (incubator)](https://github.com/bitnami/charts/tree/master/incubator/mariadb-cluster)
- [MediaWiki (stable)](https://github.com/kubernetes/charts/tree/master/stable/mediawiki)
- [Memcached (incubator)](https://github.com/bitnami/charts/tree/master/incubator/memcached)
- [MongoDB (stable)](https://github.com/kubernetes/charts/tree/master/stable/mongodb)
- [Moodle (stable)](https://github.com/kubernetes/charts/tree/master/stable/moodle)
- [MySQL (incubator)](https://github.com/bitnami/charts/tree/master/incubator/mysql)
- [nginx (incubator)](https://github.com/bitnami/charts/tree/master/incubator/nginx)
- [NodeJS (incubator)](https://github.com/bitnami/charts/tree/master/incubator/node)
- [Odoo (stable)](https://github.com/kubernetes/charts/tree/master/stable/odoo)
- [OpenCart (stable)](https://github.com/kubernetes/charts/tree/master/stable/opencart)
- [OrangeHRM (stable)](https://github.com/kubernetes/charts/tree/master/stable/orangehrm)
- [Osclass (stable)](https://github.com/kubernetes/charts/tree/master/stable/osclass)
- [OwnCloud (stable)](https://github.com/kubernetes/charts/tree/master/stable/owncloud)
- [Parse (incubator)](https://github.com/bitnami/charts/tree/master/incubator/parse)
- [Phabricator (stable)](https://github.com/kubernetes/charts/tree/master/stable/phabricator)
- [phpBB (stable)](https://github.com/kubernetes/charts/tree/master/stable/phpbb)
- [PostgreSQL (incubator)](https://github.com/bitnami/charts/tree/master/incubator/postgresql)
- [PrestaShop (stable)](https://github.com/kubernetes/charts/tree/master/stable/prestashop)
- [RabbitMQ (stable)](https://github.com/kubernetes/charts/tree/master/stable/rabbitmq)
- [Redis (stable)](https://github.com/kubernetes/charts/tree/master/stable/redis)
- [Redmine (stable)](https://github.com/kubernetes/charts/tree/master/stable/redmine)
- [SugarCRM (incubator)](https://github.com/bitnami/charts/tree/master/incubator/sugarcrm)
- [SuiteCRM (incubator)](https://github.com/bitnami/charts/tree/master/incubator/suitecrm)
- [TestLink (stable)](https://github.com/kubernetes/charts/tree/master/stable/testlink)
- [Tomcat (incubator)](https://github.com/bitnami/charts/tree/master/incubator/tomcat)
- [WildFly (incubator)](https://github.com/bitnami/charts/tree/master/incubator/wildfly)
- [WordPress (stable)](https://github.com/kubernetes/charts/tree/master/stable/wordpress)

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
