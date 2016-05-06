# Wildfly

> Wildfly formerly known as JBoss AS, or simply JBoss, is an application server authored by JBoss, now developed by Red Hat. WildFly is written in Java, and implements the Java Platform, Enterprise Edition (Java EE) specification.

Based on the [Bitnami Wildfly](https://github.com/bitnami/bitnami-docker-wildfly) image for docker, this Chart bootstraps a [Wildfly](https://wildfly.com/) deployment on a [Kubernetes](http://kubernetes.io) cluster using [Helm Classic](https://helm.sh).

## Persistence

For persistence of the Wildfly data, mount a [storage volume](http://kubernetes.io/docs/user-guide/volumes/) at the `/bitnami/wildfly/data` path of the Wildfly pod.

By default the Wildfly Chart mounts an [emptyDir](http://kubernetes.io/docs/user-guide/volumes/#emptydir) volume.

## Configuration

To edit the default Wildfly configuration, run

```bash
$ helmc edit wildfly
```

Configurable parameters can be specified in `tpl/values.toml`. If not specified default values as defined by the [Bitnami Wildfly](https://github.com/bitnami/bitnami-docker-wildfly) image are used.

> Tip: If you have issues running the above command, add `se autochdir` to your `~/.vimrc` profile or simply edit `~/.helmc/workspace/charts/wildfly/tpl/values.toml` in your favourite editor.

Finally, generate the chart to apply your changes to the configuration.

```bash
$ helmc generate wildfly
```

## Cleanup

To delete the Wildfly deployment completely:

```bash
$ helmc uninstall -n default wildfly
```
