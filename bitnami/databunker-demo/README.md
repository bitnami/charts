# Databunker DEMO

[Databunker](https://databunker.org) is a free and open source, secure vault and SDK to store customer records built to comply with GDPR.

## TL;DR

```bash
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install databunker-demo bitnami/databunker-demo
```

## Introduction

This char bootstraps a demo version of Databunker deployed on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Uninstalling the Chart

To uninstall/delete the `databunker-demo` deployment:

```console
$ helm delete databunker-demo
```
The command removes all the Kubernetes components associated with the chart and deletes the release. Remove also the chart using `--purge` option:

```console
$ helm delete --purge databunker-demo
```
 
### Exposure parameters

| Name                            | Description                                                                                                                      | Value                    |
| ------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `service.type`                  | Databunker Service Type                                                                                                 | `ClusterIP`              |
| `service.nodePorts.http`        | Node port for HashiCorp Consul UI                                                                                                | `"30300"`   
