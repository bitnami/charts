# Rabbitmq

> RabbitMQ is an open source message broker software that implements the Advanced Message Queuing Protocol (AMQP).

Based on the [Bitnami RabbitMQ](https://github.com/bitnami/bitnami-docker-rabbitmq) image for docker, this Chart bootstraps a [RabbitMQ](https://www.rabbitmq.com/) deployment on a [Kubernetes](http://kubernetes.io) cluster using [Helm Classic](https://helm.sh).

## Persistence

> *You may skip this section if your only interested in testing the Joomla Chart and have not yet made the decision to use it for your production workloads.*

For persistence of the RabbitMQ configuration, mount a [storage volume](http://kubernetes.io/v1.0/docs/user-guide/volumes.html) at the `/bitnami/rabbitmq` path of the RabbitMQ pod.

By default the RabbitMQ Chart mounts an [emptyDir](http://kubernetes.io/docs/user-guide/volumes/#emptydir) volume.

## Configuration

To edit the default RabbitMQ configuration, run

```bash
$ helmc edit rabbitmq
```

Here you can update the RabbitMQ admin username and password in `tpl/values.toml`. When not specified, the default values are used.

Refer to the Environment variables](https://github.com/bitnami/bitnami-docker-rabbitmq/#environment-variables) section of the [Bitnami RabbitMQ](https://github.com/bitnami/bitnami-docker-rabbitmq) image for the default values.

> Tip: If you have issues running the above command, add `se autochdir` to your `~/.vimrc` profile or simply edit `~/.helmc/workspace/charts/rabbitmq/tpl/values.toml` in your favourite editor.

Finally, generate the chart to apply your changes to the configuration.

```bash
$ helmc generate --force rabbitmq
```

## Access your RabbitMQ server

You should now be able to access the manager interface using the external IP configured for the RabbitMQ service.

> Note:
>
> On GKE, the service will automatically configure a firewall rule so that the RabbitMQ instance is accessible from the internet, for which you will be charged additionally.
>
> On other cloud platforms you may have to setup a firewall rule manually. Please refer your cloud providers documentation.

Get the external IP address of your RabbitMQ instance using:

```bash
$ kubectl get services rabbitmq
NAME      CLUSTER_IP      EXTERNAL_IP       PORT(S)      AGE
rabbitmq  10.63.246.116   146.148.20.117    15672/TCP    15m
```

Access your RabbitMQ deployment using the IP address listed under the `EXTERNAL_IP` column.

The default credentials are:

 - Username: `user`
 - Password: `bitnami`

## Cleanup

To delete the RabbitMQ deployment completely:

```bash
$ helmc uninstall -n default rabbitmq
```
