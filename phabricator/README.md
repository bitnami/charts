# Phabricator

> Phabricator is a collection of open source web applications that help software companies build better software. Phabricator is built by developers for developers. Every feature is optimized around developer efficiency for however you like to work. Code Quality starts with effective collaboration between team members.

Based on the [Bitnami Phabricator](https://github.com/bitnami/bitnami-docker-phabricator) image for docker, this Chart bootstraps a [Phabricator](https://phabricator.org/) deployment on a [Kubernetes](https://kubernetes.io) cluster using [Helm](https://helm.sh).

## Dependencies

The Phabricator Chart requires the [Bitnami MariaDB Chart](https://github.com/bitnami/charts/tree/master/mariadb) for setting up a database backend.

Please refer to the [README](https://github.com/bitnami/charts/tree/master/mariadb) of the Bitnami MariaDB Chart for deployment instructions.

## Persistence

> *You may skip this section if your only interested in testing the Phabricator Chart and have not yet made the decision to use it for your production workloads.*

For persistence of the Phabricator configuration and user file uploads, mount a [storage volume](http://kubernetes.io/v1.0/docs/user-guide/volumes.html) at the `/bitnami/phabricator` path of the Phabricator pod.

By default the Phabricator Chart mounts an [emptyDir](http://kubernetes.io/docs/user-guide/volumes/#emptydir) volume.

## Configuration

To edit the default Phabricator configuration, run

```bash
$ helmc edit phabricator
```

Here you can update the Phabricator admin username, password and email address in `tpl/values.toml`. When not specified, the default values are used.

Refer to the [Environment variables](https://github.com/bitnami/bitnami-docker-phabricator/#environment-variables) section of the [Bitnami Phabricator](https://github.com/bitnami/bitnami-docker-phabricator) image for the default values.

The values of `phabricatorUser` and `phabricatorPassword` are the login credentials when you [access the Phabricator instance](#access-your-phabricator-application).

Finally, generate the chart to apply your changes to the configuration.

```bash
$ helmc generate --force phabricator
```

## Access your Phabricator application

You should now be able to access the application using the external IP configured for the Phabricator service.

> Note:
>
> On GKE, the service will automatically configure a firewall rule so that the Phabricator instance is accessible from the internet, for which you will be charged additionally.
>
> On other cloud platforms you may have to setup a firewall rule manually. Please refer your cloud providers documentation.

Get the external IP address of your Phabricator instance using:

```bash
$ kubectl get services phabricator
NAME      CLUSTER_IP      EXTERNAL_IP       PORT(S)         SELECTOR      AGE
phabricator    10.63.246.116   146.148.20.117    80/TCP,443/TCP  app=phabricator    15m
```

Access your Phabricator deployment using the IP address listed under the `EXTERNAL_IP` column.

The default credentials are:

 - Username: `user`
 - Password: `bitnami1`

## Cleanup

To delete the Phabricator deployment completely:

```bash
$ helmc uninstall -n default phabricator
```

Additionally you may want to [Cleanup the MariaDB Chart](https://github.com/bitnami/charts/tree/master/mariadb#cleanup)
