# MediaWiki

> MediaWiki is an extremely powerful, scalable software and a feature-rich wiki implementation that uses PHP to process and display data stored in a database, such as MySQL.

Based on the [Bitnami MediaWiki](https://github.com/bitnami/bitnami-docker-mediawiki) image for docker, this Chart bootstraps a [MediaWiki](https://mediawiki.org/) deployment on a [Kubernetes](https://kubernetes.io) cluster using [Helm](https://helm.sh).

## Dependencies

The MediaWiki Chart requires the [Bitnami MariaDB Chart](https://github.com/bitnami/charts/tree/master/mariadb) for setting up a database backend.

Please refer to the [README](https://github.com/bitnami/charts/tree/master/mariadb) of the Bitnami MariaDB Chart for deployment instructions.

## Persistence

> *You may skip this section if your only interested in testing the MediaWiki Chart and have not yet made the decision to use it for your production workloads.*

For persistence of the MediaWiki configuration and user file uploads, mount a [storage volume](http://kubernetes.io/v1.0/docs/user-guide/volumes.html) at the `/bitnami/mediawiki` path of the MediaWiki pod.

By default the MediaWiki Chart mounts an [emptyDir](http://kubernetes.io/docs/user-guide/volumes/#emptydir) volume.

## Configuration

To edit the default MediaWiki configuration, run

```bash
$ helmc edit mediawiki
```

Here you can update the MariaDB root password, MediaWiki admin username, password and email address in `tpl/values.toml`. When not specified, the default values are used.

Refer to the [Environment variables](https://github.com/bitnami/bitnami-docker-mediawiki/#environment-variables) section of the [Bitnami MediaWiki](https://github.com/bitnami/bitnami-docker-mediawiki) image for the default values.

The values of `mediawikiUser` and `mediawikiPassword` are the login credentials when you [access the MediaWiki instance](#access-your-mediawiki-application).

> Note:
>
> If you had updated the MariaDB root password for the MariaDB deployment, then ensure you set the same password for the `mariadbRootPassword` field in the MediaWiki Chart.

Finally, generate the chart to apply your changes to the configuration.

```bash
$ helmc generate --force mediawiki
```

## Access your MediaWiki application

You should now be able to access the application using the external IP configured for the MediaWiki service.

> Note:
>
> On GKE, the service will automatically configure a firewall rule so that the MediaWiki instance is accessible from the internet, for which you will be charged additionally.
>
> On other cloud platforms you may have to setup a firewall rule manually. Please refer your cloud providers documentation.

Get the external IP address of your MediaWiki instance using:

```bash
$ kubectl get services mediawiki
NAME         CLUSTER_IP      EXTERNAL_IP       PORT(S)         SELECTOR         AGE
mediawiki    10.63.246.116   146.148.20.117    80/TCP,443/TCP  app=mediawiki    15m
```

Access your MediaWiki deployment using the IP address listed under the `EXTERNAL_IP` column.

The default credentials are:

 - Username: `user`
 - Password: `bitnami1`

## Cleanup

To delete the MediaWiki deployment completely:

```bash
$ helmc uninstall -n default mediawiki
```

Additionally you may want to [Cleanup the MariaDB Chart](https://github.com/bitnami/charts/tree/master/mariadb#cleanup)
