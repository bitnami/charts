# Redmine

> Redmine is a free and open source, web-based project management and issue tracking tool.

Based on the [Bitnami Redmine](https://github.com/bitnami/redmine) image for docker, this Chart bootstraps a [Redmine](https://redmine.org/) deployment on a [Kubernetes](https://kubernetes.io) cluster using [Helm](https://helm.sh).

## TL;DR;

### Step 1. Deploy MariaDB Chart

```bash
$ helm fetch bitnami/mariadb
$ helm generate mariadb
$ helm install mariadb
```

### Step 2. Deploy Redmine Chart

```bash
$ helm fetch bitnami/redmine
$ helm generate redmine
$ helm install redmine
```

The above commands will deploy the MariaDB and Redmine Charts to the `default` kubernetes namespace.

Get the external IP address of your Redmine instance and login using the default credentials:

 - Username: `user`
 - Password: `bitnami`

## Dependencies

The Redmine Chart requires the [Bitnami MariaDB Chart](https://github.com/bitnami/charts/tree/master/mariadb) for setting up a database backend.

Please refer to the [README](https://github.com/bitnami/charts/tree/master/mariadb) of the Bitnami MariaDB Chart for deployment instructions.

## Persistence

> *You may skip this section if your only interested in testing the Redmine Chart and have not yet made the decision to use it for your production workloads.*

For persistence of the Redmine configuration and user file uploads, mount a [storage volume](http://kubernetes.io/v1.0/docs/user-guide/volumes.html) at the `/bitnami/redmine` path of the Redmine pod.

By default the Redmine Chart mounts an [emptyDir](http://kubernetes.io/docs/user-guide/volumes/#emptydir) volume.

From the `emptyDir` documentation: *"An emptyDir volume is first created when a Pod is assigned to a Node, and exists as long as that Pod is running on that node... When a Pod is removed from a node for any reason, the data in the emptyDir is deleted forever."*

To persist your Redmine data across Pod shutdown and startup we need to mount a persistent storage volume at `/bitnami/redmine`. For the purpose of demonstration we'll use a [gcePersistentDisk](http://kubernetes.io/docs/user-guide/volumes/#gcepersistentdisk).

Create a GCE PD using:

```bash
$ gcloud compute disks create --size=500GB --zone=us-central1-a redmine-data-disk
```

> Note: You will be charged additionally for this volume.

## Deploying the Chart

Once you have MariaDB deployed and optionally created a persistent storage disk for Redmine, we are ready to deploy the Bitnami Redmine Chart.

### Step 1. Fetch the Redmine Chart to your workspace

```bash
$ helm fetch bitnami/redmine
```

The Redmine Chart will be copied into your workspace, located at `~/.helm/workspace/charts/redmine/`

### Step 2. Edit the default Redmine configuration

```bash
$ helm edit redmine
```

Here you can update the MariaDB root password, Redmine admin username, password, email address and language in `tpl/values.toml`. When not specified, the default values are:

 - `mariadbPassword`: `bitnami`
 - `redmineUser`: `user`
 - `redminePassword`: `bitnami`
 - `redmineEmail`: `user@example.com`
 - `redmineLanguage`: `en`

The values of `redmineUser` and `redminePassword` are the login credentials when you [access the Redmine instance](#access-your-redmine-application).

> Note:
>
> If you had updated the MariaDB root password for the MariaDB deployment, then ensure you set the same password for the `mariadbPassword` field in the Redmine Chart.

If you had [setup a GCE PD](#Persistence), you will need to update the `tpl/mariadb-controller.yaml` as well.

Replace:

```yaml
      volumes:
      - name: data
        emptyDir: {}
```

with

```yaml
      volumes:
      - name: data
        gcePersistentDisk:
          pdName: redmine-data-disk
          fsType: ext4
```

### Step 3. Generate the Chart

```bash
$ helm generate redmine
```

The above command will generate the Redmine Chart with your changes from the last step.

### Step 4. Deploy Redmine

```bash
$ helm install redmine
```

In the above command, Helm will deploy the Redmine Chart in the cluster in the `default` namespace.

> Note:
>
> On GKE, the above command will automatically configure a firewall rule so that the Redmine instance is accessible from the internet, for which you will be charged additionally.
>
> On other cloud platforms you may have to setup a firewall rule manually. Please refer your cloud providers documentation.

The deployment status of the Redmine pods can be checked with `kubectl` using:

```bash
$ kubectl get pods -l app=redmine
NAME            READY     STATUS    RESTARTS   AGE
redmine-b3jld   1/1       Running   0          1m
```

## Access your Redmine application

You should now be able to access the application using the external IP configured for the Redmine service.

In the case of GKE, get the external IP address of your Redmine instance using:

```bash
$ kubectl get services redmine
NAME      CLUSTER_IP      EXTERNAL_IP       PORT(S)   SELECTOR      AGE
redmine   10.99.240.185   104.197.156.125   80/TCP    app=redmine   3m
```

Access your Redmine deployment using the IP address listed under the `EXTERNAL_IP` column.

## Cleanup

To delete the Redmine deployment completely:

### Step 1. Uninstall the Redmine Chart:

```bash
$ helm uninstall -n default redmine
```

### Step 2. Delete the persistent disk:

```bash
$ gcloud compute disks delete redmine-data-disk
```

Additionally you may want to [Cleanup the MariaDB Chart](https://github.com/bitnami/charts/tree/master/mariadb#cleanup)
