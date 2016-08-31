# Magento

[Magento](https://magento.org/) is a feature-rich flexible e-commerce solution. It includes transaction options, multi-store functionality, loyalty programs, product categorization and shopper filtering, promotion rules, and more.

## TL;DR;

```bash
$ helm install magento-x.x.x.tgz
```

## Introduction

Bitnami charts for Helm are carefully engineered, actively maintained and are the quickest and easiest way to deploy containers on a Kubernetes cluster that are ready to handle production workloads.

This chart bootstraps a [Magento](https://github.com/bitnami/bitnami-docker-magento) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages the Bitnami MariaDB chart which is required for bootstrapping a MariaDB deployment for the database requirements of the Magento application.

## Get this chart

Download the latest release of the chart from the [releases](../../../releases) page.

Alternatively, clone the repo if you wish to use the development snapshot:

```bash
$ git clone https://github.com/bitnami/charts.git
```

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release magento-x.x.x.tgz
```

*Replace the `x.x.x` placeholder with the chart release version.*

The command deploys Magento on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the Magento chart and their default values.

|           Parameter           |                      Description                      |                         Default                         |
|-------------------------------|-------------------------------------------------------|---------------------------------------------------------|
| `imageTag`                    | `bitnami/magento` image tag                           | Magento image version                                   |
| `imagePullPolicy`             | Image pull policy                                     | `Always` if `imageTag` is `latest`, else `IfNotPresent` |
| `magentoHost`                 | Magento hostname                                      | `nil`                                                   |
| `magentoLoadBalancerIP`       | `loadBalancerIP` for the Magento Service              | `nil`                                                   |
| `magentoUser`                 | User of the application                               | `user`                                                  |
| `magentoPassword`             | Application password                                  | `bitnami1`                                              |
| `magentoEmail`                | Admin email                                           | `user@example.com`                                      |
| `magentoFirstName`            | Magento Admin First Name                              | `FirstName`                                             |
| `magentoLastName`             | Magento Admin Last Name                               | `LastName`                                              |
| `magentoMode`                 | Magento mode                                          | `developer`                                             |
| `magentoAdminUri`             | Magento prefix to access Magento Admin                | `admin`                                                 |
| `mariadb.mariadbRootPassword` | MariaDB admin password                                | `nil`                                                   |

The above parameters map to the env variables defined in [bitnami/magento](http://github.com/bitnami/bitnami-docker-magento). For more information please refer to the [bitnami/magento](http://github.com/bitnami/bitnami-docker-magento) image documentation.

> **Note**:
>
> For the Magento application function correctly, you should specify the `magentoHost` parameter to specify the FQDN (recommended) or the public IP address of the Magento service.
>
> Optionally, you can specify the `magentoLoadBalancerIP` parameter to assign a reserved IP address to the Magento service of the chart. However please note that this feature is only available on a few cloud providers (f.e. GKE).
>
> To reserve a public IP address on GKE:
>
> ```bash
> $ gcloud compute addresses create magento-public-ip
> ```
>
> The reserved IP address can be associated to the Magento service by specifying it as the value of the `magentoLoadBalancerIP` parameter while installing the chart.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
  --set magentoUser=admin,magentoPassword=password,mariadb.mariadbRootPassword=secretpassword \
    magento-x.x.x.tgz
```

The above command sets the Magento administrator account username and password to `admin` and `password` respectively. Additionally it sets the MariaDB `root` user password to `secretpassword`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml magento-x.x.x.tgz
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Persistence

The [Bitnami Magento](https://github.com/bitnami/bitnami-docker-magento) image stores the Magento data and configurations at the `/bitnami/magento` path of the container.

As a placeholder, the chart mounts an [emptyDir](http://kubernetes.io/docs/user-guide/volumes/#emptydir) volume at this location.

> *"An emptyDir volume is first created when a Pod is assigned to a Node, and exists as long as that Pod is running on that node. When a Pod is removed from a node for any reason, the data in the emptyDir is deleted forever."*

For persistence of the data you should replace the `emptyDir` volume with a persistent [storage volume](http://kubernetes.io/docs/user-guide/volumes/), else the data will be lost if the Pod is shutdown.

### Step 1: Create a persistent disk

You first need to create a persistent disk in the cloud platform your cluster is running. For example, on GCE you can use the `gcloud` tool to create a [gcePersistentDisk](http://kubernetes.io/docs/user-guide/volumes/#gcepersistentdisk):

```bash
$ gcloud compute disks create --size=500GB --zone=us-central1-a magento-data-disk
```

### Step 2: Update `templates/deployment.yaml`

Replace:

```yaml
      volumes:
      - name: magento-data
        emptyDir: {}
```

with

```yaml
      volumes:
      - name: magento-data
        gcePersistentDisk:
          pdName: magento-data-disk
          fsType: ext4
```

> **Note**:
>
> You should also use a persistent storage volume for the MariaDB deployment.

[Install](#installing-the-chart) the chart after making these changes.
