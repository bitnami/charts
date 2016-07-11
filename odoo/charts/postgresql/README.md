# PostgreSQL

> PostgreSQL is an object-relational database management system (ORDBMS) with an emphasis on extensibility and on standards-compliance.

Based on the [Bitnami PostgreSQL](https://github.com/bitnami/bitnami-docker-postgresql) image for docker, this Chart bootstraps a [PostgreSQL](http://www.postgresql.org/) deployment on a [Kubernetes](http://kubernetes.io) cluster using [Helm Classic](https://helm.sh).

## Persistence

For persistence of the PostgreSQL data, mount a [storage volume](http://kubernetes.io/docs/user-guide/volumes/) at the `/bitnami/postgresql/data` path of the PostgreSQL pod.

By default the PostgreSQL Chart mounts an [emptyDir](http://kubernetes.io/docs/user-guide/volumes/#emptydir) volume.

## Configuration

To edit the default PostgreSQL configuration, run

```bash
$ helmc edit postgresql
```

Configurable parameters can be specified in `tpl/values.toml`. If not specified default values as defined by the [Bitnami PostgreSQL](https://github.com/bitnami/bitnami-docker-postgresql) image are used.

> Tip: If you have issues running the above command, add `se autochdir` to your `~/.vimrc` profile or simply edit `~/.helmc/workspace/charts/postgresql/tpl/values.toml` in your favourite editor.

Finally, generate the chart to apply your changes to the configuration.

```bash
$ helmc generate --force postgresql
```

## Cleanup

To delete the PostgreSQL deployment completely:

```bash
$ helmc uninstall -n default postgresql
```
