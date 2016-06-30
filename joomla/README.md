# Joomla

> Joomla is a PHP content management system (CMS) for publishing web content. It includes features such as page caching, RSS feeds, printable versions of pages, news flashes, blogs, search, and support for language international.

Based on the [Bitnami Joomla](https://github.com/bitnami/bitnami-docker-joomla) image for docker, this Chart bootstraps a [Joomla](https://joomla.org/) deployment on a [Kubernetes](https://kubernetes.io) cluster using [Helm](https://helm.sh).

## Dependencies

The Joomla Chart requires the [Bitnami MariaDB Chart](https://github.com/bitnami/charts/tree/master/mariadb) for setting up a database backend.

Please refer to the [README](https://github.com/bitnami/charts/tree/master/mariadb) of the Bitnami MariaDB Chart for deployment instructions.

## Persistence

> *You may skip this section if your only interested in testing the Joomla Chart and have not yet made the decision to use it for your production workloads.*

For persistence of the Joomla configuration and user file uploads, mount a [storage volume](http://kubernetes.io/v1.0/docs/user-guide/volumes.html) at the `/bitnami/joomla` path of the Joomla pod.

By default the Joomla Chart mounts an [emptyDir](http://kubernetes.io/docs/user-guide/volumes/#emptydir) volume.

## Configuration

To edit the default Joomla configuration, run

```bash
$ helmc edit joomla
```

Here you can update the Joomla admin username, password and email address in `tpl/values.toml`. When not specified, the default values are used.

Refer to the [Environment variables](https://github.com/bitnami/bitnami-docker-joomla/#environment-variables) section of the [Bitnami Joomla](https://github.com/bitnami/bitnami-docker-joomla) image for the default values.

The values of `joomlaUser` and `joomlaPassword` are the login credentials when you [access the Joomla instance](#access-your-joomla-application).

Finally, generate the chart to apply your changes to the configuration.

```bash
$ helmc generate --force joomla
```

## Access your Joomla application

You should now be able to access the application using the external IP configured for the Joomla service.

> Note:
>
> On GKE, the service will automatically configure a firewall rule so that the Joomla instance is accessible from the internet, for which you will be charged additionally.
>
> On other cloud platforms you may have to setup a firewall rule manually. Please refer your cloud providers documentation.

Get the external IP address of your Joomla instance using:

```bash
$ kubectl get services joomla
NAME      CLUSTER_IP      EXTERNAL_IP       PORT(S)         SELECTOR      AGE
joomla    10.63.246.116   146.148.20.117    80/TCP,443/TCP  app=joomla    15m
```

Access your Joomla deployment using the IP address listed under the `EXTERNAL_IP` column.

The default credentials are:

 - Username: `user`
 - Password: `bitnami`

## Cleanup

To delete the Joomla deployment completely:

```bash
$ helmc uninstall -n default joomla
```

Additionally you may want to [Cleanup the MariaDB Chart](https://github.com/bitnami/charts/tree/master/mariadb#cleanup)
