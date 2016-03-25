# MariaDB

> MariaDB is a fast, reliable, scalable, and easy to use open-source relational database system. MariaDB Server is intended for mission-critical, heavy-load production systems as well as for embedding into mass-deployed software.

Based on the [Bitnami MariaDB](https://github.com/bitnami/bitnami-docker-mariadb) image for docker, this Chart bootstraps a [MariaDB](https://mariadb.com/) deployment on a [Kubernetes](http://kubernetes.io) cluster using [Helm](https://helm.sh).

## Persistence

For persistence of the MariaDB data, mount a [storage volume](http://kubernetes.io/docs/user-guide/volumes/) at the `/bitnami/mariadb/data` path of the MariaDB master pod.

By default the MariaDB Chart mounts an [emptyDir](http://kubernetes.io/docs/user-guide/volumes/#emptydir) volume.

## Configuration

To edit the default MariaDB configuration, run

```bash
$ helm edit mariadb-cluster
```

Configurable parameters can be specified in `tpl/values.toml`. If not specified default values as defined by the [Bitnami MariaDB](https://github.com/bitnami/bitnami-docker-mariadb) image are used.

> Tip: If you have issues running the above command, add `se autochdir` to your `~/.vimrc` profile or simply edit `~/.helm/workspace/charts/mariadb-cluster/tpl/values.toml` in your favourite editor.

Finally, generate the chart to apply your changes to the configuration.

```bash
$ helm generate mariadb-cluster
```

## Cleanup

To delete the MariaDB deployment completely:

```bash
$ helm uninstall -n default mariadb-cluster
```
