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

> Note:
>
> Phabricator service needs to know the Load Balancer IP to be configured properly. That's why you need to create a public address before you install the Phabricator Helm Chart.
>
> On GKE, you can can reserve a static external address and then specify that as the loadBalancerIP of a service. More information at [https://cloud.google.com/compute/docs/configure-instance-ip-addresses]
>
> On other cloud platforms you may have to setup a firewall rule manually. Please refer your cloud providers documentation.

Reserve a static external address using:

```bash
$ gcloud compute addresses create phabricator-public-ip
Created [https://www.googleapis.com/compute/v1/...].
---
address: 104.197.39.194
creationTimestamp: '2016-08-12T03:02:30.702-07:00'
description: ''
id: '8563442497282383961'
kind: compute#address
name: phabricator-public-ip
region: ...
status: RESERVED
```

Edit values.toml and update phabricatorHost with the public IP you reserved before (104.197.39.194 in this example), regenerate the chart and install.
```bash
$ helmc generate --force phabricator
$ helmc install phabricator
```

> Note:
>
> If you want to use a FQDN associated the IP reserved for the Load Balancer. You need to configure Phabricator service properly.


Edit values.toml and update phabricatorHost with the FQDN associated to the reserved IP, regenerate the chart and install.
```bash
$ helmc generate --force phabricator
$ helmc install phabricator
```

You should now be able to access the application using the external IP reserved for the Phabricator service (or the FQDN if configured).
The default credentials are:

 - Username: `user`
 - Password: `bitnami1`

## Cleanup

To delete the Phabricator deployment completely:

```bash
$ helmc uninstall -n default phabricator
```

Additionally you may want to [Cleanup the MariaDB Chart](https://github.com/bitnami/charts/tree/master/mariadb#cleanup)
