# Odoo

> Odoo is a suite of web based open source business apps. The main Odoo Apps include an Open Source CRM, Website Builder, eCommerce, Project Management, Billing & Accounting, Point of Sale, Human Resources, Marketing, Manufacturing, Purchase Management, ...

> Odoo Apps can be used as stand-alone applications, but they also integrate seamlessly so you get a full-featured Open Source ERP when you install several Apps.

Based on the [Bitnami Odoo](https://github.com/bitnami/bitnami-docker-odoo) image for docker, this Chart bootstraps a [Odoo](https://odoo.com/) deployment on a [Kubernetes](https://kubernetes.io) cluster using [Helm Classic](https://helm.sh).

## Dependencies

The Odoo Chart requires the [Bitnami PostgreSQL Chart](https://github.com/bitnami/charts/tree/master/postgresql) for setting up a database backend.

Please refer to the [README](https://github.com/bitnami/charts/tree/master/postgresql) of the Bitnami PostgreSQL Chart for deployment instructions.

## Persistence

> *You may skip this section if your only interested in testing the Odoo Chart and have not yet made the decision to use it for your production workloads.*

For persistence of the Odoo configuration and user file uploads, mount a [storage volume](http://kubernetes.io/v1.0/docs/user-guide/volumes.html) at the `/bitnami/odoo` path of the Odoo pod.

By default the Odoo Chart mounts an [emptyDir](http://kubernetes.io/docs/user-guide/volumes/#emptydir) volume.

## Configuration

To edit the default Odoo configuration, run

```bash
$ helmc edit odoo
```

Here you can update the PostgreSQL root password, Odoo admin email address, password and SMTP settings in `tpl/values.toml`. When not specified, the default values are used.

Refer to the [Environment variables](https://github.com/bitnami/bitnami-docker-odoo/#environment-variables) section of the [Bitnami Odoo](https://github.com/bitnami/bitnami-docker-odoo) image for the default values.

The values of `odooEmail` and `odooPassword` are the login credentials when you [access the Odoo instance](#access-your-odoo-application).

> Note:
>
> If you had updated the PostgreSQL root password for the PostgreSQL deployment, then ensure you set the same password for the `postgresqlRootPassword` field in the Odoo Chart.

Finally, generate the chart to apply your changes to the configuration.

```bash
$ helmc generate --force odoo
```

## Access your Odoo application

You should now be able to access the application using the external IP configured for the Odoo service.

> Note:
>
> On GKE, the service will automatically configure a firewall rule so that the Odoo instance is accessible from the internet, for which you will be charged additionally.
>
> On other cloud platforms you may have to setup a firewall rule manually. Please refer your cloud providers documentation.

Get the external IP address of your Odoo instance using:

```bash
$ kubectl get services odoo
NAME      CLUSTER_IP      EXTERNAL_IP       PORT(S)   SELECTOR      AGE
odoo     10.99.240.185   104.197.156.125    80/TCP    app=odoo     3m
```

Access your Odoo deployment using the IP address listed under the `EXTERNAL_IP` column.

The default credentials are:

 - Username: `user`
 - Password: `bitnami`

## Cleanup

To delete the Odoo deployment completely:

```bash
$ helmc uninstall -n default odoo
```

Additionally you may want to [Cleanup the PostgreSQL Chart](https://github.com/bitnami/charts/tree/master/postgresql#cleanup)
