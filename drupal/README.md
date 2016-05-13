# Drupal

> Drupal is one of the most versatile open source content management systems on the market.

Based on the [Bitnami Drupal](https://github.com/bitnami/bitnami-docker-drupal) image for docker, this Chart bootstraps a [Drupal](https://drupal.org/) deployment on a [Kubernetes](https://kubernetes.io) cluster using [Helm](https://helm.sh).

## Dependencies

The Drupal Chart requires the [Bitnami MariaDB Chart](https://github.com/bitnami/charts/tree/master/mariadb) for setting up a database backend.

Please refer to the [README](https://github.com/bitnami/charts/tree/master/mariadb) of the Bitnami MariaDB Chart for deployment instructions.

## Persistence

> *You may skip this section if your only interested in testing the Drupal Chart and have not yet made the decision to use it for your production workloads.*

For persistence of the Drupal configuration and user file uploads, mount a [storage volume](http://kubernetes.io/v1.0/docs/user-guide/volumes.html) at the `/bitnami/drupal` path of the Drupal pod.

By default the Drupal Chart mounts an [emptyDir](http://kubernetes.io/docs/user-guide/volumes/#emptydir) volume.

## Configuration

To edit the default Drupal configuration, run

```bash
$ helmc edit drupal
```

Here you can update the MariaDB root password, Drupal admin username, password and email address in `tpl/values.toml`. When not specified, the default values are used.

Refer to the [Environment variables](https://github.com/bitnami/bitnami-docker-drupal/#environment-variables) section of the [Bitnami Drupal](https://github.com/bitnami/bitnami-docker-drupal) image for the default values.

The values of `drupalUser` and `drupalPassword` are the login credentials when you [access the Drupal instance](#access-your-drupal-application).

> Note:
>
> If you had updated the MariaDB root password for the MariaDB deployment, then ensure you set the same password for the `mariadbPassword` field in the Drupal Chart.

Finally, generate the chart to apply your changes to the configuration.

```bash
$ helmc generate --force drupal
```

## Access your Drupal application

You should now be able to access the application using the external IP configured for the Drupal service.

> Note:
>
> On GKE, the service will automatically configure a firewall rule so that the Drupal instance is accessible from the internet, for which you will be charged additionally.
>
> On other cloud platforms you may have to setup a firewall rule manually. Please refer your cloud providers documentation.

Get the external IP address of your Drupal instance using:

```bash
$ kubectl get services drupal
NAME      CLUSTER_IP      EXTERNAL_IP       PORT(S)         SELECTOR      AGE
drupal    10.63.246.116   146.148.20.117    80/TCP,443/TCP  app=drupal    15m
```

Access your Drupal deployment using the IP address listed under the `EXTERNAL_IP` column.

The default credentials are:

 - Username: `user`
 - Password: `bitnami`

## Cleanup

To delete the Drupal deployment completely:

```bash
$ helmc uninstall -n default drupal
```

Additionally you may want to [Cleanup the MariaDB Chart](https://github.com/bitnami/charts/tree/master/mariadb#cleanup)
