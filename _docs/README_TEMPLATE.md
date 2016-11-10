# _Application_

- _Short introduction to the application deployed by the chart with link to the project homepage_

> **Sample**
>
> [MediaWiki](https://www.mediawiki.org) is an extremely powerful, scalable software and a feature-rich wiki implementation that uses PHP to process and display data stored in a database, such as MySQL.

## TL;DR;

- _List the `helm install` command required to deployed the chart_

> **Sample**
>
> ```bash
> $ helm install stable/mediawiki
> ```

## Introduction

- _A brief introduction to the chart and the chart(s) it depends upon._

> **Sample**
>
> This chart bootstraps a MediaWiki deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager. The chart depends upon the [MariaDB chart](https://github.com/kubernetes/charts/tree/master/stable/mariadb) for the database requirements of MediaWiki.
>
> The chart uses the [Bitnami MediaWiki Docker Image](https://hub.docker.com/r/bitnami/mediawiki) for setting up the MediaWiki deployment and is developed, contributed and maintained by [Bitnami](https://bitnami.com).

## Prerequisites

_List the cluster requirements for a successful deployment of the chart_

> **Sample**
>
> - Kubernetes 1.4+ with Beta APIs enabled
> - PV provisioner support in the underlying infrastructure

## Installing

- _Provide chart deployment instructions. This may include steps to pull chart dependencies and so on._
- _Use a release name in the `helm install` commands and refer to it in the upgrading and uninstalling sections._
- _Link to the configuration section for customizing a chart deployment._


> **Sample**
>
> Install the chart using:
>
> ```bash
> $ helm install --name my-release stable/mediawiki
> ```
>
> The command deploys MediaWiki on the Kubernetes cluster in the default configuration and with the release name `my-release`. The deployment configuration can be customized by specifying the customization parameters with the `helm install` command using the `--values` or `--set` arguments. Find more information in the [configuration section](#configuration) of this document.

## Upgrading

- _Provide instructions to upgrade a chart deployment using the `helm upgrade` commands_

> **Sample**
>
> Upgrade the chart deployment using:
>
> ```bash
> $ helm upgrade my-release stable/mediawiki
> ```
>
> The command upgrades the existing `my-release` deployment with the most latest release of the chart.
>
> **TIP**: Use `helm repo update` to update information on available charts in the chart repositories.

## Uninstalling

- _Provide instructions to uninstall a chart deployment from the cluster_

> **Sample**
>
> Uninstall the `my-release` deployment using:
>
> ```bash
> $ helm delete my-release
> ```
>
> The command deletes the release named `my-release` and frees all the kubernetes resources associated with the release.
>
> **TIP**: _Specify the `--purge`_ argument to the above command to remove the release from the store and make its name free for later use.

## Configuration

- _Insert a table listing all the configurations that can be customized via the `values.yaml` file._
- _**TIP**: The `Table Editor` plugin for SublimeText is useful for creating and updating this table_
- _Provide information on how to specify these parameters, ie. using a `myvals.yml` file or using the `--set` option and possibly an example_

> **Sample**
>
> The following table lists all the configurable parameters expose by the MediaWiki chart and their default values.
>
> |              Name             |          Decription          |                 Default                  |
> |-------------------------------|------------------------------|------------------------------------------|
> | `mediawikiUser`               | Admin user name              | `user`                                   |
> | `mediawikiPassword`           | Admin user password          | _randomly generated alphanumeric string_ |
> | `mediawikiEmail`              | Admin user email             | `user@example.com`                       |
> | `mariadb.mariadbRootPassword` | MariaDB admin password       | _no password_                            |
> | `persistence.enabled`         | Enable persistence using PVC | `true`                                   |
>
> Specify the parameters you which to customize using the `--set` argument to the `helm install` command. For instance,
>
> ```bash
> $ helm install --name my-release \
>     --set mediawikiUser=admin,mediawikiPassword=password stable/mediawiki
> ```
>
> The above command sets the MediaWiki administrator account username and password to `admin` and `password` respectively.
>
> Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,
>
> ```bash
> $ helm install --name my-release \
>     --values values.yaml stable/mediawiki
> ```
>
> **Tip**: You can use the default [values.yaml](values.yaml).

## Persistence

- _Describe how the chart handles persistence and the options to enable/disable persistence_

> **Sample**
>
> The [Bitnami MediaWiki Docker Image](https://hub.docker.com/r/bitnami/mediawiki) saves persistent data in the `/bitnami/mediawiki` and `/bitnami/apache` paths of the container. The chart makes use of [Persistent Volumes Claims](http://kubernetes.io/docs/user-guide/persistent-volumes/#persistentvolumeclaims) to set up data persistence across chart upgrades and is known to work in GKE, AWS and Minikube Kubernetes cluster setups.
>
> See the [configuration section](#configuration) to configure the PVC or to disable persistence.
