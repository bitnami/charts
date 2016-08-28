# TestLink

[TestLink](http://www.testlink.org) is a web-based test management system that facilitates software quality assurance. It is developed and maintained by Teamtest. The platform offers support for test cases, test suites, test plans, test projects and user management, as well as various reports and statistics.

## TL;DR;

```bash
$ helm install testlink-x.x.x.tgz
```

## Introduction

Bitnami charts for Helm are carefully engineered, actively maintained and are the quickest and easiest way to deploy containers on a Kubernetes cluster that are ready to handle production workloads.

This chart bootstraps a [TestLink](https://github.com/bitnami/bitnami-docker-testlink) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages the Bitnami MariaDB chart which is required for bootstrapping a MariaDB deployment for the database requirements of the TestLink application.

## Get this chart

Download the latest release of the chart from the [releases](../../../releases) page.

Alternatively, clone the repo if you wish to use the development snapshot:

```bash
$ git clone https://github.com/bitnami/charts.git
```

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release testlink-x.x.x.tgz
```

*Replace the `x.x.x` placeholder with the chart release version.*

The command deploys TestLink on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the TestLink chart and their default values.

|           Parameter           |             Description             |                         Default                         |
|-------------------------------|-------------------------------------|---------------------------------------------------------|
| `imageTag`                    | `bitnami/testlink` image tag        | TestLink image version                                  |
| `imagePullPolicy`             | Image pull policy                   | `Always` if `imageTag` is `latest`, else `IfNotPresent` |
| `testlinkUsername`            | Admin username                      | `user`                                                  |
| `testlinkPassword`            | Admin user password                 | `bitnami`                                               |
| `testlinkEmail`               | Admin user email                    | `user@example.com`                                      |
| `smtpEnable`                  | Enable SMTP                         | `false`                                                 |
| `smtpHost`                    | SMTP host                           | `nil`                                                   |
| `smtpPort`                    | SMTP port                           | `nil`                                                   |
| `smtpUser`                    | SMTP user                           | `nil`                                                   |
| `smtpPassword`                | SMTP password                       | `nil`                                                   |
| `smtpConnectionMode`          | SMTP connection mode [`ssl`, `tls`] | `nil`                                                   |
| `mariadb.mariadbRootPassword` | MariaDB admin password              | `nil`                                                   |

The above parameters map to the env variables defined in [bitnami/testlink](http://github.com/bitnami/bitnami-docker-testlink). For more information please refer to the [bitnami/testlink](http://github.com/bitnami/bitnami-docker-testlink) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
  --set testlinkUsername=admin,testlinkPassword=password,mariadb.mariadbRootPassword=secretpassword \
    testlink-x.x.x.tgz
```

The above command sets the TestLink administrator account username and password to `admin` and `password` respectively. Additionally it sets the MariaDB `root` user password to `secretpassword`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml testlink-x.x.x.tgz
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Persistence

The [Bitnami TestLink](https://github.com/bitnami/bitnami-docker-testlink) image stores the TestLink data and configurations at the `/bitnami/testlink` path of the container.

As a placeholder, the chart mounts an [emptyDir](http://kubernetes.io/docs/user-guide/volumes/#emptydir) volume at this location.

> *"An emptyDir volume is first created when a Pod is assigned to a Node, and exists as long as that Pod is running on that node. When a Pod is removed from a node for any reason, the data in the emptyDir is deleted forever."*

For persistence of the data you should replace the `emptyDir` volume with a persistent [storage volume](http://kubernetes.io/docs/user-guide/volumes/), else the data will be lost if the Pod is shutdown.

### Step 1: Create a persistent disk

You first need to create a persistent disk in the cloud platform your cluster is running. For example, on GCE you can use the `gcloud` tool to create a [gcePersistentDisk](http://kubernetes.io/docs/user-guide/volumes/#gcepersistentdisk):

```bash
$ gcloud compute disks create --size=500GB --zone=us-central1-a testlink-data-disk
```

### Step 2: Update `templates/deployment.yaml`

Replace:

```yaml
      volumes:
      - name: testlink-data
        emptyDir: {}
```

with

```yaml
      volumes:
      - name: testlink-data
        gcePersistentDisk:
          pdName: testlink-data-disk
          fsType: ext4
```

> **Note**:
>
> You should also use a persistent storage volume for the MariaDB deployment.

[Install](#installing-the-chart) the chart after making these changes.
