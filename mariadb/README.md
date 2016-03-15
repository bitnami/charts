# MariaDB

> MariaDB is a fast, reliable, scalable, and easy to use open-source relational database system. MariaDB Server is intended for mission-critical, heavy-load production systems as well as for embedding into mass-deployed software.

Based on the [Bitnami MariaDB](https://github.com/bitnami/bitnami-docker-mariadb) image for docker, this Chart bootstraps a [MariaDB](https://mariadb.com/) deployment on a [Kubernetes](https://kubernetes.io) cluster using [Helm](https://helm.sh).

## TL;DR;

```bash
$ helm fetch bitnami/mariadb
$ helm generate mariadb
$ helm install mariadb
```

The above commands will deploy the MariaDB Chart to the `default` kubernetes namespace.

## Persistence

For persistence of the MariaDB data, mount a [storage volume](http://kubernetes.io/v1.0/docs/user-guide/volumes.html) at the `/bitnami/mariadb/data` path of the MariaDB pod.

By default the MariaDB Chart mounts an [emptyDir](http://kubernetes.io/docs/user-guide/volumes/#emptydir) volume.

From the `emptyDir` documentation: *"An emptyDir volume is first created when a Pod is assigned to a Node, and exists as long as that Pod is running on that node... When a Pod is removed from a node for any reason, the data in the emptyDir is deleted forever."*

To persist your MariaDB data across Pod shutdown and startup we need to mount a persistent storage volume at `/bitnami/mariadb/data`. For the purpose of demonstration we'll use a [gcePersistentDisk](http://kubernetes.io/docs/user-guide/volumes/#gcepersistentdisk).

Create a GCE PD using:

```bash
$ gcloud compute disks create --size=500GB --zone=us-central1-a mariadb-data-disk
```

> Note: You will be charged additionally for this volume.

## Deploying the Chart

### Step 1. Fetch the MariaDB Chart to your workspace

```bash
$ helm fetch bitnami/mariadb
```

The MariaDB Chart will be copied into your workspace, located at `~/.helm/workspace/charts/mariadb/`

### Step 2. Edit the default MariaDB configuration

```bash
$ helm edit mariadb
```

By default the MariaDB root password is not assigned a value. Edit the value of `mariadbPassword` in `mariadb/tpl/values.toml` to set it to your choosing.

> Tip: If you have issues running the above command, add `se autochdir` to your `~/.vimrc` profile or simply edit `~/.helm/workspace/charts/mariadb/tpl/values.toml` in your favourite editor.

If you [setup a GCE PD](#Persistence), you will need to update the `mariadb/tpl/mariadb-controller.yaml` as well.

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

### Step 3. Generate the Chart

```bash
$ helm generate mariadb
```

The above command will generate the MariaDB Chart with your changes from the last step.

### Step 4. Deploy MariaDB

```bash
$ helm install mariadb
```

In the above command, Helm will deploy the MariaDB Chart in the cluster in the `default` namespace.

The deployment status of the MariaDB pods can be checked with `kubectl` using:

```bash
$ kubectl get pods -l provider=mariadb
NAME            READY     STATUS    RESTARTS   AGE
mariadb-3fu51   1/1       Running   0          1m
```

Your MariaDB deployment is now ready to be used.

## Cleanup

To delete the MariaDB deployment completely:

### Step 1. Uninstall the MariaDB Chart:

```bash
$ helm uninstall -n default mariadb
```

### Step 2. Delete the persistent disk:

```bash
$ gcloud compute disks delete mariadb-data-disk
```
