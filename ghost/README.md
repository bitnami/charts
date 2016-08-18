# Ghost

> Ghost is a simple, powerful publishing platform that allows you to share your stories with the world

Based on the [Bitnami Ghost](https://github.com/bitnami/bitnami-docker-ghost) image for docker, this Chart bootstraps a [Ghost](https://ghost.org/) deployment on a [Kubernetes](https://kubernetes.io) cluster using [Helm Classic](https://helm.sh).

## Dependencies

The Ghost Chart requires the [Bitnami MariaDB Chart](https://github.com/bitnami/charts/tree/master/mariadb) for setting up a database backend.

Please refer to the [README](https://github.com/bitnami/charts/tree/master/mariadb) of the Bitnami MariaDB Chart for deployment instructions.

## Persistence

> *You may skip this section if your only interested in testing the Ghost Chart and have not yet made the decision to use it for your production workloads.*

For persistence of the Ghost configuration and user file uploads, mount a [storage volume](http://kubernetes.io/v1.0/docs/user-guide/volumes.html) at the `/bitnami/ghost` path of the Ghost pod.

By default the Ghost Chart mounts an [emptyDir](http://kubernetes.io/docs/user-guide/volumes/#emptydir) volume.

## Configuration

To edit the default Ghost configuration, run

```bash
$ helmc edit ghost
```

Here you can update the Ghost hostname, host IP, host port, admin username, password, email address, language, and SMTP settings in `tpl/values.toml`. When not specified, the default values are used.

Refer to the [Environment variables](https://github.com/bitnami/bitnami-docker-ghost/#environment-variables) section of the [Bitnami Ghost](https://github.com/bitnami/bitnami-docker-ghost) image for the default values.

The values of `ghostUser` and `ghostPassword` are the login credentials when you [access the Ghost instance](#access-your-ghost-application).

Finally, generate the chart to apply your changes to the configuration.

```bash
$ helmc generate --force ghost
```

## Access your Ghost application

> Note:
>
> Ghost service needs to know the Load Balancer IP to be configured properly. That's why you need to create a public address before you install the Ghost Helm Chart. 
>
> On GKE, you can can reserve a static external address and then specify that as the loadBalancerIP of a service. More information at [https://cloud.google.com/compute/docs/configure-instance-ip-addresses] 
>
> On other cloud platforms you may have to setup a firewall rule manually. Please refer your cloud providers documentation.

Reserve a static external address using:

```bash
$ gcloud compute addresses create ghost-public-ip
Created [https://www.googleapis.com/compute/v1/...].
---
address: 104.197.39.194
creationTimestamp: '2016-08-12T03:02:30.702-07:00'
description: ''
id: '8563442497282383961'
kind: compute#address
name: ghost-public-ip
region: ...
status: RESERVED
```

Edit values.toml and update ghostHostIP with the public IP you reserved before (104.197.39.194 in this example), regenerate the chart and install.
```bash
$ helmc generate --force ghost
$ helmc install ghost
```

> Note:
>
> If you want to use a FQDN associated the IP reserved for the Load Balancer. You need to configure Ghost service properly.


Edit values.toml and update ghostHost with the FQDN associated to the reserved IP, regenerate the chart and install.
```bash
$ helmc generate --force ghost
$ helmc install ghost
```

You should now be able to access the application using the external IP reserved for the Ghost service (or the FQDN if configured). 

The default credentials are:

 - Username: `user@example.com`
 - Password: `bitnami1`

## Cleanup

To delete the Ghost deployment completely:

```bash
$ helmc uninstall -n default ghost
```
