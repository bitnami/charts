# Redmine

> Redmine is a free and open source, web-based project management and issue tracking tool.

Based on the [Bitnami Redmine](https://github.com/bitnami/bitnami-docker-redmine) image for docker, this Chart bootstraps a [Redmine](https://redmine.org/) deployment on a [Kubernetes](https://kubernetes.io) cluster using [Helm Classic](https://helm.sh).

## Dependencies

The Redmine Chart requires the [Bitnami MariaDB Chart](https://github.com/bitnami/charts/tree/master/mariadb) for setting up a database backend.

Please refer to the [README](https://github.com/bitnami/charts/tree/master/mariadb) of the Bitnami MariaDB Chart for deployment instructions.

## Persistence

> *You may skip this section if your only interested in testing the Redmine Chart and have not yet made the decision to use it for your production workloads.*

For persistence of the Redmine configuration and user file uploads, mount a [storage volume](http://kubernetes.io/v1.0/docs/user-guide/volumes.html) at the `/bitnami/redmine` path of the Redmine pod.

By default the Redmine Chart mounts an [emptyDir](http://kubernetes.io/docs/user-guide/volumes/#emptydir) volume.

## Configuration

To edit the default Redmine configuration, run

```bash
$ helmc edit redmine
```

Here you can update the MariaDB root password, Redmine admin username, password, email address, language and SMTP settings in `tpl/values.toml`. When not specified, the default values are used.

Refer to the [Environment variables](https://github.com/bitnami/bitnami-docker-redmine/#environment-variables) section of the [Bitnami Redmine](https://github.com/bitnami/bitnami-docker-redmine) image for the default values.

The values of `redmineUser` and `redminePassword` are the login credentials when you [access the Redmine instance](#access-your-redmine-application).

> Note:
>
> If you had updated the MariaDB root password for the MariaDB deployment, then ensure you set the same password for the `mariadbRootPassword` field in the Redmine Chart.

Finally, generate the chart to apply your changes to the configuration.

```bash
$ helmc generate --force redmine
```

## Access your Redmine application

You should now be able to access the application using the external IP configured for the Redmine service.

> Note:
>
> On GKE, the service will automatically configure a firewall rule so that the Redmine instance is accessible from the internet, for which you will be charged additionally.
>
> On other cloud platforms you may have to setup a firewall rule manually. Please refer your cloud providers documentation.

Get the external IP address of your Redmine instance using:

```bash
$ kubectl get services redmine
NAME      CLUSTER_IP      EXTERNAL_IP       PORT(S)   SELECTOR      AGE
redmine   10.99.240.185   104.197.156.125   80/TCP    app=redmine   3m
```

Access your Redmine deployment using the IP address listed under the `EXTERNAL_IP` column.

The default credentials are:

 - Username: `user`
 - Password: `bitnami`

## Cleanup

To delete the Redmine deployment completely:

```bash
$ helmc uninstall -n default redmine
```

Additionally you may want to [Cleanup the MariaDB Chart](https://github.com/bitnami/charts/tree/master/mariadb#cleanup)
