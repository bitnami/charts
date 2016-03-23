# Memcached

> Memcached is an in-memory key-value store for small chunks of arbitrary data (strings, objects) from results of database calls, API calls, or page rendering.

Based on the [Bitnami Memcached](https://github.com/bitnami/bitnami-docker-memcached) image for docker, this Chart bootstraps a [Memcached](http://memcached.org/) deployment on a [Kubernetes](http://kubernetes.io) cluster using [Helm](https://helm.sh).

## Configuration

To edit the default Memcached configuration, run

```bash
$ helm edit memcached
```

By default authentication is not enabled on the Memcached server. Edit the value of `memcachedPassword` in `memcached/tpl/values.toml` to set a password and enable authentication.

> Tip: If you have issues running the above command, add `se autochdir` to your `~/.vimrc` profile or simply edit `~/.helm/workspace/charts/memcached/tpl/values.toml` in your favourite editor.

Finally, generate the chart to apply your changes to the configuration.

```bash
$ helm generate memcached
```

## Cleanup

To delete the Memcached deployment completely:

```bash
$ helm uninstall -n default memcached
```
