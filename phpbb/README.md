# phpBB

> If you need to build a community forum, try phpBB. First released in 2000, phpBB is a bulletin board solution that allows you to create forums and subforums. phpBB supports the notion of users and groups, file attachments, full-text search, notifications and more. Hundreds of modifications are available including themes, communications add-ons, spam management and more.

Based on the [Bitnami phpBB](https://github.com/bitnami/bitnami-docker-phpbb) image for docker, this Chart bootstraps a [phpBB](https://www.phpbb.com/) deployment on a [Kubernetes](https://kubernetes.io) cluster using [Helm](https://helm.sh).

## Dependencies

The phpBB Chart requires the [Bitnami MariaDB Chart](https://github.com/bitnami/charts/tree/master/mariadb) for setting up a database backend.

Please refer to the [README](https://github.com/bitnami/charts/tree/master/mariadb) of the Bitnami MariaDB Chart for deployment instructions.

## Persistence

> *You may skip this section if your only interested in testing the phpBB Chart and have not yet made the decision to use it for your production workloads.*

For persistence of the phpBB configuration and user file uploads, mount a [storage volume](http://kubernetes.io/v1.0/docs/user-guide/volumes.html) at the `/bitnami/phpbb` path of the phpBB pod.

By default the phpBB Chart mounts an [emptyDir](http://kubernetes.io/docs/user-guide/volumes/#emptydir) volume.

## Configuration

To edit the default phpBB configuration, run

```bash
$ helmc edit phpbb
```

Here you can update the phpBB admin username, password and email address in `tpl/values.toml`. When not specified, the default values are used.

Refer to the [Environment variables](https://github.com/bitnami/bitnami-docker-phpbb/#environment-variables) section of the [Bitnami phpBB](https://github.com/bitnami/bitnami-docker-phpbb) image for the default values.

The values of `phpbbUser` and `phpbbPassword` are the login credentials when you [access the phpBB instance](#access-your-phpbb-application).

Finally, generate the chart to apply your changes to the configuration.

```bash
$ helmc generate --force php
```

## Access your phpBB application

You should now be able to access the application using the external IP configured for the phpBB service.

> Note:
>
> On GKE, the service will automatically configure a firewall rule so that the phpBB instance is accessible from the internet, for which you will be charged additionally.
>
> On other cloud platforms you may have to setup a firewall rule manually. Please refer your cloud providers documentation.

Get the external IP address of your phpBB instance using:

```bash
$ kubectl get services phpbb
NAME      CLUSTER_IP      EXTERNAL_IP       PORT(S)         SELECTOR      AGE
phpbb    10.63.246.116   146.148.20.117    80/TCP,443/TCP  app=phpbb    15m
```

Access your phpBB deployment using the IP address listed under the `EXTERNAL_IP` column.

The default credentials are:

 - Username: `user`
 - Password: `bitnami`

## Cleanup

To delete the phpBB deployment completely:

```bash
$ helmc uninstall -n default phpbb
```

Additionally you may want to [Cleanup the MariaDB Chart](https://github.com/bitnami/charts/tree/master/mariadb#cleanup)
