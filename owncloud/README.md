# ownCloud

[ownCloud](https://owncloud.org/) is a file sharing server that puts the control and security of your own data back into your hands.

## TL;DR;

```bash
$ helm install owncloud-x.x.x.tgz
```

## Introduction

Bitnami charts for Helm are carefully engineered, actively maintained and are the quickest and easiest way to deploy containers on a Kubernetes cluster that are ready to handle production workloads.

This chart bootstraps a [ownCloud](https://github.com/bitnami/bitnami-docker-owncloud) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages the Bitnami MariaDB chart which is required for bootstrapping a MariaDB deployment for the database requirements of the ownCloud application.

## Get this chart

Download the latest release of the chart from the [releases](../../../releases) page.

Alternatively, clone the repo if you wish to use the development snapshot:

```bash
$ git clone https://github.com/bitnami/charts.git
```

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release owncloud-x.x.x.tgz
```

*Replace the `x.x.x` placeholder with the chart release version.*

The command deploys ownCloud on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the ownCloud chart and their default values.

|           Parameter           |                      Description                      |                         Default                         |
|-------------------------------|-------------------------------------------------------|---------------------------------------------------------|
| `imageTag`                    | `bitnami/owncloud` image tag                          | ownCloud image version                                     |
| `imagePullPolicy`             | Image pull policy                                     | `Always` if `imageTag` is `latest`, else `IfNotPresent` |
| `owncloudHost`                | ownCloud host to create application URLs              | `nil`                                                   |
| `owncloudLoadBalancerIP`      | `loadBalancerIP` for the ownCloud Service             | `nil`                                                   |
| `owncloudUser`                | User of the application                               | `user`                                                  |
| `owncloudPassword`            | Application password                                  | `bitnami`                                               |
| `owncloudEmail`               | Admin email                                           | `user@example.com`                                      |
| `smtpHost`                    | SMTP Host                                             | `nil`                                                   |
| `smtpPort`                    | SMTP Port                                             | `nil`                                                   |
| `smtpUser`                    | SMTP User                                             | `nil`                                                   |
| `smtpPassword`                | SMTP Password                                         | `nil`                                                   |
| `smtpAuth`                    | SMTP Auth                                             | `nil`                                                   |
| `mariadb.mariadbRootPassword` | MariaDB admin password                                | `nil`                                                   |

The above parameters map to the env variables defined in [bitnami/owncloud](http://github.com/bitnami/bitnami-docker-owncloud). For more information please refer to the [bitnami/owncloud](http://github.com/bitnami/bitnami-docker-owncloud) image documentation.

> **Note**:
>
> For the ownCloud application function correctly, you should specify the `owncloudHost` parameter to specify the FQDN (recommended) or the public IP address of the ownCloud service.
>
> Optionally, you can specify the `owncloudLoadBalancerIP` parameter to assign a reserved IP address to the ownCloud service of the chart. However please note that this feature is only available on a few cloud providers (f.e. GKE).
>
> To reserve a public IP address on GKE:
>
> ```bash
> $ gcloud compute addresses create owncloud-public-ip
> ```
>
> The reserved IP address can be associated to the ownCloud service by specifying it as the value of the `owncloudLoadBalancerIP` parameter while installing the chart.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
  --set owncloudUser=admin,owncloudPassword=password,mariadb.mariadbRootPassword=secretpassword \
    owncloud-x.x.x.tgz
```

The above command sets the ownCloud administrator account username and password to `admin` and `password` respectively. Additionally it sets the MariaDB `root` user password to `secretpassword`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml owncloud-x.x.x.tgz
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Persistence

The [Bitnami ownCloud](https://github.com/bitnami/bitnami-docker-owncloud) image stores the ownCloud data and configurations at the `/bitnami/owncloud` path of the container.

As a placeholder, the chart mounts an [emptyDir](http://kubernetes.io/docs/user-guide/volumes/#emptydir) volume at this location.

> *"An emptyDir volume is first created when a Pod is assigned to a Node, and exists as long as that Pod is running on that node. When a Pod is removed from a node for any reason, the data in the emptyDir is deleted forever."*

For persistence of the data you should replace the `emptyDir` volume with a persistent [storage volume](http://kubernetes.io/docs/user-guide/volumes/), else the data will be lost if the Pod is shutdown.

### Step 1: Create a persistent disk

You first need to create a persistent disk in the cloud platform your cluster is running. For example, on GCE you can use the `gcloud` tool to create a [gcePersistentDisk](http://kubernetes.io/docs/user-guide/volumes/#gcepersistentdisk):

```bash
$ gcloud compute disks create --size=500GB --zone=us-central1-a owncloud-data-disk
```

### Step 2: Update `templates/deployment.yaml`

Replace:

```yaml
      volumes:
      - name: owncloud-data
        emptyDir: {}
```

with

```yaml
      volumes:
      - name: owncloud-data
        gcePersistentDisk:
          pdName: owncloud-data-disk
          fsType: ext4
```

> **Note**:
>
> You should also use a persistent storage volume for the MariaDB deployment.

[Install](#installing-the-chart) the chart after making these changes.
