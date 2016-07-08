# LAMP

> A LAMP stack comprised of [PHP](https://github.com/bitnami/bitnami-docker-php-fpm) and [MariaDB](https://github.com/bitnami/bitnami-docker-mariadb)

## Adding your code

This LAMP chart uses a [gitRepo volume](http://kubernetes.io/docs/user-guide/volumes/#gitrepo) to clone PHP source code from an accessible git repository, and serves your application.
You **must** define the `gitRepo` value and point it to a valid git repo to use this chart.

## Connecting to the database

In your PHP application, you should make use of the following environment variables to connect to the MariaDB database:

```
DB_HOST
DB_PORT
DB_DATABASE
DB_USERNAME
DB_PASSWORD
```

## Example usage: deploying a Laravel app

We will be using this chart to deploy the sample Laravel app from https://github.com/prydonius/my-laravel-app. First, we need to create a YAML file that defines the values needed to run this application, save the following in `laravelApp.yaml`:

```
# Options are: none, laravel
phpFramework: laravel
# Link to git repo with application to run
gitRepo: "https://github.com/prydonius/my-laravel-app.git"
```

Next, run the following command to deploy the chart with the sample app to your cluster:

```
helm install lamp --values laravelApp.yaml
```

Once the pod is up and running, you will be able to access the Laravel app through the service exposed.
