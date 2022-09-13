<!--- app-name: Odoo -->

# Odoo packaged by Bitnami

Odoo is an open source ERP and CRM platform, formerly known as OpenERP, that can connect a wide variety of business operations such as sales, supply chain, finance, and project management.

[Overview of Odoo](https://www.odoo.com/)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.
                           
## TL;DR

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/odoo
```

## Introduction

This chart bootstraps a [Odoo](https://github.com/bitnami/containers/tree/main/bitnami/odoo) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Odoo Apps can be used as stand-alone applications, but they also integrate seamlessly so you get a full-featured Open Source ERP when you install several Apps.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- PV provisioner support in the underlying infrastructure
- ReadWriteMany volumes for deployment scaling

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install my-release bitnami/odoo
```

The command deploys Odoo on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.
> If persistence.resourcePolicy is set to keep, you should manually delete the PVCs.



## Parameters

### Global parameters

| Name                      | Description                                     | Value |
| ------------------------- | ----------------------------------------------- | ----- |
| `global.imageRegistry`    | Global Docker image registry                    | `""`  |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]`  |
| `global.storageClass`     | Global StorageClass for Persistent Volume(s)    | `""`  |


### Common parameters

| Name                     | Description                                                                                          | Value                        |
| ------------------------ | ---------------------------------------------------------------------------------------------------- | ---------------------------- |
| `kubeVersion`            | Override Kubernetes version                                                                          | `""`                         |
| `nameOverride`           | String to partially override common.names.fullname                                                   | `""`                         |
| `fullnameOverride`       | String to fully override common.names.fullname                                                       | `""`                         |
| `commonLabels`           | Labels to add to all deployed objects                                                                | `{}`                         |
| `commonAnnotations`      | Annotations to add to all deployed objects                                                           | `{}`                         |
| `clusterDomain`          | Default Kubernetes cluster domain                                                                    | `cluster.local`              |
| `extraDeploy`            | Array of extra objects to deploy with the release                                                    | `[]`                         |
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden)              | `false`                      |
| `diagnosticMode.command` | Command to override all containers in the the statefulset                                            | `["sleep"]`                  |
| `diagnosticMode.args`    | Args to override all containers in the the statefulset                                               | `["infinity"]`               |
| `image.registry`         | Odoo image registry                                                                                  | `docker.io`                  |
| `image.repository`       | Odoo image repository                                                                                | `bitnami/odoo`               |
| `image.tag`              | Odoo image tag (immutable tags are recommended)                                                      | `15.0.20220810-debian-11-r9` |
| `image.digest`           | Odoo image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag | `""`                         |
| `image.pullPolicy`       | Odoo image pull policy                                                                               | `IfNotPresent`               |
| `image.pullSecrets`      | Odoo image pull secrets                                                                              | `[]`                         |
| `image.debug`            | Enable image debug mode                                                                              | `false`                      |


### Odoo Configuration parameters

| Name                    | Description                                                          | Value              |
| ----------------------- | -------------------------------------------------------------------- | ------------------ |
| `odooEmail`             | Odoo user email                                                      | `user@example.com` |
| `odooPassword`          | Odoo user password                                                   | `""`               |
| `odooSkipInstall`       | Skip Odoo installation wizard                                        | `false`            |
| `loadDemoData`          | Whether to load demo data for all modules during initialization      | `false`            |
| `customPostInitScripts` | Custom post-init.d user scripts                                      | `{}`               |
| `smtpHost`              | SMTP server host                                                     | `""`               |
| `smtpPort`              | SMTP server port                                                     | `""`               |
| `smtpUser`              | SMTP username                                                        | `""`               |
| `smtpPassword`          | SMTP user password                                                   | `""`               |
| `smtpProtocol`          | SMTP protocol                                                        | `""`               |
| `existingSecret`        | Name of existing secret containing Odoo credentials                  | `""`               |
| `smtpExistingSecret`    | The name of an existing secret with SMTP credentials                 | `""`               |
| `allowEmptyPassword`    | Allow the container to be started with blank passwords               | `false`            |
| `command`               | Override default container command (useful when using custom images) | `[]`               |
| `args`                  | Override default container args (useful when using custom images)    | `[]`               |
| `extraEnvVars`          | Array with extra environment variables to add to the Odoo container  | `[]`               |
| `extraEnvVarsCM`        | Name of existing ConfigMap containing extra env vars                 | `""`               |
| `extraEnvVarsSecret`    | Name of existing Secret containing extra env vars                    | `""`               |


### Odoo deployment parameters

| Name                                 | Description                                                                                                              | Value           |
| ------------------------------------ | ------------------------------------------------------------------------------------------------------------------------ | --------------- |
| `replicaCount`                       | Number of Odoo replicas to deploy                                                                                        | `1`             |
| `containerPorts.http`                | Odoo HTTP container port                                                                                                 | `8069`          |
| `resources.limits`                   | The resources limits for the Odoo container                                                                              | `{}`            |
| `resources.requests`                 | The requested resources for the Odoo container                                                                           | `{}`            |
| `podSecurityContext.enabled`         | Enabled Odoo pods' Security Context                                                                                      | `false`         |
| `podSecurityContext.fsGroup`         | Set Odoo pod's Security Context fsGroup                                                                                  | `1001`          |
| `containerSecurityContext.enabled`   | Enabled Odoo containers' Security Context                                                                                | `false`         |
| `containerSecurityContext.runAsUser` | Set Odoo container's Security Context runAsUser                                                                          | `1001`          |
| `livenessProbe.enabled`              | Enable livenessProbe                                                                                                     | `true`          |
| `livenessProbe.path`                 | Path for to check for livenessProbe                                                                                      | `/`             |
| `livenessProbe.initialDelaySeconds`  | Initial delay seconds for livenessProbe                                                                                  | `600`           |
| `livenessProbe.periodSeconds`        | Period seconds for livenessProbe                                                                                         | `30`            |
| `livenessProbe.timeoutSeconds`       | Timeout seconds for livenessProbe                                                                                        | `5`             |
| `livenessProbe.failureThreshold`     | Failure threshold for livenessProbe                                                                                      | `6`             |
| `livenessProbe.successThreshold`     | Success threshold for livenessProbe                                                                                      | `1`             |
| `readinessProbe.enabled`             | Enable readinessProbe                                                                                                    | `true`          |
| `readinessProbe.path`                | Path to check for readinessProbe                                                                                         | `/`             |
| `readinessProbe.initialDelaySeconds` | Initial delay seconds for readinessProbe                                                                                 | `30`            |
| `readinessProbe.periodSeconds`       | Period seconds for readinessProbe                                                                                        | `10`            |
| `readinessProbe.timeoutSeconds`      | Timeout seconds for readinessProbe                                                                                       | `5`             |
| `readinessProbe.failureThreshold`    | Failure threshold for readinessProbe                                                                                     | `6`             |
| `readinessProbe.successThreshold`    | Success threshold for readinessProbe                                                                                     | `1`             |
| `startupProbe.enabled`               | Enable startupProbe                                                                                                      | `false`         |
| `startupProbe.path`                  | Path to check for startupProbe                                                                                           | `/`             |
| `startupProbe.initialDelaySeconds`   | Initial delay seconds for startupProbe                                                                                   | `300`           |
| `startupProbe.periodSeconds`         | Period seconds for startupProbe                                                                                          | `10`            |
| `startupProbe.timeoutSeconds`        | Timeout seconds for startupProbe                                                                                         | `5`             |
| `startupProbe.failureThreshold`      | Failure threshold for startupProbe                                                                                       | `6`             |
| `startupProbe.successThreshold`      | Success threshold for startupProbe                                                                                       | `1`             |
| `customLivenessProbe`                | Custom livenessProbe that overrides the default one                                                                      | `{}`            |
| `customReadinessProbe`               | Custom readinessProbe that overrides the default one                                                                     | `{}`            |
| `customStartupProbe`                 | Custom startupProbe that overrides the default one                                                                       | `{}`            |
| `lifecycleHooks`                     | LifecycleHooks to set additional configuration at startup                                                                | `{}`            |
| `hostAliases`                        | Odoo pod host aliases                                                                                                    | `[]`            |
| `podLabels`                          | Extra labels for Odoo pods                                                                                               | `{}`            |
| `podAnnotations`                     | Annotations for Odoo pods                                                                                                | `{}`            |
| `podAffinityPreset`                  | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                      | `""`            |
| `podAntiAffinityPreset`              | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                 | `soft`          |
| `nodeAffinityPreset.type`            | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                | `""`            |
| `nodeAffinityPreset.key`             | Node label key to match. Ignored if `affinity` is set                                                                    | `""`            |
| `nodeAffinityPreset.values`          | Node label values to match. Ignored if `affinity` is set                                                                 | `[]`            |
| `affinity`                           | Affinity for pod assignment                                                                                              | `{}`            |
| `nodeSelector`                       | Node labels for pod assignment                                                                                           | `{}`            |
| `tolerations`                        | Tolerations for pod assignment                                                                                           | `[]`            |
| `topologySpreadConstraints`          | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template | `[]`            |
| `priorityClassName`                  | Odoo pods' Priority Class Name                                                                                           | `""`            |
| `schedulerName`                      | Use an alternate scheduler, e.g. "stork".                                                                                | `""`            |
| `terminationGracePeriodSeconds`      | Seconds Odoo pod needs to terminate gracefully                                                                           | `""`            |
| `updateStrategy.type`                | Odoo deployment strategy type                                                                                            | `RollingUpdate` |
| `updateStrategy.rollingUpdate`       | Odoo deployment rolling update configuration parameters                                                                  | `{}`            |
| `extraVolumes`                       | Optionally specify extra list of additional volumes for Odoo pods                                                        | `[]`            |
| `extraVolumeMounts`                  | Optionally specify extra list of additional volumeMounts for Odoo container(s)                                           | `[]`            |
| `extraContainerPorts`                | Optionally specify extra list of additional ports for Odoo container(s)                                                  | `[]`            |
| `sidecars`                           | Add additional sidecar containers to the Odoo pod                                                                        | `[]`            |
| `initContainers`                     | Add additional init containers to the Odoo pods                                                                          | `[]`            |


### Traffic Exposure Parameters

| Name                               | Description                                                                                                                      | Value                    |
| ---------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `service.type`                     | Odoo service type                                                                                                                | `LoadBalancer`           |
| `service.ports.http`               | Odoo service HTTP port                                                                                                           | `80`                     |
| `service.nodePorts.http`           | NodePort for the Odoo HTTP endpoint                                                                                              | `""`                     |
| `service.sessionAffinity`          | Control where client requests go, to the same pod or round-robin                                                                 | `None`                   |
| `service.sessionAffinityConfig`    | Additional settings for the sessionAffinity                                                                                      | `{}`                     |
| `service.clusterIP`                | Odoo service Cluster IP                                                                                                          | `""`                     |
| `service.loadBalancerIP`           | Odoo service Load Balancer IP                                                                                                    | `""`                     |
| `service.loadBalancerSourceRanges` | Odoo service Load Balancer sources                                                                                               | `[]`                     |
| `service.externalTrafficPolicy`    | Odoo service external traffic policy                                                                                             | `Cluster`                |
| `service.annotations`              | Additional custom annotations for Odoo service                                                                                   | `{}`                     |
| `service.extraPorts`               | Extra port to expose on Odoo service                                                                                             | `[]`                     |
| `ingress.enabled`                  | Enable ingress record generation for Odoo                                                                                        | `false`                  |
| `ingress.ingressClassName`         | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                    | `""`                     |
| `ingress.pathType`                 | Ingress path type                                                                                                                | `ImplementationSpecific` |
| `ingress.apiVersion`               | Force Ingress API version (automatically detected if not set)                                                                    | `""`                     |
| `ingress.hostname`                 | Default host for the ingress record                                                                                              | `odoo.local`             |
| `ingress.path`                     | Default path for the ingress record                                                                                              | `/`                      |
| `ingress.annotations`              | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                     |
| `ingress.tls`                      | Enable TLS configuration for the host defined at `ingress.hostname` parameter                                                    | `false`                  |
| `ingress.selfSigned`               | Create a TLS secret for this ingress record using self-signed certificates generated by Helm                                     | `false`                  |
| `ingress.extraHosts`               | An array with additional hostname(s) to be covered with the ingress record                                                       | `[]`                     |
| `ingress.extraPaths`               | An array with additional arbitrary paths that may need to be added to the ingress under the main host                            | `[]`                     |
| `ingress.extraTls`                 | TLS configuration for additional hostname(s) to be covered with this ingress record                                              | `[]`                     |
| `ingress.secrets`                  | Custom TLS certificates as secrets                                                                                               | `[]`                     |
| `ingress.extraRules`               | Additional rules to be covered with this ingress record                                                                          | `[]`                     |


### Persistence Parameters

| Name                                                   | Description                                                                                                                           | Value           |
| ------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------- | --------------- |
| `persistence.enabled`                                  | Enable persistence using Persistent Volume Claims                                                                                     | `true`          |
| `persistence.resourcePolicy`                           | Setting it to "keep" to avoid removing PVCs during a helm delete operation. Leaving it empty will delete PVCs after the chart deleted | `""`            |
| `persistence.storageClass`                             | Persistent Volume storage class                                                                                                       | `""`            |
| `persistence.accessModes`                              | Persistent Volume access modes                                                                                                        | `[]`            |
| `persistence.accessMode`                               | Persistent Volume access mode (DEPRECATED: use `persistence.accessModes` instead)                                                     | `ReadWriteOnce` |
| `persistence.size`                                     | Persistent Volume size                                                                                                                | `10Gi`          |
| `persistence.dataSource`                               | Custom PVC data source                                                                                                                | `{}`            |
| `persistence.annotations`                              | Annotations for the PVC                                                                                                               | `{}`            |
| `persistence.selector`                                 | Selector to match an existing Persistent Volume (this value is evaluated as a template)                                               | `{}`            |
| `persistence.existingClaim`                            | The name of an existing PVC to use for persistence                                                                                    | `""`            |
| `volumePermissions.enabled`                            | Enable init container that changes the owner/group of the PV mount point to `runAsUser:fsGroup`                                       | `false`         |
| `volumePermissions.resources.limits`                   | The resources limits for the init container                                                                                           | `{}`            |
| `volumePermissions.resources.requests`                 | The requested resources for the init container                                                                                        | `{}`            |
| `volumePermissions.containerSecurityContext.enabled`   | Enable init container's Security Context                                                                                              | `true`          |
| `volumePermissions.containerSecurityContext.runAsUser` | Set init container's Security Context runAsUser                                                                                       | `0`             |


### RBAC Parameters

| Name                                          | Description                                                                                              | Value   |
| --------------------------------------------- | -------------------------------------------------------------------------------------------------------- | ------- |
| `serviceAccount.create`                       | Specifies whether a ServiceAccount should be created                                                     | `true`  |
| `serviceAccount.name`                         | The name of the ServiceAccount to create (name generated using common.names.fullname template otherwise) | `""`    |
| `serviceAccount.automountServiceAccountToken` | Auto-mount the service account token in the pod                                                          | `false` |
| `serviceAccount.annotations`                  | Additional custom annotations for the ServiceAccount                                                     | `{}`    |


### Other Parameters

| Name                       | Description                                                    | Value   |
| -------------------------- | -------------------------------------------------------------- | ------- |
| `pdb.create`               | Enable a Pod Disruption Budget creation                        | `false` |
| `pdb.minAvailable`         | Minimum number/percentage of pods that should remain scheduled | `1`     |
| `pdb.maxUnavailable`       | Maximum number/percentage of pods that may be made unavailable | `""`    |
| `autoscaling.enabled`      | Enable Horizontal POD autoscaling for Odoo                     | `false` |
| `autoscaling.minReplicas`  | Minimum number of Odoo replicas                                | `1`     |
| `autoscaling.maxReplicas`  | Maximum number of Odoo replicas                                | `11`    |
| `autoscaling.targetCPU`    | Target CPU utilization percentage                              | `50`    |
| `autoscaling.targetMemory` | Target Memory utilization percentage                           | `50`    |


### Database Parameters

| Name                                                 | Description                                                              | Value          |
| ---------------------------------------------------- | ------------------------------------------------------------------------ | -------------- |
| `postgresql.enabled`                                 | Switch to enable or disable the PostgreSQL helm chart                    | `true`         |
| `postgresql.auth.username`                           | Name for a custom user to create                                         | `bn_odoo`      |
| `postgresql.auth.password`                           | Password for the custom user to create                                   | `""`           |
| `postgresql.auth.database`                           | Name for a custom database to create                                     | `bitnami_odoo` |
| `postgresql.auth.existingSecret`                     | Name of existing secret to use for PostgreSQL credentials                | `""`           |
| `postgresql.architecture`                            | PostgreSQL architecture (`standalone` or `replication`)                  | `standalone`   |
| `externalDatabase.host`                              | Database host                                                            | `""`           |
| `externalDatabase.port`                              | Database port number                                                     | `5432`         |
| `externalDatabase.user`                              | Non-root username for Keycloak                                           | `bn_odoo`      |
| `externalDatabase.password`                          | Password for the non-root username for Keycloak                          | `""`           |
| `externalDatabase.database`                          | Keycloak database name                                                   | `bitnami_odoo` |
| `externalDatabase.create`                            | Enable PostgreSQL user and database creation (when using an external db) | `true`         |
| `externalDatabase.postgresqlPostgresUser`            | External Database admin username                                         | `postgres`     |
| `externalDatabase.postgresqlPostgresPassword`        | External Database admin password                                         | `""`           |
| `externalDatabase.existingSecret`                    | Name of an existing secret resource containing the database credentials  | `""`           |
| `externalDatabase.existingSecretPasswordKey`         | Name of an existing secret key containing the non-root credentials       | `""`           |
| `externalDatabase.existingSecretPostgresPasswordKey` | Name of an existing secret key containing the admin credentials          | `""`           |


### NetworkPolicy parameters

| Name                                                          | Description                                                                                                              | Value   |
| ------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------ | ------- |
| `networkPolicy.enabled`                                       | Enable network policies                                                                                                  | `false` |
| `networkPolicy.ingress.enabled`                               | Enable network policy for Ingress Proxies                                                                                | `false` |
| `networkPolicy.ingress.namespaceSelector`                     | Ingress Proxy namespace selector labels. These labels will be used to identify the Ingress Proxy's namespace.            | `{}`    |
| `networkPolicy.ingress.podSelector`                           | Ingress Proxy pods selector labels. These labels will be used to identify the Ingress Proxy pods.                        | `{}`    |
| `networkPolicy.ingressRules.backendOnlyAccessibleByFrontend`  | Enable ingress rule that makes the backend (mariadb) only accessible by Odoo's pods.                                     | `false` |
| `networkPolicy.ingressRules.customBackendSelector`            | Backend selector labels. These labels will be used to identify the backend pods.                                         | `{}`    |
| `networkPolicy.ingressRules.accessOnlyFrom.enabled`           | Enable ingress rule that makes Odoo only accessible from a particular origin                                             | `false` |
| `networkPolicy.ingressRules.accessOnlyFrom.namespaceSelector` | Namespace selector label that is allowed to access Odoo. This label will be used to identified the allowed namespace(s). | `{}`    |
| `networkPolicy.ingressRules.accessOnlyFrom.podSelector`       | Pods selector label that is allowed to access Odoo. This label will be used to identified the allowed pod(s).            | `{}`    |
| `networkPolicy.ingressRules.customRules`                      | Custom network policy ingress rule                                                                                       | `{}`    |
| `networkPolicy.egressRules.denyConnectionsToExternal`         | Enable egress rule that denies outgoing traffic outside the cluster, except for DNS (port 53).                           | `false` |
| `networkPolicy.egressRules.customRules`                       | Custom network policy rule                                                                                               | `{}`    |


The above parameters map to the env variables defined in [bitnami/odoo](https://github.com/bitnami/containers/tree/main/bitnami/odoo). For more information please refer to the [bitnami/odoo](https://github.com/bitnami/containers/tree/main/bitnami/odoo) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install my-release \
  --set odooPassword=password,postgresql.postgresPassword=secretpassword \
    bitnami/odoo
```

The above command sets the Odoo administrator account password to `password` and the PostgreSQL `postgres` user password to `secretpassword`.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install my-release -f values.yaml bitnami/odoo
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Use a different Odoo version

To modify the application version used in this chart, specify a different version of the image using the `image.tag` parameter and/or a different repository using the `image.repository` parameter. Refer to the [chart documentation for more information on these parameters and how to use them with images from a private registry](https://docs.bitnami.com/kubernetes/apps/odoo/configuration/change-image-version/).

### Using an external database

Sometimes you may want to have Odoo connect to an external database rather than installing one inside your cluster, e.g. to use a managed database service, or use a single database server for all your applications. To do this, the chart allows you to specify credentials for an external database under the [`externalDatabase` parameter](#parameters). You should also disable the PostgreSQL installation with the `postgresql.enabled` option. For example using the following parameters:

```console
postgresql.enabled=false
externalDatabase.host=myexternalhost
externalDatabase.user=myuser
externalDatabase.password=mypassword
externalDatabase.port=3306
```

Note also if you disable PostgreSQL per above you MUST supply values for the `externalDatabase` connection.

### Sidecars and Init Containers

If you have a need for additional containers to run within the same pod as Odoo, you can do so via the `sidecars` config parameter. Simply define your container according to the Kubernetes container spec.

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

### Setting Pod's affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

## Persistence

The [Bitnami Odoo](https://github.com/bitnami/containers/tree/main/bitnami/odoo) image stores the Odoo data and configurations at the `/bitnami/odoo` path of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Parameters](#parameters) section to configure the PVC or to disable persistence.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

Refer to the [chart documentation for more information about how to upgrade from previous releases](https://docs.bitnami.com/kubernetes/apps/odoo/administration/upgrade/).

## Community supported solution

Please, note this Helm chart is a community-supported solution. This means that the Bitnami team is not actively working on new features/improvements nor providing support through GitHub Issues for this Helm chart. Any new issue will stay open for 20 days to allow the community to contribute, after 15 days without activity the issue will be marked as stale being closed after 5 days.

The Bitnami team will review any PR that is created, feel free to create a PR if you find any issue or want to implement a new feature.

New versions are not going to be affected. Once a new version is released in the upstream project, the Bitnami container image will be updated to use the latest version.

## License

Copyright &copy; 2022 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.