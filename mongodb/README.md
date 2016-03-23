# MongoDB

> MongoDB is a cross-platform document-oriented database. Classified as a NoSQL database, MongoDB eschews the traditional table-based relational database structure in favor of JSON-like documents with dynamic schemas, making the integration of data in certain types of applications easier and faster.

Based on the [Bitnami MongoDB](https://github.com/bitnami/bitnami-docker-mongodb) image for docker, this Chart bootstraps a [MongoDB](https://mongodb.com/) deployment on a [Kubernetes](http://kubernetes.io) cluster using [Helm](https://helm.sh).

## Persistence

For persistence of the MongoDB data, mount a [storage volume](http://kubernetes.io/docs/user-guide/volumes/) at the `/bitnami/mongodb/data` path of the MongoDB pod.

By default the MongoDB Chart mounts an [emptyDir](http://kubernetes.io/docs/user-guide/volumes/#emptydir) volume.

## Configuration

To edit the default MongoDB configuration, run

```bash
$ helm edit mongodb
```

Configurable parameters can be specified in `tpl/values.toml`. If not specified default values as defined by the [Bitnami MongoDB](https://github.com/bitnami/bitnami-docker-mongodb) image are used.

> Tip: If you have issues running the above command, add `se autochdir` to your `~/.vimrc` profile or simply edit `~/.helm/workspace/charts/mongodb/tpl/values.toml` in your favourite editor.

Finally, generate the chart to apply your changes to the configuration.

```bash
$ helm generate mongodb
```

## Cleanup

To delete the MongoDB deployment completely:

```bash
$ helm uninstall -n default mongodb
```
