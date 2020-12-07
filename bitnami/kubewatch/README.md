# kubewatch

[kubewatch](https://github.com/bitnami-labs/kubewatch) is a Kubernetes watcher that currently publishes notification to Slack. Run it in your k8s cluster, and you will get event notifications in a slack channel.

## TL;DR

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/kubewatch
```

## Introduction

This chart bootstraps a kubewatch deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.12+
- Helm 3.0-beta3+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install my-release bitnami/kubewatch
```

The command deploys kubewatch on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

The following tables lists the configurable parameters of the Kubewatch chart and their default values per section/component:

### Global parameters

| Parameter                               | Description                                                | Default                                                 |
|-----------------------------------------|------------------------------------------------------------|---------------------------------------------------------|
| `global.imageRegistry`                  | Global Docker image registry                               | `nil`                                                   |
| `global.imagePullSecrets`               | Global Docker registry secret names as an array            | `[]` (does not add image pull secrets to deployed pods) |

### Common parameters

| Parameter                               | Description                                                | Default                                                 |
|-----------------------------------------|------------------------------------------------------------|---------------------------------------------------------|
| `nameOverride`                          | String to partially override common.names.fullname         | `nil`                                                   |
| `fullnameOverride`                      | String to fully override common.names.fullname             | `nil`                                                   |
| `commonLabels`                          | Labels to add to all deployed objects                      | `{}`                                                    |
| `commonAnnotations`                     | Annotations to add to all deployed objects                 | `{}`                                                    |
| `clusterDomain`                         | Default Kubernetes cluster domain                          | `cluster.local`                                         |
| `extraDeploy`                           | Array of extra objects to deploy with the release          | `[]` (evaluated as a template)                          |

### Kubewatch parameters

| Parameter                               | Description                                                                              | Default                                                 |
|-----------------------------------------|------------------------------------------------------------------------------------------|---------------------------------------------------------|
| `image.registry`                        | Kubewatch image registry                                                                 | `docker.io`                                             |
| `image.repository`                      | Kubewatch image name                                                                     | `bitnami/kubewatch`                                     |
| `image.tag`                             | Kubewatch image tag                                                                      | `{TAG_NAME}`                                            |
| `image.pullPolicy`                      | Kubewatch image pull policy                                                              | `IfNotPresent`                                          |
| `image.pullSecrets`                     | Specify docker-registry secret names as an array                                         | `[]` (does not add image pull secrets to deployed pods) |
| `slack.enabled`                         | Enable Slack notifications                                                               | `true`                                                  |
| `slack.channel`                         | Slack channel to notify                                                                  | `""`                                                    |
| `slack.token`                           | Slack API token                                                                          | `""`                                                    |
| `hipchat.enabled`                       | Enable HipChat notifications                                                             | `false`                                                 |
| `hipchat.url`                           | HipChat URL                                                                              | `""`                                                    |
| `hipchat.room`                          | HipChat room to notify                                                                   | `""`                                                    |
| `hipchat.token`                         | HipChat token                                                                            | `""`                                                    |
| `mattermost.enabled`                    | Enable Mattermost notifications                                                          | `false`                                                 |
| `mattermost.channel`                    | Mattermost channel to notify                                                             | `""`                                                    |
| `mattermost.username`                   | Mattermost user to notify                                                                | `""`                                                    |
| `mattermost.url`                        | Mattermost URL                                                                           | `""`                                                    |
| `flock.enabled`                         | Enable Flock notifications                                                               | `false`                                                 |
| `flock.url`                             | Flock URL                                                                                | `""`                                                    |
| `msteams.enabled`                       | Enable Microsoft Teams notifications                                                     | `false`                                                 |
| `msteams.webhookurl`                    | Microsoft Teams webhook URL                                                              | `""`                                                    |
| `webhook.enabled`                       | Enable Webhook notifications                                                             | `false`                                                 |
| `webhook.url`                           | Webhook URL                                                                              | `""`                                                    |
| `smtp.enabled`                          | Enable SMTP (email) notifications                                                        | `false`                                                 |
| `smtp.to`                               | Destination email address (required)                                                     | `""`                                                    |
| `smtp.from`                             | Source email address (required)                                                          | `""`                                                    |
| `smtp.smarthost`                        | SMTP server address (name:port) (required)                                               | `""`                                                    |
| `smtp.hello`                            | SMTP hello field (optional)                                                              | `""`                                                    |
| `smtp.auth.username`                    | Username for LOGIN and PLAIN auth mech                                                   | `""`                                                    |
| `smtp.auth.password`                    | Password for LOGIN and PLAIN auth mech                                                   | `""`                                                    |
| `smtp.auth.identity`                    | Identity for PLAIN auth mech                                                             | `""`                                                    |
| `smtp.auth.secret`                      | Secret for CRAM-MD5 auth mech                                                            | `""`                                                    |
| `smtp.requireTLS`                       | Force STARTTLS                                                                           | `false`                                                 |
| `namespaceToWatch`                      | namespace to watch, leave it empty for watching all                                      | `""`                                                    |
| `resourcesToWatch`                      | list of resources which kubewatch should watch and notify slack                          | `{pod: true, deployment: true}`                         |
| `resourcesToWatch.pod`                  | watch changes to Pods                                                                    | `true`                                                  |
| `resourcesToWatch.deployment`           | watch changes to Deployments                                                             | `true`                                                  |
| `resourcesToWatch.replicationcontroller`| watch changes to ReplicationControllers                                                  | `false`                                                 |
| `resourcesToWatch.replicaset`           | watch changes to ReplicaSets                                                             | `false`                                                 |
| `resourcesToWatch.daemonset`            | watch changes to DaemonSets                                                              | `false`                                                 |
| `resourcesToWatch.services`             | watch changes to Services                                                                | `false`                                                 |
| `resourcesToWatch.job`                  | watch changes to Jobs                                                                    | `false`                                                 |
| `resourcesToWatch.persistentvolume`     | watch changes to PersistentVolumes                                                       | `false`                                                 |
| `command`                               | Override default container command (useful when using custom images)                     | `nil`                                                   |
| `args`                                  | Override default container args (useful when using custom images)                        | `nil`                                                   |
| `extraEnvVars`                          | Extra environment variables to be set on Kubewatch container                             | `{}`                                                    |
| `extraEnvVarsCM`                        | Name of existing ConfigMap containing extra env vars                                     | `nil`                                                   |
| `extraEnvVarsSecret`                    | Name of existing Secret containing extra env vars                                        | `nil`                                                   |

### Kubewatch deployment parameters

| Parameter                             | Description                                                                                | Default                                                 |
|---------------------------------------|--------------------------------------------------------------------------------------------|---------------------------------------------------------|
| `replicaCount`                        | Number of Kubewatch replicas to deploy                                                     | `1`                                                     |
| `podSecurityContext`                  | Kubewatch pods' Security Context                                                           | Check `values.yaml` file                                |
| `containerSecurityContext`            | Kubewatch containers' Security Context                                                     | Check `values.yaml` file                                |
| `resources.limits`                    | The resources limits for the Kubewatch container                                           | `{}`                                                    |
| `resources.requests`                  | The requested resources for the Kubewatch container                                        | `{}`                                                    |
| `leavinessProbe`                      | Leaviness probe configuration for Kubewatch                                                | Check `values.yaml` file                                |
| `readinessProbe`                      | Readiness probe configuration for Kubewatch                                                | Check `values.yaml` file                                |
| `customLivenessProbe`                 | Override default liveness probe                                                            | `nil`                                                   |
| `customReadinessProbe`                | Override default readiness probe                                                           | `nil`                                                   |
| `podAffinityPreset`                   | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`        | `""`                                                    |
| `podAntiAffinityPreset`               | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`   | `soft`                                                  |
| `nodeAffinityPreset.type`             | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`  | `""`                                                    |
| `nodeAffinityPreset.key`              | Node label key to match. Ignored if `affinity` is set.                                     | `""`                                                    |
| `nodeAffinityPreset.values`           | Node label values to match. Ignored if `affinity` is set.                                  | `[]`                                                    |
| `affinity`                            | Affinity for pod assignment                                                                | `{}` (evaluated as a template)                          |
| `nodeSelector`                        | Node labels for pod assignment                                                             | `{}` (evaluated as a template)                          |
| `tolerations`                         | Tolerations for pod assignment                                                             | `[]` (evaluated as a template)                          |
| `podLabels`                           | Extra labels for Kubewatch pods                                                            | `{}`                                                    |
| `podAnnotations`                      | Annotations for Kubewatch pods                                                             | `{}`                                                    |
| `extraVolumeMounts`                   | Optionally specify extra list of additional volumeMounts for Kubewatch container(s)        | `[]`                                                    |
| `extraVolumes`                        | Optionally specify extra list of additional volumes for Kubewatch pods                     | `[]`                                                    |
| `initContainers`                      | Add additional init containers to the Kubewatch pods                                       | `{}` (evaluated as a template)                          |
| `sidecars`                            | Add additional sidecar containers to the Kubewatch pods                                    | `{}` (evaluated as a template)                          |

### RBAC parameters

| Parameter                               | Description                                                         | Default                                                 |
|-----------------------------------------|---------------------------------------------------------------------|---------------------------------------------------------|
| `serviceAccount.create`                 | Enable the creation of a ServiceAccount for Kubewatch pods          | `true`                                                  |
| `serviceAccount.name`                   | Name of the created ServiceAccount                                  | Generated using the `common.names.fullname` template    |
| `rbac.create`                           | Weather to create & use RBAC resources or not                       | `false`                                                 |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install my-release bitnami/kubewatch \
  --set=slack.channel="#bots",slack.token="XXXX-XXXX-XXXX"
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install my-release -f values.yaml bitnami/kubewatch
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Create a Slack bot

Open [https://my.slack.com/services/new/bot](https://my.slack.com/services/new/bot) to create a new Slack bot.
The API token can be found on the edit page (it starts with `xoxb-`).

Invite the Bot to your channel by typing `/join @name_of_your_bot` in the Slack message area.

### Adding extra environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `extraEnvVars` property.

```yaml
extraEnvVars:
  - name: LOG_LEVEL
    value: DEBUG
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values.

### Sidecars and Init Containers

If you have a need for additional containers to run within the same pod as the Kubewatch app (e.g. an additional metrics or logging exporter), you can do so via the `sidecars` config parameter. Simply define your container according to the Kubernetes container spec.

```yaml
sidecars:
  - name: your-image-name
    image: your-image
    imagePullPolicy: Always
    ports:
      - name: portname
       containerPort: 1234
```

Similarly, you can add extra init containers using the `initContainers` parameter.

```yaml
initContainers:
  - name: your-image-name
    image: your-image
    imagePullPolicy: Always
    ports:
      - name: portname
        containerPort: 1234
```

### Deploying extra resources

There are cases where you may want to deploy extra objects, such a ConfigMap containing your app's configuration or some extra deployment with a micro service used by your app. For covering this case, the chart allows adding the full specification of other objects using the `extraDeploy` parameter.

### Setting Pod's affinity

This chart allows you to set your custom affinity using the `affinity` paremeter. Find more infomation about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami’s Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 3.0.0

- Chart labels were adapted to follow the [Helm charts standard labels](https://helm.sh/docs/chart_best_practices/labels/#standard-labels).
- This version also introduces `bitnami/common`, a [library chart](https://helm.sh/docs/topics/library_charts/#helm) as a dependency. More documentation about this new utility could be found [here](https://github.com/bitnami/charts/tree/master/bitnami/common#bitnami-common-library-chart). Please, make sure that you have updated the chart dependencies before executing any upgrade.

Consequences:

- Backwards compatibility is not guaranteed. To upgrade to `3.0.0`, install a new release of the Kubewatch chart.

### To 2.0.0

[On November 13, 2020, Helm v2 support was formally finished](https://github.com/helm/charts#status-of-the-project), this major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

**What changes were introduced in this major version?**

- Previous versions of this Helm Chart use `apiVersion: v1` (installable by both Helm 2 and 3), this Helm Chart was updated to `apiVersion: v2` (installable by Helm 3 only). [Here](https://helm.sh/docs/topics/charts/#the-apiversion-field) you can find more information about the `apiVersion` field.
- The different fields present in the *Chart.yaml* file has been ordered alphabetically in a homogeneous way for all the Bitnami Helm Charts

**Considerations when upgrading to this version**

- If you want to upgrade to this version from a previous one installed with Helm v3, you shouldn't face any issues
- If you want to upgrade to this version using Helm v2, this scenario is not supported as this version doesn't support Helm v2 anymore
- If you installed the previous version with Helm v2 and wants to upgrade to this version with Helm v3, please refer to the [official Helm documentation](https://helm.sh/docs/topics/v2_v3_migration/#migration-use-cases) about migrating from Helm v2 to v3

**Useful links**

- https://docs.bitnami.com/tutorials/resolve-helm2-helm3-post-migration-issues/
- https://helm.sh/docs/topics/v2_v3_migration/
- https://helm.sh/blog/migrate-from-helm-v2-to-helm-v3/

### To 1.0.0

Helm performs a lookup for the object based on its group (apps), version (v1), and kind (Deployment). Also known as its GroupVersionKind, or GVK. Changing the GVK is considered a compatibility breaker from Kubernetes' point of view, so you cannot "upgrade" those objects to the new GVK in-place. Earlier versions of Helm 3 did not perform the lookup correctly which has since been fixed to match the spec.

In https://github.com/helm/charts/pull/17285 the `apiVersion` of the deployment resources was updated to `apps/v1` in tune with the api's deprecated, resulting in compatibility breakage.

This major version signifies this change.
