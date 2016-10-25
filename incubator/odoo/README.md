# Odoo

[Odoo](https://www.odoo.com/) is a suite of web based open source business apps. The main Odoo Apps include an Open Source CRM, Website Builder, eCommerce, Project Management, Billing & Accounting, Point of Sale, Human Resources, Marketing, Manufacturing, Purchase Management, ...

Odoo Apps can be used as stand-alone applications, but they also integrate seamlessly so you get a full-featured Open Source ERP when you install several Apps.

## TL;DR;

```bash
$ helm install odoo-x.x.x.tgz
```

## Introduction

Bitnami charts for Helm are carefully engineered, actively maintained and are the quickest and easiest way to deploy containers on a Kubernetes cluster that are ready to handle production workloads.

This chart bootstraps a [Odoo](https://github.com/bitnami/bitnami-docker-odoo) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages the Bitnami PostgreSQL chart which is required for bootstrapping a PostgreSQL deployment for the database requirements of the Odoo application.

## Get this chart

Download the latest release of the chart from the [releases](../../../releases) page.

Alternatively, clone the repo if you wish to use the development snapshot:

```bash
$ git clone https://github.com/bitnami/charts.git
```

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release odoo-x.x.x.tgz
```

*Replace the `x.x.x` placeholder with the chart release version.*

The command deploys Odoo on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the Odoo chart and their default values.

|            Parameter            |         Description          |                         Default                         |
|---------------------------------|------------------------------|---------------------------------------------------------|
| `imageTag`                      | `bitnami/odoo` image tag     | Odoo image version                                      |
| `imagePullPolicy`               | Image pull policy            | `Always` if `imageTag` is `latest`, else `IfNotPresent` |
| `odooPassword`                  | Admin account password       | `bitnami`                                               |
| `odooEmail`                     | Admin account email          | `user@example.com`                                      |
| `smtpHost`                      | SMTP host                    | `nil`                                                   |
| `smtpPort`                      | SMTP port                    | `nil`                                                   |
| `smtpUser`                      | SMTP user                    | `nil`                                                   |
| `smtpPassword`                  | SMTP password                | `nil`                                                   |
| `smtpProtocol`                  | SMTP protocol [`ssl`, `tls`] | `nil`                                                   |
| `postgresql.postgresqlPassword` | PostgreSQL password          | `nil`                                                   |

The above parameters map to the env variables defined in [bitnami/odoo](http://github.com/bitnami/bitnami-docker-odoo). For more information please refer to the [bitnami/odoo](http://github.com/bitnami/bitnami-docker-odoo) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
  --set odooPassword=password,postgresql.postgresPassword=secretpassword \
    odoo-x.x.x.tgz
```

The above command sets the Odoo administrator account password to `password` and the PostgreSQL `postgres` user password to `secretpassword`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml odoo-x.x.x.tgz
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Persistence

The [Bitnami Odoo](https://github.com/bitnami/bitnami-docker-odoo) image stores the Odoo data and configurations at the `/bitnami/odoo` path of the container.

As a placeholder, the chart mounts an [emptyDir](http://kubernetes.io/docs/user-guide/volumes/#emptydir) volume at this location.

> *"An emptyDir volume is first created when a Pod is assigned to a Node, and exists as long as that Pod is running on that node. When a Pod is removed from a node for any reason, the data in the emptyDir is deleted forever."*

For persistence of the data you should replace the `emptyDir` volume with a persistent [storage volume](http://kubernetes.io/docs/user-guide/volumes/), else the data will be lost if the Pod is shutdown.

### Step 1: Create a persistent disk

You first need to create a persistent disk in the cloud platform your cluster is running. For example, on GCE you can use the `gcloud` tool to create a [gcePersistentDisk](http://kubernetes.io/docs/user-guide/volumes/#gcepersistentdisk):

```bash
$ gcloud compute disks create --size=500GB --zone=us-central1-a odoo-data-disk
```

### Step 2: Update `templates/deployment.yaml`

Replace:

```yaml
      volumes:
      - name: odoo-data
        emptyDir: {}
```

with

```yaml
      volumes:
      - name: odoo-data
        gcePersistentDisk:
          pdName: odoo-data-disk
          fsType: ext4
```

> **Note**:
>
> You should also use a persistent storage volume for the PostgreSQL deployment.

[Install](#installing-the-chart) the chart after making these changes.
