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

The following table lists the configurable parameters of the kubewatch chart and their default values.

| Parameter                                | Description                                                                                                                 | Default                                                 |
|------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------|
| `global.imageRegistry`                   | Global Docker image registry                                                                                                | `nil`                                                   |
| `global.imagePullSecrets`                | Global Docker registry secret names as an array                                                                             | `[]` (does not add image pull secrets to deployed pods) |
| `affinity`                               | node/pod affinities                                                                                                         | None                                                    |
| `image.registry`                         | Image registry                                                                                                              | `docker.io`                                             |
| `image.repository`                       | Image repository                                                                                                            | `bitnami/kubewatch`                                     |
| `image.tag`                              | Image tag                                                                                                                   | `{VERSION}`                                             |
| `image.pullPolicy`                       | Image pull policy                                                                                                           | `Always`                                                |
| `nameOverride`                           | String to partially override kubewatch.fullname template with a string (will prepend the release name)                      | `nil`                                                   |
| `fullnameOverride`                       | String to fully override kubewatch.fullname template with a string                                                          | `nil`                                                   |
| `nodeSelector`                           | node labels for pod assignment                                                                                              | `{}`                                                    |
| `podAnnotations`                         | annotations to add to each pod                                                                                              | `{}`                                                    |
| `podLabels`                              | additional labesl to add to each pod                                                                                        | `{}`                                                    |
| `replicaCount`                           | desired number of pods                                                                                                      | `1`                                                     |
| `rbac.create`                            | If true, create & use RBAC resources                                                                                        | `true`                                                  |
| `serviceAccount.create`                  | If true, create a serviceAccount                                                                                            | `true`                                                  |
| `serviceAccount.name`                    | existing ServiceAccount to use (ignored if rbac.create=true)                                                                | ``                                                      |
| `resources`                              | pod resource requests & limits                                                                                              | `{}`                                                    |
| `slack.enabled`                          | Enable Slack notifications                                                                                                  | `true`                                                  |
| `slack.channel`                          | Slack channel to notify                                                                                                     | `""`                                                    |
| `slack.token`                            | Slack API token                                                                                                             | `""`                                                    |
| `hipchat.enabled`                        | Enable HipChat notifications                                                                                                | `false`                                                 |
| `hipchat.url`                            | HipChat URL                                                                                                                 | `""`                                                    |
| `hipchat.room`                           | HipChat room to notify                                                                                                      | `""`                                                    |
| `hipchat.token`                          | HipChat token                                                                                                               | `""`                                                    |
| `mattermost.enabled`                     | Enable Mattermost notifications                                                                                             | `false`                                                 |
| `mattermost.channel`                     | Mattermost channel to notify                                                                                                | `""`                                                    |
| `mattermost.username`                    | Mattermost user to notify                                                                                                   | `""`                                                    |
| `mattermost.url`                         | Mattermost URL                                                                                                              | `""`                                                    |
| `flock.enabled`                          | Enable Flock notifications                                                                                                  | `false`                                                 |
| `flock.url`                              | Flock URL                                                                                                                   | `""`                                                    |
| `msteams.enabled`                        | Enable Microsoft Teams notifications                                                                                        | `false`                                                 |
| `msteams.webhookurl`                     | Microsoft Teams webhook URL                                                                                                 | `""`                                                    |
| `webhook.enabled`                        | Enable Webhook notifications                                                                                                | `false`                                                 |
| `webhook.url`                            | Webhook URL                                                                                                                 | `""`                                                    |
| `smtp.enabled`                           | Enable SMTP (email) notifications                                                                                           | `false`                                                 |
| `smtp.to`                                | Destination email address (required)                                                                                        | `""`                                                    |
| `smtp.from`                              | Source email address (required)                                                                                             | `""`                                                    |
| `smtp.smarthost`                         | SMTP server address (name:port) (required)                                                                                  | `""`                                                    |
| `smtp.hello`                             | SMTP hello field (optional)                                                                                                 | `""`                                                    |
| `smtp.auth.username`                     | Username for LOGIN and PLAIN auth mech                                                                                      | `""`                                                    |
| `smtp.auth.password`                     | Password for LOGIN and PLAIN auth mech                                                                                      | `""`                                                    |
| `smtp.auth.identity`                     | Identity for PLAIN auth mech                                                                                                | `""`                                                    |
| `smtp.auth.secret`                       | Secret for CRAM-MD5 auth mech                                                                                               | `""`                                                    |
| `smtp.requireTLS`                        | Force STARTTLS                                                                                                              | `false`                                                 |
| `tolerations`                            | List of node taints to tolerate (requires Kubernetes >= 1.6)                                                                | `[]`                                                    |
| `namespaceToWatch`                       | namespace to watch, leave it empty for watching all                                                                         | `""`                                                    |
| `resourcesToWatch`                       | list of resources which kubewatch should watch and notify slack                                                             | `{pod: true, deployment: true}`                         |
| `resourcesToWatch.pod`                   | watch changes to [Pods](https://kubernetes.io/docs/concepts/workloads/pods/pod-overview/)                                   | `true`                                                  |
| `resourcesToWatch.deployment`            | watch changes to [Deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)                       | `true`                                                  |
| `resourcesToWatch.replicationcontroller` | watch changes to [ReplicationControllers](https://kubernetes.io/docs/concepts/workloads/controllers/replicationcontroller/) | `false`                                                 |
| `resourcesToWatch.replicaset`            | watch changes to [ReplicaSets](https://kubernetes.io/docs/concepts/workloads/controllers/replicaset/)                       | `false`                                                 |
| `resourcesToWatch.daemonset`             | watch changes to [DaemonSets](https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/)                         | `false`                                                 |
| `resourcesToWatch.services`              | watch changes to [Services](https://kubernetes.io/docs/concepts/services-networking/service/)                               | `false`                                                 |
| `resourcesToWatch.job`                   | watch changes to [Jobs](https://kubernetes.io/docs/concepts/workloads/controllers/jobs-run-to-completion/)                  | `false`                                                 |
| `resourcesToWatch.persistentvolume`      | watch changes to [PersistentVolumes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/)                       | `false`                                                 |

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

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami’s Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

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
