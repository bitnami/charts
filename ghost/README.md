# Ghost

> Ghost is a simple, powerful publishing platform that allows you to share your stories with the world

Based on the [Bitnami Ghost](https://github.com/bitnami/bitnami-docker-ghost) image for docker, this Chart bootstraps a [Ghost](https://ghost.org/) deployment on a [Kubernetes](https://kubernetes.io) cluster using [Helm Classic](https://helm.sh).

## Persistence

> *You may skip this section if your only interested in testing the Ghost Chart and have not yet made the decision to use it for your production workloads.*

For persistence of the Ghost configuration and user file uploads, mount a [storage volume](http://kubernetes.io/v1.0/docs/user-guide/volumes.html) at the `/bitnami/ghost` path of the Ghost pod.

By default the Ghost Chart mounts an [emptyDir](http://kubernetes.io/docs/user-guide/volumes/#emptydir) volume.

## Configuration

To edit the default Ghost configuration, run

```bash
$ helmc edit ghost
```

Here you can update the Ghost admin username, password, email address, language and SMTP settings in `tpl/values.toml`. When not specified, the default values are used.

Refer to the [Environment variables](https://github.com/bitnami/bitnami-docker-ghost/#environment-variables) section of the [Bitnami Ghost](https://github.com/bitnami/bitnami-docker-ghost) image for the default values.

The values of `ghostUser` and `ghostPassword` are the login credentials when you [access the Ghost instance](#access-your-ghost-application).

Finally, generate the chart to apply your changes to the configuration.

```bash
$ helmc generate --force ghost
```

## Access your Ghost application

You should now be able to access the application using the external IP configured for the Ghost service.

> Note:
>
> On GKE, the service will automatically configure a firewall rule so that the Ghost instance is accessible from the internet, for which you will be charged additionally.
>
> On other cloud platforms you may have to setup a firewall rule manually. Please refer your cloud providers documentation.

Get the external IP address of your Ghost instance using:

```bash
$ kubectl get services ghost
NAME    CLUSTER_IP      EXTERNAL_IP       PORT(S)   SELECTOR    AGE
ghost   10.99.240.185   104.197.156.125   80/TCP    app=ghost   3m
```

Access your Ghost deployment using the IP address listed under the `EXTERNAL_IP` column.

The default credentials are:

 - Username: `user@example.com`
 - Password: `bitnami1`

## Cleanup

To delete the Ghost deployment completely:

```bash
$ helmc uninstall -n default ghost
```
