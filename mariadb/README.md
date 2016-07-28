# MariaDB

> MariaDB is a fast, reliable, scalable, and easy to use open-source relational database system. MariaDB Server is intended for mission-critical, heavy-load production systems as well as for embedding into mass-deployed software.

Based on the [Bitnami MariaDB](https://github.com/bitnami/bitnami-docker-mariadb) image for docker, this Chart bootstraps a [MariaDB](https://mariadb.com/) deployment on a [Kubernetes](http://kubernetes.io) cluster using [Helm](https://helm.sh).

## TL;DR;

```bash
$ helm install mariadb
```

## Configuration

The various configuration parameters of the MariaDB container used in the Chart can be specified in the `values.yaml`.

The following table briefly describes the configurable parameters of the chart.

|      Parameter      |                                              Descripion                                             |
|---------------------|-----------------------------------------------------------------------------------------------------|
| `imageTag`            | `bitnami/mariadb` image tag.                                                                        |
| `imagePullPolicy`     | Image pull policy. Defaults to `Always` if `imageTag` is `latest`, else defaults to `IfNotPresent`. |
| `mariadbRootPassword` | Password for the `root` user. Defaults to `nil`.                                                    |
| `mariadbUser`         | Username of new user to create.                                                                     |
| `mariadbPassword`     | Password for the new user.                                                                          |
| `mariadbDatabase`     | Name for new database to create.                                                                    |

Please refer the [bitnami/mariadb](http://github.com/bitnami/bitnami-docker-mariadb) for additional information.

## Persistence

For the persistence of the data and configurations a [storage volume](http://kubernetes.io/docs/user-guide/volumes/) should be mounted at the `/bitnami/mariadb` path of the MariaDB container.

By default, the Chart mounts an [emptyDir](http://kubernetes.io/docs/user-guide/volumes/#emptydir) volume at this location.

> *"An emptyDir volume is first created when a Pod is assigned to a Node, and exists as long as that Pod is running on that node. When a Pod is removed from a node for any reason, the data in the emptyDir is deleted forever."*

To persist the data and configurations across Pod shutdown and startup you should swap out the `emptyDir` volume with a persistent storage volume. For the purpose of demonstration we'll use a [gcePersistentDisk](http://kubernetes.io/docs/user-guide/volumes/#gcepersistentdisk).

### Step 1: Create a GCE PD using:

```bash
$ gcloud compute disks create --size=500GB --zone=us-central1-a mariadb-data-disk
```

### Step 2: Edit `templates/mariadb-deployment.yaml`

Replace:

```yaml
      volumes:
      - name: data
        emptyDir: {}
```

with

```yaml
      volumes:
      - name: data
        gcePersistentDisk:
          pdName: mariadb-data-disk
          fsType: ext4
```

## Deploying the Chart

```bash
$ helm install mariadb
awesome-bear
```

The above command deploy's the Chart and returns the release name of the deployment. Remember to note down the release name as it uniquely identifies the deployment.

> **Tip**:
>
> You can list all releases using:
>
> ```bash
> $ helm list
> ```

You can query the status of the deployment using:

```bash
$ kubectl get pods,deployment,replicasets,service -l release=awesome-bear,provider=mariadb
NAME                                    READY          STATUS        RESTARTS     AGE
awesome-bear-mariadb-2591315682-4qgrw   1/1            Running       0            38s
NAME                                    DESIRED        CURRENT       UP-TO-DATE   AVAILABLE   AGE
awesome-bear-mariadb                    1              1             1            1           38s
NAME                                    DESIRED        CURRENT       AGE
awesome-bear-mariadb-2591315682         1              1             38s
NAME                                    CLUSTER-IP     EXTERNAL-IP   PORT(S)    AGE
awesome-bear-mariadb                    10.15.241.66   <none>        3306/TCP   38s
```

> **Note**:
>
> Update `release=awesome-bear` in the above command with your release name.

Congratulations! You've successfully deployed the MariaDB Chart.

## Cleanup

To delete the MariaDB deployment completely:

### Step 1. Uninstall the MariaDB Chart:

```bash
$ helm delete awesome-bear
```

### Step 2. Delete the persistent disk:

```bash
$ gcloud compute disks delete mariadb-data-disk
```
