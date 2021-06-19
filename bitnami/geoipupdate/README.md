# geoipupdate

[GeoIP Update](https://github.com/maxmind/geoipupdate) performs automatic updates of GeoIP2 and GeoIP Legacy binary databases.

## Installing the Chart

```shell
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/geoipupdate
```

## Parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| image.repository | string | `"maxmindinc/geoipupdate"` | Repository for the geoipupdate image. |
| image.tag | string | `v4.7.1` | Tag for the geoipupdate image. |
| image.pullPolicy | string | `IfNotPresent` | The geoipupdate image pull policy. |
| cronJobType | string | `"cronJob"` | What resource should be created - cronJob or daemonSet. |
| cronJob.schedule | string | `"0 4 * * 6"` | Run a job every Saturday at 4:00 A.M. |
| cronJob.concurrencyPolicy | string | `Forbid` | Attempt or not a job to be scheduled when there was a previous schedule still running. |
| cronJob.successfulJobsHistoryLimit | int | `1` | Specify how many completed jobs should be kept. |
| cronJob.failedJobsHistoryLimit | int | `1` | Specify how many failed jobs should be kept. |
| cronJob.backoffLimit | int | `6` | How long to try recreating failed pods. |
| cronJob.activeDeadlineSeconds | int | `0` | Terminate all running Pods of a job if activeDeadlineSeconds is reached. |
| restartPolicy | string | `OnFailure` | Containers restart policy. |
| terminationGracePeriodSeconds | int | `10` | Grace period before pods are allowed to be killed forcefully. |
| tolerations | list | `[]` | Additonal labels for running pods in tained nodes. |
| affinity | object | `{}` | Pods affinity rules. |
| podSecurityContext | object | `{"fsGroup": 1000}` | Security Context for pods. |
| containerSecurityContext | object | `{"runAsUser": 1000, "runAsGroup": 1000}` | Security Context for containers. |
| resources | object | `{}` | Describes compute resource requirements. |
| createConfig.enabled | bool | `true` | Create or not the geoipupdate config file. |
| createConfig.image.repository | string | `bash` | Repository for the createConfig image. |
| createConfig.image.tag | string | `5` | Tag for the createConfig image. |
| createConfig.image.pullPolicy | string | `IfNotPresent` | The createConfig image pull policy. |
| createConfig.command | list | `["bash", "-c"]` | Command to run into createConfig initContainer. |
| createConfig.args | list | see `values.yaml` | Arguments for the createConfig initContainer command. |
| createConfig.securityContext | object | `{"runAsUser": 1000, "runAsGroup": 1000}` | Container's level Security Context for the createConfig. |
| extraInitContainers | list | `[]` | Additional Init Containers. |
| extraVolumes | list | `[]` | Additional Volumes. |
| extraVolumeMounts | list | `[]` | Additional VolumeMounts. |
| podSecurityPolicy.enabled | bool | `true` | Enable or not Pod Security Policy. |
| podSecurityPolicy.allowedHostPaths | list | `[]` | Allowed paths for hostPath. |
| podSecurityPolicy.volumes | list | `[]` | Allowed Volume types. |
| podSecurityPolicy.runAsUser | object | `{"rule": "RunAsAny"}` | |
| podSecurityPolicy.seLinux | object | `{"rule": "RunAsAny"}` | |
| podSecurityPolicy.supplementalGroups | object | `{"rule": "RunAsAny"}` | |
| podSecurityPolicy.fsGroup | object | `{"rule": "RunAsAny"}` | |
| configSecret.annotations | object | `{}` | Annotations for the geoipupdate configuration Secret. |
| configSecret.geoipupdateAccountID | string | `""` | MaxMind account ID (required). |
| configSecret.geoipupdateLicenseKey | string | `""` | Case-sensitive MaxMind license key (required). |
| configSecret.geoipupdateEditionIDs | string | `""` | List of space-separated GeoIP database edition IDs (required). |
| configSecret.geoipupdateHost | string | `""` | The host name of the server to use. The default is `updates.maxmind.com`. |
| configSecret.geoipupdateProxy | string | `""` | The proxy host name or IP address. |
| configSecret.geoipupdateProxyUserPassword | string | `""` | The proxy user name and password, separated by a colon. For instance, `username:password`. |
| configSecret.geoipupdateVerbose | string | `""` | Enable verbose mode. Set to anything (e.g., 1) to enable. |
| configSecret.geoipupdateFrequency | string | `"168"` | Should be more than 0 if cronJobType is daemonSet. |
| serviceAccount.name | string | `""` | Override Service Account name. Defaults to release name. |
