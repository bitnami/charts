# Bitnami Common Library Chart

A [Helm Library Chart](https://helm.sh/docs/topics/library_charts/#helm) for grouping common logic between bitnami charts.

## TL;DR;

```yaml
dependencies:
  - name: common
    version: 0.1.0
    repository: https://charts.bitnami.com/bitnami
```

```bash
$ helm dependency update
```

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "common.names.fullname" . }}
data:
  myvalue: "Hello World"
```

## Introduction

This chart provides a common template helpers which can be used to develop new charts using [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This Helm chart has been tested on top of [Bitnami Kubernetes Production Runtime](https://kubeprod.io/) (BKPR). Deploy BKPR to get automated TLS certificates, logging and monitoring for your applications.

## Prerequisites

- Kubernetes 1.12+
- Helm 2.16+ or Helm 3.0-beta3+

## Parameters

The following table lists the helpers available in the library which are scoped in different sections.

**Names**
| Helper identifier                           | Description                                                | Expected Input                                                                                                                                           |
|---------------------------------------------|------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------|
| `common.names.name`                         | Expand the name of the chart or use `.Values.nameOverride` | `.` Chart context                                                                                                                                        |
| `common.names.fullname`                     | Create a default fully qualified app name.                 | `.` Chart context                                                                                                                                        |
| `common.names.chart`                        | Chart name plus version                                    | `.` Chart context                                                                                                                                        |

**Images**
| Helper identifier                           | Description                                                | Expected Input                                                                                                                                           |
|---------------------------------------------|------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------|
| `common.images.image`                       | Return the proper and full image name                      | `dict "imageRoot" .Values.path.to.the.image "global" $`, see [ImageRoot](#imageRoot) for the structure.                                                  |
| `common.images.pullSecrets`                 | Return the proper Docker Image Registry Secret Names       | `dict "images" (list .Values.path.to.the.image1, .Values.path.to.the.image2) "global" $`                                                                 |

**Labels**
| Helper identifier                           | Description                                                | Expected Input                                                                                                                                           |
|---------------------------------------------|------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------|
| `common.labels.standard`                    | Return Kubernetes standard labels                          | `.` Chart context                                                                                                                                        |
| `common.labels.matchLabels`                 | Return the proper Docker Image Registry Secret Names       | `.` Chart context                                                                                                                                        |

**Storage**
| Helper identifier                           | Description                                                | Expected Input                                                                                                                                           |
|---------------------------------------------|------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------|
| `common.storage.class`                      | Return the proper Storage Class                            | `dict "persistence" .Values.path.to.the.persistence "global" $`, see [Persistence](#persistence) for the structure.                                      |

**TplValues**
| Helper identifier                           | Description                                                | Expected Input                                                                                                                                           |
|---------------------------------------------|------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------|
| `common.tplvalues.render`                   | Renders a value that contains template                     | `dict "value" .Values.path.to.the.Value "context" $`, value is the value should rendered as template, context frecuently is the chart context `$` or `.` |

**Capabilities**
| Helper identifier                           | Description                                                | Expected Input                                                                                                                                           |
|---------------------------------------------|------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------|
| `common.capabilities.deployment.apiVersion` | Return the appropriate apiVersion for deployment.          | `.` Chart context                                                                                                                                        |

## Special input schemas

### ImageRoot

```yaml
registry: 
  type: string
  description: Docker registry where the image is located
  example: docker.io

repository:
  type: string
  description: Repository and image name
  example: bitnami/nginx

tag:
  type: string
  description: image tag
  example: 1.16.1-debian-10-r63

pullPolicy:
  type: string
  description: Specify a imagePullPolicy. Defaults to 'Always' if image tag is 'latest', else set to 'IfNotPresent'

pullSecrets:
  type: array
  items:
    type: string
  description: Optionally specify an array of imagePullSecrets.

debug:
  type: boolean
  description: Set to true if you would like to see extra information on logs
  example: false

## An instance would be:
# registry: docker.io
# repository: bitnami/nginx
# tag: 1.16.1-debian-10-r63
# pullPolicy: IfNotPresent
# debug: false
```

### Persistence

```yaml
enabled:
  type: boolean
  description: Whether enable persistence.
  example: true

storageClass:
  type: string
  description: Ghost data Persistent Volume Storage Class, If set to "-", storageClassName: "" which disables dynamic provisioning.
  example: "-"
 
accessMode:
  type: string
  description: Access mode for the Persistent Volume Storage.
  example: ReadWriteOnce

size:
  type: string
  description: Size the Persistent Volume Storage.
  example: 8Gi

path:
  type: string
  description: Path to be persisted.
  example: /bitnami

## An instance would be:
# enabled: true
# storageClass: "-"
# accessMode: ReadWriteOnce
# size: 8Gi
# path: /bitnami
```

## Notable changes

N/A
