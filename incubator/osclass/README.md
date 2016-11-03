# Osclass

[Osclass](https://osclass.org/) is a php script that allows you to quickly create and manage your own free classifieds site. Using this script, you can provide free advertising for items for sale, real estate, jobs, cars... Hundreds of free classified advertising sites are using Osclass.

## TL;DR;

```bash
$ helm install osclass-x.x.x.tgz
```

## Introduction

Bitnami charts for Helm are carefully engineered, actively maintained and are the quickest and easiest way to deploy containers on a Kubernetes cluster that are ready to handle production workloads.

This chart bootstraps a [Osclass](https://github.com/bitnami/bitnami-docker-osclass) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages the Bitnami MariaDB chart which is required for bootstrapping a MariaDB deployment for the database requirements of the Osclass application.

## Get this chart

Download the latest release of the chart from the [releases](../../../releases) page.

Alternatively, clone the repo if you wish to use the development snapshot:

```bash
$ git clone https://github.com/bitnami/charts.git
$ helm dependency update charts/incubator/osclass
```

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release osclass-x.x.x.tgz
```

*Replace the `x.x.x` placeholder with the chart release version.*

The command deploys Osclass on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the Osclass chart and their default values.

|           Parameter           |                Description                |                         Default                          |
|-------------------------------|-------------------------------------------|----------------------------------------------------------|
| `imageTag`                    | `bitnami/osclass` image tag.             | Osclass image version                                   |
| `imagePullPolicy`             | Image pull policy.                        | `Always` if `imageTag` is `latest`, else `IfNotPresent`. |
| `osclassHost`                | Osclass host to create application URLs  | `nil`                                                    |
| `osclassLoadBalancerIP`      | `loadBalancerIP` for the Osclass Service | `nil`                                                    |
| `osclassUser`                | User of the application                   | `user`                                                   |
| `osclassPassword`            | Application password                      | `bitnami`                                                |
| `osclassEmail`               | Admin email                               | `user@example.com`                                       |
| `osclassWebTitle`            | Application tittle                        | `Sample Web Page`                                        |
| `osclassPingEngines`         | Allow site to appear in search engines    | `1`                                                      |
| `osclassSaveStats`           | Send statistics and reports to Osclass    | `1`                                                      |
| `smtpHost`                    | SMTP host                                 | `nil`                                                    |
| `smtpPort`                    | SMTP port                                 | `nil`                                                    |
| `smtpUser`                    | SMTP user                                 | `nil`                                                    |
| `smtpPassword`                | SMTP password                             | `nil`                                                    |
| `smtpProtocol`                | SMTP protocol [`ssl`, `tls`]              | `nil`                                                    |
| `mariadb.mariadbRootPassword` | MariaDB admin password                    | `nil`                                                    |

The above parameters map to the env variables defined in [bitnami/osclass](http://github.com/bitnami/bitnami-docker-osclass). For more information please refer to the [bitnami/osclass](http://github.com/bitnami/bitnami-docker-osclass) image documentation.

> **Note**:
>
> For the Osclass application function correctly, you should specify the `osclassHost` parameter to specify the FQDN (recommended) or the public IP address of the Osclass service.
>
> Optionally, you can specify the `osclassLoadBalancerIP` parameter to assign a reserved IP address to the Osclass service of the chart. However please note that this feature is only available on a few cloud providers (f.e. GKE).
>
> To reserve a public IP address on GKE:
>
> ```bash
> $ gcloud compute addresses create osclass-public-ip
> ```
>
> The reserved IP address can be associated to the Osclass service by specifying it as the value of the `osclassLoadBalancerIP` parameter while installing the chart.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
  --set osclassUser=admin,osclassPassword=password,mariadb.mariadbRootPassword=secretpassword \
    osclass-x.x.x.tgz
```

The above command sets the Osclass administrator account username and password to `admin` and `password` respectively. Additionally it sets the MariaDB `root` user password to `secretpassword`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml osclass-x.x.x.tgz
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Persistence

The [Bitnami Osclass](https://github.com/bitnami/bitnami-docker-osclass) image stores the Osclass data and configurations at the `/bitnami/osclass` path of the container.

As a placeholder, the chart mounts an [emptyDir](http://kubernetes.io/docs/user-guide/volumes/#emptydir) volume at this location.

> *"An emptyDir volume is first created when a Pod is assigned to a Node, and exists as long as that Pod is running on that node. When a Pod is removed from a node for any reason, the data in the emptyDir is deleted forever."*

For persistence of the data you should replace the `emptyDir` volume with a persistent [storage volume](http://kubernetes.io/docs/user-guide/volumes/), else the data will be lost if the Pod is shutdown.

### Step 1: Create a persistent disk

You first need to create a persistent disk in the cloud platform your cluster is running. For example, on GCE you can use the `gcloud` tool to create a [gcePersistentDisk](http://kubernetes.io/docs/user-guide/volumes/#gcepersistentdisk):

```bash
$ gcloud compute disks create --size=500GB --zone=us-central1-a osclass-data-disk
```

### Step 2: Update `templates/deployment.yaml`

Replace:

```yaml
      volumes:
      - name: osclass-data
        emptyDir: {}
```

with

```yaml
      volumes:
      - name: osclass-data
        gcePersistentDisk:
          pdName: osclass-data-disk
          fsType: ext4
```

> **Note**:
>
> You should also use a persistent storage volume for the MariaDB deployment.

[Install](#installing-the-chart) the chart after making these changes.
