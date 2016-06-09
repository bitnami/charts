# Redis

> Redis is an advanced key-value cache and store. It is often referred to as a data structure server since keys can contain strings, hashes, lists, sets, sorted sets, bitmaps and hyperloglogs.

Based on the [Bitnami Redis](https://github.com/bitnami/bitnami-docker-redis) image for docker, this Chart bootstraps a [Redis](https://redis.com/) deployment on a [Kubernetes](http://kubernetes.io) cluster using [Helm Classic](https://helm.sh).

## Persistence

For persistence of the Redis data, mount a [storage volume](http://kubernetes.io/docs/user-guide/volumes/) at the `/bitnami/redis` path of the Redis pod.

By default the Redis Chart mounts an [emptyDir](http://kubernetes.io/docs/user-guide/volumes/#emptydir) volume.

## Configuration

To edit the default Redis configuration, run

```bash
$ helmc edit redis
```

Configurable parameters can be specified in `tpl/values.toml`. If not specified default values as defined by the [Bitnami Redis](https://github.com/bitnami/bitnami-docker-redis) image are used.

> Tip: If you have issues running the above command, add `se autochdir` to your `~/.vimrc` profile or simply edit `~/.helmc/workspace/charts/redis/tpl/values.toml` in your favourite editor.

Finally, generate the chart to apply your changes to the configuration.

```bash
$ helmc generate --force redis
```

## Cleanup

To delete the Redis deployment completely:

```bash
$ helmc uninstall -n default redis
```
