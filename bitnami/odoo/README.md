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

| Name                     | Description                                                                             | Value                        |
| ------------------------ | --------------------------------------------------------------------------------------- | ---------------------------- |
| `kubeVersion`            | Override Kubernetes version                                                             | `""`                         |
| `nameOverride`           | String to partially override common.names.fullname                                      | `""`                         |
| `fullnameOverride`       | String to fully override common.names.fullname                                          | `""`                         |
| `commonLabels`           | Labels to add to all deployed objects                                                   | `{}`                         |
| `commonAnnotations`      | Annotations to add to all deployed objects                                              | `{}`                         |
| `clusterDomain`          | Default Kubernetes cluster domain                                                       | `cluster.local`              |
| `extraDeploy`            | Array of extra objects to deploy with the release                                       | `[]`                         |
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden) | `false`                      |
| `diagnosticMode.command` | Command to override all containers in the the statefulset                               | `["sleep"]`                  |
| `diagnosticMode.args`    | Args to override all containers in the the statefulset                                  | `["infinity"]`               |
| `image.registry`         | Odoo image registry                                                                     | `docker.io`                  |
| `image.repository`       | Odoo image repository                                                                   | `bitnami/odoo`               |
| `image.tag`              | Odoo image tag (immutable tags are recommended)                                         | `15.0.20220810-debian-11-r0` |
| `image.pullPolicy`       | Odoo image pull policy                                                                  | `IfNotPresent`               |
| `image.pullSecrets`      | Odoo image pull secrets                                                                 | `[]`                         |
| `image.debug`            | Enable image debug mode                                                                 | `false`                      |


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

### [Rolling VS Immutable tags](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Use an external database

Sometimes, you may want to have the chart use an external database rather than using the one bundled with the chart. Common use cases include using a managed database service, or using a single database server for all your applications. This chart supports external databases through its `externalDatabase.*` parameters.

When using these parameters, it is necessary to disable installation of the bundled PostgreSQL database using the `postgresql.enabled=false` parameter.

An example of the parameters set when deploying the chart with an external database are shown below:
```
postgresql.enabled=false
externalDatabase.host=myexternalhost
externalDatabase.port=5432
externalDatabase.user=myuser
externalDatabase.password=mypassword
externalDatabase.database=mydatabase
```

### Sidecars and Init Containers

If additional containers are needed in the same pod (such as additional metrics or logging exporters), they can be defined using the `sidecars` parameter. Here is an example:

```yaml
sidecars:
- name: your-image-name
  image: your-image
  imagePullPolicy: Always
  ports:
  - name: portname
    containerPort: 1234
```

If these sidecars export extra ports, extra port definitions can be added using the `service.extraPorts` parameter (where available), as shown in the example below:

```yaml
service:
...
  extraPorts:
  - name: extraPort
    port: 11311
    targetPort: 11311
```

If additional init containers are needed in the same pod, they can be defined using the `initContainers` parameter. Here is an example:

```yaml
initContainers:
  - name: your-image-name
    image: your-image
    imagePullPolicy: Always
    ports:
      - name: portname
        containerPort: 1234
```

Learn more about [sidecar containers](https://kubernetes.io/docs/concepts/workloads/pods/) and [init containers](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/).

### Pod affinity

This chart allows you to set your custom affinity using the `*.affinity` parameter(s). Find more information about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `*.podAffinityPreset`, `*.podAntiAffinityPreset`, or `*.nodeAffinityPreset` parameters.

### Ingress

This chart provides support for Ingress resources. If you have an ingress controller installed on your cluster, such as [nginx-ingress-controller](https://github.com/bitnami/charts/tree/master/bitnami/nginx-ingress-controller) or [contour](https://github.com/bitnami/charts/tree/master/bitnami/contour) you can utilize the ingress controller to serve your application.

To enable Ingress integration, set `ingress.enabled` to `true`. The `ingress.hostname` property can be used to set the host name. The `ingress.tls` parameter can be used to add the TLS configuration for this host. It is also possible to have more than one host, with a separate TLS configuration for each host.

In general, to enable Ingress integration, set the `*.ingress.enabled` parameter to *true*.

The most common scenario is to have one host name mapped to the deployment. In this case, the `*.ingress.hostname` property can be used to set the host name. The `*.ingress.tls` parameter can be used to add the TLS configuration for this host.

However, it is also possible to have more than one host. To facilitate this, the `*.ingress.extraHosts` parameter (if available) can be set with the host names specified as an array. The `*.ingress.extraTLS` parameter (if available) can also be used to add the TLS configuration for extra hosts.

> NOTE: For each host specified in the `*.ingress.extraHosts` parameter, it is necessary to set a name, path, and any annotations that the Ingress controller should know about. Not all annotations are supported by all Ingress controllers, but [this annotation reference document](https://github.com/kubernetes/ingress-nginx/blob/master/docs/user-guide/nginx-configuration/annotations.md) lists the annotations supported by many popular Ingress controllers.

Adding the TLS parameter (where available) will cause the chart to generate HTTPS URLs, and the  application will be available on port 443. The actual TLS secrets do not have to be generated by this chart. However, if TLS is enabled, the Ingress record will not work until the TLS secret exists.

[Learn more about Ingress controllers](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/).

## Persistence

The [Bitnami Odoo](https://github.com/bitnami/containers/tree/main/bitnami/odoo) image stores the Odoo data and configurations at the `/bitnami/odoo` path of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Parameters](#parameters) section to configure the PVC or to disable persistence.

## Troubleshooting

Sometimes, due to unexpected issues, installations can become corrupted and get stuck in a *CrashLoopBackOff* restart loop. In these situations, it may be necessary to access the containers and perform manual operations to troubleshoot and fix the issues. To ease this task, the chart has a "Diagnostic mode" that will deploy all the containers with all probes and lifecycle hooks disabled. In addition to this, it will override all commands and arguments with `sleep infinity`.

To activate the "Diagnostic mode", upgrade the release with the following comman. Replace the `MY-RELEASE` placeholder with the release name:
```console
$ helm upgrade MY-RELEASE --set diagnosticMode.enabled=true
```
It is also possible to change the default `sleep infinity` command by setting the `diagnosticMode.command` and `diagnosticMode.args` values.

Once the chart has been deployed in "Diagnostic mode", access the containers by executing the following command and replacing the `MY-CONTAINER` placeholder with the container name:
```console
$ kubectl exec -ti MY-CONTAINER -- bash
```

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 21.0.0

This major release updates the PostgreSQL subchart to its newest major *11.x.x*, which contain several changes in the supported values (check the [upgrade notes](https://github.com/bitnami/charts/tree/master/bitnami/postgresql#upgrading) to obtain more information).

#### Upgrading Instructions

To upgrade to *21.0.0* from *20.x*, it should be done reusing the PVC(s) used to hold the data on your previous release. To do so, follow the instructions below (the following example assumes that the release name is *odoo* and the release namespace *default*):

1. Obtain the credentials and the names of the PVCs used to hold the data on your current release:
```console
export ODOO_PASSWORD=$(kubectl get secret --namespace default odoo -o jsonpath="{.data.odoo-password}" | base64 --decode)
export POSTGRESQL_PASSWORD=$(kubectl get secret --namespace default odoo-postgresql -o jsonpath="{.data.postgresql-password}" | base64 --decode)
export POSTGRESQL_PVC=$(kubectl get pvc -l app.kubernetes.io/instance=odoo,app.kubernetes.io/name=postgresql,role=primary -o jsonpath="{.items[0].metadata.name}")
```

2. Delete the PostgreSQL statefulset (notice the option *--cascade=false*) and secret:
```console
kubectl delete statefulsets.apps --cascade=false odoo-postgresql
kubectl delete secret odoo-postgresql --namespace default
```

3. Upgrade your release using the same PostgreSQL version:
```console
CURRENT_PG_VERSION=$(kubectl exec odoo-postgresql-0 -- bash -c 'echo $BITNAMI_IMAGE_VERSION')
helm upgrade odoo bitnami/odoo \
  --set odooPassword=$ODOO_PASSWORD \
  --set postgresql.image.tag=$CURRENT_PG_VERSION \
  --set postgresql.auth.password=$POSTGRESQL_PASSWORD \
  --set postgresql.persistence.existingClaim=$POSTGRESQL_PVC
  ```

4. Delete the existing PostgreSQL pods and the new statefulset will create a new one:
```console
kubectl delete pod odoo-postgresql-0
```

### To 19.0.0

The [Bitnami Odoo](https://github.com/bitnami/containers/tree/main/bitnami/odoo) image was refactored and now the source code is published in GitHub in the `rootfs` folder of the container image repository.

#### Upgrading Instructions

To upgrade to *19.0.0* from *18.x*, it should be done enabling the "volumePermissions" init container. To do so, follow the instructions below (the following example assumes that the release name is *odoo* and the release namespace *default*):

1. Obtain the credentials and the names of the PVCs used to hold the data on your current release:
```console
export ODOO_PASSWORD=$(kubectl get secret --namespace default odoo -o jsonpath="{.data.odoo-password}" | base64 --decode)
export POSTGRESQL_PASSWORD=$(kubectl get secret --namespace default odoo-postgresql -o jsonpath="{.data.postgresql-password}" | base64 --decode)
export POSTGRESQL_PVC=$(kubectl get pvc -l app.kubernetes.io/instance=odoo,app.kubernetes.io/name=postgresql,role=primary -o jsonpath="{.items[0].metadata.name}")
```

2. Upgrade your release:
```console
helm upgrade odoo bitnami/odoo \
  --set odooPassword=$ODOO_PASSWORD \
  --set postgresql.auth.password=$POSTGRESQL_PASSWORD \
  --set postgresql.persistence.existingClaim=$POSTGRESQL_PVC \
  --set volumePermissions.enabled=true
  ```

Full compatibility is not guaranteed due to the amount of involved changes, however no breaking changes are expected aside from the ones mentioned above.

### To 18.0.0

This version standardizes the way of defining Ingress rules. When configuring a single hostname for the Ingress rule, set the `ingress.hostname` value. When defining more than one, set the `ingress.extraHosts` array. Apart from this case, no issues are expected to appear when upgrading.

### To 17.0.0

[On November 13, 2020, Helm v2 support was formally finished](https://github.com/helm/charts#status-of-the-project), this major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

#### What changes were introduced in this major version?

- Previous versions of this Helm Chart use `apiVersion: v1` (installable by both Helm 2 and 3), this Helm Chart was updated to `apiVersion: v2` (installable by Helm 3 only). [Here](https://helm.sh/docs/topics/charts/#the-apiversion-field) you can find more information about the `apiVersion` field.
- Move dependency information from the *requirements.yaml* to the *Chart.yaml*
- After running *helm dependency update*, a *Chart.lock* file is generated containing the same structure used in the previous *requirements.lock*
- The different fields present in the *Chart.yaml* file has been ordered alphabetically in a homogeneous way for all the Bitnami Helm Chart.
- Additionally updates the PostgreSQL subchart to its newest major *10.x.x*, which contains similar changes.

#### Considerations when upgrading to this version

- If you want to upgrade to this version using Helm v2, this scenario is not supported as this version does not support Helm v2 anymore.
- If you installed the previous version with Helm v2 and wants to upgrade to this version with Helm v3, please refer to the [official Helm documentation](https://helm.sh/docs/topics/v2_v3_migration/#migration-use-cases) about migrating from Helm v2 to v3.

#### Useful links

- [Bitnami Tutorial](https://docs.bitnami.com/tutorials/resolve-helm2-helm3-post-migration-issues)
- [Helm docs](https://helm.sh/docs/topics/v2_v3_migration)
- [Helm Blog](https://helm.sh/blog/migrate-from-helm-v2-to-helm-v3)

#### Upgrading Instructions

To upgrade to *17.0.0* from *16.x*, it should be done reusing the PVC(s) used to hold the data on your previous release. To do so, follow the instructions below (the following example assumes that the release name is *odoo* and the release namespace *default*):

1. Obtain the credentials and the names of the PVCs used to hold the data on your current release:
```console
export ODOO_PASSWORD=$(kubectl get secret --namespace default odoo -o jsonpath="{.data.odoo-password}" | base64 --decode)
export POSTGRESQL_PASSWORD=$(kubectl get secret --namespace default odoo-postgresql -o jsonpath="{.data.postgresql-password}" | base64 --decode)
export POSTGRESQL_PVC=$(kubectl get pvc -l app.kubernetes.io/instance=odoo,app.kubernetes.io/name=postgresql,role=master -o jsonpath="{.items[0].metadata.name}")
```

2. Delete the PostgreSQL statefulset (notice the option *--cascade=false*):
```console
kubectl delete statefulsets.apps --cascade=false odoo-postgresql
```

3. Upgrade your release:
```console
helm upgrade odoo bitnami/odoo \
  --set odooPassword=$ODOO_PASSWORD \
  --set postgresql.auth.password=$POSTGRESQL_PASSWORD \
  --set postgresql.persistence.existingClaim=$POSTGRESQL_PVC
```

4. Delete the existing PostgreSQL pods and the new statefulset will create a new one:
```console
kubectl delete pod odoo-postgresql-0
```

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
