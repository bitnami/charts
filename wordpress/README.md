# WordPress

> WordPress is one of the most versatile open source content management systems on the market. A publishing platform for building blogs and websites.

Based on the [Bitnami WordPress](https://github.com/bitnami/bitnami-docker-wordpress) image for docker, this Chart bootstraps a [WordPress](https://wordpress.org/) deployment on a [Kubernetes](https://kubernetes.io) cluster using [Helm](https://helm.sh).

## Dependencies

The WordPress Chart requires the [Bitnami MariaDB Chart](https://github.com/bitnami/charts/tree/master/mariadb) for setting up a database backend.

Please refer to the [README](https://github.com/bitnami/charts/tree/master/mariadb) of the Bitnami MariaDB Chart for deployment instructions.

## Persistence

> *You may skip this section if your only interested in testing the WordPress Chart and have not yet made the decision to use it for your production workloads.*

For persistence of the WordPress configuration and user file uploads, mount a [storage volume](http://kubernetes.io/v1.0/docs/user-guide/volumes.html) at the `/bitnami/wordpress` path of the WordPress pod.

By default the WordPress Chart mounts an [emptyDir](http://kubernetes.io/docs/user-guide/volumes/#emptydir) volume.

## Configuration

To edit the default WordPress configuration, run

```bash
$ helmc edit wordpress
```

Here you can update the WordPress admin username, password and email address in `tpl/values.toml`. When not specified, the default values are used.

Refer to the [Environment variables](https://github.com/bitnami/bitnami-docker-wordpress/#environment-variables) section of the [Bitnami WordPress](https://github.com/bitnami/bitnami-docker-wordpress) image for the default values.

The values of `wordpressUser` and `wordpressPassword` are the login credentials when you [access the WordPress instance](#access-your-wordpress-application).

Finally, generate the chart to apply your changes to the configuration.

```bash
$ helmc generate --force wordpress
```

## Access your WordPress application

You should now be able to access the application using the external IP configured for the WordPress service.

> Note:
>
> On GKE, the service will automatically configure a firewall rule so that the WordPress instance is accessible from the internet, for which you will be charged additionally.
>
> On other cloud platforms you may have to setup a firewall rule manually. Please refer your cloud providers documentation.

Get the external IP address of your WordPress instance using:

```bash
$ kubectl get services wordpress
NAME      CLUSTER_IP      EXTERNAL_IP       PORT(S)         SELECTOR      AGE
wordpress    10.63.246.116   146.148.20.117    80/TCP,443/TCP  app=wordpress    15m
```

Access your WordPress deployment using the IP address listed under the `EXTERNAL_IP` column.

The default credentials are:

 - Username: `user`
 - Password: `bitnami`

## Cleanup

To delete the WordPress deployment completely:

```bash
$ helmc uninstall -n default wordpress
```

Additionally you may want to [Cleanup the MariaDB Chart](https://github.com/bitnami/charts/tree/master/mariadb#cleanup)
