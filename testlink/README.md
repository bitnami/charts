# Testlink

> TestLink is a web-based test management system that facilitates software quality assurance. It is developed and maintained by Teamtest. The platform offers support for test cases, test suites, test plans, test projects and user management, as well as various reports and statistics.

Based on the [Bitnami Testlink](https://github.com/bitnami/bitnami-docker-testlink) image for docker, this Chart bootstraps a [Testlink](https://testlink.org/) deployment on a [Kubernetes](https://kubernetes.io) cluster using [Helm](https://helm.sh).

## Dependencies

The Testlink Chart requires the [Bitnami MariaDB Chart](https://github.com/bitnami/charts/tree/master/mariadb) for setting up a database backend.

Please refer to the [README](https://github.com/bitnami/charts/tree/master/mariadb) of the Bitnami MariaDB Chart for deployment instructions.

## Persistence

> *You may skip this section if your only interested in testing the Testlink Chart and have not yet made the decision to use it for your production workloads.*

For persistence of the Testlink configuration and user file uploads, mount a [storage volume](http://kubernetes.io/v1.0/docs/user-guide/volumes.html) at the `/bitnami/testlink` path of the Testlink pod.

By default the Testlink Chart mounts an [emptyDir](http://kubernetes.io/docs/user-guide/volumes/#emptydir) volume.

## Configuration

To edit the default Testlink configuration, run

```bash
$ helmc edit testlink
```

Here you can update the MariaDB root password, Testlink admin username, password and email address in `tpl/values.toml`. When not specified, the default values are used.

Refer to the [Environment variables](https://github.com/bitnami/bitnami-docker-testlink/#environment-variables) section of the [Bitnami Testlink](https://github.com/bitnami/bitnami-docker-testlink) image for the default values.

The values of `testlinkUser` and `testlinkPassword` are the login credentials when you [access the Testlink instance](#access-your-testlink-application).

> Note:
>
> If you had updated the MariaDB root password for the MariaDB deployment, then ensure you set the same password for the `mariadbRootPassword` field in the Testlink Chart.

Finally, generate the chart to apply your changes to the configuration.

```bash
$ helmc generate --force testlink
```

## Access your Testlink application

You should now be able to access the application using the external IP configured for the Testlink service.

> Note:
>
> On GKE, the service will automatically configure a firewall rule so that the Testlink instance is accessible from the internet, for which you will be charged additionally.
>
> On other cloud platforms you may have to setup a firewall rule manually. Please refer your cloud providers documentation.

Get the external IP address of your Testlink instance using:

```bash
$ kubectl get services testlink
NAME      CLUSTER_IP      EXTERNAL_IP       PORT(S)         SELECTOR      AGE
testlink    10.63.246.116   146.148.20.117    80/TCP,443/TCP  app=testlink    15m
```

Access your Testlink deployment using the IP address listed under the `EXTERNAL_IP` column.

The default credentials are:

 - Username: `user`
 - Password: `bitnami`

## Cleanup

To delete the Testlink deployment completely:

```bash
$ helmc uninstall -n default testlink
```

Additionally you may want to [Cleanup the MariaDB Chart](https://github.com/bitnami/charts/tree/master/mariadb#cleanup)
