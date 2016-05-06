# Tomcat

> Apache Tomcat, often referred to as Tomcat, is an open-source web server and servlet container developed by the Apache Software Foundation. Tomcat implements several Java EE specifications including Java Servlet, JavaServer Pages, Java EL, and WebSocket, and provides a "pure Java" HTTP web server environment for Java code to run in.

Based on the [Bitnami Tomcat](https://github.com/bitnami/bitnami-docker-tomcat) image for docker, this Chart bootstraps a [Tomcat](https://tomcat.com/) deployment on a [Kubernetes](http://kubernetes.io) cluster using [Helm Classic](https://helm.sh).

## Persistence

For persistence of the Tomcat data, mount a [storage volume](http://kubernetes.io/docs/user-guide/volumes/) at the `/app` path of the Tomcat pod.

By default the Tomcat Chart mounts an [emptyDir](http://kubernetes.io/docs/user-guide/volumes/#emptydir) volume.

## Configuration

To edit the default Tomcat configuration, run

```bash
$ helmc edit tomcat
```

Configurable parameters can be specified in `tpl/values.toml`. If not specified default values as defined by the [Bitnami Tomcat](https://github.com/bitnami/bitnami-docker-tomcat) image are used.

> Tip: If you have issues running the above command, add `se autochdir` to your `~/.vimrc` profile or simply edit `~/.helmc/workspace/charts/tomcat/tpl/values.toml` in your favourite editor.

Finally, generate the chart to apply your changes to the configuration.

```bash
$ helmc generate tomcat
```

## Cleanup

To delete the Tomcat deployment completely:

```bash
$ helmc uninstall -n default tomcat
```
