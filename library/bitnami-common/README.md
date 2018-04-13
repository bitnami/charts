# Bitnami Common

This chart just defines a set of templates so that they can be reused in other charts.

## Available templates

The following table lists the available templates defined in the Bitnami Common chart.

| Parameter                     | Description                                                                         | Default                |
| ----------------------------- | ----------------------------------------------------------------------------------- | ---------------------- |
| `externaldb.host`             | Return the secret key containing the database host given a service broker type      | `host`                 |
| `externaldb.port`             | Return the secret key containing the database port given a service broker type      | `port`                 |
| `externaldb.username`         | Return the secret key containing the database user given a service broker type      | `username`             |
| `externaldb.password`         | Return the secret key containing the database password given a service broker type  | `password`             |

> In order to see an example of how to use this template take a look at the [bitnami/node](https://github.com/bitnami/charts/tree/master/bitnami/node) chart