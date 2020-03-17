# Discourse Helm Chart

> **Note**: This is a Helm 3 chart. Not using Helm 3? Time to upgrade.

[Discourse](https://www.discourse.org/) is an opensource forum software.

## Chart Details
This chart will provision a fully functional and fully featured Discourse installation
that can deploy and manage applications in the cluster that it is deployed to.

Redis and Postgres are used.

For more information on Discourse and its capabilities, see it's [documentation](https://docs.discourse.org/) as well as the [documentation](https://github.com/bitnami/bitnami-docker-discourse#configuration) for the Bitnami Discourse image.

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release .
```

Discourse is pretty insistent on accessing it via port 80 or 443. This is fine if you're hosting it on a public cluster, but if you want to test it locally with a port forward you need to fight it.

The easiest [but horribly insecure] way to do it it is to simply allow kubectl to bind to privileged ports and then use a `port-forward`:

```bash
sudo setcap CAP_NET_BIND_SERVICE=+eip $(which kubectl)
kubectl portforward svc/discourse 80:3000
```

## Configuration

Configurable values are documented in the `values.yaml`.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml .
```

> **Tip**: You can use the default [values.yaml](values.yaml)
