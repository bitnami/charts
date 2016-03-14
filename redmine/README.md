# Redmine

> Redmine is a free and open source, web-based project management and issue tracking tool.

This chart bootstraps a [Redmine](https://redmine.org/) deployment on a [Kubernetes](https://kubernetes.io) cluster using [Helm](https://helm.sh).

## Prerequisites

### Kubernetes Cluster

Setup up a Kubernetes cluster on [Google Container Engine](https://cloud.google.com/container-engine/)(GCE) using [these instructions](https://cloud.google.com/container-engine/docs/before-you-begin).

Create a new cluster using:

```bash
$ gcloud container clusters create my-cluster
```

The above command creates a cluster named `my-cluster`. You can name the cluster as per your preference. You may also use an existing cluster.

> For setting up Kubernetes on other cloud platforms or bare-metal servers refer to the Kubernetes [getting started guide](http://kubernetes.io/docs/getting-started-guides/).

### Helm

Dubbed as the Kubernetes Package Manager, Helm bootstraps your Kubernetes cluster with Charts that provide ready-to-use workloads.

To install Helm, refer to the [Helm install guide](https://github.com/helm/helm#installing-helm) and ensure that the `helm` binary is in the `PATH` of your shell.

After installing Helm add the [Bitnami Charts](https://github.com/bitnami/charts) repo to Helm.

```bash
$ helm repo add bitnami https://github.com/bitnami/charts.git
```

If you are an existing user of the Bitnami charts repo, now is a good time to update your charts.

```bash
$ helm update
```

### Dependencies

#### MariaDB

The Redmine chart depends on the MariaDB chart for setting up a database server. As such we'll first deploy the MariaDB chart.

**Step 1**: Fetch the `bitnami/mariadb` chart to your workspace

```bash
$ helm fetch bitnami/mariadb
```

The MariaDB chart will be copied into your workspace, located at `~/.helm/workspace/charts/mariadb/`.

**Step 2 (Optional)**: Change the MariaDB root password

```bash
$ helm edit mariadb
```

The default value of the MariaDB root password is `bitnami`. To change it to your choosing, edit the value of `databasePassword` in `tpl/values.toml`.

> Tip: If you have issues running the above command, add `se autochdir` to your `~/.vimrc` profile or edit the `~/.helm/workspace/charts/mariadb/tpl/values.toml` in your favourite editor.

**Step 3**: Generate the chart

```bash
$ helm generate mariadb
```

The above command will generate the MariaDB chart with your changes from the last step.

**Step 4**: Deploy MariaDB

```bash
$ helm install mariadb
```

In the above command, Helm will deploy the MariaDB chart in the cluster. The deployment status of the MariaDB pods can be checked with `kubectl` using:

```bash
$ kubectl get pods -l provider=mariadb
NAME            READY     STATUS    RESTARTS   AGE
mariadb-3fu51   1/1       Running   0          1m
```

### Deploying the Redmine Chart

Now that we have the MariaDB chart deployed, we can deploy the Redmine chart.

**Step 1**: Fetch the `bitnami/redmine` chart to your workspace

```bash
$ helm fetch bitnami/redmine
```

The Redmine chart will be copied into your workspace, located at `~/.helm/workspace/charts/redmine/`

**Step 2**: Edit the default Redmine configuration

```bash
$ helm edit redmine
```

Here you can update the MariaDB root password, Redmine admin username, password and email address in `tpl/values.toml`, the default values of which are:

 - `databasePassword`: `bitnami`
 - `redmineUser`: `user`
 - `redminePassword`: `bitnami`
 - `redmineEmail`: `user@example.com`

> Note:
>
> If you had updated the MariaDB root password for the MariaDB deployment, then ensure you set the same password for the `databasePassword` field in the Redmine chart.

**Step 3**: Generate the chart

```bash
$ helm generate redmine
```

The above command will generate the Redmine chart with your changes from the last step.

**Step 4**: Deploy Redmine

```bash
$ helm install redmine
```

In the above command, Helm will deploy the Redmine chart in the cluster.

> Note:
>
> On GCE, the above command will automatically configure a firewall rule so that the Redmine instance is accessible from the internet, for which you will be charged additionally.
>
> On other cloud platforms you may have to setup a firewall rule manually. Please refer your cloud providers documentation.

The deployment status of the Redmine pods can be checked with `kubectl` using:

```bash
$ kubectl get pods -l app=redmine
NAME            READY     STATUS    RESTARTS   AGE
redmine-b3jld   1/1       Running   0          1m
```

### Access your Redmine application

You should now be able to access the application using the external ip configured for the Redmine service.

In case of GCE, get the external IP address of your Redmine instance using:

```bash
$ kubectl get services redmine
NAME      CLUSTER_IP      EXTERNAL_IP       PORT(S)   SELECTOR      AGE
redmine   10.99.240.185   104.197.156.125   80/TCP    app=redmine   3m
```

Access your Redmine deployment using the IP address listed under the `EXTERNAL_IP` column.

