# HZP Secrets Helm Chart

## Prerequisites

### Kubernetes and Helm

* On Windows, install https://rancherdesktop.io/. It comes with WSL, K3s and Helm. If you already have WSL or Docker Desktop, 
it is recommended to uninstall all first.  
* On Linux, install https://k3s.io/ and https://helm.sh/

## Make

Download and install http://gnuwin32.sourceforge.net/packages/make.htm

## Configuration

Please refer to [Configuration](../../../README.md#configuration) for configuration set up.

## Installation
> __Note:__ Installation & Uninstallation capability has been moved. Please refer to the Readme file under hzp-eo-charts.

## Check

Check the running pods with:
```
kubectl -n hzp get secrets
```

List all helm chart releases with:
```
helm list
```

## Getting Secrets
To get the value of a secret (eg. postgres-secret):
```
kubectl -n hzp get secret postgres-secret -o jsonpath="{.data.postgres-password}" | base64 --decode
```

## Postgres secrets
Password key in postgres-secret will create a database and role when postgres is bootstrapping.

The format of password key:
```
{database-name}-password: "PWD"
```
e.g: 

to create a `test_db` database and role with `somepassword` 
```
test_db-password: "PWD"
```
