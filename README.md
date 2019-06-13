# The Bitnami Library for Kubernetes

Popular applications, provided by [Bitnami](https://bitnami.com), ready to launch on Kubernetes using [Kubernetes Helm](https://github.com/helm/helm).

## TL;DR

```bash
$ helm repo add bitnami https://charts.bitnami.com
$ helm search bitnami
```

## Upstreamed charts (contributed to [helm/charts](https://github.com/helm/charts))

- [Dokuwiki](https://github.com/helm/charts/tree/master/stable/dokuwiki)
- [Drupal](https://github.com/helm/charts/tree/master/stable/drupal)
- [Ghost](https://github.com/helm/charts/tree/master/stable/ghost)
- [JasperReports](https://github.com/helm/charts/tree/master/stable/jasperreports)
- [Joomla!](https://github.com/helm/charts/tree/master/stable/joomla)
- [Kubewatch](https://github.com/helm/charts/tree/master/stable/kubewatch)
- [MariaDB](https://github.com/helm/charts/tree/master/stable/mariadb)
- [MediaWiki](https://github.com/helm/charts/tree/master/stable/mediawiki)
- [MongoDB](https://github.com/helm/charts/tree/master/stable/mongodb)
- [Moodle](https://github.com/helm/charts/tree/master/stable/moodle)
- [NATS](https://github.com/helm/charts/tree/master/stable/nats)
- [Odoo](https://github.com/helm/charts/tree/master/stable/odoo)
- [OpenCart](https://github.com/helm/charts/tree/master/stable/opencart)
- [OrangeHRM](https://github.com/helm/charts/tree/master/stable/orangehrm)
- [Osclass](https://github.com/helm/charts/tree/master/stable/osclass)
- [OwnCloud](https://github.com/helm/charts/tree/master/stable/owncloud)
- [Parse](https://github.com/helm/charts/tree/master/stable/parse)
- [Phabricator](https://github.com/helm/charts/tree/master/stable/phabricator)
- [phpBB](https://github.com/helm/charts/tree/master/stable/phpbb)
- [phpMyAdmin](https://github.com/helm/charts/tree/master/stable/phpmyadmin)
- [PostgreSQL](https://github.com/helm/charts/tree/master/stable/postgresql)
- [PrestaShop](https://github.com/helm/charts/tree/master/stable/prestashop)
- [RabbitMQ](https://github.com/helm/charts/tree/master/stable/rabbitmq)
- [Redis](https://github.com/helm/charts/tree/master/stable/redis)
- [Redmine](https://github.com/helm/charts/tree/master/stable/redmine)
- [SuiteCRM](https://github.com/helm/charts/tree/master/stable/suitecrm)
- [TestLink](https://github.com/helm/charts/tree/master/stable/testlink)
- [WordPress](https://github.com/helm/charts/tree/master/stable/wordpress)

## Bitnami charts

- [Apache](https://github.com/bitnami/charts/tree/master/bitnami/apache)
- [Apache Airflow](https://github.com/bitnami/charts/tree/master/bitnami/airflow)
- [Cassandra](https://github.com/bitnami/charts/tree/master/bitnami/cassandra)
- [Elasticsearch](https://github.com/bitnami/charts/tree/master/bitnami/elasticsearch)
- [ExternalDNS](https://github.com/bitnami/charts/tree/master/bitnami/external-dns)
- [etcd](https://github.com/bitnami/charts/tree/master/bitnami/etcd)
- [HashiCorp Consul](https://github.com/bitnami/charts/tree/master/bitnami/consul)
- [Jenkins](https://github.com/bitnami/charts/tree/master/bitnami/jenkins)
- [Kafka](https://github.com/bitnami/charts/tree/master/bitnami/kafka)
- [Kubeapps](https://github.com/bitnami/charts/tree/master/bitnami/kubeapps)
- [Magento](https://github.com/bitnami/charts/tree/master/bitnami/magento)
- [Memcached](https://github.com/bitnami/charts/tree/master/bitnami/memcached)
- [Metrics Server](https://github.com/bitnami/charts/tree/master/bitnami/metrics-server)
- [MXNet](https://github.com/bitnami/charts/tree/master/bitnami/mxnet)
- [MySQL](https://github.com/bitnami/charts/tree/master/bitnami/mysql)
- [nginx](https://github.com/bitnami/charts/tree/master/bitnami/nginx)
- [nginx-ingress-controller](https://github.com/bitnami/charts/tree/master/bitnami/nginx-ingress-controller)
- [NodeJS](https://github.com/bitnami/charts/tree/master/bitnami/node)
- [PyTorch](https://github.com/bitnami/charts/tree/master/bitnami/pytorch)
- [TensorFlow ResNet](https://github.com/bitnami/charts/tree/master/bitnami/tensorflow-resnet)
- [Tomcat](https://github.com/bitnami/charts/tree/master/bitnami/tomcat)
- [WildFly](https://github.com/bitnami/charts/tree/master/bitnami/wildfly)
- [ZooKeeper](https://github.com/bitnami/charts/tree/master/bitnami/zookeeper)

## Before you begin

### Setup a Kubernetes Cluster

The quickest way to setup a Kubernetes cluster is with [Azure Kubernetes Service](https://azure.microsoft.com/en-us/services/kubernetes-service/), [AWS Elastic Container Service](https://aws.amazon.com/eks/) or [Google Kubernetes Engine](https://cloud.google.com/kubernetes-engine/) using their respective quick-start guides. For setting up Kubernetes on other cloud platforms or bare-metal servers refer to the Kubernetes [getting started guide](http://kubernetes.io/docs/getting-started-guides/).

### Install Helm

Helm is a tool for managing Kubernetes charts. Charts are packages of pre-configured Kubernetes resources.

To install Helm, refer to the [Helm install guide](https://github.com/helm/helm#install) and ensure that the `helm` binary is in the `PATH` of your shell.

### Add Repo

The stable charts are contributed to the upstream [helm/charts](https://github.com/helm/charts) repository. The following command allows you to download and install all the charts from this repository, both the bitnami and the upstreamed ones.

```bash
$ helm repo add bitnami https://charts.bitnami.com
```

### Using Helm

Once you have installed the Helm client and initialized the Tiller server, you can deploy a Bitnami Helm Chart into a Kubernetes cluster.

Please refer to the [Quick Start guide](https://github.com/helm/helm/blob/master/docs/quickstart.md) if you wish to get running in just a few commands, otherwise the [Using Helm Guide](https://github.com/helm/helm/blob/master/docs/using_helm.md) provides detailed instructions on how to use the Helm client to manage packages on your Kubernetes cluster.

Useful Helm Client Commands:
* View available charts: `helm search`
* Install a chart: `helm install stable/<package-name>`
* Upgrade your application: `helm upgrade`

# License

Copyright (c) 2018 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
